Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA82798F3;
	Fri, 15 May 2026 16:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861882; cv=none; b=j4OYRzHiH0wd2jQh3IpNUhIJKjRR7xWF77vlUUQKcv3ipXnCoaSnSiA4NOjYMAon6jImmJb8M6k0+C3rJTkOSeyAM018ThlglJINICQpBGwktnnmKqSFD2pq6MpxCPImd+YJ57rVDUsZO7vb6dop86vCCWxrKToNOI0O5f4FVRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861882; c=relaxed/simple;
	bh=ZUCpJk6cNsJb+RRXpBxopOFUDs8bR0/eFktRVSlYAyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AwaLkWqdOfQqWpvGo8diXwWoCakMBkMAGvChA5y2kxl9Ln1yHMWX7Cc823Sn1to3KNLvhiKGx6hFNoJmCG8cIORF9Xdo7vduIkJyiiUoMljULPgMrPJgIkSkcgL6etZKDihY+PAxFmY06oI9r3Et2TFUcIRbAWCj6sQQDs2QOCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCeeVXuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCeeVXuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB6AC2BCB0;
	Fri, 15 May 2026 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861882;
	bh=ZUCpJk6cNsJb+RRXpBxopOFUDs8bR0/eFktRVSlYAyE=;
	h=From:To:Cc:Subject:Date:From;
	b=sCeeVXuYb0Mot8pkIdxxLAtmqA2RRoVL3OY3vpcK9Sn3TbGlO9nHEl6o+ID4MGs2Z
	 aIGz2tWyugI5inbBt1XuwdPMo0x9LCMi7LSWoqX8+qc/RTz7o763Eup3wso0D2eWxd
	 Rf2u8kjirmj1R0XJ9qIz6IDD9YCnG+q2f8n0hW3Q=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 000/188] 6.18.32-rc1 review
Date: Fri, 15 May 2026 17:46:57 +0200
Message-ID: <20260515154657.309489048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.32-rc1
X-KernelTest-Deadline: 2026-05-17T15:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.32 release.
There are 188 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.32-rc1

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Avoid overflow on msg bound check

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn3: Avoid overflow on msg bound check

Dudu Lu <phx0fer@gmail.com>
    vsock/virtio: fix accept queue count leak on transport mismatch

Eric Dumazet <edumazet@google.com>
    vsock/virtio: fix potential unbounded skb queue

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix empty payload in tap skb for non-linear buffers

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix length and offset in tap skb for split packets

Norbert Szetei <norbert@doyensec.com>
    vsock: fix buffer size clamping order

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: fix tp_num leak on kmalloc failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/fprobe: Remove fprobe from hash in failure path

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/fprobe: Unregister fprobe even if memory allocation fails

Menglong Dong <menglong8.dong@gmail.com>
    tracing: fprobe: optimization for entry only case

Menglong Dong <menglong8.dong@gmail.com>
    tracing: fprobe: use rhltable for fprobe_ip_table

Yochai Eisenrich <yochaie@sweet.security>
    btrfs: fix btrfs_ioctl_space_info() slot_count TOCTOU which can lead to info-leak

Guangshuo Li <lgs201920130244@gmail.com>
    btrfs: fix double free in create_space_info_sub_group() error path

Filipe Manana <fdmanana@suse.com>
    btrfs: remove fs_info argument from btrfs_sysfs_add_space_info_type()

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Move GUID programming after PHY initialization

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: dwc3: Add dwc pointer to dwc3_readl/writel

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: dwc3: Remove of dep->regs

Tejun Heo <tj@kernel.org>
    sched_ext: Read scx_root under scx_cgroup_ops_rwsem in cgroup setters

zhidao su <suzhidao@xiaomi.com>
    sched/ext: Implement cgroup_set_idle() callback

David Carlier <devnexen@gmail.com>
    Bluetooth: hci_conn: fix potential UAF in create_big_sync

Johan Hovold <johan@kernel.org>
    spi: zynq-qspi: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: zynq-qspi: Simplify clock handling with devm_clk_get_enabled()

Johan Hovold <johan@kernel.org>
    spi: tegra114: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: tegra20-sflash: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: uniphier: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: uniphier: Simplify clock handling with devm_clk_get_enabled()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    pseries/papr-hvpipe: Fix race with interrupt handler

Christian Brauner <brauner@kernel.org>
    papr-hvpipe: convert papr_hvpipe_dev_create_handle() to FD_PREPARE()

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    EDAC/versalnet: Fix device name memory leak

Damien Le Moal <dlemoal@kernel.org>
    block: fix zone write plug removal

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Avoid OOB font access if console rotation fails

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Rename struct fbcon_ops to struct fbcon_par

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework how we handle TLB fences

Prike Liang <Prike.Liang@amd.com>
    Revert "drm/amdgpu: don't attach the tlb fence for SI"

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix validating flush_gpu_tlb_pasid()

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: validate the flush_gpu_tlb_pasid()

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow time-quota setting zero esz

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: reset internal port states on soft reset AMS

SeongJae Park <sj@kernel.org>
    mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values

SeongJae Park <sj@kernel.org>
    mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values

SeongJae Park <sj@kernel.org>
    mm/damon/core: implement damon_kdamond_pid()

Xianglai Li <lixianglai@loongson.cn>
    LoongArch: KVM: Compile switch.S directly into the kernel

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: warn on freelist violations

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: use guards for locking

Andrea Righi <arighi@nvidia.com>
    sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: put backbone reference on failed claim hash insert

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: only purge non-released claims

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent use-after-free when deleting claims

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: stop caching unowned originator pointers in BAT IV

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: stop tp_meter sessions during mesh teardown

Jiexun Wang <wangjiexun2025@gmail.com>
    batman-adv: reject new tp_meter sessions during teardown

Lyes Bourennani <lbourennani@fuzzinglabs.com>
    batman-adv: fix integer overflow on buff_pos

Ben Morris <bmorris@anthropic.com>
    sctp: revalidate list cursor after sctp_sendmsg_to_asoc() in SCTP_SENDALL

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-am62a7-sk: Fix pin name in comment from M19 to N22

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Correct QUP interrupt numbers

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: align Hawaii mclk workaround with radeon

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: add missing revision check for CI

John B. Moore <jbmoore61@gmail.com>
    drm/amdgpu/sdma4: replace BUG_ON with WARN_ON in fence emission

Felix Kuehling <felix.kuehling@amd.com>
    drm/amdkfd: Make all TLB-flushes heavy-weight

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm/panel: boe-tv101wum-nl6: restore MODE_LPM after sending disable cmds

Kory Maincent (TI) <kory.maincent@bootlin.com>
    drm/bridge: tda998x: Use __be32 for audio port OF property pointer

John B. Moore <jbmoore61@gmail.com>
    drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm/panel: himax-hx83102: restore MODE_LPM after sending disable cmds

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/exynos: remove bridge when component_add fails

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: zero-initialize GART table on allocation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing revision check for CI

Francis, David <David.Francis@amd.com>
    drm: Set old handle to NULL before prime swap in change_handle

Jia Yao <jia.yao@intel.com>
    drm/xe/uapi: Reject coh_none PAT index for CPU cached memory in madvise

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/bo: Fix bo leak on unaligned size validation in xe_bo_init_locked()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix dma-buf attachment leak in xe_gem_prime_import()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/bo: Fix bo leak on GGTT flag validation in xe_bo_init_locked()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix bo leak in xe_dma_buf_init_obj() on allocation failure

Shixiong Ou <oushixiong@kylinos.cn>
    drm/udl: Increase GET_URB_TIMEOUT

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: validate SVM ioctl nattr against buffer size

Sasha Finkelstein <k@chaosmail.tech>
    drm/appletbdrm: Use kvzalloc for big allocations

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Change dither policy for 10 bpc output back to dithering

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn3: Prevent OOB reads when parsing dec msg

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vce: Prevent partial address patches

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Prevent OOB reads when parsing IB

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu: Add bounds checking to ib_{get,set}_value

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: Add upper bound check for num_of_nodes

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix incorrect FeatureCtrlMask setting on smu v14.0.x

Chenglei Xie <Chenglei.Xie@amd.com>
    drm/amdgpu: gate VM CPU HDP flush on reset lock

Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>
    drm/amdgpu: Use SMUIO 15.0.0 offsets for TSC upper and lower count.

Amir Shetaia <Amir.Shetaia@amd.com>
    drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Init variable to avoid early exit from et alignment loop

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: always recover the gpu

Marek Vasut <marex@nabladev.com>
    drm/imx: parallel-display: Prefer bus format set via legacy "interface-pix-fmt" DT property

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    drm/msm/gem: fix error handling in msm_ioctl_gem_info_get_metadata()

Johan Hovold <johan@kernel.org>
    spi: cadence: fix clock imbalance on probe failure

Johan Hovold <johan@kernel.org>
    spi: cadence: fix unclocked access on unbind

Johan Hovold <johan@kernel.org>
    spi: cadence: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix use-after-free on registration failure

Johan Hovold <johan@kernel.org>
    spi: orion: fix clock imbalance on registration failure

Johan Hovold <johan@kernel.org>
    spi: orion: fix runtime pm leak on unbind

Johan Hovold <johan@kernel.org>
    spi: orion: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mxic: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: imx: fix runtime pm leak on probe deferral

Johan Hovold <johan@kernel.org>
    spi: mpfs: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: img-spfi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: slave-mt27xx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sh-msiof: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: rspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sprd: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: pic32-sqi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: cavium-thunderx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: npcm-pspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: coldfire-qspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: bcmbca-hsspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: fsl: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sh-hspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: ch341: fix devres lifetime

Johan Hovold <johan@kernel.org>
    spi: pl022: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mtk-nor: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: pic32: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: omap2-mcspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: fsl-espi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: s3c64xx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: dln2: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mt65xx: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: mxs: fix controller deregistration

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: qcom: camss: Add missing clocks for VFE lite on sa8775p

Thomas Fourier <fourier.thomas@gmail.com>
    media: iris: Fix dma_free_attrs() size in iris_hfi_queues_init()

Arnd Bergmann <arnd@arndb.de>
    media: venus: fix QCOM_MDT_LOADER dependency

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: qcom: iris: increase H265D_MAX_SLICE to fix H.265 decoding on SC7280

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: qcom: camss: Fix csid IRQ offset for sa8775p

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: qcom: camss: Fix csid clock configuration for sa8775p

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: iris: Fix use-after-free in iris_release_internal_buffers()

Arnd Bergmann <arnd@arndb.de>
    media: iris: fix QCOM_MDT_LOADER dependency

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: omap3isp: drop the use count of v4l2 pipeline

Matthias Fend <matthias.fend@emfend.at>
    media: i2c: ov08d10: fix runtime PM handling in probe

Matthias Fend <matthias.fend@emfend.at>
    media: i2c: ov08d10: fix image vertical start setting

Michael Tretter <m.tretter@pengutronix.de>
    media: staging: imx: request mbus_config in csi_start

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: i2c: imx412: Assert reset GPIO during probe

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    media: dib8000: avoid division by 0 in dib8000_set_dds()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    media: pci: zoran: fix potential memory leak in zoran_probe()

Gregor Herburger <gregor.herburger@linutronix.de>
    arm64: dts: broadcom: bcm2712-d-rpi-5-b: update uart10 interrupt

Gregor Herburger <gregor.herburger@linutronix.de>
    arm64: dts: broadcom: bcm2712-d-rpi-5-b: add fixes for pinctrl/pinctrl_aon

Luigi Leonardi <leonardi@redhat.com>
    vsock/virtio: fix MSG_PEEK ignoring skb offset when calculating bytes to copy

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Ignore backlight and FnLock events

Johan Hovold <johan@kernel.org>
    spi: aspeed-smc: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: amlogic-spisg: fix controller deregistration

Wang Jun <1742789905@qq.com>
    media: saa7164: add ioremap return checks and cleanups

Johan Hovold <johan@kernel.org>
    spi: at91-usart: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: qup: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: meson-spicc: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: lantiq-ssc: fix controller deregistration

Johan Hovold <johan@kernel.org>
    regulator: bd9571mwv: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: s2dos05: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: act8945a: fix OF node reference imbalance

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx283: Fix hang when going from large to small resolution

Ethan Tidmore <ethantidmore06@gmail.com>
    media: intel/ipu6: fix error pointer dereference

Janne Grunau <j@jannau.net>
    media: videobuf2: Set vma_flags in vb2_dma_sg_mmap

Johan Hovold <johan@kernel.org>
    regulator: rk808: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: bq257xx: fix OF node reference imbalance

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx283: Enter full standby when stopping streaming

Oliver Neukum <oneukum@suse.com>
    media: rc: streamzap: Error handling in probe

Oliver Neukum <oneukum@suse.com>
    media: rc: xbox_remote: heed DMA restrictions

Johan Hovold <johan@kernel.org>
    regulator: max77650: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    spi: st-ssc4: fix controller deregistration

Johan Hovold <johan@kernel.org>
    regulator: mt6357: fix OF node reference imbalance

Sakari Ailus <sakari.ailus@linux.intel.com>
    staging: media: atomisp: Disallow all private IOCTLs

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a-cex7/lx2162a-sr-som: fix usd-cd & gpio pinmux

Johan Hovold <johan@kernel.org>
    spi: atmel: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: bcm63xx: fix controller deregistration

Matthew Brost <matthew.brost@intel.com>
    drm/gpusvm: Force unmapping on error in drm_gpusvm_get_pages

Ziyi Guo <n7l8m4@u.northwestern.edu>
    media: chips-media: wave5: add missing spinlock protection for handle_dynamic_resolution_change()

Ziyi Guo <n7l8m4@u.northwestern.edu>
    media: chips-media: wave5: add missing spinlock protection for send_eos_event()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: chips-media: wave5: fix a potential memory leak in wave5_vdi_init()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    media: dt-bindings: rockchip,vdec: Mark reg-names required for RK35{76,88}

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    media: dt-bindings: rockchip,vdec: Add alternative reg-names order for RK35{76,88}

Alexander Koskovich <akoskovich@pm.me>
    media: i2c: ov8856: free control handler on error in ov8856_init_controls()

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    media: renesas: vin: Fix RAW8 (again)

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    media: renesas: vsp1: Fix NULL pointer deref on module unload

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: Reduce minimum queued buffers from 2 to 0

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi: Fix wrong CTRL1 register used in writing info frames

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Enable VB2_DMABUF for metadata stream

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Fix integer overflow in pidff_rescale

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: pass the buffer size to hid_report_raw_event

Sangyun Kim <sangyun.kim@snu.ac.kr>
    HID: appletb-kbd: run inactivity autodim from workqueues

Sangyun Kim <sangyun.kim@snu.ac.kr>
    HID: appletb-kbd: fix UAF in inactivity-timer cleanup path

T.J. Mercier <tjmercier@google.com>
    HID: playstation: Clamp num_touch_reports


-------------

Diffstat:

 .../devicetree/bindings/media/rockchip,vdec.yaml   |  22 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts |  14 +
 .../arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi |   7 +
 .../dts/freescale/fsl-lx2160a-clearfog-itx.dtsi    |   2 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  24 ++
 .../boot/dts/freescale/fsl-lx2162a-clearfog.dts    |   2 +
 .../boot/dts/freescale/fsl-lx2162a-sr-som.dtsi     |   7 +
 arch/arm64/boot/dts/qcom/lemans.dtsi               |   8 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 +-
 arch/loongarch/Kbuild                              |   2 +-
 arch/loongarch/include/asm/asm-prototypes.h        |  20 +
 arch/loongarch/include/asm/kvm_host.h              |   3 -
 arch/loongarch/kvm/Makefile                        |   3 +-
 arch/loongarch/kvm/main.c                          |  35 +-
 arch/loongarch/kvm/switch.S                        |  20 +-
 arch/powerpc/platforms/pseries/papr-hvpipe.c       |  59 +--
 block/blk-zoned.c                                  | 149 +++-----
 drivers/edac/versalnet_edac.c                      |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c           |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c         |  12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  31 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  25 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  46 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  33 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  11 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   2 +-
 .../gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c    |  13 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  10 +-
 drivers/gpu/drm/bridge/tda998x_drv.c               |   2 +-
 drivers/gpu/drm/drm_gem.c                          |  25 +-
 drivers/gpu/drm/drm_gem_framebuffer_helper.c       |   4 +-
 drivers/gpu/drm/drm_gpusvm.c                       |   1 +
 drivers/gpu/drm/exynos/exynos_drm_mic.c            |   8 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   2 +-
 drivers/gpu/drm/imx/ipuv3/parallel-display.c       |  15 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   7 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |  42 +--
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   2 +
 drivers/gpu/drm/panel/panel-himax-hx83102.c        |   2 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |   9 +-
 drivers/gpu/drm/tiny/appletbdrm.c                  |   4 +-
 drivers/gpu/drm/udl/udl_main.c                     |   3 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |   5 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   8 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |  23 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c                 |  47 +++
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   6 +-
 drivers/hid/hid-appletb-kbd.c                      |  58 +--
 drivers/hid/hid-core.c                             |  67 +++-
 drivers/hid/hid-gfrm.c                             |   4 +-
 drivers/hid/hid-logitech-hidpp.c                   |   2 +-
 drivers/hid/hid-multitouch.c                       |   2 +-
 drivers/hid/hid-playstation.c                      |   6 +-
 drivers/hid/hid-primax.c                           |   2 +-
 drivers/hid/hid-vivaldi-common.c                   |   2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   7 +-
 drivers/hid/usbhid/hid-core.c                      |  11 +-
 drivers/hid/usbhid/hid-pidff.c                     |   7 +-
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   1 +
 drivers/media/dvb-frontends/dib8000.c              |   4 +-
 drivers/media/i2c/imx283.c                         |  15 +-
 drivers/media/i2c/imx412.c                         |   2 +-
 drivers/media/i2c/ov08d10.c                        |  21 +-
 drivers/media/i2c/ov8856.c                         |  10 +-
 drivers/media/pci/intel/ipu6/ipu6.c                |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  47 ++-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 .../media/platform/chips-media/wave5/wave5-vdi.c   |   1 +
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  14 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 .../media/platform/qcom/camss/camss-csid-gen3.c    |   6 +-
 drivers/media/platform/qcom/camss/camss.c          |  80 ++--
 drivers/media/platform/qcom/iris/Kconfig           |   2 +-
 drivers/media/platform/qcom/iris/iris_buffer.c     |   8 +-
 drivers/media/platform/qcom/iris/iris_hfi_queue.c  |   2 +-
 drivers/media/platform/qcom/iris/iris_vpu_buffer.h |   2 +-
 drivers/media/platform/qcom/venus/Kconfig          |   2 +-
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c |  22 ++
 .../media/platform/renesas/rcar-vin/rcar-v4l2.c    |  12 +
 drivers/media/platform/renesas/vsp1/vsp1_drv.c     |   8 +-
 drivers/media/platform/ti/omap3isp/ispvideo.c      |   1 +
 drivers/media/rc/streamzap.c                       |  12 +-
 drivers/media/rc/xbox_remote.c                     |   9 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/platform/x86/hp/hp-wmi.c                   |   5 +
 drivers/regulator/act8945a-regulator.c             |   3 +-
 drivers/regulator/bd9571mwv-regulator.c            |   3 +-
 drivers/regulator/bq257xx-regulator.c              |   3 +-
 drivers/regulator/max77650-regulator.c             |   2 +-
 drivers/regulator/mt6357-regulator.c               |   2 +-
 drivers/regulator/rk808-regulator.c                |   3 +-
 drivers/regulator/s2dos05-regulator.c              |   2 +-
 drivers/spi/spi-amlogic-spisg.c                    |   4 +-
 drivers/spi/spi-aspeed-smc.c                       |   9 +-
 drivers/spi/spi-at91-usart.c                       |   8 +-
 drivers/spi/spi-atmel.c                            |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   8 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |   4 +-
 drivers/spi/spi-cadence.c                          |  21 +-
 drivers/spi/spi-cavium-thunderx.c                  |   8 +-
 drivers/spi/spi-ch341.c                            |   7 +-
 drivers/spi/spi-coldfire-qspi.c                    |  10 +-
 drivers/spi/spi-dln2.c                             |   8 +-
 drivers/spi/spi-fsl-espi.c                         |  10 +-
 drivers/spi/spi-fsl-spi.c                          |  14 +-
 drivers/spi/spi-img-spfi.c                         |   8 +-
 drivers/spi/spi-imx.c                              |   1 +
 drivers/spi/spi-lantiq-ssc.c                       |   8 +-
 drivers/spi/spi-meson-spicc.c                      |   8 +-
 drivers/spi/spi-mpc52xx.c                          |   9 +-
 drivers/spi/spi-mpfs.c                             |   4 +-
 drivers/spi/spi-mt65xx.c                           |   4 +-
 drivers/spi/spi-mtk-nor.c                          |   4 +-
 drivers/spi/spi-mxic.c                             |   3 +-
 drivers/spi/spi-mxs.c                              |   8 +-
 drivers/spi/spi-npcm-pspi.c                        |   8 +-
 drivers/spi/spi-omap2-mcspi.c                      |   8 +-
 drivers/spi/spi-orion.c                            |  16 +-
 drivers/spi/spi-pic32-sqi.c                        |   8 +-
 drivers/spi/spi-pic32.c                            |  11 +-
 drivers/spi/spi-pl022.c                            |   8 +-
 drivers/spi/spi-qup.c                              |   8 +-
 drivers/spi/spi-rspi.c                             |  10 +-
 drivers/spi/spi-s3c64xx.c                          |   4 +-
 drivers/spi/spi-sh-hspi.c                          |  10 +-
 drivers/spi/spi-sh-msiof.c                         |  10 +-
 drivers/spi/spi-slave-mt27xx.c                     |  10 +-
 drivers/spi/spi-sprd.c                             |   8 +-
 drivers/spi/spi-st-ssc4.c                          |   8 +-
 drivers/spi/spi-tegra114.c                         |   8 +-
 drivers/spi/spi-tegra20-sflash.c                   |   8 +-
 drivers/spi/spi-uniphier.c                         |  24 +-
 drivers/spi/spi-zynq-qspi.c                        |  55 +--
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c  |   4 +
 drivers/staging/media/imx/imx-media-csi.c          |  40 +-
 drivers/usb/dwc3/core.c                            | 204 +++++-----
 drivers/usb/dwc3/core.h                            |  10 +-
 drivers/usb/dwc3/debugfs.c                         |  44 +--
 drivers/usb/dwc3/drd.c                             |  76 ++--
 drivers/usb/dwc3/ep0.c                             |  20 +-
 drivers/usb/dwc3/gadget.c                          | 162 ++++----
 drivers/usb/dwc3/gadget.h                          |   4 +-
 drivers/usb/dwc3/io.h                              |   7 +-
 drivers/usb/dwc3/ulpi.c                            |  10 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +
 drivers/video/fbdev/core/bitblit.c                 | 120 +++---
 drivers/video/fbdev/core/fbcon.c                   | 419 ++++++++++-----------
 drivers/video/fbdev/core/fbcon.h                   |   6 +-
 drivers/video/fbdev/core/fbcon_ccw.c               | 146 +++----
 drivers/video/fbdev/core/fbcon_cw.c                | 146 +++----
 drivers/video/fbdev/core/fbcon_rotate.c            |  43 ++-
 drivers/video/fbdev/core/fbcon_rotate.h            |   6 +-
 drivers/video/fbdev/core/fbcon_ud.c                | 162 ++++----
 drivers/video/fbdev/core/softcursor.c              |  18 +-
 drivers/video/fbdev/core/tileblit.c                |  28 +-
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/btrfs/space-info.c                              |   8 +-
 fs/btrfs/sysfs.c                                   |   5 +-
 fs/btrfs/sysfs.h                                   |   3 +-
 include/linux/damon.h                              |   1 +
 include/linux/fprobe.h                             |   3 +-
 include/linux/hid.h                                |   6 +-
 include/linux/hid_bpf.h                            |  14 +-
 include/linux/sched/ext.h                          |   1 +
 io_uring/zcrx.c                                    |  17 +-
 kernel/sched/ext.c                                 |  26 +-
 kernel/sched/ext_internal.h                        |  13 +-
 kernel/trace/fprobe.c                              | 380 +++++++++++++------
 mm/damon/core.c                                    |  25 +-
 mm/damon/lru_sort.c                                |  83 ++--
 mm/damon/reclaim.c                                 |  83 ++--
 net/batman-adv/bat_iv_ogm.c                        |  85 +++--
 net/batman-adv/bridge_loop_avoidance.c             |  11 +-
 net/batman-adv/main.c                              |   1 +
 net/batman-adv/tp_meter.c                          | 116 +++++-
 net/batman-adv/tp_meter.h                          |   1 +
 net/batman-adv/types.h                             |   4 +
 net/bluetooth/hci_conn.c                           |  19 +-
 net/sctp/socket.c                                  |   9 +
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/vmw_vsock/virtio_transport_common.c            |  57 ++-
 196 files changed, 2699 insertions(+), 1709 deletions(-)


