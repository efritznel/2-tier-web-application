resource "aws_key_pair" "new-keypair" {
    key_name = "new-keypair"
    public_key = file("./modules/key/new-keypair.pub")
}
