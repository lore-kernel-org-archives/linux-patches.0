Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A42F25EC;
	Fri, 10 Oct 2025 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102262; cv=none; b=RyaNvVe9tE7rr8Tv2tCJ0udMEpUsPfZSCGpGKFrLtAUzp6a8WsgFJRoQeBa488K6MqXgw7B5EegOaAHHk0IHUPGpckNGTx32KXykJKoi9IUVOcjSqqpBgW2blcBhZxETzPMebUChMSAR/+SFb8lyCQWfHeVZ/8epeVoolYITSQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102262; c=relaxed/simple;
	bh=g1tcFiXq/auPF/tp0BQIy+OX5DHNj7EIm0lIHshhNAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XlnTGVJhWE1XazEZmpXf8nTvJ51tcIHJchDZqwYw6XGyoqVLCQh56VQ/4UrGDkbCfn+uzvMizXTYrF5hVhdW76tfZb/0bWLJdWfNYv6uD3WixvSslTsllOOrU4XPB+w5CYiwkZO3TPLwwkiHEVDl0jENbOMKnENhfxuFHZUcfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oS0D6pf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oS0D6pf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39709C4CEF8;
	Fri, 10 Oct 2025 13:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102261;
	bh=g1tcFiXq/auPF/tp0BQIy+OX5DHNj7EIm0lIHshhNAE=;
	h=From:To:Cc:Subject:Date:From;
	b=oS0D6pf7Wqo0MUQBk+TdCJmoMOgaRRNOYDONhOwYeagvelEW0tvjLBqpZpuiodaDk
	 Avyj3tJpzxi8qZJXDu+A9uaCP2vBXZqXRa4+IN3uXTiUFMZOWAGoJbdsOwkgkU8FTk
	 eQbnnzSfESePJbQScq0E4xYJY9uUItvWuTYFbHbc=
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
Subject: [PATCH 6.17 00/26] 6.17.2-rc1 review
Date: Fri, 10 Oct 2025 15:15:55 +0200
Message-ID: <20251010131331.204964167@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.2-rc1
X-KernelTest-Deadline: 2025-10-12T13:13+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.2 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.2-rc1

Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
    ring buffer: Propagate __rb_map_vma return value to caller

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node footer for non inode dnode

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Ensure set_ent is always present

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: zstd - Fix compression bug caused by truncation

Herbert Xu <herbert@gondor.apana.org.au>
    Revert "crypto: testmgr - desupport SHA-1 for FIPS 140"

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    serial: qcom-geni: Fix blocked task

Rahul Rameshbabu <sergeantsagara@protonmail.com>
    rust: pci: fix incorrect platform reference in PCI driver unbind doc comment

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

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Enable MES lr_compute_wa by default


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/kvm/emulate.c                             |   9 +-
 arch/x86/kvm/kvm_emulate.h                         |   3 +-
 arch/x86/kvm/x86.c                                 |  15 +-
 crypto/rng.c                                       |   8 +
 crypto/testmgr.c                                   |   5 +
 crypto/zstd.c                                      |   2 +-
 drivers/android/dbitmap.h                          |   1 +
 drivers/base/faux.c                                |   1 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   6 +
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   5 +
 drivers/gpu/drm/amd/include/mes_v11_api_def.h      |   3 +-
 drivers/gpu/drm/amd/include/mes_v12_api_def.h      |   3 +-
 drivers/misc/amd-sbi/Kconfig                       |   1 +
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   1 -
 drivers/nvmem/layouts.c                            |  13 ++
 drivers/staging/axis-fifo/axis-fifo.c              |  68 ++++----
 drivers/tty/serial/Kconfig                         |   2 +-
 drivers/tty/serial/qcom_geni_serial.c              | 176 ++-------------------
 drivers/usb/serial/option.c                        |   6 +
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/gc.c                                       |   4 +-
 fs/f2fs/node.c                                     |  58 ++++---
 fs/f2fs/node.h                                     |   1 +
 fs/f2fs/recovery.c                                 |   2 +-
 include/linux/device.h                             |   3 +
 kernel/trace/ring_buffer.c                         |   2 +-
 net/9p/trans_fd.c                                  |   8 +-
 rust/kernel/block/mq/gen_disk.rs                   |   2 +-
 rust/kernel/drm/device.rs                          |   2 +-
 rust/kernel/drm/driver.rs                          |   2 +-
 rust/kernel/drm/file.rs                            |   2 +-
 rust/kernel/drm/gem/mod.rs                         |   2 +-
 rust/kernel/drm/ioctl.rs                           |   2 +-
 rust/kernel/pci.rs                                 |   6 +-
 37 files changed, 179 insertions(+), 257 deletions(-)


