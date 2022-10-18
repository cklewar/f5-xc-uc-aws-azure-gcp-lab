locals {
  template_output_dir_path = abspath(format("%s/_out/", path.root))
  template_input_dir_path  = abspath(format("%s/templates/", path.root))
}