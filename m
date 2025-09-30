Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AC1487F4;
	Tue, 30 Sep 2025 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244964; cv=none; b=j9TQ72GEFPifdz4K4N9h7vR43pToaTQm6+815FOpo4E74lkYSznQqyKjvaxH+IJInfJ6//IeLp0oaGpRtNP/TdU20+1ht4bQEvhx2NmtqZ6fz1z3JIOQHHvCyHaRI7yMcApcsix2nEwzEKKi/9OqJm1gOrQTIn/z35ZYewUNo7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244964; c=relaxed/simple;
	bh=ZX5CtyX6ow+yL1bEabSZLesZITBdELZk3VHJn2rWkp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Dr/i9kUcEU7a/OKvDUu75w0drU1LmCqwQ0lGMbmd15/UTyGG89X8BVFF8FQ+WlJGelu1aGVWJV9pn8joU+5i6bSVJXfI41qoqUQuqRl2rrZf8OWLbZVzKdK+IH9TFY7pgSUug8tItu1hq9ST2wOGnEvImxC/6CSmlLKl72OcLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNXr/3hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNXr/3hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94FEC4CEF0;
	Tue, 30 Sep 2025 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244964;
	bh=ZX5CtyX6ow+yL1bEabSZLesZITBdELZk3VHJn2rWkp4=;
	h=From:To:Cc:Subject:Date:From;
	b=NNXr/3hGGDBQXctTf92568Qy/CTLaZ8SIwC3W+dxkwcBAIDyJOUqhv1I/Shvc0HuE
	 kPrTtWnYMlijLtgy75mvOdBvE26xWTiJEVjpUBswTrM+7d+Cv8WsR4blmxhJFiClJH
	 LJ0kZYw0ZLGh8oqvBdZajuBJFEgICzbv2+BG9X38=
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
Subject: [PATCH 5.15 000/151] 5.15.194-rc1 review
Date: Tue, 30 Sep 2025 16:45:30 +0200
Message-ID: <20250930143827.587035735@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.194-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.194 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.194-rc1

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Justin Bronder <jsbronder@cold-front.org>
    i40e: increase max descriptors for XL710

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in config queues msg

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix validation of VF state in get resources

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

David Hildenbrand <david@redhat.com>
    mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't leave consecutive consumed OOB skbs.

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

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: suppress -EINVAL errors for bridge FDB entries added to the CPU port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()

Martin Schiller <ms@dev.tdt.de>
    net: dsa: lantiq_gswip: do also enable or disable cpu port

Ido Schimmel <idosch@nvidia.com>
    selftests: fib_nexthops: Fix creation of non-FDB nexthops

Ido Schimmel <idosch@nvidia.com>
    nexthop: Forbid FDB status change while nexthop is in a group

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: correct offset handling for IPv6 destination address

Petr Malat <oss@malat.biz>
    ethernet: rvu-af: Remove slash from the driver name

Stéphane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix shift-out-of-bounds issue

Vincent Mailhol <mailhol@kernel.org>
    can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: sun4i_can: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: hi311x: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: sort the includes by alphabetic order

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: advertise timestamping capabilities and add ioctl support

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: add generic function can_eth_ioctl_hwts()

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: add generic function can_ethtool_op_get_ts_info_hwts()

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: bittiming: replace CAN units with the generic ones from linux/units.h

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min

Leon Hwang <leon.hwang@linux.dev>
    bpf: Reject bpf_timer for PREEMPT_RT

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

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Philipp Zabel <p.zabel@pengutronix.de>
    net: rfkill: gpio: add DT support

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: set remote_deny_join_id0 on SYN recv

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Rob Herring <robh@kernel.org>
    phy: Use device_get_match_data()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: broadcom: ns-usb3: fix Wvoid-pointer-to-enum-cast warning

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Jakob Koschel <jakobkoschel@gmail.com>
    usb: gadget: dummy_hcd: remove usage of list iterator past the loop body

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in flow control levels init

Qi Xi <xiqi2@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path

Loic Poulain <loic.poulain@oss.qualcomm.com>
    drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ

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

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the incorrect inode ref size check

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

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix buffer pool seeding for control traffic

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

Ravi Gunasekaran <r-gunasekaran@ti.com>
    net: hsr: hsr_slave: Fix the promiscuous mode in offload mode

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a memory leak in fence cleanup when unloading

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Deal with zero e_shentsize

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: tegra: xusb: fix device and OF node leak at probe

Stephan Gerhold <stephan.gerhold@linaro.org>
    dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hrtimers: Unconditionally update target CPU base after offline timer migration

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Rename __hrtimer_hres_active() to hrtimer_hres_active()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Remove unused function

Andreas Kemnade <akemnade@kernel.org>
    regulator: sy7636a: fix lifecycle of power good gpio

Anders Roxell <anders.roxell@linaro.org>
    dmaengine: ti: edma: Fix memory allocation size for queue_priority_map

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use rtnl lock when iterating over ports

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add VLAN CTAG filter support

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add support for MC filtering at the slave device

Ravi Gunasekaran <r-gunasekaran@ti.com>
    net: hsr: Disable promiscuous mode in offload mode

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks

Fabian Vogt <fvogt@suse.de>
    tty: hvc_console: Call hvc_kick in hvc_write unconditionally

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Jack Wang <jinpu.wang@ionos.com>
    mtd: rawnand: stm32_fmc2: Fix dma_map_sg error check

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Alexander Dahl <ada@thorsis.com>
    mtd: nand: raw: atmel: Fix comment in timings preparation

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix invalid accesses to ceph_connection_v1_info

Miklos Szeredi <mszeredi@redhat.com>
    fuse: prevent overflow in copy_file_range return value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check if copy_file_range() returns larger than requested size

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: fix ECC overwrite

Mark Tinguely <mark.tinguely@oracle.com>
    ocfs2: fix recursive semaphore deadlock in fiemap call

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN

Nathan Chancellor <nathan@kernel.org>
    compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Salah Triki <salah.triki@gmail.com>
    EDAC/altera: Delete an inappropriate dma_free_coherent() call

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Set synthesized TSA CPUID flags

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    KVM: SVM: Return TSA_SQ_NO and TSA_L1_NO bits in __do_cpuid_func()

Kim Phillips <kim.phillips@amd.com>
    KVM: x86: Move open-coded CPUID leaf 0x80000021 EAX bit propagation code

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/flexfiles: Fix layout merge mirror check.

Luo Gengkun <luogengkun@huaweicloud.com>
    tracing: Fix tracing_marker may trigger page fault during preempt_disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

David Hildenbrand <david@redhat.com>
    mm/rmap: reject hugetlb folios in folio_make_device_exclusive()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not add length to print format in synthetic events

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Fix link frequency validation

Arnd Bergmann <arnd@arndb.de>
    media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning

Harry Yoo <harry.yoo@oracle.com>
    mm: introduce and use {pgd,p4d}_populate_kernel()

Yeoreum Yun <yeoreum.yun@arm.com>
    kunit: kasan_test: disable fortify string checker on kasan_strings() test

Eric Sandeen <sandeen@redhat.com>
    xfs: short circuit xfs_growfs_data_private() if delta is zero

Brett A C Sheffield <bacs@librecast.net>
    Revert "fbdev: Disable sysfb device registration when removing conflicting FBs"


-------------

Diffstat:

 .../bindings/serial/brcm,bcm7271-uart.yaml         |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/um/drivers/virtio_uml.c                       |   6 +-
 arch/x86/kvm/cpuid.c                               |  31 ++-
 arch/x86/kvm/svm/svm.c                             |   3 +-
 crypto/af_alg.c                                    |   7 +
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 -
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   6 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 +
 drivers/media/i2c/imx214.c                         |  27 +-
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |   6 +-
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  18 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  48 ++--
 drivers/net/can/dev/bittiming.c                    |  15 +-
 drivers/net/can/dev/dev.c                          |  50 ++++
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/etas_es58x/es581_4.c           |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |  16 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   8 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |  16 +-
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/can/xilinx_can.c                       |  16 +-
 drivers/net/dsa/lantiq_gswip.c                     |  41 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  45 +++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/natsemi/ns83820.c             |  13 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   7 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   9 +-
 drivers/phy/marvell/phy-berlin-usb.c               |   7 +-
 drivers/phy/ralink/phy-ralink-usb.c                |  10 +-
 drivers/phy/rockchip/phy-rockchip-pcie.c           |  11 +-
 drivers/phy/rockchip/phy-rockchip-usb.c            |  10 +-
 drivers/phy/tegra/xusb-tegra210.c                  |   6 +-
 drivers/phy/ti/phy-omap-control.c                  |   9 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  24 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |  27 +-
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 drivers/regulator/sy7636a-regulator.c              |   7 +-
 drivers/soc/qcom/mdt_loader.c                      |  12 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  25 +-
 drivers/usb/host/xhci-dbgcap.c                     |  94 +++++--
 drivers/usb/serial/option.c                        |  17 ++
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 drivers/video/fbdev/core/fbmem.c                   |  12 -
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/fuse/file.c                                     |   5 +-
 fs/hugetlbfs/inode.c                               |  14 +-
 fs/ksmbd/transport_rdma.c                          |  17 +-
 fs/nfs/client.c                                    |   2 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/ocfs2/extent_map.c                              |  10 +-
 fs/xfs/xfs_fsops.c                                 |   4 +
 include/crypto/if_alg.h                            |  10 +-
 include/linux/can/bittiming.h                      |  69 +++--
 include/linux/can/dev.h                            |   8 +
 include/linux/compiler-clang.h                     |  31 ++-
 include/linux/interrupt.h                          |  53 +++-
 include/linux/pgalloc.h                            |  29 +++
 include/linux/pgtable.h                            |  13 +-
 include/net/sock.h                                 |  40 ++-
 include/uapi/linux/can/netlink.h                   |   2 +
 kernel/bpf/verifier.c                              |   4 +
 kernel/cgroup/cgroup.c                             |  43 +++-
 kernel/irq/manage.c                                |   8 +-
 kernel/time/hrtimer.c                              |  50 +---
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_dynevent.c                      |   4 +
 kernel/trace/trace_events_synth.c                  |   2 -
 lib/test_kasan.c                                   |   1 +
 mm/kasan/init.c                                    |  12 +-
 mm/khugepaged.c                                    |   2 +-
 mm/memory-failure.c                                |   7 +-
 mm/migrate.c                                       |  12 +-
 mm/rmap.c                                          |   2 +-
 mm/sparse-vmemmap.c                                |   6 +-
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/ceph/messenger.c                               |   7 +-
 net/core/sock.c                                    |   5 +
 net/hsr/hsr_device.c                               | 163 +++++++++++-
 net/hsr/hsr_main.c                                 |   4 +-
 net/hsr/hsr_main.h                                 |   4 +
 net/hsr/hsr_slave.c                                |  18 +-
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/nexthop.c                                 |   7 +
 net/ipv4/tcp.c                                     |   5 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mptcp/protocol.c                               |  15 ++
 net/mptcp/sockopt.c                                |  11 +-
 net/mptcp/subflow.c                                |   3 +
 net/rds/ib_frmr.c                                  |  20 +-
 net/rfkill/rfkill-gpio.c                           |  22 +-
 net/unix/af_unix.c                                 |  15 +-
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/soc/codecs/wm8940.c                          |   2 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 sound/usb/mixer_quirks.c                           | 285 ++++++++++++++++++++-
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 132 files changed, 1469 insertions(+), 537 deletions(-)


