Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2258625A341;
	Tue, 11 Nov 2025 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822027; cv=none; b=OtIn7up8Tt+e/XHUnZNMMPwecO9goDI9pmI0DFBDQvpV39kI5kYyrkqLQf9DMep92nxKT/d1YL7ooqP6BdwcCxJalb5wDrkwrIGLK5D+jjTfPd9gF8QGbBO24sfoUEnYUc8cdxFrWIE1KCCqEbrOR2a7Xdv+g6xOxlKbMUGO11I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822027; c=relaxed/simple;
	bh=TDg8c1dFNf0+w/XneHtyFMbL7rsEv+yRZOXVagTBXqI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QrjTflo2GKdjHH2a4s/8oXUtOTwLLmjSAaud2I7w2ua/XrWm+XNa9nv5hishr9EY7kamwA8SUT37v7GS6zBmu5L5yYyyyA7iNi4OTX0NcoptXScmTrgyjKnNxoxwGr4IekYGusf1u1mVJUoXsUpVFO9z0Zo9xy8OAbG4Y8y8934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4AP4e0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4AP4e0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA324C19421;
	Tue, 11 Nov 2025 00:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822026;
	bh=TDg8c1dFNf0+w/XneHtyFMbL7rsEv+yRZOXVagTBXqI=;
	h=From:To:Cc:Subject:Date:From;
	b=s4AP4e0sZyyhqq5OhxR+rFdEP4k30zCyg9fyEk9Xjdy1/+OW5OAYPQr2YyK/cHaNy
	 SJDv/gPhTy8+QmW8cNpv41cGGyfFrnQc3wLJoV/5bG/wE/zrdW46O0et8WAUROZjM9
	 +BaBPCgOxC/JtxeTI4GuHMpFGjeqI8W5kw1Uyzsg=
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
Subject: [PATCH 6.17 000/849] 6.17.8-rc1 review
Date: Tue, 11 Nov 2025 09:32:50 +0900
Message-ID: <20251111004536.460310036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.8-rc1
X-KernelTest-Deadline: 2025-11-13T00:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.8 release.
There are 849 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.8-rc1

Amery Hung <ameryhung@gmail.com>
    selftests: drv-net: Reload pkt pointer after calling filter_udphdr

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix black screen with HDMI outputs

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: use GFP_NOWAIT for allocation in interrupt handler

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Reject modes with too high pixel clock on DCE6-10

Jessica Zhang <jessica.zhang@oss.qualcomm.com>
    drm/msm/dpu: Fix adjusted mode clock check for 3d merge

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu/userq: assign an error code for invalid userq va

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix function header names in amdgpu_connectors.c

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix vupdate_offload_work doc

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu: Fix unintended error log in VCN5_0_0

Nathan Chancellor <nathan@kernel.org>
    kbuild: Strip trailing padding bytes from modules.builtin.modinfo

Punit Agrawal <punit.agrawal@oss.qualcomm.com>
    ACPI: SPCR: Check for table version when using precise baudrate

Shenghao Ding <shenghao-ding@ti.com>
    ALSA: hda/tas2781: Enable init_profile_id for device initialization

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: Extend kconfig help text for KUNIT_UML_PCI

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Cleanup wakeup source only if it was enabled

Melissa Wen <mwen@igalia.com>
    drm/amd/display: update color on atomic commit time

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix invalid probe error return value

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Add a quirk to suppress link_startup_again

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Nathan Chancellor <nathan@kernel.org>
    lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix alignment for virtio_net_hdr_v1_hash

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: fix received length check in big packets

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Don't clear PT after process killed

Rong Zhang <i@rong.moe>
    drm/amd/display: Fix NULL deref in debugfs odm_combine_segments

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: Handle S0ix for vangogh

James Jones <jajones@nvidia.com>
    drm/nouveau: Advertise correct modifiers on GB20x

James Jones <jajones@nvidia.com>
    drm: define NVIDIA DRM format modifiers for GB20x

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Add missing terminator for zen5_rdseed_microcode

Darrick J. Wong <djwong@kernel.org>
    xfs: fix various problems in xfs_atomic_write_cow_iomap_begin

Darrick J. Wong <djwong@kernel.org>
    xfs: fix delalloc write failures in software-provided atomic writes

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_node: Fix AMD root device caching

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/core: Fix system hang caused by cpu-clock usage

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential UAF in smb2_close_cached_fid()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix regbuf vector size truncation

Joshua Rogers <linux@joshua.hu>
    smb: client: validate change notify buffer before copy

Mario Limonciello (AMD) <superm1@kernel.org>
    x86/microcode/AMD: Add more known models to entry sign checking

Yuta Hayama <hayama@lineo.co.jp>
    rtc: rx8025: fix incorrect register reference

Helge Deller <deller@gmx.de>
    parisc: Avoid crash due to unaligned access in unwinder

Miaoqian Lin <linmq006@gmail.com>
    riscv: Fix memory leak in module_frob_arch_sections()

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Don't overflow during division for dirty tracking

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/sched: Fix deadlock in drm_sched_entity_kill_jobs_cb

Yongpeng Yang <yangyongpeng@xiaomi.com>
    fscrypt: fix left shift underflow when inode->i_blkbits > PAGE_SHIFT

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: use wiphy_hrtimer_work for csa.switch_work

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: use wiphy_hrtimer_work for ttlm_work

Qiu Wenbo <qiuwenbo@kylinsec.com.cn>
    platform/x86: int3472: Fix double free of GPIO device during unregister

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: use wiphy_hrtimer_work for ml_reconf_work

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: add an hrtimer based delayed work item

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Enable mst when it's detected but yet to be initialized

Zilin Guan <zilin@seu.edu.cn>
    tracing: Fix memory leaks in create_field_var()

Bobby Eshleman <bobbyeshleman@meta.com>
    selftests/vsock: avoid false-positives when checking dmesg

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix MST static key usage

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix use-after-free due to MST port state bypass

Horatiu Vultur <horatiu.vultur@microchip.com>
    lan966x: Fix sleeping in atomic context

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix reserved multicast address table programming

Haotian Zhang <vulab@iscas.ac.cn>
    net: wan: framer: pef2256: Switch to devm_mfd_add_devices()

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix header formulas for higher MTUs and 64K pages

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix skb size check for 64K pages

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix header mapping for 64K pages

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix fdb hash size configuration

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix return value in case of module EEPROM read error

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix types for region size calulation

Martin Willi <martin@strongswan.org>
    wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup

Breno Leitao <leitao@debian.org>
    netpoll: Fix deadlock in memory allocation under spinlock

Shantiprasad Shettar <shantiprasad.shettar@broadcom.com>
    bnxt_en: Fix warning in bnxt_dl_reload_down()

Kashyap Desai <kashyap.desai@broadcom.com>
    bnxt_en: Always provide max entry and entry size in coredump segments

Gautam R A <gautam-r.a@broadcom.com>
    bnxt_en: Fix null pointer dereference in bnxt_bs_trace_check_wrap()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix a possible memory leak in bnxt_ptp_init

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Shutdown FW DMA in bnxt_shutdown()

Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
    net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup

Dan Carpenter <dan.carpenter@linaro.org>
    octeontx2-pf: Fix devm_kcalloc() error checking

Mohammad Heib <mheib@redhat.com>
    net: ionic: map SKB after pseudo-header checksum prep

Mohammad Heib <mheib@redhat.com>
    net: ionic: add dma_wmb() before ringing TX doorbell

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold sock lock while iterating over address list

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Prevent TOCTOU out-of-bounds write

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold RCU read lock while iterating over address list

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: properly bound ARL searches for < 4 ARL bin chips

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: stop reading ARL entries if search is done

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix enabling ip multicast

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix bcm63xx RGMII port link adjustment

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix resetting speed and pause on forced link

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: mdio: Check regmap pointer returned by device_node_to_regmap()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: fix invalid pointer access in debugfs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: swnode: don't use the swnode's name as the key for GPIO lookup

Gustavo Luiz Duarte <gustavold@gmail.com>
    netconsole: Acquire su_mutex before navigating configs hierarchy

Hangbin Liu <liuhangbin@gmail.com>
    net: vlan: sync VLAN features with lower device

Wang Liang <wangliang74@huawei.com>
    selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: use destination options instead of hop-by-hop

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: fix out-of-order delivery of FIN in gro:tcp test

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: tag_brcm: legacy: fix untagged rx on unbridged ports for bcm63xx

Tim Hostetler <thostet@google.com>
    gve: Implement settime64 with -EOPNOTSUPP

Tim Hostetler <thostet@google.com>
    gve: Implement gettimex64 with -EOPNOTSUPP

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: hci_event: validate skb length for unknown CC opcode

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Revert "Make HID attributes visible"

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    Revert "wifi: ath12k: Fix missing station power save configuration"

Josephine Pfeiffer <hi@josie.lol>
    riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: stacktrace: Disable KASAN checks for non-current tasks

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix a race condition related to the "hid" attribute group

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix device bus LAN ID

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Do not warn in ring_buffer_map_get_reader() when reader catches up

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: tprobe-events: Fix to put tracepoint_user when disable the tprobe

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: tprobe-events: Fix to register tracepoint correctly

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    Revert "wifi: ath10k: avoid unnecessary wait for service ready message"

Ariel D'Alessandro <ariel.dalessandro@collabora.com>
    drm/mediatek: Disable AFBC support on Mediatek DRM driver

Marek Szyprowski <m.szyprowski@samsung.com>
    media: videobuf2: forbid remove_bufs when legacy fileio is active

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use heuristic to find stream entity

Qu Wenruo <wqu@suse.com>
    btrfs: ensure no dirty metadata is written back for an fs with errors

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: treat `build_error` and `rustdoc` as kernel objects

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: workaround `rustdoc` doctests modifier bug

Miguel Ojeda <ojeda@kernel.org>
    rust: devres: fix private intra-doc link

Miguel Ojeda <ojeda@kernel.org>
    rust: condvar: fix broken intra-doc link

Linus Torvalds <torvalds@linux-foundation.org>
    x86: uaccess: don't use runtime-const rewriting in modules

Kotresh HR <khiremat@redhat.com>
    ceph: fix multifs mds auth caps issue

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: refactor wake_up_bit() pattern of calling

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix potential race condition in ceph_ioctl_lazyio()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: add checking of wait_for_completion_killable() return value

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Report individual reset error

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix mmap write lock not release

Shuming Fan <shumingf@realtek.com>
    ASoC: rt722: add settings for rt722VB

Valerio Setti <vsetti@baylibre.com>
    ASoC: meson: aiu-encoder-i2s: fix bit clock polarity

Geert Uytterhoeven <geert@linux-m68k.org>
    kbuild: uapi: Strip comments before size type check

Sammy Hsu <zelda3121@gmail.com>
    net: wwan: t7xx: add support for HP DRMR-H01

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: fix watchdog interrupt mask on pcf2131

Harini T <harini.t@amd.com>
    rtc: zynqmp: Restore alarm functionality after kexec transition

Adam Holliday <dochollidayxx@gmail.com>
    ALSA: hda/realtek: Add quirk for ASUS ROG Zephyrus Duo

Albin Babu Varghese <albinbabuvarghese20@gmail.com>
    fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds

Sascha Hauer <s.hauer@pengutronix.de>
    tools: lib: thermal: use pkg-config to locate libnl3

Emil Dahl Juhl <juhl.emildahl@gmail.com>
    tools: lib: thermal: don't preserve owner in install

Ian Rogers <irogers@google.com>
    tools bitmap: Add missing asm-generic/bitsperlong.h include

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Handle new atomic instructions for probes

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return present device nodes only on fwnode interface

Zsolt Kajtar <soci@c64.rulez.org>
    fbdev: core: Fix ubsan warning in pixel_to_pat

Hoyoung Seo <hy50.seo@samsung.com>
    scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS

Randall P. Embry <rpembry@gmail.com>
    9p: sysfs_init: don't hardcode error to ENOMEM

Aaron Kling <webgeek1234@gmail.com>
    cpufreq: tegra186: Initialize all cores to max frequencies

Randall P. Embry <rpembry@gmail.com>
    9p: fix /sys/fs/9p/caches overwriting itself

Jerome Brunet <jbrunet@baylibre.com>
    NTB: epf: Allow arbitrary BAR mapping

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    clk: clocking-wizard: Fix output clock register offset for Versal platforms

Jacky Bai <ping.bai@nxp.com>
    clk: scmi: Add duty cycle ops only when duty cycle is supported

Matthias Schiffer <matthias.schiffer@tq-group.com>
    clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled

Oleg Nesterov <oleg@redhat.com>
    9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN

Nicolas Ferre <nicolas.ferre@microchip.com>
    clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register

Ryan Wanner <Ryan.Wanner@microchip.com>
    clk: at91: clk-master: Add check for divide by 3

Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
    clk: at91: sam9x7: Add peripheral clock id for pmecc

Cristian Birsan <cristian.birsan@microchip.com>
    clk: at91: add ACR in all PLL settings

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: save and restore ACR during PLL disable/enable

Josua Mayer <josua@solid-run.com>
    rtc: pcf2127: clear minute/second interrupt

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun6i-rtc: Add A523 specifics

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix help message for ssl-non-raw

Nuno Das Neves <nunodasneves@linux.microsoft.com>
    hyperv: Add missing field to hv_output_map_device_interrupt

Wei Liu <wei.liu@kernel.org>
    clocksource: hyper-v: Skip unnecessary checks for the root partition

Yikang Yue <yikangy2@illinois.edu>
    fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink

Denzeel Oliva <wachiturroxd150@gmail.com>
    clk: samsung: exynos990: Add missing USB clock registers to HSI0

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    clk: renesas: rzv2h: Re-assert reset on deassert timeout

Icenowy Zheng <uwu@icenowy.me>
    clk: thead: th1520-ap: set all AXI clocks to CLK_IS_CRITICAL

Marko Mäkelä <marko.makela@iki.fi>
    clk: qcom: gcc-ipq6018: rework nss_port5 clock to multiple conf

austinchang <austinchang@synology.com>
    btrfs: mark dirty extent range for out of bound prealloc extents

Shardul Bankar <shardulsb08@gmail.com>
    btrfs: fix memory leak of qgroup_list in btrfs_add_qgroup_relation

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong WQE data when QP wraps around

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix the modification of max_send_sge

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix recv CQ and QP cache affinity

Shuhao Fu <sfual@cse.ust.hk>
    RDMA/uverbs: Fix umem release in UVERBS_METHOD_CQ_CREATE

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Set irdma_cq cq_num field during CQ create

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Remove unused struct irdma_cq fields

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix SD index calculation

YanLong Dai <daiyanlong@kylinos.cn>
    RDMA/bnxt_re: Fix a potential memory leak in destroy_gsi_sqp

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update dsmethod.c to get rid of unused variable warning

Mario Limonciello <Mario.Limonciello@amd.com>
    drm/amd/display: Add fallback path for YCBCR422

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci-pci: Fix USB2-only root hub registration

Coiby Xu <coxu@redhat.com>
    ima: don't clear IMA_DIGSIG flag when setting or removing non-IMA xattr

Fiona Ebner <f.ebner@proxmox.com>
    smb: client: transport: avoid reconnects triggered by pending task work

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: update cfid->last_access_time in open_cached_dir_by_dentry()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use sock_create_kern interface to create kernel socket

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Prevent entering switchdev mode with inconsistent netns

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace: Fix softlockup in ftrace_module_enable

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix xattr related buffer overflow...

Dragos Tatulea <dtatulea@nvidia.com>
    page_pool: Clamp pool size to max 16K pages

Qingfang Deng <dqfext@gmail.com>
    6pack: drop redundant locking and refcounting

Namjae Jeon <linkinjeon@kernel.org>
    exfat: validate cluster allocation bits of the allocation bitmap

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: limit log print for IO error

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: est: Drop frames causing HLBS error

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: bcsp: receive data only if registered

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3633 for MT7922

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_conn_free

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Use sk_sndtimeo as conn_timeout

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Don't initiate CIS connections if there are no buffers

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: Define hdev->wakeup() callback

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3627 for MT7925

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: avoid dealing with endianness in macb_set_hwaddr()

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Add support for BlazarIW core

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Don't query FEC statistics when FEC is disabled

Alessandro Zanni <alessandro.zanni87@gmail.com>
    selftest: net: Fix error message if empty variable

Tushar Dave <tdave@nvidia.com>
    vfio/nvgrace-gpu: Add GB300 SKU to the devid table

Timothy Pearson <tpearson@raptorengineering.com>
    vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices

Hans de Goede <hansg@kernel.org>
    platform/x86: x86-android-tablets: Stop using EPROBE_DEFER

Sunil V L <sunilvl@ventanamicro.com>
    ACPI: scan: Update honor list for RPMI System MSI

Primoz Fiser <primoz.fiser@norik.com>
    ASoC: tlv320aic3x: Fix class-D initialization for tlv320aic3007

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: enhance kfd process check in switch partition

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: sai: manage context in set_sysclk callback

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Fix fence signaling race condition in userqueue

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Add fallback to pipe reset if KCQ ring reset fails

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: resolve a race in amdgpu_amdkfd_device_fini_sw

Julian Sun <sunjunchao@bytedance.com>
    ext4: increase IO priority of fastcommit

chuguangqing <chuguangqing@inspur.com>
    fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: renesas: msiof: set SIFCTR register

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: renesas: msiof: tidyup DMAC stop timing

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: renesas: msiof: use reset controller

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: renesas: msiof: add .symmetric_xxx on snd_soc_dai_driver

Moti Haimovski <moti.haimovski@intel.com>
    accel/habanalabs: support mapping cb with vmalloc-backed coherent memory

Konstantin Sinyuk <konstantin.sinyuk@intel.com>
    accel/habanalabs/gaudi2: read preboot status after recovering from dirty state

Tomer Tayar <tomer.tayar@intel.com>
    accel/habanalabs: return ENOMEM if less than requested pages were pinned

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate

Vered Yavniely <vered.yavniely@intel.com>
    accel/habanalabs/gaudi2: fix BMON disable configuration

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Change MCQ interrupt enable flow

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: dp83640: improve phydev and driver removal handling

Petr Machata <petrm@nvidia.com>
    net: bridge: Install FDB for bridge MAC on VLAN 0

Al Viro <viro@zeniv.linux.org.uk>
    nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix mount hang after CREATE_SESSION failure

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: handle ERR_GRACE on delegation recalls

Melissa Wen <mwen@igalia.com>
    drm/amd/display: change dc stream color settings only in atomic commit

Sridevi Arvindekar <sarvinde@amd.com>
    drm/amd/display: Fix for test crash due to power gating

Lo-an Chen <lo-an.chen@amd.com>
    drm/amd/display: Init dispclk from bootup clock for DCN314

Allen Li <wei-guang.li@amd.com>
    drm/amd/display: Add fast sync field in ultra sleep more for DMUB

Karthi Kandasamy <karthi.kandasamy@amd.com>
    drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Add missing post flip calls

Amir Goldstein <amir73il@gmail.com>
    ovl: make sure that ovl_create_real() returns a hashed dentry

Jakub Sitnicki <jakub@cloudflare.com>
    tcp: Update bind bucket state on port release

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: don't apply interface quirk to Presonus S1824c

Bhargava Marreddy <bhargava.marreddy@broadcom.com>
    bng_en: make bnge_alloc_ring() self-unwind on failure

Bastien Curutchet <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Set SPI as bus interface during reset for KSZ8463

Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
    wifi: ath12k: Increase DP_REO_CMD_RING_SIZE to 256

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid handling handover twice

David Yang <mmyangfl@gmail.com>
    selftests: forwarding: Reorder (ar)ping arguments to obey POSIX getopt

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Skip resuming to D0 if device is disconnected

Niranjan H Y <niranjan.hy@ti.com>
    ASoC: ops: improve snd_soc_get_volsw

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - clear all VF configurations in the hardware

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - invalidate queues in use

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp_ocp: make ptp_ocp driver compatible with PTP_EXTTS_REQUEST2

Alex Mastro <amastro@fb.com>
    vfio: return -ENOTTY for unsupported device feature

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix prototypes of reads[bwl]()

Koakuma <koachan@protonmail.com>
    sparc/module: Add R_SPARC_UA64 relocation handling

Chen Wang <unicorn_wang@outlook.com>
    PCI: cadence: Check for the existence of cdns_pcie::ops before using it

ChunHao Lin <hau@realtek.com>
    r8169: set EEE speed down ratio to 1

Brahmajit Das <listout@listout.xyz>
    net: intel: fm10k: Fix parameter idx set but not used

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Track NAN interface start/stop

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Get the correct interface for non-netdev skb status

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove LPIG from page group response descriptor

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix connection after GTK rekeying

Seyediman Seyedarab <ImanDevel@gmail.com>
    iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()

Vivek Pernamitta <quic_vpernami@quicinc.com>
    bus: mhi: core: Improve mhi_sync_power_up handling for SYS_ERR state

Robert Marko <robert.marko@sartura.hr>
    net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: clear link parameters on admin link down

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: make a local copy of client uuid in connect

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    jfs: fix uninitialized waitqueue in transaction manager

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jfs: Verify inode mode when loading from disk

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Add fw log trace support for 5731X/5741X chips

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/ipoib: Ignore L3 master device

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Update Kconfig

Eric Dumazet <edumazet@google.com>
    ipv6: np->rxpmtu race annotation

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci-pci: add support for hosts with zero USB3 ports

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: renew a completion for each H2C command waiting C2H event

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: obtain RX path from ppdu status IE00

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: disable RTW89_PHYSTS_IE09_FTR_0 for ppdu status

wangzijie <wangzijie1@honor.com>
    f2fs: fix infinite loop in __insert_extent_tree()

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: xhci: plat: Facilitate using autosuspend for xhci plat devices

Forest Crossman <cyrozap@gmail.com>
    usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs

Al Viro <viro@zeniv.linux.org.uk>
    allow finish_no_open(file, ERR_PTR(-E...))

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Define size of debugfs entry for xri rebalancing

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Decrement ndlp kref after FDISC retries exhausted

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Clean up allocated queues when queue setup mbox commands fail

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Disable timestamp functionality if not supported

Nai-Chen Cheng <bleach1827@gmail.com>
    selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency

Christian König <christian.koenig@amd.com>
    drm/amdgpu: reject gang submissions under SRIOV

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Return an error code if the GuC load fails

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    tools: ynl-gen: validate nested arrays

Fan Gong <gongfan1@huawei.com>
    hinic3: Fix missing napi->dev in netif_queue_set_napi

Fan Gong <gongfan1@huawei.com>
    hinic3: Queue pair endianness improvements

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: i2c-hid: Resolve touchpad issues on Dell systems during S4

Palash Kambar <quic_pkambar@quicinc.com>
    scsi: ufs: ufs-qcom: Disable lane clocks during phy hibern8

Stefan Wahren <wahrenst@gmx.net>
    ethernet: Extend device_get_mac_address() to use NVMEM

Jakub Kicinski <kuba@kernel.org>
    page_pool: always add GFP_NOWARN for ATOMIC allocations

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: clear EEE runtime state in PHY_HALTED/PHY_ERROR

Xi Ruoyao <xry111@xry111.site>
    drm/amd/display/dml2: Guard dml21_map_dc_state_into_dml_display_cfg with DC_FP_START

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable VRR on DCE 6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DVI-D/HDMI adapters

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Keep PLL0 running on DCE 6.0 and 6.4

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't use non-registered VUPDATE on DCE 6

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Avoid evicting resources at S5

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: fix dml ms order of operations

Mario Limonciello <Mario.Limonciello@amd.com>
    drm/amd/display: Set up pixel encoding for YCBCR422

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix DMCUB loading sequence for DCN3.2

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Release hive reference properly

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: validate userq buffer virtual address and size

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: improve phy reset on hw restart

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: use altx queue for offchannel tx on connac+

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: disable promiscuous mode by default

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix memory leak on mt7996_mcu_sta_key_tlv error

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: serial-generic: remove shared static buffer

Rosen Penev <rosenp@gmail.com>
    wifi: mt76: mt76_eeprom_override to int

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: support writing MAC TXD for AddBA Request

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: Temporarily disable EPCS

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Set def_wcid pointer in mt7996_mac_sta_init_link()

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: Fix mt7996_reverse_frag0_hdr_trans for MLO

Jack Kao <jack.kao@mediatek.com>
    wifi: mt76: mt7925: add pci restore for hibernate

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device

Yafang Shao <laoar.shao@gmail.com>
    net/cls_cgroup: Fix task_get_classid() during qdisc run

Alok Tiwari <alok.a.tiwari@oracle.com>
    ionic: use int type for err in ionic_get_module_eeprom_by_page

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Reduce waiting time if HWC not responding

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Update bit rate constants for RZ/G3E and R-Car Gen4

Gaurav Jain <gaurav.jain@nxp.com>
    crypto: caam - double the entropy delay interval for retry

Yunseong Kim <ysk@kzalloc.com>
    crypto: ccp - Fix incorrect payload size calculation in psp_poulate_hsti()

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: Verify the single eDMA IRQ in dw_pcie_edma_irq_verify()

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - remove channel timeout field

Sangwook Shin <sw617.shin@samsung.com>
    watchdog: s3c2410_wdt: Fix max_timeout being calculated larger

Antheas Kapenekakis <lkml@antheas.dev>
    HID: asus: add Z13 folio to generic group for multitouch to work

Alok Tiwari <alok.a.tiwari@oracle.com>
    udp_tunnel: use netdev_warn() instead of netdev_WARN()

Petr Machata <petrm@nvidia.com>
    selftests: net: lib.sh: Don't defer failed commands

Stanislav Fomichev <sdf@fomichev.me>
    net: devmem: expose tcp_recvmsg_locked errors

David Ahern <dsahern@kernel.org>
    selftests: Replace sleep with slowwait

Vernon Yang <yanglincheng@kylinos.cn>
    PCI/AER: Fix NULL pointer access by aer_info

Daniel Palmer <daniel@thingy.jp>
    eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP

David Ahern <dsahern@kernel.org>
    selftests: Disable dad for ipv6 in fcnal-test.sh

Kai Huang <kai.huang@intel.com>
    x86/virt/tdx: Use precalculated TDVPR page physical address

Li RongQing <lirongqing@baidu.com>
    x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't reply to icmp error messages

chenmiao <chenmiao.ku@gmail.com>
    openrisc: Add R_OR1K_32_PCREL relocation type module support

Ido Schimmel <idosch@nvidia.com>
    selftests: traceroute: Return correct value on failure

Ido Schimmel <idosch@nvidia.com>
    selftests: traceroute: Use require_command()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Fix the custom bios input handling mechanism

Qianfeng Rong <rongqianfeng@vivo.com>
    media: redrat3: use int type to store negative error codes

Jakub Kicinski <kuba@kernel.org>
    selftests: net: replace sleeps in fcnal-test with waits

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: sh_eth: Disable WoL if system can not suspend

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/registers: Generate _HI/LO builders for reg64

Michael Riesch <michael.riesch@collabora.com>
    phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0

Michael Dege <michael.dege@renesas.com>
    phy: renesas: r8a779f0-ether-serdes: add new step added to latest datasheet

Mario Limonciello (AMD) <superm1@kernel.org>
    Fix access to video_is_primary_device() when compiled without CONFIG_VIDEO

Harikrishna Shenoy <h-shenoy@ti.com>
    phy: cadence: cdns-dphy: Enable lower resolutions in dphy

Mario Limonciello (AMD) <superm1@kernel.org>
    fbcon: Use screen info to find primary device

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix HE capabilities element check

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: update the time stamps in hidden ssid

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ntfs3: pretend $Extend records as regular files

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Fix adapt issue after PA_Init

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Correct system PM flow

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: phy: marvell: Fix 88e1510 downshift counter errata

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix unbalanced IRQ enable issue

Palash Kambar <quic_pkambar@quicinc.com>
    scsi: ufs: ufs-qcom: Align programming sequence of Shared ICE for UFS controller v5

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on resume failure

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: allow more time to send ADD_ADDR

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: validate userq input args

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong layout information on 16KB page

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Always add CT disable action during second init step

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: write full Audio InfoFrame

Loic Poulain <loic.poulain@oss.qualcomm.com>
    media: qcom: camss: csiphy-3ph: Add CSIPHY 2ph DPHY v2.0.1 init sequence

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer

Hao Yao <hao.yao@intel.com>
    media: ov08x40: Fix the horizontal flip control

Raag Jadav <raag.jadav@intel.com>
    drm/xe/i2c: Enable bus mastering

Nidhish A N <nidhish.a.n@intel.com>
    wifi: iwlwifi: fw: Add ASUS to PPAG and TAS list

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw89: Add USB ID 2001:3327 for D-Link AX18U rev. A1

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw89: Add USB ID 2001:332a for D-Link AX9U rev. A1

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: endpoint: pci-epf-test: Limit PCIe BAR size for fixed BARs

Jakub Kicinski <kuba@kernel.org>
    selftests: net: make the dump test less sensitive to mem accounting

Alexander Lobakin <aleksander.lobakin@intel.com>
    idpf: link NAPIs to queues

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Switch to GMU AO counter

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/adreno: Add fenced regwrite support

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/adreno: Add speedbin data for A623 GPU

Xion Wang <xion.wang@mediatek.com>
    char: Use list_del_init() in misc_deregister() to reinitialize list pointer

Antonino Maniscalco <antomani103@gmail.com>
    drm/msm: make sure to not queue up recovery more than once

Jie Zhang <quic_jiezh@quicinc.com>
    dt-bindings: display/msm/gmu: Update Adreno 623 bindings

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix 32b size truncation

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/adreno: Add speedbins for A663 GPU

Markus Heidelberg <m.heidelberg@cab.de>
    eeprom: at25: support Cypress FRAMs without device ID

Zizhi Wo <wozizhi@huaweicloud.com>
    tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serdev: Drop dev_pm_domain_detach() call

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    serial: qcom-geni: Add DFS clock mode support to GENI UART driver

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget

William Wu <william.wu@rock-chips.com>
    usb: gadget: f_hid: Fix zero length packet transfer

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: support phy-mode = "10g-qxgmii"

Stanislav Fomichev <sdf@fomichev.me>
    selftests: ncdevmem: don't retry EFAULT

Mario Limonciello <superm1@kernel.org>
    drm/amd/display: Indicate when custom brightness curves are in use

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: refine amdgpu pm sysfs node error code

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: dont wait for pipe update during medupdate/highirq

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix pbn_div Calculation Error

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish gpu_info

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't enable SMU on cyan skillfish

Alex Deucher <alexander.deucher@amd.com>
    drm/amd: add more cyan skillfish PCI ids

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Correct info field of bad page threshold exceed CPER

Slark Xiao <slark_xiao@163.com>
    bus: mhi: host: pci_generic: Add support for all Foxconn T99W696 SKU variants

Hector Martin <marcan@marcan.st>
    iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp: Skip SEV and SNP INIT for kdump boot

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Reuse device table for kdump

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Skip enabling command/event buffers for kdump

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Add support to remap/unmap IOMMU buffers for kdump

Matthew Auld <matthew.auld@intel.com>
    drm/xe: improve dma-resv handling for backup object

Matthew Auld <matthew.auld@intel.com>
    drm/gpusvm: fix hmm_pfn_to_map_order() usage

Colin Foster <colin.foster@in-advantage.com>
    smsc911x: add second read of EEPROM mac when possible corruption seen

Eric Dumazet <edumazet@google.com>
    net: call cond_resched() less often in __release_sock()

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Set upper limit of H2G retries over CTB

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Enable the Vaux supply if available

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: apply quirk for MOONDROP Quark2

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Present unique domain ID per package

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Add extra TC BIOS error messages

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: mac80211: Fix 6 GHz Band capabilities element advertisement in lower bands

Paul Kocialkowski <paulk@sys-base.io>
    media: verisilicon: Explicitly disable selection api ioctls for decoders

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Only validate format in querystd

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Do not write format to device in set_fmt

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Add missing lock in suspend callback

Juraj Šarinay <juraj@sarinay.com>
    net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    netlink: specs: fou: change local-v6/peer-v6 check

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: reduce number of reads when getting OROM data

Antheas Kapenekakis <lkml@antheas.dev>
    drm: panel-backlight-quirks: Make EDID match optional

Chia-I Wu <olvaffe@gmail.com>
    drm/panthor: check bo offset alignment in vm bind

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: count reg connection element in the size

Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
    drm/xe: Extend Wa_22021007897 to Xe3 platforms

Yue Haibing <yuehaibing@huawei.com>
    ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: rss_ctx: make the test pass with few queues

Al Viro <viro@zeniv.linux.org.uk>
    move_mount(2): take sanity checks in 'beneath' case into do_lock_mount()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Increase SMC timeout on SI and warn (v3)

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/xe/guc: Increase GuC crash dump buffer size

David Francis <David.Francis@amd.com>
    drm/amdgpu: Allow kfd CRIU with no buffer objects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy_7nm: Fix missing initial VCO rate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: all transaction allocations can now sleep

Devendra K Verma <devverma@amd.com>
    dmaengine: dw-edma: Set status for callback_result

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: match alloc_wc and free_wc

Thomas Andreatta <thomasandreatta2000@gmail.com>
    dmaengine: sh: setup_xref error handling

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/guc: Add devm release action to safely tear down CT

Miroslav Lichvar <mlichvar@redhat.com>
    ptp: Limit time setting of PTP clocks

Marcus Folkesson <marcus.folkesson@gmail.com>
    drm/st7571-i2c: add support for inverted pixel format

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: pcie: remember when interrupts are disabled

Richard Leitner <richard.leitner@linux.dev>
    media: nxp: imx8-isi: Fix streaming cleanup on release

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx-mipi-csis: Only set clock rate when specified in DT

Bharat Uppal <bharat.uppal@samsung.com>
    scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device in reset on suspend

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7124: do not require mclk

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: pm8001: Use int instead of u32 to store error codes

Qianfeng Rong <rongqianfeng@vivo.com>
    crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()

Eric Dumazet <edumazet@google.com>
    tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()

Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
    microchip: lan865x: add ndo_eth_ioctl handler to enable PHY ioctl support

Eric Dumazet <edumazet@google.com>
    inet_diag: annotate data-races in inet_diag_bc_sk()

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: rename stp node on EASY50712 reference board

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: xway: sysctrl: rename stp clock

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing device_type in pci node

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add model to EASY50712 dts

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing properties to cpu node

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)

Mangesh Gadre <Mangesh.Gadre@amd.com>
    drm/amdgpu: Avoid vcn v5.0.1 poison irq call trace on sriov guest

Clay King <clayking@amd.com>
    drm/amd/display: incorrect conditions for failing dto calculations

Mangesh Gadre <Mangesh.Gadre@amd.com>
    drm/amdgpu: Avoid jpeg v5.0.1 poison irq call trace on sriov guest

Relja Vojvodic <rvojvodi@amd.com>
    drm/amd/display: Increase minimum clock for TMDS 420 with pipe splitting

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Notify pmfw bad page threshold exceeded

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Add fixup for channels

Martin Tůma <martin.tuma@digiteqautomotive.com>
    media: pci: mgb4: Fix timings comparison in VIDIOC_S_DV_TIMINGS

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    media: fix uninitialized symbol warnings

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: rss_ctx: fix the queue count check

Rob Herring (Arm) <robh@kernel.org>
    drm/msm: Use of_reserved_mem_region_to_resource() for "memory-region"

Jessica Zhang <jessica.zhang@oss.qualcomm.com>
    drm/msm/dpu: Filter modes based on adjusted mode clock

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Fix warning in partitioned system

Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
    wifi: iwlwifi: mld: trigger mlo scan only when not in EMLSR

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Reset hw stats upon PCI error

Krishna Kumar <krikku@gmail.com>
    net: Prevent RPS table overwrite of active flows

Stuart Summers <stuart.summers@intel.com>
    drm/xe: Cancel pending TLB inval workers on teardown

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/vpe: cancel delayed work in hw_fini

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Consider sink max slice width limitation for dsc

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: wait for otg update pending latch before clock optimization

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Support HW cursor 180 rot for any number of pipe splits

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix vram allocation failure for a special case

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Correct the counts of nr_banks and nr_errors

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Correct the loss of aca bank reg info

Christian Bruel <christian.bruel@foss.st.com>
    misc: pci_endpoint_test: Skip IRQ tests if irq is out of range

Xin Wang <x.wang@intel.com>
    drm/xe: Ensure GT is in C0 during resumes

Christian Bruel <christian.bruel@foss.st.com>
    selftests: pci_endpoint: Skip IRQ test if IRQ is out of range.

Li RongQing <lirongqing@baidu.com>
    virtio_fs: fix the hash table using in virtio_fs_enqueue_req()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: zero initialize inode private data

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: hds: restore hds settings

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fixed_phy: let fixed_phy_unregister free the phy_device

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/xe/wcl: Extend L3bank mask workaround

Andrew Davis <afd@ti.com>
    remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper

Riana Tauro <riana.tauro@intel.com>
    drm/xe: Set GT as wedged before sending wedged uevent

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: axp288: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: fsa9480: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Fix wakeup source leaks on device unbind

Francisco Gutierrez <frankramirez@google.com>
    scsi: pm80xx: Fix race condition caused by static variables

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix controller init failure on fault during queue creation

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix I/O failures during controller reset

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Limit Wi-Fi scan slot cost to avoid A2DP glitch

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix device loss during enclosure reboot due to zero link speed

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: allow directed broadcast routes to use dst hint

Andrew Davis <afd@ti.com>
    rpmsg: char: Export alias for RPMSG ID rpmsg-raw from table

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu6: isys: Set embedded data type correctly for metadata formats

Cryolitia PukNgae <cryolitia@uniontech.com>
    iio: imu: bmi270: Match PNP ID found on newer GPD firmware

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: limit tx_max_coalesced_frames_irq

Ujwal Kundur <ujwal.kundur@gmail.com>
    rds: Fix endianness annotation for RDS_MPATH_HASH

Heiko Stuebner <heiko@sntech.de>
    drm/panel: ilitek-ili9881c: move display_on/_off dcs calls to (un-)prepare

Heiko Stuebner <heiko@sntech.de>
    drm/panel: ilitek-ili9881c: turn off power-supply when init fails

Stuart Summers <stuart.summers@intel.com>
    drm/xe/pcode: Initialize data0 for pcode read routine

Eric Dumazet <edumazet@google.com>
    idpf: do not linearize big TSO packets

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Broadcast XON on all channels

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add validation of UAC2/UAC3 effect units

Xichao Zhao <zhao.xichao@vivo.com>
    tty: serial: Modify the use of dev_err_probe()

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Add Hyper-V VF ID

Sungho Kim <sungho.kim@furiosa.ai>
    PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call

Chao Yu <chao@kernel.org>
    f2fs: fix to detect potential corrupted nid in free_nid_list

Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
    dmaengine: idxd: Add a new IAA device ID for Wildcat Lake family platforms

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.

Oleksij Rempel <o.rempel@pengutronix.de>
    net: stmmac: Correctly handle Rx checksum offload errors

Christoph Paasch <cpaasch@openai.com>
    net: When removing nexthops, don't call synchronize_net if it is not necessary

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Does not request module for miscdevice with dynamic minor

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Make misc_register() reentry for miscdevice who wants dynamic minor

Christoph Hellwig <hch@lst.de>
    dm error: mark as DM_TARGET_PASSES_INTEGRITY

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: 8851b: rfk: update IQK TIA setting

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: fix BSSID comparison for non-transmitted BSSID

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: wow: remove notify during WoWLAN net-detect

Simon Richter <Simon.Richter@hogyros.de>
    drm/xe: Make page size consistent in loop

Mohammad Rafi Shaik <quic_mohs@quicinc.com>
    ASoC: codecs: wsa883x: Handle shared reset GPIO for WSA883x speakers

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not share the name pointer between components

Shimrra Shai <shimrrashai@gmail.com>
    ASoC: es8323: add proper left/right mixer controls via DAPM

Shimrra Shai <shimrrashai@gmail.com>
    ASoC: es8323: remove DAC enablement write from es8323_probe

raub camaioni <raubcameo@gmail.com>
    usb: gadget: f_ncm: Fix MAC assignment NCM ethernet

Haibo Chen <haibo.chen@nxp.com>
    iio: adc: imx93_adc: load calibrated values even calibration failed

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register

Xichao Zhao <zhao.xichao@vivo.com>
    hwrng: timeriomem - Use us_to_ktime() where appropriate

Chenglei Xie <Chenglei.Xie@amd.com>
    drm/amdgpu: refactor bad_page_work for corner case handling

Kent Russell <kent.russell@amd.com>
    drm/amdkfd: Handle lack of READ permissions in SVM mapping

Heng Zhou <Heng.Zhou@amd.com>
    drm/amdgpu: fix nullptr err of vm_handle_moved

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: display-connector: don't set OP_DETECT for DisplayPorts

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: PERMISSIVE_CONTROL quirk autodetection

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Use direction fix only for conditional effects

Karunika Choo <karunika.choo@arm.com>
    drm/panthor: Serialize GPU cache flush operations

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: make send_packet() more robust

Charalampos Mitrodimas <charmitro@posteo.net>
    net: ipv6: fix field-spanning memcpy warning in AH output

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: register: allow fields named `offset`

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Fix invalid access in vccqx handling

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Change reset sequence for improved stability

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix PWM mode switch issue

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix auto-hibern8 timer configuration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: mscc: report and configure in-band auto-negotiation for SGMII/QSGMII

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: wait for carrier

Ido Schimmel <idosch@nvidia.com>
    bridge: Redirect to backup port when port is administratively down

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Use pci_uevent_ers() in PCI recovery

Niklas Schnelle <schnelle@linux.ibm.com>
    powerpc/eeh: Use result of error_detected() in uevent

Shimrra Shai <shimrrashai@gmail.com>
    ASoC: es8323: enable DAPM power widgets for playback DAC and output

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    tty: serial: ip22zilog: Use platform device for probing

Lukas Wunner <lukas@wunner.de>
    thunderbolt: Use is_pciehp instead of is_hotplug_bridge

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ice: Don't use %pK through printk or tracepoints

Tiezhu Yang <yangtiezhu@loongson.cn>
    net: stmmac: Check stmmac_hw_setup() in stmmac_resume()

Kirill A. Shutemov <kas@kernel.org>
    x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall

Lukas Wunner <lukas@wunner.de>
    PCI/ERR: Update device error_state already after reset

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Drain send wrs of GSI QP

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Remove early fb

Jayesh Choudhary <j-choudhary@ti.com>
    drm/tidss: Set crtc modesetting parameters with adjusted mode

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: cdns-dsi: Don't fail on MIPI_DSI_MODE_VIDEO_BURST

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: cdns-dsi: Fix REG_WAKEUP_TIME value

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Use the crtc_* timings when programming the HW

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: amphion: Delete v4l2_fh synchronously in .release()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: pci: ivtv: Don't create fake v4l2_fh

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: devmem: flip the direction of Tx tests

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: devmem: add / correct the IPv6 support

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdkfd: return -ENOTTY for unsupported IOCTLs

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: add dummy C2H handlers for BCN resend and update done

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: sdio: use indirect IO for device registers before power-on

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: print just once for unknown C2H events

Wake Liu <wakel@google.com>
    selftests/net: Ensure assert() triggers in psock_tpacket.c

Wake Liu <wakel@google.com>
    selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8

Christopher Orr <chris.orr@gmail.com>
    drm/panel-edp: Add SHP LQ134Z1 panel for Dell XPS 9345

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: always set RMDevidCheckIgnore for GSP-RM

Marcos Del Sol Vives <marcos@orca.pet>
    PCI: Disable MSI on RDC PCI to PCIe bridges

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sharp-memory: Do not access GEM-DMA vaddr directly

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    docs: kernel-doc: avoid script crash on ancient Python

Matthew Auld <matthew.auld@intel.com>
    drm/xe: rework PDE PAT index selection

TungYu Lu <tungyu.lu@amd.com>
    drm/amd/display: Wait until OTG enable state is cleared

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: add to custom amdgpu_drm_release drm_dev_enter/exit

Danny Wang <Danny.Wang@amd.com>
    drm/amd/display: Reset apply_eamless_boot_optimization when dpms_off

Terry Cheong <htcheong@chromium.org>
    ASoC: mediatek: Use SND_JACK_AVOUT for HDMI/DP jacks

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Add keyword "init" in profile section

Seyediman Seyedarab <imandevel@gmail.com>
    drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe/pf: Program LMTT directory pointer on all GTs within a tile

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Unify pm and rpm suspend and resume callbacks

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on arcturus

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on aldebaran

Paul Hsieh <Paul.Hsieh@amd.com>
    drm/amd/display: update dpp/disp clock from smu clock table

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix dmub access race condition

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: skip mgpu fan boost for multi-vf

Mangesh Gadre <Mangesh.Gadre@amd.com>
    drm/amdgpu: Initialize jpeg v5_0_1 ras function

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: add more cyan skillfish devices

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Skip poison aca bank from UE channel

Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
    drm/xe: Extend wa_13012615864 to additional Xe2 and Xe3 platforms

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: Fix vcn v5.0.1 poison irq call trace

Meng Li <li.meng@amd.com>
    drm/amd/amdgpu: Release xcp drm memory after unplug

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Effective health check before reset

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Avoid rma causes GPU duplicate reset

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Update IPID value for bad page threshold CPER

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: Fix build error when CONFIG_SUSPEND is disabled

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Don't resume device from restart worker

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Fix oops in xe_gem_fault when running core_hotunplug test.

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Add more GuC load error status codes

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Cache streams targeting link when performing LT automation

Ovidiu Bunea <ovidiu.bunea@amd.com>
    drm/amd/display: Fix dmub_cmd header alignment

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Move setup_stream_attribute

Cruise Hung <Cruise.Hung@amd.com>
    drm/amd/display: Remove check DPIA HPD status for BW Allocation

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu: Check vcn sram load return value

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: add range check for RAS bad page address

Clay King <clayking@amd.com>
    drm/amd/display: ensure committing streams is seamless

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix condition for setting timing_adjust_pending

Ostrowski Rafal <rostrows@amd.com>
    drm/amd/display: Update tiled to tiled copy command

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/configfs: Enforce canonical device names

Sk Anirban <sk.anirban@intel.com>
    drm/xe/ptl: Apply Wa_16026007364

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mfd: intel-lpss: Add Intel Wildcat Lake LPSS PCI IDs

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: cs42l43: Move IRQ enable/disable to encompass force suspend

Bastien Curutchet <bastien.curutchet@bootlin.com>
    mfd: core: Increment of_node's refcount before linking it to the platform device

Janne Grunau <j@jannau.net>
    mfd: macsmc: Add "apple,t8103-smc" compatible

Jens Kehne <jens.kehne@agilent.com>
    mfd: da9063: Split chip variant reading in two bus transactions

Arnd Bergmann <arnd@arndb.de>
    mfd: madera: Work around false-positive -Wininitialized warning

Heiko Stuebner <heiko@sntech.de>
    mfd: qnap-mcu: Include linux/types.h in qnap-mcu.h shared header

Heiko Stuebner <heiko@sntech.de>
    mfd: qnap-mcu: Handle errors returned from qnap_mcu_write

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe-i2c: Add missing MODULE_LICENSE

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe: Remove IRQ domain upon removal

Ioana Ciornei <ioana.ciornei@nxp.com>
    mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Prefer driver HWP limits

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Enhance HWP enable

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/power turbostat: Fix incorrect sorting of PMT telemetry

Mykyta Yatsenko <yatsenko@meta.com>
    selftests/bpf: Fix flaky bpf_cookie selftest

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: Fix incorrect size in cpuidle_state_disable()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add support for Dell OptiPlex 7040

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Remove Dell Precision 490 custom config data

Ben Copeland <ben.copeland@linaro.org>
    hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex

Jiri Olsa <jolsa@kernel.org>
    uprobe: Do not emulate/sstep original instruction when ip is changed

Alistair Francis <alistair.francis@wdc.com>
    nvme: Use non zero KATO for persistent discovery connections

Amery Hung <ameryhung@gmail.com>
    selftests: drv-net: Pull data before parsing headers

Amery Hung <ameryhung@gmail.com>
    bpf: Clear pfmemalloc flag when freeing all fragments

Chenghao Duan <duanchenghao@kylinos.cn>
    riscv: bpf: Fix uninitialized symbol 'retval_off'

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix possible deadlock while configuring policy

Markus Stockhausen <markus.stockhausen@gmx.de>
    clocksource/drivers/timer-rtl-otto: Do not interfere with interrupts

Markus Stockhausen <markus.stockhausen@gmx.de>
    clocksource/drivers/timer-rtl-otto: Work around dying timers

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: SPCR: Support Precise Baud Rate field

Biju Das <biju.das.jz@bp.renesas.com>
    spi: rpc-if: Add resume support for RZ/G3E

Uday Shankar <ushankar@purestorage.com>
    selftests: ublk: fix behavior when fio is not installed

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix selftest verifier_arena_large failure

Pranav Tyagi <pranav.tyagi03@gmail.com>
    futex: Don't leak robust_list pointer on exec race

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: Fail cpuidle device registration if there is one already

Tom Stellard <tstellar@redhat.com>
    bpftool: Fix -Wuninitialized-const-pointer warnings with clang >= 21

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    power: supply: qcom_battmgr: handle charging state change notifications

Janne Grunau <j@jannau.net>
    pmdomain: apple: Add "apple,t8103-pmgr-pwrstate"

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: account niov arrays to cgroup

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: fix error return value in cpupower_write_sysfs()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: check all niovs filled with dma addresses

Manikanta Guntupalli <manikanta.guntupalli@amd.com>
    i3c: dw: Add shutdown support to dw_i3c_master driver

Svyatoslav Ryhel <clamor95@gmail.com>
    video: backlight: lp855x_bl: Set correct EPROM start for LP8556

Kaibo Ma <ent3rm4n@gmail.com>
    rust: kunit: allow `cfg` on `test`s

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci-pci: Add support for Intel Wildcat Lake-U I3C

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Do not limit bpf_cgroup_from_id to current's namespace

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    selftests/bpf: Fix arena_spin_lock selftest failure

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: Enable PCI on UML without triggering WARN()

Daniel Wagner <wagi@kernel.org>
    nvme-fc: use lock accessing port_state and rport state

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: avoid scheduling association deletion twice

Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
    tee: allow a driver to allocate a tee_device without a pool

Hans de Goede <hansg@kernel.org>
    ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: pca9685: Use bulk write to atomicially update registers

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card

Bryan Brattlof <bb@ti.com>
    soc: ti: k3-socinfo: Add information for AM62L SR1.1

Nikita Travkin <nikita@trvn.ru>
    firmware: qcom: tzmem: disable sc7180 platform

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: transformer-20: fix audio-codec interrupt

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: transformer-20: add missing magnetometer interrupt

Jonas Schwöbel <jonasschwoebel@yahoo.de>
    ARM: tegra: p880: set correct touchscreen clipping

Svyatoslav Ryhel <clamor95@gmail.com>
    soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    arm64: zynqmp: Revert usb node drive strength and slew rate for zcu106

Quanyang Wang <quanyang.wang@windriver.com>
    arm64: zynqmp: Disable coresight by default

Sohil Mehta <sohil.mehta@intel.com>
    cpufreq: ondemand: Update the efficient idle check for Intel extended Families

Ming Wang <wangming01@loongson.cn>
    irqchip/loongson-pch-lpc: Use legacy domain for PCH-LPC IRQ controller

Keith Busch <kbusch@kernel.org>
    block: check for valid bio while splitting

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix incorrect array size calculation

Andreas Kemnade <andreas@kemnade.info>
    hwmon: sy7636a: add alias

Caleb Sander Mateos <csander@purestorage.com>
    io_uring/rsrc: respect submitter_task in io_register_clone_buffers()

Fabien Proriol <fabien.proriol@viavisolutions.com>
    power: supply: sbs-charger: Support multiple devices

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: keembay: release allocated memory in detach path

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Add suspend/resume support for Schmitt control registers

Chuande Chen <chuachen@cisco.com>
    hwmon: (sbtsi_temp) AMD CPU extended temperature range support

David Ober <dober6023@gmail.com>
    hwmon: (lenovo-ec-sensors) Update P8 supprt

Rong Zhang <i@rong.moe>
    hwmon: (k10temp) Add device ID for Strix Halo

Avadhut Naik <avadhut.naik@amd.com>
    hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models

Christopher Ruehl <chris.ruehl@gtsys.com.hk>
    power: supply: qcom_battmgr: add OOI chemistry

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: selftests: workload_hint: Mask unsupported types

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: gov_step_wise: Allow cooling level to be reduced earlier

Hans de Goede <hansg@kernel.org>
    ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]

Sam van Kampen <sam@tehsvk.net>
    ACPI: resource: Skip IRQ override on ASUS Vivobook Pro N6506CU

Shang song (Lenovo) <shangsong2@foxmail.com>
    ACPI: PRM: Skip handlers with NULL handler_address or NULL VA

Christian Bruel <christian.bruel@foss.st.com>
    irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Add CET-aware symbol matching for x86_64 architectures

Kees Cook <kees@kernel.org>
    arc: Fix __fls() const-foldability via __builtin_clzl()

Thomas Weißschuh <linux@weissschuh.net>
    kselftest/arm64: tpidr2: Switch to waitpid() over wait4()

Val Packett <val@packett.cool>
    firmware: qcom: scm: Allow QSEECOM on Dell Inspiron 7441 / Latitude 7455

Dennis Beier <nanovim@gmail.com>
    cpufreq/longhaul: handle NULL policy in longhaul_exit

Harini T <harini.t@amd.com>
    arm64: versal-net: Update rtc calibration value

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2

Jiawei Zhao <phoenix500526@163.com>
    libbpf: Fix USDT SIB argument handling causing unrecognized register error

Mario Limonciello (AMD) <superm1@kernel.org>
    ACPI: video: force native for Lenovo 82K8

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    ACPI: sysfs: Use ACPI_FREE() for freeing an ACPI object

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zctx: check chained notif contexts

Bibo Mao <maobibo@loongson.cn>
    irqchip/loongson-eiointc: Route interrupt parsed from bios table

Inochi Amaoto <inochiama@gmail.com>
    irqchip/sifive-plic: Respect mask state when setting affinity

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: ohci: move self_id_complete tracepoint after validating register

Kendall Willis <k-willis@ti.com>
    firmware: ti_sci: Enable abort handling of entry to LPM

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Use tnums for JEQ/JNE is_branch_taken logic

Paresh Bhagat <p-bhagat@ti.com>
    cpufreq: ti: Add support for AM62D2

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Add timeout to prevent indefinite waiting

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: host: renesas_sdhi: Fix the actual clock

Chi Zhang <chizhang@asrmicro.com>
    pinctrl: single: fix bias pull up/down handling in pin_config_set

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf: Don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    soc: ti: pruss: don't use %pK through printk

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: handle 'use_ecc' parameter of qcom_spi_config_cw_read()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    spi: loopback-test: Don't use %pK through printk

Jens Reidel <adrian@mainlining.org>
    soc: qcom: smem: Fix endian-unaware access of num_entries

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: preserve assign_mem() error return value

Ryan Chen <ryan_chen@aspeedtech.com>
    soc: aspeed: socinfo: Add AST27xx silicon IDs

Owen Gu <guhuinan@xiaomi.com>
    usb: gadget: f_fs: Fix epfile null pointer access after ep enable.

Heijligen, Thomas <thomas.heijligen@secunet.com>
    mfd: kempld: Switch back to earlier ->init() behavior

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Allow pm_restrict_gfp_mask() stacking

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: hibernate: Combine return paths in power_down()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Select polling state in some more cases

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Rearrange main loop in menu_select()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix MSG_PEEK stream corruption

Paolo Abeni <pabeni@redhat.com>
    mptcp: leverage skb deferral free

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Add HDR workaround for a specific eDP

Matthew Schwartz <matthew.schwartz@linux.dev>
    drm/amd/display: Don't program BLNDGAM_MEM_PWR_FORCE when CM low-power is disabled on DCN30

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Fix incorrect return of vblank enable on unconfigured crtc

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check that VPE has reached DPM0 in idle handler

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Clear preserved bits from register output value

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dmc: Clear HRR EVT_CTL/HTP to zero on ADL-S

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix device use-after-free on unbind

Philipp Stanner <phasta@kernel.org>
    drm/nouveau: Fix race in nouveau_sched_fini()

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix race in drm_sched_entity_select_rq()

David Rosca <david.rosca@amd.com>
    drm/sched: avoid killing parent entity on child SIGKILL

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Do not dereference NULL pointer in plane reset

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Do not wake device during a GT reset

Miaoqian Lin <linmq006@gmail.com>
    s390/mm: Fix memory leak in add_marker() when kvrealloc() fails

Heiko Carstens <hca@linux.ibm.com>
    s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump

Shawn Guo <shawnguo@kernel.org>
    regmap: irq: Correct documentation of wake_invert flag

Alexey Klimov <alexey.klimov@linaro.org>
    regmap: slimbus: fix bus_context pointer in regmap init calls

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix KASAN global-out-of-bounds warning

Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>
    kbuild: align modinfo section for Secureboot Authenticode EDK2 compat

Akash Goel <akash.goel@arm.com>
    dma-fence: Fix safe access wrapper to call timeline name method

Damien Le Moal <dlemoal@kernel.org>
    block: make REQ_OP_ZONE_OPEN a write operation

Damien Le Moal <dlemoal@kernel.org>
    block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Use ACPI handle when retrieving _FST

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix SPDX header on irqsrcs_vcn_5_0.h

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix SPDX header on amd_cper.h

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix SPDX headers on amdgpu_cper.c/h

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()

Daniel Palmer <daniel@0x0f.com>
    drm/radeon: Remove calls to drm_put_dev()

Daniel Palmer <daniel@0x0f.com>
    drm/radeon: Do not kfree() devres managed rdev

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: soc_sdw_utils: remove cs42l43 component_name

Maarten Zanders <maarten@zanders.be>
    ASoC: fsl_sai: Fix sync error in consumer mode

Petr Oros <poros@redhat.com>
    dpll: spec: add missing module-name and clock-id to pin-get reply

Hangbin Liu <liuhangbin@gmail.com>
    tools: ynl: avoid print_field when there is no reply

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    sfc: fix potential memory leak in efx_mae_process_mport()

Jijie Shao <shaojijie@huawei.com>
    net: hns3: return error code when function fails

Petr Oros <poros@redhat.com>
    tools: ynl: fix string attribute length to include null terminator

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    drm/etnaviv: fix flush sequence logic

Tony Luck <tony.luck@intel.com>
    ACPI: MRRM: Check revision of MRRM table

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: don't log messages meant for 1810c when initializing 1824c

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: add mono main switch to Presonus S1824c

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Ensure vm is created in VM_BIND ioctl

Malin Jonsson <malin.jonsson@est.tech>
    bpf: Conditionally include dynptr copy kfuncs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix tracking of periodic advertisement

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix connection cleanup with BIG with 2 or more BIS

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Fix event packet loss issue

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix another instance of dst_type handling

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix BIS connection dst_type handling

Cen Zhang <zzzccc427@163.com>
    Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once

Lizhi Xu <lizhi.xu@windriver.com>
    usbnet: Prevents free active kevent

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: mediatek: Fix double pm_runtime_disable in remove functions

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix powerpc's stack register definition in bpf_tracing.h

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: correct the endian format for DSD

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: fix bit order for DSD format

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Disable periods-elapsed work when closing PCM

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Unprepare a stream when XRUN occurs

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: aspeed - fix double free caused by devm

Harald Freudenberger <freude@linux.ibm.com>
    crypto: s390/phmac - Do not modify the req->nbytes value

Hannes Reinecke <hare@suse.de>
    nvmet-auth: update sc_c in host response

Ondrej Mosnacek <omosnace@redhat.com>
    bpf: Do not audit capability check in do_jit()

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix the unit attention counter implementation

Wonkon Kim <wkon.kim@samsung.com>
    scsi: ufs: core: Initialize value of an attribute returned by uic cmd

Noorain Eqbal <nooraineqbal@gmail.com>
    bpf: Sync pending IRQ work before freeing ring buffer

Florian Schmaus <florian.schmaus@codasip.com>
    kunit: test_dev_action: Correctly cast 'priv' pointer to long*

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: nl80211: call kfree without a NULL check

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix key tailroom accounting leak

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    wifi: mac80211: reset FILS discovery and unsol probe resp intervals

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib-test: Fix missing include of kunit/test-bug.h

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: iwlwifi: fix potential use after free in iwl_mld_remove_link()

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: fix control pipe direction

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: make sure last_fence is always updated

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix GMU firmware parser

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix GEM free for imported dma-bufs

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath11k: avoid bit operation on key flags

Karthik M <quic_karm@quicinc.com>
    wifi: ath12k: free skb during idr cleanup callback

Mark Pearson <mpearson-lenovo@squebb.ca>
    wifi: ath11k: Add missing platform IDs for quirk table

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix memory leak on unsupported WMI command

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Ensure XFD state on signal delivery

Gregory Price <gourry@gourry.net>
    x86/CPU/AMD: Add RDSEED fix for Zen5

Peter Zijlstra <peterz@infradead.org>
    x86/build: Disable SSE4a

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential cfid UAF in smb2_query_info_compound

Farhan Ali <alifm@linux.ibm.com>
    s390/pci: Restore IRQ unconditionally for the zPCI device

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Use proper dma_buffer_pos after resume

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qdsp6: q6asm: do not sleep while atomic

Paolo Abeni <pabeni@redhat.com>
    mptcp: restore window probe

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop bogus optimization in __mptcp_check_push()

Miaoqian Lin <linmq006@gmail.com>
    fbdev: valkyriefb: Fix reference count leak in valkyriefb_init

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix crash while sending Action Frames in standalone AP Mode

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    net: phy: dp83867: Disable EEE support as not implemented

Johan Hovold <johan@kernel.org>
    Bluetooth: rfcomm: fix modem control handling

Junjie Cao <junjie.cao@intel.com>
    fbdev: bitblit: bound-check glyph index in bit_putcs*

Sven Eckelmann <sven@narfation.org>
    batman-adv: Release references to inactive interfaces

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: drop the multi-buffer XDP packet in zerocopy

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Use platform device for devres-related actions

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    ACPI: button: Call input_free_device() on failing input device registration

Yuhao Jiang <danisjiang@gmail.com>
    ACPI: video: Fix use-after-free in acpi_video_switch_brightness()

Daniel Palmer <daniel@0x0f.com>
    fbdev: atyfb: Check if pll_ops->init_pll failed

Quanmin Yan <yanquanmin1@huawei.com>
    fbcon: Set fb_display[i]->mode to NULL when the mode is released

Miaoqian Lin <linmq006@gmail.com>
    net: usb: asix_devices: Check return value of usbnet_get_endpoints

Chuck Lever <chuck.lever@oracle.com>
    Revert "NFSD: Remove the cap on number of operations per NFSv4 COMPOUND"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix crash in nfsd4_read_release()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define actions for the new time_deleg FATTR4 attributes

Tejun Heo <tj@kernel.org>
    sched_ext: Mark scx_bpf_dsq_move_set_[slice|vtime]() with KF_RCU

Frédéric Danis <frederic.danis@collabora.com>
    Revert "Bluetooth: L2CAP: convert timeouts to secs_to_jiffies()"


-------------

Diffstat:

 .../devicetree/bindings/display/msm/gmu.yaml       |  34 ++
 Documentation/netlink/specs/dpll.yaml              |   2 +
 Documentation/netlink/specs/fou.yaml               |   4 +-
 Makefile                                           |   4 +-
 arch/arc/include/asm/bitops.h                      |   2 +
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts    |   5 +-
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts       |   4 +-
 arch/arm/mach-at91/pm_suspend.S                    |   8 +-
 arch/arm64/boot/dts/xilinx/versal-net.dtsi         |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts  |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
 arch/loongarch/include/asm/inst.h                  |   5 +
 arch/loongarch/kernel/inst.c                       |  12 +
 arch/mips/boot/dts/lantiq/danube.dtsi              |   6 +
 arch/mips/boot/dts/lantiq/danube_easy50712.dts     |   4 +-
 arch/mips/lantiq/xway/sysctrl.c                    |   2 +-
 arch/mips/sgi-ip22/ip22-platform.c                 |  32 ++
 arch/openrisc/kernel/module.c                      |   4 +
 arch/parisc/include/asm/video.h                    |   2 +-
 arch/parisc/kernel/unwind.c                        |  13 +-
 arch/powerpc/kernel/eeh_driver.c                   |   2 +-
 arch/riscv/kernel/module-sections.c                |   8 +-
 arch/riscv/kernel/stacktrace.c                     |  21 +-
 arch/riscv/mm/ptdump.c                             |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   5 +-
 arch/s390/Kconfig                                  |   1 -
 arch/s390/crypto/phmac_s390.c                      |  52 ++-
 arch/s390/include/asm/pci.h                        |   1 -
 arch/s390/mm/dump_pagetables.c                     |  19 +-
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/s390/pci/pci_irq.c                            |   9 +-
 arch/sparc/include/asm/elf_64.h                    |   1 +
 arch/sparc/include/asm/io_64.h                     |   6 +-
 arch/sparc/include/asm/video.h                     |   2 +
 arch/sparc/kernel/module.c                         |   1 +
 arch/um/drivers/ssl.c                              |   5 +-
 arch/x86/Makefile                                  |   2 +-
 arch/x86/entry/vsyscall/vsyscall_64.c              |  17 +-
 arch/x86/events/intel/ds.c                         |   3 +-
 arch/x86/include/asm/amd/node.h                    |   1 -
 arch/x86/include/asm/runtime-const.h               |   4 +
 arch/x86/include/asm/tdx.h                         |   2 +
 arch/x86/include/asm/uaccess_64.h                  |  10 +-
 arch/x86/include/asm/video.h                       |   2 +
 arch/x86/kernel/amd_node.c                         | 150 +++----
 arch/x86/kernel/cpu/amd.c                          |  11 +
 arch/x86/kernel/cpu/common.c                       |   6 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +
 arch/x86/kernel/cpu/mshyperv.c                     |  11 +-
 arch/x86/kernel/fpu/core.c                         |   3 +
 arch/x86/kernel/kvm.c                              |  20 +-
 arch/x86/kvm/vmx/tdx.c                             |   9 +
 arch/x86/net/bpf_jit_comp.c                        |   2 +-
 arch/x86/video/video-common.c                      |  25 +-
 arch/x86/virt/vmx/tdx/tdx.c                        |  21 +-
 block/blk-cgroup.c                                 |  23 +-
 block/blk-map.c                                    |   2 +-
 block/blk-merge.c                                  |  21 +-
 drivers/accel/amdxdna/aie2_ctx.c                   |  59 +--
 drivers/accel/amdxdna/aie2_pci.c                   |  37 +-
 drivers/accel/amdxdna/aie2_pci.h                   |   5 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |  26 --
 drivers/accel/amdxdna/amdxdna_ctx.h                |   2 -
 drivers/accel/amdxdna/amdxdna_pci_drv.c            |  74 +---
 drivers/accel/amdxdna/amdxdna_pci_drv.h            |   4 +-
 drivers/accel/habanalabs/common/memory.c           |   2 +-
 drivers/accel/habanalabs/gaudi/gaudi.c             |  19 +
 drivers/accel/habanalabs/gaudi2/gaudi2.c           |  15 +-
 drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c |   2 +-
 drivers/acpi/acpi_mrrm.c                           |   3 +
 drivers/acpi/acpi_video.c                          |   4 +-
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/button.c                              |   4 +-
 drivers/acpi/device_sysfs.c                        |   2 +-
 drivers/acpi/fan.h                                 |   7 +-
 drivers/acpi/fan_attr.c                            |   2 +-
 drivers/acpi/fan_core.c                            |  36 +-
 drivers/acpi/fan_hwmon.c                           |  11 +-
 drivers/acpi/prmt.c                                |  19 +-
 drivers/acpi/property.c                            |  24 +-
 drivers/acpi/resource.c                            |   7 +
 drivers/acpi/scan.c                                |   4 +
 drivers/acpi/spcr.c                                |  10 +-
 drivers/acpi/video_detect.c                        |   8 +
 drivers/base/regmap/regmap-slimbus.c               |   6 +-
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/bluetooth/btintel_pcie.c                   |  20 +-
 drivers/bluetooth/btmtksdio.c                      |  12 +
 drivers/bluetooth/btrtl.c                          |   4 +-
 drivers/bluetooth/btusb.c                          |  21 +
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/bus/mhi/host/internal.h                    |   2 +
 drivers/bus/mhi/host/pci_generic.c                 |  16 +-
 drivers/bus/mhi/host/pm.c                          |   2 +-
 drivers/char/hw_random/timeriomem-rng.c            |   2 +-
 drivers/char/misc.c                                |  12 +-
 drivers/clk/at91/clk-master.c                      |   3 +
 drivers/clk/at91/clk-sam9x60-pll.c                 |  75 ++--
 drivers/clk/at91/pmc.h                             |   1 +
 drivers/clk/at91/sam9x60.c                         |   2 +
 drivers/clk/at91/sam9x7.c                          |   6 +
 drivers/clk/at91/sama7d65.c                        |   4 +
 drivers/clk/at91/sama7g5.c                         |   2 +
 drivers/clk/clk-scmi.c                             |  11 +-
 drivers/clk/qcom/gcc-ipq6018.c                     |  60 +--
 drivers/clk/renesas/rzv2h-cpg.c                    |  13 +-
 drivers/clk/samsung/clk-exynos990.c                |   2 +
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c               |  11 +
 drivers/clk/thead/clk-th1520-ap.c                  |  44 +--
 drivers/clk/ti/clk-33xx.c                          |   2 +
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |   2 +-
 drivers/clocksource/hyperv_timer.c                 |  10 +-
 drivers/clocksource/timer-rtl-otto.c               |  26 +-
 drivers/clocksource/timer-vf-pit.c                 |  22 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |  25 +-
 drivers/cpufreq/cpufreq_ondemand.h                 |  23 ++
 drivers/cpufreq/longhaul.c                         |   3 +
 drivers/cpufreq/tegra186-cpufreq.c                 |  27 +-
 drivers/cpufreq/ti-cpufreq.c                       |   2 +
 drivers/cpuidle/cpuidle.c                          |   8 +-
 drivers/cpuidle/governors/menu.c                   |  79 ++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   5 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |   2 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 drivers/crypto/aspeed/aspeed-acry.c                |   2 -
 drivers/crypto/caam/ctrl.c                         |   4 +-
 drivers/crypto/ccp/hsti.c                          |   2 +-
 drivers/crypto/ccp/sev-dev.c                       |  10 +
 drivers/crypto/hisilicon/qm.c                      |  78 ++--
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |   2 +-
 drivers/dma-buf/dma-fence.c                        |   2 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  22 ++
 drivers/dma/idxd/init.c                            |   2 +
 drivers/dma/idxd/registers.h                       |   1 +
 drivers/dma/mv_xor.c                               |   4 +-
 drivers/dma/sh/shdma-base.c                        |  25 +-
 drivers/dma/sh/shdmac.c                            |  17 +-
 drivers/extcon/extcon-adc-jack.c                   |   2 +
 drivers/extcon/extcon-axp288.c                     |   2 +-
 drivers/extcon/extcon-fsa9480.c                    |   2 +-
 drivers/firewire/ohci.c                            |  12 +-
 drivers/firmware/qcom/qcom_scm.c                   |   4 +-
 drivers/firmware/qcom/qcom_tzmem.c                 |   1 +
 drivers/firmware/ti_sci.c                          |  57 ++-
 drivers/firmware/ti_sci.h                          |   3 +
 drivers/gpio/gpiolib-swnode.c                      |   2 +-
 drivers/gpio/gpiolib.c                             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c            |  53 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  66 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c           |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  68 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            | 127 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          | 123 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h          |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c            |  40 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h           |   4 +
 drivers/gpu/drm/amd/amdgpu/atom.c                  |   4 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |  12 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |  20 +-
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c         |  23 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c              |  32 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c              |  35 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   1 -
 drivers/gpu/drm/amd/amdgpu/umc_v12_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |  20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  25 ++
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c        |  56 ++-
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h        |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 183 +++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  17 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |  86 ++--
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  34 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  13 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |   2 +-
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |   3 +
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |   5 +
 .../drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |  16 +
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c | 142 ++++++-
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h |   5 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  27 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |   4 +-
 drivers/gpu/drm/amd/display/dc/dc_helper.c         |   5 +
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   3 +
 .../drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c   |   2 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c   |   1 +
 drivers/gpu/drm/amd/display/dc/dm_services.h       |   2 +
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c |  20 +-
 .../drm/amd/display/dc/dml2/display_mode_core.c    |   2 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |   4 +
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |  28 +-
 .../gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c   |   3 -
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |   5 +
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   1 +
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  73 ++--
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   5 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   2 +
 .../drm/amd/display/dc/inc/hw/timing_generator.h   |   1 +
 .../amd/display/dc/link/accessories/link_dp_cts.c  |  18 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   5 +
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   3 -
 .../gpu/drm/amd/display/dc/link/link_validation.c  |   6 +-
 .../display/dc/link/protocols/link_dp_dpia_bw.c    |  58 ++-
 .../display/dc/link/protocols/link_dp_training.c   |   9 +-
 .../gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h |   1 +
 .../gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c |  18 +
 .../drm/amd/display/dc/optc/dcn401/dcn401_optc.c   |   5 +
 .../display/dc/resource/dce100/dce100_resource.c   |  10 +-
 .../amd/display/dc/resource/dce60/dce60_resource.c |  21 +-
 .../amd/display/dc/resource/dce80/dce80_resource.c |  10 +-
 .../display/dc/resource/dcn314/dcn314_resource.c   |   1 +
 .../display/dc/virtual/virtual_stream_encoder.c    |   7 +
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    |  18 +-
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c  |  53 +--
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h  |   8 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |   5 +
 drivers/gpu/drm/amd/include/amd_cper.h             |   2 +-
 .../drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h  |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   5 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_smc.c         |  26 +-
 .../gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c  |   2 +-
 .../drm/amd/pm/powerplay/smumgr/iceland_smumgr.c   |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   8 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  23 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  18 +
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  12 +-
 drivers/gpu/drm/bridge/display-connector.c         |   3 +-
 drivers/gpu/drm/drm_gem_atomic_helper.c            |   8 +-
 drivers/gpu/drm/drm_gpusvm.c                       |  33 +-
 drivers/gpu/drm/drm_panel_backlight_quirks.c       |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |  55 ++-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  10 -
 drivers/gpu/drm/mediatek/mtk_plane.c               |  24 +-
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |  10 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              | 113 +++++-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |   1 +
 drivers/gpu/drm/msm/adreno/a6xx_preempt.c          |  20 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  17 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |  35 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h      |   3 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |  15 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |  10 +
 drivers/gpu/drm/msm/msm_gem.c                      |  31 +-
 drivers/gpu/drm/msm/msm_gem.h                      |   6 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   9 +-
 drivers/gpu/drm/msm/msm_gem_vma.c                  |   2 +-
 drivers/gpu/drm/msm/registers/gen_header.py        |   7 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.h            |   1 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |  24 +-
 drivers/gpu/drm/nouveau/dispnv50/wndwca7e.c        |  33 ++
 drivers/gpu/drm/nouveau/nouveau_sched.c            |  14 +-
 drivers/gpu/drm/nouveau/nvkm/core/enum.c           |   2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |   3 +
 drivers/gpu/drm/panel/panel-edp.c                  |   1 +
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |  31 +-
 drivers/gpu/drm/panthor/panthor_gpu.c              |   7 +
 drivers/gpu/drm/panthor/panthor_mmu.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |  25 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 -
 drivers/gpu/drm/scheduler/sched_entity.c           |  40 +-
 drivers/gpu/drm/sitronix/st7571-i2c.c              |   7 +-
 drivers/gpu/drm/tidss/tidss_crtc.c                 |   7 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |  16 +-
 drivers/gpu/drm/tidss/tidss_drv.c                  |   9 +
 drivers/gpu/drm/tiny/sharp-memory.c                |  27 +-
 drivers/gpu/drm/xe/abi/guc_errors_abi.h            |   3 +
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h              |   1 +
 drivers/gpu/drm/xe/xe_bo.c                         |  41 +-
 drivers/gpu/drm/xe/xe_configfs.c                   |   9 +-
 drivers/gpu/drm/xe/xe_device.c                     |  12 +-
 drivers/gpu/drm/xe/xe_device_sysfs.c               |   8 +-
 drivers/gpu/drm/xe/xe_gt.c                         |  21 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c                |  24 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |  12 +
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h        |   1 +
 drivers/gpu/drm/xe/xe_guc.c                        |  40 +-
 drivers/gpu/drm/xe/xe_guc_ads.c                    |  35 ++
 drivers/gpu/drm/xe/xe_guc_ct.c                     |  50 ++-
 drivers/gpu/drm/xe/xe_guc_ct.h                     |   1 +
 drivers/gpu/drm/xe/xe_guc_log.h                    |   2 +-
 drivers/gpu/drm/xe/xe_hwmon.c                      |   8 +-
 drivers/gpu/drm/xe/xe_i2c.c                        |   2 +-
 drivers/gpu/drm/xe/xe_lmtt.c                       |   9 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |  14 +-
 drivers/gpu/drm/xe/xe_pm.c                         |   8 +-
 drivers/gpu/drm/xe/xe_pt.c                         |   4 +-
 drivers/gpu/drm/xe/xe_pt_types.h                   |   3 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  34 +-
 drivers/gpu/drm/xe/xe_vram_freq.c                  |   4 +-
 drivers/gpu/drm/xe/xe_wa.c                         |  17 +-
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |   3 +-
 drivers/gpu/nova-core/regs.rs                      |   5 +-
 drivers/gpu/nova-core/regs/macros.rs               |   2 +-
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-ids.h                              |   2 +-
 drivers/hid/hid-universal-pidff.c                  |  20 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   8 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  28 +-
 drivers/hid/i2c-hid/i2c-hid.h                      |   2 +
 drivers/hid/usbhid/hid-pidff.c                     |  42 +-
 drivers/hid/usbhid/hid-pidff.h                     |   2 +-
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |  21 +-
 drivers/hwmon/k10temp.c                            |  10 +
 drivers/hwmon/lenovo-ec-sensors.c                  |  34 +-
 drivers/hwmon/sbtsi_temp.c                         |  46 ++-
 drivers/hwmon/sy7636a-hwmon.c                      |   1 +
 drivers/i3c/master/dw-i3c-master.c                 |  23 ++
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c |   3 +
 drivers/iio/adc/ad7124.c                           |  62 ++-
 drivers/iio/adc/imx93_adc.c                        |  18 +-
 drivers/iio/adc/spear_adc.c                        |   9 +-
 drivers/iio/imu/bmi270/bmi270_i2c.c                |   2 +
 drivers/infiniband/core/uverbs_std_types_cq.c      |   1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  11 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |  16 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  58 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  11 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   4 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 -
 drivers/infiniband/hw/irdma/Kconfig                |   7 +-
 drivers/infiniband/hw/irdma/pble.c                 |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/hw/irdma/verbs.h                |   8 +-
 drivers/infiniband/hw/mana/cq.c                    |  26 ++
 drivers/infiniband/hw/mana/device.c                |   3 +
 drivers/infiniband/hw/mana/mana_ib.h               |   3 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  21 +-
 drivers/iommu/amd/amd_iommu_types.h                |   5 +
 drivers/iommu/amd/init.c                           | 284 +++++++++-----
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/iommu/apple-dart.c                         |   5 +
 drivers/iommu/intel/debugfs.c                      |  10 +-
 drivers/iommu/intel/iommu.h                        |   1 -
 drivers/iommu/intel/perf.c                         |  10 +-
 drivers/iommu/intel/perf.h                         |   5 +-
 drivers/iommu/intel/prq.c                          |   7 +-
 drivers/iommu/iommufd/iova_bitmap.c                |   5 +-
 drivers/irqchip/irq-gic-v2m.c                      |  13 +-
 drivers/irqchip/irq-loongson-eiointc.c             |  21 +-
 drivers/irqchip/irq-loongson-pch-lpc.c             |   9 +-
 drivers/irqchip/irq-sifive-plic.c                  |   6 +-
 drivers/md/dm-target.c                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   5 +
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        |  48 +--
 drivers/media/i2c/ir-kbd-i2c.c                     |   6 +-
 drivers/media/i2c/og01a1b.c                        |   6 +-
 drivers/media/i2c/ov08x40.c                        |   2 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c    |   6 +
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   2 -
 drivers/media/pci/ivtv/ivtv-driver.h               |   3 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |  18 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   4 +-
 drivers/media/pci/mgb4/mgb4_vin.c                  |   3 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |   7 +-
 drivers/media/platform/nxp/imx-mipi-csis.c         |  23 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   | 156 +++-----
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  89 +++++
 drivers/media/platform/qcom/camss/camss.h          |   1 +
 drivers/media/platform/verisilicon/hantro_drv.c    |   2 +
 drivers/media/platform/verisilicon/hantro_v4l2.c   |   6 +-
 drivers/media/rc/imon.c                            |  61 +--
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/tuners/xc4000.c                      |   8 +-
 drivers/media/tuners/xc5000.c                      |  12 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  15 +-
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/mfd/cs42l43.c                              |   8 +-
 drivers/mfd/da9063-i2c.c                           |  27 +-
 drivers/mfd/intel-lpss-pci.c                       |  13 +
 drivers/mfd/kempld-core.c                          |  32 +-
 drivers/mfd/macsmc.c                               |   1 +
 drivers/mfd/madera-core.c                          |   4 +-
 drivers/mfd/mfd-core.c                             |   1 +
 drivers/mfd/qnap-mcu.c                             |   6 +-
 drivers/mfd/simple-mfd-i2c.c                       |   2 +
 drivers/mfd/stmpe-i2c.c                            |   1 +
 drivers/mfd/stmpe.c                                |   3 +
 drivers/misc/eeprom/at25.c                         |  67 ++--
 drivers/misc/mei/main.c                            |  18 +-
 drivers/misc/pci_endpoint_test.c                   |  12 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   6 +-
 drivers/mmc/host/sdhci-msm.c                       |  15 +
 drivers/mmc/host/sdhci-pci-core.c                  |  15 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   5 +-
 drivers/net/dsa/b53/b53_common.c                   |  36 +-
 drivers/net/dsa/b53/b53_regs.h                     |   3 +-
 drivers/net/dsa/dsa_loop.c                         |   9 +-
 drivers/net/dsa/microchip/ksz9477.c                |  98 ++++-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   3 +-
 drivers/net/dsa/microchip/ksz_common.c             |  49 +++
 drivers/net/dsa/microchip/ksz_common.h             |   2 +
 drivers/net/dsa/ocelot/felix.c                     |   4 +
 drivers/net/dsa/ocelot/felix.h                     |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   3 +-
 drivers/net/ethernet/broadcom/bnge/bnge_rmem.c     |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 drivers/net/ethernet/google/gve/gve_ptp.c          |  15 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |   2 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_irq.c    |   2 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_nic_io.h |  15 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_rx.c     |  10 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_rx.h     |  24 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_tx.c     |  81 ++--
 drivers/net/ethernet/huawei/hinic3/hinic3_tx.h     |  18 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.c    |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  10 +-
 drivers/net/ethernet/intel/idpf/idpf.h             |   2 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         | 140 ++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        | 146 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c      |  59 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  16 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  72 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  12 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  33 ++
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   2 +
 drivers/net/ethernet/microchip/lan865x/lan865x.c   |   1 +
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |  18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   2 -
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   4 +-
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   8 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   2 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   7 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  34 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   2 -
 drivers/net/ethernet/realtek/Kconfig               |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/sfc/mae.c                     |   4 +
 drivers/net/ethernet/smsc/smsc911x.c               |  14 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c   |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.h   |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 +-
 drivers/net/ethernet/ti/icssg/icssg_config.c       |   7 +
 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c    |   7 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   4 +-
 drivers/net/hamradio/6pack.c                       |  57 +--
 drivers/net/mdio/mdio-airoha.c                     |   2 +
 drivers/net/mdio/of_mdio.c                         |   1 -
 drivers/net/netconsole.c                           |  10 +
 drivers/net/phy/dp83640.c                          |  58 +--
 drivers/net/phy/dp83867.c                          |   6 +
 drivers/net/phy/fixed_phy.c                        |   1 +
 drivers/net/phy/marvell.c                          |  39 +-
 drivers/net/phy/mscc/mscc.h                        |   3 +
 drivers/net/phy/mscc/mscc_main.c                   |  40 ++
 drivers/net/phy/phy.c                              |  15 +
 drivers/net/usb/asix_devices.c                     |  12 +-
 drivers/net/usb/qmi_wwan.c                         |   6 +
 drivers/net/usb/usbnet.c                           |   2 +
 drivers/net/virtio_net.c                           |  51 ++-
 drivers/net/wan/framer/pef2256/pef2256.c           |   7 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  40 +-
 drivers/net/wireless/ath/ath11k/core.c             |  54 ++-
 drivers/net/wireless/ath/ath11k/mac.c              |  10 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              | 156 ++++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  28 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |  14 +-
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/stats.c     |  11 +-
 .../wireless/intel/iwlwifi/pcie/gen1_2/internal.h  |   3 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   9 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   5 +-
 .../net/wireless/mediatek/mt76/mt76_connac3_mac.h  |   7 +
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |  26 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    | 116 ++++--
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +
 drivers/net/wireless/realtek/rtw89/coex.c          |   5 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  61 ++-
 drivers/net/wireless/realtek/rtw89/core.h          |  12 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   4 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  20 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   9 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |  85 ++--
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |   3 +
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |   2 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |   1 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   7 +-
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   1 +
 drivers/ntb/hw/epf/ntb_hw_epf.c                    | 103 ++---
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fc.c                             |  10 +-
 drivers/nvme/target/auth.c                         |   5 +-
 drivers/nvme/target/fc.c                           |  16 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |   2 +-
 drivers/pci/controller/cadence/pcie-cadence.c      |   4 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |   6 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   4 +
 drivers/pci/controller/dwc/pcie-designware.c       |   4 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   7 +-
 drivers/pci/p2pdma.c                               |   2 +-
 drivers/pci/pci-driver.c                           |   2 +-
 drivers/pci/pci.c                                  |   5 +
 drivers/pci/pcie/aer.c                             |   4 +
 drivers/pci/pcie/err.c                             |   3 +-
 drivers/pci/quirks.c                               |   3 +-
 drivers/phy/cadence/cdns-dphy.c                    |   4 +-
 drivers/phy/renesas/r8a779f0-ether-serdes.c        |  28 ++
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |   5 +-
 drivers/pinctrl/pinctrl-keembay.c                  |   7 +-
 drivers/pinctrl/pinctrl-single.c                   |   4 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |  12 +-
 drivers/platform/x86/amd/pmf/pmf.h                 |  15 +-
 drivers/platform/x86/amd/pmf/spc.c                 |  48 ++-
 .../platform/x86/intel/int3472/clk_and_regulator.c |   5 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |  76 +++-
 drivers/platform/x86/lenovo/think-lmi.c            |  11 +
 drivers/platform/x86/x86-android-tablets/core.c    |   6 +-
 drivers/platform/x86/x86-android-tablets/other.c   |   6 +-
 drivers/pmdomain/apple/pmgr-pwrstate.c             |   1 +
 drivers/power/supply/qcom_battmgr.c                |   8 +-
 drivers/power/supply/sbs-charger.c                 |  16 +-
 drivers/ptp/ptp_clock.c                            |  13 +-
 drivers/ptp/ptp_ocp.c                              |   6 +-
 drivers/pwm/pwm-pca9685.c                          |  46 ++-
 drivers/remoteproc/qcom_q6v5.c                     |   5 +
 drivers/remoteproc/wkup_m3_rproc.c                 |   6 +-
 drivers/rpmsg/rpmsg_char.c                         |   3 +-
 drivers/rtc/rtc-pcf2127.c                          |  19 +-
 drivers/rtc/rtc-rx8025.c                           |   2 +-
 drivers/rtc/rtc-zynqmp.c                           |  19 +
 drivers/scsi/libfc/fc_encode.h                     |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |  21 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   7 -
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  23 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   3 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  13 +
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   3 +
 drivers/scsi/pm8001/pm8001_ctl.c                   |  24 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   1 +
 drivers/scsi/pm8001/pm8001_sas.h                   |   4 +
 drivers/scsi/qla2xxx/qla_os.c                      |   5 -
 drivers/scsi/scsi_error.c                          |   4 +-
 drivers/soc/aspeed/aspeed-socinfo.c                |   4 +
 drivers/soc/qcom/smem.c                            |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra30.c              | 122 ++++++
 drivers/soc/ti/k3-socinfo.c                        |  10 +
 drivers/soc/ti/pruss.c                             |   2 +-
 drivers/spi/spi-loopback-test.c                    |  12 +-
 drivers/spi/spi-qpic-snand.c                       |  11 +-
 drivers/spi/spi-rpc-if.c                           |   2 +
 drivers/tee/tee_core.c                             |   2 +-
 drivers/thermal/gov_step_wise.c                    |  15 +-
 drivers/thunderbolt/tb.c                           |   2 +-
 drivers/tty/serdev/core.c                          |  11 +-
 drivers/tty/serial/ip22zilog.c                     | 360 +++++++----------
 drivers/tty/serial/max3100.c                       |   2 +-
 drivers/tty/serial/max310x.c                       |   3 +-
 drivers/tty/serial/qcom_geni_serial.c              |  92 +----
 drivers/tty/vt/vt_ioctl.c                          |   4 +-
 drivers/ufs/core/ufs-mcq.c                         |  11 +
 drivers/ufs/core/ufs-sysfs.c                       |   2 +-
 drivers/ufs/core/ufs-sysfs.h                       |   1 -
 drivers/ufs/core/ufshcd.c                          |  36 +-
 drivers/ufs/host/ufs-exynos.c                      |   8 +
 drivers/ufs/host/ufs-mediatek.c                    | 231 ++++++++---
 drivers/ufs/host/ufs-qcom.c                        |  31 ++
 drivers/ufs/host/ufs-qcom.h                        |   2 +-
 drivers/ufs/host/ufshcd-pci.c                      |  70 +++-
 drivers/usb/cdns3/cdnsp-gadget.c                   |   8 +-
 drivers/usb/gadget/function/f_fs.c                 |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   3 +-
 drivers/usb/host/xhci-pci.c                        |  45 ++-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/mon/mon_bin.c                          |  14 +-
 drivers/vfio/pci/nvgrace-gpu/main.c                |   2 +
 drivers/vfio/pci/vfio_pci_intrs.c                  |   7 +
 drivers/vfio/vfio_main.c                           |   2 +-
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/fbdev/aty/atyfb_base.c               |   8 +-
 drivers/video/fbdev/core/bitblit.c                 |  33 +-
 drivers/video/fbdev/core/fb_fillrect.h             |   3 +-
 drivers/video/fbdev/core/fbcon.c                   |  19 +
 drivers/video/fbdev/core/fbmem.c                   |   1 +
 drivers/video/fbdev/pvr2fb.c                       |   2 +-
 drivers/video/fbdev/valkyriefb.c                   |   2 +
 drivers/watchdog/s3c2410_wdt.c                     |  10 +-
 fs/9p/v9fs.c                                       |   9 +-
 fs/btrfs/extent_io.c                               |   8 +
 fs/btrfs/file.c                                    |  10 +
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/ceph/dir.c                                      |   3 +-
 fs/ceph/file.c                                     |   6 +-
 fs/ceph/ioctl.c                                    |  17 +-
 fs/ceph/locks.c                                    |   5 +-
 fs/ceph/mds_client.c                               |   8 +
 fs/ceph/mdsmap.c                                   |  14 +-
 fs/ceph/super.c                                    |  14 -
 fs/ceph/super.h                                    |  14 +
 fs/crypto/inline_crypt.c                           |   3 +-
 fs/exfat/balloc.c                                  |  72 +++-
 fs/exfat/fatent.c                                  |  11 +-
 fs/ext4/fast_commit.c                              |   2 +-
 fs/ext4/xattr.c                                    |   2 +-
 fs/f2fs/extent_cache.c                             |   6 +
 fs/f2fs/node.c                                     |  17 +-
 fs/f2fs/sysfs.c                                    |   9 +-
 fs/fuse/dev.c                                      |   1 +
 fs/fuse/inode.c                                    |  11 +-
 fs/fuse/virtio_fs.c                                |   6 +-
 fs/hpfs/namei.c                                    |  18 +-
 fs/jfs/inode.c                                     |   8 +-
 fs/jfs/jfs_txnmgr.c                                |   9 +-
 fs/namespace.c                                     |  15 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfs/nfs4state.c                                 |   3 +
 fs/nfsd/nfs4proc.c                                 |  21 +-
 fs/nfsd/nfs4state.c                                |   1 +
 fs/nfsd/nfs4xdr.c                                  |  12 +-
 fs/nfsd/nfsd.h                                     |   3 +
 fs/nfsd/xdr4.h                                     |   1 +
 fs/ntfs3/inode.c                                   |   1 +
 fs/open.c                                          |  10 +-
 fs/orangefs/xattr.c                                |  12 +-
 fs/overlayfs/dir.c                                 |  22 +-
 fs/smb/client/cached_dir.c                         |  17 +-
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/smb/client/smb2pdu.c                            |   7 +-
 fs/smb/client/transport.c                          |  10 +-
 fs/smb/server/transport_tcp.c                      |   7 +-
 fs/xfs/xfs_iomap.c                                 |  82 +++-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/hyperv/hvhdk_mini.h                        |   1 +
 include/linux/bio.h                                |   4 +-
 include/linux/blk_types.h                          |  11 +-
 include/linux/blkdev.h                             |   7 +
 include/linux/cgroup.h                             |   1 +
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/fbcon.h                              |   2 +
 include/linux/filter.h                             |   2 +-
 include/linux/mfd/qnap-mcu.h                       |   2 +
 include/linux/pci.h                                |   2 +-
 include/linux/platform_data/x86/int3472.h          |   1 -
 include/linux/regmap.h                             |   2 +-
 include/linux/shdma-base.h                         |   2 +-
 include/linux/tnum.h                               |   3 +
 include/linux/virtio_net.h                         |   3 +-
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |  11 +-
 include/net/bluetooth/l2cap.h                      |   4 +-
 include/net/bluetooth/mgmt.h                       |   4 +-
 include/net/cfg80211.h                             |  78 ++++
 include/net/cls_cgroup.h                           |   2 +-
 include/net/inet_connection_sock.h                 |   5 +-
 include/net/inet_hashtables.h                      |   2 +
 include/net/inet_timewait_sock.h                   |   3 +-
 include/net/nfc/nci_core.h                         |   2 +-
 include/net/rps.h                                  |   7 +-
 include/net/sock.h                                 |   4 +
 include/net/xdp.h                                  |   5 +
 include/scsi/scsi_device.h                         |  10 +-
 include/sound/tas2781-dsp.h                        |   8 +
 include/uapi/drm/drm_fourcc.h                      |  23 +-
 include/uapi/linux/virtio_net.h                    |   3 +-
 include/ufs/ufs_quirks.h                           |   3 +
 include/ufs/ufshcd.h                               |   9 +
 include/ufs/ufshci.h                               |   4 +-
 io_uring/memmap.c                                  |   2 +-
 io_uring/notif.c                                   |   5 +
 io_uring/rsrc.c                                    |  18 +-
 io_uring/zcrx.c                                    |   9 +-
 kernel/bpf/helpers.c                               |   4 +-
 kernel/bpf/ringbuf.c                               |   2 +
 kernel/bpf/tnum.c                                  |   8 +
 kernel/bpf/verifier.c                              |   4 +
 kernel/cgroup/cgroup.c                             |  24 +-
 kernel/events/core.c                               |  20 +-
 kernel/events/uprobes.c                            |   7 +
 kernel/futex/syscalls.c                            | 106 ++---
 kernel/power/hibernate.c                           |  30 +-
 kernel/power/main.c                                |  22 +-
 kernel/sched/ext.c                                 |   8 +-
 kernel/trace/ftrace.c                              |   2 +
 kernel/trace/ring_buffer.c                         |   4 +
 kernel/trace/trace_events_hist.c                   |   6 +-
 kernel/trace/trace_fprobe.c                        |   7 +-
 lib/crypto/Makefile                                |   2 +-
 lib/kunit/Kconfig                                  |  11 +
 lib/kunit/kunit-test.c                             |   2 +-
 net/8021q/vlan.c                                   |   2 +
 net/9p/trans_fd.c                                  |   9 +-
 net/batman-adv/originator.c                        |  14 +-
 net/bluetooth/hci_conn.c                           |  27 +-
 net/bluetooth/hci_event.c                          |  18 +-
 net/bluetooth/hci_sync.c                           |  23 +-
 net/bluetooth/iso.c                                |  33 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/bluetooth/mgmt.c                               |  32 +-
 net/bluetooth/rfcomm/tty.c                         |  26 +-
 net/bluetooth/sco.c                                |   7 +
 net/bridge/br.c                                    |   5 +
 net/bridge/br_forward.c                            |   5 +-
 net/bridge/br_if.c                                 |   1 +
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_mst.c                                |  10 +-
 net/bridge/br_private.h                            |  13 +-
 net/core/dev.c                                     |  64 ++-
 net/core/filter.c                                  |   1 +
 net/core/net-sysfs.c                               |   4 +-
 net/core/netpoll.c                                 |   7 +-
 net/core/page_pool.c                               |  12 +-
 net/core/sock.c                                    |  15 +-
 net/dsa/tag_brcm.c                                 |  10 +-
 net/ethernet/eth.c                                 |   5 +-
 net/ipv4/fou_nl.c                                  |   4 +-
 net/ipv4/inet_connection_sock.c                    |  12 +-
 net/ipv4/inet_diag.c                               |  14 +-
 net/ipv4/inet_hashtables.c                         |  44 ++-
 net/ipv4/inet_timewait_sock.c                      |   1 +
 net/ipv4/ip_input.c                                |  11 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  25 ++
 net/ipv4/nexthop.c                                 |   6 +
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_fastopen.c                            |   7 +-
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/ah6.c                                     |  50 ++-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  30 ++
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/cfg.c                                 |  23 +-
 net/mac80211/chan.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |  12 +-
 net/mac80211/iface.c                               |  25 +-
 net/mac80211/key.c                                 |  11 +-
 net/mac80211/link.c                                |   4 +-
 net/mac80211/mesh.c                                |   3 +
 net/mac80211/mlme.c                                |  62 +--
 net/mac80211/status.c                              |  21 +-
 net/mptcp/protocol.c                               |  61 +--
 net/mptcp/protocol.h                               |   2 +-
 net/netfilter/nf_tables_api.c                      |  47 +--
 net/rds/rds.h                                      |   2 +-
 net/sctp/diag.c                                    |  23 +-
 net/wireless/core.c                                |  56 +++
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/scan.c                                |   9 +-
 net/wireless/trace.h                               |  21 +
 rust/Makefile                                      |  15 +-
 rust/kernel/devres.rs                              |   2 +-
 rust/kernel/kunit.rs                               |   7 +
 rust/kernel/sync/condvar.rs                        |   2 +-
 rust/macros/kunit.rs                               |  48 ++-
 scripts/Makefile.vmlinux_o                         |  15 +-
 scripts/kernel-doc.py                              |  34 +-
 security/integrity/ima/ima_appraise.c              |  23 +-
 sound/drivers/serial-generic.c                     |  12 +-
 sound/hda/codecs/realtek/alc269.c                  |  10 +
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |  12 +
 sound/soc/codecs/cs-amp-lib-test.c                 |   1 +
 sound/soc/codecs/es8323.c                          |  17 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |   2 +-
 sound/soc/codecs/rt722-sdca.c                      |  14 +
 sound/soc/codecs/rt722-sdca.h                      |   6 +
 sound/soc/codecs/tas2781-fmwlib.c                  |  12 +
 sound/soc/codecs/tas2781-i2c.c                     |   6 +
 sound/soc/codecs/tlv320aic3x.c                     |  32 +-
 sound/soc/codecs/wsa883x.c                         |  57 ++-
 sound/soc/fsl/fsl_micfil.c                         |   4 +-
 sound/soc/fsl/fsl_sai.c                            |  11 +-
 sound/soc/intel/avs/pcm.c                          |  15 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   2 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   2 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   2 +-
 sound/soc/mediatek/mt8186/mt8186-mt6366.c          |   2 +-
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |   8 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |   2 +-
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c         |   1 -
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   4 +-
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c         |   1 -
 sound/soc/meson/aiu-encoder-i2s.c                  |   9 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   3 +
 sound/soc/renesas/rcar/msiof.c                     |  54 ++-
 sound/soc/renesas/rz-ssi.c                         |  25 +-
 sound/soc/sdw_utils/soc_sdw_utils.c                |   1 -
 sound/soc/soc-ops.c                                |   1 +
 sound/soc/sof/ipc4-pcm.c                           |  56 +++
 sound/soc/stm/stm32_sai_sub.c                      |   8 +
 sound/usb/mixer.c                                  |   7 +
 sound/usb/mixer_s1810c.c                           |  49 ++-
 sound/usb/quirks.c                                 |   3 -
 sound/usb/validate.c                               |   9 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/link.c                           |  54 ++-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/include/linux/bitmap.h                       |   1 +
 tools/lib/bpf/bpf_tracing.h                        |   2 +-
 tools/lib/bpf/usdt.bpf.h                           |  44 ++-
 tools/lib/bpf/usdt.c                               |  62 ++-
 tools/lib/thermal/Makefile                         |   9 +-
 tools/net/ynl/lib/ynl-priv.h                       |  14 +-
 tools/net/ynl/lib/ynl.c                            |   6 +-
 tools/net/ynl/pyynl/ethtool.py                     |   3 +
 tools/net/ynl/pyynl/ynl_gen_c.py                   |   2 +-
 tools/power/cpupower/lib/cpuidle.c                 |   5 +-
 tools/power/cpupower/lib/cpupower.c                |   2 +-
 tools/power/x86/turbostat/turbostat.c              |   2 +-
 .../x86_energy_perf_policy.c                       |  30 +-
 tools/testing/kunit/configs/arch_uml.config        |   5 +-
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/arm64/abi/tpidr2.c         |   6 +-
 tools/testing/selftests/bpf/benchs/bench_sockmap.c |   5 +-
 .../selftests/bpf/prog_tests/arena_spin_lock.c     |  13 +
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |   3 +-
 .../testing/selftests/bpf/progs/arena_spin_lock.c  |   5 +-
 .../selftests/bpf/progs/verifier_arena_large.c     |   1 +
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
 tools/testing/selftests/bpf/test_xsk.sh            |   2 +
 tools/testing/selftests/drivers/net/hds.py         |  39 ++
 tools/testing/selftests/drivers/net/hw/devmem.py   |  14 +-
 tools/testing/selftests/drivers/net/hw/ncdevmem.c  |   4 +
 tools/testing/selftests/drivers/net/hw/rss_ctx.py  |  11 +-
 .../selftests/drivers/net/lib/py/__init__.py       |   2 +-
 tools/testing/selftests/drivers/net/lib/py/env.py  |  41 +-
 .../selftests/drivers/net/netdevsim/Makefile       |   4 +
 tools/testing/selftests/net/fcnal-test.sh          | 432 +++++++++++----------
 .../net/forwarding/custom_multipath_hash.sh        |   2 +-
 .../net/forwarding/gre_custom_multipath_hash.sh    |   2 +-
 .../net/forwarding/ip6_forward_instats_vrf.sh      |   6 +-
 .../net/forwarding/ip6gre_custom_multipath_hash.sh |   2 +-
 tools/testing/selftests/net/forwarding/lib.sh      |   8 +-
 .../net/forwarding/mirror_gre_bridge_1q_lag.sh     |   2 +-
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh    |   4 +-
 tools/testing/selftests/net/gro.c                  |  12 +-
 tools/testing/selftests/net/lib.sh                 |  32 +-
 tools/testing/selftests/net/lib/py/utils.py        |  18 +
 tools/testing/selftests/net/lib/xdp_native.bpf.c   |  98 ++++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/net/netlink-dumps.c        |  43 +-
 tools/testing/selftests/net/psock_tpacket.c        |   4 +-
 tools/testing/selftests/net/tfo_passive.sh         |   2 +-
 tools/testing/selftests/net/traceroute.sh          |  51 +--
 .../selftests/pci_endpoint/pci_endpoint_test.c     |   4 +
 .../intel/workload_hint/workload_hint_test.c       |   2 +
 tools/testing/selftests/ublk/test_generic_01.sh    |   4 +
 tools/testing/selftests/ublk/test_generic_02.sh    |   4 +
 tools/testing/selftests/ublk/test_generic_12.sh    |   4 +
 tools/testing/selftests/ublk/test_null_01.sh       |   4 +
 tools/testing/selftests/ublk/test_null_02.sh       |   4 +
 tools/testing/selftests/ublk/test_stress_05.sh     |   4 +
 tools/testing/selftests/vsock/vmtest.sh            |   8 +-
 usr/include/headers_check.pl                       |   2 +
 933 files changed, 10037 insertions(+), 4513 deletions(-)


