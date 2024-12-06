Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172351FD7A5
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502876; cv=none; b=eNZVuP0/SSLeksij80sjO/+Til36+CJtsnzTKTP2Rsz1ZTyRfri3no9nSRZ90bsdYpqlapL7YqC7OgDIps4yNO5yPOtlV21rcVa9X6uuHqw7wH4cbFaDFlXQW78+P+7/6U3cOL1cuTWlYpCNyAc4PJkIper+vvFlwmJrNM2oSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502876; c=relaxed/simple;
	bh=TXUA9RlIUqkm5rjT50AEsMKI1VZaQn1VWCjjdXnrhpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EqmQ+IubHwOK1vJcVzBrbIcjuoXpeu4vvWFDvo25HokonwKimbvdxlHtb0vZwhkDRDEba/FDWHW/rUTAknVIfgXycGmEy4ld3SGHj/LYuoQxikJ+3tyh2ei42RRB1tNj//HSj6nKESjjaXJFx+5BCCRFeGvMLSM1tVOKmFph4Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+bnmHeh; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+bnmHeh"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7ee51d9ae30so1626425a12.1
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 08:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733502873; x=1734107673; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2anKylo24QPQloGU94NwV7KKz1VmKqGyKyAv4aVGMo=;
        b=a+bnmHehHaYXXFT8N+dhnLyK313zaikj/14sKhUqJOurLMXw/tdKREoCi6sDGygrcO
         hl+A02e91ezzNLGciv+4yuSrCexINM33xthXMeL1snj468PfNbEYtRHsZ6NkVQV5EV4F
         /S7ervG7Rh3aT0F04iODJpwACdwmQ9JYBwS8ZbOKx1aRs+zek9XlJor8o4chW+qTG1tH
         3Gn+v/XivhhnktS9KA7jQnJGpONK9FgMAG+LZou4DnpsH1ZmtpSrKa27B8YaZk8i93Vz
         M7buGBr6VF4iiTy9H2xitGj3GTO8SQNIvQ2rr7X61Q+hZJTR8x9aZcjtnS0zJN2u3v/B
         Re9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733502873; x=1734107673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2anKylo24QPQloGU94NwV7KKz1VmKqGyKyAv4aVGMo=;
        b=RNI3OeWVo7Wx+n+WXY8YzQAPS4Mr1zTMHpmbYTIQaPDFdQoFim03NvH4BE+zTTG4Yp
         mNQL5Yr4J4jYXkdKzdO+18FYbh3F7GHfqogrwBnJhhCwbkXvzufXNEd+MGgQ3kXz0Qbc
         UTc8PwrE23I/HfOT6sok2cxOLom8U7vx02KApzJc9kzKRVyykGJn9fz8TNRrnenSxtle
         HI+unQDxxrGfhugoUcQpOBgq3T7pKqr9/qFslH7uKkmbWYeahG3eEuGThXE1mQ3xy5wU
         92Rbf3Db/BJQXQGyuYQKbDdHujZ/aOtjpyl+x32h7bg9z0eqDsPZW9VYjmCcdopnk825
         MEgw==
X-Forwarded-Encrypted: i=1; AJvYcCUdvWMwBBK4B4zIEvemj1ga7Iw8Px4bCo6sagEoQU7BWrxl6PQ2yEQfXd6YUlk79OhZrBtufzF/@lists.linux.dev
X-Gm-Message-State: AOJu0YyLM2Rezb/bHCzZAfVuERFvnE+ge3eao1GN2146BLlNYMEvARod
	MdJ7RoLg/RpXHDYGXeU3a4CMUMxVHpcJwscs3LJ/xjtRiYSD+f/xqJQp4PpE4sior9mKD+d5/Im
	fgmdVooQRWkjdkfQ4ZucHVaWfLHo=
X-Gm-Gg: ASbGncscp4QFETV0tWn8KtukLKdChYqEe45scYVDjck5XcrrGnKM9QJkuENowm4J9WO
	n5AQHI0P3yPGwX3279ups55irlWLB0RYtQeRgw6sqJOKyWQ==
X-Google-Smtp-Source: AGHT+IFn1Ui0z0SzDUCq6p6T1PBclq9bHy0GOTyO9it2wjHK0i7LZhmY0rbEbmPaR8yOOiCNizQcqmUidyiKCFlYeB8=
X-Received: by 2002:a17:90a:d403:b0:2ee:d797:408b with SMTP id
 98e67ed59e1d1-2ef6945f06bmr5727436a91.2.1733502873006; Fri, 06 Dec 2024
 08:34:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241206143527.654980698@linuxfoundation.org>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 6 Dec 2024 17:34:20 +0100
Message-ID: <CADo9pHj6VBpetSswefGGi_TdQVb_avnDkhniSYTPazj240Ditw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
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

Works as it should

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den fre 6 dec. 2024 kl 15:39 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.4-rc1.gz
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
>     Linux 6.12.4-rc1
>
> Frederic Weisbecker <frederic@kernel.org>
>     posix-timers: Target group sigqueue to current task only if not exiti=
ng
>
> Ovidiu Bunea <Ovidiu.Bunea@amd.com>
>     drm/amd/display: Remove PIPE_DTO_SRC_SEL programming from set_dtbclk_=
dto
>
> Yihan Zhu <Yihan.Zhu@amd.com>
>     drm/amd/display: update pipe selection policy to check head pipe
>
> Joshua Aberback <joshua.aberback@amd.com>
>     drm/amd/display: Fix handling of plane refcount
>
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amd/pm: Remove arcturus min power limit
>
> Kenneth Feng <kenneth.feng@amd.com>
>     drm/amd/pm: disable pcie speed switching on Intel platform for smu v1=
4.0.2/3
>
> Umio Yasuno <coelacanth_dream@protonmail.com>
>     drm/amd/pm: update current_socclk and current_uclk in gpu_metrics on =
smu v13.0.7
>
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd: Fix initialization mistake for NBIO 7.11 devices
>
> Kenneth Feng <kenneth.feng@amd.com>
>     drm/amd/pm: skip setting the power source on smu v14.0.2/3
>
> Vitaly Prosyak <vitaly.prosyak@amd.com>
>     drm/amdgpu: fix usage slab after free
>
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd: Add some missing straps from NBIO 7.11.0
>
> Kenneth Feng <kenneth.feng@amd.com>
>     drm/amdgpu/pm: add gen5 display to the user on smu v14.0.2/3
>
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdkfd: Use the correct wptr size
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/xe/guc_submit: fix race around suspend_pending
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/xe/migrate: use XE_BO_FLAG_PAGETABLE
>
> Alex Deucher <alexander.deucher@amd.com>
>     Revert "drm/radeon: Delay Connector detecting when HPD singals is uns=
table"
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/xe/migrate: fix pat index usage
>
> Jonathan Cavitt <jonathan.cavitt@intel.com>
>     drm/xe/xe_guc_ads: save/restore OA registers and allowlist regs
>
> Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
>     drm: xlnx: zynqmp_dpsub: fix hotplug detection
>
> Lucas Stach <l.stach@pengutronix.de>
>     drm/etnaviv: flush shader L1 cache after user commandstream
>
> Chen-Yu Tsai <wenst@chromium.org>
>     drm/bridge: it6505: Fix inverted reset polarity
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     drm/mediatek: Fix child node refcount handling in early exit
>
> Thomas Zimmermann <tzimmermann@suse.de>
>     drm/fbdev-dma: Select FB_DEFERRED_IO
>
> Ma Ke <make24@iscas.ac.cn>
>     drm/sti: avoid potential dereference of error pointers
>
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     drm: panel: jd9365da-h3: Remove unused num_init_cmds structure member
>
> Ma Ke <make24@iscas.ac.cn>
>     drm/sti: avoid potential dereference of error pointers in sti_gdp_ato=
mic_check
>
> Ma Ke <make24@iscas.ac.cn>
>     drm/sti: avoid potential dereference of error pointers in sti_hqvdp_a=
tomic_check
>
> Lyude Paul <lyude@redhat.com>
>     drm/panic: Fix uninitialized spinlock acquisition with CONFIG_DRM_PAN=
IC=3Dn
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     net: fec: make PPS channel configurable
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     net: fec: refactor PPS channel configuration
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     dt-bindings: net: fec: add pps channel property
>
> Carlos Llamas <cmllamas@google.com>
>     binder: add delivered_freeze to debugfs output
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix memleak of proc->delivered_freeze
>
> Carlos Llamas <cmllamas@google.com>
>     binder: allow freeze notification for dead nodes
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix BINDER_WORK_CLEAR_FREEZE_NOTIFICATION debug logs
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix BINDER_WORK_FROZEN_BINDER debug logs
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix freeze UAF in binder_release_work()
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix OOB in binder_add_freeze_work()
>
> Carlos Llamas <cmllamas@google.com>
>     binder: fix node UAF in binder_add_freeze_work()
>
> Nathan Chancellor <nathan@kernel.org>
>     powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clan=
g
>
> Nathan Chancellor <nathan@kernel.org>
>     powerpc: Fix stack protector Kconfig test for clang
>
> Zicheng Qu <quzicheng@huawei.com>
>     iio: gts: fix infinite loop for gain_to_scaletables()
>
> Nuno Sa <nuno.sa@analog.com>
>     iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer
>
> Zicheng Qu <quzicheng@huawei.com>
>     iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()
>
> Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
>     iio: invensense: fix multiple odr switch when FIFO is off
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     iio: accel: kx022a: Fix raw read format
>
> Yang Erkun <yangerkun@huawei.com>
>     nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur
>
> Yang Erkun <yangerkun@huawei.com>
>     nfsd: make sure exp active before svc_export_show
>
> Damien Le Moal <dlemoal@kernel.org>
>     PCI: rockchip-ep: Fix address translation unit programming
>
> Andrea della Porta <andrea.porta@suse.com>
>     PCI: of_property: Assign PCI instead of CPU bus address to dynamic PC=
I nodes
>
> Niklas Cassel <cassel@kernel.org>
>     PCI: dwc: ep: Fix advertised resizable BAR size regression
>
> Yuan Can <yuancan@huawei.com>
>     dm thin: Add missing destroy_work_on_stack()
>
> Ssuhung Yeh <ssuhung@gmail.com>
>     dm: Fix typo in error message
>
> Adrian Huang <ahuang12@lenovo.com>
>     mm/vmalloc: combine all TLB flush operations of KASAN shadow virtual =
address into one operation
>
> Oleksandr Tymoshenko <ovt@google.com>
>     ovl: properly handle large files in ovl_security_fileattr
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     leds: flash: mt6360: Fix device_for_each_child_node() refcounting in =
error paths
>
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     thermal: int3400: Fix reading of current_uuid for active policy
>
> Jiri Olsa <jolsa@kernel.org>
>     fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful =
iov_iter_zero
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     slab: Fix too strict alignment check in create_cache()
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_ep=
f()
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     PCI: endpoint: Fix PCI domain ID release in pci_epc_destroy()
>
> Kishon Vijay Abraham I <kishon@kernel.org>
>     PCI: keystone: Add link up check to ks_pcie_other_map_bus()
>
> Kishon Vijay Abraham I <kishon@kernel.org>
>     PCI: keystone: Set mode as Root Complex for "ti,keystone-pcie" compat=
ible
>
> Frank Li <Frank.Li@nxp.com>
>     i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable =
counter
>
> Frank Li <Frank.Li@nxp.com>
>     i3c: master: svc: fix possible assignment of the same address to two =
devices
>
> Frank Li <Frank.Li@nxp.com>
>     i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs(=
)
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enab=
led
>
> Peter Griffin <peter.griffin@linaro.org>
>     scsi: ufs: exynos: Fix hibern8 notify callbacks
>
> Peter Griffin <peter.griffin@linaro.org>
>     scsi: ufs: exynos: Add check inside exynos_ufs_config_smu()
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/stacktrace: Use break instead of return statement
>
> Alexandru Ardelean <aardelean@baylibre.com>
>     util_macros.h: fix/rework find_closest() macros
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: spinand: winbond: Fix 512GW, 01GW, 01JW and 02JW ECC information
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: spinand: winbond: Fix 512GW and 02JW OOB layout
>
> Max Kellermann <max.kellermann@ionos.com>
>     ceph: fix cred leak in ceph_mds_check_access()
>
> Max Kellermann <max.kellermann@ionos.com>
>     ceph: pass cred pointer to ceph_mds_auth_match()
>
> Patrick Donnelly <pdonnell@redhat.com>
>     ceph: extract entity name from device id
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to drop all discards after creating snapshot on lvm device
>
> yuan.gao <yuan.gao@ucloud.cn>
>     mm/slub: Avoid list corruption when removing a slab from the full lis=
t
>
> Stefan Eichenberger <stefan.eichenberger@toradex.com>
>     PCI: imx6: Fix suspend/resume support on i.MX6QDL
>
> Balaji Pothunoori <quic_bpothuno@quicinc.com>
>     remoteproc: qcom_q6v5_pas: disable auto boot for wpss
>
> Xu Yang <xu.yang_2@nxp.com>
>     perf jevents: fix breakage when do perf stat on system metric
>
> Qiang Yu <quic_qianyu@quicinc.com>
>     PCI: qcom: Disable ASPM L0s for X1E80100
>
> Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>     vfio/qat: fix overflow check in qat_vf_resume_write()
>
> Choong Yong Liang <yong.liang.choong@linux.intel.com>
>     net: stmmac: set initial EEE policy configuration
>
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()
>
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: 9430/1: entry: Do a dummy read from VMAP shadow
>
> Vasily Gorbik <gor@linux.ibm.com>
>     s390/entry: Mark IRQ entries to fix stack depot warnings
>
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: 9429/1: ioremap: Sync PGDs for VMALLOC shadow
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     spmi: pmic-arb: fix return path in for_each_available_child_of_node()
>
> Saravana Kannan <saravanak@google.com>
>     driver core: fw_devlink: Stop trying to optimize cycle detection logi=
c
>
> Marek Vasut <marex@denx.de>
>     nvmem: core: Check read_only flag for force_ro in bin_attr_nvmem_writ=
e()
>
> Zicheng Qu <quzicheng@huawei.com>
>     ad7780: fix division by zero in ad7780_write_raw()
>
> Gabor Juhos <j4g8y7@gmail.com>
>     clk: qcom: gcc-qcs404: fix initial rate of GPLL3
>
> Sibi Sankar <quic_sibis@quicinc.com>
>     cpufreq: scmi: Fix cleanup path when boost enablement fails
>
> Nathan Chancellor <nathan@kernel.org>
>     powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with=
 clang
>
> Zheng Yejian <zhengyejian@huaweicloud.com>
>     mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
>
> Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>
>     leds: lp55xx: Remove redundant test for invalid channel number
>
> Pratyush Brahma <quic_pbrahma@quicinc.com>
>     iommu/arm-smmu: Defer probe of clients after smmu device bound
>
> Mostafa Saleh <smostafa@google.com>
>     iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables
>
> Sergey Senozhatsky <senozhatsky@chromium.org>
>     zram: clear IDLE flag after recompression
>
> MengEn Sun <mengensun@tencent.com>
>     vmstat: call fold_vm_zone_numa_events() before show per zone NUMA eve=
nt
>
> guoweikang <guoweikang.kernel@gmail.com>
>     ftrace: Fix regression with module command in stack_trace_filter
>
> Wei Yang <richard.weiyang@gmail.com>
>     maple_tree: refine mas_store_root() on storing NULL
>
> Vasiliy Kovalev <kovalev@altlinux.org>
>     ovl: Filter invalid inodes with missing lookup function
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     kunit: string-stream: Fix a UAF bug in kunit_init_suite()
>
> Zichen Xie <zichenxie0106@gmail.com>
>     kunit: Fix potential null dereference in kunit_device_driver_test()
>
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>     tracing: Fix function timing profiler to initialize hashtable
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     media: uvcvideo: Require entities to have a non-zero unique ID
>
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Stop stream during unregister
>
> Gaosheng Cui <cuigaosheng1@huawei.com>
>     media: platform: allegro-dvt: Fix possible memory leak in allocate_bu=
ffers_internal()
>
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     media: ov08x40: Fix burst write sequence
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     media: amphion: Fix pm_runtime_set_suspended() with runtime pm enable=
d
>
> Romain Gantois <romain.gantois@bootlin.com>
>     net: phy: dp83869: fix status reporting for 1000base-x autonegotiatio=
n
>
> Ard Biesheuvel <ardb@kernel.org>
>     efi/libstub: Free correct pointer on failure
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     media: platform: exynos4-is: Fix an OF node reference leak in fimc_md=
_is_isp_available
>
> Li Zetao <lizetao1@huawei.com>
>     media: ts2020: fix null-ptr-deref in ts2020_probe()
>
> Benjamin Gaignard <benjamin.gaignard@collabora.com>
>     media: verisilicon: av1: Fix reference video buffer pointer assignmen=
t
>
> John Keeping <jkeeping@inmusicbrands.com>
>     media: platform: rga: fix 32-bit DMA limitation
>
> Ming Qian <ming.qian@nxp.com>
>     media: imx-jpeg: Ensure power suppliers be suspended before detach th=
em
>
> Alexander Shiyan <eagle.alexander923@gmail.com>
>     media: i2c: tc358743: Fix crash in the probe error path when using po=
lling
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm en=
abled
>
> Guoqing Jiang <guoqing.jiang@canonical.com>
>     media: mtk-jpeg: Fix null-ptr-deref during unload module
>
> Ming Qian <ming.qian@nxp.com>
>     media: imx-jpeg: Set video drvdata before register video device
>
> Ming Qian <ming.qian@nxp.com>
>     media: amphion: Set video drvdata before register video device
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     media: qcom: camss: fix error path on configuration of power domains
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8186-corsola: Fix IT6505 reset line polarity
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     arm64: dts: ti: k3-am62-verdin: Fix SD regulator startup delay
>
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8186-corsola: Fix GPU supply coupling max-spr=
ead
>
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer
>
> Yuan Can <yuancan@huawei.com>
>     md/md-bitmap: Add missing destroy_work_on_stack()
>
> Xiao Ni <xni@redhat.com>
>     md/raid5: Wait sync io to finish before changing group cnt
>
> Daniel Borkmann <daniel@iogearbox.net>
>     netkit: Add option for scrubbing skb meta data
>
> Will Deacon <will@kernel.org>
>     iommu/tegra241-cmdqv: Fix unused variable warning
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: ref-verify: fix use-after-free after invalid ref action
>
> Lizhi Xu <lizhi.xu@windriver.com>
>     btrfs: add a sanity check for btrfs root in btrfs_search_slot()
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: don't loop for nowait writes when checking for cross reference=
s
>
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: fix use-after-free in btrfs_encoded_read_endio()
>
> Mark Harmstone <maharmstone@fb.com>
>     btrfs: move priv off stack in btrfs_encoded_read_regular_fill_pages()
>
> Mark Harmstone <maharmstone@fb.com>
>     btrfs: change btrfs_encoded_read() so that reading of extent is done =
by caller
>
> David Sterba <dsterba@suse.com>
>     btrfs: drop unused parameter file_offset from btrfs_encoded_read_regu=
lar_fill_pages()
>
> Ojaswin Mujoo <ojaswin@linux.ibm.com>
>     quota: flush quota_release_work upon quota writeback
>
> Long Li <leo.lilong@huawei.com>
>     xfs: remove unknown compat feature check in superblock write validati=
on
>
>
> -------------
>
> Diffstat:
>
>  Documentation/devicetree/bindings/net/fsl,fec.yaml |   7 ++
>  Makefile                                           |   4 +-
>  arch/arm/kernel/entry-armv.S                       |   8 ++
>  arch/arm/mm/ioremap.c                              |  35 ++++++-
>  .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |   3 +
>  arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   2 +-
>  arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |   2 +-
>  arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi   |   6 +-
>  arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
>  arch/powerpc/Kconfig                               |   4 +-
>  arch/powerpc/Makefile                              |  13 +--
>  arch/powerpc/kernel/vdso/Makefile                  |   8 +-
>  arch/s390/kernel/entry.S                           |   4 +
>  arch/s390/kernel/kprobes.c                         |   6 ++
>  arch/s390/kernel/stacktrace.c                      |   2 +-
>  drivers/android/binder.c                           |  64 ++++++++++---
>  drivers/base/core.c                                |  55 +++++------
>  drivers/block/zram/zram_drv.c                      |   7 ++
>  drivers/clk/qcom/gcc-qcs404.c                      |   1 +
>  drivers/cpufreq/scmi-cpufreq.c                     |   4 +-
>  drivers/firmware/efi/libstub/efi-stub.c            |   2 +-
>  drivers/gpu/drm/Kconfig                            |   2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   6 +-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c            |   9 ++
>  drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |   2 +-
>  drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +
>  .../gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |  15 +--
>  .../amd/display/dc/dml2/dml2_dc_resource_mgmt.c    |  23 ++++-
>  .../amd/include/asic_reg/nbio/nbio_7_11_0_offset.h |   2 +
>  .../include/asic_reg/nbio/nbio_7_11_0_sh_mask.h    |  13 +++
>  drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   8 +-
>  drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h       |   2 +-
>  drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   6 +-
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   2 +
>  drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |   2 +-
>  .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  37 ++++++--
>  drivers/gpu/drm/bridge/ite-it6505.c                |   8 +-
>  drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
>  drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   3 +-
>  drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
>  drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |   1 -
>  drivers/gpu/drm/radeon/radeon_connectors.c         |  10 --
>  drivers/gpu/drm/sti/sti_cursor.c                   |   3 +
>  drivers/gpu/drm/sti/sti_gdp.c                      |   3 +
>  drivers/gpu/drm/sti/sti_hqvdp.c                    |   3 +
>  drivers/gpu/drm/xe/xe_guc_ads.c                    |  14 +++
>  drivers/gpu/drm/xe/xe_guc_submit.c                 |  17 +++-
>  drivers/gpu/drm/xe/xe_migrate.c                    |   6 +-
>  drivers/gpu/drm/xlnx/zynqmp_kms.c                  |   4 +-
>  drivers/i3c/master.c                               |   2 +-
>  drivers/i3c/master/svc-i3c-master.c                |  39 +++++---
>  drivers/iio/accel/kionix-kx022a.c                  |   2 +-
>  drivers/iio/adc/ad7780.c                           |   2 +-
>  drivers/iio/adc/ad7923.c                           |   4 +-
>  .../iio/common/inv_sensors/inv_sensors_timestamp.c |   4 +
>  drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   2 -
>  drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   3 -
>  drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |   1 -
>  drivers/iio/industrialio-gts-helper.c              |   2 +-
>  drivers/iio/inkern.c                               |   2 +-
>  drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   2 +
>  drivers/iommu/arm/arm-smmu/arm-smmu.c              |  11 +++
>  drivers/iommu/io-pgtable-arm.c                     |  18 +++-
>  drivers/leds/flash/leds-mt6360.c                   |   3 +-
>  drivers/leds/leds-lp55xx-common.c                  |   3 -
>  drivers/md/dm-thin.c                               |   1 +
>  drivers/md/md-bitmap.c                             |   1 +
>  drivers/md/persistent-data/dm-space-map-common.c   |   2 +-
>  drivers/md/raid5.c                                 |   4 +
>  drivers/media/dvb-frontends/ts2020.c               |   8 +-
>  drivers/media/i2c/dw9768.c                         |  10 +-
>  drivers/media/i2c/ov08x40.c                        |  33 ++++++-
>  drivers/media/i2c/tc358743.c                       |   4 +-
>  drivers/media/platform/allegro-dvt/allegro-core.c  |   4 +-
>  drivers/media/platform/amphion/vpu_drv.c           |   2 +-
>  drivers/media/platform/amphion/vpu_v4l2.c          |   2 +-
>  .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |  10 ++
>  .../media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c |  11 ---
>  drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   4 +-
>  drivers/media/platform/qcom/camss/camss.c          |  19 ++--
>  drivers/media/platform/qcom/venus/core.c           |   2 +-
>  drivers/media/platform/rockchip/rga/rga.c          |   2 +-
>  .../media/platform/samsung/exynos4-is/media-dev.h  |   5 +-
>  .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |   3 +-
>  drivers/media/usb/gspca/ov534.c                    |   2 +-
>  drivers/media/usb/uvc/uvc_driver.c                 | 102 +++++++++++++++=
------
>  drivers/mtd/nand/spi/winbond.c                     |  16 ++--
>  drivers/net/ethernet/freescale/fec_ptp.c           |  11 ++-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
>  drivers/net/netkit.c                               |  68 +++++++++++---
>  drivers/net/phy/dp83869.c                          |  20 +++-
>  drivers/nvmem/core.c                               |   2 +-
>  drivers/pci/controller/dwc/pci-imx6.c              |  57 +++++++++---
>  drivers/pci/controller/dwc/pci-keystone.c          |  12 +++
>  drivers/pci/controller/dwc/pcie-designware-ep.c    |   2 +-
>  drivers/pci/controller/dwc/pcie-qcom.c             |   2 +-
>  drivers/pci/controller/pcie-rockchip-ep.c          |  16 +++-
>  drivers/pci/controller/pcie-rockchip.h             |   4 +
>  drivers/pci/endpoint/pci-epc-core.c                |  11 +--
>  drivers/pci/of_property.c                          |   2 +-
>  drivers/remoteproc/qcom_q6v5_pas.c                 |   2 +-
>  drivers/spmi/spmi-pmic-arb.c                       |   3 +-
>  .../intel/int340x_thermal/int3400_thermal.c        |   2 +-
>  drivers/ufs/host/ufs-exynos.c                      |  23 +++--
>  drivers/vfio/pci/qat/main.c                        |   2 +-
>  fs/btrfs/btrfs_inode.h                             |  12 ++-
>  fs/btrfs/ctree.c                                   |   6 +-
>  fs/btrfs/extent-tree.c                             |   2 +-
>  fs/btrfs/inode.c                                   |  94 ++++++++++-----=
----
>  fs/btrfs/ioctl.c                                   |  32 ++++++-
>  fs/btrfs/ref-verify.c                              |   1 +
>  fs/btrfs/send.c                                    |   2 +-
>  fs/ceph/mds_client.c                               |   7 +-
>  fs/ceph/super.c                                    |  10 +-
>  fs/f2fs/segment.c                                  |  16 ++--
>  fs/f2fs/super.c                                    |  12 +++
>  fs/nfsd/export.c                                   |   5 +-
>  fs/nfsd/nfs4state.c                                |  19 ++++
>  fs/overlayfs/inode.c                               |   7 +-
>  fs/overlayfs/util.c                                |   3 +
>  fs/proc/kcore.c                                    |   1 +
>  fs/quota/dquot.c                                   |   2 +
>  fs/xfs/libxfs/xfs_sb.c                             |   7 --
>  include/drm/drm_panic.h                            |  14 +++
>  include/linux/kasan.h                              |  12 ++-
>  include/linux/util_macros.h                        |  56 +++++++----
>  include/uapi/linux/if_link.h                       |  15 +++
>  kernel/signal.c                                    |   9 +-
>  kernel/trace/ftrace.c                              |   7 ++
>  lib/kunit/debugfs.c                                |   5 +-
>  lib/kunit/kunit-test.c                             |   2 +
>  lib/maple_tree.c                                   |  13 ++-
>  mm/damon/tests/vaddr-kunit.h                       |   1 +
>  mm/damon/vaddr.c                                   |   4 +-
>  mm/kasan/shadow.c                                  |  14 ++-
>  mm/slab.h                                          |   5 +
>  mm/slab_common.c                                   |   2 +-
>  mm/slub.c                                          |   9 +-
>  mm/vmalloc.c                                       |  34 +++++--
>  mm/vmstat.c                                        |   1 +
>  tools/perf/pmu-events/empty-pmu-events.c           |  12 +--
>  tools/perf/pmu-events/jevents.py                   |  12 +--
>  143 files changed, 1071 insertions(+), 434 deletions(-)
>
>
>
