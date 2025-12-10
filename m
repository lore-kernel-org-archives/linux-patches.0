Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93FB20102B;
	Wed, 10 Dec 2025 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351899; cv=none; b=tGcHjxIxhJgye0ltkx23jftge6sY4IAqICFxsg8UxTufhS6YzyWc4l1vhupjaI297WCoE+Gq3DJTY6auHqoTC1AI+nSoJ4GJAEqSsxGsOzQF2zLsb6KoOCp9uklOI0tsbsEi/HwGt9KrrtJT5hlalMA3yLEekanvGS/IEo1evJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351899; c=relaxed/simple;
	bh=OzirUe8Ps3wt8uzTut46rPEI+8P8UHybNVej/xoYs/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ceXWO+s/56KkEN2onoHB47KUR88FL2cE18ZsEFUsY4X0Je0woRaEhGXNbmHTghlGmpHNA4v/Jk75ub7LZ1C4dehGbtWbCgpRleGXiBVkYsNj9bgQTDYXM3LKNmpeQPFEZrIhFSfGUMy8gCrFF9fRdBMtB0oFfaOjUxVVlXTbPVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j69s7w0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j69s7w0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C021C4CEF1;
	Wed, 10 Dec 2025 07:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351898;
	bh=OzirUe8Ps3wt8uzTut46rPEI+8P8UHybNVej/xoYs/M=;
	h=From:To:Cc:Subject:Date:From;
	b=j69s7w0sKq3shPtRYz2Qca/J/ZOgi9r7Uk92jevvnrygJKIAKc/5bjGVOpl9YvY/V
	 Pm8I1AgdYDATSjhAJoO5bLt7NVwkNgtOxVVp7kNVHmOFwnE7MuXrMa5asmpkgvbCpP
	 EuPJJ24HGXtSg2G6ODDWj6YIh7F6EJu13C/XI/Fc=
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
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 00/49] 6.12.62-rc1 review
Date: Wed, 10 Dec 2025 16:29:30 +0900
Message-ID: <20251210072948.125620687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.62-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.62-rc1
X-KernelTest-Deadline: 2025-12-12T07:29+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.62 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.62-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.62-rc1

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: Add Telit FN990B40 modem support

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: Add Telit FN920C04 modem support

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: check device's attached status in compat ioctls

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: multiq3: sanitize config options in multiq3_attach()

Ian Abbott <abbotti@mev.co.uk>
    comedi: c6xdigio: Fix invalid PNP driver unregistration

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1

Zenm Chen <zenmchen@gmail.com>
    wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1

Linus Torvalds <torvalds@linux-foundation.org>
    samples: work around glibc redefining some of our defines wrong

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Mask all interrupts during kexec/kdump

Naoki Ueki <naoki25519@gmail.com>
    HID: elecom: Add support for ELECOM M-XT3URBK (018F)

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd/pmc: Add spurious_8042 to Xbox Ally

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list

Jia Ston <ston.jia@outlook.com>
    platform/x86: huawei-wmi: add keys for HONOR models

April Grimoire <april@aprilg.moe>
    HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore backlight event

Praveen Talari <praveen.talari@oss.qualcomm.com>
    pinctrl: qcom: msm: Fix deadlock in pinmux configuration

Keith Busch <kbusch@kernel.org>
    nvme: fix admin request_queue lifetime

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: hid-input: Extend Elan ignore battery quirk to USB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bfs: Reconstruct file type when loading from disk

Lushih Hsieh <bruce@mail.kh.edu.tw>
    ALSA: usb-audio: Add native DSD quirks for PureAudio DAC series

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: Fix GPU mappings for APU after prefetch

Yiqi Sun <sunyiqixm@gmail.com>
    smb: fix invalid username check in smb3_fs_context_parse_param()

Max Chou <max.chou@realtek.com>
    Bluetooth: btrtl: Avoid loading the config file on security chips

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Use kref in vmw_bo_dirty

Robin Gong <yibin.gong@nxp.com>
    spi: imx: keep dma request disabled before dma transfer setup

Alvaro Gamez Machado <alvaro.gamez@hazent.com>
    spi: xilinx: increase number of retries before declaring stall

Song Liu <song@kernel.org>
    ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()

Johan Hovold <johan@kernel.org>
    USB: serial: kobil_sct: fix TIOCMBIS and TIOCMBIC

Johan Hovold <johan@kernel.org>
    USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC

Magne Bruno <magne.bruno@addi-data.com>
    serial: add support of CPCI cards

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: match on interface number for jtag

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: move Telit 0x10c7 composition in the right place

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 new compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W760

Omar Sandoval <osandov@fb.com>
    KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: pcl818: fix null-ptr-deref in pcl818_ai_cancel()

Alexey Nepomnyashih <sdl@nppct.ru>
    ext4: add i_data_sem protection in ext4_destroy_inline_data_nolock()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    locking/spinlock/debug: Fix data-race in do_raw_write_lock

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: ipc: fix use-after-free in ipc_msg_send_request

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: refresh inline data size before write operations

Ye Bin <yebin10@huawei.com>
    jbd2: avoid bug_on in jbd2_journal_get_create_access() when file system corrupted

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: process: Also mention Sasha Levin as stable tree maintainer

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: flush all states in xfrm_state_fini

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: also call xfrm_state_delete_tunnel at destroy time for states that were never added

Sabrina Dubroca <sd@queasysnail.net>
    Revert "xfrm: destroy xfrm_state synchronously on net exit path"

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: delete x->tunnel as we delete x


-------------

Diffstat:

 Documentation/process/2.Process.rst            |  6 ++-
 Makefile                                       |  4 +-
 arch/loongarch/kernel/machine_kexec.c          |  2 +
 arch/x86/include/asm/kvm_host.h                |  9 ++++
 arch/x86/kvm/svm/svm.c                         | 24 +++++----
 arch/x86/kvm/x86.c                             | 21 ++++++++
 drivers/bluetooth/btrtl.c                      | 24 +++++----
 drivers/bus/mhi/host/pci_generic.c             | 52 +++++++++++++++++++
 drivers/comedi/comedi_fops.c                   | 42 ++++++++++++---
 drivers/comedi/drivers/c6xdigio.c              | 46 ++++++++++++----
 drivers/comedi/drivers/multiq3.c               |  9 ++++
 drivers/comedi/drivers/pcl818.c                |  5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c           |  2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c     | 12 ++---
 drivers/hid/hid-apple.c                        |  1 +
 drivers/hid/hid-elecom.c                       |  6 ++-
 drivers/hid/hid-ids.h                          |  3 +-
 drivers/hid/hid-input.c                        |  5 +-
 drivers/hid/hid-quirks.c                       |  3 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c   |  3 ++
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c |  2 +
 drivers/nvme/host/core.c                       |  3 +-
 drivers/pinctrl/qcom/pinctrl-msm.c             |  2 +-
 drivers/platform/x86/acer-wmi.c                |  4 ++
 drivers/platform/x86/amd/pmc/pmc-quirks.c      | 25 +++++++++
 drivers/platform/x86/huawei-wmi.c              |  4 ++
 drivers/spi/spi-imx.c                          | 15 ++++--
 drivers/spi/spi-xilinx.c                       |  2 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c | 14 ++---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c  | 13 +++--
 drivers/tty/serial/8250/8250_pci.c             | 37 +++++++++++++
 drivers/usb/serial/belkin_sa.c                 | 28 ++++++----
 drivers/usb/serial/ftdi_sio.c                  | 72 +++++++++-----------------
 drivers/usb/serial/kobil_sct.c                 | 18 +++----
 drivers/usb/serial/option.c                    | 22 ++++++--
 fs/bfs/inode.c                                 | 19 ++++++-
 fs/ext4/inline.c                               | 14 ++++-
 fs/jbd2/transaction.c                          | 19 +++++--
 fs/smb/client/fs_context.c                     |  2 +-
 fs/smb/server/transport_ipc.c                  |  7 ++-
 include/net/xfrm.h                             | 13 ++---
 kernel/locking/spinlock_debug.c                |  4 +-
 kernel/trace/ftrace.c                          | 40 ++++++++++----
 net/ipv4/ipcomp.c                              |  2 +
 net/ipv6/ipcomp6.c                             |  2 +
 net/ipv6/xfrm6_tunnel.c                        |  2 +-
 net/key/af_key.c                               |  2 +-
 net/xfrm/xfrm_ipcomp.c                         |  1 -
 net/xfrm/xfrm_state.c                          | 41 ++++++---------
 net/xfrm/xfrm_user.c                           |  2 +-
 samples/vfs/test-statx.c                       |  6 +++
 samples/watch_queue/watch_test.c               |  6 +++
 sound/usb/quirks.c                             |  6 +++
 53 files changed, 521 insertions(+), 207 deletions(-)


