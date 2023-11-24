
adt_qc <- function(object, iso_features){
  
  ## Mark cells for removal based on the ADT assay. Removed only after RNA based qc and preprocessing!
  adt_counts <- GetAssayData(object, slot = "counts", assay = "ADT")
  
  all_features <- rownames(object@assays$ADT)
  iso_count <- colSums(x = GetAssayData(object = object, assay = "ADT", slot = "counts")[iso_features, , drop = FALSE])
  total_counts_ADT <- colSums(x = GetAssayData(object = object, assay = "ADT", slot = "counts")[all_features, , drop = FALSE])
  
  qc.stats <- DropletUtils::cleanTagCounts(adt_counts, controls = iso_features) %>% as.data.frame()
  high_control_threshold <- attr(qc.stats$high.controls, "thresholds")
  print(paste0("control thresholds(low,high): (", paste0(high_control_threshold, collapse = " , "), ")"))
  
  DF <- data.frame(total_counts = total_counts_ADT, iso_counts = iso_count, nFeatures = object$nFeature_ADT)
  
  p<-ggplot(DF, aes(x=total_counts_ADT, y=nFeatures, color = iso_count)) + 
    geom_point(binaxis='y', stackdir='center') + theme_bw() +
    scale_color_gradient(low = "blue", high = "red", trans = "log10") + 
    guides(colour = guide_colourbar(barheight = unit(8, "cm")))
  print(p)
  
  DF2 <- DF %>% pivot_longer(!nFeatures, values_to = "counts", names_to = "names")
  p <- ggplot(DF2, aes(x = counts, fill = names)) + geom_histogram() +
    theme_bw() +
    scale_fill_manual(values = kelly()[3:length(kelly())]) +
    facet_wrap(~names , ncol = 1, scales = "free") +
    geom_vline(aes(xintercept = xintercept, color = Lines), data.frame(xintercept = high_control_threshold["higher"], Lines = "upper_iso_count_threshold") , linetype = "dashed")
  print(p)
  
  ## Mark the cells that should be filtered based on adt values (removed after RNA based pre-processing!)
  
  ## remove Isotype controls from assay
  new_assay_data <- Seurat::GetAssayData(object, assay = "ADT")
  object[["ADT"]] <-  Seurat::CreateAssayObject(new_assay_data[!(rownames(new_assay_data) %in% iso_features),])
  object[["Isotypes"]] <-  Seurat::CreateAssayObject(new_assay_data[(rownames(new_assay_data) %in% iso_features),])
  ## add info which cells should later be removed
  object@meta.data$adt_filter <- (qc.stats$discard) 
  

  return(object)
}



plot_nebulosa <- function(object, assay = "RNA", features,slot = "data", joint = FALSE, title_name = "", tool = "nebulosa", seurat.min.cutoff = NA, seurat.max.cutoff = NA, reduction = NULL){
  Seurat::DefaultAssay(object) <- assay
  if(tool == "nebulosa"){
    p <- Nebulosa::plot_density(object, features = features, slot = slot, joint = joint, reduction = reduction) + labs(title = title_name, caption = paste0("Assay: ", assay, "; features: ", paste0(features, collapse = ",")))
  }else{
    p <- Seurat::FeaturePlot(object, features = features, slot = slot, min.cutoff = seurat.min.cutoff, max.cutoff = seurat.max.cutoff, reduction = reduction, keep.scale = NULL) + labs(title = title_name, caption = paste0("Assay: ", assay, "; features: ", paste0(features, collapse = ",")))
  }
  return(p)
}
