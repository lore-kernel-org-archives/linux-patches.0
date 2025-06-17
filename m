Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799C32EF655;
	Tue, 17 Jun 2025 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174114; cv=none; b=jOK5GJjeGt7UvWCbgv5gxvc0rNHVZnaRS4wpsSN/b+Z4f+jSe0bG5CB5IsMHjd44xOmn0FsOev8ekEeU4XjrNrfk9bZ3Ygl94KtxePldTyRTM67ZE9IWeHB3Et2iIUP5oCyIGsEJa5mSS4AfZX7m48oEV7kxTk/Ha9/SotzEb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174114; c=relaxed/simple;
	bh=qlZqTC+PoOfwVJTzUzx5GQNR9S98gImMNi/kb1/1Ixo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rQkdiO2efBTOOCK5C/otDgm7CJCMInn950HYIqcsrh3KSklQUFY6/PLHc36hjnI9i8n/JUTkia0wA9cnIOJ2JwNaKX16uspYRIa6mZQOseQi/TAA16vkakvB8EhRwW7AZiKNbpr6NTRsNET4b3n8cd6VyMgeYICjmQDWKecCv7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuBnduvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuBnduvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182A8C4CEE3;
	Tue, 17 Jun 2025 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174114;
	bh=qlZqTC+PoOfwVJTzUzx5GQNR9S98gImMNi/kb1/1Ixo=;
	h=From:To:Cc:Subject:Date:From;
	b=SuBnduvLj+b7DvQKFjgPvLam8h79GNc7Oba4oza5ZhdNidPlsc+rY1qQ/TuaTMJdQ
	 X8JjC7HAKt9TzUcg9t85mWhXg4NjFNmuaFBemHwK5WlXddysKRkkkU+eTzDwVyBar2
	 ebVmheo0VNZdmPMQbva/JLgypkcEg5pF5BGNwl30=
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
Subject: [PATCH 6.6 000/356] 6.6.94-rc1 review
Date: Tue, 17 Jun 2025 17:21:55 +0200
Message-ID: <20250617152338.212798615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.94-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.94-rc1
X-KernelTest-Deadline: 2025-06-19T15:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.94 release.
There are 356 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.94-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.94-rc1

I Hsin Cheng <richard120310@gmail.com>
    drm/meson: Use 1000ULL when operating with mode->clock

Oliver Neukum <oneukum@suse.com>
    net: usb: aqc111: debug info before sanitation

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    regulator: dt-bindings: mt6357: Drop fixed compatible requirement

Eric Dumazet <edumazet@google.com>
    calipso: unlock rcu before returning -EAFNOSUPPORT

Thomas Gleixner <tglx@linutronix.de>
    x86/iopl: Cure TIF_IO_BITMAP inconsistencies

Stefano Stabellini <stefano.stabellini@amd.com>
    xen/arm: call uaccess_ttbr0_enable for dm_op hypercall

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Flush altsetting 0 endpoints before reinitializating them after reset.

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting USB 3.2 speed

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting command completion event

Wupeng Ma <mawupeng1@huawei.com>
    VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix read_stb function and get_stb ioctl

Nathan Chancellor <nathan@kernel.org>
    kbuild: Disable -Wdefault-const-init-unsafe

Oleg Nesterov <oleg@redhat.com>
    posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "io_uring: ensure deferred completions are posted for multishot"

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: fix wrong NOWAIT check in io_rw_init_file()

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT

Jens Axboe <axboe@kernel.dk>
    io_uring: add io_file_can_poll() helper

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: usbhid: Eliminate recurrent out-of-bounds bug in usbhid_parse()

David Heimann <d@dmeh.net>
    ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1

Suleiman Souhlal <suleiman@google.com>
    tools/resolve_btfids: Fix build when cross compiling kernel with clang.

Matthew Wilcox (Oracle) <willy@infradead.org>
    block: Fix bvec_set_folio() for very large folios

Matthew Wilcox (Oracle) <willy@infradead.org>
    bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP

Peter Zijlstra <peterz@infradead.org>
    perf: Ensure bpf_perf_link path is properly serialized

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: access fcpreq only when holding reqlock

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/filesystems: Fix potential unsigned integer underflow in fs_name()

Eric Dumazet <edumazet@google.com>
    net_sched: ets: fix a race in ets_qdisc_change()

Eric Dumazet <edumazet@google.com>
    net_sched: tbf: fix a race in tbf_change()

Eric Dumazet <edumazet@google.com>
    net_sched: red: fix a race in __red_change()

Eric Dumazet <edumazet@google.com>
    net_sched: prio: fix a race in prio_tune()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix leak of Geneve TLV option object

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix return value when searching for existing flow group

Amir Tzin <amirtz@nvidia.com>
    net/mlx5: Fix ECVF vports unload on shutdown flow

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Ensure fw pages are always allocated on same NUMA

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix sparse errors

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix NULL pointer deference on eir_get_service_data

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds clause 45 read/write access

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds read/write access

Carlos Fernandez <carlos.fernandez@technica-engineering.de>
    macsec: MACsec SCI assignment for ES = 0

Michal Luczaj <mhal@rbox.co>
    net: Fix TOCTOU issue in sk_is_readable()

Yunhui Cui <cuiyunhui@bytedance.com>
    ACPI: CPPC: Fix NULL pointer dereference when nosmp is used

Robert Malz <robert.malz@canonical.com>
    i40e: retry VFLR handling if there is ongoing VF reset

Robert Malz <robert.malz@canonical.com>
    i40e: return false from i40e_reset_vf if reset is in progress

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix more rounding issues with 59.94Hz modes

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use vclk_freq instead of pixel_freq in debug print

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix debug log statement when setting the HDMI clocks

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use unsigned long long / Hz for frequency types

Haren Myneni <haren@linux.ibm.com>
    powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: fix a potential crash on gso_skb handling

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: iscsi: Fix incorrect error path labels for flashnode operations

Wojciech Slenska <wojciech.slenska@gmail.com>
    pinctrl: qcom: pinctrl-qcm2290: Add missing pins

Dan Carpenter <dan.carpenter@linaro.org>
    regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't wait when there is no vdev started

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't use static variables in ath11k_debugfs_fw_stats_process()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()

Easwar Hariharan <eahariha@linux.microsoft.com>
    wifi: ath11k: convert timeouts to secs_to_jiffies()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: fix soc_dp_stats debugfs file permission

Caleb Connolly <caleb.connolly@linaro.org>
    ath10k: snoc: fix unbalanced IRQ enable in crash recovery

Jeongjun Park <aha310510@gmail.com>
    ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Protect mgmt_pending list with its own lock

Dr. David Alan Gilbert <linux@treblig.org>
    Bluetooth: MGMT: Remove unused mgmt_pending_find_data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix UAF on mgmt_remove_adv_monitor_complete

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_core: fix list_for_each_entry_rcu usage

Sanjeev Yadav <sanjeev.y@mediatek.com>
    scsi: core: ufs: Fix a hang in the error handler

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Move runtime PM enable to sci_probe_single()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Check if TX data was written to device in .tx_empty()

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators

Beleswar Padhi <b-padhi@ti.com>
    arm64: dts: ti: k3-j721e-sk: Add support for multiple CAN instances

Vaishnav Achath <vaishnav.a@ti.com>
    arm64: dts: ti: k3-j721e-sk: Model CSI2RX connector mux

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am65-main: Fix sdhci node properties

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: use unchecked __memset internally

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi - fix crash with unsupported versions of F34

Dan Carpenter <dan.carpenter@linaro.org>
    pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()

Jakob Unterwurzacher <jakobunt@gmail.com>
    net: dsa: microchip: linearize skb for tail-tagging switches

Pieter Van Trappen <pieter.van.trappen@cern.ch>
    net: dsa: microchip: update tag_ksz masks for KSZ9477 family

Al Viro <viro@zeniv.linux.org.uk>
    do_change_type(): refuse to operate on unmounted/not ours mounts

Al Viro <viro@zeniv.linux.org.uk>
    fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)

Al Viro <viro@zeniv.linux.org.uk>
    path_overmount(): avoid false negatives

Yuuki NAGAO <wf.yn386@gmail.com>
    ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Verify content returned by parse_int_array()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: hda: Fix RPM usage count underflow

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom: Prevent calling phy_exit() before phy_init()

Ido Schimmel <idosch@nvidia.com>
    seg6: Fix validation of nexthop addresses

Mirco Barone <mirco.barone@polito.it>
    wireguard: device: enable threaded NAPI

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow RGMII for bcm63xx RGMII ports

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable RGMII delay on bcm63xx

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: also check reverse tuple to obtain clashing entry

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo_avx2: fix initial map fill

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix power.is_suspended cleanup for direct-complete devices

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: correctly report gso type for UDP tunnels

Jinjian Song <jinjian.song@fibocom.com>
    net: wwan: t7xx: Fix napi rx poll issue

Shiming Cheng <shiming.cheng@mediatek.com>
    net: fix udp gso skb_segment after pull from frag_list

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring timestamping

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: fix pskb_may_pull length

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix rebuilding the Tx scheduler tree for large queue counts

Michal Kubiak <michal.kubiak@intel.com>
    ice: create new Tx scheduler nodes for new queues only

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix Tx scheduler error handling in XDP callback

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix shared reset

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-spi: fix shared reset

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Make sure to insert the vlan tags also in host mode

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4_en: Prevent potential integer overflow calculating Hz

Yanqing Wang <ot_yanqing.wang@mediatek.com>
    driver: net: ethernet: mtk_star_emac: fix suspend/resume issue

Charalampos Mitrodimas <charmitro@posteo.net>
    net: tipc: fix refcount warning in tipc_aead_encrypt

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt

Quentin Schulz <quentin.schulz@cherry.de>
    net: stmmac: platform: guarantee uniqueness of bus_id

Nicolas Pitre <npitre@baylibre.com>
    vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: prevent deactivate active config while enabling the config

Qasim Ijaz <qasdev00@gmail.com>
    fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    counter: interrupt-cnt: Protect enable/disable OPs with mutex

WangYuli <wangyuli@uniontech.com>
    MIPS: Loongson64: Add missing '#interrupt-cells' for loongson64c_ls7a

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    iio: adc: ad7124: Fix 3dB filter frequency reading

Brian Pellegrino <bpellegrino@arka.org>
    iio: filter: admv8818: Support frequencies >= 2^32

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix range calculation

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix integer overflow

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix band 4, state 15

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Fix a logic error in wake on connect

Henry Martin <bsdhenrymartin@gmail.com>
    serial: Fix potential null-ptr-deref in mlb_usio_probe()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    usb: renesas_usbhs: Reorder clock handling and power management in probe

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: loongson: Add missing alarm notifications for ACPI RTC events

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Initialize aer_err_info before using it

Henry Martin <bsdhenrymartin@gmail.com>
    dmaengine: ti: Add NULL check in udma_probe()

Chenyuan Yang <chenyuan0y@gmail.com>
    phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug

Mario Limonciello <mario.limonciello@amd.com>
    PCI: Explicitly put devices into D0 when initializing

Hector Martin <marcan@marcan.st>
    PCI: apple: Use gpiod_set_value_cansleep in probe flow

Hans Zhang <18255117159@163.com>
    PCI: cadence: Fix runtime atomic count underflow

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: sh: assign correct interrupts with DT

Pali Rohár <pali@kernel.org>
    cifs: Fix validation of SMB1 query reparse point response

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when remounting nfs

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: clear SB_RDONLY before getting superblock

Anubhav Shelat <ashelat@redhat.com>
    perf trace: Always print return value for syscalls returning a pid

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf record: Fix incorrect --user-regs comments

Leo Yan <leo.yan@arm.com>
    perf tests switch-tracking: Fix timestamp comparison

Alexey Gladkov <legion@kernel.org>
    mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()

Dan Carpenter <dan.carpenter@linaro.org>
    rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-r5: Drop check performed in k3_r5_rproc_{mbox_callback/kick}

Dan Carpenter <dan.carpenter@linaro.org>
    remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix pattern matching with Python 3

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix PEBS-via-PT data_src

Namhyung Kim <namhyung@kernel.org>
    perf trace: Fix leaks of 'struct thread' in set_filter_loop_pids()

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: make corrupting read bios work

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: error all IOs when num_features is absent

Alexei Safin <a.safin@rosa.ru>
    hwmon: (asus-ec-sensors) check sensor index in read_string()

Mikhail Arkhipov <m.arhipov@rosa.ru>
    mtd: nand: ecc-mxic: Fix use of uninitialized variable ret

Henry Martin <bsdhenrymartin@gmail.com>
    backlight: pm8941: Add NULL check in wled_configure()

Benjamin Marzinski <bmarzins@redhat.com>
    dm: free table mempools if not used in __bind

Benjamin Marzinski <bmarzins@redhat.com>
    dm: don't change md if dm_table_set_restrictions() fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui browser hists: Set actions->thread before calling do_zoom_thread()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Warn when libdebuginfod devel files are not available

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Fix attribute addition

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Remove bogus void member

Sergey Shtylyov <s.shtylyov@omp.ru>
    fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()

Henry Martin <bsdhenrymartin@gmail.com>
    soc: aspeed: Add NULL check in aspeed_lpc_enable_snoop()

Su Hui <suhui@nfschina.com>
    soc: aspeed: lpc: Fix impossible judgment condition

Joel Stanley <joel@jms.id.au>
    ARM: aspeed: Don't select SRAM

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Rename RTC node to match binding expectations

Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
    arm64: dts: renesas: white-hawk-ard-audio: Fix TPU0 groups

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou

Vignesh Raman <vignesh.raman@collabora.com>
    arm64: defconfig: mediatek: enable PHY drivers

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064: add missing clocks to the timer node

Andre Przywara <andre.przywara@arm.com>
    dt-bindings: vendor-prefixes: Add Liontron name

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: fix double-free on mc_dev

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()

Wentao Liang <vulab@iscas.ac.cn>
    nilfs2: add pointer check for nilfs_direct_propagate()

Murad Masimov <m.masimov@mt-integration.ru>
    ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check return result of sb_min_blocksize

Prasanth Babu Mantena <p-mantena@ti.com>
    arm64: dts: ti: k3-j721e-common-proc-board: Enable OSPI1 on J721E

Aaron Kling <webgeek1234@gmail.com>
    arm64: tegra: Drop remaining serial clock-names and reset-names

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Update eMMC for NanoPi R5 series

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Add missing 'compatible' property to regulators node

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt6357: Drop regulator-fixed compatibles

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Set SAI5 MCLK direction to output for HDMI audio

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Set SAI5 MCLK direction to output for HDMI audio

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix RTC capacitive load

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: at91sam9263: fix NAND chip selects

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sc8280xp-x13s: Drop duplicate DMIC supplies

Xilin Wu <wuxilin123@gmail.com>
    arm64: dts: qcom: sm8250: Fix CPU7 opp table

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm8350: Reenable crypto & cryptobam

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: remove excess reserved gpios

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: refactor node order

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: fix usb regulator mistake

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: remove wifi

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to correct check conditions in f2fs_cross_rename

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use d_inode(dentry) cleanup dentry->d_inode

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Stop clearing the the UDPv4 checksum for L2 frames

Faicker Mo <faicker.mo@zenlayer.com>
    net: openvswitch: Fix the dead loop of MPLS parse

Kuniyuki Iwashima <kuniyu@amazon.com>
    calipso: Don't call calipso functions for AF_INET sk.

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: QOS: Refactor TC_HTB_LEAF_DEL_LAST callback

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Fix memory leak when using one step timestamping

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: phy: fix up const issues in to_mdio_device() and to_phy_device()

Wei Fang <wei.fang@nxp.com>
    net: phy: clear phydev->devlink when the link is deleted

KaFai Wan <mannkafai@gmail.com>
    bpf: Avoid __bpf_prog_ret0_warn when jit fails

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix 1-step timestamping over ipv4 or ipv6

Jack Morgenstein <jackm@nvidia.com>
    RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: aqc111: fix error handling of usbnet read calls

Radim Krčmář <rkrcmar@ventanamicro.com>
    RISC-V: KVM: lock the correct mp_state during reset

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_tunnel: fix geneve_opt dump

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Avoid using sk_socket after free when sending

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()

Li RongQing <lirongqing@baidu.com>
    vfio/type1: Fix error unwind in migration dirty bitmap allocation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix RX buffer size of MCU event

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: set EHT max ampdu length capability

Henry Martin <bsdhenrymartin@gmail.com>
    wifi: mt76: mt7915: Fix null-ptr-deref in mt7915_mmio_wed_init()

Michal Koutný <mkoutny@suse.com>
    kernfs: Relax constraint in draining guard

ping.gao <ping.gao@samsung.com>
    scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k_htc: Abort software beacon handling if disabled

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix live migration function without VF device driver

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: add eq and aeq interruption restore

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: fix XQE dma address error

Rajat Soni <quic_rajson@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_service_ready_ext_event

Rolf Eike Beer <eb@emlix.com>
    iommu: remove duplicate selection of DMAR_TABLE

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: rtw88: fix the 'para' buffer size to avoid reading out of bounds

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Store backchain even for leaf progs

Vincent Knecht <vincent.knecht@mailoo.org>
    clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz

Tao Chen <chen.dylane@linux.dev>
    bpf: Fix WARN() in get_bpf_raw_tp_regs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: at91: Fix possible out-of-boundary access

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in nlattr

Jiayuan Chen <jiayuan.chen@linux.dev>
    ktls, sockmap: Fix missing uncharge operation

Miaoqian Lin <linmq006@gmail.com>
    tracing: Fix error handling in event_trigger_parse()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Rename event_trigger_alloc() to trigger_data_alloc()

Hans Zhang <18255117159@163.com>
    efi/libstub: Describe missing 'out' parameter in efi_load_initrd

Henry Martin <bsdhenrymartin@gmail.com>
    clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: camcc-sm6350: Add *_wait_val values for GDSCs

Steven Rostedt <rostedt@goodmis.org>
    tracing: Move histogram trigger variables from stack to per CPU structure

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix error flow upon firmware failure for RQ destruction

Zhongqiu Duan <dzq.aishenghu0@gmail.com>
    netfilter: nft_quota: match correctly when the quota just depleted

Huajian Yang <huajianyang@asrmicro.com>
    netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it

Lorenzo Bianconi <lorenzo@kernel.org>
    bpf: Allow XDP dev-bound programs to perform XDP_REDIRECT into maps

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in linker

Chao Yu <chao@kernel.org>
    f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ fscrypt_is_bounce_page()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: assign random address if device address is same as bond

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Protect against overflow in iommu_pgsize()

Jonathan Wiepert <jonathan.wiepert@gmail.com>
    Use thread-safe function pointer in libbpf_print

Tao Chen <chen.dylane@linux.dev>
    libbpf: Remove sample_period init in perf_buffer

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h

Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
    wifi: ath12k: fix node corruption in ar->arvifs list

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Add MSDU length validation for TKIP MIC error

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: do not ignore hardware read error during DPK

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm: Use xdo.dev instead of xdo.real_dev

Viktor Malik <vmalik@redhat.com>
    libbpf: Fix buffer overflow in bpf_object__init_prog

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix GCPS 64-bit member variables

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sbi->total_valid_block_count

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: ath12k: Fix WMI tag for EHT rate in peer assoc

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix panic when calling skb_linearize

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: fix duplicated data transmission

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: fix ktls panic with sockmap

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    selftests/bpf: Fix bpf_nf selftest failure

Jacob Moroni <jmoroni@google.com>
    IB/cm: use rwlock for MAD agent lock

Stone Zhang <quic_stonez@quicinc.com>
    wifi: ath11k: fix node corruption in ar->arvifs list

Roger Pau Monne <roger.pau@citrix.com>
    xen/x86: fix initial memory balloon target

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_drm_drv: Unbind secondary mmsys components on err

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: Fix kobject put for component sub-drivers

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_drm_drv: Fix kobject put for mtk_mutex device ptr

Anand Moon <linux.amoon@gmail.com>
    perf/amlogic: Replace smp_processor_id() with raw_smp_processor_id() in meson_ddr_pmu_create()

Kees Cook <kees@kernel.org>
    scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Do not discard modified SVE state

Huang Yiwei <quic_hyiwei@quicinc.com>
    firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES

Biju Das <biju.das.jz@bp.renesas.com>
    drm/tegra: rgb: Fix the unbound reference count

Kees Cook <kees@kernel.org>
    drm/vkms: Adjust vkms_state->active_planes allocation type

Biju Das <biju.das.jz@bp.renesas.com>
    drm: rcar-du: Fix memory leak in rcar_du_vsps_init()

Neill Kapron <nkapron@google.com>
    selftests/seccomp: fix syscall_restart test for arm compat

Kornel Dulęba <korneld@google.com>
    arm64: Support ARM64_VA_BITS=52 when setting ARCH_MMAP_RND_BITS_MAX

Miaoqian Lin <linmq006@gmail.com>
    firmware: psci: Fix refcount leak in psci_dt_init

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix macintosh_config for Mac II

Kees Cook <kees@kernel.org>
    watchdog: exar: Shorten identity name to fit correctly

Andrey Vatoropin <a.vatoropin@crpt.ru>
    fs/ntfs3: handle hdr_first_de() return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Fix merging of FPSIMD state during signal return

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Discard stale CPU state when handling SME traps

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Avoid RES0 bits in the SME trap handler

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: Fix frame size enumeration

Charles Han <hanchunchao@inspur.com>
    drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table

Maxime Ripard <mripard@kernel.org>
    drm/vc4: tests: Use return instead of assert

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add seqno waiter for sync_files

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Constrain channels according to TDM mask

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: sh-msiof: Fix maximum DMA transfer size

Armin Wolf <W_Armin@gmx.de>
    ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Print PM debug messages during hibernation

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()

Zijun Hu <quic_zijuhu@quicinc.com>
    PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()

Kees Cook <kees@kernel.org>
    ASoC: SOF: ipc4-pcm: Adjust pipeline_list->pipelines allocation type

Alexander Shiyan <eagle.alexander923@gmail.com>
    power: reset: at91-reset: Optimize at91_reset()

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: modify chip select (CS) deactivation

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: remove redundant error handling code

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Fix X1_X2_X4 encoding and support x4 transfers

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: fix integer overflow in i{64,}toa_r() and

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/{skx_common,i10nm}: Fix the loss of saved RRL for HBM pseudo channel 0

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Fix general protection fault

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Enable main IRQs

Jemmy Wong <jemmywong512@gmail.com>
    tools/nolibc/types.h: fix mismatched parenthesis in minor()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: exserial: don't forget to handle FFixedHW opregions for reading

Tzung-Bi Shih <tzungbi@kernel.org>
    kunit: Fix wrong parameter to kunit_deactivate_static_stub()

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - move fallback ahash_request to the end of the struct

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Only add ecb if it is not already there

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lrw - Only add ecb if it is not already there

Yongliang Gao <leonylgao@tencent.com>
    rcu/cpu_stall_cputime: fix the hardirq count for x86 architecture

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: fix a wrong error type when metadata bytenr mismatches

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: update device stats when an error is detected

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Avoid empty transfer descriptor

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Handle zero-length skcipher requests

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Sanitize CPUID(0x80000000) output

Annie Li <jiayanli@google.com>
    x86/microcode/AMD: Do not return error when microcode update is not necessary

Eddie James <eajames@linux.ibm.com>
    powerpc/crash: Fix non-smp kexec preparation

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    powerpc: do not build ppc_save_regs.o always

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()

Qing Wang <wangqing7171@gmail.com>
    perf/core: Fix broken throttling when max_samples_per_tick=1

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_create_inode error handling fix

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/idle: Remove MFENCEs for X86_BUG_CLFLUSH_MONITOR in mwait_idle_with_hints() and prefer_mwait_c1_over_halt()

Ahmed S. Darwish <darwi@linutronix.de>
    tools/x86/kcpuid: Fix error handling

Aurabindo Pillai <aurabindo.pillai@amd.com>
    Revert "drm/amd/display: more liberal vmin/vmax update for freesync"

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    dt-bindings: usb: cypress,hx3: Add support for all variants

Sergey Senozhatsky <senozhatsky@chromium.org>
    thunderbolt: Do not double dequeue a configuration request

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix timeout value in get_stb

Dustin Lundquist <dustin@null-ptr.net>
    serial: jsm: fix NPE during jsm_uart_port_init

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    Bluetooth: hci_qca: move the SoC type check to the right place

Qasim Ijaz <qasdev00@gmail.com>
    usb: typec: ucsi: fix Clang -Wsign-conversion warning

Charles Yeh <charlesyeh522@gmail.com>
    USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: storage: Ignore UAS driver for SanDisk 3.2 Gen2 storage device

Jiayi Li <lijiayi@kylinos.cn>
    usb: quirks: Add NO_LPM quirk for SanDisk Extreme 55AE

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Fix offset calculation for .start_secs < 0

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Make rtc_time64_to_tm() support dates before 1970

Gautham R. Shenoy <gautham.shenoy@amd.com>
    acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: set GPIO output value before setting direction

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31

Pan Taixi <pantaixi@huaweicloud.com>
    tracing: Fix compilation warning on arm32


-------------

Diffstat:

 .../bindings/phy/fsl,imx8mq-usb-phy.yaml           |   3 +-
 .../regulator/mediatek,mt6357-regulator.yaml       |  12 +-
 .../devicetree/bindings/usb/cypress,hx3.yaml       |  19 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/at91sam9263ek.dts      |   2 +-
 arch/arm/boot/dts/microchip/tny_a9263.dts          |   2 +-
 arch/arm/boot/dts/microchip/usb_a9263.dts          |   4 +-
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi           |  15 +-
 arch/arm/mach-aspeed/Kconfig                       |   1 -
 arch/arm64/Kconfig                                 |   6 +-
 .../arm64/boot/dts/freescale/imx8mm-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 .../arm64/boot/dts/freescale/imx8mn-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   1 +
 .../boot/dts/freescale/imx8mp-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/mediatek/mt6357.dtsi           |  10 -
 arch/arm64/boot/dts/mediatek/mt6359.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |  50 ++---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |  12 --
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  12 --
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |   3 -
 .../arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts |   2 +
 .../arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts |   3 +
 .../boot/dts/qcom/sdm845-samsung-starqltechn.dts   |  16 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   6 +-
 .../r8a779g0-white-hawk-ard-audio-da7212.dtso      |   2 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   8 -
 .../arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi |   5 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |  19 +-
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |   1 +
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             | 166 ++++++++++++++-
 arch/arm64/configs/defconfig                       |   3 +
 arch/arm64/include/asm/esr.h                       |  12 +-
 arch/arm64/include/asm/fpsimd.h                    |   3 +
 arch/arm64/kernel/entry-common.c                   |  46 ++++-
 arch/arm64/kernel/fpsimd.c                         |  21 +-
 arch/arm64/xen/hypercall.S                         |  21 +-
 arch/m68k/mac/config.c                             |   2 +-
 .../boot/dts/loongson/loongson64c_4core_ls7a.dts   |   1 +
 arch/powerpc/kernel/Makefile                       |   2 +-
 arch/powerpc/kexec/crash.c                         |   5 +-
 arch/powerpc/platforms/book3s/vas-api.c            |   9 +
 arch/powerpc/platforms/powernv/memtrace.c          |   8 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   4 +-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/x86/include/asm/mwait.h                       |   9 +-
 arch/x86/kernel/cpu/common.c                       |  17 +-
 arch/x86/kernel/cpu/microcode/core.c               |   2 +
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/ioport.c                           |  13 +-
 arch/x86/kernel/process.c                          |  15 +-
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/acpi/acpica/exserial.c                     |   6 +
 drivers/acpi/apei/Kconfig                          |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/osi.c                                 |   1 -
 drivers/base/power/domain.c                        |   2 +-
 drivers/base/power/main.c                          |   3 +-
 drivers/bluetooth/hci_qca.c                        |  14 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/qcom/camcc-sm6350.c                    |  18 ++
 drivers/clk/qcom/dispcc-sm6350.c                   |   3 +
 drivers/clk/qcom/gcc-msm8939.c                     |   4 +-
 drivers/clk/qcom/gcc-sm6350.c                      |   6 +
 drivers/clk/qcom/gpucc-sm6350.c                    |   6 +
 drivers/counter/interrupt-cnt.c                    |   9 +
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   7 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |  34 +--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/marvell/cesa/cipher.c               |   3 +
 drivers/crypto/marvell/cesa/hash.c                 |   2 +-
 drivers/dma/ti/k3-udma.c                           |   3 +-
 drivers/edac/i10nm_base.c                          |  35 ++--
 drivers/edac/skx_common.c                          |   1 +
 drivers/edac/skx_common.h                          |  11 +-
 drivers/firmware/Kconfig                           |   1 -
 drivers/firmware/arm_sdei.c                        |  11 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |   1 +
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/fpga/tests/fpga-mgr-test.c                 |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  16 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   8 +
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  31 ++-
 drivers/gpu/drm/meson/meson_drv.c                  |   2 +-
 drivers/gpu/drm/meson/meson_drv.h                  |   2 +-
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  29 +--
 drivers/gpu/drm/meson/meson_vclk.c                 | 226 +++++++++++---------
 drivers/gpu/drm/meson/meson_vclk.h                 |  13 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c      |  10 +-
 drivers/gpu/drm/tegra/rgb.c                        |  14 +-
 drivers/gpu/drm/vc4/tests/vc4_mock_output.c        |  36 ++--
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  26 +++
 drivers/hid/hid-hyperv.c                           |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  25 ++-
 drivers/hwmon/asus-ec-sensors.c                    |   4 +
 drivers/hwtracing/coresight/coresight-config.h     |   2 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |  49 +++--
 drivers/iio/adc/ad7124.c                           |   4 +-
 drivers/iio/filter/admv8818.c                      | 230 ++++++++++++++++-----
 drivers/infiniband/core/cm.c                       |  16 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   1 -
 drivers/infiniband/hw/mlx5/qpc.c                   |  30 ++-
 drivers/input/rmi4/rmi_f34.c                       | 133 ++++++------
 drivers/iommu/Kconfig                              |   1 -
 drivers/iommu/iommu.c                              |   4 +-
 drivers/md/dm-flakey.c                             |  70 ++++---
 drivers/md/dm.c                                    |  30 +--
 drivers/mfd/exynos-lpass.c                         |   1 -
 drivers/mfd/stmpe-spi.c                            |   2 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |  11 +-
 drivers/mtd/nand/ecc-mxic.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    |  25 ++-
 drivers/net/dsa/b53/b53_common.c                   |  23 +--
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |   3 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  47 +++--
 drivers/net/ethernet/intel/ice/ice_sched.c         | 181 +++++++++++++---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   4 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   7 +
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   6 +
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  49 +++--
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |  21 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/macsec.c                               |  40 +++-
 drivers/net/phy/mdio_bus.c                         |  12 ++
 drivers/net/phy/mscc/mscc_ptp.c                    |  20 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/usb/aqc111.c                           |  10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  26 +++
 drivers/net/wireguard/device.c                     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |  37 ++--
 drivers/net/wireless/ath/ath11k/core.h             |   4 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  62 +++---
 drivers/net/wireless/ath/ath11k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath12k/core.c             |   8 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   9 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   3 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |  10 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |  11 +-
 drivers/nvme/target/fcloop.c                       |  31 +--
 drivers/pci/controller/cadence/pcie-cadence-host.c |  11 +-
 drivers/pci/controller/pcie-apple.c                |   4 +-
 drivers/pci/pci-driver.c                           |   6 -
 drivers/pci/pci.c                                  |  15 +-
 drivers/pci/pci.h                                  |   1 +
 drivers/pci/pcie/dpc.c                             |   2 +-
 drivers/perf/amlogic/meson_ddr_pmu_core.c          |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   6 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  14 +-
 drivers/pinctrl/pinctrl-at91.c                     |   6 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   9 +
 drivers/power/reset/at91-reset.c                   |   5 +-
 drivers/ptp/ptp_private.h                          |  12 +-
 drivers/regulator/max20086-regulator.c             |   6 +-
 drivers/remoteproc/qcom_wcnss_iris.c               |   2 +
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   8 -
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/rtc/class.c                                |   2 +-
 drivers/rtc/lib.c                                  |  24 ++-
 drivers/rtc/rtc-loongson.c                         |   8 +
 drivers/rtc/rtc-sh.c                               |  12 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  29 +--
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  11 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  17 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   2 +-
 drivers/spi/spi-sh-msiof.c                         |  13 +-
 drivers/spi/spi-tegra210-quad.c                    |  24 +--
 drivers/staging/media/rkvdec/rkvdec.c              |  10 +-
 drivers/thunderbolt/ctl.c                          |   5 +
 drivers/thunderbolt/usb4.c                         |   4 +-
 drivers/tty/serial/jsm/jsm_tty.c                   |   1 +
 drivers/tty/serial/milbeaut_usio.c                 |   5 +-
 drivers/tty/serial/sh-sci.c                        |  81 ++++++--
 drivers/tty/vt/vt_ioctl.c                          |   2 -
 drivers/ufs/core/ufs-mcq.c                         |   6 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/ufs/host/ufs-qcom.c                        |   5 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  21 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +
 drivers/usb/class/usbtmc.c                         |  21 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/function/f_hid.c                |  12 +-
 drivers/usb/renesas_usbhs/common.c                 |  50 +++--
 drivers/usb/serial/pl2303.c                        |   2 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   3 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   2 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  79 +++++--
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  14 +-
 drivers/vfio/vfio_iommu_type1.c                    |   2 +-
 drivers/video/backlight/qcom-wled.c                |   6 +-
 drivers/video/fbdev/core/fbcvt.c                   |   2 +-
 drivers/watchdog/exar_wdt.c                        |   2 +-
 drivers/xen/balloon.c                              |  13 +-
 fs/btrfs/scrub.c                                   |  34 ++-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/f2fs.h                                     |  10 +-
 fs/f2fs/namei.c                                    |  10 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/filesystems.c                                   |  14 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/kernfs/dir.c                                    |   5 +-
 fs/kernfs/file.c                                   |   3 +-
 fs/namespace.c                                     |  25 ++-
 fs/nfs/super.c                                     |  19 ++
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/ntfs3/index.c                                   |   8 +
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/smb/client/cifssmb.c                            |  20 +-
 fs/squashfs/super.c                                |   5 +
 include/linux/arm_sdei.h                           |   4 +-
 include/linux/bio.h                                |   2 +-
 include/linux/bvec.h                               |   7 +-
 include/linux/hid.h                                |   3 +-
 include/linux/io_uring_types.h                     |   3 +
 include/linux/mdio.h                               |   5 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/phy.h                                |   5 +-
 include/net/bluetooth/hci_core.h                   |   2 +-
 include/net/checksum.h                             |   2 +-
 include/net/sock.h                                 |   7 +-
 io_uring/io_uring.c                                |  10 +-
 io_uring/io_uring.h                                |  12 ++
 io_uring/kbuf.c                                    |   3 +-
 io_uring/poll.c                                    |   2 +-
 io_uring/rw.c                                      |  26 ++-
 kernel/bpf/core.c                                  |  29 +--
 kernel/events/core.c                               |  50 +++--
 kernel/power/hibernate.c                           |   5 +
 kernel/power/main.c                                |   3 +-
 kernel/power/power.h                               |   4 +
 kernel/power/wakelock.c                            |   3 +
 kernel/rcu/tree.c                                  |  10 +-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_stall.h                            |   4 +-
 kernel/time/posix-cpu-timers.c                     |   9 +
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace.h                               |   8 +-
 kernel/trace/trace_events_hist.c                   | 122 +++++++++--
 kernel/trace/trace_events_trigger.c                |  20 +-
 lib/kunit/static_stub.c                            |   2 +-
 mm/kasan/report.c                                  |   4 +-
 mm/kasan/shadow.c                                  |   2 +-
 net/bluetooth/eir.c                                |  10 +-
 net/bluetooth/hci_core.c                           |  16 +-
 net/bluetooth/hci_sync.c                           |  20 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/mgmt.c                               | 140 ++++++-------
 net/bluetooth/mgmt_util.c                          |  51 ++---
 net/bluetooth/mgmt_util.h                          |   8 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/core/filter.c                                  |   2 +-
 net/core/skmsg.c                                   |  53 +++--
 net/core/utils.c                                   |   4 +-
 net/dsa/tag_brcm.c                                 |   2 +-
 net/dsa/tag_ksz.c                                  |  22 +-
 net/ipv4/udp_offload.c                             |   5 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/ipv6/netfilter.c                               |  12 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  13 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/ncsi/internal.h                                |  21 +-
 net/ncsi/ncsi-pkt.h                                |  23 +--
 net/ncsi/ncsi-rsp.c                                |  21 +-
 net/netfilter/nf_nat_core.c                        |  12 +-
 net/netfilter/nft_quota.c                          |  20 +-
 net/netfilter/nft_set_pipapo_avx2.c                |  21 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netlabel/netlabel_kapi.c                       |   5 +
 net/openvswitch/flow.c                             |   2 +-
 net/sched/sch_ets.c                                |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                |   5 +-
 net/sched/sch_tbf.c                                |   2 +-
 net/tipc/crypto.c                                  |   6 +-
 net/tls/tls_sw.c                                   |  15 +-
 net/xfrm/xfrm_device.c                             |   2 -
 net/xfrm/xfrm_state.c                              |   2 -
 scripts/Makefile.extrawarn                         |  12 ++
 scripts/gcc-plugins/gcc-common.h                   |  32 +++
 scripts/gcc-plugins/randomize_layout_plugin.c      |  40 ++--
 sound/soc/apple/mca.c                              |  23 +++
 sound/soc/codecs/hda.c                             |   4 +-
 sound/soc/codecs/tas2764.c                         |   2 +-
 sound/soc/intel/avs/debugfs.c                      |   6 +-
 sound/soc/intel/avs/ipc.c                          |   4 +-
 sound/soc/sof/ipc4-pcm.c                           |   3 +-
 sound/soc/ti/omap-hdmi.c                           |   7 +-
 sound/usb/implicit.c                               |   1 +
 tools/arch/x86/kcpuid/kcpuid.c                     |  47 +++--
 tools/bpf/resolve_btfids/Makefile                  |   2 +-
 tools/include/nolibc/stdlib.h                      |   4 +-
 tools/include/nolibc/types.h                       |   2 +-
 tools/lib/bpf/bpf_core_read.h                      |   6 +
 tools/lib/bpf/libbpf.c                             |   5 +-
 tools/lib/bpf/linker.c                             |   4 +-
 tools/lib/bpf/nlattr.c                             |  15 +-
 tools/perf/Makefile.config                         |   2 +
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-trace.c                         |   5 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |   5 +-
 tools/perf/tests/switch-tracking.c                 |   2 +-
 tools/perf/ui/browsers/hists.c                     |   2 +-
 tools/perf/util/intel-pt.c                         | 205 +++++++++++++++++-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   6 +
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   7 +-
 347 files changed, 3285 insertions(+), 1551 deletions(-)


