Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A491684AC;
	Tue, 11 Mar 2025 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706343; cv=none; b=F0qt0CD2j4VUdwOAbSTlsBaF4OlblARp35nurzwg1Jzgk8qGBiWpYGlF1IosqA4KJTEeHMOLau62TsjFreh+DdJOptHp3jUapfNlgugyMOZdrmgEefc0w+XiKaFIFJj4+GdGk5/DX/ZTTOFN0rbtk+IGGxGSHW6iirdPy4E+rvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706343; c=relaxed/simple;
	bh=prASiTiK2qVL3a9566UyTIlfwCQPJgtUJjyyQZQYmwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gmhWD07EOfL9IkFkT8cpxL4+oVnTA90Dp8VKMnS3uN+s1TiQIvSpVo/PXaAjdZoIEApXIV2FbAp3A1KWiIRB87TIxM/3UJM5ve3c5MtPf3Q+wO8XhKTAyZQADO+p0m6KD/yT9zWFzSaZFGbGzIOSoQNI28zts2xv8paOoad5Qfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voMQkRn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voMQkRn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEDCC4CEE9;
	Tue, 11 Mar 2025 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706342;
	bh=prASiTiK2qVL3a9566UyTIlfwCQPJgtUJjyyQZQYmwI=;
	h=From:To:Cc:Subject:Date:From;
	b=voMQkRn7iTW8tlT9wRJYbLdZK8DwcPp9US8YY8QpuUqM8l1jUSqdRZBwhDhsEZB29
	 u1BHTzjO3jfz2CIBMihzkNVr4NO68jMvzi9iG676MaiCU+t6W2/kgr4Txq3u8JxE9q
	 4wwuGAIcOSfuXrnaYZbFR9pxXvS8tKu+GT6KqJ+U=
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
Subject: [PATCH 5.10 000/462] 5.10.235-rc1 review
Date: Tue, 11 Mar 2025 15:54:26 +0100
Message-ID: <20250311145758.343076290@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.235-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.235-rc1
X-KernelTest-Deadline: 2025-03-13T14:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.235 release.
There are 462 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 13 Mar 2025 14:56:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.235-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.235-rc1

Jakub Kicinski <kuba@kernel.org>
    net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels

Ben Hutchings <benh@debian.org>
    udf: Fix use of check_add_overflow() with mixed type arguments

Ben Hutchings <benh@debian.org>
    perf cs-etm: Add missing variable in cs_etm__process_queues()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Enable the TRB overfetch quirk on VIA VL805

Filipe Manana <fdmanana@suse.com>
    btrfs: bring back the incorrectly removed extent buffer lock recursion support

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - inject error before stopping queue

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct lld when linking through clang

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: add bounds checks to host bulk flow fairness counts

Michal Luczaj <mhal@rbox.co>
    vsock: Orphan socket after transport release

Michal Luczaj <mhal@rbox.co>
    vsock: Keep the binding until socket destruction

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Invoke proto::close on close()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "media: uvcvideo: Require entities to have a non-zero unique ID"

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

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix unchecked dereference

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

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake P DID

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

Murad Masimov <m.masimov@mt-integration.ru>
    ALSA: usx2y: validate nrpacks module parameter on probe

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

Meir Elisha <meir.elisha@volumez.com>
    nvmet-tcp: Fix a possible sporadic response drops in weakly ordered arch

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()

Yu-Chun Lin <eleanor15x@gmail.com>
    HID: google: fix unused variable warning under !CONFIG_ACPI

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: limit printed string from FW file

Hao Zhang <zhanghao1@kylinos.cn>
    mm/page_alloc: fix uninitialized variable

Olivier Gayot <olivier.gayot@canonical.com>
    block: fix conversion of GPT partition name to 7-bit

Heiko Carstens <hca@linux.ibm.com>
    s390/traps: Fix test_monitor_call() inline assembly

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

Koichiro Den <koichiro.den@canonical.com>
    gpio: aggregator: protect driver attr handlers against module unload

Daniil Dulov <d.dulov@aladdin.ru>
    HID: appleir: Fix potential NULL dereference at raw event handle

Rob Herring (Arm) <robh@kernel.org>
    Revert "of: reserved-memory: Fix using wrong number of cells to get property 'alignment'"

Peter Jones <pjones@redhat.com>
    efi: Don't map the entire mokvar table to determine its size

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable BAR resize on Dell G5 SE

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Check extended configuration space register when system uses large bar

Haoxiang Li <haoxiang_li2024@163.com>
    smb: client: Add check for next_buffer in receive_encrypted_standard()

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
    intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly

Thomas Gleixner <tglx@linutronix.de>
    sched/core: Prevent rescheduling when interrupts are disabled

Ard Biesheuvel <ardb@kernel.org>
    vmlinux.lds: Ensure that const vars with relocations are mapped R/O

Paolo Abeni <pabeni@redhat.com>
    mptcp: always handle address removal under msk socket lock

Kaustabh Chakraborty <kauschluss@disroot.org>
    phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk

BH Hsieh <bhsieh@nvidia.com>
    phy: tegra: xusb: reset VBUS & ID OVERRIDE

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usbnet: gl620a: fix endpoint checking in genelink_bind()

Tyrone Ting <kfting@nuvoton.com>
    i2c: npcm: disable interrupt enable bit before devm_request_irq

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix low freq setting via IOC_PERIOD

Nikolay Kuratov <kniv@yandex-team.ru>
    ftrace: Avoid potential division by zero in function_stat_show()

Russell Senior <russell@personaltelco.net>
    x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in rpl lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: rpl_iptunnel: mitigate 2-realloc issue

Justin Iurman <justin.iurman@uliege.be>
    include: net: add static inline dst_dev_overhead() to dst.h

Brian Vazquez <brianvv@google.com>
    net: use indirect call helpers for dst_output

Brian Vazquez <brianvv@google.com>
    net: use indirect call helpers for dst_input

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: ipv6: rpl_iptunnel: simplify the return expression of rpl_do_srh()

Harshal Chaudhari <hchaudhari@marvell.com>
    net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.

Wang Hai <wanghai38@huawei.com>
    tcp: Defer ts_recent changes until req is owned

Philo Lu <lulie@linux.alibaba.com>
    ipvs: Always clear ipvs_property flag in skb_scrub_packet()

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: es8328: fix route from DAC to output

Sean Anderson <sean.anderson@linux.dev>
    net: cadence: macb: Synchronize stats calculations

Ido Schimmel <idosch@nvidia.com>
    net: loopback: Avoid sending IP packets without an Ethernet header

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports

Arnd Bergmann <arnd@arndb.de>
    sunrpc: suppress warnings for unused procfs functions

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix bind QP error cleanup flow

Mark Zhang <markzhang@nvidia.com>
    IB/mlx5: Set and get correct qp_num for a DCT QP

Patrick Bellasi <derkling@google.com>
    x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix incorrect device in dma_unmap_single

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: use dma_map_resource for sdma address

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix error code in cadence_nand_init()

Christian Brauner <brauner@kernel.org>
    acct: block access to kernel internal filesystems

John Veness <john-linux@pelago.org.uk>
    ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED

Haoxiang Li <haoxiang_li2024@163.com>
    nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix supplicant wait loop

Yan Zhai <yan@cloudflare.com>
    bpf: skip non exist keys in generic_map_lookup_batch

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

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/mm: Move __real_pte stubs into hash-4k.h

Jill Donahue <jilliandonahue58@gmail.com>
    USB: gadget: f_midi: f_midi_complete to call queue_work

Davidlohr Bueso <dave@stgolabs.net>
    usb/gadget: f_midi: Replace tasklet with work

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Fix timeout issue during controller enter/exit from halt state

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: Increase DWC3 controller halt timeout

Sven Eckelmann <sven@narfation.org>
    batman-adv: Drop unmanaged ELP metric worker

Sven Eckelmann <sven@narfation.org>
    batman-adv: Drop initialization of flexible ethtool_link_ksettings

Sven Eckelmann <sven@narfation.org>
    batman-adv: Add new include for min/max helpers

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Change to kvalloc() in eventlog/acpi.c

Eddie James <eajames@linux.ibm.com>
    tpm: Use managed allocation for bios event log

Thomas Zimmermann <tzimmermann@suse.de>
    drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()

Maxime Ripard <maxime@cerno.tech>
    drm/probe-helper: Create a HPD IRQ event helper for a single connector

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

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings

Casey Chen <cachen@purestorage.com>
    nvme-pci: fix multiple races in nvme_setup_io_queues

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

Chao Yu <chao@kernel.org>
    f2fs: fix to wait dio completion

Hangbin Liu <liuhangbin@gmail.com>
    selftests: rtnetlink: update netdevsim ipsec output format

Hangbin Liu <liuhangbin@gmail.com>
    netdevsim: print human readable IP address

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

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/static-call: Remove early_boot_irqs_disabled check to fix Xen PVH dom0

John Ogness <john.ogness@linutronix.de>
    kdb: Do not assume write() callback available

Devarsh Thakkar <devarsht@ti.com>
    drm/tidss: Clear the interrupt status for interrupts being disabled

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Fix issue in irq handling causing irq-flood issue

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

Waiman Long <longman@redhat.com>
    clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context

Waiman Long <longman@redhat.com>
    clocksource: Use pr_info() for "Checking clocksource synchronization" message

Yury Norov <yury.norov@gmail.com>
    clocksource: Replace cpumask_weight() with cpumask_empty()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    clocksource: Replace deprecated CPU-hotplug functions.

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Limit number of CPUs checked for clock synchronization

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()

Nathan Chancellor <nathan@kernel.org>
    arm64: Handle .ARM.attributes section in linker scripts

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

Ard Biesheuvel <ardb@kernel.org>
    efi: Avoid cold plugged memory for placing the kernel

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

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    usb: core: fix pipe creation for get_bMaxPacketSize0

Huacai Chen <chenhuacai@loongson.cn>
    USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: gadget: remove of_node reference upon udc_stop

Guo Ren <guoren@linux.alibaba.com>
    usb: gadget: udc: renesas_usb3: Fix compiler warning

Elson Roy Serrao <quic_eserrao@quicinc.com>
    usb: roles: set switch registered flag early on

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Ensure LBRs are disabled when a CPU is starting

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore neighbor throughput metrics in error case

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

Takashi Iwai <tiwai@suse.de>
    PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P

Edward Adam Davis <eadavis@qq.com>
    media: vidtv: Fix a null-ptr-deref in vidtv_mux_stop_thread

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

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix hang in nfsd4_shutdown_callback

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: clear acl_access/acl_default after releasing them

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent excessive coalescing on receive

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

Mike Snitzer <snitzer@kernel.org>
    pnfs/flexfiles: retry getting layout segment for reads

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jennifer Berringer <jberring@redhat.com>
    nvmem: core: improve range check for nvmem_cell_write()

Luca Weiss <luca.weiss@fairphone.com>
    nvmem: qcom-spmi-sdam: Set size in struct nvmem_config

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

Cosmin Tanislav <demonsingur@gmail.com>
    media: mc: fix endpoint iteration

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: qcom: smem_state: fix missing of_node_put in error path

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: as73211: fix channel handling in only-color triggered buffer

Nathan Chancellor <nathan@kernel.org>
    x86/boot: Use '-std=gnu11' to fix build with GCC 15

Nathan Chancellor <nathan@kernel.org>
    kbuild: Move -Wenum-enum-conversion to W=2

Long Li <longli@microsoft.com>
    scsi: storvsc: Set correct data length for sending SCSI command without payload

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Move FCE Trace buffer allocation to user control

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo C6400

Hou Tao <houtao1@huawei.com>
    dm-crypt: track tag_offset in convert_context

Hou Tao <houtao1@huawei.com>
    dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()

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

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8821ae: Fix media status report

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

Nathan Chancellor <nathan@kernel.org>
    efi: libstub: Use '-std=gnu11' to fix build with GCC 15

Zijun Hu <quic_zijuhu@quicinc.com>
    blk-cgroup: Fix class @block_class's subsystem refcount leakage

Anastasia Belova <abelova@astralinux.ru>
    clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix alpha mode configuration

Cody Eksal <masterr3c0rd@epochal.quest>
    clk: sunxi-ng: a100: enable MMC clock reparenting

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection

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

Maarten Lankhorst <dev@lankhorst.se>
    drm/modeset: Handle tiled displays in pan_display_atomic.

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    leds: lp8860: Write full EEPROM, not only half of it

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: s3c64xx: Fix compilation warning

Willem de Bruijn <willemb@google.com>
    tun: revert fix group permission check

Cong Wang <cong.wang@bytedance.com>
    netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()

Juergen Gross <jgross@suse.com>
    x86/xen: add FRAME_END to xen_hypercall_hvm()

Juergen Gross <jgross@suse.com>
    x86/xen: fix xen_hypercall_hvm() to not clobber %rbx

Eric Dumazet <edumazet@google.com>
    net: rose: lock the socket in rose_bind()

Jacob Moroni <mail@jakemoroni.com>
    net: atlantic: fix warning during hot unplug

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: Improve interrupt support

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

Xi Ruoyao <xry111@xry111.site>
    x86/mm: Don't disable PCID when INVLPG has been fixed by microcode

Illia Ostapyshyn <illia@yshyn.com>
    Input: allocate keycode for phone linking

Liu Ye <liuye@kylinos.cn>
    selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()

Dan Carpenter <dan.carpenter@linaro.org>
    tipc: re-order conditions in tipc_crypto_key_rcv()

Yuanjie Yang <quic_yuanjiey@quicinc.com>
    mmc: sdhci-msm: Correctly set the load for the regulator

Borislav Petkov <bp@alien8.de>
    APEI: GHES: Have GHES honor the panic= setting

Randolph Ha <rha051117@gmail.com>
    i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz

Vadim Fedorenko <vadfed@meta.com>
    net/mlx5: use do_aux_work for PHC overflow checks

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

Leo Stone <leocstone@gmail.com>
    safesetid: check size of policy writes

Kuan-Wei Chiu <visitorckw@gmail.com>
    printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Restrict init function to AMD-based systems

Carlos Llamas <cmllamas@google.com>
    lockdep: Fix upper limit for LOCKDEP_*_BITS configs

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

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Fix Get/SetInterface return value

Sean Rhodes <sean@starlabs.systems>
    drivers/card_reader/rtsx_usb: Restore interrupt based detection

Ricardo B. Marliere <rbm@suse.com>
    ktest.pl: Check kernelrelease return in get_version

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject mismatching sum of field_len with set key length

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

Eric Dumazet <edumazet@google.com>
    net: hsr: fix fill_frame_info() regression vs VLAN packets

Kory Maincent <kory.maincent@bootlin.com>
    net: sh_eth: Fix missing rtnl lock in suspend/resume path

Rafał Miłecki <rafal@milecki.pl>
    bgmac: reduce max frame size to support just MTU 1500

Michal Luczaj <mhal@rbox.co>
    vsock: Allow retrying on connect() failure

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix runtime error of index out of bounds

Chenyuan Yang <chenyuan0y@gmail.com>
    net: davicom: fix UAF in dm9000_drv_remove

Jakub Kicinski <kuba@kernel.org>
    net: netdevsim: try to close UDP port harness races

Eric Dumazet <edumazet@google.com>
    net: rose: fix timer races against user threads

Wentao Liang <vulab@iscas.ac.cn>
    PM: hibernate: Add error handling for syscore_suspend()

Eric Dumazet <edumazet@google.com>
    ipmr: do not call mr_mfc_uses_dev() for unres entries

Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
    net: fec: implement TSO descriptor cleanup

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix oops when unload drivers paralleling

pangliyuan <pangliyuan1@huawei.com>
    ubifs: skip dumping tnc tree when zroot is null

Oleksij Rempel <linux@rempel-privat.de>
    rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: ti: edma: fix OF node reference leaks in edma_driver

Jianbo Liu <jianbol@nvidia.com>
    xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO

Luo Yifan <luoyifan@cmss.chinamobile.com>
    tools/bootconfig: Fix the wrong format specifier

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix COPY_NOTIFY xdr buf size calculation

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    module: Extend the preempt disabled section in dereference_symbol_descriptor().

Su Yue <glass.su@suse.com>
    ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails

Paul Menzel <pmenzel@molgen.mpg.de>
    scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1

King Dix <kingdix10@qq.com>
    PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    mtd: hyperbus: hbmc-am654: fix an OF node reference leak

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Propagate buf->error to userspace

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: camif-core: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mipi-csis: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: marvell: Add check for clk_enable()

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8994: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: correct sleep clock frequency

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property

Dan Carpenter <dan.carpenter@linaro.org>
    rdma/cxgb4: Prevent potential integer overflow on 32bit

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Avoid false error about access to uninitialized gids array

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: add i2c clock-div property

Fabien Parent <fparent@baylibre.com>
    arm64: dts: mediatek: mt8516: remove 2 invalid i2c clocks

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix wdt irq type

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix GICv2 range

Chen Ridong <chenridong@huawei.com>
    padata: avoid UAF for reorder_work

Chen Ridong <chenridong@huawei.com>
    padata: add pd get/put refcnt helper

Chen Ridong <chenridong@huawei.com>
    padata: fix UAF in padata_reorder

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
    perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf env: Conditionally compile BPF support code on having HAVE_LIBBPF_SUPPORT

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_btf()

George Lander <lander@jagmn.com>
    ASoC: sun4i-spdif: Add clock multiplier settings

Marco Leogrande <leogrande@google.com>
    tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/rose: prevent integer overflows in rose_setsockopt()

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: Disallow replacing of child qdisc from one parent to another

Maher Sanalla <msanalla@nvidia.com>
    net/mlxfw: Drop hard coded max FW flash image size

Liu Jian <liujian56@huawei.com>
    net: let net.core.dev_weight always be non-zero

Mingwei Zheng <zmw12306@gmail.com>
    pwm: stm32: Add check for clk_enable()

Bo Gan <ganboing@gmail.com>
    clk: analogbits: Fix incorrect calculation of vco rate delta

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: adjust allocation of colocated AP data

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Handle specific BSSID in 6GHz scanning

Dmitry V. Levin <ldv@strace.io>
    selftests: harness: fix printing of mismatch values in __EXPECT()

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq: ACPI: Fix max-frequency computation

WangYuli <wangyuli@uniontech.com>
    wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: fix data error when recvmsg with MSG_PEEK flag

Andreas Kemnade <andreas@kemnade.info>
    wifi: wlcore: fix unbalanced pm_runtime calls

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    regulator: of: Implement the unwind path of of_regulator_match()

Octavian Purdila <tavip@google.com>
    team: prevent adding a device which is already a team device lower

Marek Vasut <marex@denx.de>
    clk: imx8mp: Fix clkout1/2 support

Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
    cpufreq: schedutil: Fix superfluous updates caused by need_freq_update

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: schedutil: Simplify sugov_update_next_freq()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()

He Rongguang <herongguang@linux.alibaba.com>
    cpupower: fix TSC MHz calculation

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ACPI: fan: cleanup resources in the error path of .probe()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: pci: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix memory leaks and invalid access at probe error path

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: destroy workqueue at rtl_deinit_core

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

Mingwei Zheng <zmw12306@gmail.com>
    spi: zynq-qspi: Add check for clk_enable()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: usb: fix workqueue leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix init_sw_vars leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: wait for firmware loading before releasing memory

Colin Ian King <colin.king@canonical.com>
    rtlwifi: remove redundant assignment to variable err

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: do not complete firmware loading needlessly

Charles Han <hanchunchao@inspur.com>
    ipmi: ipmb: Add check devm_kasprintf() returned value

Thomas Gleixner <tglx@linutronix.de>
    genirq: Make handle_enforce_irqctx() unconditionally available

Ivan Stepchenko <sid@itb.spb.ru>
    drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table

Sui Jingfeng <sui.jingfeng@linux.dev>
    drm/etnaviv: Fix page property being used for non writecombine buffers

David Howells <dhowells@redhat.com>
    afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call

Christophe Leroy <christophe.leroy@csgroup.eu>
    select: Fix unbalanced user_access_end()

Randy Dunlap <rdunlap@infradead.org>
    partitions: ldm: remove the initial kernel-doc notation

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    nvme: Add error check for xa_store in nvme_get_effects_log

Yu Kuai <yukuai3@huawei.com>
    nbd: don't allow reconnect after disconnect

David Howells <dhowells@redhat.com>
    afs: Fix directory format encoding struct

David Howells <dhowells@redhat.com>
    afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  10 +
 .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
 Makefile                                           |   9 +-
 arch/alpha/include/uapi/asm/ptrace.h               |   2 +
 arch/alpha/kernel/asm-offsets.c                    |   2 +
 arch/alpha/kernel/entry.S                          |  24 +--
 arch/alpha/kernel/traps.c                          |   2 +-
 arch/alpha/mm/fault.c                              |   4 +-
 arch/arm/boot/dts/mt7623.dtsi                      |   2 +-
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |  29 +--
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +--
 arch/arm64/boot/dts/mediatek/mt8516.dtsi           |  38 ++--
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 -
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
 arch/arm64/include/asm/mman.h                      |   9 +-
 arch/arm64/kernel/cacheinfo.c                      |  12 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |   1 +
 arch/arm64/kernel/vmlinux.lds.S                    |   1 +
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/kernel/traps.c                        |   4 +-
 arch/m68k/include/asm/vga.h                        |   8 +-
 arch/mips/kernel/ftrace.c                          |   2 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |  28 +++
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  26 ---
 arch/powerpc/lib/code-patching.c                   |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
 arch/s390/include/asm/futex.h                      |   2 +-
 arch/s390/kernel/traps.c                           |   6 +-
 arch/s390/kvm/vsie.c                               |  25 ++-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/events/intel/core.c                       |   5 +-
 arch/x86/include/asm/msr-index.h                   |   3 +-
 arch/x86/kernel/amd_nb.c                           |   4 +
 arch/x86/kernel/cpu/bugs.c                         |  20 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |   2 +-
 arch/x86/kernel/cpu/cyrix.c                        |   4 +-
 arch/x86/kernel/cpu/intel.c                        |  52 +++--
 arch/x86/kernel/i8253.c                            |  11 +-
 arch/x86/kernel/static_call.c                      |   1 -
 arch/x86/mm/init.c                                 |  23 ++-
 arch/x86/xen/mmu_pv.c                              |  79 +++++--
 arch/x86/xen/xen-head.S                            |   5 +-
 block/blk-cgroup.c                                 |   1 +
 block/partitions/efi.c                             |   2 +-
 block/partitions/ldm.h                             |   2 +-
 block/partitions/mac.c                             |  18 +-
 crypto/testmgr.h                                   | 227 +++++++++++++++------
 drivers/acpi/apei/ghes.c                           |  10 +-
 drivers/acpi/fan.c                                 |  10 +-
 drivers/base/regmap/regmap-irq.c                   |   2 +
 drivers/block/nbd.c                                |   1 +
 drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
 drivers/char/tpm/eventlog/acpi.c                   |  16 +-
 drivers/char/tpm/eventlog/efi.c                    |  13 +-
 drivers/char/tpm/eventlog/of.c                     |   3 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
 drivers/clk/imx/clk-imx8mp.c                       |   5 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   6 +-
 drivers/clocksource/i8253.c                        |  13 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  36 +++-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
 drivers/crypto/hisilicon/qm.c                      |  46 ++---
 drivers/crypto/qce/core.c                          |  13 +-
 drivers/dma/ti/edma.c                              |   3 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/firmware/efi/efi.c                         |   6 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/firmware/efi/libstub/randomalloc.c         |   3 +
 drivers/firmware/efi/libstub/relocate.c            |   3 +
 drivers/firmware/efi/mokvar-table.c                |  41 ++--
 drivers/gpio/gpio-aggregator.c                     |  20 +-
 drivers/gpio/gpio-bcm-kona.c                       |  71 +++++--
 drivers/gpio/gpio-pca953x.c                        |  19 --
 drivers/gpio/gpio-rcar.c                           |   7 +-
 drivers/gpio/gpio-stmpe.c                          |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   2 +
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
 drivers/gpu/drm/drm_dp_cec.c                       |  14 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  14 +-
 drivers/gpu/drm/drm_probe_helper.c                 | 116 ++++++++---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
 drivers/gpu/drm/radeon/r300.c                      |   3 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
 drivers/gpu/drm/radeon/rs400.c                     |  18 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   9 +-
 drivers/gpu/drm/scheduler/gpu_scheduler_trace.h    |   4 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |  22 +-
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
 drivers/i2c/busses/i2c-npcm7xx.c                   |   7 +
 drivers/i2c/i2c-core-acpi.c                        |  22 ++
 drivers/idle/intel_idle.c                          |   4 +
 drivers/iio/light/as73211.c                        |  24 ++-
 drivers/infiniband/hw/cxgb4/device.c               |   6 +-
 drivers/infiniband/hw/mlx4/main.c                  |   6 +-
 drivers/infiniband/hw/mlx5/counters.c              |   8 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
 drivers/leds/leds-lp8860.c                         |   2 +-
 drivers/leds/leds-netxbig.c                        |   1 +
 drivers/md/dm-crypt.c                              |  27 +--
 drivers/media/dvb-frontends/cxd2841er.c            |   8 +-
 drivers/media/i2c/ov5640.c                         |   1 +
 drivers/media/platform/exynos4-is/mipi-csis.c      |  10 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   7 +-
 drivers/media/platform/s3c-camif/camif-core.c      |  13 +-
 drivers/media/rc/iguanair.c                        |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   8 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  14 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  85 ++++++--
 drivers/media/usb/uvc/uvc_driver.c                 |  63 +++---
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/media/usb/uvc/uvc_status.c                 |   1 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +
 drivers/media/usb/uvc/uvcvideo.h                   |   9 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
 drivers/mfd/lpc_ich.c                              |   3 +-
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/misc/fastrpc.c                             |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/mmc/core/sdio.c                            |   2 +
 drivers/mmc/host/sdhci-msm.c                       |  53 ++++-
 drivers/mtd/hyperbus/hbmc-am654.c                  |  19 +-
 drivers/mtd/nand/onenand/onenand_base.c            |   1 +
 drivers/mtd/nand/raw/cadence-nand-controller.c     |  44 +++-
 drivers/net/caif/caif_virtio.c                     |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   4 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   3 +-
 drivers/net/ethernet/broadcom/tg3.c                |  58 ++++++
 drivers/net/ethernet/cadence/macb.h                |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  12 +-
 drivers/net/ethernet/davicom/dm9000.c              |   3 +-
 drivers/net/ethernet/emulex/benet/be.h             |   2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        | 197 +++++++++---------
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  31 ++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  15 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  24 ++-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   4 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   2 +
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/geneve.c                               |  16 +-
 drivers/net/gtp.c                                  |   5 -
 drivers/net/loopback.c                             |  14 ++
 drivers/net/netdevsim/ipsec.c                      |  12 +-
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/netdevsim/udp_tunnels.c                |  23 ++-
 drivers/net/ppp/ppp_generic.c                      |  28 ++-
 drivers/net/team/team.c                            |  11 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/gl620a.c                           |   4 +-
 drivers/net/usb/rtl8150.c                          |  28 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  42 ++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  67 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  13 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  23 ---
 drivers/net/wireless/ti/wlcore/main.c              |  10 +-
 drivers/nvme/host/core.c                           |  16 +-
 drivers/nvme/host/pci.c                            |  66 +++++-
 drivers/nvme/target/tcp.c                          |  15 +-
 drivers/nvmem/core.c                               |   2 +
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/of/base.c                                  |   8 +-
 drivers/parport/parport_pc.c                       |   5 +
 drivers/pci/controller/pcie-rcar-ep.c              |   2 +-
 drivers/pci/endpoint/pci-epc-core.c                |   2 +-
 drivers/pci/quirks.c                               |   1 +
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
 drivers/pwm/pwm-stm32.c                            |   7 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |   3 +-
 drivers/rapidio/rio-scan.c                         |   5 +-
 drivers/regulator/of_regulator.c                   |  14 +-
 drivers/rtc/rtc-pcf85063.c                         |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c                     | 122 +++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
 drivers/scsi/qla2xxx/qla_init.c                    |  28 ++-
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/scsi/ufs/ufs_bsg.c                         |   1 +
 drivers/slimbus/messaging.c                        |   5 +-
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/spi/spi-mxs.c                              |   3 +-
 drivers/spi/spi-zynq-qspi.c                        |  13 +-
 drivers/staging/media/imx/imx-media-of.c           |   8 +-
 drivers/tee/optee/supp.c                           |  35 +---
 drivers/tty/serial/8250/8250.h                     |   2 +
 drivers/tty/serial/8250/8250_dma.c                 |  16 ++
 drivers/tty/serial/8250/8250_pci.c                 |  10 +
 drivers/tty/serial/8250/8250_port.c                |   9 +
 drivers/tty/serial/sh-sci.c                        |  25 ++-
 drivers/usb/atm/cxacru.c                           |  13 +-
 drivers/usb/class/cdc-acm.c                        |  28 ++-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/quirks.c                          |  10 +
 drivers/usb/dwc2/gadget.c                          |   1 +
 drivers/usb/dwc3/gadget.c                          |  37 +++-
 drivers/usb/gadget/composite.c                     |  17 +-
 drivers/usb/gadget/function/f_midi.c               |  22 +-
 drivers/usb/gadget/function/f_tcm.c                |  66 +++---
 drivers/usb/gadget/udc/renesas_usb3.c              |   2 +-
 drivers/usb/host/pci-quirks.c                      |   9 +
 drivers/usb/host/xhci-mem.c                        |   5 +-
 drivers/usb/host/xhci-pci.c                        |  17 +-
 drivers/usb/host/xhci-ring.c                       |  12 +-
 drivers/usb/host/xhci.c                            |  23 ++-
 drivers/usb/host/xhci.h                            |  11 +-
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
 fs/afs/dir.c                                       |   7 +-
 fs/afs/xdr_fs.h                                    |   2 +-
 fs/afs/yfsclient.c                                 |   5 +-
 fs/binfmt_flat.c                                   |   2 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/locking.c                                 |  68 +++++-
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/transaction.c                             |   4 +-
 fs/cifs/smb2ops.c                                  |   4 +
 fs/f2fs/file.c                                     |  13 ++
 fs/nfs/flexfilelayout/flexfilelayout.c             |  27 ++-
 fs/nfs/nfs42xdr.c                                  |   2 +
 fs/nfsd/nfs2acl.c                                  |   2 +
 fs/nfsd/nfs3acl.c                                  |   2 +
 fs/nfsd/nfs4callback.c                             |   8 +-
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
 fs/select.c                                        |   4 +-
 fs/squashfs/inode.c                                |   5 +-
 fs/ubifs/debug.c                                   |  22 +-
 fs/udf/super.c                                     |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/drm/drm_probe_helper.h                     |   1 +
 include/linux/efi.h                                |   1 +
 include/linux/i8253.h                              |   1 +
 include/linux/kallsyms.h                           |   2 +-
 include/linux/kvm_host.h                           |   9 +
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/netdevice.h                          |   6 +
 include/linux/pci_ids.h                            |   4 +
 include/linux/pps_kernel.h                         |   3 +-
 include/linux/usb/hcd.h                            |   5 +-
 include/net/dst.h                                  |  23 ++-
 include/net/flow_dissector.h                       |  16 ++
 include/net/flow_offload.h                         |   6 +
 include/net/l3mdev.h                               |   2 +
 include/net/net_namespace.h                        |  15 +-
 include/trace/events/oom.h                         |  36 +++-
 include/uapi/linux/input-event-codes.h             |   1 +
 kernel/acct.c                                      | 141 ++++++++-----
 kernel/bpf/syscall.c                               |  18 +-
 kernel/debug/kdb/kdb_io.c                          |   2 +
 kernel/events/core.c                               |  17 +-
 kernel/irq/internals.h                             |   9 +-
 kernel/padata.c                                    |  45 +++-
 kernel/power/hibernate.c                           |   7 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |   8 +-
 kernel/sched/cpufreq_schedutil.c                   |  12 +-
 kernel/time/clocksource.c                          |  79 ++++++-
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ftrace.c                              |  27 ++-
 lib/Kconfig.debug                                  |   8 +-
 mm/memcontrol.c                                    |   7 +-
 mm/oom_kill.c                                      |  14 +-
 mm/page_alloc.c                                    |   1 +
 net/8021q/vlan.c                                   |   3 +-
 net/8021q/vlan.h                                   |   2 +-
 net/8021q/vlan_dev.c                               |  15 +-
 net/8021q/vlan_netlink.c                           |   7 +-
 net/batman-adv/bat_v.c                             |   3 +-
 net/batman-adv/bat_v_elp.c                         | 124 +++++++----
 net/batman-adv/bat_v_elp.h                         |   2 -
 net/batman-adv/bat_v_ogm.c                         |   1 +
 net/batman-adv/fragmentation.c                     |   2 +-
 net/batman-adv/hard-interface.c                    |   1 +
 net/batman-adv/icmp_socket.c                       |   1 +
 net/batman-adv/main.c                              |   1 +
 net/batman-adv/netlink.c                           |   1 +
 net/batman-adv/tp_meter.c                          |   1 +
 net/batman-adv/types.h                             |   3 -
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/can/j1939/socket.c                             |   4 +-
 net/can/j1939/transport.c                          |   5 +-
 net/core/drop_monitor.c                            |  39 ++--
 net/core/flow_dissector.c                          |  49 +++--
 net/core/flow_offload.c                            |   7 +
 net/core/neighbour.c                               |  11 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sysctl_net_core.c                         |   5 +-
 net/hsr/hsr_forward.c                              |   7 +-
 net/ipv4/arp.c                                     |   4 +-
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/ip_input.c                                |   1 +
 net/ipv4/ip_output.c                               |   1 +
 net/ipv4/ipmr_base.c                               |   3 -
 net/ipv4/route.c                                   |   8 +-
 net/ipv4/tcp_minisocks.c                           |  10 +-
 net/ipv4/tcp_offload.c                             |  11 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv4/udp_offload.c                             |   8 +-
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/ipv6/ip6_output.c                              |   1 +
 net/ipv6/ndisc.c                                   |  28 +--
 net/ipv6/route.c                                   |   7 +-
 net/ipv6/rpl_iptunnel.c                            |  67 +++---
 net/ipv6/seg6_iptunnel.c                           |   2 +-
 net/ipv6/udp.c                                     |   4 +-
 net/llc/llc_s_ac.c                                 |  49 +++--
 net/mptcp/pm_netlink.c                             |   6 -
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/ncsi-manage.c                             |  13 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/nfc/nci/hci.c                                  |   2 +
 net/openvswitch/datapath.c                         |  12 +-
 net/rose/af_rose.c                                 |  40 ++--
 net/rose/rose_timer.c                              |  15 ++
 net/sched/cls_flower.c                             |   8 +-
 net/sched/sch_api.c                                |   4 +
 net/sched/sch_cake.c                               | 140 +++++++------
 net/sched/sch_fifo.c                               |   3 +
 net/sched/sch_netem.c                              |   2 +-
 net/smc/af_smc.c                                   |   2 +-
 net/smc/smc_rx.c                                   |  37 ++--
 net/smc/smc_rx.h                                   |   8 +-
 net/sunrpc/cache.c                                 |  10 +-
 net/tipc/crypto.c                                  |   4 +-
 net/vmw_vsock/af_vsock.c                           |  82 +++++---
 net/wireless/nl80211.c                             |   5 +
 net/wireless/reg.c                                 |   3 +-
 net/wireless/scan.c                                |  35 ++++
 net/xfrm/xfrm_replay.c                             |  10 +-
 scripts/Makefile.extrawarn                         |   5 +-
 scripts/genksyms/genksyms.c                        |  11 +-
 scripts/genksyms/genksyms.h                        |   2 +-
 scripts/genksyms/parse.y                           |  18 +-
 security/integrity/ima/ima_api.c                   |  16 +-
 security/integrity/ima/ima_template_lib.c          |  17 +-
 security/safesetid/securityfs.c                    |   3 +
 security/tomoyo/common.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  78 +++++++
 sound/soc/codecs/es8328.c                          |  15 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  17 +-
 sound/soc/sunxi/sun4i-spdif.c                      |   7 +
 sound/usb/midi.c                                   |   2 +-
 sound/usb/usx2y/usbusx2y.c                         |  11 +
 sound/usb/usx2y/usbusx2y.h                         |  26 +++
 sound/usb/usx2y/usbusx2yaudio.c                    |  27 ---
 tools/bootconfig/main.c                            |   4 +-
 tools/perf/bench/epoll-wait.c                      |   7 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-top.c                           |   2 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/util/bpf-event.c                        |  10 +-
 tools/perf/util/cs-etm.c                           |   2 +-
 tools/perf/util/dso.c                              |  14 +-
 tools/perf/util/env.c                              |  28 ++-
 tools/perf/util/env.h                              |   8 +-
 tools/perf/util/header.c                           |  29 ++-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
 tools/testing/ktest/ktest.pl                       |   7 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
 .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  16 +-
 tools/testing/selftests/kselftest_harness.h        |  24 +--
 tools/testing/selftests/net/ipsec.c                |   3 +-
 tools/testing/selftests/net/rtnetlink.sh           |   4 +-
 tools/testing/selftests/net/udpgso.c               |  26 +++
 434 files changed, 4060 insertions(+), 2030 deletions(-)


