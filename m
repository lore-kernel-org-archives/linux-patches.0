Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31C84F7987;
	Tue, 21 Jul 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647822; cv=none; b=EVLceOhQmuaJAcFtRtIPs+1uErh/o+RMnQYkHEOcQ9YNzBntbjqUAMAFOgP6Ui+YgdsNMeaAQa8Zr1jJdgNHA28r0eT/FOJwkLxCEzYp35MZ4vpqhra0uql9EDUtUNEMICsGKHgSKDndLeNRLlNAXkRB/CMCrf9RRcoWXcOZk48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647822; c=relaxed/simple;
	bh=yBq17AB+Hl85dv3ohsldK00k/vzSJTr4vKwbHbLISPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NSYmCYvSd28amztNqAIFsklLQN9pat11HO5FeSKZfsSN0P2ia/8Sm8gAQEYURaNK5py1WKhHdnZ1H06KIdidAeucJTZhLwttaHPIDxujaUGhs/ARf15WDk8yKQfzHJ40b/1jsJkIvbcWjUNhRSB4rSIw/IVbh/ml3wR+iAjcLKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bd18M5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bd18M5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAF1F00A3D;
	Tue, 21 Jul 2026 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647805;
	bh=VlC7ygJNst5rgXYAs8PdInA4bcDk78+ZG63E55MHkZ8=;
	h=From:To:Cc:Subject:Date;
	b=1bd18M5/wRnGfSW1N7499G1VOM2q1ZJAEacHanwyNJX+fgplXmC9U5FBi+Gntk+wc
	 3C+KHs0xchk6FBRaEyYO+iZ7k4DSqAsGTt+eSx8irRpfN0tb1xwRkzqf2DKmleS/Zw
	 bGvcQvy3tnxu0a9PmY9MfijmCLgOGpU2lQmICMoI=
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
Subject: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Date: Tue, 21 Jul 2026 16:54:33 +0200
Message-ID: <20260721152552.646164743@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.1.5-rc1
X-KernelTest-Deadline: 2026-07-23T15:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.1.5 release.
There are 2077 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.1.5-rc1

Thomas Gleixner <tglx@kernel.org>
    posix-cpu-timers: Prevent UAF caused by non-leader exec() race

Thomas Gleixner <tglx@kernel.org>
    posix-timers: Expand timer_[re]arm() callbacks with a boolean return value

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fix Color Manager (3DLUT, Shaper, Blend)

Christoph Hellwig <hch@lst.de>
    iomap: consolidate bio submission

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix implicit declaration of brelse()

Namjae Jeon <linkinjeon@kernel.org>
    exfat: add data_start_bytes and exfat_cluster_to_phys_bytes() helper

Namjae Jeon <linkinjeon@kernel.org>
    exfat: add balloc parameter to exfat_map_cluster() for iomap support

Namjae Jeon <linkinjeon@kernel.org>
    exfat: replace unsafe macros with static inline functions

Eric Biggers <ebiggers@kernel.org>
    crypto: xilinx-trng - Remove crypto_rng interface

Pratyush Yadav (Google) <pratyush@kernel.org>
    liveupdate: validate session type before performing operation

Mauricio Faria de Oliveira <mfo@igalia.com>
    usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()

Mauricio Faria de Oliveira <mfo@igalia.com>
    usb: atm: ueagle-atm: remove function entry/exit debug messages

Mauricio Faria de Oliveira <mfo@igalia.com>
    usb: atm: ueagle-atm: use dev_dbg() for 'device found' message

Christoph Hellwig <hch@lst.de>
    xfs: add newly added RTGs to the free pool in growfs

Christoph Hellwig <hch@lst.de>
    xfs: factor out a xfs_zone_mark_free helper

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use opener credentials for FSCTL mutations

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move compression definitions into common/fscc.h

Davide Ornaghi <d.ornaghi97@gmail.com>
    ksmbd: fix path resolution in ksmbd_vfs_kern_path_create

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix cyclic locking warning on netdev unregister

Chris Mason <clm@meta.com>
    binder: cache secctx size before release zeroes it

Jisheng Zhang <jszhang@kernel.org>
    binder: Use LIST_HEAD() to initialize on stack list head

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda/tas2781: Cancel async firmware request at unbind

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    firmware_loader: Add cancel helper for async requests

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Update offsets for 2i2 Gen 4 firmware 2417

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Allow selecting config_set by firmware version

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-rotation: Fix stale or zero output when reading raw values

Keshav Verma <iganschel@gmail.com>
    f2fs: fix listxattr handling of corrupted xattr entries

Chao Yu <chao@kernel.org>
    f2fs: fix potential deadlock in gc_merge path of f2fs_balance_fs()

Ruipeng Qi <ruipengqi3@gmail.com>
    f2fs: fix potential deadlock in f2fs_balance_fs()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    device property: initialize the remaining fields of fwnode_handle in fwnode_init()

Zenghui Yu <yuzenghui@huawei.com>
    samples/damon/mtier: fail early if address range parameters are invalid

SeongJae Park <sj@kernel.org>
    mm/damon/core: trace esz at first setup

Sun Jian <sun.jian.kdev@gmail.com>
    bpf: Reject negative const offsets for buffer pointers

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: fix resume error handling

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: make non-fatal errors non-blocking in suspend

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: use pm_runtime_resume_and_get() in suspend

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: disable irq during suspend to fix unhandled interrupt

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: fix esdhc_change_pinstate() to allow default state restore

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: restore DLL override for DDR modes on resume

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: remove unnecessary mmc_card_wake_sdio_irq check for tuning save/restore

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    mmc: sdhci-of-dwcmshc: check bus clock enable result in the probe() method

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: mmc_test: Fix __counted_by handling after kzalloc_flex() conversion

Ao Sun <ao.sun@transsion.com>
    mmc: block: fix RPMB device unregister ordering

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: lpc32xx_slc: fail DMA transfer on completion timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: lpc32xx_mlc: fail DMA transfers on timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: fsl_ifc: return errors for failed page reads

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mmc: vub300: defer reset until cmd_mutex is unlocked

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: mchp23k256: use SPI match data for chip caps

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: onenand: samsung: report DMA completion timeouts

Xu Rao <raoxu@uniontech.com>
    mtd: virt-concat: free duplicate generated name

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: fix permanently busy scans after multiple roam iterations

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate extension-frame layout before RX

Zhiling Zou <roxy520tt@gmail.com>
    wifi: mac80211: free ack status frame on TX header build failure

Zhao Li <enderaoelyther@gmail.com>
    wifi: ieee80211: validate MLE common info length

Haofeng Li <lihaofeng@kylinos.cn>
    wifi: cfg80211: validate EHT MLE before MLD ID read

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    powerpc/uaccess: correct check for CONFIG_PPC_E500 in mask_user_address()

Junrui Luo <moonafterrain@outlook.com>
    powerpc/spufs: fix out-of-bounds access in spufs_mem_mmap_access()

Zhao Dongdong <zhaodongdong@kylinos.cn>
    reset: sunxi: fix memory region leak on ioremap failure

Robby Cai <robby.cai@nxp.com>
    reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ

Florian Westphal <fw@strlen.de>
    ipvs: reload ip header after head reallocation

Julian Anastasov <ja@ssi.bg>
    ipvs: fix more places with wrong ipv6 transport offsets

Maoyi Xie <maoyixie.tju@gmail.com>
    memstick: ms_block: reject a card that reports too many blocks

James Raphael Tiovalen <jamestiotio@gmail.com>
    macsec: fix promiscuity refcount leak in macsec_dev_open()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    llc: fix SAP refcount leak when creating incoming sockets

Eric Biggers <ebiggers@kernel.org>
    crypto: aes - Fix conditions for selecting MAC dependencies

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btrtl: validate firmware patch bounds

Asim Viladi Oglu Manizada <manizada@pm.me>
    net: openvswitch: reject oversized nested action attrs

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: Fix incorrect IRQSTAT bit offsets

Aurelien Jarno <aurelien@aurel32.net>
    arch/riscv: vdso: remove CFI landing pad from rt_sigreturn

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: vdso: Do not use LTO for the vDSO

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: brcmfmac: cyw: fix heap overflow on a short auth frame

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: mac80211: fix memory leak in ieee80211_register_hw()

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: fix roaming to different channel in host_mlme mode

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: rt2x00: avoid full teardown before work setup in probe

Zhiping Zhang <zhipingz@meta.com>
    net/mlx5: free mlx5_st_idx_data on final dealloc

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/pseries: fix memory leak on krealloc failure in papr_init

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: restore pinctrl before restoring ios timing on resume

Thomas Huth <thuth@redhat.com>
    selftests/landlock: Fix screwed up pointers in the scoped_signal_test

Thomas Huth <thuth@redhat.com>
    selftests/landlock: Skip scoped_signal subtest with MSG_OOB if not available

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: Fix i.MX8MP VC8000E power up sequence

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: Fix i.MX8MP power notifier

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    pmdomain: mediatek: Fix possible nullptr KP in HWV cleanup/on-check

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI

Farhad Alemi <farhad.alemi@berkeley.edu>
    cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed

Hui Wang <hui.wang@canonical.com>
    selftests/rseq: Fix a building error for riscv arch

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Fix type mismatch in get_align_mask().

Heiko Carstens <hca@linux.ibm.com>
    s390/diag: Add missing array_index_nospec() call to memtop_get_page_count()

Crystal Wood <crwood@redhat.com>
    tracing/osnoise: Call synchronize_rcu() when unregistering

Tao Liu <ltao@redhat.com>
    riscv: Prevent NULL pointer dereference in machine_kexec_prepare()

Michael Bommarito <michael.bommarito@gmail.com>
    drbd: reject data replies with an out-of-range payload size

TJ Adams <tadamsjr@google.com>
    ata: libata-core: Allow capacity transition to zero for locked drives

TJ Adams <tadamsjr@google.com>
    ata: libata-core: Skip HPA resize for locked drives

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Free mon_data structures on rdt_get_tree() failure

Jinjie Ruan <ruanjinjie@huawei.com>
    cpu/hotplug: Fix NULL kobject warning in cpuhp_smt_enable()

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: smp: Fix hot-unplug tearing by forcing unregistration

Zhu Lingshan <lingshan.zhu@amd.com>
    amdkfd: properly free secondary context id

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: drop in-flight Tx SKBs on close

Dust Li <dust.li@linux.alibaba.com>
    dibs: loopback: validate offset and size in move_data()

Daehyeon Ko <4ncienth@gmail.com>
    macsec: don't read an unset MAC header in macsec_encrypt()

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: reset full ip_vs_seq structs in ip_vs_conn_new

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: use parsed transport offset in SCTP state lookup

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    llc: fix SAP refcount leak in llc_ui_autobind()

Nirmoy Das <nirmoyd@nvidia.com>
    selftests: net: make busywait timeout clock portable

Dawei Feng <dawei.feng@seu.edu.cn>
    octeontx2-pf: fix SQB pointer leak on init failure

Yousef Alhouseen <alhouseenyousef@gmail.com>
    mac802154: remove interfaces with RCU list deletion

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/monwriter: Reject buffer reuse with different data length

Haoxiang Li <haoxiang_li2024@163.com>
    irqchip/irq-riscv-imsic-early: Fix fwnode leak on state setup failure

Zi Yan <ziy@nvidia.com>
    mm/compaction: handle free_pages_prepare() properly in compaction_free()

Martin Kaiser <martin@kaiser.cx>
    riscv: probes: save original sp in rethook trampoline

HyeongJun An <sammiee5311@gmail.com>
    hwmon: (asus_atk0110) Check package count before accessing element

Haoxiang Li <haoxiang_li2024@163.com>
    net: ipa: fix SMEM state handle leaks in SMP2P init

Maoyi Xie <maoyixie.tju@gmail.com>
    net: wwan: iosm: bound device offsets in the MUX downlink decoder

Bryam Vargas <hexlabsecurity@proton.me>
    ata: libata-core: Reject an invalid concurrent positioning ranges count

Wentao Liang <vulab@iscas.ac.cn>
    ata: pata_pxa: Fix DMA channel leak on probe error

Bryam Vargas <hexlabsecurity@proton.me>
    ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD

Dawei Feng <dawei.feng@seu.edu.cn>
    net/mlx5: HWS, fix matcher leak on resize target setup failure

Bryam Vargas <hexlabsecurity@proton.me>
    orangefs: keep the readdir entry size 64-bit in fill_from_part()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix double addition of offset for @+FOFFSET

Joshua Crofts <joshua.crofts1@gmail.com>
    hwmon: (max1619) add missing 'select REGMAP' to Kconfig

David Lee <david.lee@trailofbits.com>
    fhandle: reject detached mounts in capable_wrt_mount()

Bryam Vargas <hexlabsecurity@proton.me>
    net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Bryam Vargas <hexlabsecurity@proton.me>
    net/sched: sch_multiq: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Andrea Righi <arighi@nvidia.com>
    net: lan743x: Initialize eth_syslock spinlock before use

Haoxiang Li <haoxiang_li2024@163.com>
    fsl/fman: Free init resources on KeyGen failure in fman_init()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    hwmon: (occ) unregister sysfs devices outside occ lock

Xu Rao <raoxu@uniontech.com>
    ACPI: TAD: Check AC wake capability before enabling wakeup

Haoxiang Li <haoxiang_li2024@163.com>
    net: liquidio: fix BAR resource leak on PF number failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (w83793) remove vrm sysfs file on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (w83627hf) remove VID sysfs files on error and remove

Conor Dooley <conor.dooley@microchip.com>
    rtc: mpfs: fix counter upload completion condition

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Replace mk_users keyring with simple list

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: renesas-rtca3: Fix PIE clear polling condition in alarm setup error path

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()

Wentao Liang <vulab@iscas.ac.cn>
    ipmi: fix refcount leak in i_ipmi_request()

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: use sk_msg_free_partial to fix partial send

Matt Fleming <mfleming@cloudflare.com>
    ipmi: Fix user refcount underflow in event delivery

Hongchen Zhang <zhanghongchen@loongson.cn>
    LoongArch: Fix missing dirty page tracking in {pte,pmd}_wrprotect()

Xuewen Wang <wangxuewen@kylinos.cn>
    LoongArch: Fix nr passing in set_direct_map_valid_noflush()

Biju Das <biju.das.jz@bp.renesas.com>
    pwm: rzg2l-gpt: Fix period_ticks type from u32 to u64

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: vdso: Always declare vdso_start symbols

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_perms()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master on updates

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/userptr: Stub notifier_lock helpers when DRM_GPUSVM=n

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Define acpi_ut_safe_strncpy() as strscpy_pad() alias

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: move rcu_read_lock()/spin_lock() from _bh variants

Daniel Gibson <daniel@gibson.sh>
    platform/x86/amd/pmc: Avoid logging "(null)" for DMI values

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: fix stack buffer overflow in multichannel session-key copy

Junrui Luo <moonafterrain@outlook.com>
    octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF

Ankit Garg <nktgrg@google.com>
    gve: fix header buffer corruption with header-split and HW-GRO

Shitalkumar Gandhi <shital.gandhi45@gmail.com>
    ieee802154: ca8210: fix pointer truncation in kfifo on 64-bit

Shitalkumar Gandhi <shital.gandhi45@gmail.com>
    ieee802154: ca8210: fix cas_ctl leak on spi_async failure

Michael Bommarito <michael.bommarito@gmail.com>
    ieee802154: allow legacy LLSEC ADD/DEL ops to pass strict validation

Michael Bommarito <michael.bommarito@gmail.com>
    ieee802154: admin-gate legacy LLSEC dump operations

Haoxiang Li <haoxiang_li2024@163.com>
    octeontx2-af: Free BPID bitmap on setup failure

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_gre: require CAP_NET_ADMIN in the device netns for changelink

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ipip: require CAP_NET_ADMIN in the device netns for changelink

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip_vti: require CAP_NET_ADMIN in the device netns for changelink

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_vti: require CAP_NET_ADMIN in the device netns for changelink

Dawei Feng <dawei.feng@seu.edu.cn>
    net: ena: clean up XDP TX queues when regular TX setup fails

Ross Porter <ross.porter@canonical.com>
    selftests: net: fix file owner for broadcast_ether_dst test

Zihan Xi <xizh2024@lzu.edu.cn>
    net/sched: act_ct: preserve tc_skb_cb across defragmentation

Haoxiang Li <haoxiang_li2024@163.com>
    net: ixp4xx_hss: fix duplicate HDLC netdev allocation

Haoxiang Li <haoxiang_li2024@163.com>
    net: wwan: t7xx: destroy DMA pool on CLDMA late init failure

Philippe Schenker <philippe.schenker@impulsing.ch>
    net: ethernet: ti: icssg: guard PA stat lookups

Maoyi Xie <maoyixie.tju@gmail.com>
    net: sit: require CAP_NET_ADMIN in the device netns for changelink

Andreas Kemnade <andreas@kemnade.info>
    gpios: palmas: add .get_direction() op

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: avoid corruption of shared interrupt trigger state

Paul Louvel <paul.louvel@bootlin.com>
    gpio-f7188x: Add support for NCT6126D version B

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: be sure IRQ domain is created before exposing GPIO chips

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: tegra: do not call pinctrl for GPIO direction

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: more robust management of IRQ domain teardown

Dexuan Cui <decui@microsoft.com>
    net: mana: Sync page pool RX frags for CPU

Dexuan Cui <decui@microsoft.com>
    net: mana: Validate the packet length reported by the NIC

Bradley Morgan <include@grrlz.net>
    cpu: hotplug: Bound hotplug states sysfs output

Bradley Morgan <include@grrlz.net>
    cpu: hotplug: Preserve per instance callback errors

Cao Ruichuang <create0818@163.com>
    selftests/ftrace: Drop invalid top-level local in test_ownership

Zhan Xusheng <zhanxusheng1024@gmail.com>
    posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()

Thomas Gleixner <tglx@kernel.org>
    locking/rt: Fix the incorrect RCU protection in rt_spin_unlock()

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()

Michael Bommarito <michael.bommarito@gmail.com>
    tracing/user_events: Fix use-after-free in user_event_mm_dup()

Doruk Tan Ozturk <doruk@0sec.ai>
    net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix type confusion in CDC union descriptor parsing

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix race condition in reset_device sysfs callback

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix logic error in packet reset

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix firmware leak in async update

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix DMA mapping violation in line setup

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - add response length checks

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - validate control endpoint type

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - release data interface on disconnect

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - only expose sysfs attributes on control interface

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix use-after-free and double-free in disconnect

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Fix use-after-free during unmount

Haoxiang Li <haoxiang_li2024@163.com>
    scsi: elx: efct: Fix I/O leak on unsupported additional CDB

WenTao Liang <vulab@iscas.ac.cn>
    scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()

Bryam Vargas <hexlabsecurity@proton.me>
    scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER AND MOVE

Bryam Vargas <hexlabsecurity@proton.me>
    scsi: target: Bound PR-OUT TransportID parsing to the received buffer

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: xen: scsiback: Free unsubmitted command instead of double-putting it

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: xen: scsiback: Free the command tag on the TMR submit-failure path

Xu Rao <raoxu@uniontech.com>
    scsi: sg: Report request-table problems when any status is set

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()

Haoxiang Li <haoxiang_li2024@163.com>
    scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path

Jhonraushan <raushan.jhon@gmail.com>
    accel/ivpu: Reject firmware log with size smaller than header

Shuvam Pandey <shuvampandey1@gmail.com>
    accel/amdxdna: Use caller client for debug BO sync

Doruk Tan Ozturk <doruk@0sec.ai>
    accel/amdxdna: reject user command submission without a command BO

Doruk Tan Ozturk <doruk@0sec.ai>
    accel/amdxdna: reject command submission on devices without a submit op

Wentao Liang <vulab@iscas.ac.cn>
    accel/amdxdna: Fix use-after-free in amdxdna_gem_dmabuf_mmap()

Philipp Stanner <phasta@kernel.org>
    dma-buf: dma-fence: Fix potential NULL pointer dereference

André Draszik <andre.draszik@linaro.org>
    dma-fence: use correct callback in dma_fence_timeline_name()

Baineng Shou <shoubaineng@gmail.com>
    dma-fence: Make dma_fence_dedup_array() robust against 0-count input

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: make error counter atomic

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: increase sprintf buffer size

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix a possible NULL pointer dereference

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: avoid double increment of &use_bh_wq_enabled

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix buffer overflow in FEC calculation

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't increment hash_offset twice

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a bug if the bio is out of limits

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix leaking uninitialized kernel memory

Mikulas Patocka <mpatocka@redhat.com>
    dm_early_create: fix freeing used table on dm_resume failure

Ingo Blechschmidt <iblech@speicherleck.de>
    dm: avoid leaking the caller's thread keyring via the table device file

Mikulas Patocka <mpatocka@redhat.com>
    dm-stats: fix merge accounting

Mikulas Patocka <mpatocka@redhat.com>
    dm-stats: fix dm_jiffies_to_msec64

Samuel Moelius <sam.moelius@trailofbits.com>
    dm-pcache: reject option groups without values

Benjamin Marzinski <bmarzins@redhat.com>
    dm-log: fix a bitset_size overflow on 32bit machines

Mikulas Patocka <mpatocka@redhat.com>
    dm-ioctl: fix a possible overflow in list_version_get_info

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix wrong count calculation in dm_bufio_issue_discard

Samuel Moelius <sam.moelius@trailofbits.com>
    dm era: fix out-of-bounds memory access for non-zero start sector

Ming-Hung Tsai <mtsai@redhat.com>
    dm thin metadata: fix metadata snapshot consistency on commit failure

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm thin metadata: fix superblock refcount leak on snapshot shadow failure

Haoxiang Li <haoxiang_li2024@163.com>
    net: sparx5: unregister blocking notifier on init failure

Yitang Yang <yi1tang.yang@gmail.com>
    block: fix IORING_URING_CMD_REISSUE flags check in blkdev_uring_cmd

Mike Waychison <mike@waychison.com>
    block: fix race in blk_time_get_ns() returning 0

Connor Williamson <connordw@amazon.com>
    block: remove redundant GD_NEED_PART_SCAN in add_disk_final()

Sun Jian <sun.jian.kdev@gmail.com>
    selftests/bpf: Cover negative buffer pointer offsets

Jiri Olsa <jolsa@kernel.org>
    bpf: Add missing access_ok call to copy_user_syms

Jann Horn <jannh@google.com>
    bpf,fork: wipe ->bpf_storage before bailouts that access it

Tristan Madani <tristan@talencesecurity.com>
    bpf: Reset register bounds before narrowing retval range in check_mem_access()

Woraphat Khiaodaeng <worapat.kd2@gmail.com>
    io_uring/bpf-ops: reject re-registration of an already-bound ops

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing device refcount for CAN filter removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: validate frame length in bcm_rx_setup() for RTR replies

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: track a single source interface for ANYDEV timeout/throttle ops

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix stale rx/tx ops after device removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix data race on rx_stamp/rx_ifindex in bcm_rx_handler()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix CAN frame rx/tx statistics

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: extend bcm_tx_lock usage for data and timer updates

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing rcu list annotations and operations

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking when updating filter and timer values

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix lockless bound/ifindex race and silent RX_SETUP failure

Lee Jones <lee@kernel.org>
    can: bcm: defer rx_op deallocation to workqueue to fix thrtimer UAF

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: serialize TX state transitions under so->rx_lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix use-after-free race with concurrent NETDEV_UNREGISTER

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: use unconditional synchronize_rcu() in isotp_release()

Fan Wu <fanwu01@zju.edu.cn>
    can: esd_usb: kill anchored URBs before freeing netdevs

Souvik Banerjee <souvik@amlalabs.com>
    ovl: use linked upper dentry in copy-up tmpfile

Maoyi Xie <maoyixie.tju@gmail.com>
    netdev-genl: report NAPI thread PID in the caller's pid namespace

Wentao Liang <vulab@iscas.ac.cn>
    nvmet: fix refcount leak in nvmet_sq_create()

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet-rdma: handle inline data with a nonzero offset

Michael Bommarito <michael.bommarito@gmail.com>
    nvmet-auth: reject short AUTH_RECEIVE buffers

Nick Chan <towinchenmi@gmail.com>
    nvme-apple: Prevent shared tags across queues on Apple A11

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFS: Charge unstable writes by request size, not folio size

Weiming Shi <bestswngs@gmail.com>
    sctp: validate STALE_COOKIE cause length before reading staleness

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    spi: uniphier: Fix completion initialization order before devm_request_irq()

Javier Fernandez Pastrana <javier.pastrana@linutronix.de>
    spi: imx: reconfigure for PIO when DMA cannot be started

Wang Yan <wangyan01@kylinos.cn>
    time: Fix off-by-one in compat settimeofday() usec validation

Jaewon Yang <yong010301@gmail.com>
    tpm: Make the TPM character devices non-seekable

Thorsten Blum <thorsten.blum@linux.dev>
    tpm: fix event_size output in tpm1_binary_bios_measurements_show

Maoyi Xie <maoyixie.tju@gmail.com>
    xfrm: xfrm_interface: require CAP_NET_ADMIN in the device netns for changelink

Sanman Pradhan <psanman@juniper.net>
    xfrm: use compat translator only for u64 alignment mismatch

Qianyu Luo <qianyuluo3@gmail.com>
    xfrm: nat_keepalive: avoid double free on send error

Wentao Liang <vulab@iscas.ac.cn>
    xen/gntdev: fix error handling in ioctl

Steven Rostedt <rostedt@goodmis.org>
    ufs: core: tracing: Do not dereference pointers in TP_printk()

Dmitry Safonov <0x7f454c46@gmail.com>
    tcp: Decrement tcp_md5_needed static branch

Michael Bommarito <michael.bommarito@gmail.com>
    tcp: defer md5sig_info kfree past RCU grace period in tcp_connect

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix ice_init_link() error return preventing probe

Pei Xiao <xiaopei01@kylinos.cn>
    i2c: spacemit: fix spurious IRQ handling returning IRQ_HANDLED

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()

Roman Vivchar <rva333@protonmail.com>
    i2c: mediatek: fix WRRD for SoCs without auto_restart option

Vincent Jardin <vjardin@free.fr>
    i2c: imx: fix locked bus on SMBus block-read of 0 (IRQ)

Vincent Jardin <vjardin@free.fr>
    i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)

Joshua Crofts <joshua.crofts1@gmail.com>
    hwmon: (max6697) add missing 'select REGMAP_I2C' to Kconfig

Joshua Crofts <joshua.crofts1@gmail.com>
    hwmon: (ltc2992) add missing 'select REGMAP_I2C' to Kconfig

Ibrahim Hashimov <security@auditcode.ai>
    ksmbd: fix integer overflow in set_file_allocation_info()

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: use kvzalloc() for megabyte buffer in simple fallocate

Holger Dengler <dengler@linux.ibm.com>
    pkey: Move keytype check from pkey api to handler

Daniel Gibson <daniel@gibson.sh>
    platform/x86/amd/pmc: Don't log during intermediate wakeups

Daniel Gibson <daniel@gibson.sh>
    platform/x86/amd/pmc: Add delay_suspend module parameter

Daniel Gibson <daniel@gibson.sh>
    platform/x86/amd/pmc: Delay suspend for some Lenovo Laptops

Daniel Gibson <daniel@gibson.sh>
    platform/x86/amd/pmc: Check for intermediate wakeup in function

Srinivas Pandruvada <srinivas.pandruvada@intel.com>
    platform/x86: ISST: Restore SST-PP control to all domains

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add support for Omen 16-ap0xxx (8E35)

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add support for Omen 16-ap0xxx (8D26)

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    platform/x86: dell-laptop: fix missing cleanups in init error path

ZhaoJinming <zhaojinming@uniontech.com>
    platform/x86/intel/tpmi: use cleanup helpers in mem_write()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    dmaengine: sh: rz-dmac: Move interrupt request after everything is set up

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma-pcie: Reject devices without driver data

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    dmaengine: sh: rz-dmac: Fix incorrect NULL check for list_first_entry()

Frank Li <Frank.Li@nxp.com>
    dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK

Kartik Rajput <kkartik@nvidia.com>
    dmaengine: tegra: Fix burst size calculation

Hongling Zeng <zenghongling@kylinos.cn>
    sunrpc: fix uninitialized xprt_create_args structure

Michael Bommarito <michael.bommarito@gmail.com>
    tpm: tpm2-sessions: wait for async KPP completion in tpm_buf_append_salt

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()

Baoli Zhang <baoli.zhang@linux.intel.com>
    tpm: restore timeout for key creation commands

Bhargav Joshi <j.bhargav.u@gmail.com>
    irqchip/crossbar: Use correct index in crossbar_domain_free()

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: retain dead thread stats in TGID queries

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix NULL pointer dereference in initialization

Stafford Horne <shorne@gmail.com>
    openrisc: Fix jump_label smp syncing

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Pause continuous reads at block boundaries

Takahiro Kuwano <takahiro.kuwano@infineon.com>
    mtd: spi-nor: spansion: use die erase for multi-die devices only

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: swp: Improve locking user experience

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Check length in pkey_pckmo handler implementation

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Check length in PKEY_VERIFYPROTK ioctl

Sebastian Alba Vives <sebasjosue84@gmail.com>
    fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_header()

Maoyi Xie <maoyixie.tju@gmail.com>
    net: thunderbolt: Fix frags[] overflow by bounding frame_count

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    bus: mhi: host: pci_generic: Fix the physical function check

Sebastian Alba Vives <sebasjosue84@gmail.com>
    fpga: dfl: add bounds check in dfh_get_param_size()

Michael Bommarito <michael.bommarito@gmail.com>
    ocfs2: reject non-inline dinodes with i_size and zero i_clusters

Michael Bommarito <michael.bommarito@gmail.com>
    ocfs2: reject dinodes whose i_rdev disagrees with the file type

Michael Bommarito <michael.bommarito@gmail.com>
    ocfs2: reject dinodes with non-canonical i_mode type

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: add journal NULL check in ocfs2_checkpoint_inode()

Ian Bridges <icb@fastmail.org>
    ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec

Ian Bridges <icb@fastmail.org>
    ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits

Kyle Zeng <kylebot@openai.com>
    ocfs2: avoid moving extents to occupied clusters

Arseniy Krasnov <avkrasnov@rulkc.org>
    mtd: rawnand: fix condition in 'nand_select_target()'

Vasiliy Kovalev <kovalev@altlinux.org>
    net/9p: fix infinite loop in p9_client_rpc on fatal signal

Bastien Curutchet <bastien.curutchet@bootlin.com>
    mtd: rawnand: pl353: fix probe resource allocation

Tristan Madani <tristan@talencesecurity.com>
    ocfs2: use kzalloc for quota recovery bitmap allocation

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Stafford Horne <shorne@gmail.com>
    openrisc: Add full instruction cache invalidate functions

Ionut Nechita <ionut.nechita@windriver.com>
    scsi: sas: Skip opt_sectors when DMA reports no real optimization hint

Pratyush Yadav (Google) <pratyush@kernel.org>
    kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES

Martin Wilck <martin.wilck@suse.com>
    scsi: smartpqi: Use shost_to_hba() in pqi_scan_finished()

Alexey Charkov <alchark@flipper.net>
    power: supply: bq257xx: Fix VSYSMIN clamping logic

Breno Leitao <leitao@debian.org>
    9p: skip nlink update in cacheless mode to fix WARN_ON

Ruoyu Wang <ruoyuw560@gmail.com>
    mtd: slram: remove failed entries from the device list

Karl Mehltretter <kmehltretter@gmail.com>
    kcov: use WRITE_ONCE() for selftest mode stores

Muchun Song <muchun.song@linux.dev>
    mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE

Amit Machhiwal <amachhiw@linux.ibm.com>
    powerpc/dt_cpu_ftrs: Set CPU_FTR_P11_PVR for Power11 and later processors

Jinjiang Tu <tujinjiang@huawei.com>
    fs/proc: fix KPF_KSM reported for all anonymous pages

Krzysztof Wilczyński <kwilczynski@kernel.org>
    proc: only bump parent nlink when registering directories

Dev Jain <dev.jain@arm.com>
    fs/proc/task_mmu: do not warn on seeing non-migration pmd entry

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()

SeongJae Park <sj@kernel.org>
    mm/damon/core: always put unsuccessfully committed target pids

Zishun Yi <vulab@iscas.ac.cn>
    riscv: cacheinfo: Fix node reference leak in populate_cache_leaves

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade

Aaron Tomlin <atomlin@atomlin.com>
    mips: sched: Fix CPUMASK_OFFSTACK memory corruption

Bryam Vargas <hexlabsecurity@proton.me>
    selftests/landlock: Test SCOPE_SIGNAL on the SIGIO/fowner pgid path

WenTao Liang <vulab@iscas.ac.cn>
    power: supply: charger-manager: fix refcount leak in is_full_charged()

Bryam Vargas <hexlabsecurity@proton.me>
    landlock: Fix LANDLOCK_SCOPE_SIGNAL bypass on the SIGIO path

Peiyang He <peiyang_he@smail.nju.edu.cn>
    ntfs: fix hole runlist memory leak in insert range error path

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: fix WARN_ON for resident attribute in ntfs_map_runlist_nolock()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: make system files immutable to prevent corruption

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: avoid self-deadlock during inode eviction

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: sanitize MFT references returned from ntfs_lookup_inode_by_name()

Peiyang He <peiyang_he@smail.nju.edu.cn>
    ntfs: fail attrlist updates when the superblock is inactive

Peiyang He <peiyang_he@smail.nju.edu.cn>
    ntfs: fix mrec_lock ABBA deadlock in rename

Tristan Madani <tristan@talencesecurity.com>
    ntfs3: fix out-of-bounds read in decompress_lznt

Michael Bommarito <michael.bommarito@gmail.com>
    ntfs3: validate split-point offset in indx_insert_into_buffer

Michael Bommarito <michael.bommarito@gmail.com>
    ntfs3: bound to_move in indx_insert_into_root before hdr_insert_head

Michael Bommarito <michael.bommarito@gmail.com>
    ntfs3: cap RESTART_TABLE free-chain walker at rt->used

Michael Bommarito <michael.bommarito@gmail.com>
    fs/ntfs3: bound NTFS_DE view.data_off in UpdateRecordData{Root,Allocation}

Michael Bommarito <michael.bommarito@gmail.com>
    fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overflow

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: validate lcns_follow in log_replay conversion

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: bound attr_off in UpdateResidentValue against data_off

Michael Bommarito <michael.bommarito@gmail.com>
    fs/ntfs3: bound copy_lcns dp->page_lcns[] index in analysis pass

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: bound DeleteIndexEntryAllocation memmove length

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename

DaeMyung Kang <charsyam@gmail.com>
    ntfs: reject non-resident records for resident-only attributes

DaeMyung Kang <charsyam@gmail.com>
    ntfs: validate resident index root values on lookup

DaeMyung Kang <charsyam@gmail.com>
    ntfs: validate resident volume name values on lookup

DaeMyung Kang <charsyam@gmail.com>
    ntfs: do not replace volume name after lookup errors

Samuel Moelius <sam.moelius@trailofbits.com>
    ntfs: detect mapping-pairs LCN accumulator overflow

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: validate index entries on reading

DaeMyung Kang <charsyam@gmail.com>
    ntfs: avoid heap allocation for free-cluster readahead state

DaeMyung Kang <charsyam@gmail.com>
    ntfs: only alias volume $UpCase to default on exact match

DaeMyung Kang <charsyam@gmail.com>
    ntfs: reinit search context before volume information lookup

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: skip extent mft records in writeback to prevent deadlock

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: centalize $INDEX_ROOT header validation

DaeMyung Kang <charsyam@gmail.com>
    ntfs: update index root allocated size before shrink

DaeMyung Kang <charsyam@gmail.com>
    ntfs: free volume-wide resources on fill_super failure

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: validate index block header more strictly

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: not change 0-byte $DATA attribute to non-resident

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: add bounds check before accessing EA entries

DaeMyung Kang <charsyam@gmail.com>
    ntfs: validate attribute values on lookup

Marco Crivellari <marco.crivellari@suse.com>
    ntfs: Add WQ_PERCPU to alloc_workqueue users

Ron de Bruijn <rmbruijn@gmail.com>
    ntfs: fix off-by-one in mapping pairs decoding bounds checks

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: fix incorrect size of symbolic link

DaeMyung Kang <charsyam@gmail.com>
    ntfs: grow index root value before reparent header update

SeongJae Park <sj@kernel.org>
    mm/damon/core: make charge_addr_from aware of end-address exclusivity

Muchun Song <muchun.song@linux.dev>
    mm/memory_hotplug: fix incorrect altmap passing in error path

Deepanshu Kartikey <kartikey406@gmail.com>
    mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch

Johan Hovold <johan@kernel.org>
    power: supply: max17042: fix OF node reference imbalance

Ma Ke <make24@iscas.ac.cn>
    power: supply: cpcap-battery: Fix missing nvmem_device_put() causing reference leak

Muchun Song <muchun.song@linux.dev>
    mm/mm_init: fix pageblock migratetype for ZONE_DEVICE compound pages

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: DEC: Ensure 32-bit stack location for o32 prom_printf()

Johan Hovold <johan@kernel.org>
    MIPS: ip22-gio: fix device reference leak in probe

Johan Hovold <johan@kernel.org>
    MIPS: ip22-gio: fix kfree() of static object

Johan Hovold <johan@kernel.org>
    MIPS: ip22-gio: fix gio device memory leak

Muchun Song <muchun.song@linux.dev>
    mm/sparse-vmemmap: fix vmemmap accounting underflow

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: xlnx: Check remote core state

Wasim Nazir <wasim.nazir@oss.qualcomm.com>
    remoteproc: qcom: Fix leak when custom dump_segments addition fails

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Bound-check xdr_buf_to_bvec() stores before writing

Chuck Lever <chuck.lever@oracle.com>
    lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure

Chuck Lever <chuck.lever@oracle.com>
    lockd: Plug nlm_file leak when nlm_do_fopen() fails

Luxiao Xu <rakukuip@gmail.com>
    sunrpc: harden rq_procinfo lifecycle to prevent double-free

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: wait for in-flight TLS handshake callback when cancel loses race

Chris Mason <clm@meta.com>
    sunrpc: pin svc_xprt across the asynchronous TLS handshake callback

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    nvdimm/btt: Free arena sub-allocations on discover_arenas() error path

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    nvdimm/btt: Free arenas on btt_init() error paths

Junrui Luo <moonafterrain@outlook.com>
    jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()

Terry Bowman <terry.bowman@amd.com>
    cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size

Duje Mihanović <duje@dujemihanovic.xyz>
    backlight: ktd2801: Enable BL_CORE_SUSPENDRESUME

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    mfd: tps6586x: Fix OF node refcount

Shyam Prasad N <sprasad@microsoft.com>
    cifs: invalidate cfid on unlink/rename/rmdir

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: prevent TVLV OOB check overflow

Sven Eckelmann <sven@narfation.org>
    batman-adv: mcast: avoid OOB read of num_dests header

Sven Eckelmann <sven@narfation.org>
    batman-adv: frag: fix primary_if leak on failed linearization

Sven Eckelmann <sven@narfation.org>
    batman-adv: clean untagged VLAN on netdev registration failure

Sven Eckelmann <sven@narfation.org>
    batman-adv: frag: free unfragmentable packet

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix VLAN priority offset

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: avoid request storms during pending request

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: fix tie-break for candidate selection

Sven Eckelmann <sven@narfation.org>
    batman-adv: ensure minimal ethernet header on TX

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: ensure accessible eth_hdr proto field

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: reacquire gw address after skb realloc

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: acquire ARP hw source only after skb realloc

Sven Eckelmann <sven@narfation.org>
    batman-adv: access unicast_ttvn skb->data only after skb realloc

Sven Eckelmann <sven@narfation.org>
    batman-adv: retrieve ethhdr after potential skb realloc on RX

Sven Eckelmann <sven@narfation.org>
    batman-adv: gw: acquire ethernet header only after skb realloc

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Set non-turbo capacity to HWP_GUARANTEED_PERF()

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Fix uncleared need_freq_update on the .adjust_perf() path

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/lbr: Fix kernel address leakage

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/brs: Fix kernel address leakage

Thorsten Blum <thorsten.blum@linux.dev>
    x86/boot: Reject too long acpi_rsdp= values

Thorsten Blum <thorsten.blum@linux.dev>
    x86/boot: Validate console=uart8250 baud rate to fix early boot hang

Tycho Andersen (AMD) <tycho@kernel.org>
    x86/virt/sev: Revert "Drop WBINVD before setting MSR_AMD64_SYSCFG_SNP_EN"

Mario Limonciello <mario.limonciello@amd.com>
    x86/video: Only fall back to vga_default_device() without screen info

Ali Ahmet MEMIS <dev@unknownbbqr.xyz>
    tools/power/x86/intel-speed-select: Harden daemon pidfile open

Guangshuo Li <lgs201920130244@gmail.com>
    mfd: sm501: Fix reference leak on failed device registration

Armin Wolf <W_Armin@gmx.de>
    leds: uleds: Fix potential buffer overread

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix incorrect execmem checks on overlayfs

Tristan Madani <tristan@talencesecurity.com>
    selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: check connect-related permissions on TCP Fast Open

Wang Jun <1742789905@qq.com>
    soc: fsl: qe: panic on ioremap() failure in qe_reset()

Siddharth Vadapalli <s-vadapalli@ti.com>
    soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/proxy

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    gpu/buddy: bail out of try_harder when alignment cannot be honoured

Guangshuo Li <lgs201920130244@gmail.com>
    gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: simplify and_then with condition to filter

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: use correct direction to set up tunnel route

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()

Wyatt Feng <bronzed_45_vested@icloud.com>
    netfilter: xt_nat: reject unsupported target families

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    netfilter: ecache: fix inverted time_after() check

Florian Westphal <fw@strlen.de>
    netfilter: xt_physdev: masks are not c-strings

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    netfilter: nf_conncount: fix zone comparison in tuple dedup

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: support IPIP tunnel with direct xmit

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: use dst in this direction when pushing IPIP header

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_sip: reload possible stale data pointer

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: don't leak bad clone into future transaction

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_sip: validate skb_dst() before accessing it

Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_fib: reject fib expression on the netdev egress hook

Haoze Xie <royenheart@gmail.com>
    netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst

Wyatt Feng <bronzed_45_vested@icloud.com>
    netfilter: xt_cluster: reject template conntracks in hash match

David Carlier <devnexen@gmail.com>
    netfilter: nfnl_cthelper: apply per-class values when updating policies

Muhammad Bilal <meatuni001@gmail.com>
    netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: fix NULL pointer dereference in graph_callback

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8183: Release reserved memory on cleanup

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8183: Check runtime resume during probe

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8192: Release reserved memory on cleanup

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8192: Check runtime resume during probe

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get

Zhao Dongdong <zhaodongdong@kylinos.cn>
    ASoC: SOF: topology: fix memory leak in snd_sof_load_topology

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: tridentfb: fix potential memory leak in trident_pci_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: nvidia: fix potential memory leak in nvidiafb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: vesafb: fix memory leak in vesafb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: uvesafb: fix potential memory leak in uvesafb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: s3fb: fix potential memory leak in s3_pci_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: i740fb: fix potential memory leak in i740fb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: radeon: fix potential memory leak in radeonfb_pci_register()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: efifb: fix memory leak in efifb_probe()

Li RongQing <lirongqing@baidu.com>
    fbdev: sm712: Fix operator precedence in big_swap macro

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: hecubafb: fix potential memory leak in hecubafb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: broadsheetfb: fix potential memory leak in broadsheetfb_probe()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: metronomefb: fix potential memory leak in metronomefb_probe()

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Inject SEA if guest VNCR isn't normal memory

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Re-translate VNCR before injecting abort

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR

Weiming Shi <bestswngs@gmail.com>
    KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()

Fuad Tabba <tabba@google.com>
    KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2

Oliver Upton <oupton@kernel.org>
    KVM: arm64: Ensure level is always initialized when relaxing perms

Bradley Morgan <include@grrlz.net>
    KVM: arm64: account pKVM reclaim against the VM mm

Marc Zyngier <maz@kernel.org>
    KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state

leixiang <leixiang@kylinos.cn>
    KVM: x86: Nullify irqfd->producer if updating IRTE for bypass fails

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore pending PV EOI if the vCPU has since disabled PV EOIs

Binbin Wu <binbin.wu@linux.intel.com>
    KVM: TDX: Reject concurrent change to CPUID entry count

Atish Patra <atishp@meta.com>
    KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs

Matthew Rosato <mjrosato@linux.ibm.com>
    KVM: s390: pci: Fix handling of AIF enable without AISB

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Move vTPR vs. TPR Threshold consistency check into "normal" checks

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: arm64: vgic: Check the interrupt is still ours before migrating it

Haoxiang Li <haoxiang_li2024@163.com>
    KVM: s390: pci: Fix GISC refcount leak on AIF enable failure

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries/Kconfig: Enable CONFIG_VPA_PMU to be used with KVM

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix unlikely race in try_get_locked_pte()

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Initialize KVM_S390_GET_CMMA_BITS memory

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: vsie: Use mmu cache to allocate rmap

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Silence potential warnings in _gmap_crstep_xchg_atomic()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: vsie: Add missing radix_tree_preload() in _gaccess_shadow_fault()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: vsie: Fix allocation of struct vsie_rmap

Qiang Ma <maqianga@uniontech.com>
    LoongArch: KVM: Return full old CSR value from kvm_emu_xchg_csr()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix FPU register width with user access API

Qiang Ma <maqianga@uniontech.com>
    LoongArch: KVM: Check the return values for put_user()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Check irq validity in kvm_vcpu_ioctl_interrupt()

Yanfei Xu <yanfei.xu@bytedance.com>
    LoongArch: KVM: Validate irqchip index in irqfd routing

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Move expander gpio-line-names to board files

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Fix expander gpio line typo

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Move gpio-line-names to board files

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: Fix OPP tables for all DisplayPort controllers

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Fix GPIO names typo

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: imx8ulp-evk: Correct Type-C int GPIO flags

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Enable internal ADC reference

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Move divergent mecio1 ADC channels to board files

David Jander <david@protonic.nl>
    ARM: dts: stm32: stm32mp15x-mecio1-io: Fix ADC sampling times

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix Ethernet PHY not found on PX30 Ringneck

Nickolay Goppen <setotau@mainlining.org>
    arm64: dts: qcom: sdm630: describe adsp_mem region properly

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    ARM: dts: imx6ul-var-som: fix warning for non-existent dc-supply property

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: ironhide: Describe inline ECC carveouts

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: s32g3: Fix SWT8 watchdog address

Mark Rutland <mark.rutland@arm.com>
    arm64: fpsimd: Fix type mismatch in sve_{save,load}_state()

Yong Wang <edragain@163.com>
    net: ife: require ETH_HLEN to be pullable in ife_decode()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-vf: clear stale mailbox IRQ state before request_irq()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-pf: clear stale mailbox IRQ state before request_irq()

Zhengchuan Liang <zcliangcn@gmail.com>
    net: atm: reject out-of-range traffic classes in QoS validation

Michael Bommarito <michael.bommarito@gmail.com>
    net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()

Li Xiasong <lixiasong1@huawei.com>
    tipc: restrict socket queue dumps in enqueue tracepoints

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: SOF: topology: validate vendor array size before parsing

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-control: Fix TOCTOU in bytes_put and bytes_get

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-control: Use overflow checks in control_update size calc

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Validate notification payload size

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Fix TOCTOU in sof_ipc4_bytes_put

Jason Wang <jasowang@redhat.com>
    VDUSE: avoid leaking information to userspace

Zhang Tianci <zhangtianci.1997@bytedance.com>
    vduse: Fix race in vduse_dev_msg_sync and vduse_dev_read_iter

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()

Przemyslaw Korba <przemyslaw.korba@intel.com>
    idpf: add padding to PTP virtchnl structures

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Allow sparse CPU masks in ring_buffer_desc()

Vincent Donnefort <vdonnefort@google.com>
    tracing/remotes: Fix struct_len in trace_remote_alloc_buffer()

Vincent Donnefort <vdonnefort@google.com>
    tracing/remotes: Fix leak in trace_remote_alloc_buffer() error path

Ben Dooks <ben.dooks@codethink.co.uk>
    drm/imagination: make pvr_fw_trace_init_mask_ops static

Guangshuo Li <lgs201920130244@gmail.com>
    smb: client: fix overflow in passthrough ioctl bounds check

Guangshuo Li <lgs201920130244@gmail.com>
    drm/xe: free madvise VMA array on L2 flush failure

Anas Khan <anxkhn28@gmail.com>
    drm/xe: remove duplicate <kunit/test-bug.h> include

Harman Kalra <hkalra@marvell.com>
    octeontx2-af: fix VF bringup affecting PF promiscuous state

Gal Pressman <gal@nvidia.com>
    ethtool: rss: Fix hfunc and input_xfrm parsing on big endian

Li RongQing <lirongqing@baidu.com>
    net/mlx5: Fix L3 tunnel entropy refcount leak

Wang Yan <wangyan01@kylinos.cn>
    selftests/net: fix EVP_MD_CTX leak in tcp_mmap

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fb-helper: Only consider active CRTCs for vblank sync

Timur Tabi <ttabi@nvidia.com>
    regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK

Zizhi Wo <wozizhi@huawei.com>
    smb: client: fix busy dentry warning on unmount after DIO

Cao Guanghui <caoguanghui@kylinos.cn>
    dm era: fix NULL pointer dereference in metadata_open()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: pin upper rpc_clnt across the TLS connect_worker

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: release lower rpc_clnt if killed waiting for XPRT_LOCKED

Guangshuo Li <lgs201920130244@gmail.com>
    cifs: validate DFS referral string offsets

Rongguang Wei <weirongguang@kylinos.cn>
    s390/zcrypt: Remove the empty file

Julian Anastasov <ja@ssi.bg>
    ipvs: ensure inner headers in ICMP errors are in headroom

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: fix PMTU for GUE/GRE tunnel ICMP errors

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: use parsed transport offset in TCP state lookup

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: pass parsed transport offset to state handlers

Tamaki Yanagawa <ty@000ty.net>
    netfilter: nft_lookup: fix catchall element handling with inverted lookups

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()

Yuyang Huang <yuyanghuang@google.com>
    ipv4: igmp: annotate data-races around timer-related fields

Yuyang Huang <sigefriedhyy@gmail.com>
    ipv4: igmp: annotate data-races around im->users

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: Fix potential UAF in MLD delayed work

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()

Rosen Penev <rosenp@gmail.com>
    gpio: mvebu: free generic chips on unbind

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/core: Avoid enabling BRS from the SVM reload path

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: check DMAC extraction support before filtering

Samuel Moelius <sam.moelius@trailofbits.com>
    net/sched: cake: reject overhead values that underflow length

Rosen Penev <rosenp@gmail.com>
    net: mdio: select REGMAP_MMIO instead of depending on it

Cihan Karadag <cihan.cihan@gmail.com>
    selftests: gpio: add gpio-cdev-uaf to .gitignore

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Reject invalid indirect BO handle in indirect CSD setup

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix potential amdxdna_umap lifetime race

Ben Dooks <ben.dooks@codethink.co.uk>
    tracing: Make tracepoint_printk static as not exported

Robert Mader <robert.mader@collabora.com>
    drm: Guard DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE

Jia Wang <wangjia@ultrarisc.com>
    gpio: dwapb: Defer clock gating until noirq

Enrico Pozzobon <enrico.pozzobon@dissecto.com>
    net: usb: lan78xx: disable VLAN filter in promiscuous mode

Yuho Choi <dbgh9129@gmail.com>
    net/liquidio: drop cached VF pci_dev LUT

Dong Yibo <dong100@mucse.com>
    net: rnpgbe: fix mailbox endianness and remove pointer casts

Chuck Lever <chuck.lever@oracle.com>
    net/tls: Consume empty data records in tls_sw_read_sock()

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix VMA access race

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Use unsigned long for nr_pages in amdxdna_hmm_register()

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Prevent PM resume deadlock in hwctx_sync_debug_bo()

Hui Wang <hui.wang@canonical.com>
    ring-buffer: Fix event length with forced 8-byte alignment

Stig Hornang <stig@hornang.me>
    Bluetooth: L2CAP: fix tx ident leak for commands without a response

Weiming Shi <bestswngs@gmail.com>
    Bluetooth: bpa10x: avoid OOB read of revision string in bpa10x_setup()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix malformed ISO_END/CONT handling

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Refactor FLR to use device_reprobe()

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: Separate coredump work from RX work

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add support for smart trigger dump

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: Support Product level reset

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: sco: Fix a race condition in sco_sock_timeout()

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: MGMT: Fix adv monitor add failure cleanup

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: hold L2CAP conn across debugfs control

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: avoid untracked enable work

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/ltphy: Fix SSC Enablement bit in PORT_CLOCK_CTL

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: make the voting mechanism adaptable

Steve French <stfrench@microsoft.com>
    smb: client: preserve leading slash for POSIX absolute symlink targets

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix multichannel binding and enforce channel limit

Eric Dumazet <edumazet@google.com>
    amt: fix size calculation in amt_get_size()

Xiang Mei <xmei5@asu.edu>
    net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload

Xiang Mei <xmei5@asu.edu>
    net: qualcomm: rmnet: validate MAP frame length before ingress parsing

Shigeru Yoshida <syoshida@redhat.com>
    qede: fix off-by-one in BD ring consumption on build_skb failure

Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>
    net: microchip: vcap: fix races on the shared Super VCAP block

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix publication race for priv->channel_stats[]

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix HV VHCA stats agent registration race

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix HV VHCA stats zero-sized buffer allocation

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Fix PE/VS value shift mismatch during link training

Shay Drory <shayd@nvidia.com>
    net/mlx5e: TC, skip peer flow cleanup when LAG seq is unavailable

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, MPESW, Fix missing complete() on devcom error

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, Fix off-by-one in single-FDB error rollback

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, extend shared FDB API with group_id filter

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, prepare for SD device integration

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, replace peer count check with direct peer lookup

Shay Drory <shayd@nvidia.com>
    net/mlx5: LAG, factor out shared FDB code into dedicated file

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, avoid LAG and representor lock cycles

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: E-Switch, add representor lifecycle lock

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag: refactor representor reload handling

Mingyou Chen <qby140326@gmail.com>
    platform/x86: bitland-mifs-wmi: Fix NULL pointer dereference during suspend/resume

Wyatt Feng <bronzed_45_vested@icloud.com>
    netfilter: xt_connmark: reject invalid shift parameters

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: get command skips end element with open interval

Zhixing Chen <running910@gmail.com>
    netfilter: ip6tables: mark malformed IPv6 extension headers for hotdrop

Feng Wu <wufengwufengwufeng@gmail.com>
    netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()

Wyatt Feng <bronzed_45_vested@icloud.com>
    netfilter: xt_u32: reject invalid shift counts

Qihang <q.h.hack.winter@gmail.com>
    gue: validate REMCSUM private option length

Xiang Mei <xmei5@asu.edu>
    net: usb: net1080: validate packet_len before pad-byte access in rx_fixup

Jia He <justin.he@arm.com>
    arm64/sysreg: Fix BWE field encoding in ID_AA64DFR2_EL1

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    selftests/hid: Cover hid_bpf_get_data() size overflow

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    selftests/hid: Load only requested struct_ops maps

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    HID: bpf: Fix hid_bpf_get_data() range check

Cen Zhang <zzzccc427@gmail.com>
    ntfs: avoid stale runlist element dereference in fallocate

Ariana Lazar <ariana.lazar@microchip.com>
    iio: dac: mcp47feb02: Fix passing uninitialized vref1_uV for no Vref1 case

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Avoid eager DVMSync reclaim batches with C1-Pro SME erratum

Lee Jones <lee@kernel.org>
    HID: core: Fix OOB read in hid_get_report for numbered reports

Georgiy Osokin <g.osokin@auroraos.dev>
    HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()

Cen Zhang <zzzccc427@gmail.com>
    ntfs: avoid stale runlist element dereference in MFT writeback

David Howells <dhowells@redhat.com>
    netfs: Fix barriering when walking subrequest list

Karuna Ramkumar <rkaruna@google.com>
    ata: libata-scsi: limit simulated SCSI command copy to response length

Myeonghun Pak <mhun512@gmail.com>
    ata: sata_gemini: unwind clocks on IDE pinctrl errors

David Howells <dhowells@redhat.com>
    cifs: Fix missing credit release on failure in cifs_issue_read()

Jiri Olsa <jolsa@kernel.org>
    uprobes/x86: Use proper mm_struct in __in_uprobe_trampoline

David Windsor <dwindsor@gmail.com>
    x86/uprobes: Keep shadow stack in sync for emulated CALLs

Matthew Auld <matthew.auld@intel.com>
    drm/xe/pt: prevent invalid cursor access for purged BOs

Matthew Auld <matthew.auld@intel.com>
    drm/xe: fix NPD in bo_meminfo()

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Don't attempt to process FAST_REQ or EVENT relays

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/hw_engine: Fix double-free of managed BO in error path

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/userptr: Drop bogus static from finish in force_invalidate

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/userptr: Hold notifier_lock for write on inject test path

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix returned size for DRM_IOCTL_PVR_DEV_QUERY

Francois Dugast <francois.dugast@intel.com>
    drm/xe/pt: Fix NULL pointer dereference in xe_pt_zap_ptes_entry()

David Howells <dhowells@redhat.com>
    netfs: Fix folio state after ENOMEM whilst under writeback iteration

David Howells <dhowells@redhat.com>
    netfs: Fix writeback error handling

David Howells <dhowells@redhat.com>
    netfs: Fix writethrough to use collection offload

David Howells <dhowells@redhat.com>
    cachefiles: Fix file burial to take lock when unsetting S_KERNEL_FILE

David Howells <dhowells@redhat.com>
    netfs: Fix netfs_create_write_req() to handle async cache object creation

Morduan Zang <zhangdandan@uniontech.com>
    iomap: guard io_size EOF trim against concurrent truncate underflow

Amir Goldstein <amir73il@gmail.com>
    ovl: fix comment about locking order

Hongling Zeng <zenghongling@kylinos.cn>
    cachefiles: Fix double unlock in nomem_d_alloc error path

Michael Bommarito <michael.bommarito@gmail.com>
    minix: avoid overflow in bitmap block count calculation

Fengnan Chang <changfengnan@bytedance.com>
    iomap: release pages on atomic dio size mismatch

David Howells <dhowells@redhat.com>
    afs: Fix unchecked-length string display in debug statement

David Howells <dhowells@redhat.com>
    afs: Fix the volume AFS_VOLUME_RM_TREE is set on

David Howells <dhowells@redhat.com>
    afs: Fix premature cell exposure through /afs

David Howells <dhowells@redhat.com>
    afs: Fix lack of locking around modifications of net->cells_dyn_ino

David Howells <dhowells@redhat.com>
    afs: Fix vllist leak

David Howells <dhowells@redhat.com>
    afs: Fix leak of ungot volume

David Howells <dhowells@redhat.com>
    afs: Use scoped_seqlock_read() rather than manually doing seqlock stuff

David Howells <dhowells@redhat.com>
    afs: Fix missing NULL pointer check in afs_break_some_callbacks()

David Howells <dhowells@redhat.com>
    afs: Fix callback service message parsers to pass through -EAGAIN

David Howells <dhowells@redhat.com>
    afs: Fix reinitialisation of the inode, in particular ->lock_work

David Howells <dhowells@redhat.com>
    afs: Fix misplaced inc of net->cells_outstanding

David Howells <dhowells@redhat.com>
    afs: Fix bulk lookup malfunction due to change in dir_emit() API

Li RongQing <lirongqing@baidu.com>
    afs: Remove erroneous seq |= 1 in volume lookup loop

Zilin Guan <zilin@seu.edu.cn>
    afs: use kvfree() to free memory allocated by kvcalloc()

David Howells <dhowells@redhat.com>
    afs: Fix directory inode initialisation order

David Howells <dhowells@redhat.com>
    afs: Remove setting of AS_RELEASE_ALWAYS for symlinks and mountpoints

David Howells <dhowells@redhat.com>
    afs: Fix double netfs initialisation in afs_root_iget()

Dan Carpenter <error27@gmail.com>
    afs: Fix error code in afs_extract_vl_addrs()

Christian Brauner <brauner@kernel.org>
    fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid

Samuel Moelius <sam.moelius@trailofbits.com>
    net/sched: hhf: clear heavy-hitter state on reset

Samuel Moelius <sam.moelius@trailofbits.com>
    net/sched: dualpi2: clear stale classification on filter miss

Michael Bommarito <michael.bommarito@gmail.com>
    xen/pvcalls: bound backend response req_id before indexing rsp[]

Viacheslav Bocharov <v@baodeep.com>
    pinctrl: meson: restore non-sleeping GPIO access

Vladimir Zapolskiy <vz@kernel.org>
    gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: fix use-after-free of fp->owner.name in durable handle owner check

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: reject undersized DACLs before parsing ACEs

Sechang Lim <rhkrqnwk98@gmail.com>
    net/sched: act_bpf: use rcu_dereference_bh() to read the filter

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: tso: don't touch dangerous feature bits

Gleb Markov <markov.gi@npc-ksb.ru>
    cxgb4: Fix decode strings dump for T6 adapters

Longjun Tang <tanglongjun@kylinos.cn>
    virtio_net: disable cb when NAPI is busy-polled

Xin Long <lucien.xin@gmail.com>
    sctp: fix addr_wq_timer race in sctp_free_addr_wq()

Felix Gu <ustc.gu@gmail.com>
    spi: rzv2h-rspi: Fix DMA transfer error handling for signal interruption

Qingshuang Fu <fuqingshuang@kylinos.cn>
    irqchip/ts4800: Fix missing chained handler cleanup on remove

Yuho Choi <dbgh9129@gmail.com>
    irqchip/gic-v3-its: Fix OF node reference leak

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Make the $ prefix mandatory for comm access

Sechang Lim <rhkrqnwk98@gmail.com>
    tracing/fprobe: Fix NULL pointer dereference in fprobe_fgraph_entry()

Martin Kaiser <martin@kaiser.cx>
    tracing: eprobe: read the complete FILTER_PTR_STRING pointer

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/events: Fix to check the simple_tsk_fn creation

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg

Steven Rostedt <rostedt@goodmis.org>
    tracing/eprobes: Allow use of BTF names to dereference pointers

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Interrupt group start/resumption if group_bind_locked() fails

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix a leak when a group is evicted before the tiler OOM is serviced

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix panthor_pwr_unplug()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Don't overrule pending immediate ticks in sched_resume_tick()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix theoretical IOMEM access in suspended state

Karunika Choo <karunika.choo@arm.com>
    drm/panthor: Store IRQ register base iomem pointer in panthor_irq

Karunika Choo <karunika.choo@arm.com>
    drm/panthor: Split register definitions by components

Karunika Choo <karunika.choo@arm.com>
    drm/panthor: Pass an iomem pointer to GPU register access helpers

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix potential invalid pointer deref in group_process_tiler_oom()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Keep the reset work disabled until everything is initialized

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Always use the IRQ-safe variant when acquiring the fence lock

Viacheslav Bocharov <v@baodeep.com>
    gpio: shared-proxy: always serialize with a sleeping mutex

Ido Schimmel <idosch@nvidia.com>
    bridge: stp: Fix a potential use-after-free when deleting a bridge

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: Introduce slaves_lock to avoid race condition and UAF

Rosen Penev <rosenp@gmail.com>
    net: gianfar: dispose irq mappings on probe failure and device removal

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix VMDQ mask for 1-queue mode

Petr Wozniak <petr.wozniak@gmail.com>
    net: phy: sfp: free mii_bus in sfp_i2c_mdiobus_destroy

Xiang Mei <xmei5@asu.edu>
    usbnet: gl620a: fix out-of-bounds read in genelink_rx_fixup()

Pengfei Zhang <zhangfeionline@gmail.com>
    ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: don't cache shinfo across skb realloc

Guenter Roeck <linux@roeck-us.net>
    hwmon: (aspeed-g6-pwm-tach) Guard fan RPM calculation against divide-by-zero

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix passing events to regulator core

Matti Vaittinen <mazziesaccount@gmail.com>
    hwmon: adm1275: Prevent reading uninitialized stack

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix iommu domain lifetime race during device removal

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/core) honor vrm_version in pmbus_data2reg_vid()

Luca Weiss <luca.weiss@fairphone.com>
    ASoC: codecs: lpass-va-macro: Fix LPASS Codec Version for SC7280

Kyle Hendry <kylehendrydev@gmail.com>
    MIPS: mm: Add check for highmem before removing memory block

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: DEC: Ensure RTC platform device deregistration upon failure

Xin Long <lucien.xin@gmail.com>
    sctp: add INIT verification after cookie unpacking

Yousef Alhouseen <alhouseenyousef@gmail.com>
    sctp: fix SCTP_RESET_STREAMS stream list length limit

Wei Fang <wei.fang@nxp.com>
    net: enetc: check the number of BDs needed for xdp_frame

Matvey Kovalev <matvey.kovalev@ispras.ru>
    qede: fix out-of-bounds check for cqe->len_list[]

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    seg6: validate SRH length before reading fixed fields

Corey Leavitt <corey@leavitt.info>
    net: pse-pd: scope pse_control regulator handle to kref lifetime

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: htc-egpio: use managed gpiochip registration

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: mvebu: fail probe if gpiochip registration fails

KaFai Wan <kafai.wan@linux.dev>
    bpf: Fix insn_aux_data leak on verifier err_free_env path

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Mask pseudo pointer values in verifier logs

Samuel Holland <samuel.holland@sifive.com>
    riscv: Fix 32-bit call_on_irq_stack() frame pointer ABI

Yicong Yang <yang.yicong@picoheart.com>
    ACPI: RIMT: Only defer the IOMMU configuration in init stage

Pengpeng Hou <pengpeng@iscas.ac.cn>
    spi: sh-msiof: abort transfers when reset times out

Martin Kaiser <martin@kaiser.cx>
    tracing: probes: fix typo in a log message

Jiaming Zhang <r772577952@gmail.com>
    ALSA: FCP: Fix NULL pointer dereference in interface lookup

Shuaisong Yang <yangshuaisong@h-partners.com>
    net: hns3: differentiate autoneg default values between copper and fiber

Shuaisong Yang <yangshuaisong@h-partners.com>
    net: hns3: fix permanent link down deadlock after reset

Shuaisong Yang <yangshuaisong@h-partners.com>
    net: hns3: refactor MAC autoneg and speed configuration

Shuaisong Yang <yangshuaisong@h-partners.com>
    net: hns3: unify copper port ksettings configuration path

Nirmoy Das <nirmoyd@nvidia.com>
    selftests: tls: size splice_short pipe by page size

Eric Dumazet <edumazet@google.com>
    tipc: avoid busy looping in tipc_exit_net()

Eric Dumazet <edumazet@google.com>
    tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Store struct sock in struct udp_bearer.

Kuniyuki Iwashima <kuniyu@google.com>
    udp_tunnel: Pass struct sock to setup_udp_tunnel_sock().

Kuniyuki Iwashima <kuniyu@google.com>
    udp_tunnel: Pass struct sock to udp_tunnel_sock_release().

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix potential divide-by-zero when num_vsi is zero

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3-c22" fallback

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc_dma: fix eDMA maxburst misalignment with channel count

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Fix off-by-one error in tail call

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Fix outdated tail call comments

谢致邦 (XIE Zhibang) <Yeking@Red54.com>
    LoongArch: Move struct kimage forward declaration before use

Inochi Amaoto <inochiama@gmail.com>
    net: stmmac: dwmac-spacemit: Fix wrong irq definition

Inochi Amaoto <inochiama@gmail.com>
    net: stmmac: dwmac-spacemit: Fix wrong phy interface definition

Shitalkumar Gandhi <shital.gandhi45@gmail.com>
    net: ethernet: sunplus: spl2sw: fix phy_node refcount leak in remove

Ruoyu Wang <ruoyuw560@gmail.com>
    net: sungem: fix probe error cleanup

Greg Thelen <gthelen@google.com>
    tools: ynl: build archives with $(AR)

Xiang Mei <xmei5@asu.edu>
    geneve: validate inner network offset in geneve_gro_complete()

Xiang Mei <xmei5@asu.edu>
    geneve: gate GRO hint in geneve_gro_complete() on gs->gro_hint

Yun Zhou <yun.zhou@windriver.com>
    net: mvneta: re-enable percpu interrupt on resume

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: fix CGX debugfs RVU AF PCI reference leaks

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Validate NIX maximum LFs correctly

Jan Klos <honza.klos@gmail.com>
    net: phy: realtek: Clear MDIO_AN_10GBT_CTRL_ADV10G bit

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Fall back to standard MTU when PF reports adapter_mtu of 0

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mxl862xx: fix use-after-free of DSA ports in crc_err_work

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mxl862xx: avoid unaligned 16-bit access in api_wrap

David Yang <mmyangfl@gmail.com>
    net: dsa: realtek: fix memory leak in rtl8366rb_setup_led()

Haoxiang Li <haoxiang_li2024@163.com>
    rtc: cmos: unregister HPET IRQ handler on probe failure

Fredrik M Olsson <fredrik.m.olsson@axis.com>
    rtc: ds1307: Fix off-by-one issue with wday for rx8130

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: preserve errors from smb2_set_sparse()

Li RongQing <lirongqing@baidu.com>
    ACPI: processor_idle: Mark LPI enter functions as __cpuidle

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Unbreak tools build after switching over to strscpy_pad()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: testing: zone: Flush work items during cleanup

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix handling of _PAGE_UNUSED pte bit

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: fix ordering of heartbeat vs ownership

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix missing notification for ignore_routes_with_linkdown

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix state corruption during proxy_ndp sysctl restart

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix error handling in disable_policy sysctl

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix error handling in forwarding sysctl

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix error handling in ignore_routes_with_linkdown sysctl

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: fix error handling in disable_ipv6 sysctl

Xin Long <lucien.xin@gmail.com>
    sctp: fix err_chunk memory leaks in INIT handling

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: Handle TC_ACT_CONSUMED in tcf_qevent_handle

Jakub Sitnicki <jakub@cloudflare.com>
    net: lwtunnel: Drop skb metadata before LWT encapsulation

Nicolai Buchwitz <nb@tipi-net.de>
    net: usb: lan78xx: restore VLAN and hash filters after link up

Eric Dumazet <edumazet@google.com>
    veth: fix NAPI leak in XDP enable error path

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg: Fix XSK zero copy TX during application wakeup

Aleksandrova Alyona <aga@itb.spb.ru>
    net: dsa: sja1105: round up PTP perout pin duration

Eric Dumazet <edumazet@google.com>
    net: do not acquire dev->tx_global_lock in netdev_watchdog_up()

Xiang Mei <xmei5@asu.edu>
    net, bpf: check master for NULL in xdp_master_redirect()

Doehyun Baek <doehyunbaek@gmail.com>
    Docs/driver-api/uio-howto: document mmap_prepare callback

Krzysztof Wilczyński <kwilczynski@kernel.org>
    alpha/PCI: Fix __pci_mmap_fits() overflow for zero-length BARs

Krzysztof Wilczyński <kwilczynski@kernel.org>
    alpha/PCI: Add security_locked_down() check to pci_mmap_resource()

Koichiro Den <den@valinux.co.jp>
    NTB: epf: Fix doorbell bitmask and IRQ vector handling

Koichiro Den <den@valinux.co.jp>
    NTB: epf: Report 0-based doorbell vector via ntb_db_event()

Koichiro Den <den@valinux.co.jp>
    NTB: epf: Make db_valid_mask cover only real doorbell bits

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Exclude reserved slots from db_valid_mask

Oder Chiou <oder_chiou@realtek.com>
    ASoC: rt5575: Use __le32 for SPI burst write address

HyeongJun An <sammiee5311@gmail.com>
    ASoC: SDCA: Validate written enum value in ge_put_enum_double()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: Allow exit latency to exceed target residency

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: expectation timeouts are passed in milliseconds

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: run expectation eviction with no helper

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: store master_tuple in expectation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: check NULL when retrieving ct extension

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper

Qingshuang Fu <fuqingshuang@kylinos.cn>
    gpio: davinci: fix IRQ domain leak on devm_kzalloc failure

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: ebtables emulation must reject non-bridge targets

Runyu Xiao <runyu.xiao@seu.edu.cn>
    netfilter: nft_synproxy: stop bypassing the priv->info snapshot

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: flowtable: Validate iph->ihl in nf_flow_ip4_tunnel_proto()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: prevent connlimit drops for early confirmed ct

Mathias Krause <minipli@grsecurity.net>
    netfilter: nf_nat: avoid invalid nat_net pointer use on failed nf_nat_init()

Bradley Morgan <include@grrlz.net>
    bpf: Disable xfrm_decode_session hook attachment

Chen Cheng <chencheng@fnnas.com>
    md/raid5: avoid R5_Overlap races while breaking stripe batches

Chen Cheng <chencheng@fnnas.com>
    md/raid5: use stripe state snapshot in break_stripe_batch_list()

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: fib: Don't ignore error route in local/main tables.

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: improve the timing of stats

Xiang Mei <xmei5@asu.edu>
    ipv6: Fix null-ptr-deref in fib6_nh_mtu_change().

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: fix use-after-free of conn->preauth_info in concurrent SMB2 NEGOTIATE

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    selftests/bpf: Cover small conntrack opts error writes

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Guard conntrack opts error writes

Stepan Ionichev <sozdayvek@gmail.com>
    rtc: msc313: fix NULL deref in shared IRQ handler at probe

Dima Ruinskiy <dima.ruinskiy@intel.com>
    e1000e: Reconfigure PLL clock gate timeout and re-enable K1 on Meteor Lake

Mohamed Khalfella <mkhalfella@purestorage.com>
    i40e: Fix i40e_debug() to use struct i40e_hw argument

ZhaoJinming <zhaojinming@uniontech.com>
    ice: dpll: fix memory leak in ice_dpll_init_info error paths

ZhaoJinming <zhaojinming@uniontech.com>
    ice: dpll: set pointers to NULL after kfree in ice_dpll_deinit_info

John Madieu <john.madieu.xa@bp.renesas.com>
    rtc: isl1208: Balance enable_irq_wake() with disable_irq_wake() on cleanup

Marcin Szycik <marcin.szycik@intel.com>
    ice: call netif_keep_dst() once when entering switchdev mode

Lukasz Czapnik <lukasz.czapnik@intel.com>
    ice: fix AQ error code comparison in ice_set_pauseparam()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Preserve pointer spill metadata during half-slot cleanup

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Report 0-based doorbell vector via ntb_db_event()

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Defer pci_epc_raise_irq() out of atomic context

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Document legacy MSI doorbell offset

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: endpoint: pci-epf-ntb: Add check to detect 'db_count' value of 0

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: endpoint: pci-epf-vntb: Add check to detect 'db_count' value of 0

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ASoC: cs530x: Fix expected MCLK rates for CS5302/4/8

Zhan Xusheng <zhanxusheng@xiaomi.com>
    erofs: handle 48-bit blocks_hi for compressed inodes

Xiang Mei <xmei5@asu.edu>
    drm/edid: fix OOB read in drm_parse_tiled_block()

Ruoyu Wang <ruoyuw560@gmail.com>
    gpiolib: initialize return value in gpiochip_set_multiple()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: fix ABBA deadlock in pwrseq_device_unregister()

Amery Hung <ameryhung@gmail.com>
    bpf: Fix effective prog array index with BPF_F_PREORDER

Thiébaud Weksteen <tweek@google.com>
    bpf: Fix BPF_PROG_ASSOC_STRUCT_OPS last field check

Avinash Duduskar <avinash.duduskar@gmail.com>
    bpf: zero-initialize the fib lookup flow struct

Yichong Chen <chenyichong@uniontech.com>
    bpftool: Fix vmlinux BTF leak in cgroup commands

Sun Jian <sun.jian.kdev@gmail.com>
    bpf: Fix partial copy of non-linear test_run output

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Fix stack slot index in nospec checks

Ronan Dalton <ronan.dalton@alliedtelesis.co.nz>
    rtc: ds1307: handle oscillator stop flag for ds1337/ds1339/ds3231

Antoni Pokusinski <apokusinski01@gmail.com>
    rtc: abx80x: fix the RTC_VL_CLR clearing all status flags

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: do not accept VLAN uppers while bridged

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: ioam: fix type confusion of dst_entry

Weiming Shi <bestswngs@gmail.com>
    ipv6: ndisc: fix NULL deref in accept_untracked_na()

Wayen Yan <win847@gmail.com>
    net: airoha: Fix skb->priority underflow in airoha_dev_select_queue()

Michael Bommarito <michael.bommarito@gmail.com>
    net/sched: act_ct: fix nf_connlabels leak on two error paths

Rosen Penev <rosenp@gmail.com>
    net: emac: Fix NULL pointer dereference in emac_probe

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: mcs: Fix mcs resources free on PF shutdown

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Clear stats of all resources when freeing resources

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: mcs: Fix unsupported secy stats read

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: npc: cn20k: fix NPC defrag

Wayen Yan <win847@gmail.com>
    net: ethernet: mtk_ppe: Fix rhashtable leak in mtk_ppe_init error paths

Ilya Maximets <i.maximets@ovn.org>
    net: dst_metadata: fix false-positive memcpy overflow in tun_dst_unclone

Weiming Shi <bestswngs@gmail.com>
    tipc: fix use-after-free of the discoverer in tipc_disc_rcv()

Ruoyu Wang <ruoyuw560@gmail.com>
    net: marvell: prestera: initialize err in prestera_port_sfp_bind

Aboorva Devarajan <aboorvad@linux.ibm.com>
    selftests/mm: fix exclusive_cow test fork() handling

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: remove hardcoded THP sizing assumptions in hmm tests

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: allow PUD-level entries in compound testcase of hmm tests

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: clarify alternate unmapping in compaction_test

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category

Mike Rapoport (Microsoft) <rppt@kernel.org>
    selftests/mm: run_vmtests.sh: free memory if available memory is low

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap

Sayali Patil <sayalip@linux.ibm.com>
    selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: size tmpfs according to PMD page size in split_huge_page_test

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh

Hao Ge <hao.ge@linux.dev>
    alloc_tag: fix use-after-free in /proc/allocinfo after module unload

Bhargav Joshi <j.bhargav.u@gmail.com>
    irqchip/crossbar: Fix parent domain resource leak

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: Forward the timeout/ error in imx_mu_generic_tx()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    tpm_crb: Check ACPI_COMPANION() against NULL during probe

Florian Westphal <fw@strlen.de>
    netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: skip iphdr options when looking for icmp header

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: zero device address for non-ether case

Florian Westphal <fw@strlen.de>
    netfilter: nft_meta_bridge: add validate callback for get operations

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: reject offsets exceeding 65535 bytes

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: make sure gc is properly stopped

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: honor REQ_NOWAIT when waiting for behind writes

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending and barrier reference leaks on discard failures

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending leak on write request failures

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: fix writes_pending and barrier reference leaks on write failures

Robertus Diawan Chris <robertusdchris@gmail.com>
    mac802154: Prevent overwrite return code in mac802154_perform_association()

Aleksandr Nogikh <nogikh@google.com>
    ieee802154: fix kernel-infoleak in dgram_recvmsg()

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Restore initial state on failed device_rename() in cfg802154_switch_netns()

Xu Rao <raoxu@uniontech.com>
    ACPI: IPMI: Fix inverted interface check in ipmi_bmc_gone()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: resource: Amend kernel-doc style

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    thermal: intel: Fix dangling resources on thermal_throttle_online() failure

Breno Leitao <leitao@debian.org>
    arm64/hw_breakpoint: reject unaligned watchpoints that would truncate BAS

Arnd Bergmann <arnd@arndb.de>
    arm64: static_call: include asm/insns.h

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: flowtable: fix and simplify IP6IP6 tunnel handling

Cen Zhang <zzzccc427@gmail.com>
    ALSA: usb-audio: Kill MIDI 2.0 URBs before freeing endpoints

Daniel Zahka <daniel.zahka@gmail.com>
    eth: fbnic: take netif_addr_lock_bh() around rx mode address programming

Ido Schimmel <idosch@nvidia.com>
    selftests: vlan_bridge_binding: Fix flaky operational state check

Breno Leitao <leitao@debian.org>
    netconsole: don't drop the last byte of a full-sized message

Yun Zhou <yun.zhou@windriver.com>
    flow_dissector: check device type before reading ETH_ADDRS

Lukasz Raczylo <lukasz@raczylo.com>
    net: macb: add TX stall timeout callback to recover from lost TSTART write

Wayen Yan <win847@gmail.com>
    net: airoha: fix foe_check_time allocation size

Cosmin Ratiu <cratiu@nvidia.com>
    devlink: Fix parent ref leak on tc-bw failure

Cosmin Ratiu <cratiu@nvidia.com>
    devlink: Fix parent ref leak in devl_rate_node_create()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix VLAN upper check not rejecting bridge join

Xiang Mei <xmei5@asu.edu>
    virtio-net: fix len check in receive_big()

Quang Nguyen <quang.nguyen.wx@renesas.com>
    spi: rpc-if: Use correct device for hardware reinitialization on resume

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    PCI: iproc: Restore .map_irq() for the platform bus driver

Michael Bommarito <michael.bommarito@gmail.com>
    ALSA: usb-audio: qcom: clear opened when stream enable fails

Michael Bommarito <michael.bommarito@gmail.com>
    ALSA: usb-audio: qcom: reject stream disable with no active interface

Xin Long <lucien.xin@gmail.com>
    sctp: hold socket lock when dumping endpoints in sctp_diag

Jakub Kicinski <kuba@kernel.org>
    net: psample: fix info leak in PSAMPLE_ATTR_DATA

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: npc: Log successful MCAM drop-on-non-hit install at debug level

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-pf: Fix leak of SQ timestamp buffer on teardown

Tianchen Ding <dtcccc@linux.alibaba.com>
    selftests/ftrace: Fix trace_marker_raw test on 64K page kernels

Christian Marangi <ansuelsmth@gmail.com>
    net: ethernet: mtk_eth_soc: fix supported_interface set after phylink_create

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm/amdgpu: initialize irq.lock spinlock earlier

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm

Matthew Schwartz <matthew.schwartz@linux.dev>
    drm/amd/display: Fix mem_type change detection for async flips

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Skip PHY SSC reduction on some 8K panels

Qiang Yu <Qiang.Yu@amd.com>
    drm/amdgpu: initialize iter.start in amdgpu_devcoredump_format

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdkfd: Avoid double-unpin of DOORBELL/MMIO BOs on free

Sen Wang <sen@ti.com>
    ASoC: tlv320aic3x: restrict CLKDIV bypass Q values in dual-rate mode

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Set standard errno on decompression failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Validate array presence before casting BPF prog info pointers

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Fix hist entry and format list leaks in c2c_he_free()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Free format list entries when c2c_hists__init() fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf cs-etm: Bounds-check CPU in cs_etm__get_queue()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf cs-etm: Require full global header in auxtrace_info size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf cs-etm: Validate num_cpu before metadata allocation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Use snprintf() for guestmount path construction

Eric Dumazet <edumazet@google.com>
    xfrm: validate selector family and prefixlen during match

Eric Dumazet <edumazet@google.com>
    xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_default[]

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Fix xfrm state cache insertion race

Xu Rao <raoxu@uniontech.com>
    ALSA: usb-audio: qcom: Free sideband sg_table objects

Gao Xiang <xiang@kernel.org>
    erofs: call erofs_exit_ishare() before rcu_barrier()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Add missing runtime PM get in dev_nack_retry_count_store()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Update dev_nack_retry_count under maintenance lock

Jisheng Zhang <jszhang@kernel.org>
    spi: dw: fix wrong BAUDR setting after resume

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Fix wa_oob codegen recipe for external module builds

Guangshuo Li <lgs201920130244@gmail.com>
    drm/i915: clear CRTC color blob pointers after dropping refs

Francesco Lavra <flavra@baylibre.com>
    regcache: Do not overwrite error code when finalizing cache after error

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: mlxbf3: fail probe if gpiochip registration fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf cs-etm: Reject CPU IDs that would overflow signed comparison

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Free format list entries when releasing c2c hist entries

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Bounds-check array offsets in bpil_offs_to_addr()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Reject oversized BPF metadata events that truncate header.size

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Replace (void*)1 sentinel with proper runtime allocation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hwmon: Fix fd check to accept fd 0 in hwmon_pmu__describe_items()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use snprintf() for root_dir path construction

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Set error code when open() fails on uncompressed fallback path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Fix heap overflow in dso__get_filename() on decompressed path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Validate p_filesz before use in filename__read_build_id()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Fix bswap copy-paste error for 32-bit ELF p_filesz

Ian Rogers <irogers@google.com>
    perf maps: Add maps__mutate_mapping

Pengpeng Hou <pengpeng@iscas.ac.cn>
    sparc: led: avoid trimming a newline from empty writes

Karol Wachowski <karol.wachowski@linux.intel.com>
    accel/ivpu: fix HWS command queue leak on registration failure

John Johansen <john.johansen@canonical.com>
    apparmor: fix label can not be immediately before a declaration

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Prevent reuse of dynamic address on device add failure

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix race in i3c_hci_addr_to_dev()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Defer new-device registration out of DAA caller context

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Ensure Hot-Join operations are stopped on shutdown

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Consolidate Hot-Join DAA work in the core

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Serialize i3c_set_hotjoin() with the maintenance lock

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Make hot-join workqueue freezable to block hot-join during suspend

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix suspend behavior when bus disable falls back to software reset

Eduardo Vasconcelos <eduardo@eduardovasconcelos.com>
    apparmor: Fix inverted comparison in cache_hold_inc()

Maciek Borzecki <maciek.borzecki@gmail.com>
    apparmor: fix uninitialised pointer passed to audit_log_untrustedstring()

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: don't audit files pointing to aa_null.dentry

Zygmunt Krynicki <me@zygoon.pl>
    apparmor: put secmark label after secid lookup

Zygmunt Krynicki <me@zygoon.pl>
    apparmor: aa_getprocattr free procattr leak on format failure

John Johansen <john.johansen@canonical.com>
    apparmor: remove unnecessary goto and associated label

Zygmunt Krynicki <me@zygoon.pl>
    apparmor: release exe file resources on path failure

Zygmunt Krynicki <me@zygoon.pl>
    apparmor: fail policy unpack on accept2 allocation failure

Hongling Zeng <zenghongling@kylinos.cn>
    apparmor: Fix return in ns_mkdir_op

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: remove or add symlinks to rawdata according to export_binary

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: fix NULL pointer dereference in unpack_pdb

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: fix potential UAF in aa_replace_profiles

Ryan Lee <ryan.lee@canonical.com>
    apparmor: grab ns lock and refresh when looking up changehat child profiles

John Johansen <john.johansen@canonical.com>
    apparmor: fix rawdata_f_data implicit flex array

Zygmunt Krynicki <me@zygoon.pl>
    apparmor: aa_label_alloc use aa_label_free on alloc failure

Ruoyu Wang <ruoyuw560@gmail.com>
    apparmor: check label build before no_new_privs test

Andrew Morton <akpm@linux-foundation.org>
    security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()

John Johansen <john.johansen@canonical.com>
    apparmor: fix refcount leak when updating the sk_ctx

John Johansen <john.johansen@canonical.com>
    apparmor: fix race in unix socket mediation when peer_path is used

John Johansen <john.johansen@canonical.com>
    apparmor: fix shadowing of plabel that prevents cache from being updated

Yuanhe Shu <xiangzao@linux.alibaba.com>
    Revert "PCI/MSI: Unmap MSI-X region on error"

Randy Dunlap <rdunlap@infradead.org>
    Documentation: ABI: sysfs-class-reboot-mode-reboot_modes: fix doc warnings

Thomas Weißschuh <linux@weissschuh.net>
    sparc: Avoid -Wunused-but-set-parameter in clear_user_page()

Dong Chenchen <dongchenchen2@huawei.com>
    xfrm: Fix dev use-after-free in xfrm async resumption

Shuvam Pandey <shuvampandey1@gmail.com>
    PCI: dwc: Avoid dwc_pcie_rasdes_debugfs_deinit() NULL dereference when no RAS DES capability

Felix Gu <ustc.gu@gmail.com>
    phy: freescale: phy-fsl-imx8qm-lvds-phy: Fix missing pm_runtime_disable() on probe error path

Felix Gu <ustc.gu@gmail.com>
    phy: freescale: phy-fsl-imx8qm-lvds-phy: Use synchronous PM runtime put in reset

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: mediatek: Use actual physical address instead of virt_to_phys()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: phy: sc8280xp-qmp-pcie: Disallow bifurcation register on Purwa

Inochi Amaoto <inochiama@gmail.com>
    dt-bindings: dma: snps,dw-axi-dmac: Add fallback compatible for CV1800B

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Add bounds checks to read_build_id() note iteration in minimal build

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Add bounds checks to elf_read_build_id() note iteration

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Fix metadata leak in perf_env__add_bpf_info() on duplicate insert

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Fix map data leak in bpf_metadata_create() on alloc failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Add NULL check for btf__type_by_id() in synthesize_bpf_prog_name()

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools lib api: Fix mount_overload() snprintf truncation and toupper range

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools lib api: Fix filename__write_int() writing uninitialized stack data

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use snprintf() in dso__read_running_kernel_build_id()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hwmon: Guard label read against empty or failed reads

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix uninitialized pathname on uncompressed fallback in filename__decompress()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hwmon: Fix parse_hwmon_filename() strlcpy buffer overflow

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hwmon: Use scnprintf() in hwmon_pmu__for_each_event()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hwmon: Fix off-by-one null termination on sysfs reads

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix thread__set_comm_from_proc() on empty comm file

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf intel-pt: Fix snprintf size tracking bug in insn decoder

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use mkostemp() for O_CLOEXEC on temporary files

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Bounds-check .gnu_debuglink section data

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Fix signed overflow in sysfs__read_build_id() size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools lib api: Fix missing null termination in filename__read_int/ull()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf pmu: Fix pmu_id() heap underwrite on empty identifier file

James Clark <james.clark@linaro.org>
    perf cs-etm: Queue context packets for frontend

Tanushree Shah <tshah@linux.ibm.com>
    perf data convert json: Fix addr_location leak on time-filtered samples

Jens Remus <jremus@linux.ibm.com>
    perf s390: Fix TEXTREL in Python extension by compiling as PIC

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Return sendctx slot after Send preparation failure

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Repost Receive buffers for malformed replies

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Sanitize the reply credit grant after parsing

Chris Mason <clm@meta.com>
    xprtrdma: Fix bcall rep leak and unbounded peek

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Resize reply buffers before reposting receives

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Document and assert reply-handler invariants

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Check frwr_wp_create() during connect

Chris Mason <clm@meta.com>
    xprtrdma: Initialize re_id before removal registration

Chris Mason <clm@meta.com>
    xprtrdma: Fix ep kref imbalance on ADDR_CHANGE

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use scnprintf() in build_id__snprintf() and hwmon read_events()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Use scnprintf() in snprintf_hex() and synthesize_bpf_prog_name()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Add O_CLOEXEC to open() calls in DSO and ELF code

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix idle-hist callchain display using wrong rb_first variant

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Bounds-check prio before test_bit() in timehist

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    PCI: rcar-host: Remove unused LIST_HEAD(res)

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: NULL bitmap pointers after bitmap_free()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use perf_env__get_cpu_topology() in machine__resolve()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Use scnprintf() in cpu_map__snprint() to prevent overflow

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix get_max_num() size_t underflow on empty sysfs file

David E. Box <david.e.box@linux.intel.com>
    platform/x86/intel/vsec: Restore BAR fallback for header walk

Jamie Nguyen <jamien@nvidia.com>
    fs/ntfs3: resize log->one_page_buf when adopting on-disk page size

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: prevent potential lcn remains uninitialized

Christian Fontanez <christfontanez@gmail.com>
    virtio: add missing kernel-doc for map and vmap members

Chuck Lever <chuck.lever@oracle.com>
    lockd: Correct kernel-doc status descriptions for NLMv4 GRANTED

Shuvam Pandey <shuvampandey1@gmail.com>
    PCI: meson: Add missing remove callback

Shuvam Pandey <shuvampandey1@gmail.com>
    PCI: meson: Propagate devm_add_action_or_reset() failure

Biju Das <biju.das.jz@bp.renesas.com>
    pwm: rzg2l-gpt: Add missing newlines to dev_err_probe() messages

Li RongQing <lirongqing@baidu.com>
    PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro

Yang Erkun <yangerkun@huawei.com>
    nfs: use nfsi->rwsem to protect traversal of the file lock list

Mike Snitzer <snitzer@kernel.org>
    NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS in pg_get_mirror_count_write

Mike Snitzer <snitzer@kernel.org>
    NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS on fatal DS connect errors

Clark Wang <xiaoning.wang@nxp.com>
    nfs: keep PG_UPTODATE clear after read errors in page groups

Dai Ngo <dai.ngo@oracle.com>
    NFSv4/pnfs: defer return_range callbacks until after inode unlock

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Decouple req recycling from RPC completion

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Use sendctx DMA state for Send signaling

Sagi Grimberg <sagi@grimberg.me>
    pNFS/filelayout: fix cheking if a layout is striped

Hongling Zeng <zenghongling@kylinos.cn>
    sunrpc: Fix error handling in rpc_sysfs_xprt_switch_add_xprt_store()

Phillip Varney <pbvarney@protonmail.com>
    clk: qcom: a53: Corrected frequency multiplier for 1152MHz

Nuno Sá <nuno.sa@analog.com>
    dmaengine: dma-axi-dmac: use DMA pool to manange DMA descriptor

Nuno Sá <nuno.sa@analog.com>
    dmaengine: dma-axi-dmac: Properly free struct axi_dmac_desc

Nuno Sá <nuno.sa@analog.com>
    dmaengine: Fix possible use after free

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    dmaengine: qcom: gpi: set DMA_PRIVATE capability

Junrui Luo <moonafterrain@outlook.com>
    mshv: add bounds check on vp_index in mshv_intercept_isr()

Pratyush Yadav (Google) <pratyush@kernel.org>
    docs: memfd_preservation: fix rendering of ABI documentation

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: camcc-x1e80100: Add support for camera QDSS debug clocks

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    dt-bindings: clock: qcom: Add X1P42100 camera clock controller

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Free callchain nodes in idle thread cleanup

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix int16_t truncation of max_cpu_num in set_max_cpu_num()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf timechart: Fix cpu2y() OOB read on untrusted CPU index

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Fix use-after-free in he__get_c2c_hists() error path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf stat: Introduce perf_env__get_cpu_topology() to guard NULL env->cpu

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf mmap: Fix NULL deref in aio cleanup on alloc failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Replace BUG_ON and add NULL checks in replay event helpers

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Use thread__put() in free_idle_threads()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix thread reference leak in idle hist processing

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Use is_idle_sample() for idle thread runtime cast guard

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Clean up idle_threads entry on init failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Bounds-check CPU IDs in setup_nodes() topology loop

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Bounds-check CPU and node IDs before bitmap and array access

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf stat: Bounds-check CPU index in topology aggregation callbacks

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf mmap: Guard cpu__get_node() return in aio_bind()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix register_pid() overflow, strcpy, and BUG_ON

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Cap max_cpu at MAX_CPUS in timehist sample processing

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix thread reference leaks in timehist_get_thread()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Add bounds check to cpu__get_node()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Guard remaining test_bit calls from OOB sample CPU

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix comp_cpus heap overflow with cross-machine recordings

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix NULL dereference in latency_runtime_event

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Replace BUG_ON on invalid CPU with graceful skip

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix thread reference leak in latency_switch_event

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Guard test_bit from out-of-bounds sample CPU

James Clark <james.clark@linaro.org>
    perf annotate: Fix crashes on empty annotate windows

Rui Qi <qirui.001@bytedance.com>
    perf: Fix off-by-one stack buffer overflow in kallsyms__parse()

Akhil R <akhilrajeev@nvidia.com>
    dt-bindings: dma: nvidia,tegra186-gpc-dma: Make reset optional

Shengjiu Wang <shengjiu.wang@nxp.com>
    dmaengine: imx-sdma: Refine spba bus searching in probe

Xu Rao <raoxu@uniontech.com>
    thunderbolt: debugfs: Fix margining error counter buffer leak

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add missing kdoc for ALLM parameters

Jamie Nguyen <jamien@nvidia.com>
    fs/ntfs3: fix mount failure on 64K page-size kernels

Arnd Bergmann <arnd@arndb.de>
    ntfs3: avoid another -Wmaybe-uninitialized warning

Mihai Brodschi <m.brodschi@gmail.com>
    ntfs3: Allocate iomap inline_data using alloc_page

Helen Koike <koike@igalia.com>
    fs/ntfs3: call _ntfs_bad_inode() when failing to rename

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix wrong LCN in run_remove_range() when splitting a run

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: add bounds check to run_get_highest_vcn()

Yixun Lan <dlan@kernel.org>
    clk: spacemit: k3: Fix PCIe clock register offset

Yixun Lan <dlan@kernel.org>
    clk: spacemit: k3: Switch to pll2_d6 as parent for PCIe clock

Zhan Xusheng <zhanxusheng1024@gmail.com>
    docs: changes.rst: restore pahole 1.26 minimum (regressed by sort)

Rosen Penev <rosenp@gmail.com>
    HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter

Yuho Choi <dbgh9129@gmail.com>
    clk: at91: keep securam node alive while mapping it

Aldo Conte <aldocontelk@gmail.com>
    iio: tcs3472: power down chip on probe failure

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: handle I2C read error(s) in mma8452_read()

Guilherme Ivo Bozi <guilherme.bozi@usp.br>
    iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handling

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: magnetometer: ak8975: fix potential kernel stack memory leak

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: light: si1133: prevent race condition on timeout

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: light: si1133: reset counter to prevent race condition

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf header: Validate bitmap size before allocating in do_read_bitmap()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf header: Sanity check HEADER_EVENT_DESC attr.size before swap

Zhan Xusheng <zhanxusheng@xiaomi.com>
    timers/migration: Update stale @online doc to @available

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    PCI: qcom: Disable ASPM L0s for SA8775P

Athira Rajeev <atrajeev@linux.ibm.com>
    powerpc tools perf: Initialize error code in auxtrace_record_init function

Baruch Siach <baruch@tkos.co.il>
    docs: threat-model: add missing closing parenthesis

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: rzg2l: Rename iterator in for_each_mod_clock() to avoid shadowing

Hongling Zeng <zenghongling@kylinos.cn>
    gpib: cb7210: Fix region leak when request_irq fails

Adam Crosser <adam.crosser@praetorian.com>
    gpib: fix double decrement of descriptor_busy in command_ioctl()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sonypi: Check ACPI_COMPANION() against NULL at probe time

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    hpet: Check ACPI_COMPANION() against NULL at probe time

James Kim <james010kim@gmail.com>
    char: tlclk: fix use-after-free in tlclk_cleanup()

Dave Penkler <dpenkler@gmail.com>
    gpib: Fix inappropriate ioctl error return

Ravi Bangoria <ravi.bangoria@amd.com>
    perf test amd ibs: Fix incorrect kernel version check

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: max3421: Reject hub port requests for non-existent ports

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: max3421: Fix shift-out-of-bounds in max3421_hub_control()

Guangshuo Li <lgs201920130244@gmail.com>
    staging: most: video: avoid double free on video register failure

Ian Rogers <irogers@google.com>
    perf inject: Fix itrace branch stack synthesis

Ian Rogers <irogers@google.com>
    perf event: Fix size of synthesized sample with branch stacks

Michael Petlan <mpetlan@redhat.com>
    perf build-id: Fix off-by-one bug when printing kernel/module build-id

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs-ccc: fix peripheral driver registration failures after oob fix

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: classmate-laptop: Address memory leaks on driver removal

Chen-Yu Tsai <wenst@chromium.org>
    PCI: mediatek-gen3: Fix incorrectly skipped pwrctrl error message

Dan Carpenter <error27@gmail.com>
    PCI: dwc: Fix signedness bug in fault injection test code

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: platform: defer connection counter increment until alloc succeeds

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    PCI/pwrctrl: Lock device when calling device_is_bound()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: don't free the channel if the startup callback failed

Sergey Senozhatsky <senozhatsky@chromium.org>
    mailbox: mtk-adsp: fix UAF during device teardown

Conor Dooley <conor.dooley@microchip.com>
    mailbox: mpfs: fix check for syscon presence in mpfs_mbox_inbox_isr()

Chen-Yu Tsai <wenst@chromium.org>
    PCI: mediatek-gen3: Do full device power down on removal

Leo Yan <leo.yan@arm.com>
    coresight: Handle helper enable failure properly

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: Fix source not disabled on idr_alloc_u32 failure

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: intel_ace2x: release bpt_stream when close it

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    iio: light: acpi-als: Check ACPI_COMPANION() against NULL

Mihai Sain <mihai.sain@microchip.com>
    clk: at91: sam9x7: Fix gmac_gclk clock definition

Leo Yan <leo.yan@arm.com>
    perf pmu: Skip test on Arm64 when #slots is zero

Ian Rogers <irogers@google.com>
    perf unwind: Refactor get_entries to allow dynamic libdw/libunwind selection

Ian Rogers <irogers@google.com>
    perf pmu-events AMD: Switch l2_itlb_misses to bp_l1_tlb_miss_l2_tlb_miss.all

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    phy: phy-can-transceiver: Check driver match and driver data against NULL

Qiang Yu <qiang.yu@oss.qualcomm.com>
    PCI: qcom: Set max OPP before DBI access during resume

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: dwc: Apply ECRC workaround for DesignWare cores prior to 5.10a

Biswapriyo Nath <nathbappai@gmail.com>
    dt-bindings: clock: qcom,sm6125-dispcc: reference qcom,gcc.yaml

Luo Jie <jie.luo@oss.qualcomm.com>
    clk: qcom: cmnpll: Account for reference clock divider

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: fix missing error code when trace ID is invalid

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    bus: mhi: ep: Add missing state_lock protection for mhi_state access

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    bus: mhi: ep: Fix potential deadlock in mhi_ep_reset_worker()

Hsiu Che Yu <yu.whisper.personal@gmail.com>
    rust: alloc: fix assert in `Vec::reserve` doc test

Rong Zhang <i@rong.moe>
    PCI: loongson: Do not ignore downstream devices on external bridges

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Add .start_link() callback

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Enable clock before PHY init

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Move interrupt enable to own function

Ian Rogers <irogers@google.com>
    perf tool: Fix missing schedstat delegates and dont_split_sample_group in delegate_tool

Ian Rogers <irogers@google.com>
    perf sched: Add missing mmap2 handler in timehist

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: xo15-ebook: Fix wakeup source and GPE handling

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    x86/platform/olpc: xo15: Drop wakeup source on driver removal

Guixin Liu <kanie@linux.alibaba.com>
    PCI: Check ROM header and data structure addr before accessing

Guixin Liu <kanie@linux.alibaba.com>
    PCI: Introduce named defines for PCI ROM

Carlos Bilbao <carlos.bilbao@kernel.org>
    PCI/ASPM: Don't reconfigure ASPM entering low-power state

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore

James Clark <james.clark@linaro.org>
    coresight: ete: Always save state on power down

Leo Yan <leo.yan@arm.com>
    coresight: tmc: Fix overflow when calculating is bigger than 2GiB

Baoli.Zhang <baoli.zhang@linux.intel.com>
    soundwire: fix bug in sdw_add_element_group_count found by syzkaller

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: don't program SDW_SCP_BUSCLOCK_SCALE on a unattached Peripheral

Yingchao Deng <yingchao.deng@oss.qualcomm.com>
    coresight: cti: Fix DT filter signals silently ignored

Thomas Richter <tmricht@linux.ibm.com>
    perf callchain: Handle multiple address spaces

Ian Rogers <irogers@google.com>
    perf debuginfo: Fix libdw API contract violations

Ian Rogers <irogers@google.com>
    perf annotate-data: Fix libdw API contract violations

Ian Rogers <irogers@google.com>
    perf probe-finder: Fix libdw API contract violations

Ian Rogers <irogers@google.com>
    perf libdw: Fix libdw API contract violations and memory leaks

Ian Rogers <irogers@google.com>
    perf dwarf-aux: Fix libdw API contract violations

Ian Rogers <irogers@google.com>
    perf dwarf-aux: Fix libdw segmentation fault in cu_walk_functions_at

Alexandru Hossu <hossu.alexandru@gmail.com>
    staging: nvec: fix use-after-free in nvec_rx_completed()

Maksym Pikhotskyi <mpikhotskyi@gmail.com>
    staging: rtl8723bs: fix stainfo check in rtw_aes_decrypt

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix missed IBI after false SLVSTART on NPCM845

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Only trigger ActiveBoth interrupts on boot

Nam Cao <namcao@linutronix.de>
    eventpoll: Fix epoll_wait() report false negative

Christian Brauner <brauner@kernel.org>
    eventpoll: rename epi->next and txlist for clarity

Christian Brauner <brauner@kernel.org>
    eventpoll: expand top-of-file overview / locking doc

Gui-Dong Han <hanguidong02@gmail.com>
    9p: Add missing read barrier in virtio zero-copy path

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p: fix race condition on rdma->state in trans_rdma.c

Hongling Zeng <zenghongling@kylinos.cn>
    9p: avoid returning ERR_PTR(0) from mkdir operations

Aleksandr Nogikh <nogikh@google.com>
    ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: cs42l43: Sanity check firmware size

Matthew Bystrin <dev.mbstr@gmail.com>
    mfd: rsmu: Fix page register setup

Matti Vaittinen <mazziesaccount@gmail.com>
    mfd: bd72720: Drop BUCK11 ID

Guangshuo Li <lgs201920130244@gmail.com>
    ksmbd: fix use-after-free in same_client_has_lease()

Eric Dumazet <edumazet@google.com>
    net: serialize netif_running() check in enqueue_to_backlog()

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Replace waitqueue and flag with completion

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix memory leak of bonding resources

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Reject GET_TOGGLE_MEM when toggle page was not allocated

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fail DBR related page allocation UAPIs if the feature is disabled

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid repeated requests to allocate WC pages

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Proper rollback if the ioremap fails

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Add a max slot check for SQ

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Enable app allocated QPs

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Support doorbells for app allocated QPs

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Enhance dbr usecnt logic in doorbell uapis

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Update msn table size for app allocated QPs

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Refactor bnxt_re_init_user_qp()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid displaying the kernel pointer

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Free CQ toggle page after firmware teardown

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Free SRQ toggle page after firmware teardown

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Initialize dpi variable to zero

Brett Creeley <brett.creeley@amd.com>
    ionic: Fix check in ionic_get_link_ext_stats

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    dt-bindings: net: updated interrupt type to be active low, level triggered

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Remove FCS size in RX frame

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: mdiobus->parent initialized with NULL

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg: Use undirected TX tag for XDP zero copy in HSR offload mode

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg: Use undirected TX tag for native XDP in HSR offload mode

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix AF_XDP fill ring alloc and wakeup condition

Wayen.Yan <win847@gmail.com>
    net: airoha: Fix always-true condition in PPE1 queue reservation loop

Eric Dumazet <edumazet@google.com>
    tcp: ipv6: clamp default adverting MSS to avoid GSO_BY_FRAGS (0xFFFF)

Eric Dumazet <edumazet@google.com>
    tipc: fix UAF in tipc_l2_send_msg()

Gui-Dong Han <hanguidong02@gmail.com>
    KEYS: Use acquire when reading state in keyring search

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/kexec: fix double get_cpu() imbalance in kexec_prepare_cpus

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/powernv: fix preempt count leak in pnv_kexec_wait_secondaries_down

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/perf: fix preempt count underflow in fsl_emb_pmu_del

Yadan Fan <ydfan@suse.com>
    MIPS: mm: Fix out-of-bounds write in maar_res_walk()

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf, sockmap: fix integer overflow in bpf_msg_pop_data() bounds check

Kuniyuki Iwashima <kuniyu@google.com>
    sockmap: Fix use-after-free in udp_bpf_recvmsg()

Weiming Shi <bestswngs@gmail.com>
    bpf, sockmap: reject overflowing copy + len in bpf_msg_push_data()

Al Viro <viro@zeniv.linux.org.uk>
    udf: fix nls leak on udf_fill_super() failure

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket

Leo Yan <leo.yan@arm.com>
    selftests/bpf: Initialize operation name before use

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Fix typo in verify_umulti_link_info

Jiri Olsa <jolsa@kernel.org>
    bpf: Guard __get_user acesss with access_ok for uprobe_multi data

Nathan Chancellor <nathan@kernel.org>
    btrfs: Drop WQ_PERCPU from ordered_flags in btrfs_init_workqueues()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: always return a value for FS_IOC_GETFLAGS

Jian Zhang <zhangjian496@huawei.com>
    cifs: remove all cifs files before kill super

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix conflicting option validation for new mount API

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()

Alice Mikityanska <alice@isovalent.com>
    geneve: Fix off-by-one comparing with GRO_LEGACY_MAX_SIZE

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them

Florian Westphal <fw@strlen.de>
    netfilter: nf_conncount: callers must hold rcu read lock

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: avoid stale FIFO cells during resize

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: oss: Serialize readq reset state with q->lock

Runyu Xiao <runyu.xiao@seu.edu.cn>
    kcm: use WRITE_ONCE() when changing lower socket callbacks

Wayen.Yan <win847@gmail.com>
    net: airoha: Fix debugfs new-tuple display for IPv4 ROUTE entries

Wayen.Yan <win847@gmail.com>
    net: airoha: Fix register index for Tx-fwd counter configuration

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: fix NPC mailbox codes in mbox.h

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: bcmgenet: Use weighted round-robin TX DMA arbitration

Matthieu Buffet <matthieu@buffet.re>
    landlock: Fix unmarked concurrent access to socket family

Grzegorz Nitka <grzegorz.nitka@intel.com>
    dpll: balance create/delete notifications in __dpll_pin_(un)register

Grzegorz Nitka <grzegorz.nitka@intel.com>
    dpll: guard sync-pair removal on full pin unregister

Grzegorz Nitka <grzegorz.nitka@intel.com>
    dpll: emit per-dpll delete notifications in dpll_pin_on_pin_unregister()

Grzegorz Nitka <grzegorz.nitka@intel.com>
    dpll: send delete notification before unregister in on-pin rollback

Grzegorz Nitka <grzegorz.nitka@intel.com>
    dpll: fix stale iteration in dpll_pin_on_pin_unregister()

Ruoyu Wang <ruoyuw560@gmail.com>
    net: wwan: t7xx: check skb_clone in control TX

Wentao Guan <guanwentao@uniontech.com>
    net: ethernet: mtk_wed: debugfs: correct index in wed_amsdu_show()

Wayen.Yan <win847@gmail.com>
    net: airoha: Fix error handling in airoha_ppe_flush_sram_entries()

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: npc: Fix size of entry2cntr_map

Xu Kuohai <xukuohai@huawei.com>
    bpf: Fix setting retval to -EPERM for cgroup hooks not returning errno

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5: Check max_macs devlink param value against max capability

Sun Jian <sun.jian.kdev@gmail.com>
    bpf: Run generic devmap egress prog on private skb

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_dualpi2: Add missing module alias

Zhi-Jun You <hujy652@gmail.com>
    net: ethernet: mtk_wed: fix loading WO firmware for MT7986

Eric Dumazet <edumazet@google.com>
    net: watchdog: fix refcount tracking races

Aditya Garg <gargaditya@linux.microsoft.com>
    net: mana: guard TX wq object destroy with INVALID_MANA_HANDLE check

Aditya Garg <gargaditya@linux.microsoft.com>
    net: mana: initialize gdma queue id to INVALID_QUEUE_ID

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_dualpi2: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_codel: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_fq_codel: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen

Paolo Abeni <pabeni@redhat.com>
    virtio_net: do not allow tunnel csum offload for non GSO packets

Sechang Lim <rhkrqnwk98@gmail.com>
    tcp: clear sock_ops cb flags before force-closing a child socket

Joe Damato <joe@dama.to>
    bnxt: fix head underflow on XDP head-grow

Chuck Lever <chuck.lever@oracle.com>
    handshake: Require admin permission for DONE command

Lucas Tsai <lucas_tsai@richtek.com>
    power: supply: core: fix supplied_from allocations

Dan Williams <djbw@kernel.org>
    cxl/memdev: Pin parents for entire memdev lifetime

Dan Williams <djbw@kernel.org>
    cxl/region: Resolve region deletion races

Dan Williams <djbw@kernel.org>
    cxl/region: Block region delete during region creation

Guangshuo Li <lgs201920130244@gmail.com>
    ASoC: adau1372: Clear PLL_EN on failed PLL lock without reset GPIO

David Matlack <dmatlack@google.com>
    vfio: selftests: Ensure libvfio output dirs are always created

Li Ming <ming.li@zohomail.com>
    cxl/region: Fill first free targets[] slot during auto-discovery

Li Ming <ming.li@zohomail.com>
    cxl/region: Fix out-of-bounds access in cxl_cancel_auto_attach()

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    ASoC: sdw_utils: fix missing component_name for cs42l43 part_id 0x2A3B

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Avoid copying the user array twice in the full-array copy helper

Lars Pöschel <lars.poeschel@edag.com>
    spi: xilinx: use FIFO occupancy register to determine buffer size

Alex Mastro <amastro@fb.com>
    iommufd: Clarify IOAS_MAP_FILE dma-buf support

Li RongQing <lirongqing@baidu.com>
    iommu/dma-iommu: Fix wrong scatterlist length assignment in P2PDMA path

HanQuan <eilaimemedsnaimel@gmail.com>
    ALSA: seq: Fix kernel heap address leak in bounce_error_event()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: qcom: Guard sideband endpoint removal

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Free default RNG on module exit

Felix Gu <ustc.gu@gmail.com>
    crypto: cavium/cpt - fix DMA cleanup using wrong loop index

Felix Gu <ustc.gu@gmail.com>
    crypto: marvell/octeontx - fix DMA cleanup using wrong loop index

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Add check after kzalloc() memory in alloc_mock_res()

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Unregister cxl_acpi in cxl_test_init() error path

Michael Bommarito <michael.bommarito@gmail.com>
    tipc: reject inverted service ranges from peer bindings

Michael Bommarito <michael.bommarito@gmail.com>
    tipc: prevent snt_unacked underflow on CONN_ACK

Michael Bommarito <michael.bommarito@gmail.com>
    tipc: require net admin for TIPCv2 netlink mutators

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_hfsc: Don't make class passive twice

Daniel Borkmann <daniel@iogearbox.net>
    net: Stop leased rxq before uninstalling its memory provider

Samuel Moelius <sam.moelius@trailofbits.com>
    net: pfcp: allocate per-cpu tstats for PFCP netdevs

Xin Long <lucien.xin@gmail.com>
    sctp: validate embedded address parameter length

Xiang Mei <xmei5@asu.edu>
    bridge: cfm: reject invalid CCM interval at configuration time

Kuniyuki Iwashima <kuniyu@google.com>
    net: fib_rules: Don't dump dying fib_rule in fib_rules_dump().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: fib: Don't dump dying fib_info in fib_leaf_notify().

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_flow: Dont expose folded kernel pointers

George Moussalem <george.moussalem@outlook.com>
    net: dsa: qca8k: fix led devicename when using external mdio bus

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: topology: Check PCM and DAI name strings before use

HyeongJun An <sammiee5311@gmail.com>
    ASoC: tegra: tegra210_ahub: Validate written enum value

HyeongJun An <sammiee5311@gmail.com>
    ASoC: fsl: fsl_audmix: Validate written enum values

HyeongJun An <sammiee5311@gmail.com>
    ASoC: meson: aiu: Validate written enum values

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: hdac_hdmi: Validate written enum value

Arnd Bergmann <arnd@arndb.de>
    ASoC: SOF: Intel: hda-sdw-bpt: select SND_SOF_SOF_HDA_SDW_BPT properly

Arnd Bergmann <arnd@arndb.de>
    ASoC: SOF: Intel: select SND_SOC_SDW_UTILS=y from SND_SOC_SOF_HDA_GENERIC=y

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix wrong error test on simple_write_to_buffer()

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Release the HW‑provided UAR index rather than the SW one

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix undefined shift of user RQ WQE size

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Remove raw RSS QP restrack tracking

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Remove DCT restrack tracking

Maxwell Doose <m32285159@gmail.com>
    fs: efs: remove unneeded debug prints

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Drop FRMR pool handle on UMR revoke failure

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Add ib_frmr_pool_drop for unrecoverable handles

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Fix FRMR handle leak on push failure

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Avoid NULL dereference on FRMR bad usage

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Fix FRMR set pinned push error path

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Fix FRMR aging push to queue error flow

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/core: Fix skipped usage for driver built FRMR key

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Fix TPH extraction in FRMR pool key

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Fix mkey creation error flow rollback

Samuel Moelius <sam.moelius@trailofbits.com>
    Bluetooth: vhci: validate devcoredump state before side effects

Samuel Moelius <sam.moelius@trailofbits.com>
    Bluetooth: hci: validate codec capability element length

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel_pcie: Load IOSF debug regs by controller variant

Zhao Dongdong <zhaodongdong@kylinos.cn>
    Bluetooth: btmtk: fix URB leak in alloc_mtk_intr_urb error path

Jordan Walters <jaggyaur@gmail.com>
    Bluetooth: hci_core: Fix UAF in hci_unregister_dev()

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING

Weiming Shi <bestswngs@gmail.com>
    Bluetooth: eir: Fix stack OOB write when prepending the Flags AD

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for non-serdev device

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_qca: fix NULL pointer dereference in qca_setup() for non-serdev device

Heiko Carstens <hca@linux.ibm.com>
    s390/process: Fix kernel thread function pointer type

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix possible uninitialized value in cs35l56_spi_system_reset()

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a523: Add missing GPIO interrupt

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: remove undefined groups from pcm_spi pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix phy1_led1 pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: add missed gpio22 pin group

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix gpio21 pin group

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix pwm pin function for an7581 and an7583

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix incorrect led mapping in phy4_led1 pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix incorrect led mapping in phy4_led1 pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix misprint in gpio19 pinconf

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix misprint in gpio19 pinconf

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: add missed gpio32 pin group

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: add missed gpio32 pin group

Andre Przywara <andre.przywara@arm.com>
    pinctrl: sunxi: a523: Remove unneeded IRQ remuxing flag

Angelo Dureghello <adureghello@baylibre.com>
    m68k: mcf5441x: fix clocks numbering

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Tighten cgroup storage cookie checks for prog arrays

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    vfio/qat: fix f_pos race in qat_vf_resume_write()

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    of: cpu: add check in __of_find_n_match_cpu_property()

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Zero out LSA backing memory to avoid leaking to user

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Fix integer overflow in mock LSA bounds checks

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Verify cmd->size_in before accessing payload

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix bpf_iter/task_vma test

Yun Zhou <yun.zhou@windriver.com>
    ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix kernel BUG in ext4_write_inline_data_end

Louis Scalbert <louis.scalbert@6wind.com>
    bonding: 3ad: fix mux port state on oper down

Louis Scalbert <louis.scalbert@6wind.com>
    bonding: 3ad: fix carrier when no usable slaves

Louis Scalbert <louis.scalbert@6wind.com>
    bonding: 3ad: add lacp_strict configuration knob

Louis Scalbert <louis.scalbert@6wind.com>
    netlink: specs: rt-link: missed broadcast-neigh

Louis Scalbert <louis.scalbert@6wind.com>
    tools: missed broadcast_neigh if_link uapi header

Hongling Zeng <zenghongling@kylinos.cn>
    ext4: fix ERR_PTR(0) in ext4_mkdir()

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (gpd-fan): fix race condition between device removal and sysfs access

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (gpd-fan): Initialize EC before registering hwmon device

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (gpd-fan): drop global driver data and use per-device allocation

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Don't leave parent IRQ disabled if system_suspend fails

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Cleanup if component_probe fails

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Prevent double-free of debugfs

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix missing calls to wm_adsp2_remove()

Christoph Hellwig <hch@lst.de>
    iomap: pass the correct len to fserror_report_io in __iomap_write_begin

Srujana Challa <schalla@marvell.com>
    vdpa/octeon_ep: fix IRQ-to-ring mapping in interrupt handler

Srujana Challa <schalla@marvell.com>
    vdpa/octeon_ep: Fix PF->VF mailbox data address calculation

Arnd Bergmann <arnd@arndb.de>
    vduse: fix compat handling for VDUSE_IOTLB_GET_FD/VDUSE_VQ_GET_INFO

longlong yan <yanlonglong@kylinos.cn>
    tools/virtio: check mmap return value in vringh_test

Qing Ming <a0yami@mailbox.org>
    vhost/net: complete zerocopy ubufs only once

Zhang Tianci <zhangtianci.1997@bytedance.com>
    vduse: Requeue failed read to send_list head

Filip Hejsek <filip.hejsek@gmail.com>
    virtio_console: read size from config space during device init

Jia Jia <physicalmtea@gmail.com>
    virtio: rtc: tear down old virtqueues before restore

Qihang Tang <q.h.hack.winter@gmail.com>
    vhost/vdpa: validate virtqueue index in mmap and fault paths

Qihang Tang <q.h.hack.winter@gmail.com>
    vduse: hold vduse_lock across IDR lookup in open path

Enric Balletbo i Serra <eballetb@redhat.com>
    clocksource: move NXP timer selection to drivers/clocksource

Justin Suess <utilityemal77@gmail.com>
    bpf: Cancel special fields on map value recycle

Val Packett <val@packett.cool>
    ASoC: codecs: aw88261: fix incorrect masks for boost regs

Ruoyu Wang <ruoyuw560@gmail.com>
    spi: meson-spifc: fix runtime PM leak on remove

Chuck Lever <chuck.lever@oracle.com>
    lockd: Avoid hashing uninitialized bytes in nlm4svc_lookup_file()

Chuck Lever <chuck.lever@oracle.com>
    lockd: Do not monitor when looking up the LOCK_MSG callback host

Chuck Lever <chuck.lever@oracle.com>
    lockd: Translate nlm__int__deadlock in __nlm4svc_proc_lock_msg()

Chuck Lever <chuck.lever@oracle.com>
    lockd: Stop warning on nlm__int__drop_reply in !V4 cast_status

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Handle layout stid in nfsd4_drop_revoked_stid()

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx4: Fill in the access_flags if IB_MR_REREG_ACCESS is not specified

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: sma1307: Fix uevent string leaks in fault worker

KhaiWenTan <khai.wen.tan@linux.intel.com>
    igc: skip RX timestamp header for frame preemption verification

Larysa Zaremba <larysa.zaremba@intel.com>
    ixgbe: do not configure xps for XDP queues

Weiming Shi <bestswngs@gmail.com>
    btrfs: lzo: reject compressed segment that overflows the compressed input

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock cloning inline extent when using flushoncommit

Cen Zhang <zzzccc427@gmail.com>
    btrfs: annotate lockless read of defrag_bytes in should_nocow()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: always set max_active_zones for zoned devices

Matthew Wilcox (Oracle) <willy@infradead.org>
    Revert "btrfs: fix the file offset calculation inside btrfs_decompress_buf2page()"

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix deadlock waiting for ticket during data relocation

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't account data relocation space-info in statfs free space

Yuho Choi <dbgh9129@gmail.com>
    PM: QoS: Fix misc device registration unwind

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    hwmon: (it87) Clamp negative values to zero in set_fan()

Jeff Layton <jlayton@kernel.org>
    vfs: add FS_USERNS_DELEGATABLE flag and set it for NFS

Sumit Gupta <sumitg@nvidia.com>
    memory: tegra186-emc: stop borrowing MC aggregate hook for EMC

David Laight <david.laight.linux@gmail.com>
    fbdev: sm501fb: Fix buffer errors in OF binding code

Helge Deller <deller@gmx.de>
    fbdev/arm: Export acorndata_8x8 font symbol for bootloader

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath12k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE when NSS ratio is reported

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix EAPOL TX failure caused by stale tcl_metadata bits

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: fix interrupt banks mapping on gpio chips

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Drop superfluous break

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: fix potential tx_retries underflow

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7925: fix potential tx_retries underflow

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7921: fix potential tx_retries underflow

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix potential tx_retries underflow

Bjoern A. Zeeb <bz@FreeBSD.org>
    wifi: mt76: fix argument to ieee80211_is_first_frag()

Dylan Eskew <dylan.eskew@candelatech.com>
    wifi: mt76: mt7996: limit work in set_bitrate_mask

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: remove redundant pdev->bus check in probe

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix reading zeroed info->control.flags after mt76_tx_status_skb_add()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix possible NULL pointer dereference in mt7996_mac_write_txwi_80211()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix possible token leak in mt7996_tx_prepare_skb()

Aviel Zohar <avielzohar123@gmail.com>
    wifi: mt76: mt7925: validate skb length in testmode query

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: skip MLD header rewrite for 802.3 encap TX

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: keep TX BA state in the primary WCID

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: fix stale pointer comparisons in change_vif_links

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix NULL pointer dereference in mt7996_init_tx_queues()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: add missing max_remain_on_channel_duration

Rajat Gupta <rajat.gupta@oss.qualcomm.com>
    wifi: mt76: use kfree_rcu for offchannel link in mt76_put_vif_phy_link

Hongling Zeng <zenghongling@kylinos.cn>
    wifi: mt76: mt7921: fix resource leak in probe error path

Myeonghun Pak <mhun512@gmail.com>
    wifi: mt76: mt7925: clean up DMA on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    ARM: configs: Drop duplicated CONFIG_EXT4_FS

Hongyan Xia <hongyan.xia@transsion.com>
    sched/fair: Fix cpu_util runnable_avg arithmetic

Wolfram Sang <wsa+renesas@sang-engineering.com>
    hwspinlock: qcom: avoid uninitialized struct members

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    remoteproc: qcom_q6v5_wcss: drop redundant wcss_q6_bcr_reset

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: show the right `quiet_cmd_rustc_procmacrolibrary`

Hui Zhu <zhuhui@kylinos.cn>
    vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()

Hao Ge <hao.ge@linux.dev>
    lib/test_hmm: fix memory leak in dmirror_migrate_to_system()

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Destroy the pages content after detaching from dmabuf

Ankit Soni <Ankit.Soni@amd.com>
    iommufd: Take dma_resv lock before dma_buf_unpin() in release path

Timur Tabi <ttabi@nvidia.com>
    pinctrl: PINCTRL_STMFX should depend on CONFIG_OF

Yu-Chun Lin <eleanor.lin@realtek.com>
    dt-bindings: pinctrl: realtek,rtd1625: Fix input voltage property name

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    pinctrl: mediatek: mt8167: Fix Schmitt trigger register offset of pins 34-39

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39

Mike Christie <michael.christie@oracle.com>
    scsi: target: Remove tcm_loop target reset handling

Hongjie Fang <hongjiefang@asrmicro.com>
    scsi: ufs: core: Handle PM commands timeout before SCSI EH

David Disseldorp <ddiss@suse.de>
    scsi: target: Fix hexadecimal CHAP_I handling

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    pinctrl: qcom: Fix resolving register base address from device node

Yuho Choi <dbgh9129@gmail.com>
    watchdog: unregister PM notifier on watchdog unregister

Al Viro <viro@zeniv.linux.org.uk>
    configfs: fix lockless traversals of ->s_children

Dmitry Vyukov <dvyukov@google.com>
    firmware_loader: Fix recursive lock in device_cache_fw_images()

Aaron Ma <aaron.ma@canonical.com>
    ASoC: amd: acp-sdw-sof: Bound DAI link iteration

Aaron Ma <aaron.ma@canonical.com>
    ASoC: amd: acp-sdw-legacy: Bound DAI link iteration

Felix Gu <ustc.gu@gmail.com>
    spi: ep93xx: fix double-free of zeropage on DMA setup failure

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Don't mangle the mr->pd inside the rereg callback

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Pull the pdn out of the depths of the umr machinery

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Remove unused mkc bits in mlx5r_umr_update_mr_page_shift()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/nldev: Fix locking when accessing mr->pd

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Properly support implicit ODP rereg_mr

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Don't take the rereg_mr fallback without a new translation

Bryam Vargas <hexlabsecurity@proton.me>
    ntfs: fix u16 truncation of restart-area length check

Bryam Vargas <hexlabsecurity@proton.me>
    ntfs: bound the attribute-list entry in ntfs_read_inode_mount()

Bryam Vargas <hexlabsecurity@proton.me>
    ntfs: bound the look-ahead attribute-list entry in ntfs_external_attr_find()

Bryam Vargas <hexlabsecurity@proton.me>
    ntfs: validate resident attribute lists and harden the validator

Mark Harmstone <mark@harmstone.com>
    btrfs: don't force DIO writes to be serialized

Samuel Moelius <sam.moelius@trailofbits.com>
    thermal: testing: reject missing command arguments

Pengjie Zhang <zhangpengjie2@huawei.com>
    cpufreq: Documentation: fix conservative governor freq_step description

Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
    ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()

Yuho Choi <dbgh9129@gmail.com>
    ACPI: IPMI: Fix message kref handling on dead device

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf: Fix NULL pointer dereference in bpf_task_from_vpid()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    powerpc/8xx: implement get_direction() in cpm1

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mac80211: bound S1G TIM PVB walk to the TIM element

David Gow <david@davidgow.net>
    kunit:tool: Don't write to stdout when it should be disabled

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Fix NMI/tracepoint re-entry deadlock on lru locks

Christian Brauner <brauner@kernel.org>
    filelock: fix break_lease() stub signature for CONFIG_FILE_LOCKING=n

David Carlier <devnexen@gmail.com>
    netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

David Windsor <dwindsor@gmail.com>
    bpf: Reject sleepable BPF_LSM_CGROUP programs at load time

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Verifier support for sleepable tracepoint programs

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: alternative: Also patch the CFI vDSO

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: alternative: Pass vDSO start as parameter to apply_vdso_alternatives()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: alternative: Use IS_ENABLED() over ifdeffery for apply_vdso_alternatives()

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Clear variable event pointer on read

Rui Qi <qirui.001@bytedance.com>
    riscv: stacktrace: Remove bogus -0x4 offset in non-FP walk_stackframe

Hui Wang <hui.wang@canonical.com>
    riscv: cpu_ops: Change return value type of cpu_is_stopped() to bool

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcm: Fix unlocked runtime state reads in xfer ioctls

HyeongJun An <sammiee5311@gmail.com>
    ALSA: seq: Fix partial userptr event expansion

Tristan Madani <tristan@talencesecurity.com>
    wifi: wcn36xx: fix OOB read from short trigger BA firmware response

Tristan Madani <tristan@talencesecurity.com>
    wifi: wcn36xx: fix OOB read from firmware count in PRINT_REG_INFO indication

Tristan Madani <tristan@talencesecurity.com>
    wifi: wcn36xx: fix heap overflow from oversized firmware HAL response

Christian Brauner <brauner@kernel.org>
    kernfs: link kn to its parent before the LSM init hook

Miklos Szeredi <mszeredi@redhat.com>
    simpe_xattr: use per-sb cache

Miklos Szeredi <mszeredi@redhat.com>
    simple_xattr: change interface to pass struct simple_xattrs **

Miklos Szeredi <mszeredi@redhat.com>
    tmpfs: simplify constructing "security.foo" xattr names

Miklos Szeredi <mszeredi@redhat.com>
    kernfs: fix xattr race condition with multiple superblocks

Leon Hwang <leon.hwang@linux.dev>
    bpf: Update transport_header when encapsulating UDP tunnel in lwt

Leon Hwang <leon.hwang@linux.dev>
    bpf: Check tail zero of bpf_prog_info

Leon Hwang <leon.hwang@linux.dev>
    bpf: Check tail zero of bpf_map_info

Kaitao Cheng <chengkaitao@kylinos.cn>
    bpf: Clear rb node linkage when freeing bpf_rb_root

Mykyta Yatsenko <yatsenko@meta.com>
    selftests/bpf: Fix flaky file_reader test

Bernard Metzler <bernard.metzler@linux.dev>
    RDMA/siw: Fix endpoint/socket association handling

Nora Schiffer <nora.schiffer@ew.tq-group.com>
    arm64: dts: freescale: fsl-ls1028a-tqmls1028a-mbls1028a: switch mmc aliases

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mp-kontron: Fix GPIO for display power switch

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as well

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2162a-clearfog: use rev2 SoC dtsi

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx95: Correct PCIe outbound address space configuration

Alice Guo <alice.guo@nxp.com>
    arm64: dts: imx94: fix DDR PMU interrupt number

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mp-kontron: Reduce EERAM SPI clock frequency

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Initialize iwmr->access during MR registration

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix OOB read during CQ MR registration

Oliver Hartkopp <socketcan@hartkopp.net>
    ALSA: hda: fix Kconfig dependency of HD Audio PCI

Jason Gunthorpe <jgg@ziepe.ca>
    IB/cm: Fix av cm device leak on an error path in cm_init_av_by_path()

Arnd Bergmann <arnd@arndb.de>
    RDMA/hfi1: Open-code rvt_set_ibdev_name()

DaeMyung Kang <charsyam@gmail.com>
    ntfs: free link name from ntfs_name_cache

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: revert ct extension genid infrastructure

Junxiao Chang <junxiao.chang@intel.com>
    x86/cpu: Remove obsolete aperfmperf_get_khz() declaration

Shengming Hu <hu.shengming@zte.com.cn>
    mm/slub: preserve original size in _kmalloc_nolock_noprof retry path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: qcom: Initialize offload control return value

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: fix unaligned memory access in timestamp adjustment

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: adjust duplicate timestamp options

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: drop packets if timestamp adjustment fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Convert PCIBIOS errors to errno on DVSEC config accesses

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Fix the incorrect check of pci_read_config_word() return

Ian Bridges <icb@fastmail.org>
    ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2/dlm: require a ref for locking_state debugfs open

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: reject FITRIM ranges shorter than a cluster

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: validate fast symlink target during inode read

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix buffer head management in ocfs2_read_blocks()

Thomas Weißschuh <linux@weissschuh.net>
    lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: rebase copied fsdlm LVB pointers in locking_state

Wandun Chen <chenwandun@lixiang.com>
    of: reserved_mem: avoid post-init UAF when alloc_reserved_mem_array() fails

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: always resume_all after suspend_all

Alexei Starovoitov <ast@kernel.org>
    bpf: Take mmap_lock in zap_pages()

Dan Williams <djbw@kernel.org>
    cxl/test: Fix __fortify_panic

Dan Williams <djbw@kernel.org>
    cxl/fwctl: Fix __fortify_panic

Andreas Kemnade <andreas@kemnade.info>
    wifi: wlcore: enable the right set of ciphers

Antony Antony <antony.antony@secunet.com>
    xfrm: fix NAT-related field inheritance in SA migration

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Use Node ID to identify DF and UMC domains

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix PCI device refcount leak in UPI discovery

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix discovery unit lookup for multi-die systems

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/core: Always use the NMI latency mitigation

Christian Brauner <brauner@kernel.org>
    eventpoll: wrap EP_UNACTIVE_PTR in typed sentinel helpers

Christian Brauner <brauner@kernel.org>
    eventpoll: extract ep_deliver_event() from ep_send_events()

Christian Brauner <brauner@kernel.org>
    eventpoll: split ep_insert() into alloc + register stages

Christian Brauner <brauner@kernel.org>
    eventpoll: rename attach_epitem() to ep_attach_file()

Jeff Layton <jlayton@kernel.org>
    mm: preserve PG_dropbehind flag during folio split

Pranjal Shrivastava <praan@google.com>
    iommu/vt-d: Fix RB-tree corruption in probe error path

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix vhost_get_avail_idx for a non empty ring

Woojin Ji <random6.xyz@gmail.com>
    bpftool: Use libbpf error code for flow dissector query

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Return errors for failed debug BO commands

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: set sub_block_index for mca ras sub-blocks

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amd/pm: Add empty string validation to sysfs store functions

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix KASAN slab-out-of-bounds in amdgpu_coredump ring dump

Marek Szyprowski <m.szyprowski@samsung.com>
    irqchip/exynos-combiner: Remove useless spinlock

Li Chen <me@linux.beauty>
    ext4: fix fast commit wait/wake bit mapping on 64-bit

Karl Mehltretter <kmehltretter@gmail.com>
    lockdep/selftests: Restore sched_rt_mutex state on PREEMPT_RT

Karl Mehltretter <kmehltretter@gmail.com>
    lockdep/selftests: Restore migrate_disable() state on PREEMPT_RT

Al Viro <viro@zeniv.linux.org.uk>
    configfs_lookup(): don't leave ->s_dentry dangling on failure

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: sophgo: sg2042: use hex for CPU unit address

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: sophgo: sg2044: use hex for CPU unit address

Alexander Potapenko <glider@google.com>
    lib/test_meminit: use && for bools

Frederic Weisbecker <frederic@kernel.org>
    tick/sched: Fix TOCTOU in nohz idle time fetch

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject exclusive maps for bpf_map_elem iterators

Nathan Chancellor <nathan@kernel.org>
    driver core: Use system_percpu_wq instead of system_wq

liuxixin <gliuxen@gmail.com>
    nvme: fix FDP fdpcidx bounds check

Guanyou.Chen <chenguanyou9338@gmail.com>
    sched: restore timer_slack_ns when resetting RT policy on fork

Danila Chernetsov <listdansp@mail.ru>
    ext2: fix ignored return value of generic_write_sync()

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/fake-numa: fix under-allocation detection in uniform split

Deepanshu Kartikey <kartikey406@gmail.com>
    bpf: fix UAF by restoring RCU-delayed inode freeing in bpffs

Chanwoo Lee <cw9316.lee@samsung.com>
    scsi: ufs: Fix wrong value printed in unexpected UPIU response case

Dan Carpenter <error27@gmail.com>
    scsi: pm8001: Fix error code in non_fatal_log_show()

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Skip max_entries override on signed loaders

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Skip initial_value override on signed loaders

KP Singh <kpsingh@kernel.org>
    libbpf: Reject non-exclusive metadata maps in the signed loader

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject exclusive maps as inner maps in map-in-map

Martin Wilck <martin.wilck@suse.com>
    scsi: Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans"

Neal Cardwell <ncardwell@google.com>
    tcp_bbr: fix SPDX-License-Identifier to be GPL-2.0 OR BSD-3-Clause

Alison Schofield <alison.schofield@intel.com>
    nvdimm/btt: Handle preemption in BTT lane acquisition

Randy Dunlap <rdunlap@infradead.org>
    x86/cpu: Keep the PROCESSOR_SELECT menu together

Yuho Choi <dbgh9129@gmail.com>
    ARM: imx31: Fix IIM mapping leak in revision check

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: button: Fix lid_device value leak past driver removal

Bart Van Assche <bvanassche@acm.org>
    ata: libata: Fix ata_exec_internal()

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath12k: fix NULL deref in change_sta_links for unready link

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath12k: fix inconsistent arvif state in vdev_create error paths

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix memory leak in ath12k_wifi7_dp_rx_h_verify_tkip_mic()

Kwan Lai Chee Hou <laicheehou9@gmail.com>
    wifi: ath12k: fix incorrect HT/VHT/HE/EHT MCS reporting in monitor mode

J. Neuschäfer <j.ne@posteo.net>
    HID: wiimote: Fix table layout and whitespace errors

Yuho Choi <dbgh9129@gmail.com>
    ARM: imx3: Fix CCM node reference leak

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix delegation reference leak in nfsd4_revoke_states

John Madieu <john.madieu.xa@bp.renesas.com>
    ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble

Carlos Song <carlos.song@nxp.com>
    spi: imx: replace dmaengine_terminate_all() with dmaengine_terminate_sync()

Felix Gu <ustc.gu@gmail.com>
    spi: atmel: fix DMA channel and bounce buffer leaks

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback

Pasha Tatashin <pasha.tatashin@soleen.com>
    liveupdate: fix u-a-f in luo_file_unpreserve_files() and luo_file_finish()

Pasha Tatashin <pasha.tatashin@soleen.com>
    liveupdate: block session mutations during reboot

Pasha Tatashin <pasha.tatashin@soleen.com>
    liveupdate: fix TOCTOU race in luo_session_retrieve()

Pasha Tatashin <pasha.tatashin@soleen.com>
    liveupdate: skip serialization for context-preserving kexec

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Skip endianness swap when loader generation failed

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Skip hash computation when loader generation failed

David Matlack <dmatlack@google.com>
    liveupdate: Reference count incoming FLB data

David Matlack <dmatlack@google.com>
    liveupdate: Use refcount_t for FLB reference counts

Yuyang Huang <yuyanghuang@google.com>
    selftests/bpf: add verification for BPF_PROG_QUERY attr size boundaries

Yuyang Huang <yuyanghuang@google.com>
    bpf: fix BPF_PROG_QUERY OOB write and cgroup backward compat

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    raid1: fix nr_pending leak in REQ_ATOMIC bad-block error path

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix bio accounting for split md cloned bios

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix error-path detection with md_cloned_bio()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix deadlock in read error recovery path

Chen Cheng <chencheng@fnnas.com>
    md/raid10: reset read_slot when reusing r10bio for discard

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: ironhide: Describe all reserved memory

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: r8a78000: Fix GIC-720AE View 1 Redistributor description

Danilo Krummrich <dakr@kernel.org>
    rpmsg: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    Drivers: hv: vmbus: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    cdx: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    amba: use generic driver_override infrastructure

Renjiang Han <renjiang.han@oss.qualcomm.com>
    media: qcom: venus: relax encoder frame/blur step size on v6

Renjiang Han <renjiang.han@oss.qualcomm.com>
    media: qcom: venus: relax encoder frame/blur dimension steps on v4

Renjiang Han <renjiang.han@oss.qualcomm.com>
    media: qcom: venus: drop extra padding in NV12 raw size calculation

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    Revert "media: venus: hfi_platform: Correct supported codecs for sc7280"

Yixun Lan <dlan@kernel.org>
    dts: riscv: spacemit: k3: Fix I/O power settings

Tristan Madani <tristmd@gmail.com>
    RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path

Tristan Madani <tristmd@gmail.com>
    RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe

Jiri Pirko <jiri@resnulli.us>
    RDMA/umem: Add ib_umem_is_contiguous() stub for !CONFIG_INFINIBAND_USER_MEM

Jinseok Kim <always.starving0@gmail.com>
    arm: dts: bcm2711: Fix typo in gpio-line-names

Marek Vasut <marex@nabladev.com>
    arm64: dts: st: Fix SAI addresses on stm32mp251

zhoumin <teczm@foxmail.com>
    EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_info

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix memory topology parsing for Panther Lake-H SoCs

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix call trace due to missing release()

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a8xx: Fix RSCC offset

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a8xx: Make a8xx_recover IFPC safe

Arnd Bergmann <arnd@arndb.de>
    firmware: samsung: acpm: remove compile-testing stubs

Tudor Ambarus <tudor.ambarus@linaro.org>
    firmware: samsung: acpm: Add devm_acpm_get_by_phandle helper

Jessica Zhang <jesszhan0024@gmail.com>
    drm/msm/dp: Fix the ISR_* enum values

Jessica Zhang <jesszhan0024@gmail.com>
    drm/msm/dp: fix HPD state status bit shift value

Andrea Righi <arighi@nvidia.com>
    sched/deadline: Reject debugfs dl_server writes for offline CPUs

Alexey Kardashevskiy <aik@amd.com>
    crypto: ccp/tsm - Enable the root port after the endpoint

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tegra - Fix dma_free_coherent size error

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: inside-secure/eip93 - Add check for devm_request_threaded_irq

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - disable error report before flr

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: kill osb->system_file_mutex lock

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: don't BUG_ON an invalid journal dinode

Dan Carpenter <error27@gmail.com>
    rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()

Yury Norov <ynorov@nvidia.com>
    uaccess: minimize INLINE_COPY_USER-related ifdefery

Yury Norov <ynorov@nvidia.com>
    uaccess: unify inline vs outline copy_{from,to}_user() selection

Yury Norov <ynorov@nvidia.com>
    rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()

Josh Law <objecting@objecting.org>
    lib/base64: validate before writing in decode tail path

Davidlohr Bueso <dave@stgolabs.net>
    dax/kmem: account for partial discontiguous resource upon removal

Danilo Krummrich <dakr@kernel.org>
    rust: devres: add 'static bound to Devres<T>

Brian Norris <briannorris@chromium.org>
    arm64: tegra: Add #{address,size}-cells to Chromium-based /firmware

Brian Norris <briannorris@chromium.org>
    ARM: tegra: Add #{address,size}-cells to Chromium-based /firmware

Carlos Llamas <cmllamas@google.com>
    libbpf: Fix UAF in strset__add_str()

Siddharth Nayyar <sidnayyar@google.com>
    bpftool: Fix typo in struct_ops map FD generation for light skeleton

Michael Bommarito <michael.bommarito@gmail.com>
    libbpf: Harden parse_vma_segs() path parsing

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau/bios: specify correct display fuse register for Ampere and Ada

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Fix iommu_map_sgtable() return value check

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix iommu_map_sgtable() return value check

Felix Gu <ustc.gu@gmail.com>
    drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()

Felix Gu <ustc.gu@gmail.com>
    gpu: host1x: mipi: Fix device_node reference leak in tegra_mipi_request()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Allow entries in BO caches to be freed

Ion Agorria <ion@agorria.com>
    drm/tegra: gr2d/gr3d: Contain PM in the gr*d_probe/gr*d_remove

Svyatoslav Ryhel <clamor95@gmail.com>
    drm/tegra: gr2d/gr3d: Initialize address register map before HOST1X client is registered

Tomas Glozar <tglozar@redhat.com>
    rtla/actions: Restore continue flag in actions_perform()

Linus Walleij <linusw@kernel.org>
    dt-bindings: vendor-prefixes: Add Verbatim Corporation

Jackie Dong <xy-jackie@139.com>
    ALSA: hda/realtek:ALC269 fixup for Yoga Pro 7 15ASH11 mic mute LED

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix premature break in init_iommu_one()

Jiayuan Chen <jiayuan.chen@linux.dev>
    net/sched: cls_bpf: prevent unbounded recursion in offload rollback

Eric Dumazet <edumazet@google.com>
    ipv6: guard against possible NULL deref in __in6_dev_stats_get()

Breno Leitao <leitao@debian.org>
    workqueue: drop spurious '*' from print_worker_info() fn declaration

Mateusz Nowicki <mateusz.nowicki@posteo.net>
    nvme-pci: fix out-of-bounds access in nvme_setup_descriptor_pools

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: fix flex array size in struct nvme_ns_head

Geliang Tang <geliang@kernel.org>
    nvmet-tcp: check return value of nvmet_tcp_set_queue_sock

Geliang Tang <geliang@kernel.org>
    nvmet-tcp: fix page fragment cache leak in error path

Jia He <justin.he@arm.com>
    init/initramfs_test: wait_for_initramfs() before running

Charles Keepax <ckeepax@opensource.cirrus.com>
    pinctrl: cs42l43: Fix polarity on debounce

Charles Keepax <ckeepax@opensource.cirrus.com>
    pinctrl: cs42l43: Fix leaked pm reference on error path

Joey Lu <a0987203069@gmail.com>
    pinctrl: nuvoton: ma35d1: fix MFP register offset and pin table

Florian Schmaus <flo@geekplace.eu>
    selftests: Fix Makefile target for nsfs

Zhang Cen <rollkingzzc@gmail.com>
    ALSA: seq: midi: Serialize output teardown with event_input

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: xen-front: Connect event channel after stream prepare

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: xen-front: Reset event channel state on stream clear

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: governor: Fix stale prev_cpu_nice spike when enabling ignore_nice_load

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: governor: Fix data races on per-CPU idle/nice baselines

Ripan Deuri <ripan.deuri@oss.qualcomm.com>
    wifi: ath12k: fix error unwind on arch_init() failure in PCI probe

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: Drop duplicate Kconfig dependency

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: debugfs: Fix the flags list

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix address of Tegra264 main GPIO controller

Danilo Krummrich <dakr@kernel.org>
    driver core: Guard deferred probe timeout extension with delayed_work_pending()

Danilo Krummrich <dakr@kernel.org>
    driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()

Rosen Penev <rosenp@gmail.com>
    mips: n64: add __iomem for writel call

Rosen Penev <rosenp@gmail.com>
    mips: ralink: mt7621: add missing __iomem

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: DEC: Remove do_IRQ() call indirection

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix big-endian stack argument fetching in o32 wrapper

Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
    PM: sleep: Use complete() in device_pm_sleep_init()

Xianwei Zhao <xianwei.zhao@amlogic.com>
    pinctrl: meson: amlogic-a4: fix gpio output glitch

Tao Cui <cuitao@kylinos.cn>
    RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PAD: Fix teardown ordering in acpi_pad_remove()

Lianfa Weng <wenglianfa@huawei.com>
    RDMA/hns: Fix log flood after cmd_mbox failure

Lianfa Weng <wenglianfa@huawei.com>
    RDMA/hns: Fix warning in poll cq direct mode

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: use checked accesses in `setup_falcon_data`

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: use checked access in `FwSecBiosImage::header`

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: use checked ops and accesses in `FwSecBiosImage::ucode`

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: read BitToken using FromBytes

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: avoid reading too far in read_more_at_offset

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: use checked arithmetic for bios image range end

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: vbios: stop scanning at BIOS_MAX_SCAN_LEN

Guangshuo Li <lgs201920130244@gmail.com>
    IB/mlx4: Fix refcount leak in add_port() error path

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix a use-after-free problem in rxe_mmap

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix out-of-bounds write in irdma_copy_user_pgaddrs

Chancel Liu <chancel.liu@nxp.com>
    ASoC: dapm: Fix widget lookup with prefixed names across DAPM contexts

Han Gao <gaohan@iscas.ac.cn>
    pinctrl: spacemit: fix NULL check in spacemit_pin_set_config

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Always check register address validity

Daniel Palmer <daniel@thingy.jp>
    tools/nolibc: stackprotector: Avoid stalling program startup if crng is not init yet

Shiraz Saleem <shirazsaleem@microsoft.com>
    RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed

Ronaldo Nunez <rnunez@baylibre.com>
    pwm: imx27: Fix variable truncation in .apply()

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: conservative: Simplify frequency limit handling

Pengjie Zhang <zhangpengjie2@huawei.com>
    cpufreq: Documentation: fix sampling_down_factor range

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/mdss: correct UBWC programming sequences

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8189: Fix probe resource cleanup

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: eip93 - fix reset ring register definition

Saravana Kannan <saravanak@kernel.org>
    of: dynamic: Fix overlayed devices not probing because of fw_devlink

Saravana Kannan <saravanak@kernel.org>
    Revert "treewide: Fix probing of devices in DT overlays"

Zhang Yuwei <zhangyuwei20@huawei.com>
    driver core: Use mod_delayed_work to prevent lost deferred probe work

Stepan Ionichev <sozdayvek@gmail.com>
    device property: fix fwnode reference leak in fwnode_graph_get_endpoint_by_id()

Conor Kotwasinski <conorkotwasinski2024@u.northwestern.edu>
    kernfs: fix suspicious RCU usage in kernfs_put()

Baokun Li <libaokun@linux.alibaba.com>
    writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()

Joel Selvaraj <foss@joelselvaraj.com>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Correct IPA FW path

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix wrong interrupt number for i2c19

Ritesh Kumar <quic_riteshk@quicinc.com>
    arm64: dts: qcom: lemans: Add eDP ref clock for eDP PHYs

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Bound synthetic-field strings with seq_buf

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: monaco: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Add power-domain and iface clk for ice node

Harshal Dev <harshal.dev@oss.qualcomm.com>
    arm64: dts: qcom: kaanapali: Add power-domain and iface clk for ice node

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: eliza-mtp: Fix the debug UART index

Geert Uytterhoeven <geert+renesas@glider.be>
    firmware: arm_scmi: Fix OOB in scmi_power_name_get()

Sven Püschel <s.pueschel@pengutronix.de>
    media: rockchip: rga: fix too small buffer size

Nishanth Sampath Kumar <nissampa@cisco.com>
    regmap-i2c: fix sparse warning in regmap_smbus_word_write_reg16

Eric Dumazet <edumazet@google.com>
    net/sched: sch_drr: annotate data-races around cl->deficit

GuoHan Zhao <zhaoguohan@kylinos.cn>
    vfio/xe: avoid duplicate reset in xe_vfio_pci_reset_done

Hongling Zeng <zenghongling@kylinos.cn>
    nilfs2: Fix return in nilfs_mkdir

David Matlack <dmatlack@google.com>
    vfio: selftests: Allow builds when ARCH=x86

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: selftests: Fix out-of-tree build with make O=

Daniel Palmer <daniel@thingy.jp>
    tools/nolibc: getopt: Fix potential out of bounds access

Chen-Yu Tsai <wenst@chromium.org>
    regulator: dt-bindings: mt6359: Drop regulator-name pattern restrictions

Randy Dunlap <rdunlap@infradead.org>
    bitops: use common function parameter names

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    sysfs: clamp show() return value in sysfs_kf_read()

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: synopsys: Fix IPI using hardcoded datatype

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Read sensor config as 32-bit value

Andre Przywara <andre.przywara@arm.com>
    firmware: smccc: Fix Arm SMCCC SOC_ID name call

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: fix uboot partition offset on Milk-V Jupiter

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: set console baud rate on Milk-V Jupiter

Jose A. Perez de Azpillaga <azpijr@gmail.com>
    staging: media: atomisp: fix loop shadowing in ia_css_stream_destroy()

Yuho Choi <dbgh9129@gmail.com>
    media: atomisp: gc2235: fix UAF and memory leak

Zilin Guan <zilin@seu.edu.cn>
    media: atomisp: Fix memory leak in atomisp_fixed_pattern_table()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix incorrect inode ID assignment in hfs_new_inode()

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx95-19x19-evk: Fix PCIe EP vpcie-supply

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8qxp-mek: Remove unnecessary PCIe EP vpcie-supply

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8dxl-evk: Remove unnecessary PCIe EP properties

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx95-verdin-ivy: fix RS485 RTS polarity

Jamie Nguyen <jamien@nvidia.com>
    firmware: arm_ffa: Honor partition info descriptor size

Kevin Brodsky <kevin.brodsky@arm.com>
    selftests/mm: Fix resv_sz when parsing arm64 signal frame

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Update util_est after updating util_avg during dequeue

Bibek Kumar Patro <bibek.patro@oss.qualcomm.com>
    iommu/arm-smmu-qcom: Fix fastrpc compatible string in ACTLR client match table

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Fix test for refinement of single-value tnum

Roman Kvasnytskyi <roman@kvasnytskyi.net>
    selftests/bpf: Reject unsupported -k option in vmtest.sh

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Override EXTRA_LDFLAGS for static builds

Fengnan Chang <changfengnan@bytedance.com>
    dm: limit target bio polling to one shot

Liviu Dudau <liviu.dudau@arm.com>
    drm/syncobj: Fix memory leak in drm_syncobj_find_fence()

Crystal Wood <crwood@redhat.com>
    rtla: Stop the record trace on interrupt

Costa Shulyupin <costa.shul@redhat.com>
    tools/rtla: Fix --dump-tasks usage in timerlat

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Initialize seqfile before creating file

Sara Venkatesh <sarajvenkatesh@gmail.com>
    RDMA/srpt: fix integer overflow in immediate data length check

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Fix devx subscribe-event unwind NULL dereference

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Fix UMR XLT cleanup on ODP populate failure

Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
    RDMA/hns: Fix arithmetic overflow in calc_hem_config()

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier

Linmao Li <lilinmao@kylinos.cn>
    ipv6: addrconf: bail out of dad_failure when state is no longer POSTDAD

Eric Dumazet <edumazet@google.com>
    net/sched: sch_htb: annotate data-races (I)

Eric Dumazet <edumazet@google.com>
    net/sched: sch_htb: do not change sch->flags in htb_dump()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_dualpi2: annotate data-races in dualpi2_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: add qdisc_qlen_inc() and qdisc_qlen_dec()

Qiang Ma <maqianga@uniontech.com>
    spi: hisi-kunpeng: Use dev_err_probe() for host registration failure

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    crypto: safexcel - Fix potential memory leak in safexcel_pci_probe()

Stepan Ionichev <sozdayvek@gmail.com>
    crypto: ccp/sev-dev-tsm - bail out early when pdev->bus is NULL

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Cap AEAD AD length to 0x80000000

Sean Christopherson <seanjc@google.com>
    crypto: ccp - Treat zero-length cert chain as query for blob lengths

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add slave_destroy interface for v3 hw

Eric Dumazet <edumazet@google.com>
    net/sched: sch_hfsc: annotate data-races in hfsc_dump_class_stats()

Stepan Ionichev <sozdayvek@gmail.com>
    clk: scpi: Unregister child clock providers on remove

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Register a hwmon device for each thermal zone

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Fix critical temperature attribute removal

Pengpeng Hou <pengpeng@iscas.ac.cn>
    evm: terminate and bound the evm_xattrs read buffer

Lin He <helin52@huawei.com>
    drm/hisilicon/hibmc: use clock to look up the PLL value

Lin He <helin52@huawei.com>
    drm/hisilicon/hibmc: move display contrl config to hibmc_probe()

Lin He <helin52@huawei.com>
    drm/hisilicon/hibmc: fix no showing when no connectors connected

Lin He <helin52@huawei.com>
    drm/hisilicon/hibmc: add updating link cap in DP detect()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/chrome: wilco_ec: event: Check ACPI_COMPANION()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/chrome: chromeos_tbmc: Check ACPI_COMPANION()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/chrome: chromeos_privacy_screen: Check ACPI_COMPANION()

Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix ICE reg size

Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
    arm64: dts: qcom: kodiak: Fix ICE reg size

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Fix DSI1 phy reference clock rate

Cristian Marussi <cristian.marussi@arm.com>
    clk: scmi: Fix clock rate rounding

Hsiu Che Yu <yu.whisper.personal@gmail.com>
    rust: alloc: fix `Vec::extend_with` SAFETY comment

Christian Brauner <brauner@kernel.org>
    rhashtable: give each instance its own lockdep class

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Mark USB SS1 and SS2 as role-switch capable

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: Drop forced host mode for USB SS0 and SS1

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: fix error return code in mes_v12_1_map_test_bo

Breno Leitao <leitao@debian.org>
    workqueue: forbid TEST_WORKQUEUE from being built-in

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to host

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: mediatek: mt7988a-bpi-r4pro: rework pcie gpio-hog handling

Stefan Metzmacher <metze@samba.org>
    sockptr: fix usize check in copy_struct_from_sockptr() for user pointers

Stefan Metzmacher <metze@samba.org>
    uaccess: fix ignored_trailing logic in copy_struct_to_user()

Matt Bobrowski <mattbobrowski@google.com>
    bpf: fix crash in bpf_[set|remove]_dentry_xattr for negative dentries

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    soc: mediatek: mtk-mmsys: Restore MT8167 routing masks lost during merge

Sean Christopherson <seanjc@google.com>
    iommu/amd: Fix a stale comment about which legacy mode is user visible

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: venus: scale MMCX power domain on SM8250

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: scale MMCX power domain on SM8250

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Move PCIe devices into soc node

Nickolay Goppen <setotau@mainlining.org>
    arm64: dts: qcom: sdm630: set adsp compute-cbs' regs properly

Nickolay Goppen <setotau@mainlining.org>
    arm64: dts: qcom: sdm660: set cdsp compute-cbs' regs properly

Yixun Lan <dlan@kernel.org>
    dts: riscv: spacemit: correct 32k clock frequency

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: qcom: camss: vfe: fix PIX subdev naming on VFE lite

Leon Romanovsky <leon@kernel.org>
    ntb: Use consistent DMA attributes when freeing DMA mappings

Leon Romanovsky <leon@kernel.org>
    ntb: Store original DMA address for future release

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    nilfs2: fix backing_dev_info reference leak

Alexander Aring <aahringo@redhat.com>
    dlm: fix add msg handle in send_queue ordered

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix clflush buffer size

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    ARM: multi_v7_defconfig: Correct QCOM_RPMH and QCOM_RPMHPD

Weiming Shi <bestswngs@gmail.com>
    crypto: asymmetric_keys - fix OOB read in pefile_digest_pe_contents

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve

Lothar Rubusch <l.rubusch@gmail.com>
    crypto: atmel-sha204a - fix blocking and non-blocking rng logic

Tycho Andersen (AMD) <tycho@kernel.org>
    crypto: ccp - Initialize data during __sev_snp_init_locked()

Tycho Andersen (AMD) <tycho@kernel.org>
    crypto: ccp - Check for page allocation failure correctly in TIO

Tycho Andersen (AMD) <tycho@kernel.org>
    crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one

Tycho Andersen (AMD) <tycho@kernel.org>
    crypto: ccp - Reverse the cleanup order in psp_dev_destroy()

Di Shen <di.shen@unisoc.com>
    OPP: Fix race between OPP addition and lookup

Zhan Xusheng <zhanxusheng1024@gmail.com>
    alarmtimer: Remove stale return description from alarm_handle_timer()

Chris Brandt <chris.brandt@renesas.com>
    drm: renesas: rz-du: mipi_dsi: Fix return path on error

Kuniyuki Iwashima <kuniyu@google.com>
    vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().

Peng Fan <peng.fan@nxp.com>
    Revert "arm64: dts: imx8mp-kontron: Add support for reading SD_VSEL signal"

Peng Fan <peng.fan@nxp.com>
    Revert "arm64: dts: imx8mm-kontron: Add support for reading SD_VSEL signal"

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: imx8mp-ab2: Correct interrupt flags

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: imx8mn-vhip4-evalboard-v2: Correct interrupt flags

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: imx8mn-vhip4-evalboard-v1: Correct interrupt flags

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8x-colibri: Correct SODIMM PAD settings

Weixin Guo <2298701336@qq.com>
    arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Add #{address,size}-cells to Chromium-based /firmware

Brian Norris <briannorris@chromium.org>
    ARM: dts: rockchip: Add #{address,size}-cells to Chromium-based /firmware

Duje Mihanović <duje@dujemihanovic.xyz>
    arm64: dts: marvell: samsung-coreprimevelte: Increase touchscreen voltage

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: fix pic64gx gpio interrupt-cells

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: update pic64gx gpio interrupts to better match the SoC

David Heidelberg <david@ixit.cz>
    drm/panel: Clean up S6E3HA2 config dependencies and fill help text

David Heidelberg <david@ixit.cz>
    drm/panel: Clean up S6E3FC2X01 config dependencies

Marijn Suijten <marijn.suijten@somainline.org>
    drm/panel: Clean up SOFEF00 config dependencies

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: restrict LMR feedback check to TB and non-TB ranging

Alice Ryhl <aliceryhl@google.com>
    drm/gpuvm: take refcount on DRM device

Marek Vasut <marex@nabladev.com>
    dt-bindings: vendor-prefixes: Add Displaytech Ltd.

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: remove gpio hogs from beaglev-fire

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: gpio controllers on mpfs need 2 interrupt cells

Felix Gu <ustc.gu@gmail.com>
    pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path

Conor Dooley <conor.dooley@microchip.com>
    dts: spacemit: set console baud rate on bpif3

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    lib/vsprintf: Fix to check field_width and precision

Damian Muszynski <damian.muszynski@intel.com>
    crypto: qat - fix heartbeat error injection

Josh Poimboeuf <jpoimboe@kernel.org>
    klp-build: Fix patch cleanup on interrupt

Josh Poimboeuf <jpoimboe@kernel.org>
    klp-build: Fix checksum comparison for changed offsets

Josh Poimboeuf <jpoimboe@kernel.org>
    klp-build: Fix hang on out-of-date .config

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix reloc hash collision in find_reloc_by_dest_range()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Replace iterator callback with for_each_sym_by_mangled_name()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix relocation conversion failures for R_X86_64_NONE

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix extraction of text annotations for alternatives

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix cloning of zero-length section symbols

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix handling of zero-length .altinstr_replacement sections

Joe Lawrence <joe.lawrence@redhat.com>
    objtool/klp: Fix create_fake_symbols() skipping entsize-based sections

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix .data..once static local non-correlation

Joe Lawrence <joe.lawrence@redhat.com>
    objtool/klp: Fix is_uncorrelated_static_local() for Clang

Ashish Mhetre <amhetre@nvidia.com>
    memory: tegra: Wire up system sleep PM ops

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm: verisilicon: call atomic helper's plane state check even if no CRTC

Nas Chung <nas.chung@chipsnmedia.com>
    media: v4l2-common: Add YUV24 format info

Samuel Holland <samuel@sholland.org>
    media: cedrus: Fix failure to clean up hardware on probe failure

Felix Gu <ustc.gu@gmail.com>
    watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register failure

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    watchdog: sama5d4_wdt: Fix WDDIS detection on SAM9X60 and SAMA7G5

Yingjie Gao <gaoyingjie@uniontech.com>
    watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH

Gabriele Monaco <gmonaco@redhat.com>
    Documentation/rv: Replace stale website link

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    ixgbe: fix unaligned u32 access in ixgbe_update_flash_X550()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath11k: cancel SSR work items during PCI shutdown

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath9k: fix OOB access from firmware tx status queue ID

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: eint: Drop base from mtk_eint_chip_write_mask()

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    soc: xilinx: Shutdown and free rx mailbox channel

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    soc: xilinx: Fix race condition in event registration

Xingjing Deng <micro6947@gmail.com>
    kconfig: fix potential NULL pointer dereference in conf_askvalue

Tristan Madani <tristan@talencesecurity.com>
    wifi: rtw89: add bounds check on firmware mac_id in link lookup

Tristan Madani <tristan@talencesecurity.com>
    wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA buffer

Shin-Yi Lin <isaiah@realtek.com>
    wifi: rtw89: Correct data type for scan index to avoid infinite loop

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw88: fix wrong pci_get_drvdata type in AER handlers

Christos Longros <chris.longros@gmail.com>
    wifi: rtw89: fix wrong pci_get_drvdata type in AER handlers

Timur Tabi <ttabi@nvidia.com>
    gpu: nova-core: use correct fwsignature for GA100

Danilo Krummrich <dakr@kernel.org>
    driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdkfd: Validate CRIU-restored IDs before idr_alloc

Felix Gu <ustc.gu@gmail.com>
    pinctrl: pinconf-generic: fix properties bitmap leak in parse_fw_cfg()

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    dt-bindings: pinctrl: nvidia,tegra234: Add missing required block

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix Tegra234 MGBE PTP clock

Louis Kotze <loukot@gmail.com>
    wifi: cfg80211: fix grammar in MLO group key error message

Edward Adam Davis <eadavis@qq.com>
    hfsplus: Add a sanity check for btree node size

Edward Adam Davis <eadavis@qq.com>
    hfsplus: Remove the duplicate attr inode dirty marking action

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-shift-axolotl: Correct touchscreen sleep state

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    arm64: dts: qcom: fix temp-alarm probe failure for PMH0104 on Glymur

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_reg warning

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Fix phy simple_bus_reg warning

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: ipq5424: Fix USB simple_bus_reg warnings

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix cache and SRAM simple_bus_reg warnings

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix USB simple_bus_reg warning

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-oneplus: Drop address from framebuffer node

Alexander Koskovich <akoskovich@pm.me>
    arm64: dts: qcom: milos: Reduce rmtfs_mem size to 2.5MiB

Sean Christopherson <seanjc@google.com>
    x86/bug: Add printf() validation to HAVE_ARCH_BUG_FORMAT_ARGS WARNs

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: net: bluetooth: qualcomm: Fix WCN6855 regulator names

Kamlesh Kumar <kamlesh0hrs@gmail.com>
    ima: Fix sigv3 signature handling for EVM_IMA_XATTR_DIGSIG

Diederik de Haas <diederik@cknow-tech.com>
    arm64: dts: rockchip: Fix gmac0 reset pin for NanoPi R5S

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix Ethernet PHY not found on PX30 Cobra

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Update vdec register blocks order on RK3588

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Fix vdec register blocks order on RK3576

Baolin Liu <liubaolin@kylinos.cn>
    Documentation: proc: fix section numbering in table of contents

Gregory Bell <grbell@redhat.com>
    selftests/bpf: Use local type for bpf_fou_encap in test_tunnel_kern

Gregory Bell <grbell@redhat.com>
    selftests/bpf: Use local type for flow_offload_tuple_rhash in xdp_flowtable

Felix Gu <ustc.gu@gmail.com>
    spi: atcspi200: fix use-after-free when driver unbind

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: remove trailing semicolon from AMDGPU_PM_POLICY_ATTR macro

Antoine Tenart <atenart@kernel.org>
    libbpf: Fix deduplication of typedef with base definitions

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Fix invalid IRQ requests during AHB probe

Nick Hu <nick.hu@sifive.com>
    dt-bindings: timer: Remove sifive,fine-ctr-bits property

Matt Bobrowski <mattbobrowski@google.com>
    selftests/bpf: Fix off-by-one in bpf_cpumask_populate related selftest

Aaron Tomlin <atomlin@atomlin.com>
    libbpf: Report error when a negative kprobe offset is specified

Yuho Choi <dbgh9129@gmail.com>
    drm/radeon: fix memory leak in radeon_ring_restore() on lock failure

Werner Kasselman <werner@verivus.ai>
    drm/radeon: fix integer overflow in radeon_align_pitch()

Alex Sierra <alex.sierra@amd.com>
    drm/amdkfd: fix redundant MQD iterations in GFX v12.1

Werner Kasselman <werner@verivus.ai>
    drm/amdgpu: fix integer overflow in amdgpu_gem_align_pitch()

Max Zhen <max.zhen@amd.com>
    accel/amdxdna: Guard management mailbox channel cleanup against NULL pointer

Jonathan Cavitt <jonathan.cavitt@intel.com>
    drm/gpuvm: Do not prepare NULL objects

Felix Gu <ustc.gu@gmail.com>
    accel/amdxdna: Fix memory leak in amdxdna_iommu_alloc()

Max Zhen <max.zhen@amd.com>
    accel/amdxdna: Fix fatal_error_info layout in firmware interface

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Fix potential tracepoint null pointer dereferences

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix order of canceled mailbox messages

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix iommu_map_sgtable() return value handling

Max Zhen <max.zhen@amd.com>
    accel/amdxdna: Handle DETACH_DEBUG_BO through config_debug_bo path

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Adjust size for copy_to_user()

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Create shared functions for AIE2 and AIE4

Matthew Brost <matthew.brost@intel.com>
    drm/gpusvm: Reject VMAs with VM_IO or VM_PFNMAP when creating SVM ranges

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Drop extra drm_mode_config_reset() call

Thomas Zimmermann <tzimmermann@suse.de>
    drm/rockchip: Test for imported buffers with drm_gem_is_imported()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_dp: Fix null-ptr-deref in dw_dp_remove()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_dp: Switch to drmm_kzalloc()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: inno-hdmi: Switch to drmm_kzalloc()

Max Zhen <max.zhen@amd.com>
    accel/amdxdna: Fix leak when pinning ubuf pages

Chen Ni <nichen@iscas.ac.cn>
    clocksource/drivers/sun5i: Handle error returns from devm_reset_control_get_optional_exclusive()

Stafford Horne <shorne@gmail.com>
    openrisc: mm: Fix section mismatch between map_page and __set_fixmap

Felix Gu <ustc.gu@gmail.com>
    soc: fsl: qe_ports_ic: Add missing cleanup on device removal

Jiacheng Yu <yujiacheng3@huawei.com>
    fbcon: Use correct type for vc_resize() return value

Ian Bridges <icb@fastmail.org>
    fbcon: fix NULL pointer dereference for a console without vc_data

David Howells <dhowells@redhat.com>
    afs: Fix uncancelled rxrpc OOB message handler

David Howells <dhowells@redhat.com>
    afs: Fix further netns teardown to cancel the preallocation charger

Nan Li <tonanli66@gmail.com>
    afs: handle CB.InitCallBackState3 requests without a server record

Matvey Kovalev <matvey.kovalev@ispras.ru>
    afs: fix NULL pointer dereference in afs_get_tree()

David Howells <dhowells@redhat.com>
    afs: Fix netns teardown to cancel the preallocation charger

David Howells <dhowells@redhat.com>
    rxrpc: Fix double unlock in rxrpc_recvmsg()

David Howells <dhowells@redhat.com>
    rxrpc: Fix leak of connection from OOB challenge

David Howells <dhowells@redhat.com>
    rxrpc: Fix the reception of a reply packet before data transmission

Wyatt Feng <bronzed_45_vested@icloud.com>
    rxrpc: Fix ACKALL packet handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix oob challenge leak in cleanup after notification failure

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxrpc_rotate_tx_rotate() to check there's something to rotate

David Howells <dhowells@redhat.com>
    rxrpc: Fix potential infinite loop in rxrpc_recvmsg()

David Howells <dhowells@redhat.com>
    rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)

David Howells <dhowells@redhat.com>
    rxrpc: Fix socket notification race

David Howells <dhowells@redhat.com>
    rxrpc: Fix UAF in rxgk_issue_challenge()

Hyunwoo Kim <imv4bel@gmail.com>
    rxrpc: Don't move a peeked OOB message onto the pending queue

Jeffrey Altman <jaltman@auristor.com>
    rxrpc: rxrpc_verify_data ensure rx_dec_buffer alloc

Li Daming <d4n.for.sec@gmail.com>
    rxrpc: serialize kernel accept preallocation with socket teardown

Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>
    serial: 8250_omap: clear rx_running on zero-length DMA completes

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: implement gpio_chip::get_direction()

Stephan Gerhold <stephan.gerhold@linaro.org>
    serial: msm: Disable DMA for kernel console UART

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    dt-bindings: power: imx93: Add MIPI PHY power domain

Chen-Yu Tsai <wens@kernel.org>
    dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix sequence number when no EOF

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Relax the constrains for interpolating the hw clock

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not add clock samples with small sof delta

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix dev_sof filtering in hw timestamp

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix buffer sequence in frame gaps

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Avoid partial metadata buffers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use hw timestaming if the clock buffer is full

Damien Laine <damien.laine@gmail.com>
    ALSA: hda/realtek: Fix speakers on Legion Pro 7 16ARX8H with codec SSID 17aa:38a7

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix cached processing coefficient verbs

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda: conexant: Remove mic bias threshold override

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang X6xx45xU

Sean Anderson <sean.anderson@linux.dev>
    media: uvcvideo: Fix deadlock if uvc_status_stop is called from async_ctrl.work

Eric Biggers <ebiggers@kernel.org>
    crypto: sun4i-ss - Remove insecure and unused rng_alg

Michael Bommarito <michael.bommarito@gmail.com>
    iommu/vt-d: Clear Present bit before tearing down scalable-mode context entry

Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
    crypto: algif_skcipher - force synchronous processing


-------------

Diffstat:

 .../testing/sysfs-class-reboot-mode-reboot_modes   |  13 +-
 Documentation/admin-guide/pm/cpufreq.rst           |   6 +-
 Documentation/arch/arm64/cpu-hotplug.rst           |  28 +-
 .../bindings/clock/qcom,dispcc-sm6125.yaml         |  17 +-
 .../bindings/clock/qcom,x1e80100-camcc.yaml        |   1 +
 .../bindings/dma/nvidia,tegra186-gpc-dma.yaml      |  23 +-
 .../devicetree/bindings/dma/snps,dw-axi-dmac.yaml  |   5 +-
 .../media/allwinner,sun4i-a10-video-engine.yaml    |  10 +
 .../bindings/net/bluetooth/qcom,wcn6855-bt.yaml    |   7 +-
 .../devicetree/bindings/net/microchip,lan8650.yaml |   2 +-
 .../devicetree/bindings/net/renesas,ether.yaml     |   3 +-
 .../bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml   |  13 +-
 .../pinctrl/nvidia,tegra234-pinmux-aon.yaml        |   4 +
 .../bindings/pinctrl/nvidia,tegra234-pinmux.yaml   |   4 +
 .../bindings/pinctrl/realtek,rtd1625-pinctrl.yaml  |   2 +-
 .../bindings/regulator/mt6359-regulator.yaml       |  43 --
 .../devicetree/bindings/timer/sifive,clint.yaml    |  16 -
 .../devicetree/bindings/vendor-prefixes.yaml       |   4 +
 Documentation/driver-api/nvdimm/btt.rst            |   5 +-
 Documentation/driver-api/uio-howto.rst             |   4 +-
 Documentation/filesystems/proc.rst                 |  14 +-
 Documentation/mm/memfd_preservation.rst            |   2 +-
 Documentation/netlink/specs/handshake.yaml         |   1 +
 Documentation/netlink/specs/rt-link.yaml           |   6 +
 Documentation/networking/bonding.rst               |  23 +
 Documentation/process/changes.rst                  |   7 +-
 Documentation/process/threat-model.rst             |   2 +-
 Documentation/trace/eprobetrace.rst                |   4 +
 Documentation/trace/rv/monitor_sched.rst           |   7 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/pci-sysfs.c                      |  13 +-
 arch/arc/include/asm/uaccess.h                     |   3 +-
 arch/arm/boot/compressed/Makefile                  |   2 +-
 arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts     |   2 +-
 arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts  |   2 +-
 arch/arm/boot/dts/nvidia/tegra124-nyan.dtsi        |   5 +
 arch/arm/boot/dts/nvidia/tegra124-venice2.dts      |   5 +
 arch/arm/boot/dts/nxp/imx/imx6ul-var-som.dtsi      |   4 -
 arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi      |   5 +
 arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts      | 128 ++++
 arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts      | 144 +++++
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi     | 146 +----
 arch/arm/boot/dts/ti/omap/am335x-sl50.dts          |   4 +-
 arch/arm/configs/axm55xx_defconfig                 |   1 -
 arch/arm/configs/dove_defconfig                    |   1 -
 arch/arm/configs/ep93xx_defconfig                  |   1 -
 arch/arm/configs/mmp2_defconfig                    |   1 -
 arch/arm/configs/multi_v7_defconfig                |   4 +-
 arch/arm/configs/mv78xx0_defconfig                 |   1 -
 arch/arm/configs/sunxi_defconfig                   |   1 -
 arch/arm/include/asm/uaccess.h                     |   3 +-
 arch/arm/mach-imx/Kconfig                          |  21 -
 arch/arm/mach-imx/cpu-imx31.c                      |   9 +-
 arch/arm/mach-imx/mm-imx3.c                        |   2 +
 arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi     |   3 +-
 .../fsl-ls1028a-tqmls1028a-mbls1028a.dtsi          |   4 +-
 .../boot/dts/freescale/fsl-lx2162a-clearfog.dts    |   2 +-
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts      |   2 -
 .../arm64/boot/dts/freescale/imx8mm-kontron-bl.dts |  10 +-
 .../boot/dts/freescale/imx8mm-kontron-osm-s.dtsi   |   7 +-
 .../dts/freescale/imx8mn-vhip4-evalboard-v1.dts    |   2 +-
 .../dts/freescale/imx8mn-vhip4-evalboard-v2.dts    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-ab2.dts       |   2 +-
 .../boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts |  14 +-
 .../boot/dts/freescale/imx8mp-kontron-osm-s.dtsi   |   7 +-
 .../dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts    |   3 +
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |   1 -
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts      |   4 +-
 arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi   |   4 +-
 arch/arm64/boot/dts/freescale/imx94.dtsi           |   2 +-
 arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts  |   2 +-
 .../arm64/boot/dts/freescale/imx95-verdin-ivy.dtsi |   1 -
 arch/arm64/boot/dts/freescale/imx95.dtsi           |  10 +-
 arch/arm64/boot/dts/freescale/s32g3.dtsi           |   2 +-
 .../marvell/mmp/pxa1908-samsung-coreprimevelte.dts |   2 +-
 arch/arm64/boot/dts/mediatek/Makefile              |   8 +
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso |  20 +
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso |  20 +
 .../dts/mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi  |   2 -
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   2 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   5 +
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts      |   5 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   8 +-
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |  88 +--
 arch/arm64/boot/dts/qcom/eliza-mtp.dts             |   4 +-
 arch/arm64/boot/dts/qcom/eliza.dtsi                |   6 +-
 arch/arm64/boot/dts/qcom/glymur-crd.dts            |   4 -
 arch/arm64/boot/dts/qcom/glymur.dtsi               |  12 +-
 arch/arm64/boot/dts/qcom/hamoa.dtsi                |  77 +--
 arch/arm64/boot/dts/qcom/ipq5424.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |   6 +-
 arch/arm64/boot/dts/qcom/kodiak.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               | 710 +++++++++++----------
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts   |   5 +
 arch/arm64/boot/dts/qcom/milos.dtsi                |   2 +-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi       |   2 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |  37 +-
 arch/arm64/boot/dts/qcom/sdm660.dtsi               |  36 +-
 .../qcom/sdm845-db845c-navigation-mezzanine.dtso   |   5 +
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts  |   2 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |   8 +-
 arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts  |  76 ++-
 arch/arm64/boot/dts/renesas/r8a78000.dtsi          |  36 +-
 arch/arm64/boot/dts/rockchip/px30-cobra.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   5 +
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts |   6 +-
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   6 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |  12 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   8 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 +
 arch/arm64/include/asm/kvm_nested.h                |   8 +
 arch/arm64/include/asm/tlbbatch.h                  |  10 +-
 arch/arm64/include/asm/tlbflush.h                  |  49 +-
 arch/arm64/include/asm/uaccess.h                   |   3 +-
 arch/arm64/kernel/acpi.c                           |   2 +
 arch/arm64/kernel/entry-fpsimd.S                   |   8 +-
 arch/arm64/kernel/fpsimd.c                         |  10 +-
 arch/arm64/kernel/hw_breakpoint.c                  |   9 +
 arch/arm64/kernel/process.c                        |  35 -
 arch/arm64/kernel/smp.c                            |  28 +-
 arch/arm64/kernel/static_call.c                    |   1 +
 arch/arm64/kvm/at.c                                |   8 -
 arch/arm64/kvm/emulate-nested.c                    |   1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  11 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   3 +-
 arch/arm64/kvm/nested.c                            | 166 ++---
 arch/arm64/kvm/pkvm.c                              |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   2 +
 arch/arm64/kvm/vgic/vgic.c                         |  20 +-
 arch/arm64/mm/mmu.c                                |  11 +-
 arch/arm64/tools/sysreg                            |   2 +-
 arch/hexagon/include/asm/uaccess.h                 |   3 +-
 arch/loongarch/include/asm/kexec.h                 |   3 +-
 arch/loongarch/include/asm/pgtable.h               |   4 +
 arch/loongarch/include/asm/uaccess.h               |   3 +-
 arch/loongarch/kvm/exit.c                          |   1 -
 arch/loongarch/kvm/irqfd.c                         |   3 +-
 arch/loongarch/kvm/vcpu.c                          |  11 +-
 arch/loongarch/mm/pageattr.c                       |   2 +-
 arch/loongarch/net/bpf_jit.c                       |  28 +-
 arch/m68k/coldfire/m5441x.c                        |  18 +-
 arch/m68k/include/asm/uaccess.h                    |   3 +-
 arch/microblaze/include/asm/uaccess.h              |   3 +-
 arch/mips/dec/int-handler.S                        |   2 +-
 arch/mips/dec/platform.c                           |   6 +-
 arch/mips/dec/prom/init.c                          |   6 +-
 arch/mips/dec/setup.c                              |   6 -
 arch/mips/fw/lib/call_o32.S                        |   2 +-
 arch/mips/include/asm/dec/prom.h                   |  15 +-
 arch/mips/include/asm/uaccess.h                    |   3 +-
 arch/mips/kernel/mips-mt-fpaff.c                   |  28 +-
 arch/mips/mm/init.c                                |  17 +-
 arch/mips/n64/init.c                               |   2 +-
 arch/mips/ralink/mt7621.c                          |   2 +-
 arch/mips/sgi-ip22/ip22-gio.c                      |   7 +-
 arch/nios2/include/asm/uaccess.h                   |   3 +-
 arch/openrisc/include/asm/cacheflush.h             |   4 +
 arch/openrisc/include/asm/uaccess.h                |   3 +-
 arch/openrisc/kernel/jump_label.c                  |   2 +-
 arch/openrisc/kernel/patching.c                    |   3 +
 arch/openrisc/kernel/smp.c                         |  21 +
 arch/openrisc/mm/cache.c                           |  16 +
 arch/openrisc/mm/init.c                            |   2 +-
 arch/parisc/include/asm/uaccess.h                  |   3 +-
 arch/powerpc/include/asm/uaccess.h                 |   2 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   9 +
 arch/powerpc/kexec/core_64.c                       |   4 +-
 arch/powerpc/perf/core-fsl-emb.c                   |   3 +-
 arch/powerpc/platforms/8xx/cpm1.c                  |  26 +
 arch/powerpc/platforms/cell/spufs/file.c           |   6 +-
 arch/powerpc/platforms/powernv/setup.c             |   3 +-
 arch/powerpc/platforms/pseries/Kconfig             |   1 +
 .../platforms/pseries/papr_platform_attributes.c   |   8 +-
 .../riscv/boot/dts/microchip/mpfs-beaglev-fire.dts |  25 +-
 arch/riscv/boot/dts/microchip/mpfs.dtsi            |   6 +-
 .../boot/dts/microchip/pic64gx-curiosity-kit.dts   |  47 +-
 arch/riscv/boot/dts/microchip/pic64gx.dtsi         |  38 +-
 arch/riscv/boot/dts/sophgo/sg2042-cpus.dtsi        | 236 +++----
 arch/riscv/boot/dts/sophgo/sg2044-cpus.dtsi        | 236 +++----
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts    |   2 +-
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts  |   4 +-
 arch/riscv/boot/dts/spacemit/k1.dtsi               |   2 +-
 arch/riscv/boot/dts/spacemit/k3.dtsi               |   3 +-
 arch/riscv/include/asm/cpu_ops.h                   |   2 +-
 arch/riscv/include/asm/vdso.h                      |  10 +-
 arch/riscv/kernel/alternative.c                    |  14 +-
 arch/riscv/kernel/asm-offsets.c                    |   4 +-
 arch/riscv/kernel/cacheinfo.c                      |   2 +-
 arch/riscv/kernel/cpu-hotplug.c                    |   4 +-
 arch/riscv/kernel/cpu_ops_sbi.c                    |  11 +-
 arch/riscv/kernel/entry.S                          |   8 +-
 arch/riscv/kernel/machine_kexec.c                  |   3 +
 arch/riscv/kernel/probes/rethook_trampoline.S      |   3 +
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/riscv/kernel/vdso/Makefile                    |   6 +-
 arch/riscv/kernel/vdso/rt_sigreturn.S              |  10 +-
 arch/s390/include/asm/pgtable.h                    |   4 +-
 arch/s390/include/asm/uaccess.h                    |   3 +-
 arch/s390/kernel/diag/diag310.c                    |   7 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   3 +
 arch/s390/kernel/process.c                         |   2 +-
 arch/s390/kvm/dat.c                                |   2 +-
 arch/s390/kvm/gaccess.c                            |  73 ++-
 arch/s390/kvm/gmap.c                               |   7 +-
 arch/s390/kvm/gmap.h                               |  14 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/pci.c                                |  12 +-
 arch/s390/mm/gmap_helpers.c                        |   9 +-
 arch/s390/mm/mmap.c                                |   2 +-
 arch/sh/include/asm/uaccess.h                      |   3 +-
 arch/sparc/include/asm/page_32.h                   |   2 +
 arch/sparc/include/asm/uaccess_32.h                |   3 +-
 arch/sparc/include/asm/uaccess_64.h                |   3 +-
 arch/sparc/kernel/led.c                            |   2 +-
 arch/um/include/asm/uaccess.h                      |   3 +-
 arch/x86/Kconfig.cpu                               |   8 +-
 arch/x86/boot/compressed/acpi.c                    |   7 +-
 arch/x86/boot/early_serial_console.c               |  11 +-
 arch/x86/events/amd/brs.c                          |  10 +-
 arch/x86/events/amd/core.c                         |  18 +-
 arch/x86/events/amd/lbr.c                          |   3 +-
 arch/x86/events/amd/uncore.c                       |   6 +-
 arch/x86/events/intel/uncore_discovery.c           |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/include/asm/bug.h                         |   2 +
 arch/x86/kernel/cpu/cpu.h                          |   1 -
 arch/x86/kernel/uprobes.c                          |  26 +-
 arch/x86/kvm/irq.c                                 |   4 +-
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/kvm/svm/sev.c                             |   6 +-
 arch/x86/kvm/vmx/nested.c                          |  68 +-
 arch/x86/kvm/vmx/tdx.c                             |   6 +-
 arch/x86/platform/olpc/olpc-xo15-sci.c             |   1 +
 arch/x86/video/video-common.c                      |  23 +-
 arch/x86/virt/svm/sev.c                            |   2 +
 arch/xtensa/include/asm/uaccess.h                  |   3 +-
 block/blk.h                                        |  13 +-
 block/genhd.c                                      |   4 -
 block/ioctl.c                                      |   2 +-
 crypto/Kconfig                                     |   4 +-
 crypto/af_alg.c                                    |   2 +
 crypto/algif_skcipher.c                            |  75 +--
 crypto/asymmetric_keys/verify_pefile.c             |   2 +
 crypto/ecrdsa.c                                    |   2 +-
 crypto/rng.c                                       |  11 +
 drivers/accel/amdxdna/Makefile                     |   1 +
 drivers/accel/amdxdna/aie.c                        |  89 +++
 drivers/accel/amdxdna/aie.h                        |  31 +
 drivers/accel/amdxdna/aie2_ctx.c                   |  26 +-
 drivers/accel/amdxdna/aie2_error.c                 |  17 +-
 drivers/accel/amdxdna/aie2_message.c               | 164 ++---
 drivers/accel/amdxdna/aie2_msg_priv.h              |   2 +-
 drivers/accel/amdxdna/aie2_pci.c                   | 166 ++---
 drivers/accel/amdxdna/aie2_pci.h                   |  26 +-
 drivers/accel/amdxdna/aie2_pm.c                    |   6 +-
 drivers/accel/amdxdna/aie2_smu.c                   |  22 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |  40 +-
 drivers/accel/amdxdna/amdxdna_gem.c                |  37 +-
 drivers/accel/amdxdna/amdxdna_gem.h                |   1 -
 drivers/accel/amdxdna/amdxdna_iommu.c              |  56 +-
 drivers/accel/amdxdna/amdxdna_mailbox.c            |  10 +-
 drivers/accel/amdxdna/amdxdna_pci_drv.h            |   8 +
 drivers/accel/amdxdna/amdxdna_ubuf.c               |  12 +-
 drivers/accel/amdxdna/npu1_regs.c                  |   4 +-
 drivers/accel/amdxdna/npu4_regs.c                  |   4 +-
 drivers/accel/amdxdna/npu5_regs.c                  |   2 +-
 drivers/accel/amdxdna/npu6_regs.c                  |   2 +-
 drivers/accel/ivpu/ivpu_fw_log.c                   |   4 +
 drivers/accel/ivpu/ivpu_job.c                      |  10 +-
 drivers/acpi/acpi_ipmi.c                           |   4 +-
 drivers/acpi/acpi_pad.c                            |   6 +-
 drivers/acpi/acpi_tad.c                            |   2 +-
 drivers/acpi/acpica/acutils.h                      |   2 -
 drivers/acpi/acpica/utnonansi.c                    |   7 -
 drivers/acpi/button.c                              |  26 +-
 drivers/acpi/processor_idle.c                      |  13 +-
 drivers/acpi/resource.c                            |   6 +-
 drivers/acpi/riscv/cpuidle.c                       |   2 +-
 drivers/acpi/riscv/rimt.c                          |   7 +-
 drivers/amba/bus.c                                 |  37 +-
 drivers/android/binder.c                           |  18 +-
 drivers/ata/libata-core.c                          |  44 +-
 drivers/ata/libata-scsi.c                          |   9 +-
 drivers/ata/libata.h                               |   9 +
 drivers/ata/pata_pxa.c                             |   1 +
 drivers/ata/sata_gemini.c                          |   2 +-
 drivers/base/core.c                                |  83 ++-
 drivers/base/dd.c                                  |   7 +-
 drivers/base/firmware_loader/main.c                |  71 ++-
 drivers/base/power/main.c                          |   6 +-
 drivers/base/property.c                            |   4 +-
 drivers/base/regmap/regcache.c                     |   2 +-
 drivers/base/regmap/regmap-i2c.c                   |   2 +-
 drivers/block/drbd/drbd_receiver.c                 |   5 +
 drivers/bluetooth/Kconfig                          |   2 +-
 drivers/bluetooth/bpa10x.c                         |   8 +-
 drivers/bluetooth/btintel.c                        |  10 +-
 drivers/bluetooth/btintel.h                        |   9 +
 drivers/bluetooth/btintel_pcie.c                   | 531 ++++++++++++---
 drivers/bluetooth/btintel_pcie.h                   |  26 +-
 drivers/bluetooth/btmtk.c                          |   4 +-
 drivers/bluetooth/btrtl.c                          |   5 +-
 drivers/bluetooth/hci_qca.c                        |  11 +-
 drivers/bluetooth/hci_vhci.c                       |  10 +
 drivers/bus/imx-weim.c                             |   6 -
 drivers/bus/mhi/ep/main.c                          |  11 +-
 drivers/bus/mhi/host/pci_generic.c                 |  20 +-
 drivers/bus/sunxi-rsb.c                            |   3 +
 drivers/cdx/cdx.c                                  |  40 +-
 drivers/char/hpet.c                                |   6 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  10 +-
 drivers/char/sonypi.c                              |   6 +-
 drivers/char/tlclk.c                               |   4 +
 drivers/char/tpm/eventlog/tpm1.c                   |   4 +-
 drivers/char/tpm/tpm-dev.c                         |   2 +-
 drivers/char/tpm/tpm2-cmd.c                        |   6 +-
 drivers/char/tpm/tpm2-sessions.c                   |  45 +-
 drivers/char/tpm/tpm_crb.c                         |   6 +-
 drivers/char/tpm/tpm_tis_core.c                    |  35 +-
 drivers/char/tpm/tpmrm-dev.c                       |   2 +-
 drivers/char/virtio_console.c                      |  52 +-
 drivers/clk/at91/pmc.c                             |   2 +-
 drivers/clk/at91/sam9x7.c                          |  18 +-
 drivers/clk/clk-scmi.c                             |   4 +-
 drivers/clk/clk-scpi.c                             |   2 +-
 drivers/clk/microchip/clk-mpfs-ccc.c               |  15 +-
 drivers/clk/qcom/a53-pll.c                         |   2 +-
 drivers/clk/qcom/camcc-x1e80100.c                  |  64 ++
 drivers/clk/qcom/ipq-cmn-pll.c                     |  11 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |   6 +-
 drivers/clk/samsung/Kconfig                        |   2 +-
 drivers/clk/spacemit/ccu-k3.c                      |  20 +-
 drivers/clocksource/Kconfig                        |  31 +
 drivers/clocksource/timer-sun5i.c                  |   3 +
 drivers/cpufreq/cpufreq_conservative.c             |  12 +-
 drivers/cpufreq/cpufreq_governor.c                 |  42 +-
 drivers/cpufreq/intel_pstate.c                     |   6 +-
 drivers/cpuidle/driver.c                           |   8 -
 drivers/crypto/Kconfig                             |   1 -
 drivers/crypto/allwinner/Kconfig                   |   8 -
 drivers/crypto/allwinner/sun4i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |  36 --
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c  |  69 --
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |  20 -
 drivers/crypto/atmel-sha204a.c                     |   8 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |   4 +-
 drivers/crypto/ccp/psp-dev.c                       |  12 +-
 drivers/crypto/ccp/sev-dev-tsm.c                   |  23 +-
 drivers/crypto/ccp/sev-dev.c                       |  26 +-
 drivers/crypto/hisilicon/qm.c                      |   4 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |   2 +
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |   2 +-
 drivers/crypto/inside-secure/safexcel.c            |   2 +-
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   1 -
 .../intel/qat/qat_common/adf_heartbeat_inject.c    |   6 +-
 .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |  25 -
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |   4 +-
 drivers/crypto/tegra/tegra-se-aes.c                |  33 +-
 drivers/crypto/xilinx/xilinx-trng.c                |  85 +--
 drivers/cxl/core/core.h                            |   2 +
 drivers/cxl/core/features.c                        |   2 +-
 drivers/cxl/core/memdev.c                          |   4 +-
 drivers/cxl/core/pci.c                             |  26 +-
 drivers/cxl/core/port.c                            |   7 +-
 drivers/cxl/core/ras.c                             |  27 +-
 drivers/cxl/core/region.c                          | 125 ++--
 drivers/cxl/core/trace.h                           |  24 +-
 drivers/cxl/cxl.h                                  |  22 +-
 drivers/dax/kmem.c                                 |   6 +
 drivers/dibs/dibs_loopback.c                       |   5 +
 drivers/dma-buf/dma-fence-unwrap.c                 |   3 +
 drivers/dma-buf/dma-fence.c                        |   9 +-
 drivers/dma/dma-axi-dmac.c                         |  68 +-
 drivers/dma/dmaengine.c                            |   3 +-
 drivers/dma/dw-edma/dw-edma-core.h                 |   2 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |   3 +
 drivers/dma/dw-edma/dw-edma-v0-core.c              |   6 +
 drivers/dma/imx-sdma.c                             |   4 +-
 drivers/dma/qcom/gpi.c                             |   1 +
 drivers/dma/sh/rz-dmac.c                           |  92 +--
 drivers/dma/tegra186-gpc-dma.c                     |   7 +
 drivers/dpll/dpll_core.c                           |  20 +-
 drivers/edac/igen6_edac.c                          | 405 +++++++++---
 drivers/edac/skx_common.c                          |   3 +
 drivers/firmware/arm_ffa/driver.c                  |  27 +-
 drivers/firmware/arm_scmi/power.c                  |   6 +-
 drivers/firmware/arm_scmi/sensors.c                |   2 +-
 drivers/firmware/samsung/exynos-acpm.c             |  23 +
 drivers/firmware/smccc/soc_id.c                    |   2 +-
 drivers/firmware/xilinx/zynqmp.c                   |  28 +
 drivers/fpga/dfl.c                                 |   2 +
 drivers/fpga/microchip-spi.c                       |   3 +
 drivers/gpib/cb7210/cb7210.c                       |   1 +
 drivers/gpib/common/gpib_os.c                      |   4 +-
 drivers/gpio/gpio-davinci.c                        |   4 +-
 drivers/gpio/gpio-dwapb.c                          |  83 ++-
 drivers/gpio/gpio-f7188x.c                         |   6 +-
 drivers/gpio/gpio-htc-egpio.c                      |   6 +-
 drivers/gpio/gpio-mlxbf3.c                         |   3 +-
 drivers/gpio/gpio-mt7621.c                         | 283 ++++++--
 drivers/gpio/gpio-mvebu.c                          |   6 +-
 drivers/gpio/gpio-palmas.c                         |  19 +
 drivers/gpio/gpio-shared-proxy.c                   | 136 ++--
 drivers/gpio/gpio-tegra.c                          |  18 +-
 drivers/gpio/gpio-timberdale.c                     |   2 +-
 drivers/gpio/gpiolib-acpi-core.c                   |  19 +-
 drivers/gpio/gpiolib-shared.c                      |   9 +-
 drivers/gpio/gpiolib-shared.h                      |  31 +-
 drivers/gpio/gpiolib.c                             |   2 +-
 drivers/gpu/buddy.c                                |  67 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c   |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/mes_v12_1.c             |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   3 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   5 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  13 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  81 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   2 +
 drivers/gpu/drm/amd/display/dc/dc.h                |  58 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h          |  24 -
 .../drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c   | 229 +++----
 .../drm/amd/display/dc/hubp/dcn401/dcn401_hubp.h   |  23 +-
 .../gpu/drm/amd/display/dc/hubp/dcn42/dcn42_hubp.c |  78 +--
 .../gpu/drm/amd/display/dc/hubp/dcn42/dcn42_hubp.h |  10 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  | 431 ++++++++-----
 .../drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c    | 495 +++++++++++++-
 .../drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.h    |   9 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h       |  35 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h        |  79 +--
 .../gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c | 177 +++--
 .../gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.h |  25 +-
 .../gpu/drm/amd/display/dc/mpc/dcn42/dcn42_mpc.c   | 392 +++++++++++-
 .../gpu/drm/amd/display/dc/mpc/dcn42/dcn42_mpc.h   |  49 +-
 .../amd/display/dc/resource/dcn42/dcn42_resource.c |   1 -
 .../amd/display/modules/info_packet/info_packet.c  |   2 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  26 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   4 +
 drivers/gpu/drm/drm_edid.c                         |   8 +
 drivers/gpu/drm/drm_fb_helper.c                    |  92 ++-
 drivers/gpu/drm/drm_gpusvm.c                       |   5 +
 drivers/gpu/drm/drm_gpuvm.c                        |   9 +-
 drivers/gpu/drm/drm_ioctl.c                        |  14 +-
 drivers/gpu/drm/drm_syncobj.c                      |  10 +-
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h       |   1 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h         |   1 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c       |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  78 ++-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c     |  35 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |  14 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h    |   1 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c   |  75 ++-
 drivers/gpu/drm/i915/display/intel_atomic.c        |   6 +
 drivers/gpu/drm/i915/display/intel_lt_phy.c        |   6 +-
 drivers/gpu/drm/imagination/pvr_drv.c              |   6 +-
 drivers/gpu/drm/imagination/pvr_fw_trace.c         |   2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   7 +-
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c              |  15 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   4 +-
 drivers/gpu/drm/msm/dp/dp_reg.h                    |   4 +-
 drivers/gpu/drm/msm/msm_mdss.c                     | 113 ++--
 .../gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c |   3 +-
 drivers/gpu/drm/panel/Kconfig                      |  13 +-
 drivers/gpu/drm/panthor/panthor_device.c           |   9 +-
 drivers/gpu/drm/panthor/panthor_device.h           | 100 +--
 drivers/gpu/drm/panthor/panthor_drv.c              |   8 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |  29 +-
 drivers/gpu/drm/panthor/panthor_fw_regs.h          |  32 +
 drivers/gpu/drm/panthor/panthor_gpu.c              |  50 +-
 drivers/gpu/drm/panthor/panthor_gpu_regs.h         | 123 ++++
 drivers/gpu/drm/panthor/panthor_heap.c             |   2 +-
 drivers/gpu/drm/panthor/panthor_hw.c               |  50 +-
 drivers/gpu/drm/panthor/panthor_hw.h               |   2 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |  37 +-
 drivers/gpu/drm/panthor/panthor_mmu_regs.h         |  73 +++
 drivers/gpu/drm/panthor/panthor_pwr.c              |  73 ++-
 drivers/gpu/drm/panthor/panthor_pwr_regs.h         |  83 +++
 drivers/gpu/drm/panthor/panthor_regs.h             | 291 ---------
 drivers/gpu/drm/panthor/panthor_sched.c            | 113 ++--
 drivers/gpu/drm/radeon/radeon_gem.c                |  13 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   4 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |  12 +-
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c          |   7 +-
 drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c      |   3 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |   4 +-
 drivers/gpu/drm/tegra/fbdev.c                      |   1 -
 drivers/gpu/drm/tegra/gem.c                        |  22 +-
 drivers/gpu/drm/tegra/gr2d.c                       |  19 +-
 drivers/gpu/drm/tegra/gr3d.c                       |  19 +-
 drivers/gpu/drm/tegra/submit.c                     |   3 +-
 drivers/gpu/drm/tidss/tidss_kms.c                  |   2 -
 drivers/gpu/drm/v3d/v3d_submit.c                   |   2 +
 drivers/gpu/drm/verisilicon/vs_primary_plane.c     |  10 +-
 drivers/gpu/drm/xe/Makefile                        |   4 +-
 drivers/gpu/drm/xe/tests/xe_pci.c                  |   1 -
 drivers/gpu/drm/xe/xe_drm_client.c                 |  12 +-
 drivers/gpu/drm/xe/xe_guc_relay.c                  |  13 +-
 drivers/gpu/drm/xe/xe_hw_engine.c                  |   4 +-
 drivers/gpu/drm/xe/xe_pt.c                         |  72 ++-
 drivers/gpu/drm/xe/xe_svm.h                        |  15 +-
 drivers/gpu/drm/xe/xe_userptr.c                    |   2 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c                 |   2 +-
 drivers/gpu/host1x/bus.c                           |  62 +-
 drivers/gpu/host1x/job.c                           |  10 +-
 drivers/gpu/host1x/mipi.c                          |   6 +-
 drivers/gpu/nova-core/firmware.rs                  |   8 +-
 drivers/gpu/nova-core/firmware/gsp.rs              |   3 +-
 drivers/gpu/nova-core/vbios.rs                     | 118 ++--
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   5 +-
 drivers/hid/hid-core.c                             |   7 +
 drivers/hid/hid-logitech-hidpp.c                   |   1 -
 drivers/hid/hid-picolcd_core.c                     |   3 +-
 drivers/hid/hid-wiimote-modules.c                  |  58 +-
 drivers/hv/mshv_synic.c                            |   5 +
 drivers/hv/vmbus_drv.c                             |  43 +-
 drivers/hwmon/Kconfig                              |   3 +
 drivers/hwmon/aspeed-g6-pwm-tach.c                 |   5 +-
 drivers/hwmon/asus_atk0110.c                       |   3 +
 drivers/hwmon/gpd-fan.c                            | 224 ++++---
 drivers/hwmon/it87.c                               |   3 +
 drivers/hwmon/occ/common.c                         |  34 +-
 drivers/hwmon/occ/common.h                         |   1 +
 drivers/hwmon/pmbus/adm1275.c                      |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  37 +-
 drivers/hwmon/w83627hf.c                           |   4 +
 drivers/hwmon/w83793.c                             |   1 +
 drivers/hwspinlock/qcom_hwspinlock.c               |   5 +-
 drivers/hwtracing/coresight/coresight-core.c       |  34 +-
 .../hwtracing/coresight/coresight-cti-platform.c   |   1 +
 drivers/hwtracing/coresight/coresight-etm-perf.c   |   5 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  52 +-
 drivers/hwtracing/coresight/coresight-platform.c   |  12 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   2 +-
 drivers/hwtracing/coresight/coresight-sysfs.c      |   8 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |   4 +-
 drivers/i2c/busses/i2c-imx.c                       |  36 +-
 drivers/i2c/busses/i2c-k1.c                        |   2 +-
 drivers/i2c/busses/i2c-mlxbf.c                     |   4 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/i2c-core-of.c                          |   5 -
 drivers/i3c/master.c                               | 145 ++++-
 drivers/i3c/master/dw-i3c-master.c                 |  15 +-
 drivers/i3c/master/dw-i3c-master.h                 |   2 -
 drivers/i3c/master/i3c-master-cdns.c               |  14 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |  48 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   9 +-
 drivers/i3c/master/mipi-i3c-hci/hci.h              |   1 +
 drivers/i3c/master/mipi-i3c-hci/ibi.h              |  13 +-
 drivers/i3c/master/mipi-i3c-hci/pio.c              |   7 +-
 drivers/i3c/master/svc-i3c-master.c                |  30 +-
 drivers/iio/accel/mma8452.c                        |   2 +
 drivers/iio/adc/xilinx-ams.c                       |   5 +
 drivers/iio/dac/mcp47feb02.c                       |  37 +-
 drivers/iio/light/acpi-als.c                       |   6 +-
 drivers/iio/light/si1133.c                         |  14 +-
 drivers/iio/light/tcs3472.c                        |  38 +-
 drivers/iio/magnetometer/ak8975.c                  |  14 +
 drivers/iio/orientation/hid-sensor-rotation.c      |  40 +-
 drivers/infiniband/core/cm.c                       |  13 +-
 drivers/infiniband/core/counters.c                 |   2 +-
 drivers/infiniband/core/frmr_pools.c               | 106 ++-
 drivers/infiniband/core/nldev.c                    |  15 +-
 drivers/infiniband/core/restrack.c                 |  49 ++
 drivers/infiniband/core/restrack.h                 |   1 +
 drivers/infiniband/core/uverbs_cmd.c               |  10 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           | 217 +++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   5 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  11 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   1 +
 drivers/infiniband/hw/bnxt_re/uapi.c               |  83 ++-
 drivers/infiniband/hw/hfi1/init.c                  |  13 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   6 +-
 drivers/infiniband/hw/hns/hns_roce_debugfs.c       |  19 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   8 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  20 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   6 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/irdma/hw.c                   |   7 +-
 drivers/infiniband/hw/irdma/main.h                 |   3 +-
 drivers/infiniband/hw/irdma/utils.c                |  12 +-
 drivers/infiniband/hw/irdma/verbs.c                |  19 +-
 drivers/infiniband/hw/irdma/verbs.h                |   1 -
 drivers/infiniband/hw/mana/main.c                  |   3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   1 +
 drivers/infiniband/hw/mlx4/mr.c                    |   9 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  45 +-
 drivers/infiniband/hw/mlx5/devx.c                  |  30 +-
 drivers/infiniband/hw/mlx5/main.c                  |  17 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   9 +
 drivers/infiniband/hw/mlx5/mr.c                    |  60 +-
 drivers/infiniband/hw/mlx5/odp.c                   |  12 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  13 +-
 drivers/infiniband/hw/mlx5/restrack.c              |   3 -
 drivers/infiniband/hw/mlx5/umr.c                   |  93 ++-
 drivers/infiniband/hw/mlx5/umr.h                   |   9 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |  19 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   6 +-
 drivers/infiniband/sw/rxe/rxe_ns.c                 |   4 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  33 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |  30 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   5 +-
 drivers/input/misc/ims-pcu.c                       | 131 +++-
 drivers/iommu/amd/amd_iommu_types.h                |  11 +-
 drivers/iommu/amd/init.c                           |   7 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   2 +-
 drivers/iommu/dma-iommu.c                          |   2 +-
 drivers/iommu/intel/iommu.c                        |   6 +-
 drivers/iommu/intel/pasid.c                        |   4 +-
 drivers/iommu/iommufd/pages.c                      |  10 +-
 drivers/irqchip/exynos-combiner.c                  |   4 -
 drivers/irqchip/irq-crossbar.c                     |  10 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   6 +-
 drivers/irqchip/irq-riscv-imsic-early.c            |  15 +-
 drivers/irqchip/irq-ts4800.c                       |  10 +
 drivers/leds/uleds.c                               |   3 +-
 drivers/mailbox/imx-mailbox.c                      |   3 +-
 drivers/mailbox/mailbox-mpfs.c                     |   2 +-
 drivers/mailbox/mailbox.c                          |  26 +-
 drivers/mailbox/mtk-adsp-mailbox.c                 |   9 +-
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-era-target.c                         |  10 +-
 drivers/md/dm-integrity.c                          |  12 +-
 drivers/md/dm-ioctl.c                              |   4 +-
 drivers/md/dm-log.c                                |   3 +
 drivers/md/dm-pcache/dm_pcache.c                   |   8 +
 drivers/md/dm-stats.c                              |  10 +-
 drivers/md/dm-thin-metadata.c                      |  67 +-
 drivers/md/dm-verity-fec.c                         |   4 +-
 drivers/md/dm-verity-fec.h                         |   2 +-
 drivers/md/dm-verity-loadpin.c                     |   2 +-
 drivers/md/dm-verity-target.c                      |  16 +-
 drivers/md/dm-verity.h                             |   2 +-
 drivers/md/dm.c                                    |  24 +-
 drivers/md/md-bitmap.c                             |   9 +-
 drivers/md/md-bitmap.h                             |   2 +-
 drivers/md/md-llbitmap.c                           |  13 +-
 drivers/md/md.c                                    |  27 +-
 drivers/md/md.h                                    |   5 +
 drivers/md/raid1.c                                 |  54 +-
 drivers/md/raid10.c                                |  57 +-
 drivers/md/raid5.c                                 |  55 +-
 drivers/media/platform/qcom/camss/camss-vfe.c      |   2 +-
 .../media/platform/qcom/iris/iris_platform_gen1.c  |   2 +-
 drivers/media/platform/qcom/iris/iris_probe.c      |   7 +
 drivers/media/platform/qcom/venus/core.c           |   7 +-
 drivers/media/platform/qcom/venus/core.h           |   1 +
 drivers/media/platform/qcom/venus/helpers.c        |   4 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   6 +-
 drivers/media/platform/qcom/venus/hfi_platform.c   |  24 -
 drivers/media/platform/qcom/venus/hfi_platform.h   |   2 -
 .../media/platform/qcom/venus/hfi_platform_v4.c    |  20 +-
 .../media/platform/qcom/venus/hfi_platform_v6.c    |  16 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   8 +-
 drivers/media/platform/rockchip/rga/rga-hw.c       |   2 +-
 drivers/media/platform/rockchip/rga/rga-hw.h       |   2 +-
 drivers/media/platform/synopsys/dw-mipi-csi2rx.c   |  15 +-
 drivers/media/usb/uvc/uvc_status.c                 |  28 +-
 drivers/media/usb/uvc/uvc_video.c                  | 179 ++++--
 drivers/media/v4l2-core/v4l2-common.c              |   1 +
 drivers/memory/tegra/mc.c                          |  14 +
 drivers/memory/tegra/tegra186-emc.c                |   4 +-
 drivers/memstick/core/ms_block.c                   |   4 +
 drivers/mfd/cs42l43.c                              |   2 +-
 drivers/mfd/rsmu_i2c.c                             |   6 +-
 drivers/mfd/rsmu_spi.c                             |   5 +-
 drivers/mfd/sm501.c                                |   4 +-
 drivers/mfd/tps6586x.c                             |   2 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/core/mmc_test.c                        |  18 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  91 ++-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  14 +-
 drivers/mmc/host/vub300.c                          |  36 +-
 drivers/mtd/devices/mchp23k256.c                   |   2 +-
 drivers/mtd/devices/slram.c                        |  22 +-
 drivers/mtd/maps/vmu-flash.c                       |   7 +-
 drivers/mtd/mtd_virt_concat.c                      |   4 +-
 drivers/mtd/nand/onenand/onenand_samsung.c         |   7 +-
 drivers/mtd/nand/raw/fsl_ifc_nand.c                |   9 +-
 drivers/mtd/nand/raw/lpc32xx_mlc.c                 |  12 +-
 drivers/mtd/nand/raw/lpc32xx_slc.c                 |  12 +-
 drivers/mtd/nand/raw/nand_base.c                   |  24 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   2 +-
 drivers/mtd/spi-nor/Kconfig                        |   1 -
 drivers/mtd/spi-nor/debugfs.c                      |   1 +
 drivers/mtd/spi-nor/spansion.c                     |   4 +-
 drivers/mtd/spi-nor/swp.c                          |  11 +-
 drivers/net/amt.c                                  |  10 +-
 drivers/net/bareudp.c                              |   4 +-
 drivers/net/bonding/bond_3ad.c                     |  27 +-
 drivers/net/bonding/bond_main.c                    |   1 +
 drivers/net/bonding/bond_netlink.c                 |  16 +
 drivers/net/bonding/bond_options.c                 |  27 +
 drivers/net/can/usb/esd_usb.c                      |   5 +-
 drivers/net/dsa/mxl862xx/mxl862xx-host.c           |  18 +-
 drivers/net/dsa/qca/qca8k-leds.c                   |   3 +-
 drivers/net/dsa/realtek/rtl8366rb-leds.c           |   8 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |   2 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   6 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |   9 +-
 drivers/net/ethernet/airoha/airoha_ppe_debugfs.c   |   2 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  23 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  58 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  23 +-
 drivers/net/ethernet/cadence/macb_main.c           |  29 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |  18 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  27 -
 .../net/ethernet/cavium/liquidio/octeon_device.h   |   3 -
 .../net/ethernet/cavium/liquidio/octeon_mailbox.c  |  33 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   8 -
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  10 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   7 +
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c   |   3 +
 drivers/net/ethernet/freescale/fman/fman.c         |   4 +-
 drivers/net/ethernet/freescale/gianfar.c           |  16 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  28 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  31 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 108 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 drivers/net/ethernet/ibm/emac/core.c               |  13 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  15 +-
 drivers/net/ethernet/intel/i40e/i40e_debug.h       |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   1 -
 drivers/net/ethernet/intel/ice/ice_dpll.c          |  20 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  12 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  16 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   2 +-
 drivers/net/ethernet/intel/idpf/virtchnl2.h        |  12 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   3 +
 .../net/ethernet/marvell/octeontx2/af/cn20k/npc.c  |   9 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  31 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |   9 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  59 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  27 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  15 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  40 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   2 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  83 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  22 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  10 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   4 +-
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |   6 +-
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c        |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  12 +
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |  37 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  47 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  17 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  24 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 507 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  | 102 ++-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  41 +-
 .../ethernet/mellanox/mlx5/core/lag/shared_fdb.c   | 235 +++++++
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |   8 +
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c   |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/sd.h   |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/st.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   1 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |   9 +-
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   7 +-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   4 +
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c        |   2 +
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |  11 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   2 +-
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   5 +-
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   4 +-
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   |   5 +-
 drivers/net/ethernet/microchip/vcap/vcap_api.c     |  72 ++-
 drivers/net/ethernet/microchip/vcap/vcap_api.h     |   3 +-
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   8 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c        |   3 +-
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |   3 +-
 .../net/ethernet/microchip/vcap/vcap_api_private.h |   3 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   3 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  80 ++-
 drivers/net/ethernet/mucse/rnpgbe/rnpgbe_mbx.c     |  26 +-
 drivers/net/ethernet/mucse/rnpgbe/rnpgbe_mbx.h     |   5 +-
 drivers/net/ethernet/mucse/rnpgbe/rnpgbe_mbx_fw.c  |  82 +--
 drivers/net/ethernet/mucse/rnpgbe/rnpgbe_mbx_fw.h  |  14 +
 drivers/net/ethernet/oa_tc6.c                      |  14 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  11 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   9 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   5 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |   1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  78 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-spacemit.c   |  13 +-
 drivers/net/ethernet/sun/sungem.c                  |  13 +-
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |   6 +-
 drivers/net/ethernet/ti/icssg/icssg_common.c       | 120 ++--
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   1 +
 drivers/net/geneve.c                               |  24 +-
 drivers/net/gtp.c                                  |  10 +-
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/ipa/ipa_smp2p.c                        |  30 +-
 drivers/net/macsec.c                               |   9 +-
 drivers/net/mdio/Kconfig                           |   3 +-
 drivers/net/netconsole.c                           |  12 +-
 drivers/net/ovpn/udp.c                             |   2 +-
 drivers/net/pfcp.c                                 |   5 +-
 drivers/net/phy/realtek/realtek_main.c             |   3 +-
 drivers/net/phy/sfp.c                              |   1 +
 drivers/net/pse-pd/pse_core.c                      |   6 +-
 drivers/net/thunderbolt/main.c                     |   8 +-
 drivers/net/usb/gl620a.c                           |   6 +-
 drivers/net/usb/lan78xx.c                          |  55 +-
 drivers/net/usb/net1080.c                          |   2 +-
 drivers/net/veth.c                                 |   2 +
 drivers/net/virtio_net.c                           |  27 +-
 drivers/net/vxlan/vxlan_core.c                     |  14 +-
 drivers/net/wan/ixp4xx_hss.c                       |   4 +-
 drivers/net/wireguard/socket.c                     |   8 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   4 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   8 +
 drivers/net/wireless/ath/ath12k/ahb.c              |  25 +-
 drivers/net/wireless/ath/ath12k/dp.c               |  10 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   6 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  21 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   5 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |  13 +
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |   6 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |   1 -
 drivers/net/wireless/mediatek/mt76/channel.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   1 -
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt7925/testmode.c   |   5 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  35 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  12 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  13 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   3 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   8 +-
 drivers/net/wireless/ti/wlcore/main.c              |  23 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  40 +-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c             |   3 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c             |   2 +
 drivers/ntb/hw/epf/ntb_hw_epf.c                    |  81 ++-
 drivers/ntb/ntb_transport.c                        |  10 +-
 drivers/nvdimm/btt.c                               |  14 +-
 drivers/nvdimm/nd.h                                |  11 +-
 drivers/nvdimm/region_devs.c                       |  66 +-
 drivers/nvme/host/apple.c                          |  12 +-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/nvme/host/pci.c                            |   9 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  26 +-
 drivers/nvme/target/rdma.c                         |  18 +-
 drivers/nvme/target/tcp.c                          |  11 +-
 drivers/of/cpu.c                                   |   2 +-
 drivers/of/dynamic.c                               |   1 -
 drivers/of/of_reserved_mem.c                       |  28 +-
 drivers/of/overlay.c                               |  15 +
 drivers/of/platform.c                              |   5 -
 drivers/opp/core.c                                 |   5 +-
 drivers/pci/controller/dwc/pci-meson.c             |  13 +-
 .../pci/controller/dwc/pcie-designware-debugfs.c   |  10 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  16 +-
 drivers/pci/controller/dwc/pcie-designware.h       |   1 +
 drivers/pci/controller/dwc/pcie-intel-gw.c         |  46 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  43 +-
 drivers/pci/controller/pci-loongson.c              |  31 +-
 drivers/pci/controller/pcie-iproc-bcma.c           |   2 +-
 drivers/pci/controller/pcie-iproc-platform.c       |   2 +-
 drivers/pci/controller/pcie-iproc.c                |   1 -
 drivers/pci/controller/pcie-iproc.h                |   2 -
 drivers/pci/controller/pcie-mediatek-gen3.c        |   4 +-
 drivers/pci/controller/pcie-mediatek.c             |  19 +-
 drivers/pci/controller/pcie-rcar-host.c            |   1 -
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |  21 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      | 130 +++-
 drivers/pci/msi/msi.c                              |   4 +-
 drivers/pci/pci.c                                  |   3 -
 drivers/pci/pwrctrl/core.c                         |  26 +-
 drivers/pci/rom.c                                  | 149 ++++-
 drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c    |  26 +-
 drivers/phy/phy-can-transceiver.c                  |   3 +
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |   6 +-
 drivers/pinctrl/mediatek/mtk-eint.c                |   6 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c          | 122 +++-
 drivers/pinctrl/mediatek/pinctrl-mt8167.c          |   2 +-
 drivers/pinctrl/mediatek/pinctrl-mt8516.c          |   2 +-
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c         |  15 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/nuvoton/pinctrl-ma35.c             |   3 +-
 drivers/pinctrl/nuvoton/pinctrl-ma35d1.c           | 470 ++++++++------
 drivers/pinctrl/pinconf-generic.c                  |   5 +-
 drivers/pinctrl/qcom/tlmm-test.c                   |  19 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   8 +-
 drivers/pinctrl/spacemit/pinctrl-k1.c              |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c      |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c        |   1 -
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   2 +-
 drivers/platform/chrome/chromeos_privacy_screen.c  |   3 +
 drivers/platform/chrome/chromeos_tbmc.c            |   6 +-
 drivers/platform/chrome/wilco_ec/event.c           |   8 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |  39 ++
 drivers/platform/x86/amd/pmc/pmc.c                 |  83 ++-
 drivers/platform/x86/amd/pmc/pmc.h                 |   2 +
 drivers/platform/x86/bitland-mifs-wmi.c            |   8 +
 drivers/platform/x86/classmate-laptop.c            |  12 +-
 drivers/platform/x86/dell/dell-laptop.c            |   5 +
 drivers/platform/x86/hp/hp-wmi.c                   |   8 +
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   2 +-
 drivers/platform/x86/intel/vsec.c                  |  17 +-
 drivers/platform/x86/intel/vsec_tpmi.c             |  25 +-
 drivers/platform/x86/xo15-ebook.c                  |   7 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  46 +-
 drivers/pmdomain/imx/imx93-blk-ctrl.c              |  60 +-
 drivers/pmdomain/mediatek/mtk-pm-domains.c         |  40 +-
 drivers/power/sequencing/core.c                    |   9 +-
 drivers/power/supply/bq257xx_charger.c             |   7 +-
 drivers/power/supply/charger-manager.c             |   6 +-
 drivers/power/supply/cpcap-battery.c               |  11 +-
 drivers/power/supply/max17042_battery.c            |   3 +-
 drivers/power/supply/power_supply_core.c           |  11 +-
 drivers/pwm/pwm-imx27.c                            |   8 +-
 drivers/pwm/pwm-rzg2l-gpt.c                        |   8 +-
 drivers/rapidio/devices/tsi721.c                   |   3 +-
 drivers/regulator/core.c                           |   4 +-
 drivers/regulator/ltc3676.c                        |  10 +-
 drivers/remoteproc/qcom_common.c                   |  14 +-
 drivers/remoteproc/qcom_q6v5_wcss.c                |  23 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |  46 +-
 drivers/reset/reset-imx7.c                         |   6 +
 drivers/reset/reset-sunxi.c                        |   4 +-
 drivers/rpmsg/qcom_glink_native.c                  |   2 -
 drivers/rpmsg/rpmsg_core.c                         |  43 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   1 -
 drivers/rtc/rtc-abx80x.c                           |   3 +-
 drivers/rtc/rtc-cmos.c                             |   6 +
 drivers/rtc/rtc-ds1307.c                           |  30 +-
 drivers/rtc/rtc-isl1208.c                          |  15 +-
 drivers/rtc/rtc-mpfs.c                             |   2 +-
 drivers/rtc/rtc-msc313.c                           |   4 +-
 drivers/rtc/rtc-renesas-rtca3.c                    |   2 +-
 drivers/s390/char/monwriter.c                      |   3 +
 drivers/s390/crypto/pkey_api.c                     |   8 +-
 drivers/s390/crypto/pkey_pckmo.c                   |   4 +
 drivers/s390/crypto/zcrypt_cex2a.c                 |   0
 drivers/s390/crypto/zcrypt_cex2a.h                 |   0
 drivers/s390/crypto/zcrypt_cex2c.c                 |   0
 drivers/s390/crypto/zcrypt_cex2c.h                 |   0
 drivers/scsi/elx/efct/efct_hw.c                    |   2 +
 drivers/scsi/elx/efct/efct_unsol.c                 |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  12 +-
 drivers/scsi/hpsa.c                                |   4 +
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   5 +-
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/scsi/scsi_transport_sas.c                  | 101 ++-
 drivers/scsi/sg.c                                  |   7 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   2 +-
 drivers/soc/fsl/qe/qe.c                            |   3 +
 drivers/soc/fsl/qe/qe_ports_ic.c                   |  21 +-
 drivers/soc/mediatek/mt8167-mmsys.h                |  11 +-
 drivers/soc/ti/k3-ringacc.c                        |   4 +-
 drivers/soc/xilinx/zynqmp_power.c                  |  47 +-
 drivers/soundwire/generic_bandwidth_allocation.c   |  57 +-
 drivers/soundwire/intel_ace2x.c                    |   1 +
 drivers/soundwire/stream.c                         |   7 +
 drivers/spi/spi-atcspi200.c                        |  13 +-
 drivers/spi/spi-atmel.c                            | 133 ++--
 drivers/spi/spi-dw.h                               |   1 +
 drivers/spi/spi-ep93xx.c                           |   1 +
 drivers/spi/spi-hisi-kunpeng.c                     |   6 +-
 drivers/spi/spi-imx.c                              |  19 +-
 drivers/spi/spi-meson-spifc.c                      |   1 +
 drivers/spi/spi-rpc-if.c                           |   6 +-
 drivers/spi/spi-rzv2h-rspi.c                       |   4 +-
 drivers/spi/spi-sh-msiof.c                         |  10 +-
 drivers/spi/spi-uniphier.c                         |   4 +-
 drivers/spi/spi-xilinx.c                           |  11 +-
 drivers/spi/spi.c                                  |   5 -
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |  29 +-
 drivers/staging/media/atomisp/pci/atomisp_cmd.c    |   6 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |   8 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/most/video/video.c                 |   7 +-
 drivers/staging/nvec/nvec.c                        |   4 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |   2 +-
 drivers/target/iscsi/iscsi_target_auth.c           |   6 +-
 drivers/target/loopback/tcm_loop.c                 |  64 --
 drivers/target/target_core_fabric_lib.c            |  89 ++-
 drivers/target/target_core_internal.h              |   3 +-
 drivers/target/target_core_pr.c                    |  12 +-
 drivers/thermal/intel/therm_throt.c                |   7 +-
 drivers/thermal/testing/command.c                  |  48 +-
 drivers/thermal/testing/thermal_testing.h          |   8 +
 drivers/thermal/testing/zone.c                     |   7 +-
 drivers/thermal/thermal_hwmon.c                    | 156 ++---
 drivers/thunderbolt/debugfs.c                      |   8 +-
 drivers/tty/serial/8250/8250_omap.c                |   3 +-
 drivers/tty/serial/max310x.c                       |  12 +
 drivers/tty/serial/msm_serial.c                    |   3 +-
 drivers/ufs/core/ufs_trace.h                       |  36 +-
 drivers/ufs/core/ufshcd.c                          |  36 +-
 drivers/usb/atm/ueagle-atm.c                       |  94 ++-
 drivers/usb/host/max3421-hcd.c                     |   8 +
 drivers/vdpa/octeon_ep/octep_vdpa_main.c           |  20 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |   2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 197 +++++-
 drivers/vfio/pci/qat/main.c                        |  18 +-
 drivers/vfio/pci/xe/main.c                         |   2 -
 drivers/vhost/net.c                                |  15 +-
 drivers/vhost/vdpa.c                               |  29 +-
 drivers/vhost/vhost.c                              |  11 +-
 drivers/video/backlight/ktd2801-backlight.c        |   1 +
 drivers/video/fbdev/aty/radeon_base.c              |   1 +
 drivers/video/fbdev/broadsheetfb.c                 |   8 +-
 drivers/video/fbdev/carminefb.c                    |   1 +
 drivers/video/fbdev/core/fbcon.c                   |  10 +-
 drivers/video/fbdev/efifb.c                        |   1 +
 drivers/video/fbdev/hecubafb.c                     |   6 +-
 drivers/video/fbdev/i740fb.c                       |   1 +
 drivers/video/fbdev/metronomefb.c                  |   8 +-
 drivers/video/fbdev/nvidia/nvidia.c                |   1 +
 drivers/video/fbdev/s3fb.c                         |   1 +
 drivers/video/fbdev/sm501fb.c                      |  16 +-
 drivers/video/fbdev/sm712.h                        |   2 +-
 drivers/video/fbdev/tdfxfb.c                       |   1 +
 drivers/video/fbdev/tridentfb.c                    |   1 +
 drivers/video/fbdev/uvesafb.c                      |   4 +-
 drivers/video/fbdev/vesafb.c                       |   1 +
 drivers/virtio/virtio_rtc_driver.c                 |  28 +-
 drivers/watchdog/sama5d4_wdt.c                     |  48 +-
 drivers/watchdog/sp5100_tco.c                      |   3 +-
 drivers/watchdog/sprd_wdt.c                        |   5 +-
 drivers/watchdog/watchdog_core.c                   |   3 +
 drivers/xen/gntdev.c                               |   8 +-
 drivers/xen/pvcalls-front.c                        |  88 ++-
 drivers/xen/xen-scsiback.c                         |  30 +-
 fs/9p/vfs_inode.c                                  |  28 +-
 fs/9p/vfs_inode_dotl.c                             |   4 +-
 fs/afs/callback.c                                  |  17 +-
 fs/afs/cell.c                                      |  27 +-
 fs/afs/cm_security.c                               |   3 +-
 fs/afs/cmservice.c                                 |   7 +-
 fs/afs/dir.c                                       |  40 +-
 fs/afs/dynroot.c                                   |   2 +-
 fs/afs/fs_operation.c                              |   2 +-
 fs/afs/inode.c                                     |  15 +-
 fs/afs/internal.h                                  |   3 +-
 fs/afs/rxrpc.c                                     |  16 +-
 fs/afs/super.c                                     |   5 +-
 fs/afs/vl_list.c                                   |  10 +-
 fs/afs/volume.c                                    |   2 +-
 fs/bpf_fs_kfuncs.c                                 |  10 +-
 fs/btrfs/compression.c                             |  18 +-
 fs/btrfs/delalloc-space.c                          |   2 +
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent-tree.c                             |   5 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/lzo.c                                     |  11 +
 fs/btrfs/reflink.c                                 | 101 +--
 fs/btrfs/space-info.c                              |   2 +
 fs/btrfs/space-info.h                              |  11 +
 fs/btrfs/super.c                                   |   4 +-
 fs/btrfs/zoned.c                                   |  64 +-
 fs/cachefiles/namei.c                              |   3 +-
 fs/configfs/dir.c                                  |  57 +-
 fs/crypto/fscrypt_private.h                        |  32 +-
 fs/crypto/keyring.c                                | 216 +++----
 fs/dlm/midcomms.c                                  |   4 +-
 fs/efs/file.c                                      |  21 +-
 fs/erofs/inode.c                                   |   5 +-
 fs/erofs/super.c                                   |   4 +-
 fs/eventpoll.c                                     | 609 ++++++++++++------
 fs/exfat/balloc.c                                  |   2 +-
 fs/exfat/dir.c                                     |  48 +-
 fs/exfat/exfat_fs.h                                | 131 +++-
 fs/exfat/fatent.c                                  |   4 +-
 fs/exfat/file.c                                    |   8 +-
 fs/exfat/inode.c                                   |  26 +-
 fs/exfat/namei.c                                   |  26 +-
 fs/exfat/super.c                                   |   5 +-
 fs/ext2/file.c                                     |   9 +-
 fs/ext4/ext4.h                                     |  20 +
 fs/ext4/fast_commit.c                              |  50 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/ext4/ioctl.c                                    |  15 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/data.c                                     |  29 +
 fs/f2fs/f2fs.h                                     |   1 +
 fs/f2fs/segment.c                                  |   8 +
 fs/f2fs/xattr.c                                    |   6 +-
 fs/fhandle.c                                       |   2 +-
 fs/fs-writeback.c                                  |   5 -
 fs/hfs/inode.c                                     |   2 +-
 fs/hfsplus/btree.c                                 |   2 +
 fs/hfsplus/xattr.c                                 |   1 -
 fs/iomap/bio.c                                     |  13 +-
 fs/iomap/buffered-io.c                             |   2 +-
 fs/iomap/direct-io.c                               |   7 +-
 fs/iomap/ioend.c                                   |   8 +-
 fs/jbd2/journal.c                                  |   2 +
 fs/kernfs/dir.c                                    |  33 +-
 fs/kernfs/file.c                                   |  13 +-
 fs/kernfs/inode.c                                  |  36 +-
 fs/kernfs/kernfs-internal.h                        |  24 +-
 fs/kernfs/mount.c                                  |   2 +-
 fs/lockd/lockd.h                                   |   8 +
 fs/lockd/svc4proc.c                                |  19 +-
 fs/lockd/svcproc.c                                 |   2 +-
 fs/lockd/svcsubs.c                                 |   7 +-
 fs/minix/minix.h                                   |   2 +-
 fs/namei.c                                         |   4 +
 fs/netfs/read_retry.c                              |   7 +-
 fs/netfs/write_issue.c                             |  18 +-
 fs/netfs/write_retry.c                             |   7 +-
 fs/nfs/callback_proc.c                             |   9 +-
 fs/nfs/delegation.c                                |   9 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  29 +
 fs/nfs/flexfilelayout/flexfilelayout.h             |  16 +
 fs/nfs/fs_context.c                                |   8 +-
 fs/nfs/internal.h                                  |  12 +-
 fs/nfs/nfs4proc.c                                  |  22 +-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   2 +-
 fs/nfs/read.c                                      |  25 +-
 fs/nfs/write.c                                     |  14 +-
 fs/nfsd/nfs4state.c                                |  16 +-
 fs/nilfs2/namei.c                                  |   2 +-
 fs/nilfs2/super.c                                  |   2 -
 fs/ntfs/aops.c                                     |  23 +-
 fs/ntfs/attrib.c                                   | 345 +++++++---
 fs/ntfs/attrib.h                                   |   4 +
 fs/ntfs/attrlist.c                                 |  20 +-
 fs/ntfs/dir.c                                      |  79 +--
 fs/ntfs/ea.c                                       |  16 +-
 fs/ntfs/index.c                                    | 297 ++++++---
 fs/ntfs/index.h                                    |  12 +-
 fs/ntfs/inode.c                                    |  38 +-
 fs/ntfs/logfile.c                                  |   2 +-
 fs/ntfs/mft.c                                      | 137 +---
 fs/ntfs/namei.c                                    |  67 +-
 fs/ntfs/runlist.c                                  |  12 +-
 fs/ntfs/super.c                                    |  53 +-
 fs/ntfs3/attrib.c                                  |  10 +-
 fs/ntfs3/frecord.c                                 |  17 +-
 fs/ntfs3/fslog.c                                   | 147 ++++-
 fs/ntfs3/index.c                                   |  45 +-
 fs/ntfs3/inode.c                                   |   9 +-
 fs/ntfs3/lznt.c                                    |   2 +-
 fs/ntfs3/namei.c                                   |   2 +-
 fs/ntfs3/ntfs_fs.h                                 |   3 +-
 fs/ntfs3/run.c                                     |  14 +-
 fs/ocfs2/alloc.c                                   |   2 +-
 fs/ocfs2/aops.c                                    |  13 +-
 fs/ocfs2/buffer_head_io.c                          |   7 +-
 fs/ocfs2/dlm/dlmdebug.c                            |  16 +-
 fs/ocfs2/dlmglue.c                                 |  17 +
 fs/ocfs2/inode.c                                   | 206 +++++-
 fs/ocfs2/journal.c                                 |  13 +-
 fs/ocfs2/journal.h                                 |   3 +
 fs/ocfs2/move_extents.c                            |   4 +-
 fs/ocfs2/ocfs2.h                                   |   2 -
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/ocfs2/refcounttree.c                            |   9 +-
 fs/ocfs2/stack_user.c                              |  10 +-
 fs/ocfs2/super.c                                   |   2 -
 fs/ocfs2/sysfile.c                                 |   9 +-
 fs/orangefs/dir.c                                  |   7 +-
 fs/overlayfs/copy_up.c                             |  12 +-
 fs/overlayfs/inode.c                               |   4 +-
 fs/pidfs.c                                         |  45 +-
 fs/proc/generic.c                                  |   9 +-
 fs/proc/page.c                                     |   2 +-
 fs/proc/task_mmu.c                                 |  74 ++-
 fs/resctrl/rdtgroup.c                              |  33 +-
 fs/smb/client/cifs_fs_sb.h                         |   1 +
 fs/smb/client/cifsfs.c                             |  12 +
 fs/smb/client/connect.c                            |   4 +
 fs/smb/client/file.c                               |   6 +
 fs/smb/client/fs_context.c                         | 102 +--
 fs/smb/client/inode.c                              |  30 +-
 fs/smb/client/ioctl.c                              |  12 +-
 fs/smb/client/misc.c                               |   8 +
 fs/smb/client/reparse.c                            |  17 +-
 fs/smb/client/smb1pdu.h                            |   5 -
 fs/smb/client/smb2ops.c                            |  38 +-
 fs/smb/client/smb2pdu.h                            |   4 -
 fs/smb/common/fscc.h                               |  18 +
 fs/smb/server/auth.c                               |  47 +-
 fs/smb/server/auth.h                               |   7 +-
 fs/smb/server/mgmt/user_session.c                  |   4 +-
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/misc.c                               |  33 -
 fs/smb/server/misc.h                               |   1 -
 fs/smb/server/oplock.c                             |   6 +
 fs/smb/server/smb2pdu.c                            | 171 +++--
 fs/smb/server/smb2pdu.h                            |   3 -
 fs/smb/server/smbacl.c                             |   7 +-
 fs/smb/server/vfs.c                                |  55 +-
 fs/smb/server/vfs_cache.c                          |  29 +-
 fs/super.c                                         |  11 +-
 fs/sysfs/file.c                                    |   4 +
 fs/udf/super.c                                     |   2 +-
 fs/xattr.c                                         | 265 ++++----
 fs/xfs/xfs_aops.c                                  |   3 +-
 fs/xfs/xfs_rtalloc.c                               |   8 +
 fs/xfs/xfs_zone_alloc.c                            |  11 +-
 fs/xfs/xfs_zone_alloc.h                            |   1 +
 fs/xfs/xfs_zone_gc.c                               |   4 +-
 include/acpi/platform/aclinuxex.h                  |   1 +
 include/asm-generic/bitops/lock.h                  |  22 +-
 include/asm-generic/uaccess.h                      |   3 +-
 include/dt-bindings/clock/qcom,x1e80100-camcc.h    |   3 +
 include/dt-bindings/power/fsl,imx93-power.h        |   1 +
 include/linux/amba/bus.h                           |   5 -
 include/linux/arm-smccc.h                          |   5 +
 include/linux/bpf-cgroup.h                         |   5 +-
 include/linux/bpf.h                                |   2 +
 include/linux/bpf_lsm.h                            |   6 +
 include/linux/cdx/cdx_bus.h                        |   4 -
 include/linux/device.h                             |   5 +-
 include/linux/edac.h                               |   3 +
 include/linux/filelock.h                           |   2 +-
 include/linux/firmware.h                           |  10 +
 .../linux/firmware/samsung/exynos-acpm-protocol.h  |  10 +-
 include/linux/firmware/xlnx-zynqmp.h               |  21 +
 include/linux/fs.h                                 |   1 +
 include/linux/fwnode.h                             |   3 +
 include/linux/hfs_common.h                         |   1 +
 include/linux/host1x.h                             |   7 +
 include/linux/hyperv.h                             |   5 -
 include/linux/i3c/master.h                         |  14 +-
 include/linux/ieee80211-eht.h                      |  12 +-
 include/linux/ieee80211-s1g.h                      |   2 +-
 include/linux/inetdevice.h                         |   5 +
 include/linux/iomap.h                              |   2 +
 include/linux/iommu.h                              |   1 +
 include/linux/kernfs.h                             |  11 +-
 include/linux/liveupdate.h                         |   9 +-
 include/linux/mfd/rohm-bd72720.h                   |   1 -
 include/linux/netdevice.h                          |   4 +
 include/linux/nfs_page.h                           |   1 +
 include/linux/nfs_xdr.h                            |   1 -
 include/linux/rhashtable-types.h                   |  22 +-
 include/linux/rpmsg.h                              |   4 -
 include/linux/shmem_fs.h                           |   3 +-
 include/linux/sockptr.h                            |   2 +-
 include/linux/sunrpc/clnt.h                        |   1 +
 include/linux/uaccess.h                            |  27 +-
 include/linux/virtio.h                             |   2 +
 include/linux/vmalloc.h                            |   4 +-
 include/linux/xattr.h                              |  35 +-
 include/net/addrconf.h                             |  10 +-
 include/net/bluetooth/hci.h                        |   5 +-
 include/net/bluetooth/l2cap.h                      |  10 +-
 include/net/bond_options.h                         |   1 +
 include/net/bonding.h                              |   1 +
 include/net/dst_metadata.h                         |   7 +-
 include/net/fib_rules.h                            |   5 +
 include/net/gue.h                                  |   2 +-
 include/net/ip_fib.h                               |  12 +-
 include/net/ip_vs.h                                |   3 +-
 include/net/mana/mana.h                            |   8 +
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |   4 +
 include/net/netfilter/nf_conntrack_expect.h        |  17 +-
 include/net/netfilter/nf_conntrack_extend.h        |  12 -
 include/net/netfilter/nf_conntrack_helper.h        |  18 +-
 include/net/netfilter/nf_conntrack_timeout.h       |  27 +-
 include/net/netfilter/nf_dup_netdev.h              |  36 +-
 include/net/netfilter/nf_flow_table.h              |   5 +-
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/netfilter/nft_meta.h                   |   2 +
 include/net/sch_generic.h                          |  32 +-
 include/net/sctp/sctp.h                            |   3 +-
 include/net/tc_act/tc_pedit.h                      |  18 +-
 include/net/tcp.h                                  |   9 +
 include/net/udp_tunnel.h                           |   4 +-
 include/net/xfrm.h                                 |  15 +-
 include/rdma/frmr_pools.h                          |   3 +-
 include/rdma/ib_umem.h                             |   4 +
 include/rdma/ib_verbs.h                            |   5 +
 include/rdma/rdma_vt.h                             |  20 -
 include/soc/spacemit/k3-syscon.h                   |   4 +-
 include/sound/soc-dapm.h                           |   1 +
 include/trace/events/dma_fence.h                   |  40 +-
 include/uapi/linux/bpf.h                           |   2 +
 include/uapi/linux/if_link.h                       |   1 +
 include/uapi/linux/iommufd.h                       |  12 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |   1 +
 include/uapi/rdma/bnxt_re-abi.h                    |   7 +-
 include/ufs/ufshcd.h                               |   3 -
 init/initramfs_test.c                              |  17 +-
 io_uring/bpf-ops.c                                 |   2 +
 kernel/bpf/arena.c                                 |  61 +-
 kernel/bpf/arraymap.c                              |   8 +-
 kernel/bpf/bpf_lru_list.c                          | 165 +++--
 kernel/bpf/bpf_lru_list.h                          |  25 +-
 kernel/bpf/bpf_lsm.c                               |  23 +
 kernel/bpf/cgroup.c                                | 168 +++--
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/devmap.c                                |  12 +
 kernel/bpf/disasm.c                                |   5 +-
 kernel/bpf/hashtab.c                               |  32 +-
 kernel/bpf/helpers.c                               |  17 +-
 kernel/bpf/inode.c                                 |  13 +-
 kernel/bpf/map_in_map.c                            |   5 +-
 kernel/bpf/map_iter.c                              |   4 +
 kernel/bpf/states.c                                |  13 +-
 kernel/bpf/syscall.c                               |  35 +-
 kernel/bpf/verifier.c                              |  56 +-
 kernel/cgroup/cpuset.c                             |   7 +-
 kernel/cpu.c                                       |  20 +-
 kernel/exit.c                                      |   7 +-
 kernel/fork.c                                      |   9 +-
 kernel/kcov.c                                      |   4 +-
 kernel/kexec_core.c                                |   8 +-
 kernel/liveupdate/kexec_handover.c                 |  32 +-
 kernel/liveupdate/luo_file.c                       |   5 +-
 kernel/liveupdate/luo_flb.c                        |  52 +-
 kernel/liveupdate/luo_session.c                    |  99 ++-
 kernel/locking/spinlock_rt.c                       |  27 +-
 kernel/power/qos.c                                 |  11 +-
 kernel/sched/core.c                                |   1 +
 kernel/sched/cpufreq_schedutil.c                   |   1 +
 kernel/sched/debug.c                               |   3 +
 kernel/sched/fair.c                                | 211 +++---
 kernel/signal.c                                    |  10 +-
 kernel/taskstats.c                                 |  62 +-
 kernel/time/alarmtimer.c                           |   8 +-
 kernel/time/posix-cpu-timers.c                     | 187 ++++--
 kernel/time/posix-timers.c                         |   6 +-
 kernel/time/posix-timers.h                         |   4 +-
 kernel/time/tick-sched.c                           |  11 +-
 kernel/time/time.c                                 |   2 +-
 kernel/time/timer_migration.h                      |  18 +-
 kernel/trace/bpf_trace.c                           |  22 +-
 kernel/trace/fprobe.c                              |  10 +
 kernel/trace/ring_buffer.c                         |   8 +-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_eprobe.c                        |   2 +-
 kernel/trace/trace_events_hist.c                   |  41 +-
 kernel/trace/trace_events_user.c                   |  43 +-
 kernel/trace/trace_osnoise.c                       |   4 +-
 kernel/trace/trace_probe.c                         | 174 ++++-
 kernel/trace/trace_probe.h                         |   7 +-
 kernel/trace/trace_remote.c                        |  18 +-
 kernel/workqueue.c                                 |   2 +-
 lib/Kconfig.debug                                  |   5 +
 lib/alloc_tag.c                                    |   9 +-
 lib/base64.c                                       |   3 +-
 lib/crypto/Kconfig                                 |   3 +-
 lib/fonts/font_acorn_8x8.c                         |   5 +
 lib/locking-selftest.c                             |   7 +-
 lib/rhashtable.c                                   |  17 +-
 lib/test_hmm.c                                     |   6 +-
 lib/test_meminit.c                                 |   2 +-
 lib/tests/kunit_iov_iter.c                         |  12 +-
 lib/tests/liveupdate.c                             |   3 +
 lib/usercopy.c                                     |   4 +-
 lib/vsprintf.c                                     |  36 +-
 mm/compaction.c                                    |   7 +-
 mm/damon/core.c                                    |  59 +-
 mm/damon/sysfs-schemes.c                           |  17 +-
 mm/huge_memory.c                                   |   3 +
 mm/hugetlb.c                                       |   7 +-
 mm/memory_hotplug.c                                |   2 +-
 mm/mm_init.c                                       |  47 +-
 mm/numa_emulation.c                                |  17 +-
 mm/shmem.c                                         |  50 +-
 mm/slub.c                                          |   7 +-
 mm/sparse-vmemmap.c                                |  20 +-
 net/9p/client.c                                    |   2 +
 net/9p/trans_rdma.c                                |  19 +-
 net/9p/trans_virtio.c                              |   5 +
 net/atm/common.c                                   |   2 +
 net/batman-adv/distributed-arp-table.c             |  30 +-
 net/batman-adv/fragmentation.c                     |   8 +-
 net/batman-adv/gateway_client.c                    |   3 +-
 net/batman-adv/main.c                              |  13 +-
 net/batman-adv/mesh-interface.c                    |  17 +-
 net/batman-adv/mesh-interface.h                    |   2 +
 net/batman-adv/multicast_forw.c                    |   7 +-
 net/batman-adv/routing.c                           |   3 +-
 net/batman-adv/translation-table.c                 |   5 +-
 net/bluetooth/6lowpan.c                            |  83 ++-
 net/bluetooth/eir.c                                |   8 +-
 net/bluetooth/hci_codec.c                          |   2 +-
 net/bluetooth/hci_core.c                           |   2 +
 net/bluetooth/hci_event.c                          |   7 +
 net/bluetooth/iso.c                                |  31 +-
 net/bluetooth/l2cap_core.c                         |  94 ++-
 net/bluetooth/l2cap_sock.c                         | 103 ++-
 net/bluetooth/mgmt.c                               |   2 +
 net/bluetooth/msft.c                               |   2 +-
 net/bluetooth/sco.c                                |  15 +-
 net/bluetooth/smp.c                                |  27 +-
 net/bpf/test_run.c                                 |   8 +-
 net/bridge/br_cfm.c                                |   6 +
 net/bridge/br_cfm_netlink.c                        |   4 +-
 net/bridge/br_if.c                                 |   3 +
 net/bridge/br_stp.c                                |   3 +-
 net/bridge/netfilter/nft_meta_bridge.c             |  23 +-
 net/can/bcm.c                                      | 654 ++++++++++++++-----
 net/can/isotp.c                                    | 298 ++++++---
 net/core/dev.c                                     |   9 +-
 net/core/fib_rules.c                               |   6 +-
 net/core/filter.c                                  |  28 +-
 net/core/flow_dissector.c                          |  12 +-
 net/core/lwt_bpf.c                                 |  12 +
 net/core/lwtunnel.c                                |   6 +
 net/core/netdev-genl.c                             |   4 +-
 net/core/netdev_rx_queue.c                         |   8 +-
 net/devlink/rate.c                                 |  25 +-
 net/ethtool/netlink.h                              |  28 +
 net/ethtool/rss.c                                  |  14 +-
 net/handshake/genl.c                               |   2 +-
 net/ieee802154/core.c                              |  49 +-
 net/ieee802154/header_ops.c                        |   9 +-
 net/ieee802154/ieee802154.h                        |  17 +
 net/ieee802154/netlink.c                           |  36 +-
 net/ife/ife.c                                      |   2 +-
 net/ipv4/fib_trie.c                                |   4 +
 net/ipv4/fou_core.c                                |   9 +-
 net/ipv4/igmp.c                                    |  63 +-
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/ip_vti.c                                  |   3 +
 net/ipv4/ipip.c                                    |   3 +
 net/ipv4/netfilter/nf_nat_h323.c                   |  12 +
 net/ipv4/netfilter/nf_nat_pptp.c                   |  14 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c        |  27 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_output.c                              |   8 +-
 net/ipv4/udp_bpf.c                                 |   9 +
 net/ipv4/udp_tunnel_core.c                         |  10 +-
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv4/xfrm4_input.c                             |   2 -
 net/ipv6/addrconf.c                                |  55 +-
 net/ipv6/ioam6_iptunnel.c                          |   8 +-
 net/ipv6/ip6_fib.c                                 |  17 +-
 net/ipv6/ip6_gre.c                                 |   6 +
 net/ipv6/ip6_tunnel.c                              |  10 +
 net/ipv6/ip6_vti.c                                 |   3 +
 net/ipv6/mcast.c                                   |  40 +-
 net/ipv6/ndisc.c                                   |   8 +-
 net/ipv6/netfilter.c                               |   4 +-
 net/ipv6/netfilter/ip6t_ah.c                       |   5 +
 net/ipv6/netfilter/ip6t_hbh.c                      |   1 +
 net/ipv6/netfilter/ip6t_rt.c                       |   3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   3 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6.c                                    |   3 +
 net/ipv6/sit.c                                     |   3 +
 net/ipv6/xfrm6_input.c                             |   2 -
 net/kcm/kcmsock.c                                  |   8 +-
 net/l2tp/l2tp_core.c                               |   2 +-
 net/llc/af_llc.c                                   |   1 +
 net/llc/llc_conn.c                                 |   1 -
 net/mac80211/main.c                                |   3 +-
 net/mac80211/rx.c                                  |  34 +-
 net/mac80211/tx.c                                  |  17 +-
 net/mac80211/util.c                                |   3 +
 net/mac802154/iface.c                              |   2 +-
 net/mac802154/scan.c                               |   1 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  12 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  36 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  18 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  11 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   6 +-
 net/netfilter/nf_conncount.c                       |  23 +-
 net/netfilter/nf_conntrack_amanda.c                |  39 +-
 net/netfilter/nf_conntrack_bpf.c                   |  35 +-
 net/netfilter/nf_conntrack_broadcast.c             |   4 +
 net/netfilter/nf_conntrack_core.c                  | 122 ++--
 net/netfilter/nf_conntrack_ecache.c                |   2 +-
 net/netfilter/nf_conntrack_expect.c                | 184 +++---
 net/netfilter/nf_conntrack_extend.c                |  32 +-
 net/netfilter/nf_conntrack_ftp.c                   |  11 +-
 net/netfilter/nf_conntrack_h323_main.c             | 129 ++--
 net/netfilter/nf_conntrack_helper.c                |  94 ++-
 net/netfilter/nf_conntrack_irc.c                   |  11 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |  20 +-
 net/netfilter/nf_conntrack_netlink.c               |  32 +-
 net/netfilter/nf_conntrack_pptp.c                  |  92 +--
 net/netfilter/nf_conntrack_proto_gre.c             |  70 ++
 net/netfilter/nf_conntrack_sane.c                  |   8 +-
 net/netfilter/nf_conntrack_seqadj.c                |  19 +-
 net/netfilter/nf_conntrack_sip.c                   |  66 +-
 net/netfilter/nf_conntrack_snmp.c                  |  21 +-
 net/netfilter/nf_conntrack_tftp.c                  |   5 +-
 net/netfilter/nf_conntrack_timeout.c               |  27 +-
 net/netfilter/nf_dup_netdev.c                      |  15 +-
 net/netfilter/nf_flow_table_core.c                 |  12 +-
 net/netfilter/nf_flow_table_ip.c                   | 107 +---
 net/netfilter/nf_flow_table_path.c                 |   7 +-
 net/netfilter/nf_nat_core.c                        |  10 +
 net/netfilter/nf_nat_sip.c                         |  23 +
 net/netfilter/nf_queue.c                           |  14 +
 net/netfilter/nf_synproxy_core.c                   |  40 +-
 net/netfilter/nf_tables_api.c                      |   3 +
 net/netfilter/nfnetlink_cthelper.c                 |  81 ++-
 net/netfilter/nfnetlink_cttimeout.c                | 112 ++--
 net/netfilter/nfnetlink_osf.c                      |   6 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +
 net/netfilter/nft_compat.c                         |  24 +-
 net/netfilter/nft_ct.c                             |  29 +-
 net/netfilter/nft_fib.c                            |   9 +
 net/netfilter/nft_fib_netdev.c                     |  29 +-
 net/netfilter/nft_fwd_netdev.c                     |  17 +-
 net/netfilter/nft_lookup.c                         |  10 +-
 net/netfilter/nft_meta.c                           |   5 +-
 net/netfilter/nft_payload.c                        |  16 +-
 net/netfilter/nft_set_pipapo.c                     |  34 +-
 net/netfilter/nft_set_pipapo.h                     |   8 +
 net/netfilter/nft_set_rbtree.c                     |   8 +-
 net/netfilter/nft_synproxy.c                       |   9 +-
 net/netfilter/xt_CT.c                              |   2 +-
 net/netfilter/xt_cluster.c                         |   2 +-
 net/netfilter/xt_connmark.c                        |  14 +-
 net/netfilter/xt_nat.c                             |   9 +
 net/netfilter/xt_physdev.c                         |   5 -
 net/netfilter/xt_rateest.c                         |   2 +-
 net/netfilter/xt_u32.c                             |  12 +-
 net/openvswitch/conntrack.c                        |   2 +-
 net/openvswitch/flow_netlink.c                     | 201 ++++--
 net/psample/psample.c                              |   6 +-
 net/qrtr/af_qrtr.c                                 |   2 +-
 net/rxrpc/ar-internal.h                            |   6 +-
 net/rxrpc/call_accept.c                            |  25 +-
 net/rxrpc/call_event.c                             |   5 +-
 net/rxrpc/call_object.c                            |   2 +
 net/rxrpc/conn_client.c                            |   2 +-
 net/rxrpc/conn_event.c                             |   9 +-
 net/rxrpc/input.c                                  |  39 +-
 net/rxrpc/local_object.c                           |   2 +-
 net/rxrpc/oob.c                                    |  12 +-
 net/rxrpc/recvmsg.c                                |  23 +-
 net/rxrpc/rxgk.c                                   |   3 +-
 net/rxrpc/sendmsg.c                                |   3 +-
 net/sched/act_api.c                                |  13 +-
 net/sched/act_bpf.c                                |   2 +-
 net/sched/act_ct.c                                 |  13 +-
 net/sched/act_pedit.c                              |  13 +-
 net/sched/cls_api.c                                |  25 +-
 net/sched/cls_bpf.c                                |  10 +-
 net/sched/cls_flow.c                               |  12 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_cake.c                               |  13 +-
 net/sched/sch_cbs.c                                |   4 +-
 net/sched/sch_choke.c                              |   8 +-
 net/sched/sch_codel.c                              |  48 +-
 net/sched/sch_drr.c                                |  12 +-
 net/sched/sch_dualpi2.c                            | 122 ++--
 net/sched/sch_etf.c                                |   8 +-
 net/sched/sch_ets.c                                |   4 +-
 net/sched/sch_fq.c                                 |   6 +-
 net/sched/sch_fq_codel.c                           |  48 +-
 net/sched/sch_fq_pie.c                             |   4 +-
 net/sched/sch_generic.c                            |  51 +-
 net/sched/sch_hfsc.c                               |  28 +-
 net/sched/sch_hhf.c                                |  34 +-
 net/sched/sch_htb.c                                |  18 +-
 net/sched/sch_mq.c                                 |   5 +-
 net/sched/sch_mqprio.c                             |  18 +-
 net/sched/sch_multiq.c                             |   6 +-
 net/sched/sch_netem.c                              |  10 +-
 net/sched/sch_prio.c                               |   4 +-
 net/sched/sch_qfq.c                                |   6 +-
 net/sched/sch_red.c                                |   4 +-
 net/sched/sch_sfb.c                                |   4 +-
 net/sched/sch_sfq.c                                |   9 +-
 net/sched/sch_skbprio.c                            |   4 +-
 net/sched/sch_taprio.c                             |   6 +-
 net/sched/sch_tbf.c                                |   6 +-
 net/sched/sch_teql.c                               | 128 ++--
 net/sctp/diag.c                                    |  67 +-
 net/sctp/protocol.c                                |  13 +-
 net/sctp/sm_make_chunk.c                           |  15 +-
 net/sctp/sm_statefuns.c                            |  64 +-
 net/sctp/socket.c                                  |  38 +-
 net/smc/smc_cdc.c                                  |  15 +-
 net/socket.c                                       |  30 +-
 net/sunrpc/clnt.c                                  |  19 +-
 net/sunrpc/svc.c                                   |  10 +
 net/sunrpc/svcsock.c                               |  10 +
 net/sunrpc/sysfs.c                                 |   4 +-
 net/sunrpc/xdr.c                                   |  14 +-
 net/sunrpc/xprtrdma/backchannel.c                  |   5 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     | 157 +++--
 net/sunrpc/xprtrdma/transport.c                    |  68 +-
 net/sunrpc/xprtrdma/verbs.c                        | 126 +++-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   4 +-
 net/sunrpc/xprtsock.c                              |  16 +-
 net/tipc/bearer.c                                  |   1 +
 net/tipc/core.c                                    |   9 +-
 net/tipc/discover.c                                |  14 +-
 net/tipc/name_distr.c                              |  13 +-
 net/tipc/netlink.c                                 |  12 +
 net/tipc/socket.c                                  |   9 +-
 net/tipc/udp_media.c                               |  53 +-
 net/tls/tls_sw.c                                   |  11 +
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/pmsr.c                                |   4 +-
 net/wireless/scan.c                                |   5 +-
 net/xfrm/espintcp.c                                |  34 +-
 net/xfrm/xfrm_input.c                              |  29 +-
 net/xfrm/xfrm_interface_core.c                     |   3 +
 net/xfrm/xfrm_nat_keepalive.c                      |  15 +-
 net/xfrm/xfrm_policy.c                             |  27 +-
 net/xfrm/xfrm_state.c                              |  26 +-
 net/xfrm/xfrm_user.c                               |  20 +-
 rust/Makefile                                      |   2 +-
 rust/helpers/uaccess.c                             |   2 +-
 rust/kernel/alloc/kvec.rs                          |   4 +-
 rust/kernel/devres.rs                              |   6 +-
 samples/damon/mtier.c                              |   3 +
 samples/trace_events/trace-events-sample.c         |   4 +
 scripts/kconfig/conf.c                             |   6 +-
 scripts/livepatch/klp-build                        |  41 +-
 security/apparmor/af_unix.c                        |  65 +-
 security/apparmor/apparmorfs.c                     | 113 +++-
 security/apparmor/domain.c                         |  58 +-
 security/apparmor/file.c                           |  12 +-
 security/apparmor/include/apparmorfs.h             |  12 +
 security/apparmor/label.c                          |   2 +-
 security/apparmor/lsm.c                            |   2 +-
 security/apparmor/net.c                            |   1 +
 security/apparmor/policy.c                         |  20 +-
 security/apparmor/policy_unpack.c                  |   6 +-
 security/apparmor/procattr.c                       |   2 +
 security/apparmor/task.c                           |   2 +-
 security/integrity/evm/evm_secfs.c                 |  16 +-
 security/integrity/ima/ima_appraise.c              |   5 +-
 security/integrity/ima/ima_policy.c                |   3 +-
 security/keys/keyring.c                            |   2 +-
 security/landlock/fs.c                             |  14 +
 security/landlock/fs.h                             |  10 +
 security/landlock/net.c                            |  11 +-
 security/landlock/task.c                           |  11 +
 security/selinux/hooks.c                           |  80 ++-
 sound/core/init.c                                  |  11 +-
 sound/core/pcm_compat.c                            |   4 +-
 sound/core/pcm_native.c                            |   7 +-
 sound/core/seq/oss/seq_oss_event.c                 |   6 +-
 sound/core/seq/oss/seq_oss_event.h                 |   3 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |   5 +-
 sound/core/seq/oss/seq_oss_midi.c                  |   6 +-
 sound/core/seq/oss/seq_oss_midi.h                  |   2 +-
 sound/core/seq/oss/seq_oss_readq.c                 |  77 ++-
 sound/core/seq/oss/seq_oss_rw.c                    |   5 +-
 sound/core/seq/seq_clientmgr.c                     |  33 +-
 sound/core/seq/seq_fifo.c                          |  52 +-
 sound/core/seq/seq_memory.c                        |   2 +-
 sound/core/seq/seq_midi.c                          |  55 +-
 sound/drivers/aloop.c                              |   1 -
 sound/hda/codecs/conexant.c                        |   3 -
 sound/hda/codecs/realtek/alc269.c                  |  12 +-
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |   3 +
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c     |   3 +
 sound/hda/controllers/Kconfig                      |   2 +-
 sound/hda/core/regmap.c                            |   4 +-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c            |   7 +-
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |   7 +-
 sound/soc/codecs/adau1372.c                        |   5 +
 sound/soc/codecs/aw88261.c                         |  12 +-
 sound/soc/codecs/cs35l56-shared.c                  |   4 +-
 sound/soc/codecs/cs35l56.c                         |  27 +-
 sound/soc/codecs/cs530x.c                          |  29 +-
 sound/soc/codecs/cs530x.h                          |   6 -
 sound/soc/codecs/hdac_hdmi.c                       |   4 +-
 sound/soc/codecs/lpass-va-macro.c                  |   7 +-
 sound/soc/codecs/rt5575-spi.c                      |   2 +-
 sound/soc/codecs/sma1307.c                         |  35 +-
 sound/soc/codecs/tlv320aic3x.c                     |  25 +-
 sound/soc/codecs/wm_adsp.c                         |   7 +
 sound/soc/fsl/fsl_asrc_dma.c                       |  20 +
 sound/soc/fsl/fsl_audmix.c                         |   6 +
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  23 +-
 sound/soc/mediatek/mt8189/mt8189-afe-pcm.c         |  38 +-
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |  21 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |   3 +
 sound/soc/meson/aiu-codec-ctrl.c                   |   3 +
 sound/soc/qcom/qdsp6/q6apm.c                       |   8 +
 sound/soc/renesas/rcar/rsnd.h                      |   2 +-
 sound/soc/sdca/sdca_asoc.c                         |   3 +
 sound/soc/sdw_utils/soc_sdw_utils.c                |   1 +
 sound/soc/soc-dapm.c                               |  49 +-
 sound/soc/soc-topology.c                           |  37 +-
 sound/soc/sof/intel/Kconfig                        |   6 +-
 sound/soc/sof/ipc3-control.c                       |  79 ++-
 sound/soc/sof/ipc4-control.c                       |  34 +-
 sound/soc/sof/topology.c                           |   7 +-
 sound/soc/tegra/tegra210_ahub.c                    |   4 +-
 sound/usb/fcp.c                                    |   2 +
 sound/usb/midi2.c                                  |   5 +
 sound/usb/mixer_scarlett2.c                        | 201 +++++-
 sound/usb/qcom/mixer_usb_offload.c                 |   2 +-
 sound/usb/qcom/qc_audio_offload.c                  |  30 +-
 sound/xen/xen_snd_front_alsa.c                     |  17 +-
 sound/xen/xen_snd_front_evtchnl.c                  |  28 +-
 sound/xen/xen_snd_front_evtchnl.h                  |   6 +-
 tools/bpf/bpftool/cgroup.c                         |  14 +-
 tools/bpf/bpftool/gen.c                            |   2 +-
 tools/bpf/bpftool/net.c                            |   4 +-
 tools/include/nolibc/getopt.h                      |   2 +-
 tools/include/nolibc/stackprotector.h              |   3 +-
 tools/include/uapi/linux/bpf.h                     |   2 +
 tools/include/uapi/linux/if_link.h                 |   2 +
 tools/lib/api/fs/fs.c                              |  19 +-
 tools/lib/bpf/btf.c                                |   4 +-
 tools/lib/bpf/gen_loader.c                         |  81 ++-
 tools/lib/bpf/libbpf.c                             |   9 +-
 tools/lib/bpf/strset.c                             |  62 +-
 tools/lib/bpf/usdt.c                               |  16 +-
 tools/lib/symbol/kallsyms.c                        |   5 +-
 tools/net/ynl/Makefile                             |   2 +-
 tools/net/ynl/generated/Makefile                   |   2 +-
 tools/net/ynl/lib/Makefile                         |   2 +-
 tools/objtool/elf.c                                |  75 +--
 tools/objtool/include/objtool/elf.h                |  32 +-
 tools/objtool/klp-diff.c                           | 133 ++--
 tools/perf/Makefile.config                         |   1 +
 tools/perf/arch/common.c                           |   4 +-
 tools/perf/arch/powerpc/util/auxtrace.c            |   6 +
 tools/perf/arch/x86/tests/amd-ibs-period.c         |   2 +-
 tools/perf/bench/inject-buildid.c                  |   9 +-
 tools/perf/builtin-annotate.c                      |   3 +-
 tools/perf/builtin-buildid-list.c                  |   4 +-
 tools/perf/builtin-c2c.c                           |  28 +-
 tools/perf/builtin-diff.c                          |   3 +-
 tools/perf/builtin-inject.c                        | 172 ++++-
 tools/perf/builtin-record.c                        |   2 +
 tools/perf/builtin-report.c                        |   7 +-
 tools/perf/builtin-sched.c                         | 177 +++--
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/builtin-stat.c                          |  50 +-
 tools/perf/pmu-events/amd_metrics.py               |   2 +-
 tools/perf/pmu-events/metric.py                    |   1 -
 tools/perf/tests/code-reading.c                    |   7 +-
 tools/perf/tests/dlfilter-test.c                   |   8 +-
 tools/perf/tests/pmu-events.c                      |  24 +-
 tools/perf/tests/sample-parsing.c                  |   5 +-
 tools/perf/ui/browser.c                            |   3 +
 tools/perf/ui/browsers/annotate.c                  |   5 +-
 tools/perf/util/Build                              |   1 +
 tools/perf/util/annotate-data.c                    |  27 +-
 tools/perf/util/arm-spe.c                          |  28 +-
 tools/perf/util/auxtrace.c                         |   3 +-
 tools/perf/util/bpf-event.c                        |  52 +-
 tools/perf/util/bpf-event.h                        |   4 +-
 tools/perf/util/bpf-utils.c                        |  16 +
 tools/perf/util/build-id.c                         |   7 +-
 tools/perf/util/callchain.c                        |  15 +
 tools/perf/util/callchain.h                        |   1 +
 tools/perf/util/config.c                           |   4 +
 tools/perf/util/cpumap.c                           |  49 +-
 tools/perf/util/cs-etm-base.c                      |   4 +-
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  21 +-
 tools/perf/util/cs-etm.c                           | 310 ++++++---
 tools/perf/util/cs-etm.h                           |   8 +-
 tools/perf/util/data-convert-json.c                |   1 +
 tools/perf/util/debuginfo.c                        |   9 +-
 tools/perf/util/disasm.c                           |   7 +-
 tools/perf/util/dso.c                              |  48 +-
 tools/perf/util/dwarf-aux.c                        |  39 +-
 tools/perf/util/dwarf-aux.h                        |   5 +
 tools/perf/util/env.h                              |  14 +
 tools/perf/util/event.c                            |  15 +-
 tools/perf/util/header.c                           |  91 ++-
 tools/perf/util/hist.c                             |   9 +-
 tools/perf/util/hist.h                             |   1 +
 tools/perf/util/hwmon_pmu.c                        |  36 +-
 tools/perf/util/intel-bts.c                        |   3 +-
 .../util/intel-pt-decoder/intel-pt-insn-decoder.c  |  11 +-
 tools/perf/util/intel-pt.c                         |  35 +-
 tools/perf/util/libdw.c                            |  49 +-
 tools/perf/util/machine.c                          |  42 +-
 tools/perf/util/maps.c                             | 156 ++++-
 tools/perf/util/maps.h                             |   3 +
 tools/perf/util/mmap.c                             |  20 +-
 tools/perf/util/pmu.c                              |  10 +-
 tools/perf/util/probe-finder.c                     | 102 +--
 tools/perf/util/svghelper.c                        |  10 +-
 tools/perf/util/symbol-elf.c                       | 121 ++--
 tools/perf/util/symbol-minimal.c                   |  16 +-
 tools/perf/util/symbol.c                           |  19 +-
 tools/perf/util/symbol_conf.h                      |  10 +
 tools/perf/util/synthetic-events.c                 |  25 +-
 tools/perf/util/synthetic-events.h                 |   6 +-
 tools/perf/util/thread.c                           |   5 +
 tools/perf/util/tool.c                             |   6 +
 tools/perf/util/unwind-libdw.c                     |  20 +-
 tools/perf/util/unwind-libunwind-local.c           |  27 +-
 tools/perf/util/unwind-libunwind.c                 |   2 +-
 tools/perf/util/unwind.c                           | 104 +++
 tools/perf/util/unwind.h                           |  65 +-
 tools/power/x86/intel-speed-select/isst-daemon.c   |   9 +-
 tools/testing/cxl/test/cxl.c                       |  10 +-
 tools/testing/cxl/test/cxl_translate.c             |   2 +-
 tools/testing/cxl/test/mem.c                       |  45 +-
 tools/testing/kunit/kunit_parser.py                |  12 +-
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/bpf/README.rst             |   2 +-
 .../selftests/bpf/prog_tests/bpf_attr_size.c       |  69 ++
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   6 +
 .../selftests/bpf/prog_tests/fill_link_info.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/htab_update.c |   4 +-
 .../testing/selftests/bpf/prog_tests/linked_list.c |  33 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |  10 +-
 .../prog_tests/raw_tp_writable_reject_bad_access.c |  57 ++
 .../raw_tp_writable_reject_nbd_invalid.c           |  43 --
 .../selftests/bpf/prog_tests/refcounted_kptr.c     |   8 +-
 tools/testing/selftests/bpf/prog_tests/verifier.c  |   2 +
 .../selftests/bpf/prog_tests/verifier_log.c        |   1 +
 .../selftests/bpf/progs/bpf_iter_task_vmas.c       |   2 +-
 .../testing/selftests/bpf/progs/cpumask_success.c  |   2 +-
 tools/testing/selftests/bpf/progs/file_reader.c    |   2 +-
 tools/testing/selftests/bpf/progs/htab_update.c    |   4 +-
 tools/testing/selftests/bpf/progs/linked_list.c    |  71 +++
 .../testing/selftests/bpf/progs/refcounted_kptr.c  |  20 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  26 +
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  13 +-
 .../testing/selftests/bpf/progs/verifier_bounds.c  |  14 +-
 .../selftests/bpf/progs/verifier_ptr_to_buf.c      |  27 +
 .../selftests/bpf/progs/verifier_raw_tp_writable.c |  16 +
 tools/testing/selftests/bpf/progs/xdp_flowtable.c  |   7 +-
 tools/testing/selftests/bpf/vmtest.sh              |   2 +-
 tools/testing/selftests/drivers/net/hw/tso.py      |  16 +-
 .../ftrace/test.d/00basic/test_ownership.tc        |   2 +-
 .../ftrace/test.d/00basic/trace_marker_raw.tc      |  14 +-
 tools/testing/selftests/gpio/.gitignore            |   1 +
 tools/testing/selftests/hid/Makefile               |   2 +-
 tools/testing/selftests/hid/hid_bpf.c              |  36 +-
 tools/testing/selftests/hid/progs/hid.c            |  15 +
 .../selftests/landlock/scoped_signal_test.c        | 237 ++++++-
 .../selftests/mm/charge_reserved_hugetlb.sh        |  45 +-
 tools/testing/selftests/mm/compaction_test.c       |   3 +
 tools/testing/selftests/mm/hmm-tests.c             | 125 +++-
 tools/testing/selftests/mm/hugepage-mremap.c       |  32 +-
 .../selftests/mm/hugetlb_reparenting_test.sh       |  60 +-
 tools/testing/selftests/mm/pkey-arm64.h            |   3 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  66 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  27 +-
 tools/testing/selftests/mm/uffd-stress.c           |   5 +-
 tools/testing/selftests/net/broadcast_ether_dst.sh |   2 +-
 tools/testing/selftests/net/lib.sh                 |  25 +-
 .../selftests/net/netfilter/nft_flowtable.sh       |   8 +-
 tools/testing/selftests/net/tcp_mmap.c             |   4 +
 tools/testing/selftests/net/tls.c                  |   8 +-
 tools/testing/selftests/net/vlan_bridge_binding.sh |   2 +-
 tools/testing/selftests/rseq/Makefile              |   6 +-
 tools/testing/selftests/vfio/Makefile              |   7 +-
 tools/testing/selftests/vfio/lib/libvfio.mk        |   6 +-
 tools/tracing/rtla/src/actions.c                   |   2 +
 tools/tracing/rtla/src/common.c                    |  19 +-
 tools/tracing/rtla/src/common.h                    |   1 -
 tools/tracing/rtla/src/timerlat.c                  |   2 +-
 tools/tracing/rtla/src/timerlat_hist.c             |   4 +-
 tools/tracing/rtla/src/timerlat_top.c              |   3 +-
 tools/virtio/vringh_test.c                         |   5 +
 virt/kvm/kvm_main.c                                |  16 +-
 1929 files changed, 28193 insertions(+), 14617 deletions(-)


