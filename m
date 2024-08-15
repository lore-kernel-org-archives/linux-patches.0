Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A8019DF5F;
	Thu, 15 Aug 2024 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731920; cv=none; b=p4uhppQUmzIUV5If/+vdIxlvqYT7h8935Q3Oi3Iuoo0kV+Z0UydAfIYDNhtiSGmYOggIqLg343H0dfGRkMYkqYDuj0spSY8TOBQTwFM28ffhpZOEMJPnadaAysAlN8dfLy5SlJMfmqLr1ZLMK+yzuX2u2do2UUvrpMnFTZH2TC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731920; c=relaxed/simple;
	bh=F1BIOthaUpspbBb7M5SvKvCMpM2PNIj1L6R856h9Ol4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=osYfrJc8K+xa5DYSdg0GAB+yG5/lWddqes+hHo80CZyMz4OGwlkZao5xNzLGTetMdMxot4GlL5P+ymQ/HOlCIwKPnmTkXZZEB5xqZdR4HvIT4A3CAJLjMz8o/BFkhsS5iNygvBEiogdPVcwBwndiGragRFsZvLPCERUAPnewo/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFQxSW5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFQxSW5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A21C32786;
	Thu, 15 Aug 2024 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731920;
	bh=F1BIOthaUpspbBb7M5SvKvCMpM2PNIj1L6R856h9Ol4=;
	h=From:To:Cc:Subject:Date:From;
	b=IFQxSW5HW7yQ5dfjP2l63CAIKtWA1YYRdm7468IMGuoRI9x1j2yTRp5LiHg3wgaGk
	 719NY7QhvEYElMFsl2oKsEyGRIDM0ziULv0c2CGnKVKEMRMhse6CIG2FUP8BplJIWS
	 4xf8mp81gNCdIJPnHRf66pamYcMvTJGQcEbtbXgU=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/352] 5.10.224-rc1 review
Date: Thu, 15 Aug 2024 15:21:06 +0200
Message-ID: <20240815131919.196120297@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.224-rc1
X-KernelTest-Deadline: 2024-08-17T13:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.224 release.
There are 352 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.224-rc1

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode

Eric Dumazet <edumazet@google.com>
    wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values

Jason Wang <jasowang@redhat.com>
    vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler

Cai Huoqing <caihuoqing@baidu.com>
    vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage

Yunke Cao <yunkec@google.com>
    media: uvcvideo: Use entity get_cur in uvc_ctrl_set

Amit Daniel Kachhap <amit.kachhap@arm.com>
    arm64: cpufeature: Fix the visibility of compat hwcaps

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc: Avoid nmi_enter/nmi_exit in real mode interrupt.

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: allow clone callbacks to sleep

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set element extended ACK reporting support

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Fix use-after-free on concurrent DPC and hot-removal

Jari Ruusu <jariruusu@protonmail.com>
    Fix gcc 4.9 build issue in 5.10.y

Linus Torvalds <torvalds@linux-foundation.org>
    Add gitignore file for samples/fanotify/ subdirectory

Gabriel Krisman Bertazi <krisman@collabora.com>
    samples: Make fs-monitor depend on libc and headers

Gabriel Krisman Bertazi <krisman@collabora.com>
    samples: Add fs error monitoring example

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix backup support in signal endpoints

Geliang Tang <geliang.tang@suse.com>
    mptcp: export local_address

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: mib: count MPJ with backup flag

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix NL PM announced address accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: distinguish rcv vs sent backup flag in requests

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both directions for backup

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Set DDC timeout in milliseconds

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: analogix_dp: properly handle zero sized AUX transactions

Andi Kleen <ak@linux.intel.com>
    x86/mtrr: Check if fixed MTRRs exist before saving them

Waiman Long <longman@redhat.com>
    padata: Fix possible divide-by-0 panic in padata_mt_helper()

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    tracing: Fix overflow in get_free_elt()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Round constant_charge_voltage writes down

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Fix constant_charge_voltage writes

Shay Drory <shayd@nvidia.com>
    genirq/irqdesc: Honor caller provided affinity in alloc_desc()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    irqchip/xilinx: Fix shift out of bounds

George Kennedy <george.kennedy@oracle.com>
    serial: core: check uartclk for zero to avoid divide by zero

Arseniy Krasnov <avkrasnov@salutedevices.com>
    irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to 'raw_spinlock_t'

Qianggui Song <qianggui.song@amlogic.com>
    irqchip/meson-gpio: support more than 8 channels gpio irq

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Remove scsi_dma_map() error messages

Justin Stitt <justinstitt@google.com>
    ntp: Safeguard against time_constant overflow

Dan Williams <dan.j.williams@intel.com>
    driver core: Fix uevent_show() vs driver detach race

Justin Stitt <justinstitt@google.com>
    ntp: Clamp maxerror and esterror to operating range

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Move per CPU pointer access into the atomic section

Vamshi Gajjela <vamshigajjela@google.com>
    scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Set start_delayed during suspend

Chris Wulff <crwulff@gmail.com>
    usb: gadget: core: Check for unset descriptor

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    USB: serial: debug: do not echo input by default

Oliver Neukum <oneukum@suse.com>
    usb: vhci-hcd: Do not drop references before new references are gained

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4

Steven 'Steve' Kendall <skend@chromium.org>
    ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix racy access to midibuf

Ma Ke <make24@iscas.ac.cn>
    drm/client: fix null pointer dereference in drm_client_modeset_probe

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Re-add ScratchAmp quirk entries

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix scldiv calculation

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Fix to check symbol prefixes correctly

Menglong Dong <menglong8.dong@gmail.com>
    bpf: kprobe: remove unused declaring of bpf_kprobe_override

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Send alert notifications to all devices if source not found

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Correct Soundwire ports mask

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Improve handling of stuck alerts

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround (again)

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A725 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X1C definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Unify speculative SSBS errata logic

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X925 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A720 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Add workaround for Arm errata 3194386 and 3312417

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X4 definitions

Besar Wicaksono <bwicaksono@nvidia.com>
    arm64: Add Neoverse-V2 part

James Morse <james.morse@arm.com>
    arm64: cpufeature: Force HWCAP to be based on the sysreg visible to user-space

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: fix wrong unit use in ext4_mb_find_by_goal

Zheng Zucheng <zhengzucheng@huawei.com>
    sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a race to wake a sync task

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Prevent release of buffer in I/O

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: avoid memleak in jbd2_journal_write_metadata_buffer

Michal Pecio <michal.pecio@gmail.com>
    media: uvcvideo: Fix the bandwdith quirk on USB 3.x

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Ignore empty TS packets

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the null pointer dereference in apply_state_adjust_rules

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix the null pointer dereference to ras_manager

Filipe Manana <fdmanana@suse.com>
    btrfs: fix bitmap leak when loading free space cache on duplicate entry

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't give key data to userspace

Roman Smirnov <r.smirnov@omp.ru>
    udf: prevent integer overflow in udf_bitmap_free_blocks()

FUJITA Tomonori <fujita.tomonori@gmail.com>
    PCI: Add Edimax Vendor ID to pci_ids.h

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix send_signal test with nested CONFIG_PARAVIRT

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: SBS: manage alarm sysfs attribute through psy core

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: create alarm sysfs attribute atomically

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    clocksource/drivers/sh_cmt: Address race condition for clock events

Yu Kuai <yukuai3@huawei.com>
    md/raid5: avoid BUG_ON() while continue reshape after reassembling

Li Nan <linan122@huawei.com>
    md: do not delete safemode_timer in mddev_suspend

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_fwd_cb_cr() data race

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Stop PPS on driver remove

James Chapman <jchapman@katalix.com>
    l2tp: fix lockdep splat

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: dsa: bcm_sf2: Fix a possible memory leak in bcm_sf2_mdio_register()

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()

Eric Dumazet <edumazet@google.com>
    net: linkwatch: use system_unbound_wq

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: fix memory leak for not ip packets

Kuniyuki Iwashima <kuniyu@amazon.com>
    sctp: Fix null-ptr-deref in reuseport_add_sock().

Xin Long <lucien.xin@gmail.com>
    sctp: move hlist_node and hashent out of sctp_ep_common

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_entry_text() for i386

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_pgtable() alignment assumption

Yipeng Zou <zouyipeng@huawei.com>
    irqchip/mbigen: Fix mbigen node address layout

Marc Zyngier <maz@kernel.org>
    genirq: Allow irq_chip registration functions to take a const irq_chip

Alexander Maltsev <keltar.gw@gmail.com>
    netfilter: ipset: Add list flush to cancel_gc

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate data handling

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't increment tx_dropped in case of NETDEV_TX_BUSY

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
    HID: wacom: Modify pen IDs

Patryk Duda <patrykd@google.com>
    platform/chrome: cros_ec_proto: Lock device when updating MKBP version

Zhe Qiao <qiaozhe@iscas.ac.cn>
    riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Eric Dumazet <edumazet@google.com>
    sched: act_ct: take care of padding in struct zones_ht_key

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Danilo Krummrich <dakr@kernel.org>
    drm/nouveau: prime: fix refcount underflow

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Skip over memory region when node value is NULL

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: imx_rproc: Fix ignoring mapping vdev regions

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: ignore mapping vdev regions

Shenwei Wang <shenwei.wang@nxp.com>
    irqchip/imx-irqsteer: Handle runtime power management correctly

Lucas Stach <l.stach@pengutronix.de>
    irqchip/imx-irqsteer: Add runtime PM support

Lucas Stach <l.stach@pengutronix.de>
    irqchip/imx-irqsteer: Constify irq_chip struct

Marc Zyngier <maz@kernel.org>
    genirq: Allow the PM device to originate from irq domain

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix memory leakage caused by driver API devm_free_percpu()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    driver core: Cast to (void *) with __force for __percpu pointer

Jay Buddhabhatti <jay.buddhabhatti@amd.com>
    drivers: soc: xilinx: check return status of get_api_version()

Michael Tretter <m.tretter@pengutronix.de>
    soc: xilinx: move PM_INIT_FINALIZE to zynqmp_pm_domains driver

Zhang Yi <yi.zhang@huawei.com>
    ext4: check the extent status again before inserting delalloc block

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out a common helper to query extent map

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: always initialize i_uid/i_gid

Eric Sandeen <sandeen@redhat.com>
    fuse: verify {g,u}id mount options correctly

Miklos Szeredi <mszeredi@redhat.com>
    fuse: name fs_context consistently

Esben Haabendal <esben@geanix.com>
    powerpc/configs: Update defconfig with now user-visible CONFIG_FSL_IFC

Seth Forshee (DigitalOcean) <sforshee@kernel.org>
    fs: don't allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT

Leon Romanovsky <leon@kernel.org>
    nvme-pci: add missing condition check for existence of mapped data

Jens Axboe <axboe@kernel.dk>
    nvme: split command copy into a helper

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Allow allocation of more than 1 MSI interrupt

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Refactor arch_setup_msi_irqs()

Thomas Gleixner <tglx@linutronix.de>
    s390/pci: Rework MSI descriptor walk

Thomas Gleixner <tglx@linutronix.de>
    s390/pci: Do not mask MSI[-X] entries on teardown

ethanwu <ethanwu@synology.com>
    ceph: fix incorrect kmalloc size of pagevec mempool

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable

Al Viro <viro@zeniv.linux.org.uk>
    lirc: rc_dev_get_from_fd(): fix file leak

Al Viro <viro@zeniv.linux.org.uk>
    powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()

Xiao Liang <shaw.leon@gmail.com>
    apparmor: Fix null pointer deref when receiving skb during sock creation

Dan Carpenter <dan.carpenter@linaro.org>
    mISDN: Fix a use after free in hfcmulti_tx()

Fred Li <dracodingfly@gmail.com>
    bpf: Fix a segment issue when downgrading gso_size

Petr Machata <petrm@nvidia.com>
    net: nexthop: Initialize all fields in dumped nexthops

Simon Horman <horms@kernel.org>
    net: stmmac: Correct byte order of perfect_match

Shigeru Yoshida <syoshida@redhat.com>
    tipc: Return non-zero value from tipc_udp_addr2str() on error

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo_avx2: disable softinterrupts

Johannes Berg <johannes.berg@intel.com>
    net: bonding: correctly annotate RCU in bond_should_notify_peers()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect source address in Record Route option

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: SMP-CPS: Fix address for GCR_ACCESS register for CM3 and later

Lance Richardson <rlance@google.com>
    dma: fix call order in dmam_free_coherent

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix no-args func prototype BTF dumping syntax

Sheng Yong <shengyong@oppo.com>
    f2fs: fix start segno of large section

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix time-travel-start option

Jeongjun Park <aha310510@gmail.com>
    jfs: Fix array-index-out-of-bounds in diFree

Douglas Anderson <dianders@chromium.org>
    kdb: Use the passed prompt in kdb_position_cursor()

Arnd Bergmann <arnd@arndb.de>
    kdb: address -Wformat-security warnings

Pavel Begunkov <asml.silence@gmail.com>
    kernel: rerun task_work while freezing in get_signal()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/io-wq: limit retrying worker initialisation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle inconsistent state in nilfs_btnode_create_block()

WangYuli <wangyuli@uniontech.com>
    Bluetooth: btusb: Add Realtek RTL8852BE support ID 0x13d3:0x3591

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e125 to device tables

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't assume RBD_LOCK_STATE_LOCKED for exclusive mappings

Ilya Dryomov <idryomov@gmail.com>
    rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait

Dragan Simic <dsimic@manjaro.org>
    drm/panfrost: Mark simple_ondemand governor as softdep

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: env: Hook up Loongsson-2K

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: ip30: ip30-console: Add missing include

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't assume rbd_is_lock_owner() for exclusive mappings

Michael Ellerman <mpe@ellerman.id.au>
    selftests/sigaltstack: Fix ppc64 GCC build

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a use-after-free related to destroying CM IDs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform: mips: cpu_hwmon: Disable driver on unsupported hardware

Thomas Gleixner <tglx@linutronix.de>
    watchdog/perf: properly initialize the turbo mode timestamp and rearm counter

Joy Chakraborty <joychakr@google.com>
    rtc: isl1208: Fix return value of nvmem callbacks

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix a topa_entry base address calculation

Marco Cavenati <cavenati.marco@gmail.com>
    perf/x86/intel/pt: Fix topa_entry base length

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: validate nvme_local_port correctly

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Complete command early within lock

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix flash read failure

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix for possible memory corruption

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: During vport delete send async logout explicitly

Joy Chakraborty <joychakr@google.com>
    rtc: cmos: Fix return value of nvmem callbacks

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix devm_krealloc() wasting memory

Zijun Hu <quic_zijuhu@quicinc.com>
    kobject_uevent: Fix OOB access within zap_modalias_env()

Nathan Chancellor <nathan@kernel.org>
    kbuild: Fix '-S -c' in x86 stack protector scripts

Ross Lagerwall <ross.lagerwall@citrix.com>
    decompress_bunzip2: fix rare decompression failure

Fedor Pchelkin <pchelkin@ispras.ru>
    ubi: eba: properly rollback inside self_check_eba

Bastien Curutchet <bastien.curutchet@bootlin.com>
    clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use

Chao Yu <chao@kernel.org>
    f2fs: fix to don't dirty inode for readonly filesystem

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix bug in lock.cat

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()

Jan Kara <jack@suse.cz>
    jbd2: make jbd2_journal_get_max_txn_bufs() internal

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    leds: ss4200: Convert PCIBIOS_* return codes to errnos

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: Fix interface type change

Baokun Li <libaokun1@huawei.com>
    ext4: make sure the first directory block is not a hole

Baokun Li <libaokun1@huawei.com>
    ext4: check dot and dotdot of dx_root before making dir indexed

Paolo Pisati <p.pisati@gmail.com>
    m68k: amiga: Turn off Warp1260 interrupts during boot

Jan Kara <jack@suse.cz>
    udf: Avoid using corrupted block bitmap buffer

Frederic Weisbecker <frederic@kernel.org>
    task_work: Introduce task_work_cancel() again

Frederic Weisbecker <frederic@kernel.org>
    task_work: s/task_work_cancel()/task_work_cancel_func()/

Fedor Pchelkin <pchelkin@ispras.ru>
    apparmor: use kvfree_sensitive to free data->data

Pierre Gondois <pierre.gondois@arm.com>
    sched/fair: Use all little CPUs for CPU-bound workloads

Sung Joon Kim <sungjoon.kim@amd.com>
    drm/amd/display: Check for NULL pointer

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix optrom version displayed in FDMI

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes

Jan Kara <jack@suse.cz>
    ext2: Verify bitmap and itable block numbers before using them

Chao Yu <chao@kernel.org>
    hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Tejun Heo <tj@kernel.org>
    sched/fair: set_load_weight() must also call reweight_task() for SCHED_IDLE tasks

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of scope when choosing the src addr

Chengen Du <chengen.du@canonical.com>
    af_packet: Handle outgoing VLAN packets without hardware offloading

Breno Leitao <leitao@debian.org>
    net: netconsole: Disable target before netpoll cleanup

Yu Liao <liaoyu15@huawei.com>
    tick/broadcast: Make takeover of broadcast hrtimer reliable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: thermal: correct thermal zone node name limit

Csókás, Bence <csokas.bence@prolan.hu>
    rtc: interface: Add RTC offset to alarm after fix-up

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

Alex Shi <alex.shi@linux.alibaba.com>
    fs/nilfs2: remove some unused macros to tame gcc

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP

Peng Fan <peng.fan@nxp.com>
    pinctrl: freescale: mxs: Fix refcount of child

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pinctrl: ti: ti-iodelay: Drop if block with always false condition

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: single: fix possible memory leak when pinctrl_enable() fails

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak when pinctrl_enable() fails

Dmitry Yashin <dmt.yashin@gmail.com>
    pinctrl: rockchip: update rk3308 iomux routes

Martin Willi <martin@strongswan.org>
    net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports

Martin Willi <martin@strongswan.org>
    net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing pagesize and alignment check in FRMR

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - do not leave interrupt disabled on suspend failure

Leon Romanovsky <leon@kernel.org>
    RDMA/device: Return error earlier if port in not valid

Arnd Bergmann <arnd@arndb.de>
    mtd: make mtd_test.c a separate module

Chen Ni <nichen@iscas.ac.cn>
    ASoC: max98088: Check for clk_prepare_enable() error

Honggang LI <honggangli@163.com>
    RDMA/rxe: Don't set BTH_ACK_MASK for UC or UD QPs

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Fix truncated output warning in alias_GUID.c

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Fix truncated output warning in mad.c

Andrei Lalaev <andrei.lalaev@anton-paar.com>
    Input: qt1050 - handle CHIP_ID reading error

James Clark <james.clark@arm.com>
    coresight: Fix ref leak when of_coresight_parse_endpoint() fails

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix resource double counting on remove & rescan

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fixup gss_status tracepoint error output

Andreas Larsson <andreas@gaisler.com>
    sparc64: Fix incorrect function signature and add prototype for prom_cif_init

Jan Kara <jack@suse.cz>
    ext4: avoid writing unitialized memory to disk in EA inodes

NeilBrown <neilb@suse.de>
    SUNRPC: avoid soft lockup when transmitting UDP to reachable server.

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix rpcrdma_reqs_reset()

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Rename frwr_release_mr()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mfd: omap-usb-tll: Use struct_size to allocate tll

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: flush all buffers in output plane streamoff

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix infinite loop when replaying fast_commit

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "leds: led-core: Fix refcount leak in of_led_get()"

Chen Ni <nichen@iscas.ac.cn>
    drm/qxl: Add check for drm_cvt_mode

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix DMA direction handling for cached RW buffers

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix condition in sort__sym_cmp()

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Unregister sysfs attributes before calling deactivate()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Store RPF partition configuration per RPF instance

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Fix _irqsave and _irq mix

Daniel Schaefer <dhs@frame.work>
    media: uvcvideo: Override default flags

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow entity-defined get_info and get_cur

Aleksandr Burakov <a.burakov@rosalinux.ru>
    saa7134: Unchecked i2c_transfer function result fixed

David Hildenbrand <david@redhat.com>
    s390/uv: Don't call folio_wait_writeback() without a folio reference

Matthew Wilcox (Oracle) <willy@infradead.org>
    s390/mm: Convert gmap_make_secure to use a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    s390/mm: Convert make_page_secure to use a folio

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: fix race in gmap_make_secure()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: add export before import

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: properly handle page flags for protected guests

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: avoid stalls when making pages secure

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Zheng Yejian <zhengyejian1@huawei.com>
    media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators

Taehee Yoo <ap420073@gmail.com>
    xdp: fix invalid wait context of page_pool_destroy()

Amit Cohen <amcohen@nvidia.com>
    selftests: forwarding: devlink_lib: Wait for udev events after reloading

Alan Maguire <alan.maguire@oracle.com>
    bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    bna: adjust 'name' buf size of bna_tcb and bna_ccb structures

Alan Maguire <alan.maguire@oracle.com>
    bpf: annotate BTF show functions with __printf

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Close fd in error path in drop_on_reuseport

Johannes Berg <johannes.berg@intel.com>
    wifi: virt_wifi: don't use strlen() in const context

Gaosheng Cui <cuigaosheng1@huawei.com>
    gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey

En-Wei Wu <en-wei.wu@canonical.com>
    wifi: virt_wifi: avoid reporting connection success with wrong SSID

Shai Malin <smalin@marvell.com>
    qed: Improve the stack space of filter_config()

Adrian Hunter <adrian.hunter@intel.com>
    perf: Prevent passing zero nr_pages to rb_alloc_aux()

Adrian Hunter <adrian.hunter@intel.com>
    perf: Fix perf_aux_size() for greater-than 32-bit size

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: rise cap on SELinux secmark context

Ismael Luceno <iluceno@suse.de>
    ipvs: Avoid unnecessary calls to skb_is_gso_sctp

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Fix FEC_ECR_EN1588 being cleared on link-down

Csókás Bence <csokas.bence@prolan.hu>
    net: fec: Refactor: #define magic constants

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers

Carl Huang <cjhuang@codeaurora.org>
    ath11k: dp: stop rx pktlog before suspend

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl: Fix ACL scale regression and firmware errors

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode() more flexible

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl_erp: Fix object nesting warning

Ido Schimmel <idosch@nvidia.com>
    lib: objagg: Fix general protection fault

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Check length of recv in test_sockmap

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: set rmb's SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined

Stefan Raspl <raspl@linux.ibm.com>
    net/smc: Allow SMC-D 1MB DMB allocations

Hagar Hemdan <hagarhem@amazon.com>
    net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix prog numbers in test_sockmap

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Initialize completion before mailbox

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: spitz: fix GPIO assignment for backlight

Arnd Bergmann <arnd@arndb.de>
    ARM: pxa: spitz: use gpio descriptors for audio

Thorsten Blum <thorsten.blum@toblux.com>
    m68k: cmpxchg: Fix return value for default case in __arch_xchg()

Chen Ni <nichen@iscas.ac.cn>
    x86/xen: Convert comma to semicolon

Eero Tamminen <oak@helsinkinet.fi>
    m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: gx: correct hdmi clocks

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: mediatek: mt7622: fix "emmc" pinctrl mux

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix SPI0 chip selects

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix board reset

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Increase VOP clk rate on RK3328

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pdr: fix parsing of domains lists

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pdr: protect locator_addr with the main mutex

Esben Haabendal <esben@geanix.com>
    memory: fsl_ifc: Make FSL_IFC config visible and selectable

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: specify UFS core_clk frequencies

Stephen Boyd <swboyd@chromium.org>
    soc: qcom: rpmh-rsc: Ensure irqs aren't disabled by rpmh_rsc_send_data() callers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: add power-domain to UFS PHY

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix swapped temp{1,8} critical alarms

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix underflow when writing limit attributes

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Always do lazy disabling

Wayne Tung <chineweff@gmail.com>
    hwmon: (adt7475) Fix default duty on fan is disabled

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/xen: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/intel_mid_pci: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/of: Return consistent error type from x86_of_pci_irq_enable()

Chao Yu <chao@kernel.org>
    hfsplus: fix to avoid false alarm of circular locking

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_debugfs: fix wrong EC message version

Arnd Bergmann <arnd@arndb.de>
    EDAC, i10nm: make skx_common.o a separate module

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Add new ADXL components for 2-level memory


-------------

Diffstat:

 Documentation/arm64/cpu-feature-registers.rst      |  38 ++++-
 Documentation/arm64/silicon-errata.rst             |  36 +++++
 .../devicetree/bindings/thermal/thermal-zones.yaml |   5 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi        |  23 ---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  26 +++-
 arch/arm/mach-pxa/spitz.c                          |  39 +++--
 arch/arm/mach-pxa/{include/mach => }/spitz.h       |   2 +-
 arch/arm/mach-pxa/spitz_pm.c                       |   2 +-
 arch/arm64/Kconfig                                 |  38 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   4 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   4 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   2 -
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/include/asm/cpucaps.h                   |   3 +-
 arch/arm64/include/asm/cputype.h                   |  16 ++
 arch/arm64/kernel/cpu_errata.c                     |  31 ++++
 arch/arm64/kernel/cpufeature.c                     |  94 +++++++++---
 arch/arm64/kernel/proton-pack.c                    |  12 ++
 arch/m68k/amiga/config.c                           |   9 ++
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/include/asm/mach-loongson64/boot_param.h |   2 +
 arch/mips/include/asm/mips-cm.h                    |   4 +
 arch/mips/kernel/smp-cps.c                         |   5 +-
 arch/mips/loongson64/env.c                         |   8 +
 arch/mips/pci/pcie-octeon.c                        |   0
 arch/mips/sgi-ip30/ip30-console.c                  |   1 +
 arch/powerpc/configs/85xx-hw.config                |   2 +
 arch/powerpc/include/asm/percpu.h                  |  10 ++
 arch/powerpc/kernel/mce.c                          |  14 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kernel/traps.c                        |   8 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/xmon/ppc-dis.c                        |  33 ++---
 arch/riscv/mm/fault.c                              |  17 ++-
 arch/s390/include/asm/pgtable.h                    |   9 +-
 arch/s390/include/asm/uv.h                         |  10 +-
 arch/s390/kernel/uv.c                              | 163 +++++++++++++++------
 arch/s390/kvm/intercept.c                          |   5 +
 arch/s390/mm/gmap.c                                |   4 +-
 arch/s390/pci/pci_irq.c                            | 120 +++++++++------
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/um/kernel/time.c                              |   4 +-
 arch/x86/events/intel/pt.c                         |   4 +-
 arch/x86/events/intel/pt.h                         |   4 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/mm/pti.c                                  |   8 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 drivers/acpi/battery.c                             |  16 +-
 drivers/acpi/sbs.c                                 |  23 +--
 drivers/android/binder.c                           |   4 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/devres.c                              |  13 +-
 drivers/base/module.c                              |   4 +
 drivers/block/rbd.c                                |  35 ++---
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/edac/Makefile                              |  10 +-
 drivers/edac/skx_common.c                          |  88 +++++++++--
 drivers/edac/skx_common.h                          |  15 +-
 drivers/firmware/turris-mox-rwtm.c                 |  18 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   7 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   7 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  14 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   7 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/drm_client_modeset.c               |   5 +
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  53 ++++++-
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   8 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/max6697.c                            |   5 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   4 +-
 drivers/i2c/i2c-smbus.c                            |  64 +++++++-
 drivers/infiniband/core/device.c                   |   6 +-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   4 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 +
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/keyboard/qt1050.c                    |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/irqchip/irq-imx-irqsteer.c                 |  40 ++++-
 drivers/irqchip/irq-mbigen.c                       |  20 ++-
 drivers/irqchip/irq-meson-gpio.c                   |  35 +++--
 drivers/irqchip/irq-xilinx-intc.c                  |   2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/led-class.c                           |   1 -
 drivers/leds/led-triggers.c                        |   2 +-
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/md/md.c                                    |   1 -
 drivers/md/raid5.c                                 |  20 ++-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 drivers/media/platform/qcom/venus/vdec.c           |   3 +-
 drivers/media/platform/vsp1/vsp1_histo.c           |  20 +--
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   8 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/rc/lirc_dev.c                        |   4 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  35 ++++-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  90 ++++++++----
 drivers/media/usb/uvc/uvc_video.c                  |  37 ++++-
 drivers/media/usb/uvc/uvcvideo.h                   |   5 +
 drivers/memory/Kconfig                             |   2 +-
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/tests/Makefile                         |  34 ++---
 drivers/mtd/tests/mtd_test.c                       |   9 ++
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/dsa/bcm_sf2.c                          |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   3 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 +++++--
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c   |  18 +--
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |  38 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |  13 --
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |  23 +--
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  47 +++---
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/sr9700.c                           |  11 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  51 ++++++-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   6 +
 drivers/net/wireless/ath/ath11k/mac.c              |  19 ++-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 drivers/net/wireless/virt_wifi.c                   |  20 ++-
 drivers/nvme/host/pci.c                            |  36 +++--
 drivers/parport/procfs.c                           |  24 +--
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pcie-rockchip.c             |   2 +-
 drivers/pci/msi.c                                  |   4 +-
 drivers/pci/pci.c                                  |  19 ++-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  17 +--
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/chrome/cros_ec_proto.c            |   2 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/power/supply/axp288_charger.c              |  24 +--
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |   5 +
 drivers/rtc/interface.c                            |   9 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-isl1208.c                          |  11 +-
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  38 ++---
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  63 ++++++--
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   7 +-
 drivers/scsi/qla2xxx/qla_sup.c                     | 108 +++++++++-----
 drivers/scsi/ufs/ufshcd.c                          |  11 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/soc/qcom/rpmh.c                            |   1 -
 drivers/soc/xilinx/zynqmp_pm_domains.c             |  16 ++
 drivers/soc/xilinx/zynqmp_power.c                  |   5 +-
 drivers/spi/spi-fsl-lpspi.c                        |   6 +-
 drivers/tty/serial/serial_core.c                   |   8 +
 drivers/usb/gadget/function/u_serial.c             |   1 +
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 drivers/vhost/vdpa.c                               |  30 ++--
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/ceph/super.c                                    |   3 +-
 fs/exec.c                                          |   8 +-
 fs/ext2/balloc.c                                   |  11 +-
 fs/ext4/extents_status.c                           |   2 +
 fs/ext4/inode.c                                    |  78 ++++++----
 fs/ext4/mballoc.c                                  |   3 +-
 fs/ext4/namei.c                                    |  73 +++++++--
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/inode.c                                    |   3 +
 fs/f2fs/segment.h                                  |   3 +-
 fs/file.c                                          |   1 +
 fs/fuse/control.c                                  |  10 +-
 fs/fuse/inode.c                                    |  80 ++++++----
 fs/fuse/virtio_fs.c                                |  12 +-
 fs/hfs/inode.c                                     |   3 +
 fs/hfsplus/bfind.c                                 |  15 +-
 fs/hfsplus/extents.c                               |   9 +-
 fs/hfsplus/hfsplus_fs.h                            |  21 +++
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |   6 +
 fs/jfs/jfs_imap.c                                  |   5 +-
 fs/nilfs2/btnode.c                                 |  25 +++-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   7 +-
 fs/proc/proc_sysctl.c                              |   6 +-
 fs/proc/task_mmu.c                                 |   2 +
 fs/super.c                                         |  11 ++
 fs/udf/balloc.c                                    |  51 +++----
 fs/udf/super.c                                     |   3 +-
 include/linux/compiler_attributes.h                |   1 +
 include/linux/irq.h                                |   7 +-
 include/linux/irqdomain.h                          |  10 ++
 include/linux/jbd2.h                               |   5 -
 include/linux/msi.h                                |   2 -
 include/linux/objagg.h                             |   1 -
 include/linux/pci_ids.h                            |   2 +
 include/linux/qed/qed_eth_if.h                     |  21 +--
 include/linux/sched/signal.h                       |   6 +
 include/linux/task_work.h                          |   3 +-
 include/linux/trace_events.h                       |   1 -
 include/net/netfilter/nf_tables.h                  |  25 +++-
 include/net/sctp/sctp.h                            |   4 +-
 include/net/sctp/structs.h                         |   8 +-
 include/trace/events/rpcgss.h                      |   2 +-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 io_uring/io-wq.c                                   |  10 +-
 kernel/bpf/btf.c                                   |  10 +-
 kernel/debug/kdb/kdb_io.c                          |   6 +-
 kernel/dma/mapping.c                               |   2 +-
 kernel/events/core.c                               |   2 +
 kernel/events/internal.h                           |   2 +-
 kernel/irq/chip.c                                  |  32 ++--
 kernel/irq/irqdesc.c                               |   1 +
 kernel/irq/manage.c                                |   2 +-
 kernel/kprobes.c                                   |   4 +-
 kernel/padata.c                                    |   7 +
 kernel/rcu/rcutorture.c                            |   2 +-
 kernel/sched/core.c                                |  23 ++-
 kernel/sched/cputime.c                             |   6 +
 kernel/sched/fair.c                                |   9 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/signal.c                                    |   8 +
 kernel/task_work.c                                 |  34 ++++-
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |  24 +++
 kernel/trace/tracing_map.c                         |   6 +-
 kernel/watchdog_hld.c                              |  11 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 ++-
 lib/objagg.c                                       |  18 +--
 net/bluetooth/l2cap_core.c                         |   1 +
 net/core/filter.c                                  |  15 +-
 net/core/link_watch.c                              |   4 +-
 net/core/xdp.c                                     |   4 +-
 net/ipv4/esp4.c                                    |   3 +-
 net/ipv4/nexthop.c                                 |   7 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/esp6.c                                    |   3 +-
 net/ipv6/ndisc.c                                   |  34 +++--
 net/iucv/af_iucv.c                                 |   4 +-
 net/l2tp/l2tp_core.c                               |  15 +-
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/options.c                                |   2 +-
 net/mptcp/pm.c                                     |   9 ++
 net/mptcp/pm_netlink.c                             |  30 +++-
 net/mptcp/protocol.c                               |  10 +-
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                |  24 ++-
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nf_tables_api.c                      | 149 ++++---------------
 net/netfilter/nft_connlimit.c                      |   2 +-
 net/netfilter/nft_counter.c                        |   4 +-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_pipapo.c                     |  18 ++-
 net/netfilter/nft_set_pipapo_avx2.c                |  12 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/packet/af_packet.c                             |  86 ++++++++++-
 net/sched/act_ct.c                                 |   4 +-
 net/sctp/input.c                                   |  48 +++---
 net/sctp/proc.c                                    |  10 +-
 net/sctp/socket.c                                  |   6 +-
 net/smc/smc_core.c                                 |  32 ++--
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   2 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   9 +-
 net/sunrpc/xprtrdma/verbs.c                        |  20 ++-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   2 +-
 net/tipc/udp_media.c                               |   5 +-
 net/wireless/nl80211.c                             |  16 +-
 net/wireless/util.c                                |   8 +-
 samples/Kconfig                                    |   8 +
 samples/Makefile                                   |   1 +
 samples/fanotify/.gitignore                        |   1 +
 samples/fanotify/Makefile                          |   5 +
 samples/fanotify/fs-monitor.c                      | 142 ++++++++++++++++++
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 security/apparmor/lsm.c                            |   7 +
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_unpack.c                  |   1 +
 security/keys/keyctl.c                             |   2 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/max98088.c                        |  10 +-
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/intel/common/soc-intel-quirks.h          |   2 +-
 sound/soc/pxa/spitz.c                              |  58 +++-----
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/quirks-table.h                           |   4 +
 sound/usb/stream.c                                 |   4 +-
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/memory-model/lock.cat                        |  20 +--
 tools/perf/util/sort.c                             |   2 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   2 +-
 .../bpf/progs/btf_dump_test_case_multidim.c        |   4 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   9 +-
 .../drivers/net/mlxsw/spectrum-2/tc_flower.sh      |  55 ++++++-
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 360 files changed, 3135 insertions(+), 1499 deletions(-)


