locals {
  template_output_dir_path = abspath("_out/")
  template_input_dir_path  = abspath(format("%s/templates/", path.root))
}