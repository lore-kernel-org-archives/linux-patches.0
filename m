Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4944F1DDA3B;
	Mon,  6 Jan 2025 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178628; cv=none; b=lBWSlnfyg2SaL5PCE4mrfglVxKmZnixCCKC2ljPkWQHHkbjAMbTnXwt3AH3t9uSEg/nR5imQ2iZXErjGM2ofAhTbtow7z+9Bf9xwpBrCmqSIXw1UZE+MKailvMZc0RFACqOIfFNQ/0+MS3uZx6WAvuv8lNX2gmhLY6Yl0TvX7wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178628; c=relaxed/simple;
	bh=ygSaCPltoB72biCwrLrCaMKfrJrfsOggjbAYv2T6Xic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xzr7oFl/BZY2aMzUeAyjrBMGxZTqqGZ5TbVpUPxoBOXxYo9MvxkPuEqPggBR3qQf5hNYYQTleVry/J3Fp3zTJOeCZBCIZa6X28Ycs/QoAayo4loJLReTiKb9vnSKP69SEatO2eWQvd5lWhhS91nKxd1RLSuM1ueC0awsFeqXhJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0bMs8m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0bMs8m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C3AC4CED2;
	Mon,  6 Jan 2025 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178628;
	bh=ygSaCPltoB72biCwrLrCaMKfrJrfsOggjbAYv2T6Xic=;
	h=From:To:Cc:Subject:Date:From;
	b=R0bMs8m/CBPmObc+pXesnHEaURptb3UU3GVNtmnDpKdYe8AZTjF+DDv4LQ4QYvsLZ
	 TYUzNoUuGoff4VKHsquSaH/asm0VkPEu6BFAbuTqnspuYCz/0tPzwGYd5QX7DTfGIN
	 irACcYNfn6EI71phv3jFGX/GzhFVCjP5YC3OejQc=
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
Subject: [PATCH 5.15 000/168] 5.15.176-rc1 review
Date: Mon,  6 Jan 2025 16:15:08 +0100
Message-ID: <20250106151138.451846855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.176-rc1
X-KernelTest-Deadline: 2025-01-08T15:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.176 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.176-rc1

Seiji Nishikawa <snishika@redhat.com>
    mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()

Biju Das <biju.das.jz@bp.renesas.com>
    dt-bindings: display: adi,adv7533: Drop single lane support

Biju Das <biju.das.jz@bp.renesas.com>
    drm: adv7511: Drop dsi single lane support

Nikolay Kuratov <kniv@yandex-team.ru>
    net/sctp: Prevent autoclose integer overflow in sctp_association_init()

Pascal Hambourg <pascal@plouf.fr.eu.org>
    sky2: Add device ID 11ab:4373 for Marvell 88E8075

Evgenii Shatokhin <e.shatokhin@yadro.com>
    pinctrl: mcp23s08: Fix sleeping in atomic context due to regmap locking

Dan Carpenter <dan.carpenter@linaro.org>
    RDMA/uverbs: Prevent integer overflow issue

Arnd Bergmann <arnd@arndb.de>
    kcov: mark in_softirq_really() as __always_inline

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix the missed iteration for the max bit in do_input()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix input MODULE_DEVICE_TABLE() built for 64-bit on 32-bit host

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid queuing redundant Stop Endpoint commands

Leon Romanovsky <leon@kernel.org>
    ARC: build: Try to guess GCC variant of cross compiler

Uros Bizjak <ubizjak@gmail.com>
    irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FE910C04 compositions

Anton Protopopov <aspsk@isovalent.com>
    bpf: fix potential error return

Adrian Ratiu <adrian.ratiu@collabora.com>
    sound: usb: format: don't warn that raw DSD is unsupported

Adrian Ratiu <adrian.ratiu@collabora.com>
    sound: usb: enable DSD output for ddHiFi TC44C

Filipe Manana <fdmanana@suse.com>
    btrfs: flush delalloc workers queue before stopping cleaner kthread during unmount

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: Correct the migration DMA map direction

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: mac80211: wake the queues in case of failure in resume

Qu Wenruo <wqu@suse.com>
    btrfs: sysfs: fix direct super block member reads

Anand Jain <anand.jain@oracle.com>
    btrfs: sysfs: convert scnprintf and snprintf to sysfs_emit

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when COWing tree bock and tracing is enabled

Filipe Manana <fdmanana@suse.com>
    btrfs: rename and export __btrfs_cow_block()

Eric Dumazet <edumazet@google.com>
    ila: serialize calls to nf_register_net_hooks()

Eric Dumazet <edumazet@google.com>
    af_packet: fix vlan_get_protocol_dgram() vs MSG_PEEK

Eric Dumazet <edumazet@google.com>
    af_packet: fix vlan_get_tci() vs MSG_PEEK

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init()

Eric Dumazet <edumazet@google.com>
    net: restrict SO_REUSEPORT to inet sockets

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rtrs: Ensure 'ib_sge list' is accessible

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: mv643xx_eth: fix an OF node reference leak

Vitalii Mordan <mordan@ispras.ru>
    eth: bcmsysport: fix call balance of priv->clk handling routines

Tanya Agarwal <tanyaagarwal25699@gmail.com>
    ALSA: usb-audio: US16x08: Initialize array before use

Antonio Pastor <antonio.pastor@gmail.com>
    net: llc: reset skb->transport_header

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/dg1: Fix power gate sequence.

Ilya Shchipletsov <rabbelkin@mail.ru>
    netrom: check buffer length before accessing it

Wang Liang <wangliang74@huawei.com>
    net: fix memory leak in tcp_conn_request()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: stmmac: restructure the error path of stmmac_probe_config_dt()

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: don't create a MDIO bus if unnecessary

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    net: stmmac: platform: provide devm_stmmac_probe_config_dt()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing flush CQE for DWQE

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix warning storm caused by invalid input in IO path

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix mapping error of zero-hop WQE buffer

Yunsheng Lin <linyunsheng@huawei.com>
    RDMA/hns: Remove redundant 'bt_level' for hem_list_alloc_item()

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Remove redundant 'attr_mask' in modify_qp_init_to_init()

Stefan Ekenberg <stefan.ekenberg@axis.com>
    drm/bridge: adv7511_audio: Update Audio InfoFrame properly

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the locking while accessing the QP table

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix max_qp_wrs reported

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix reporting hw_ver in query_device

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Add check for path mtu in modify_qp

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Enforce same type port association for multiport RoCE

Kairui Song <kasong@tencent.com>
    zram: fix uninitialized ZRAM not releasing backing device

Sergey Senozhatsky <senozhatsky@chromium.org>
    drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Limit Stop Endpoint retries

Michal Pecio <michal.pecio@gmail.com>
    xhci: retry Stop Endpoint on buggy NEC controllers

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Panther Lake-M/P

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Lunar Lake

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add Intel Barlow Ridge PCI ID

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Meteor Lake

George D Sworo <george.d.sworo@intel.com>
    thunderbolt: Add support for Intel Raptor Lake

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have process_string() also allow arrays

Thiébaud Weksteen <tweek@google.com>
    selinux: ignore unknown extended permissions

Naman Jain <namjain@linux.microsoft.com>
    x86/hyperv: Fix hv tsc page based sched_clock for hibernation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: improve shutdown sequence

Yang Erkun <yangerkun@huaweicloud.com>
    nfsd: cancel nfsd_shrinker_work using sync mode in nfs4_state_shutdown_net

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Dimitri Fedrau <dimitri.fedrau@liebherr.com>
    power: supply: gpio-charger: Fix set charge current limits

Lizhi Xu <lizhi.xu@windriver.com>
    tracing: Prevent bad count for tracing_cpumask_write

Christian Göttsche <cgzones@googlemail.com>
    tracing: Constify string literal data member in struct trace_event_call

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix IPIs usage in kfence_protect_page()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix racy issue from session lookup and expire

Kees Cook <kees@kernel.org>
    lib: stackinit: hide never-taken branch from compiler

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Verify request type in the corresponding down message reply

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: mm: Rename asid2idx() to ctxid2asid()

Peterson Guo <peterson.guo@amd.com>
    drm/amd/display: Add a left edge pixel if in YCbCr422 or YCbCr420 and odm

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix MST sideband message body length check

Hou Tao <houtao1@huawei.com>
    bpf: Check validity of link->type in bpf_link_show_fdinfo()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Probe toolchain support of -msym32

Matthew Wilcox (Oracle) <willy@infradead.org>
    vmalloc: fix accounting with i915

Ming Lei <ming.lei@redhat.com>
    virtio-blk: don't keep queue frozen during system suspend

Cathy Avery <cavery@redhat.com>
    scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-nb-wmi: Ignore unknown event 0xCF

Mark Brown <broonie@kernel.org>
    regmap: Use correct format specifier for logging range errors

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: fix Z60MR100 startup pop issue

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix for a potential deadlock

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix hw revision numbering for ISP1020/1040

James Hilliard <james.hilliard1@gmail.com>
    watchdog: it87_wdt: add PWRGD enable quirk for Qotom QCML04

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobe: Make trace_kprobe's module callback called after jump_label update

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: rawnand: fix double free in atmel_pmecc_create_user()

Chen Ridong <chenridong@huawei.com>
    dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Select only supported masters for ACPI devices

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    dmaengine: mv_xor: fix child node refcount handling in early exit

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_phy_destroy() fails to destroy the phy

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_phy_put() fails to release the phy

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix an OF node refcount leakage in _of_phy_get()

Maciej Andrzejewski <maciej.andrzejewski@m-works.net>
    mtd: rawnand: arasan: Fix missing de-registration of NAND

Maciej Andrzejewski <maciej.andrzejewski@m-works.net>
    mtd: rawnand: arasan: Fix double assertion of chip-select

Zichen Xie <zichenxie0106@gmail.com>
    mtd: diskonchip: Cast an operand to prevent potential overflow

NeilBrown <neilb@suse.de>
    nfsd: restore callback functionality for NFSv4.0

Cong Wang <cong.wang@bytedance.com>
    bpf: Check negative offsets in __bpf_skb_min_len()

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Add sk_rmem_alloc related logic for tcp_bpf ingress redirection

Cong Wang <cong.wang@bytedance.com>
    tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()

Bart Van Assche <bvanassche@acm.org>
    mm/vmstat: fix a W=1 clang compiler warning

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu: Handle NULL bo->tbo.resource (again) in amdgpu_vm_bo_update

Xuewen Yan <xuewen.yan@unisoc.com>
    epoll: Add synchronous wakeup support for ep_poll_callback

Ilya Dryomov <idryomov@gmail.com>
    ceph: validate snapdirname option length when mounting

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix refcount leakage for OF node returned by __of_get_dma_parent()

Herve Codina <herve.codina@bootlin.com>
    of: Fix error path in of_parse_phandle_with_args_map()

Jann Horn <jannh@google.com>
    udmabuf: also check for F_SEAL_FUTURE_WRITE

Edward Adam Davis <eadavis@qq.com>
    nilfs2: prevent use of deleted inode

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix using uninitialized variable @addr_len in API of_irq_parse_one()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pnfs: Fix a live lock between recalled layouts and layoutget

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add "%s" check in test_event_printk()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add missing helper functions in event pointer dereference check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix test_event_printk() to process entire print argument

Sean Christopherson <seanjc@google.com>
    KVM: x86: Play nice with protected guests in complete_hypercall_exit()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: util: Avoid accessing a ringbuffer not initialized yet

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: reject inline extent items with 0 ref count

Kairui Song <kasong@tencent.com>
    zram: refuse to use zero sized block device as backing device

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: clk: Fix clk_enable() to return 0 on NULL clk

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix interpretation of values of Temperature Result and Limit Registers

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix Current Register value interpretation

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Use SI constants from units.h

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Simplify with dev_err_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Don't use "proxy" headers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/modes: Avoid divide by zero harder in drm_mode_vrefresh()

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FE910C04 rmnet compositions

Jack Wu <wojackbb@gmail.com>
    USB: serial: option: add MediaTek T7XX compositions

Mank Wang <mank.wang@netprisma.com>
    USB: serial: option: add Netprisma LCUK54 modules for WWAN Ready

Michal Hrusecky <michal.hrusecky@turris.com>
    USB: serial: option: add MeiG Smart SLM770A

Daniel Swanemar <d.swanemar@gmail.com>
    USB: serial: option: add TCL IK512 MBIM & ECM

James Bottomley <James.Bottomley@HansenPartnership.com>
    efivarfs: Fix error on non-existent file

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: riic: Always round-up when calculating bus period

Dan Carpenter <dan.carpenter@linaro.org>
    chelsio/chtls: prevent potential integer overflow on 32bit

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: mdiobus: fix an OF node reference leak

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Fix for recursive locking warning

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: ethernet: bgmac-platform: fix an OF node reference leak

Dan Carpenter <dan.carpenter@linaro.org>
    net: hinic: Fix cleanup in create_rxqs/txqs()

Shannon Nelson <shannon.nelson@amd.com>
    ionic: use ee->offset when returning sprom data

Brett Creeley <brett.creeley@amd.com>
    ionic: Fix netdev notifier unregister on failure

Eric Dumazet <edumazet@google.com>
    netdevsim: prevent bad user input in nsim_dev_health_break_write()

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check return value of sock_recvmsg when draining clc data

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check smcd_v2_ext_offset when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check sndbuf_space again after NOSPACE flag is set in smc_poll

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix incorrect symlink detection in fast symlink

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    i2c: pnx: Fix timeout in wait functions

Peng Hongchi <hongchi.peng@siengine.com>
    usb: dwc2: gadget: Don't write invalid mapped sg entries into dma_desc with iommu enabled

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix msi node for ls7a

Ajit Khaparde <ajit.khaparde@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM5760X NIC

Jiwei Sun <sunjw10@lenovo.com>
    PCI: vmd: Create domain symlink before pci_bus_add_devices()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: fix jack detection on ADL-N variant RVP

Roger Quadros <rogerq@kernel.org>
    usb: cdns3: Add quirk flag to enable suspend residency

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UBSAN warning in parse_audio_unit()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI/AER: Disable AER service on suspend

Vidya Sagar <vidyas@nvidia.com>
    PCI: Use preserve_config in place of pci_flags

Lion Ackermann <nnamrec@gmail.com>
    net: sched: fix ordering of qlen adjustment


-------------

Diffstat:

 .../bindings/display/bridge/adi,adv7533.yaml       |   2 +-
 Makefile                                           |   4 +-
 arch/arc/Makefile                                  |   2 +-
 arch/arm64/mm/context.c                            |  22 +--
 arch/mips/Makefile                                 |   2 +-
 .../boot/dts/loongson/loongson64g_4core_ls7a.dts   |   1 +
 arch/riscv/include/asm/kfence.h                    |   4 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  58 ++++++
 arch/x86/kvm/x86.c                                 |   2 +-
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/block/zram/zram_drv.c                      |  28 +--
 drivers/clocksource/hyperv_timer.c                 |  14 +-
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/at_xdmac.c                             |   2 +
 drivers/dma/dw/acpi.c                              |   6 +-
 drivers/dma/dw/internal.h                          |   8 +
 drivers/dma/dw/pci.c                               |   4 +-
 drivers/dma/mv_xor.c                               |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   4 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  23 +++
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  14 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  34 ++++
 drivers/gpu/drm/drm_modes.c                        |  11 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |   2 +-
 drivers/hv/hv_kvp.c                                |   6 +
 drivers/hv/hv_snapshot.c                           |   6 +
 drivers/hv/hv_util.c                               |   9 +
 drivers/hv/hyperv_vmbus.h                          |   2 +
 drivers/hwmon/tmp513.c                             |  74 +++----
 drivers/i2c/busses/i2c-pnx.c                       |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/infiniband/core/uverbs_cmd.c               |  16 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  28 +--
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  49 +++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  17 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 -
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/irqchip/irq-gic.c                          |   2 +-
 drivers/media/dvb-frontends/dib3000mb.c            |   2 +-
 drivers/mmc/host/sdhci-tegra.c                     |   1 -
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  11 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   4 +-
 drivers/mtd/nand/raw/diskonchip.c                  |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  21 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   5 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c       |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   2 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  14 +-
 drivers/net/ethernet/marvell/sky2.c                |   1 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 153 ++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_platform.h  |   2 +
 drivers/net/mdio/fwnode_mdio.c                     |  13 +-
 drivers/net/netdevsim/health.c                     |   2 +
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |   2 +-
 drivers/of/address.c                               |   2 +-
 drivers/of/base.c                                  |  15 +-
 drivers/of/irq.c                                   |   1 +
 drivers/pci/controller/pci-host-common.c           |   4 -
 drivers/pci/controller/vmd.c                       |   8 +-
 drivers/pci/pcie/aer.c                             |  18 ++
 drivers/pci/probe.c                                |  22 +--
 drivers/pci/quirks.c                               |   4 +
 drivers/phy/phy-core.c                             |  21 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   6 +
 drivers/platform/x86/asus-nb-wmi.c                 |   1 +
 drivers/power/supply/gpio-charger.c                |   8 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   7 +-
 drivers/scsi/qla1280.h                             |  12 +-
 drivers/scsi/storvsc_drv.c                         |   7 +-
 drivers/sh/clk/core.c                              |   2 +-
 drivers/thunderbolt/icm.c                          |   5 +
 drivers/thunderbolt/nhi.c                          |  24 +++
 drivers/thunderbolt/nhi.h                          |  13 ++
 drivers/usb/cdns3/core.h                           |   1 +
 drivers/usb/cdns3/drd.c                            |  10 +-
 drivers/usb/cdns3/drd.h                            |   3 +
 drivers/usb/dwc2/gadget.c                          |   4 +-
 drivers/usb/host/xhci-ring.c                       |  42 +++-
 drivers/usb/host/xhci.c                            |  21 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/serial/option.c                        |  27 +++
 drivers/watchdog/it87_wdt.c                        |  39 ++++
 fs/btrfs/ctree.c                                   |  37 ++--
 fs/btrfs/ctree.h                                   |   7 +
 fs/btrfs/disk-io.c                                 |   9 +
 fs/btrfs/inode.c                                   |   2 +
 fs/btrfs/sysfs.c                                   |  93 +++++----
 fs/btrfs/tree-checker.c                            |  27 ++-
 fs/ceph/super.c                                    |   2 +
 fs/efivarfs/inode.c                                |   2 +-
 fs/efivarfs/internal.h                             |   1 -
 fs/efivarfs/super.c                                |   3 -
 fs/erofs/inode.c                                   |  20 +-
 fs/eventpoll.c                                     |   5 +-
 fs/ksmbd/auth.c                                    |   2 +
 fs/ksmbd/mgmt/user_session.c                       |   6 +-
 fs/ksmbd/server.c                                  |   4 +-
 fs/ksmbd/smb2pdu.c                                 |  33 ++--
 fs/nfs/pnfs.c                                      |   2 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nilfs2/inode.c                                  |   8 +-
 fs/nilfs2/namei.c                                  |   5 +
 include/clocksource/hyperv_timer.h                 |   2 +
 include/linux/hyperv.h                             |   1 +
 include/linux/if_vlan.h                            |  16 +-
 include/linux/mlx5/driver.h                        |   6 +
 include/linux/skmsg.h                              |  11 +-
 include/linux/trace_events.h                       |   2 +-
 include/linux/vmstat.h                             |   2 +-
 include/linux/wait.h                               |   1 +
 include/net/netfilter/nf_tables.h                  |   7 +-
 include/net/sock.h                                 |  10 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/bpf/syscall.c                               |  13 +-
 kernel/kcov.c                                      |   2 +-
 kernel/trace/trace.c                               |   3 +
 kernel/trace/trace_events.c                        | 213 +++++++++++++++++----
 kernel/trace/trace_kprobe.c                        |   2 +-
 lib/test_stackinit.c                               |   1 +
 mm/vmalloc.c                                       |   3 +-
 mm/vmscan.c                                        |   9 +-
 net/core/filter.c                                  |  21 +-
 net/core/skmsg.c                                   |   6 +-
 net/core/sock.c                                    |   5 +-
 net/dsa/dsa2.c                                     |   7 +
 net/ipv4/tcp_bpf.c                                 |   6 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv6/ila/ila_xlat.c                            |  16 +-
 net/llc/llc_input.c                                |   2 +-
 net/mac80211/util.c                                |   3 +
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netrom/nr_route.c                              |   6 +
 net/packet/af_packet.c                             |  28 +--
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_choke.c                              |   2 +-
 net/sctp/associola.c                               |   3 +-
 net/smc/af_smc.c                                   |  13 +-
 net/smc/smc_clc.c                                  |   9 +
 net/smc/smc_clc.h                                  |  14 +-
 scripts/mod/file2alias.c                           |   4 +-
 security/selinux/ss/services.c                     |   8 +-
 sound/pci/hda/patch_conexant.c                     |  28 +++
 sound/soc/intel/boards/sof_sdw.c                   |   9 +
 sound/usb/format.c                                 |   7 +-
 sound/usb/mixer.c                                  |   7 +
 sound/usb/mixer_us16x08.c                          |   2 +-
 sound/usb/quirks.c                                 |   2 +
 158 files changed, 1391 insertions(+), 495 deletions(-)


