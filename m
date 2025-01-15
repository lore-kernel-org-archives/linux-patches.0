Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F436248BDB
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 11:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736941822; cv=none; b=JmaFOeJBFj3XGJGoJjuaDHKs+YpZSkSWPLzbe0qlf5cI2+LuWDbWcZ26viKZ0pRAl8fcKtZr/neb5KSQn3rBqL0yFHelolpOq7kht6leUj/owbt7Tmt7mkx5iAx4r6Rx60fetey8zo10EKBBjHdnp4ULoeHlGG1HBR0UPCG5R/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736941822; c=relaxed/simple;
	bh=2vQvBczTWw4TpKx9HGYBgFlU4xOCQb6UbPuqmzT/gEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sq0E1paJHNVn0/hhTpUHgN+DycghlZyfAUAPaXVKQh6tHpOsBucV81MWrRgDMAPPsoBQf7eP2McgMAXPt65o3IoW3OuYGnDNj4HptriBuvnuWQsLNTv1SnFvMeWxTn4blXRdy03yj4yknwyxi5KHcOXOci67Yf3c+9MgM76/wHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfNsFt6F; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfNsFt6F"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2163dc5155fso120432385ad.0
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 03:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736941819; x=1737546619; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YC9Efgxb3Jnvpdp36p1eIst5jXn+GFRWR23xe28ZD8=;
        b=PfNsFt6FN+4pP7F8LSgU/wNNfzEZecTlyMFmTVbstjDPHzpl+aVtsFIHprnOIZamtH
         gfkwdTTG6ozVRXC+UFoKa70GUigwRQicVi3ZlmVOkslB+LeDQlHLKOG9vQhNGaWBmBoS
         AYuarPVFWIXjCOVrzMxmz+V6sSLu5hLCxISCfyU+YWJmxclTzyhbVjav7dB4Kx2u262A
         J5tBoXbUmXnHYZqISBe0EahGUEJwvWOJDqLisqOrtHChZ4qiqDIoKUpWom09epSf9Tnk
         Pi13dd5GDSGZRebZMdsn/1FfuAp9S0ISYC6RRLkIHqyll0BuJV4WDYJAAZD/nvg9wsc8
         2Z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736941819; x=1737546619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YC9Efgxb3Jnvpdp36p1eIst5jXn+GFRWR23xe28ZD8=;
        b=lDVDXj59hqHUPYytUW/VplWKw5E+VESTSzh90ApkE6cUYambDXZSNohCdDoocIL2ej
         T35G5IJCXerUPE6fm4iRxfo+8U35XD/BPXbOe+yUorqi11zg6B5U8L2pnnNeHxOTjQXm
         zHbcOIPpwZJ68Rl3TQj7R881+mQjt+jhY+RHz/KgRVhpOp5LpKzMFD4g0+Gt3tCdxt+l
         9b9i967qAb9W3kz0JSwrfOtKB0K7QvhcuC6wPXNGLFsvxT+JukXH0p/LzYmEMNHjBkem
         wnmp9E5noTbFBmFWz+cfLOPxJxKR0LiCHkEWN4XfeY6qQvVT+K7yqNIuySjZUD2USSqD
         jkfw==
X-Forwarded-Encrypted: i=1; AJvYcCX1G1jPxL+ka6GqDYjaZXUeBO8h4USCaJn5Vqod4GElpA+QuN5/vDzXMje2ok/n4HeCsnGGhqv3@lists.linux.dev
X-Gm-Message-State: AOJu0YyvilS2X9nw439xk3FOZYMqADFq7ylYxNfPY2BXhDvXwKag3aGi
	ChD3PeLWddkumks3WpmA3yEZv45zB+DCPcuKB2wqmaqVUTeyK8AWBgoOAs6dhJLzDvFCQXG1K5M
	wM+U4h417XXWrtODE0vIq9YfO5Es=
X-Gm-Gg: ASbGnct6DsS/cGvSGLGQB7SswEAVEi++I3ShnFobu9Dg8LZxAAXsa2nMTXYLiziCLAJ
	rSB6OUF2sol3fDNbMWdy09YGcupMLMVRvFWnLfx4MgVZZv/ImWCQY
X-Google-Smtp-Source: AGHT+IEvzYRItsNtK9ke/m1UFZIZ4DOt0LYIlxTnXl5okZTdq9mnMEEsqa9qtG1KulFCoFQ8Z2fzzTkz4SPV355HpnU=
X-Received: by 2002:a17:90a:d00b:b0:2ea:4578:46d8 with SMTP id
 98e67ed59e1d1-2f548eb9e19mr42505809a91.9.1736941818618; Wed, 15 Jan 2025
 03:50:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103606.357764746@linuxfoundation.org>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 15 Jan 2025 12:50:06 +0100
X-Gm-Features: AbW1kvb5rhHCFNsAi_EneZFXd63-gjiZ0vo15nWB6UQ886kFCaxoltHoKoV6Qvc
Message-ID: <CADo9pHiPFOGUiYBrUDCejkBek8eRq_NgPmSbM5S0d9YPajqjHw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

Den ons 15 jan. 2025 kl 11:45 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
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
>     Linux 6.12.10-rc1
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev: prevent accessing NAPI instances from another namespace
>
> Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
>     iio: imu: inv_icm42600: fix spi burst write not supported
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: don't touch sqd->thread off tw add
>
> Daniel Golle <daniel@makrotopia.org>
>     drm/mediatek: Only touch DISP_REG_OVL_PITCH_MSB if AFBC is supported
>
> Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
>     xe/oa: Fix query mode of operation for OAR/OAC
>
> Ashutosh Dixit <ashutosh.dixit@intel.com>
>     drm/xe/oa: Add input fence dependencies
>
> Ashutosh Dixit <ashutosh.dixit@intel.com>
>     drm/xe/oa/uapi: Define and parse OA sync properties
>
> Ashutosh Dixit <ashutosh.dixit@intel.com>
>     drm/xe/oa: Separate batch submission from waiting for completion
>
> guanjing <guanjing@cmss.chinamobile.com>
>     firewall: remove misplaced semicolon from stm32_firewall_get_firewall
>
> Peter Geis <pgwipeout@gmail.com>
>     arm64: dts: rockchip: add hevc power domain clock to rk3328
>
> Yu Kuai <yukuai3@huawei.com>
>     block, bfq: fix waker_bfqq UAF after bfq_split_bfqq()
>
> Daniil Stas <daniil.stas@posteo.net>
>     hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors=
 occur
>
> Jie Gan <quic_jiegan@quicinc.com>
>     arm64: dts: qcom: sa8775p: fix the secure device bootup issue
>
> Jesse Taube <Mr.Bossman075@gmail.com>
>     ARM: dts: imxrt1050: Fix clocks for mmc
>
> Wei Fang <wei.fang@nxp.com>
>     arm64: dts: imx95: correct the address length of netcmix_blk_ctrl
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/eventfd: ensure io_eventfd_signal() defers another RCU perio=
d
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     iio: adc: ad7124: Disable all channels at probe time
>
> David Lechner <dlechner@baylibre.com>
>     iio: adc: ad7173: fix using shared static info struct
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     iio: inkern: call iio_device_put() only on mapped devices
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     iio: adc: at91: call input_free_device() on allocated iio_dev
>
> Fabio Estevam <festevam@gmail.com>
>     iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()
>
> Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
>     iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
>
> Charles Han <hanchunchao@inspur.com>
>     iio: adc: ti-ads1298: Add NULL check in ads1298_init
>
> Carlos Song <carlos.song@nxp.com>
>     iio: gyro: fxas21002c: Fix missing data update in trigger handler
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: adc: ti-ads1119: fix sample size in scan struct for triggered bu=
ffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: adc: ti-ads1119: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: adc: ti-ads8688: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: adc: rockchip_saradc: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: imu: kmx61: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: light: bh1745: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: light: vcnl4035: fix information leak in triggered buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: dummy: iio_simply_dummy_buffer: fix information leak in triggere=
d buffer
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: pressure: zpa2326: fix information leak in triggered buffer
>
> GONG Ruiqi <gongruiqi1@huawei.com>
>     usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
>
> Xu Yang <xu.yang_2@nxp.com>
>     usb: host: xhci-plat: set skip_phy_initialization if software node ha=
s XHCI_SKIP_PHY_INIT property
>
> Ingo Rohloff <ingo.rohloff@lauterbach.com>
>     usb: gadget: configfs: Ignore trailing LF for user strings to cdev
>
> Akash M <akash.m5@samsung.com>
>     usb: gadget: f_fs: Remove WARN_ON in functionfs_bind
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     usb: typec: tcpm/tcpci_maxim: fix error code in max_contaminant_read_=
resistance_kohm()
>
> Prashanth K <quic_prashk@quicinc.com>
>     usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints
>
> Xu Yang <xu.yang_2@nxp.com>
>     usb: typec: tcpci: fix NULL pointer issue on shared irq case
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() =
and in the error path of .probe()
>
> Takashi Iwai <tiwai@suse.de>
>     usb: gadget: midi2: Reverse-select at the right place
>
> Ma Ke <make_ruc2021@163.com>
>     usb: fix reference leak in usb_new_device()
>
> Kai-Heng Feng <kaihengf@nvidia.com>
>     USB: core: Disable LPM only for non-suspended ports
>
> Jun Yan <jerrysteve1101@gmail.com>
>     USB: usblp: return error when setting unsupported protocol
>
> Prashanth K <quic_prashk@quicinc.com>
>     usb: dwc3-am62: Disable autosuspend during remove
>
> Rick Edgecombe <rick.p.edgecombe@intel.com>
>     x86/fpu: Ensure shadow stack is active before "getting" registers
>
> Lianqin Hu <hulianqin@vivo.com>
>     usb: gadget: u_serial: Disable ep before setting port to null to fix =
the crash caused by port being null
>
> Ben Wolsieffer <ben.wolsieffer@hefring.com>
>     serial: stm32: use port lock wrappers for break control
>
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     tty: serial: 8250: Fix another runtime PM usage counter underflow
>
> Rengarajan S <rengarajan.s@microchip.com>
>     misc: microchip: pci1xxxx: Resolve return code mismatch during GPIO s=
et config
>
> Rengarajan S <rengarajan.s@microchip.com>
>     misc: microchip: pci1xxxx: Resolve kernel panic during GPIO IRQ handl=
ing
>
> Li Huafei <lihuafei1@huawei.com>
>     topology: Keep the cpumask unchanged when printing cpumap
>
> Andr=C3=A9 Draszik <andre.draszik@linaro.org>
>     usb: dwc3: gadget: fix writing NYET threshold
>
> Johan Hovold <johan@kernel.org>
>     USB: serial: cp210x: add Phoenix Contact UPS Device
>
> Lubomir Rintel <lrintel@redhat.com>
>     usb-storage: Add max sectors quirk for Nokia 208
>
> Zicheng Qu <quzicheng@huawei.com>
>     staging: iio: ad9832: Correct phase range check
>
> Zicheng Qu <quzicheng@huawei.com>
>     staging: iio: ad9834: Correct phase range check
>
> Michal Hrusecky <michal.hrusecky@turris.com>
>     USB: serial: option: add Neoway N723-EA support
>
> Chukun Pan <amadeus@jmu.edu.cn>
>     USB: serial: option: add MeiG Smart SRM815
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring/sqpoll: zero sqd->thread on tctx errors
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring/timeout: fix multishot updates
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: increase MAX_SURFACES to the value supported by hw
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: fix page fault due to max surface definition mismatc=
h
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: fix divide error in DM plane scale calcs
>
> Zhu Lingshan <lingshan.zhu@amd.com>
>     drm/amdkfd: wq_release signals dma_fence only when available
>
> Jesse.zhang@amd.com <Jesse.zhang@amd.com>
>     drm/amdkfd: fixed page fault when enable MES shader debugger
>
> Kun Liu <Kun.Liu2@amd.com>
>     drm/amd/pm: fix BUG: scheduling while atomic
>
> Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
>     drm/amdgpu: Add a lock when accessing the buddy trim function
>
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_ove=
rride[]
>
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[=
]
>
> Binbin Zhou <zhoubinbin@loongson.cn>
>     gpio: loongson: Fix Loongson-2K2000 ACPI GPIO register offset
>
> Nam Cao <namcao@linutronix.de>
>     riscv: kprobes: Fix incorrect address calculation
>
> Nam Cao <namcao@linutronix.de>
>     riscv: Fix sleeping in invalid context in die()
>
> Christian Brauner <brauner@kernel.org>
>     fs: kill MNT_ONRB
>
> Meetakshi Setiya <msetiya@microsoft.com>
>     smb: client: sync the root session and superblock context passwords b=
efore automounting
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     arm64: dts: qcom: sa8775p: Fix the size of 'addr_space' regions
>
> Qiang Yu <quic_qianyu@quicinc.com>
>     arm64: dts: qcom: x1e80100: Fix up BAR space size for PCIe6a
>
> Andrea Righi <arighi@nvidia.com>
>     sched_ext: idle: Refresh idle masks during idle-to-idle transitions
>
> Chen Ridong <chenridong@huawei.com>
>     cgroup/cpuset: remove kernfs active break
>
> Honglei Wang <jameshongleiwang@126.com>
>     sched_ext: switch class when preempted by higher priority scheduler
>
> Changwoo Min <changwoo@igalia.com>
>     sched_ext: Replace rq_lock() to raw_spin_rq_lock() in scx_ops_bypass(=
)
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     thermal: of: fix OF node leak in of_thermal_zone_find()
>
> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains
>
> Roman Li <Roman.Li@amd.com>
>     drm/amd/display: Add check for granularity in dml ceil/floor helpers
>
> Alex Hung <alex.hung@amd.com>
>     drm/amd/display: Remove unnecessary amdgpu_irq_get/put
>
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     Revert "drm/mediatek: dsi: Correct calculation formula of PHY Timing"
>
> Mikhail Zaslonko <zaslonko@linux.ibm.com>
>     btrfs: zlib: fix avail_in bytes for s390 zlib HW compression path
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: Implement new SMB3 POSIX type
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     sctp: sysctl: plpmtud_probe_interval: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     sctp: sysctl: udp_port: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     sctp: sysctl: auth_enable: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     sctp: sysctl: rto_min/max: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: sysctl: blackhole timeout: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: sysctl: sched: avoid using current->nsproxy
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: sysctl: avail sched: remove write access
>
> Milan Broz <gmazyland@gmail.com>
>     dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (t=
ake 2)
>
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY
>
> Miklos Szeredi <mszeredi@redhat.com>
>     fs: fix is_mnt_ns_file()
>
> Amir Goldstein <amir73il@gmail.com>
>     fs: relax assertions on failure to encode file handles
>
> Alex Williamson <alex.williamson@redhat.com>
>     vfio/pci: Fallback huge faults for unaligned pfn
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     scsi: ufs: qcom: Power off the PHY if it was already powered on in uf=
s_qcom_power_up_sequence()
>
> Krister Johansen <kjlx@templeofstupid.com>
>     dm thin: make get_first_thin use rcu-safe list first function
>
> Atish Patra <atishp@rivosinc.com>
>     drivers/perf: riscv: Return error for default case
>
> Atish Patra <atishp@rivosinc.com>
>     drivers/perf: riscv: Fix Platform firmware event data
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix read-retry for fs with no ->prepare_read()
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix kernel async DIO
>
> Lucas De Marchi <lucas.demarchi@intel.com>
>     drm/xe: Fix tlb invalidation when wedging
>
> Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
>     riscv: use local label names instead of global ones in assembly
>
> Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
>     riscv: stacktrace: fix backtracing through exceptions
>
> Xu Lu <luxu.kernel@bytedance.com>
>     riscv: mm: Fix the out of bound issue of vmemmap address
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     cpuidle: riscv-sbi: fix device node release in early exit of for_each=
_possible_cpu
>
> Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
>     riscv: module: remove relocation_head rel_entry member allocation
>
> He Wang <xw897002528@gmail.com>
>     ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked
>
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86: intel/pmc: Fix ioremap() of bad address
>
> Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>     platform/x86/amd/pmc: Only disable IRQ1 wakeup where i8042 actually e=
nabled it
>
> David Howells <dhowells@redhat.com>
>     afs: Fix the maximum cell name length
>
> Wentao Liang <liangwentao@iscas.ac.cn>
>     ksmbd: fix a missing return value check bug
>
> Liankun Yang <liankun.yang@mediatek.com>
>     drm/mediatek: Add return value check when reading DPCD
>
> Koichiro Den <koichiro.den@canonical.com>
>     gpio: virtuser: fix handling of multiple conn_ids in lookup table
>
> Koichiro Den <koichiro.den@canonical.com>
>     gpio: virtuser: fix missing lookup table cleanups
>
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>     drm/mediatek: mtk_dsi: Add registers to pdata to fix MT8186/MT8188
>
> Liankun Yang <liankun.yang@mediatek.com>
>     drm/mediatek: Fix mode valid issue for dp
>
> Liankun Yang <liankun.yang@mediatek.com>
>     drm/mediatek: Fix YCbCr422 color format issue for DP
>
> Arnd Bergmann <arnd@arndb.de>
>     drm/mediatek: stop selecting foreign drivers
>
> Jason-JH.Lin <jason-jh.lin@mediatek.com>
>     drm/mediatek: Add support for 180-degree rotation in the display driv=
er
>
> Jason-JH.Lin <jason-jh.lin@mediatek.com>
>     drm/mediatek: Move mtk_crtc_finish_page_flip() to ddp_cmdq_cb()
>
> Guoqing Jiang <guoqing.jiang@canonical.com>
>     drm/mediatek: Set private->all_drm_private[i]->drm to NULL if mtk_drm=
_bind returns err
>
> Chenguang Zhao <zhaochenguang@kylinos.cn>
>     net/mlx5: Fix variable not being completed when function returns
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     rtase: Fix a check for error in rtase_alloc_msix()
>
> Parker Newman <pnewman@connecttech.com>
>     net: stmmac: dwmac-tegra: Read iommu stream id from device tree
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>     sched: sch_cake: add bounds checks to host bulk flow fairness counts
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: conntrack: clamp maximum hashtable size to INT_MAX
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: imbalance in flowtable binding
>
> Leo Yang <leo.yang.sy0@gmail.com>
>     mctp i3c: fix MCTP I3C driver multi-thread issue
>
> Jie Wang <wangjie125@huawei.com>
>     net: hns3: fix kernel crash when 1588 is sent on HIP08 devices
>
> Hao Lan <lanhao@huawei.com>
>     net: hns3: fixed hclge_fetch_pf_reg accesses bar space out of bounds =
issue
>
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: initialize reset_timer before hclgevf_misc_irq_init()
>
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: don't auto enable misc vector
>
> Hao Lan <lanhao@huawei.com>
>     net: hns3: Resolved the issue that the debugfs query result is incons=
istent.
>
> Hao Lan <lanhao@huawei.com>
>     net: hns3: fix missing features due to dev->features configuration to=
o early
>
> Hao Lan <lanhao@huawei.com>
>     net: hns3: fixed reset failure issues caused by the incorrect reset t=
ype
>
> Daniel Borkmann <daniel@iogearbox.net>
>     tcp: Annotate data-race around sk->sk_mark in tcp_v4_send_reset
>
> Chris Lu <chris.lu@mediatek.com>
>     Bluetooth: btmtk: Fix failed to send func ctrl for MediaTek devices.
>
> Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
>     Bluetooth: btnxpuart: Fix driver sending truncated data
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: MGMT: Fix Add Device to responding before completing
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_sync: Fix not setting Random Address when required
>
> Jakub Kicinski <kuba@kernel.org>
>     eth: gve: use appropriate helper to set xdp_features
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     ipvlan: Fix use-after-free in ipvlan_get_iflink().
>
> Benjamin Coddington <bcodding@redhat.com>
>     tls: Fix tls_sw_sendmsg error handling
>
> En-Wei Wu <en-wei.wu@canonical.com>
>     igc: return early when failing to read EECD register
>
> Przemyslaw Korba <przemyslaw.korba@intel.com>
>     ice: fix incorrect PHY settings for 100 GB/s
>
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     ice: fix max values for dpll pin phase adjust
>
> Jakub Kicinski <kuba@kernel.org>
>     net: don't dump Tx and uninitialized NAPIs
>
> Anumula Murali Mohan Reddy <anumula@chelsio.com>
>     cxgb4: Avoid removal of uninserted tid
>
> Michael Chan <michael.chan@broadcom.com>
>     bnxt_en: Fix DIM shutdown
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     bnxt_en: Fix possible memory leak when hwrm_req_replace fails
>
> Shannon Nelson <shannon.nelson@amd.com>
>     pds_core: limit loop over fw name list
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: avoid NULL pointer dereference if no valid extent tree
>
> Jiawen Wu <jiawenwu@trustnetic.com>
>     net: libwx: fix firmware mailbox abnormal return
>
> Eric Dumazet <edumazet@google.com>
>     net_sched: cls_flow: validate TCA_FLOW_RSHIFT attribute
>
> Zhongqiu Duan <dzq.aishenghu0@gmail.com>
>     tcp/dccp: allow a connection when sk_max_ack_backlog is zero
>
> Antonio Pastor <antonio.pastor@gmail.com>
>     net: 802: LLC+SNAP OID:PID lookup on start of skb data
>
> Keisuke Nishimura <keisuke.nishimura@inria.fr>
>     ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_pro=
be()
>
> Li Zhijian <lizhijian@fujitsu.com>
>     selftests/alsa: Fix circular dependency involving global-timer
>
> Chen-Yu Tsai <wenst@chromium.org>
>     ASoC: mediatek: disable buffer pre-allocation
>
> Shuming Fan <shumingf@realtek.com>
>     ASoC: rt722: add delay time to wait for the calibration procedure
>
> Amir Goldstein <amir73il@gmail.com>
>     ovl: support encoding fid from inode with no alias
>
> Amir Goldstein <amir73il@gmail.com>
>     ovl: pass realinode to ovl_encode_real_fh() instead of realdentry
>
> Amir Goldstein <amir73il@gmail.com>
>     fuse: respect FOPEN_KEEP_CACHE on opendir
>
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: fix the infinite loop in __exfat_free_cluster()
>
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: fix the new buffer was not zeroed before writing
>
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: fix the infinite loop in exfat_readdir()
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix is-caching check in read-retry
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix the (non-)cancellation of copy when cache is temporarily d=
isabled
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix ceph copy to cache on write-begin
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix missing barriers by using clear_and_wake_up_bit()
>
> David Howells <dhowells@redhat.com>
>     nfs: Fix oops in nfs_netfs_init_request() when copying to cache
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix enomem handling in buffered reads
>
> Ming-Hung Tsai <mtsai@redhat.com>
>     dm array: fix cursor index when skipping across block boundaries
>
> Ming-Hung Tsai <mtsai@redhat.com>
>     dm array: fix unreleased btree blocks on closing a faulty array curso=
r
>
> Ming-Hung Tsai <mtsai@redhat.com>
>     dm array: fix releasing a faulty array block twice in dm_array_cursor=
_end
>
> Long Li <leo.lilong@huawei.com>
>     iomap: fix zero padding data issue in concurrent append writes
>
> Long Li <leo.lilong@huawei.com>
>     iomap: pass byte granular end position to iomap_add_to_ioend
>
> Pankaj Raghav <p.raghav@samsung.com>
>     fs/writeback: convert wbc_account_cgroup_owner to take a folio
>
> Zhang Yi <yi.zhang@huawei.com>
>     jbd2: flush filesystem device before updating tail sequence
>
> Zhang Yi <yi.zhang@huawei.com>
>     jbd2: increase IO priority for writing revoke records
>
>
> -------------
>
> Diffstat:
>
>  Documentation/admin-guide/cgroup-v2.rst            |   2 +-
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi           |   2 +-
>  arch/arm64/boot/dts/freescale/imx95.dtsi           |   2 +-
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi              |   5 +-
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   2 +-
>  arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   1 +
>  arch/riscv/include/asm/page.h                      |   1 +
>  arch/riscv/include/asm/pgtable.h                   |   2 +-
>  arch/riscv/include/asm/sbi.h                       |   1 +
>  arch/riscv/kernel/entry.S                          |  21 +-
>  arch/riscv/kernel/module.c                         |  18 +-
>  arch/riscv/kernel/probes/kprobes.c                 |   2 +-
>  arch/riscv/kernel/stacktrace.c                     |   4 +-
>  arch/riscv/kernel/traps.c                          |   6 +-
>  arch/riscv/mm/init.c                               |  17 +-
>  arch/x86/kernel/fpu/regset.c                       |   3 +-
>  block/bfq-iosched.c                                |  12 +-
>  drivers/acpi/resource.c                            |  18 ++
>  drivers/base/topology.c                            |  24 +-
>  drivers/bluetooth/btmtk.c                          |   7 +
>  drivers/bluetooth/btnxpuart.c                      |   1 +
>  drivers/cpuidle/cpuidle-riscv-sbi.c                |   4 +-
>  drivers/gpio/gpio-loongson-64bit.c                 |   6 +-
>  drivers/gpio/gpio-virtuser.c                       |  44 ++--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |  17 ++
>  drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   3 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  35 +--
>  drivers/gpu/drm/amd/display/dc/core/dc.c           |   2 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_state.c     |   8 +-
>  drivers/gpu/drm/amd/display/dc/dc.h                |   4 +-
>  drivers/gpu/drm/amd/display/dc/dc_stream.h         |   2 +-
>  drivers/gpu/drm/amd/display/dc/dc_types.h          |   1 -
>  .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |   8 +
>  .../drm/amd/display/dc/dml2/dml2_mall_phantom.c    |   2 +-
>  drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   2 +
>  drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |  12 +-
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   1 +
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   1 +
>  drivers/gpu/drm/mediatek/Kconfig                   |   5 -
>  drivers/gpu/drm/mediatek/mtk_crtc.c                |  25 +-
>  drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  69 +++---
>  drivers/gpu/drm/mediatek/mtk_dp.c                  |  46 ++--
>  drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   2 +
>  drivers/gpu/drm/mediatek/mtk_dsi.c                 |  49 ++--
>  drivers/gpu/drm/xe/xe_gt.c                         |   8 +-
>  drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |   4 +-
>  drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h        |   3 +-
>  drivers/gpu/drm/xe/xe_oa.c                         | 265 ++++++++++++++-=
------
>  drivers/gpu/drm/xe/xe_oa_types.h                   |   6 +
>  drivers/gpu/drm/xe/xe_query.c                      |   2 +-
>  drivers/gpu/drm/xe/xe_ring_ops.c                   |   5 +-
>  drivers/gpu/drm/xe/xe_sched_job_types.h            |   2 +
>  drivers/hwmon/drivetemp.c                          |   8 +-
>  drivers/iio/adc/ad7124.c                           |   3 +
>  drivers/iio/adc/ad7173.c                           |  10 +-
>  drivers/iio/adc/at91_adc.c                         |   2 +-
>  drivers/iio/adc/rockchip_saradc.c                  |   2 +
>  drivers/iio/adc/ti-ads1119.c                       |   4 +-
>  drivers/iio/adc/ti-ads124s08.c                     |   4 +-
>  drivers/iio/adc/ti-ads1298.c                       |   2 +
>  drivers/iio/adc/ti-ads8688.c                       |   2 +-
>  drivers/iio/dummy/iio_simple_dummy_buffer.c        |   2 +-
>  drivers/iio/gyro/fxas21002c_core.c                 |  11 +-
>  drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   1 +
>  drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  22 +-
>  drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c    |   3 +-
>  drivers/iio/imu/kmx61.c                            |   2 +-
>  drivers/iio/inkern.c                               |   2 +-
>  drivers/iio/light/bh1745.c                         |   2 +
>  drivers/iio/light/vcnl4035.c                       |   2 +-
>  drivers/iio/pressure/zpa2326.c                     |   2 +
>  drivers/md/dm-ebs-target.c                         |   2 +-
>  drivers/md/dm-thin.c                               |   5 +-
>  drivers/md/dm-verity-fec.c                         |  40 ++--
>  drivers/md/persistent-data/dm-array.c              |  19 +-
>  drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |   4 +-
>  drivers/net/ethernet/amd/pds_core/devlink.c        |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  38 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   3 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   5 +-
>  drivers/net/ethernet/google/gve/gve_main.c         |  14 +-
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   3 -
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  96 +++-----
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   1 -
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  45 +++-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   3 +
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_regs.c    |   9 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  41 +++-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c  |   9 +-
>  drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   2 +
>  drivers/net/ethernet/intel/ice/ice_dpll.c          |  35 ++-
>  drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   4 +-
>  drivers/net/ethernet/intel/igc/igc_base.c          |   6 +
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   1 +
>  drivers/net/ethernet/realtek/rtase/rtase_main.c    |   2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  14 +-
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c         |  24 +-
>  drivers/net/ieee802154/ca8210.c                    |   6 +-
>  drivers/net/mctp/mctp-i3c.c                        |   4 +
>  drivers/perf/riscv_pmu_sbi.c                       |  17 +-
>  drivers/platform/x86/amd/pmc/pmc.c                 |   8 +-
>  drivers/platform/x86/intel/pmc/core_ssram.c        |   4 +
>  drivers/staging/iio/frequency/ad9832.c             |   2 +-
>  drivers/staging/iio/frequency/ad9834.c             |   2 +-
>  drivers/thermal/thermal_of.c                       |   1 +
>  drivers/tty/serial/8250/8250_core.c                |   3 +
>  drivers/tty/serial/stm32-usart.c                   |   4 +-
>  drivers/ufs/core/ufshcd-priv.h                     |   6 -
>  drivers/ufs/core/ufshcd.c                          |   1 -
>  drivers/ufs/host/ufs-qcom.c                        |  13 +-
>  drivers/usb/chipidea/ci_hdrc_imx.c                 |  25 +-
>  drivers/usb/class/usblp.c                          |   7 +-
>  drivers/usb/core/hub.c                             |   6 +-
>  drivers/usb/core/port.c                            |   7 +-
>  drivers/usb/dwc3/core.h                            |   1 +
>  drivers/usb/dwc3/dwc3-am62.c                       |   1 +
>  drivers/usb/dwc3/gadget.c                          |   4 +-
>  drivers/usb/gadget/Kconfig                         |   4 +-
>  drivers/usb/gadget/configfs.c                      |   6 +-
>  drivers/usb/gadget/function/f_fs.c                 |   2 +-
>  drivers/usb/gadget/function/f_uac2.c               |   1 +
>  drivers/usb/gadget/function/u_serial.c             |   8 +-
>  drivers/usb/host/xhci-plat.c                       |   3 +-
>  drivers/usb/serial/cp210x.c                        |   1 +
>  drivers/usb/serial/option.c                        |   4 +-
>  drivers/usb/storage/unusual_devs.h                 |   7 +
>  drivers/usb/typec/tcpm/maxim_contaminant.c         |   4 +-
>  drivers/usb/typec/tcpm/tcpci.c                     |  25 +-
>  drivers/usb/typec/ucsi/ucsi_ccg.c                  |   4 +-
>  drivers/vfio/pci/vfio_pci_core.c                   |  17 +-
>  fs/afs/afs.h                                       |   2 +-
>  fs/afs/afs_vl.h                                    |   1 +
>  fs/afs/vl_alias.c                                  |   8 +-
>  fs/afs/vlclient.c                                  |   2 +-
>  fs/btrfs/extent_io.c                               |   7 +-
>  fs/btrfs/inode.c                                   |   2 +-
>  fs/btrfs/scrub.c                                   |   4 +
>  fs/btrfs/zlib.c                                    |   4 +-
>  fs/buffer.c                                        |   4 +-
>  fs/exfat/dir.c                                     |   3 +-
>  fs/exfat/fatent.c                                  |  10 +
>  fs/exfat/file.c                                    |   6 +
>  fs/ext4/page-io.c                                  |   2 +-
>  fs/f2fs/data.c                                     |   9 +-
>  fs/fs-writeback.c                                  |   8 +-
>  fs/fuse/dir.c                                      |   2 +
>  fs/iomap/buffered-io.c                             |  68 +++++-
>  fs/jbd2/commit.c                                   |   4 +-
>  fs/jbd2/revoke.c                                   |   2 +-
>  fs/mount.h                                         |  15 +-
>  fs/mpage.c                                         |   2 +-
>  fs/namespace.c                                     |  24 +-
>  fs/netfs/buffered_read.c                           |  28 ++-
>  fs/netfs/direct_write.c                            |   7 +-
>  fs/netfs/read_collect.c                            |   9 +-
>  fs/netfs/read_pgpriv2.c                            |   4 +
>  fs/netfs/read_retry.c                              |   5 +-
>  fs/netfs/write_collect.c                           |   9 +-
>  fs/nfs/fscache.c                                   |   9 +-
>  fs/notify/fdinfo.c                                 |   4 +-
>  fs/overlayfs/copy_up.c                             |  16 +-
>  fs/overlayfs/export.c                              |  49 ++--
>  fs/overlayfs/namei.c                               |   4 +-
>  fs/overlayfs/overlayfs.h                           |   2 +-
>  fs/smb/client/namespace.c                          |  19 +-
>  fs/smb/server/smb2pdu.c                            |  43 ++++
>  fs/smb/server/smb2pdu.h                            |  10 +
>  fs/smb/server/vfs.c                                |   3 +-
>  include/linux/bus/stm32_firewall_device.h          |   2 +-
>  include/linux/iomap.h                              |   2 +-
>  include/linux/mount.h                              |   3 +-
>  include/linux/netfs.h                              |   1 -
>  include/linux/writeback.h                          |   4 +-
>  include/net/inet_connection_sock.h                 |   2 +-
>  include/uapi/drm/xe_drm.h                          |  17 ++
>  include/ufs/ufshcd.h                               |   2 -
>  io_uring/eventfd.c                                 |   2 +-
>  io_uring/io_uring.c                                |   5 +-
>  io_uring/sqpoll.c                                  |   6 +-
>  io_uring/timeout.c                                 |   4 +-
>  kernel/cgroup/cpuset.c                             |  35 +--
>  kernel/sched/ext.c                                 |  76 ++++--
>  kernel/sched/ext.h                                 |   8 +-
>  kernel/sched/idle.c                                |   5 +-
>  net/802/psnap.c                                    |   4 +-
>  net/bluetooth/hci_sync.c                           |  11 +-
>  net/bluetooth/mgmt.c                               |  38 ++-
>  net/bluetooth/rfcomm/tty.c                         |   4 +-
>  net/core/dev.c                                     |  43 +++-
>  net/core/dev.h                                     |   3 +-
>  net/core/link_watch.c                              |  10 +-
>  net/core/netdev-genl.c                             |   9 +-
>  net/ipv4/tcp_ipv4.c                                |   2 +-
>  net/mptcp/ctrl.c                                   |  17 +-
>  net/netfilter/nf_conntrack_core.c                  |   5 +-
>  net/netfilter/nf_tables_api.c                      |  15 +-
>  net/rds/tcp.c                                      |  39 ++-
>  net/sched/cls_flow.c                               |   3 +-
>  net/sched/sch_cake.c                               | 140 ++++++-----
>  net/sctp/sysctl.c                                  |  14 +-
>  net/tls/tls_sw.c                                   |   2 +-
>  sound/soc/codecs/rt722-sdca.c                      |   7 +-
>  .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
>  tools/testing/selftests/alsa/Makefile              |   2 +-
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh  |  33 +--
>  207 files changed, 1626 insertions(+), 884 deletions(-)
>
>
>
