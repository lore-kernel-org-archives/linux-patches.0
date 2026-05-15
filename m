Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204053F927B;
	Fri, 15 May 2026 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862433; cv=none; b=aaV0FG0GbZdevCirW9qtgMWxNx9YUWcO5vhqW/vKriqHDr8YWePQ92BUeD9KBadJ6GWU2inXeG913juaHieowXVw1HkzUmdK1lflwEggj9atBKm9vTpMD1ckSsnlGqBK3GSopfYskhtjQRp2zd+FoIQpeTFfxrIH8xtutpyNb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862433; c=relaxed/simple;
	bh=0ZmfI1J+qOacU5ewE+U00l5YCG/zkwLnSKtXI9WzNIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rHYg2FTYVlqp63RIr2Tb537imeSE6HLyVjofUNcsqpgoizwY2V3igwKBlVWUa/V+0WtZxuzkntGoVWirE3cQasWHEpjrT6VviZoIbxKy1nkmiKKGeTanwv1G6aZk/kfT7u298kBw8qoVObnlAT2am42XjGlL4OUPXH/PWOqfadE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGFKY9do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGFKY9do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F71FC2BCB0;
	Fri, 15 May 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862432;
	bh=0ZmfI1J+qOacU5ewE+U00l5YCG/zkwLnSKtXI9WzNIU=;
	h=From:To:Cc:Subject:Date:From;
	b=MGFKY9dod0VCOQFM1w5IGdTTGU1BpCLfnKeSDvDjkJTksYoS9maMRuXDVElVqSxOt
	 lrmdrW0HKC3fYettFD03RQzDHNzVMM3ANgpFN9Z5ywsems919DLS6Vmges4D7Vsnde
	 8WkxFzYIOV2brw0iIcVLGcI4eZrr47Tl3IlnONH4=
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
Subject: [PATCH 7.0 000/201] 7.0.9-rc1 review
Date: Fri, 15 May 2026 17:46:58 +0200
Message-ID: <20260515154658.538039039@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.9-rc1
X-KernelTest-Deadline: 2026-05-17T15:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.9 release.
There are 201 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.9-rc1

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

Lorenzo Stoakes <ljs@kernel.org>
    mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()

Markus Mayer <mmayer@broadcom.com>
    perf build: fix "argument list too long" in second location

Tejun Heo <tj@kernel.org>
    sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu()

Tejun Heo <tj@kernel.org>
    cgroup: Defer css percpu_ref kill on rmdir until cgroup is depopulated

Petr Malat <oss@malat.biz>
    cgroup: Increment nr_dying_subsys_* from rmdir context

Johan Hovold <johan@kernel.org>
    spi: uniphier: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: uniphier: Simplify clock handling with devm_clk_get_enabled()

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    EDAC/versalnet: Fix device name memory leak

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/versalnet: Refactor memory controller initialization and cleanup

Breno Leitao <leitao@debian.org>
    kho: fix error handling in kho_add_subtree()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: warn on freelist violations

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: use guards for locking

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: reset internal port states on soft reset AMS

Andrea Righi <arighi@nvidia.com>
    sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: put backbone reference on failed claim hash insert

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: only purge non-released claims

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent use-after-free when deleting claims

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: fix tp_num leak on kmalloc failure

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

Franz Schnyder <franz.schnyder@toradex.com>
    arm64: dts: ti: k3-am69-aquila-dev: Fix DP regulator enable GPIO

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-am62a7-sk: Fix pin name in comment from M19 to N22

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Correct QUP interrupt numbers

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    arm64: dts: qcom: kodiak: Fix PCIe1 PHY ref clock voting

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

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/sti: remove bridge when sti_hda component_add fails

Kory Maincent (TI) <kory.maincent@bootlin.com>
    drm/bridge: tda998x: Use __be32 for audio port OF property pointer

John B. Moore <jbmoore61@gmail.com>
    drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm/panel: himax-hx83102: restore MODE_LPM after sending disable cmds

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu/userq: fix access to stale wptr mapping

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

Shubhankar Milind Sardeshpande <Shubhankar.MilindSardeshpande@amd.com>
    drm/amdgpu: Avoid reset in AMDGPU unload path for APUs with GFX V11 and higher.

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

Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>
    drm/amdgpu: Use NBIF offset for register RCC_STRAP0_RCC_DEV0_EPF0_STRAP0 .

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Add missing firmware declaration for PSP v15.0.0

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: fix math_mod() using arg1 instead of arg2

Amir Shetaia <Amir.Shetaia@amd.com>
    drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Init variable to avoid early exit from et alignment loop

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/v3d: Reject empty multisync extension to prevent infinite loop

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: always recover the gpu

Marek Vasut <marex@nabladev.com>
    drm/imx: parallel-display: Prefer bus format set via legacy "interface-pix-fmt" DT property

Harry Wentland <harry.wentland@amd.com>
    drm/colorop: Fix blob property reference tracking in state lifecycle

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    drm/msm/gem: fix error handling in msm_ioctl_gem_info_get_metadata()

Johan Hovold <johan@kernel.org>
    spi: cadence-quadspi: fix unclocked access on unbind

Johan Hovold <johan@kernel.org>
    spi: cadence-quadspi: fix runtime pm and clock imbalance on unbind

Johan Hovold <johan@kernel.org>
    spi: cadence-quadspi: fix clock imbalance on probe failure

Johan Hovold <johan@kernel.org>
    spi: cadence-quadspi: fix runtime pm disable imbalance on probe failure

Johan Hovold <johan@kernel.org>
    spi: cadence: fix clock imbalance on probe failure

Johan Hovold <johan@kernel.org>
    spi: cadence: fix unclocked access on unbind

Johan Hovold <johan@kernel.org>
    spi: cadence-quadspi: fix controller deregistration

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
    spi: octeon: fix controller deregistration

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
    spi: ep93xx: fix controller deregistration

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

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe/hdcp: Add NULL check for media_gt in intel_hdcp_gsc_check_status()

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    media: qcom: camss: Add missing clocks for VFE lite on sa8775p

Vikash Garodia <vikash.garodia@oss.qualcomm.com>
    media: iris: switch to hardware mode after firmware boot

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: iris: fix use-after-free of fmt_src during MBPF check

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

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/atomic: Add affected colorops with affected planes

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/colorop: Preserve bypass value in duplicate_state()

Johan Hovold <johan@kernel.org>
    spi: aspeed-smc: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: amlogic-spisg: fix controller deregistration

Wang Jun <1742789905@qq.com>
    media: saa7164: add ioremap return checks and cleanups

Hans de Goede <johannes.goede@oss.qualcomm.com>
    media: ipu-bridge: Add upside-down sensor DMI quirk for Dell XPS 13 9340 and XPS 14 9440

Johan Hovold <johan@kernel.org>
    spi: at91-usart: fix controller deregistration

Franz Schnyder <franz.schnyder@toradex.com>
    arm64: dts: ti: k3-am69-aquila-clover: Fix DP regulator enable GPIO

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

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: mali-c55: Fully reset the ISP configuration

Dang Huynh <dang.huynh@mainlining.org>
    media: rockchip: rkcif: Add missing MUST_CONNECT flag to pads

Janne Grunau <j@jannau.net>
    media: videobuf2: Set vma_flags in vb2_dma_sg_mmap

Johan Hovold <johan@kernel.org>
    regulator: rk808: fix OF node reference imbalance

Johan Hovold <johan@kernel.org>
    regulator: bq257xx: fix OF node reference imbalance

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx283: Enter full standby when stopping streaming

Xiaolei Wang <xiaolei.wang@windriver.com>
    media: i2c: ov5647: Fix runtime PM refcount leak in s_ctrl

Oliver Neukum <oneukum@suse.com>
    media: rc: streamzap: Error handling in probe

Oliver Neukum <oneukum@suse.com>
    media: rc: xbox_remote: heed DMA restrictions

Felix Gu <ustc.gu@gmail.com>
    media: ti: vpe: Add missing v4l2_device_unregister in vip_remove()

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

Matthew Brost <matthew.brost@intel.com>
    drm/gpusvm: Allow device pages to be mapped in mixed mappings after system pages

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: freescale: imx95-toradex-smarc: fix PMIC_SD2_VSEL label position

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

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: mali-c55: Fix wrong comment of ISP block types

Daniel Scally <dan.scally@ideasonboard.com>
    media: mali-c55: Fix Iridix bypass macros

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: mali-c55: Initialize the ISP in enable_streams()

Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
    media: rzv2h-ivc: Fix concurrent buffer list access

Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
    media: rzv2h-ivc: Fix FM_STOP register write

Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
    media: rzv2h-ivc: Write AXIRX_PIXFMT once

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: Reduce minimum queued buffers from 2 to 0

Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
    media: rzv2h-ivc: Avoid double job scheduling

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
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts |  14 ++
 .../arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi |   7 +
 .../dts/freescale/fsl-lx2160a-clearfog-itx.dtsi    |   2 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  24 ++
 .../boot/dts/freescale/fsl-lx2162a-clearfog.dts    |   2 +
 .../boot/dts/freescale/fsl-lx2162a-sr-som.dtsi     |   7 +
 .../boot/dts/freescale/imx95-toradex-smarc.dtsi    |   1 -
 arch/arm64/boot/dts/qcom/kodiak.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |   8 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 +-
 arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts   |   2 +-
 arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts      |   2 +-
 drivers/edac/versalnet_edac.c                      | 182 ++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c           |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c         |  12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  31 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c         |  97 ++++----
 drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c           |   9 +-
 drivers/gpu/drm/amd/amdgpu/psp_v15_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  25 ++-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  46 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  33 ++-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  11 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   2 +-
 .../src/dml2_standalone_libraries/lib_float_math.c |   2 +-
 .../gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c    |  13 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  10 +-
 drivers/gpu/drm/bridge/tda998x_drv.c               |   2 +-
 drivers/gpu/drm/drm_atomic.c                       |   7 +
 drivers/gpu/drm/drm_colorop.c                      |  28 ++-
 drivers/gpu/drm/drm_gem.c                          |  25 ++-
 drivers/gpu/drm/drm_gem_framebuffer_helper.c       |   4 +-
 drivers/gpu/drm/drm_gpusvm.c                       |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_mic.c            |   8 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   2 +-
 drivers/gpu/drm/imx/ipuv3/parallel-display.c       |  15 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   7 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |  42 ++--
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   2 +
 drivers/gpu/drm/panel/panel-himax-hx83102.c        |   2 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |   9 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   8 +-
 drivers/gpu/drm/tiny/appletbdrm.c                  |   4 +-
 drivers/gpu/drm/udl/udl_main.c                     |   3 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |   5 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   |   5 +
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c           |  12 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   8 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |  23 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c                 |  47 ++++
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   6 +-
 drivers/hid/hid-appletb-kbd.c                      |  58 +++--
 drivers/hid/hid-core.c                             |  67 ++++--
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
 drivers/media/i2c/ov5647.c                         |  12 +-
 drivers/media/i2c/ov8856.c                         |  10 +-
 drivers/media/pci/intel/ipu-bridge.c               |  14 ++
 drivers/media/pci/intel/ipu6/ipu6.c                |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  47 +++-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 .../media/platform/arm/mali-c55/mali-c55-common.h  |   2 +
 .../media/platform/arm/mali-c55/mali-c55-core.c    |  35 ---
 drivers/media/platform/arm/mali-c55/mali-c55-isp.c |  37 +--
 .../media/platform/arm/mali-c55/mali-c55-params.c  | 128 ++++++++++-
 .../platform/arm/mali-c55/mali-c55-registers.h     |   4 +-
 .../media/platform/chips-media/wave5/wave5-vdi.c   |   1 +
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  14 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 .../media/platform/qcom/camss/camss-csid-gen3.c    |   6 +-
 drivers/media/platform/qcom/camss/camss.c          |  80 +++----
 drivers/media/platform/qcom/iris/Kconfig           |   2 +-
 drivers/media/platform/qcom/iris/iris_buffer.c     |   8 +-
 drivers/media/platform/qcom/iris/iris_core.c       |   4 +
 drivers/media/platform/qcom/iris/iris_hfi_common.c |   4 +
 drivers/media/platform/qcom/iris/iris_hfi_queue.c  |   2 +-
 drivers/media/platform/qcom/iris/iris_vdec.c       |   6 -
 drivers/media/platform/qcom/iris/iris_vdec.h       |   1 -
 drivers/media/platform/qcom/iris/iris_venc.c       |   6 -
 drivers/media/platform/qcom/iris/iris_venc.h       |   1 -
 drivers/media/platform/qcom/iris/iris_vidc.c       |   6 +-
 drivers/media/platform/qcom/iris/iris_vpu2.c       |   1 +
 drivers/media/platform/qcom/iris/iris_vpu3x.c      |   9 +-
 drivers/media/platform/qcom/iris/iris_vpu4x.c      |  24 +-
 drivers/media/platform/qcom/iris/iris_vpu_buffer.h |   2 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |  16 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.h |   3 +
 drivers/media/platform/qcom/venus/Kconfig          |   2 +-
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c |  22 ++
 .../media/platform/renesas/rcar-vin/rcar-v4l2.c    |  12 +
 .../platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c   |  35 +--
 .../media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h   |   8 +-
 drivers/media/platform/renesas/vsp1/vsp1_drv.c     |   8 +-
 .../platform/rockchip/rkcif/rkcif-interface.c      |   3 +-
 .../media/platform/rockchip/rkcif/rkcif-stream.c   |   2 +-
 drivers/media/platform/ti/omap3isp/ispvideo.c      |   1 +
 drivers/media/platform/ti/vpe/vip.c                |   1 +
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
 drivers/spi/spi-cadence-quadspi.c                  |  40 ++--
 drivers/spi/spi-cadence.c                          |  21 +-
 drivers/spi/spi-cavium-octeon.c                    |   8 +-
 drivers/spi/spi-cavium-thunderx.c                  |   8 +-
 drivers/spi/spi-ch341.c                            |   7 +-
 drivers/spi/spi-coldfire-qspi.c                    |  10 +-
 drivers/spi/spi-dln2.c                             |   8 +-
 drivers/spi/spi-ep93xx.c                           |   8 +-
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
 drivers/spi/spi-uniphier.c                         |  24 +-
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c  |   4 +
 drivers/staging/media/imx/imx-media-csi.c          |  40 ++--
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +
 include/linux/cgroup-defs.h                        |   4 +-
 include/linux/hid.h                                |   6 +-
 include/linux/hid_bpf.h                            |  14 +-
 include/linux/mm.h                                 |   2 +-
 io_uring/zcrx.c                                    |  17 +-
 kernel/cgroup/cgroup.c                             | 248 ++++++++++-----------
 kernel/liveupdate/kexec_handover.c                 |  13 +-
 kernel/sched/ext.c                                 |  12 +-
 mm/util.c                                          |  51 +++--
 mm/vma.c                                           |   3 +-
 net/batman-adv/bat_iv_ogm.c                        |  85 ++++---
 net/batman-adv/bridge_loop_avoidance.c             |  11 +-
 net/batman-adv/main.c                              |   1 +
 net/batman-adv/tp_meter.c                          | 116 ++++++++--
 net/batman-adv/tp_meter.h                          |   1 +
 net/batman-adv/types.h                             |   4 +
 net/sctp/socket.c                                  |   9 +
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/vmw_vsock/virtio_transport_common.c            |  57 ++---
 tools/perf/pmu-events/Build                        |   4 +-
 tools/testing/vma/include/dup.h                    |  41 ++--
 tools/testing/vma/include/stubs.h                  |   3 +-
 200 files changed, 1917 insertions(+), 988 deletions(-)


