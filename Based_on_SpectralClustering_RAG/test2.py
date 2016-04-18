from skimage import graph, data, io, segmentation, color
from skimage.future import graph
from matplotlib import pyplot as plt
from skimage.measure import regionprops
import numpy as np
from matplotlib import colors
 
def show_image(img):
    width = img.shape[1] / 50.0
    height = img.shape[0] * width/img.shape[1]
    f = plt.figure(figsize=(width, height))
    plt.imshow(img)
    
    
image = io.imread('C:\Users\sxun\Desktop\j.jpg')
show_image(image)

labels = segmentation.slic(image, compactness=30, n_segments=400)

border_image = segmentation.mark_boundaries(image, labels, (0, 0, 0))
show_image(border_image)


rag = graph.rag_mean_color(image, labels)
out = graph.draw_rag(labels, rag, border_image)
show_image(out)

out_labels=graph.cut_threshold(labels,rag,29)

out = graph.draw_rag(labels, rag, border_image)
show_image(out)

final_label_rgb = color.label2rgb(out_labels, image, kind='avg')
show_image(final_label_rgb)
