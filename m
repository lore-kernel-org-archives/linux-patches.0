Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A724EF4EE;
	Sat, 17 Aug 2024 08:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723881649; cv=none; b=qJdJpiaRL1Yg3ltufRyH4BxEX191VkXk2c62oNCLHjjZoMbK26jbQedLXffNGQlISUktT59gPH7Z/gMIEU+ypLcS2pmlwfXPucH32bePVfPE/6mhDs1sJ/2+LaiNTtZjDF81zoGW++Gl3iOyfVnxuPVsESVam6oOz7JMd0ScshA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723881649; c=relaxed/simple;
	bh=ZynNRVYFz5mcOP/8JOIf4Z1pypU4zekAWv3Nezuo+mU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MwosyJ0z+6l2NkKoRbWgiyhaeYyizpWLiXfoOl0D7Xvg9jAnTeKjTsJX0/+kpAaCmgFHbo8ZNnksIFW4d0rRXKaxWNdbTWEUpRcVnP1ig+A6jPVeoGIUCUOQsrIjekftMBn895e+UzonSwiVj3t2W23f3e2577hinlp2vtVkXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5Rn6fvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5Rn6fvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C0AC116B1;
	Sat, 17 Aug 2024 08:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723881649;
	bh=ZynNRVYFz5mcOP/8JOIf4Z1pypU4zekAWv3Nezuo+mU=;
	h=From:To:Cc:Subject:Date:From;
	b=g5Rn6fvcwRpgMAEVwmJPk/Yurf5EPhPHKiNJhNcggK+ikO283WSImIxijQVwfbb8e
	 vVXgYGoNWhndlRapqeurlVnoTNPuzoY+cw0sxbfh5wfI+0ZlgwHxhR/uVetuL7J6UA
	 SpECcmRGA/V3Cspo6XWaAynZp7Nyan7RhgQ59QPg=
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
Subject: [PATCH 5.15 000/479] 5.15.165-rc3 review
Date: Sat, 17 Aug 2024 10:00:38 +0200
Message-ID: <20240817075228.220424500@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.165-rc3
X-KernelTest-Deadline: 2024-08-19T07:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.165 release.
There are 479 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.165-rc3

Niklas Cassel <cassel@kernel.org>
    Revert "ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error"

Sean Young <sean@mess.org>
    media: Revert "media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()"

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode

Eric Dumazet <edumazet@google.com>
    wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values

Kees Cook <kees@kernel.org>
    binfmt_flat: Fix corruption when not offsetting data start

Chris Wulff <crwulff@gmail.com>
    usb: gadget: u_audio: Check return codes from usb_ep_enable and config_ep_by_speed.

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage

Amit Daniel Kachhap <amit.kachhap@arm.com>
    arm64: cpufeature: Fix the visibility of compat hwcaps

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: correct #clock-cells for QMP PHY nodes

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc: Avoid nmi_enter/nmi_exit in real mode interrupt.

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fully established after ADD_ADDR echo on MPJ

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: check basic rates validity

Jisheng Zhang <jszhang@kernel.org>
    PCI: dwc: Restore MSI Receiver mask during resume

Shenwei Wang <shenwei.wang@nxp.com>
    net: stmmac: Enable mac_managed_pm phylink config

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow clone callbacks to sleep

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bail out if stateful expression provides no .clone

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set element extended ACK reporting support

Jakub Kicinski <kuba@kernel.org>
    tls: fix race between tx work scheduling and socket close

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Fix use-after-free on concurrent DPC and hot-removal

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double inode unlock for direct IO sync writes

Christoph Hellwig <hch@lst.de>
    xfs: fix log recovery buffer allocation for the legacy h_size fixup

Filipe Manana <fdmanana@suse.com>
    btrfs: fix corruption after buffer fault in during direct IO append write

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check backup support in signal endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate backup in MPJ

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix backup support in signal endpoints

Geliang Tang <geliang.tang@suse.com>
    mptcp: export local_address

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set request_bkup flag when sending MP_PRIO

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix bad RCVPRUNED mib accounting

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

Yang Yingliang <yangyingliang@huawei.com>
    sched/smt: Fix unbalance sched_smt_present dec/inc

Yang Yingliang <yangyingliang@huawei.com>
    sched/smt: Introduce sched_smt_present_inc/dec() helper

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

Andrey Konovalov <andreyknvl@gmail.com>
    kcov: properly check for softirq context

George Kennedy <george.kennedy@oracle.com>
    serial: core: check uartclk for zero to avoid divide by zero

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Fix bogus clock_was_set() invocation in do_adjtimex()

Justin Stitt <justinstitt@google.com>
    ntp: Safeguard against time_constant overflow

Dan Williams <dan.j.williams@intel.com>
    driver core: Fix uevent_show() vs driver detach race

Arseniy Krasnov <avkrasnov@salutedevices.com>
    irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to 'raw_spinlock_t'

Qianggui Song <qianggui.song@amlogic.com>
    irqchip/meson-gpio: support more than 8 channels gpio irq

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()

Feng Tang <feng.tang@intel.com>
    clocksource: Scale the watchdog read retries automatically

Paul E. McKenney <paulmck@kernel.org>
    torture: Enable clocksource watchdog with "tsc=watchdog"

Waiman Long <longman@redhat.com>
    clocksource: Reduce the default clocksource_watchdog() retries to 2

Justin Stitt <justinstitt@google.com>
    ntp: Clamp maxerror and esterror to operating range

Jason Wang <jasowang@redhat.com>
    vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Move per CPU pointer access into the atomic section

Vamshi Gajjela <vamshigajjela@google.com>
    scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES

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

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: fix irq scheduling issue with PREEMPT_RT

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

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spidev: Add missing spi_device_id for bh2228fv

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Correct Soundwire ports mask

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask

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

Mark Rutland <mark.rutland@arm.com>
    arm64: barrier: Restore spec_bar() macro

Besar Wicaksono <bwicaksono@nvidia.com>
    arm64: Add Neoverse-V2 part

James Morse <james.morse@arm.com>
    arm64: cpufeature: Force HWCAP to be based on the sysreg visible to user-space

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: fix wrong unit use in ext4_mb_find_by_goal

Zheng Zucheng <zhengzucheng@huawei.com>
    sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    profiling: remove profile=sleep support

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a race to wake a sync task

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Prevent release of buffer in I/O

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: avoid memleak in jbd2_journal_write_metadata_buffer

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix uninitialized variable in ext4_inlinedir_to_tree

Michal Pecio <michal.pecio@gmail.com>
    media: uvcvideo: Fix the bandwdith quirk on USB 3.x

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Ignore empty TS packets

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Add null checker before passing variables

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the null pointer dereference in apply_state_adjust_rules

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix the null pointer dereference to ras_manager

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the null pointer dereference for smu7

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

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: wait for previous gc cycles when removing port

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

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a deadlock in dma buf fence polling

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: operate for period elapse event in process context"

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: obsolete workqueue for period update"

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

Justin Stitt <justinstitt@google.com>
    power: supply: bq24190_charger: replace deprecated strncpy with strscpy

Zhe Qiao <qiaozhe@iscas.ac.cn>
    riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().

Dan Carpenter <dan.carpenter@linaro.org>
    net: mvpp2: Don't re-use loop iterator

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Don't ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().

Florent Fourcot <florent.fourcot@wifirst.fr>
    rtnetlink: enable alt_ifname for setlink/newlink

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda: conexant: Fix headset auto detect fail in the polling mode

Eric Dumazet <edumazet@google.com>
    sched: act_ct: take care of padding in struct zones_ht_key

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Danilo Krummrich <dakr@kernel.org>
    drm/nouveau: prime: fix refcount underflow

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix ls2k1000-rtc interrupt

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix liointc IRQ polarity

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a

Binbin Zhou <zhoubinbin@loongson.cn>
    MIPS: Loongson64: DTS: Add RTC support to Loongson-2K1000

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Fix all mstb marked as not probed after suspend/resume

Shenwei Wang <shenwei.wang@nxp.com>
    irqchip/imx-irqsteer: Handle runtime power management correctly

Lucas Stach <l.stach@pengutronix.de>
    irqchip/imx-irqsteer: Add runtime PM support

Lucas Stach <l.stach@pengutronix.de>
    irqchip/imx-irqsteer: Constify irq_chip struct

Marc Zyngier <maz@kernel.org>
    genirq: Allow the PM device to originate from irq domain

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Fixed unbalanced fwnode get and put

Thomas Weißschuh <linux@weissschuh.net>
    leds: triggers: Flush pending brightness before activating trigger

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Call synchronize_rcu() before calling trig->activate()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Store brightness set by led_trigger_event()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Remove unused function led_trigger_rename_static()

Johannes Berg <johannes.berg@intel.com>
    leds: trigger: use RCU to protect the led_cdevs list

Jay Buddhabhatti <jay.buddhabhatti@amd.com>
    drivers: soc: xilinx: check return status of get_api_version()

Michael Tretter <m.tretter@pengutronix.de>
    soc: xilinx: move PM_INIT_FINALIZE to zynqmp_pm_domains driver

Zhang Yi <yi.zhang@huawei.com>
    ext4: check the extent status again before inserting delalloc block

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out a common helper to query extent map

Zhang Yi <yi.zhang@huawei.com>
    ext4: convert to exclusive lock while inserting delalloc extents

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_da_map_blocks()

Baokun Li <libaokun1@huawei.com>
    ext4: make ext4_es_insert_extent() return void

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: always initialize i_uid/i_gid

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8998: switch USB QMP PHY to new style of bindings

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: msm8998: drop USB PHY clock index

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: msm8996: Move '#clock-cells' to QMP PHY child node

Esben Haabendal <esben@geanix.com>
    powerpc/configs: Update defconfig with now user-visible CONFIG_FSL_IFC

Seth Forshee (DigitalOcean) <sforshee@kernel.org>
    fs: don't allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT

Leon Romanovsky <leon@kernel.org>
    nvme-pci: add missing condition check for existence of mapped data

Jens Axboe <axboe@kernel.dk>
    nvme: separate command prep and issue

Jens Axboe <axboe@kernel.dk>
    nvme: split command copy into a helper

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Allow allocation of more than 1 MSI interrupt

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Refactor arch_setup_msi_irqs()

Thomas Gleixner <tglx@linutronix.de>
    s390/pci: Rework MSI descriptor walk

ethanwu <ethanwu@synology.com>
    ceph: fix incorrect kmalloc size of pagevec mempool

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable

Conor Dooley <conor.dooley@microchip.com>
    spi: spidev: add correct compatible for Rohm BH2228FV

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: spidev: order compatibles alphabetically

Vincent Tremblay <vincent@vtremblay.dev>
    spidev: Add Silicon Labs EM3581 device compatible

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: spidev: Replace OF specific code by device property API

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: spidev: Replace ACPI specific code by device_get_match_data()

Javier Martinez Canillas <javierm@redhat.com>
    spi: spidev: Make probe to fail early if a spidev compatible is used

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

Hou Tao <houtao1@huawei.com>
    bpf, events: Use prog to emit ksymbol event for main program

Lance Richardson <rlance@google.com>
    dma: fix call order in dmam_free_coherent

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix no-args func prototype BTF dumping syntax

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix signal blocking race/hang

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix time-travel-start option

Ma Ke <make24@iscas.ac.cn>
    phy: cadence-torrent: Check return value on register read

Vignesh Raghavendra <vigneshr@ti.com>
    dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels

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
    MIPS: Loongson64: Test register availability before use

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: reset: Prioritise firmware service

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Remove memory node for builtin-dtb

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: env: Hook up Loongsson-2K

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix GMAC phy node

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: ip30: ip30-console: Add missing include

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Skip over memory region when node value is NULL

Gwenael Treuveur <gwenael.treuveur@foss.st.com>
    remoteproc: stm32_rproc: Fix mailbox interrupts queuing

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

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Reset intel_dp->link_trained before retraining the link

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell

Nitin Gote <nitin.r.gote@intel.com>
    drm/i915/gt: Do not consider preemption during execlists_dequeue for gen8

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix a topa_entry base address calculation

Marco Cavenati <cavenati.marco@gmail.com>
    perf/x86/intel/pt: Fix topa_entry base length

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the bits of the CHA extended umask for SPR

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix event leak upon exec and file release

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix event leak upon exit

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: validate nvme_local_port correctly

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Complete command early within lock

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix flash read failure

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Use QP lock to search for bsg

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix for possible memory corruption

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Unable to act on RSCN for port online

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: During vport delete send async logout explicitly

Joy Chakraborty <joychakr@google.com>
    rtc: cmos: Fix return value of nvmem callbacks

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    mm/numa_balancing: teach mpol_to_str about the balancing mode

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix memory leakage caused by driver API devm_free_percpu()

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix devm_krealloc() wasting memory

Bailey Forrest <bcf@google.com>
    gve: Fix an edge case for TSO skb validity check

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

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

Huacai Chen <chenhuacai@kernel.org>
    fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Manivannan Sadhasivam <mani@kernel.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Niklas Cassel <cassel@kernel.org>
    PCI: dw-rockchip: Fix initial PERST# GPIO value

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix bug in lock.cat

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Add a quirk for Sonix HD USB Camera

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Move HD Webcam quirk to the right place

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Fix microphone sound on HD webcam.

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix integer overflow calculating timestamp

Jan Kara <jack@suse.cz>
    jbd2: make jbd2_journal_get_max_txn_bufs() internal

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    leds: ss4200: Convert PCIBIOS_* return codes to errnos

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: Fix interface type change

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add cred_transfer test

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: tighten task exit cancellations

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

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Eric Sandeen <sandeen@redhat.com>
    fuse: verify {g,u}id mount options correctly

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

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mm: mmap_lock: replace get_memcg_path_buf() with on-stack buffer

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix possible recursive locking detected warning

Jann Horn <jannh@google.com>
    landlock: Don't lose track of restrictions on cred_transfer

Carlos López <clopez@suse.de>
    s390/dasd: fix error checks in dasd_copy_pair_store()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Missed error return

Csókás, Bence <csokas.bence@prolan.hu>
    rtc: interface: Add RTC offset to alarm after fix-up

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix field-spanning write in INDEX_HDR

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Replace inode_trylock with inode_lock

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

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix getting file type

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Missed NI_FLAG_UPDATE_PARENT setting

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix transform resident to nonresident for compressed files

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Merge synonym COMPRESSION_UNIT and NTFS_LZNT_CUNIT

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use ALIGN kernel macro

Martin Willi <martin@strongswan.org>
    net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports

Martin Willi <martin@strongswan.org>
    net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo: fix initial map fill

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: constify lookup fn args where possible

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix insufficient extend DB for VFs.

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix undifined behavior caused by invalid max_sge

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing pagesize and alignment check in FRMR

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Denis Arefev <arefev@swemel.ru>
    net: missing check virtio

Michael S. Tsirkin <mst@redhat.com>
    vhost/vsock: always initialize seqpacket_allow

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: Clean up error handling in vpci_scan_bus()

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

Leon Romanovsky <leon@kernel.org>
    RDMA/cache: Release GID table even if leak is detected

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE

James Clark <james.clark@arm.com>
    coresight: Fix ref leak when of_coresight_parse_endpoint() fails

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock

Konrad Dybcio <konrad.dybcio@linaro.org>
    clk: qcom: branch: Add helper functions for setting retain bits

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix resource double counting on remove & rescan

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fixup gss_status tracepoint error output

Andreas Larsson <andreas@gaisler.com>
    sparc64: Fix incorrect function signature and add prototype for prom_cif_init

Jan Kara <jack@suse.cz>
    ext4: avoid writing unitialized memory to disk in EA inodes

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: don't track ranges in fast_commit if inode has inlined data

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: return early for non-eligible fast_commit track events

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 another fix for EXCHGID4_FLAG_USE_PNFS_DS for DS server

NeilBrown <neilb@suse.de>
    SUNRPC: avoid soft lockup when transmitting UDP to reachable server.

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix rpcrdma_reqs_reset()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mfd: omap-usb-tll: Use struct_size to allocate tll

Arnd Bergmann <arnd@arndb.de>
    mfd: rsmu: Split core code into separate module

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix exclude_guest setting

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix aux_watermark calculation for 64-bit size

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

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Add DRM_MODE_ROTATE_0 to rotation property

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Add missing plane settings when async update

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Store RPF partition configuration per RPF instance

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Fix _irqsave and _irq mix

Daniel Schaefer <dhs@frame.work>
    media: uvcvideo: Override default flags

Aleksandr Burakov <a.burakov@rosalinux.ru>
    saa7134: Unchecked i2c_transfer function result fixed

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: i2c: Fix imx412 exposure control

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Zheng Yejian <zhengyejian1@huawei.com>
    media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators

Friedrich Vock <friedrich.vock@gmx.de>
    drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fix aldebaran pcie speed reporting

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

John Stultz <jstultz@google.com>
    locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers

Johannes Berg <johannes.berg@intel.com>
    wifi: virt_wifi: don't use strlen() in const context

Gaosheng Cui <cuigaosheng1@huawei.com>
    gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey

En-Wei Wu <en-wei.wu@canonical.com>
    wifi: virt_wifi: avoid reporting connection success with wrong SSID

Adrian Hunter <adrian.hunter@intel.com>
    perf: Fix default aux_watermark calculation

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

Donglin Peng <dolinux.peng@gmail.com>
    libbpf: Checking the btf_type kind when fixing variable offsets

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

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_v[46]_err()

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_write_err()

Eric Dumazet <edumazet@google.com>
    tcp: add tcp_done_with_error() helper

Eric Dumazet <edumazet@google.com>
    tcp: annotate lockless access to sk->sk_err

Eric Dumazet <edumazet@google.com>
    tcp: annotate lockless accesses to sk->sk_err_soft

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

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Do not complete if there are no waiters

Christophe Leroy <christophe.leroy@csgroup.eu>
    vmlinux.lds.h: catch .bss..L* sections into BSS")

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

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add ports node for anx7625

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
    arm64: dts: qcom: sm8250: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: switch UFS QMP PHY to new style of bindings

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: add power-domain to UFS PHY

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix swapped temp{1,8} critical alarms

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix underflow when writing limit attributes

Yao Zi <ziyao@disroot.org>
    drm/meson: fix canvas release in bind function

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

Christoph Hellwig <hch@lst.de>
    block: initialize integrity buffer to zero before writing it to media

Jinyoung Choi <j-young.choi@samsung.com>
    block: cleanup bio_integrity_prep

Nitesh Shetty <nj.shetty@samsung.com>
    block: refactor to use helper

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_debugfs: fix wrong EC message version

Arnd Bergmann <arnd@arndb.de>
    EDAC, i10nm: make skx_common.o a separate module

Chao Yu <chao@kernel.org>
    f2fs: fix to don't dirty inode for readonly filesystem

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_convert_inline_inode()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  10 +-
 Documentation/arm64/cpu-feature-registers.rst      |  38 ++++-
 Documentation/arm64/silicon-errata.rst             |  36 ++++
 .../devicetree/bindings/thermal/thermal-zones.yaml |   5 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi        |  23 ---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  26 ++-
 arch/arm/mach-pxa/spitz.c                          |  39 ++++-
 arch/arm/mach-pxa/{include/mach => }/spitz.h       |   2 +-
 arch/arm/mach-pxa/spitz_pm.c                       |   2 +-
 arch/arm64/Kconfig                                 |  38 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   4 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   4 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   4 +-
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |  25 +--
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   2 -
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   6 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  36 ++--
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  22 +--
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   3 -
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/include/asm/barrier.h                   |   4 +
 arch/arm64/include/asm/cputype.h                   |  16 ++
 arch/arm64/kernel/cpu_errata.c                     |  31 ++++
 arch/arm64/kernel/cpufeature.c                     |  94 +++++++++--
 arch/arm64/kernel/proton-pack.c                    |  12 ++
 arch/arm64/tools/cpucaps                           |   1 +
 arch/m68k/amiga/config.c                           |   9 +
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |  98 +++++++----
 arch/mips/include/asm/mach-loongson64/boot_param.h |   2 +
 arch/mips/include/asm/mips-cm.h                    |   4 +
 arch/mips/kernel/smp-cps.c                         |   5 +-
 arch/mips/loongson64/env.c                         |   8 +
 arch/mips/loongson64/reset.c                       |  38 ++---
 arch/mips/loongson64/smp.c                         |  23 ++-
 arch/mips/pci/pcie-octeon.c                        |   0
 arch/mips/sgi-ip30/ip30-console.c                  |   1 +
 arch/powerpc/configs/85xx-hw.config                |   2 +
 arch/powerpc/include/asm/interrupt.h               |  14 +-
 arch/powerpc/include/asm/percpu.h                  |  10 ++
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/xmon/ppc-dis.c                        |  33 ++--
 arch/riscv/mm/fault.c                              |  17 +-
 arch/s390/pci/pci_irq.c                            | 116 ++++++++-----
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/um/kernel/time.c                              |   4 +-
 arch/um/os-Linux/signal.c                          | 118 ++++++++++---
 arch/x86/events/intel/pt.c                         |   4 +-
 arch/x86/events/intel/pt.h                         |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/mm/pti.c                                  |   8 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 block/bio-integrity.c                              |  21 ++-
 drivers/acpi/battery.c                             |  16 +-
 drivers/acpi/sbs.c                                 |  23 +--
 drivers/android/binder.c                           |   4 +-
 drivers/ata/libata-scsi.c                          |  10 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/devres.c                              |  11 +-
 drivers/base/module.c                              |   4 +
 drivers/block/rbd.c                                |  35 ++--
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clk/qcom/clk-branch.h                      |  26 +++
 drivers/clk/qcom/gcc-sc7280.c                      |   3 +
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/dma/ti/k3-udma.c                           |   4 +-
 drivers/edac/Makefile                              |  10 +-
 drivers/edac/skx_common.c                          |  21 ++-
 drivers/edac/skx_common.h                          |   4 +-
 drivers/firmware/turris-mox-rwtm.c                 |  23 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |  12 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  55 +++---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  14 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   4 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/drm_client_modeset.c               |   5 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |   4 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  53 +++++-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   6 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  17 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h        |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |   4 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  37 ++--
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   8 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/max6697.c                            |   5 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   4 +-
 drivers/i2c/i2c-smbus.c                            |  64 ++++++-
 drivers/infiniband/core/cache.c                    |  14 +-
 drivers/infiniband/core/device.c                   |   6 +-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 +
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  13 ++
 drivers/infiniband/hw/mlx5/odp.c                   |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/keyboard/qt1050.c                    |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/iommu/sprd-iommu.c                         |   2 +-
 drivers/irqchip/irq-imx-irqsteer.c                 |  40 ++++-
 drivers/irqchip/irq-mbigen.c                       |  20 ++-
 drivers/irqchip/irq-meson-gpio.c                   |  35 ++--
 drivers/irqchip/irq-xilinx-intc.c                  |   2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/led-class.c                           |   1 -
 drivers/leds/led-triggers.c                        |  75 ++++----
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/leds/trigger/ledtrig-timer.c               |   5 -
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/md/md.c                                    |   1 -
 drivers/md/raid5.c                                 |  20 ++-
 drivers/media/i2c/imx412.c                         |   9 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 drivers/media/platform/qcom/venus/vdec.c           |   3 +-
 drivers/media/platform/vsp1/vsp1_histo.c           |  20 +--
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   8 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/rc/lirc_dev.c                        |   4 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   9 +-
 drivers/media/usb/uvc/uvc_video.c                  |  47 +++++-
 drivers/memory/Kconfig                             |   2 +-
 drivers/mfd/Makefile                               |   6 +-
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mfd/rsmu_core.c                            |   2 +
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/tests/Makefile                         |  34 ++--
 drivers/mtd/tests/mtd_test.c                       |   9 +
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/dsa/bcm_sf2.c                          |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   3 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 ++++--
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  22 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c   |  18 +-
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |  38 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |  13 --
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/sr9700.c                           |  11 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  15 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 drivers/net/wireless/virt_wifi.c                   |  20 ++-
 drivers/nvme/host/pci.c                            |  99 ++++++-----
 drivers/parport/procfs.c                           |  24 +--
 drivers/pci/controller/dwc/pcie-designware-host.c  |   7 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pcie-rockchip.c             |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  12 +-
 drivers/pci/pci.c                                  |  19 ++-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/phy/cadence/phy-cadence-torrent.c          |   3 +
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  17 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/chrome/cros_ec_proto.c            |   2 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/power/supply/axp288_charger.c              |  24 +--
 drivers/power/supply/bq24190_charger.c             |   2 +-
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |  10 +-
 drivers/remoteproc/stm32_rproc.c                   |   2 +-
 drivers/rtc/interface.c                            |   9 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-isl1208.c                          |  11 +-
 drivers/s390/block/dasd_devmap.c                   |  10 +-
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  11 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  20 ++-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  98 ++++++-----
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |  35 +++-
 drivers/scsi/qla2xxx/qla_init.c                    |  87 ++++++++--
 drivers/scsi/qla2xxx/qla_inline.h                  |   8 +
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   7 +-
 drivers/scsi/qla2xxx/qla_sup.c                     | 108 ++++++++----
 drivers/scsi/ufs/ufshcd.c                          |  11 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/soc/qcom/rpmh.c                            |   1 -
 drivers/soc/xilinx/zynqmp_pm_domains.c             |  16 ++
 drivers/soc/xilinx/zynqmp_power.c                  |   5 +-
 drivers/spi/spi-fsl-lpspi.c                        |   6 +-
 drivers/spi/spidev.c                               |  95 +++++------
 drivers/tty/serial/serial_core.c                   |   8 +
 drivers/usb/gadget/function/u_audio.c              |  42 ++++-
 drivers/usb/gadget/function/u_serial.c             |   1 +
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/vhost/vsock.c                              |   4 +-
 fs/binfmt_flat.c                                   |   4 +-
 fs/btrfs/ctree.h                                   |   1 +
 fs/btrfs/file.c                                    |  60 +++++--
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/ceph/super.c                                    |   3 +-
 fs/exec.c                                          |   8 +-
 fs/ext2/balloc.c                                   |  11 +-
 fs/ext4/extents.c                                  |   5 +-
 fs/ext4/extents_status.c                           |  16 +-
 fs/ext4/extents_status.h                           |   6 +-
 fs/ext4/fast_commit.c                              |  65 +++++--
 fs/ext4/inline.c                                   |   6 +-
 fs/ext4/inode.c                                    | 115 +++++++------
 fs/ext4/mballoc.c                                  |   3 +-
 fs/ext4/namei.c                                    |  88 +++++++---
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/inline.c                                   |   6 +-
 fs/f2fs/inode.c                                    |   3 +
 fs/file.c                                          |   1 +
 fs/fuse/inode.c                                    |  24 ++-
 fs/hfs/inode.c                                     |   3 +
 fs/hfsplus/bfind.c                                 |  15 +-
 fs/hfsplus/extents.c                               |   9 +-
 fs/hfsplus/hfsplus_fs.h                            |  21 +++
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |   6 +
 fs/jfs/jfs_imap.c                                  |   5 +-
 fs/nfs/nfs4client.c                                |   6 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nilfs2/btnode.c                                 |  25 ++-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   2 +-
 fs/ntfs3/attrib.c                                  |  14 +-
 fs/ntfs3/bitmap.c                                  |   2 +-
 fs/ntfs3/dir.c                                     |   3 +-
 fs/ntfs3/file.c                                    |   5 +-
 fs/ntfs3/frecord.c                                 |   2 +-
 fs/ntfs3/fslog.c                                   |   5 +-
 fs/ntfs3/fsntfs.c                                  |   2 +-
 fs/ntfs3/index.c                                   |   4 +-
 fs/ntfs3/inode.c                                   |   2 +-
 fs/ntfs3/ntfs.h                                    |  13 +-
 fs/ntfs3/ntfs_fs.h                                 |   2 +
 fs/proc/proc_sysctl.c                              |   6 +-
 fs/proc/task_mmu.c                                 |   2 +
 fs/super.c                                         |  11 ++
 fs/udf/balloc.c                                    |  51 +++---
 fs/udf/super.c                                     |   3 +-
 fs/xfs/xfs_log_recover.c                           |  20 ++-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/clocksource.h                        |  14 +-
 include/linux/hugetlb.h                            |   1 +
 include/linux/irq.h                                |   7 +-
 include/linux/irqdomain.h                          |  10 ++
 include/linux/jbd2.h                               |   5 -
 include/linux/leds.h                               |  32 ++--
 include/linux/objagg.h                             |   1 -
 include/linux/pci_ids.h                            |   2 +
 include/linux/perf_event.h                         |   1 +
 include/linux/profile.h                            |   1 -
 include/linux/sched/signal.h                       |   6 +
 include/linux/task_work.h                          |   3 +-
 include/linux/trace_events.h                       |   1 -
 include/linux/virtio_net.h                         |  11 ++
 include/net/netfilter/nf_tables.h                  |  20 ++-
 include/net/sctp/sctp.h                            |   4 +-
 include/net/sctp/structs.h                         |   8 +-
 include/net/tcp.h                                  |   1 +
 include/trace/events/mptcp.h                       |   2 +-
 include/trace/events/rpcgss.h                      |   2 +-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 io_uring/io-wq.c                                   |  10 +-
 io_uring/io_uring.c                                |   5 +-
 kernel/bpf/btf.c                                   |  10 +-
 kernel/debug/kdb/kdb_io.c                          |   6 +-
 kernel/dma/mapping.c                               |   2 +-
 kernel/events/core.c                               |  77 ++++++---
 kernel/events/internal.h                           |   2 +-
 kernel/events/ring_buffer.c                        |   4 +-
 kernel/irq/chip.c                                  |  32 ++--
 kernel/irq/irqdesc.c                               |   1 +
 kernel/irq/irqdomain.c                             |   7 +-
 kernel/irq/manage.c                                |   2 +-
 kernel/kcov.c                                      |  15 +-
 kernel/kprobes.c                                   |   4 +-
 kernel/locking/rwsem.c                             |   6 +-
 kernel/padata.c                                    |   7 +
 kernel/profile.c                                   |  16 +-
 kernel/rcu/rcutorture.c                            |   2 +-
 kernel/sched/core.c                                |  50 +++---
 kernel/sched/cputime.c                             |   6 +
 kernel/sched/fair.c                                |  19 +--
 kernel/sched/sched.h                               |   2 +-
 kernel/signal.c                                    |   8 +
 kernel/task_work.c                                 |  34 +++-
 kernel/time/clocksource-wdtest.c                   |  13 +-
 kernel/time/clocksource.c                          |  10 +-
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |  24 +++
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/tracing_map.c                         |   6 +-
 kernel/watchdog_hld.c                              |  11 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 +-
 lib/objagg.c                                       |  18 +-
 mm/hugetlb.c                                       |   2 +-
 mm/mempolicy.c                                     |  18 +-
 mm/mmap_lock.c                                     | 175 +++----------------
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bridge/br_multicast.c                          |   4 +-
 net/core/filter.c                                  |  15 +-
 net/core/link_watch.c                              |   4 +-
 net/core/rtnetlink.c                               |  65 +++----
 net/core/xdp.c                                     |   4 +-
 net/ipv4/esp4.c                                    |   3 +-
 net/ipv4/netfilter/iptable_nat.c                   |  18 +-
 net/ipv4/nexthop.c                                 |   7 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/tcp.c                                     |  13 +-
 net/ipv4/tcp_input.c                               |  34 ++--
 net/ipv4/tcp_ipv4.c                                |  19 +--
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv4/tcp_timer.c                               |  10 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/esp6.c                                    |   3 +-
 net/ipv6/ndisc.c                                   |  34 ++--
 net/ipv6/netfilter/ip6table_nat.c                  |  14 +-
 net/ipv6/tcp_ipv6.c                                |  19 +--
 net/iucv/af_iucv.c                                 |   4 +-
 net/l2tp/l2tp_core.c                               |  15 +-
 net/mac80211/cfg.c                                 |  21 +--
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/options.c                                |   5 +-
 net/mptcp/pm.c                                     |   9 +
 net/mptcp/pm_netlink.c                             |  48 ++++--
 net/mptcp/protocol.c                               |  18 +-
 net/mptcp/protocol.h                               |   4 +
 net/mptcp/subflow.c                                |  24 ++-
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nf_tables_api.c                      | 188 ++++-----------------
 net/netfilter/nft_connlimit.c                      |   4 +-
 net/netfilter/nft_counter.c                        |   4 +-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_last.c                           |   4 +-
 net/netfilter/nft_limit.c                          |  14 +-
 net/netfilter/nft_quota.c                          |   4 +-
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_pipapo.c                     |  40 +++--
 net/netfilter/nft_set_pipapo.h                     |  27 ++-
 net/netfilter/nft_set_pipapo_avx2.c                |  81 +++++----
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/packet/af_packet.c                             |  86 +++++++++-
 net/sched/act_ct.c                                 |   4 +-
 net/sctp/input.c                                   |  48 +++---
 net/sctp/proc.c                                    |  10 +-
 net/sctp/socket.c                                  |   6 +-
 net/smc/smc_core.c                                 |   5 +-
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   2 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   3 +-
 net/sunrpc/xprtrdma/verbs.c                        |  16 +-
 net/tipc/udp_media.c                               |   5 +-
 net/tls/tls_sw.c                                   |  16 +-
 net/wireless/nl80211.c                             |  16 +-
 net/wireless/util.c                                |   8 +-
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 security/apparmor/lsm.c                            |   7 +
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_unpack.c                  |   1 +
 security/keys/keyctl.c                             |   2 +-
 security/landlock/cred.c                           |  11 +-
 sound/firewire/amdtp-stream.c                      |  38 +++--
 sound/firewire/amdtp-stream.h                      |   1 +
 sound/pci/hda/patch_conexant.c                     |  54 +-----
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/max98088.c                        |  10 +-
 sound/soc/codecs/wcd938x-sdw.c                     |   4 +-
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/intel/common/soc-intel-quirks.h          |   2 +-
 sound/soc/meson/axg-fifo.c                         |  26 ++-
 sound/soc/pxa/spitz.c                              |  58 +++----
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/mixer.c                                  |   7 +
 sound/usb/quirks-table.h                           |   4 +
 sound/usb/quirks.c                                 |   4 +
 sound/usb/stream.c                                 |   4 +-
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/lib/bpf/linker.c                             |  11 +-
 tools/memory-model/lock.cat                        |  20 +--
 tools/perf/arch/x86/util/intel-pt.c                |  15 +-
 tools/perf/util/sort.c                             |   2 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   2 +-
 .../bpf/progs/btf_dump_test_case_multidim.c        |   4 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   9 +-
 .../drivers/net/mlxsw/spectrum-2/tc_flower.sh      |  55 +++++-
 tools/testing/selftests/landlock/base_test.c       |  74 ++++++++
 tools/testing/selftests/landlock/config            |   5 +-
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  41 ++++-
 tools/testing/selftests/rcutorture/bin/torture.sh  |   6 +-
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 463 files changed, 4085 insertions(+), 2385 deletions(-)


