Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE8018871F;
	Wed,  4 Feb 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217450; cv=none; b=O7oxXZhDM2VMQB8xLiouK0FYpmdTDB37PCvDhY6EYGpWv3Ky1vRnxq2wJEA3qCIyk4yAjPmVKVrBwUHtlt1l+eOCbPenSrehgrWam60Wt+OQCq6SjF9n0Zl00h5MnHEFmGElwRdAQPVj+EQskpDH/ilIVl3N3heJI3+CRyiYpzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217450; c=relaxed/simple;
	bh=TTL11dHhJhgY2vlH2NQxyYzadmXE6uZ7ValIXoOADfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WYadOfKKVDi3Q5/mO/xHFMkVpkquKC4vY+9Gtid++yEJosiYYQf6ki4sEP7TMgUN8IJeZK43TVBgoDK+S7s90GyIEG1r+tr0m0jRqg+FvQI1lgryBXIJPgYXH9+Pw91TKqxFS6rEmsg6FkDmYXe/vhEtgD6384/Xjo43nAAOUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1h7Rkn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1h7Rkn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6881C4CEF7;
	Wed,  4 Feb 2026 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217450;
	bh=TTL11dHhJhgY2vlH2NQxyYzadmXE6uZ7ValIXoOADfY=;
	h=From:To:Cc:Subject:Date:From;
	b=n1h7Rkn9NOQhE397HA4NLuJKPGlpb4jbpeNjAMEJBY8I3DZaO1Q67MCsB8lXocekK
	 TXOBjOyRD3eO6DNskefoBYLJJ6yKpGpO2yhNw76Xx6VaU+Sbm3tLHjqgVhGyA+5bTK
	 zN1pQDMLCw+8W2FnEmZsedp2zSQljNVX4wO42z04=
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
Subject: [PATCH 6.1 000/280] 6.1.162-rc1 review
Date: Wed,  4 Feb 2026 15:36:14 +0100
Message-ID: <20260204143909.614719725@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.162-rc1
X-KernelTest-Deadline: 2026-02-06T14:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.162 release.
There are 280 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.162-rc1

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix recursive locking in RPC handle list access

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver

Johan Hovold <johan@kernel.org>
    drm/imx/tve: fix probe device leak

Laveesh Bansal <laveeshb@laveeshbansal.com>
    writeback: fix 100% CPU usage when dirtytime_expire_interval is 0

Pimyn Girgis <pimyn@google.com>
    mm/kfence: randomize the freelist on initialization

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid dup SUB_CLOSED events after disconnect

Chen Ni <nichen@iscas.ac.cn>
    net/sched: act_ife: convert comma to semicolon

JP Kobryn <inwardvessel@gmail.com>
    btrfs: prevent use-after-free on page private data in btrfs_subpage_clear_uptodate()

Robert McClinton <rbmccav@gmail.com>
    drm/radeon: delete radeon_fence_process in is_signaled, no deadlock

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint

Yunseong Kim <ysk@kzalloc.com>
    ksmbd: Fix race condition in RPC handle list access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_session_rpc_open

Xin Long <lucien.xin@gmail.com>
    sctp: linearize cloned gso packets in sctp_rcv

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring EST

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Replace Mutex with Spinlock for RLCG register access to avoid Priority Inversion in SRIOV

Zqiang <qiang.zhang@linux.dev>
    usbnet: Fix using smp_processor_id() in preemptible code warnings

Maninder Singh <maninder1.s@samsung.com>
    NFSD: fix race between nfsd registration and exports_proc

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix NULL pointer dereference in gfs2_log_flush

Gavin Li <gavinl@nvidia.com>
    Revert "net/mlx5: Block entering switchdev mode with ns inconsistency"

Waiman Long <longman@redhat.com>
    blk-cgroup: Reinit blkg_iostat_set after clearing in blkcg_reset_stats()

Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
    fs/ntfs3: Initialize allocated memory before use

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    iomap: Fix possible overflow condition in iomap_write_delalloc_scan

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - flush misc workqueue during device shutdown

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check dce_hwseq before dereferencing it

Harry Yoo <harry.yoo@oracle.com>
    Revert "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()"

Marc Kleine-Budde <mkl@pengutronix.de>
    can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/amdkfd: fix a memory leak in device_queue_manager_init()

Gyeyoung Baek <gye976@gmail.com>
    genirq/irq_sim: Initialize work context pointers properly

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: move TDLS work to wiphy work

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: use wiphy work for sdata->work

Nikola Z. Ivanov <zlatistiv@gmail.com>
    team: Move team device type change at the end of team_port_add

Sean Christopherson <seanjc@google.com>
    x86/fpu: Clear XSTATE_BV[i] in guest XSAVE state whenever XFD[i]=1

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa883x: fix unnecessary initialisation

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa881x: fix unnecessary initialisation

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Drop unused version readout

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Use proper shutdown GPIO polarity

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Simplify &pdev->dev in probe

Wentao Liang <vulab@iscas.ac.cn>
    phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()

Dragan Simic <dsimic@manjaro.org>
    phy: phy-rockchip-inno-usb2: Use dev_err_probe() in the probe path

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: phy-rockchip-inno-usb2: simplify phy clock handling

Nilay Shroff <nilay@linux.ibm.com>
    nvme: fix PCIe subsystem reset controller state transition

Keith Busch <kbusch@kernel.org>
    nvme-pci: do not directly handle subsys reset fallout

Daniel Wagner <dwagner@suse.de>
    nvme-fc: rename free_ctrl callback to match name pattern

Fiona Klute <fiona.klute@gmx.de>
    iio: chemical: scd4x: fix reported channel endianness

Johan Hovold <johan@kernel.org>
    iio: adc: exynos_adc: fix OF populate on driver rebind

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    ALSA: scarlett2: Fix buffer overflow in config retrieval

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Prevent illegal clock reduction in HS200/HS400 mode

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Update DLL and pre-change delay for rockchip platform

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Fix restoration of SVE context

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: trace: treat reg parameter as string

Thomas Fourier <fourier.thomas@gmail.com>
    ksmbd: smbd: fix dma_unmap_sg() nents

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Remove separate rst and clk mask for 8mq vpu

Brian Foster <bfoster@redhat.com>
    xfs: set max_agbno to allow sparse alloc of last full inode chunk

Ryan Roberts <ryan.roberts@arm.com>
    mm: kmsan: fix poisoning of high-order non-compound pages

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix device leak on route allocation

Vlastimil Babka <vbabka@suse.cz>
    mm/page_alloc: prevent pcp corruption with SMP=n

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix OF node leak on route allocation failure

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()

Dawei Li <set_pte_at@outlook.com>
    xen: make remove callback of xen driver void returned

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/rmap: fix two comments related to huge_pmd_unshare()

Robin Murphy <robin.murphy@arm.com>
    gpio: rockchip: Stop calling pinctrl for set_direction

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc21: fix xclk for APUs

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer: Add compiler_builtins -> core dep

Jan Kara <jack@suse.cz>
    flex_proportions: make fprop_new_period() hardirq safe

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only reset subflow errors when propagated

Kohei Enju <kohei@enjuk.jp>
    efivarfs: fix error propagation in efivar_entry_get()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla2xxx: edif: Fix dma_free_coherent() size

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()

Fabio Estevam <festevam@gmail.com>
    ASoC: fsl: imx-card: Do not force slot width to sample width

Han Gao <gaohan@iscas.ac.cn>
    riscv: compat: fix COMPAT_UTS_MACHINE definition

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: meson: mark the GPIO controller as sleeping

Sai Sree Kartheek Adivi <s-adivi@ti.com>
    dma/pool: distinguish between missing and exhausted atomic pools

Denis Sergeev <denserg.edu@gmail.com>
    gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler

Tagir Garaev <tgaraev653@gmail.com>
    ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion

Kery Qi <qikeyu2017@gmail.com>
    scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()

Martin Kaiser <martin@kaiser.cx>
    net: bridge: fix static key check

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: nci: Fix race between rfkill and nci_unregister_device().

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Account for netdev stats in ndo_get_stats64

Yafang Shao <laoar.shao@gmail.com>
    net/mlx5e: Report rx_discards_phy via rx_dropped

Jesse Brandeburg <jbrandeburg@cloudflare.com>
    ice: stop counting UDP csum mismatch as rx_errors

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: llcp: Fix memleak in nfc_llcp_send_ui_frame().

Kery Qi <qikeyu2017@gmail.com>
    rocker: fix memory leak in rocker_world_port_post_fini()

Kery Qi <qikeyu2017@gmail.com>
    net: wwan: t7xx: fix potential skb->frags overflow in RX path

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: use the right ifindex when replying to icmpv6 from localhost

Zilin Guan <zilin@seu.edu.cn>
    net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()

Eric Dumazet <edumazet@google.com>
    bonding: annotate data-races around slave->last_rx

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): fix error message

Zilin Guan <zilin@seu.edu.cn>
    net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()

Jia-Hong Su <s11242586@gmail.com>
    Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject narrower access to pointer ctx fields

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not let BPF test infra emit invalid GSO types to stack

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

Jeongjun Park <aha310510@gmail.com>
    netrom: fix double-free in nr_route_frame()

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: ensure safe queue release with state management

Yang Shen <shenyang39@huawei.com>
    uacce: implement mremap in uacce_vm_ops to return -EPERM

Wenkai Lin <linwenkai6@hisilicon.com>
    uacce: fix cdev handling in the cleanup path

Johan Hovold <johan@kernel.org>
    intel_th: fix device leak on output open()

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
    wifi: ath10k: fix dma_free_coherent() pointer

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix potential OOB access in audio mixer handling

Kübrich, Andreas <andreas.kuebrich@spektra-dresden.de>
    iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver

Tomas Melin <tomas.melin@vaisala.com>
    iio: adc: ad9467: fix ad9434 vref mask

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

Melbin K Mathew <mlbnkm1@gmail.com>
    vsock/virtio: fix potential underflow in virtio_transport_get_credit()

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix error handling

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

Yun Lu <luyun@kylinos.cn>
    netdevsim: fix a race issue related to the operation on bpf_bound_progs list

Arun Raghavan <arunr@valvesoftware.com>
    ALSA: usb: Increase volume range that triggers a warning

David Jeffery <djeffery@redhat.com>
    scsi: core: Wake up the error handler when final completions race against each other

Naohiko Shimizu <naohiko.shimizu@gmail.com>
    riscv: clocksource: Fix stimecmp update hazard on RV32

Arkadiusz Kozdra <floss@arusekk.pl>
    kconfig: fix static linking of nconf

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: refactor Makefile to reduce process forks

Cheng-Yu Lee <cylee12@realtek.com>
    regmap: Fix race condition in hwspinlock irqsave routine

Felix Gu <gu_0233@qq.com>
    spi: spi-sprd-adi: Fix double free in probe error path

Yang Yingliang <yangyingliang@huawei.com>
    spi: sprd-adi: switch to use spi_alloc_host()

Andrew Davis <afd@ti.com>
    spi: sprd: adi: Use devm_register_restart_handler()

Yang Li <yang.lee@linux.alibaba.com>
    spi: sprd-adi: Use devm_platform_get_and_ioremap_resource()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: sprd-adi: Convert to platform remove callback returning void

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    iio: adc: ad7280a: handle spi_setup() errors in probe()

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix getting range information for subdevices 16 to 255

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: avoid writing L1TF-vulnerable PTEs

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove dangerous max-link-speed from helios64

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

Kuniyuki Iwashima <kuniyu@google.com>
    fou: Don't allow 0 for FOU_ATTR_IPPROTO.

Jakub Kicinski <kuba@kernel.org>
    net: fou: use policy and operation tables generated from the spec

Jakub Kicinski <kuba@kernel.org>
    net: fou: rename the source for linking

Jakub Kicinski <kuba@kernel.org>
    netlink: add a proto specification for FOU

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

Niklas Cassel <cassel@kernel.org>
    ata: libata: Print features also for ATAPI devices

Niklas Cassel <cassel@kernel.org>
    ata: libata: Call ata_dev_config_lpm() for ATAPI devices

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: Introduce ata_dev_config_lpm()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: cleanup fua support detection

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: Introduce ata_ncq_supported()

Niklas Cassel <cassel@kernel.org>
    ata: libata: Add cpr_log to ata_dev_print_features() early return

Mark Harmstone <mark@harmstone.com>
    btrfs: fix missing fields in superblock backup with BLOCK_GROUP_TREE

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links

Wojtek Wasko <wwasko@nvidia.com>
    testptp: Add option to open PHC in readonly mode

Mahesh Bandewar <maheshb@google.com>
    selftest/ptp: update ptp selftest to exercise the gettimex options

Xabier Marquiegui <reibax@gmail.com>
    ptp: add testptp mask test

Alex Maftei <alex.maftei@amd.com>
    selftests/ptp: Add -X option for testing PTP_SYS_OFFSET_PRECISE

Alex Maftei <alex.maftei@amd.com>
    selftests/ptp: Add -x option for testing PTP_SYS_OFFSET_EXTENDED

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    testptp: Add support for testing ptp_clock_info .adjphase callback

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

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Clean up kfd node on surprise disconnect

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

Jaroslav Kysela <perex@perex.cz>
    ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer

Brian Kao <powenkao@google.com>
    scsi: core: Fix error handler encryption support

Benjamin Tissoires <bentiss@kernel.org>
    HID: usbhid: paper over wrong bNumDescriptor field

Haotian Zhang <vulab@iscas.ac.cn>
    dmaengine: omap-dma: fix dma_pool resource leak in error paths

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)

Dan Carpenter <dan.carpenter@linaro.org>
    phy: stm32-usphyc: Fix off by one in probe()

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix uninitialized addr_width when "xlnx,addrwidth" property is missing

Sheetal <sheetal@nvidia.com>
    dmaengine: tegra-adma: Fix use-after-free

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

Shradha Gupta <shradhagupta@linux.microsoft.com>
    hv_netvsc: Allocate rx indirection table size dynamically

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

Josef Bacik <josef@toxicpanda.com>
    btrfs: move flush related definitions to space-info.h

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

Andreas Gruenbacher <agruenba@redhat.com>
    Revert "gfs2: Fix use of bio_chain"

Morduan Zang <zhangdandan@uniontech.com>
    efi/cper: Fix cper_bits_to_str buffer handling and return value

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Set mu_resource_id before get handle


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 Documentation/netlink/specs/fou.yaml               | 130 ++++++++++++++
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  16 +-
 .../boot/dts/rockchip/rk3399-kobol-helios64.dts    |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |   1 -
 arch/arm64/kernel/hibernate.c                      |   2 +-
 arch/arm64/kernel/signal.c                         |  26 ++-
 arch/loongarch/kernel/perf_event.c                 |  21 ++-
 arch/riscv/include/asm/compat.h                    |   2 +-
 arch/x86/events/perf_event.h                       |  13 +-
 arch/x86/include/asm/kfence.h                      |  29 ++-
 arch/x86/kernel/cpu/resctrl/core.c                 |  21 ++-
 arch/x86/kernel/cpu/resctrl/internal.h             |   3 +
 arch/x86/kernel/fpu/core.c                         |  32 +++-
 arch/x86/kvm/x86.c                                 |   9 +
 arch/x86/mm/fault.c                                |  15 +-
 arch/x86/mm/kaslr.c                                |  10 +-
 block/blk-cgroup.c                                 |   4 +
 crypto/authencesn.c                                |   6 +
 drivers/ata/libata-core.c                          |  62 ++++++-
 drivers/ata/libata-scsi.c                          |  30 +---
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/xen-blkback/xenbus.c                 |   4 +-
 drivers/block/xen-blkfront.c                       |   3 +-
 drivers/bluetooth/hci_ldisc.c                      |   4 +-
 drivers/char/tpm/xen-tpmfront.c                    |   3 +-
 drivers/clocksource/timer-riscv.c                  |   3 +-
 drivers/comedi/comedi_fops.c                       |   2 +-
 drivers/comedi/drivers/dmm32at.c                   |  32 +++-
 drivers/comedi/range.c                             |   2 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   1 +
 drivers/crypto/qat/qat_common/adf_init.c           |   1 +
 drivers/crypto/qat/qat_common/adf_isr.c            |   5 +
 drivers/dma/apple-admac.c                          |   1 +
 drivers/dma/at_hdmac.c                             |   9 +-
 drivers/dma/bcm-sba-raid.c                         |   6 +-
 drivers/dma/dw/rzn1-dmamux.c                       |   4 +-
 drivers/dma/idxd/compat.c                          |  23 ++-
 drivers/dma/lpc18xx-dmamux.c                       |  19 +-
 drivers/dma/qcom/gpi.c                             |   6 +-
 drivers/dma/sh/rz-dmac.c                           |   5 +
 drivers/dma/stm32-dmamux.c                         |  22 ++-
 drivers/dma/tegra210-adma.c                        |  10 +-
 drivers/dma/ti/dma-crossbar.c                      |  18 +-
 drivers/dma/ti/k3-udma-private.c                   |   2 +-
 drivers/dma/ti/omap-dma.c                          |   4 +
 drivers/dma/xilinx/xilinx_dma.c                    |   7 +-
 drivers/edac/i3200_edac.c                          |  11 +-
 drivers/edac/x38_edac.c                            |   9 +-
 drivers/firmware/efi/cper.c                        |   2 +-
 drivers/firmware/imx/imx-scu-irq.c                 |  24 +--
 drivers/gpio/gpio-rockchip.c                       |   8 -
 drivers/gpio/gpiolib-acpi.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   8 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  18 +-
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   3 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  23 +--
 drivers/gpu/drm/imx/imx-tve.c                      |  13 ++
 drivers/gpu/drm/nouveau/dispnv50/curs507a.c        |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/radeon/radeon_fence.c              |   8 -
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   4 +-
 drivers/gpu/drm/xen/xen_drm_front.c                |   3 +-
 drivers/hid/usbhid/hid-core.c                      |  17 +-
 drivers/hwtracing/intel_th/core.c                  |  19 +-
 drivers/iio/adc/ad7280a.c                          |   4 +-
 drivers/iio/adc/ad9467.c                           |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   1 +
 drivers/iio/adc/exynos_adc.c                       |  13 +-
 drivers/iio/chemical/scd4x.c                       |   6 +-
 drivers/iio/dac/ad5686.c                           |   6 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  15 +-
 drivers/input/misc/xen-kbdfront.c                  |   5 +-
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++
 drivers/irqchip/irq-gic-v3-its.c                   |   8 +-
 drivers/isdn/mISDN/timerdev.c                      |  13 +-
 drivers/leds/led-class.c                           |  10 +-
 drivers/misc/mei/mei-trace.h                       |  18 +-
 drivers/misc/uacce/uacce.c                         |  42 ++++-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  41 +++++
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  20 ++-
 drivers/net/bonding/bond_main.c                    |  29 +--
 drivers/net/bonding/bond_options.c                 |   8 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   2 +-
 drivers/net/can/usb/ems_usb.c                      |   8 +-
 drivers/net/can/usb/esd_usb.c                      |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   2 +-
 drivers/net/can/usb/gs_usb.c                       |  11 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   9 +-
 drivers/net/can/usb/mcba_usb.c                     |   8 +-
 drivers/net/can/usb/usb_8dev.c                     |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   5 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   1 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  86 ++++++---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  22 ++-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 --
 drivers/net/ethernet/rocker/rocker_main.c          |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   5 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   5 +
 drivers/net/hyperv/hyperv_net.h                    |   5 +-
 drivers/net/hyperv/netvsc_drv.c                    |  13 +-
 drivers/net/hyperv/rndis_filter.c                  |  29 ++-
 drivers/net/ipvlan/ipvlan.h                        |   2 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  16 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  49 +++---
 drivers/net/macvlan.c                              |  20 ++-
 drivers/net/netdevsim/bpf.c                        |   6 +
 drivers/net/netdevsim/dev.c                        |   2 +
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/team/team.c                            |  23 ++-
 drivers/net/usb/dm9601.c                           |   4 -
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  16 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |   9 +-
 drivers/net/xen-netback/xenbus.c                   |   3 +-
 drivers/net/xen-netfront.c                         |   4 +-
 drivers/nfc/virtual_ncidev.c                       |   4 -
 drivers/nvme/host/fabrics.c                        |  15 ++
 drivers/nvme/host/fabrics.h                        |   1 +
 drivers/nvme/host/fc.c                             |   5 +-
 drivers/nvme/host/nvme.h                           |  14 +-
 drivers/nvme/host/pci.c                            |  41 +++++
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/nvme/target/tcp.c                          |  28 ++-
 drivers/of/base.c                                  |   8 +-
 drivers/of/platform.c                              |   2 +-
 drivers/pci/Kconfig                                |   6 -
 drivers/pci/xen-pcifront.c                         |   4 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   2 +-
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |   3 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  56 +++---
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +-
 drivers/phy/tegra/xusb-tegra186.c                  |   3 +
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   9 +-
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |  17 ++
 drivers/ptp/ptp_chardev.c                          |  37 +++-
 drivers/ptp/ptp_private.h                          |  16 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |   1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/scsi/scsi_error.c                          |  35 +++-
 drivers/scsi/scsi_lib.c                            |   8 +
 drivers/scsi/storvsc_drv.c                         |   3 +-
 drivers/scsi/xen-scsifront.c                       |   4 +-
 drivers/slimbus/core.c                             |  19 +-
 drivers/soc/imx/imx8m-blk-ctrl.c                   |  11 +-
 drivers/spi/spi-sprd-adi.c                         |  67 ++-----
 drivers/target/sbp/sbp_target.c                    |   4 +-
 drivers/tty/hvc/hvc_xen.c                          |   4 +-
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/usb/core/config.c                          |   5 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/host/ohci-platform.c                   |   1 +
 drivers/usb/host/uhci-platform.c                   |   1 +
 drivers/usb/host/xen-hcd.c                         |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   2 +
 drivers/usb/serial/option.c                        |   1 +
 drivers/vhost/scsi.c                               |  24 +--
 drivers/video/fbdev/xen-fbfront.c                  |   6 +-
 drivers/w1/slaves/w1_therm.c                       |  60 ++-----
 drivers/w1/w1.c                                    |   2 -
 drivers/xen/pvcalls-back.c                         |   3 +-
 drivers/xen/pvcalls-front.c                        |   3 +-
 drivers/xen/xen-pciback/xenbus.c                   |   4 +-
 drivers/xen/xen-scsiback.c                         |   5 +-
 fs/btrfs/block-group.c                             |  60 ++++---
 fs/btrfs/ctree.h                                   |  59 -------
 fs/btrfs/delayed-inode.c                           |   1 +
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/inode-item.c                              |   1 +
 fs/btrfs/props.c                                   |   1 +
 fs/btrfs/relocation.c                              |  14 ++
 fs/btrfs/send.c                                    |   2 +
 fs/btrfs/space-info.c                              |  76 ++++++--
 fs/btrfs/space-info.h                              |  69 ++++++++
 fs/btrfs/sysfs.c                                   |  18 +-
 fs/btrfs/transaction.c                             |  11 +-
 fs/efivarfs/vars.c                                 |   2 +-
 fs/ext4/xattr.c                                    |   1 +
 fs/fs-writeback.c                                  |  14 +-
 fs/gfs2/log.c                                      |   3 +-
 fs/gfs2/lops.c                                     |   2 +-
 fs/gfs2/super.c                                    |   4 +
 fs/iomap/buffered-io.c                             |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfsd/nfsctl.c                                   |  17 +-
 fs/ntfs3/inode.c                                   |   7 +-
 fs/smb/server/mgmt/user_session.c                  |  35 ++--
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/transport_ipc.c                      |  12 ++
 fs/smb/server/transport_rdma.c                     |  15 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  11 +-
 include/linux/kfence.h                             |   1 +
 include/linux/libata.h                             |  36 ++--
 include/linux/nvme.h                               |   3 +
 include/linux/posix-clock.h                        |  39 ++++-
 include/linux/textsearch.h                         |   1 +
 include/linux/usb/quirks.h                         |   3 +
 include/net/bonding.h                              |  13 +-
 include/net/nfc/nfc.h                              |   2 +
 include/scsi/scsi_eh.h                             |   6 +
 include/sound/pcm.h                                |   2 +-
 include/uapi/linux/comedi.h                        |   2 +-
 include/xen/xenbus.h                               |   2 +-
 io_uring/io_uring.c                                |   8 +-
 kernel/bpf/cgroup.c                                |   8 +-
 kernel/dma/pool.c                                  |   7 +-
 kernel/irq/irq_sim.c                               |   2 +-
 kernel/time/hrtimer.c                              |   2 +-
 kernel/time/posix-clock.c                          |  53 ++++--
 lib/flex_proportions.c                             |   5 +-
 mm/Kconfig                                         |  10 +-
 mm/damon/sysfs.c                                   |  15 +-
 mm/kfence/core.c                                   |  23 ++-
 mm/kmsan/shadow.c                                  |   3 +-
 mm/migrate.c                                       |  12 +-
 mm/mprotect.c                                      | 101 ++++++-----
 mm/page_alloc.c                                    |  47 ++++-
 mm/rmap.c                                          |  20 +--
 net/9p/trans_xen.c                                 |   3 +-
 net/bpf/test_run.c                                 |   5 +
 net/bridge/br_input.c                              |   2 +-
 net/can/j1939/transport.c                          |  10 +-
 net/core/dev.c                                     |  25 ++-
 net/core/filter.c                                  |  25 ++-
 net/ipv4/Makefile                                  |   1 +
 net/ipv4/esp4_offload.c                            |   4 +-
 net/ipv4/{fou.c => fou_core.c}                     |  50 ++----
 net/ipv4/fou_nl.c                                  |  48 +++++
 net/ipv4/fou_nl.h                                  |  25 +++
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/esp6_offload.c                            |   4 +-
 net/ipv6/icmp.c                                    |   4 +-
 net/ipv6/ip6_tunnel.c                              |   2 +-
 net/ipv6/ndisc.c                                   |   4 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/mac80211/ibss.c                                |   8 +-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/iface.c                               |  10 +-
 net/mac80211/mesh.c                                |  10 +-
 net/mac80211/mesh_hwmp.c                           |   6 +-
 net/mac80211/mlme.c                                |  13 +-
 net/mac80211/ocb.c                                 |   6 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/scan.c                                |   2 +-
 net/mac80211/status.c                              |   6 +-
 net/mac80211/tdls.c                                |  11 +-
 net/mac80211/util.c                                |   2 +-
 net/mptcp/protocol.c                               |  13 +-
 net/netrom/nr_route.c                              |  13 +-
 net/nfc/core.c                                     |  27 ++-
 net/nfc/llcp_commands.c                            |  17 +-
 net/nfc/llcp_core.c                                |   4 +-
 net/nfc/nci/core.c                                 |   4 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/sch_qfq.c                                |   8 +-
 net/sched/sch_teql.c                               |   5 +
 net/sctp/input.c                                   |   2 +-
 net/sctp/sm_statefuns.c                            |  10 +-
 net/vmw_vsock/virtio_transport_common.c            |  30 +++-
 scripts/generate_rust_analyzer.py                  |   2 +-
 scripts/kconfig/.gitignore                         |   4 +-
 scripts/kconfig/Makefile                           |  45 ++---
 scripts/kconfig/gconf-cfg.sh                       |   7 +-
 scripts/kconfig/mconf-cfg.sh                       |  25 +--
 scripts/kconfig/nconf-cfg.sh                       |  28 +--
 scripts/kconfig/qconf-cfg.sh                       |  10 +-
 scripts/remove-stale-files                         |   2 +
 sound/core/oss/pcm_oss.c                           |   4 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/pci/ctxfi/ctamixer.c                         |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |   8 +
 sound/soc/codecs/tlv320adcx140.c                   |   8 +-
 sound/soc/codecs/wsa881x.c                         |  54 ++++--
 sound/soc/codecs/wsa883x.c                         |   9 +
 sound/soc/fsl/imx-card.c                           |   1 -
 sound/soc/intel/boards/sof_es8336.c                |   2 +-
 sound/usb/mixer.c                                  |  22 ++-
 sound/usb/mixer_scarlett2.c                        |   7 +-
 sound/xen/xen_snd_front.c                          |   3 +-
 tools/testing/selftests/net/amt.sh                 |   7 +-
 tools/testing/selftests/net/fib-onlink-tests.sh    |  76 ++++----
 tools/testing/selftests/net/toeplitz.c             |   4 +-
 tools/testing/selftests/ptp/testptp.c              | 194 +++++++++++++++++++--
 tools/testing/vsock/util.c                         |  12 ++
 306 files changed, 2737 insertions(+), 1248 deletions(-)


