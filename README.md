# tfvm

Terraform Libvirt VMs is a lightweight Terraform project that makes it easy to spin up local VM(s) on your machine using a simple YAML configuration file.

## Prerequisites

- **Virtualization** enabled in your BIOS/UEFI.
- **libvirtd** (KVM/QEMU) installed, enabled, and running.

  - Recommended: add your user to the `libvirt` group to avoid needing root privileges.

- **Terraform** installed.
- **SSH** key pair available (public + private key).

## Clone the repository

```bash
git clone https://github.com/laxyyza/tfvm.git && cd tfvm
```

## Initialize Terraform

```bash
terraform init
```

## Apply configuration

[!NOTE]

> The default config fetches a Debian base image from the internet. Depending on your network speed, the initial download may take a while. To customize the base image, see [Recommended Config Changes](#recommended-config-changes).

```bash
terraform apply
```

### Apply and connect via console

```bash
terraform apply -auto-approve && virsh console test-vm-01
```

Once applied, you can SSH into your VM:

```bash
ssh user@test-vm-01
```

## Destroy VM(s)

```bash
terraform destroy
```

## Configuration

The default configuration lives in `input/config.yaml`.

### Recommended config changes

By default, the config uses a URL for the base image. The drawback is that running `terraform destroy` will also delete the downloaded image, requiring a re-download next time.

Instead, download the cloud image manually and point `base_image.source` to the local file path.

Example: Download Debian 13 generic cloud image (x86_64):

```bash
wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
```

Move the image to the default libvirt images directory:

```bash
sudo mv debian-13-generic-amd64.qcow2 /var/lib/libvirt/images/
```

Update `input/config.yaml`:

```yaml
base_image:
  name: debian.qcow2
  #source: https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
  source: /var/lib/libvirt/images/debian-13-generic-amd64.qcow2
```

### Adding a password for the user

If you want to add a password for user.

1. Install the `whois` package (provides `mkpasswd`).

2. Generate a SHA-512 password hash:

   ```bash
   mkpasswd --method=SHA-512 --rounds=4096
   ```

3. Copy the generated hash and create a `terraform.tfvars` file with:

   ```hcl
   password = "HASHED_PASSWORD"
   ```

   Example `terraform.tfvars`:

   ```hcl
   password = "$6$rounds=4096$wlnba7DjkCWA8kbf$A3i5cdlpX/3hbMG3RDPQI8ZVQ3WGIXSk7orTwlMyrw.VY9vVOBLa0DjC3LdWUuNqluSBtJGDWsXrjJJQXL4cD0" # value: examplepassword
   ```

### Base images

Use **cloud images** with cloud-init support.

Tested images:

- [Debian 13 (generic)](https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2)
- [Ubuntu 24.04 LTS (Noble)](https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img)
