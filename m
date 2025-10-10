Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8811A2F28EE;
	Fri, 10 Oct 2025 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102379; cv=none; b=PEBbxHTWqxIHd9KypcI+HVSkxWG2RwYloJ8zwYz6KTflal7pqyWvehvlN+2tLy1H3050BHbIZsE3CCOdAG3XsETh4SKsA8hbLxODEXePTERVyYGZITYvv5FeJ/gYu5+Caiyl02IaAVuj9PPGZGbdFOcnxq4kuA5fc0qLVHz9l4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102379; c=relaxed/simple;
	bh=BAGN1yQNVoZlt9+DqPlE8Y3QYVMbGEtysFDL/sd/CMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CTWe08qu4iWeo1br2lTC84AvGrbiUDRCudS1XAZ5SNbk2vaYfFPlQNHtHHqEgrFgG40/iCiVKkdgSdRkVLmI2kWwcHiZ+lwbDz+pUTWo/k/j0F/Eg7YftYld3Jo/c6OQaDLbXu9x2+MLRf0mx2WaNMbKG5AGT6VPiSdHP4UF4k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7SFUWuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7SFUWuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECCEC4CEF1;
	Fri, 10 Oct 2025 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102379;
	bh=BAGN1yQNVoZlt9+DqPlE8Y3QYVMbGEtysFDL/sd/CMs=;
	h=From:To:Cc:Subject:Date:From;
	b=s7SFUWuqUSMCws+TG28+hRFvkOR7W92pHTBUVZaMKCN9UAaqAW+VyTR4S6xtf9VDU
	 ZIgZuvF/fAWUA+yYpLm6i/bc1u66VVgKXv2i+VzxZJkneFdkg8p1fRwl7qAokiPMyg
	 oSW8AzFkHvhqF/gZp3rsHwku9OPJNYuPLKxHl9NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 00/41] 6.16.12-rc1 review
Date: Fri, 10 Oct 2025 15:15:48 +0200
Message-ID: <20251010131333.420766773@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.12-rc1
X-KernelTest-Deadline: 2025-10-12T13:13+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.12 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.12-rc1

Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
    ring buffer: Propagate __rb_map_vma return value to caller

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Ensure set_ent is always present

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core/PM: Set power.no_callbacks along with power.no_pm

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: faux: Set power.no_pm for faux devices

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: flush RX FIFO on read errors

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix TX handling on copy_from_user() failure

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix maximum TX packet length check

Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
    serial: stm32: allow selecting console when the driver is module

Carlos Llamas <cmllamas@google.com>
    binder: fix double-free in dbitmap

Max Kellermann <max.kellermann@ionos.com>
    drivers/misc/amd-sbi/Kconfig: select REGMAP_I2C

Michael Walle <mwalle@kernel.org>
    nvmem: layouts: fix automatic module loading

Arnaud Lecomte <contact@arnaud-lcm.com>
    hid: fix I2C read buffer overflow in raw_event() for mcp2221

Christoffer Sandberg <cs@tuxedo.de>
    platform/x86/amd/pmc: Add Stellaris Slim Gen6 AMD to spurious 8042 quirks list

Duy Nguyen <duy.nguyen.rh@renesas.com>
    can: rcar_canfd: Fix controller mode setting

Chen Yufeng <chenyufeng@iie.ac.cn>
    can: hi311x: fix null pointer dereference when resuming from sleep before interface was enabled

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: WARN if an object is aborted with an elevated refcount

Lizhi Xu <lizhi.xu@windriver.com>
    netfs: Prevent duplicate unlocking

David Sterba <dsterba@suse.com>
    btrfs: ref-verify: handle damaged extent root tree

Jack Yu <jack.yu@realtek.com>
    ASoC: rt5682s: Adjust SAR ADC button mode to fix noise issue

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Support new ACPI ID AMDI0108

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/gfx11: Add Cleaner Shader Support for GFX11.0.1/11.0.4 GPUs

hupu <hupu.gm@gmail.com>
    perf subcmd: avoid crash in exclude_cmds when excludes is empty

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for OneXPlayer X1Pro EVA-02

aprilgrimoire <aprilgrimoire@proton.me>
    platform/x86/amd/pmc: Add MECHREVO Yilong15Pro to spurious_8042 list

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: limit MAX_TAG_SIZE to 255

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Adjust pdm gain value

Shuming Fan <shumingf@realtek.com>
    ASoC: rt712: avoid skipping the blind write

Antheas Kapenekakis <lkml@antheas.dev>
    gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-05

Rahul Rameshbabu <sergeantsagara@protonmail.com>
    rust: pci: fix incorrect platform reference in PCI driver probe doc comment

Miguel Ojeda <ojeda@kernel.org>
    rust: block: fix `srctree/` links

Miguel Ojeda <ojeda@kernel.org>
    rust: drm: fix `srctree/` links

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Don't claim USB ID 07b8:8188

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192cu: Don't claim USB ID 07b8:8188

Zenm Chen <zenmchen@gmail.com>
    Bluetooth: btusb: Add USB ID 2001:332a for D-Link AX9U rev. A1

Xiaowei Li <xiaowei.li@simcom.com>
    USB: serial: option: add SIMCom 8230C compositions

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: fix use-after-free in rtw89_core_tx_kick_off_and_wait()

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: mcc: stop TX during MCC prepare

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Enable MES lr_compute_wa by default

Shenghao Ding <shenghao-ding@ti.com>
    ALSA: hda/tas2781: Fix the order of TAS2781 calibrated-data


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/kvm/emulate.c                             |  9 ++-
 arch/x86/kvm/kvm_emulate.h                         |  3 +-
 arch/x86/kvm/x86.c                                 | 15 ++---
 crypto/rng.c                                       |  8 +++
 drivers/android/dbitmap.h                          |  1 +
 drivers/base/faux.c                                |  1 +
 drivers/bluetooth/btusb.c                          |  2 +
 drivers/gpio/gpiolib-acpi-quirks.c                 | 12 ++++
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             | 15 +++++
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |  6 ++
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |  5 ++
 drivers/gpu/drm/amd/include/mes_v11_api_def.h      |  3 +-
 drivers/gpu/drm/amd/include/mes_v12_api_def.h      |  3 +-
 drivers/hid/hid-mcp2221.c                          |  4 ++
 drivers/iommu/iommufd/device.c                     |  3 +-
 drivers/iommu/iommufd/iommufd_private.h            |  3 +-
 drivers/iommu/iommufd/main.c                       |  4 ++
 drivers/md/dm-integrity.c                          |  2 +-
 drivers/misc/amd-sbi/Kconfig                       |  1 +
 drivers/net/can/rcar/rcar_canfd.c                  |  7 ++-
 drivers/net/can/spi/hi311x.c                       | 33 ++++++-----
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  2 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |  1 -
 drivers/net/wireless/realtek/rtw89/chan.c          | 35 +++++++++++
 drivers/net/wireless/realtek/rtw89/chan.h          |  2 +
 drivers/net/wireless/realtek/rtw89/core.c          | 32 ++++++++--
 drivers/net/wireless/realtek/rtw89/core.h          | 37 +++++++++++-
 drivers/net/wireless/realtek/rtw89/pci.c           |  3 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |  2 +
 drivers/nvmem/layouts.c                            | 13 +++++
 drivers/platform/x86/amd/pmc/pmc-quirks.c          | 15 +++++
 drivers/platform/x86/amd/pmf/core.c                |  1 +
 drivers/platform/x86/oxpec.c                       |  7 +++
 drivers/staging/axis-fifo/axis-fifo.c              | 68 ++++++++++------------
 drivers/tty/serial/Kconfig                         |  2 +-
 drivers/usb/serial/option.c                        |  6 ++
 fs/btrfs/ref-verify.c                              |  9 ++-
 fs/netfs/buffered_write.c                          |  2 +-
 include/linux/device.h                             |  3 +
 kernel/trace/ring_buffer.c                         |  2 +-
 net/9p/trans_fd.c                                  |  8 +--
 rust/kernel/block/mq/gen_disk.rs                   |  2 +-
 rust/kernel/drm/device.rs                          |  2 +-
 rust/kernel/drm/driver.rs                          |  2 +-
 rust/kernel/drm/file.rs                            |  2 +-
 rust/kernel/drm/gem/mod.rs                         |  2 +-
 rust/kernel/drm/ioctl.rs                           |  2 +-
 rust/kernel/pci.rs                                 |  4 +-
 sound/pci/hda/tas2781_hda.c                        | 25 ++++++--
 sound/soc/amd/acp/amd.h                            |  2 +-
 sound/soc/codecs/rt5682s.c                         | 17 +++---
 sound/soc/codecs/rt712-sdca.c                      |  6 +-
 tools/lib/subcmd/help.c                            |  3 +
 54 files changed, 339 insertions(+), 124 deletions(-)


