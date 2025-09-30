Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA8304BD4;
	Tue, 30 Sep 2025 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244080; cv=none; b=nBX7k0JuVaRGDVDxBV38hIHW8pfuwM8DWIvc5nU08dwXCBG+cSbLYSQFsg8bMRWECKe++fnLFbBluPclQkvLenRmbJFjkmRLSVhorvveyYnIILm/x7fMqmqygl1F6YpqA//KeqGUrgiU5Ner46jYDnerzt9Z/F85K63B/yhft8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244080; c=relaxed/simple;
	bh=y5di4zWex2fVjFcUckDb7URzseyqwhtI4yBUheBjHhU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uqnPXyvFda2IpBVxq3wHVQZo8k1jkzmKGu1CHs248wVDOa219kLf9JTSawDqsCsxPmYjfdsC7iBZl+jEx+TIwlyiIV6IsKwNu9ZC6sj/6n+1SOZqWVy6XhbNZCI743C4NCRj0SXv340X58StQfpPpWwlGGECHP6dM21Jf17ENg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8xfYVYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8xfYVYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC69C4CEF0;
	Tue, 30 Sep 2025 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244080;
	bh=y5di4zWex2fVjFcUckDb7URzseyqwhtI4yBUheBjHhU=;
	h=From:To:Cc:Subject:Date:From;
	b=q8xfYVYnQJXnVDyVKuX4J/wi4C3rXRFeKGSz3w0JN5wuCDqSQ26fs37++2ZSKQGtp
	 KRJZOHoQ739lUycjSIRX2Bonfp1WQqSBCF+7grEB/kQOkXm4wqEeJ4358Ib6di4OU+
	 Y2kKD3Pnfo/7NQDBJ1tPvFYYX4ouK/WxnHMeMkwc=
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
Subject: [PATCH 5.10 000/122] 5.10.245-rc1 review
Date: Tue, 30 Sep 2025 16:45:31 +0200
Message-ID: <20250930143822.939301999@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.245-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.245 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.245-rc1

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: dynevent: Add a missing lockdown check on dynevent

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add mask to apply valid bits for itr_idx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add max boundary check for VF filters

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix input validation logic for action_meta

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in i40e_validate_queue_map

Eric Biggers <ebiggers@kernel.org>
    crypto: af_alg - Fix incorrect boolean values in af_alg_ctx

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Ido Schimmel <idosch@nvidia.com>
    selftests: fib_nexthops: Fix creation of non-FDB nexthops

Ido Schimmel <idosch@nvidia.com>
    nexthop: Forbid FDB status change while nexthop is in a group

Ido Schimmel <idosch@nvidia.com>
    nexthop: Emit a notification when a single nexthop is replaced

Ido Schimmel <idosch@nvidia.com>
    nexthop: Emit a notification when a nexthop is added

Ido Schimmel <idosch@nvidia.com>
    rtnetlink: Add RTNH_F_TRAP flag

Ido Schimmel <idosch@nvidia.com>
    nexthop: Pass extack to nexthop notifier

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: correct offset handling for IPv6 destination address

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

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Initialize cpufreq-based invariance before subsys

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: Correct thermal sensor index

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
    ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix block comments in mixer_quirks

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the incorrect inode ref size check

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Philipp Zabel <p.zabel@pengutronix.de>
    net: rfkill: gpio: add DT support

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Rob Herring <robh@kernel.org>
    phy: Use device_get_match_data()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: broadcom: ns-usb3: fix Wvoid-pointer-to-enum-cast warning

Rafał Miłecki <rafal@milecki.pl>
    phy: phy-bcm-ns-usb3: drop support for deprecated DT binding

Chunfeng Yun <chunfeng.yun@mediatek.com>
    phy: ti: convert to devm_platform_ioremap_resource(_byname)

Chunfeng Yun <chunfeng.yun@mediatek.com>
    phy: broadcom: convert to devm_platform_ioremap_resource(_byname)

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Jakob Koschel <jakobkoschel@gmail.com>
    usb: gadget: dummy_hcd: remove usage of list iterator past the loop body

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in flow control levels init

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

Qi Xi <xiqi2@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path

Colin Ian King <colin.i.king@gmail.com>
    ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8974: Correct PLL rate rounding

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct typo in control name

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

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

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qed: Don't collect too many protection override GRC elements

Miaoqian Lin <linmq006@gmail.com>
    um: virtio_uml: Fix use-after-free after put_device in probe

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

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

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

Antoine Tenart <atenart@kernel.org>
    tunnels: reset the GSO metadata before reusing the skb

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910C4-WWX new compositions

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A w/audio compositions

Fabian Vogt <fvogt@suse.de>
    tty: hvc_console: Call hvc_kick in hvc_write unconditionally

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Alexander Dahl <ada@thorsis.com>
    mtd: nand: raw: atmel: Fix comment in timings preparation

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Jack Wang <jinpu.wang@ionos.com>
    mtd: rawnand: stm32_fmc2: Fix dma_map_sg error check

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

Nathan Chancellor <nathan@kernel.org>
    compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Salah Triki <salah.triki@gmail.com>
    EDAC/altera: Delete an inappropriate dma_free_coherent() call

Kees Cook <keescook@chromium.org>
    overflow: Allow mixed type arguments

Nick Desaulniers <ndesaulniers@google.com>
    compiler.h: drop fallback overflow checkers

Keith Busch <kbusch@kernel.org>
    overflow: Correct check_shl_overflow() comment

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/flexfiles: Fix layout merge mirror check.

Luo Gengkun <luogengkun@huaweicloud.com>
    tracing: Fix tracing_marker may trigger page fault during preempt_disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Add check for devm_kcalloc()

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Fix link frequency validation

Arnd Bergmann <arnd@arndb.de>
    media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: flush: do not reset ADD_ADDR limit


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/um/drivers/virtio_uml.c                       |   6 +-
 arch/x86/kvm/svm/svm.c                             |   3 +-
 crypto/af_alg.c                                    |   7 +
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   6 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 +
 drivers/media/i2c/imx214.c                         |  27 +-
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |   6 +-
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/mtd/mtdpstore.c                            |   3 +
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  18 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  48 ++--
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  45 +++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/natsemi/ns83820.c             |  13 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   7 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/phy/broadcom/phy-bcm-cygnus-pcie.c         |   4 +-
 drivers/phy/broadcom/phy-bcm-kona-usb2.c           |   4 +-
 drivers/phy/broadcom/phy-bcm-ns-usb2.c             |   4 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             | 168 +-----------
 drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c          |  13 +-
 drivers/phy/broadcom/phy-bcm-sr-pcie.c             |   5 +-
 drivers/phy/broadcom/phy-bcm-sr-usb.c              |   4 +-
 drivers/phy/broadcom/phy-brcm-sata.c               |   8 +-
 drivers/phy/marvell/phy-berlin-usb.c               |   7 +-
 drivers/phy/ralink/phy-ralink-usb.c                |  10 +-
 drivers/phy/rockchip/phy-rockchip-pcie.c           |  11 +-
 drivers/phy/rockchip/phy-rockchip-usb.c            |  10 +-
 drivers/phy/ti/phy-omap-control.c                  |  26 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  28 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |  42 +--
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 drivers/soc/qcom/mdt_loader.c                      |  12 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  25 +-
 drivers/usb/host/xhci-dbgcap.c                     |  94 +++++--
 drivers/usb/serial/option.c                        |  17 ++
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/fuse/file.c                                     |   5 +-
 fs/hugetlbfs/inode.c                               |  14 +-
 fs/nfs/client.c                                    |   2 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 +-
 fs/nfs/nfs4proc.c                                  |   1 -
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/ocfs2/extent_map.c                              |  10 +-
 include/crypto/if_alg.h                            |  10 +-
 include/linux/compiler-clang.h                     |  44 ++--
 include/linux/compiler-gcc.h                       |   4 -
 include/linux/interrupt.h                          |  96 ++++---
 include/linux/overflow.h                           | 208 ++++-----------
 include/net/nexthop.h                              |   3 +-
 include/net/sock.h                                 |  40 ++-
 include/uapi/linux/rtnetlink.h                     |   6 +-
 kernel/cgroup/cgroup.c                             |  43 +++-
 kernel/irq/manage.c                                | 111 +++++++-
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_dynevent.c                      |   4 +
 mm/khugepaged.c                                    |   2 +-
 mm/memory-failure.c                                |   7 +-
 mm/migrate.c                                       |  12 +-
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/core/sock.c                                    |   5 +
 net/ipv4/fib_semantics.c                           |   2 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/nexthop.c                                 |  28 +-
 net/ipv4/tcp.c                                     |   5 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mptcp/pm_netlink.c                             |   1 -
 net/mptcp/protocol.c                               |  16 ++
 net/rds/ib_frmr.c                                  |  20 +-
 net/rfkill/rfkill-gpio.c                           |  22 +-
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/soc/codecs/wm8940.c                          |   2 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 sound/usb/mixer_quirks.c                           | 285 ++++++++++++++++++++-
 tools/include/linux/compiler-gcc.h                 |   4 -
 tools/include/linux/overflow.h                     | 140 +---------
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 109 files changed, 1195 insertions(+), 909 deletions(-)


