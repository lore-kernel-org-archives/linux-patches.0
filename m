Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6487125D1F7;
	Tue, 30 Sep 2025 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243841; cv=none; b=M+R/pNduWviCuwHTtt4floJL9mRaYLck6cvuvV5CGSliqn3FF4y3CDAr2avFXp2nuxpijfEOLTW0ISg0XcrFBeDno7cplYgQj2Iu6ZdlMx7Yf/h95dC0rkcANNDj51bEFWM4Ty64mDAjBytXMFnyeUNUQ+s7yx6TGHUkf9UMVkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243841; c=relaxed/simple;
	bh=gw+WLp65zmGfsyoflL1FHMsmTwVGN6yACr8ZD0DSG+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n7pgFzIrTXR3s/hGffQslGOKmeBkxHIgkRuBgl/ljEoIybzuTWoFZ66ayYAev4IdzLXCQLUoWe4qsz2kAXgUE5GfS9LjOUUzNvKpxblSymWfjGTKjMjscIwsac4fVObP1eMrnO8RoNUTF4LDEKNZhC1skajyUgMfdb//VFjEGJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHyPXMpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHyPXMpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE3CC4CEF0;
	Tue, 30 Sep 2025 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243841;
	bh=gw+WLp65zmGfsyoflL1FHMsmTwVGN6yACr8ZD0DSG+c=;
	h=From:To:Cc:Subject:Date:From;
	b=xHyPXMpVrGRRtEsneN3Uve2yiAWQ+QotPYz4PQM/ZSEmXCC+MQ7AwOGoRWZ6qQi4b
	 5XkPo+7Tg8bqzWuZ/zVce0Wcbm1a7oBxImNi+7+gwTEJSz8g2D13BO7FL2KRWvueb7
	 X34xIWZpU8J6ld+QwP79yOOMzuvnrcl/hFpB/9K4=
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
Subject: [PATCH 5.4 00/81] 5.4.300-rc1 review
Date: Tue, 30 Sep 2025 16:46:02 +0200
Message-ID: <20250930143819.654157320@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.300-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.300-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.300 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.300-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.300-rc1

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add mask to apply valid bits for itr_idx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix validation of VF state in get resources

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in config queues msg

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Justin Bronder <jsbronder@cold-front.org>
    i40e: increase max descriptors for XL710

David Hildenbrand <david@redhat.com>
    mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Fix OOB access in font allocation

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    fbcon: fix integer overflow in fbcon_do_set_font

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add max boundary check for VF filters

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix input validation logic for action_meta

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in i40e_validate_queue_map

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Stéphane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix shift-out-of-bounds issue

Vincent Mailhol <mailhol@kernel.org>
    can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: sun4i_can: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: hi311x: populate ndo_change_mtu() to prevent buffer overflow

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_can: rcar_can_resume(): fix s2ram with PSCI

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions

Jiayi Li <lijiayi@kylinos.cn>
    usb: core: Add 0x prefix to quirks debug output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix build with CONFIG_INPUT=n

Chen Ni <nichen@iscas.ac.cn>
    ALSA: usb-audio: Convert comma to semicolon

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Remove unneeded wmb() in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Simplify NULL comparison in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid multiple assignments in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix block comments in mixer_quirks

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Philipp Zabel <p.zabel@pengutronix.de>
    net: rfkill: gpio: add DT support

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in flow control levels init

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Jakob Koschel <jakobkoschel@gmail.com>
    usb: gadget: dummy_hcd: remove usage of list iterator past the loop body

Colin Ian King <colin.i.king@gmail.com>
    ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8974: Correct PLL rate rounding

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct typo in control name

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: mvsdio: Fix dma_unmap_sg() nents value

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: restrict no-battery detection to bq27000

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery

Nathan Chancellor <nathan@kernel.org>
    nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*

Duoming Zhou <duoming@zju.edu.cn>
    cnic: Fix use-after-free bugs in cnic_delete_task

Alexey Nepomnyashih <sdl@nppct.ru>
    net: liquidio: fix overflow in octeon_init_instr_queue()

Tariq Toukan <tariqt@nvidia.com>
    Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect().

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: remove redundant memory barrier when cleaning Tx descs

Yeounsu Moon <yyyynoom@gmail.com>
    net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure

Chen Ridong <chenridong@huawei.com>
    cgroup: split cgroup_destroy_wq into 3 workqueues

Geert Uytterhoeven <geert+renesas@glider.be>
    pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch

Liao Yuanhong <liaoyuanhong@vivo.com>
    wifi: mac80211: fix incorrect type for ret

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Deal with zero e_shentsize

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

Stephan Gerhold <stephan.gerhold@linaro.org>
    dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees

Anders Roxell <anders.roxell@linaro.org>
    dmaengine: ti: edma: Fix memory allocation size for queue_priority_map

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed

Michal Schmidt <mschmidt@redhat.com>
    i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path

Nitesh Narayan Lal <nitesh@redhat.com>
    i40e: Use irq_update_affinity_hint()

Thomas Gleixner <tglx@linutronix.de>
    genirq: Provide new interfaces for affinity hints

Thomas Gleixner <tglx@linutronix.de>
    genirq: Export affinity setter for modules

John Garry <john.garry@huawei.com>
    genirq/affinity: Add irq_update_affinity_desc()

Kohei Enju <enjuk@amazon.com>
    igb: fix link test skipping when interface is admin down

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910C4-WWX new compositions

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A w/audio compositions

Fabian Vogt <fvogt@suse.de>
    tty: hvc_console: Call hvc_kick in hvc_write unconditionally

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Alexander Dahl <ada@thorsis.com>
    mtd: nand: raw: atmel: Fix comment in timings preparation

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

Miklos Szeredi <mszeredi@redhat.com>
    fuse: prevent overflow in copy_file_range return value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check if copy_file_range() returns larger than requested size

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: fix ECC overwrite

Mark Tinguely <mark.tinguely@oracle.com>
    ocfs2: fix recursive semaphore deadlock in fiemap call

Salah Triki <salah.triki@gmail.com>
    EDAC/altera: Delete an inappropriate dma_free_coherent() call

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing of delayed work used for post resume purposes


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/kvm/svm.c                                 |   3 +-
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  18 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  45 ++--
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  46 +++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/natsemi/ns83820.c             |  13 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |  13 +
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 drivers/soc/qcom/mdt_loader.c                      |  12 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  13 +-
 drivers/usb/core/hub.c                             |  21 +-
 drivers/usb/core/hub.h                             |   1 +
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  25 +-
 drivers/usb/serial/option.c                        |  17 ++
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 fs/fuse/file.c                                     |   5 +-
 fs/hugetlbfs/inode.c                               |  14 +-
 fs/nfs/nfs4proc.c                                  |   1 -
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/ocfs2/extent_map.c                              |  10 +-
 include/linux/interrupt.h                          |  96 ++++---
 include/net/sock.h                                 |  40 ++-
 kernel/cgroup/cgroup.c                             |  43 +++-
 kernel/irq/manage.c                                | 111 +++++++-
 mm/khugepaged.c                                    |   2 +-
 mm/memory-failure.c                                |   7 +-
 mm/migrate.c                                       |  12 +-
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/core/sock.c                                    |   5 +
 net/ipv4/tcp.c                                     |   5 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/rds/ib_frmr.c                                  |  20 +-
 net/rfkill/rfkill-gpio.c                           |  22 +-
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/soc/codecs/wm8940.c                          |   2 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 sound/usb/mixer_quirks.c                           | 279 ++++++++++++++++++++-
 65 files changed, 829 insertions(+), 236 deletions(-)


