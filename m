Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E9F1AC43B;
	Thu, 15 Aug 2024 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731135; cv=none; b=SPBQXEzWccuOlwpojW2BTJjJt9MXdUbS9nA0EWm45o+JhO7q77oX06o8wWIhm2JG6AkDK01a1w+++v3zXIdT8nVI+mjXzVDNyktbcWhdnqXtBJ258eFWp2Mbpt1M7CtZVvhzk9Vm0ZAuL9ytVcYPjrA29ZB5uTHfe+sqULPkuyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731135; c=relaxed/simple;
	bh=Zjmq6V92Zh+Dg8gjMz1nfhiwwtTz1E0OtZg5/9t7ca8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UGn6KNXMQqlmagqena6ZWepaCknML+6XiDQXVB/u8+dLovyZseEalKXbWB3FJIhbSraqlSB6WWKx5oM6vFdE6Gq5kwjCgdHLOHScATPLuauVF86RslANcuD2NpNvHYzADaDA14oZKdKcbySVPpptb/5rnGE3ygUXNwt0l/kNTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwPf63Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwPf63Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55661C32786;
	Thu, 15 Aug 2024 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731135;
	bh=Zjmq6V92Zh+Dg8gjMz1nfhiwwtTz1E0OtZg5/9t7ca8=;
	h=From:To:Cc:Subject:Date:From;
	b=QwPf63Fnxqmr8luJPGazrXFcDe5YnMbr8hH9k/kXG4UwWCDTlw4UyWFHtN6BOqbvh
	 DRZaal35o4MQ1m32TDwfDWM9vd2h/7pZpSrTh5uySqfpJf7LkTLbhbWFsoReOzVcd7
	 96zkqej/D+ferrKjCED+0jeBbriECanHkxtcVA/M=
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
Subject: [PATCH 5.4 000/259] 5.4.282-rc1 review
Date: Thu, 15 Aug 2024 15:22:13 +0200
Message-ID: <20240815131902.779125794@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.282-rc1
X-KernelTest-Deadline: 2024-08-17T13:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.282 release.
There are 259 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.282-rc1

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage

Yunke Cao <yunkec@google.com>
    media: uvcvideo: Use entity get_cur in uvc_ctrl_set

Amit Daniel Kachhap <amit.kachhap@arm.com>
    arm64: cpufeature: Fix the visibility of compat hwcaps

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set element extended ACK reporting support

Nathan Chancellor <nathan@kernel.org>
    kbuild: Fix '-S -c' in x86 stack protector scripts

Jari Ruusu <jariruusu@protonmail.com>
    Fix gcc 4.9 build issue in 5.4.y

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Set DDC timeout in milliseconds

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: analogix_dp: properly handle zero sized AUX transactions

Andi Kleen <ak@linux.intel.com>
    x86/mtrr: Check if fixed MTRRs exist before saving them

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    tracing: Fix overflow in get_free_elt()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Round constant_charge_voltage writes down

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Fix constant_charge_voltage writes

Shay Drory <shayd@nvidia.com>
    genirq/irqdesc: Honor caller provided affinity in alloc_desc()

George Kennedy <george.kennedy@oracle.com>
    serial: core: check uartclk for zero to avoid divide by zero

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

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix scldiv calculation

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    spi: fsl-lpspi: remove unneeded array

Menglong Dong <menglong8.dong@gmail.com>
    bpf: kprobe: remove unused declaring of bpf_kprobe_override

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Send alert notifications to all devices if source not found

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Improve handling of stuck alerts

Corey Minyard <cminyard@mvista.com>
    i2c: smbus: Don't filter out duplicate alerts

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

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Stop PPS on driver remove

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
    x86/mm: Fix pti_clone_pgtable() alignment assumption

Yipeng Zou <zouyipeng@huawei.com>
    irqchip/mbigen: Fix mbigen node address layout

Marc Zyngier <maz@kernel.org>
    genirq: Allow irq_chip registration functions to take a const irq_chip

Alexander Maltsev <keltar.gw@gmail.com>
    netfilter: ipset: Add list flush to cancel_gc

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
    HID: wacom: Modify pen IDs

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

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

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Joe Perches <joe@perches.com>
    parport: Standardize use of printmode

Joe Perches <joe@perches.com>
    parport: Convert printk(KERN_<LEVEL> to pr_<level>(

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Chen-Yu Tsai <wens@csie.org>
    PCI: rockchip: Make 'ep-gpios' DT property optional

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Leon Romanovsky <leonro@nvidia.com>
    nvme-pci: add missing condition check for existence of mapped data

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Allow allocation of more than 1 MSI interrupt

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Refactor arch_setup_msi_irqs()

Thomas Gleixner <tglx@linutronix.de>
    s390/pci: Rework MSI descriptor walk

Thomas Gleixner <tglx@linutronix.de>
    s390/pci: Do not mask MSI[-X] entries on teardown

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/pci: fix CPU address in MSI for directed IRQ

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: Move soc_intel_is_foo() helpers to a generic header

Thomas Gleixner <tglx@linutronix.de>
    ASoC: Intel: Convert to new X86 CPU match macros

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

Shigeru Yoshida <syoshida@redhat.com>
    tipc: Return non-zero value from tipc_udp_addr2str() on error

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

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix time-travel-start option

Jeongjun Park <aha310510@gmail.com>
    jfs: Fix array-index-out-of-bounds in diFree

Douglas Anderson <dianders@chromium.org>
    kdb: Use the passed prompt in kdb_position_cursor()

Arnd Bergmann <arnd@arndb.de>
    kdb: address -Wformat-security warnings

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

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix for possible memory corruption

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: During vport delete send async logout explicitly

Joy Chakraborty <joychakr@google.com>
    rtc: cmos: Fix return value of nvmem callbacks

Zijun Hu <quic_zijuhu@quicinc.com>
    kobject_uevent: Fix OOB access within zap_modalias_env()

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

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix bug in lock.cat

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

Sung Joon Kim <sungjoon.kim@amd.com>
    drm/amd/display: Check for NULL pointer

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes

Chao Yu <chao@kernel.org>
    hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of scope when choosing the src addr

Chengen Du <chengen.du@canonical.com>
    af_packet: Handle outgoing VLAN packets without hardware offloading

Breno Leitao <leitao@debian.org>
    net: netconsole: Disable target before netpoll cleanup

Yu Liao <liaoyu15@huawei.com>
    tick/broadcast: Make takeover of broadcast hrtimer reliable

Csókás, Bence <csokas.bence@prolan.hu>
    rtc: interface: Add RTC offset to alarm after fix-up

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

Alex Shi <alex.shi@linux.alibaba.com>
    fs/nilfs2: remove some unused macros to tame gcc

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - do not leave interrupt disabled on suspend failure

Leon Romanovsky <leonro@nvidia.com>
    RDMA/device: Return error earlier if port in not valid

Arnd Bergmann <arnd@arndb.de>
    mtd: make mtd_test.c a separate module

Chen Ni <nichen@iscas.ac.cn>
    ASoC: max98088: Check for clk_prepare_enable() error

Honggang LI <honggangli@163.com>
    RDMA/rxe: Don't set BTH_ACK_MASK for UC or UD QPs

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Fix truncated output warning in alias_GUID.c

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Fix truncated output warning in mad.c

Andrei Lalaev <andrei.lalaev@anton-paar.com>
    Input: qt1050 - handle CHIP_ID reading error

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

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mfd: omap-usb-tll: Use struct_size to allocate tll

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

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Zheng Yejian <zhengyejian1@huawei.com>
    media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: move snd_usb_pipe_sanity_check into the USB core

Amit Cohen <amcohen@nvidia.com>
    selftests: forwarding: devlink_lib: Wait for udev events after reloading

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    bna: adjust 'name' buf size of bna_tcb and bna_ccb structures

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

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Initialize completion before mailbox

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()

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

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix board reset

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Increase VOP clk rate on RK3328

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: specify UFS core_clk frequencies

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

Tony Luck <tony.luck@intel.com>
    EDAC, skx: Retrieve and print retry_rd_err_log registers

Tony Luck <tony.luck@intel.com>
    EDAC, skx_common: Refactor so that we initialize "dev" in result of adxl decode.


-------------

Diffstat:

 Documentation/arm64/cpu-feature-registers.rst      |  38 ++++-
 Documentation/arm64/silicon-errata.rst             |  36 +++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  21 ++-
 arch/arm64/Kconfig                                 |  38 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   4 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   4 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   4 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/include/asm/cpucaps.h                   |   3 +-
 arch/arm64/include/asm/cputype.h                   |  16 ++
 arch/arm64/kernel/cpu_errata.c                     |  44 +++++
 arch/arm64/kernel/cpufeature.c                     |  94 ++++++++---
 arch/m68k/amiga/config.c                           |   9 ++
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/include/asm/mips-cm.h                    |   4 +
 arch/mips/kernel/smp-cps.c                         |   5 +-
 arch/mips/pci/pcie-octeon.c                        |   0
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/xmon/ppc-dis.c                        |  33 ++--
 arch/s390/pci/pci_irq.c                            | 132 +++++++++------
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/um/kernel/time.c                              |   4 +-
 arch/x86/events/intel/pt.c                         |   4 +-
 arch/x86/events/intel/pt.h                         |   4 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/mm/pti.c                                  |   6 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 drivers/acpi/battery.c                             |  16 +-
 drivers/acpi/sbs.c                                 |  23 +--
 drivers/android/binder.c                           |   4 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/devres.c                              |   8 +-
 drivers/base/module.c                              |   4 +
 drivers/block/rbd.c                                |  35 ++--
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/edac/Makefile                              |  10 +-
 drivers/edac/skx_base.c                            |  51 +++++-
 drivers/edac/skx_common.c                          | 146 ++++++++++++-----
 drivers/edac/skx_common.h                          |  19 ++-
 drivers/firmware/turris-mox-rwtm.c                 |  18 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   7 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   3 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/drm_client_modeset.c               |   5 +
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  47 +++++-
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/max6697.c                            |   5 +-
 drivers/i2c/i2c-smbus.c                            |  69 ++++++--
 drivers/infiniband/core/device.c                   |   6 +-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/keyboard/qt1050.c                    |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/irqchip/irq-imx-irqsteer.c                 |  40 ++++-
 drivers/irqchip/irq-mbigen.c                       |  20 ++-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/led-triggers.c                        |   2 +-
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/md/raid5.c                                 |  20 ++-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 drivers/media/platform/qcom/venus/vdec.c           |   1 +
 drivers/media/platform/vsp1/vsp1_histo.c           |  20 +--
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   8 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  35 +++-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  90 +++++++----
 drivers/media/usb/uvc/uvc_video.c                  |  37 ++++-
 drivers/media/usb/uvc/uvcvideo.h                   |   5 +
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mtd/tests/Makefile                         |  34 ++--
 drivers/mtd/tests/mtd_test.c                       |   9 ++
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 ++++--
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |  13 --
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |  23 +--
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  47 +++---
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/sr9700.c                           |  11 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 drivers/net/wireless/virt_wifi.c                   |  20 ++-
 drivers/nvme/host/pci.c                            |  10 +-
 drivers/parport/daisy.c                            |   6 +-
 drivers/parport/ieee1284.c                         |   4 +-
 drivers/parport/ieee1284_ops.c                     |   3 +-
 drivers/parport/parport_amiga.c                    |   2 +-
 drivers/parport/parport_atari.c                    |   2 +-
 drivers/parport/parport_cs.c                       |   6 +-
 drivers/parport/parport_gsc.c                      |  15 +-
 drivers/parport/parport_ip32.c                     |  25 ++-
 drivers/parport/parport_mfc3.c                     |   2 +-
 drivers/parport/parport_pc.c                       | 178 +++++++++------------
 drivers/parport/parport_sunbpp.c                   |   2 +-
 drivers/parport/probe.c                            |   7 +-
 drivers/parport/procfs.c                           |  28 ++--
 drivers/parport/share.c                            |  24 +--
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pcie-rockchip.c             |  12 +-
 drivers/pci/msi.c                                  |   4 +-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/power/supply/axp288_charger.c              |  24 +--
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |   5 +
 drivers/rtc/interface.c                            |   9 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-isl1208.c                          |  11 +-
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  38 +++--
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   7 +-
 drivers/scsi/ufs/ufshcd.c                          |  11 +-
 drivers/spi/spi-fsl-lpspi.c                        |  11 +-
 drivers/tty/serial/serial_core.c                   |   8 +
 drivers/usb/core/urb.c                             |  33 ++--
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/exec.c                                          |   8 +-
 fs/ext4/mballoc.c                                  |   3 +-
 fs/ext4/namei.c                                    |  73 +++++++--
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/inode.c                                    |   3 +
 fs/file.c                                          |   1 +
 fs/hfs/inode.c                                     |   3 +
 fs/hfsplus/bfind.c                                 |  15 +-
 fs/hfsplus/extents.c                               |   9 +-
 fs/hfsplus/hfsplus_fs.h                            |  21 +++
 fs/jbd2/journal.c                                  |   1 +
 fs/jfs/jfs_imap.c                                  |   5 +-
 fs/nilfs2/btnode.c                                 |  25 ++-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   7 +-
 fs/udf/balloc.c                                    |  51 +++---
 fs/udf/super.c                                     |   3 +-
 include/linux/compiler_attributes.h                |   1 +
 include/linux/irq.h                                |   7 +-
 include/linux/irqdomain.h                          |  10 ++
 include/linux/msi.h                                |   2 -
 include/linux/objagg.h                             |   1 -
 include/linux/pci_ids.h                            |   2 +
 include/linux/platform_data/x86/soc.h              |  65 ++++++++
 include/linux/qed/qed_eth_if.h                     |  21 +--
 include/linux/trace_events.h                       |   1 -
 include/linux/usb.h                                |   1 +
 include/net/netfilter/nf_tables.h                  |  21 ++-
 include/net/sctp/sctp.h                            |   4 +-
 include/net/sctp/structs.h                         |   8 +-
 include/trace/events/rpcgss.h                      |   2 +-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 kernel/debug/kdb/kdb_io.c                          |   6 +-
 kernel/dma/mapping.c                               |   2 +-
 kernel/events/core.c                               |   2 +
 kernel/events/internal.h                           |   2 +-
 kernel/irq/chip.c                                  |  32 ++--
 kernel/irq/irqdesc.c                               |   1 +
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |  24 +++
 kernel/trace/tracing_map.c                         |   6 +-
 kernel/watchdog_hld.c                              |  11 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 +-
 lib/objagg.c                                       |  18 +--
 mm/page-writeback.c                                |  30 +++-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/core/filter.c                                  |  15 +-
 net/core/link_watch.c                              |   4 +-
 net/ipv4/nexthop.c                                 |   7 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/ndisc.c                                   |  34 ++--
 net/iucv/af_iucv.c                                 |   4 +-
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nf_tables_api.c                      | 128 +++------------
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/packet/af_packet.c                             |  86 +++++++++-
 net/sctp/input.c                                   |  48 +++---
 net/sctp/proc.c                                    |  10 +-
 net/sctp/socket.c                                  |   6 +-
 net/smc/smc_core.c                                 |  32 ++--
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   2 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/tipc/udp_media.c                               |   5 +-
 net/wireless/nl80211.c                             |  10 +-
 net/wireless/util.c                                |   8 +-
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 security/apparmor/lsm.c                            |   7 +
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/soc/codecs/max98088.c                        |  10 +-
 sound/soc/intel/common/soc-intel-quirks.h          |  55 +------
 sound/usb/helper.c                                 |  16 +-
 sound/usb/helper.h                                 |   1 -
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/mixer_scarlett_gen2.c                    |   2 +-
 sound/usb/quirks.c                                 |  12 +-
 sound/usb/stream.c                                 |   4 +-
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/memory-model/lock.cat                        |  20 +--
 tools/perf/util/sort.c                             |   2 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 .../bpf/progs/btf_dump_test_case_multidim.c        |   4 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   3 +-
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 255 files changed, 2224 insertions(+), 1257 deletions(-)


