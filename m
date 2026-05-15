Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6D2305672;
	Fri, 15 May 2026 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860653; cv=none; b=lo8Z0f+99rVPs+tfZeHKs/j9N66cp4HmlyYQG3uBaD4eVgevEo2rgVhM/QS4U8g5mGpNXbbvmTLJIvXJP2Fxp+qrZH12cCNHVlXe0Xt+QQPqJN9SztYM5JgyyRZPq+3EJu3iGS8CRyvZIanqY/j1G9LqKmeaxVt2tv8WihN7IHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860653; c=relaxed/simple;
	bh=9yEE7fr7W8g2iEdB3ajTB6Yh/B0joebA2ii5I8ns9GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ADuLMszgkiGuDZAmlm5UOZPrHAOWlfhVKj4y/3uWtCyHNMZTmTCUnVtNP9RNR4G66N6VMSAS0aB1Hu80UYKk1uJ/7iuqGB317yEtlIDjVsraxa8hF4vHGE3sWjdpYoQ6txjh8uUObxvBV5VjGIHkGyEuaX+VLNiuXoO5XhGFsao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjedPMR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjedPMR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E192C2BCB0;
	Fri, 15 May 2026 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860652;
	bh=9yEE7fr7W8g2iEdB3ajTB6Yh/B0joebA2ii5I8ns9GQ=;
	h=From:To:Cc:Subject:Date:From;
	b=TjedPMR2JP80II8oAnif6cryVXH6uiUJZ97frdjAq6m1/NsMNlq9RbBVykCJN0D4i
	 qogNuKUGgZNdLDp6FXNrnMjdCBV/V/GZ5tcl8kGMeKfeiw5l4P/iluL4GA30PZ60Qu
	 wSq60QQIz6Bh5JkmBFOoalvVbwORZEZYLUrWNfVs=
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
Subject: [PATCH 6.6 000/474] 6.6.140-rc1 review
Date: Fri, 15 May 2026 17:41:49 +0200
Message-ID: <20260515154715.053014143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.140-rc1
X-KernelTest-Deadline: 2026-05-17T15:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.140 release.
There are 474 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.140-rc1

Bjoern Doebel <doebel@amazon.de>
    smb: client: use kzalloc to zero-initialize security descriptor buffer

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: nx - fix context leak in nx842_crypto_free_ctx

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    Bluetooth: MGMT: Fix memory leak in set_ssp_complete

Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
    mtd: spi-nor: sst: Fix SST write failure

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Avoid overflow on msg bound check

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn3: Avoid overflow on msg bound check

Eric Dumazet <edumazet@google.com>
    vsock/virtio: fix potential unbounded skb queue

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix length and offset in tap skb for split packets

Dudu Lu <phx0fer@gmail.com>
    vsock/virtio: fix accept queue count leak on transport mismatch

Norbert Szetei <norbert@doyensec.com>
    vsock: fix buffer size clamping order

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Wake-up from WFI when iqrchip is in userspace

Max Kellermann <max.kellermann@ionos.com>
    ceph: only d_add() negative dentries when they are unhashed

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Move GUID programming after PHY initialization

Steven Rostedt <rostedt@goodmis.org>
    tracing/probes: Limit size of event probe to 3K

Yochai Eisenrich <yochaie@sweet.security>
    btrfs: fix btrfs_ioctl_space_info() slot_count TOCTOU which can lead to info-leak

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: fix tp_num leak on kmalloc failure

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: stop tp_meter sessions during mesh teardown

Viorel Suman (OSS) <viorel.suman@oss.nxp.com>
    pwm: imx-tpm: Count the number of enabled channels in probe

Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
    mtd: spi-nor: sst: Fix write enable before AAI sequence

Bence Csókás <csokas.bence@prolan.hu>
    mtd: spi-nor: sst: Factor out common write operation to `sst_nor_write_data()`

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger

SeongJae Park <sj@kernel.org>
    mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: reset internal port states on soft reset AMS

SeongJae Park <sj@kernel.org>
    mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values

SeongJae Park <sj@kernel.org>
    mm/damon/core: implement damon_kdamond_pid()

Hyunwoo Kim <imv4bel@gmail.com>
    rxrpc: Also unshare DATA/RESPONSE packets when paged frags are present

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow time-quota setting zero esz

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix use-after-free due to enslave fail after slave array update

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()

David Howells <dhowells@redhat.com>
    rxrpc: Fix conn-level packet handling to unshare RESPONSE packets

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Avoid OOB font access if console rotation fails

Johan Hovold <johan@kernel.org>
    spi: microchip-core-qspi: fix controller deregistration

Li Zetao <lizetao1@huawei.com>
    spi: microchip-core-qspi: Use helper function devm_clk_get_enabled()

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/hugetlb_cma: round up per_node before logging it

Johan Hovold <johan@kernel.org>
    spi: uniphier: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: uniphier: Simplify clock handling with devm_clk_get_enabled()

Yang Yingliang <yangyingliang@huawei.com>
    spi: uniphier: switch to use modern name

Johan Hovold <johan@kernel.org>
    spi: tegra20-sflash: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: tegra114: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sun6i: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: sun6i: switch to use modern name

Johan Hovold <johan@kernel.org>
    spi: zynq-qspi: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: zynq-qspi: Simplify clock handling with devm_clk_get_enabled()

Yang Yingliang <yangyingliang@huawei.com>
    spi: zynq-qspi: switch to use modern name

Johan Hovold <johan@kernel.org>
    spi: ti-qspi: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: spi-ti-qspi: switch to use modern name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: spi-ti-qspi: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    spi: sun4i: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: sun4i: switch to use modern name

Johan Hovold <johan@kernel.org>
    spi: syncuacer: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: synquacer: switch to use modern name

David Carlier <devnexen@gmail.com>
    Bluetooth: hci_conn: fix potential UAF in create_big_sync

Michal Kosiorek <mkosiorek121@gmail.com>
    xfrm: defensively unhash xfrm_state lists in __xfrm_state_delete

Michael Bommarito <michael.bommarito@gmail.com>
    xfrm: ah: account for ESN high bits in async callbacks

Eric Biggers <ebiggers@google.com>
    net: ipv6: stop checking crypto_ahash_alignmask

Eric Biggers <ebiggers@google.com>
    net: ipv4: stop checking crypto_ahash_alignmask

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: Fix UMP group 16 filtering

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Notify client and port info changes

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Serialize deferred fasync state checks

Takashi Iwai <tiwai@suse.de>
    ALSA: misc: Use guard() for spin locks

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda: cs35l56: Propagate ASP TX source control errors

David Carlier <devnexen@gmail.com>
    tracepoint: balance regfunc() on func_add() failure in tracepoint_add_func()

Sam Edwards <cfsworks@gmail.com>
    net: stmmac: Prevent NULL deref when RX memory exhausted

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: rename STMMAC_GET_ENTRY() -> STMMAC_NEXT_ENTRY()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: avoid shadowing global buf_sz

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: caam - guard HMAC key hex dumps in hash_digest_key

Thorsten Blum <thorsten.blum@linux.dev>
    printk: add print_hex_dump_devel()

Junrui Luo <moonafterrain@outlook.com>
    erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx

Ard Biesheuvel <ardb@kernel.org>
    crypto: nx - Migrate to scomp API

Gustavo A. R. Silva <gustavoars@kernel.org>
    crypto: nx - Avoid -Wflex-array-member-not-at-end warning

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()

Yi Cong <yicong@kylinos.cn>
    wifi: rtl8xxxu: fix potential use of uninitialized value

Zilin Guan <zilin@seu.edu.cn>
    hfsplus: fix held lock freed on hfsplus_fill_super()

Deepanshu Kartikey <kartikey406@gmail.com>
    hfsplus: fix uninit-value by validating catalog record size

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a resource leak in xfs_alloc_buftarg()

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs

Seohyeon Maeng <bioloidgp@gmail.com>
    udf: fix partition descriptor append bookkeeping

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not unregister platform device

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: defio: Disconnect deferred I/O from the lifetime of struct fb_info

Johan Hovold <johan@kernel.org>
    spi: fix resource leaks on device setup failure

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the total number of nodes

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum number of lookups

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum server registration per node

Zhengchuan Liang <zcliangcn@gmail.com>
    net: bridge: use a stable FDB dst snapshot in RCU readers

Yuan Zhaoming <yuanzm2@lenovo.com>
    net: mctp: fix don't require received header reserved bits to be zero

Long Li <longli@microsoft.com>
    RDMA/mana_ib: Disable RX steering on RSS QP destroy

Joseph Salisbury <joseph.salisbury@oracle.com>
    sched: Use u64 for bandwidth ratio calculations

Naman Jain <namjain@linux.microsoft.com>
    block: relax pgmap check in bio_add_page for compatible zone device pages

Oliver Neukum <oneukum@suse.com>
    media: rc: igorplugusb: heed coherency rules

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: aoa: Skip devices with no codecs in i2sbus_resume()

Oliver Neukum <oneukum@suse.com>
    media: rc: ttusbir: respect DMA coherency rules

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: clear stale prepared state

Takashi Iwai <tiwai@suse.de>
    ALSA: aoa: Use guard() for mutex locks

Corey Minyard <corey@minyard.net>
    ipmi:ssif: Clean up kthread on errors

Corey Minyard <corey@minyard.net>
    ipmi:ssif: Fix a shutdown race

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone governor cleanup issues

Daniel Hodges <git@danielhodges.dev>
    PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: fix mt7925u USB WFSYS reset handling

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: describe USB WFSYS reset with a descriptor

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: connac: introduce helper for mt7925 chipset

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Enable batched TLB flush in unmap_hotplug_range()

Alistair Popple <apopple@nvidia.com>
    lib: test_hmm: evict device pages on file close to avoid use-after-free

Daniel Hodges <git@danielhodges.dev>
    wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on dcc->discard_cmd_cnt conditionally

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: replace connection list with hash table

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use msleep instaed of schedule_timeout_interruptible()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: validate the whole DACL before rewriting it in cifsacl

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: require minimum ACE size in smb_check_perm_dacl()

Namjae Jeon <linkinjeon@kernel.org>
    smb: common: change the data type of num_aces to le16

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move some duplicate definitions to common/smbacl.h

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: put backbone reference on failed claim hash insert

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: only purge non-released claims

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent use-after-free when deleting claims

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: stop caching unowned originator pointers in BAT IV

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: reject new tp_meter sessions during teardown

Lyes Bourennani <lbourennani@fuzzinglabs.com>
    batman-adv: fix integer overflow on buff_pos

Ben Morris <bmorris@anthropic.com>
    sctp: revalidate list cursor after sctp_sendmsg_to_asoc() in SCTP_SENDALL

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: align Hawaii mclk workaround with radeon

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: add missing revision check for CI

John B. Moore <jbmoore61@gmail.com>
    drm/amdgpu/sdma4: replace BUG_ON with WARN_ON in fence emission

John B. Moore <jbmoore61@gmail.com>
    drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: zero-initialize GART table on allocation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing revision check for CI

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: validate SVM ioctl nattr against buffer size

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn3: Prevent OOB reads when parsing dec msg

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vce: Prevent partial address patches

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Prevent OOB reads when parsing IB

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu: Add bounds checking to ib_{get,set}_value

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: Add upper bound check for num_of_nodes

Amir Shetaia <Amir.Shetaia@amd.com>
    drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure

Johan Hovold <johan@kernel.org>
    spi: cadence: fix unclocked access on unbind

Johan Hovold <johan@kernel.org>
    spi: cadence: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    spi: orion: fix clock imbalance on registration failure

Johan Hovold <johan@kernel.org>
    spi: orion: fix runtime pm leak on unbind

Johan Hovold <johan@kernel.org>
    spi: imx: fix runtime pm leak on probe deferral

Johan Hovold <johan@kernel.org>
    spi: img-spfi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: rspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sprd: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: coldfire-qspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: bcmbca-hsspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: fsl: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sh-hspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mtk-nor: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: omap2-mcspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: fsl-espi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: s3c64xx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: dln2: fix controller deregistration

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: omap3isp: drop the use count of v4l2 pipeline

Matthias Fend <matthias.fend@emfend.at>
    media: i2c: ov08d10: fix image vertical start setting

Michael Tretter <m.tretter@pengutronix.de>
    media: staging: imx: request mbus_config in csi_start

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: i2c: imx412: Assert reset GPIO during probe

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    media: dib8000: avoid division by 0 in dib8000_set_dds()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    media: pci: zoran: fix potential memory leak in zoran_probe()

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Ignore backlight and FnLock events

Wang Jun <1742789905@qq.com>
    media: saa7164: add ioremap return checks and cleanups

Johan Hovold <johan@kernel.org>
    spi: at91-usart: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: qup: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: lantiq-ssc: fix controller deregistration

Johan Hovold <johan@kernel.org>
    regulator: bd9571mwv: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: act8945a: fix OF node reference imbalance

Janne Grunau <j@jannau.net>
    media: videobuf2: Set vma_flags in vb2_dma_sg_mmap

Johan Hovold <johan@kernel.org>
    regulator: rk808: fix OF node reference imbalance

Oliver Neukum <oneukum@suse.com>
    media: rc: streamzap: Error handling in probe

Oliver Neukum <oneukum@suse.com>
    media: rc: xbox_remote: heed DMA restrictions

Johan Hovold <johan@kernel.org>
    regulator: max77650: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: mt6357: fix OF node reference imbalance

Sakari Ailus <sakari.ailus@linux.intel.com>
    staging: media: atomisp: Disallow all private IOCTLs

Johan Hovold <johan@kernel.org>
    spi: atmel: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: bcm63xx: fix controller deregistration

Alexander Koskovich <akoskovich@pm.me>
    media: i2c: ov8856: free control handler on error in ov8856_init_controls()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Enable VB2_DMABUF for metadata stream

T.J. Mercier <tjmercier@google.com>
    HID: playstation: Clamp num_touch_reports

Paul E. McKenney <paulmck@kernel.org>
    exit: Sleep at TASK_IDLE when waiting for application core dump

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use per-root-bridge PCIH flag to skip mem resource fixup

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Fix potential ADE in loongson_gpu_fixup_dma_hang()

Quentin Perret <qperret@google.com>
    KVM: arm64: Fix initialisation order in __pkvm_init_finalise()

David Woodhouse <dwmw@amazon.co.uk>
    KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix node_cnt race between extent node destroy and writeback

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fiemap boundary handling when read extent cache is incomplete

Cen Zhang <zzzccc427@gmail.com>
    f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()

Gang Yan <yangang@kylinos.cn>
    mptcp: fix scheduling with atomic in timestamp sockopt

Gang Yan <yangang@kylinos.cn>
    mptcp: sockopt: set timestamp flags on subflow socket, not msk

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: use MPTCP_RST_EMPTCP for ACK HMAC validation failure

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: use MPJoinSynAckHMacFailure for SynAck HMAC failure

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fastclose msk when linger time is 0

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: Reject unknown opcodes before ICRC processing

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: Reject non-8-byte ATOMIC_WRITE payloads

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ocrdma: Don't NULL deref uctx on errors in ocrdma_copy_pd_uresp()

Junrui Luo <moonafterrain@outlook.com>
    RDMA/mlx5: Fix error path fall-through in mlx5_ib_dev_res_srq_init()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()

André Draszik <andre.draszik@linaro.org>
    power: supply: max17042: avoid overflow when determining health

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Stop ruling out unbound devices as error source

Shuai Xue <xueshuai@linux.alibaba.com>
    PCI/AER: Clear only error bits in PCIe Device Status

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: check for nEPT/nNPT in slow flush hypercalls

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: validate dacloffset before building DACL pointers

Zisen Ye <zisenye@stu.xidian.edu.cn>
    smb/client: fix out-of-bounds read in symlink_data()

Zisen Ye <zisenye@stu.xidian.edu.cn>
    smb/client: fix out-of-bounds read in smb2_compound_op()

Vasily Gorbik <gor@linux.ibm.com>
    s390/debug: Reject zero-length input in debug_input_flush_fn()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/hns: Fix unlocked call to hns_roce_qp_remove()

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: vport: fix self-deadlock on release of tunnel ports

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet: avoid recursive nvmet-wq flush in nvmet_ctrl_free

Fedor Pchelkin <pchelkin@ispras.ru>
    nvme-apple: drop invalid put of admin queue reference count

Junrui Luo <moonafterrain@outlook.com>
    md/raid10: fix divide-by-zero in setup_geo() with zero far_copies

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix slab-out-of-bounds access in auth message processing

Christian A. Ehrhardt <lk@c--e.de>
    lib/scatterlist: fix temp buffer in extract_user_to_sg()

Christian A. Ehrhardt <lk@c--e.de>
    lib/scatterlist: fix length calculations in extract_kvec_to_sg

Lukas Wunner <lukas@wunner.de>
    lib/crypto: mpi: Fix integer underflow in mpi_read_raw_from_sgl()

Michael Bommarito <michael.bommarito@gmail.com>
    isofs: validate block number from NFS file handle in isofs_export_iget

Michael Bommarito <michael.bommarito@gmail.com>
    isofs: validate Rock Ridge CE continuation extent against volume size

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: correctly reject too-small hash devices

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: correctly reject too-small FEC devices

David Carlier <devnexen@gmail.com>
    eventfs: Hold eventfs_mutex and SRCU when remount walks events

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix a buffer overflow in ioctl processing

Mikulas Patocka <mpatocka@redhat.com>
    dm: don't report warning when doing deferred remove

Mikulas Patocka <mpatocka@redhat.com>
    dm-thin: fix metadata refcount underflow

Guangshuo Li <lgs201920130244@gmail.com>
    btrfs: fix double free in create_space_info() error path

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: remove child devices when apm is removed

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm-dai: reset queue ptr on trigger stop

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: Intel: bytcr_wm5102: Fix MCLK leak on platform_clock_control error

Joseph Salisbury <joseph.salisbury@oracle.com>
    ASoC: fsl_easrc: fix comment typo

Tommaso Soncin <soncintommaso@gmail.com>
    ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table

Shrikanth Hegde <sshegde@linux.ibm.com>
    cpuidle: powerpc: avoid double clear when breaking snooze

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs-ccc: fix out of bounds access during output registration

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    clk: imx: imx8-acm: fix flags for acm clocks

Johan Hovold <johan@kernel.org>
    spi: topcliff-pch: fix use-after-free on unbind

Thorsten Blum <thorsten.blum@linux.dev>
    thermal/drivers/sprd: Fix raw temperature clamping in sprd_thm_rawdata_to_temp

Thorsten Blum <thorsten.blum@linux.dev>
    thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata

Michael Bommarito <michael.bommarito@gmail.com>
    udf: reject descriptors with oversized CRC length

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: Disable GSO for packets with small MSS

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    hv_sock: fix ARM64 support

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: of: clear OF_POPULATED on hog nodes in remove path

Xu Yang <xu.yang_2@nxp.com>
    extcon: ptn5150: handle pending IRQ events during system resume

Shyam Prasad N <sprasad@microsoft.com>
    cifs: change_conf needs to be called for session setup

Shyam Prasad N <sprasad@microsoft.com>
    cifs: abort open_cached_dir if we don't request leases

Naman Jain <namjain@linux.microsoft.com>
    block: add pgmap check to biovec_phys_mergeable

Jiexun Wang <wangjiexun2025@gmail.com>
    af_unix: Reject SIOCATMARK on non-stream sockets

Myeonghun Pak <mhun512@gmail.com>
    hwmon: (corsair-psu) Close HID device on probe errors

Johan Hovold <johan@kernel.org>
    clk: rk808: fix OF node reference imbalance

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc2992) Fix u32 overflow in power read path

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc2992) Clamp threshold writes to hardware range

Hongling Zeng <zenghongling@kylinos.cn>
    parisc: Fix IRQ leak in LASI driver

Pavitra Jha <jhapavitra98@gmail.com>
    net: wwan: t7xx: validate port_count against message length in t7xx_port_enum_msg_handler

Nan Li <tonanli66@gmail.com>
    net/rds: handle zerocopy send cleanup before the message is queued

Maoyi Xie <maoyixie.tju@gmail.com>
    ip6_gre: Use cached t->net in ip6erspan_changelink().

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix VF illegal register access

SeungJu Cheon <suunj1331@gmail.com>
    sound: ua101: fix division by zero at probe

Kai Zen <kai.aizen.dev@gmail.com>
    net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo

Tudor Ambarus <tudor.ambarus@linaro.org>
    mtd: spi-nor: debugfs: fix out-of-bounds read in spi_nor_params_show()

Miklos Szeredi <mszeredi@redhat.com>
    fanotify: fix false positive on permission events

Johan Hovold <johan@kernel.org>
    staging: vme_user: fix root device leak on init failure

Johan Hovold <johan@kernel.org>
    spi: s3c64xx: fix NULL-deref on driver unbind

Johan Hovold <johan@kernel.org>
    spi: zynqmp-gqspi: fix controller deregistration

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix OOB read and infinite loop in hci_le_create_big_complete_evt

Michael Bommarito <michael.bommarito@gmail.com>
    Bluetooth: virtio_bt: validate rx pkt_type header length

Michael Bommarito <michael.bommarito@gmail.com>
    Bluetooth: virtio_bt: clamp rx length before skb_put

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: prune /sys/fs/selinux/disable

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: shrink critical section in sel_write_load()

David Windsor <dwindsor@gmail.com>
    selinux: don't reserve xattr slot when we won't fill it

Yilin Zhu <zylzyl2333@gmail.com>
    ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()

Ruijie Li <ruijieli51@gmail.com>
    xfrm: provide message size for XFRM_MSG_MAPPING

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kdump: fix KASAN sanitization flag for core_$(BITS).o

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: firewire-tascam: Do not drop unread control events

Felix Gu <ustc.gu@gmail.com>
    usb: ulpi: fix memory leak on ulpi_register() error paths

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910Cx compositions

Aaro Koskinen <aaro.koskinen@iki.fi>
    USB: omap_udc: DMA: Don't enable burst 4 mode

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Fix UAC3 cluster descriptor size check

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: midi2: Restart output URBs on resume

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: usblp: fix uninitialized heap leak via LPGETSTATUS ioctl

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: usblp: fix heap leak in IEEE 1284 device ID via short response

Marek Szyprowski <m.szyprowski@samsung.com>
    wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task

Tristan Madani <tristan@talencesecurity.com>
    wifi: b43: enforce bounds check on firmware key index in b43_rx()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove station if connection prep fails

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    wifi: ath5k: do not access array OOB

Jeongjun Park <aha310510@gmail.com>
    wifi: rsi: fix kthread lifetime race between self-exit and external-stop

Catherine <enderaoelyther@gmail.com>
    wifi: mac80211: drop stray 'static' from fast-RX rx_result

Tristan Madani <tristan@talencesecurity.com>
    wifi: b43legacy: enforce bounds check on firmware key index in RX path

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: fix ROC abort flow interruption in mt7921_roc_work

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7921: fix a potential clc buffer length underflow

Jann Horn <jannh@google.com>
    exit: prevent preemption of oopsing TASK_DEAD task

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Don't mark STACK_INVALID as STACK_MISC in mark_stack_slot_misc

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: validate fake register spill/fill precision backtracking logic

Andrii Nakryiko <andrii@kernel.org>
    bpf: handle fake register spill to stack with BPF_ST_MEM instruction

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: validate precision logic in partial_stack_load_preserves_zeros

Andrii Nakryiko <andrii@kernel.org>
    bpf: track aligned STACK_ZERO cases as imprecise spilled registers

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: validate zero preservation for sub-slot loads

Andrii Nakryiko <andrii@kernel.org>
    bpf: preserve constant zero when doing partial register restore

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: validate STACK_ZERO is preserved on subreg spill

Andrii Nakryiko <andrii@kernel.org>
    bpf: preserve STACK_ZERO slots on partial reg spills

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: add stack access precision test

Andrii Nakryiko <andrii@kernel.org>
    bpf: support non-r10 register spill/fill to/from stack in precision tracking

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_red: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: check validity of VMCB controls when returning from SMM

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix leaking event log memory

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix crash when the event log is disabled

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix RTNL assertion warning when remove module

Qingfang Deng <qingfang.deng@linux.dev>
    flow_dissector: do not dissect PPPoE PFC frames

Dong Chenchen <dongchenchen2@huawei.com>
    net: Fix icmp host relookup triggering ip_rt_bug

Ankit Soni <Ankit.Soni@amd.com>
    iommu/amd: serialize sequence allocation under concurrent TLB invalidations

Uros Bizjak <ubizjak@gmail.com>
    iommu/amd: Use atomic64_inc_return() in iommu.c

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected GFN

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets

Tejas Bharambe <tejas.bharambe@outlook.com>
    ext4: validate p_idx bounds in ext4_ext_correct_indexes

David Howells <dhowells@redhat.com>
    rxrpc: Fix potential UAF after skb_unshare() failure

Felix Gu <ustc.gu@gmail.com>
    spi: meson-spicc: Fix double-put in remove path

Rick Edgecombe <rick.p.edgecombe@intel.com>
    x86/shstk: Prevent deadlock during shstk sigreturn

Yussuf Khalil <dev@pp3345.net>
    drm/amd/display: Do not skip unrelated mode changes in DSC validation

Linus Torvalds <torvalds@linux-foundation.org>
    x86: shadow stacks: proper error handling for mmap lock

Johan Hovold <johan@kernel.org>
    spi: rockchip: fix controller deregistration

Mark Brown <broonie@kernel.org>
    ASoC: SOF: Don't allow pointer operations on unconfigured streams

Sina Hassani <sina@openai.com>
    iommufd: Fix a race with concurrent allocation and unmap

Shivam Kalra <shivamkalra98@zohomail.in>
    ACPI: video: force native backlight on HP OMEN 16 (8A44)

Jinjie Ruan <ruanjinjie@huawei.com>
    ACPI: CPPC: Fix related_cpus inconsistency during CPU hotplug

Guangshuo Li <lgs201920130244@gmail.com>
    ACPI: scan: Use acpi_dev_put() in object add error paths

Rajat Gupta <rajgupt@qti.qualcomm.com>
    fbdev: udlfb: add vm_ops to dlfb_ops_mmap to prevent use-after-free

Corey Minyard <corey@minyard.net>
    ipmi:si: Return state to normal if message allocation fails

Corey Minyard <corey@minyard.net>
    ipmi: Check event message buffer response for bad data

Corey Minyard <corey@minyard.net>
    ipmi: Add limits to event and receive message requests

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: target: configfs: Bound snprintf() return in tg_pt_gp_members_show()

Kai Ma <k4729.23098@gmail.com>
    netfilter: reject zero shift in nft_bitwise

Andrea Mayer <andrea.mayer@uniroma2.it>
    net: ipv6: fix NOREF dst use in seg6 and rpl lwtunnels

Deepanshu Kartikey <kartikey406@gmail.com>
    ALSA: caiaq: fix usb_dev refcount leak on probe failure

Arjan van de Ven <arjan@linux.intel.com>
    drm/amdgpu: fix zero-size GDS range init on RDNA4

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ipv6: rpl: reserve mac_len headroom when recompressed SRH grows

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Don't abort when no input device is available

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path

Douglas Anderson <dianders@chromium.org>
    driver core: Add kernel-doc for DEV_FLAG_COUNT enum value

Yucheng Lu <kanolyc@gmail.com>
    crypto: authencesn - reject short ahash digests during instance creation

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails

Keenan Dong <keenanat2000@gmail.com>
    rtmutex: Use waiter::task instead of current in remove_waiter()

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: fix integer overflow in run_unpack() volume boundary check

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: add buffer boundary checks to run_unpack()

Steven Rostedt <rostedt@goodmis.org>
    ktest: Fix the month in the name of the failure directory

Chen Zhao <chezhao@nvidia.com>
    IB/core: Fix zero dmac race in neighbor resolution

Junrui Luo <moonafterrain@outlook.com>
    dm mirror: fix integer overflow in create_dirty_log()

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - fix DMA sync direction

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    crypto: ccree - fix a memory leak in cc_mac_digest()

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: hisilicon - Fix dma_unmap_single() direction

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - Release client on allocation failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup

Eric Biggers <ebiggers@kernel.org>
    crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit

Johan Hovold <johan@kernel.org>
    can: ucan: fix devres lifetime

Shuvam Pandey <shuvampandey1@gmail.com>
    Bluetooth: hci_event: fix potential UAF in SSP passkey handlers

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: set version in TGID exit notifications

Zhenzhong Wu <jt26wzz@gmail.com>
    tcp: call sk_data_ready() after listener migration

Chia-Ming Chang <chiamingc@synology.com>
    inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails

Junrui Luo <moonafterrain@outlook.com>
    md/raid5: validate payload size before accessing journal metadata

Chia-Ming Chang <chiamingc@synology.com>
    md/raid5: fix soft lockup in retry_aligned_read()

Sohei Koyama <skoyama@ddn.com>
    ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: fix multishot recv missing EOF on wakeup race

James Kim <james010kim@gmail.com>
    mtd: docg3: fix use-after-free in docg3_release()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: docg3: Convert to platform remove callback returning void

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for nCR3 validity

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts

Kevin Cheng <chengkev@google.com>
    KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state

Sean Christopherson <seanjc@google.com>
    KVM: x86: Defer non-architectural deliver of exception payload to userspace read

Denis M. Karpov <komlomal@gmail.com>
    userfaultfd: allow registration of ranges below mmap_min_addr

SeongJae Park <sj@kernel.org>
    mm/damon/core: use time_in_range_open() for damos quota window start

Johan Hovold <johan@kernel.org>
    rtc: ntxec: fix OF node reference imbalance

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: stop transmit if retries are exhausted

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: add error logging for data transfer

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - rename first/last to first_desc/last_desc

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - fix SEC1 32k ahash request limitation

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration

Bin Liu <b-liu@ti.com>
    mmc: block: use single block write in retry

Ryan Roberts <ryan.roberts@arm.com>
    randomize_kstack: Maintain kstack_offset per task

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    power: supply: axp288_charger: Do not cancel work before initializing it

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Show CPU vulnerabilites correctly

Arnd Bergmann <arnd@arndb.de>
    tpm: avoid -Wunused-but-set-variable

Nathan Chancellor <nathan@kernel.org>
    extract-cert: Wrap key_pass with '#ifdef USE_PKCS11_ENGINE'

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()

Ruide Cao <caoruide123@gmail.com>
    ipv4: icmp: validate reply type before using icmp_pointers

hkbinbin <hkbinbinbin@gmail.com>
    RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/arcpgu: fix device node leak

Marek Vasut <marex@nabladev.com>
    net: ks8851: Avoid excess softirq scheduling

Marek Vasut <marex@nabladev.com>
    net: ks8851: Reinstate disabling of BHs around IRQ handler

Ruijie Li <ruijieli51@gmail.com>
    net/smc: avoid early lgr access in smc_clc_wait_msg

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix firmware version check

Ao Zhou <draw51280@163.com>
    net: rds: fix MR cleanup on copy error

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Free the node during ctrl_cmd_bye()

Yiyang Chen <cyyzero16@gmail.com>
    tools/accounting: handle truncated taskstats netlink messages

David Howells <dhowells@redhat.com>
    rxrpc: Fix re-decryption of RESPONSE packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxkad crypto unalignment handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix memory leaks in rxkad_verify_response()

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: fix one-shot mode data acquisition

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcmtest: Fix resource leaks in module init error paths

Guangshuo Li <lgs201920130244@gmail.com>
    ALSA: pcmtest: fix reference leak on failed device registration

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: 6fire: Fix input volume change detection

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Handle probe errors properly

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: caiaq: Fix control_put() result and cache rollback

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix potential data race at fasync handling

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE

Longxuan Yu <ylong030@ucr.edu>
    io_uring/poll: fix signed comparison in io_poll_get_ownership()

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-ads7950: use iio_push_to_buffers_with_ts_unaligned()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/timeout: check unused sqe fields

Dawei Feng <dawei.feng@seu.edu.cn>
    rbd: fix null-ptr-deref when device_add_disk() fails

Simon Liebold <simonlie@amazon.de>
    selftests/mqueue: Fix incorrectly named file

Ben Levinsky <ben.levinsky@amd.com>
    remoteproc: xlnx: Only access buffer information if IPI is buffered

Helge Deller <deller@gmx.de>
    parisc: _llseek syscall is only available for 32-bit userspace

Robert Beckett <bob.beckett@collabora.com>
    nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set

Robert Beckett <bob.beckett@collabora.com>
    nvme-pci: add NVME_QUIRK_DISABLE_WRITE_ZEROES for Kingston OM3SGP4

Marek Vasut <marex@nabladev.com>
    mfd: stpmic1: Attempt system shutdown twice in case PMIC is confused

Josh Hunt <johunt@akamai.com>
    md/raid10: fix deadlock with check operation and nowait requests

Gao Xiang <xiang@kernel.org>
    erofs: fix the out-of-bounds nameoff handling for trailing dirents

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq_oss: return full count for successful SEQ_FULLSIZE writes

Harin Lee <me@harin.net>
    ALSA: ctxfi: Add fallback to default RSR for S/PDIF

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: fix OF node lifetime handling

Vasiliy Kovalev <kovalev@altlinux.org>
    ext2: reject inodes with zero i_nlink and valid mode in ext2_iget()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Fix use-after-free in driver remove()

Chen Ni <nichen@iscas.ac.cn>
    media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()

Josh Law <objecting@objecting.org>
    lib/ts_kmp: fix integer overflow in pattern length calculation

Rong Zhang <i@rong.moe>
    Revert "ALSA: usb: Increase volume range that triggers a warning"

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-ntb: Remove duplicate resource teardown

Fan Wu <fanwu01@zju.edu.cn>
    media: mtk-jpeg: fix use-after-free in release path due to uncancelled work

Luxiao Xu <rakukuip@gmail.com>
    net: strparser: fix skb_head leak in strp_abort_strp()

Zhengchuan Liang <zcliangcn@gmail.com>
    net: caif: clear client service pointer on teardown

Ziqing Chen <chenziqing@xiaomi.com>
    ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Fix race between m2m job_abort and device_run

Wentao Liang <vulab@iscas.ac.cn>
    of: unittest: fix use-after-free in testdrv_probe()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix handling of MAY_BACKLOG requests

Chao Yu <chao@kernel.org>
    f2fs: fix to detect potential corrupted nid in free_nid_list

Johan Hovold <johan@kernel.org>
    spi: imx: fix use-after-free on unbind

Michael Bommarito <michael.bommarito@gmail.com>
    um: drivers: call kernel_strrchr() explicitly in cow_user.c

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw88: check for PCI upstream bridge existence

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not forget to endio for partial discard requests

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    LoongArch: Add spectre boundry for syscall dispatch table

Douglas Anderson <dianders@chromium.org>
    driver core: Don't let a device probe until it's ready

Heming Zhao <heming.zhao@suse.com>
    ocfs2: split transactions in dio completion to avoid credit exhaustion

Douglas Anderson <dianders@chromium.org>
    device property: Make modifications of fwnode "flags" thread safe

Douglas Anderson <dianders@chromium.org>
    regset: use kvzalloc() for regset_get_alloc()

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Limit BO list entry count to prevent resource exhaustion

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove comment for reorder_work

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Fix pd UAF once and for all

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible UAFs

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not mark framebuffer as busy

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix heap over-read in ibmasm_send_i2o_message()

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix OOB reads in command_file_write due to missing size checks

Tyllis Xu <livelycarpet87@gmail.com>
    misc: ibmasm: fix OOB MMIO read in ibmasm_handle_mouse_interrupt()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    leds: qcom-lpg: Check for array overflow when selecting the high resolution

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/nouveau: fix u32 overflow in pushbuf reloc bounds check

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Evaluate packsize caps at the right place

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: allow ci_irq_handler() handle both ID and VBUS change

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: otg: not wait vbus drop if use role_switch

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Avoid false E-MU sample-rate notifications

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  20 +-
 arch/arm64/crypto/aes-modes.S                      |   4 +-
 arch/arm64/kvm/arm.c                               |   5 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   8 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   2 +-
 arch/arm64/mm/mmu.c                                |  36 ++-
 arch/loongarch/kernel/cpu-probe.c                  |   7 +
 arch/loongarch/kernel/syscall.c                    |   3 +-
 arch/loongarch/pci/acpi.c                          |   5 +
 arch/loongarch/pci/pci.c                           |   3 +
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/powerpc/kexec/Makefile                        |   2 +-
 arch/s390/kernel/debug.c                           |   5 +
 arch/um/drivers/cow_user.c                         |   8 +-
 arch/x86/kernel/shstk.c                            |  45 ++-
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  35 +--
 arch/x86/kvm/svm/nested.c                          |  56 +++-
 arch/x86/kvm/svm/svm.c                             |  17 ++
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/x86.c                                 |  62 ++--
 block/bio-integrity.c                              |   2 +
 block/bio.c                                        |  14 +-
 block/blk.h                                        |  21 ++
 certs/extract-cert.c                               |   6 +-
 crypto/authencesn.c                                |   5 +
 crypto/pcrypt.c                                    |   7 +-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/power.c                               |   2 +-
 drivers/acpi/scan.c                                |   2 +-
 drivers/acpi/video_detect.c                        |   8 +
 drivers/base/core.c                                |  39 ++-
 drivers/base/dd.c                                  |  20 ++
 drivers/block/rbd.c                                |   6 +-
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/bluetooth/virtio_bt.c                      |  39 ++-
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  70 ++++-
 drivers/char/ipmi/ipmi_ssif.c                      |  36 ++-
 drivers/char/tpm/tpm_tis_core.c                    |  11 +-
 drivers/clk/clk-rk808.c                            |   2 +-
 drivers/clk/imx/clk-imx8-acm.c                     |   3 +-
 drivers/clk/microchip/clk-mpfs-ccc.c               |   6 +-
 drivers/cpuidle/cpuidle-powernv.c                  |   5 +-
 drivers/cpuidle/cpuidle-pseries.c                  |   5 +-
 drivers/crypto/atmel-aes.c                         |   2 +-
 drivers/crypto/atmel-ecc.c                         |   1 +
 drivers/crypto/atmel-sha204a.c                     |   6 +-
 drivers/crypto/atmel-tdes.c                        |   8 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   4 +-
 drivers/crypto/caam/caamhash.c                     |   4 +-
 drivers/crypto/ccree/cc_hash.c                     |   1 +
 drivers/crypto/hisilicon/sec/sec_algs.c            |   2 +-
 drivers/crypto/nx/nx-842.c                         |  47 +--
 drivers/crypto/nx/nx-842.h                         |  25 +-
 drivers/crypto/nx/nx-common-powernv.c              |  31 +-
 drivers/crypto/nx/nx-common-pseries.c              |  33 +-
 drivers/crypto/talitos.c                           | 340 +++++++++++++--------
 drivers/dma/idxd/device.c                          |   3 +-
 drivers/extcon/extcon-ptn5150.c                    |  14 +
 drivers/firmware/google/framebuffer-coreboot.c     |  12 +-
 drivers/gpio/gpiolib-of.c                          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |  43 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c           |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  25 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  46 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  29 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  11 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   7 +-
 .../gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c    |  13 +-
 drivers/gpu/drm/drm_gem_framebuffer_helper.c       |   4 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   9 +-
 drivers/gpu/drm/tiny/arcpgu.c                      |   3 +-
 drivers/hid/hid-playstation.c                      |   6 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/ltc2992.c                            |  41 ++-
 drivers/i2c/i2c-core-of.c                          |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   9 +-
 drivers/iio/adc/ti-ads7950.c                       |  11 +-
 drivers/infiniband/core/addr.c                     |   3 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   7 +
 drivers/infiniband/hw/mana/qp.c                    |  15 +
 drivers/infiniband/hw/mlx4/srq.c                   |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   2 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |  14 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  14 +-
 drivers/iommu/amd/amd_iommu_types.h                |   2 +-
 drivers/iommu/amd/init.c                           |   2 +-
 drivers/iommu/amd/iommu.c                          |  18 +-
 drivers/iommu/iommufd/io_pagetable.c               |  10 +
 drivers/leds/rgb/leds-qcom-lpg.c                   |   7 +-
 drivers/md/dm-ioctl.c                              |   6 +-
 drivers/md/dm-raid1.c                              |   6 +-
 drivers/md/dm-verity-fec.c                         |   8 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +
 drivers/md/raid10.c                                |   6 +-
 drivers/md/raid5-cache.c                           |  48 ++-
 drivers/md/raid5.c                                 |   8 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   1 +
 drivers/media/dvb-frontends/dib8000.c              |   4 +-
 drivers/media/i2c/imx219.c                         |   3 +
 drivers/media/i2c/imx412.c                         |   2 +-
 drivers/media/i2c/ov08d10.c                        |  10 +-
 drivers/media/i2c/ov8856.c                         |  10 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  47 ++-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |   9 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   1 +
 drivers/media/platform/ti/omap3isp/ispvideo.c      |   1 +
 drivers/media/rc/igorplugusb.c                     |  16 +-
 drivers/media/rc/streamzap.c                       |  12 +-
 drivers/media/rc/ttusbir.c                         |  13 +-
 drivers/media/rc/xbox_remote.c                     |   9 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/mfd/stpmic1.c                              |  20 +-
 drivers/misc/ibmasm/ibmasmfs.c                     |   7 +
 drivers/misc/ibmasm/lowlevel.c                     |  12 +-
 drivers/misc/ibmasm/remote.c                       |   5 +
 drivers/mmc/core/block.c                           |  12 +-
 drivers/mmc/core/card.h                            |   5 +
 drivers/mmc/core/queue.c                           |   8 +-
 drivers/mmc/core/queue.h                           |   3 +
 drivers/mmc/core/quirks.h                          |   9 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  19 +-
 drivers/mtd/devices/docg3.c                        |   8 +-
 drivers/mtd/spi-nor/debugfs.c                      |   4 +-
 drivers/mtd/spi-nor/sst.c                          |  50 +--
 drivers/net/bonding/bond_main.c                    |   6 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  22 ++
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 +
 drivers/net/ethernet/micrel/ks8851.h               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  69 ++---
 drivers/net/ethernet/micrel/ks8851_par.c           |  15 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |  11 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  11 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  47 +--
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   7 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c     |   2 +
 drivers/net/phy/mdio_bus.c                         |   4 +-
 drivers/net/wireless/ath/ath5k/base.c              |   3 +-
 drivers/net/wireless/broadcom/b43/xmit.c           |   3 +-
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   6 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   6 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   3 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h   |   4 +
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  51 +++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  28 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   3 +-
 drivers/net/wireless/rsi/rsi_common.h              |   5 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c             |  20 +-
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c         |  18 +-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h            |   2 +-
 drivers/nvme/host/apple.c                          |   6 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/core.c                         |   2 +-
 drivers/of/base.c                                  |   2 +-
 drivers/of/dynamic.c                               |   2 +-
 drivers/of/platform.c                              |   2 +-
 drivers/of/unittest.c                              |   1 -
 drivers/parisc/lasi.c                              |  12 +-
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   4 +
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |  56 +---
 drivers/pci/pci.c                                  |   7 +-
 drivers/pci/pcie/aer.c                             |   2 -
 drivers/platform/x86/hp/hp-wmi.c                   |   5 +
 drivers/power/supply/axp288_charger.c              |  19 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/pwm/pwm-imx-tpm.c                          |   8 +
 drivers/regulator/act8945a-regulator.c             |   3 +-
 drivers/regulator/bd9571mwv-regulator.c            |   3 +-
 drivers/regulator/max77650-regulator.c             |   2 +-
 drivers/regulator/mt6357-regulator.c               |   2 +-
 drivers/regulator/rk808-regulator.c                |   3 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |  20 +-
 drivers/rtc/rtc-ntxec.c                            |   2 +-
 drivers/scsi/sd.c                                  |   1 +
 drivers/spi/spi-at91-usart.c                       |   8 +-
 drivers/spi/spi-atmel.c                            |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   8 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |   4 +-
 drivers/spi/spi-cadence.c                          |  15 +-
 drivers/spi/spi-coldfire-qspi.c                    |  10 +-
 drivers/spi/spi-dln2.c                             |   8 +-
 drivers/spi/spi-fsl-espi.c                         |  10 +-
 drivers/spi/spi-fsl-spi.c                          |  14 +-
 drivers/spi/spi-img-spfi.c                         |   8 +-
 drivers/spi/spi-imx.c                              |   5 +
 drivers/spi/spi-lantiq-ssc.c                       |   8 +-
 drivers/spi/spi-meson-spicc.c                      |   2 -
 drivers/spi/spi-microchip-core-qspi.c              |  41 +--
 drivers/spi/spi-mpc52xx.c                          |   3 +-
 drivers/spi/spi-mtk-nor.c                          |   4 +-
 drivers/spi/spi-omap2-mcspi.c                      |   8 +-
 drivers/spi/spi-orion.c                            |   9 +
 drivers/spi/spi-qup.c                              |   8 +-
 drivers/spi/spi-rockchip.c                         |   4 +-
 drivers/spi/spi-rspi.c                             |  10 +-
 drivers/spi/spi-s3c64xx.c                          |   9 +-
 drivers/spi/spi-sh-hspi.c                          |  10 +-
 drivers/spi/spi-sprd.c                             |   8 +-
 drivers/spi/spi-sun4i.c                            |  80 ++---
 drivers/spi/spi-sun6i.c                            | 154 +++++-----
 drivers/spi/spi-synquacer.c                        |  88 +++---
 drivers/spi/spi-tegra114.c                         |   8 +-
 drivers/spi/spi-tegra20-sflash.c                   |   8 +-
 drivers/spi/spi-ti-qspi.c                          |  97 +++---
 drivers/spi/spi-topcliff-pch.c                     |   6 +-
 drivers/spi/spi-uniphier.c                         | 212 +++++++------
 drivers/spi/spi-zynq-qspi.c                        |  79 ++---
 drivers/spi/spi-zynqmp-gqspi.c                     |   4 +-
 drivers/spi/spi.c                                  |  63 ++--
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c  |   4 +
 drivers/staging/media/imx/imx-media-csi.c          |  40 ++-
 drivers/staging/vme_user/vme_fake.c                |   2 +
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/thermal/sprd_thermal.c                     |   4 +-
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/usb/chipidea/core.c                        |  45 +--
 drivers/usb/chipidea/otg.c                         |   7 +-
 drivers/usb/class/usblp.c                          |   3 +-
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/dwc3/core.c                            |  12 +-
 drivers/usb/gadget/udc/omap_udc.c                  |   4 -
 drivers/usb/host/xhci.c                            |   1 -
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +
 drivers/video/fbdev/core/fb_defio.c                | 179 ++++++++---
 drivers/video/fbdev/core/fbcon_rotate.c            |   5 +-
 drivers/video/fbdev/udlfb.c                        |  31 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/btrfs/space-info.c                              |   2 +-
 fs/ceph/dir.c                                      |   6 +-
 fs/erofs/decompressor.c                            |   1 +
 fs/erofs/dir.c                                     |  28 +-
 fs/ext2/inode.c                                    |  14 +-
 fs/ext4/extents.c                                  |  15 +
 fs/ext4/xattr.c                                    |   6 +-
 fs/f2fs/data.c                                     |  32 +-
 fs/f2fs/extent_cache.c                             |  17 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/node.c                                     |  17 +-
 fs/f2fs/segment.c                                  |   6 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/hfsplus/bfind.c                                 |  51 ++++
 fs/hfsplus/catalog.c                               |   4 +-
 fs/hfsplus/dir.c                                   |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   9 +
 fs/hfsplus/super.c                                 |   6 +-
 fs/isofs/export.c                                  |   2 +-
 fs/isofs/rock.c                                    |   9 +
 fs/notify/fsnotify.c                               |   2 +-
 fs/notify/inotify/inotify_user.c                   |   1 +
 fs/notify/mark.c                                   |  18 +-
 fs/ntfs3/run.c                                     |  18 +-
 fs/ocfs2/aops.c                                    |  74 +++--
 fs/smb/client/cached_dir.c                         |   8 +
 fs/smb/client/cifsacl.c                            | 177 ++++++++---
 fs/smb/client/cifsacl.h                            |  91 +-----
 fs/smb/client/smb2inode.c                          |  12 +-
 fs/smb/client/smb2misc.c                           |   3 +-
 fs/smb/client/smb2ops.c                            |  11 +
 fs/smb/common/smbacl.h                             | 122 ++++++++
 fs/smb/server/connection.c                         |  28 +-
 fs/smb/server/connection.h                         |   6 +-
 fs/smb/server/smb2pdu.c                            |   4 +-
 fs/smb/server/smbacl.c                             |  48 +--
 fs/smb/server/smbacl.h                             | 113 +------
 fs/smb/server/transport_rdma.c                     |   5 +
 fs/smb/server/transport_tcp.c                      |  25 +-
 fs/smb/server/vfs_cache.c                          |  40 ++-
 fs/tracefs/event_inode.c                           |  14 +
 fs/tracefs/inode.c                                 |   5 +-
 fs/tracefs/internal.h                              |   3 +
 fs/udf/misc.c                                      |   8 +-
 fs/udf/super.c                                     |   4 +-
 fs/userfaultfd.c                                   |   2 -
 fs/xfs/xfs_buf.c                                   |   1 +
 include/linux/bpf_verifier.h                       |  31 +-
 include/linux/damon.h                              |   2 +
 include/linux/device.h                             |  45 +++
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/fb.h                                 |   4 +-
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/fwnode.h                             |  44 ++-
 include/linux/mmap_lock.h                          |   6 +-
 include/linux/mmc/card.h                           |   1 +
 include/linux/padata.h                             |   4 -
 include/linux/printk.h                             |  13 +
 include/linux/randomize_kstack.h                   |  26 +-
 include/linux/sched.h                              |   4 +
 include/linux/tpm_eventlog.h                       |   9 +-
 include/linux/usb.h                                |   3 +-
 include/net/mana/mana.h                            |   1 +
 include/net/mctp.h                                 |   3 +
 include/trace/events/rxrpc.h                       |   6 +-
 include/video/udlfb.h                              |   1 +
 init/main.c                                        |   1 -
 io_uring/poll.c                                    |  14 +-
 io_uring/timeout.c                                 |   4 +
 kernel/bpf/verifier.c                              | 236 +++++++++-----
 kernel/exit.c                                      |   3 +-
 kernel/fork.c                                      |   2 +
 kernel/locking/rtmutex.c                           |  13 +-
 kernel/padata.c                                    | 136 +++------
 kernel/regset.c                                    |   6 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/rt.c                                  |   2 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/taskstats.c                                 |   1 +
 kernel/trace/trace_probe.c                         |   6 +
 kernel/trace/trace_probe.h                         |   4 +-
 kernel/tracepoint.c                                |   2 +
 lib/crypto/mpi/mpicoder.c                          |   2 +-
 lib/scatterlist.c                                  |   8 +-
 lib/test_hmm.c                                     |  86 +++---
 lib/ts_kmp.c                                       |  18 +-
 mm/damon/core.c                                    |  37 ++-
 mm/damon/lru_sort.c                                |  88 ++++--
 mm/damon/reclaim.c                                 |  88 ++++--
 mm/damon/sysfs-schemes.c                           |  12 +-
 mm/hugetlb.c                                       |   1 +
 net/batman-adv/bat_iv_ogm.c                        |  85 ++++--
 net/batman-adv/bridge_loop_avoidance.c             |  11 +-
 net/batman-adv/main.c                              |   1 +
 net/batman-adv/tp_meter.c                          | 116 +++++--
 net/batman-adv/tp_meter.h                          |   1 +
 net/batman-adv/types.h                             |   4 +
 net/bluetooth/hci_conn.c                           |  19 +-
 net/bluetooth/hci_event.c                          |  47 ++-
 net/bluetooth/l2cap_sock.c                         |   9 +
 net/bluetooth/mgmt.c                               | 262 +++++++++++-----
 net/bluetooth/mgmt_util.c                          |  46 +++
 net/bluetooth/mgmt_util.h                          |   3 +
 net/bridge/br_arp_nd_proxy.c                       |   8 +-
 net/bridge/br_fdb.c                                |  28 +-
 net/caif/cfsrvl.c                                  |  14 +-
 net/ceph/auth.c                                    |   4 +-
 net/ceph/mon_client.c                              |   2 +
 net/core/flow_dissector.c                          |  13 +-
 net/core/rtnetlink.c                               |   1 +
 net/ipv4/ah4.c                                     |  29 +-
 net/ipv4/icmp.c                                    |   8 +-
 net/ipv4/inet_connection_sock.c                    |   3 +
 net/ipv6/ah6.c                                     |  27 +-
 net/ipv6/exthdrs.c                                 |   9 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/rpl_iptunnel.c                            |   9 +
 net/ipv6/seg6_iptunnel.c                           |  12 +-
 net/ipv6/xfrm6_protocol.c                          |   4 +-
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mctp/route.c                                   |   8 +-
 net/mptcp/protocol.c                               |   3 +-
 net/mptcp/sockopt.c                                |  12 +-
 net/mptcp/subflow.c                                |   4 +-
 net/netfilter/nft_bitwise.c                        |   3 +-
 net/openvswitch/vport-netdev.c                     |   6 +-
 net/qrtr/ns.c                                      |  86 +++++-
 net/rds/message.c                                  |  20 +-
 net/rds/rdma.c                                     |   4 -
 net/rxrpc/ar-internal.h                            |   1 -
 net/rxrpc/call_event.c                             |  27 +-
 net/rxrpc/conn_event.c                             |  44 ++-
 net/rxrpc/io_thread.c                              |  24 +-
 net/rxrpc/rxkad.c                                  | 112 +++----
 net/rxrpc/skbuff.c                                 |   9 -
 net/sched/sch_red.c                                |   2 +-
 net/sctp/socket.c                                  |   9 +
 net/smc/smc_clc.c                                  |   4 +-
 net/strparser/strparser.c                          |   8 +
 net/unix/af_unix.c                                 |   3 +
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/vmw_vsock/hyperv_transport.c                   |   4 +-
 net/vmw_vsock/virtio_transport_common.c            |  15 +-
 net/xfrm/xfrm_state.c                              |  12 +-
 net/xfrm/xfrm_user.c                               |   1 +
 security/selinux/hooks.c                           |   3 +-
 security/selinux/selinuxfs.c                       |  54 +---
 sound/aoa/codecs/onyx.c                            | 104 ++-----
 sound/aoa/codecs/tas.c                             | 113 +++----
 sound/aoa/core/gpio-feature.c                      |  20 +-
 sound/aoa/core/gpio-pmf.c                          |  26 +-
 sound/aoa/soundbus/i2sbus/core.c                   |  12 +-
 sound/aoa/soundbus/i2sbus/pcm.c                    | 143 ++++-----
 sound/core/control.c                               |   4 +
 sound/core/misc.c                                  |  44 +--
 sound/core/seq/oss/seq_oss_rw.c                    |   6 +-
 sound/core/seq/seq_clientmgr.c                     |   9 +-
 sound/core/seq/seq_clientmgr.h                     |   5 +-
 sound/core/seq/seq_ump_client.c                    |   4 +-
 sound/drivers/pcmtest.c                            |  19 +-
 sound/firewire/tascam/tascam-hwdep.c               |   1 +
 sound/pci/ctxfi/ctatc.c                            |   3 +-
 sound/pci/hda/cs35l56_hda.c                        |  19 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 sound/soc/fsl/fsl_easrc.c                          |   2 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |   1 +
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   2 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   3 +
 sound/soc/sof/compress.c                           |   3 +
 sound/usb/6fire/control.c                          |  10 +-
 sound/usb/caiaq/control.c                          |  52 +++-
 sound/usb/caiaq/device.c                           |  35 ++-
 sound/usb/caiaq/input.c                            |   2 +-
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/format.c                                 |   2 +-
 sound/usb/midi2.c                                  |   9 +-
 sound/usb/misc/ua101.c                             |   7 +
 sound/usb/mixer.c                                  |   7 +-
 sound/usb/mixer_quirks.c                           |  12 +-
 sound/usb/stream.c                                 |   4 +-
 tools/accounting/getdelays.c                       |  41 ++-
 tools/accounting/procacct.c                        |  40 ++-
 tools/testing/ktest/ktest.pl                       |   2 +-
 .../selftests/bpf/progs/verifier_spill_fill.c      | 281 +++++++++++++++++
 .../bpf/progs/verifier_subprog_precision.c         |  87 +++++-
 tools/testing/selftests/bpf/verifier/precise.c     |  38 ++-
 .../testing/selftests/mqueue/{setting => settings} |   0
 447 files changed, 5555 insertions(+), 2927 deletions(-)


