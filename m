Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AB325F78F;
	Tue, 11 Mar 2025 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705397; cv=none; b=GvyMSSOn9tkOlnHlizutmtnRaKgcqQANP5+8Yre05CG02sLw7UDOxh3cGmV3LSteghyzPKKK40qnhDV3t1FOzTVBoFRJdUZCX5ui9wgQfo+lmSRZ0I58au+RcrU+IWdaiARnC1YTNqbQD9TXcmK9WVD6fWAVrCwuFg1c8cPPcZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705397; c=relaxed/simple;
	bh=/k6fuY39NMvhVjrcQnGXRKOGRNqFGSehFFvvZoXxRUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IZBStLgAiIkNF3oG/B/N8kcPG2gTn02u3iCyn7Vt2uxXtnyoPvKvk3fAtptPWrbw3EUc/YawpFW6NDRUR2q23yygYt5vSux75nwl03qaSvX36iOrGcqs4WuAsbceWWA+vB1xGIG3vL/nFiHqf+LQ6q+0ZJzeLSpOQDltPSk56gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F86ftM0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F86ftM0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034F1C4CEE9;
	Tue, 11 Mar 2025 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705396;
	bh=/k6fuY39NMvhVjrcQnGXRKOGRNqFGSehFFvvZoXxRUI=;
	h=From:To:Cc:Subject:Date:From;
	b=F86ftM0Y4lY3rh1rieODapmfjteVVuxIftNrwuh+yy5/HwmmMpgb4c3K/hGlnKCNP
	 7Ff++hy2ebxr2VDnWuVTLAmgAb/RX3L39qsXVVQsvo0yxGVVoOIvBSLjc7q+NHqjb9
	 hp9yuNj+KytvHh07/mV+5EcBdMHt5cJyKbVwBl0Y=
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
Subject: [PATCH 5.4 000/328] 5.4.291-rc1 review
Date: Tue, 11 Mar 2025 15:56:10 +0100
Message-ID: <20250311145714.865727435@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.291-rc1
X-KernelTest-Deadline: 2025-03-13T14:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.291 release.
There are 328 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.291-rc1

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Make GPIO lookup table match the device

Visweswara Tanuku <quic_vtanuku@quicinc.com>
    slimbus: messaging: Free transaction ID in delayed interrupt scenario

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-P/U support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-H support

Pawel Chmielewski <pawel.chmielewski@intel.com>
    intel_th: pci: Add Arrow Lake support

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check the inode number is not the invalid value of zero

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    xhci: pci: Fix indentation in the PCI device ID definitions

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: Check bmAttributes only if configuration is valid

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: gadget: Fix setting self-powered state on suspend

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: Set self-powered based on MaxPower and bmAttributes

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality

Fedor Pchelkin <boddah8794@gmail.com>
    usb: typec: ucsi: increase timeout for PPM reset operations

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix a flaw in existing endpoint checks

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Flush the notify_hotplug_work

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Use devm_usb_get_phy()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Call clk_put()

Christian Heusel <christian@heusel.eu>
    Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    gpio: rcar: Fix missing of_node_put() call

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix missing dst ref drop in ila lwtunnel

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop in ila lwtunnel

Jason Xing <kerneljasonxing@gmail.com>
    net-timestamp: support TCP GSO case for a few missing flags

Oscar Maes <oscmaes92@gmail.com>
    vlan: enforce underlying device type

Jiayuan Chen <jiayuan.chen@linux.dev>
    ppp: Fix KMSAN uninit-value warning with bpf

Nikolay Aleksandrov <razor@blackwall.org>
    be2net: fix sleeping while atomic bugs in be_ndo_bridge_getlink

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix preprocessor guard

Xinghuo Chen <xinghuo.chen@foxmail.com>
    hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()

Eric Dumazet <edumazet@google.com>
    llc: do not use skb_get() before dev_queue_xmit()

Erik Schumacher <erik.schumacher@iris-sensing.com>
    hwmon: (ad7314) Validate leading zero bits and return error

Maud Spierings <maudspierings@gocontroll.com>
    hwmon: (ntc_thermistor) Fix the ncpXXxh103 sensor table

Titus Rwantare <titusr@google.com>
    hwmon: (pmbus) Initialise page count in pmbus_identify()

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    caif_virtio: fix wrong pointer check in cfv_probe()

Antoine Tenart <atenart@kernel.org>
    net: gso: fix ownership in __udp_gso_segment

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()

Yu-Chun Lin <eleanor15x@gmail.com>
    HID: google: fix unused variable warning under !CONFIG_ACPI

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: limit printed string from FW file

Hao Zhang <zhanghao1@kylinos.cn>
    mm/page_alloc: fix uninitialized variable

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: fix an API misues when rio_add_net() fails

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: add check for rio_add_net() in rio_scan_alloc_net()

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    wifi: nl80211: reject cooked mode if it is set along with other flags

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: cfg80211: regulatory: improve invalid hints checking

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Properly parse CPUID leaf 0x2 TLB descriptor 0x63

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Validate CPUID leaf 0x2 EDX output

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cacheinfo: Validate CPUID leaf 0x2 EDX output

Mingcong Bai <jeffbai@aosc.io>
    platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e

Richard Thier <u9vata@gmail.com>
    drm/radeon: Fix rs400_gpu_init for ATI mobility radeon Xpress 200M

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: update ALC222 depop optimize

Hoku Ishibe <me@hokuishi.be>
    ALSA: hda: intel: Add Dell ALC3271 to power_save denylist

Daniil Dulov <d.dulov@aladdin.ru>
    HID: appleir: Fix potential NULL dereference at raw event handle

Rob Herring (Arm) <robh@kernel.org>
    Revert "of: reserved-memory: Fix using wrong number of cells to get property 'alignment'"

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable BAR resize on Dell G5 SE

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Check extended configuration space register when system uses large bar

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: skip BAR resizing if the bios already did it

Christian Brauner <brauner@kernel.org>
    acct: perform last write from workqueue

Yang Yang <yang.yang29@zte.com.cn>
    kernel/acct.c: use dedicated helper to access rlimit values

Hui Su <sh_def@163.com>
    kernel/acct.c: use #elif instead of #end and #elif

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    drop_monitor: fix incorrect initialization order

Quang Le <quanglex97@gmail.com>
    pfifo_tail_enqueue: Drop new packet when sch->limit == 0

Thomas Gleixner <tglx@linutronix.de>
    sched/core: Prevent rescheduling when interrupts are disabled

Kaustabh Chakraborty <kauschluss@disroot.org>
    phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk

BH Hsieh <bhsieh@nvidia.com>
    phy: tegra: xusb: reset VBUS & ID OVERRIDE

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usbnet: gl620a: fix endpoint checking in genelink_bind()

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix low freq setting via IOC_PERIOD

Nikolay Kuratov <kniv@yandex-team.ru>
    ftrace: Avoid potential division by zero in function_stat_show()

Russell Senior <russell@personaltelco.net>
    x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems

Harshal Chaudhari <hchaudhari@marvell.com>
    net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.

Philo Lu <lulie@linux.alibaba.com>
    ipvs: Always clear ipvs_property flag in skb_scrub_packet()

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: es8328: fix route from DAC to output

Sean Anderson <sean.anderson@linux.dev>
    net: cadence: macb: Synchronize stats calculations

Ido Schimmel <idosch@nvidia.com>
    net: loopback: Avoid sending IP packets without an Ethernet header

Arnd Bergmann <arnd@arndb.de>
    sunrpc: suppress warnings for unused procfs functions

Sven Eckelmann <sven@narfation.org>
    batman-adv: Drop unmanaged ELP metric worker

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore neighbor throughput metrics in error case

Christian Brauner <brauner@kernel.org>
    acct: block access to kernel internal filesystems

John Veness <john-linux@pelago.org.uk>
    ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED

Haoxiang Li <haoxiang_li2024@163.com>
    nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix supplicant wait loop

Andrey Vatoropin <a.vatoropin@crpt.ru>
    power: supply: da9150-fg: fix potential overflow

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix port range key handling in BPF conversion

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix handling of mixed port and port-range keys

Maksym Glubokiy <maksym.glubokiy@plvision.eu>
    net: extract port range fields from fl_flow_key

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Suppress list corruption splat in geneve_destroy_tunnels().

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Fix use-after-free in geneve_find_dev().

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Fixup ALC225 depop procedure

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add type for ALC287

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/mm: Move __real_pte stubs into hash-4k.h

Jill Donahue <jilliandonahue58@gmail.com>
    USB: gadget: f_midi: f_midi_complete to call queue_work

Davidlohr Bueso <dave@stgolabs.net>
    usb/gadget: f_midi: Replace tasklet with work

Allen Pais <allen.lkml@gmail.com>
    usb/gadget: f_midi: convert tasklets to use new tasklet_setup() API

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Fix timeout issue during controller enter/exit from halt state

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: Increase DWC3 controller halt timeout

Chen Ridong <chenridong@huawei.com>
    memcg: fix soft lockup in the OOM process

Carlos Galo <carlosgalo@google.com>
    mm: update mark_victim tracepoints fields

Ignat Korchagin <ignat@cloudflare.com>
    crypto: testmgr - some more fixes to RSA test vectors

Ignat Korchagin <ignat@cloudflare.com>
    crypto: testmgr - populate RSA CRT parameters in RSA test vectors

lei he <helei.sig11@bytedance.com>
    crypto: testmgr - fix version number of RSA tests

Lei He <helei.sig11@bytedance.com>
    crypto: testmgr - Fix wrong test case of RSA

Lei He <helei.sig11@bytedance.com>
    crypto: testmgr - fix wrong key length for pkcs1pad

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Long Li <longli@microsoft.com>
    scsi: storvsc: Set correct data length for sending SCSI command without payload

Xin Long <lucien.xin@gmail.com>
    vlan: move dev_put into vlan_dev_uninit

Xin Long <lucien.xin@gmail.com>
    vlan: introduce vlan_dev_free_egress_priority

Stefan Berger <stefanb@linux.ibm.com>
    ima: Fix use-after-free on a dentry's dname.name

Calvin Owens <calvin@wbinvd.org>
    pps: Fix a use-after-free

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Koichiro Den <koichiro.den@canonical.com>
    Revert "btrfs: avoid monopolizing a core when activating a swap file"

David Woodhouse <dwmw@amazon.co.uk>
    x86/i8253: Disable PIT timer 0 when not in use

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    parport_pc: add support for ASIX AX99100

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    serial: 8250_pci: add support for ASIX AX99100

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    can: ems_pci: move ASIX AX99100 ids to pci_ids.h

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: protect access to buffers with no active references

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not force clear folio if buffer is referenced

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not output warnings when clearing dirty buffers

Ivan Kokshaysky <ink@unseen.parts>
    alpha: replace hardcoded stack offsets with autogenerated ones

Eric Dumazet <edumazet@google.com>
    ndisc: extend RCU protection in ndisc_send_skb()

Eric Dumazet <edumazet@google.com>
    openvswitch: use RCU protection in ovs_vport_cmd_fill_info()

Eric Dumazet <edumazet@google.com>
    arp: use RCU protection in arp_xmit()

Eric Dumazet <edumazet@google.com>
    neighbour: use RCU protection in __neigh_notify()

Li Zetao <lizetao1@huawei.com>
    neighbour: delete redundant judgment statements

Eric Dumazet <edumazet@google.com>
    ndisc: use RCU protection in ndisc_alloc_skb()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU protection in ip6_default_advmss()

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in inet_select_addr()

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in rt_is_expired()

Eric Dumazet <edumazet@google.com>
    net: add dev_net_rcu() helper

Jiri Pirko <jiri@nvidia.com>
    net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    regmap-irq: Add missing kfree()

Jann Horn <jannh@google.com>
    partitions: mac: fix handling of bogus partition table

Wentao Liang <vulab@iscas.ac.cn>
    gpio: stmpe: Check return value of stmpe_reg_read in stmpe_gpio_irq_sync_unlock

Ivan Kokshaysky <ink@unseen.parts>
    alpha: align stack for page fault and user unaligned trap handlers

John Keeping <jkeeping@inmusicbrands.com>
    serial: 8250: Fix fifo underflow on flush

Ivan Kokshaysky <ink@unseen.parts>
    alpha: make stack 16-byte aligned (most cases)

Alexander Hölzl <alexander.hoelzl@gmx.net>
    can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    can: c_can: fix unbalanced runtime PM disable in error path

Johan Hovold <johan@kernel.org>
    USB: serial: option: drop MeiG Smart defines

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FN990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990B compositions

Chester A. Unal <chester.a.unal@arinc9.com>
    USB: serial: option: add MeiG Smart SLM828

Jann Horn <jannh@google.com>
    usb: cdc-acm: Fix handling of oversized fragments

Jann Horn <jannh@google.com>
    usb: cdc-acm: Check control transfer buffer size before access

Marek Vasut <marek.vasut+renesas@mailbox.org>
    USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Ignore non-compliant devices with too many configs or interfaces

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: f_midi: fix MIDI Streaming descriptor lengths

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone

Lei Huang <huanglei@kylinos.cn>
    USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist

Huacai Chen <chenhuacai@loongson.cn>
    USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: gadget: remove of_node reference upon udc_stop

Guo Ren <guoren@linux.alibaba.com>
    usb: gadget: udc: renesas_usb3: Fix compiler warning

Elson Roy Serrao <quic_eserrao@quicinc.com>
    usb: roles: set switch registered flag early on

Andy Strohman <andrew@andrewstrohman.com>
    batman-adv: fix panic during interface removal

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix a oob in orangefs_debug_write

Maksym Planeta <maksym@exostellar.io>
    Grab mm lock before grabbing pt lock

Ramesh Thomas <ramesh.thomas@intel.com>
    vfio/pci: Enable iowrite64 and ioread64 for vfio pci

Arnd Bergmann <arnd@arndb.de>
    media: cxd2841er: fix 64-bit division on gcc-9

Juergen Gross <jgross@suse.com>
    x86/xen: allow larger contiguous memory regions in PV guests

Petr Tesarik <petr.tesarik.ext@huawei.com>
    xen: remove a confusing comment on auto-translated guest I/O

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Add missing newline to dev_err format string

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Make sure GPIO bits are unlocked when requesting IRQ

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0

Radu Rendec <rrendec@redhat.com>
    arm64: cacheinfo: Avoid out-of-bounds write to cacheinfo array

Eric Dumazet <edumazet@google.com>
    team: better TEAM_OPTION_TYPE_STRING validation

Eric Dumazet <edumazet@google.com>
    vrf: use RCU protection in l3mdev_l3_out()

Eric Dumazet <edumazet@google.com>
    ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()

Charles Han <hanchunchao@inspur.com>
    HID: multitouch: Add NULL check in mt_input_configured

Su Yue <glass.su@suse.com>
    ocfs2: check dir i_size in ocfs2_find_entry

WangYuli <wangyuli@uniontech.com>
    MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Ensure info->enable callback is always set

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: wait for the last response to Deselect Package before configuring channel

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix registered buffer page address

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: onenand: Fix uninitialized retlen in do_otp_read()

Dan Carpenter <dan.carpenter@linaro.org>
    NFC: nci: Add bounds checking in nci_hci_create_pipe()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    nilfs2: fix possible int overflows in nilfs_fiemap()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ocfs2: handle a symlink read error correctly

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix incorrect CPU endianness conversion causing mount failure

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jennifer Berringer <jberring@redhat.com>
    nvmem: core: improve range check for nvmem_cell_write()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - unregister previously registered algos in error path

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - fix goto jump in error path

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove redundant NULL assignment

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix event flags in uvc_ctrl_send_events

Sam Bobrowicz <sam@elite-embedded.com>
    media: ov5640: fix get_light_freq on auto

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: qcom: smem_state: fix missing of_node_put in error path

Nathan Chancellor <nathan@kernel.org>
    kbuild: Move -Wenum-enum-conversion to W=2

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/pseries/eeh: Fix get PE state translation

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Drop __initdata macro for port_cfg

Stephan Gerhold <stephan.gerhold@linaro.org>
    soc: qcom: socinfo: Avoid out of bounds read of serial number

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't prepare BOT write request twice

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Decrement command ref count on cleanup

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Translate error to sense

Marcel Hamer <marcel.hamer@windriver.com>
    wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()

Heiko Stuebner <heiko@sntech.de>
    HID: hid-sensor-hub: don't use stale platform-data on remove

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Fix using wrong number of cells to get property 'alignment'

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix of_find_node_opts_by_path() handling of alias+path+options

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Correct child specifier used as input of the 2nd nexus node

Kuan-Wei Chiu <visitorckw@gmail.com>
    perf bench: Fix undefined behavior in cmpworker()

Anastasia Belova <abelova@astralinux.ru>
    clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix alpha mode configuration

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc

Haoxiang Li <haoxiang_li2024@163.com>
    drm/komeda: Add check for komeda_get_layer_fourcc_list()

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: fix some corner-cases when grabbing vsie pages

Sean Christopherson <seanjc@google.com>
    KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()

Jakob Unterwurzacher <jakobunt@gmail.com>
    arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma

Dan Carpenter <dan.carpenter@linaro.org>
    binfmt_flat: Fix integer overflow bug on 32 bit systems

Thomas Zimmermann <tzimmermann@suse.de>
    m68k: vga: Fix I/O defines

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: Fix FUTEX_OP_ANDN implementation

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    leds: lp8860: Write full EEPROM, not only half of it

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: s3c64xx: Fix compilation warning

Willem de Bruijn <willemb@google.com>
    tun: revert fix group permission check

Cong Wang <cong.wang@bytedance.com>
    netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()

Eric Dumazet <edumazet@google.com>
    net: rose: lock the socket in rose_bind()

Yan Zhai <yan@cloudflare.com>
    udp: gso: do not drop small packets when PMTU reduces

Lenny Szubowicz <lszubowi@redhat.com>
    tg3: Disable tg3 PCIe AER on system reboot

Hans Verkuil <hverkuil@xs4all.nl>
    gpu: drm_dp_cec: fix broken CEC adapter properties check

Prasad Pandit <pjp@fedoraproject.org>
    firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry

Daniel Wagner <wagi@kernel.org>
    nvme: handle connectivity loss in nvme_set_queue_count

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix NULL pointer dereference on certain command aborts

Hardik Gajjar <hgajjar@de.adit-jv.com>
    usb: xhci: Add timeout argument in address_device USB HCD callback

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: rtl8150: enable basic endpoint checking

Emil Renner Berthing <kernel@esmil.dk>
    net: usb: rtl8150: use new tasklet API

Romain Perier <romain.perier@gmail.com>
    tasklet: Introduce new initialization API

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct lld when linking through clang

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: add bounds checks to host bulk flow fairness counts

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove dangling pointers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Only save async fh if success

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle errors that nilfs_prepare_chunk() may return

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: eliminate staggered calls to kunmap in nilfs_rename

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link

Ralf Schlatterbeck <rsc@runtux.com>
    spi-mxs: Fix chipselect glitch

Xi Ruoyao <xry111@xry111.site>
    x86/mm: Don't disable PCID when INVLPG has been fixed by microcode

Borislav Petkov <bp@alien8.de>
    APEI: GHES: Have GHES honor the panic= setting

Even Xu <even.xu@intel.com>
    HID: Wacom: Add PCI Wacom device support

Hans de Goede <hdegoede@redhat.com>
    mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: don't emit warning in tomoyo_write_control()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Respect quirk_max_rate for non-UHS SDIO card

Stas Sergeev <stsp2@yandex.ru>
    tun: fix group permission check

Kuan-Wei Chiu <visitorckw@gmail.com>
    printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Restrict init function to AMD-based systems

Suleiman Souhlal <suleiman@google.com>
    sched: Don't try to catch up excess steal time.

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when attempting to join an aborted transaction

Qu Wenruo <wqu@suse.com>
    btrfs: output the reason for open_ctree() failure

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't free command immediately

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Fix double free in error path

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections

Jos Wang <joswang@lenovo.com>
    usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE

Sean Rhodes <sean@starlabs.systems>
    drivers/card_reader/rtsx_usb: Restore interrupt based detection

Ricardo B. Marliere <rbm@suse.com>
    ktest.pl: Check kernelrelease return in get_version

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reset cb_seq_status after NFS4ERR_DELAY

Lin Yujun <linyujun809@huawei.com>
    hexagon: Fix unbalanced spinlock in die()

Willem de Bruijn <willemb@google.com>
    hexagon: fix using plain integer as NULL pointer warning in cmpxchg

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is read from *.symref file

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is added from source

Kory Maincent <kory.maincent@bootlin.com>
    net: sh_eth: Fix missing rtnl lock in suspend/resume path

Michal Luczaj <mhal@rbox.co>
    vsock: Allow retrying on connect() failure

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix runtime error of index out of bounds

Chenyuan Yang <chenyuan0y@gmail.com>
    net: davicom: fix UAF in dm9000_drv_remove

Eric Dumazet <edumazet@google.com>
    net: rose: fix timer races against user threads

Wentao Liang <vulab@iscas.ac.cn>
    PM: hibernate: Add error handling for syscore_suspend()

Eric Dumazet <edumazet@google.com>
    ipmr: do not call mr_mfc_uses_dev() for unres entries

Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
    net: fec: implement TSO descriptor cleanup

pangliyuan <pangliyuan1@huawei.com>
    ubifs: skip dumping tnc tree when zroot is null

Oleksij Rempel <linux@rempel-privat.de>
    rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: ti: edma: fix OF node reference leaks in edma_driver

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    module: Extend the preempt disabled section in dereference_symbol_descriptor().

Su Yue <glass.su@suse.com>
    ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails

Paul Menzel <pmenzel@molgen.mpg.de>
    scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Propagate buf->error to userspace

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: camif-core: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mipi-csis: Add check for clk_enable()

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()

Chen Ni <nichen@iscas.ac.cn>
    media: lmedm04: Handle errors for lme2510_int_read

Malcolm Priestley <tvboxspy@gmail.com>
    media: lmedm04: Use GFP_KERNEL for URB allocation/submission.

Oliver Neukum <oneukum@suse.com>
    media: rc: iguanair: handle timeouts

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: mediatek: mt7623: fix IR nodename

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property

Dan Carpenter <dan.carpenter@linaro.org>
    rdma/cxgb4: Prevent potential integer overflow on 32bit

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Avoid false error about access to uninitialized gids array

Puranjay Mohan <puranjay@kernel.org>
    bpf: Send signals asynchronously if !preemptible

Jiachen Zhang <me@jcix.top>
    perf report: Fix misleading help message about --demangle

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf top: Don't complain about lack of vmlinux when not resolving some kernel samples

Thomas Weißschuh <linux@weissschuh.net>
    padata: fix sysfs store callback check

Ba Jing <bajing@cmss.chinamobile.com>
    ktest.pl: Remove unused declarations in run_bisect_test function

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_btf()

George Lander <lander@jagmn.com>
    ASoC: sun4i-spdif: Add clock multiplier settings

Marco Leogrande <leogrande@google.com>
    tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: Disallow replacing of child qdisc from one parent to another

Maher Sanalla <msanalla@nvidia.com>
    net/mlxfw: Drop hard coded max FW flash image size

Liu Jian <liujian56@huawei.com>
    net: let net.core.dev_weight always be non-zero

Bo Gan <ganboing@gmail.com>
    clk: analogbits: Fix incorrect calculation of vco rate delta

Dmitry V. Levin <ldv@strace.io>
    selftests: harness: fix printing of mismatch values in __EXPECT()

Kees Cook <keescook@chromium.org>
    selftests/harness: Display signed values correctly

Andreas Kemnade <andreas@kemnade.info>
    wifi: wlcore: fix unbalanced pm_runtime calls

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    regulator: of: Implement the unwind path of of_regulator_match()

Octavian Purdila <tavip@google.com>
    team: prevent adding a device which is already a team device lower

He Rongguang <herongguang@linux.alibaba.com>
    cpupower: fix TSC MHz calculation

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: pci: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix memory leaks and invalid access at probe error path

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: remove unused check_buddy_priv

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtlwifi: remove unused dualmac control leftovers

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtlwifi: remove unused timer and related code

Jakob Koschel <jakobkoschel@gmail.com>
    rtlwifi: replace usage of found with dedicated list iterator variable

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: mmc: controller: clarify the address-cells description

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: usb: fix workqueue leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se Rename RT_TRACE to rtl_dbg

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: do not complete firmware loading needlessly

Charles Han <hanchunchao@inspur.com>
    ipmi: ipmb: Add check devm_kasprintf() returned value

Ivan Stepchenko <sid@itb.spb.ru>
    drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table

Sui Jingfeng <sui.jingfeng@linux.dev>
    drm/etnaviv: Fix page property being used for non writecombine buffers

Randy Dunlap <rdunlap@infradead.org>
    partitions: ldm: remove the initial kernel-doc notation

Yu Kuai <yukuai3@huawei.com>
    nbd: don't allow reconnect after disconnect

David Howells <dhowells@redhat.com>
    afs: Fix directory format encoding struct

Kees Cook <keescook@chromium.org>
    overflow: Allow mixed type arguments

Keith Busch <kbusch@kernel.org>
    overflow: Correct check_shl_overflow() comment

Kees Cook <keescook@chromium.org>
    overflow: Add __must_check attribute to check_*() helpers

Ben Hutchings <benh@debian.org>
    udf: Fix use of check_add_overflow() with mixed type arguments

Ben Hutchings <benh@debian.org>
    perf cs-etm: Add missing variable in cs_etm__process_queues()


-------------

Diffstat:

 .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
 Makefile                                           |   9 +-
 arch/alpha/include/uapi/asm/ptrace.h               |   2 +
 arch/alpha/kernel/asm-offsets.c                    |   2 +
 arch/alpha/kernel/entry.S                          |  24 +--
 arch/alpha/kernel/traps.c                          |   2 +-
 arch/alpha/mm/fault.c                              |   4 +-
 arch/arm/boot/dts/mt7623.dtsi                      |   2 +-
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +--
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
 arch/arm64/kernel/cacheinfo.c                      |  12 +-
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/kernel/traps.c                        |   4 +-
 arch/m68k/include/asm/vga.h                        |   8 +-
 arch/mips/kernel/ftrace.c                          |   2 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |  28 +++
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  26 ---
 arch/powerpc/lib/code-patching.c                   |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
 arch/s390/include/asm/futex.h                      |   2 +-
 arch/s390/kvm/vsie.c                               |  25 ++-
 arch/x86/kernel/amd_nb.c                           |   4 +
 arch/x86/kernel/cpu/cacheinfo.c                    |   2 +-
 arch/x86/kernel/cpu/cyrix.c                        |   4 +-
 arch/x86/kernel/cpu/intel.c                        |  52 +++--
 arch/x86/kernel/i8253.c                            |  11 +-
 arch/x86/mm/init.c                                 |  32 +--
 arch/x86/xen/mmu_pv.c                              |  79 +++++--
 block/partitions/ldm.h                             |   2 +-
 block/partitions/mac.c                             |  18 +-
 crypto/testmgr.h                                   | 227 +++++++++++++++------
 drivers/acpi/apei/ghes.c                           |  10 +-
 drivers/base/bus.c                                 |   2 +
 drivers/base/regmap/regmap-irq.c                   |   2 +
 drivers/block/nbd.c                                |   1 +
 drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
 drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/clocksource/i8253.c                        |  13 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
 drivers/crypto/qce/core.c                          |  13 +-
 drivers/dma/ti/edma.c                              |   3 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/gpio/gpio-bcm-kona.c                       |  71 +++++--
 drivers/gpio/gpio-rcar.c                           |   7 +-
 drivers/gpio/gpio-stmpe.c                          |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  16 ++
 drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c   |   2 +
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
 drivers/gpu/drm/drm_dp_cec.c                       |  14 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
 drivers/gpu/drm/radeon/r300.c                      |   3 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
 drivers/gpu/drm/radeon/rs400.c                     |  18 +-
 drivers/gpu/drm/scheduler/gpu_scheduler_trace.h    |   4 +-
 drivers/hid/hid-appleir.c                          |   2 +-
 drivers/hid/hid-core.c                             |   2 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-multitouch.c                       |   5 +-
 drivers/hid/hid-sensor-hub.c                       |  21 +-
 drivers/hid/intel-ish-hid/ishtp-hid.c              |   4 +-
 drivers/hid/wacom_wac.c                            |   5 +
 drivers/hwmon/ad7314.c                             |  10 +
 drivers/hwmon/ntc_thermistor.c                     |  66 +++---
 drivers/hwmon/pmbus/pmbus.c                        |   2 +
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |  15 ++
 drivers/infiniband/hw/cxgb4/device.c               |   6 +-
 drivers/infiniband/hw/mlx4/main.c                  |   6 +-
 drivers/leds/leds-lp8860.c                         |   2 +-
 drivers/media/dvb-frontends/cxd2841er.c            |   8 +-
 drivers/media/i2c/ov5640.c                         |   1 +
 drivers/media/platform/exynos4-is/mipi-csis.c      |  10 +-
 drivers/media/platform/s3c-camif/camif-core.c      |  13 +-
 drivers/media/rc/iguanair.c                        |   4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  14 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  85 ++++++--
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/media/usb/uvc/uvc_status.c                 |   1 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +
 drivers/media/usb/uvc/uvcvideo.h                   |   9 +-
 drivers/mfd/lpc_ich.c                              |   3 +-
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/misc/fastrpc.c                             |   2 +-
 drivers/mmc/core/sdio.c                            |   2 +
 drivers/mtd/nand/onenand/onenand_base.c            |   1 +
 drivers/net/caif/caif_virtio.c                     |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |  58 ++++++
 drivers/net/ethernet/cadence/macb.h                |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  12 +-
 drivers/net/ethernet/davicom/dm9000.c              |   3 +-
 drivers/net/ethernet/emulex/benet/be.h             |   2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        | 197 +++++++++---------
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  31 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   2 +
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/geneve.c                               |  16 +-
 drivers/net/gtp.c                                  |   5 -
 drivers/net/loopback.c                             |  14 ++
 drivers/net/ppp/ppp_generic.c                      |  28 ++-
 drivers/net/team/team.c                            |  11 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/gl620a.c                           |   4 +-
 drivers/net/usb/rtl8150.c                          |  28 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  36 +---
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  65 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.c    |  42 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |  40 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    | 157 +++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   | 211 ++++++++++---------
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |  70 +++----
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |  10 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  23 ---
 drivers/net/wireless/ti/wlcore/main.c              |  10 +-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvmem/core.c                               |   2 +
 drivers/of/base.c                                  |   8 +-
 drivers/parport/parport_pc.c                       |   5 +
 drivers/pci/endpoint/pci-epc-core.c                |   2 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  12 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  11 +
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/power/supply/da9150-fg.c                   |   4 +-
 drivers/pps/clients/pps-gpio.c                     |   4 +-
 drivers/pps/clients/pps-ktimer.c                   |   4 +-
 drivers/pps/clients/pps-ldisc.c                    |   6 +-
 drivers/pps/clients/pps_parport.c                  |   4 +-
 drivers/pps/kapi.c                                 |  10 +-
 drivers/pps/kc.c                                   |  10 +-
 drivers/pps/pps.c                                  | 127 ++++++------
 drivers/ptp/ptp_clock.c                            |   8 +
 drivers/rapidio/devices/rio_mport_cdev.c           |   3 +-
 drivers/rapidio/rio-scan.c                         |   5 +-
 drivers/regulator/of_regulator.c                   |  14 +-
 drivers/rtc/rtc-pcf85063.c                         |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/scsi/ufs/ufs_bsg.c                         |   1 +
 drivers/slimbus/messaging.c                        |   5 +-
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/spi/spi-mxs.c                              |   3 +-
 drivers/staging/media/imx/imx-media-of.c           |   8 +-
 drivers/tee/optee/supp.c                           |  35 +---
 drivers/tty/serial/8250/8250.h                     |   2 +
 drivers/tty/serial/8250/8250_dma.c                 |  16 ++
 drivers/tty/serial/8250/8250_pci.c                 |  10 +
 drivers/tty/serial/8250/8250_port.c                |   9 +
 drivers/tty/serial/sh-sci.c                        |  25 ++-
 drivers/usb/atm/cxacru.c                           |  13 +-
 drivers/usb/class/cdc-acm.c                        |  28 ++-
 drivers/usb/core/hub.c                             |  13 +-
 drivers/usb/core/quirks.c                          |  10 +
 drivers/usb/dwc2/gadget.c                          |   1 +
 drivers/usb/dwc3/gadget.c                          |  37 +++-
 drivers/usb/gadget/composite.c                     |  17 +-
 drivers/usb/gadget/function/f_midi.c               |  22 +-
 drivers/usb/gadget/function/f_tcm.c                |  54 ++---
 drivers/usb/gadget/udc/renesas_usb3.c              |   2 +-
 drivers/usb/host/pci-quirks.c                      |   9 +
 drivers/usb/host/xhci-mem.c                        |   2 +
 drivers/usb/host/xhci-pci.c                        |   8 +-
 drivers/usb/host/xhci-ring.c                       |  12 +-
 drivers/usb/host/xhci.c                            |  23 ++-
 drivers/usb/host/xhci.h                            |   9 +-
 drivers/usb/renesas_usbhs/common.c                 |   6 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   2 +-
 drivers/usb/roles/class.c                          |   5 +-
 drivers/usb/serial/option.c                        |  49 +++--
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  11 +
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |   1 +
 drivers/vfio/platform/vfio_platform_common.c       |  10 +
 drivers/video/fbdev/omap2/omapfb/dss/dss-of.c      |   1 +
 fs/afs/xdr_fs.h                                    |   2 +-
 fs/binfmt_flat.c                                   |   2 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/transaction.c                             |   4 +-
 fs/nfsd/nfs4callback.c                             |   1 +
 fs/nilfs2/dir.c                                    |  24 +--
 fs/nilfs2/inode.c                                  |  10 +-
 fs/nilfs2/mdt.c                                    |   6 +-
 fs/nilfs2/namei.c                                  |  37 ++--
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/nilfs2/page.c                                   |  55 ++---
 fs/nilfs2/page.h                                   |   4 +-
 fs/nilfs2/segment.c                                |   4 +-
 fs/ocfs2/dir.c                                     |  25 ++-
 fs/ocfs2/quota_global.c                            |   5 +
 fs/ocfs2/super.c                                   |   2 +-
 fs/ocfs2/symlink.c                                 |   5 +-
 fs/orangefs/orangefs-debugfs.c                     |   4 +-
 fs/squashfs/inode.c                                |   5 +-
 fs/ubifs/debug.c                                   |  22 +-
 fs/udf/super.c                                     |   2 +-
 include/linux/i8253.h                              |   1 +
 include/linux/interrupt.h                          |  28 ++-
 include/linux/kallsyms.h                           |   2 +-
 include/linux/kvm_host.h                           |   9 +
 include/linux/netdevice.h                          |   6 +
 include/linux/overflow.h                           | 101 +++++----
 include/linux/pci_ids.h                            |   4 +
 include/linux/pps_kernel.h                         |   3 +-
 include/linux/usb/hcd.h                            |   5 +-
 include/net/flow_dissector.h                       |  16 ++
 include/net/flow_offload.h                         |   6 +
 include/net/l3mdev.h                               |   2 +
 include/net/net_namespace.h                        |  15 +-
 include/trace/events/oom.h                         |  36 +++-
 kernel/acct.c                                      | 141 ++++++++-----
 kernel/events/core.c                               |  17 +-
 kernel/padata.c                                    |   2 +-
 kernel/power/hibernate.c                           |   7 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |   8 +-
 kernel/softirq.c                                   |  18 +-
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ftrace.c                              |  27 ++-
 mm/memcontrol.c                                    |   7 +-
 mm/oom_kill.c                                      |  14 +-
 mm/page_alloc.c                                    |   1 +
 net/8021q/vlan.c                                   |   3 +-
 net/8021q/vlan.h                                   |   2 +-
 net/8021q/vlan_dev.c                               |  15 +-
 net/8021q/vlan_netlink.c                           |   7 +-
 net/batman-adv/bat_v.c                             |   2 -
 net/batman-adv/bat_v_elp.c                         | 116 ++++++++---
 net/batman-adv/bat_v_elp.h                         |   2 -
 net/batman-adv/types.h                             |   3 -
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/can/j1939/socket.c                             |   4 +-
 net/can/j1939/transport.c                          |   5 +-
 net/core/drop_monitor.c                            |  39 ++--
 net/core/flow_dissector.c                          |  49 +++--
 net/core/flow_offload.c                            |   7 +
 net/core/neighbour.c                               |  11 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sysctl_net_core.c                         |   5 +-
 net/ipv4/arp.c                                     |   4 +-
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/ipmr_base.c                               |   3 -
 net/ipv4/route.c                                   |   8 +-
 net/ipv4/tcp_offload.c                             |  11 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv4/udp_offload.c                             |   8 +-
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/ipv6/ndisc.c                                   |  28 +--
 net/ipv6/route.c                                   |   7 +-
 net/ipv6/udp.c                                     |   4 +-
 net/llc/llc_s_ac.c                                 |  49 +++--
 net/ncsi/ncsi-manage.c                             |  13 +-
 net/nfc/nci/hci.c                                  |   2 +
 net/openvswitch/datapath.c                         |  12 +-
 net/rose/af_rose.c                                 |  24 ++-
 net/rose/rose_timer.c                              |  15 ++
 net/sched/cls_flower.c                             |   8 +-
 net/sched/sch_api.c                                |   4 +
 net/sched/sch_cake.c                               | 140 +++++++------
 net/sched/sch_fifo.c                               |   3 +
 net/sched/sch_netem.c                              |   2 +-
 net/sunrpc/cache.c                                 |  10 +-
 net/vmw_vsock/af_vsock.c                           |   5 +
 net/wireless/nl80211.c                             |   5 +
 net/wireless/reg.c                                 |   3 +-
 scripts/Makefile.extrawarn                         |   5 +-
 scripts/genksyms/genksyms.c                        |  11 +-
 scripts/genksyms/genksyms.h                        |   2 +-
 scripts/genksyms/parse.y                           |  18 +-
 security/integrity/ima/ima_api.c                   |  16 +-
 security/integrity/ima/ima_template_lib.c          |  17 +-
 security/tomoyo/common.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  86 +++++++-
 sound/soc/codecs/es8328.c                          |  15 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  17 +-
 sound/soc/sunxi/sun4i-spdif.c                      |   7 +
 tools/perf/bench/epoll-wait.c                      |   7 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-top.c                           |   2 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/util/cs-etm.c                           |   2 +-
 tools/perf/util/env.c                              |   5 +-
 tools/perf/util/env.h                              |   2 +-
 tools/perf/util/header.c                           |   8 +-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
 tools/testing/ktest/ktest.pl                       |   7 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
 tools/testing/selftests/kselftest_harness.h        |  42 +++-
 tools/testing/selftests/net/udpgso.c               |  26 +++
 305 files changed, 3058 insertions(+), 1680 deletions(-)


