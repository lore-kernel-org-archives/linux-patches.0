Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98922578D;
	Wed, 10 Dec 2025 07:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352010; cv=none; b=Ee/VkcoX5taaAfBzHHNcMQ/KzMTsnVnLjX++gzLcyRsNt7bEIHu1c+X1IggC9u1Ixkqf/jg+nNw/hFKsl4EMivlnnmS/8+2KNpblpY/X03D4TsWN2KRzJ+918B/43KED74jynggKYYqt/IOV46KUnUE281yozJuAcV2j3t0dF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352010; c=relaxed/simple;
	bh=WaU8CB+keO7tGquzhNUmzKphso7QZVUTw0nW+6rRSOs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NibCcdy1jH9ob62ePONbrQvbBWfGf8ZSCzR6Iiue86u5aSOZscNlwJpxIHB/xPX5yZFl+M1qfuLhrMO9icVN+rtuz+LH5kXoW1AKS0RlMefKJkCjnAbWJ/RmSGAXWWxZsr7VRVI1nHmzTrbHggbdZnsb1PenkO3sq3LlC2QxeaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Orf5B6M8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Orf5B6M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EBAC4CEF1;
	Wed, 10 Dec 2025 07:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352010;
	bh=WaU8CB+keO7tGquzhNUmzKphso7QZVUTw0nW+6rRSOs=;
	h=From:To:Cc:Subject:Date:From;
	b=Orf5B6M8UV2k1Aur8J2k1VNvvOW9iBY7F+Y+zrJoLEtNNyVDhXMl3ZyfjkiZ5lMKM
	 kTinYhx7tk0e8gxRuil1numjnDDllqurb96qkoswFXP3el7MYPCyc0sv49bBEAvrwn
	 1LxZQZkyNLdGBe6YvWsnNAsyzIHT2IUOUdJrmSEA=
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
Subject: [PATCH 6.17 00/60] 6.17.12-rc1 review
Date: Wed, 10 Dec 2025 16:29:30 +0900
Message-ID: <20251210072947.850479903@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.12-rc1
X-KernelTest-Deadline: 2025-12-12T07:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.12 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.12-rc1

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

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ad4080: fix chip identification

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1

Zenm Chen <zenmchen@gmail.com>
    wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1

Marcos Vega <marcosmola2@gmail.com>
    platform/x86: hp-wmi: Add Omen MAX 16-ah0xx fan support and thermal profile

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add Omen 16-wf1xxx fan support

Linus Torvalds <torvalds@linux-foundation.org>
    samples: work around glibc redefining some of our defines wrong

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Mask all interrupts during kexec/kdump

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Use IRQ_WORK_INIT_HARD() to initialize rq->scx.kick_cpus_irq_work

Naoki Ueki <naoki25519@gmail.com>
    HID: elecom: Add support for ELECOM M-XT3URBK (018F)

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel/hid: Add Nova Lake support

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix possible deadlock in the deferred_irq_workfn()

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd/pmc: Add spurious_8042 to Xbox Ally

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    platform/x86: intel-uncore-freq: Add additional client processors

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

Edip Hazuri <edip@medip.dev>
    platform/x86: hp-wmi: mark Victus 16-r0 and 16-s0 for victus_s fan and thermal profile support

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd/pmc: Add support for Van Gogh SoC

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: hid-input: Extend Elan ignore battery quirk to USB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bfs: Reconstruct file type when loading from disk

Lauri Tirkkonen <lauri@hacktheplanet.fi>
    HID: lenovo: fixup Lenovo Yoga Slim 7x Keyboard rdesc

Lushih Hsieh <bruce@mail.kh.edu.tw>
    ALSA: usb-audio: Add native DSD quirks for PureAudio DAC series

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: Fix GPU mappings for APU after prefetch

Yiqi Sun <sunyiqixm@gmail.com>
    smb: fix invalid username check in smb3_fs_context_parse_param()

Niranjan H Y <niranjan.hy@ti.com>
    ASoC: SDCA: bug fix while parsing mipi-sdca-control-cn-list

Max Chou <max.chou@realtek.com>
    Bluetooth: btrtl: Avoid loading the config file on security chips

Baojun Xu <baojun.xu@ti.com>
    ALSA: hda/tas2781: Add new quirk for HP new projects

Adrian Barnaś <abarnas@google.com>
    arm64: Reject modules with internal alternative callbacks

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Use kref in vmw_bo_dirty

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    ACPI: MRRM: Fix memory leaks and improve error handling

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

Biju Das <biju.das.jz@bp.renesas.com>
    serial: sh-sci: Fix deadlock during RSCI FIFO overrun error

Biju Das <biju.das.jz@bp.renesas.com>
    dt-bindings: serial: rsci: Drop "uart-has-rtscts: false"

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

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: zstd - fix double-free in per-CPU stream cleanup

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    locking/spinlock/debug: Fix data-race in do_raw_write_lock

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: ipc: fix use-after-free in ipc_msg_send_request

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: refresh inline data size before write operations

Ye Bin <yebin10@huawei.com>
    jbd2: avoid bug_on in jbd2_journal_get_create_access() when file system corrupted

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: process: Also mention Sasha Levin as stable tree maintainer


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,rsci.yaml   |  2 -
 Documentation/process/2.Process.rst                |  6 +-
 Makefile                                           |  4 +-
 arch/arm64/include/asm/alternative.h               |  7 ++-
 arch/arm64/kernel/alternative.c                    | 19 +++---
 arch/arm64/kernel/module.c                         |  9 ++-
 arch/loongarch/kernel/machine_kexec.c              |  2 +
 arch/x86/include/asm/kvm_host.h                    |  9 +++
 arch/x86/kvm/svm/svm.c                             | 24 ++++----
 arch/x86/kvm/x86.c                                 | 21 +++++++
 crypto/zstd.c                                      |  7 +--
 drivers/acpi/acpi_mrrm.c                           | 51 ++++++++++-----
 drivers/bluetooth/btrtl.c                          | 24 ++++----
 drivers/comedi/comedi_fops.c                       | 42 +++++++++++--
 drivers/comedi/drivers/c6xdigio.c                  | 46 ++++++++++----
 drivers/comedi/drivers/multiq3.c                   |  9 +++
 drivers/comedi/drivers/pcl818.c                    |  5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         | 12 ++--
 drivers/hid/hid-apple.c                            |  1 +
 drivers/hid/hid-elecom.c                           |  6 +-
 drivers/hid/hid-ids.h                              |  4 +-
 drivers/hid/hid-input.c                            |  5 +-
 drivers/hid/hid-lenovo.c                           | 17 +++++
 drivers/hid/hid-quirks.c                           |  3 +-
 drivers/iio/adc/ad4080.c                           |  9 ++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  3 +
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c     |  2 +
 drivers/nvme/host/core.c                           |  3 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  2 +-
 drivers/platform/x86/acer-wmi.c                    |  4 ++
 drivers/platform/x86/amd/pmc/pmc-quirks.c          | 25 ++++++++
 drivers/platform/x86/amd/pmc/pmc.c                 |  3 +
 drivers/platform/x86/amd/pmc/pmc.h                 |  1 +
 drivers/platform/x86/hp/hp-wmi.c                   |  6 +-
 drivers/platform/x86/huawei-wmi.c                  |  4 ++
 drivers/platform/x86/intel/hid.c                   |  1 +
 .../x86/intel/uncore-frequency/uncore-frequency.c  |  4 ++
 drivers/spi/spi-imx.c                              | 15 +++--
 drivers/spi/spi-xilinx.c                           |  2 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     | 14 +++--
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      | 13 ++--
 drivers/tty/serial/8250/8250_pci.c                 | 37 +++++++++++
 drivers/tty/serial/sh-sci.c                        | 12 +++-
 drivers/usb/serial/belkin_sa.c                     | 28 +++++----
 drivers/usb/serial/ftdi_sio.c                      | 72 ++++++++--------------
 drivers/usb/serial/kobil_sct.c                     | 18 +++---
 drivers/usb/serial/option.c                        | 22 ++++++-
 fs/bfs/inode.c                                     | 19 +++++-
 fs/ext4/inline.c                                   | 14 ++++-
 fs/jbd2/transaction.c                              | 19 ++++--
 fs/smb/client/fs_context.c                         |  2 +-
 fs/smb/server/transport_ipc.c                      |  7 ++-
 kernel/locking/spinlock_debug.c                    |  4 +-
 kernel/sched/ext.c                                 |  4 +-
 kernel/trace/ftrace.c                              | 40 +++++++++---
 samples/vfs/test-statx.c                           |  6 ++
 samples/watch_queue/watch_test.c                   |  6 ++
 sound/hda/codecs/realtek/alc269.c                  |  9 +++
 sound/soc/sdca/sdca_functions.c                    |  3 +-
 sound/usb/quirks.c                                 |  6 ++
 61 files changed, 564 insertions(+), 212 deletions(-)


