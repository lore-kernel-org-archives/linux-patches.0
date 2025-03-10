Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062718DB24;
	Mon, 10 Mar 2025 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628338; cv=none; b=Qk5uEuMdYyIOTdRsr1XVUU/xsAJkThatSfjks5lOvt+7lI6Va3JXInXknYpTsOnoUOz2DxjwYadCXie74JQQ1vDbmeeaXyLCQpzPtGzKInPyRPSd0sxQJvFtGZ2TqbFSFYfXPOxmzcMk5JaCIFAOMik8Qhp6iSDp6s2VALRHk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628338; c=relaxed/simple;
	bh=y6NK62yWrqMndq3tYyX1Mdt1SG/A59dj5bKfh1vN7d4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a1EBotypyxlnn9a8e3AUWPg6lZBhhGaO3XkbXK9vTuhH162k8Es1WewN9egW56uPgKwTXYea5f8Kd2xRUtcX0vul6sjQHFbtGFlnN5g29BPebyX075l8gawtksy9PqTdgUoTa/SX2eLmH6+6Vh+01rqdJ8Pv1u0twmlnQ7+0Soc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+TaLsXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+TaLsXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3E4C4CEE5;
	Mon, 10 Mar 2025 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628337;
	bh=y6NK62yWrqMndq3tYyX1Mdt1SG/A59dj5bKfh1vN7d4=;
	h=From:To:Cc:Subject:Date:From;
	b=z+TaLsXwBLI6LDAjRBGNXfS171mQF3JfBIVWYvOSQwRbvdYHbwdLl6DikPrI3Gvdz
	 6FFOFlhtB7T8odWfr40Oi3u8ICVQ+xjyXr1WDsO1PHmBwcn+1lftwWshD5HLTXbey1
	 HYCwNE9OyYTF1T5Nqf45gt3uIA9wh5l22fvZeZuI=
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
Subject: [PATCH 6.1 000/109] 6.1.131-rc1 review
Date: Mon, 10 Mar 2025 18:05:44 +0100
Message-ID: <20250310170427.529761261@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.131-rc1
X-KernelTest-Deadline: 2025-03-12T17:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.131 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.131-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.131-rc1

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct lld when linking through clang

Michal Luczaj <mhal@rbox.co>
    vsock: Orphan socket after transport release

Michal Luczaj <mhal@rbox.co>
    vsock: Keep the binding until socket destruction

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Invoke proto::close on close()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add rough attr alloc_size check

Irui Wang <irui.wang@mediatek.com>
    media: mediatek: vcodec: Handle invalid decoder vsi

Tuo Li <islituo@gmail.com>
    scsi: lpfc: Fix a possible data race in lpfc_unregister_fcf_rescan()

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

Jiri Olsa <jolsa@kernel.org>
    uprobes: Fix race in uprobe_free_utask

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: e500: always restore irqs"

Arnd Bergmann <arnd@arndb.de>
    ALSA: hda: realtek: fix incorrect IS_REACHABLE() usage

Nayab Sayed <nayabbasha.sayed@microchip.com>
    iio: adc: at91-sama5d2_adc: fix sama7g5 realbits value

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r: clear reset status flag

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: Force initialization of SDO

Haoyu Li <lihaoyu499@gmail.com>
    drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Make GPIO lookup table match the device

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: host: pci_generic: Use pci_try_reset_function() to avoid deadlock

Visweswara Tanuku <quic_vtanuku@quicinc.com>
    slimbus: messaging: Free transaction ID in delayed interrupt scenario

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drivers: core: fix device leak in __fw_devlink_relax_cycles()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-P/U support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-H support

Pawel Chmielewski <pawel.chmielewski@intel.com>
    intel_th: pci: Add Arrow Lake support

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake P DID

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Enable the TRB overfetch quirk on VIA VL805

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

Badhri Jagan Sridharan <badhri@google.com>
    usb: dwc3: gadget: Prevent irq storm when TH re-executes

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Set SUSPENDENABLE soon after phy init

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix a flaw in existing endpoint checks

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Flush the notify_hotplug_work

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader

Pawel Laszczak <pawell@cadence.com>
    usb: hub: lack of clearing xHC resources

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

Zecheng Li <zecheng@google.com>
    sched/fair: Fix potential memory corruption in child_cfs_rq_on_list

Uday Shankar <ushankar@purestorage.com>
    ublk: set_params: properly check if parameters can be applied

Jason Xing <kerneljasonxing@gmail.com>
    net-timestamp: support TCP GSO case for a few missing flags

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix soft lockup in exfat_clear_bitmap

Jarkko Sakkinen <jarkko@kernel.org>
    x86/sgx: Fix size overflows in sgx_encl_create()

Oscar Maes <oscmaes92@gmail.com>
    vlan: enforce underlying device type

Jiayuan Chen <jiayuan.chen@linux.dev>
    ppp: Fix KMSAN uninit-value warning with bpf

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: make sure ptp clock is unregister and freed if hclge_ptp_get_cycle returns an error

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

Salah Triki <salah.triki@gmail.com>
    bluetooth: btusb: Initialize .owner field of force_poll_sync_fops

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()

Yu-Chun Lin <eleanor15x@gmail.com>
    HID: google: fix unused variable warning under !CONFIG_ACPI

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: limit printed string from FW file

Ryan Roberts <ryan.roberts@arm.com>
    mm: don't skip arch_sync_kernel_mappings() in error paths

Hao Zhang <zhanghao1@kylinos.cn>
    mm/page_alloc: fix uninitialized variable

Olivier Gayot <olivier.gayot@canonical.com>
    block: fix conversion of GPT partition name to 7-bit

Heiko Carstens <hca@linux.ibm.com>
    s390/traps: Fix test_monitor_call() inline assembly

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    dma: kmsan: export kmsan_handle_dma() for modules

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: fix an API misues when rio_add_net() fails

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: add check for rio_add_net() in rio_scan_alloc_net()

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    wifi: nl80211: reject cooked mode if it is set along with other flags

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: cfg80211: regulatory: improve invalid hints checking

Haoxiang Li <haoxiang_li2024@163.com>
    Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()

Haoxiang Li <haoxiang_li2024@163.com>
    Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: fix 'scheduling while atomic' in mptcp_pm_nl_append_new_local_addr

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

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: update ALC222 depop optimize

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - add supported Mic Mute LED for Lenovo platform

Hoku Ishibe <me@hokuishi.be>
    ALSA: hda: intel: Add Dell ALC3271 to power_save denylist

Koichiro Den <koichiro.den@canonical.com>
    gpio: aggregator: protect driver attr handlers against module unload

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    gpio: rcar: Use raw_spinlock to protect register access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix bug on trap in smb2_lock

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb2_lock

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix type confusion via race condition when using ipc_msg_send_request

Daniil Dulov <d.dulov@aladdin.ru>
    HID: appleir: Fix potential NULL dereference at raw event handle

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Convert unreachable() to BUG()

Rob Herring (Arm) <robh@kernel.org>
    Revert "of: reserved-memory: Fix using wrong number of cells to get property 'alignment'"

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/amd_nb: Use rdmsr_safe() in amd_get_mmconfig_range()

Waiman Long <longman@redhat.com>
    x86/speculation: Add __update_spec_ctrl() helper

Peter Zijlstra <peterz@infradead.org>
    cpuidle, intel_idle: Fix CPUIDLE_FLAG_IBRS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable BAR resize on Dell G5 SE

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Check extended configuration space register when system uses large bar

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Inspect header requirements before using scrq direct

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Perform tx CSO during send scrq direct


-------------

Diffstat:

 Makefile                                           |   9 +-
 arch/loongarch/kernel/machine_kexec.c              |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |  21 ++-
 arch/s390/kernel/traps.c                           |   6 +-
 arch/x86/include/asm/spec-ctrl.h                   |  11 ++
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/cpu/bugs.c                         |   2 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  52 ++++--
 arch/x86/kernel/cpu/sgx/ioctl.c                    |   7 +
 arch/x86/kvm/svm/svm.c                             |  12 ++
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/mm/init.c                                 |  23 ++-
 block/partitions/efi.c                             |   2 +-
 drivers/base/core.c                                |   1 +
 drivers/block/ublk_drv.c                           |   7 +-
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bus/mhi/host/pci_generic.c                 |   5 +-
 drivers/gpio/gpio-aggregator.c                     |  20 ++-
 drivers/gpio/gpio-rcar.c                           |  31 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 ++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +-
 drivers/gpu/drm/radeon/r300.c                      |   3 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
 drivers/gpu/drm/radeon/rs400.c                     |  18 +-
 drivers/gpu/drm/scheduler/gpu_scheduler_trace.h    |   4 +-
 drivers/hid/hid-appleir.c                          |   2 +-
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/intel-ish-hid/ishtp-hid.c              |   4 +-
 drivers/hwmon/ad7314.c                             |  10 ++
 drivers/hwmon/ntc_thermistor.c                     |  66 +++----
 drivers/hwmon/pmbus/pmbus.c                        |   2 +
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |  15 ++
 drivers/idle/intel_idle.c                          |   4 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  68 ++++---
 drivers/iio/dac/ad3552r.c                          |   6 +
 drivers/iio/filter/admv8818.c                      |  14 +-
 .../media/platform/mediatek/vcodec/vdec_vpu_if.c   |   6 +
 drivers/misc/cardreader/rtsx_usb.c                 |  15 --
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/caif/caif_virtio.c                     |   2 +-
 drivers/net/ethernet/emulex/benet/be.h             |   2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        | 197 ++++++++++-----------
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  21 ++-
 drivers/net/ppp/ppp_generic.c                      |  28 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/nvme/target/tcp.c                          |  15 +-
 drivers/of/of_reserved_mem.c                       |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/rapidio/devices/rio_mport_cdev.c           |   3 +-
 drivers/rapidio/rio-scan.c                         |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +
 drivers/slimbus/messaging.c                        |   5 +-
 drivers/spi/spi-mxs.c                              |   3 +-
 drivers/usb/atm/cxacru.c                           |  13 +-
 drivers/usb/core/hub.c                             |  33 ++++
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc3/core.c                            |  85 +++++----
 drivers/usb/dwc3/core.h                            |   2 +-
 drivers/usb/dwc3/drd.c                             |   4 +-
 drivers/usb/dwc3/gadget.c                          |  10 +-
 drivers/usb/gadget/composite.c                     |  17 +-
 drivers/usb/host/xhci-mem.c                        |   3 +-
 drivers/usb/host/xhci-pci.c                        |  18 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   6 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   2 +-
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  11 ++
 drivers/usb/typec/ucsi/ucsi.c                      |   2 +-
 drivers/virt/acrn/hsm.c                            |   6 +-
 fs/exfat/balloc.c                                  |  10 +-
 fs/exfat/exfat_fs.h                                |   2 +-
 fs/exfat/fatent.c                                  |  11 +-
 fs/nilfs2/dir.c                                    |  24 ++-
 fs/nilfs2/namei.c                                  |  37 ++--
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/ntfs3/record.c                                  |   3 +
 fs/smb/server/smb2pdu.c                            |   8 +-
 fs/smb/server/transport_ipc.c                      |   1 +
 kernel/events/uprobes.c                            |   2 +-
 kernel/sched/fair.c                                |   6 +-
 mm/kmsan/hooks.c                                   |   1 +
 mm/memory.c                                        |   6 +-
 mm/page_alloc.c                                    |   1 +
 mm/vmalloc.c                                       |   4 +-
 net/8021q/vlan.c                                   |   3 +-
 net/bluetooth/mgmt.c                               |   5 +
 net/ipv4/tcp_offload.c                             |  11 +-
 net/ipv4/udp_offload.c                             |   8 +-
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/llc/llc_s_ac.c                                 |  49 ++---
 net/mptcp/pm_netlink.c                             |  18 +-
 net/vmw_vsock/af_vsock.c                           |  77 +++++---
 net/wireless/nl80211.c                             |   5 +
 net/wireless/reg.c                                 |   3 +-
 sound/pci/hda/Kconfig                              |   1 +
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |  99 ++++++++++-
 sound/usb/usx2y/usbusx2y.c                         |  11 ++
 sound/usb/usx2y/usbusx2y.h                         |  26 +++
 sound/usb/usx2y/usbusx2yaudio.c                    |  27 ---
 106 files changed, 969 insertions(+), 507 deletions(-)


