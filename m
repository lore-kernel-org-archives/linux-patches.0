Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC93364E92;
	Wed, 28 Jan 2026 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614121; cv=none; b=NwUn53wBwT68wZOgtD0nRKMK7tnu87ll5Hjiakl8yC5MViVYN9xHw8R/Dk9qjSdt+aov9JU7gT14/ntU4NKqWtLfI4BS+U6lpgbzUscDmK8nAS+VS7svnVn836kzXTqEmypbgiU9KhiY5HX2lIBdlpvO+pMDKY5UKOvkLzbuAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614121; c=relaxed/simple;
	bh=bhItCD0LsfeAbA5dfF3AszVE4nQFus/Egg3v3mvdLY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gf18/0LGt9xUUr5JKUuU0SbskDxv6c6xWA/jBvONPaf70okvN3mKbb9lotQMKr0e45R4ey86pWHu9c5m2NbK1oRm64KOKaQV9cSSioVN2cJiav2Bw7VIBfYo9fy6+h4c8OAVktFZiIeoWrA2LW9EIS4c5JTsqF7pcFZj+LicWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn1C8CQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn1C8CQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944D0C4CEF1;
	Wed, 28 Jan 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614120;
	bh=bhItCD0LsfeAbA5dfF3AszVE4nQFus/Egg3v3mvdLY8=;
	h=From:To:Cc:Subject:Date:From;
	b=kn1C8CQFrMllG5FdO3840qJmNyhN0+b6IQ433zQE8xFAIXT2grgRbnQNNUj58+WQt
	 KbTBLS7Vhw3bZThWcYaM/c//3QYnKfSD7CEnKkcTmG2sQQorNXAYzAMH5/GHR8O36M
	 LDwKXLeik5XO+wcTm9CpkJ+QmItSYfLQ7+eywM/c=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.6 000/254] 6.6.122-rc1 review
Date: Wed, 28 Jan 2026 16:19:36 +0100
Message-ID: <20260128145344.698118637@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.122-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.122-rc1
X-KernelTest-Deadline: 2026-01-30T14:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.122 release.
There are 254 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.122-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.122-rc1

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phy: fix phy_uses_state_machine()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()

Sean Christopherson <seanjc@google.com>
    x86/fpu: Clear XSTATE_BV[i] in guest XSAVE state whenever XFD[i]=1

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath11k: fix RCU stall while reaping monitor destination ring

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: csa unmap use uninterruptible lock

Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
    fs/ntfs3: Initialize allocated memory before use

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_session_rpc_open

Zqiang <qiang.zhang@linux.dev>
    usbnet: Fix using smp_processor_id() in preemptible code warnings

Maninder Singh <maninder1.s@samsung.com>
    NFSD: fix race between nfsd registration and exports_proc

Nilay Shroff <nilay@linux.ibm.com>
    nvme: fix PCIe subsystem reset controller state transition

Keith Busch <kbusch@kernel.org>
    nvme-pci: do not directly handle subsys reset fallout

Daniel Wagner <dwagner@suse.de>
    nvme-fc: rename free_ctrl callback to match name pattern

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa883x: fix unnecessary initialisation

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa881x: fix unnecessary initialisation

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Drop unused version readout

Wentao Liang <vulab@iscas.ac.cn>
    phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()

Dragan Simic <dsimic@manjaro.org>
    phy: phy-rockchip-inno-usb2: Use dev_err_probe() in the probe path

Ryan Roberts <ryan.roberts@arm.com>
    mm: kmsan: fix poisoning of high-order non-compound pages

Vlastimil Babka <vbabka@suse.cz>
    mm/page_alloc: prevent pcp corruption with SMP=n

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix OF node leak on route allocation failure

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    iio: adc: exynos_adc: fix OF populate on driver rebind

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    ALSA: scarlett2: Fix buffer overflow in config retrieval

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/rmap: fix two comments related to huge_pmd_unshare()

Rasmus Villemoes <ravi@prevas.dk>
    iio: core: add separate lockdep class for info_exist_lock

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: core: add missing mutex_destroy in iio_dev_release()

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure

Marc Kleine-Budde <mkl@pengutronix.de>
    can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak

Ido Schimmel <idosch@nvidia.com>
    bridge: mcast: Fix use-after-free during router port configuration

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not let BPF test infra emit invalid GSO types to stack

Ihor Solodrai <ihor.solodrai@pm.me>
    selftests/bpf: Check for timeout in perf_link test

Matthew Wilcox (Oracle) <willy@infradead.org>
    migrate: correct lock ordering for hugetlb file folios

Marc Kleine-Budde <mkl@pengutronix.de>
    can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: ems_usb_read_bulk_callback(): fix URB memory leak

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3-its: Avoid truncating memory addresses

Fernand Sieber <sieberf@amazon.com>
    perf/x86/intel: Do not enable BTS for guests

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Remove separate rst and clk mask for 8mq vpu

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix automatic module loading

Jeongjun Park <aha310510@gmail.com>
    netrom: fix double-free in nr_route_frame()

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: ensure safe queue release with state management

Yang Shen <shenyang39@huawei.com>
    uacce: implement mremap in uacce_vm_ops to return -EPERM

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: fix isolate sysfs check condition

Wenkai Lin <linwenkai6@hisilicon.com>
    uacce: fix cdev handling in the cleanup path

Johan Hovold <johan@kernel.org>
    intel_th: fix device leak on output open()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix crash on synthetic stacktrace field usage

Johan Hovold <johan@kernel.org>
    slimbus: core: fix device reference leak on report present

Johan Hovold <johan@kernel.org>
    slimbus: core: fix runtime PM imbalance on report present

Thomas Fourier <fourier.thomas@gmail.com>
    octeontx2: Fix otx2_dma_map_page() error return code

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    arm64: Set __nocfi on swsusp_arch_resume()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Allocate SSVE storage when restoring ZA

Marek Vasut <marex@nabladev.com>
    wifi: rsi: Fix memory corruption due to not set vif driver data size

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: ath12k: fix dma_free_coherent() pointer

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: ath10k: fix dma_free_coherent() pointer

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Prevent illegal clock reduction in HS200/HS400 mode

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix potential OOB access in audio mixer handling

Kübrich, Andreas <andreas.kuebrich@spektra-dresden.de>
    iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl

Fiona Klute <fiona.klute@gmx.de>
    iio: chemical: scd4x: fix reported channel endianness

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver

Tomas Melin <tomas.melin@vaisala.com>
    iio: adc: ad9467: fix ad9434 vref mask

Markus Koeniger <markus.koeniger@liebherr.com>
    iio: accel: iis328dq: fix gain values

Rob Herring (Arm) <robh@kernel.org>
    of: platform: Use default match table for /firmware

Weigang He <geoffreyhe2@gmail.com>
    of: fix reference count leak in of_alias_scan()

Hans de Goede <johannes.goede@oss.qualcomm.com>
    leds: led-class: Only Add LED to leds_list when it is fully ready

Cedric Xing <cedric.xing@intel.com>
    x86: make page fault handling disable interrupts properly

Eric Dumazet <edumazet@google.com>
    net/sched: act_ife: avoid possible NULL deref

Melbin K Mathew <mlbnkm1@gmail.com>
    vsock/virtio: cap TX credit to local buffer size

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: fix seqpacket message bounds test

Melbin K Mathew <mlbnkm1@gmail.com>
    vsock/virtio: fix potential underflow in virtio_transport_get_credit()

David Yang <mmyangfl@gmail.com>
    net: openvswitch: fix data race in ovs_vport_get_upcall_stats

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix error handling

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix off-by-one in maximum bridge ID determination

Eric Dumazet <edumazet@google.com>
    bonding: provide a net pointer to __skb_flow_dissect()

Taehee Yoo <ap420073@gmail.com>
    selftests: net: amt: wait longer for connection before sending packets

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Don't clear SI SMC table when setting power limit

Laurent Vivier <lvivier@redhat.com>
    usbnet: limit max_mtu based on device's hard_mtu

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-race in ndisc_router_discovery()

Eric Dumazet <edumazet@google.com>
    mISDN: annotate data-race around dev->work

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M

David Yang <mmyangfl@gmail.com>
    be2net: fix data race in be_get_new_eqd

David Yang <mmyangfl@gmail.com>
    net: hns3: fix data race in hns3_fetch_stats

Yun Lu <luyun@kylinos.cn>
    netdevsim: fix a race issue related to the operation on bpf_bound_progs list

Arun Raghavan <arunr@valvesoftware.com>
    ALSA: usb: Increase volume range that triggers a warning

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    scsi: qla2xxx: Sanitize payload size to prevent member overflow

David Jeffery <djeffery@redhat.com>
    scsi: core: Wake up the error handler when final completions race against each other

Naohiko Shimizu <naohiko.shimizu@gmail.com>
    riscv: clocksource: Fix stimecmp update hazard on RV32

Arkadiusz Kozdra <floss@arusekk.pl>
    kconfig: fix static linking of nconf

Cheng-Yu Lee <cylee12@realtek.com>
    regmap: Fix race condition in hwspinlock irqsave routine

Felix Gu <gu_0233@qq.com>
    spi: spi-sprd-adi: Fix double free in probe error path

Yang Yingliang <yangyingliang@huawei.com>
    spi: sprd-adi: switch to use spi_alloc_host()

Andrew Davis <afd@ti.com>
    spi: sprd: adi: Use devm_register_restart_handler()

Georgi Djakov <djakov@kernel.org>
    interconnect: debugfs: initialize src_node and dst_node to empty strings

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    iio: adc: ad7280a: handle spi_setup() errors in probe()

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix kernel panic in GET_INSTANCE_ID macro

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix kobject warnings for empty attribute names

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix getting range information for subdevices 16 to 255

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: avoid writing L1TF-vulnerable PTEs

Ondrej Jirman <megi@xff.cz>
    arm64: dts: rockchip: Fix voltage threshold for volume keys for Pinephone Pro

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove dangerous max-link-speed from helios64

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()

Long Li <longli@microsoft.com>
    scsi: storvsc: Process unsupported MODE_SENSE_10

feng <alec.jiang@gmail.com>
    Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA

gongqi <550230171hxy@gmail.com>
    Input: i8042 - add quirks for MECHREVO Wujie 15X Pro

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "nfc/nci: Add the inconsistency check between the input data length and count"

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    w1: fix redundant counter decrement in w1_attach_slave_device()

Thorsten Blum <thorsten.blum@linux.dev>
    w1: therm: Fix off-by-one buffer overflow in alarms_store

Ian Abbott <abbotti@mev.co.uk>
    comedi: dmm32at: serialize use of paged registers

Marnix Rijnart <marnix.rijnart@iwell.eu>
    serial: 8250_pci: Fix broken RS485 for F81504/508/512

Taeyang Lee <0wn@theori.io>
    crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Enforce that teql can only be used as root qdisc

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2: cn10k: fix RX flowid TCAM mask handling

Dmitry Skorodumov <dskr99@gmail.com>
    ipvlan: Make the addrs_lock be per port

Eric Dumazet <edumazet@google.com>
    l2tp: avoid one data-race in l2tp_tunnel_del_work()

David Yang <mmyangfl@gmail.com>
    veth: fix data race in veth_get_ethtool_stats

Kuniyuki Iwashima <kuniyu@google.com>
    fou: Don't allow 0 for FOU_ATTR_IPPROTO.

Kuniyuki Iwashima <kuniyu@google.com>
    tools: ynl: Specify --no-line-number in ynl-regen.sh.

Kuniyuki Iwashima <kuniyu@google.com>
    gue: Fix skb memleak with inner IP protocol 0.

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: avoid misleading per-packet error log

Xin Long <lucien.xin@gmail.com>
    sctp: move SCTP_CMD_ASSOC_SHKEY right after SCTP_CMD_PEER_INIT

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error

Ricardo B. Marlière <rbm@suse.com>
    selftests: net: fib-onlink-tests: Convert to use namespaces by default

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net: convert fib-onlink-tests.sh to run it in unique namespace

Eric Dumazet <edumazet@google.com>
    bonding: limit BOND_MODE_8023AD to Ethernet devices

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: dm9601: remove broken SR9700 support

Chwee-Lin Choong <chwee.lin.choong@intel.com>
    igc: fix race condition in TX timestamp read for register 0

Dave Ertman <david.m.ertman@intel.com>
    ice: Avoid detrimental cleanup for bond during interface stop

Jacob Keller <jacob.e.keller@intel.com>
    ice: initialize ring_stats->syncp

Niklas Cassel <cassel@kernel.org>
    ata: libata: Print features also for ATAPI devices

Niklas Cassel <cassel@kernel.org>
    ata: libata: Call ata_dev_config_lpm() for ATAPI devices

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: Introduce ata_dev_config_lpm()

Niklas Cassel <cassel@kernel.org>
    ata: libata: Add cpr_log to ata_dev_print_features() early return

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pmdomain: qcom: rpmhpd: Add MXC to SC8280XP

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    dt-bindings: power: qcom-rpmpd: split RPMh domains definitions

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    dt-bindings: power: qcom,rpmpd: add Turbo L5 corner

Taniya Das <quic_tdas@quicinc.com>
    dt-bindings: power: qcom,rpmpd: document the SM8750 RPMh Power Domains

Sibi Sankar <quic_sibis@quicinc.com>
    dt-bindings: power: rpmpd: Update part number to X1E80100

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: power: qcom,rpmpd: document the SM8650 RPMh Power Domains

Otto Pflüger <otto.pflueger@abscue.de>
    dt-bindings: power: rpmpd: Add MSM8917, MSM8937 and QM215

Danila Tikhonov <danila@jiaxyga.com>
    dt-bindings: power: qcom,rpmpd: Add SM7150

Mark Harmstone <mark@harmstone.com>
    btrfs: fix missing fields in superblock backup with BLOCK_GROUP_TREE

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: Always do Hyper-V panic notification in hv_kmsg_dump()

Nuno Das Neves <nunodasneves@linux.microsoft.com>
    hyperv-tlfs: Change prefix of generic HV_REGISTER_* MSRs to HV_MSR_*

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links

Wojtek Wasko <wwasko@nvidia.com>
    testptp: Add option to open PHC in readonly mode

Mahesh Bandewar <maheshb@google.com>
    selftest/ptp: update ptp selftest to exercise the gettimex options

Xabier Marquiegui <reibax@gmail.com>
    ptp: add testptp mask test

Wojtek Wasko <wwasko@nvidia.com>
    ptp: Add PHC file mode checks. Allow RO adjtime() without FMODE_WRITE.

Wojtek Wasko <wwasko@nvidia.com>
    posix-clock: Store file pointer in struct posix_clock_context

Linus Torvalds <torvalds@linux-foundation.org>
    Fix memory leak in posix_clock_open()

Xabier Marquiegui <reibax@gmail.com>
    posix-clock: introduce posix_clock_context concept

Ming Lei <ming.lei@redhat.com>
    io_uring: move local task_work in exit cancel loop

Robbie Ko <robbieko@synology.com>
    btrfs: fix deadlock in wait_current_trans() due to ignored transaction type

Johan Hovold <johan@kernel.org>
    dmaengine: ti: k3-udma: fix device leak on udma lookup

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on am335x route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation

Biju Das <biju.das.jz@bp.renesas.com>
    dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: qcom: gpi: Fix memory leak in gpi_peripheral_config()

Johan Hovold <johan@kernel.org>
    dmaengine: lpc18xx-dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: idxd: fix device leaks on compat bind and unbind

Johan Hovold <johan@kernel.org>
    dmaengine: dw: dmamux: fix OF node leak on route allocation failure

Johan Hovold <johan@kernel.org>
    dmaengine: bcm-sba-raid: fix device leak on probe

Johan Hovold <johan@kernel.org>
    dmaengine: at_hdmac: fix device leak on of_dma_xlate()

Janne Grunau <j@jannau.net>
    dmaengine: apple-admac: Add "apple,t8103-admac" compatible

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()

Marek Vasut <marex@nabladev.com>
    drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/nv50-: Set lock_core in curs507a_prepare

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/amdkfd: fix a memory leak in device_queue_manager_init()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Clean up kfd node on surprise disconnect

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Bump the HDMI clock to 340MHz

Lisa Robinson <lisa@bytefly.space>
    LoongArch: Fix PMU counter allocation for mixed-type event groups

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure

Aboorva Devarajan <aboorvad@linux.ibm.com>
    mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Fix memory bandwidth counter width for Hygon

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Add missing resctrl initialization for Hygon

Arnaud Ferraris <arnaud.ferraris@collabora.com>
    tcpm: allow looking for role_sw device in the main node

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/i3200: Fix a resource leak in i3200_probe1()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/x38: Fix a resource leak in x38_probe1()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    hrtimer: Fix softirq base check in update_needs_ipi()

Yang Erkun <yangerkun@huawei.com>
    ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref

Ilikara Zheng <ilikara@aosc.io>
    nvme-pci: disable secondary temp for Wodposit WPBSNM8

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    USB: serial: ftdi_sio: add support for PICAXE AXE027 cable

Ulrich Mohr <u.mohr@semex-engcon.com>
    USB: serial: option: add Telit LE910 MBIM composition

Huacai Chen <chenhuacai@kernel.org>
    USB: OHCI/UHCI: Add soft dependencies on ehci_platform

Johannes Brüderl <johannes.bruederl@gmail.com>
    usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Check for USB4 IP_NAME

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7

Louis Chauvet <louis.chauvet@bootlin.com>
    phy: rockchip: inno-usb2: fix disconnection in gadget mode

Rafael Beims <rafael.beims@toradex.com>
    phy: freescale: imx8m-pcie: assert phy reset during power on

Luca Ceresoli <luca.ceresoli@bootlin.com>
    phy: rockchip: inno-usb2: fix communication disruption in gadget mode

Dan Williams <dan.j.williams@intel.com>
    x86/kaslr: Recognize all ZONE_DEVICE users as physaddr consumers

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: can: j1939: j1939_xtp_rx_rts_session_active(): deactivate session upon receiving the second rts

Ondrej Ille <ondrej.ille@gmail.com>
    can: ctucanfd: fix SSP_SRC in cases when bit-rate is higher than 1 MBit.

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak

Nilay Shroff <nilay@linux.ibm.com>
    null_blk: fix kmemleak by releasing references to fault configfs items

Jaroslav Kysela <perex@perex.cz>
    ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer

Brian Kao <powenkao@google.com>
    scsi: core: Fix error handler encryption support

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check dce_hwseq before dereferencing it

Benjamin Tissoires <bentiss@kernel.org>
    HID: usbhid: paper over wrong bNumDescriptor field

Neil Armstrong <neil.armstrong@linaro.org>
    i2c: qcom-geni: make sure I2C hub controllers can't use SE DMA

Haotian Zhang <vulab@iscas.ac.cn>
    dmaengine: omap-dma: fix dma_pool resource leak in error paths

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)

Dan Carpenter <dan.carpenter@linaro.org>
    phy: stm32-usphyc: Fix off by one in probe()

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom-qusb2: Fix NULL pointer dereference on early suspend

Johan Hovold <johan+linaro@kernel.org>
    phy: drop probe registration printks

Ivaylo Ivanov <ivo.ivanov.ivanov1@gmail.com>
    phy: phy-snps-eusb2: refactor constructs names

Stefano Radaelli <stefano.radaelli21@gmail.com>
    phy: fsl-imx8mq-usb: Clear the PCS_TX_SWING_FULL field before using it

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix uninitialized addr_width when "xlnx,addrwidth" property is missing

Sheetal <sheetal@nvidia.com>
    dmaengine: tegra-adma: Fix use-after-free

Anthony Brandon <anthony@amarulasolutions.com>
    dmaengine: xilinx: xdma: Fix regmap max_register

Bagas Sanjaya <bagasdotme@gmail.com>
    mm, kfence: describe @slab parameter in __kfence_obj_info()

Bagas Sanjaya <bagasdotme@gmail.com>
    textsearch: describe @list member in ts_ops search

Emil Svendsen <emas@bang-olufsen.dk>
    ASoC: tlv320adcx140: fix word length

Emil Svendsen <emas@bang-olufsen.dk>
    ASoC: tlv320adcx140: fix null pointer

Eric Dumazet <edumazet@google.com>
    net/sched: sch_qfq: do not free existing class in qfq_change_class()

Gal Pressman <gal@nvidia.com>
    selftests: drv-net: fix RPS mask handling for high CPU numbers

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Fix use-after-free in inet6_addr_del().

Aditya Garg <gargaditya@linux.microsoft.com>
    net: hv_netvsc: reject RSS hash key programming without RX indirection table

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    btrfs: fix memory leaks in create_space_info() error paths

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: introduce btrfs_space_info sub-group

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: factor out check_removing_space_info() from btrfs_free_block_groups()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: factor out init_space_info() from create_space_info()

Boris Burkov <boris@bur.io>
    btrfs: store fs_info in space_info

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Restore destroying state bit after profile cleanup

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: add a final full barrier after run all tests

Eric Dumazet <edumazet@google.com>
    ipv4: ip_gre: make ipgre_header() robust

Eric Dumazet <edumazet@google.com>
    macvlan: fix possible UAF in macvlan_forward_source()

Eric Dumazet <edumazet@google.com>
    net: update netdev_lock_{type,name}

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()

Eric Dumazet <edumazet@google.com>
    net: bridge: annotate data-races around fdb->{updated,used}

Johannes Nixdorf <jnixdorf-oss@avm.de>
    net: bridge: Set BR_FDB_ADDED_BY_USER early in fdb_add_entry

Qu Wenruo <wqu@suse.com>
    btrfs: send: check for inline extents in range_is_hole_in_parent()

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: remove boilerplate code

Szymon Wilczek <swilczek.lx@gmail.com>
    can: etas_es58x: allow partial RX URB allocation to succeed

Zilin Guan <zilin@seu.edu.cn>
    pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Fix inner mode lookup in tunnel mode GSO segmentation

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa884x: fix codec initialisation

Andreas Gruenbacher <agruenba@redhat.com>
    Revert "gfs2: Fix use of bio_chain"

Morduan Zang <zhangdandan@uniontech.com>
    efi/cper: Fix cper_bits_to_str buffer handling and return value

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Set mu_resource_id before get handle


-------------

Diffstat:

 .../devicetree/bindings/power/qcom,rpmpd.yaml      |  83 ++++---
 Documentation/netlink/specs/fou.yaml               |   2 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  16 +-
 .../boot/dts/rockchip/rk3399-kobol-helios64.dts    |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |   1 -
 .../boot/dts/rockchip/rk3399-pinephone-pro.dts     |   4 +-
 arch/arm64/include/asm/hyperv-tlfs.h               |  45 ++--
 arch/arm64/include/asm/mshyperv.h                  |   4 +-
 arch/arm64/kernel/hibernate.c                      |   2 +-
 arch/arm64/kernel/signal.c                         |   4 +
 arch/loongarch/kernel/perf_event.c                 |  21 +-
 arch/x86/events/perf_event.h                       |  13 +-
 arch/x86/hyperv/hv_init.c                          |   8 +-
 arch/x86/include/asm/hyperv-tlfs.h                 | 145 ++++++------
 arch/x86/include/asm/kfence.h                      |  29 ++-
 arch/x86/include/asm/mshyperv.h                    |  30 +--
 arch/x86/kernel/cpu/mshyperv.c                     |  56 ++---
 arch/x86/kernel/cpu/resctrl/core.c                 |  21 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   3 +
 arch/x86/kernel/fpu/core.c                         |  32 ++-
 arch/x86/kvm/x86.c                                 |   9 +
 arch/x86/mm/fault.c                                |  15 +-
 arch/x86/mm/kaslr.c                                |  10 +-
 crypto/authencesn.c                                |   6 +
 drivers/ata/libata-core.c                          |  32 ++-
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/null_blk/main.c                      |  12 +-
 drivers/clocksource/hyperv_timer.c                 |  26 +--
 drivers/clocksource/timer-riscv.c                  |   3 +-
 drivers/comedi/comedi_fops.c                       |   2 +-
 drivers/comedi/drivers/dmm32at.c                   |  32 ++-
 drivers/comedi/range.c                             |   2 +-
 drivers/dma/apple-admac.c                          |   1 +
 drivers/dma/at_hdmac.c                             |   9 +-
 drivers/dma/bcm-sba-raid.c                         |   6 +-
 drivers/dma/dw/rzn1-dmamux.c                       |   4 +-
 drivers/dma/idxd/compat.c                          |  23 +-
 drivers/dma/lpc18xx-dmamux.c                       |  19 +-
 drivers/dma/qcom/gpi.c                             |   6 +-
 drivers/dma/sh/rz-dmac.c                           |   5 +
 drivers/dma/stm32-dmamux.c                         |  22 +-
 drivers/dma/tegra210-adma.c                        |  10 +-
 drivers/dma/ti/dma-crossbar.c                      |  18 +-
 drivers/dma/ti/k3-udma-private.c                   |   2 +-
 drivers/dma/ti/omap-dma.c                          |   4 +
 drivers/dma/xilinx/xdma-regs.h                     |   1 +
 drivers/dma/xilinx/xdma.c                          |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   7 +-
 drivers/edac/i3200_edac.c                          |  11 +-
 drivers/edac/x38_edac.c                            |   9 +-
 drivers/firmware/efi/cper.c                        |   2 +-
 drivers/firmware/imx/imx-scu-irq.c                 |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  19 +-
 drivers/gpu/drm/amd/display/dc/dc_hdmi_types.h     |   2 +-
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   2 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  23 +-
 drivers/gpu/drm/nouveau/dispnv50/curs507a.c        |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  17 +-
 drivers/hv/hv.c                                    |  36 ++-
 drivers/hv/hv_common.c                             |  32 +--
 drivers/hwtracing/intel_th/core.c                  |  19 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  11 +-
 drivers/iio/accel/st_accel_core.c                  |  72 +++++-
 drivers/iio/adc/ad7280a.c                          |   4 +-
 drivers/iio/adc/ad9467.c                           |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   1 +
 drivers/iio/adc/exynos_adc.c                       |  13 +-
 drivers/iio/chemical/scd4x.c                       |   6 +-
 drivers/iio/dac/ad5686.c                           |   6 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  15 +-
 drivers/iio/industrialio-core.c                    |  12 +-
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++
 drivers/interconnect/debugfs-client.c              |   5 +
 drivers/irqchip/irq-gic-v3-its.c                   |   8 +-
 drivers/isdn/mISDN/timerdev.c                      |  13 +-
 drivers/leds/led-class.c                           |  10 +-
 drivers/misc/uacce/uacce.c                         |  48 +++-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  41 ++++
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   7 +
 drivers/net/bonding/bond_main.c                    |  11 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   2 +-
 drivers/net/can/usb/ems_usb.c                      |   8 +-
 drivers/net/can/usb/esd_usb.c                      |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   2 +-
 drivers/net/can/usb/gs_usb.c                       |   9 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   9 +-
 drivers/net/can/usb/mcba_usb.c                     |   8 +-
 drivers/net/can/usb/usb_8dev.c                     |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   5 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  69 +++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  29 ++-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  43 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  86 +++++--
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/hyperv/netvsc_drv.c                    |   3 +
 drivers/net/ipvlan/ipvlan.h                        |   2 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  16 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  49 ++--
 drivers/net/macvlan.c                              |  20 +-
 drivers/net/netdevsim/bpf.c                        |   6 +
 drivers/net/netdevsim/dev.c                        |   2 +
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/phy/phy_device.c                       |  58 +++--
 drivers/net/usb/dm9601.c                           |   4 -
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/veth.c                                 |   8 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  16 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   4 +-
 drivers/net/wireless/ath/ath12k/ce.c               |  12 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/nfc/virtual_ncidev.c                       |   4 -
 drivers/nvme/host/fabrics.c                        |  15 ++
 drivers/nvme/host/fabrics.h                        |   1 +
 drivers/nvme/host/fc.c                             |   5 +-
 drivers/nvme/host/nvme.h                           |  14 +-
 drivers/nvme/host/pci.c                            |  41 ++++
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/nvme/target/tcp.c                          |  28 ++-
 drivers/of/base.c                                  |   8 +-
 drivers/of/platform.c                              |   2 +-
 drivers/pci/Kconfig                                |   6 -
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   2 +-
 drivers/phy/broadcom/phy-bcm-ns2-pcie.c            |   2 -
 drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c          |   1 -
 drivers/phy/broadcom/phy-bcm-sr-pcie.c             |   2 -
 drivers/phy/broadcom/phy-brcm-sata.c               |   2 +-
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |   3 +-
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |   1 +
 drivers/phy/marvell/phy-pxa-usb.c                  |   1 -
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |   2 -
 drivers/phy/qualcomm/phy-qcom-m31.c                |   2 -
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |  18 +-
 drivers/phy/qualcomm/phy-qcom-snps-eusb2.c         | 256 ++++++++++-----------
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  41 ++--
 drivers/phy/st/phy-stih407-usb.c                   |   2 -
 drivers/phy/st/phy-stm32-usbphyc.c                 |   6 +-
 drivers/phy/tegra/xusb-tegra186.c                  |   3 +
 drivers/phy/ti/phy-twl4030-usb.c                   |   1 -
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |   8 +
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h       |  12 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  11 +-
 drivers/pmdomain/qcom/rpmhpd.c                     |   4 +
 drivers/ptp/ptp_chardev.c                          |  37 ++-
 drivers/ptp/ptp_private.h                          |  16 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   7 +
 drivers/scsi/scsi_error.c                          |  35 ++-
 drivers/scsi/scsi_lib.c                            |   8 +
 drivers/scsi/storvsc_drv.c                         |   3 +-
 drivers/slimbus/core.c                             |  19 +-
 drivers/spi/spi-sprd-adi.c                         |  63 ++---
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/usb/core/config.c                          |   5 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/host/ohci-platform.c                   |   1 +
 drivers/usb/host/uhci-platform.c                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   2 +
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/w1/slaves/w1_therm.c                       |  60 ++---
 drivers/w1/w1.c                                    |   2 -
 drivers/xen/xen-scsiback.c                         |   1 +
 fs/btrfs/block-group.c                             |  60 +++--
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/send.c                                    |   2 +
 fs/btrfs/space-info.c                              |  76 ++++--
 fs/btrfs/space-info.h                              |  10 +
 fs/btrfs/sysfs.c                                   |  18 +-
 fs/btrfs/transaction.c                             |  11 +-
 fs/ext4/xattr.c                                    |   1 +
 fs/gfs2/lops.c                                     |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfsd/nfsctl.c                                   |  17 +-
 fs/ntfs3/inode.c                                   |   7 +-
 fs/smb/server/mgmt/user_session.c                  |  20 +-
 fs/smb/server/mgmt/user_session.h                  |   1 +
 include/asm-generic/hyperv-tlfs.h                  |  32 ++-
 include/asm-generic/mshyperv.h                     |   2 +-
 include/dt-bindings/power/qcom,rpmhpd.h            | 235 +++++++++++++++++++
 include/dt-bindings/power/qcom-rpmpd.h             | 246 ++------------------
 include/linux/iio/iio-opaque.h                     |   2 +
 include/linux/kfence.h                             |   1 +
 include/linux/nvme.h                               |   3 +
 include/linux/posix-clock.h                        |  39 +++-
 include/linux/textsearch.h                         |   1 +
 include/linux/usb/quirks.h                         |   3 +
 include/scsi/scsi_eh.h                             |   6 +
 include/sound/pcm.h                                |   2 +-
 include/uapi/linux/comedi.h                        |   2 +-
 io_uring/io-wq.c                                   |   2 +-
 io_uring/io_uring.c                                |   8 +-
 kernel/time/hrtimer.c                              |   2 +-
 kernel/time/posix-clock.c                          |  53 +++--
 kernel/trace/trace_events_hist.c                   |   9 +
 kernel/trace/trace_events_synth.c                  |   8 +-
 mm/Kconfig                                         |  10 +-
 mm/damon/sysfs-schemes.c                           |  11 +-
 mm/damon/sysfs.c                                   |   5 +-
 mm/kmsan/shadow.c                                  |   2 +-
 mm/migrate.c                                       |  12 +-
 mm/page_alloc.c                                    |  47 +++-
 mm/rmap.c                                          |  20 +-
 net/bpf/test_run.c                                 |   5 +
 net/bridge/br_fdb.c                                |  35 +--
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_multicast.c                          |   9 +
 net/can/j1939/transport.c                          |  10 +-
 net/core/dev.c                                     |  25 +-
 net/core/filter.c                                  |   7 +
 net/dsa/dsa.c                                      |   2 +-
 net/ipv4/esp4_offload.c                            |   4 +-
 net/ipv4/fou_core.c                                |   3 +
 net/ipv4/fou_nl.c                                  |   2 +-
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/esp6_offload.c                            |   4 +-
 net/ipv6/ip6_tunnel.c                              |   2 +-
 net/ipv6/ndisc.c                                   |   4 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/netrom/nr_route.c                              |  13 +-
 net/openvswitch/vport.c                            |  11 +-
 net/sched/act_ife.c                                |   6 +-
 net/sched/sch_qfq.c                                |   8 +-
 net/sched/sch_teql.c                               |   5 +
 net/sctp/sm_statefuns.c                            |  10 +-
 net/vmw_vsock/virtio_transport_common.c            |  30 ++-
 scripts/kconfig/nconf-cfg.sh                       |  11 +-
 sound/core/oss/pcm_oss.c                           |   4 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/pci/ctxfi/ctamixer.c                         |   2 +
 sound/soc/codecs/tlv320adcx140.c                   |   8 +-
 sound/soc/codecs/wsa881x.c                         |  11 +-
 sound/soc/codecs/wsa883x.c                         |   9 +
 sound/soc/codecs/wsa884x.c                         |   3 +-
 sound/usb/mixer.c                                  |  22 +-
 sound/usb/mixer_scarlett2.c                        |   7 +-
 tools/net/ynl/ynl-regen.sh                         |   2 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |  15 +-
 tools/testing/selftests/net/amt.sh                 |   7 +-
 tools/testing/selftests/net/fib-onlink-tests.sh    |  76 +++---
 tools/testing/selftests/net/toeplitz.c             |   4 +-
 tools/testing/selftests/ptp/testptp.c              | 114 +++++++--
 tools/testing/vsock/util.c                         |  12 +
 tools/testing/vsock/vsock_test.c                   |  11 +
 260 files changed, 2726 insertions(+), 1457 deletions(-)


