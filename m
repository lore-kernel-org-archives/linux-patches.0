Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2091DDC23;
	Wed,  7 May 2025 18:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643798; cv=none; b=sLquG8YpzEKie5LFKVQM3tXmreUJHtqXz0+1vMI1EYabs6Iu40JYy1snT69u9PqGfrufUk/Wqwv6/y2WORfISjvyNozELWhcRhYNMBEDCHBIJ3sAFIqRfw1PA9FFRFbEdykHIxO2qoGFuIipNBqvyZawYWdzP6eKjVCK7ADWozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643798; c=relaxed/simple;
	bh=jiZyqJz9qc9BkStfijZok3QHoUWXOB3kr2DwK5irNE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Myw1W7X/xINzWRDnbFOu9EFXBmnftVUWAc8QdCUAltK8iI+oRiXbhjFEDc4FVSq7fgIOBkm0ebC6O/xkjfgk7JFiz0oPSgSHA0uzsVFQEm/C25a0yFLQ5p7InQLj2frjvSkS3uS1huvbkb8c5m6WFRdJpO3vzOOWKSOxFVWmQsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=au275zn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="au275zn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF00C4CEE9;
	Wed,  7 May 2025 18:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643798;
	bh=jiZyqJz9qc9BkStfijZok3QHoUWXOB3kr2DwK5irNE0=;
	h=From:To:Cc:Subject:Date:From;
	b=au275zn7hlB/nEMBzp+wT9xUKxc2nTpdOvd3zp2JGZiwZ2AczhiIWH011LP5aN+wz
	 Y6ruVXdbAw1dXVJ3nFOz4hPEq11aIE37/2BoU5o1nKCTWCkvenRkseLTtNd5Pz5UVg
	 s4yxpTJA+r1GgvUY7i6ToknTxYa1OBkKbCSJkMf8=
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
Subject: [PATCH 6.14 000/183] 6.14.6-rc1 review
Date: Wed,  7 May 2025 20:37:25 +0200
Message-ID: <20250507183824.682671926@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.14.6-rc1
X-KernelTest-Deadline: 2025-05-09T18:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.14.6 release.
There are 183 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.14.6-rc1

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Change btree_insert_node() assertion to error

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/amd/display: Fix slab-use-after-free in hdcp

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp

Penglei Jiang <superman.xpt@gmail.com>
    btrfs: fix the inode leak in btrfs_iget()

David Sterba <dsterba@suse.com>
    btrfs: pass struct btrfs_inode to btrfs_iget_locked()

David Sterba <dsterba@suse.com>
    btrfs: pass struct btrfs_inode to btrfs_read_locked_inode()

Qu Wenruo <wqu@suse.com>
    btrfs: expose per-inode stable writes flag

Shyam Saini <shyamsaini@linux.microsoft.com>
    drivers: base: handle module_kobject creation

Shyam Saini <shyamsaini@linux.microsoft.com>
    kernel: globalize lookup_or_create_module_kobject()

Shyam Saini <shyamsaini@linux.microsoft.com>
    kernel: param: rename locate_module_kobject

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: skip reporting zone for new block group

Naohiro Aota <naohiro.aota@wdc.com>
    block: introduce zone capacity helper

Christian Bruel <christian.bruel@foss.st.com>
    arm64: dts: st: Use 128kB size for aliased GIC400 register access on stm32mp25 SoCs

Christian Bruel <christian.bruel@foss.st.com>
    arm64: dts: st: Adjust interrupt-controller for stm32mp25 SoCs

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: opos6ul: add ksz8081 phy properties

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx95: Correct the range of PCIe app-reg region

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Skip Rx buffer ownership release if not acquired

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Balance device refcount when destroying devices

Cong Wang <xiyou.wangcong@gmail.com>
    sch_ets: make est_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_qfq: make qfq_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: make hfsc_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_drr: make drr_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_qlen_notify() idempotent

Ming Lei <ming.lei@redhat.com>
    ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd

Ming Lei <ming.lei@redhat.com>
    ublk: simplify aborting ublk request

Ming Lei <ming.lei@redhat.com>
    ublk: remove __ublk_quiesce_dev()

Uday Shankar <ushankar@purestorage.com>
    ublk: improve detection and handling of ublk server exit

Ming Lei <ming.lei@redhat.com>
    ublk: move device reset into ublk_ch_release()

Uday Shankar <ushankar@purestorage.com>
    ublk: properly serialize all FETCH_REQs

Ming Lei <ming.lei@redhat.com>
    ublk: add helper of ublk_need_map_io()

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for Alienware m15 R7

Kenneth Graunke <kenneth@whitecape.org>
    drm/xe: Invalidate L3 read-only cachelines for geometry streams too

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Add handling of VPU_JSM_STATUS_MVNCI_CONTEXT_VIOLATION_HW

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Fix locking order in ivpu_job_submit

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Abort all jobs after command queue unregister

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    mm, slab: clean up slab->obj_exts always

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix RX error handling

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Add range check for CMD_RTS

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix LEN_MASK

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix possible stuck of SPI interrupt

Jian Shen <shenjian15@huawei.com>
    net: hns3: defer calling ptp_clock_register()

Hao Lan <lanhao@huawei.com>
    net: hns3: fixed debugfs tm_qset size

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix an interrupt residual problem

Jian Shen <shenjian15@huawei.com>
    net: hns3: store rx VLAN tag offload state for VF

Sathesh B Edara <sedara@marvell.com>
    octeon_ep: Fix host hang issue during device reboot

Mattias Barthel <mattias.barthel@atlascopco.com>
    net: fec: ERR007885 Workaround for conventional TX

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Fix memleak issue when GSO enabled

Sagi Maimon <sagi.maimon@adtran.com>
    ptp: ocp: Fix NULL dereference in Adva board SMA sysfs operations

Jibin Zhang <jibin.zhang@mediatek.com>
    net: use sock_gen_put() when sk_state is TCP_TIME_WAIT

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    bnxt_en: fix module unload sequence

Alexander Stein <alexander.stein@ew.tq-group.com>
    ASoC: simple-card-utils: Fix pointer check in graph_util_parse_link_direction

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: sai: add a check on minimal kernel frequency

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: sai: skip useless iterations on kernel rate loop

Alistair Francis <alistair.francis@wdc.com>
    nvmet-tcp: select CONFIG_TLS from CONFIG_NVME_TARGET_TCP_TLS

Alistair Francis <alistair23@gmail.com>
    nvme-tcp: select CONFIG_TLS from CONFIG_NVME_TCP_TLS

Michael Liang <mliang@purestorage.com>
    nvme-tcp: fix premature queue removal and I/O failover

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool -d byte order for 32-bit values

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Fix out-of-bound memcpy() during ethtool -w

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Fix coredump logic to free allocated buffer

Kashyap Desai <kashyap.desai@broadcom.com>
    bnxt_en: call pci_alloc_irq_vectors() after bnxt_reserve_rings()

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Add missing skb_mark_for_recycle() in bnxt_rx_vlan()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix ethtool selftest output in one of the failure cases

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix error handling path in bnxt_init_chip()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix built-mic regression on other ASUS models

Felix Fietkau <nbd@nbd.name>
    net: ipv6: fix UDPv6 GSO segmentation with NAT

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix broken taprio gate states after clock jump

Chad Monroe <chad@monroe.io>
    net: ethernet: mtk_eth_soc: fix SER panic with 4GB+ RAM

Jacob Keller <jacob.e.keller@intel.com>
    igc: fix lock order in igc_ptp_reset

Larysa Zaremba <larysa.zaremba@intel.com>
    idpf: protect shutdown from reset

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    idpf: fix potential memory leak on kcalloc() failure

Da Xue <da@libre.computer>
    net: mdio: mux-meson-gxl: set reversed bit when using internal phy

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Russell Cloran <rcloran@gmail.com>
    drm/mipi-dbi: Fix blanking for non-16 bit formats

Maxime Ripard <mripard@kernel.org>
    drm/tests: shmem: Fix memleak

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix queue unquiesce check on slot_reset

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Fix buffer overflow at UMP SysEx message conversion

Maulik Shah <maulik.shah@oss.qualcomm.com>
    pinctrl: qcom: Fix PINGROUP definition for sm8750

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Fix capture of steering registers

Keoseong Park <keosung.park@samsung.com>
    scsi: ufs: core: Remove redundant query_complete trace

Madhu Chittim <madhu.chittim@intel.com>
    idpf: fix offloads support for encapsulated packets

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix Get Tx Topology AQ command error on E830

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Remove unnecessary ice_is_e8xx() functions

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Don't check device type when checking GNSS presence

Victor Nogueira <victor@mojatatu.com>
    net_sched: qfq: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: ets: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: drr: Fix double list add in class with netem as child qdisc

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: remove write-after-free of client_id

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: specify auxiliary_device to be created

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: make pdsc_auxbus_dev_del() void

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: sync mtk_clks_source_name array

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: fix spinlock recursion issues on rx/tx poll

Justin Lai <justinlai0215@realtek.com>
    rtase: Modify the condition used to detect overflow in rtase_calc_time_mitigation

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    bnxt_en: improve TX timestamping FIFO configuration

Sathesh B Edara <sedara@marvell.com>
    octeon_ep_vf: Resolve netdevice usage count issue

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: copy RX timestamp to new fragments

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add additional to checks to clear TX/RX paths

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: avoid NULL pointer dereference in skb_dequeue()

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Avoid redundant buffer allocation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not setting timeout for BIG Create Sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Receiver

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: ACPI: Re-sync CPU boost state on system resume

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: acpi: Set policy->boost_supported

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Introduce policy->boost_supported flag

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Fix NULL pointer deref in acp_i2s_set_tdm_slot

Raju Rangoju <Raju.Rangoju@amd.com>
    spi: spi-mem: Add fix to avoid divide error

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Correct DCT interrupt handling

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix error handling for enabling roce

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Fix lock order in mlx5e_tx_reporter_ptpsq_unhealthy_recover

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: TC, Continue the attr process even if encap entry is invalid

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5e: Use custom tunnel header for vxlan gbp

e.kubanski <e.kubanski@partner.samsung.com>
    xsk: Fix offset calculation in unaligned mode

e.kubanski <e.kubanski@partner.samsung.com>
    xsk: Fix race condition in AF_XDP generic RX path

Ido Schimmel <idosch@nvidia.com>
    vxlan: vnifilter: Fix unlocked deletion of default FDB entry

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/boot: Fix dash warning

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Remove erroneous assert in plfxlc_mac_release

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix the check for the SCRATCH register upon resume

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: don't warn if the NIC is gone in resume

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: back off on continuous errors

Chen Linxuan <chenlinxuan@uniontech.com>
    drm/i915/pxp: fix undefined reference to `intel_pxp_gsccs_is_ready_for_sessions'

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Enable speaker for HP platform

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    iommu/arm-smmu-v3: Add missing S2FWB feature detection

Chenyuan Yang <chenyuan0y@gmail.com>
    ASoC: Intel: sof_sdw: Add NULL check in asoc_sdw_rt_dmic_rtd_init()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/boot: Check for ld-option support

Hui Wang <hui.wang@canonical.com>
    pinctrl: imx: Return NULL if no group is matched and found

Anthony Iliopoulos <ailiop@suse.com>
    powerpc64/ftrace: fix module loading without patchable function entries

Donet Tom <donettom@linux.ibm.com>
    book3s64/radix : Align section vmemmap start address to PAGE_SIZE

Sheetal <sheetal@nvidia.com>
    ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence

Nico Pache <npache@redhat.com>
    firmware: cs_dsp: tests: Depend on FW_CS_DSP rather then enabling it

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib-test: Don't select SND_SOC_CS_AMP_LIB

Geert Uytterhoeven <geert+renesas@glider.be>
    ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Default IPS to RCG_IN_ACTIVE_IPS2_IN_OFF

Alan Huang <mmpgouride@gmail.com>
    bcachefs: Remove incorrect __counted_by annotation

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix setting policy limits when frequency tables are used

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid using inconsistent policy->min and policy->max

Jethro Donaldson <devel@jro.nz>
    smb: client: fix zero length for mkdir POSIX create context

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in session logoff

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in kerberos authentication

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_session_rpc_open

Shouye Liu <shouyeliu@tencent.com>
    platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU hotplug

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep cycles

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix two issues in iommu_copy_struct_from_user()

Mingcong Bai <jeffbai@aosc.io>
    iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)

Balbir Singh <balbirs@nvidia.com>
    iommu/arm-smmu-v3: Fix pgsize_bit for sva domains

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids

Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
    iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid

Janne Grunau <j@jannau.net>
    drm: Select DRM_KMS_HELPER from DRM_DEBUG_DP_MST_TOPOLOGY_REFS

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix offset for HDP remap in nbio v7.11

Benjamin Marzinski <bmarzins@redhat.com>
    dm: always update the array size in realloc_argv on success

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a warning on invalid table line

LongPing Wei <weilongping@oppo.com>
    dm-bufio: don't schedule in atomic context

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/sev: Support memory acceptance in the EFI stub under SVSM

Wentao Liang <vulab@iscas.ac.cn>
    wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not take trace_event_sem in print_event_fields()

Aaron Kling <webgeek1234@gmail.com>
    spi: tegra114: Don't fail set_cs_timing when delays are zero

Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
    mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe

Wei Yang <richard.weiyang@gmail.com>
    mm/memblock: repeat setting reserved region nid if array is doubled

Wei Yang <richard.weiyang@gmail.com>
    mm/memblock: pass size instead of end to memblock_set_node()

Stephan Gerhold <stephan.gerhold@linaro.org>
    irqchip/qcom-mpm: Prevent crash when trying to handle non-wake GPIOs

Vishal Badole <Vishal.Badole@amd.com>
    amd-xgbe: Fix to ensure dependent features are toggled with RX checksum offload

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: KVM: Mask PEBS_ENABLE loaded for guest with vCPU's value.

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Only check the group flag for X86 leader

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: fix wrong PHY LED mapping and PHY2 LED defines

Helge Deller <deller@gmx.de>
    parisc: Fix double SIGFPE crash

Will Deacon <will@kernel.org>
    arm64: errata: Add missing sentinels to Spectre-BHB MIDR arrays

Clark Wang <xiaoning.wang@nxp.com>
    i2c: imx-lpi2c: Fix clock count when probe defers

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Set DDR and SDMMC interrupt mask before registration

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Test the correct error reg offset

Philipp Stanner <phasta@kernel.org>
    drm/nouveau: Fix WARN_ON in nouveau_fence_context_kill()

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/fdinfo: Protect against driver unbind

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode

Dave Chen <davechen@synology.com>
    btrfs: fix COW handling in run_delalloc_nocow()

Josef Bacik <josef@toxicpanda.com>
    btrfs: adjust subpage bit start based on sectorsize

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Use NOIRQ_SYSTEM_SLEEP_PM_OPS()

Joachim Priesner <joachim.priesner@web.de>
    ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek - Add more HP laptops which need mute led fixup

Christian Heusel <christian@heusel.eu>
    Revert "rndis_host: Flag RNDIS modems as WWAN devices"


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi   |   3 +
 arch/arm64/boot/dts/freescale/imx95.dtsi           |   8 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   9 +-
 arch/arm64/kernel/proton-pack.c                    |   2 +
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/powerpc/boot/wrapper                          |   6 +-
 arch/powerpc/kernel/module_64.c                    |   4 -
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  17 +-
 arch/x86/boot/compressed/mem.c                     |   5 +-
 arch/x86/boot/compressed/sev.c                     |  40 ++
 arch/x86/boot/compressed/sev.h                     |   2 +
 arch/x86/events/core.c                             |   2 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/events/perf_event.h                       |   9 +-
 drivers/accel/ivpu/ivpu_drv.c                      |  32 +-
 drivers/accel/ivpu/ivpu_drv.h                      |   2 +
 drivers/accel/ivpu/ivpu_hw_btrs.h                  |   2 +-
 drivers/accel/ivpu/ivpu_job.c                      | 111 ++++-
 drivers/accel/ivpu/ivpu_job.h                      |   1 +
 drivers/accel/ivpu/ivpu_mmu.c                      |   3 +-
 drivers/accel/ivpu/ivpu_pm.c                       |  18 +-
 drivers/accel/ivpu/ivpu_sysfs.c                    |   5 +-
 drivers/base/module.c                              |  13 +-
 drivers/block/ublk_drv.c                           | 552 +++++++++++----------
 drivers/bluetooth/btintel_pcie.c                   |  57 ++-
 drivers/bluetooth/btusb.c                          | 101 ++--
 drivers/cpufreq/acpi-cpufreq.c                     |  14 +
 drivers/cpufreq/cpufreq.c                          |  42 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |   3 +-
 drivers/cpufreq/freq_table.c                       |  10 +-
 drivers/cpufreq/intel_pstate.c                     |   3 +
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/firmware/arm_ffa/driver.c                  |   3 +-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 drivers/firmware/cirrus/Kconfig                    |   5 +-
 drivers/gpu/drm/Kconfig                            |   2 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c            |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  20 -
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |  56 +--
 drivers/gpu/drm/drm_file.c                         |   6 +
 drivers/gpu/drm/drm_mipi_dbi.c                     |   6 +-
 drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h         |   8 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/gpu/drm/tests/drm_gem_shmem_test.c         |   3 +
 drivers/gpu/drm/xe/instructions/xe_gpu_commands.h  |   1 +
 drivers/gpu/drm/xe/xe_guc_capture.c                |   2 +-
 drivers/gpu/drm/xe/xe_ring_ops.c                   |  13 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/iommu/amd/init.c                           |   8 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   6 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  21 +-
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/md/dm-bufio.c                              |   9 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   5 +-
 drivers/net/ethernet/amd/pds_core/auxbus.c         |  39 +-
 drivers/net/ethernet/amd/pds_core/core.h           |   7 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |   7 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  18 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  30 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  38 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  29 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   1 +
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  82 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  13 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |   5 -
 drivers/net/ethernet/intel/ice/ice_common.c        | 208 ++++----
 drivers/net/ethernet/intel/ice/ice_common.h        |   7 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |  10 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  31 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h          |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 137 ++---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        | 235 +++------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |  11 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   9 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   5 +
 drivers/net/ethernet/intel/idpf/idpf.h             |  18 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  76 ++-
 drivers/net/ethernet/intel/idpf/idpf_main.c        |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   6 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  18 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |  13 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  32 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |   4 +-
 drivers/net/ethernet/vertexcom/mse102x.c           |  36 +-
 drivers/net/mdio/mdio-mux-meson-gxl.c              |   3 +-
 drivers/net/usb/rndis_host.c                       |  16 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  28 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |   1 -
 drivers/nvme/host/Kconfig                          |   1 +
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/tcp.c                            |  31 +-
 drivers/nvme/target/Kconfig                        |   1 +
 drivers/pinctrl/freescale/pinctrl-imx.c            |   6 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c          | 159 +++---
 drivers/pinctrl/qcom/pinctrl-sm8750.c              |   4 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |   7 +-
 drivers/platform/x86/dell/alienware-wmi.c          |   9 +
 .../x86/intel/uncore-frequency/uncore-frequency.c  |  13 +-
 drivers/ptp/ptp_ocp.c                              |  52 +-
 drivers/spi/spi-mem.c                              |   6 +-
 drivers/spi/spi-tegra114.c                         |   6 +-
 drivers/ufs/core/ufshcd.c                          |   2 -
 fs/bcachefs/btree_update_interior.c                |  17 +-
 fs/bcachefs/error.c                                |   8 +
 fs/bcachefs/error.h                                |   2 +
 fs/bcachefs/xattr_format.h                         |   8 +-
 fs/btrfs/btrfs_inode.h                             |   8 +
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/file.c                                    |   1 -
 fs/btrfs/inode.c                                   | 152 +++---
 fs/btrfs/ioctl.c                                   |   1 +
 fs/btrfs/zoned.c                                   |  18 +-
 fs/smb/client/smb2pdu.c                            |   1 +
 fs/smb/server/auth.c                               |  14 +-
 fs/smb/server/mgmt/user_session.c                  |  20 +-
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/smb2pdu.c                            |   9 -
 include/linux/blkdev.h                             |  67 ++-
 include/linux/cpufreq.h                            |  86 ++--
 include/linux/iommu.h                              |   8 +-
 include/linux/module.h                             |   2 +
 include/net/bluetooth/hci.h                        |   4 +-
 include/net/bluetooth/hci_core.h                   |  20 +-
 include/net/bluetooth/hci_sync.h                   |   3 +
 include/net/xdp_sock.h                             |   3 -
 include/net/xsk_buff_pool.h                        |   4 +-
 include/sound/ump_convert.h                        |   2 +-
 kernel/params.c                                    |   6 +-
 kernel/trace/trace.c                               |   5 +-
 kernel/trace/trace_output.c                        |   4 +-
 mm/memblock.c                                      |  12 +-
 mm/slub.c                                          |  27 +-
 net/bluetooth/hci_conn.c                           | 181 +------
 net/bluetooth/hci_event.c                          |  15 +-
 net/bluetooth/hci_sync.c                           | 150 +++++-
 net/bluetooth/iso.c                                |  26 +-
 net/bluetooth/l2cap_core.c                         |   3 +
 net/ipv4/tcp_offload.c                             |   2 +-
 net/ipv4/udp_offload.c                             |  61 ++-
 net/ipv6/tcpv6_offload.c                           |   2 +-
 net/sched/sch_drr.c                                |  16 +-
 net/sched/sch_ets.c                                |  17 +-
 net/sched/sch_hfsc.c                               |  10 +-
 net/sched/sch_htb.c                                |   2 +
 net/sched/sch_qfq.c                                |  18 +-
 net/xdp/xsk.c                                      |   6 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 sound/pci/hda/patch_realtek.c                      |  23 +-
 sound/soc/amd/acp/acp-i2s.c                        |   2 +-
 sound/soc/codecs/Kconfig                           |   5 +-
 sound/soc/generic/simple-card-utils.c              |   4 +-
 sound/soc/renesas/rz-ssi.c                         |   2 +-
 sound/soc/sdw_utils/soc_sdw_rt_dmic.c              |   2 +
 sound/soc/soc-core.c                               |  32 +-
 sound/soc/soc-pcm.c                                |   5 +-
 sound/soc/stm/stm32_sai_sub.c                      |  16 +-
 sound/usb/endpoint.c                               |   7 +
 sound/usb/format.c                                 |   3 +-
 194 files changed, 2373 insertions(+), 1773 deletions(-)


