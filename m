Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E8E26B087;
	Thu, 13 Feb 2025 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458640; cv=none; b=NQodvwBTvZld5IUGg/iO7SV+mYZDmnaDHIAN44qun7y7db3h/9awhl2qLiffAzxY3wP6UBr71gUwDrVLuegpnmvsaJ8iaEM3SkMaxHH0l9OPmyTFzV2MNZd1FGb2yEexBM3cKXoqWpHXuM6nt1CjxoVuoP7yAbBeUUn8usLvuR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458640; c=relaxed/simple;
	bh=u51CXhkpu4AEsEfUZLw0BuLQICbd2e7xHRbTALlpM2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CpPT3sMcAg39A9o4M2Q5fp6RjBRs4SN/mS+wrRwPXgbVAxOo0/S9tGeUah5uPO8uZeaobJ4BD4d3g16cVpcOe/TuXJpOQ09FVhjOb7Yh6y9bTzXGK87IbariE9ZnF2PJYfHOTvskLYnfdN1irk/YDceGg/bwb5fxYccGoPlaZTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMcRhehk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMcRhehk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93753C4CED1;
	Thu, 13 Feb 2025 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458640;
	bh=u51CXhkpu4AEsEfUZLw0BuLQICbd2e7xHRbTALlpM2c=;
	h=From:To:Cc:Subject:Date:From;
	b=eMcRhehki7PjCmd85hqfN5aKwsgalpyTtoVWo0OqP8jvCEXKV85faafoWg6kB/L7k
	 86zcg77H02DOZxnjCqpFrqvxQmOMHlrokPTqszk2OPvOSnB9FZKVqIEFgDDdQSCC5U
	 QZeVdN4Ofw4MEdV3hQH8FmMyvT9ThWffVdE4JTlg=
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
Subject: [PATCH 6.13 000/443] 6.13.3-rc1 review
Date: Thu, 13 Feb 2025 15:22:45 +0100
Message-ID: <20250213142440.609878115@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.13.3-rc1
X-KernelTest-Deadline: 2025-02-15T14:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.13.3 release.
There are 443 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.13.3-rc1

Miklos Szeredi <mszeredi@redhat.com>
    fs: fix adding security options to statmount.mnt_opt

Jeff Layton <jlayton@kernel.org>
    fs: prepend statmount.mnt_opts string with security_sb_mnt_opts()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: disable PCIE wake bit when PCIE deinit

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    Revert "drm/amd/display: Fix green screen issue after suspend"

Bart Van Assche <bvanassche@acm.org>
    md: Fix linear_set_limits()

Dan Carpenter <dan.carpenter@linaro.org>
    md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add()

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Convert unreachable() to BUG()

Bence Csókás <csokas.bence@prolan.hu>
    spi: atmel-qspi: Memory barriers after memory-mapped I/O

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Create `atmel_qspi_ops` to support newer SoC families

WangYuli <wangyuli@uniontech.com>
    MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static

Heiko Carstens <hca@linux.ibm.com>
    s390/fpu: Add fpc exception handler / remove fixup section again

Frederic Weisbecker <frederic@kernel.org>
    timers/migration: Fix off-by-one root mis-connection

Miklos Szeredi <mszeredi@redhat.com>
    statmount: let unset strings be empty

Michal Simek <michal.simek@amd.com>
    rtc: zynqmp: Fix optional clock name property

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a race for an ODP MR which leads to CQE with error

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Ensure info->enable callback is always set

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix PFC_MASK for RZ/V2H and RZ/G3E

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    pinctrl: samsung: fix fwnode refcount cleanup if platform_get_irq_optional() fails

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla: Add trace_instance_stop

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    rtla/osnoise: Distinguish missing workload option

Steven Rostedt <rostedt@goodmis.org>
    tracing/osnoise: Fix resetting of tracepoints

Jan Kiszka <jan.kiszka@siemens.com>
    scripts/gdb: fix aarch64 userspace detection in get_current_task

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: simplify split calculation

Milos Reljin <milos_reljin@outlook.com>
    net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: wait for the last response to Deselect Package before configuring channel

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix copy buffer page size

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix registered buffer page address

Anandu Krishnan E <quic_anane@quicinc.com>
    misc: fastrpc: Deregister device nodes properly in error scenarios

Vimal Agrawal <vimal.agrawal@sophos.com>
    misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: onenand: Fix uninitialized retlen in do_otp_read()

Nick Chan <towinchenmi@gmail.com>
    irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix missing 'ret' assignment in set_speed()

Steven Rostedt <rostedt@goodmis.org>
    fgraph: Fix set_graph_notrace with setting TRACE_GRAPH_NOTRACE_BIT

Dan Carpenter <dan.carpenter@linaro.org>
    NFC: nci: Add bounds checking in nci_hci_create_pipe()

Uros Bizjak <ubizjak@gmail.com>
    mailbox: zynqmp: Remove invalid __percpu annotation in zynqmp_ipi_probe()

Pekka Pessi <ppessi@nvidia.com>
    mailbox: tegra-hsp: Clear mailbox before using message

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Encode COMPOUND operation status on page boundaries

Dragan Simic <dsimic@manjaro.org>
    nfs: Make NFS_FSCACHE select NETFS_SUPPORT instead of depending on it

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    nilfs2: fix possible int overflows in nilfs_fiemap()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ocfs2: handle a symlink read error correctly

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix incorrect CPU endianness conversion causing mount failure

Mike Snitzer <snitzer@kernel.org>
    pnfs/flexfiles: retry getting layout segment for reads

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: -f: no reconnect

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't retry connect operation on EPOLLERR

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix multishots with selected buffers

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: set word length to 1

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: fix reading from non zero offset

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: fix MAC address byte order

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: simplify read beyond device check

Jennifer Berringer <jberring@redhat.com>
    nvmem: core: improve range check for nvmem_cell_write()

Luca Weiss <luca.weiss@fairphone.com>
    nvmem: qcom-spmi-sdam: Set size in struct nvmem_config

Antoine Viallon <antoine@lesviallon.fr>
    ceph: fix memory leak in ceph_mds_auth_match()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - unregister previously registered algos in error path

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - fix goto jump in error path

Stefan Eichenberger <eichest@gmail.com>
    irqchip/irq-mvebu-icu: Fix access to msi_data from irq_domain::host_data

Niklas Cassel <cassel@kernel.org>
    ata: libata-sff: Ensure that we cannot write outside the allocated buffer

Daniel Baumann <daniel@debian.org>
    ata: libata-core: Add ATA_QUIRK_NOLPM for Samsung SSD 870 QVO drives

Liu Shixin <liushixin2@huawei.com>
    mm/compaction: fix UBSAN shift-out-of-bounds warning

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    mm/hugetlb: fix hugepage allocation for interleaved memory nodes

Li Zhijian <lizhijian@fujitsu.com>
    mm/vmscan: accumulate nr_demoted for accurate demotion statistics

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: gup: fix infinite loop within __get_longterm_locked

Catalin Marinas <catalin.marinas@arm.com>
    mm: kmemleak: fix upper boundary check for physical address objects

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove dangling pointers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove redundant NULL assignment

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Only save async fh if success

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Support partial control reads

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix event flags in uvc_ctrl_send_events

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix crash during unbind if gpio unit is in use

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix logging SP & EQ status only for UB9702

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix UB9702 VC map

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix use of non-existing registers on UB9702

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub9x3: Fix extra fwnode_handle_put()

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: ccs: Fix cleanup order in ccs_probe()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Fix CCS static data parsing for large block sizes

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: venus: destroy hfi session after m2m_ctx release

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: dcmipp: correct dma_set_mask_and_coherent mask value

Sam Bobrowicz <sam@elite-embedded.com>
    media: ov5640: fix get_light_freq on auto

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    media: intel/ipu6: remove cpu latency qos request on error

Naushir Patuck <naush@raspberrypi.com>
    media: imx296: Add standby delay during probe

Zhen Lei <thunder.leizhen@huawei.com>
    media: nuvoton: Fix an error check in npcm_video_ece_init()

Cosmin Tanislav <demonsingur@gmail.com>
    media: mc: fix endpoint iteration

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: Documentation: tx-rx: Fix formatting

Lubomir Rintel <lkundrak@v3.sk>
    media: mmp: Bring back registration of the device

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: qcom: smem_state: fix missing of_node_put in error path

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    soc: qcom: llcc: Enable LLCC_WRCACHE at boot on X1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on error paths

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: samsung: exynos-pmu: Fix uninitialized ret in tensor_set_bits_atomic()

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/fault: Use a separate spinlock to protect fault->deliver list

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/fault: Destroy response and mutex in iommufd_fault_destroy()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: as73211: fix channel handling in only-color triggered buffer

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r-hs: clear reset status flag

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r-common: fix ad3541/2r ranges

Dan Carpenter <dan.carpenter@linaro.org>
    iio: chemical: bme680: Fix uninitialized variable in __bme680_read_raw()

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix avoid_reserve to allow taking folio from subpool

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Clean up parsed CCS static data on parse failure

Marco Elver <elver@google.com>
    kfence: skip __GFP_THISNODE allocations on NUMA systems

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Fix struct iommu_hwpt_pgfault init and padding

Easwar Hariharan <eahariha@linux.microsoft.com>
    jiffies: Cast to unsigned long in secs_to_jiffies() conversion

Frederic Weisbecker <frederic@kernel.org>
    hrtimers: Force migrate away hrtimers queued after CPUHP_AP_HRTIMERS_DYING

Gabriele Monaco <gmonaco@redhat.com>
    rv: Reset per-task monitors also for idle tasks

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Change to kvalloc() in eventlog/acpi.c

Aubrey Li <aubrey.li@linux.intel.com>
    ACPI: PRM: Remove unnecessary strict handler address checks

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix error handling in recovery/reset

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Clear runtime_error after pm_runtime_resume_and_get() fails

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix error handling in ivpu_boot()

Wentao Liang <vulab@iscas.ac.cn>
    xfs: Add error handling for xfs_reflink_cancel_cow_range

Wentao Liang <vulab@iscas.ac.cn>
    xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end

Christoph Hellwig <hch@lst.de>
    xfs: don't call remap_verify_area with sb write protection held

Conor Dooley <conor.dooley@microchip.com>
    pwm: microchip-core: fix incorrect comparison with max period

Helge Deller <deller@kernel.org>
    parisc: Temporarily disable jump label support

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Disable Tegra234 sce-fabric node

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix typo in Tegra234 dce-fabric compatible

Eric Biggers <ebiggers@google.com>
    crypto: qce - fix priority to be less than ARMv8 CE

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8650: correct MDSS interconnects

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8550: correct MDSS interconnects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8650: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8650: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8650: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix CDSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix MPSS memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix CDSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix ADSP memory length

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Fix uart1 interconnect path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix ADSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: x1e80100: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: x1e80100: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdx75: Fix MPSS memory length

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Disable DSI display output by default

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Disable DPI display output by default

Andreas Kemnade <andreas@kemnade.info>
    ARM: dts: ti/omap: gta04: fix pm issues caused by spi module

Romain Naour <romain.naour@skf.com>
    ARM: dts: dra7: Add bus_dma_limit for l4 cfg bus

Denis Arefev <arefev@swemel.ru>
    ubi: Add a check for ubi_num

Nathan Chancellor <nathan@kernel.org>
    x86/boot: Use '-std=gnu11' to fix build with GCC 15

Zhang Rui <rui.zhang@intel.com>
    x86/acpi: Fix LAPIC/x2APIC parsing order

Alice Ryhl <aliceryhl@google.com>
    x86: rust: set rustc-abi=x86-softfloat on rustc>=1.86.0

Miguel Ojeda <ojeda@kernel.org>
    rust: init: use explicit ABI to clean warning in future compilers

Christian Brauner <brauner@kernel.org>
    pidfs: improve ioctl handling

Christian Brauner <brauner@kernel.org>
    pidfs: check for valid ioctl commands

Nathan Chancellor <nathan@kernel.org>
    kbuild: Move -Wenum-enum-conversion to W=2

Igor Pylypiv <ipylypiv@google.com>
    scsi: core: Do not retry I/Os during depopulation

Long Li <longli@microsoft.com>
    scsi: storvsc: Set correct data length for sending SCSI command without payload

André Draszik <andre.draszik@linaro.org>
    scsi: ufs: core: Fix use-after free in init error and remove paths

Eric Biggers <ebiggers@google.com>
    scsi: ufs: qcom: Fix crypto key eviction

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Move FCE Trace buffer allocation to user control

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't set pos_unknown just after device recognition

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Prevent changing BAR size/flags in pci_epc_set_bar()

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Write BAR_MASK before iATU registers in pci_epc_set_bar()

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()

Werner Sembach <wse@tuxedocomputers.com>
    PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix SR-IOV for PFs initially in standby

Brad Griffis <bgriffis@nvidia.com>
    arm64: tegra: Fix Tegra234 PCIe interrupt-map

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for resume on Dell Venue 11 Pro 7130

Kuan-Wei Chiu <visitorckw@gmail.com>
    ALSA: hda: Fix headset detection failure due to unstable sort

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix quirk matching for Legion Pro 7

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo C6400

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: qcom: scm: Fix missing read barrier in qcom_scm_get_tzmem_pool()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: qcom: scm: Fix missing read barrier in qcom_scm_is_available()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "media: uvcvideo: Require entities to have a non-zero unique ID"

Jens Axboe <axboe@kernel.dk>
    block: don't revert iter for -EIOCBQUEUED

Xi Ruoyao <xry111@xry111.site>
    Revert "MIPS: csrc-r4k: Select HAVE_UNSTABLE_SCHED_CLOCK if SMP && 64BIT"

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: pci-legacy: Override pci_address_to_pio

Mateusz Jończyk <mat.jonczyk@o2.pl>
    mips/math-emu: fix emulation of the prefx instruction

Hou Tao <houtao1@huawei.com>
    dm-crypt: track tag_offset in convert_context

Hou Tao <houtao1@huawei.com>
    dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/pseries/eeh: Fix get PE state translation

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Extend the maximum number of watchpoints

Kexy Biscuit <kexybiscuit@aosc.io>
    MIPS: Loongson64: remove ROM Size unit in boardinfo

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Drop __initdata macro for port_cfg

Stephan Gerhold <stephan.gerhold@linaro.org>
    soc: qcom: socinfo: Avoid out of bounds read of serial number

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: acp: Support microphone from Lenovo Go S

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: renesas: rz-ssi: Add a check for negative sample_space

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Terminate all the DMA transactions

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100: Fix usb_2 controller interrupts

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-microsoft-romulus: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-lenovo-yoga-slim7x: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-crd: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e78100-lenovo-thinkpad-t14s: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-qcp: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-dell-xps13-9345: Fix USB QMP PHY supplies

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-asus-vivobook-s15: Fix USB QMP PHY supplies

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: document scope of NCM implementation

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: fix DPE OoB read

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: break up NCM header size computation

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: refactor NCM datagram loop

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: check that DPE points past NCM header

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: use static NDP16 location in URB

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: fix possible overflow in DPE length check

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't prepare BOT write request twice

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Decrement command ref count on cleanup

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Translate error to sense

Vasily Khoruzhick <anarsoul@gmail.com>
    wifi: rtw88: 8703b: Fix RX/TX issues

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7915: add module param to select 5 GHz or 6 GHz on MT7916

Fiona Klute <fiona.klute@gmx.de>
    wifi: rtw88: sdio: Fix disconnection after beacon loss

Nick Morrow <usbwifi2024@gmail.com>
    wifi: mt76: mt7921u: Add VID/PID for TP-Link TXE50UH

Marcel Hamer <marcel.hamer@windriver.com>
    wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8821ae: Fix media status report

Steven Rostedt <rostedt@goodmis.org>
    atomic64: Use arch_spin_locks instead of raw_spin_locks

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Do not allow events in NMI with generic atomic64 cmpxchg()

Heiko Stuebner <heiko@sntech.de>
    HID: hid-sensor-hub: don't use stale platform-data on remove

Peng Fan <peng.fan@nxp.com>
    Input: bbnsm_pwrkey - add remove hook

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Warn for missing static reserved memory regions

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Fix using wrong number of cells to get property 'alignment'

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix of_find_node_opts_by_path() handling of alias+path+options

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    of: address: Fix empty resource handling in __of_address_resource_bounds()

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Correct child specifier used as input of the 2nd nexus node

Bao D. Nguyen <quic_nguyenb@quicinc.com>
    scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions

Kuan-Wei Chiu <visitorckw@gmail.com>
    perf bench: Fix undefined behavior in cmpworker()

Dave Young <dyoung@redhat.com>
    x86/efi: skip memattr table on kexec boot

Nathan Chancellor <nathan@kernel.org>
    efi: libstub: Use '-std=gnu11' to fix build with GCC 15

Zijun Hu <quic_zijuhu@quicinc.com>
    blk-cgroup: Fix class @block_class's subsystem refcount leakage

Eyal Birger <eyal.birger@gmail.com>
    seccomp: passthrough uretprobe systemcall without filtering

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-mm: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-img: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-bdp: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-aud: fix conversion to mtk_clk_simple_probe

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe

Anastasia Belova <abelova@astralinux.ru>
    clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add missing parent_map for a clock

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add missing parent_map for two clocks

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    clk: qcom: gcc-sm8650: Do not turn off PCIe GDSCs during gdsc_disable()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    clk: qcom: gcc-sm8550: Do not turn off PCIe GDSCs during gdsc_disable()

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix alpha mode configuration

Binbin Zhou <zhoubinbin@loongson.cn>
    clk: clk-loongson2: Fix the number count of clk provider

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix UB9702 refclk register access

Lubomir Rintel <lkundrak@v3.sk>
    clk: mmp2: call pm_genpd_init() only after genpd.name is set

Cody Eksal <masterr3c0rd@epochal.quest>
    clk: sunxi-ng: a100: enable MMC clock reparenting

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - fix crash when enabling pass-through port

David Gstir <david@sigma-star.at>
    KEYS: trusted: dcp: fix improper sg use with CONFIG_VMAP_STACK=y

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix and re-enable xe_print_blob_ascii85()

Lo-an Chen <lo-an.chen@amd.com>
    drm/amd/display: Fix seamless boot sequence

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: add a BO metadata flag to disable write compression for Vulkan

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: Iterate DSC BPP from high to low on all platforms

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/devcoredump: Move exec queue snapshot to Contexts section

Haoxiang Li <haoxiang_li2024@163.com>
    drm/komeda: Add check for komeda_get_layer_fourcc_list()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: astdp: Fix timeout for enabling video signal

Brian Geffon <bgeffon@google.com>
    drm/i915: Fix page cleanup on DMA remap failure

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/guc: Debug print LRC state entries only if the context is pinned

Tom Chung <chiahsuan.chung@amd.com>
    Revert "drm/amd/display: Use HW lock mgr for PSR1"

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Block per-queue reset when halt_if_hws_hang=1

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: only flush the validate MES contex

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: change the config of cgcg on gfx12

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Mark MM activity as unsupported

Aric Cyr <Aric.Cyr@amd.com>
    drm/amd/display: Optimize cursor position updates

Dan Carpenter <dan.carpenter@linaro.org>
    ksmbd: fix integer overflows on 32 bit systems

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: fix some corner-cases when grabbing vsie pages

Keith Busch <kbusch@kernel.org>
    kvm: defer huge page recovery vhost task to later

Sean Christopherson <seanjc@google.com>
    KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()

Chao Gao <chao.gao@intel.com>
    KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Robin Murphy <robin.murphy@arm.com>
    remoteproc: omap: Handle ARM dma_iommu_mapping

Jakob Unterwurzacher <jakobunt@gmail.com>
    arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma

Thomas Zimmermann <tzimmermann@suse.de>
    drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: timer: Always evaluate the need for a soft timer

Ard Biesheuvel <ardb@kernel.org>
    arm64/mm: Reduce PA space to 48 bits when LPA2 is not enabled

Mark Brown <broonie@kernel.org>
    arm64/sme: Move storage of reg_smidr to __cpuinfo_store_cpu()

Ard Biesheuvel <ardb@kernel.org>
    arm64/mm: Override PARange for !LPA2 and use it consistently

Ard Biesheuvel <ardb@kernel.org>
    arm64/kvm: Configure HYP TCR.PS/DS based on host stage1

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix Qemu crash when running in passthrough

Xu Yang <xu.yang_2@nxp.com>
    perf: imx9_perf: Introduce AXI filter version to refactor the driver and better extension

Dan Carpenter <dan.carpenter@linaro.org>
    binfmt_flat: Fix integer overflow bug on 32 bit systems

Ming Lei <tom.leiming@gmail.com>
    block: mark GFP_NOIO around sysfs ->store()

Nam Cao <namcao@linutronix.de>
    fs/proc: do_task_stat: Fix ESP not readable during coredump

Thomas Zimmermann <tzimmermann@suse.de>
    m68k: vga: Fix I/O defines

Marc Zyngier <maz@kernel.org>
    arm64: Filter out SVE hwcaps when FEAT_SVE isn't implemented

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: Fix FUTEX_OP_ANDN implementation

Yu Kuai <yukuai3@huawei.com>
    md: reintroduce md-linear

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: change lease epoch type from unsigned int to __u16

Ruben Devos <devosruben6@gmail.com>
    smb: client: fix order of arguments of tracepoints

Maarten Lankhorst <dev@lankhorst.se>
    drm/client: Handle tiled displays better

Maarten Lankhorst <dev@lankhorst.se>
    drm/modeset: Handle tiled displays in pan_display_atomic.

Pali Rohár <pali@kernel.org>
    cifs: Remove intermediate object of failed create SFU call

Sebastian Wiese-Wagner <seb@fastmail.to>
    ALSA: hda/realtek: Enable Mute LED on HP Laptop 14s-fq1xxx

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    leds: lp8860: Write full EEPROM, not only half of it

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: s3c64xx: Fix compilation warning

Andreas Kemnade <andreas@kemnade.info>
    cpufreq: fix using cpufreq-dt as module

Robin Murphy <robin.murphy@arm.com>
    PCI/TPH: Restore TPH Requester Enable correctly

David Howells <dhowells@redhat.com>
    rxrpc: Fix call state set to not include the SERVER_SECURING state

Ido Schimmel <idosch@nvidia.com>
    net: sched: Fix truncation of offloaded action statistics

Willem de Bruijn <willemb@google.com>
    tun: revert fix group permission check

Cong Wang <cong.wang@bytedance.com>
    netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()

Quang Le <quanglex97@gmail.com>
    pfifo_tail_enqueue: Drop new packet when sch->limit == 0

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: property: Fix return value for nval == 0 in acpi_data_prop_read()

Juergen Gross <jgross@suse.com>
    x86/xen: add FRAME_END to xen_hypercall_hvm()

Juergen Gross <jgross@suse.com>
    x86/xen: fix xen_hypercall_hvm() to not clobber %rbx

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: GPIO_GRGPIO should depend on OF

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: sim: lock hog configfs items if present

Eric Dumazet <edumazet@google.com>
    net: rose: lock the socket in rose_bind()

Jacob Moroni <mail@jakemoroni.com>
    net: atlantic: fix warning during hot unplug

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: Improve interrupt support

David Howells <dhowells@redhat.com>
    rxrpc: Fix the rxrpc_connection attend queue handling

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: rss_ctx: add missing cleanup in queue reconfigure

Jakub Kicinski <kuba@kernel.org>
    ethtool: ntuple: fix rss + ring_cookie check

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix hiding unsupported fields in dumps

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Fix migration initialization

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Preserve oa_ctrl unused bits

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/dp: fix the Adaptive sync Operation mode for SDP

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Fix Repeater authentication during topology change

Yan Zhai <yan@cloudflare.com>
    udp: gso: do not drop small packets when PMTU reduces

Lenny Szubowicz <lszubowi@redhat.com>
    tg3: Disable tg3 PCIe AER on system reboot

Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
    vmxnet3: Fix tx queue race condition with XDP

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    ice: Add check for devm_kzalloc()

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: Correct overlaying of PHY and MAC Wake-on-LAN

Daniel Wagner <wagi@kernel.org>
    nvme-fc: use ctrl state getter

Keith Busch <kbusch@kernel.org>
    nvme: make nvme_tls_attrs_group static

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: stop storing XDP verdict within ice_rx_buf

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: gather page_count()'s of each frag right before XDP prog call

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: put Rx buffers after being done with current frame

Hans Verkuil <hverkuil@xs4all.nl>
    gpu: drm_dp_cec: fix broken CEC adapter properties check

Prasad Pandit <pjp@fedoraproject.org>
    firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a memory leak in controller identify

Daniel Wagner <wagi@kernel.org>
    nvme: handle connectivity loss in nvme_set_queue_count

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Fix inaccurate h_nr_runnable accounting with delayed dequeue

Hans de Goede <hdegoede@redhat.com>
    platform/x86: serdev_helpers: Check for serial_ctrl_uid == NULL

Günther Noack <gnoack@google.com>
    tty: Permit some TIOCL_SETSEL modes without CAP_SYS_ADMIN

Sean Anderson <sean.anderson@linux.dev>
    tty: xilinx_uartps: split sysrq handling

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore AC events

Hridesh MG <hridesh699@gmail.com>
    platform/x86: acer-wmi: add support for Acer Nitro AN515-58

Illia Ostapyshyn <illia@yshyn.com>
    Input: allocate keycode for phone linking

Yu-Chun Lin <eleanor15x@gmail.com>
    ASoC: amd: Add ACPI dependency to fix build error

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Add support for Acer Predator PH16-72

Kees Bakker <kees@ijzerbout.nl>
    iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-pcm: don't use soc_pcm_ret() on .prepare callback

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Add support for Acer PH14-51

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472: Check for adev == NULL

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu-v3: Clean up more on probe failure

Richard Acayan <mailingradian@gmail.com>
    iommu/arm-smmu-qcom: add sdm670 adreno iommu compatible

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Correct quirk for Lenovo Yoga Slim 7

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Allocate PGD for x86_64 transition page tables separately

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Improve verifier log for resource leak on exit

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: ensure proper channel cleanup in error path

Liu Ye <liuye@kylinos.cn>
    selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()

Dan Carpenter <dan.carpenter@linaro.org>
    tipc: re-order conditions in tipc_crypto_key_rcv()

Shinas Rasheed <srasheed@marvell.com>
    octeon_ep_vf: update tx/rx stats locally for persistence

Shinas Rasheed <srasheed@marvell.com>
    octeon_ep: update tx/rx stats locally for persistence

Yuanjie Yang <quic_yuanjiey@quicinc.com>
    mmc: sdhci-msm: Correctly set the load for the regulator

Luke D. Jones <luke@ljones.dev>
    HID: hid-asus: Disable OOBE mode on the ProArt P16

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    net: wwan: iosm: Fix hibernation by re-binding the driver around it

Mazin Al Haddad <mazin@getstate.dev>
    Bluetooth: MGMT: Fix slab-use-after-free Read in mgmt_remove_adv_monitor_sync

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3628 for MT7925

Andrew Halaney <ajhalaney@gmail.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3610 for MT7922

Mark Dietzer <git@doridian.net>
    Bluetooth: btusb: Add ID 0x2c7c:0x0130 for Qualcomm WCN785x

Borislav Petkov <bp@alien8.de>
    APEI: GHES: Have GHES honor the panic= setting

Randolph Ha <rha051117@gmail.com>
    i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: avoid memory leak

Somashekhar(Som) <somashekhar.puttagangaiah@intel.com>
    wifi: iwlwifi: pcie: Add support for new device ids

Stefan Dösinger <stefan@codeweavers.com>
    wifi: brcmfmac: Check the return value of of_property_read_string_index()

Andre Przywara <andre.przywara@arm.com>
    Revert "mfd: axp20x: Allow multiple regulators"

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    net/mlx5: use do_aux_work for PHC overflow checks

Even Xu <even.xu@intel.com>
    HID: Wacom: Add PCI Wacom device support

Youwan Wang <youwan@nfschina.com>
    HID: multitouch: Add quirk for Hantick 5288 touchpad

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, num_of_rules counter on matcher should be atomic

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, change error flow on matcher disconnect

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: Make GCC_8150 depend on QCOM_GDSC

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: add __packed attribute to efuse layout struct

Hans de Goede <hdegoede@redhat.com>
    mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: don't emit warning in tomoyo_write_control()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()

Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
    mmc: sdhci-esdhc-imx: enable 'SDHCI_QUIRK_NO_LED' quirk for S32G

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Respect quirk_max_rate for non-UHS SDIO card

Stas Sergeev <stsp2@yandex.ru>
    tun: fix group permission check

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: add crystal_cap check to avoid setting as overflow value

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath12k: ath12k_mac_op_set_key(): fix uninitialized symbol 'ret'

Karol Przybylski <karprzy7@gmail.com>
    wifi: ath12k: Fix for out-of bound access error

Jeongjun Park <aha310510@gmail.com>
    ring-buffer: Make reading page consistent with the code logic

Gabe Teeger <Gabe.Teeger@amd.com>
    drm/amd/display: Limit Scaling Ratio on DCN3.01

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Increase sanitizer frame larger than limit when compile testing with clang

Leo Stone <leocstone@gmail.com>
    safesetid: check size of policy writes

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP CTS KSV list wait timer

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP CTS compare V matching

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP encryption when R0 ready

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP Bstatus check

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Queue interrupt work to different CPU

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: Don't enable sdma 4.4.5 CTXEMPTY interrupt

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix Mode Cutoff in DSC Passthrough to DP2.1 Monitor

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/vc4: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/sti: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/radeon: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/exynos: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/amd/display: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: ite-it66121: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: anx7625: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/connector: add mutex to protect ELD from concurrent access

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: filter out too wide modes if no 3dmux is present

Kuan-Wei Chiu <visitorckw@gmail.com>
    printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: Overwriting dualDPP UBF values before usage

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: Populate chroma prefetch parameters, DET buffer fix

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/tests: hdmi: return meaningful value from set_connector_edid()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/tests: hdmi: handle empty modes in find_preferred_mode()

Zhi Wang <zhiw@nvidia.com>
    nvkm: correctly calculate the available space of the GSP cmdq buffer

Zhi Wang <zhiw@nvidia.com>
    nvkm/gsp: correctly advance the read pointer of GSP message queue

Dustin L. Howett <dustin@howett.net>
    drm: panel-backlight-quirks: Add Framework 13 glossy and 2.8k panels

Thomas Weißschuh <linux@weissschuh.net>
    drm: panel-backlight-quirks: Add Framework 13 matte panel

Thomas Weißschuh <linux@weissschuh.net>
    drm/amd/display: Add support for minimum backlight quirk

Thomas Weißschuh <linux@weissschuh.net>
    drm: Add panel backlight quirks

Dongwon Kim <dongwon.kim@intel.com>
    drm/virtio: New fence for every plane update

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Restrict init function to AMD-based systems

Carlos Llamas <cmllamas@google.com>
    lockdep: Fix upper limit for LOCKDEP_*_BITS configs

Thorsten Blum <thorsten.blum@linux.dev>
    locking/ww_mutex/test: Use swap() macro

Peter Zijlstra <peterz@infradead.org>
    x86: Convert unreachable() to BUG()

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Check bandwidth overflow earlier for hotplug

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Correctly account for allocated bandwidth during hotplug

Suleiman Souhlal <suleiman@google.com>
    sched: Don't try to catch up excess steal time.

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't use btrfs_set_item_key_safe on RAID stripe-extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling

Hao-ran Zheng <zhenghaoran154@gmail.com>
    btrfs: fix data race when accessing the inode's disk_i_size at btrfs_drop_extents()

Sven Schnelle <svens@linux.ibm.com>
    s390/stackleak: Use exrl instead of ex in __stackleak_poison()

Kees Cook <kees@kernel.org>
    exec: fix up /proc/pid/comm in the execveat(AT_EMPTY_PATH) case

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Ensure adequate HUGE_MAX_HSTATE

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when attempting to join an aborted transaction

Qu Wenruo <wqu@suse.com>
    btrfs: do not output error message if a qgroup has been already cleaned up

Filipe Manana <fdmanana@suse.com>
    btrfs: fix assertion failure when splitting ordered extent after transaction abort

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat while merging a relocation root

Geert Uytterhoeven <geert+renesas@glider.be>
    irqchip/lan966x-oic: Make CONFIG_LAN966X_OIC depend on CONFIG_MCHP_LAN966X_PCI


-------------

Diffstat:

 Documentation/arch/arm64/elf_hwcaps.rst            |  39 +-
 Documentation/driver-api/media/tx-rx.rst           |   2 +-
 Documentation/gpu/drm-kms-helpers.rst              |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/ti/omap/dra7-l4.dtsi             |   2 +
 arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi         |  10 +
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   5 -
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts    |   4 -
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   2 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   6 +-
 arch/arm64/boot/dts/qcom/sdx75.dtsi                |   2 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm6375.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               | 492 ++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8450.dtsi               | 216 ++++-----
 arch/arm64/boot/dts/qcom/sm8550.dtsi               | 271 ++++++------
 arch/arm64/boot/dts/qcom/sm8650.dtsi               | 305 +++++++------
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts     |   4 +-
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   6 +-
 .../boot/dts/qcom/x1e80100-dell-xps13-9345.dts     |   4 +-
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   6 +-
 .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   6 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             | 280 ++++++------
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
 arch/arm64/include/asm/assembler.h                 |   5 +
 arch/arm64/include/asm/pgtable-hwdef.h             |   6 -
 arch/arm64/include/asm/pgtable-prot.h              |   7 +
 arch/arm64/include/asm/sparsemem.h                 |   5 +-
 arch/arm64/kernel/cpufeature.c                     |  55 +--
 arch/arm64/kernel/cpuinfo.c                        |  10 +
 arch/arm64/kernel/pi/idreg-override.c              |   9 +
 arch/arm64/kernel/pi/map_kernel.c                  |   6 +
 arch/arm64/kvm/arch_timer.c                        |   4 +-
 arch/arm64/kvm/arm.c                               |   8 +-
 arch/arm64/mm/hugetlbpage.c                        |  12 +
 arch/arm64/mm/init.c                               |   7 +-
 arch/loongarch/include/uapi/asm/ptrace.h           |  10 +
 arch/loongarch/kernel/ptrace.c                     |   6 +-
 arch/m68k/include/asm/vga.h                        |   8 +-
 arch/mips/Kconfig                                  |   1 -
 arch/mips/kernel/ftrace.c                          |   2 +-
 arch/mips/loongson64/boardinfo.c                   |   2 -
 arch/mips/math-emu/cp1emu.c                        |   2 +-
 arch/mips/pci/pci-legacy.c                         |   8 +
 arch/parisc/Kconfig                                |   4 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
 arch/s390/include/asm/asm-extable.h                |   4 +
 arch/s390/include/asm/fpu-insn.h                   |  17 +-
 arch/s390/include/asm/futex.h                      |   2 +-
 arch/s390/include/asm/processor.h                  |   3 +-
 arch/s390/kernel/vmlinux.lds.S                     |   1 -
 arch/s390/kvm/vsie.c                               |  25 +-
 arch/s390/mm/extable.c                             |   9 +
 arch/s390/pci/pci_bus.c                            |   1 -
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/include/asm/kexec.h                       |  18 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +
 arch/x86/kernel/acpi/boot.c                        |  50 ++-
 arch/x86/kernel/amd_nb.c                           |   4 +
 arch/x86/kernel/machine_kexec_64.c                 |  45 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kernel/reboot.c                           |   2 +-
 arch/x86/kvm/lapic.c                               |  11 +
 arch/x86/kvm/lapic.h                               |   1 +
 arch/x86/kvm/mmu/mmu.c                             |  45 +-
 arch/x86/kvm/svm/sev.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   5 +
 arch/x86/kvm/vmx/vmx.c                             |  21 +
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   7 +-
 arch/x86/mm/fault.c                                |   2 +-
 arch/x86/pci/fixup.c                               |  30 ++
 arch/x86/platform/efi/quirks.c                     |   5 +
 arch/x86/xen/xen-head.S                            |   5 +-
 block/blk-cgroup.c                                 |   1 +
 block/blk-sysfs.c                                  |   3 +
 block/fops.c                                       |   5 +-
 drivers/accel/ivpu/ivpu_drv.c                      |   8 +-
 drivers/accel/ivpu/ivpu_pm.c                       |  86 ++--
 drivers/acpi/apei/ghes.c                           |  10 +-
 drivers/acpi/prmt.c                                |   4 +-
 drivers/acpi/property.c                            |  10 +-
 drivers/ata/libata-core.c                          |   4 +
 drivers/ata/libata-sff.c                           |  18 +-
 drivers/bluetooth/btusb.c                          |   6 +
 drivers/char/misc.c                                |  37 +-
 drivers/char/tpm/eventlog/acpi.c                   |  15 +-
 drivers/clk/clk-loongson2.c                        |   5 +-
 drivers/clk/mediatek/clk-mt2701-aud.c              |  10 +
 drivers/clk/mediatek/clk-mt2701-bdp.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-img.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-mm.c               |   1 +
 drivers/clk/mediatek/clk-mt2701-vdec.c             |   1 +
 drivers/clk/mmp/pwr-island.c                       |   2 +-
 drivers/clk/qcom/Kconfig                           |   1 +
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/clk/qcom/dispcc-sm6350.c                   |   7 +-
 drivers/clk/qcom/gcc-mdm9607.c                     |   2 +-
 drivers/clk/qcom/gcc-sm6350.c                      |  22 +-
 drivers/clk/qcom/gcc-sm8550.c                      |   8 +-
 drivers/clk/qcom/gcc-sm8650.c                      |   8 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   6 +-
 drivers/cpufreq/Kconfig                            |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   2 -
 drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
 drivers/crypto/qce/aead.c                          |   2 +-
 drivers/crypto/qce/core.c                          |  13 +-
 drivers/crypto/qce/sha.c                           |   2 +-
 drivers/crypto/qce/skcipher.c                      |   2 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/firmware/qcom/qcom_scm.c                   |  10 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpio/gpio-pca953x.c                        |  19 -
 drivers/gpio/gpio-sim.c                            |  13 +-
 drivers/gpu/drm/Kconfig                            |   4 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/amd/amdgpu/Kconfig                 |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  11 -
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  25 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         |  25 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  20 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |  22 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.h    |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   2 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/dml2/Makefile       |   4 +
 .../drm/amd/display/dc/dml2/display_mode_core.c    |  35 +-
 .../display/dc/dml2/display_mode_core_structs.h    |   6 +-
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c |  35 +-
 .../gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c   |   7 +-
 .../drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c  |   6 +-
 .../drm/amd/display/dc/hubbub/dcn30/dcn30_hubbub.c |   3 +-
 .../drm/amd/display/dc/hubbub/dcn31/dcn31_hubbub.c |   3 +-
 .../drm/amd/display/dc/hubbub/dcn32/dcn32_hubbub.c |   3 +-
 .../drm/amd/display/dc/hubbub/dcn35/dcn35_hubbub.c |   3 +-
 .../gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c |   8 +-
 .../gpu/drm/amd/display/dc/hubp/dcn30/dcn30_hubp.c |   2 +
 .../gpu/drm/amd/display/dc/hubp/dcn32/dcn32_hubp.c |   2 +
 .../drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c   |  10 +-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   3 +-
 .../display/dc/resource/dcn301/dcn301_resource.c   |   8 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 -
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
 drivers/gpu/drm/ast/ast_dp.c                       |   2 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   2 +
 drivers/gpu/drm/bridge/ite-it6505.c                |  83 ++--
 drivers/gpu/drm/bridge/ite-it66121.c               |   2 +
 drivers/gpu/drm/display/drm_dp_cec.c               |  14 +-
 drivers/gpu/drm/drm_client_modeset.c               |   9 +
 drivers/gpu/drm/drm_connector.c                    |   1 +
 drivers/gpu/drm/drm_edid.c                         |   6 +
 drivers/gpu/drm/drm_fb_helper.c                    |  14 +-
 drivers/gpu/drm/drm_panel_backlight_quirks.c       |  94 ++++
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |  10 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |  13 +
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   4 -
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   6 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  20 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |  13 +
 drivers/gpu/drm/msm/dp/dp_audio.c                  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |  16 +-
 drivers/gpu/drm/radeon/radeon_audio.c              |   2 +
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   9 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   2 +
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c |  33 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   7 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |  58 ++-
 drivers/gpu/drm/xe/regs/xe_oa_regs.h               |   6 +
 drivers/gpu/drm/xe/xe_devcoredump.c                |  42 +-
 drivers/gpu/drm/xe/xe_devcoredump.h                |   2 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   4 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c                |  14 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.h                |   6 +
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   3 +-
 drivers/gpu/drm/xe/xe_guc_log.c                    |   4 +-
 drivers/gpu/drm/xe/xe_oa.c                         |  12 +-
 drivers/hid/hid-asus.c                             |  26 ++
 drivers/hid/hid-multitouch.c                       |   5 +
 drivers/hid/hid-sensor-hub.c                       |  21 +-
 drivers/hid/wacom_wac.c                            |   5 +
 drivers/i2c/i2c-core-acpi.c                        |  22 +
 drivers/i3c/master.c                               |   2 +-
 drivers/iio/chemical/bme680_core.c                 |   4 +-
 drivers/iio/dac/ad3552r-common.c                   |   5 +-
 drivers/iio/dac/ad3552r-hs.c                       |   6 +
 drivers/iio/dac/ad3552r.h                          |   8 +-
 drivers/iio/light/as73211.c                        |  24 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  17 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   2 +
 drivers/input/misc/nxp-bbnsm-pwrkey.c              |   8 +
 drivers/input/mouse/synaptics.c                    |  56 ++-
 drivers/input/mouse/synaptics.h                    |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  17 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   8 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   1 +
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/iommu/iommufd/fault.c                      |  44 +-
 drivers/iommu/iommufd/iommufd_private.h            |  29 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/irqchip/irq-apple-aic.c                    |   3 +-
 drivers/irqchip/irq-mvebu-icu.c                    |   3 +-
 drivers/leds/leds-lp8860.c                         |   2 +-
 drivers/mailbox/tegra-hsp.c                        |   6 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   2 +-
 drivers/md/Kconfig                                 |  13 +
 drivers/md/Makefile                                |   2 +
 drivers/md/dm-crypt.c                              |  27 +-
 drivers/md/md-autodetect.c                         |   8 +-
 drivers/md/md-linear.c                             | 352 +++++++++++++++
 drivers/md/md.c                                    |   2 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/ccs/ccs-data.c                   |  14 +-
 drivers/media/i2c/ds90ub913.c                      |   1 -
 drivers/media/i2c/ds90ub953.c                      |   1 -
 drivers/media/i2c/ds90ub960.c                      | 123 +++---
 drivers/media/i2c/imx296.c                         |   2 +
 drivers/media/i2c/ov5640.c                         |   1 +
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   1 +
 drivers/media/platform/marvell/mmp-driver.c        |  21 +-
 drivers/media/platform/nuvoton/npcm-video.c        |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   8 +-
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c         |   2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  83 +++-
 drivers/media/usb/uvc/uvc_driver.c                 |  98 ++--
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +
 drivers/media/usb/uvc/uvc_video.c                  |  21 +
 drivers/media/usb/uvc/uvcvideo.h                   |  10 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
 drivers/mfd/axp20x.c                               |   2 +-
 drivers/mfd/lpc_ich.c                              |   3 +-
 drivers/misc/fastrpc.c                             |   8 +-
 drivers/mmc/core/sdio.c                            |   2 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   1 +
 drivers/mmc/host/sdhci-msm.c                       |  53 ++-
 drivers/mtd/nand/onenand/onenand_base.c            |   1 +
 drivers/mtd/ubi/build.c                            |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  16 +-
 drivers/net/ethernet/broadcom/tg3.c                |  58 +++
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          | 150 +++++--
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |  43 --
 .../net/ethernet/marvell/octeon_ep/octep_ethtool.c |  39 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  19 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.h    |   6 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  11 +-
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h  |   4 +-
 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c  |   7 +-
 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h  |   4 +-
 .../marvell/octeon_ep_vf/octep_vf_ethtool.c        |  29 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |  17 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.h  |   6 +
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.c    |   9 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.h    |   2 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_tx.c    |   7 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_tx.h    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  24 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c |  17 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.h |   2 +-
 .../mellanox/mlx5/core/steering/hws/matcher.c      |  24 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  67 ++-
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/ipheth.c                           |  69 ++-
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |  14 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |   5 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  59 +--
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   8 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c        | 167 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  10 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  16 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   4 +-
 drivers/net/wireless/realtek/rtw88/rtw8703b.c      |   8 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.h      |   8 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |   9 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   9 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   9 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   2 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  16 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   9 +
 drivers/net/wireless/realtek/rtw89/pci_be.c        |   1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  13 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  56 ++-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fc.c                             |   9 +-
 drivers/nvme/host/pci.c                            |   4 +-
 drivers/nvme/host/sysfs.c                          |   2 +-
 drivers/nvme/target/admin-cmd.c                    |   1 +
 drivers/nvmem/core.c                               |   2 +
 drivers/nvmem/imx-ocotp-ele.c                      |  38 +-
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/of/address.c                               |  12 +-
 drivers/of/base.c                                  |   8 +-
 drivers/of/of_reserved_mem.c                       |   9 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  48 +-
 drivers/pci/endpoint/pci-epf-core.c                |   1 +
 drivers/pci/tph.c                                  |   2 +-
 drivers/perf/fsl_imx9_ddr_perf.c                   |  33 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/platform/x86/acer-wmi.c                    |  45 ++
 drivers/platform/x86/intel/int3472/discrete.c      |   3 +
 drivers/platform/x86/intel/int3472/tps68470.c      |   3 +
 drivers/platform/x86/serdev_helpers.h              |   4 +-
 drivers/ptp/ptp_clock.c                            |   8 +
 drivers/pwm/pwm-microchip-core.c                   |   2 +-
 drivers/remoteproc/omap_remoteproc.c               |  17 +
 drivers/rtc/rtc-zynqmp.c                           |   4 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c                     | 122 ++++-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
 drivers/scsi/qla2xxx/qla_init.c                    |  28 +-
 drivers/scsi/scsi_lib.c                            |   9 +-
 drivers/scsi/st.c                                  |   6 +
 drivers/scsi/st.h                                  |   1 +
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/soc/mediatek/mtk-devapc.c                  |  19 +-
 drivers/soc/qcom/llcc-qcom.c                       |   1 +
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/soc/samsung/exynos-pmu.c                   |   2 +-
 drivers/spi/atmel-quadspi.c                        | 118 +++--
 drivers/tty/serial/sh-sci.c                        |  25 +-
 drivers/tty/serial/xilinx_uartps.c                 |   8 +-
 drivers/tty/vt/selection.c                         |  14 +
 drivers/tty/vt/vt.c                                |   2 -
 drivers/ufs/core/ufshcd.c                          |  31 +-
 drivers/ufs/host/ufs-qcom.c                        |  18 +-
 drivers/ufs/host/ufshcd-pci.c                      |   2 -
 drivers/ufs/host/ufshcd-pltfrm.c                   |  28 +-
 drivers/usb/gadget/function/f_tcm.c                |  52 +--
 drivers/vfio/platform/vfio_platform_common.c       |  10 +
 fs/binfmt_flat.c                                   |   2 +-
 fs/btrfs/ctree.c                                   |   2 +
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/ordered-data.c                            |  12 +
 fs/btrfs/qgroup.c                                  |   5 +-
 fs/btrfs/raid-stripe-tree.c                        |  26 +-
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/transaction.c                             |   4 +-
 fs/ceph/mds_client.c                               |  16 +-
 fs/exec.c                                          |  29 +-
 fs/namespace.c                                     |  54 ++-
 fs/nfs/Kconfig                                     |   3 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  27 +-
 fs/nfsd/nfs4xdr.c                                  |  20 +-
 fs/nilfs2/inode.c                                  |   6 +-
 fs/ocfs2/super.c                                   |   2 +-
 fs/ocfs2/symlink.c                                 |   5 +-
 fs/pidfs.c                                         |  34 ++
 fs/proc/array.c                                    |   2 +-
 fs/smb/client/cifsglob.h                           |  14 +-
 fs/smb/client/dir.c                                |   6 +-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2inode.c                          | 108 ++---
 fs/smb/client/smb2ops.c                            |  41 +-
 fs/smb/client/smb2pdu.c                            |   2 +-
 fs/smb/client/smb2proto.h                          |   2 +-
 fs/smb/server/transport_ipc.c                      |   9 +
 fs/xfs/xfs_exchrange.c                             |  71 ++-
 fs/xfs/xfs_inode.c                                 |   7 +-
 fs/xfs/xfs_iomap.c                                 |   6 +-
 include/drm/drm_connector.h                        |   5 +-
 include/drm/drm_utils.h                            |   4 +
 include/linux/binfmts.h                            |   4 +-
 include/linux/call_once.h                          |  45 ++
 include/linux/hrtimer_defs.h                       |   1 +
 include/linux/jiffies.h                            |   2 +-
 include/linux/kvm_host.h                           |   9 +
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/platform_data/x86/asus-wmi.h         |   5 +
 include/net/sch_generic.h                          |   2 +-
 include/rv/da_monitor.h                            |   4 +
 include/trace/events/rxrpc.h                       |   1 +
 include/uapi/drm/amdgpu_drm.h                      |   9 +-
 include/uapi/linux/input-event-codes.h             |   1 +
 include/uapi/linux/iommufd.h                       |   4 +-
 include/uapi/linux/raid/md_p.h                     |   2 +-
 include/uapi/linux/raid/md_u.h                     |   2 +
 include/ufs/ufs.h                                  |   4 +-
 include/ufs/ufshcd.h                               |   1 -
 io_uring/net.c                                     |   5 +
 io_uring/poll.c                                    |   4 +
 kernel/bpf/verifier.c                              |   2 +-
 kernel/locking/test-ww_mutex.c                     |   9 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |  28 +-
 kernel/sched/deadline.c                            |  56 ++-
 kernel/sched/fair.c                                |  19 +
 kernel/sched/sched.h                               |   2 +-
 kernel/seccomp.c                                   |  12 +
 kernel/time/hrtimer.c                              | 103 ++++-
 kernel/time/timer_migration.c                      |  10 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace_functions_graph.c               |   2 +-
 kernel/trace/trace_osnoise.c                       |  17 +-
 lib/Kconfig.debug                                  |   8 +-
 lib/atomic64.c                                     |  78 ++--
 lib/maple_tree.c                                   |  23 +-
 mm/compaction.c                                    |   3 +-
 mm/gup.c                                           |  14 +-
 mm/hugetlb.c                                       |  24 +-
 mm/kfence/core.c                                   |   2 +
 mm/kmemleak.c                                      |   2 +-
 mm/vmscan.c                                        |   7 +-
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/bluetooth/mgmt.c                               |  12 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/ethtool/rss.c                                  |   3 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/udp.c                                     |   4 +-
 net/ncsi/ncsi-manage.c                             |  13 +-
 net/nfc/nci/hci.c                                  |   2 +
 net/rose/af_rose.c                                 |  24 +-
 net/rxrpc/ar-internal.h                            |   2 +-
 net/rxrpc/call_object.c                            |   6 +-
 net/rxrpc/conn_event.c                             |  21 +-
 net/rxrpc/conn_object.c                            |   1 +
 net/rxrpc/input.c                                  |   2 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/sch_fifo.c                               |   3 +
 net/sched/sch_netem.c                              |   2 +-
 net/tipc/crypto.c                                  |   4 +-
 rust/kernel/init.rs                                |   2 +-
 scripts/Makefile.extrawarn                         |   5 +-
 scripts/gdb/linux/cpus.py                          |   2 +-
 scripts/generate_rust_target.rs                    |  18 +
 security/keys/trusted-keys/trusted_dcp.c           |  22 +-
 security/safesetid/securityfs.c                    |   3 +
 security/tomoyo/common.c                           |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   8 +-
 sound/pci/hda/hda_auto_parser.h                    |   1 +
 sound/pci/hda/patch_realtek.c                      |  20 +-
 sound/soc/amd/Kconfig                              |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  28 ++
 sound/soc/intel/boards/sof_sdw.c                   |   5 +-
 sound/soc/renesas/rz-ssi.c                         |  10 +-
 sound/soc/soc-pcm.c                                |  32 +-
 sound/soc/sof/intel/hda-dai.c                      |  12 +
 sound/soc/sof/intel/hda.c                          |   5 +
 tools/perf/bench/epoll-wait.c                      |   7 +-
 .../testing/selftests/bpf/progs/exceptions_fail.c  |   4 +-
 tools/testing/selftests/bpf/progs/preempt_lock.c   |  14 +-
 .../selftests/bpf/progs/verifier_spin_lock.c       |   2 +-
 tools/testing/selftests/drivers/net/hw/rss_ctx.py  |   2 +
 tools/testing/selftests/net/ipsec.c                |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/net/udpgso.c               |  26 ++
 tools/tracing/rtla/src/osnoise.c                   |   2 +-
 tools/tracing/rtla/src/timerlat_hist.c             |  26 +-
 tools/tracing/rtla/src/timerlat_top.c              |  27 +-
 tools/tracing/rtla/src/trace.c                     |   8 +
 tools/tracing/rtla/src/trace.h                     |   1 +
 479 files changed, 5359 insertions(+), 2651 deletions(-)


