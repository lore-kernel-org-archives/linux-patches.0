Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FB0272E53;
	Thu, 20 Aug 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243275; cv=none; b=f8ZiHHEzEiw5ArnIyWyZlz/3/A6JsYf4uHj4xNYoxKI9EwrlDBFgdiTkSwor1q8GbzCA0cR65ZNXjut+TjPaJjoodFQBJvM+t/dxdZtGUYCn0dVsJ91GPG3YS13bryVR0R4mx9a9UBKHH6ehQ8UOnDqStcl0USG2vTLVw9EfjUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243275; c=relaxed/simple;
	bh=72Rs9eIqETe8bwxTZ+FTAKiGn+6NpYeFesQKFre7npc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qMHGJDkpRs7tbRqEMh9y456EvlQjCEDWdygeyqp7/cywg+Uq+fh2YhVvVhUcc+IXa/lT05slImGl1n2W6pJpCR9LCHgaShrNq6BRcFZEik0PnHSaEIntnIxvkqD5dVdffwK8jdWXTbhs4ZcJFdNFKV1Zbpv3OZs5q2tR+wqJl1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1re+94Hd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1re+94Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136071F000E9;
	Thu, 20 Aug 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243271;
	bh=K1kUntSACGYx/wlT+xJN6oxaA2lRoiHDkOhoKxK4sXg=;
	h=From:To:Cc:Subject:Date;
	b=1re+94HdJC7kqV5P4zzQ89PGG22SOwFPtWBfQdbxGSu20IAvabr6ZwjyCDrt6Rd1o
	 uMmqnPufxEQe7SuCALB/M2kgEWMIwvdfGAVW0WmqDXBp2dc+LqVVCVb+wm27r8Ysr1
	 y35I3SndW10Wtqo6L67vgb4CS7mVGfdDo6aYdqaE=
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
Subject: [PATCH 5.15 000/272] 5.15.217-rc1 review
Date: Thu, 20 Aug 2026 16:53:04 +0200
Message-ID: <20260820145231.229664293@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.217-rc1
X-KernelTest-Deadline: 2026-08-22T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.217 release.
There are 272 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.217-rc1

Easwar Hariharan <eahariha@linux.microsoft.com>
    jiffies: Cast to unsigned long in secs_to_jiffies() conversion

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Unlock reservations on dma_resv_reserve_fences() error

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Reserve fence slots on buffer objects in cotables

Robert Mader <robert.mader@collabora.com>
    udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()

Christian Brauner <brauner@kernel.org>
    binfmt_misc: use exe_file_deny_write_access() for the interpreter clone

Baul Lee <baul.lee@xbow.com>
    net/x25: fix use-after-free of the socket by its timers

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG

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

Daming Li <d4n.for.sec@gmail.com>
    net: smc: fix splice entry lifetime imbalance in smc_rx_splice

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: rdma write inline if qp has sufficient inline space

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free stranded TX buffers on ring deinit

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_ct: fix sk_buff leak when the header checks reject a packet

Xin Long <lucien.xin@gmail.com>
    openvswitch: move key and ovs_cb update out of handle_fragments

Xin Long <lucien.xin@gmail.com>
    net: sched: use skb_ip_totlen and iph_totlen

Xin Long <lucien.xin@gmail.com>
    openvswitch: use skb_ip_totlen in conntrack

Xin Long <lucien.xin@gmail.com>
    net: add a couple of helpers for iph tot_len

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/ptdump: always stabilise against page table freeing using init_mm

Tejun Heo <tj@kernel.org>
    sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix torn gpu metrics reads

Aaron Ma <aaron.ma@canonical.com>
    ice: wait for reset completion in ice_resume()

Easwar Hariharan <eahariha@linux.microsoft.com>
    jiffies: Define secs_to_jiffies()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure

Jonas Gorski <jonas.gorski@bisdn.de>
    i2c: iproc: reset bus after timeout if START_BUSY is stuck

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: bcm-iproc: remove printout on handled timeouts

Liem <liem16213@gmail.com>
    i2c: imx: Fix slave registration race and error handling

Christian Brauner <brauner@kernel.org>
    binfmt_misc: restore write access when removing an entry

Amir Goldstein <amir73il@gmail.com>
    fs: don't block write during exec on pre-content watched files

Amir Goldstein <amir73il@gmail.com>
    fsnotify: opt-in for permission events at file open time

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

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: sd_zbc: Introduce struct zoned_disk_info

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: sd: sd_zbc: Use logical blocks as unit when querying zones

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: sd_zbc: Improve source code documentation

Chengfeng Ye <nicoyip.dev@gmail.com>
    net: pktgen: fix proc entry use-after-free

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix code style (WARNING: Block comments)

David Carlier <devnexen@gmail.com>
    igc: remove napi_synchronize() in igc_down()

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject repeated SMB2 NEGOTIATE requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: conn lock to serialize smb2 negotiate

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate minimum PDU size for transform requests

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix minimum SMB2 PDU size

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix minimum SMB1 PDU size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rename smb2_get_msg to smb_get_msg

Christian Brauner <brauner@kernel.org>
    super: fix emergency thaw deadlock on frozen block devices

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Add global mutex to serialize trace_parser access

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net/sched: serialize qdisc_rtab_list against concurrent get/put

James Montgomery <james_montgomery@disroot.org>
    ksmbd: defer destroy_previous_session() until after NTLM authentication

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix two unsafe bare decodes in decode_lockers()

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix hanging __ceph_get_caps() with stale mds_wanted

Xiubo Li <xiubli@redhat.com>
    ceph: print cluster fsid and client global_id in all debug logs

Xiubo Li <xiubli@redhat.com>
    ceph: rename _to_client() to _to_fs_client()

Xiubo Li <xiubli@redhat.com>
    libceph: add doutc and *_client debug macros support

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

Paolo Abeni <pabeni@redhat.com>
    mptcp: cleanup MPJ subflow list handling

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

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)

Jiangshan Yi <yijiangshan@kylinos.cn>
    serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_mid: Remove unneeded test for ->setup() presence

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

Norbert Szetei <norbert@doyensec.com>
    ALSA: seq: close a re-opened queue timer in the destructor

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

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vrr: require valid min/max vfreq for VRR

David Carlier <devnexen@gmail.com>
    media: aspeed: fix missing of_reserved_mem_device_release() on probe failure

Bryam Vargas <hexlabsecurity@proton.me>
    drm/virtio: bound EDID block reads to the response buffer

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Return proper error codes instead of -1

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: fix Tiled Display Topology ID size

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/virtio: use uninterruptible resv lock for plane updates

Christian König <christian.koenig@amd.com>
    dma-buf/drivers: make reserving a shared slot mandatory v4

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix buffer overflows in sideband chunk accumulation

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Rename __direct_map() to direct_map()

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Split out TDP MMU page fault handling

Chao Peng <chao.p.peng@linux.intel.com>
    KVM: Rename mmu_notifier_* to mmu_invalidate_*

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap SPTEs

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps

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

Bryam Vargas <hexlabsecurity@proton.me>
    net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid calling child->ops->dequeue(child) twice

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: tegra: do not call pinctrl for GPIO direction

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    treewide: rename pinctrl_gpio_direction_output_new()

Junrui Luo <moonafterrain@outlook.com>
    octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink

Dexuan Cui <decui@microsoft.com>
    net: mana: Validate the packet length reported by the NIC

Zihan Xi <xizh2024@lzu.edu.cn>
    net/sched: act_ct: preserve tc_skb_cb across defragmentation

Haoxiang Li <haoxiang_li2024@163.com>
    net: ixp4xx_hss: fix duplicate HDLC netdev allocation

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ipip: require CAP_NET_ADMIN in the device netns for changelink

Liu Jian <liujian56@huawei.com>
    net: Add helper function to parse netlink msg of ip_tunnel_encap

Thomas Gleixner <tglx@kernel.org>
    locking/rt: Fix the incorrect RCU protection in rt_spin_unlock()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: rename probe error labels

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix use-after-free on disconnect

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix firmware leak in async update

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    firmware_loader: introduce __free() cleanup hanler

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: make error counter atomic

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't increment hash_offset twice

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()

Souvik Banerjee <souvik@amlalabs.com>
    ovl: use linked upper dentry in copy-up tmpfile

Jann Horn <jannh@google.com>
    bpf,fork: wipe ->bpf_storage before bailouts that access it

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove XDomain from the bus without holding tb->lock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove service debugfs entries during unregister

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Update property.c function documentation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    thunderbolt: Remove usage of the deprecated ida_simple_xx() API

Fan Wu <fanwu01@zju.edu.cn>
    can: esd_usb: kill anchored URBs before freeing netdevs

Frank Jungclaus <frank.jungclaus@esd.eu>
    can/esd_usb2: Rename esd_usb2.c to esd_usb.c

Vincent Jardin <vjardin@free.fr>
    i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    i2c: imx: separate atomic, dma and non-dma use case

Ibrahim Hashimov <security@auditcode.ai>
    ksmbd: fix integer overflow in set_file_allocation_info()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: use kvzalloc() for megabyte buffer in simple fallocate

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: retain dead thread stats in TGID queries

Oleg Nesterov <oleg@redhat.com>
    taskstats: fill_stats_for_tgid: use for_each_thread()

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Detach the private data and chip info structures

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Remove unused irq field in struct dw_edma_chip

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: swp: Improve locking user experience

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: Fix spi_nor_try_unlock_all()

Maoyi Xie <maoyixie.tju@gmail.com>
    net: thunderbolt: Fix frags[] overflow by bounding frame_count

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Breno Leitao <leitao@debian.org>
    9p: skip nlink update in cacheless mode to fix WARN_ON

Michael Bommarito <michael.bommarito@gmail.com>
    ntfs3: validate split-point offset in indx_insert_into_buffer

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Undo critial modificatins to keep directory consistency

Pavel Skripkin <paskripkin@gmail.com>
    fs/ntfs3: Make ntfs_update_mftmirr return void

Tristan Madani <tristan@talencesecurity.com>
    selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()

Casey Schaufler <casey@schaufler-ca.com>
    lsm: infrastructure management of the sock security

Ondrej Mosnacek <omosnace@redhat.com>
    lsm: use default hook return value in call_int_hook()

Wasim Nazir <wasim.nazir@oss.qualcomm.com>
    remoteproc: qcom: Fix leak when custom dump_segments addition fails

Yogesh Lal <quic_ylal@quicinc.com>
    remoteproc: qcom: pas: Adjust the phys addr wrt the mem region

Mukesh Ojha <quic_mojha@quicinc.com>
    remoteproc: qcom: fix sparse warnings

Mukesh Ojha <quic_mojha@quicinc.com>
    remoteproc: qcom: replace kstrdup with kstrndup

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_sip: validate skb_dst() before accessing it

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: remove net variable shadowing

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: move prove_locking helper around

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: use GFP_KERNEL for insertions

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8192: Check runtime resume during probe

Tang Bin <tangbin@cmss.chinamobile.com>
    ASoC: mediatek: mt8192-afe-pcm: Simplify probe() with local dev variable

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: Use common mtk_afe_pcm_platform with common probe cb

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8192-afe-pcm: Simplify with dev_err_probe()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8192-afe-pcm: Convert to devm_pm_runtime_enable()

Haoze Xie <royenheart@gmail.com>
    netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst

Eric Dumazet <edumazet@google.com>
    ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]

Eric Dumazet <edumazet@google.com>
    net: dst: add four helpers to annotate data-races around dst->dev

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->output

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->input

Eric Dumazet <edumazet@google.com>
    tcp: convert to dev_net_rcu()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8183: Check runtime resume during probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-vf: clear stale mailbox IRQ state before request_irq()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-pf: clear stale mailbox IRQ state before request_irq()

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2: Annotate mmio regions as __iomem

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix APR entry mapping based on APR_LMT_CFG

Jason Wang <jasowang@redhat.com>
    VDUSE: avoid leaking information to userspace

Eugenio Pérez <eperezma@redhat.com>
    vduse: take out allocations from vduse_dev_alloc_coherent

Eugenio Pérez <eperezma@redhat.com>
    vduse: remove unused vaddr parameter of vduse_domain_free_coherent

Sheng Zhao <sheng.zhao@bytedance.com>
    vduse: Use fixed 4KB bounce pages for non-4KB page size

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum: On port enslavement to a LAG, join upper's bridges

Li Xiasong <lixiasong1@huawei.com>
    tipc: restrict socket queue dumps in enqueue tracepoints

Jiacheng Yu <yujiacheng3@huawei.com>
    fbcon: Use correct type for vc_resize() return value

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Rename struct fbcon_ops to struct fbcon_par

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

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda: conexant: Remove mic bias threshold override

Bryam Vargas <hexlabsecurity@proton.me>
    Input: mms114 - reject an oversized device packet size

Haoxiang Li <haoxiang_li2024@163.com>
    i2c: davinci: Unregister cpufreq notifier on probe failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: mms114 - fix touch indexing for MMS134S and MMS136

Sebastian Alba Vives <sebasjosue84@gmail.com>
    fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning

Jason Gunthorpe <jgg@ziepe.ca>
    udmabuf: Do not create malformed scatterlists

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uninitialized

Weinan Liu <wnliu@google.com>
    iommu/amd: Don't split flush for amd_iommu_domain_flush_all()

Pedro Falcato <pfalcato@suse.de>
    mm: do file ownership checks with the proper mount idmap

Xiang Mei <xmei5@asu.edu>
    net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot

Christoph Hellwig <hch@lst.de>
    xfs: check v5 superblock features early

Long Li <leo.lilong@huawei.com>
    xfs: fix ilock leak on error in xfs_dq_get_next_id

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

Kefu Chai <k.chai@proxmox.com>
    libceph: tolerate addrvecs with multiple entries of the same type

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

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-wsa-macro: Fix enum kcontrol accesses

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

Zhan Xusheng <zhanxusheng@xiaomi.com>
    fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization

Fullway Wang <fullwaywang@outlook.com>
    media: mtk-vcodec: potential null pointer deference in SCP

Chao Yu <chao@kernel.org>
    f2fs: fix UAF issue in f2fs_merge_page_bio()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   2 +
 arch/arm64/kvm/mmu.c                               |  10 +-
 arch/mips/kvm/mmu.c                                |  12 +-
 arch/openrisc/include/asm/processor.h              |   2 +
 arch/openrisc/kernel/signal.c                      |   5 +-
 arch/powerpc/include/asm/kvm_book3s_64.h           |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   6 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   2 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   8 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |   4 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |   2 +-
 arch/powerpc/platforms/pseries/pci.c               |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  12 +-
 arch/x86/kvm/mmu/mmu.c                             | 154 ++++--
 arch/x86/kvm/mmu/paging_tmpl.h                     |   6 +-
 crypto/ccm.c                                       |   2 +-
 drivers/char/tpm/tpm_tis_core.c                    |  38 +-
 drivers/crypto/qce/core.c                          |   2 +-
 drivers/dma-buf/dma-resv.c                         |  10 +-
 drivers/dma-buf/udmabuf.c                          |  21 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  90 ++--
 drivers/dma/dw-edma/dw-edma-core.h                 |  33 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |  83 ++--
 drivers/dma/dw-edma/dw-edma-v0-core.c              |  38 +-
 drivers/dma/dw-edma/dw-edma-v0-core.h              |   4 +-
 drivers/dma/dw-edma/dw-edma-v0-debugfs.c           |  18 +-
 drivers/dma/dw-edma/dw-edma-v0-debugfs.h           |   8 +-
 drivers/fpga/dfl-afu-main.c                        |   3 +
 drivers/gpio/gpio-mvebu.c                          |   4 +-
 drivers/gpio/gpio-pxa.c                            |   4 +-
 drivers/gpio/gpio-rockchip.c                       |   4 +-
 drivers/gpio/gpio-tegra.c                          |  18 +-
 drivers/gpio/gpio-vf610.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  21 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  17 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |  26 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  14 +-
 drivers/gpu/drm/drm_connector.c                    |  12 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  32 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   2 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |  12 +-
 drivers/gpu/drm/i915/display/intel_vrr.c           |   4 +
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   4 +-
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
 drivers/gpu/drm/virtio/virtgpu_gem.c               |  28 ++
 drivers/gpu/drm/virtio/virtgpu_plane.c             |  10 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cotable.c            |   4 +
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  11 +-
 drivers/i2c/busses/i2c-davinci.c                   |   4 +-
 drivers/i2c/busses/i2c-imx.c                       | 135 ++++--
 drivers/input/joystick/iforce/iforce-packets.c     |  11 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   3 +
 drivers/input/joystick/psxpad-spi.c                |   1 +
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/ims-pcu.c                       |   5 +-
 drivers/input/mouse/focaltech.c                    |   2 +-
 drivers/input/rmi4/rmi_f54.c                       |  43 +-
 drivers/input/rmi4/rmi_f55.c                       |   4 +-
 drivers/input/touchscreen/mms114.c                 |  21 +-
 drivers/input/touchscreen/sur40.c                  |  23 +-
 drivers/iommu/amd/iommu.c                          |   3 +-
 drivers/md/dm-integrity.c                          |   4 -
 drivers/md/dm-verity-target.c                      |  12 +-
 drivers/md/dm-verity.h                             |   2 +-
 drivers/media/i2c/imx219.c                         |  47 +-
 drivers/media/platform/aspeed-video.c              |   1 +
 drivers/media/platform/marvell-ccic/cafe-driver.c  |   1 +
 .../media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c  |   5 +
 drivers/media/v4l2-core/v4l2-async.c               |   8 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   6 +-
 drivers/mmc/host/atmel-mci.c                       |   2 +
 drivers/mmc/host/omap_hsmmc.c                      |   2 +-
 drivers/mmc/host/sdhci.c                           |  16 +
 drivers/mmc/host/sdhci.h                           |   2 +-
 drivers/mmc/host/vub300.c                          |  36 +-
 drivers/mtd/maps/vmu-flash.c                       |   8 +-
 drivers/mtd/spi-nor/swp.c                          |  30 +-
 drivers/net/can/usb/Kconfig                        |  15 +-
 drivers/net/can/usb/Makefile                       |   2 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c}      |   5 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  25 +
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  48 ++
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  18 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  14 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  92 +++-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  13 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +
 drivers/net/ipa/ipa_smp2p.c                        |  30 +-
 drivers/net/thunderbolt.c                          |   8 +-
 drivers/net/wan/ixp4xx_hss.c                       |   4 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  45 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   4 +-
 drivers/pinctrl/cirrus/pinctrl-lochnagar.c         |   2 +-
 drivers/pinctrl/core.c                             |  15 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   4 +-
 drivers/pinctrl/intel/pinctrl-lynxpoint.c          |   4 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |   4 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   4 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   4 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c          |   4 +-
 drivers/pinctrl/pinctrl-as3722.c                   |   4 +-
 drivers/pinctrl/pinctrl-axp209.c                   |   2 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |  11 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |   4 +-
 drivers/pinctrl/pinctrl-rk805.c                    |   4 +-
 drivers/pinctrl/pinctrl-st.c                       |   4 +-
 drivers/pinctrl/renesas/gpio.c                     |   4 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   4 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   4 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |   4 +-
 drivers/remoteproc/qcom_common.c                   |  31 +-
 drivers/remoteproc/qcom_common.h                   |   5 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  20 +-
 drivers/s390/cio/vfio_ccw_cp.c                     |  17 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   5 +
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
 drivers/scsi/scsi_debug.c                          |  27 +-
 drivers/scsi/sd.h                                  |  27 +-
 drivers/scsi/sd_zbc.c                              | 126 +++--
 drivers/thunderbolt/domain.c                       |  36 +-
 drivers/thunderbolt/icm.c                          |   5 +
 drivers/thunderbolt/nhi.c                          |   6 +-
 drivers/thunderbolt/nvm.c                          |   4 +-
 drivers/thunderbolt/property.c                     |  38 +-
 drivers/thunderbolt/switch.c                       |  20 +-
 drivers/thunderbolt/tb.c                           |  58 +--
 drivers/thunderbolt/tb.h                           |   2 +
 drivers/thunderbolt/xdomain.c                      |  96 ++--
 drivers/tty/serial/8250/8250_mid.c                 |   6 +-
 drivers/tty/serial/max310x.c                       |  20 +-
 drivers/tty/serial/sc16is7xx.c                     | 192 ++++++--
 drivers/usb/gadget/function/f_tcm.c                | 192 ++++++--
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  91 ++--
 drivers/vdpa/vdpa_user/iova_domain.h               |  13 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  16 +-
 drivers/video/fbdev/core/bitblit.c                 | 120 ++---
 drivers/video/fbdev/core/fbcon.c                   | 413 ++++++++--------
 drivers/video/fbdev/core/fbcon.h                   |   6 +-
 drivers/video/fbdev/core/fbcon_ccw.c               | 146 +++---
 drivers/video/fbdev/core/fbcon_cw.c                | 146 +++---
 drivers/video/fbdev/core/fbcon_rotate.c            |  44 +-
 drivers/video/fbdev/core/fbcon_rotate.h            |   6 +-
 drivers/video/fbdev/core/fbcon_ud.c                | 162 +++----
 drivers/video/fbdev/core/softcursor.c              |  18 +-
 drivers/video/fbdev/core/tileblit.c                |  28 +-
 fs/9p/vfs_inode.c                                  |   9 +
 fs/binfmt_elf.c                                    |   4 +-
 fs/binfmt_elf_fdpic.c                              |   4 +-
 fs/binfmt_misc.c                                   |  14 +-
 fs/ceph/acl.c                                      |   6 +-
 fs/ceph/addr.c                                     |  20 +-
 fs/ceph/cache.c                                    |   2 +-
 fs/ceph/caps.c                                     |  53 ++-
 fs/ceph/dir.c                                      |  20 +-
 fs/ceph/export.c                                   |  10 +-
 fs/ceph/file.c                                     |  42 +-
 fs/ceph/inode.c                                    |  14 +-
 fs/ceph/ioctl.c                                    |   8 +-
 fs/ceph/mds_client.c                               |  11 +
 fs/ceph/mds_client.h                               |   2 +
 fs/ceph/mdsmap.c                                   |   2 +-
 fs/ceph/metric.c                                   |   5 +-
 fs/ceph/snap.c                                     |   2 +-
 fs/ceph/super.c                                    |  22 +-
 fs/ceph/super.h                                    |  14 +-
 fs/ceph/xattr.c                                    |  12 +-
 fs/cifs/smb2ops.c                                  |   4 +-
 fs/crypto/policy.c                                 |   2 +-
 fs/exec.c                                          |   6 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/ksmbd/auth.c                                    |   4 +-
 fs/ksmbd/connection.c                              |  23 +-
 fs/ksmbd/connection.h                              |   5 +
 fs/ksmbd/oplock.c                                  |   8 +-
 fs/ksmbd/smb2pdu.c                                 | 102 ++--
 fs/ksmbd/smb2pdu.h                                 |   9 -
 fs/ksmbd/smb_common.c                              |  43 +-
 fs/ksmbd/smb_common.h                              |   9 +
 fs/namei.c                                         |  43 ++
 fs/ntfs3/fsntfs.c                                  |  20 +-
 fs/ntfs3/index.c                                   |  44 +-
 fs/ntfs3/ntfs_fs.h                                 |   2 +-
 fs/overlayfs/copy_up.c                             |  14 +-
 fs/super.c                                         |  19 +-
 fs/xfs/libxfs/xfs_sb.c                             |   4 +-
 fs/xfs/xfs_dquot.c                                 |   3 +-
 include/drm/drm_connector.h                        |   6 +-
 include/drm/drm_displayid.h                        |   2 +-
 include/linux/audit.h                              |  18 +-
 include/linux/bootconfig.h                         |   3 +
 include/linux/bpf_lsm.h                            |   4 +
 include/linux/ceph/ceph_debug.h                    |  38 ++
 include/linux/dma-resv.h                           |   2 +-
 include/linux/dma/edma.h                           |  50 +-
 include/linux/firmware.h                           |   3 +
 include/linux/fs.h                                 |  33 ++
 include/linux/ip.h                                 |  21 +
 include/linux/jiffies.h                            |  13 +
 include/linux/kvm_host.h                           |  60 +--
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/mmc/sdio_ids.h                       |   2 +-
 include/linux/namei.h                              |   1 +
 include/linux/pinctrl/consumer.h                   |  13 +-
 include/linux/thunderbolt.h                        |   3 +
 include/media/v4l2-async.h                         |   8 +-
 include/net/dst.h                                  |  24 +-
 include/net/inet6_hashtables.h                     |   2 +-
 include/net/inet_hashtables.h                      |   2 +-
 include/net/ip.h                                   |  11 +-
 include/net/ip_tunnels.h                           |   3 +
 include/net/ip_vs.h                                |   7 +
 include/net/lwtunnel.h                             |   8 +-
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/route.h                                |   5 +-
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
 kernel/fork.c                                      |  21 +-
 kernel/locking/spinlock_rt.c                       |  27 +-
 kernel/sched/psi.c                                 |   6 +
 kernel/taskstats.c                                 |  67 +--
 kernel/trace/ftrace.c                              |  21 +-
 lib/bootconfig.c                                   |  65 +++
 lib/compat_audit.c                                 |  12 +-
 mm/madvise.c                                       |   3 +-
 mm/memory_hotplug.c                                |  15 +-
 mm/mincore.c                                       |   3 +-
 mm/pagewalk.c                                      |   8 +
 mm/ptdump.c                                        |   7 +
 net/bluetooth/hci_event.c                          |   2 -
 net/ceph/cls_lock_client.c                         |  21 +-
 net/ceph/decode.c                                  |  18 +-
 net/ceph/osdmap.c                                  |   9 +-
 net/core/dst.c                                     |   8 +-
 net/core/pktgen.c                                  |  43 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/icmp.c                                    |  24 +-
 net/ipv4/igmp.c                                    |   2 +-
 net/ipv4/ip_fragment.c                             |   2 +-
 net/ipv4/ip_output.c                               |   4 +-
 net/ipv4/ip_tunnel_core.c                          |  35 ++
 net/ipv4/ip_vti.c                                  |   4 +-
 net/ipv4/ipip.c                                    |  41 +-
 net/ipv4/netfilter.c                               |   4 +-
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/tcp_fastopen.c                            |   4 +-
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_metrics.c                             |   8 +-
 net/ipv4/xfrm4_output.c                            |   2 +-
 net/ipv6/ip6_tunnel.c                              |  40 +-
 net/ipv6/sit.c                                     |  38 +-
 net/ipv6/tcp_ipv6.c                                |  10 +-
 net/mptcp/options.c                                |   8 +-
 net/mptcp/pm_netlink.c                             |   4 -
 net/mptcp/protocol.c                               | 127 +++--
 net/mptcp/protocol.h                               |  29 +-
 net/mptcp/sockopt.c                                |  24 +-
 net/mptcp/subflow.c                                |  17 +-
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
 net/netfilter/nf_queue.c                           |  14 +
 net/netfilter/nf_tables_offload.c                  |   2 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +
 net/netfilter/nft_set_pipapo.c                     | 260 ++++++----
 net/netfilter/nft_set_pipapo.h                     |   8 +
 net/openvswitch/conntrack.c                        |  39 +-
 net/packet/af_packet.c                             |   7 +-
 net/rxrpc/call_accept.c                            |  27 +-
 net/sched/act_ct.c                                 |  41 +-
 net/sched/sch_api.c                                |  24 +-
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_taprio.c                             |  12 +-
 net/sctp/protocol.c                                |  20 +-
 net/sctp/sysctl.c                                  |   9 +-
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_rx.c                                   |  12 +-
 net/smc/smc_tx.c                                   |  17 +-
 net/tipc/socket.c                                  |   6 +-
 net/x25/af_x25.c                                   |   4 +-
 net/x25/x25_timer.c                                |  25 +-
 net/xfrm/espintcp.c                                |  32 +-
 security/apparmor/include/net.h                    |   6 +-
 security/apparmor/lsm.c                            |  38 +-
 security/bpf/hooks.c                               |   3 +
 security/security.c                                | 530 +++++++++++++--------
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
 sound/pci/hda/patch_conexant.c                     |   3 -
 sound/soc/codecs/cs4265.c                          |   4 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |   8 +-
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  12 +-
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         | 118 ++---
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  10 +-
 virt/kvm/kvm_main.c                                |  49 +-
 358 files changed, 4765 insertions(+), 2894 deletions(-)


