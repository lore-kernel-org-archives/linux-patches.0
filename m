Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646B2D595B;
	Thu, 15 Jan 2026 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498859; cv=none; b=CbCDWLHkiS7LGf4ITqJvKDwCOsaB51sKdLyD+5ev6RcvThWmKPMC87arSznnojF/cfxzIxKDqQjlvt1YYp68e1drXghJ/i9VOM+GRwlR+OSy9JrFhLmlrss5PD0U/Qj/2Wgw4IVPKvMIbuaO5gken65lcQlJnb8/ae7q0YHFbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498859; c=relaxed/simple;
	bh=XrXvacDROq+4KPbbjlSqlynRLG7MhY7DQ59KNbIAsD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C4RS1FjBFHo/5QhTuNmlL6h+BFK94+zW5uxvlmyXK8lKbHH5UTI69ZvY2sofgJirmHnBf9VjT39pqEn8LM/x09fiOPYTA+CBZKMKm6cC5RWviRNhmLBTGo6bG5AkjTUSJ9n85VuZ6mNj1Oy7QGuaUI8GeaUAPILxOA0WS3NgfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaozZRSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaozZRSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C347C116D0;
	Thu, 15 Jan 2026 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498858;
	bh=XrXvacDROq+4KPbbjlSqlynRLG7MhY7DQ59KNbIAsD4=;
	h=From:To:Cc:Subject:Date:From;
	b=PaozZRSaPupDMQ0f6ervEQsdn5kGG1xOWeHve7Gvy/w2fqv3f6+tKRu1gZNcbfLRi
	 vSRt2+XWfrtobgpZfXaJ5a86nI4PrlQ8y3yL85PJYdI99igBvScjZquxCstf0jXB5g
	 OZbxV6nlWS47mWwooahhaLs9DZZG14L5pGaYJBMQ=
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
Subject: [PATCH 5.10 000/451] 5.10.248-rc1 review
Date: Thu, 15 Jan 2026 17:43:21 +0100
Message-ID: <20260115164230.864985076@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.248-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.248-rc1
X-KernelTest-Deadline: 2026-01-17T16:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.248 release.
There are 451 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.248-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.248-rc1

Michal Rábek <mrabek@redhat.com>
    scsi: sg: Fix occasional bogus elapsed time that exceeds timeout

Alexander Stein <alexander.stein@ew.tq-group.com>
    ASoC: fsl_sai: Add missing registers to cache default

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_session_activate() fail if device is no longer registered

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix sscanf() error return value handling

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix race condition in register_control_type()

NeilBrown <neil@brown.name>
    nfsd: provide locking for v4_end_grace

Laibin Qiu <qiulaibin@huawei.com>
    blk-throttle: Set BIO_THROTTLED when bio has been throttled

Eric Dumazet <edumazet@google.com>
    arp: do not assume dev_hard_header() does not change skb->head

Petko Manolov <petkan@nucleusys.com>
    net: usb: pegasus: fix memory leak in update_eth_regs_async()

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix NULL deref when deactivating inactive aggregate in qfq_reset

René Rebe <rene@exactco.de>
    HID: quirks: work around VID/PID conflict for appledisplay

Srijit Bose <srijit.bose@broadcom.com>
    bnxt_en: Fix potential data corruption with HW GRO/LRO

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: move and rename reset helpers

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Don't print error message due to invalid module

Di Zhu <zhud@hygon.cn>
    netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates

Weiming Shi <bestswngs@gmail.com>
    net: sock: fix hardened usercopy panic in sock_recv_errqueue

yuan.gao <yuan.gao@ucloud.cn>
    inet: ping: Fix icmp out counting

Alexandre Knecht <knecht.alexandre@gmail.com>
    bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: update last_gc only when GC has been performed

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_synproxy: avoid possible data-race on update operation

Ian Ray <ian.ray@gehealthcare.com>
    ARM: dts: imx6q-ba16: fix RTC interrupt level

Xingui Yang <yangxingui@huawei.com>
    scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"

Wen Xiong <wenxiong@linux.ibm.com>
    scsi: ipr: Enable/disable IRQD_NO_BALANCING during reset

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up the automount fs_context to use the correct cred

Scott Mayhew <smayhew@redhat.com>
    NFSv4: ensure the open stateid seqid doesn't go backwards

Sam James <sam@gentoo.org>
    alpha: don't reference obsolete termio struct for TC* constants

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself

Kuniyuki Iwashima <kuniyu@google.com>
    tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().

Tariq Toukan <tariqt@nvidia.com>
    net: netdevice: Add operation ndo_sk_get_lower_dev

Sharath Chandra Vurukala <quic_sharathv@quicinc.com>
    net: Add locking to protect skb->dev access in ip_output

Ye Bin <yebin10@huawei.com>
    ext4: fix out-of-bound read in ext4_xattr_inode_dec_ref_all()

Ye Bin <yebin10@huawei.com>
    ext4: introduce ITAIL helper

Ilya Dryomov <idryomov@gmail.com>
    libceph: make calc_target() set t->paused, not just clear it

Tuo Li <islituo@gmail.com>
    libceph: make free_choose_arg_map() resilient to partial allocation

Ilya Dryomov <idryomov@gmail.com>
    libceph: replace overzealous BUG_ON in osdmap_apply_incremental()

Eric Dumazet <edumazet@google.com>
    wifi: avoid kernel-infoleak from struct iw_point

Miaoqian Lin <linmq006@gmail.com>
    drm/pl111: Fix error handling in pl111_amba_probe

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: aes: Fix missing MMU protection for AES S-box

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add nova lake point S DID

Thomas Fourier <fourier.thomas@gmail.com>
    net: 3com: 3c59x: fix possible null dereference in vortex_probe1()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: Fix dma_free_coherent() size

Johan Hovold <johan@kernel.org>
    usb: gadget: lpc32xx_udc: fix clock imbalance in error path

Su Hui <suhui@nfschina.com>
    net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()

Sanjeev Yadav <sanjeev.y@mediatek.com>
    scsi: core: ufs: Fix a hang in the error handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "iommu/amd: Skip enabling command/event buffers for kdump"

Sean Nyekjaer <sean@geanix.com>
    pwm: stm32: Always program polarity

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Enable chip before any communication

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    leds: lp50xx: Remove duplicated error reporting in .remove()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: lp50xx: Get rid of redundant check in lp50xx_enable_disable()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: lp50xx: Reduce level of dereferences

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    bus: fsl-mc-bus: fix KASAN use-after-free in fsl_mc_bus_remove()

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not clean up repair bio if submit fails

Kees Cook <keescook@chromium.org>
    ovl: Use "buf" flexible array for memcpy() destination

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Move pool freeing

Peter Xu <peterx@redhat.com>
    mm/mprotect: use long for page accountings and retval

Chuck Lever <chuck.lever@oracle.com>
    NFSD: NFSv4 file creation neglects setting ACL

Jouni Malinen <jouni.malinen@oss.qualcomm.com>
    wifi: mac80211: Discard Beacon frames to non-broadcast address

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gma500: Remove unused helper psb_fbdev_fb_setcolreg()

NeilBrown <neil@brown.name>
    lockd: fix vfs_test_lock() calls

Marek Szyprowski <m.szyprowski@samsung.com>
    media: samsung: exynos4-is: fix potential ABBA deadlock on init

Johan Hovold <johan@kernel.org>
    media: vpif_capture: fix section mismatch

Haoxiang Li <haoxiang_li2024@163.com>
    media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: we cannot have isolated pages in the balloon list

Miaohe Lin <linmiaohe@huawei.com>
    mm/balloon_compaction: make balloon page compaction callbacks static

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix clk prepare imbalance on probe failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: stm32: sai: Use the devm_clk_get_optional() helper

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: stm: Use dev_err_probe() helper

Miaoqian Lin <linmq006@gmail.com>
    media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Fix disabling L0s capability

Donet Tom <donettom@linux.ibm.com>
    powerpc/64s/slb: Fix SLB multihit issue during SLB preload

Johan Hovold <johan@kernel.org>
    iommu/qcom: fix device leak on of_xlate()

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32

Shivani Agarwal <shivani.agarwal@broadcom.com>
    crypto: af_alg - zero initialize memory allocated via sock_kmalloc

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use local variable to avoid TOCTOU

Guenter Roeck <linux@roeck-us.net>
    hwmon: replace snprintf in show functions with sysfs_emit

Joshua Rogers <linux@joshua.hu>
    SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap

Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
    tpm: Cap the number of PCR banks

Ye Bin <yebin10@huawei.com>
    jbd2: fix the inconsistency between checksum and data in memory for journal sb

Johan Hovold <johan@kernel.org>
    usb: ohci-nxp: fix device leak on probe failure

Zhang Zekun <zhangzekun11@huawei.com>
    usb: ohci-nxp: Use helper function devm_clk_get_enabled()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ignore unknown endpoint flags

Udipto Goswami <udipto.goswami@oss.qualcomm.com>
    usb: dwc3: keep susphy enabled during exit to avoid controller faults

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating zero-sized extent in extent cache

Chao Yu <chao@kernel.org>
    f2fs: fix to propagate error from f2fs_enable_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()

Chao Yu <chao@kernel.org>
    f2fs: use global inline_xattr_slab instead of per-sb slab cache

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a memory leak in xfs_buf_item_init()

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't rewrite ret from inode_permission

Fedor Pchelkin <pchelkin@ispras.ru>
    ext4: fix string copying in parse_apply_sb_mount_options()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Fix integer overflow in sample size validation

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Clear substream pointers on close

Kees Cook <keescook@chromium.org>
    net/mlx5e: Avoid field-overflowing memcpy()

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: udc: fix use-after-free in usb_gadget_state_work

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbgtty: fix device unregister

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Harden s32ton() against conversion to 0 bits

Shigeru Yoshida <syoshida@redhat.com>
    ipv4: Fix uninit-value access in __ip_make_skb()

Shigeru Yoshida <syoshida@redhat.com>
    ipv6: Fix potential uninit-value access in __ip6_make_skb()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Apply the link chain quirk on NEC isoc endpoints

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: move link chain bit quirk checks into one helper function.

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a null-ptr access in the cursor snooper

Peilin Ye <yepeilin.cs@gmail.com>
    fbcon: Avoid using FNTCHARCNT() and hard-coded built-in font charcount

Peilin Ye <yepeilin.cs@gmail.com>
    parisc/sticore: Avoid hard-coding built-in font charcount

Peilin Ye <yepeilin.cs@gmail.com>
    Fonts: Add charcount field to font_desc

Peilin Ye <yepeilin.cs@gmail.com>
    console: Delete dummy con_font_set() and con_font_default() callback implementations

Peilin Ye <yepeilin.cs@gmail.com>
    console: Delete unused con_font_copy() callback implementations

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    virtio_console: fix order of fields cols and rows

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/core: Fix "KASAN: slab-use-after-free Read in ib_register_device" problem

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dispnv50: Don't call drm_atomic_get_crtc_state() in prepare_fb

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()

Deepanshu Kartikey <kartikey406@gmail.com>
    net: nfc: fix deadlock between nfc_unregister_device and rfkill_fop_write

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: fix incorrect command used to write single register

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    nfsd: Drop the client reference in client_states_open()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    fjes: Add missing iounmap in fjes_hw_init()

Guangshuo Li <lgs201920130244@gmail.com>
    e1000: fix OOB in e1000_tbi_should_accept()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cm: Fix leaking the multicast GID table reference

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Check for the presence of LS_NLA_TYPE_DGID correctly

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: fix idr_alloc() returning an ID out of range

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: adv7842: Remove redundant cancel_delayed_work in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: TDA1997x: Remove redundant cancel_delayed_work in probe

Ivan Abramov <i.abramov@mt-integration.ru>
    media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()

Haotian Zhang <vulab@iscas.ac.cn>
    media: cec: Fix debugfs leak on bus_register() failure

René Rebe <rene@exactco.de>
    fbdev: tcx.c fix mem_map to correct smem_start offset

Thorsten Blum <thorsten.blum@linux.dev>
    fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing

Rene Rebe <rene@exactco.de>
    fbdev: gbefb: fix to use physical address instead of dma address

Uladzislau Rezki (Sony) <urezki@gmail.com>
    dm-ebs: Mark full buffer dirty even on partial write

Ivan Abramov <i.abramov@mt-integration.ru>
    media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()

Sven Schnelle <svens@stackframe.org>
    parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()

Sven Schnelle <svens@stackframe.org>
    parisc: entry.S: fix space adjustment on interruption for 64-bit userspace

Haotian Zhang <vulab@iscas.ac.cn>
    media: rc: st_rc: Fix reset control resource leak

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max77620: Fix potential IRQ chip conflict when probing two devices

Johan Hovold <johan@kernel.org>
    mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Allow LED 0 to be added to module bank

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Reinstate clearing state_saved in legacy and !PM codepaths

Hans de Goede <johannes.goede@oss.qualcomm.com>
    HID: logitech-dj: Remove duplicate error logging

Johan Hovold <johan@kernel.org>
    iommu/sun50i: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/omap: fix device leaks on probe_device()

Johan Hovold <johan@kernel.org>
    iommu/mediatek: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/mediatek-v1: fix device leak on probe_device()

Johan Hovold <johan@kernel.org>
    iommu/ipmmu-vmsa: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/exynos: fix device leak on of_xlate()

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6adm: the the copp device only during last instance

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: perform correct state check before closing

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix device leak on probe

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: traceonoff_triggers: strip off names

Thomas Fourier <fourier.thomas@gmail.com>
    RDMA/bnxt_re: fix dma_free_coherent() pointer

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix to use correct page size for PDE table

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()

Jang Ingyu <ingyujang25@korea.ac.kr>
    RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Remove possible negative shift

Pwnverse <stanksal@purdue.edu>
    net: rose: fix invalid array index in rose_kill_by_device()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix reference count leak when using error routes with nexthop objects

Will Rosenberg <whrosenb@asu.edu>
    ipv6: BUG() in pskb_expand_head() as part of calipso_skbuff_setattr()

Anshumali Gaur <agaur@marvell.com>
    octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"

Bagas Sanjaya <bagasdotme@gmail.com>
    net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: skip multicast entries for fdb_dump()

Thomas Fourier <fourier.thomas@gmail.com>
    firewire: nosy: Fix dma_free_coherent() size

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    firewire: nosy: switch from 'pci_' to 'dma_' API

Andrew Morton <akpm@linux-foundation.org>
    genalloc.h: fix htmldocs warning

Deepakkumar Karn <dkarn@redhat.com>
    net: usb: rtl8150: fix memory leak on usb_submit_urb() failure

Jiri Pirko <jiri@nvidia.com>
    team: fix check for port enabled in team_queue_override_port_prio_changed()

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic

Thomas Fourier <fourier.thomas@gmail.com>
    platform/x86: msi-laptop: add missing sysfs_remove_group()

Eric Dumazet <edumazet@google.com>
    ip6_gre: make ip6gre_header() robust

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid needlessly taking the RTNL on vport destroy

Jacky Chou <jacky_chou@aspeedtech.com>
    net: mdio: aspeed: add dummy read to avoid read-after-write issue

Potin Lai <potin.lai@quantatw.com>
    net: mdio: aspeed: move reg accessing part into separate functions

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Do not use req->iv after crypto_aead_encrypt

Kohei Enju <enjuk@amazon.com>
    iavf: fix off-by-one issues in iavf_config_rss_reg()

Przemyslaw Korba <przemyslaw.korba@intel.com>
    i40e: fix scheduling in set_rx_mode

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83791d) Convert macros to functions to avoid TOCTOU

Ma Ke <make24@iscas.ac.cn>
    i2c: amd-mp2: fix reference leak in MP2 PCI device

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: fix rpmsg device leak

Johan Hovold <johan@kernel.org>
    soc: amlogic: canvas: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: ocmem: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    amba: tegra-ahb: Fix device leak on SMMU enable

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()

Prithvi Tambewagh <activprithvi@gmail.com>
    io_uring: fix filename leak in __io_openat_prep()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfsd: Mark variable __maybe_unused to avoid W=1 build break

Amir Goldstein <amir73il@gmail.com>
    fsnotify: do not generate ACCESS/MODIFY events on child for special files

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not clear needs_force_resume with enabled runtime PM

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not register unsupported perf events

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()

Sean Christopherson <seanjc@google.com>
    KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0

Ilya Dryomov <idryomov@gmail.com>
    libceph: make decode_pool() more resilient against corrupted osdmaps

Helge Deller <deller@gmx.de>
    parisc: Do not reprogram affinitiy on ASP chip

Zhichi Lin <zhichi.lin@vivo.com>
    scs: fix a wrong parameter in __scs_magic

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver

Prithvi Tambewagh <activprithvi@gmail.com>
    ocfs2: fix kernel BUG in ocfs2_find_victim_chain

Jeongjun Park <aha310510@gmail.com>
    media: vidtv: initialize local pointers upon transfer of memory ownership

Alison Schofield <alison.schofield@intel.com>
    tools/testing/nvdimm: Use per-DIMM device handle

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_recover_fsync_data()

Deepanshu Kartikey <kartikey406@gmail.com>
    f2fs: invalidate dentry cache on failed whiteout creation

Andrey Vatoropin <a.vatoropin@crpt.ru>
    scsi: target: Reset t_task_cdb pointer in error case

Dai Ngo <dai.ngo@oracle.com>
    NFSD: use correct reservation type in nfsd4_scsi_fence_client

Junrui Luo <moonafterrain@outlook.com>
    scsi: aic94xx: fix use-after-free in device removal path

Tony Battersby <tonyb@cybernetics.com>
    scsi: Revert "scsi: qla2xxx: Perform lockless command completion in abort path"

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: nforce2: fix reference count leak in nforce2

Ma Ke <make24@iscas.ac.cn>
    intel_th: Fix error handling in intel_th_output_open

Tianchu Chen <flynnnchen@tencent.com>
    char: applicom: fix NULL pointer dereference in ac_ioctl

Haoxiang Li <haoxiang_li2024@163.com>
    usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe

Duoming Zhou <duoming@zju.edu.cn>
    usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal

Ma Ke <make24@iscas.ac.cn>
    USB: lpc32xx_udc: Fix error handling in probe

Johan Hovold <johan@kernel.org>
    phy: broadcom: bcm63xx-usbh: fix section mismatches

Colin Ian King <colin.i.king@gmail.com>
    media: pvrusb2: Fix incorrect variable used in trace message

Jeongjun Park <aha310510@gmail.com>
    media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: Maintain minimal modifications to the bcdDevice range.

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-mem2mem: Fix outdated documentation

Byungchul Park <byungchul@sk.com>
    jbd2: use a weaker annotation in journal handling

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix incorrect group number assertion in mb_check_buddy

Karina Yankevich <k.yankevich@omp.ru>
    ext4: xattr: fix null pointer deref in ext4_raw_inode()

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix uninitialized var in config-bisect.pl

Rene Rebe <rene@exactco.de>
    floppy: fix for PAGE_SIZE != 4KB

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: improve RCU read sections around vhost_vsock_get()

Dan Carpenter <dan.carpenter@linaro.org>
    block: rnbd-clt: Fix signedness bug in init_dev()

Daniel Wagner <wagi@kernel.org>
    nvme-fc: don't hold rport lock when putting ctrl

Wenhua Lin <Wenhua.Lin@unisoc.com>
    serial: sprd: Return -EPROBE_DEFER when uart clock is not ready

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: xhci: limit run_graceperiod for only usb 3.0 devices

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: typec: ucsi: Handle incorrect num_connectors capability

Lizhi Xu <lizhi.xu@windriver.com>
    usbip: Fix locking bug in RT-enabled kernels

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix remount failure in different process environments

Encrow Thorne <jyc0019@gmail.com>
    reset: fix BIT macro reference

Li Qiang <liqiang01@kylinos.cn>
    via_wdt: fix critical boot hang due to unnamed resource allocation

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Use reinit_completion on mbx_intr_comp

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive

Ben Collins <bcollins@kernel.org>
    powerpc/addnote: Fix overflow on 32-bit builds

Josua Mayer <josua@solid-run.com>
    clk: mvebu: cp110 add CLK_IGNORE_UNUSED to pcie_x10, pcie_x11 & pcie_x4

Matthias Schiffer <matthias.schiffer@tq-group.com>
    ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Init workqueue before request mbox channel

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix __scan_channels() failing to rescan channels

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix the race between __scan_channels() and deliver_response()

Shipei Qu <qu@darknavy.com>
    ALSA: usb-mixer: us16x08: validate meter packet indices

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: vxpocket: Fix resource leak in vxpocket_probe error path

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    net/hsr: fix NULL pointer dereference in prp_get_untagged_frame()

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl-cpm: Check length parity before switching to 16 bit mode

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: CPPC: Fix missing PCC check for guaranteed_perf

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table

Junjie Cao <junjie.cao@intel.com>
    Input: ti_am335x_tsc - fix off-by-one error in wire_order validation

Ping Cheng <pinglinux@gmail.com>
    HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen

Thomas Fourier <fourier.thomas@gmail.com>
    block: rnbd-clt: Fix leaked ID in init_dev()

Guoqing Jiang <guoqing.jiang@linux.dev>
    block/rnbd-clt: fix wrong max ID in ida_alloc_max

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    block/rnbd: Remove a useless mutex

Haoxiang Li <haoxiang_li2024@163.com>
    MIPS: Fix a reference leak bug in ip22_check_gio()

Junrui Luo <moonafterrain@outlook.com>
    hwmon: (ibmpex) fix use-after-free in high/low store

Jian Shen <shenjian15@huawei.com>
    net: hns3: add VLAN id validation before using

Jian Shen <shenjian15@huawei.com>
    net: hns3: using the num_tqps in the vf driver to apply for resources

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Handle escaped percent properly

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Validate format string parameters

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Add support for unrecognized string

Gal Pressman <gal@nvidia.com>
    ethtool: Avoid overflowing userspace buffer on stats query

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats

Tom Rix <trix@redhat.com>
    ethtool: use phydev variable

Dan Carpenter <dan.carpenter@linaro.org>
    nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()

Victor Nogueira <victor@mojatatu.com>
    net/sched: ets: Remove drr class from the active list if it changes to strict

Junrui Luo <moonafterrain@outlook.com>
    caif: fix integer underflow in cffrml_receive()

Slavin Liu <slavin452@gmail.com>
    ipvs: fix ipv4 null-ptr-deref in route error path

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: fix leaked ct in error paths

Alexey Simakov <bigalex934@gmail.com>
    broadcom: b44: prevent uninitialized value usage

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix middle attribute validation in push_nsh() action

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Fix use-after-free when updating multicast route stats

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix neighbour use-after-free

Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
    ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: Always remove class from active list before deleting in ets_qdisc_change

Wang Liang <wangliang74@huawei.com>
    netrom: Fix memory leak in nr_sendmsg()

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: btusb: Add new VID/PID 13d3/3533 for RTL8821CE

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: always update btrfs_scrub_progress::last_physical

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/073

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: Verify inode mode when loading from disk

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfsplus: fix missing hfs_bnode_get() in __hfs_bnode_create

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/070

Song Liu <song@kernel.org>
    livepatch: Match old_sympos 0 and 1 in klp_find_func()

Shuhao Fu <sfual@cse.ust.hk>
    cpufreq: s5pv210: fix refcount leak

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    ACPICA: Avoid walking the Namespace if start_node is NULL

Peter Zijlstra <peterz@infradead.org>
    x86/ptrace: Always inline trivial accessors

Deepanshu Kartikey <kartikey406@gmail.com>
    btrfs: fix memory leak of fs_devices in degraded seed device path

Ondrej Mosnacek <omosnace@redhat.com>
    bpf, arm64: Do not audit capability check in do_jit()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails

Jamie Iles <quic_jiles@quicinc.com>
    i3c: fix uninitialized variable use in i2c setup

Nicklas Bo Jensen <njensen@akamai.com>
    netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around

Sun Ke <sunke32@huawei.com>
    NFS: Fix missing unlock in nfs_unlink()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: dice: fix buffer overflow in detect_stream_formats()

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    usb: phy: Initialize struct usb_phy list_head

Haotien Hsu <haotienh@nvidia.com>
    usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix memory leak in ocfs2_merge_rec_left()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: align ARM CPER type with UEFI 2.9A/2.10 specs

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: Adjust infopfx size to accept an extra space

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: Add a new helper function to print bitmasks

Haotian Zhang <vulab@iscas.ac.cn>
    dm log-writes: Add missing set_freezable() for freezable kthread

Alexey Simakov <bigalex934@gmail.com>
    dm-raid: fix possible NULL dereference with undefined raid type

Liyuan Pang <pangliyuan1@huawei.com>
    ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()

Andres J Rosa <andyrosa@gmail.com>
    ALSA: uapi: Fix typo in asound.h comment

Dave Kleikamp <dave.kleikamp@oracle.com>
    dma/pool: eliminate alloc_pages warning in atomic_pool_expand

shechenglong <shechenglong@xfusion.com>
    block: fix comment for op_is_zone_mgmt() to include RESET_ALL

Cong Zhang <cong.zhang@oss.qualcomm.com>
    blk-mq: Abort suspend when wakeup events are pending

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Disable regulator when error happens

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Disable regulator when error happens

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()

Anton Khirnov <anton@khirnov.net>
    platform/x86: asus-wmi: use brightness_set_blocking() for kbd led

Armin Wolf <W_Armin@gmx.de>
    fs/nls: Fix inconsistency between utf8_to_utf32() and utf32_to_utf8()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags

Ondrej Mosnacek <omosnace@redhat.com>
    fs_context: drop the unused lsm_flags member

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: ignore SB_RDONLY when mounting nfs"

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: clear SB_RDONLY before getting superblock"

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: ignore SB_RDONLY when remounting nfs"

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid

Armin Wolf <W_Armin@gmx.de>
    fs/nls: Fix utf16 to utf8 conversion

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid changing nlink when file removes and attribute updates race

NeilBrown <neilb@suse.de>
    NFS: don't unhash dentry during unlink/rename

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Label the dentry with a verifier in nfs_rmdir() and nfs_unlink()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix open coded versions of nfs_set_cache_invalid()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Clean up function nfs_mark_dir_for_revalidate()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: single: Fix incorrect type for error return variable

Matthijs Kooijman <matthijs@stdin.nl>
    pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix split kallsyms DSO counting

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_cake: Fix incorrect qlen reduction in cake_drop

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: lpddr_cmds: fix signed shifts in lpddr_cmds

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_connlimit: update the count if add was skipped

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: rework API to use sk_buff directly

William Tu <u9012063@gmail.com>
    netfilter: nf_conncount: reduce unnecessary GC

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_connlimit: move stateful fields out of expression data

sparkhuang <huangshaobo3@xiaomi.com>
    regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix virtqueue_set_affinity() docs

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unused return value of __mb_check_buddy

René Rebe <rene@exactco.de>
    ACPI: processor_core: fix map_x2apic_id for amd-pstate on am4

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amd/display: Fix logical vs bitwise bug in get_embedded_panel_info_v2_1()

Stephan Gerhold <stephan.gerhold@linaro.org>
    iommu/arm-smmu-qcom: Enable use of all SMR groups when running bare-metal

Randy Dunlap <rdunlap@infradead.org>
    backlight: lp855x: Fix lp855x.h kernel-doc warnings

Luca Ceresoli <luca.ceresoli@bootlin.com>
    backlight: led-bl: Add devlink to supplier LEDs

Mans Rullgard <mans@mansr.com>
    backlight: led_bl: Take led_access lock when required

Ria Thomas <ria.thomas@morsemicro.com>
    wifi: ieee80211: correct FILS status codes

Shawn Lin <shawn.lin@rock-chips.com>
    PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition

Jianglei Nie <niejianglei2021@163.com>
    staging: fbtft: core: fix potential memory leak in fbtft_probe_common()

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: ccree - Correctly handle return of sg_nents_for_len

Matt Bobrowski <mattbobrowski@google.com>
    selftests/bpf: Improve reliability of test_perf_branches_no_hw()

Gopi Krishna Menon <krishnagopi487@gmail.com>
    usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: fix hang during suspend if set as peripheral

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: fix hang during shutdown if set as peripheral

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: disable platform lowlevel hw resources during shutdown

Oliver Neukum <oneukum@suse.com>
    usb: chaoskey: fix locking for O_NONBLOCK

Zhao Yipeng <zhaoyipeng5@huawei.com>
    ima: Handle error code returned by ima_filter_rule_match()

Seungjin Bae <eeodqql09@gmail.com>
    wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6358-irq: Fix missing irq_domain_remove() in error path

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6397-irq: Fix missing irq_domain_remove() in error path

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: bcm2835: Make sure the channel is enabled after pwm_request()

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    pwm: bcm2835: Support apply function for atomic configuration

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD/blocklayout: Fix minlength check in proc_layoutget

Haotian Zhang <vulab@iscas.ac.cn>
    watchdog: wdat_wdt: Fix ACPI table leak in probe function

Liu Xinpeng <liuxp11@chinatelecom.cn>
    watchdog: wdat_wdt: Stop watchdog when uninstalling module

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix failure paths in send_signal test

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Exit ks_pcie_probe() for invalid mode

Haotian Zhang <vulab@iscas.ac.cn>
    leds: netxbig: Fix GPIO descriptor leak in error paths

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls

Haotian Zhang <vulab@iscas.ac.cn>
    ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    lib/vsprintf: Check pointer before dereferencing in time_and_date()

Haotian Zhang <vulab@iscas.ac.cn>
    clk: renesas: r9a06g032: Fix memory leak in error path

Herve Codina <herve.codina@bootlin.com>
    soc: renesas: r9a06g032-sysctrl: Handle h2mode setting based on USBF presence

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: renesas: r9a06g032: Export function to set dmamux

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config unlock in nbd_genl_connect

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()

Long Li <leo.lilong@huawei.com>
    macintosh/mac_hid: fix race condition in mac_hid_toggle_emumouse

Ma Ke <make24@iscas.ac.cn>
    RDMA/rtrs: server: Fix error handling in get_or_create_srv

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: stex: Fix reboot_notifier leak in probe error path

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config put in recv_work

Yu Kuai <yukuai3@huawei.com>
    nbd: partition nbd_read_stat() into nbd_read_reply() and nbd_handle_reply()

Yu Kuai <yukuai3@huawei.com>
    nbd: clean up return value checking of sock_xmit()

Gabor Juhos <j4g8y7@gmail.com>
    regulator: core: disable supply if enabling main regulator fails

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Correct large PEBS flag check

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the checking of quota files before moving extents

Eric Whitney <enwlinux@gmail.com>
    ext4: minor defrag code improvements

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: da9055: Fix missing regmap_del_irq_chip() in error path

Bart Van Assche <bvanassche@acm.org>
    scsi: target: Do not write NUL characters into ASCII configfs output

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    power: supply: apm_power: only unset own apm_get_power_status

Ivan Abramov <i.abramov@mt-integration.ru>
    power: supply: wm831x: Check wm831x_set_bits() return value

Frank Li <Frank.Li@nxp.com>
    i3c: fix refcount inconsistency in i3c_master_register

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: master: Inherit DMA masks and parameters from parent device

Jeremy Kerr <jk@codeconstruct.com.au>
    i3c: Allow OF-alias-based persistent bus numbering

Jamie Iles <quic_jiles@quicinc.com>
    i3c: support dynamically added i2c devices

Jamie Iles <quic_jiles@quicinc.com>
    i3c: remove i2c board info from i2c_dev_desc

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: stm32: fix hwspinlock resource leak in probe function

Tengda Wu <wutengda@huaweicloud.com>
    x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()

Alexander Potapenko <glider@google.com>
    x86: kmsan: don't instrument stack walking functions

Alexander Potapenko <glider@google.com>
    kmsan: introduce __no_sanitize_memory and __no_kmsan_checks

Kees Cook <keescook@chromium.org>
    compiler-gcc.h: Define __SANITIZE_ADDRESS__ under hwaddress sanitizer

Hui Su <sh_def@163.com>
    x86/dumpstack: Make show_trace_log_lvl() static

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: fix OF node leak in

Heiko Carstens <hca@linux.ibm.com>
    s390/ap: Don't leak debug feature files if AP instructions are not available

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: Fix fallback CPU detection

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: discard samples during filters settling time

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: introduce st_lsm6dsx_device_set_enable routine

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    inet: Avoid ehash lookup race in inet_ehash_insert()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()

Johan Hovold <johan@kernel.org>
    irqchip/qcom-irq-combiner: Fix section mismatch

Seungjin Bae <eeodqql09@gmail.com>
    USB: Fix descriptor count when handling invalid MBIM extended descriptor

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/vgem-fence: Fix potential deadlock on release

Guido Günther <agx@sigxcpu.org>
    drm/panel: visionox-rm69299: Don't clear all mode flags

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: unprivileged task can create labels

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: check device's attached status in compat ioctls

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: multiq3: sanitize config options in multiq3_attach()

Ian Abbott <abbotti@mev.co.uk>
    comedi: c6xdigio: Fix invalid PNP driver unregistration

Linus Torvalds <torvalds@linux-foundation.org>
    samples: work around glibc redefining some of our defines wrong

Jia Ston <ston.jia@outlook.com>
    platform/x86: huawei-wmi: add keys for HONOR models

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore backlight event

Praveen Talari <praveen.talari@oss.qualcomm.com>
    pinctrl: qcom: msm: Fix deadlock in pinmux configuration

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bfs: Reconstruct file type when loading from disk

Robin Gong <yibin.gong@nxp.com>
    spi: imx: keep dma request disabled before dma transfer setup

Alvaro Gamez Machado <alvaro.gamez@hazent.com>
    spi: xilinx: increase number of retries before declaring stall

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

Alexey Nepomnyashih <sdl@nppct.ru>
    ext4: add i_data_sem protection in ext4_destroy_inline_data_nolock()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    locking/spinlock/debug: Fix data-race in do_raw_write_lock

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

 Documentation/filesystems/mount_api.rst            |   1 -
 Documentation/process/2.Process.rst                |   6 +-
 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/ioctls.h               |   8 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/imx6q-ba16.dtsi                  |   2 +-
 arch/arm/boot/dts/sama5d2.dtsi                     |  10 +-
 arch/arm/include/asm/word-at-a-time.h              |  10 +-
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/mips/sgi-ip22/ip22-gio.c                      |   3 +-
 arch/parisc/kernel/asm-offsets.c                   |   2 +
 arch/parisc/kernel/entry.S                         |  16 +-
 arch/powerpc/boot/addnote.c                        |   7 +-
 arch/powerpc/kernel/process.c                      |   5 -
 arch/powerpc/mm/book3s64/internal.h                |   1 -
 arch/powerpc/mm/book3s64/mmu_context.c             |   2 -
 arch/powerpc/mm/book3s64/slb.c                     |  88 ---------
 arch/powerpc/mm/ptdump/hashpagetable.c             |   6 +
 arch/powerpc/platforms/pseries/cmm.c               |   5 +-
 arch/s390/kernel/smp.c                             |   1 +
 arch/x86/crypto/blake2s-core.S                     |   4 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/include/asm/ptrace.h                      |  20 +-
 arch/x86/include/asm/stacktrace.h                  |   3 -
 arch/x86/kernel/dumpstack.c                        |  29 ++-
 arch/x86/kernel/unwind_frame.c                     |  11 ++
 arch/x86/kvm/lapic.c                               |  32 ++-
 arch/x86/kvm/svm/nested.c                          |   4 +-
 arch/x86/kvm/svm/svm.c                             |  18 +-
 block/blk-mq.c                                     |  18 +-
 block/blk-throttle.c                               |  16 +-
 crypto/af_alg.c                                    |   5 +-
 crypto/algif_hash.c                                |   3 +-
 crypto/algif_rng.c                                 |   3 +-
 crypto/asymmetric_keys/asymmetric_type.c           |  12 +-
 crypto/seqiv.c                                     |   8 +-
 drivers/acpi/acpica/nswalk.c                       |   9 +-
 drivers/acpi/apei/ghes.c                           |  16 +-
 drivers/acpi/cppc_acpi.c                           |   3 +-
 drivers/acpi/processor_core.c                      |   2 +-
 drivers/acpi/property.c                            |   9 +-
 drivers/amba/tegra-ahb.c                           |   1 +
 drivers/atm/he.c                                   |   3 +-
 drivers/base/power/runtime.c                       |  22 ++-
 drivers/block/floppy.c                             |   2 +-
 drivers/block/nbd.c                                |  96 +++++----
 drivers/block/rnbd/rnbd-clt.c                      |  20 +-
 drivers/block/rnbd/rnbd-clt.h                      |   2 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/bus/ti-sysc.c                              |  11 +-
 drivers/char/applicom.c                            |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  20 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/char/tpm/tpm1-cmd.c                        |   5 -
 drivers/char/tpm/tpm2-cmd.c                        |   8 +-
 drivers/char/virtio_console.c                      |   2 +-
 drivers/clk/mvebu/cp110-system-controller.c        |  20 ++
 drivers/clk/renesas/r9a06g032-clocks.c             |  69 ++++++-
 drivers/cpufreq/cpufreq-nforce2.c                  |   3 +
 drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   6 +-
 drivers/firewire/nosy.c                            |  47 +++--
 drivers/firmware/efi/cper-arm.c                    |  52 +++--
 drivers/firmware/efi/cper.c                        |  60 ++++++
 drivers/firmware/imx/imx-scu-irq.c                 |   8 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   2 +-
 drivers/gpu/drm/gma500/framebuffer.c               |  44 -----
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |  13 ++
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +-
 drivers/gpu/drm/panel/panel-visionox-rm69299.c     |   2 +-
 drivers/gpu/drm/pl111/pl111_drv.c                  |   2 +-
 drivers/gpu/drm/vgem/vgem_fence.c                  |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  17 +-
 drivers/hid/hid-core.c                             |   7 +-
 drivers/hid/hid-input.c                            |  18 +-
 drivers/hid/hid-logitech-dj.c                      |  56 +++---
 drivers/hid/hid-quirks.c                           |   9 +
 drivers/hwmon/applesmc.c                           |  34 ++--
 drivers/hwmon/ibmpex.c                             |   9 +-
 drivers/hwmon/ina209.c                             |   6 +-
 drivers/hwmon/ina2xx.c                             |   2 +-
 drivers/hwmon/ina3221.c                            |   2 +-
 drivers/hwmon/lineage-pem.c                        |   8 +-
 drivers/hwmon/ltc2945.c                            |   4 +-
 drivers/hwmon/ltc2990.c                            |   2 +-
 drivers/hwmon/ltc4151.c                            |   2 +-
 drivers/hwmon/ltc4215.c                            |   8 +-
 drivers/hwmon/ltc4222.c                            |   4 +-
 drivers/hwmon/ltc4260.c                            |   4 +-
 drivers/hwmon/ltc4261.c                            |   4 +-
 drivers/hwmon/max16065.c                           |  19 +-
 drivers/hwmon/occ/common.c                         |  69 +++----
 drivers/hwmon/occ/sysfs.c                          |   4 +-
 drivers/hwmon/pmbus/inspur-ipsps.c                 |  28 +--
 drivers/hwmon/pmbus/pmbus_core.c                   |   8 +-
 drivers/hwmon/s3c-hwmon.c                          |   4 +-
 drivers/hwmon/sch5627.c                            |  24 +--
 drivers/hwmon/sch5636.c                            |  20 +-
 drivers/hwmon/smm665.c                             |   4 +-
 drivers/hwmon/stts751.c                            |  20 +-
 drivers/hwmon/vexpress-hwmon.c                     |  12 +-
 drivers/hwmon/w83791d.c                            |  19 +-
 drivers/hwmon/w83l786ng.c                          |  26 ++-
 drivers/hwmon/xgene-hwmon.c                        |  14 +-
 drivers/hwtracing/intel_th/core.c                  |  20 +-
 drivers/i2c/busses/i2c-amd-mp2-pci.c               |   5 +-
 drivers/i3c/master.c                               | 189 ++++++++++++++++--
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |  24 ++-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |  71 +++++--
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  32 +--
 drivers/infiniband/core/addr.c                     |  33 +---
 drivers/infiniband/core/cma.c                      |   3 +
 drivers/infiniband/core/device.c                   |   5 +
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   8 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   4 -
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/touchscreen/ti_am335x_tsc.c          |   2 +-
 drivers/iommu/amd/init.c                           |  28 +--
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  27 ++-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |  10 +-
 drivers/iommu/exynos-iommu.c                       |   9 +-
 drivers/iommu/ipmmu-vmsa.c                         |   2 +
 drivers/iommu/mtk_iommu.c                          |   2 +
 drivers/iommu/mtk_iommu_v1.c                       |   2 +
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/iommu/omap-iommu.h                         |   2 -
 drivers/iommu/sun50i-iommu.c                       |   2 +
 drivers/irqchip/qcom-irq-combiner.c                |   2 +-
 drivers/leds/leds-lp50xx.c                         |  95 +++++----
 drivers/leds/leds-netxbig.c                        |  36 +++-
 drivers/macintosh/mac_hid.c                        |   3 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-log-writes.c                         |   1 +
 drivers/md/dm-raid.c                               |   2 +
 drivers/media/cec/core/cec-core.c                  |   1 +
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |  11 +-
 drivers/media/i2c/msp3400-kthreads.c               |   2 +
 drivers/media/i2c/tda1997x.c                       |   1 -
 drivers/media/platform/davinci/vpif_capture.c      |   4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  10 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c  |   4 +-
 drivers/media/platform/rcar_drif.c                 |   1 +
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   3 +
 drivers/media/usb/dvb-usb/dtv5100.c                |   5 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/mfd/altera-sysmgr.c                        |   2 +
 drivers/mfd/da9055-core.c                          |   1 +
 drivers/mfd/max77620.c                             |  15 +-
 drivers/mfd/mt6358-irq.c                           |   1 +
 drivers/mfd/mt6397-irq.c                           |   1 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/vmw_balloon.c                         |   3 +-
 drivers/mtd/lpddr/lpddr_cmds.c                     |   8 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/ethernet/3com/3c59x.c                  |   2 +-
 drivers/net/ethernet/broadcom/b44.c                |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  87 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   | 122 ++++++++++--
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  17 +-
 drivers/net/fjes/fjes_hw.c                         |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   3 +
 drivers/net/mdio/mdio-aspeed.c                     |  77 +++++---
 drivers/net/team/team.c                            |   2 +-
 drivers/net/usb/pegasus.c                          |   2 +
 drivers/net/usb/rtl8150.c                          |   2 +
 drivers/net/usb/sr9700.c                           |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   9 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  27 ++-
 drivers/net/wireless/st/cw1200/bh.c                |   6 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/parisc/gsc.c                               |   4 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |  10 +-
 drivers/pci/pci-driver.c                           |   4 +
 drivers/phy/broadcom/phy-bcm63xx-usbh.c            |   6 +-
 drivers/pinctrl/pinctrl-single.c                   |  25 ++-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   2 +-
 drivers/platform/chrome/cros_ec_ishtp.c            |   1 +
 drivers/platform/x86/acer-wmi.c                    |   4 +
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/platform/x86/huawei-wmi.c                  |   4 +
 drivers/platform/x86/ibm_rtl.c                     |   2 +-
 drivers/platform/x86/msi-laptop.c                  |   3 +
 drivers/power/supply/apm_power.c                   |   3 +-
 drivers/power/supply/wm831x_power.c                |  10 +-
 drivers/powercap/powercap_sys.c                    |  22 ++-
 drivers/pwm/pwm-bcm2835.c                          |  95 +++------
 drivers/pwm/pwm-stm32.c                            |   3 +-
 drivers/regulator/core.c                           |  37 ++--
 drivers/rpmsg/qcom_glink_native.c                  |   8 +
 drivers/s390/crypto/ap_bus.c                       |   8 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   3 +
 drivers/scsi/ipr.c                                 |  28 ++-
 drivers/scsi/iscsi_tcp.c                           |  13 +-
 drivers/scsi/libiscsi.c                            |  39 +++-
 drivers/scsi/libsas/sas_internal.h                 |  14 --
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/sg.c                                  |  20 +-
 drivers/scsi/sim710.c                              |   2 +
 drivers/scsi/stex.c                                |   1 +
 drivers/scsi/ufs/ufshcd.c                          |   4 +-
 drivers/soc/amlogic/meson-canvas.c                 |   5 +-
 drivers/soc/qcom/ocmem.c                           |   2 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-imx.c                              |  15 +-
 drivers/spi/spi-xilinx.c                           |   2 +-
 drivers/staging/comedi/comedi_fops.c               |  42 +++-
 drivers/staging/comedi/drivers/c6xdigio.c          |  46 +++--
 drivers/staging/comedi/drivers/multiq3.c           |   9 +
 drivers/staging/fbtft/fbtft-core.c                 |   4 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   5 +-
 drivers/target/target_core_configfs.c              |   1 -
 drivers/target/target_core_transport.c             |   1 +
 drivers/tty/serial/8250/8250_pci.c                 |  37 ++++
 drivers/tty/serial/sprd_serial.c                   |   6 +
 drivers/usb/core/message.c                         |   2 +-
 drivers/usb/dwc2/platform.c                        |  16 +-
 drivers/usb/dwc3/dwc3-of-simple.c                  |   7 +-
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/usb/dwc3/host.c                            |   2 +-
 drivers/usb/gadget/legacy/raw_gadget.c             |   3 +
 drivers/usb/gadget/udc/core.c                      |  17 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  20 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |   6 -
 drivers/usb/host/ohci-nxp.c                        |  20 +-
 drivers/usb/host/xhci-dbgtty.c                     |   6 +
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-mem.c                        |  10 +-
 drivers/usb/host/xhci-ring.c                       |   8 +-
 drivers/usb/host/xhci.h                            |  16 +-
 drivers/usb/misc/chaoskey.c                        |  16 +-
 drivers/usb/misc/sisusbvga/sisusb_con.c            |  21 --
 drivers/usb/phy/phy-fsl-usb.c                      |   1 +
 drivers/usb/phy/phy.c                              |   4 +
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/belkin_sa.c                     |  28 +--
 drivers/usb/serial/ftdi_sio.c                      |  72 +++----
 drivers/usb/serial/kobil_sct.c                     |  18 +-
 drivers/usb/serial/option.c                        |  22 ++-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   6 +
 drivers/usb/usbip/vhci_hcd.c                       |   6 +-
 drivers/vhost/vsock.c                              |  15 +-
 drivers/video/backlight/led_bl.c                   |  18 +-
 drivers/video/console/dummycon.c                   |  20 --
 drivers/video/console/sticore.c                    |   8 +-
 drivers/video/fbdev/core/fbcon.c                   |  68 ++-----
 drivers/video/fbdev/core/fbcon_rotate.c            |   3 +-
 drivers/video/fbdev/core/tileblit.c                |   4 +-
 drivers/video/fbdev/gbefb.c                        |   5 +-
 drivers/video/fbdev/pxafb.c                        |  12 +-
 drivers/video/fbdev/ssd1307fb.c                    |   4 +-
 drivers/video/fbdev/tcx.c                          |   2 +-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 drivers/watchdog/via_wdt.c                         |   1 +
 drivers/watchdog/wdat_wdt.c                        |  65 ++++--
 fs/bfs/inode.c                                     |  19 +-
 fs/btrfs/extent_io.c                               |  15 +-
 fs/btrfs/ioctl.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   5 +
 fs/btrfs/volumes.c                                 |   1 +
 fs/exfat/super.c                                   |  19 +-
 fs/ext4/inline.c                                   |  14 +-
 fs/ext4/inode.c                                    |   5 +
 fs/ext4/mballoc.c                                  |  58 ++++--
 fs/ext4/move_extent.c                              |  18 +-
 fs/ext4/super.c                                    |   7 +-
 fs/ext4/xattr.c                                    |  38 +---
 fs/ext4/xattr.h                                    |  10 +
 fs/f2fs/f2fs.h                                     |   3 -
 fs/f2fs/file.c                                     |   3 +-
 fs/f2fs/namei.c                                    |   6 +-
 fs/f2fs/recovery.c                                 |   9 +-
 fs/f2fs/super.c                                    |  53 ++---
 fs/f2fs/xattr.c                                    |  32 ++-
 fs/f2fs/xattr.h                                    |  10 +-
 fs/hfsplus/bnode.c                                 |   4 +-
 fs/hfsplus/dir.c                                   |   7 +-
 fs/hfsplus/inode.c                                 |  32 ++-
 fs/jbd2/journal.c                                  |  14 ++
 fs/jbd2/transaction.c                              |  21 +-
 fs/lockd/svc4proc.c                                |   4 +-
 fs/lockd/svclock.c                                 |  21 +-
 fs/lockd/svcproc.c                                 |   5 +-
 fs/locks.c                                         |  13 +-
 fs/nfs/dir.c                                       | 131 ++++++++----
 fs/nfs/inode.c                                     |   6 +-
 fs/nfs/internal.h                                  |   5 +-
 fs/nfs/namespace.c                                 |  11 ++
 fs/nfs/nfs4proc.c                                  |  13 +-
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfs/pnfs.c                                      |   1 +
 fs/nfs/super.c                                     |  26 ---
 fs/nfs/unlink.c                                    |   6 +-
 fs/nfs/write.c                                     |   8 +-
 fs/nfsd/blocklayout.c                              |   7 +-
 fs/nfsd/export.c                                   |   2 +-
 fs/nfsd/netns.h                                    |   2 +
 fs/nfsd/nfs4state.c                                |  46 ++++-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfsctl.c                                   |   3 +-
 fs/nfsd/state.h                                    |   2 +-
 fs/nfsd/vfs.c                                      |   2 +-
 fs/nls/nls_base.c                                  |  27 ++-
 fs/notify/fsnotify.c                               |   9 +-
 fs/ocfs2/alloc.c                                   |   1 -
 fs/ocfs2/move_extents.c                            |   8 +-
 fs/ocfs2/suballoc.c                                |  10 +
 fs/overlayfs/export.c                              |   2 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/xfs/xfs_buf_item.c                              |   1 +
 include/linux/balloon_compaction.h                 |  65 ++----
 include/linux/blk_types.h                          |   5 +-
 include/linux/compiler-clang.h                     |  23 +++
 include/linux/compiler-gcc.h                       |  14 ++
 include/linux/console.h                            |   1 -
 include/linux/cper.h                               |  12 +-
 include/linux/font.h                               |   1 +
 include/linux/fs_context.h                         |   1 -
 include/linux/genalloc.h                           |   1 +
 include/linux/hugetlb.h                            |   4 +-
 include/linux/i3c/master.h                         |   1 -
 include/linux/ieee80211.h                          |   4 +-
 include/linux/mm.h                                 |   2 +-
 include/linux/netdevice.h                          |   7 +-
 include/linux/nfs_fs.h                             |   9 +
 include/linux/platform_data/lp855x.h               |   4 +-
 include/linux/rculist_nulls.h                      |  59 ++++++
 include/linux/reset.h                              |   1 +
 include/linux/security.h                           |   2 +-
 include/linux/soc/renesas/r9a06g032-sysctrl.h      |  11 ++
 include/linux/tpm.h                                |   9 +-
 include/linux/usb/gadget.h                         |   5 +
 include/linux/virtio_config.h                      |   2 +-
 include/media/v4l2-mem2mem.h                       |   3 +-
 include/net/dst.h                                  |  12 ++
 include/net/netfilter/nf_conntrack_count.h         |  16 +-
 include/net/sock.h                                 |  13 ++
 include/net/xfrm.h                                 |  13 +-
 include/scsi/libiscsi.h                            |   2 +
 include/uapi/linux/kd.h                            |   2 +-
 include/uapi/linux/mptcp.h                         |   1 +
 include/uapi/sound/asound.h                        |   2 +-
 io_uring/io_uring.c                                |   2 +-
 kernel/dma/pool.c                                  |   2 +-
 kernel/livepatch/core.c                            |   8 +-
 kernel/locking/spinlock_debug.c                    |   4 +-
 kernel/scs.c                                       |   2 +-
 kernel/trace/trace_events.c                        |   2 +
 lib/crypto/aes.c                                   |   4 +-
 lib/fonts/font_10x18.c                             |   1 +
 lib/fonts/font_6x10.c                              |   1 +
 lib/fonts/font_6x11.c                              |   1 +
 lib/fonts/font_6x8.c                               |   1 +
 lib/fonts/font_7x14.c                              |   1 +
 lib/fonts/font_8x16.c                              |   1 +
 lib/fonts/font_8x8.c                               |   1 +
 lib/fonts/font_acorn_8x8.c                         |   1 +
 lib/fonts/font_mini_4x6.c                          |   1 +
 lib/fonts/font_pearl_8x8.c                         |   1 +
 lib/fonts/font_sun12x22.c                          |   1 +
 lib/fonts/font_sun8x16.c                           |   1 +
 lib/fonts/font_ter16x32.c                          |   1 +
 lib/idr.c                                          |   2 +
 lib/vsprintf.c                                     |   6 +-
 mm/balloon_compaction.c                            |  15 +-
 mm/hugetlb.c                                       |   4 +-
 mm/mempolicy.c                                     |   2 +-
 mm/mprotect.c                                      |  34 ++--
 net/bridge/br_private.h                            |   1 +
 net/bridge/br_vlan_tunnel.c                        |  11 +-
 net/caif/cffrml.c                                  |   9 +-
 net/can/j1939/transport.c                          |   2 +
 net/ceph/osd_client.c                              |  11 +-
 net/ceph/osdmap.c                                  | 140 +++++++------
 net/core/dev.c                                     |  33 ++++
 net/core/sock.c                                    |   7 +-
 net/core/sock_map.c                                |  53 ++---
 net/ethtool/ioctl.c                                | 134 +++++++++----
 net/hsr/hsr_forward.c                              |   2 +
 net/ipv4/arp.c                                     |   7 +-
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/ip_output.c                               |  19 +-
 net/ipv4/ipcomp.c                                  |   2 +
 net/ipv4/ping.c                                    |   4 +-
 net/ipv4/raw.c                                     |   3 +
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/ip6_gre.c                                 |   9 +-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/ipcomp6.c                                 |   2 +
 net/ipv6/xfrm6_tunnel.c                            |   2 +-
 net/key/af_key.c                                   |   2 +-
 net/mac80211/rx.c                                  |   5 +
 net/mptcp/pm_netlink.c                             |   3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   3 +
 net/netfilter/nf_conncount.c                       | 219 ++++++++++++++-------
 net/netfilter/nft_connlimit.c                      |  69 ++++---
 net/netfilter/nft_synproxy.c                       |   6 +-
 net/netfilter/xt_connlimit.c                       |  14 +-
 net/netrom/nr_out.c                                |   4 +-
 net/nfc/core.c                                     |   9 +-
 net/openvswitch/conntrack.c                        |  16 +-
 net/openvswitch/flow_netlink.c                     |  13 +-
 net/openvswitch/vport-netdev.c                     |  17 +-
 net/rose/af_rose.c                                 |   2 +-
 net/sched/sch_cake.c                               |  60 +++---
 net/sched/sch_ets.c                                |   6 +-
 net/sched/sch_qfq.c                                |   2 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   3 +-
 net/tls/tls_device.c                               |  18 +-
 net/wireless/wext-core.c                           |   4 +
 net/wireless/wext-priv.c                           |   4 +
 net/xfrm/xfrm_ipcomp.c                             |   1 -
 net/xfrm/xfrm_state.c                              |  41 ++--
 net/xfrm/xfrm_user.c                               |   2 +-
 samples/vfs/test-statx.c                           |   6 +
 samples/watch_queue/watch_test.c                   |   6 +
 security/integrity/ima/ima_policy.c                |   2 +-
 security/smack/smack_lsm.c                         |  41 ++--
 sound/firewire/dice/dice-extension.c               |   4 +-
 sound/isa/wavefront/wavefront_midi.c               |   2 +
 sound/isa/wavefront/wavefront_synth.c              |   4 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |   8 +-
 sound/pcmcia/vx/vxpocket.c                         |   8 +-
 sound/soc/bcm/bcm63xx-pcm-whistler.c               |   4 +-
 sound/soc/codecs/ak4458.c                          |  10 +-
 sound/soc/codecs/ak5558.c                          |  10 +-
 sound/soc/fsl/fsl_sai.c                            |   3 +
 sound/soc/qcom/qdsp6/q6adm.c                       | 146 +++++++-------
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   7 +-
 sound/soc/stm/stm32_i2s.c                          |  62 ++----
 sound/soc/stm/stm32_sai.c                          |  39 ++--
 sound/soc/stm/stm32_sai_sub.c                      |  46 ++---
 sound/soc/stm/stm32_spdifrx.c                      |  44 ++---
 sound/usb/mixer_us16x08.c                          |  20 +-
 tools/perf/util/symbol.c                           |   4 +-
 tools/testing/ktest/config-bisect.pl               |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   7 +-
 tools/testing/radix-tree/idr-test.c                |  21 ++
 .../selftests/bpf/prog_tests/perf_branches.c       |  16 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   5 +
 .../selftests/bpf/progs/test_perf_branches.c       |   3 +
 .../test.d/ftrace/func_traceonoff_triggers.tc      |   5 +-
 472 files changed, 4037 insertions(+), 2442 deletions(-)


