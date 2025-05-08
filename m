Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423262620DE
	for <patches@lists.linux.dev>; Thu,  8 May 2025 08:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746693519; cv=none; b=UUdPwHWXjxlP74btsRH6BRFBtRRUogPQaktdOpiRZqRTZeI3wDFtUntXxuSAflFdEf1F8SA6AUYGMPGbMK0vbarLpuKmSo5aUhJU05D/Ys5jQr9c+yoBj9IMHK9je24rdVbslJEpUb5BXAW5oOmxrkwhxJlmK9bDbPnkmXG4qoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746693519; c=relaxed/simple;
	bh=9k4Bm74leTnP25Nnqshl6UYRbyjlX5IQz2W0UZ5nDxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fcv1Qj0aWjWjF2QISySV5GcVACOTWihy2FamXrbnBh0impp8cq537mxfIYcgP0yGvUc/KtRA9UjgHSK2PkM3zRV5axHszOo8LpPi70MKWf9xBNNSlFvxbuprIK+4U3WTvt1iuYv0sPlp+4znWZsT1stspJdLQdFK2L8v6FP5nbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgMmeWKc; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgMmeWKc"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-309fac646adso1805405a91.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 01:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746693515; x=1747298315; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odMjhmE2q9IeccJ3MLf6oZFMBh3nkZzx9KAbYs9uzJk=;
        b=JgMmeWKcxSkEWNhUcoPaDVTq0kHOBMT95yDgfjZhNxu6+pjOD/UBZiojWijEhcMV1q
         /2hhc/dPQV/bDjyVJ1Nnq09srPPgrssLx1frzxd9AXljvhOb11uQrMRbAXBQ5QP9aLo9
         jRzn8MUBqfd0NZpE0UKmkOAT1U7zvIqoK6iTjWXLBWRwBQuiS5Ru58+p5V/XhQwLle1L
         /Pi2hLjRoOHhQFnk5kNfAbZgxhqGbkvRjVCeap/KaalkpnTM8GqtSWcwpni1G+dRrQJN
         efnuL6lM8IGsiG87TdBnDGRLYnBfyHMp4heNyLfQPKqXl513TrQVCP2CjE811N9AWgIg
         +9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746693515; x=1747298315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=odMjhmE2q9IeccJ3MLf6oZFMBh3nkZzx9KAbYs9uzJk=;
        b=WCqWlnk5AKE42sIThKILm4YbdxzdnnTlzRyi6eXlLPwnpr/oaXOfQX9HB2Ifbs7j1N
         vXGZniXbjTjSPd5ieXJSsL7Wk53SpGomhKApmGUSlBui2Bl/0dxKrKtYPjMStPIUAhBk
         p68VDhZueL4oX549He0EiimP2OiemZIP8fPbLF3ALQJm9C5Uof3RKcr3Ps9cRnjp9jEq
         iNXoc6HQd4QHzux9gYhD1wYymtUtQ+D1nMG4J2rogJoi3dBv6ZNZlFNB1CkP+KAu1PQe
         TUaJ/+1zjCm7ubuew2E4pvrgzS/mvpLXHutHw7Ul0AevbGkOXpjCndCWA0D9NrV/byFD
         S/PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqQQLL4KBEm63TErfhHmLCjTu7So2ZP6p7k8qt2LYpQW9luGjcgI8+sr41Fbc37DsvLts9nYI5@lists.linux.dev
X-Gm-Message-State: AOJu0YzgJlAJ3jBWig0AMv9kpVxZVM2gw09PsP60QUGJNnZBRQQXBbKF
	ven3g73leI5meL+0LDuILdObKq8FNY/9dXPVLdVbs8F23zpMSRbpetjyJxb6uE03Lq9kvxxMYPC
	sF7JvG6UIjLjZsC9S+qMjMf8lZ+s=
X-Gm-Gg: ASbGncsTLvtJdhZ/hTfJ0x2lH3/82JEwNCkJzxj0xaPE7sszxnRq7mKKzF7vqHtGr46
	lMs/pqIGFEMC7xNwbwhorIO/DZUoD7DPyL6cDU4UhgLJ1gyNjpQ+k9H8yNtlgvK/QzOrdtV3ONy
	JtE6YAJhEiC/g0N5m7qDMo/7S6+8eEZ9Nr82Dw
X-Google-Smtp-Source: AGHT+IHznbTIKxm1RReqn9wTpoJLD9pnMfMpuK1AP6nM31q3RNWjx8yxS6uZkenjkVbE7/7egXeq5JzPy7jtkkjPIW0=
X-Received: by 2002:a17:90b:38c1:b0:2ee:5c9b:35c0 with SMTP id
 98e67ed59e1d1-30adbf2bcacmr3456425a91.9.1746693515144; Thu, 08 May 2025
 01:38:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250507183824.682671926@linuxfoundation.org>
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 8 May 2025 10:38:22 +0200
X-Gm-Features: ATxdqUHfLf6kGhtg8O9udjnaJQXPgx9Vv0vLTnTZQPCVuk0p9lFTvm5SkPSVlYQ
Message-ID: <CADo9pHierZz-kgrJD9_yE1KQxFXvXxkpHmS32Sm6vC_uu3SrRw@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den ons 7 maj 2025 kl 20:50 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.14.6-rc1
>
> Kent Overstreet <kent.overstreet@linux.dev>
>     bcachefs: Change btree_insert_node() assertion to error
>
> Chris Bainbridge <chris.bainbridge@gmail.com>
>     drm/amd/display: Fix slab-use-after-free in hdcp
>
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp
>
> Penglei Jiang <superman.xpt@gmail.com>
>     btrfs: fix the inode leak in btrfs_iget()
>
> David Sterba <dsterba@suse.com>
>     btrfs: pass struct btrfs_inode to btrfs_iget_locked()
>
> David Sterba <dsterba@suse.com>
>     btrfs: pass struct btrfs_inode to btrfs_read_locked_inode()
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: expose per-inode stable writes flag
>
> Shyam Saini <shyamsaini@linux.microsoft.com>
>     drivers: base: handle module_kobject creation
>
> Shyam Saini <shyamsaini@linux.microsoft.com>
>     kernel: globalize lookup_or_create_module_kobject()
>
> Shyam Saini <shyamsaini@linux.microsoft.com>
>     kernel: param: rename locate_module_kobject
>
> Naohiro Aota <naohiro.aota@wdc.com>
>     btrfs: zoned: skip reporting zone for new block group
>
> Naohiro Aota <naohiro.aota@wdc.com>
>     block: introduce zone capacity helper
>
> Christian Bruel <christian.bruel@foss.st.com>
>     arm64: dts: st: Use 128kB size for aliased GIC400 register access on =
stm32mp25 SoCs
>
> Christian Bruel <christian.bruel@foss.st.com>
>     arm64: dts: st: Adjust interrupt-controller for stm32mp25 SoCs
>
> S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.com>
>     ARM: dts: opos6ul: add ksz8081 phy properties
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     arm64: dts: imx95: Correct the range of PCIe app-reg region
>
> Sudeep Holla <sudeep.holla@arm.com>
>     firmware: arm_ffa: Skip Rx buffer ownership release if not acquired
>
> Cristian Marussi <cristian.marussi@arm.com>
>     firmware: arm_scmi: Balance device refcount when destroying devices
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     sch_ets: make est_qlen_notify() idempotent
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     sch_qfq: make qfq_qlen_notify() idempotent
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     sch_hfsc: make hfsc_qlen_notify() idempotent
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     sch_drr: make drr_qlen_notify() idempotent
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     sch_htb: make htb_qlen_notify() idempotent
>
> Ming Lei <ming.lei@redhat.com>
>     ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_=
cmd
>
> Ming Lei <ming.lei@redhat.com>
>     ublk: simplify aborting ublk request
>
> Ming Lei <ming.lei@redhat.com>
>     ublk: remove __ublk_quiesce_dev()
>
> Uday Shankar <ushankar@purestorage.com>
>     ublk: improve detection and handling of ublk server exit
>
> Ming Lei <ming.lei@redhat.com>
>     ublk: move device reset into ublk_ch_release()
>
> Uday Shankar <ushankar@purestorage.com>
>     ublk: properly serialize all FETCH_REQs
>
> Ming Lei <ming.lei@redhat.com>
>     ublk: add helper of ublk_need_map_io()
>
> Kurt Borja <kuurtb@gmail.com>
>     platform/x86: alienware-wmi-wmax: Add support for Alienware m15 R7
>
> Kenneth Graunke <kenneth@whitecape.org>
>     drm/xe: Invalidate L3 read-only cachelines for geometry streams too
>
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Add handling of VPU_JSM_STATUS_MVNCI_CONTEXT_VIOLATION_HW
>
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Fix locking order in ivpu_job_submit
>
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Abort all jobs after command queue unregister
>
> Zhenhua Huang <quic_zhenhuah@quicinc.com>
>     mm, slab: clean up slab->obj_exts always
>
> Stefan Wahren <wahrenst@gmx.net>
>     net: vertexcom: mse102x: Fix RX error handling
>
> Stefan Wahren <wahrenst@gmx.net>
>     net: vertexcom: mse102x: Add range check for CMD_RTS
>
> Stefan Wahren <wahrenst@gmx.net>
>     net: vertexcom: mse102x: Fix LEN_MASK
>
> Stefan Wahren <wahrenst@gmx.net>
>     net: vertexcom: mse102x: Fix possible stuck of SPI interrupt
>
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: defer calling ptp_clock_register()
>
> Hao Lan <lanhao@huawei.com>
>     net: hns3: fixed debugfs tm_qset size
>
> Yonglong Liu <liuyonglong@huawei.com>
>     net: hns3: fix an interrupt residual problem
>
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: store rx VLAN tag offload state for VF
>
> Sathesh B Edara <sedara@marvell.com>
>     octeon_ep: Fix host hang issue during device reboot
>
> Mattias Barthel <mattias.barthel@atlascopco.com>
>     net: fec: ERR007885 Workaround for conventional TX
>
> Thangaraj Samynathan <thangaraj.s@microchip.com>
>     net: lan743x: Fix memleak issue when GSO enabled
>
> Sagi Maimon <sagi.maimon@adtran.com>
>     ptp: ocp: Fix NULL dereference in Adva board SMA sysfs operations
>
> Jibin Zhang <jibin.zhang@mediatek.com>
>     net: use sock_gen_put() when sk_state is TCP_TIME_WAIT
>
> Vadim Fedorenko <vadim.fedorenko@linux.dev>
>     bnxt_en: fix module unload sequence
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     ASoC: simple-card-utils: Fix pointer check in graph_util_parse_link_d=
irection
>
> Olivier Moysan <olivier.moysan@foss.st.com>
>     ASoC: stm32: sai: add a check on minimal kernel frequency
>
> Olivier Moysan <olivier.moysan@foss.st.com>
>     ASoC: stm32: sai: skip useless iterations on kernel rate loop
>
> Alistair Francis <alistair.francis@wdc.com>
>     nvmet-tcp: select CONFIG_TLS from CONFIG_NVME_TARGET_TCP_TLS
>
> Alistair Francis <alistair23@gmail.com>
>     nvme-tcp: select CONFIG_TLS from CONFIG_NVME_TCP_TLS
>
> Michael Liang <mliang@purestorage.com>
>     nvme-tcp: fix premature queue removal and I/O failover
>
> Michael Chan <michael.chan@broadcom.com>
>     bnxt_en: Fix ethtool -d byte order for 32-bit values
>
> Shruti Parab <shruti.parab@broadcom.com>
>     bnxt_en: Fix out-of-bound memcpy() during ethtool -w
>
> Shruti Parab <shruti.parab@broadcom.com>
>     bnxt_en: Fix coredump logic to free allocated buffer
>
> Kashyap Desai <kashyap.desai@broadcom.com>
>     bnxt_en: call pci_alloc_irq_vectors() after bnxt_reserve_rings()
>
> Somnath Kotur <somnath.kotur@broadcom.com>
>     bnxt_en: Add missing skb_mark_for_recycle() in bnxt_rx_vlan()
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     bnxt_en: Fix ethtool selftest output in one of the failure cases
>
> Shravya KN <shravya.k-n@broadcom.com>
>     bnxt_en: Fix error handling path in bnxt_init_chip()
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Fix built-mic regression on other ASUS models
>
> Felix Fietkau <nbd@nbd.name>
>     net: ipv6: fix UDPv6 GSO segmentation with NAT
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: dsa: felix: fix broken taprio gate states after clock jump
>
> Chad Monroe <chad@monroe.io>
>     net: ethernet: mtk_eth_soc: fix SER panic with 4GB+ RAM
>
> Jacob Keller <jacob.e.keller@intel.com>
>     igc: fix lock order in igc_ptp_reset
>
> Larysa Zaremba <larysa.zaremba@intel.com>
>     idpf: protect shutdown from reset
>
> Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>     idpf: fix potential memory leak on kcalloc() failure
>
> Da Xue <da@libre.computer>
>     net: mdio: mux-meson-gxl: set reversed bit when using internal phy
>
> Simon Horman <horms@kernel.org>
>     net: dlink: Correct endianness handling of led_mode
>
> Russell Cloran <rcloran@gmail.com>
>     drm/mipi-dbi: Fix blanking for non-16 bit formats
>
> Maxime Ripard <mripard@kernel.org>
>     drm/tests: shmem: Fix memleak
>
> Keith Busch <kbusch@kernel.org>
>     nvme-pci: fix queue unquiesce check on slot_reset
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: ump: Fix buffer overflow at UMP SysEx message conversion
>
> Maulik Shah <maulik.shah@oss.qualcomm.com>
>     pinctrl: qcom: Fix PINGROUP definition for sm8750
>
> John Harrison <John.C.Harrison@Intel.com>
>     drm/xe/guc: Fix capture of steering registers
>
> Keoseong Park <keosung.park@samsung.com>
>     scsi: ufs: core: Remove redundant query_complete trace
>
> Madhu Chittim <madhu.chittim@intel.com>
>     idpf: fix offloads support for encapsulated packets
>
> Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>     ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()
>
> Paul Greenwalt <paul.greenwalt@intel.com>
>     ice: fix Get Tx Topology AQ command error on E830
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Remove unnecessary ice_is_e8xx() functions
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Don't check device type when checking GNSS presence
>
> Victor Nogueira <victor@mojatatu.com>
>     net_sched: qfq: Fix double list add in class with netem as child qdis=
c
>
> Victor Nogueira <victor@mojatatu.com>
>     net_sched: ets: Fix double list add in class with netem as child qdis=
c
>
> Victor Nogueira <victor@mojatatu.com>
>     net_sched: hfsc: Fix a UAF vulnerability in class with netem as child=
 qdisc
>
> Victor Nogueira <victor@mojatatu.com>
>     net_sched: drr: Fix double list add in class with netem as child qdis=
c
>
> Shannon Nelson <shannon.nelson@amd.com>
>     pds_core: remove write-after-free of client_id
>
> Shannon Nelson <shannon.nelson@amd.com>
>     pds_core: specify auxiliary_device to be created
>
> Shannon Nelson <shannon.nelson@amd.com>
>     pds_core: make pdsc_auxbus_dev_del() void
>
> Daniel Golle <daniel@makrotopia.org>
>     net: ethernet: mtk_eth_soc: sync mtk_clks_source_name array
>
> Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
>     net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when a=
dvised
>
> Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
>     net: ethernet: mtk-star-emac: fix spinlock recursion issues on rx/tx =
poll
>
> Justin Lai <justinlai0215@realtek.com>
>     rtase: Modify the condition used to detect overflow in rtase_calc_tim=
e_mitigation
>
> Vadim Fedorenko <vadim.fedorenko@linux.dev>
>     bnxt_en: improve TX timestamping FIFO configuration
>
> Sathesh B Edara <sedara@marvell.com>
>     octeon_ep_vf: Resolve netdevice usage count issue
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID
>
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: L2CAP: copy RX timestamp to new fragments
>
> Kiran K <kiran.k@intel.com>
>     Bluetooth: btintel_pcie: Add additional to checks to clear TX/RX path=
s
>
> En-Wei Wu <en-wei.wu@canonical.com>
>     Bluetooth: btusb: avoid NULL pointer dereference in skb_dequeue()
>
> Kiran K <kiran.k@intel.com>
>     Bluetooth: btintel_pcie: Avoid redundant buffer allocation
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_conn: Fix not setting timeout for BIG Create Sync
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Recei=
ver
>
> Viresh Kumar <viresh.kumar@linaro.org>
>     cpufreq: ACPI: Re-sync CPU boost state on system resume
>
> Viresh Kumar <viresh.kumar@linaro.org>
>     cpufreq: acpi: Set policy->boost_supported
>
> Viresh Kumar <viresh.kumar@linaro.org>
>     cpufreq: Introduce policy->boost_supported flag
>
> Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
>     ASoC: amd: acp: Fix NULL pointer deref in acp_i2s_set_tdm_slot
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     spi: spi-mem: Add fix to avoid divide error
>
> Karol Wachowski <karol.wachowski@intel.com>
>     accel/ivpu: Correct DCT interrupt handling
>
> Chris Mi <cmi@nvidia.com>
>     net/mlx5: E-switch, Fix error handling for enabling roce
>
> Cosmin Ratiu <cratiu@nvidia.com>
>     net/mlx5e: Fix lock order in mlx5e_tx_reporter_ptpsq_unhealthy_recove=
r
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: TC, Continue the attr process even if encap entry is inval=
id
>
> Maor Gottlieb <maorg@nvidia.com>
>     net/mlx5: E-Switch, Initialize MAC Address for Default GID
>
> Vlad Dogaru <vdogaru@nvidia.com>
>     net/mlx5e: Use custom tunnel header for vxlan gbp
>
> e.kubanski <e.kubanski@partner.samsung.com>
>     xsk: Fix offset calculation in unaligned mode
>
> e.kubanski <e.kubanski@partner.samsung.com>
>     xsk: Fix race condition in AF_XDP generic RX path
>
> Ido Schimmel <idosch@nvidia.com>
>     vxlan: vnifilter: Fix unlocked deletion of default FDB entry
>
> Madhavan Srinivasan <maddy@linux.ibm.com>
>     powerpc/boot: Fix dash warning
>
> Murad Masimov <m.masimov@mt-integration.ru>
>     wifi: plfxlc: Remove erroneous assert in plfxlc_mac_release
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: fix the check for the SCRATCH register upon resume
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: don't warn if the NIC is gone in resume
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: iwlwifi: back off on continuous errors
>
> Chen Linxuan <chenlinxuan@uniontech.com>
>     drm/i915/pxp: fix undefined reference to `intel_pxp_gsccs_is_ready_fo=
r_sessions'
>
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek - Enable speaker for HP platform
>
> Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>     iommu/arm-smmu-v3: Add missing S2FWB feature detection
>
> Chenyuan Yang <chenyuan0y@gmail.com>
>     ASoC: Intel: sof_sdw: Add NULL check in asoc_sdw_rt_dmic_rtd_init()
>
> Madhavan Srinivasan <maddy@linux.ibm.com>
>     powerpc/boot: Check for ld-option support
>
> Hui Wang <hui.wang@canonical.com>
>     pinctrl: imx: Return NULL if no group is matched and found
>
> Anthony Iliopoulos <ailiop@suse.com>
>     powerpc64/ftrace: fix module loading without patchable function entri=
es
>
> Donet Tom <donettom@linux.ibm.com>
>     book3s64/radix : Align section vmemmap start address to PAGE_SIZE
>
> Sheetal <sheetal@nvidia.com>
>     ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence
>
> Nico Pache <npache@redhat.com>
>     firmware: cs_dsp: tests: Depend on FW_CS_DSP rather then enabling it
>
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs-amp-lib-test: Don't select SND_SOC_CS_AMP_LIB
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     ASoC: soc-core: Stop using of_property_read_bool() for non-boolean pr=
operties
>
> Leo Li <sunpeng.li@amd.com>
>     drm/amd/display: Default IPS to RCG_IN_ACTIVE_IPS2_IN_OFF
>
> Alan Huang <mmpgouride@gmail.com>
>     bcachefs: Remove incorrect __counted_by annotation
>
> Jeongjun Park <aha310510@gmail.com>
>     tracing: Fix oob write in trace_seq_to_buffer()
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: Fix setting policy limits when frequency tables are used
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: Avoid using inconsistent policy->min and policy->max
>
> Jethro Donaldson <devel@jro.nz>
>     smb: client: fix zero length for mkdir POSIX create context
>
> Sean Heelan <seanheelan@gmail.com>
>     ksmbd: fix use-after-free in session logoff
>
> Sean Heelan <seanheelan@gmail.com>
>     ksmbd: fix use-after-free in kerberos authentication
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix use-after-free in ksmbd_session_rpc_open
>
> Shouye Liu <shouyeliu@tencent.com>
>     platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU h=
otplug
>
> Mario Limonciello <mario.limonciello@amd.com>
>     platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep =
cycles
>
> Nicolin Chen <nicolinc@nvidia.com>
>     iommu: Fix two issues in iommu_copy_struct_from_user()
>
> Mingcong Bai <jeffbai@aosc.io>
>     iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)
>
> Balbir Singh <balbirs@nvidia.com>
>     iommu/arm-smmu-v3: Fix pgsize_bit for sva domains
>
> Nicolin Chen <nicolinc@nvidia.com>
>     iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated strea=
m ids
>
> Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
>     iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
>
> Janne Grunau <j@jannau.net>
>     drm: Select DRM_KMS_HELPER from DRM_DEBUG_DP_MST_TOPOLOGY_REFS
>
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: Fix offset for HDP remap in nbio v7.11
>
> Benjamin Marzinski <bmarzins@redhat.com>
>     dm: always update the array size in realloc_argv on success
>
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-integrity: fix a warning on invalid table line
>
> LongPing Wei <weilongping@oppo.com>
>     dm-bufio: don't schedule in atomic context
>
> Ard Biesheuvel <ardb@kernel.org>
>     x86/boot/sev: Support memory acceptance in the EFI stub under SVSM
>
> Wentao Liang <vulab@iscas.ac.cn>
>     wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage=
()
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Do not take trace_event_sem in print_event_fields()
>
> Aaron Kling <webgeek1234@gmail.com>
>     spi: tegra114: Don't fail set_cs_timing when delays are zero
>
> Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
>     mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe
>
> Wei Yang <richard.weiyang@gmail.com>
>     mm/memblock: repeat setting reserved region nid if array is doubled
>
> Wei Yang <richard.weiyang@gmail.com>
>     mm/memblock: pass size instead of end to memblock_set_node()
>
> Stephan Gerhold <stephan.gerhold@linaro.org>
>     irqchip/qcom-mpm: Prevent crash when trying to handle non-wake GPIOs
>
> Vishal Badole <Vishal.Badole@amd.com>
>     amd-xgbe: Fix to ensure dependent features are toggled with RX checks=
um offload
>
> Sean Christopherson <seanjc@google.com>
>     perf/x86/intel: KVM: Mask PEBS_ENABLE loaded for guest with vCPU's va=
lue.
>
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel: Only check the group flag for X86 leader
>
> Christian Marangi <ansuelsmth@gmail.com>
>     pinctrl: airoha: fix wrong PHY LED mapping and PHY2 LED defines
>
> Helge Deller <deller@gmx.de>
>     parisc: Fix double SIGFPE crash
>
> Will Deacon <will@kernel.org>
>     arm64: errata: Add missing sentinels to Spectre-BHB MIDR arrays
>
> Clark Wang <xiaoning.wang@nxp.com>
>     i2c: imx-lpi2c: Fix clock count when probe defers
>
> Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
>     EDAC/altera: Set DDR and SDMMC interrupt mask before registration
>
> Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
>     EDAC/altera: Test the correct error reg offset
>
> Philipp Stanner <phasta@kernel.org>
>     drm/nouveau: Fix WARN_ON in nouveau_fence_context_kill()
>
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     drm/fdinfo: Protect against driver unbind
>
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode
>
> Dave Chen <davechen@synology.com>
>     btrfs: fix COW handling in run_delalloc_nocow()
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: adjust subpage bit start based on sectorsize
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     ASoC: renesas: rz-ssi: Use NOIRQ_SYSTEM_SLEEP_PM_OPS()
>
> Joachim Priesner <joachim.priesner@web.de>
>     ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset
>
> Geoffrey D. Bennett <g@b4.vu>
>     ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()
>
> Chris Chiu <chris.chiu@canonical.com>
>     ALSA: hda/realtek - Add more HP laptops which need mute led fixup
>
> Christian Heusel <christian@heusel.eu>
>     Revert "rndis_host: Flag RNDIS modems as WWAN devices"
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  .../boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi   |   3 +
>  arch/arm64/boot/dts/freescale/imx95.dtsi           |   8 +-
>  arch/arm64/boot/dts/st/stm32mp251.dtsi             |   9 +-
>  arch/arm64/kernel/proton-pack.c                    |   2 +
>  arch/parisc/math-emu/driver.c                      |  16 +-
>  arch/powerpc/boot/wrapper                          |   6 +-
>  arch/powerpc/kernel/module_64.c                    |   4 -
>  arch/powerpc/mm/book3s64/radix_pgtable.c           |  17 +-
>  arch/x86/boot/compressed/mem.c                     |   5 +-
>  arch/x86/boot/compressed/sev.c                     |  40 ++
>  arch/x86/boot/compressed/sev.h                     |   2 +
>  arch/x86/events/core.c                             |   2 +-
>  arch/x86/events/intel/core.c                       |   2 +-
>  arch/x86/events/perf_event.h                       |   9 +-
>  drivers/accel/ivpu/ivpu_drv.c                      |  32 +-
>  drivers/accel/ivpu/ivpu_drv.h                      |   2 +
>  drivers/accel/ivpu/ivpu_hw_btrs.h                  |   2 +-
>  drivers/accel/ivpu/ivpu_job.c                      | 111 ++++-
>  drivers/accel/ivpu/ivpu_job.h                      |   1 +
>  drivers/accel/ivpu/ivpu_mmu.c                      |   3 +-
>  drivers/accel/ivpu/ivpu_pm.c                       |  18 +-
>  drivers/accel/ivpu/ivpu_sysfs.c                    |   5 +-
>  drivers/base/module.c                              |  13 +-
>  drivers/block/ublk_drv.c                           | 552 +++++++++++----=
------
>  drivers/bluetooth/btintel_pcie.c                   |  57 ++-
>  drivers/bluetooth/btusb.c                          | 101 ++--
>  drivers/cpufreq/acpi-cpufreq.c                     |  14 +
>  drivers/cpufreq/cpufreq.c                          |  42 +-
>  drivers/cpufreq/cpufreq_ondemand.c                 |   3 +-
>  drivers/cpufreq/freq_table.c                       |  10 +-
>  drivers/cpufreq/intel_pstate.c                     |   3 +
>  drivers/edac/altera_edac.c                         |   9 +-
>  drivers/edac/altera_edac.h                         |   2 +
>  drivers/firmware/arm_ffa/driver.c                  |   3 +-
>  drivers/firmware/arm_scmi/bus.c                    |   3 +
>  drivers/firmware/cirrus/Kconfig                    |   5 +-
>  drivers/gpu/drm/Kconfig                            |   2 +-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c            |   2 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  20 -
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |  56 +--
>  drivers/gpu/drm/drm_file.c                         |   6 +
>  drivers/gpu/drm/drm_mipi_dbi.c                     |   6 +-
>  drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h         |   8 +-
>  drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
>  drivers/gpu/drm/tests/drm_gem_shmem_test.c         |   3 +
>  drivers/gpu/drm/xe/instructions/xe_gpu_commands.h  |   1 +
>  drivers/gpu/drm/xe/xe_guc_capture.c                |   2 +-
>  drivers/gpu/drm/xe/xe_ring_ops.c                   |  13 +-
>  drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
>  drivers/iommu/amd/init.c                           |   8 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   6 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  21 +-
>  drivers/iommu/intel/iommu.c                        |   4 +-
>  drivers/irqchip/irq-qcom-mpm.c                     |   3 +
>  drivers/md/dm-bufio.c                              |   9 +-
>  drivers/md/dm-integrity.c                          |   2 +-
>  drivers/md/dm-table.c                              |   5 +-
>  drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c             |   5 +-
>  drivers/net/ethernet/amd/pds_core/auxbus.c         |  39 +-
>  drivers/net/ethernet/amd/pds_core/core.h           |   7 +-
>  drivers/net/ethernet/amd/pds_core/devlink.c        |   7 +-
>  drivers/net/ethernet/amd/pds_core/main.c           |  11 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
>  drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  18 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  30 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  38 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  29 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   1 +
>  drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
>  drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
>  drivers/net/ethernet/freescale/fec_main.c          |   7 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  82 ++-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  13 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
>  drivers/net/ethernet/intel/ice/ice.h               |   5 -
>  drivers/net/ethernet/intel/ice/ice_common.c        | 208 ++++----
>  drivers/net/ethernet/intel/ice/ice_common.h        |   7 +-
>  drivers/net/ethernet/intel/ice/ice_ddp.c           |  10 +-
>  drivers/net/ethernet/intel/ice/ice_gnss.c          |  31 +-
>  drivers/net/ethernet/intel/ice/ice_gnss.h          |   4 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.c           | 137 ++---
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c        | 235 +++------
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |  11 +-
>  drivers/net/ethernet/intel/ice/ice_type.h          |   9 -
>  drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   5 +
>  drivers/net/ethernet/intel/idpf/idpf.h             |  18 +-
>  drivers/net/ethernet/intel/idpf/idpf_lib.c         |  76 ++-
>  drivers/net/ethernet/intel/idpf/idpf_main.c        |   1 +
>  drivers/net/ethernet/intel/igc/igc_ptp.c           |   6 +-
>  .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
>  .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |   4 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  18 +-
>  drivers/net/ethernet/mediatek/mtk_star_emac.c      |  13 +-
>  .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   6 +-
>  .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  32 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   5 +-
>  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
>  drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  11 +-
>  drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
>  drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
>  drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
>  drivers/net/ethernet/mscc/ocelot.c                 |   6 +
>  drivers/net/ethernet/realtek/rtase/rtase_main.c    |   4 +-
>  drivers/net/ethernet/vertexcom/mse102x.c           |  36 +-
>  drivers/net/mdio/mdio-mux-meson-gxl.c              |   3 +-
>  drivers/net/usb/rndis_host.c                       |  16 +-
>  drivers/net/vxlan/vxlan_vnifilter.c                |   8 +-
>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  28 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   7 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  24 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   9 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  16 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +-
>  drivers/net/wireless/purelifi/plfxlc/mac.c         |   1 -
>  drivers/nvme/host/Kconfig                          |   1 +
>  drivers/nvme/host/pci.c                            |   2 +-
>  drivers/nvme/host/tcp.c                            |  31 +-
>  drivers/nvme/target/Kconfig                        |   1 +
>  drivers/pinctrl/freescale/pinctrl-imx.c            |   6 +-
>  drivers/pinctrl/mediatek/pinctrl-airoha.c          | 159 +++---
>  drivers/pinctrl/qcom/pinctrl-sm8750.c              |   4 +-
>  drivers/platform/x86/amd/pmc/pmc.c                 |   7 +-
>  drivers/platform/x86/dell/alienware-wmi.c          |   9 +
>  .../x86/intel/uncore-frequency/uncore-frequency.c  |  13 +-
>  drivers/ptp/ptp_ocp.c                              |  52 +-
>  drivers/spi/spi-mem.c                              |   6 +-
>  drivers/spi/spi-tegra114.c                         |   6 +-
>  drivers/ufs/core/ufshcd.c                          |   2 -
>  fs/bcachefs/btree_update_interior.c                |  17 +-
>  fs/bcachefs/error.c                                |   8 +
>  fs/bcachefs/error.h                                |   2 +
>  fs/bcachefs/xattr_format.h                         |   8 +-
>  fs/btrfs/btrfs_inode.h                             |   8 +
>  fs/btrfs/extent_io.c                               |   2 +-
>  fs/btrfs/file.c                                    |   1 -
>  fs/btrfs/inode.c                                   | 152 +++---
>  fs/btrfs/ioctl.c                                   |   1 +
>  fs/btrfs/zoned.c                                   |  18 +-
>  fs/smb/client/smb2pdu.c                            |   1 +
>  fs/smb/server/auth.c                               |  14 +-
>  fs/smb/server/mgmt/user_session.c                  |  20 +-
>  fs/smb/server/mgmt/user_session.h                  |   1 +
>  fs/smb/server/smb2pdu.c                            |   9 -
>  include/linux/blkdev.h                             |  67 ++-
>  include/linux/cpufreq.h                            |  86 ++--
>  include/linux/iommu.h                              |   8 +-
>  include/linux/module.h                             |   2 +
>  include/net/bluetooth/hci.h                        |   4 +-
>  include/net/bluetooth/hci_core.h                   |  20 +-
>  include/net/bluetooth/hci_sync.h                   |   3 +
>  include/net/xdp_sock.h                             |   3 -
>  include/net/xsk_buff_pool.h                        |   4 +-
>  include/sound/ump_convert.h                        |   2 +-
>  kernel/params.c                                    |   6 +-
>  kernel/trace/trace.c                               |   5 +-
>  kernel/trace/trace_output.c                        |   4 +-
>  mm/memblock.c                                      |  12 +-
>  mm/slub.c                                          |  27 +-
>  net/bluetooth/hci_conn.c                           | 181 +------
>  net/bluetooth/hci_event.c                          |  15 +-
>  net/bluetooth/hci_sync.c                           | 150 +++++-
>  net/bluetooth/iso.c                                |  26 +-
>  net/bluetooth/l2cap_core.c                         |   3 +
>  net/ipv4/tcp_offload.c                             |   2 +-
>  net/ipv4/udp_offload.c                             |  61 ++-
>  net/ipv6/tcpv6_offload.c                           |   2 +-
>  net/sched/sch_drr.c                                |  16 +-
>  net/sched/sch_ets.c                                |  17 +-
>  net/sched/sch_hfsc.c                               |  10 +-
>  net/sched/sch_htb.c                                |   2 +
>  net/sched/sch_qfq.c                                |  18 +-
>  net/xdp/xsk.c                                      |   6 +-
>  net/xdp/xsk_buff_pool.c                            |   1 +
>  sound/pci/hda/patch_realtek.c                      |  23 +-
>  sound/soc/amd/acp/acp-i2s.c                        |   2 +-
>  sound/soc/codecs/Kconfig                           |   5 +-
>  sound/soc/generic/simple-card-utils.c              |   4 +-
>  sound/soc/renesas/rz-ssi.c                         |   2 +-
>  sound/soc/sdw_utils/soc_sdw_rt_dmic.c              |   2 +
>  sound/soc/soc-core.c                               |  32 +-
>  sound/soc/soc-pcm.c                                |   5 +-
>  sound/soc/stm/stm32_sai_sub.c                      |  16 +-
>  sound/usb/endpoint.c                               |   7 +
>  sound/usb/format.c                                 |   3 +-
>  194 files changed, 2373 insertions(+), 1773 deletions(-)
>
>
>
