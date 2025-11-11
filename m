Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BD12E0412;
	Tue, 11 Nov 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824299; cv=none; b=f/gynOXsx9nh4+D7+Gbh/mHaVLxkBoF0ChQle81LiYJi4U6cpADR1pwYasp2SAgxAvi7cdHHA40iS9owe39VJUlJrhBqJW29KxFp3WAcP/pd2db1rPS0ZPDqm3jucQZ6nxFbhTq2Vj2TJX0lrCfFBHEdH2nDU1XwPE0Bor9t78k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824299; c=relaxed/simple;
	bh=kKjgi3+ZQphSro6xKKSKwWkmUCNQgYZxbh3QmHi42j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qKvn52P1zjpV4nDztDp8t/SsFYBiGAtqikiKVdvgo/3maESjzMQzyq/bR0f5RH2rAS6UN4Zm3o6txcecl/2QNYDN0hvmoRIR22VfX0OtOVcrhWNyy0jC0nehOWYJLwtraflBXiMQooKGrJaprqCcZ1GgApX85r4rZhp6Sb+TdWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fi6fViR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fi6fViR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74617C19421;
	Tue, 11 Nov 2025 01:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824299;
	bh=kKjgi3+ZQphSro6xKKSKwWkmUCNQgYZxbh3QmHi42j8=;
	h=From:To:Cc:Subject:Date:From;
	b=Fi6fViR4DZN5fBMsTy86vFljYUFXaAXGIP+yYTkNWSIU+E/hYDNmEOrhKQ+5whyCX
	 bHiKypdjtRw5lJ8FE12qhZrcFOC7ALLOp4LLQjtS/gZTFu1lTV01JG0W0W1cezWiZd
	 iPV5SoJcxBBO8rwaUIJ2vG9qiHtzXVAEd/Ruw8xw=
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
Subject: [PATCH 6.12 000/562] 6.12.58-rc2 review
Date: Tue, 11 Nov 2025 10:24:49 +0900
Message-ID: <20251111012348.571643096@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.58-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.58-rc2
X-KernelTest-Deadline: 2025-11-13T01:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.58 release.
There are 562 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.58-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.58-rc2

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix black screen with HDMI outputs

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix function header names in amdgpu_connectors.c

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu: Fix unintended error log in VCN5_0_0

Punit Agrawal <punit.agrawal@oss.qualcomm.com>
    ACPI: SPCR: Check for table version when using precise baudrate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Cleanup wakeup source only if it was enabled

Melissa Wen <mwen@igalia.com>
    drm/amd/display: update color on atomic commit time

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Add a quirk to suppress link_startup_again

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Nathan Chancellor <nathan@kernel.org>
    lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: fix received length check in big packets

Rong Zhang <i@rong.moe>
    drm/amd/display: Fix NULL deref in debugfs odm_combine_segments

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: Handle S0ix for vangogh

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential UAF in smb2_close_cached_fid()

Joshua Rogers <linux@joshua.hu>
    smb: client: validate change notify buffer before copy

Mario Limonciello (AMD) <superm1@kernel.org>
    x86/microcode/AMD: Add more known models to entry sign checking

Yuta Hayama <hayama@lineo.co.jp>
    rtc: rx8025: fix incorrect register reference

Helge Deller <deller@gmx.de>
    parisc: Avoid crash due to unaligned access in unwinder

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Don't overflow during division for dirty tracking

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/sched: Fix deadlock in drm_sched_entity_kill_jobs_cb

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Enable mst when it's detected but yet to be initialized

Zilin Guan <zilin@seu.edu.cn>
    tracing: Fix memory leaks in create_field_var()

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
    net/mlx5e: SHAMPO, Fix skb size check for 64K pages

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix fdb hash size configuration

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix return value in case of module EEPROM read error

Martin Willi <martin@strongswan.org>
    wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup

Hongguang Gao <hongguang.gao@broadcom.com>
    bnxt_en: Add a 'force' parameter to bnxt_free_ctx_mem()

Hongguang Gao <hongguang.gao@broadcom.com>
    bnxt_en: Refactor bnxt_free_ctx_mem()

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Add mem_valid bit to struct bnxt_ctx_mem_type

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix a possible memory leak in bnxt_ptp_init

Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
    net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup

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
    net: dsa: b53: stop reading ARL entries if search is done

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix enabling ip multicast

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix bcm63xx RGMII port link adjustment

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix resetting speed and pause on forced link

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: fix invalid pointer access in debugfs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: swnode: don't use the swnode's name as the key for GPIO lookup

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

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: reorganize functions

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: hci_event: validate skb length for unknown CC opcode

Josephine Pfeiffer <hi@josie.lol>
    riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: stacktrace: Disable KASAN checks for non-current tasks

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix device bus LAN ID

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Do not warn in ring_buffer_map_get_reader() when reader catches up

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

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Audio disappears on HP 15-fc000 after warm boot again

Linus Torvalds <torvalds@linux-foundation.org>
    x86: uaccess: don't use runtime-const rewriting in modules

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/runtime-const: Add the RUNTIME_CONST_PTR assembly macro

Linus Torvalds <torvalds@linux-foundation.org>
    x86: use cmov for user address masking

Kotresh HR <khiremat@redhat.com>
    ceph: fix multifs mds auth caps issue

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: refactor wake_up_bit() pattern of calling

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix potential race condition in ceph_ioctl_lazyio()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: add checking of wait_for_completion_killable() return value

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix mmap write lock not release

Valerio Setti <vsetti@baylibre.com>
    ASoC: meson: aiu-encoder-i2s: fix bit clock polarity

Geert Uytterhoeven <geert@linux-m68k.org>
    kbuild: uapi: Strip comments before size type check

Sammy Hsu <zelda3121@gmail.com>
    net: wwan: t7xx: add support for HP DRMR-H01

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: fix watchdog interrupt mask on pcf2131

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

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: save and restore ACR during PLL disable/enable

Josua Mayer <josua@solid-run.com>
    rtc: pcf2127: clear minute/second interrupt

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun6i-rtc: Add A523 specifics

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix help message for ssl-non-raw

Yikang Yue <yikangy2@illinois.edu>
    fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink

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

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Set irdma_cq cq_num field during CQ create

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Remove unused struct irdma_cq fields

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix SD index calculation

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update dsmethod.c to get rid of unused variable warning

Mario Limonciello <Mario.Limonciello@amd.com>
    drm/amd/display: Add fallback path for YCBCR422

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    char: misc: restrict the dynamic range to exclude reserved minors

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci-pci: Fix USB2-only root hub registration

Coiby Xu <coxu@redhat.com>
    ima: don't clear IMA_DIGSIG flag when setting or removing non-IMA xattr

Fiona Ebner <f.ebner@proxmox.com>
    smb: client: transport: avoid reconnects triggered by pending task work

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use sock_create_kern interface to create kernel socket

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

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: add mono main switch to Presonus S1824c

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: bcsp: receive data only if registered

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3633 for MT7922

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_conn_free

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: avoid dealing with endianness in macb_set_hwaddr()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Don't query FEC statistics when FEC is disabled

Timothy Pearson <tpearson@raptorengineering.com>
    vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices

Sunil V L <sunilvl@ventanamicro.com>
    ACPI: scan: Update honor list for RPMI System MSI

Primoz Fiser <primoz.fiser@norik.com>
    ASoC: tlv320aic3x: Fix class-D initialization for tlv320aic3007

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: sai: manage context in set_sysclk callback

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: resolve a race in amdgpu_amdkfd_device_fini_sw

Julian Sun <sunjunchao@bytedance.com>
    ext4: increase IO priority of fastcommit

chuguangqing <chuguangqing@inspur.com>
    fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock

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

Karthi Kandasamy <karthi.kandasamy@amd.com>
    drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream

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

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - clear all VF configurations in the hardware

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - invalidate queues in use

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

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    jfs: fix uninitialized waitqueue in transaction manager

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jfs: Verify inode mode when loading from disk

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

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: i2c-hid: Resolve touchpad issues on Dell systems during S4

Stefan Wahren <wahrenst@gmx.net>
    ethernet: Extend device_get_mac_address() to use NVMEM

Jakub Kicinski <kuba@kernel.org>
    page_pool: always add GFP_NOWARN for ATOMIC allocations

Xi Ruoyao <xry111@xry111.site>
    drm/amd/display/dml2: Guard dml21_map_dc_state_into_dml_display_cfg with DC_FP_START

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable VRR on DCE 6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DVI-D/HDMI adapters

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Avoid evicting resources at S5

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: fix dml ms order of operations

Mario Limonciello <Mario.Limonciello@amd.com>
    drm/amd/display: Set up pixel encoding for YCBCR422

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix memory leak on mt7996_mcu_sta_key_tlv error

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: serial-generic: remove shared static buffer

Rosen Penev <rosenp@gmail.com>
    wifi: mt76: mt76_eeprom_override to int

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: Temporarily disable EPCS

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device

Yafang Shao <laoar.shao@gmail.com>
    net/cls_cgroup: Fix task_get_classid() during qdisc run

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

Stanislav Fomichev <sdf@fomichev.me>
    net: devmem: expose tcp_recvmsg_locked errors

David Ahern <dsahern@kernel.org>
    selftests: Replace sleep with slowwait

Daniel Palmer <daniel@thingy.jp>
    eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP

David Ahern <dsahern@kernel.org>
    selftests: Disable dad for ipv6 in fcnal-test.sh

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

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix HE capabilities element check

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ntfs3: pretend $Extend records as regular files

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

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on resume failure

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: allow more time to send ADD_ADDR

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong layout information on 16KB page

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer

Hao Yao <hao.yao@intel.com>
    media: ov08x40: Fix the horizontal flip control

Nidhish A N <nidhish.a.n@intel.com>
    wifi: iwlwifi: fw: Add ASUS to PPAG and TAS list

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: endpoint: pci-epf-test: Limit PCIe BAR size for fixed BARs

Xion Wang <xion.wang@mediatek.com>
    char: Use list_del_init() in misc_deregister() to reinitialize list pointer

Antonino Maniscalco <antomani103@gmail.com>
    drm/msm: make sure to not queue up recovery more than once

Zizhi Wo <wozizhi@huaweicloud.com>
    tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget

William Wu <william.wu@rock-chips.com>
    usb: gadget: f_hid: Fix zero length packet transfer

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: support phy-mode = "10g-qxgmii"

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix pbn_div Calculation Error

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish gpu_info

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't enable SMU on cyan skillfish

Alex Deucher <alexander.deucher@amd.com>
    drm/amd: add more cyan skillfish PCI ids

Hector Martin <marcan@marcan.st>
    iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp: Skip SEV and SNP INIT for kdump boot

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Skip enabling command/event buffers for kdump

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

Antheas Kapenekakis <lkml@antheas.dev>
    drm: panel-backlight-quirks: Make EDID match optional

Chia-I Wu <olvaffe@gmail.com>
    drm/panthor: check bo offset alignment in vm bind

Yue Haibing <yuehaibing@huawei.com>
    ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: rss_ctx: make the test pass with few queues

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/xe/guc: Increase GuC crash dump buffer size

David Francis <David.Francis@amd.com>
    drm/amdgpu: Allow kfd CRIU with no buffer objects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy_7nm: Fix missing initial VCO rate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL

Devendra K Verma <devverma@amd.com>
    dmaengine: dw-edma: Set status for callback_result

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: match alloc_wc and free_wc

Thomas Andreatta <thomasandreatta2000@gmail.com>
    dmaengine: sh: setup_xref error handling

Miroslav Lichvar <mlichvar@redhat.com>
    ptp: Limit time setting of PTP clocks

Bharat Uppal <bharat.uppal@samsung.com>
    scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device in reset on suspend

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

Relja Vojvodic <rvojvodi@amd.com>
    drm/amd/display: Increase minimum clock for TMDS 420 with pipe splitting

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Add fixup for channels

Martin Tůma <martin.tuma@digiteqautomotive.com>
    media: pci: mgb4: Fix timings comparison in VIDIOC_S_DV_TIMINGS

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    media: fix uninitialized symbol warnings

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: rss_ctx: fix the queue count check

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Fix warning in partitioned system

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Support HW cursor 180 rot for any number of pipe splits

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix vram allocation failure for a special case

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Correct the counts of nr_banks and nr_errors

Miklos Szeredi <mszeredi@redhat.com>
    fuse: zero initialize inode private data

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fixed_phy: let fixed_phy_unregister free the phy_device

Andrew Davis <afd@ti.com>
    remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Fix wakeup source leaks on device unbind

Francisco Gutierrez <frankramirez@google.com>
    scsi: pm80xx: Fix race condition caused by static variables

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix controller init failure on fault during queue creation

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix I/O failures during controller reset

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: allow directed broadcast routes to use dst hint

Andrew Davis <afd@ti.com>
    rpmsg: char: Export alias for RPMSG ID rpmsg-raw from table

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu6: isys: Set embedded data type correctly for metadata formats

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: limit tx_max_coalesced_frames_irq

Ujwal Kundur <ujwal.kundur@gmail.com>
    rds: Fix endianness annotation for RDS_MPATH_HASH

Eric Dumazet <edumazet@google.com>
    idpf: do not linearize big TSO packets

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
    wifi: rtw89: fix BSSID comparison for non-transmitted BSSID

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: wow: remove notify during WoWLAN net-detect

raub camaioni <raubcameo@gmail.com>
    usb: gadget: f_ncm: Fix MAC assignment NCM ethernet

Haibo Chen <haibo.chen@nxp.com>
    iio: adc: imx93_adc: load calibrated values even calibration failed

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register

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

Ido Schimmel <idosch@nvidia.com>
    bridge: Redirect to backup port when port is administratively down

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Use pci_uevent_ers() in PCI recovery

Niklas Schnelle <schnelle@linux.ibm.com>
    powerpc/eeh: Use result of error_detected() in uevent

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    tty: serial: ip22zilog: Use platform device for probing

Lukas Wunner <lukas@wunner.de>
    thunderbolt: Use is_pciehp instead of is_hotplug_bridge

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ice: Don't use %pK through printk or tracepoints

Tiezhu Yang <yangtiezhu@loongson.cn>
    net: stmmac: Check stmmac_hw_setup() in stmmac_resume()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall

Lukas Wunner <lukas@wunner.de>
    PCI/ERR: Update device error_state already after reset

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR

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

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdkfd: return -ENOTTY for unsupported IOCTLs

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: sdio: use indirect IO for device registers before power-on

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: print just once for unknown C2H events

Wake Liu <wakel@google.com>
    selftests/net: Ensure assert() triggers in psock_tpacket.c

Wake Liu <wakel@google.com>
    selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8

Marcos Del Sol Vives <marcos@orca.pet>
    PCI: Disable MSI on RDC PCI to PCIe bridges

TungYu Lu <tungyu.lu@amd.com>
    drm/amd/display: Wait until OTG enable state is cleared

Danny Wang <Danny.Wang@amd.com>
    drm/amd/display: Reset apply_eamless_boot_optimization when dpms_off

Terry Cheong <htcheong@chromium.org>
    ASoC: mediatek: Use SND_JACK_AVOUT for HDMI/DP jacks

Seyediman Seyedarab <imandevel@gmail.com>
    drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on arcturus

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on aldebaran

Paul Hsieh <Paul.Hsieh@amd.com>
    drm/amd/display: update dpp/disp clock from smu clock table

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: add more cyan skillfish devices

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Skip poison aca bank from UE channel

Meng Li <li.meng@amd.com>
    drm/amd/amdgpu: Release xcp drm memory after unplug

Ce Sun <cesun102@amd.com>
    drm/amdgpu: Avoid rma causes GPU duplicate reset

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Fix oops in xe_gem_fault when running core_hotunplug test.

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Add more GuC load error status codes

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Move setup_stream_attribute

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu: Check vcn sram load return value

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: add range check for RAS bad page address

Clay King <clayking@amd.com>
    drm/amd/display: ensure committing streams is seamless

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix condition for setting timing_adjust_pending

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mfd: intel-lpss: Add Intel Wildcat Lake LPSS PCI IDs

Bastien Curutchet <bastien.curutchet@bootlin.com>
    mfd: core: Increment of_node's refcount before linking it to the platform device

Jens Kehne <jens.kehne@agilent.com>
    mfd: da9063: Split chip variant reading in two bus transactions

Arnd Bergmann <arnd@arndb.de>
    mfd: madera: Work around false-positive -Wininitialized warning

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe-i2c: Add missing MODULE_LICENSE

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe: Remove IRQ domain upon removal

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Prefer driver HWP limits

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Enhance HWP enable

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage

Mykyta Yatsenko <yatsenko@meta.com>
    selftests/bpf: Fix flaky bpf_cookie selftest

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: Fix incorrect size in cpuidle_state_disable()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Remove Dell Precision 490 custom config data

Ben Copeland <ben.copeland@linaro.org>
    hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex

Jiri Olsa <jolsa@kernel.org>
    uprobe: Do not emulate/sstep original instruction when ip is changed

Alistair Francis <alistair.francis@wdc.com>
    nvme: Use non zero KATO for persistent discovery connections

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

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: fix error return value in cpupower_write_sysfs()

Svyatoslav Ryhel <clamor95@gmail.com>
    video: backlight: lp855x_bl: Set correct EPROM start for LP8556

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci-pci: Add support for Intel Wildcat Lake-U I3C

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Do not limit bpf_cgroup_from_id to current's namespace

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

Andreas Kemnade <andreas@kemnade.info>
    hwmon: sy7636a: add alias

Fabien Proriol <fabien.proriol@viavisolutions.com>
    power: supply: sbs-charger: Support multiple devices

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: keembay: release allocated memory in detach path

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

Dennis Beier <nanovim@gmail.com>
    cpufreq/longhaul: handle NULL policy in longhaul_exit

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

Inochi Amaoto <inochiama@gmail.com>
    irqchip/sifive-plic: Respect mask state when setting affinity

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: ohci: move self_id_complete tracepoint after validating register

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf: Don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    soc: ti: pruss: don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    spi: loopback-test: Don't use %pK through printk

Jens Reidel <adrian@mainlining.org>
    soc: qcom: smem: Fix endian-unaware access of num_entries

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: preserve assign_mem() error return value

Ryan Chen <ryan_chen@aspeedtech.com>
    soc: aspeed: socinfo: Add AST27xx silicon IDs

Heiko Carstens <hca@linux.ibm.com>
    s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix race in drm_sched_entity_select_rq()

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Re-group and rename the entity run-queue lock

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Optimise drm_sched_entity_push_job

Owen Gu <guhuinan@xiaomi.com>
    usb: gadget: f_fs: Fix epfile null pointer access after ep enable.

Gregory Price <gourry@gourry.net>
    x86/CPU/AMD: Add RDSEED fix for Zen5

Heijligen, Thomas <thomas.heijligen@secunet.com>
    mfd: kempld: Switch back to earlier ->init() behavior

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Select polling state in some more cases

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Rearrange main loop in menu_select()

Tejun Heo <tj@kernel.org>
    sched_ext: Mark scx_bpf_dsq_move_set_[slice|vtime]() with KF_RCU

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Use platform device for devres-related actions

Joshua Grisham <josh@joshuagrisham.com>
    ACPI: fan: Add fan speed reporting for fans with only _FST

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Fix incorrect return of vblank enable on unconfigured crtc

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check that VPE has reached DPM0 in idle handler

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Clear preserved bits from register output value

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix device use-after-free on unbind

Philipp Stanner <phasta@kernel.org>
    drm/nouveau: Fix race in nouveau_sched_fini()

David Rosca <david.rosca@amd.com>
    drm/sched: avoid killing parent entity on child SIGKILL

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Do not dereference NULL pointer in plane reset

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Do not wake device during a GT reset

Miaoqian Lin <linmq006@gmail.com>
    s390/mm: Fix memory leak in add_marker() when kvrealloc() fails

Alexey Klimov <alexey.klimov@linaro.org>
    regmap: slimbus: fix bus_context pointer in regmap init calls

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix KASAN global-out-of-bounds warning

Damien Le Moal <dlemoal@kernel.org>
    block: make REQ_OP_ZONE_OPEN a write operation

Damien Le Moal <dlemoal@kernel.org>
    block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Use ACPI handle when retrieving _FST

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

Maarten Zanders <maarten@zanders.be>
    ASoC: fsl_sai: Fix sync error in consumer mode

Petr Oros <poros@redhat.com>
    dpll: spec: add missing module-name and clock-id to pin-get reply

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    sfc: fix potential memory leak in efx_mae_process_mport()

Jijie Shao <shaojijie@huawei.com>
    net: hns3: return error code when function fails

Petr Oros <poros@redhat.com>
    tools: ynl: fix string attribute length to include null terminator

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    drm/etnaviv: fix flush sequence logic

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix tracking of periodic advertisement

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix another instance of dst_type handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix BIS connection dst_type handling

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Update hci_conn_hash_lookup_big for Broadcast slave

Cen Zhang <zzzccc427@163.com>
    Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once

Lizhi Xu <lizhi.xu@windriver.com>
    usbnet: Prevents free active kevent

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix powerpc's stack register definition in bpf_tracing.h

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: fix bit order for DSD format

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Disable periods-elapsed work when closing PCM

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Unprepare a stream when XRUN occurs

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: aspeed - fix double free caused by devm

Ondrej Mosnacek <omosnace@redhat.com>
    bpf: Do not audit capability check in do_jit()

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Avoid repeated usage of bpf_prog->aux->stack_depth

Yonghong Song <yonghong.song@linux.dev>
    bpf: Find eligible subprogs for private stack support

Wonkon Kim <wkon.kim@samsung.com>
    scsi: ufs: core: Initialize value of an attribute returned by uic cmd

Noorain Eqbal <nooraineqbal@gmail.com>
    bpf: Sync pending IRQ work before freeing ring buffer

Florian Schmaus <florian.schmaus@codasip.com>
    kunit: test_dev_action: Correctly cast 'priv' pointer to long*

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix key tailroom accounting leak

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't mark keys for inactive links as uploaded

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib-test: Fix missing include of kunit/test-bug.h

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: fix control pipe direction

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix GMU firmware parser

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath11k: avoid bit operation on key flags

Yu Zhang(Yuriy) <quic_yuzha@quicinc.com>
    wifi: ath11k: add support for MU EDCA

Karthik M <quic_karm@quicinc.com>
    wifi: ath12k: free skb during idr cleanup callback

Mark Pearson <mpearson-lenovo@squebb.ca>
    wifi: ath11k: Add missing platform IDs for quirk table

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix memory leak on unsupported WMI command

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Ensure XFD state on signal delivery

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential cfid UAF in smb2_query_info_compound

Farhan Ali <alifm@linux.ibm.com>
    s390/pci: Restore IRQ unconditionally for the zPCI device

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

Johan Hovold <johan@kernel.org>
    Bluetooth: rfcomm: fix modem control handling

Junjie Cao <junjie.cao@intel.com>
    fbdev: bitblit: bound-check glyph index in bit_putcs*

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: drop the multi-buffer XDP packet in zerocopy

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
    NFSD: Fix crash in nfsd4_read_release()


-------------

Diffstat:

 Documentation/netlink/specs/dpll.yaml              |   2 +
 Makefile                                           |   4 +-
 arch/arc/include/asm/bitops.h                      |   2 +
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts    |   5 +-
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts       |   4 +-
 arch/arm/mach-at91/pm_suspend.S                    |   8 +-
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
 arch/riscv/kernel/stacktrace.c                     |  21 +-
 arch/riscv/mm/ptdump.c                             |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   5 +-
 arch/s390/Kconfig                                  |   1 -
 arch/s390/include/asm/pci.h                        |   1 -
 arch/s390/mm/dump_pagetables.c                     |  19 +-
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/s390/pci/pci_irq.c                            |   9 +-
 arch/sparc/include/asm/elf_64.h                    |   1 +
 arch/sparc/include/asm/io_64.h                     |   6 +-
 arch/sparc/include/asm/video.h                     |   2 +
 arch/sparc/kernel/module.c                         |   1 +
 arch/um/drivers/ssl.c                              |   5 +-
 arch/x86/entry/vsyscall/vsyscall_64.c              |  17 +-
 arch/x86/events/intel/ds.c                         |   3 +-
 arch/x86/include/asm/runtime-const.h               |  17 +
 arch/x86/include/asm/uaccess_64.h                  |  22 +-
 arch/x86/include/asm/video.h                       |   2 +
 arch/x86/kernel/cpu/amd.c                          |  35 ++
 arch/x86/kernel/cpu/common.c                       |   6 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +
 arch/x86/kernel/fpu/core.c                         |   3 +
 arch/x86/kernel/kvm.c                              |  20 +-
 arch/x86/lib/getuser.S                             |  12 +-
 arch/x86/net/bpf_jit_comp.c                        |  13 +-
 block/blk-cgroup.c                                 |  23 +-
 drivers/accel/habanalabs/common/memory.c           |   2 +-
 drivers/accel/habanalabs/gaudi/gaudi.c             |  19 +
 drivers/accel/habanalabs/gaudi2/gaudi2.c           |  15 +-
 drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c |   2 +-
 drivers/acpi/acpi_video.c                          |   4 +-
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/button.c                              |   4 +-
 drivers/acpi/device_sysfs.c                        |   2 +-
 drivers/acpi/fan.h                                 |   8 +-
 drivers/acpi/fan_attr.c                            |  39 +-
 drivers/acpi/fan_core.c                            |  61 ++-
 drivers/acpi/fan_hwmon.c                           |  19 +-
 drivers/acpi/prmt.c                                |  19 +-
 drivers/acpi/property.c                            |  24 +-
 drivers/acpi/resource.c                            |   7 +
 drivers/acpi/scan.c                                |   4 +
 drivers/acpi/spcr.c                                |  10 +-
 drivers/acpi/video_detect.c                        |   8 +
 drivers/base/regmap/regmap-slimbus.c               |   6 +-
 drivers/bluetooth/btmtksdio.c                      |  12 +
 drivers/bluetooth/btrtl.c                          |   4 +-
 drivers/bluetooth/btusb.c                          |  19 +
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/bus/mhi/host/internal.h                    |   2 +
 drivers/bus/mhi/host/pm.c                          |   2 +-
 drivers/char/misc.c                                |  40 +-
 drivers/clk/at91/clk-master.c                      |   3 +
 drivers/clk/at91/clk-sam9x60-pll.c                 |  75 ++--
 drivers/clk/at91/sam9x7.c                          |   1 +
 drivers/clk/clk-scmi.c                             |  11 +-
 drivers/clk/qcom/gcc-ipq6018.c                     |  60 +--
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c               |  11 +
 drivers/clk/ti/clk-33xx.c                          |   2 +
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |   2 +-
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
 drivers/dma/dw-edma/dw-edma-core.c                 |  22 ++
 drivers/dma/mv_xor.c                               |   4 +-
 drivers/dma/sh/shdma-base.c                        |  25 +-
 drivers/dma/sh/shdmac.c                            |  17 +-
 drivers/extcon/extcon-adc-jack.c                   |   2 +
 drivers/firewire/ohci.c                            |  12 +-
 drivers/firmware/qcom/qcom_scm.c                   |   2 +-
 drivers/firmware/qcom/qcom_tzmem.c                 |   1 +
 drivers/gpio/gpiolib-swnode.c                      |   2 +-
 drivers/gpio/gpiolib.c                             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c            |  53 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  66 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  77 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c            |  34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/atom.c                  |   4 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |  13 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   9 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  25 ++
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c        |  56 ++-
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h        |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 100 ++++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   3 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |  86 ++--
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  10 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   3 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  13 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |   2 +-
 .../drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |  16 +
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c | 142 ++++++-
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h |   5 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  25 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dc_helper.c         |   5 +
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   3 +
 .../drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c   |   2 +-
 drivers/gpu/drm/amd/display/dc/dm_services.h       |   2 +
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c |  20 +-
 .../drm/amd/display/dc/dml2/display_mode_core.c    |   2 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |   4 +
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |  28 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   1 +
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  73 ++--
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   5 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   2 +
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   5 +
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   3 -
 .../display/dc/link/protocols/link_dp_training.c   |   9 +-
 .../drm/amd/display/dc/optc/dcn401/dcn401_optc.c   |   5 +
 .../display/dc/resource/dcn314/dcn314_resource.c   |   1 +
 .../display/dc/virtual/virtual_stream_encoder.c    |   7 +
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |   5 +
 .../gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c  |   2 +-
 .../drm/amd/pm/powerplay/smumgr/iceland_smumgr.c   |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   8 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  12 +-
 drivers/gpu/drm/bridge/display-connector.c         |   3 +-
 drivers/gpu/drm/drm_gem_atomic_helper.c            |   8 +-
 drivers/gpu/drm/drm_panel_backlight_quirks.c       |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  10 -
 drivers/gpu/drm/mediatek/mtk_plane.c               |  24 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   3 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |  10 +
 drivers/gpu/drm/msm/registers/gen_header.py        |   7 +
 drivers/gpu/drm/nouveau/nouveau_sched.c            |  14 +-
 drivers/gpu/drm/nouveau/nvkm/core/enum.c           |   2 +-
 drivers/gpu/drm/panthor/panthor_gpu.c              |   7 +
 drivers/gpu/drm/panthor/panthor_mmu.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |  25 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 -
 drivers/gpu/drm/scheduler/sched_entity.c           |  73 ++--
 drivers/gpu/drm/scheduler/sched_main.c             |   6 +-
 drivers/gpu/drm/tidss/tidss_crtc.c                 |   7 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |  16 +-
 drivers/gpu/drm/xe/abi/guc_errors_abi.h            |   3 +
 drivers/gpu/drm/xe/xe_bo.c                         |  28 +-
 drivers/gpu/drm/xe/xe_gt.c                         |  19 +-
 drivers/gpu/drm/xe/xe_guc.c                        |  32 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |  10 +
 drivers/gpu/drm/xe/xe_guc_log.h                    |   2 +-
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-ids.h                              |   2 +-
 drivers/hid/hid-universal-pidff.c                  |  20 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   8 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  28 +-
 drivers/hid/i2c-hid/i2c-hid.h                      |   2 +
 drivers/hid/usbhid/hid-pidff.c                     |  42 +-
 drivers/hid/usbhid/hid-pidff.h                     |   2 +-
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |  14 -
 drivers/hwmon/k10temp.c                            |  10 +
 drivers/hwmon/lenovo-ec-sensors.c                  |  34 +-
 drivers/hwmon/sbtsi_temp.c                         |  46 ++-
 drivers/hwmon/sy7636a-hwmon.c                      |   1 +
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c |   3 +
 drivers/iio/adc/imx93_adc.c                        |  18 +-
 drivers/iio/adc/spear_adc.c                        |   9 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  58 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  11 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   4 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 -
 drivers/infiniband/hw/irdma/Kconfig                |   7 +-
 drivers/infiniband/hw/irdma/pble.c                 |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/hw/irdma/verbs.h                |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  21 +-
 drivers/iommu/amd/init.c                           |  28 +-
 drivers/iommu/apple-dart.c                         |   5 +
 drivers/iommu/intel/debugfs.c                      |  10 +-
 drivers/iommu/intel/perf.c                         |  10 +-
 drivers/iommu/intel/perf.h                         |   5 +-
 drivers/iommu/iommufd/iova_bitmap.c                |   5 +-
 drivers/irqchip/irq-gic-v2m.c                      |  13 +-
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
 drivers/media/platform/verisilicon/hantro_drv.c    |   2 +
 drivers/media/platform/verisilicon/hantro_v4l2.c   |   6 +-
 drivers/media/rc/imon.c                            |  61 +--
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/tuners/xc4000.c                      |   8 +-
 drivers/media/tuners/xc5000.c                      |  12 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  15 +-
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/mfd/da9063-i2c.c                           |  27 +-
 drivers/mfd/intel-lpss-pci.c                       |  13 +
 drivers/mfd/kempld-core.c                          |  32 +-
 drivers/mfd/madera-core.c                          |   4 +-
 drivers/mfd/mfd-core.c                             |   1 +
 drivers/mfd/stmpe-i2c.c                            |   1 +
 drivers/mfd/stmpe.c                                |   3 +
 drivers/mmc/host/renesas_sdhi_core.c               |   6 +-
 drivers/mmc/host/sdhci-msm.c                       |  15 +
 drivers/net/dsa/b53/b53_common.c                   |  27 +-
 drivers/net/dsa/b53/b53_regs.h                     |   3 +-
 drivers/net/dsa/dsa_loop.c                         |   9 +-
 drivers/net/dsa/microchip/ksz9477.c                |  98 ++++-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   3 +-
 drivers/net/dsa/microchip/ksz_common.c             |  49 +++
 drivers/net/dsa/microchip/ksz_common.h             |   2 +
 drivers/net/dsa/ocelot/felix.c                     |   4 +
 drivers/net/dsa/ocelot/felix.h                     |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  75 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.c    |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  10 +-
 drivers/net/ethernet/intel/idpf/idpf.h             |   2 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         | 102 ++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        | 129 ++----
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  12 +-
 drivers/net/ethernet/microchip/lan865x/lan865x.c   |   1 +
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |  18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   2 -
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   4 +-
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   8 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   2 +-
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
 drivers/net/mdio/of_mdio.c                         |   1 -
 drivers/net/phy/fixed_phy.c                        |   1 +
 drivers/net/phy/marvell.c                          |  39 +-
 drivers/net/phy/phy.c                              |  13 +
 drivers/net/usb/asix_devices.c                     |  12 +-
 drivers/net/usb/qmi_wwan.c                         |   6 +
 drivers/net/usb/usbnet.c                           |   2 +
 drivers/net/virtio_net.c                           |  36 +-
 drivers/net/wan/framer/pef2256/pef2256.c           |   7 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  40 +-
 drivers/net/wireless/ath/ath11k/core.c             |  54 ++-
 drivers/net/wireless/ath/ath11k/core.h             |   3 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  61 ++-
 drivers/net/wireless/ath/ath11k/wmi.c              |  11 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |  10 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  34 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  28 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |  14 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   4 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +
 drivers/net/wireless/realtek/rtw89/core.c          |  61 ++-
 drivers/net/wireless/realtek/rtw89/core.h          |  12 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   4 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   7 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   7 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |   1 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   7 +-
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   1 +
 drivers/ntb/hw/epf/ntb_hw_epf.c                    | 103 ++---
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fc.c                             |  10 +-
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
 drivers/pci/pcie/err.c                             |   3 +-
 drivers/pci/quirks.c                               |   3 +-
 drivers/phy/cadence/cdns-dphy.c                    |   4 +-
 drivers/phy/renesas/r8a779f0-ether-serdes.c        |  28 ++
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |   5 +-
 drivers/pinctrl/pinctrl-keembay.c                  |   7 +-
 drivers/pinctrl/pinctrl-single.c                   |   4 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   2 +-
 drivers/pmdomain/apple/pmgr-pwrstate.c             |   1 +
 drivers/power/supply/qcom_battmgr.c                |   8 +-
 drivers/power/supply/sbs-charger.c                 |  16 +-
 drivers/ptp/ptp_clock.c                            |  13 +-
 drivers/pwm/pwm-pca9685.c                          |  46 ++-
 drivers/remoteproc/qcom_q6v5.c                     |   5 +
 drivers/remoteproc/wkup_m3_rproc.c                 |   6 +-
 drivers/rpmsg/rpmsg_char.c                         |   3 +-
 drivers/rtc/rtc-pcf2127.c                          |  19 +-
 drivers/rtc/rtc-rx8025.c                           |   2 +-
 drivers/scsi/libfc/fc_encode.h                     |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |  21 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   7 -
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  23 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   3 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  13 +
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   3 +
 drivers/scsi/pm8001/pm8001_ctl.c                   |  24 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   1 +
 drivers/scsi/pm8001/pm8001_sas.h                   |   4 +
 drivers/scsi/qla2xxx/qla_os.c                      |   5 -
 drivers/soc/aspeed/aspeed-socinfo.c                |   4 +
 drivers/soc/qcom/smem.c                            |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra30.c              | 122 ++++++
 drivers/soc/ti/pruss.c                             |   2 +-
 drivers/spi/spi-loopback-test.c                    |  12 +-
 drivers/spi/spi-rpc-if.c                           |   2 +
 drivers/tee/tee_core.c                             |   2 +-
 drivers/thermal/gov_step_wise.c                    |  15 +-
 drivers/thunderbolt/tb.c                           |   2 +-
 drivers/tty/serial/ip22zilog.c                     | 360 +++++++----------
 drivers/tty/serial/max3100.c                       |   2 +-
 drivers/tty/serial/max310x.c                       |   3 +-
 drivers/tty/vt/vt_ioctl.c                          |   4 +-
 drivers/ufs/core/ufshcd.c                          |  16 +-
 drivers/ufs/host/ufs-exynos.c                      |   8 +
 drivers/ufs/host/ufs-mediatek.c                    | 222 ++++++++---
 drivers/ufs/host/ufshcd-pci.c                      |  70 +++-
 drivers/usb/cdns3/cdnsp-gadget.c                   |   8 +-
 drivers/usb/gadget/function/f_fs.c                 |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   3 +-
 drivers/usb/host/xhci-pci.c                        |  45 ++-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/mon/mon_bin.c                          |  14 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   7 +
 drivers/vfio/vfio_main.c                           |   2 +-
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/fbdev/aty/atyfb_base.c               |   8 +-
 drivers/video/fbdev/core/bitblit.c                 |  33 +-
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
 fs/exfat/balloc.c                                  |  72 +++-
 fs/exfat/fatent.c                                  |  11 +-
 fs/ext4/fast_commit.c                              |   2 +-
 fs/ext4/xattr.c                                    |   2 +-
 fs/f2fs/extent_cache.c                             |   6 +
 fs/f2fs/node.c                                     |  17 +-
 fs/f2fs/sysfs.c                                    |   9 +-
 fs/fuse/inode.c                                    |  11 +-
 fs/hpfs/namei.c                                    |  18 +-
 fs/jfs/inode.c                                     |   8 +-
 fs/jfs/jfs_txnmgr.c                                |   9 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfs/nfs4state.c                                 |   3 +
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/ntfs3/inode.c                                   |   1 +
 fs/open.c                                          |  10 +-
 fs/orangefs/xattr.c                                |  12 +-
 fs/smb/client/cached_dir.c                         |  16 +-
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/smb/client/smb2pdu.c                            |   7 +-
 fs/smb/client/transport.c                          |  10 +-
 fs/smb/server/transport_tcp.c                      |   7 +-
 include/drm/gpu_scheduler.h                        |  23 +-
 include/linux/blk_types.h                          |  11 +-
 include/linux/bpf_verifier.h                       |   7 +
 include/linux/cgroup.h                             |   1 +
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/fbcon.h                              |   2 +
 include/linux/filter.h                             |   3 +-
 include/linux/pci.h                                |   2 +-
 include/linux/shdma-base.h                         |   2 +-
 include/linux/tnum.h                               |   3 +
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |  13 +-
 include/net/bluetooth/mgmt.h                       |   2 +-
 include/net/cls_cgroup.h                           |   2 +-
 include/net/nfc/nci_core.h                         |   2 +-
 include/net/xdp.h                                  |   5 +
 include/ufs/ufs_quirks.h                           |   3 +
 include/ufs/ufshcd.h                               |   8 +
 include/ufs/ufshci.h                               |   4 +-
 io_uring/notif.c                                   |   5 +
 kernel/bpf/core.c                                  |   5 +
 kernel/bpf/helpers.c                               |   2 +-
 kernel/bpf/ringbuf.c                               |   2 +
 kernel/bpf/tnum.c                                  |   8 +
 kernel/bpf/verifier.c                              | 100 ++++-
 kernel/cgroup/cgroup.c                             |  24 +-
 kernel/events/uprobes.c                            |   7 +
 kernel/futex/syscalls.c                            | 106 ++---
 kernel/sched/ext.c                                 |   8 +-
 kernel/trace/ftrace.c                              |   2 +
 kernel/trace/ring_buffer.c                         |   4 +
 kernel/trace/trace_events_hist.c                   |   6 +-
 lib/crypto/Makefile                                |   2 +-
 lib/kunit/kunit-test.c                             |   2 +-
 net/8021q/vlan.c                                   |   2 +
 net/9p/trans_fd.c                                  |   9 +-
 net/bluetooth/hci_event.c                          |  19 +-
 net/bluetooth/hci_sync.c                           |  23 +-
 net/bluetooth/iso.c                                |  11 +-
 net/bluetooth/mgmt.c                               |   6 +-
 net/bluetooth/rfcomm/tty.c                         |  26 +-
 net/bluetooth/sco.c                                |   7 +
 net/bridge/br.c                                    |   5 +
 net/bridge/br_forward.c                            |   5 +-
 net/bridge/br_if.c                                 |   1 +
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_mst.c                                |  10 +-
 net/bridge/br_private.h                            |  13 +-
 net/core/filter.c                                  |   1 +
 net/core/page_pool.c                               |  12 +-
 net/core/sock.c                                    |  15 +-
 net/dsa/tag_brcm.c                                 |  70 ++--
 net/ethernet/eth.c                                 |   5 +-
 net/ipv4/inet_diag.c                               |  14 +-
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
 net/mac80211/cfg.c                                 |  20 +-
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/iface.c                               |   9 +
 net/mac80211/key.c                                 |  10 +-
 net/mac80211/mesh.c                                |   3 +
 net/mac80211/mlme.c                                |   5 +-
 net/mptcp/protocol.c                               |  18 +-
 net/mptcp/protocol.h                               |   2 +-
 net/rds/rds.h                                      |   2 +-
 net/sctp/diag.c                                    |  23 +-
 security/integrity/ima/ima_appraise.c              |  23 +-
 sound/drivers/serial-generic.c                     |  12 +-
 sound/pci/hda/patch_realtek.c                      |  17 +-
 sound/soc/codecs/cs-amp-lib-test.c                 |   1 +
 sound/soc/codecs/tlv320aic3x.c                     |  32 +-
 sound/soc/fsl/fsl_sai.c                            |  11 +-
 sound/soc/intel/avs/pcm.c                          |   3 +
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   2 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   2 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   2 +-
 sound/soc/mediatek/mt8186/mt8186-mt6366.c          |   2 +-
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |   8 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |   2 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   4 +-
 sound/soc/meson/aiu-encoder-i2s.c                  |   9 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   3 +
 sound/soc/sof/ipc4-pcm.c                           |  56 +++
 sound/soc/stm/stm32_sai_sub.c                      |   8 +
 sound/usb/mixer.c                                  |   7 +
 sound/usb/mixer_s1810c.c                           |  28 +-
 sound/usb/validate.c                               |   9 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/link.c                           |  54 ++-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/include/linux/bitmap.h                       |   1 +
 tools/lib/bpf/bpf_tracing.h                        |   2 +-
 tools/lib/bpf/usdt.bpf.h                           |  44 ++-
 tools/lib/bpf/usdt.c                               |  62 ++-
 tools/lib/thermal/Makefile                         |   9 +-
 tools/net/ynl/lib/ynl-priv.h                       |   4 +-
 tools/power/cpupower/lib/cpuidle.c                 |   5 +-
 tools/power/cpupower/lib/cpupower.c                |   2 +-
 .../x86_energy_perf_policy.c                       |  30 +-
 tools/testing/selftests/Makefile                   |   2 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |   3 +-
 .../selftests/bpf/progs/verifier_arena_large.c     |   1 +
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
 tools/testing/selftests/bpf/test_xsk.sh            |   2 +
 tools/testing/selftests/drivers/net/hw/rss_ctx.py  |  11 +-
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
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/net/psock_tpacket.c        |   4 +-
 tools/testing/selftests/net/traceroute.sh          |  51 +--
 .../intel/workload_hint/workload_hint_test.c       |   2 +
 usr/include/headers_check.pl                       |   2 +
 613 files changed, 5918 insertions(+), 2723 deletions(-)


