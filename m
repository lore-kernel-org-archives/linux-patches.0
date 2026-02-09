Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E8237A496;
	Mon,  9 Feb 2026 14:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647172; cv=none; b=SiHkmcr+lHLfMrJwo6LFIjREg4iSHPb2wRv4svPvbA2aHjN1t4z3rV8mAz39fvORvwil0sDV9AAFHCe6KyR9VAHklUGaabhVoiGB8ayHmfNgI/X/1p17LqRQnvgaRoABVtzYJdrIAyJOmkxM19nD/E2FM1MVzj8cBx0NF/Zcw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647172; c=relaxed/simple;
	bh=2I821ocIsTWcoskjLjzllF8eJw4+PTDQPAFe26CiPvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WN7odKF82qyx22iw+8fNelkXnRSzQSHsVABTgmSLoen29ZZER5i8mdvw8ULPSQZiy65qreZNjfjvcaAXyhZbSG0oPgm9enmb0kszH+BMMjhH/mB0pHqcsijnC2l3ZbtqLIunaGXULruroTnXHzMWpwr+7kopX0S3rmeixBHrlBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgaABkGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgaABkGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48580C16AAE;
	Mon,  9 Feb 2026 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647172;
	bh=2I821ocIsTWcoskjLjzllF8eJw4+PTDQPAFe26CiPvQ=;
	h=From:To:Cc:Subject:Date:From;
	b=jgaABkGPsJTJ1lGTXBIQ/rdgWR1nubhLPWcc10KBrd2IxWtZLwNL3aXpEjT6xsOpC
	 eAi+19XpbwQsyKNptfU2mDSmFFOFqBLvKkPJJFKTaKbD4QTj9IyvKLCihNGEjijHPl
	 55CSkH7tTCxk9WcSIJSUC662O+cPLDaYb+48rg4s=
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
Subject: [PATCH 6.18 000/175] 6.18.10-rc1 review
Date: Mon,  9 Feb 2026 15:21:13 +0100
Message-ID: <20260209142320.474120190@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.10-rc1
X-KernelTest-Deadline: 2026-02-11T14:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.10 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.10-rc1

Nathan Chancellor <nathan@kernel.org>
    riscv: Add intermediate cast to 'unsigned long' in __get_user_asm

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use the right limit for PCM OOB check

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Really fix headset mic for TongFang X6AR55xU.

Vishwaroop A <va@nvidia.com>
    spi: tegra114: Preserve SPI mode bits in def_command1_reg

Felix Gu <ustc.gu@gmail.com>
    spi: tegra: Fix a memory leak in tegra_slink_probe()

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer check in IRQ handler

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer clearing in tegra_qspi_non_combined_seq_xfer

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer in tegra_qspi_combined_seq_xfer

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer assignment in tegra_qspi_setup_transfer_one

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Move curr_xfer read inside spinlock

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Return IRQ_HANDLED when timeout already processed transfer

Guodong Xu <guodong@riscstar.com>
    regulator: spacemit-p1: Fix n_voltages for BUCK and LDO regulators

LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
    i2c: imx: preserve error state in block data length handler

Chen Ni <nichen@iscas.ac.cn>
    gpio: loongson-64bit: Fix incorrect NULL check after devm_kcalloc()

Chris Bainbridge <chris.bainbridge@gmail.com>
    ASoC: amd: fix memory leak in acp3x pdm dma ops

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    ALSA: usb-audio: fix broken logic in snd_audigy2nx_led_update()

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: rate-limit log messages in KUnit builds

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Factor out common debugfs string read

Shigeru Yoshida <syoshida@redhat.com>
    ipv6: Fix ECMP sibling count mismatch when clearing RTF_ADDRCONF

Keith Busch <kbusch@kernel.org>
    nvme-pci: handle changing device dma map requirements

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/guc: Fix CFI violation in debugfs access.

Andrew Fasano <andrew.fasano@nist.gov>
    netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) Mark occ_init_attribute() as __printf

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/pm: Disable D3Cold for BMG only on specific platforms

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/query: Fix topology query pointer advance

Jacob Keller <jacob.e.keller@intel.com>
    drm/mgag200: fix mgag200_bmc_stop_scanout()

Paolo Abeni <pabeni@redhat.com>
    net: gro: fix outer network offset

Eric Dumazet <edumazet@google.com>
    net: add proper RCU protection to /proc/net/ptype

Chen Ni <nichen@iscas.ac.cn>
    net: ethernet: adi: adin1110: Check return value of devm_gpiod_get_optional() in adin1110_check_spi()

Melissa Wen <mwen@igalia.com>
    drm/amd/display: fix wrong color value mapping on MCM shaper LUT

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: pause TCM on fast resume

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: cancel mlo_scan_start_wk

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: enetc: Convert 16-bit register reads to 32-bit for ENETC v4

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: enetc: Convert 16-bit register writes to 32-bit for ENETC v4

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: enetc: Remove CBDR cacheability AXI settings for ENETC v4

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: enetc: Remove SI/BDR cacheability AXI settings for ENETC v4

Daniel Hodges <hodgesd@meta.com>
    tipc: use kfree_sensitive() for session key material

Jakub Kicinski <kuba@kernel.org>
    net: rss: fix reporting RXH_XFRM_NO_CHANGE as input_xfrm for contexts

Jiayuan Chen <jiayuan.chen@shopee.com>
    linkwatch: use __dev_put() in callers to prevent UAF

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: fix page array leak

Jakub Kicinski <kuba@kernel.org>
    net: don't touch dev->stats in BPF redirect paths

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    hwmon: (acpi_power_meter) Fix deadlocks related to acpi_power_meter_notify()

Sergey Senozhatsky <senozhatsky@chromium.org>
    net: usb: r8152: fix resume reset deadlock

Eric Dumazet <edumazet@google.com>
    macvlan: fix error recovery in macvlan_common_newlink()

Marek Behún <kabel@kernel.org>
    net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module

Mohammad Heib <mheib@redhat.com>
    i40e: drop udp_tunnel_get_rx_info() call from i40e_open()

Mohammad Heib <mheib@redhat.com>
    ice: drop udp_tunnel_get_rx_info() call from ndo_open()

Aaron Ma <aaron.ma@canonical.com>
    ice: Fix PTP NULL pointer dereference during VSI rebuild

Jacob Keller <jacob.e.keller@intel.com>
    ice: PTP: fix missing timestamps on E825 hardware

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix missing TX timestamps interrupts on E825 devices

Junrui Luo <moonafterrain@outlook.com>
    dpaa2-switch: add bounds check for if_id in IRQ handler

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in PF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Initialize netdev pointer before queue setup

Junrui Luo <moonafterrain@outlook.com>
    dpaa2-switch: prevent ZERO_SIZE_PTR dereference when num_ifs is zero

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: use skb_header_pointer_careful()

Eric Dumazet <edumazet@google.com>
    net: add skb_header_pointer_careful() helper

leobannocloutier@gmail.com <leobannocloutier@gmail.com>
    hwmon: (dell-smm) Add Dell G15 5510 to fan control whitelist

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix memory leak in smb2_open_file()

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    platform/x86/intel/tpmi/plr: Make the file domain<n>/status writeable

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Skip empty attribute names

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix PSS event register mask

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: toshiba_haps: Fix memory leaks in add/remove routines

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: pause the workload setting in dm"

Ian Rogers <irogers@google.com>
    tracing: Avoid possible signed 64-bit truncation

Martin Hamilton <m@martinh.net>
    ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Book 9i 13IRU8 audio

Qu Wenruo <wqu@suse.com>
    btrfs: reject new transactions if the fs is fully read-only

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't increment crypto_tx_tailroom_needed_cnt twice

Edward Adam Davis <eadavis@qq.com>
    btrfs: sync read disk super and set block size

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: correctly check if CSA is active

Qiang Ma <maqianga@uniontech.com>
    btrfs: fix Wmaybe-uninitialized warning in replay_one_buffer()

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: free potentially allocated iovec on cache put failure

Nathan Chancellor <nathan@kernel.org>
    riscv: Use 64-bit variable for output in __get_user_asm

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()

Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>
    wifi: cfg80211: Fix bitrate calculation overflow for HE rates

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    spi: intel-pci: Add support for Nova Lake SPI serial flash

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for MOONDROP Moonriver2 Ti

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    regmap: maple: free entry on mas_store_gfp() failure

Devyn Liu <liudingyuan@h-partners.com>
    spi: hisi-kunpeng: Fixed the wrong debugfs node name in hisi_spi debugfs initialization

Shenghao Ding <shenghao-ding@ti.com>
    ALSA: hda/tas2781: Add newly-released HP laptop

Dimitrios Katsaros <patcherwork@gmail.com>
    ASoC: tlv320adcx140: Propagate error codes during probe

Radhi Bajahaw <bajahawradhi@gmail.com>
    ASoC: amd: yc: Fix microphone on ASUS M6500RE

Hannes Reinecke <hare@kernel.org>
    nvmet-tcp: fixup hang in nvmet_tcp_listen_data_ready()

Edward Adam Davis <eadavis@qq.com>
    ALSA: usb-audio: Prevent excessive number of frames

Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
    nvme-fc: release admin tagset if init fails

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: simple-card-utils: Check device node before overwrite direction

Kery Qi <qikeyu2017@gmail.com>
    ASoC: davinci-evm: Fix reference leak in davinci_evm_probe

Guodong Xu <guodong@riscstar.com>
    dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()

Deep Harsora <Deep_Harsora@dell.com>
    ASoC: Intel: sof_sdw: Add new quirks for PTL on Dell with CS42L43

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: mac80211: collect station statistics earlier when disconnect

Arnoud Willemsen <mail@lynthium.com>
    HID: Elecom: Add support for ELECOM M-XT3DRBK (018C)

Dennis Marttinen <twelho@welho.tech>
    HID: logitech: add HID++ support for Logitech MX Anywhere 3S

Martin Kaiser <martin@kaiser.cx>
    riscv: trace: fix snapshot deadlock with sbi ecall

Wupeng Ma <mawupeng1@huawei.com>
    ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free

Perry Yuan <perry.yuan@amd.com>
    drm/amd/pm: Disable MMIO access during SMU Mode 1 reset

Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
    HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-thc: Add safety check for reading DMA buffer

Kwok Kin Ming <kenkinming2002@gmail.com>
    HID: i2c-hid: fix potential buffer overflow in i2c_hid_get_report()

Chris Chiu <chris.chiu@canonical.com>
    HID: quirks: Add another Chicony HP 5MP Cameras to hid_ignore_list

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Reduce number of arguments of dcn30's CalculatePrefetchSchedule()

Daniel Gomez <da.gomez@samsung.com>
    netfilter: replace -EEXIST with -EBUSY

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: qcom: Remove ASPM L0s support for MSM8996 SoC

Ruslan Krupitsa <krupitsarus@outlook.com>
    ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED quirk

Brendan Jackman <jackmanb@google.com>
    x86/sev: Disable GCOV on noinstr object

Matouš Lánský <matouslansky@post.cz>
    ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55

Siarhei Vishniakou <svv@google.com>
    HID: playstation: Center initial joystick axes to prevent spurious events

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Reset enum_devices_done before enumeration

Lukas Gerlach <lukas.gerlach@cispa.de>
    riscv: Sanitize syscall table indexing under speculation

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reservation leak in some error paths when inserting inline extent

DaytonCL <artem749507@gmail.com>
    HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Update ishtp bus match to support device ID table

Filipe Manana <fdmanana@suse.com>
    btrfs: do not free data reservation in fallback from inline due to -ENOSPC

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix refcount leak in parse_durable_handle_context()

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: Enable exception fixup for specific ADE subcode

Alexandre Negrel <alexandre@negrel.dev>
    io_uring: use GFP_NOWAIT for overflow CQEs on legacy rings

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix refcount leak in smb2_open()

FengWei Shih <dannyshih@synology.com>
    md: suspend array while updating raid_disks via sysfs

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Set correct protection_map[] for VM_NONE/VM_SHARED

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()

shechenglong <shechenglong@xfusion.com>
    block,bfq: fix aux stat accumulation destination

Dmytro Bagrii <dimich.dmb@gmail.com>
    platform/x86: dell-lis3lv02d: Add Latitude 5400

Yao Zi <ziyao@disroot.org>
    wifi: iwlwifi: Implement settime64 as stub for MVM/MLD PTP

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: support devices with virtual driver CD

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't WARN for connections on invalid channels

Peter Åstrand <astrand@lysator.liu.se>
    wifi: wlcore: ensure skb headroom before skb_push

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: ocb: skip rx_no_sta when interface is not joined

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix ftrace event field alignments

Carlos Llamas <cmllamas@google.com>
    binderfs: fix ida_alloc_max() upper bound

Carlos Llamas <cmllamas@google.com>
    binder: fix BR_FROZEN_REPLY error log

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF in binder_netlink_report()

Carlos Llamas <cmllamas@google.com>
    rust_binderfs: fix ida_alloc_max() upper bound

Alice Ryhl <aliceryhl@google.com>
    rust_binder: add additional alignment checks

Alice Ryhl <aliceryhl@google.com>
    rust_binder: correctly handle FDA objects of length zero

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Have SD_SERIALIZE affect newidle balancing

Tim Chen <tim.c.chen@linux.intel.com>
    sched/fair: Skip sched_balance_running cmpxchg when balance is not due

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: Add Telit FE990B40 modem support

Lukas Wunner <lukas@wunner.de>
    treewide: Drop pci_save_state() after pci_restore_state()

Lukas Wunner <lukas@wunner.de>
    PCI/ERR: Ensure error recoverability at all times

Gabor Juhos <j4g8y7@gmail.com>
    hwmon: (gpio-fan) Allow to stop FANs when CONFIG_PM is disabled

Gabor Juhos <j4g8y7@gmail.com>
    hwmon: (gpio-fan) Fix set_rpm() return value

Sean Christopherson <seanjc@google.com>
    KVM: Don't clobber irqfd routing type when deassigning irqfd

Zhiquan Li <zhiquan_li@163.com>
    KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures

Tomas Hlavacek <tmshlvck@gmail.com>
    net: spacemit: k1-emac: fix jumbo frame support

Kevin Hao <haokexin@gmail.com>
    net: cpsw_new: Execute ndo_set_rx_mode callback in a work queue

Kevin Hao <haokexin@gmail.com>
    net: cpsw: Execute ndo_set_rx_mode callback in a work queue

Dave Airlie <airlied@redhat.com>
    nouveau/gsp: fix suspend/resume regression on r570 firmware

Dave Airlie <airlied@redhat.com>
    nouveau/gsp: use rpc sequence numbers properly.

Dave Airlie <airlied@redhat.com>
    nouveau: add a third state to the fini handler.

Bert Karwatzki <spasswolf@web.de>
    Revert "drm/amd: Check if ASPM is enabled from PCIe subsystem"

Kairui Song <kasong@tencent.com>
    mm, shmem: prevent infinite loop on truncate race

Max Yuan <maxyuan@google.com>
    gve: Correct ethtool rx_dropped calculation

Debarghya Kundu <debarghyak@google.com>
    gve: Fix stats report corruption on queue count change

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Set minimum version for set_hw_resource_1 on gfx11 to 0x52

Chen Ridong <chenridong@huawei.com>
    cgroup/dmem: avoid pool UAF

Chen Ridong <chenridong@huawei.com>
    cgroup/dmem: avoid rcu warning when unregister region

Chen Ridong <chenridong@huawei.com>
    cgroup/dmem: fix NULL pointer dereference when setting max

Daniel Vogelbacher <daniel@chaospixel.com>
    ceph: fix oops due to invalid pointer for kfree() in parse_longname()

Thomas Weissschuh <thomas.weissschuh@linutronix.de>
    ARM: 9468/1: fix memset64() on big-endian

Ilya Dryomov <idryomov@gmail.com>
    rbd: check for EOD after exclusive lock is ensured to be held

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix NULL pointer dereference in ceph_mds_auth_match()

Hao Ge <hao.ge@linux.dev>
    mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single

Andrii Nakryiko <andrii@kernel.org>
    procfs: avoid fetching build ID while holding VMA lock

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep usb phy power domain on for system wakeup

Jacky Bai <ping.bai@nxp.com>
    pmdomain: imx: gpcv2: Fix the imx8mm gpu hang due to wrong adb400 reset

Xu Yang <xu.yang_2@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep gpc power domain on for system wakeup

Gabor Juhos <j4g8y7@gmail.com>
    pmdomain: qcom: rpmpd: fix off-by-one error in clamping to the highest state

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Fix racy access at PCM trigger

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix swapped arrays in PSS output

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: fix booting on 32bit non-PAE systems

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/vmware: Fix hypercall clobbers

YunJe Shin <yjshin0438@gmail.com>
    nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/string.h                      |   5 +-
 arch/loongarch/kernel/traps.c                      |   5 +
 arch/loongarch/mm/cache.c                          |   8 +-
 arch/riscv/include/asm/uaccess.h                   |  14 +-
 arch/riscv/kernel/Makefile                         |  15 +-
 arch/riscv/kernel/traps.c                          |   4 +-
 arch/x86/coco/sev/Makefile                         |   2 +
 arch/x86/include/asm/kfence.h                      |   7 +-
 arch/x86/include/asm/vmware.h                      |   4 +-
 arch/x86/kvm/svm/svm.c                             |   2 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +
 arch/x86/kvm/x86.c                                 |  30 +--
 arch/x86/kvm/x86.h                                 |   2 +
 block/bfq-cgroup.c                                 |   2 +-
 drivers/android/binder.c                           |  19 +-
 drivers/android/binder/rust_binderfs.c             |   8 +-
 drivers/android/binder/thread.rs                   | 109 +++++----
 drivers/android/binderfs.c                         |   8 +-
 drivers/base/regmap/regcache-maple.c               |  11 +-
 drivers/block/rbd.c                                |  33 ++-
 drivers/bus/mhi/host/pci_generic.c                 |  13 ++
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   2 -
 drivers/dma/ioat/init.c                            |   1 -
 drivers/dma/mmp_pdma.c                             |   6 +
 drivers/firmware/cirrus/cs_dsp.c                   |  82 +++++--
 drivers/firmware/cirrus/cs_dsp.h                   |  18 ++
 drivers/firmware/cirrus/test/cs_dsp_test_bin.c     |  22 +-
 .../firmware/cirrus/test/cs_dsp_test_bin_error.c   |  24 +-
 drivers/firmware/cirrus/test/cs_dsp_test_wmfw.c    |  26 ++-
 .../firmware/cirrus/test/cs_dsp_test_wmfw_error.c  |  24 +-
 drivers/firmware/cirrus/test/cs_dsp_tests.c        |   1 +
 drivers/gpio/gpio-loongson-64bit.c                 |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 -
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  11 -
 .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |   7 +-
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c | 258 ++++++---------------
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   7 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   9 +-
 drivers/gpu/drm/mgag200/mgag200_bmc.c              |  31 +--
 drivers/gpu/drm/mgag200/mgag200_drv.h              |   6 +
 drivers/gpu/drm/nouveau/include/nvif/client.h      |   2 +-
 drivers/gpu/drm/nouveau/include/nvif/driver.h      |   2 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/device.h |   3 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/engine.h |   2 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/object.h |   5 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/oproxy.h |   2 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/subdev.h |   4 +-
 .../drm/nouveau/include/nvkm/core/suspend_state.h  |  11 +
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h  |   6 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_nvif.c             |  10 +-
 drivers/gpu/drm/nouveau/nvif/client.c              |   4 +-
 drivers/gpu/drm/nouveau/nvkm/core/engine.c         |   4 +-
 drivers/gpu/drm/nouveau/nvkm/core/ioctl.c          |   4 +-
 drivers/gpu/drm/nouveau/nvkm/core/object.c         |  20 +-
 drivers/gpu/drm/nouveau/nvkm/core/oproxy.c         |   2 +-
 drivers/gpu/drm/nouveau/nvkm/core/subdev.c         |  18 +-
 drivers/gpu/drm/nouveau/nvkm/core/uevent.c         |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/ce/ga100.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/ce/priv.h      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  22 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/pci.c   |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/priv.h  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/user.c  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/base.c    |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/chan.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/falcon.c       |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/uchan.c   |   6 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/base.c      |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/nv04.c      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/nv10.c      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/nv20.c      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/nv20.h      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/nv40.c      |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/mpeg/nv44.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/sec2/base.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/xtensa.c       |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/devinit/base.c |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c   |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/user.c   |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gpio/base.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/gh100.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h     |   8 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fbsr.c |   2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |   8 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c  |   6 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c |   8 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/base.c |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/therm/base.c   |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/timer/base.c   |   2 +-
 drivers/gpu/drm/xe/xe_guc.c                        |   6 +-
 drivers/gpu/drm/xe/xe_guc.h                        |   2 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  13 +-
 drivers/gpu/drm/xe/xe_query.c                      |   2 +-
 drivers/hid/hid-elecom.c                           |  15 +-
 drivers/hid/hid-ids.h                              |   7 +-
 drivers/hid/hid-logitech-hidpp.c                   |   2 +
 drivers/hid/hid-multitouch.c                       |   1 +
 drivers/hid/hid-playstation.c                      |   5 +
 drivers/hid/hid-quirks.c                           |   5 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   1 +
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |   1 +
 drivers/hid/intel-ish-hid/ishtp/bus.c              |  12 +-
 .../hid/intel-thc-hid/intel-thc/intel-thc-dma.c    |   5 +
 drivers/hwmon/acpi_power_meter.c                   |  17 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   8 +
 drivers/hwmon/gpio-fan.c                           |   6 +-
 drivers/hwmon/occ/common.c                         |   1 +
 drivers/i2c/busses/i2c-imx.c                       |   3 +-
 drivers/md/md.c                                    |   4 +-
 drivers/net/ethernet/adi/adin1110.c                |   3 +
 drivers/net/ethernet/broadcom/bnx2.c               |   2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   1 -
 drivers/net/ethernet/broadcom/tg3.c                |   1 -
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  39 ++--
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |   4 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 -
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  10 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |  11 +-
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c   |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c  |   4 -
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |  17 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  77 +++---
 drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
 drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c   |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 -
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |   6 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 -
 drivers/net/ethernet/intel/ice/ice_main.c          |  28 +--
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 179 ++++++++------
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  18 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igc/igc_main.c          |   2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   1 -
 drivers/net/ethernet/mellanox/mlx4/main.c          |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 -
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   1 -
 drivers/net/ethernet/microchip/lan743x_main.c      |   1 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   4 -
 drivers/net/ethernet/neterion/s2io.c               |   1 -
 drivers/net/ethernet/spacemit/k1_emac.c            |  21 +-
 drivers/net/ethernet/ti/cpsw.c                     |  41 +++-
 drivers/net/ethernet/ti/cpsw_new.c                 |  34 ++-
 drivers/net/ethernet/ti/cpsw_priv.h                |   1 +
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/usb/r8152.c                            |  29 +--
 drivers/net/usb/sr9700.c                           |   5 +
 drivers/net/wireless/intel/iwlwifi/mld/iface.c     |   2 -
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |   2 +
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c       |   7 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c       |   7 +
 drivers/net/wireless/ti/wlcore/tx.c                |   5 +
 drivers/nvme/host/fc.c                             |   2 +
 drivers/nvme/host/pci.c                            |  45 ++--
 drivers/nvme/target/tcp.c                          |  26 ++-
 drivers/pci/bus.c                                  |   3 +
 drivers/pci/controller/dwc/pcie-qcom.c             |   4 +-
 drivers/pci/pci.c                                  |   3 -
 drivers/pci/pcie/portdrv.c                         |   1 -
 drivers/platform/x86/dell/dell-lis3lv02d.c         |   1 +
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |   5 +
 drivers/platform/x86/intel/plr_tpmi.c              |   2 +-
 drivers/platform/x86/intel/telemetry/debugfs.c     |   4 +-
 drivers/platform/x86/intel/telemetry/pltdrv.c      |   2 +-
 drivers/platform/x86/toshiba_haps.c                |   2 +-
 drivers/pmdomain/imx/gpcv2.c                       |   8 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |   2 +-
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |  30 +++
 drivers/pmdomain/qcom/rpmpd.c                      |   2 +-
 drivers/regulator/spacemit-p1.c                    |   6 +-
 drivers/scsi/bfa/bfad.c                            |   1 -
 drivers/scsi/csiostor/csio_init.c                  |   1 -
 drivers/scsi/ipr.c                                 |   1 -
 drivers/scsi/lpfc/lpfc_init.c                      |   6 -
 drivers/scsi/qla2xxx/qla_os.c                      |   5 -
 drivers/scsi/qla4xxx/ql4_os.c                      |   5 -
 drivers/spi/spi-hisi-kunpeng.c                     |   4 +-
 drivers/spi/spi-intel-pci.c                        |   1 +
 drivers/spi/spi-tegra114.c                         |   3 +
 drivers/spi/spi-tegra20-slink.c                    |   6 +-
 drivers/spi/spi-tegra210-quad.c                    |  56 ++++-
 drivers/target/iscsi/iscsi_target_util.c           |  10 +-
 drivers/tty/serial/8250/8250_pci.c                 |   1 -
 drivers/tty/serial/jsm/jsm_driver.c                |   1 -
 fs/btrfs/disk-io.c                                 |  13 ++
 fs/btrfs/fs.h                                      |   8 +
 fs/btrfs/inode.c                                   |  22 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/volumes.c                                 |   2 +
 fs/ceph/crypto.c                                   |   9 +-
 fs/ceph/mds_client.c                               |   5 +-
 fs/ceph/mdsmap.c                                   |  26 ++-
 fs/ceph/mdsmap.h                                   |   1 +
 fs/ceph/super.h                                    |  16 +-
 fs/proc/task_mmu.c                                 |  42 ++--
 fs/smb/client/smb2file.c                           |   1 +
 fs/smb/server/smb2pdu.c                            |   8 +-
 include/linux/buildid.h                            |   3 +
 include/linux/ceph/ceph_fs.h                       |   6 +
 include/linux/firmware/cirrus/cs_dsp.h             |   4 +-
 include/linux/skbuff.h                             |  12 +
 io_uring/io_uring.c                                |   2 +-
 io_uring/rw.c                                      |  15 +-
 io_uring/zcrx.c                                    |   1 +
 kernel/cgroup/dmem.c                               |  70 +++++-
 kernel/sched/fair.c                                |  54 ++---
 kernel/trace/ring_buffer.c                         |   2 +
 kernel/trace/trace.c                               |   8 +-
 kernel/trace/trace.h                               |   7 +-
 kernel/trace/trace_entries.h                       |  32 +--
 kernel/trace/trace_export.c                        |  21 +-
 lib/buildid.c                                      |  42 +++-
 mm/shmem.c                                         |  23 +-
 mm/slub.c                                          |   6 +-
 net/bridge/netfilter/ebtables.c                    |   2 +-
 net/core/filter.c                                  |   8 +-
 net/core/gro.c                                     |   2 +
 net/core/link_watch.c                              |  20 +-
 net/core/net-procfs.c                              |  50 ++--
 net/ethtool/common.c                               |   3 -
 net/ethtool/rss.c                                  |   9 +-
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/key.c                                 |   3 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/ocb.c                                 |   3 +
 net/mac80211/sta_info.c                            |   7 +-
 net/netfilter/nf_log.c                             |   4 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/x_tables.c                           |   2 +-
 net/sched/cls_u32.c                                |  13 +-
 net/tipc/crypto.c                                  |   4 +-
 net/wireless/util.c                                |   8 +-
 sound/drivers/aloop.c                              |  62 ++---
 sound/hda/codecs/realtek/alc269.c                  |  27 ++-
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |   5 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/tlv320adcx140.c                   |   3 +
 sound/soc/generic/simple-card-utils.c              |   4 +-
 sound/soc/intel/boards/sof_sdw.c                   |   8 +
 sound/soc/ti/davinci-evm.c                         |  39 +++-
 sound/usb/mixer_quirks.c                           |   9 +-
 sound/usb/pcm.c                                    |   3 +-
 sound/usb/quirks.c                                 |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 virt/kvm/eventfd.c                                 |  44 ++--
 265 files changed, 1872 insertions(+), 1033 deletions(-)


