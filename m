Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB60216E2D;
	Thu, 12 Dec 2024 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024976; cv=none; b=VcJG86vXzYAlVPn7lg2bn+lr+9Q37iXMBOakytKsNPds5/fi8RD3AfGRQdSSi4jwjNYaTX5wM/aiz3AwfQMHORAt1R2FZ2DmOwZXxXoAXw4CS4GNYyZ4HuOiidIthAXyoZyv5yoH4GGmlRaRVc+9t/3b37/9ACHfCPjcl88wJ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024976; c=relaxed/simple;
	bh=HzX357LetwoU+WLUez6WROCZ5AabVU/+/yJpY0pvqeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T/gnHPmP7N5Vf5l/6PS0WRbzk8/B63qLP61Pvur3F86lkIRkU94pVNe7bkaM4oozGqO/EKtlqDX+jfrB+EDix5Fo7ta0FguVuhhwqVLKR2wrbXma3WPk57CXnu04HCQHKGz8HYkDG6EwJJ3bXffGsWK7KTjM1NxflHVlSm1YJe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnRk9iTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnRk9iTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2DAC4CECE;
	Thu, 12 Dec 2024 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024976;
	bh=HzX357LetwoU+WLUez6WROCZ5AabVU/+/yJpY0pvqeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=JnRk9iTlm3JvTyC9asl/q/D4HiqpJOF4z2/yt5o55aNqWSi1gE6qf6Sw/pJkf2AH3
	 noeOAgDxFU5vDxLF06FCEWwNr7j3ctSWalSDkeK4UBwG8JGgdr2jODLmT8uiJIKKSq
	 ObSMSeku11A4Gk1l44Ak3N+8wSIltM/MXnn787yM=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.4 000/321] 5.4.287-rc1 review
Date: Thu, 12 Dec 2024 15:58:38 +0100
Message-ID: <20241212144229.291682835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.287-rc1
X-KernelTest-Deadline: 2024-12-14T14:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.287 release.
There are 321 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.287-rc1

John Fastabend <john.fastabend@gmail.com>
    bpf, xdp: Update devmap comments to reflect napi/rcu usage

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Damien Le Moal <dlemoal@kernel.org>
    PCI: rockchip-ep: Fix address translation unit programming

Zhang Zekun <zhangzekun11@huawei.com>
    Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"

Thomas Gleixner <tglx@linutronix.de>
    modpost: Add .irqentry.text to OTHER_SECTIONS

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Richard Weinberger <richard@nod.at>
    jffs2: Fix rtime decompressor

Kinsey Moore <kinsey.moore@oarcorp.com>
    jffs2: Prevent rtime decompress memory corruption

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device

Jing Zhang <jingzhangos@google.com>
    KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix buffer full but size is 0 case

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "unicode: Don't special case ignorable code points"

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: fix OOB devmap writes when deleting elements

Björn Töpel <bjorn.topel@intel.com>
    xdp: Simplify devmap cleanup

Parker Newman <pnewman@connecttech.com>
    misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/prom_init: Fixup missing powermac #size-cells

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: handle USB Error Interrupt if IOC not set

Defa Li <defa.li@mediatek.com>
    i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun FF5xxx NICs

Keith Busch <kbusch@kernel.org>
    PCI: Add 'reset_subordinate' to reset hierarchy below bridge

Qi Han <hanqi@vivo.com>
    f2fs: fix f2fs_bug_on when uninstalling filesystem call f2fs_evict_inode.

Yi Yang <yiyang13@huawei.com>
    nvdimm: rectify the illogical code within nd_dax_probe()

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom-pmic-gpio: add support for PM8937

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't modify unknown block number in MTIOCGET

Mukesh Ojha <quic_mojha@quicinc.com>
    leds: class: Protect brightness_show() with led_cdev->led_access mutex

Uros Bizjak <ubizjak@gmail.com>
    tracing: Use atomic64_inc_return() in trace_clock_counter()

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in __netpoll_setup

Jakub Kicinski <kuba@kernel.org>
    net/neighbor: clear error in case strict check is not set

Dmitry Antipov <dmantipov@yandex.ru>
    rocker: fix link status detection in rocker_carrier_init()

Jonas Karlman <jonas@kwiboo.se>
    ASoC: hdmi-codec: reorder channel allocation list

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables

Norbert van Bolhuis <nvbolhuis@gmail.com>
    wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    wifi: ipw2x00: libipw_rx_any(): fix bad alignment

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: set the right AMDGPU sg segment limitation

Nihar Chaithanya <niharchaithanya@gmail.com>
    jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix array-index-out-of-bounds in jfs_readdir

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix shift-out-of-bounds in dbSplit

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: array-index-out-of-bounds fix in dtReadFirst

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for Arcadyan devices

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for SX76X

Ignat Korchagin <ignat@cloudflare.com>
    net: inet6: do not leave a dangling sk pointer in inet6_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: inet: do not leave a dangling sk pointer in inet_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: af_can: do not leave a dangling sk pointer in can_create()

Ignat Korchagin <ignat@cloudflare.com>
    Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()

Ignat Korchagin <ignat@cloudflare.com>
    af_packet: avoid erroring out after sock_init_data() in packet_create()

Elena Salomatkina <esalomatkina@ispras.ru>
    net/sched: cbs: Fix integer overflow in cbs_set_port_rate()

Simon Horman <horms@kernel.org>
    net: ethernet: fs_enet: Use %pa to format resource_size_t

Simon Horman <horms@kernel.org>
    net: fec_mpc52xx_phy: Use %pa to format resource_size_t

Zhu Jun <zhujun2@cmss.chinamobile.com>
    samples/bpf: Fix a resource leak

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()

Liao Chen <liaochen4@huawei.com>
    drm/mcde: Enable module autoloading

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model

Rohan Barar <rohan.barar@gmail.com>
    media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108

David Given <dg@cowlark.com>
    media: uvcvideo: Add a quirk for the Kaiweets KTI-W02 infrared camera

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Handle CPU hotplug remove during sampling

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Further prevent card detect during shutdown

Cosmin Tanislav <demonsingur@gmail.com>
    regmap: detach regmap from dev on regmap_exit

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_fence_array_signaled v4

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Supported speed displayed incorrectly for VPorts

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix NVMe and NPIV connect issue

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: update seq_file index in ocfs2_dlm_seq_next

Kuan-Wei Chiu <visitorckw@gmail.com>
    tracing: Fix cmp_entries_dup() to respect sort() comparison rules

WangYuli <wangyuli@uniontech.com>
    HID: wacom: fix when get product name maybe null pointer

Hou Tao <houtao1@huawei.com>
    bpf: Fix exact match conditions in trie_get_next_key()

Hou Tao <houtao1@huawei.com>
    bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: free inode when ocfs2_get_init_inode() fails

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Charles Han <hanchunchao@inspur.com>
    gpio: grgpio: Add NULL check in grgpio_probe

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: grgpio: use a helper variable to store the address of ofdev->dev

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - access 32-bit arguments as 32-bit

Jiri Slaby <jslaby@suse.cz>
    x86/asm/crypto: Annotate local functions

Jiri Slaby <jslaby@suse.cz>
    x86/asm: Reorder early variables

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

Juergen Gross <jgross@suse.com>
    xen/xenbus: fix locking

SeongJae Park <sjpark@amazon.de>
    xenbus/backend: Protect xenbus callback with lock

SeongJae Park <sjpark@amazon.de>
    xenbus/backend: Add memory pressure handler callback

Paul Durrant <pdurrant@amazon.com>
    xen/xenbus: reference count registered modules

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: skip duplicated elements pending gc run

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Hold module reference while requesting a module

Yuan Can <yuancan@huawei.com>
    igb: Fix potential invalid memory access in igb_init_module()

Louis Leseur <louis.leseur@gmail.com>
    net/qed: allow old cards not supporting "num_images" to work

Kuniyuki Iwashima <kuniyu@amazon.com>
    tipc: Fix use-after-free of kernel socket in cleanup_bearer().

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: add new AEAD key structure for user API

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: enable creating a "preliminary" node

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: add reference counter to bearer

Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
    dccp: Fix memory leak in dccp_feat_change_recv

Jiri Wiesner <jwiesner@suse.de>
    net/ipv6: release expired exception dst cached in socket

Dmitry Antipov <dmantipov@yandex.ru>
    can: j1939: j1939_session_new(): fix skb reference counting

Martin Ottens <martin.ottens@fau.de>
    net/sched: tbf: correct backlog statistic for GSO packets

Dmitry Antipov <dmantipov@yandex.ru>
    netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia <jinghao7@illinois.edu>
    ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: flush shader L1 cache after user commandstream

Yang Erkun <yangerkun@huawei.com>
    nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur

Yang Erkun <yangerkun@huawei.com>
    nfsd: make sure exp active before svc_export_show

Yuan Can <yuancan@huawei.com>
    dm thin: Add missing destroy_work_on_stack()

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()

Alexandru Ardelean <aardelean@baylibre.com>
    util_macros.h: fix/rework find_closest() macros

Zicheng Qu <quzicheng@huawei.com>
    ad7780: fix division by zero in ad7780_write_raw()

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-qcs404: fix initial rate of GPLL3

guoweikang <guoweikang.kernel@gmail.com>
    ftrace: Fix regression with module command in stack_trace_filter

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: Filter invalid inodes with missing lookup function

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled

Li Zetao <lizetao1@huawei.com>
    media: ts2020: fix null-ptr-deref in ts2020_probe()

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: tc358743: Fix crash in the probe error path when using polling

Filipe Manana <fdmanana@suse.com>
    btrfs: ref-verify: fix use-after-free after invalid ref action

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    quota: flush quota_release_work upon quota writeback

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix the naming style for mask definition

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Liu Jian <liujian56@huawei.com>
    sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Replace internal use of SOCKWQ_ASYNC_NOSPACE

Calum Mackay <calum.mackay@oracle.com>
    SUNRPC: correct error code comment in xs_tcp_setup_socket()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    rtc: ab-eoz9: don't fail temperature reads on undervoltage notification

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Waqar Hameed <waqar.hameed@axis.com>
    ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Yongliang Gao <leonylgao@tencent.com>
    rtc: check if __rtc_read_time was successful in rtc_timer_do_work()

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    rtc: abx80x: Fix WDT bit position of the status register

Jinjie Ruan <ruanjinjie@huawei.com>
    rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.0: Fix a use-after-free problem in the asynchronous open()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Always dump trace for specified task in show_stack

Johannes Berg <johannes.berg@intel.com>
    um: Clean up stacktrace dump

Dmitry Safonov <0x7f454c46@gmail.com>
    um: add show_stack_loglvl()

Dmitry Safonov <0x7f454c46@gmail.com>
    um/sysrq: remove needless variable sp

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the return value of elf_core_copy_task_fpregs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix potential integer overflow during physmem setup

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Propagate TX failures in intentless mode as well

Yang Erkun <yangerkun@huawei.com>
    SUNRPC: make sure cache entry active before cache_show

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply quirk for Medion E15433

Dinesh Kumar <desikumar81@gmail.com>
    ALSA: hda/realtek: Fix Internal Speaker and Mic boost of Infinix Y4 Max

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Set PCBeep to default value for ALC274

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC225 depop procedure

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Muchun Song <songmuchun@bytedance.com>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Huacai Chen <chenhuacai@loongson.cn>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    tty: ldsic: fix tty_ldisc_autoload sysctl's proc_handler

Jann Horn <jannh@google.com>
    comedi: Flush partial mappings in error case

Lukas Wunner <lukas@wunner.de>
    PCI: Fix use-after-free of slot->bus on hot remove

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
    soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()

Waiman Long <longman@redhat.com>
    cgroup: Move rcu_head up near the top of cgroup_root

Yafang Shao <laoar.shao@gmail.com>
    cgroup: Make operations on the cgroup root_list RCU safe

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: clean up TIOCGSERIAL

Jinjie Ruan <ruanjinjie@huawei.com>
    misc: apds990x: Fix missing pm_runtime_disable()

Edward Adam Davis <eadavis@qq.com>
    USB: chaoskey: Fix possible deadlock chaoskey_list_lock

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fail open after removal

Oliver Neukum <oneukum@suse.com>
    usb: yurex: make waiting on yurex_write interruptible

Jeongjun Park <aha310510@gmail.com>
    usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()

Paolo Abeni <pabeni@redhat.com>
    ipmr: fix tables suspicious RCU usage

Eric Dumazet <edumazet@google.com>
    ipmr: convert /proc handlers to rcu_read_lock()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_shutdown_copy()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent NULL dereference in nfsd4_process_cb_update()

Jonathan Marek <jonathan@marek.ca>
    rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Fix GLINK command prefix

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Send READ_NOTIFY command in FIFO full case

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Add TX_DATA_CONT command while sending

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Avoid garbage when not printing a syscall's arguments

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Do not lose last events in a race

Antonio Quartulli <antonio@mandelbit.com>
    m68k: coldfire/device.c: only build FEC when HW macros are defined

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

weiyufeng <weiyufeng@kylinos.cn>
    PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Alexandru Ardelean <alexandru.ardelean@analog.com>
    clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Alexandru Ardelean <alexandru.ardelean@analog.com>
    dt-bindings: clock: adi,axi-clkgen: convert old binding to yaml format

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/sh7760fb: Alloc DMA memory from hardware device

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()

Zeng Heng <zengheng4@huawei.com>
    scsi: fusion: Remove unused variable 'rc'

Ye Bin <yebin10@huawei.com>
    scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use dev_err_probe()

Marcus Folkesson <marcus.folkesson@gmail.com>
    mfd: da9052-spi: Change read-mask to write-mask

Jinjie Ruan <ruanjinjie@huawei.com>
    mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Flag VDSO64 entry points as functions

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Release resources at card release

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Use snd_card_free_when_closed() at disconnection

Mingwei Zheng <zmw12306@gmail.com>
    net: rfkill: gpio: Add check for clk_enable()

Paolo Abeni <pabeni@redhat.com>
    selftests: net: really check for bg process completion

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Fix sk_msg_reset_curr

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_pop_data

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_push_data

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: fix power register offset on GC300

Marc Kleine-Budde <mkl@pengutronix.de>
    drm/etnaviv: dump: fix sparse warnings

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Convert to Linux IRQ interfaces

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Use GEM CMA object functions

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix regmap_write_bits usage

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: use GENMASK to define register bit fields

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: do not define SHIFT/MASK for single bits

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: Drop unnecessary register read

Igor Prusov <ivprusov@salutedevices.com>
    dt-bindings: vendor-prefixes: Add NeoFidelity, Inc

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix locking in omap_gem_new_dmabuf()

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Gregory Price <gourry@gourry.net>
    tpm: fix signed/unsigned bug when checking event logs

Jerry Snitselaar <jsnitsel@redhat.com>
    efi/tpm: Pass correct address to memblock_reserve

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mmc: mmc_spi: drop buggy snprintf()

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()

Jinjie Ruan <ruanjinjie@huawei.com>
    soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

David Thompson <davthompson@nvidia.com>
    EDAC/bluefield: Fix potential integer overflow

Yuan Can <yuancan@huawei.com>
    firmware: google: Unregister driver_info on failure

Arthur Heymans <arthur@aheymans.xyz>
    firmware: google: Unregister driver_info on failure and exit in gsmi

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Aleksandr Mishin <amishin@t-argos.ru>
    acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Reinstate early console

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: mvme16x: Add and use "mvme16x.h"

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Fix SCSI controller IRQ numbers

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix freeing of the HMB descriptor table

David Disseldorp <ddiss@suse.de>
    initramfs: avoid filename buffer overrun

Jonas Gorski <jonas.gorski@gmail.com>
    mips: asm: fix warning when disabling MIPS_FP_SUPPORT

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/xen/pvh: Annotate indirect branch as safe

Puranjay Mohan <pjy@amazon.com>
    nvme: fix metadata handling in nvme-passthrough

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Force all NFSv4.2 COPY requests to be synchronous

Pali Rohár <pali@kernel.org>
    cifs: Fix buffer overflow when parsing NFS reparse points

Breno Leitao <leitao@debian.org>
    ipmr: Fix access to mfc_cache_list without lock held

David Wang <00107082@163.com>
    proc/softirqs: replace seq_printf with seq_put_decimal_ull_width

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()

Mikhail Rudenko <mike.rudenko@gmail.com>
    regulator: rk808: Add apply_bit for BUCK3 on RK809

Charles Han <hanchunchao@inspur.com>
    soc: qcom: Add check devm_kasprintf() returned value

Benoît Monin <benoit.monin@gmx.fr>
    net: usb: qmi_wwan: add Quectel RG650V

Arnd Bergmann <arnd@arndb.de>
    x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB

Piyush Raj Chouhan <piyushchouhan1598@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Infinix ZERO BOOK 13

Li Zhijian <lizhijian@fujitsu.com>
    selftests/watchdog-test: Fix system accidentally reset after watchdog-test

Ben Greear <greearb@candelatech.com>
    mac80211: fix user-power when emulating chanctx

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet

Andrew Morton <akpm@linux-foundation.org>
    mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Chris Down <chris@chrisdown.name>
    kbuild: Use uname for LINUX_COMPILE_HOST detection

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind CONFIG_BROKEN

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |   67 +
 .../devicetree/bindings/clock/axi-clkgen.txt       |   25 -
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 Makefile                                           |    4 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |    4 +-
 arch/arm64/kernel/process.c                        |    2 +-
 arch/m68k/coldfire/device.c                        |    8 +-
 arch/m68k/include/asm/mcfgpio.h                    |    2 +-
 arch/m68k/include/asm/mvme147hw.h                  |    4 +-
 arch/m68k/kernel/early_printk.c                    |    9 +-
 arch/m68k/mvme147/config.c                         |   30 +
 arch/m68k/mvme147/mvme147.h                        |    6 +
 arch/m68k/mvme16x/config.c                         |    2 +
 arch/m68k/mvme16x/mvme16x.h                        |    6 +
 arch/mips/include/asm/switch_to.h                  |    2 +-
 arch/powerpc/include/asm/sstep.h                   |    5 -
 arch/powerpc/include/asm/vdso.h                    |    1 +
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/lib/sstep.c                           |   12 +-
 arch/s390/kernel/perf_cpum_sf.c                    |    4 +-
 arch/s390/kernel/syscalls/Makefile                 |    2 +-
 arch/sh/kernel/cpu/proc.c                          |    2 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/um/drivers/ubd_kern.c                         |    2 +-
 arch/um/drivers/vector_kern.c                      |    3 +-
 arch/um/kernel/physmem.c                           |    6 +-
 arch/um/kernel/process.c                           |    2 +-
 arch/um/kernel/sysrq.c                             |   24 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |   37 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   49 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |   20 +-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       |   20 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |    8 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |    8 +-
 arch/x86/crypto/chacha-ssse3-x86_64.S              |    4 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    4 +-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |    8 +-
 arch/x86/crypto/serpent-avx2-asm_64.S              |    8 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |    8 +-
 arch/x86/events/intel/pt.c                         |   11 +-
 arch/x86/events/intel/pt.h                         |    2 +
 arch/x86/include/asm/amd_nb.h                      |    5 +-
 arch/x86/kernel/head_64.S                          |   11 +-
 arch/x86/kvm/vmx/vmx.c                             |    4 +-
 arch/x86/platform/pvh/head.S                       |    2 +
 block/blk-mq.c                                     |    6 +
 block/blk-mq.h                                     |   13 +
 crypto/pcrypt.c                                    |   12 +-
 drivers/acpi/arm64/gtdt.c                          |    2 +-
 drivers/base/regmap/regmap-irq.c                   |    4 +
 drivers/base/regmap/regmap.c                       |   12 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/clk/clk-axi-clkgen.c                       |   26 +-
 drivers/clk/qcom/gcc-qcs404.c                      |    1 +
 drivers/cpufreq/loongson2_cpufreq.c                |    4 +-
 drivers/crypto/bcm/cipher.c                        |    5 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    6 +-
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/edac/bluefield_edac.c                      |    2 +-
 drivers/edac/fsl_ddr_edac.c                        |   22 +-
 drivers/firmware/arm_scpi.c                        |    3 +
 drivers/firmware/efi/tpm.c                         |   19 +-
 drivers/firmware/google/gsmi.c                     |   10 +-
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    1 +
 drivers/gpu/drm/drm_mm.c                           |    2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |    6 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |    3 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |   13 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |   40 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   21 +
 drivers/gpu/drm/fsl-dcu/Kconfig                    |    1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          |  154 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |    3 +
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |    6 +-
 drivers/gpu/drm/mcde/mcde_drv.c                    |    1 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   10 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |    1 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hid/wacom_wac.c                            |    4 +-
 drivers/i3c/master.c                               |    5 +-
 drivers/iio/adc/ad7780.c                           |    2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |    2 +-
 drivers/leds/led-class.c                           |   14 +-
 drivers/md/bcache/super.c                          |    2 +-
 drivers/md/dm-thin.c                               |    1 +
 drivers/media/dvb-core/dvbdev.c                    |   15 +-
 drivers/media/dvb-frontends/ts2020.c               |    8 +-
 drivers/media/i2c/tc358743.c                       |    4 +-
 drivers/media/platform/qcom/venus/core.c           |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    3 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/gspca/ov534.c                    |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   11 +
 drivers/message/fusion/mptsas.c                    |    4 +-
 drivers/mfd/da9052-spi.c                           |    2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c                 |  208 +-
 drivers/mfd/rt5033.c                               |    4 +-
 drivers/mfd/tps65010.c                             |    8 +-
 drivers/misc/apds990x.c                            |   12 +-
 drivers/misc/eeprom/eeprom_93cx6.c                 |   10 +
 drivers/mmc/core/bus.c                             |    2 +
 drivers/mmc/core/core.c                            |    3 +
 drivers/mmc/host/dw_mmc.c                          |    4 +-
 drivers/mmc/host/mmc_spi.c                         |    9 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |    8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |    2 -
 drivers/mtd/ubi/attach.c                           |   12 +-
 drivers/mtd/ubi/wl.c                               |    9 +-
 drivers/net/can/sun4i_can.c                        |   22 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |   13 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   19 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +
 drivers/net/usb/lan78xx.c                          |   11 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/nvme/host/core.c                           |    7 +-
 drivers/nvme/host/pci.c                            |   16 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   18 +-
 drivers/pci/controller/pcie-rockchip.h             |    4 +
 drivers/pci/hotplug/cpqphp_pci.c                   |   19 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    2 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/quirks.c                               |   15 +-
 drivers/pci/slot.c                                 |    4 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    2 +
 drivers/platform/x86/intel_bxtwc_tmu.c             |   22 +-
 drivers/power/avs/smartreflex.c                    |    4 +-
 drivers/power/supply/power_supply_core.c           |    2 -
 drivers/regulator/rk808-regulator.c                |    2 +
 drivers/rpmsg/qcom_glink_native.c                  |  175 +-
 drivers/rtc/interface.c                            |    7 +-
 drivers/rtc/rtc-ab-eoz9.c                          |    7 -
 drivers/rtc/rtc-abx80x.c                           |    2 +-
 drivers/rtc/rtc-st-lpc.c                           |    5 +-
 drivers/scsi/bfa/bfad.c                            |    3 +-
 drivers/scsi/qedf/qedf_main.c                      |    1 +
 drivers/scsi/qedi/qedi_main.c                      |    1 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |   10 -
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/st.c                                  |   31 +-
 drivers/sh/intc/core.c                             |    2 +-
 drivers/soc/qcom/qcom-geni-se.c                    |    3 +-
 drivers/soc/qcom/socinfo.c                         |    8 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/spi/spi.c                                  |   13 +-
 drivers/staging/comedi/comedi_fops.c               |   12 +
 drivers/staging/greybus/uart.c                     |    3 -
 drivers/staging/media/allegro-dvt/allegro-core.c   |    4 +-
 drivers/tty/serial/8250/8250_omap.c                |    4 +-
 drivers/tty/tty_ldisc.c                            |    2 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/gadget.c                          |    9 +-
 drivers/usb/gadget/composite.c                     |   18 +-
 drivers/usb/host/ehci-spear.c                      |    7 +-
 drivers/usb/misc/chaoskey.c                        |   35 +-
 drivers/usb/misc/iowarrior.c                       |   50 +-
 drivers/usb/misc/yurex.c                           |    5 +-
 drivers/usb/typec/tcpm/wcove.c                     |    4 -
 drivers/vfio/pci/vfio_pci_config.c                 |   16 +-
 drivers/video/fbdev/sh7760fb.c                     |   11 +-
 drivers/watchdog/iTCO_wdt.c                        |   21 +-
 drivers/watchdog/mtk_wdt.c                         |    6 +
 drivers/xen/xenbus/xenbus_probe.c                  |   31 +-
 drivers/xen/xenbus/xenbus_probe_backend.c          |   39 +
 fs/btrfs/ref-verify.c                              |    1 +
 fs/cifs/smb2ops.c                                  |    6 +
 fs/ext4/fsmap.c                                    |   54 +-
 fs/ext4/mballoc.c                                  |   18 +-
 fs/ext4/mballoc.h                                  |    1 +
 fs/ext4/super.c                                    |    8 +-
 fs/f2fs/inode.c                                    |    4 +-
 fs/hfsplus/hfsplus_fs.h                            |    3 +-
 fs/hfsplus/wrapper.c                               |    2 +
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jffs2/erase.c                                   |    7 +-
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/jfs/xattr.c                                     |    2 +-
 fs/nfs/nfs4proc.c                                  |    8 +-
 fs/nfsd/export.c                                   |    5 +-
 fs/nfsd/nfs4callback.c                             |   16 +-
 fs/nfsd/nfs4proc.c                                 |   14 +-
 fs/nfsd/nfs4recover.c                              |    3 +-
 fs/nfsd/nfs4state.c                                |   19 +
 fs/nilfs2/btnode.c                                 |    2 -
 fs/nilfs2/dir.c                                    |    2 +-
 fs/nilfs2/gcinode.c                                |    4 +-
 fs/nilfs2/mdt.c                                    |    1 -
 fs/nilfs2/page.c                                   |    2 +-
 fs/ocfs2/aops.h                                    |    2 +
 fs/ocfs2/dlmglue.c                                 |    1 +
 fs/ocfs2/file.c                                    |    4 +
 fs/ocfs2/localalloc.c                              |   19 -
 fs/ocfs2/namei.c                                   |    4 +-
 fs/ocfs2/resize.c                                  |    2 +
 fs/ocfs2/super.c                                   |   13 +-
 fs/overlayfs/util.c                                |    3 +
 fs/proc/softirqs.c                                 |    2 +-
 fs/quota/dquot.c                                   |    2 +
 fs/ubifs/super.c                                   |    6 +-
 fs/ubifs/tnc_commit.c                              |    2 +
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8data.h_shipped                      | 6703 ++++++++++----------
 include/linux/blkdev.h                             |    2 +-
 include/linux/cgroup-defs.h                        |    7 +-
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/jiffies.h                            |    2 +-
 include/linux/leds.h                               |    2 +-
 include/linux/netpoll.h                            |    2 +-
 include/linux/sunrpc/xprtsock.h                    |    1 +
 include/linux/util_macros.h                        |   56 +-
 include/uapi/linux/tipc.h                          |   21 +
 include/xen/xenbus.h                               |    3 +
 init/initramfs.c                                   |   15 +
 kernel/bpf/devmap.c                                |   68 +-
 kernel/bpf/lpm_trie.c                              |   27 +-
 kernel/cgroup/cgroup-internal.h                    |    3 +-
 kernel/cgroup/cgroup.c                             |   23 +-
 kernel/time/time.c                                 |    2 +-
 kernel/trace/ftrace.c                              |    3 +
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_event_perf.c                    |    6 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/string_helpers.c                               |    2 +-
 mm/shmem.c                                         |    2 -
 net/9p/trans_xen.c                                 |    9 +-
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |   10 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/filter.c                                  |   85 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/dccp/feat.c                                    |    6 +-
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/ipmr.c                                    |   50 +-
 net/ipv4/ipmr_base.c                               |    3 +-
 net/ipv4/tcp_bpf.c                                 |   11 +-
 net/ipv6/af_inet6.c                                |   22 +-
 net/ipv6/ip6mr.c                                   |    8 +-
 net/ipv6/route.c                                   |    6 +-
 net/mac80211/main.c                                |    2 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    7 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/xt_LED.c                             |    4 +-
 net/netlink/af_netlink.c                           |   31 +-
 net/netlink/af_netlink.h                           |    2 -
 net/packet/af_packet.c                             |   12 +-
 net/rfkill/rfkill-gpio.c                           |    8 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/xprtsock.c                              |   29 +-
 net/tipc/bearer.c                                  |   14 +-
 net/tipc/bearer.h                                  |    3 +
 net/tipc/node.c                                    |   99 +-
 net/tipc/node.h                                    |    1 +
 net/tipc/udp_media.c                               |    2 +-
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |    1 +
 scripts/mkcompile_h                                |    2 +-
 scripts/mod/file2alias.c                           |    5 +-
 scripts/mod/modpost.c                              |    2 +-
 security/apparmor/capability.c                     |    2 +
 sound/pci/hda/patch_realtek.c                      |  113 +-
 sound/soc/codecs/da7219.c                          |    9 +-
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/fsl/fsl_micfil.c                         |   74 +-
 sound/soc/fsl/fsl_micfil.h                         |  270 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   15 +
 sound/soc/stm/stm32_sai_sub.c                      |    6 +-
 sound/usb/6fire/chip.c                             |   10 +-
 sound/usb/caiaq/audio.c                            |   10 +-
 sound/usb/caiaq/audio.h                            |    1 +
 sound/usb/caiaq/device.c                           |   19 +-
 sound/usb/caiaq/input.c                            |   12 +-
 sound/usb/caiaq/input.h                            |    1 +
 sound/usb/clock.c                                  |   32 +-
 sound/usb/quirks.c                                 |   19 +-
 sound/usb/usx2y/us122l.c                           |    5 +-
 tools/perf/builtin-trace.c                         |   14 +-
 tools/perf/util/cs-etm.c                           |   25 +-
 tools/perf/util/probe-finder.c                     |   17 +-
 tools/testing/selftests/net/pmtu.sh                |    2 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |    3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |    6 +
 virt/kvm/arm/vgic/vgic-its.c                       |   32 +-
 virt/kvm/arm/vgic/vgic.h                           |   24 +
 315 files changed, 5960 insertions(+), 4907 deletions(-)


