Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F774195C0;
	Thu, 20 Aug 2026 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244003; cv=none; b=dParYljBb97vMbfEQgfaJyZ2HaxPCvYhqAMA6fbw7EJRfzTj9JiQp5qFNrWVGHVQxqzZLbdaMHxwsSWmiI7WmC4dk5nghNPEK6myDpdWKsfDtvghIgGI1ADNbbiozCqMVfTe32CxwFiKbXcfMsB24zyI5vcERH/XH+QO/8ntGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244003; c=relaxed/simple;
	bh=i4XkWIxPtAHwR6lkn1RBtsPx1esylkQgdpINc1AXN34=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uOrQpWwNhNU2lTyWP4pDlevN+yVteipejFwjOIwjXuxtUkivdwIp6uMEnoTTKdb17tYsPZIU5RViNwvFa64btr99DK2AkVnDBBDfshdRivL7N5ZwqRU3RjFlogBnl1uct1h1npG5uTw9gUrRRheVKOPPj0/YlX4dHrXDgn448gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrq15BNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrq15BNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3B51F000E9;
	Thu, 20 Aug 2026 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244000;
	bh=fFuFA5GN1yhSOsBZUb3mW5af3LkybCOOBsKvP68wylo=;
	h=From:To:Cc:Subject:Date;
	b=hrq15BNl3/zJ9sRgVY+GeVeqSu0Re86ulfauZE9GwV7Euw/eo+LIlvVB53nBFbUSP
	 1IUJg5sXxCZi4tuCV/8wtu/BM5OJvuKcscTevqvuhyna0M35Wl1g3kkWKdQHV6i9+K
	 zpSzCej+eArdJP3rtdiU6Tsc+QVfP3wubtm2tpF8=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 5.10 000/235] 5.10.266-rc1 review
Date: Thu, 20 Aug 2026 16:53:56 +0200
Message-ID: <20260820145216.426568665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.266-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.266-rc1
X-KernelTest-Deadline: 2026-08-22T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.266 release.
There are 235 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.266-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.266-rc1

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix information leak

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: smbus: Check for parent device before dereference

Robert Mader <robert.mader@collabora.com>
    udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()

Christian Brauner <brauner@kernel.org>
    binfmt_misc: use exe_file_deny_write_access() for the interpreter clone

Daming Li <d4n.for.sec@gmail.com>
    net: smc: fix splice entry lifetime imbalance in smc_rx_splice

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: rdma write inline if qp has sufficient inline space

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: move free desc queue mode selection in pdata

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: move ale selection in pdata

Eric Dumazet <edumazet@google.com>
    af_packet: Don't send zero-byte data in tpacket_snd().

Rosen Penev <rosenp@gmail.com>
    ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers

Wei Fang <wei.fang@nxp.com>
    net: packet: fix wrong transport_header when sending VLAN-tagged frame

Florian Westphal <fw@strlen.de>
    netfilter: ipset: fix list type element drift bug

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: flowtable: publish GC-visible tuple last

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: ipset: fix refcount race between list:set GC and swap

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ccm - Set rfc4309 maxauthsize from child

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Add EL2 virtual timer interrupt for Tegra194

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free stranded TX buffers on ring deinit

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/ptdump: always stabilise against page table freeing using init_mm

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_gact, act_police: range check the fallback control action

Tejun Heo <tj@kernel.org>
    sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Baul Lee <baul.lee@xbow.com>
    ALSA: usx2y: bound the hwdep mmap fault offset

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix potential leaks of uninitialized memory

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix torn gpu metrics reads

Hongyan Xu <getshell@seu.edu.cn>
    hwmon: (npcm750-pwm-fan): stop fan timer on device detach

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure

Christian Brauner <brauner@kernel.org>
    binfmt_misc: restore write access when removing an entry

Amir Goldstein <amir73il@gmail.com>
    fs: don't block write during exec on pre-content watched files

Amir Goldstein <amir73il@gmail.com>
    fsnotify: opt-in for permission events at file open time

Jonas Gorski <jonas.gorski@bisdn.de>
    i2c: iproc: reset bus after timeout if START_BUSY is stuck

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: bcm-iproc: remove printout on handled timeouts

Dawei Feng <dawei.feng@seu.edu.cn>
    ice: fix memory leak in ice_lbtest_prepare_rings()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: fix VF interrupts cleanup

Ibrahim Hashimov <security@auditcode.ai>
    scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: scsi_debug: Rename zone type constants

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: sd: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: sd: sd_zbc: Use logical blocks as unit when querying zones

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: sd_zbc: Improve source code documentation

Chengfeng Ye <nicoyip.dev@gmail.com>
    net: pktgen: fix proc entry use-after-free

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix code style (WARNING: Block comments)

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: reject frames without a transaction header

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    skbuff: introduce skb_pull_data

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Add global mutex to serialize trace_parser access

Christian Brauner <brauner@kernel.org>
    super: fix emergency thaw deadlock on frozen block devices

Shiming Cheng <shiming.cheng@mediatek.com>
    net: gro: fix double aggregation of flush-marked skbs

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net/sched: serialize qdisc_rtab_list against concurrent get/put

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix hanging __ceph_get_caps() with stale mds_wanted

Xiubo Li <xiubli@redhat.com>
    ceph: rename _to_client() to _to_fs_client()

Xiubo Li <xiubli@redhat.com>
    libceph: add doutc and *_client debug macros support

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix two unsafe bare decodes in decode_lockers()

Xiang Mei <xmei5@asu.edu>
    libceph: bound pg_{temp,upmap,upmap_items} length to CEPH_PG_MAX_SIZE

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    libceph: Amend checking to fix `make W=1` build breakage

Max Kellermann <max.kellermann@ionos.com>
    ceph: avoid fs reclaim while using current->journal_info

Zhiling Zou <roxy520tt@gmail.com>
    sctp: avoid auth_enable sysctl UAF during netns teardown

Chenguang Zhao <zhaochenguang@kylinos.cn>
    mptcp: decrement subflows counter on failed passive join

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix subflow accounting on close

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: implement gpio get_direction() callback

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix regression with GPIO configuration

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove obsolete out_thread label

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sc16is7xx: Fill in rs485_supported

Tomasz Moń <tomasz.mon@camlingroup.com>
    sc16is7xx: Properly resume TX after stop

Michael Bommarito <michael.bommarito@gmail.com>
    mptcp: only set DATA_FIN when a mapping is present

Jiangshan Yi <yijiangshan@kylinos.cn>
    serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_mid: Remove unneeded test for ->setup() presence

Norbert Szetei <norbert@doyensec.com>
    ALSA: seq: close a re-opened queue timer in the destructor

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

Mirela Rabulea <mirela.rabulea@nxp.com>
    media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: async: Set owner for async sub-devices

Daniel Hodges <git@danielhodges.dev>
    wifi: ath6kl: fix use-after-free in aggr_reset_state()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx219: Rename VTS to FRM_LENGTH

David Plowman <david.plowman@raspberrypi.com>
    media: i2c: imx219: Correct the minimum vblanking value

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Drop IMX219_VTS_* macros

Guangshuo Li <lgs201920130244@gmail.com>
    media: marvell-cam: fix missing pci_disable_device() on remove

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

David Carlier <devnexen@gmail.com>
    media: aspeed: fix missing of_reserved_mem_device_release() on probe failure

Bryam Vargas <hexlabsecurity@proton.me>
    drm/virtio: bound EDID block reads to the response buffer

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Return proper error codes instead of -1

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: fix Tiled Display Topology ID size

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/virtio: use uninterruptible resv lock for plane updates

Christian König <christian.koenig@amd.com>
    dma-buf/drivers: make reserving a shared slot mandatory v4

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix buffer overflows in sideband chunk accumulation

Venkatesh Srinivas <venkateshs@chromium.org>
    KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN

David Matlack <dmatlack@google.com>
    KVM: Introduce vcpu->wants_to_run

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move "apicv_active" into "struct kvm_lapic"

Sean Christopherson <seanjc@google.com>
    KVM: x86: Check for in-kernel xAPIC when querying APICv for directed yield

Sean Christopherson <seanjc@google.com>
    KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix data loss on receive throttling

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: clean up comments and whitespace

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: add write-fifo support

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix write implementation

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: refactor write-room handling

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: gadget: bdc: fix checkpatch.pl spacing error

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list

Dawei Feng <dawei.feng@seu.edu.cn>
    octeontx2-pf: fix SQB pointer leak on init failure

Haoxiang Li <haoxiang_li2024@163.com>
    net: ipa: fix SMEM state handle leaks in SMP2P init

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: use sk_msg_free_partial to fix partial send

Breno Leitao <leitao@debian.org>
    bootconfig: fix NULL-pointer arithmetic in xbc_snprint_cmdline()

Breno Leitao <leitao@debian.org>
    bootconfig: move xbc_snprint_cmdline() to lib/bootconfig.c

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    bootconfig: do not put quotes on cmdline items unless necessary

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: tegra: do not call pinctrl for GPIO direction

Bryam Vargas <hexlabsecurity@proton.me>
    net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid calling child->ops->dequeue(child) twice

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ipip: require CAP_NET_ADMIN in the device netns for changelink

Liu Jian <liujian56@huawei.com>
    net: Add helper function to parse netlink msg of ip_tunnel_encap

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix firmware leak in async update

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    firmware_loader: introduce __free() cleanup hanler

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: rename probe error labels

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix use-after-free on disconnect

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix race condition in reset_device sysfs callback

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: make error counter atomic

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't increment hash_offset twice

Bryam Vargas <hexlabsecurity@proton.me>
    scsi: target: Bound PR-OUT TransportID parsing to the received buffer

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Generate correct identifiers for PR OUT transport IDs

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    scsi: target: core: pr: Initialize arrays at declaration time

Souvik Banerjee <souvik@amlalabs.com>
    ovl: use linked upper dentry in copy-up tmpfile

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove XDomain from the bus without holding tb->lock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Vincent Jardin <vjardin@free.fr>
    i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    i2c: imx: separate atomic, dma and non-dma use case

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Remove unused irq field in struct dw_edma_chip

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    dmaengine: dw-edma: Improve the linked list and data blocks definition

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    PCI: Add pci_find_vsec_capability() to find a specific VSEC

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: use kvzalloc() for megabyte buffer in simple fallocate

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: swp: Improve locking user experience

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: Fix spi_nor_try_unlock_all()

Tudor Ambarus <tudor.ambarus@microchip.com>
    mtd: spi-nor: Move Software Write Protection logic out of the core

Michael Walle <michael@walle.cc>
    mtd: spi-nor: intel: remove global protection flag

Michael Walle <michael@walle.cc>
    mtd: spi-nor: sst: remove global protection flag

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: retain dead thread stats in TGID queries

Oleg Nesterov <oleg@redhat.com>
    taskstats: fill_stats_for_tgid: use for_each_thread()

Maoyi Xie <maoyixie.tju@gmail.com>
    net: thunderbolt: Fix frags[] overflow by bounding frame_count

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Breno Leitao <leitao@debian.org>
    9p: skip nlink update in cacheless mode to fix WARN_ON

Vasiliy Kovalev <kovalev@altlinux.org>
    net/9p: fix infinite loop in p9_client_rpc on fatal signal

Tristan Madani <tristan@talencesecurity.com>
    selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()

Casey Schaufler <casey@schaufler-ca.com>
    lsm: infrastructure management of the sock security

Ondrej Mosnacek <omosnace@redhat.com>
    lsm: use default hook return value in call_int_hook()

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: don't leak bad clone into future transaction

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: move cloning of match info to insert/removal path

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: merge deactivate helper into caller

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: prepare walk function for on-demand clone

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: make pipapo_clone helper return NULL

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: use GFP_KERNEL for insertions

Junrui Luo <moonafterrain@outlook.com>
    jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    jbd2: add a helper to find out number of fast commit blocks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_sip: validate skb_dst() before accessing it

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: remove net variable shadowing

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-vf: clear stale mailbox IRQ state before request_irq()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8183: Check runtime resume during probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-pf: clear stale mailbox IRQ state before request_irq()

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2: Annotate mmio regions as __iomem

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum: On port enslavement to a LAG, join upper's bridges

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Apply RIF configuration when joining a LAG

David Howells <dhowells@redhat.com>
    rxrpc: Fix socket notification race

David Howells <dhowells@redhat.com>
    rxrpc: Fix notification vs call-release vs recvmsg

David Howells <dhowells@redhat.com>
    rxrpc: Fix recv-recv race of completed call

Li Xiasong <lixiasong1@huawei.com>
    tipc: restrict socket queue dumps in enqueue tracepoints

Li Daming <d4n.for.sec@gmail.com>
    rxrpc: serialize kernel accept preallocation with socket teardown

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: implement gpio_chip::get_direction()

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: max310x: replace bare use of 'unsigned' with 'unsigned int' (checkpatch)

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix cached processing coefficient verbs

Ricardo Robaina <rrobaina@redhat.com>
    audit: fix recursive locking deadlock in audit_dupe_exe()

Ricardo Robaina <rrobaina@redhat.com>
    audit: use 'unsigned int' instead of 'unsigned'

Jeff Layton <jlayton@kernel.org>
    audit: widen ino fields to u64

NeilBrown <neil@brown.name>
    VFS/audit: introduce kern_path_parent() for audit

Bryam Vargas <hexlabsecurity@proton.me>
    Input: mms114 - reject an oversized device packet size

Zhenhao Wan <whi4ed0g@gmail.com>
    RDMA/rtrs-srv: Bound RDMA-Write length to chunk size in rdma_write_sg

Akhil R <akhilrajeev@nvidia.com>
    i2c: smbus: Use device_*() functions instead of of_*()

Akhil R <akhilrajeev@nvidia.com>
    device property: Add fwnode_irq_get_byname

Haoxiang Li <haoxiang_li2024@163.com>
    i2c: davinci: Unregister cpufreq notifier on probe failure

Sebastian Alba Vives <sebasjosue84@gmail.com>
    fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning

Jason Gunthorpe <jgg@ziepe.ca>
    udmabuf: Do not create malformed scatterlists

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uninitialized

Chao Yu <chao@kernel.org>
    f2fs: fix UAF issue in f2fs_merge_page_bio()

Xiang Mei <xmei5@asu.edu>
    net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot

Christoph Hellwig <hch@lst.de>
    xfs: check v5 superblock features early

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix UVD decode image min size calculation

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Implement insert_end for VCE 3

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Reject UVD message with dimensions above 4096

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate GEM_CREATE domain combinations

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Reject UVD message with invalid number of h265 refs

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Fix out of bounds check on CCW array

Guangshuo Li <lgs201920130244@gmail.com>
    drm/radeon: fix autosuspend cleanup during teardown

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci: make tuning_err a signed int

Myeonghun Pak <mhun512@gmail.com>
    mmc: sdhci: unmap the bounce buffer before device release

Zhan Xusheng <zhanxusheng1024@gmail.com>
    mmc: omap_hsmmc: fix busy_timeout overflow in ns conversion on 32-bit

Yiming Zhu <zhuyiming@kuaishou.com>
    ceph: fix MDS random selection readiness predicate

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Avoid using invalid osd indices from primary_temp

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sur40 - fix V4L error path cleanup

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sur40 - fix input device registration ordering

Ali Ahmet Memis <ali@iusegentoo.com>
    openrisc: signal: do not restore privileged SR bits on sigreturn

Josh Poimboeuf <jpoimboe@kernel.org>
    ftrace: Fix off-by-one fentry site disable in ftrace_free_mem()

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix multiple unsafe decodes in decode_locker()

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: qce - fix error path in devm_qce_register_algs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - propagate F54 worker errors to V4L2 queue

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - block s_input when F54 queue is busy

Bryam Vargas <hexlabsecurity@proton.me>
    Input: synaptics-rmi4 - bound the F54 report size to the allocated buffer

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - zero report size on F54 work error

George Wilson <gcwilson@linux.ibm.com>
    powerpc/pseries: lparcfg - fix kbuf[] underflow

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Input: iforce - validate input packet lengths

Zhefu Zhang <a723356@gmail.com>
    Input: atkbd - skip deactivate for Xiaomi Book Pro 14's internal keyboard

Linmao Li <lilinmao@kylinos.cn>
    Input: psxpad-spi - set driver data before use

Richard Davies <richard@arachsys.com>
    Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - fix F55 transmitter electrode count typo

George Wilson <gcwilson@linux.ibm.com>
    powerpc/pseries: pci - logic bug

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: cs4265: sort the register default table

Hidayath Khan <hidayath@linux.ibm.com>
    s390/qeth: validate user buffer length in SNMP and ARP query ioctls

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: reset DSS fields in case of unexpected size

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: do not cancel a policy conversion that never started

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a class permission count below its inherited common

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require every boolean value to be defined

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: separate destination availability state

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization

Fullway Wang <fullwaywang@outlook.com>
    media: mtk-vcodec: potential null pointer deference in SCP


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   2 +
 arch/arm64/kvm/arm.c                               |   2 +-
 arch/mips/kvm/mips.c                               |   2 +-
 arch/openrisc/include/asm/processor.h              |   2 +
 arch/openrisc/kernel/signal.c                      |   5 +-
 arch/powerpc/kvm/powerpc.c                         |   2 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |   2 +-
 arch/powerpc/platforms/pseries/pci.c               |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  12 +-
 arch/x86/kvm/lapic.c                               |  41 +-
 arch/x86/kvm/lapic.h                               |   3 +-
 arch/x86/kvm/svm/avic.c                            |   4 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   9 +-
 arch/x86/kvm/x86.c                                 |  19 +-
 crypto/ccm.c                                       |   2 +-
 drivers/base/property.c                            |  29 ++
 drivers/char/tpm/tpm_tis_core.c                    |  38 +-
 drivers/crypto/qce/core.c                          |   2 +-
 drivers/dma-buf/dma-resv.c                         |   8 +-
 drivers/dma-buf/udmabuf.c                          |  21 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  77 ++--
 drivers/dma/dw-edma/dw-edma-core.h                 |  20 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 | 180 ++++++--
 drivers/dma/dw-edma/dw-edma-v0-core.c              |  76 ++--
 drivers/fpga/dfl-afu-main.c                        |   3 +
 drivers/gpio/gpio-tegra.c                          |  18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  21 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |  26 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  14 +-
 drivers/gpu/drm/drm_connector.c                    |  12 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  32 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   2 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   7 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   2 +-
 drivers/gpu/drm/lima/lima_gem.c                    |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/gpu/drm/qxl/qxl_release.c                  |   2 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 +
 drivers/gpu/drm/radeon/radeon_vm.c                 |   2 +-
 drivers/gpu/drm/tegra/fb.c                         |   8 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   4 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |   4 +-
 drivers/gpu/drm/vc4/vc4_gem.c                      |   2 +-
 drivers/gpu/drm/vgem/vgem_fence.c                  |   2 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   1 +
 drivers/gpu/drm/virtio/virtgpu_gem.c               |  17 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |   5 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   9 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |  11 +
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  11 +-
 drivers/i2c/busses/i2c-davinci.c                   |   4 +-
 drivers/i2c/busses/i2c-imx.c                       | 126 +++--
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/i2c/i2c-core-smbus.c                       |  15 +-
 drivers/i2c/i2c-smbus.c                            |   5 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   5 +-
 drivers/input/joystick/iforce/iforce-packets.c     |  11 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   3 +
 drivers/input/joystick/psxpad-spi.c                |   1 +
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/ims-pcu.c                       |   7 +-
 drivers/input/mouse/focaltech.c                    |   2 +-
 drivers/input/rmi4/rmi_f54.c                       |  43 +-
 drivers/input/rmi4/rmi_f55.c                       |   4 +-
 drivers/input/touchscreen/mms114.c                 |   6 +
 drivers/input/touchscreen/sur40.c                  |  23 +-
 drivers/md/dm-integrity.c                          |   4 -
 drivers/md/dm-verity-target.c                      |  12 +-
 drivers/md/dm-verity.h                             |   2 +-
 drivers/media/i2c/imx219.c                         |  47 +-
 drivers/media/platform/aspeed-video.c              |   1 +
 drivers/media/platform/marvell-ccic/cafe-driver.c  |   1 +
 .../media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c  |   5 +
 drivers/media/v4l2-core/v4l2-async.c               |   8 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   7 +-
 drivers/mmc/host/atmel-mci.c                       |   2 +
 drivers/mmc/host/omap_hsmmc.c                      |   2 +-
 drivers/mmc/host/sdhci.c                           |  16 +
 drivers/mmc/host/sdhci.h                           |   2 +-
 drivers/mmc/host/vub300.c                          |  36 +-
 drivers/mtd/maps/vmu-flash.c                       |   8 +-
 drivers/mtd/spi-nor/Makefile                       |   2 +-
 drivers/mtd/spi-nor/core.c                         | 406 +----------------
 drivers/mtd/spi-nor/core.h                         |   5 +
 drivers/mtd/spi-nor/intel.c                        |  16 +-
 drivers/mtd/spi-nor/sst.c                          |  30 +-
 drivers/mtd/spi-nor/swp.c                          | 426 +++++++++++++++++
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  25 +
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  48 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  13 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 109 ++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   4 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  31 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           | 139 ++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   4 +
 drivers/net/ipa/ipa_smp2p.c                        |  30 +-
 drivers/net/thunderbolt.c                          |   8 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  13 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  45 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/pci/pci.c                                  |  30 ++
 drivers/s390/cio/vfio_ccw_cp.c                     |  17 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   5 +
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
 drivers/scsi/scsi_debug.c                          |  27 +-
 drivers/scsi/sd.h                                  |   5 +-
 drivers/scsi/sd_zbc.c                              |  79 +++-
 drivers/target/target_core_fabric_lib.c            | 146 ++++--
 drivers/target/target_core_internal.h              |   5 +-
 drivers/target/target_core_pr.c                    |  54 +--
 drivers/thunderbolt/domain.c                       |  30 ++
 drivers/thunderbolt/icm.c                          |   5 +
 drivers/thunderbolt/switch.c                       |  14 +
 drivers/thunderbolt/tb.c                           |  58 +--
 drivers/thunderbolt/tb.h                           |   2 +
 drivers/thunderbolt/xdomain.c                      |  71 ++-
 drivers/tty/serial/8250/8250_mid.c                 |   6 +-
 drivers/tty/serial/max310x.c                       |  20 +-
 drivers/tty/serial/sc16is7xx.c                     | 192 ++++++--
 drivers/usb/gadget/function/f_tcm.c                | 192 ++++++--
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  20 +
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   7 +-
 drivers/usb/serial/keyspan_pda.c                   | 471 ++++++++++---------
 fs/9p/vfs_inode.c                                  |   9 +
 fs/binfmt_elf.c                                    |   4 +-
 fs/binfmt_elf_fdpic.c                              |   4 +-
 fs/binfmt_misc.c                                   |  14 +-
 fs/ceph/addr.c                                     |  24 +-
 fs/ceph/cache.c                                    |   2 +-
 fs/ceph/caps.c                                     |  53 ++-
 fs/ceph/dir.c                                      |  20 +-
 fs/ceph/export.c                                   |  10 +-
 fs/ceph/file.c                                     |  33 +-
 fs/ceph/inode.c                                    |  20 +-
 fs/ceph/ioctl.c                                    |   8 +-
 fs/ceph/mds_client.c                               |  11 +
 fs/ceph/mds_client.h                               |   2 +
 fs/ceph/mdsmap.c                                   |   2 +-
 fs/ceph/super.c                                    |  22 +-
 fs/ceph/super.h                                    |   8 +-
 fs/ceph/xattr.c                                    |   8 +-
 fs/cifs/smb2ops.c                                  |   4 +-
 fs/exec.c                                          |   6 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/jbd2/journal.c                                  |  10 +-
 fs/namei.c                                         |  42 ++
 fs/overlayfs/copy_up.c                             |  14 +-
 fs/super.c                                         |  19 +-
 fs/xfs/libxfs/xfs_sb.c                             |   4 +-
 include/drm/drm_connector.h                        |   6 +-
 include/drm/drm_displayid.h                        |   2 +-
 include/linux/audit.h                              |  18 +-
 include/linux/bootconfig.h                         |   3 +
 include/linux/bpf_lsm.h                            |   4 +
 include/linux/ceph/ceph_debug.h                    |  38 ++
 include/linux/dma-resv.h                           |   2 +-
 include/linux/dma/edma.h                           |   2 -
 include/linux/firmware.h                           |   3 +
 include/linux/fs.h                                 |  28 ++
 include/linux/i2c-smbus.h                          |   6 +-
 include/linux/jbd2.h                               |   9 +-
 include/linux/kvm_host.h                           |   1 +
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/namei.h                              |   1 +
 include/linux/pci.h                                |   1 +
 include/linux/property.h                           |   1 +
 include/linux/skbuff.h                             |   2 +
 include/linux/thunderbolt.h                        |   3 +
 include/media/v4l2-async.h                         |   9 +-
 include/net/act_api.h                              |  20 +
 include/net/ip_tunnels.h                           |   3 +
 include/net/ip_vs.h                                |   7 +
 include/trace/events/rxrpc.h                       |   2 +
 include/uapi/linux/ip_vs.h                         |   6 -
 init/main.c                                        |  39 --
 kernel/audit.c                                     |   2 +-
 kernel/audit.h                                     |  32 +-
 kernel/audit_fsnotify.c                            |  39 +-
 kernel/audit_tree.c                                |   2 +-
 kernel/audit_watch.c                               |  42 +-
 kernel/auditfilter.c                               |  17 +-
 kernel/auditsc.c                                   |   6 +-
 kernel/bpf/bpf_inode_storage.c                     |  10 +
 kernel/sched/psi.c                                 |   6 +
 kernel/taskstats.c                                 |  67 +--
 kernel/trace/ftrace.c                              |  21 +-
 lib/bootconfig.c                                   |  65 +++
 lib/compat_audit.c                                 |  12 +-
 mm/memory_hotplug.c                                |  15 +-
 mm/pagewalk.c                                      |   8 +
 mm/ptdump.c                                        |   7 +
 net/9p/client.c                                    |   2 +
 net/bluetooth/hidp/core.c                          |  25 +-
 net/ceph/cls_lock_client.c                         |  21 +-
 net/ceph/osdmap.c                                  |   9 +-
 net/core/pktgen.c                                  |  43 +-
 net/core/skbuff.c                                  |  28 +-
 net/ipv4/ip_tunnel_core.c                          |  35 ++
 net/ipv4/ipip.c                                    |  41 +-
 net/ipv6/ip6_tunnel.c                              |  40 +-
 net/ipv6/sit.c                                     |  38 +-
 net/mptcp/options.c                                |  21 +-
 net/mptcp/protocol.c                               |   4 +-
 net/mptcp/protocol.h                               |  14 +
 net/mptcp/subflow.c                                |  12 +-
 net/netfilter/ipset/ip_set_core.c                  |  19 +-
 net/netfilter/ipset/ip_set_list_set.c              |   7 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   8 +-
 net/netfilter/nf_conntrack_sip.c                   |  10 +-
 net/netfilter/nf_flow_table_core.c                 |   7 +-
 net/netfilter/nf_tables_offload.c                  |   2 +-
 net/netfilter/nft_set_pipapo.c                     | 252 ++++++----
 net/netfilter/nft_set_pipapo.h                     |   8 +
 net/packet/af_packet.c                             |   7 +-
 net/rxrpc/call_accept.c                            |  28 +-
 net/rxrpc/call_object.c                            |  27 +-
 net/rxrpc/recvmsg.c                                |  23 +-
 net/sched/act_gact.c                               |   5 +
 net/sched/act_police.c                             |   6 +
 net/sched/sch_api.c                                |  24 +-
 net/sched/sch_taprio.c                             |  12 +-
 net/sctp/protocol.c                                |  20 +-
 net/sctp/sysctl.c                                  |   9 +-
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_rx.c                                   |  12 +-
 net/smc/smc_tx.c                                   |  17 +-
 net/tipc/socket.c                                  |   6 +-
 net/xfrm/espintcp.c                                |  32 +-
 security/apparmor/include/net.h                    |   6 +-
 security/apparmor/lsm.c                            |  38 +-
 security/bpf/hooks.c                               |   3 +
 security/security.c                                | 506 +++++++++++++--------
 security/selinux/hooks.c                           |  91 ++--
 security/selinux/include/objsec.h                  |   5 +
 security/selinux/netlabel.c                        |  23 +-
 security/selinux/ss/policydb.c                     |  31 ++
 security/selinux/ss/services.c                     |   4 +-
 security/smack/smack.h                             |   5 +
 security/smack/smack_lsm.c                         |  66 ++-
 security/smack/smack_netfilter.c                   |   8 +-
 sound/core/seq/seq_timer.c                         |  13 +-
 sound/hda/hdac_regmap.c                            |   4 +-
 sound/soc/codecs/cs4265.c                          |   4 +-
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  12 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  10 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |  10 +-
 sound/usb/usx2y/usbus428ctldefs.h                  |   2 +
 sound/usb/usx2y/usbusx2y.c                         |   2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                    |  15 +-
 virt/kvm/kvm_main.c                                |   3 +
 276 files changed, 4340 insertions(+), 2447 deletions(-)


