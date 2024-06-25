Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1B61465A8;
	Tue, 25 Jun 2024 09:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309512; cv=none; b=T61wyeeHP7lTriGOeyhweRsb7Jt9xmu/HjOTQCmbQpHAe6Jrv5CstXZDu+J1RpN13auCddudUUH1gStOc1a3FUTkaoXbGeeFk09cLh6lhMPbNef3IlAkWN7oVERrvNFOehAdE64TmgKvVsCpczyrtkqpBNUVvbX/9FP+W3do/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309512; c=relaxed/simple;
	bh=SgSwhVKxSUbc/K/QSYHROrYiznMf2PV3YtufWp24sEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YBJF2AyHEnChN0XE0lolDxuBqS+wkXZUd1S6NqsWq7TQVpO1UR1WfItU62PhQ7bbKk94hNXQAtM7SzS5yRH2/x/oma+lM5Z3Avae1NCJAJjfK/f7r2G4ff2qmdlESv8YruV7KRY/Z9ZiouJ/gmM57vE2jOb7Y9rkYno6Hup+p7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDtOn6zY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDtOn6zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583DBC32781;
	Tue, 25 Jun 2024 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309511;
	bh=SgSwhVKxSUbc/K/QSYHROrYiznMf2PV3YtufWp24sEk=;
	h=From:To:Cc:Subject:Date:From;
	b=GDtOn6zYcs+XjAnObQTYGKBFjfU6NPoo3zNB9204W6htl7/pvPgU0/OWq97d61PVd
	 DH9VqvBvcGHxMWy8G5xN6/DKvuW4GqeXd/pHdzjEMH5phQ62BDkgBrxdy9z3Rmlj85
	 23PCgyREXOAe4S8lzPbXGKVnfkswaarkAnWPTAII=
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
Subject: [PATCH 6.1 000/131] 6.1.96-rc1 review
Date: Tue, 25 Jun 2024 11:32:35 +0200
Message-ID: <20240625085525.931079317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.96-rc1
X-KernelTest-Deadline: 2024-06-27T08:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.96 release.
There are 131 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.96-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default"

Andrew Ballance <andrewjballance@gmail.com>
    hid: asus: asus_report_fixup: fix potential read out of bounds

Davide Caratti <dcaratti@redhat.com>
    net/sched: unregister lockdep keys in qdisc_create/qdisc_alloc error path

Martin Leung <martin.leung@amd.com>
    drm/amd/display: revert Exit idle optimizations before HDCP execution

Matthias Maennich <maennich@google.com>
    kheaders: explicitly define file modes for archived headers

Masahiro Yamada <masahiroy@kernel.org>
    Revert "kheaders: substituting --sort in archive creation"

Tony Luck <tony.luck@intel.com>
    x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add new macros to work with (vendor/family/model) values

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    pmdomain: ti-sci: Fix duplicate PD referrals

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdk4412: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdkv310: fix keypad no-autorepeat

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Show also errors for --insn-trace option

Changbin Du <changbin.du@huawei.com>
    perf: script: add raw|disasm arguments to --insn-trace option

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Fix dual flash mode sanity test in stm32_qspi_setup()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

Peter Xu <peterx@redhat.com>
    mm/page_table_check: fix crash on ZONE_DEVICE

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()

Rafael Aquini <aquini@redhat.com>
    mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

Aleksandr Nogikh <nogikh@google.com>
    kcov: don't lose track of remote references during softirqs

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mso: using joiner is not possible with eDP MSO

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on N14AP7

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 445/465 G11.

Sean Christopherson <seanjc@google.com>
    KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Disassociate vcpus from redistributor region on teardown

Breno Leitao <leitao@debian.org>
    KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Steve French <stfrench@microsoft.com>
    cifs: fix typo in module parameter enable_gcm_256

Boris Burkov <boris@bur.io>
    btrfs: retry block group reclaim without infinite loop

Ignat Korchagin <ignat@cloudflare.com>
    net: do not leave a dangling sk pointer, when socket creation fails

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: improve reset check

Oleksij Rempel <linux@rempel-privat.de>
    net: stmmac: Assign configured channel value to EXTTS event

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: dts: bcm63268: Add missing properties to the TWD node

Nathan Chancellor <nathan@kernel.org>
    kbuild: Remove support for Clang's ThinLTO caching

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Add check for srq max_sge attribute

Sudeep Holla <sudeep.holla@arm.com>
    firmware: psci: Fix return value from psci_system_suspend()

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin

Fabio Estevam <festevam@gmail.com>
    arm64: dts: imx93-11x11-evk: Remove the 'no-sdio' property

Kalle Niemi <kaleposti@gmail.com>
    regulator: bd71815: fix ramp values

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix missing kmem_cache_destroy()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix kmemleak in ioat_pci_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix error path in ioat3_dma_probe()

Bjorn Helgaas <bhelgaas@google.com>
    dmaengine: ioat: use PCI core macros for PCIe Capability

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix leaking on version mismatch

Bjorn Helgaas <bhelgaas@google.com>
    dmaengine: ioat: Drop redundant pci_enable_pcie_error_reporting()

Li RongQing <lirongqing@baidu.com>
    dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Restore PTP tx_avail count in case of skb_pad() error

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix VSI list rule with ICE_SW_LKUP_LAST type

Jianguo Wu <wujianguo@chinatelecom.cn>
    seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix suspicious rcu_dereference_protected()

Simon Horman <horms@kernel.org>
    octeontx2-pf: Add error handling to VLAN unoffload handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: No need to calculate speed divider when offload is disabled

Dan Carpenter <dan.carpenter@linaro.org>
    ptp: fix integer overflow in max_vclocks_store

Xin Long <lucien.xin@gmail.com>
    sched: act_ct: add netns into the key of tcf_ct_flow_table

Xin Long <lucien.xin@gmail.com>
    tipc: force a dst refcount before doing decryption

David Ruth <druth@chromium.org>
    net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_api: rely on rcu in tcf_idr_check_alloc

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: phy: mxl-gpy: Remove interrupt mask clearing from config_init

Xu Liang <lxu@maxlinear.com>
    net: phy: mxl-gpy: enhance delay time required by loopback disable function

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: Support WOL at both the PHY and MAC appropriately

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: disable WOL upon resume to restore full data path operation

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make interrupt remembering atomic

Yue Haibing <yuehaibing@huawei.com>
    netns: Make get_net_ns() handle zero refcount net

Eric Dumazet <edumazet@google.com>
    xfrm6: check ip6_dst_idev() return value in xfrm6_get_saddr()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL dereference in rt6_probe()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL deref in fib6_nh_init()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netrom: Fix a memory leak in nr_heartbeat_expiry()

Ajrat Makhmutov <rautyrauty@gmail.com>
    ALSA: hda/realtek: Enable headset mic on IdeaPad 330-17IKB 81DM

Florian Westphal <fw@strlen.de>
    bpf: Avoid splat in pskb_pull_reason

Ondrej Mosnacek <omosnace@redhat.com>
    cipso: fix total option length computation

En-Wei Wu <en-wei.wu@canonical.com>
    ice: avoid IRQ collision to fix init failure on ACPI S3 resume

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: move RDMA init to ice_idc.c

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA/hda: intel-dsp-config: Document AVS as dsp_driver option

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: Remove Framework Laptop 16 from quirks

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Build event generation tests only as modules

Christian Marangi <ansuelsmth@gmail.com>
    mips: bmips: BCM6358: make sure CBR is correctly set

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    MIPS: Routerboard 532: Fix vendor retry check code

Linus Torvalds <torvalds@linux-foundation.org>
    tty: add the option to have a tty reject a new ldisc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: function: Remove usage of the deprecated ida_simple_xx() API

Parker Newman <pnewman@connecttech.com>
    serial: exar: adding missing CTI and Exar PCI ids

Esben Haabendal <esben@geanix.com>
    serial: imx: Introduce timeout when waiting on transmitter empty

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Don't set "linux,phy_charger_detect" property on Lenovo Yoga Tab2 1380

Joao Pinto <Joao.Pinto@synopsys.com>
    Avoid hw_desc array overrun in dw-axi-dmac

Alex Henrie <alexhenrie24@gmail.com>
    usb: misc: uss720: check for incompatible versions of the Belkin F5U002

Yunlei He <heyunlei@oppo.com>
    f2fs: remove clear SB_INLINECRYPT flag in default_options

Aleksandr Aprelkov <aaprelkov@usergate.com>
    iommu/arm-smmu-v3: Free MSIs in case of ENOMEM

Tzung-Bi Shih <tzungbi@kernel.org>
    power: supply: cros_usbpd: provide ID table for avoiding fallback match

Ben Fradella <bfradell@netapp.com>
    platform/x86: p2sb: Don't init until unassigned resources have been assigned

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/io: Avoid clang null pointer arithmetic warnings

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Enforce hcall result buffer validity and size

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for Lenovo 13X

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: mask irqs in timeout path before hard reset

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: add mask irq callback to gp and pp

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14

Arvid Norlander <lkml@vorpal.se>
    platform/x86: toshiba_acpi: Add quirk for buttons on Z830

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Exit idle optimizations before HDCP execution

Uri Arev <me@wantyapps.xyz>
    Bluetooth: ath3k: Fix multiple issues reported by checkpatch.pl

Luke D. Jones <luke@ljones.dev>
    HID: asus: fix more n-key report descriptors if n-key quirked

Sean O'Brien <seobrien@chromium.org>
    HID: Add quirk for Logitech Casa touchpad

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7921s: fix potential hung tasks during chip recovery

Breno Leitao <leitao@debian.org>
    netpoll: Fix race condition in netpoll_owner_active

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek: keep default LED state in rtl8366rb

Kunwu Chan <chentao@kylinos.cn>
    kselftest: arm64: Add a null pointer check

Davide Caratti <dcaratti@redhat.com>
    net/sched: fix false lockdep warning on qdisc root lock

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Fix crash while reading debugfs attribute

Wander Lairson Costa <wander@redhat.com>
    drop_monitor: replace spin_lock by raw_spin_lock

Eric Dumazet <edumazet@google.com>
    af_packet: avoid a false positive warning in packet_setsockopt()

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: work around memset overflow warning

Eric Dumazet <edumazet@google.com>
    batman-adv: bypass empty buckets in batadv_purge_orig_ref()

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix flaky test btf_map_in_map/lookup_update

Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
    selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh

Justin Stitt <justinstitt@google.com>
    block/ioctl: prefer different overflow check

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Fix invalid context warning when enable srcu barrier testing

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Make stall-tasks directly exit when rcutorture tests end

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: work around a potential audit memory leak

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec - Fix memory leak for sec resource release

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Disable BH when taking works lock on MT path


-------------

Diffstat:

 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml    |  2 +-
 Makefile                                           |  9 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |  2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |  2 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  2 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |  2 +-
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts  |  1 -
 arch/arm64/kvm/vgic/vgic-init.c                    |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 15 +++-
 arch/arm64/kvm/vgic/vgic.h                         |  2 +-
 arch/mips/bmips/setup.c                            |  3 +-
 arch/mips/boot/dts/brcm/bcm63268.dtsi              |  2 +
 arch/mips/pci/ops-rc32434.c                        |  4 +-
 arch/mips/pci/pcie-octeon.c                        |  6 ++
 arch/powerpc/include/asm/hvcall.h                  |  8 +-
 arch/powerpc/include/asm/io.h                      | 24 +++---
 arch/x86/include/asm/cpu_device_id.h               | 98 ++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c                        |  4 +-
 arch/x86/kvm/x86.c                                 |  9 +-
 block/ioctl.c                                      |  2 +-
 drivers/acpi/acpica/exregion.c                     | 23 +----
 drivers/bluetooth/ath3k.c                          | 25 +++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  4 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  6 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |  1 +
 drivers/dma/idxd/irq.c                             |  4 +-
 drivers/dma/ioat/init.c                            | 65 +++++++-------
 drivers/dma/ioat/registers.h                       |  7 --
 drivers/firmware/psci/psci.c                       |  4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |  2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |  4 +
 drivers/gpu/drm/lima/lima_bcast.c                  | 12 +++
 drivers/gpu/drm/lima/lima_bcast.h                  |  3 +
 drivers/gpu/drm/lima/lima_gp.c                     |  8 ++
 drivers/gpu/drm/lima/lima_pp.c                     | 18 ++++
 drivers/gpu/drm/lima/lima_sched.c                  |  7 ++
 drivers/gpu/drm/lima/lima_sched.h                  |  1 +
 drivers/gpu/drm/radeon/sumo_dpm.c                  |  2 +
 drivers/hid/hid-asus.c                             | 49 +++++------
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-multitouch.c                       |  6 ++
 drivers/i2c/busses/i2c-ocores.c                    |  2 +-
 drivers/infiniband/hw/mlx5/srq.c                   | 13 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  2 +-
 drivers/net/dsa/realtek/rtl8366rb.c                | 87 +++++--------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  5 +-
 drivers/net/ethernet/intel/ice/ice.h               |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c           | 52 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c          | 36 +++-----
 drivers/net/ethernet/intel/ice/ice_switch.c        |  6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  5 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   | 44 +++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c      | 48 +++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h      | 28 +++++++
 drivers/net/ethernet/qualcomm/qca_debug.c          |  6 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            | 16 ++--
 drivers/net/ethernet/qualcomm/qca_spi.h            |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 40 +++++----
 drivers/net/phy/mxl-gpy.c                          | 97 ++++++++++++++-------
 drivers/net/usb/ax88179_178a.c                     | 18 ++--
 drivers/net/usb/rtl8150.c                          |  3 +-
 drivers/net/virtio_net.c                           | 12 ++-
 drivers/net/wireless/ath/ath.h                     |  6 +-
 drivers/net/wireless/ath/ath9k/main.c              |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  2 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  2 -
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |  2 -
 drivers/net/wireless/mediatek/mt76/sdio.c          |  3 +-
 drivers/pci/pci.c                                  | 12 +++
 drivers/platform/x86/p2sb.c                        | 29 +++----
 drivers/platform/x86/toshiba_acpi.c                | 36 +++++++-
 drivers/power/supply/cros_usbpd-charger.c          | 11 ++-
 drivers/ptp/ptp_sysfs.c                            |  3 +-
 drivers/regulator/bd71815-regulator.c              |  2 +-
 drivers/regulator/core.c                           |  1 +
 drivers/scsi/qedi/qedi_debugfs.c                   | 12 +--
 drivers/soc/ti/ti_sci_pm_domains.c                 | 20 ++++-
 drivers/spi/spi-stm32-qspi.c                       | 12 ++-
 drivers/tty/serial/8250/8250_exar.c                | 42 ++++++++++
 drivers/tty/serial/imx.c                           |  7 +-
 drivers/tty/tty_ldisc.c                            |  6 ++
 drivers/tty/vt/vt.c                                | 10 +++
 drivers/usb/dwc3/dwc3-pci.c                        |  8 +-
 drivers/usb/gadget/function/f_hid.c                |  6 +-
 drivers/usb/gadget/function/f_printer.c            |  6 +-
 drivers/usb/gadget/function/rndis.c                |  4 +-
 drivers/usb/misc/uss720.c                          | 22 +++--
 fs/btrfs/block-group.c                             | 11 ++-
 fs/f2fs/super.c                                    |  2 -
 fs/smb/client/cifsfs.c                             |  2 +-
 fs/udf/udftime.c                                   | 11 ++-
 include/linux/kcov.h                               |  2 +
 include/linux/mod_devicetable.h                    |  2 +
 include/linux/tty_driver.h                         |  8 ++
 include/net/sch_generic.h                          |  1 +
 io_uring/sqpoll.c                                  |  8 ++
 kernel/gcov/gcc_4_7.c                              |  4 +-
 kernel/gen_kheaders.sh                             |  9 +-
 kernel/kcov.c                                      |  1 +
 kernel/padata.c                                    |  8 +-
 kernel/rcu/rcutorture.c                            | 16 ++--
 kernel/trace/Kconfig                               |  4 +-
 kernel/trace/preemptirq_delay_test.c               |  1 +
 mm/page_table_check.c                              | 11 ++-
 net/batman-adv/originator.c                        |  2 +
 net/core/drop_monitor.c                            | 20 ++---
 net/core/filter.c                                  |  5 ++
 net/core/net_namespace.c                           |  9 +-
 net/core/netpoll.c                                 |  2 +-
 net/core/sock.c                                    |  3 +
 net/ipv4/cipso_ipv4.c                              | 12 ++-
 net/ipv4/tcp_input.c                               |  1 +
 net/ipv6/route.c                                   |  4 +-
 net/ipv6/seg6_local.c                              |  8 +-
 net/ipv6/xfrm6_policy.c                            |  8 +-
 net/netfilter/ipset/ip_set_core.c                  | 11 +--
 net/netrom/nr_timer.c                              |  3 +-
 net/packet/af_packet.c                             | 26 +++---
 net/sched/act_api.c                                | 66 ++++++++++-----
 net/sched/act_ct.c                                 | 16 ++--
 net/sched/sch_api.c                                |  1 +
 net/sched/sch_generic.c                            |  4 +
 net/sched/sch_htb.c                                | 22 +----
 net/tipc/node.c                                    |  1 +
 sound/hda/intel-dsp-config.c                       |  2 +-
 sound/pci/hda/patch_realtek.c                      | 10 ++-
 sound/soc/intel/boards/sof_sdw.c                   |  9 ++
 tools/perf/Documentation/perf-script.txt           |  7 +-
 tools/perf/builtin-script.c                        | 24 ++++--
 tools/testing/selftests/arm64/tags/tags_test.c     |  4 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      | 26 +-----
 tools/testing/selftests/bpf/test_tc_tunnel.sh      | 13 ++-
 virt/kvm/kvm_main.c                                |  5 +-
 135 files changed, 1112 insertions(+), 563 deletions(-)


