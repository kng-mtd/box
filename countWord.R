a=vector()

a[1]='Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum non sem blandit, sagittis enim ut, semper augue. Donec ullamcorper bibendum nisi, non ullamcorper lorem scelerisque ut. Quisque in ante dolor. Integer pretium, elit nec consectetur facilisis, enim urna molestie velit, at tristique urna nulla in justo. Integer consequat ipsum velit, id malesuada nisl posuere vitae. Aliquam erat volutpat. Etiam quis augue vel diam cursus efficitur. Maecenas imperdiet mollis varius. Nunc tincidunt enim et ultrices ullamcorper. Mauris interdum fringilla tempus. Praesent auctor imperdiet leo, non efficitur lorem condimentum id. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus condimentum tellus quam, vel posuere dolor convallis ut. Vestibulum semper, orci ac blandit eleifend, mi massa faucibus ante, sed convallis ante augue varius lectus. Suspendisse aliquam, mi vel varius mattis, velit enim varius lorem, eget suscipit tellus quam at neque. Etiam luctus erat vitae auctor luctus.'

a[2]='Vestibulum sed tempus risus. Maecenas vitae orci molestie, elementum nunc quis, tristique nibh. Duis a diam sit amet purus malesuada egestas. Vestibulum sit amet tortor sollicitudin est laoreet accumsan. Vestibulum ut auctor nibh. Integer eu purus a arcu efficitur rhoncus. Integer pellentesque quam neque, eu blandit ligula consequat quis. Pellentesque ullamcorper vel purus vel facilisis. In massa eros, bibendum et justo eu, egestas faucibus sem.'

a[3]='Donec faucibus tellus vitae leo eleifend, quis molestie ex ultricies. Nullam imperdiet arcu sit amet porta viverra. Nam sed est sollicitudin, suscipit ligula ut, maximus augue. Suspendisse potenti. Sed pellentesque, urna sit amet suscipit molestie, justo velit pretium lacus, id sagittis sem quam a erat. In ut pulvinar velit. Curabitur vehicula odio hendrerit tellus tincidunt cursus. Aenean malesuada metus sollicitudin turpis tristique efficitur. Suspendisse a risus porta, elementum sapien eget, tincidunt purus. In ullamcorper nisi at erat venenatis auctor. Integer pharetra maximus velit in pellentesque. Sed condimentum blandit lorem, in maximus dolor vulputate quis. Maecenas pharetra eget turpis sed commodo. Duis ac justo efficitur, tristique odio eget, tristique augue.'

a[4]='Nunc egestas arcu mollis molestie venenatis. Etiam ut neque risus. Nullam ut elit sem. Cras eu ullamcorper velit. Morbi blandit eros a eros faucibus tristique. Donec ac magna vitae lacus placerat egestas. Praesent ante augue, porta cursus justo nec, porttitor hendrerit sem. Quisque justo ligula, laoreet ac sem et, semper rutrum libero. Nunc feugiat felis sit amet placerat maximus. Duis porttitor consequat nulla ac pretium. Suspendisse sed posuere arcu. Fusce pellentesque, neque sit amet pellentesque finibus, leo dolor consectetur elit, a ultrices purus orci ut urna. Maecenas tempor magna a mi sollicitudin, sit amet luctus sapien venenatis.'

a[5]='Aliquam dapibus venenatis tincidunt. Praesent at aliquet nibh. Donec eu ipsum sed nulla accumsan ullamcorper. Integer ornare magna sed iaculis auctor. Aenean consectetur blandit tellus, vel iaculis tellus pharetra sed. Sed rutrum est vitae sodales ullamcorper. Nullam molestie, odio sed porttitor maximus, nisl lorem mollis urna, sit amet semper libero ipsum vitae quam. Pellentesque vitae vulputate ligula. Fusce consectetur eu nulla eget laoreet. Phasellus aliquet mi at augue ultrices, sagittis semper arcu porttitor. Praesent at facilisis massa, quis hendrerit odio.' 

aa=paste0(a[1],a[2],a[3],a[4],a[5]) |>
  str_remove_all('[[:punct:]]') |>
  str_remove_all('[0-9]')

b0=str_split(aa,' ') |> unlist()
b1=unique(b0)

tb=tibble()
for(i in a){
  b2=str_split(i,' ') |> unlist()
  c=vector()
  for(j in b2) c[j]=sum(b2==j);
  tb=bind_rows(tb,c)
}
tb
