Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0038617BD6;
	Thu,  5 Sep 2024 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725554210; cv=none; b=c2I7PmZ3qS3GGZ5ZE9HjwHVJtjImXIT0T4YffM30YoR4lU4MEnPOTxSpSYhzfFm3JlkqI7E3jvsQSJRuP0rEZGklZjozTzV/u40bPiX0Xujf43jsG/RjykdvOFCapnF6A+NylBnRkkuMiCaf3iflAbh50+nALz3Guvk15Nu23Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725554210; c=relaxed/simple;
	bh=+bDhq8WiBFagQjNnY55ou4WqXvQbLPRnxq76i5rBkz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r6sJFNmGnVCWC+WdfBJBWauMl8u5L5tTyJbHPvSQBxs7/wblpjbhUkr/hE2M1Qe849BKg/gmy69840FI+xyNhDFzuUulXYw/GnLJBfIxlO5p0ED7enunQ03htMrX3eU/haHi+dGeEaBpp00qkrgWN+75C14q9MKdlJcXD6vSRmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re/8WGcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re/8WGcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F283DC4CEC3;
	Thu,  5 Sep 2024 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725554209;
	bh=+bDhq8WiBFagQjNnY55ou4WqXvQbLPRnxq76i5rBkz0=;
	h=From:To:Cc:Subject:Date:From;
	b=re/8WGcyg3piApGI0j0+EuHhNa6mWxf/hM5zFmOyaC2RQeR0oQ0uvHdGwL8s8usGj
	 wXUVqUM8N+L8iFJdCkcTcUkrY2RjsdN3DiAPGJAUPeavhYtopcka0XqZagInMYN0LM
	 JZEtp+Q/HXvif7buccFsYj1vbAuaja6wPtHKkfoc=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.6 000/131] 6.6.50-rc2 review
Date: Thu,  5 Sep 2024 18:36:33 +0200
Message-ID: <20240905163540.863769972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.50-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.50-rc2
X-KernelTest-Deadline: 2024-09-07T16:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.50 release.
There are 131 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 07 Sep 2024 16:35:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.50-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.50-rc2

Richard Fitzgerald <rf@opensource.cirrus.com>
    i2c: Use IS_REACHABLE() for substituting empty ACPI functions

Breno Leitao <leitao@debian.org>
    virtio_net: Fix napi_skb_cache_put warning

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Enforce alignment of frame and interval

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip wbscl_set_scaler_filter if filter is null

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check BIOS images before it is used

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: use preferred link settings for dp signal only

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Correct the defined value for AMDGPU_DMUB_NOTIFICATION_MAX

winstang <winstang@amd.com>
    drm/amd/display: added NULL check at start of dc_validate_stream

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Don't use fsleep for PSR exit waits on dmub replay

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: add lock in kfd_process_dequeue_from_device

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: add lock in amdgpu_gart_invalidate_tlb

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: add skip_hw_access checks for sriov

Christoph Hellwig <hch@lst.de>
    block: remove the blk_flush_integrity call in blk_integrity_unregister

Julien Stephan <jstephan@baylibre.com>
    driver: iio: add missing checks on iio_info's callback access

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on blocks for inline_data inode

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: make hash table duplicates more survivable

Yazen Ghannam <yazen.ghannam@amd.com>
    hwmon: (k10temp) Check return value of amd_smn_read()

Olivier Dautricourt <olivierdautricourt@gmail.com>
    dmaengine: altera-msgdma: properly free descriptor in msgdma_free_descriptor

Olivier Dautricourt <olivierdautricourt@gmail.com>
    dmaengine: altera-msgdma: use irq variant of spin_lock/unlock while invoking callbacks

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Check if fully initialized before signalling HPD event via IRQ

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Revert "Add quota_change type"

Maxime Méré <maxime.mere@foss.st.com>
    crypto: stm32/cryp - call finalize with bh disabled

Haoran Liu <liuhaoran14@163.com>
    drm/meson: plane: Add error handling

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix incorrect page release

Ben Walsh <ben@jubnut.com>
    platform/chrome: cros_ec_lpc: MEC access can use an AML mutex

Casey Schaufler <casey@schaufler-ca.com>
    smack: tcp: ipv4, fix incorrect labeling

Andy Shevchenko <andy.shevchenko@gmail.com>
    regmap: spi: Fix potential off-by-one when calculating reserved size

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgu: fix Unintentional integer overflow for mall size

Jason Xing <kernelxing@tencent.com>
    net: remove NULL-pointer net parameter in ip_metrics_convert

Amir Goldstein <amir73il@gmail.com>
    fsnotify: clear PARENT_WATCHED flags lazily

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    usb: typec: ucsi: Fix null pointer dereference in trace

Simon Holesch <simon@holesch.de>
    usbip: Don't submit special requests twice

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-cci: Always assign *val

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Remove buggy bypass lock contention mitigation

Ken Sloat <ksloat@designlinxhs.com>
    pwm: xilinx: Fix u32 overflow issue in 32-bit width PWM mode.

Shannon Nelson <shannon.nelson@amd.com>
    ionic: fix potential irq name truncation

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Properly handle unexpected AQ completions

Chris Lew <quic_clew@quicinc.com>
    soc: qcom: smem: Add qcom_smem_bust_hwspin_lock_by_host()

Richard Maina <quic_rmaina@quicinc.com>
    hwspinlock: Introduce hwspin_lock_bust()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: check ieee80211_bss_info_change_notify() against MLD

Aleksandr Mishin <amishin@t-argos.ru>
    PCI: al: Check IORESOURCE_BUS existence during probe

Jagadeesh Kona <quic_jkona@quicinc.com>
    cpufreq: scmi: Avoid overflow of target_freq in fast switch

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    wifi: iwlwifi: remove fw_running op

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: update type of buf size to u32 for eeprom functions

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/kfd: Correct pinned buffer handling at kfd restore and validate process

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: ser: avoid multiple deinit on same CAM

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: check negtive return for table entries

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: the warning dereferencing obj for nbio_v7_4

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: check specific index for smu13

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: check specific index for aldebaran

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: fix the waring dereferencing hive

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: fix dereference after null check

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Fix the warning division or modulo by zero

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Check input value for CUSTOM profile mode setting on legacy SOCs

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: initialize 'ret' in ath11k_qmi_load_file_target_mem()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath12k: initialize 'ret' in ath12k_qmi_load_file_target_mem()

Leesoo Ahn <lsahn@ooseel.net>
    apparmor: fix possible NULL pointer dereference

Michael Chen <michael.chen@amd.com>
    drm/amdkfd: Reconcile the definition and use of oem_id in struct kfd_topology_device

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix mc_data out-of-bounds read warning

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix ucode out-of-bounds read warning

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number

Lin.Cao <lincao12@amd.com>
    drm/amdkfd: Check debug trap enable before write dbg_ev_file

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix out-of-bounds write warning

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix the uninitialized variable warning

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix uninitialized variable agc_btc_response

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix uninitialized variable warning for smu10

Tim Huang <Tim.Huang@amd.com>
    drm/amd/pm: fix uninitialized variable warnings for vangogh_ppt

Asad Kamal <asad.kamal@amd.com>
    drm/amd/amdgpu: Check tbo resource pointer

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix index may exceed array range within fpu_update_bw_bounding_box

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Skip inactive planes within ModeSupportAndSystemConfiguration

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Ensure index calculation will not overflow

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix Coverity INTEGER_OVERFLOW within decide_fallback_link_setting_max_bw_policy

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Spinlock before reading event

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix Coverity INTEGER_OVERFLOW within dal_gpio_service_create

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix Coverity INTERGER_OVERFLOW within construct_integrated_info

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check msg_id before processing transcation

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check num_valid_sets before accessing reader_wm_sets[]

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add array index check for hdcp ddc access

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index for aux_rd_interval before using

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Stop amdgpu_dm initialize when stream nums greater than 6

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check gpio_id before used as array index

Zhigang Luo <Zhigang.Luo@amd.com>
    drm/amdgpu: avoid reading vf2pf info size from FB

Tim Huang <Tim.Huang@amd.com>
    drm/amd/pm: fix uninitialized variable warnings for vega10_hwmgr

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: fix the Out-of-bounds read warning

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: Fix negative array index read

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: fix warning using uninitialized value of max_vid_step

Tim Huang <Tim.Huang@amd.com>
    drm/amd/pm: fix uninitialized variable warning for smu8_hwmgr

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: fix uninitialized variable warning

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Check the return value of smum_send_msg_to_smc

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix overflowed array index read warning

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Assign linear_pitch_alignment even for VM

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pr_debug: add missing \n at the end

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid duplicated SUB_CLOSED events

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: stop transfer when check is done (part 2.2)

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: disable get and dump addr checks

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: test for flush/re-add endpoints

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-re-adding ID 0 signal

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate event numbers

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: add mptcp_lib_events helper

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-adding init endp with != id

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-using ID of unused ADD_ADDR

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: add explicit test case for remove/readd

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: cannot rm sf if closed

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: declare event macros in mptcp_lib

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: userspace pm get addr tests

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: dump userspace addrs list

Geliang Tang <geliang.tang@suse.com>
    selftests: mptcp: userspace pm create id 0 subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix RM_ADDR ID for the initial subflow

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: make pm_remove_addrs_and_subflows static

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: codecs: ES8326: button detect issue

Krzysztof Stępniak <kfs.szk@gmail.com>
    ASoC: amd: yc: Support mic on Lenovo Thinkpad E14 Gen 6

ZHANG Yuntian <yt@radxa.com>
    net: usb: qmi_wwan: add MeiG Smart SRM825L

Rik van Riel <riel@surriel.com>
    dma-debug: avoid deadlock between dma debug vs printk and netconsole

Richard Fitzgerald <rf@opensource.cirrus.com>
    i2c: Fix conditional for substituting empty ACPI functions

Devyn Liu <liudingyuan@huawei.com>
    spi: hisi-kunpeng: Add validation for the minimum value of speed_hz

Bruno Ancona <brunoanconasala@gmail.com>
    ASoC: amd: yc: Support mic on HP 14-em0002la

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix FSCTL_GET_REPARSE_POINT against NetApp

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Fix 'stack guard page was hit' error in dr_rule

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Explicitly reset RPN with Null RPN

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Transmit RPN/NRPN message at each MSB/LSB data reception

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Use the common RPN/bank conversion context

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Explicitly reset RPN with Null RPN

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Transmit RPN/NRPN message at each MSB/LSB data reception

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Mute speakers at suspend / shutdown

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/generic: Add a helper to mute speakers at suspend/shutdown

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: validate dref root and objectid

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Bypass quick recovery if force reset is needed

Kyoungrul Kim <k831.kim@samsung.com>
    scsi: ufs: core: Check LSDBS cap when !mcq

Philip Mueller <philm@manjaro.org>
    drm: panel-orientation-quirks: Add quirk for OrangePi Neo

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    drm/fb-helper: Don't schedule_work() to flush frame buffer during panic()


-------------

Diffstat:

 Documentation/locking/hwspinlock.rst               |  11 +
 Makefile                                           |   4 +-
 block/blk-integrity.c                              |   2 -
 drivers/base/regmap/regmap-spi.c                   |   3 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   4 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   6 +-
 drivers/dma/altera-msgdma.c                        |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c  |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |  11 +-
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |   6 +
 drivers/gpu/drm/amd/amdgpu/df_v1_7.c               |   2 +
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c             |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |   4 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   9 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  19 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   2 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |  18 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   7 +-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c   |   3 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c   |   3 +
 .../gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c   |   7 +-
 .../gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c |  10 +
 .../gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c |  10 +
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |  10 +
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |  10 +
 .../gpu/drm/amd/display/dc/dml/display_mode_vba.c  |   7 +-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c |  17 +-
 drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c     |  17 +-
 .../display/dc/link/protocols/link_dp_capability.c |  26 +-
 .../display/dc/link/protocols/link_dp_training.c   |   4 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |  28 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   2 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |  13 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   5 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |  29 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  15 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  60 +++-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |  20 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |  31 ++-
 .../drm/amd/pm/powerplay/smumgr/vega10_smumgr.c    |   6 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  27 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |  14 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   2 +
 drivers/gpu/drm/bridge/tc358767.c                  |   2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  11 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/meson/meson_plane.c                |  17 +-
 drivers/hwmon/k10temp.c                            |  36 ++-
 drivers/hwspinlock/hwspinlock_core.c               |  28 ++
 drivers/hwspinlock/hwspinlock_internal.h           |   3 +
 drivers/iio/industrialio-core.c                    |   7 +-
 drivers/iio/industrialio-event.c                   |   9 +
 drivers/iio/inkern.c                               |  32 ++-
 drivers/infiniband/hw/efa/efa_com.c                |  30 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  18 +-
 drivers/media/v4l2-core/v4l2-cci.c                 |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 -
 drivers/net/wireless/realtek/rtw89/ser.c           |   8 +-
 drivers/pci/controller/dwc/pcie-al.c               |  16 +-
 drivers/platform/chrome/cros_ec_lpc_mec.c          |  76 +++++-
 drivers/platform/chrome/cros_ec_lpc_mec.h          |  11 +
 drivers/soc/qcom/smem.c                            |  26 ++
 drivers/spi/spi-hisi-kunpeng.c                     |   1 +
 drivers/ufs/core/ufshcd.c                          |  19 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   2 +-
 drivers/usb/usbip/stub_rx.c                        |  77 ++++--
 fs/btrfs/tree-checker.c                            |  47 ++++
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inline.c                                   |  20 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/gfs2/quota.c                                    |  19 +-
 fs/gfs2/util.c                                     |   6 +-
 fs/notify/fsnotify.c                               |  31 ++-
 fs/notify/fsnotify.h                               |   2 +-
 fs/notify/mark.c                                   |  32 ++-
 fs/smb/client/smb2inode.c                          |   6 +-
 include/clocksource/timer-xilinx.h                 |   2 +-
 include/linux/fsnotify_backend.h                   |   8 +-
 include/linux/hwspinlock.h                         |   6 +
 include/linux/i2c.h                                |   2 +-
 include/linux/soc/qcom/smem.h                      |   2 +
 include/net/ip.h                                   |   3 +-
 include/net/tcp.h                                  |   2 +-
 include/sound/ump_convert.h                        |   1 +
 include/ufs/ufshcd.h                               |   1 +
 include/ufs/ufshci.h                               |   1 +
 kernel/dma/debug.c                                 |   5 +-
 kernel/rcu/tree.h                                  |   1 -
 kernel/rcu/tree_nocb.h                             |  32 +--
 net/ipv4/fib_semantics.c                           |   5 +-
 net/ipv4/metrics.c                                 |   8 +-
 net/ipv4/tcp_cong.c                                |  11 +-
 net/ipv6/route.c                                   |   2 +-
 net/mac80211/main.c                                |   3 +-
 net/mptcp/fastopen.c                               |   4 +-
 net/mptcp/options.c                                |  50 ++--
 net/mptcp/pm.c                                     |  28 +-
 net/mptcp/pm_netlink.c                             |  52 ++--
 net/mptcp/protocol.c                               |  58 ++--
 net/mptcp/protocol.h                               |   9 +-
 net/mptcp/sched.c                                  |   4 +-
 net/mptcp/sockopt.c                                |   4 +-
 net/mptcp/subflow.c                                |  48 ++--
 net/wireless/scan.c                                |  46 +++-
 security/apparmor/apparmorfs.c                     |   4 +
 security/smack/smack_lsm.c                         |   2 +-
 sound/core/seq/seq_ports.h                         |  14 +-
 sound/core/seq/seq_ump_convert.c                   |  97 ++++---
 sound/core/ump_convert.c                           |  60 ++--
 sound/pci/hda/hda_generic.c                        |  63 +++++
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/patch_conexant.c                     |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 sound/soc/codecs/es8326.c                          |   2 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 304 +++++++++++++++++++--
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  38 +++
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  30 +-
 145 files changed, 1664 insertions(+), 573 deletions(-)


