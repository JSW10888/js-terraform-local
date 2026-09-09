resource "google_compute_address" "ip_address" {
  name = "my-address"
}

data "template_file" "web_init" {
  # Render the template once for each instance
  count    = "${length(var.hostnames)}"
  template = "${file("templates/web_init.tpl")}"
  vars {
    # count.index tells us the index of the instance we are rendering
    hostname = "${var.hostnames[count.index]}"
  }
}

resource "gcp_instance" "web" {
  # Create one instance for each hostname
  count     = "${length(var.hostnames)}"

  # Pass each instance its corresponding template_file
  user_data = "${data.template_file.web_init.*.rendered[count.index]}"
}
