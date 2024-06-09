Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C13B796;
	Sun,  9 Jun 2024 11:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717933282; cv=none; b=O8FU5nfRalrD0tTzqUEWaL72A065xy7XC1/l6N61a5o9m0nN9kDvARhtfEngpbQgI17DHU9WCEGegu5Ffj3AS6Gc8hwGPb7E6HRGmIW60CFmGeuozirD7/AjJDWF0hhwkmWiFtPORBmj9yvvT63kaxNSCq+6qTfzxZ8jQ2ybM+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717933282; c=relaxed/simple;
	bh=Iy15L56nfSG6S2lWhpbGIjwxqcXjzXFqun+Nh0L7JZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rezMyGurTeYQ971Scg2mIB/PiOBmX3AU7ds7knyNdhb2sVbrE7MNEAx2zDJ+DzADuQCAXK3DcqIDtx/G3wnZmXgetudXpRBPw59C2dizSvEnmmReotoCJtQJtPGk0juZL1IrJ4Epei6ro9eF6ttY5TTofFLaQpY+bB2jLLP7E6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StcDtjnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StcDtjnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52357C2BD10;
	Sun,  9 Jun 2024 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717933281;
	bh=Iy15L56nfSG6S2lWhpbGIjwxqcXjzXFqun+Nh0L7JZs=;
	h=From:To:Cc:Subject:Date:From;
	b=StcDtjnqEiMwsA1r45YnPRR7rAFHXjIUL313chwwIBtkMj1l3Au82f3TuIAB9laUM
	 WICZZMSgaGZt5xG632RbWWGAlvJZkV23vpejjqZZgZAMm4UIVuCI+tCG2l+wDJ/Uyy
	 5R7e9jPfd7Dv4jwi7POj8ksbSqv2AZpZJQV1Vxeo=
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
Subject: [PATCH 6.6 000/741] 6.6.33-rc2 review
Date: Sun,  9 Jun 2024 13:41:16 +0200
Message-ID: <20240609113903.732882729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.33-rc2
X-KernelTest-Deadline: 2024-06-11T11:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.33 release.
There are 741 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.33-rc2

Chao Yu <chao@kernel.org>
    f2fs: use f2fs_{err,info}_ratelimited() for cleanup

Daeho Jeong <daehojeong@google.com>
    f2fs: write missing last sum blk of file pinning section

Yang Jihong <yangjihong@bytedance.com>
    perf sched timehist: Fix -g/--call-graph option failure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make error messages at dpu_core_irq_register_callback() more sensible

Samuel Holland <samuel.holland@sifive.com>
    riscv: Save/restore envcfg CSR during CPU suspend

Samuel Holland <samuel.holland@sifive.com>
    riscv: Fix enabling cbo.zero when running in M-mode

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: vsp1: Remove unbalanced .s_stream(0) calls

Dave Airlie <airlied@redhat.com>
    nouveau: report byte usage in VRAM usage.

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the sparse warnings

Yang Jihong <yangjihong1@huawei.com>
    perf evlist: Add perf_evlist__go_system_wide() helper

James Clark <james.clark@arm.com>
    perf util: Add a function for replacing characters in a string

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Don't present root domain on error

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel/tpmi: Handle error from tpmi_process_info()

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline

Gerd Hoffmann <kraxel@redhat.com>
    KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID

Bjorn Helgaas <bhelgaas@google.com>
    x86/pci: Skip early E820 check for ECAM region

Hagar Hemdan <hagarhem@amazon.com>
    efi: libstub: only free priv.runtime_map when allocated

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Omit physical KASLR when memory reservations exist

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Set lower bound of start tick time

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix swapped song position pointer data

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: prevent pt_regs corruption for secondary idle threads

Guenter Roeck <linux@roeck-us.net>
    hwmon: (shtc1) Fix property misspelling

Peter Colberg <peter.colberg@intel.com>
    hwmon: (intel-m10-bmc-hwmon) Fix multiplier for N6000 board power sensor

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: fix display size for jt240mhqs_hwt_ek_e3 panel

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: tweak timing for jt240mhqs_hwt_ek_e3 panel

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: fix timing for jt240mhqs_hwt_ek_e3 panel

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: drop error message from guest name lookup

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix yet another spot for system message conversion

Yue Haibing <yuehaibing@huawei.com>
    ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound

Shay Agroskin <shayagr@amazon.com>
    net: ena: Fix redundant device NUMA node override

David Arinzon <darinzon@amazon.com>
    net: ena: Reduce lines with longer column width boundary

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix RGMII error in KSZ DSA driver

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: stm32: Don't warn about spurious interrupts

Miguel Ojeda <ojeda@kernel.org>
    kheaders: use `command -v` to test for existence of `cpio`

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gt: Fix CCS id's calculation for CCS mode setting

Arnd Bergmann <arnd@arndb.de>
    drm/i915/guc: avoid FIELD_PREP warning

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix comparison to constant symbols, 'm', 'n'

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: extend minimum interval restriction to entire cycle too

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: make q->picos_per_byte available to fill_sched_entry()

Eric Garver <eric@garver.life>
    netfilter: nft_fib: allow from forward/input without iif selector

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: bail out if IP has been disabled on the device

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: skbuff vlan metadata mangle support

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix start counter for ft1 filter

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Don't clear bank selection at event -> UMP MIDI2 conversion

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing bank setup between MIDI1/MIDI2 UMP conversion

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'fail' tests as flaky

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: add ms units for tc-netem delay

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: simult flows: mark 'unbalanced' tests as flaky

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix accounting if a VLAN already exists

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: micrel: Fix lan8841_config_intr after getting out of sleep mode

Xiaolei Wang <xiaolei.wang@windriver.com>
    net:fec: Add fec_enet_deinit()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Allow delete from sockmap/sockhash only if update is allowed

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Only restrict 44.1kHz for the ASP

Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
    net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-pf: Free send queue buffers incase of leaf to inner

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Read sk->sk_hash under bindlock during bind().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race around unix_sk(sk)->addr.

Roded Zats <rzats@paloaltonetworks.com>
    enic: Validate length of nl attributes in enic_set_vf_port

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Remove debugfs at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Use guard() for locking

Friedrich Vock <friedrich.vock@gmx.de>
    bpf: Fix potential integer overflow in resolve_btfids

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    dma-buf/sw-sync: don't enable IRQ from sync_print_obj()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix UDP GSO for encapsulated packets

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5e: Fix IPsec tunnel mode offload feature check

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Use mlx5_ipsec_rx_status_destroy to correctly delete status rules

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix MTMP register capability offset in MCAM register

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Lag, do bond only if slaves agree on roce state

Mathieu Othacehe <othacehe@gnu.org>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Enable colorspace property for MST connectors

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix ns enable/disable possible hang

Keith Busch <kbusch@kernel.org>
    nvme-multipath: fix io accounting on failover

Hannes Reinecke <hare@suse.de>
    nvme-tcp: add definitions for TLS cipher suites

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: handle NUMA_NO_NODE correctly

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: fix node id validation

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: fix up kthread-related error handling

Andreas Gruenbacher <agruenba@redhat.com>
    kthread: add kthread_stop_put

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Don't mark message DMA mapped when no transfer in it is

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: restore vlan q-in-q match support

Alexander Maltsev <keltar.gw@gmail.com>
    netfilter: ipset: Add list flush to cancel_gc

Eric Dumazet <edumazet@google.com>
    netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Matthew R. Ochs <mochs@nvidia.com>
    tpm_tis_spi: Account for SPI header when allocating TPM SPI xfer buffer

Carlos López <clopez@suse.de>
    tracing/probes: fix error check in parse_btf_field()

Andrey Konovalov <andreyknvl@gmail.com>
    kasan, fortify: properly rename memintrinsics

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: Interpret .set_channels() input differently

Henry Wang <xin.wang2@amd.com>
    drivers/xen: Improve the late XenStore init protocol

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()

Paolo Abeni <pabeni@redhat.com>
    net: relax socket state check at accept time.

Dae R. Jeong <threeearcat@gmail.com>
    tls: fix missing memory barrier in tls_init

Wei Fang <wei.fang@nxp.com>
    net: fec: avoid lock evasion when reading pps_enable

Jacob Keller <jacob.e.keller@intel.com>
    Revert "ixgbe: Manual AN-37 for troublesome link partners for X550 SFI"

Matthew Bystrin <dev.mbstr@gmail.com>
    riscv: stacktrace: fixed walk_stackframe()

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: return actual transfer data len

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: rename read_len as actual_len

Frank Li <Frank.Li@nxp.com>
    i3c: add actual_len in i3c_priv_xfer

Charlie Jenkins <charlie@rivosinc.com>
    riscv: cpufeature: Fix thead vector hwcap removal

Jiri Pirko <jiri@resnulli.us>
    virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Remove ptp traps in case the ptp is not enabled.

Yang Li <yang.lee@linux.alibaba.com>
    rv: Update rv_en(dis)able_monitor doc to match kernel-doc

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    arm64: asm-bug: Add .align 2 to the end of __BUG_ENTRY

Aaron Conole <aconole@redhat.com>
    openvswitch: Set the skbuff pkt_type for proper pmtud support.

Olga Kornievskaia <kolga@netapp.com>
    pNFS/filelayout: fixup pNfs allocation modes

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix shift-out-of-bounds in dctcp_update_alpha().

Neha Malcom Francis <n-francis@ti.com>
    regulator: tps6594-regulator: Correct multi-phase configuration

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix memleak in seg6_hmac_init_algo

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Update unix_sk(sk)->oob_skb under sk_receive_queue lock.

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: tps6287x: Force writing VSEL bit

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: pickable ranges: don't always cache vsel

Dan Aloni <dan.aloni@vastdata.com>
    rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL

Dan Aloni <dan.aloni@vastdata.com>
    sunrpc: fix NFSACL RPC retry on soft mount

Martin Kaiser <martin@kaiser.cx>
    nfs: keep server info for remounts

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Fixup smatch warning for ambiguous return

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix wrong loading calibrated data sequence

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2552: Add TX path for capturing AUDIO-OUT data

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix uninit-value in nci_rx_work

Taehee Yoo <ap420073@gmail.com>
    selftests: net: kill smcrouted in the cleanup logic in amt.sh

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: sr: fix missing sk_buff release in seg6_input_core

Florian Fainelli <florian.fainelli@broadcom.com>
    net: Always descend into dsa/ folder with CONFIG_NET_DSA enabled

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y

Namhyung Kim <namhyung@kernel.org>
    perf/arm-dmc620: Fix lockdep assert in ->event_init()

Roger Pau Monne <roger.pau@citrix.com>
    xen/x86: add extra pages to unpopulated-alloc if available

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: bd71828: Don't overwrite runtime voltages

Waiman Long <longman@redhat.com>
    blk-cgroup: Properly propagate the iostat update up the hierarchy

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: fix list corruption from reorder of WRITE ->lqueued

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: fix list corruption from resetting io stat

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau: use tile_mode and pte_kind for VM_BIND bo allocations

Dave Airlie <airlied@redhat.com>
    nouveau: add an ioctl to report vram usage

Dave Airlie <airlied@redhat.com>
    nouveau: add an ioctl to return vram bar size.

Hsin-Te Yuan <yuanhsinte@chromium.org>
    ASoC: mediatek: mt8192: fix register configuration for tdm

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix lifetime of cs_dsp instance

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Initialize all ASP1 registers

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix to ensure ASP1 registers match cache

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cs_dsp_ctl: Use private_free for control cleanup

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix a warning reported by robot kernel test

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails

Benjamin Gray <bgray@linux.ibm.com>
    selftests/powerpc/dexcr: Add -no-pie to hashchk tests

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_dpsub: Always register bridge

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "drm/bridge: ti-sn65dsi83: Fix enable error path"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid confusing "transmit timed out" message

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid recursive cec_claim_log_addrs

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-api: add locking in cec_release()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-adap: always cancel work in cec_transmit_msg_fh

Randy Dunlap <rdunlap@infradead.org>
    media: sunxi: a83-mips-csi2: also select GENERIC_PHY

Li Zhijian <lizhijian@fujitsu.com>
    cxl/region: Fix cxlr_pmem leaks

Alison Schofield <alison.schofield@intel.com>
    cxl/trace: Correct DPA field masks for general_media & dram events

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the declaration of kasan_map_memory

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for get_thread_reg

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for __switch_mm

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp

Dongliang Mu <mudongliangabcd@gmail.com>
    media: flexcop-usb: fix sanity check of bNumEndpoints

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Take hotkey_mutex during hotkey_exit()

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix meter_certificate decoding

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix meter_show display

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix maximum meter bundle length

Eugen Hristev <eugen.hristev@collabora.com>
    media: mediatek: vcodec: fix possible unbalanced PM counter

Irui Wang <irui.wang@mediatek.com>
    media: mediatek: vcodec: add encoder power management helper functions

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix buffer size in gfx_v9_4_3_init_ cp_compute_microcode() and rlc_microcode()

Le Ma <le.ma@amd.com>
    drm/amdgpu: init microcode chip name from ip versions

Marek Szyprowski <m.szyprowski@samsung.com>
    Input: cyapa - add missing input core locking to suspend/resume functions

Dan Carpenter <dan.carpenter@linaro.org>
    media: stk1160: fix bounds checking in stk1160_copy_video()

Michael Walle <mwalle@kernel.org>
    drm/bridge: tc358775: fix support for jeida-18 and jeida-24

Aleksandr Mishin <amishin@t-argos.ru>
    drm/msm/dpu: Add callback function pointer check before its call

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: stop using raw IRQ indices in the kernel output

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make the irq table size static

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: add helper to get IRQ-related data

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: extract dpu_core_irq_is_valid() helper

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: remove irq_idx argument from IRQ callbacks

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use variable length array instead of fixed size

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check 'folio' pointer for NULL

Johannes Berg <johannes.berg@intel.com>
    um: vector: fix bpfflash parameter evaluation

Roberto Sassu <roberto.sassu@huawei.com>
    um: Add winch to winch_handlers before registering winch IRQ

Duoming Zhou <duoming@zju.edu.cn>
    um: Fix return value in ubd_init()

Neil Armstrong <neil.armstrong@linaro.org>
    drm/meson: gate px_clk when setting rate

Wojciech Macek <wmacek@chromium.org>
    drm/mediatek: dp: Fix mtk_dp_aux_transfer return value

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Always flush the slave INTF on the CTL

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Print dual-DSI-adjusted pclk instead of original mode pclk

Fabio Estevam <festevam@denx.de>
    media: ov2680: Do not fail if data-lanes property is absent

Fabio Estevam <festevam@denx.de>
    media: ov2680: Allow probing if link-frequencies is absent

Fabio Estevam <festevam@denx.de>
    media: ov2680: Clear the 'ret' variable on success

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Don't turn on privacy LED if streamon fails

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-subdev: Document and enforce .s_stream() requirements

Fenglin Wu <quic_fenglinw@quicinc.com>
    Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Fix ITAPDLY for HS400 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add OTAP/ITAP delay enable

Vignesh Raghavendra <vigneshr@ti.com>
    mmc: sdhci_am654: Drop lookup for deprecated ti,otap-del-sel

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Write ITAPDLY for DDR52 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add tuning algorithm for delay chain

Arnd Bergmann <arnd@arndb.de>
    Input: ims-pcu - fix printf string overflow

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: adc: axi-adc: add clocks property

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: adc: axi-adc: update bindings for backend framework

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Have "events" directory get permissions from its parent

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Free all of the eventfs_inode after RCU

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs/tracing: Add callback for release of an eventfs_inode

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Create eventfs_root_inode to store dentry

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: replace hardcoded divisor value with BIT() macro

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic-pci: register attributes via pci_driver

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic: deduplicate common code

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Reset chip on probe() and resume()

Luca Ceresoli <luca.ceresoli@bootlin.com>
    iio: accel: mxc4005: allow module autoloading via OF compatible

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Do not differentiate the toplevel events directory

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: Revert Remove pixle rate limit for subvp

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Remove pixle rate limit for subvp

Devyn Liu <liudingyuan@huawei.com>
    gpiolib: acpi: Fix failed in acpi_gpiochip_find() by adding parent node match

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: rockchip,rk3399-pcie: Add missing maxItems to ep-gpios

Sven Schnelle <svens@linux.ibm.com>
    s390/boot: Remove alt_stfle_fac_list from decompressor

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of nvme dump block

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of len fields in nvme reipl block

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: Use standard stack frame layout

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Create .build-id links for unstripped vdso files

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix build ID symlinks to installed debug VDSO files

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: unify vdso_install rules

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Generate unwind information for C modules

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/vdso64: filter out munaligned-symbols flag for vdso

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix callchain parse error with kernel tracepoint events again

Ian Rogers <irogers@google.com>
    perf pmu: Count sys and cpuid JSON events separately

Ian Rogers <irogers@google.com>
    perf pmu: Assume sysfs events are always the same case

Ian Rogers <irogers@google.com>
    perf tools: Add/use PMU reverse lookup from config to name

Ian Rogers <irogers@google.com>
    perf tools: Use pmus to describe type from attribute

Jing Zhang <renyu.zj@linux.alibaba.com>
    perf pmu: "Compat" supports regular expression matching identifiers

James Clark <james.clark@arm.com>
    perf pmu: Move pmu__find_core_pmu() to pmus.c

James Clark <james.clark@arm.com>
    perf test: Add a test for strcmp_cpuid_str() expression

Ian Rogers <irogers@google.com>
    perf stat: Don't display metric header for non-leader uncore events

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: fotg210: Add missing kernel doc description

Chao Yu <chao@kernel.org>
    f2fs: fix to add missing iput() in gc_data_segment()

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    perf daemon: Fix file leak in daemon_session__control

Ian Rogers <irogers@google.com>
    libsubcmd: Fix parse-options memory leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    serial: sh-sci: protect invalidating RXDMA on shutdown

Chao Yu <chao@kernel.org>
    f2fs: compress: don't allow unaligned truncation on released compress inode

Chao Yu <chao@kernel.org>
    f2fs: fix to release node block count in error path of f2fs_new_node_page()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock

Chao Yu <chao@kernel.org>
    f2fs: compress: fix error path of inc_valid_block_count()

Chao Yu <chao@kernel.org>
    f2fs: introduce get_available_block_count() for cleanup

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: deprecate io_bits

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to update i_compr_blocks correctly

James Clark <james.clark@arm.com>
    perf symbols: Fix ownership of string in dso__load_vmlinux()

Ian Rogers <irogers@google.com>
    perf maps: Move symbol maps functions to maps.c

Ian Rogers <irogers@google.com>
    perf thread: Fixes to thread__new() related to initializing comm

Ian Rogers <irogers@google.com>
    perf report: Avoid SEGV in report__setup_sample_type()

Ian Rogers <irogers@google.com>
    perf ui browser: Avoid SEGV on title

Wu Bo <bo.wu@vivo.com>
    f2fs: fix block migration when section is not aligned to pow2

Daeho Jeong <daehojeong@google.com>
    f2fs: support file pinning for zoned devices

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: kill heap-based allocation

Daeho Jeong <daehojeong@google.com>
    f2fs: separate f2fs_gc_range() to use GC for a range

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: use BLKS_PER_SEG, BLKS_PER_SEC, and SEGS_PER_SEC

Chao Yu <chao@kernel.org>
    f2fs: support printk_ratelimited() in f2fs_printk()

KaiLong Wang <wangkailong@jari.cn>
    f2fs: Clean up errors in segment.h

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_DPC_ENABLE_DSM with PCI Firmware r3.3

Johan Hovold <johan+linaro@kernel.org>
    dt-bindings: spmi: hisilicon,hisi-spmi-controller: fix binding references

Randy Dunlap <rdunlap@infradead.org>
    extcon: max8997: select IRQ_DOMAIN instead of depending on it

Ian Rogers <irogers@google.com>
    perf ui browser: Don't save pointer to stack memory

He Zhe <zhe.he@windriver.com>
    perf bench internals inject-build-id: Fix trap divide when collecting just one DSO

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: synquacer: Fix an error handling path in synquacer_i2c_probe()

Sai Pavan Boddu <sai.pavan.boddu@amd.com>
    i2c: cadence: Avoid fifo clear after start

Huai-Yuan Liu <qq810974084@gmail.com>
    ppdev: Add an error check in register_device

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ppdev: Remove usage of the deprecated ida_simple_xx() API

Dan Carpenter <dan.carpenter@linaro.org>
    stm class: Fix a double free in stm_register_device()

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Clear uac pointer when freed.

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Fix race condition use of controls after free during gadget unbind.

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Avoid unnecessary destruction of file_ida

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: phy: qcom,usb-snps-femto-v2: use correct fallback for sc8180x

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: fix msm899[68] power-domains

Chen Ni <nichen@iscas.ac.cn>
    watchdog: sa1100: Fix PTR_ERR_OR_ZERO() vs NULL check in sa1100dog_probe()

Matti Vaittinen <mazziesaccount@gmail.com>
    watchdog: bd9576: Drop "always-running" property

Duoming Zhou <duoming@zju.edu.cn>
    watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger

Danila Tikhonov <danila@jiaxyga.com>
    pinctrl: qcom: pinctrl-sm7150: Fix sdc1 and ufs special pins regs

Rafał Miłecki <rafal@milecki.pl>
    dt-bindings: pinctrl: mediatek: mt7622: fix array properties

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    VMCI: Fix an error handling path in vmci_guest_probe_device()

Duoming Zhou <duoming@zju.edu.cn>
    PCI: of_property: Return error for int_map allocation failure

Miklos Szeredi <mszeredi@redhat.com>
    ovl: remove upper umask handling from ovl_create_upper()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    leds: pwm: Disable PWM when going to suspend

Sean Young <sean@mess.org>
    pwm: Rename pwm_apply_state() to pwm_apply_might_sleep()

Samuel Holland <samuel.holland@sifive.com>
    riscv: Flush the instruction cache during SMP bringup

Andrew Jones <ajones@ventanamicro.com>
    RISC-V: Enable cbo.zero in usermode

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix unassigned instruction op (discovered by MemorySanitizer)

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Wait for Link Training==0 before starting Link retrain

Michal Simek <michal.simek@amd.com>
    microblaze: Remove early printk call from cpuinfo-static.c

Michal Simek <michal.simek@amd.com>
    microblaze: Remove gcc flag for non existing early_printk.c file

Matthew Wilcox (Oracle) <willy@infradead.org>
    udf: Convert udf_expand_file_adinicb() to use a folio

Jan Kara <jack@suse.cz>
    udf: Remove GFP_NOFS allocation in udf_expand_file_adinicb()

Marco Pagani <marpagan@redhat.com>
    fpga: region: add owner module and take its refcount

Ye Bin <yebin10@huawei.com>
    vfio/pci: fix potential memory leak in vfio_intx_enable()

Christian Brauner <brauner@kernel.org>
    i915: make inject_virtual_interrupt() void

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix access to resource selector registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Safe access for TRCQCLTR

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not save/restore Data trace control registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not hardcode IOMEM access for register restore

Nuno Sa <nuno.sa@analog.com>
    iio: adc: adi-axi-adc: only error out in major version mismatch

Nuno Sa <nuno.sa@analog.com>
    iio: adc: adi-axi-adc: move to backend framework

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad9467: convert to backend framework

Nuno Sa <nuno.sa@analog.com>
    iio: add the IIO backend framework

Nuno Sa <nuno.sa@analog.com>
    iio: buffer-dmaengine: export buffer alloc and free functions

Nuno Sa <nuno.sa@analog.com>
    iio: adc: adi-axi-adc: convert to regmap

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad9467: use chip_info variables instead of array

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad9467: use spi_get_device_match_data()

Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>
    iio: pressure: dps310: support negative temperature values

James Clark <james.clark@arm.com>
    perf test shell arm_coresight: Increase buffer size for Coresight basic tests

Ian Rogers <irogers@google.com>
    perf docs: Document bpf event modifier

Anshuman Khandual <anshuman.khandual@arm.com>
    coresight: etm4x: Fix unbalanced pm_runtime_enable()

Hannah Peuckmann <hannah.peuckmann@canonical.com>
    riscv: dts: starfive: visionfive 2: Remove non-existing TDM hardware

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: stm32: Fixing err code to not indicate success

Chao Yu <chao@kernel.org>
    f2fs: fix to check pinfile flag in f2fs_move_file_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to relocate check condition in f2fs_fallocate()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()

Ian Rogers <irogers@google.com>
    perf bench uprobe: Remove lib64 from libc.so.6 binary path

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties

Wolfram Sang <wsa+renesas@sang-engineering.com>
    dt-bindings: PCI: rcar-pci-host: Add optional regulators

Adrian Hunter <adrian.hunter@intel.com>
    perf record: Fix debug message placement for test consumption

Yang Jihong <yangjihong1@huawei.com>
    perf record: Move setting tracking events before record__init_thread_masks()

Yang Jihong <yangjihong1@huawei.com>
    perf evlist: Add evlist__findnew_tracking_event() helper

James Clark <james.clark@arm.com>
    perf tests: Apply attributes to all events in object code reading test

James Clark <james.clark@arm.com>
    perf tests: Make "test data symbol" more robust on Neoverse N1

Xianwei Zhao <xianwei.zhao@amlogic.com>
    arm64: dts: meson: fix S4 power-controller node

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment

Arnd Bergmann <arnd@arndb.de>
    module: don't ignore sysfs_create_link() failures

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: add proper sched.h include for sched_set_fifo()

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix probe path for Endpoint mode

Arnd Bergmann <arnd@arndb.de>
    greybus: arche-ctrl: move device table to its right location

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Fix bitwise types

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Update uart_driver_registered on driver removal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Lock port->lock when calling uart_handle_cts_change()

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Use global annotation_options

Namhyung Kim <namhyung@kernel.org>
    perf top: Convert to the global annotation_options

Namhyung Kim <namhyung@kernel.org>
    perf report: Convert to the global annotation_options

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Introduce global annotation_options

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Split branch stack cycles information out of 'struct annotation_line'

Ian Rogers <irogers@google.com>
    perf machine thread: Remove exited threads by default

Ian Rogers <irogers@google.com>
    perf record: Lazy load kernel symbols

Arnd Bergmann <arnd@arndb.de>
    firmware: dmi-id: add a release callback function

Chen Ni <nichen@iscas.ac.cn>
    dmaengine: idma64: Add check for dma_set_max_seg_size

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix invalid PDI offset

Thomas Richter <tmricht@linux.ibm.com>
    perf stat: Do not fail on metrics on s390 z/VM systems

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: simplify partner's PD caps registration

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: always register a link to USB PD device

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Get rid of duplicate --group option item

Randy Dunlap <rdunlap@infradead.org>
    counter: linux/counter.h: fix Excess kernel-doc description warning

Marco Pagani <marpagan@redhat.com>
    fpga: bridge: add owner module and take its refcount

Marco Pagani <marpagan@redhat.com>
    fpga: manager: add owner module and take its refcount

Chao Yu <chao@kernel.org>
    f2fs: fix to wait on page writeback in __clone_blkaddrs()

Chao Yu <chao@kernel.org>
    f2fs: multidev: fix to recognize valid zero block address

Neil Armstrong <neil.armstrong@linaro.org>
    phy: qcom: qmp-combo: fix duplicate return in qmp_v4_configure_dp_phy

Rui Miguel Silva <rmfrfs@gmail.com>
    greybus: lights: check return of get_channel_from_mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: core: Leave private pointer NULL when no private data supplied

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Add missing libgen.h header needed for using basename()

Ian Rogers <irogers@google.com>
    perf record: Delete session after stopping sideband thread

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: fix to change Rx features

Cheng Yu <serein.chengyu@huawei.com>
    sched/core: Fix incorrect initialization of the 'burst' parameter in cpu_max_write()

Vitalii Bursov <vitaly@bursov.com>
    sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level

Eric Dumazet <edumazet@google.com>
    af_packet: do not call packet_read_pending() from tpacket_destruct_skb()

Eric Dumazet <edumazet@google.com>
    netrom: fix possible dead-lock in nr_rt_ioctl()

Chris Lew <quic_clew@quicinc.com>
    net: qrtr: ns: Fix module refcnt

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: fix vlan use-after-free

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: bridge: increase IGMP/MLD exclude timeout membership interval

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: xmit: make sure we have at least eth header len bytes

Wang Yao <wangyao@lemote.com>
    modules: Drop the .export_symbol section from the final modules

Beau Belgrave <beaub@linux.microsoft.com>
    tracing/user_events: Fix non-spaced field matching

Beau Belgrave <beaub@linux.microsoft.com>
    tracing/user_events: Prepare find/delete for same name events

Beau Belgrave <beaub@linux.microsoft.com>
    tracing/user_events: Allow events to persist for perfmon_capable users

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/cma: Fix kmemleak in rdma_core observed during blktests nvme/rdma use siw

Leon Romanovsky <leon@kernel.org>
    RDMA/IPoIB: Fix format truncation compilation errors

Edward Liaw <edliaw@google.com>
    selftests/kcmp: remove unused open mode

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix gss_free_in_token_pages()

Michal Schmidt <mschmidt@redhat.com>
    bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Adds MSN table capability for Gen P7 adapters

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Update the HW interface definitions

Chandramohan Akula <chandramohan.akula@broadcom.com>
    RDMA/bnxt_re: Remove roundup_pow_of_two depth for all hardware queue resources

Chandramohan Akula <chandramohan.akula@broadcom.com>
    RDMA/bnxt_re: Refactor the queue index update

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove the redundant folio_wait_stable()

Dan Carpenter <dan.carpenter@linaro.org>
    ext4: fix potential unnitialized variable

Aleksandr Aprelkov <aaprelkov@usergate.com>
    sunrpc: removed redundant procp check

David Hildenbrand <david@redhat.com>
    drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()

Christoph Hellwig <hch@lst.de>
    virt: acrn: stop using follow_pfn

Jan Kara <jack@suse.cz>
    ext4: avoid excessive credit estimate in ext4_tmpfile()

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add VEX versions of VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map

Marc Gonzalez <mgonzalez@freebox.fr>
    clk: qcom: mmcc-msm8998: fix venus clock issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8550: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm6350: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8450: fix DisplayPort clocks

Duoming Zhou <duoming@zju.edu.cn>
    lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g043: Add clock and reset entry for PLIC

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779a0: Fix CANFD parent clock

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Use __iowrite64_copy() for write combining stores

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix incorrect rxe_put in error path

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Allow good work requests to be executed

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: remove invalid Stromer register offset

Catalin Popescu <catalin.popescu@leica-geosystems.com>
    clk: rs9: fix wrong default value for clock amplitude

Alexandre Mergnat <amergnat@baylibre.com>
    clk: mediatek: mt8365-mm: fix DPI0 parent

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Modify the print level of CQE error

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Use complete parentheses in macros

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix GMV table pagesize

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix UAF for cq async event

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix deadlock on SRQ async events.

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: Fix return value in hns_roce_map_mr_sg

Yi Liu <yi.l.liu@intel.com>
    iommu: Undo pasid attachment only for the devices that have succeeded

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    clk: mediatek: pllfh: Don't log error for missing fhctl node

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Adding remote atomic access flag to updatable flags

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Uncacheable mkey has neither rb_key or cache_ent

Jaewon Kim <jaewon02.kim@samsung.com>
    clk: samsung: exynosautov9: fix wrong pll clock id value

Pratyush Yadav <p.yadav@ti.com>
    media: cadence: csi2rx: configure DPHY before starting source stream

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Parse topology block for all DispID structure v1.x

Detlev Casanova <detlev.casanova@collabora.com>
    drm/rockchip: vop2: Do not divide height twice for YUV

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add quirk for Logitech Rally Bar

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/mipi-dsi: use correct return type for the DSC functions

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector

Hsin-Te Yuan <yuanhsinte@chromium.org>
    drm/bridge: anx7625: Update audio status while detecting

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/panel: novatek-nt35950: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: dpc3433: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: tc358775: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611uxc: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt8912b: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: icn6211: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: anx7625: Don't log an error when DSI host can't be found

Steven Rostedt <rostedt@goodmis.org>
    ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value

Aleksandr Mishin <amishin@t-argos.ru>
    drm: vc4: Fix possible null pointer dereference

Huai-Yuan Liu <qq810974084@gmail.com>
    drm/arm/malidp: fix a possible null pointer dereference

Zhipeng Lu <alexious@zju.edu.cn>
    media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries

Randy Dunlap <rdunlap@infradead.org>
    fbdev: sh7760fb: allow modular build

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-subdev: Fix stream handling for crop API

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    media: i2c: et8ek8: Don't strip remove function when driver is builtin

Fabio Estevam <festevam@denx.de>
    media: dt-bindings: ovti,ov2680: Fix the power supply names

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Request IRQ earlier

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Avoid a long timeout for AUX transfer if nothing connected

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: allow voltage swing / pre emphasis of 3

Aleksandr Mishin <amishin@t-argos.ru>
    drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference

Ricardo Ribalda <ribalda@chromium.org>
    media: radio-shark2: Avoid led_names truncations

Arnd Bergmann <arnd@arndb.de>
    media: rcar-vin: work around -Wenum-compare-conditional warning

Aleksandr Burakov <a.burakov@rosalinux.ru>
    media: ngene: Add dvb_ca_en50221_init return value check

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Test result of avs_get_module_entry()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix potential integer overflow

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix ASRC module initialization

Tianchen Ding <dtcccc@linux.alibaba.com>
    selftests: cgroup: skip test_cgcore_lesser_ns_open when cgroup2 mounted without nsdelegate

Arnd Bergmann <arnd@arndb.de>
    fbdev: sisfb: hide unused variables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Implement firmware boot state check

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed

Yong Zhi <yong.zhi@intel.com>
    ASoC: SOF: Intel: mtl: call dsp dump when boot retry fails

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: lnl: Correct rom_status_reg

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Correct rom_status_reg

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: pci-mtl: fix ARL-S definitions

Arun T <arun.t@intel.com>
    ASoC: SOF: Intel: pci-mtl: use ARL specific firmware definitions

Arun T <arun.t@intel.com>
    ASoC: Intel: common: add ACPI matching tables for Arrow Lake

Arnd Bergmann <arnd@arndb.de>
    powerpc/fsl-soc: hide unused const variable

Justin Green <greenjustin@chromium.org>
    drm/mediatek: Add 0 size check to mtk_drm_gem_obj

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: vclk: fix calculation of 59.94 fractional rates

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: kirkwood: Fix potential NULL dereference

Arnd Bergmann <arnd@arndb.de>
    fbdev: shmobile: fix snprintf truncation

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: Assign dummy when codec not specified for a DAI link

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    mtd: rawnand: hynix: fixed typo

Aapo Vienamo <aapo.vienamo@linux.intel.com>
    mtd: core: Report error if first mtd_otp_size() call fails in mtd_otp_nvmem_add()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: ssm4567: Do not ignore route checks

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Disable route checks for Skylake boards

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix potential index out of bounds in color transformation function

Douglas Anderson <dianders@chromium.org>
    drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesn't assert

Douglas Anderson <dianders@chromium.org>
    drm/dp: Don't attempt AUX transfers when eDP panels are not powered

Marek Vasut <marex@denx.de>
    drm/lcdif: Do not disable clocks on already suspended hardware

Geert Uytterhoeven <geert+renesas@glider.be>
    dev_printk: Add and use dev_no_printk()

Geert Uytterhoeven <geert+renesas@glider.be>
    printk: Let no_printk() use _printk()

Tony Lindgren <tony@atomide.com>
    drm/omapdrm: Fix console with deferred ops

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Provide I/O-memory helpers as module

Tony Lindgren <tony@atomide.com>
    drm/omapdrm: Fix console by implementing fb_dirty

Vignesh Raman <vignesh.raman@collabora.com>
    drm/ci: update device type for volteer devices

Helen Koike <helen.koike@collabora.com>
    drm/ci: add subset-1-gfx to LAVA_TAGS and adjust shards

Helen Koike <helen.koike@collabora.com>
    drm/ci: uprev mesa version: fix container build & crosvm

Jagan Teki <jagan@amarulasolutions.com>
    drm/bridge: Fix improper bridge init order with pre_enable_prev_first

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Remove HCI_AMP support

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Bluetooth: Remove usage of the deprecated ida_simple_xx() API

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Fix BIS cleanup

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: qca: Fix error code in qca_read_fw_build_info()

Sebastian Urban <surban@surban.net>
    Bluetooth: compute LE flow credits based on recvbuf space

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: micrel: Fix receiving the timestamp in the frame for lan8841

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: SO_KEEPALIVE: fix getsockopt support

Wei Fang <wei.fang@nxp.com>
    net: fec: remove .ndo_poll_controller to avoid deadlocks

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issue of net_device

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issues of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Use kernel universal linked list to implement ax25_dev_list

Puranjay Mohan <puranjay@kernel.org>
    riscv, bpf: make some atomic operations fully ordered

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Emit a barrier for BPF_FETCH instructions

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Discard command completions in internal error

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Add a timeout to acquire the command queue semaphore

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Reload only IB representors upon lag disable/enable

Shay Drory <shayd@nvidia.com>
    net/mlx5: Enable 4 ports multiport E-switch

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix invalid unregister error path

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix incorrect unregister order

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: add missing seg6_local_exit

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix overwriting ct original tuple for ICMPv6

Eric Dumazet <edumazet@google.com>
    net: usb: smsc95xx: stop lying about skb->truesize

Breno Leitao <leitao@debian.org>
    af_unix: Fix data races in unix_release_sock/unix_stream_sendmsg

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Locking fixes

Jakub Kicinski <kuba@kernel.org>
    selftests: net: move amt to socat for better compatibility

Jakub Kicinski <kuba@kernel.org>
    selftests: net: add missing config for amt.sh

Paolo Abeni <pabeni@redhat.com>
    selftests: net: add more missing kernel config

Jakub Kicinski <kuba@kernel.org>
    eth: sungem: remove .ndo_poll_controller to avoid deadlocks

gaoxingwang <gaoxingwang1@huawei.com>
    net: ipv6: fix wrong start position when receive hop-by-hop fragment

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix reboot hang on Mac IIci

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Fix spinlock race in kernel thread creation

Eric Dumazet <edumazet@google.com>
    net: usb: sr9700: stop lying about skb->truesize

Eric Dumazet <edumazet@google.com>
    usb: aqc111: stop lying about skb->truesize

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle "no sensors" in PM operations

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwl8k: initialize cmd->addr[] properly

Robert Richter <rrichter@amd.com>
    x86/numa: Fix SRAT lookup of CFMWS ranges with numa_fill_memblks()

Kent Overstreet <kent.overstreet@linux.dev>
    kernel/numa.c: Move logging out of numa.h

Himanshu Madhani <himanshu.madhani@oracle.com>
    scsi: qla2xxx: Fix debugfs output for fw_resource_count

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: qedf: Ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: bfa: Ensure the copied buf is NUL terminated

Chen Ni <nichen@iscas.ac.cn>
    HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors

Michal Schmidt <mschmidt@redhat.com>
    selftests/bpf: Fix pointer arithmetic in test_xdp_do_redirect

Mickaël Salaün <mic@digikod.net>
    kunit: Fix kthread reference

Valentin Obst <kernel@valentinobst.de>
    selftests: default to host arch for LLVM builds

John Hubbard <jhubbard@nvidia.com>
    selftests/resctrl: fix clang build failure: use LOCAL_HDRS

John Hubbard <jhubbard@nvidia.com>
    selftests/binderfs: use the Makefile's rules, not Make's implicit rules

Kees Cook <keescook@chromium.org>
    wifi: nl80211: Avoid address calculations via out of bounds array indexing

Jiri Olsa <jolsa@kernel.org>
    libbpf: Fix error message in attach_kprobe_multi

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: fix tx queue of loopback packets

Guenter Roeck <linux@roeck-us.net>
    Revert "sh: Handle calling csum_partial with misaligned data"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()

Stanislav Fomichev <sdf@google.com>
    bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: ar5523: enable proper endpoint verification

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix verifier assumptions about socket->sk

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: carl9170: add a proper sanity check for endpoints

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"

Eric Dumazet <edumazet@google.com>
    net: give more chances to rcu in netdev_wait_allrefs_any()

Hao Chen <chenhao418@huawei.com>
    drivers/perf: hisi: hns3: Actually use devm_add_action_or_reset()

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi: hns3: Fix out-of-bound access when valid event group

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Simplify probe function using devm functions

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Prepare removing pwm_chip from driver data

Eric Dumazet <edumazet@google.com>
    tcp: avoid premature drops in tcp_add_backlog()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Avoid EEPROM timeout without EEPROM on 88E6250-family switches

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Add support for model-specific pre- and post-reset handlers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: populate board data for WCN3990

Portia Stephens <portia.stephens@canonical.com>
    cpufreq: brcmstb-avs-cpufreq: ISO C90 forbids mixed declarations

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix a fd leak in error paths in open_netns

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: do_xmote fixes

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: finish_xmote cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename gfs2_withdrawn to gfs2_withdrawing_or_withdrawn

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Mark withdraws as unlikely

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix potential glock use-after-free on unmount

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove ill-placed consistency check

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No longer use 'extern' in function declarations

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename gfs2_lookup_{ simple => meta }

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Convert gfs2_internal_read to folios

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Get rid of gfs2_alloc_blocks generation parameter

Su Hui <suhui@nfschina.com>
    wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()

Binbin Zhou <zhoubinbin@loongson.cn>
    dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition

Binbin Zhou <zhoubinbin@loongson.cn>
    dt-bindings: thermal: loongson,ls2k-thermal: Add Loongson-2K0500 compatible

Binbin Zhou <zhoubinbin@loongson.cn>
    dt-bindings: thermal: loongson,ls2k-thermal: Fix binding check issues

Aleksandr Mishin <amishin@t-argos.ru>
    thermal/drivers/tsens: Fix null pointer dereference

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    wifi: ath12k: fix out-of-bound access of qmi_invoke_handler()

Ard Biesheuvel <ardb@kernel.org>
    x86/purgatory: Switch to the position-independent small code model

Yuri Karpov <YKarpov@ispras.ru>
    scsi: hpsa: Fix allocation size for Scsi_Host private data

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix the failure of adding phy with zero-address to port

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: init vif works only once

Aleksandr Mishin <amishin@t-argos.ru>
    cppc_cpufreq: Fix possible null pointer dereference

Stafford Horne <shorne@gmail.com>
    openrisc: traps: Don't send signals to kernel mode threads

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Avoid call to compute_score on multiple sites

Juergen Gross <jgross@suse.com>
    x86/pat: Fix W^X violation false-positives when running as Xen PV guest

Juergen Gross <jgross@suse.com>
    x86/pat: Restructure _lookup_address_cpa()

Juergen Gross <jgross@suse.com>
    x86/pat: Introduce lookup_address_in_pgd_attr()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: exit() callback is optional

Hechao Li <hli@netflix.com>
    tcp: increase the default TCP scaling ratio

Paolo Abeni <pabeni@redhat.com>
    tcp: define initial scaling factor value as a macro

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix umount cgroup2 error in test_sockmap

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/64: Clear most of CR4 in startup_64(), except PAE, MCE and LA57

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "ignore unlock failures after withdraw"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't forget to complete delayed withdraw

Arnd Bergmann <arnd@arndb.de>
    ACPI: disable -Wstringop-truncation

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/loongson-pch-msi: Fix off-by-one on allocation error path

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/alpine-msi: Fix off-by-one in allocation error path

Uros Bizjak <ubizjak@gmail.com>
    locking/atomic/x86: Correct the definition of __arch_try_cmpxchg128()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: LPSS: Advertise number of chip selects via property

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling interrupts

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing CGC enable

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing unipro mode

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing reset bit

Andrii Nakryiko <andrii@kernel.org>
    bpf: prevent r10 register from being marked as precise

Anton Protopopov <aspsk@isovalent.com>
    bpf: Pack struct bpf_fib_lookup

Sahil Siddiq <icegambit91@gmail.com>
    bpftool: Mount bpffs on provided dir instead of parent dir

Arnd Bergmann <arnd@arndb.de>
    wifi: carl9170: re-fix fortified-memset warning

Alexander Aring <aahringo@redhat.com>
    dlm: fix user space lock decision to copy lvb

Alexander Lobakin <aleksander.lobakin@intel.com>
    bitops: add missing prototype check

Arnd Bergmann <arnd@arndb.de>
    mlx5: stop warning for 64KB pages

Arnd Bergmann <arnd@arndb.de>
    mlx5: avoid truncating error message

Arnd Bergmann <arnd@arndb.de>
    qed: avoid truncating work queue length

Arnd Bergmann <arnd@arndb.de>
    enetc: avoid truncating error message

Armin Wolf <W_Armin@gmx.de>
    ACPI: Fix Generic Initiator Affinity _OSC bit

Shrikanth Hegde <sshegde@linux.ibm.com>
    sched/fair: Add EAS checks before updating root_domain::overutilized

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix check in iwl_mvm_sta_fw_id_mask

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: reconfigure TLC during HW restart

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: select STA mask only for active links

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: allocate STA links only for active links

Johannes Berg <johannes.berg@intel.com>
    wifi: ieee80211: fix ieee80211_mle_basic_sta_prof_size_ok()

Guixiong Wei <weiguixiong@bytedance.com>
    x86/boot: Ignore relocations in .notes sections in walk_relocs() too

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7915: workaround too long expansion sparse warnings

Aloka Dixit <quic_alokad@quicinc.com>
    wifi: ath12k: use correct flag field for 320 MHz channels

Yonghong Song <yonghong.song@linux.dev>
    bpftool: Fix missing pids during link show

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't force enable power save on non-running vdevs

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: pcie: handle randbuf allocation failure

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: poll service ready message before failing

Yu Kuai <yukuai3@huawei.com>
    block: support to account io_ticks precisely

INAGAKI Hiroshi <musashino.open@gmail.com>
    block: fix and simplify blkdevparts= cmdline parsing

Christoph Hellwig <hch@lst.de>
    block: refine the EOF check in blkdev_iomap_begin

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - specify firmware files for 402xx

Yu Kuai <yukuai3@huawei.com>
    md: fix resync softlockup when bitmap size is less than array size

Kees Cook <keescook@chromium.org>
    lkdtm: Disable CFI checking for perms functions

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Make client-lock non-sleeping

Kees Cook <keescook@chromium.org>
    kunit/fortify: Fix mismatched kvalloc()/vfree() usage

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix missing mutex_destroy() at module removal

Chun-Kuang Hu <chunkuang.hu@kernel.org>
    soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE

Mukesh Ojha <quic_mojha@quicinc.com>
    firmware: qcom: scm: Fix __scm and waitq completion variable initialization

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pmic_glink: notify clients about the current state

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pmic_glink: don't traverse clients list without a lock

David Hildenbrand <david@redhat.com>
    s390/mm: Re-enable the shared zeropage for !PV and !skeys KVM guests

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: Do not place zeropages when zeropages are disallowed

Gabriel Krisman Bertazi <krisman@suse.de>
    io-wq: write next_work before dropping acct_lock

Ilya Denisyev <dev@elkcl.ru>
    jffs2: prevent xattr node from overflowing the eraseblock

Maxime Ripard <mripard@kernel.org>
    ARM: configs: sunxi: Enable DRM_DW_HDMI

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu: Fix buffer overflow in print_cpu_stall_info()

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow

Jens Axboe <axboe@kernel.dk>
    io_uring: use the right type for work_llist empty check

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix tracepoint subchannel type field

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha512-avx2 - add missing vzeroupper

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha256-avx2 - add missing vzeroupper

Eric Biggers <ebiggers@google.com>
    crypto: x86/nh-avx2 - add missing vzeroupper

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - drop platform ifdef checks

Al Viro <viro@zeniv.linux.org.uk>
    parisc: add missing export of __cmpxchg_u8()

Arnd Bergmann <arnd@arndb.de>
    nilfs2: fix out-of-range warning

Brian Kubisiak <brian@kubisiak.com>
    ecryptfs: Fix buffer size for tag 66 packet

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    firmware: raspberrypi: Use correct device for DMA mappings

Guenter Roeck <linux@roeck-us.net>
    mm/slub, kunit: Use inverted data to corrupt kmem cache

Aleksandr Mishin <amishin@t-argos.ru>
    crypto: bcm - Fix pointer arithmetic

Eric Sandeen <sandeen@redhat.com>
    openpromfs: finish conversion to the new mount API

Dan Carpenter <dan.carpenter@linaro.org>
    nvmet: prevent sprintf() overflow in nvmet_subsys_nsid_exists()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix uninitialized symbol 'share' in smb2_tree_connect()

Linus Torvalds <torvalds@linux-foundation.org>
    epoll: be better about file lifetimes

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix nvme status code when namespace is disabled

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix possible memory leak when tearing down a controller

Nilay Shroff <nilay@linux.ibm.com>
    nvme: cancel pending I/O if nvme controller is in terminal state

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-auth: replace pr_debug() with pr_err() to report an error.

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-auth: return the error code to the nvmet_auth_host_hash() callers

Nilay Shroff <nilay@linux.ibm.com>
    nvme: find numa distance only if controller has valid numa id

Linus Torvalds <torvalds@linux-foundation.org>
    x86/mm: Remove broken vsyscall emulation code from the page fault code

Lancelot SIX <lancelot.six@amd.com>
    drm/amdkfd: Flush the process wq before creating a kfd_process

Sung Joon Kim <sungjoon.kim@amd.com>
    drm/amd/display: Disable seamless boot on 128b/132b encoding

Leo Ma <hanghong.ma@amd.com>
    drm/amd/display: Fix DC mode screen flickering on DCN321

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add VCO speed parameter for DCN31 FPU

Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
    drm/amd/display: Allocate zero bw after bw alloc enable

Swapnil Patel <swapnil.patel@amd.com>
    drm/amd/display: Add dtbclk access to dcn315

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdgpu: Fix VRAM memory accounting

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-dsp-config: harden I2C/I2S codec detection

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: da7219-aad: fix usage of device_get_named_child_node()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add Grand Ridge to HPM CPU list

Zqiang <qiang.zhang1211@gmail.com>
    softirq: Fix suspicious RCU usage in __do_softirq()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: make E-MU FPGA writes potentially more reliable

Puranjay Mohan <puranjay@kernel.org>
    bpf, x86: Fix PROBE_MEM runtime load check

Peter Colberg <peter.colberg@intel.com>
    fpga: dfl-pci: add PCI subdevice ID for Intel D5005 card

Vicki Pfau <vi@endrift.com>
    Input: xpad - add support for ASUS ROG RAIKIRI

Oliver Upton <oliver.upton@linux.dev>
    KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715-sdca: volume step modification

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715: add vendor clear control register

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: cs35l41: Update DSP1RX5/6 Sources for DSP config

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: vqmmc-ipq4019: fix module autoloading

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: qcom-refgen: fix module autoloading

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca: add headset microphone vrefo setting

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca: modify channel number to support 4 channels

Derek Fang <derek.fang@realtek.com>
    ASoC: dt-bindings: rt5645: add cbj sleeve gpio property

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5645: Fix the electric noise due to the CBJ contacts floating

end.to.start <end.to.start@mail.ru>
    ASoC: acp: Support microphone from device Acer 315-24p

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: pcm: Restrict DSP D0i3 during S0ix to IPC3

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Exit cache-only after cs35l56_wait_for_firmware_boot()

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: irq_helpers: duplicate IRQ name

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Apply Asus T100TA quirk to Asus T100TAM too

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Fix boot crash when maxcpus < first housekeeping CPU

Clément Léger <cleger@rivosinc.com>
    selftests: sud_test: return correct emulated syscall value on RISC-V

Derek Foreman <derek.foreman@collabora.com>
    drm/etnaviv: fix tx clock gating on some GC7000 variants

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Lately init pmu after smp is online

Sean Christopherson <seanjc@google.com>
    cpu: Ignore "mitigations" kernel parameter if CPU_MITIGATIONS=n

Duanqiang Wen <duanqiangwen@net-swift.com>
    Revert "net: txgbe: fix clk_name exceed MAX_DEV_ID limits"

Duanqiang Wen <duanqiangwen@net-swift.com>
    Revert "net: txgbe: fix i2c dev name cannot match clkdev"

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu/mes: fix use-after-free issue

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: Fix the ring buffer size for queue VM flush

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdkfd: Add VRAM accounting for SVM migration

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Restore config space after reset

Felix Kuehling <felix.kuehling@amd.com>
    drm/amdgpu: Update BO eviction priorities

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Set color_mgmt_changed to true on unsuspend

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN920C04 compositions

Abdelrahman Morsy <abdelrahmanhesham94@gmail.com>
    HID: mcp-2221: cancel delayed_work only when CONFIG_IIO is enabled

Rob Herring <robh@kernel.org>
    dt-bindings: rockchip: grf: Add missing type to 'pcie-phy' node

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class

Richard Kinder <richard.kinder@gmail.com>
    wifi: mac80211: ensure beacon is non-S1G prior to extracting the beacon timestamp field

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't use rate mask for scanning

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: Add missing dependency on CRYPTO_SIG

Takashi Iwai <tiwai@suse.de>
    ALSA: Fix deadlocks with kctl removals at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix NULL module pointer assignment at card init

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 440/460 G11.

Nandor Kracser <bonifaido@gmail.com>
    ksmbd: ignore trailing slashes in share paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: avoid to send duplicate oplock break notifications

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Break dir enumeration if directory contents error

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix case when index is reused during tree transformation

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Taking DOS names into account during link counting

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Remove max link count info display during driver init

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential hang in nilfs_detach_log_writer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix unexpected freezing of nilfs_segctor_sync()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free of timer for log writer thread

Thorsten Blum <thorsten.blum@toblux.com>
    net: smc91x: Fix m68k kernel compilation for ColdFire CPU

Herve Codina <herve.codina@bootlin.com>
    net: lan966x: remove debugfs directory in probe() error path

Romain Gantois <romain.gantois@bootlin.com>
    net: ti: icssg_prueth: Fix NULL pointer dereference in prueth_probe()

Brennan Xavier McManus <bxmcmanus@gmail.com>
    tools/nolibc/stdlib: fix memory error in realloc()

Shuah Khan <skhan@linuxfoundation.org>
    tools/latency-collector: Fix -Wformat-security compile warns

Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
    net: mana: Fix the extra HZ in mana_hwc_send_request

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix a race between readers and resize checks

Ken Milmore <ken.milmore@gmail.com>
    r8169: Fix possible ring buffer corruption on fragmented Tx packets.

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "r8169: don't try to disable interrupts if NAPI is, scheduled already"

Ming Lei <ming.lei@redhat.com>
    io_uring: fail NOP if non-zero op flags is passed in

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Pin-yen Lin <treapking@chromium.org>
    serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup

Doug Berger <opendmb@gmail.com>
    serial: 8250_bcm7271: use default_mux_rate if possible

Dan Carpenter <dan.carpenter@linaro.org>
    speakup: Fix sizeof() vs ARRAY_SIZE() bug

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing receive state reset after mode switch

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix possible out-of-bounds in gsm0_receive()

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix possible use-after-free issue in ftrace_location()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix BTFARG testcase to check fprobe is enabled correctly

Daniel J Blueman <daniel@quora.org>
    x86/tsc: Trust initial offset in architectural TSC-adjust MSRs


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 .../devicetree/bindings/iio/adc/adi,axi-adc.yaml   |  13 +-
 .../devicetree/bindings/media/i2c/ovti,ov2680.yaml |  18 +-
 .../devicetree/bindings/pci/rcar-pci-host.yaml     |  14 +
 .../bindings/pci/rockchip,rk3399-pcie.yaml         |   1 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |  16 +-
 .../bindings/phy/qcom,usb-snps-femto-v2.yaml       |   4 +-
 .../bindings/pinctrl/mediatek,mt7622-pinctrl.yaml  |  92 ++--
 .../devicetree/bindings/soc/rockchip/grf.yaml      |   1 +
 Documentation/devicetree/bindings/sound/rt5645.txt |   6 +
 .../spmi/hisilicon,hisi-spmi-controller.yaml       |   4 +-
 .../bindings/thermal/loongson,ls2k-thermal.yaml    |  34 +-
 Documentation/driver-api/fpga/fpga-bridge.rst      |   7 +-
 Documentation/driver-api/fpga/fpga-mgr.rst         |  34 +-
 Documentation/driver-api/fpga/fpga-region.rst      |  13 +-
 Documentation/driver-api/pwm.rst                   |   8 +-
 Documentation/filesystems/f2fs.rst                 |   6 +-
 MAINTAINERS                                        |  10 +-
 Makefile                                           |  13 +-
 arch/arm/Makefile                                  |   7 +-
 arch/arm/configs/sunxi_defconfig                   |   1 +
 arch/arm/vdso/Makefile                             |  25 --
 arch/arm64/Makefile                                |   9 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi          |  13 +-
 arch/arm64/include/asm/asm-bug.h                   |   1 +
 arch/arm64/kernel/vdso/Makefile                    |  10 -
 arch/arm64/kernel/vdso32/Makefile                  |  10 -
 arch/loongarch/Makefile                            |   4 +-
 arch/loongarch/include/asm/perf_event.h            |   3 +-
 arch/loongarch/kernel/perf_event.c                 |   2 +-
 arch/loongarch/vdso/Makefile                       |  10 -
 arch/m68k/kernel/entry.S                           |   4 +-
 arch/m68k/mac/misc.c                               |  36 +-
 arch/microblaze/kernel/Makefile                    |   1 -
 arch/microblaze/kernel/cpu/cpuinfo-static.c        |   2 +-
 arch/openrisc/kernel/traps.c                       |  42 +-
 arch/parisc/Makefile                               |   8 +-
 arch/parisc/kernel/parisc_ksyms.c                  |   1 +
 arch/powerpc/include/asm/hvcall.h                  |   2 +-
 arch/powerpc/platforms/pseries/lpar.c              |   6 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  10 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/Makefile                                |   9 +-
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |  40 --
 arch/riscv/include/asm/cpufeature.h                |   1 +
 arch/riscv/include/asm/csr.h                       |   3 +
 arch/riscv/include/asm/hwcap.h                     |  16 +
 arch/riscv/include/asm/sbi.h                       |   2 +
 arch/riscv/include/asm/suspend.h                   |   1 +
 arch/riscv/kernel/compat_vdso/Makefile             |  10 -
 arch/riscv/kernel/cpu.c                            |  40 +-
 arch/riscv/kernel/cpu_ops_sbi.c                    |   2 +-
 arch/riscv/kernel/cpu_ops_spinwait.c               |   3 +-
 arch/riscv/kernel/cpufeature.c                     |  14 +-
 arch/riscv/kernel/setup.c                          |   4 +
 arch/riscv/kernel/smpboot.c                        |   9 +-
 arch/riscv/kernel/stacktrace.c                     |  20 +-
 arch/riscv/kernel/suspend.c                        |   4 +
 arch/riscv/kernel/vdso/Makefile                    |  10 -
 arch/riscv/net/bpf_jit_comp64.c                    |  20 +-
 arch/s390/Makefile                                 |   6 +-
 arch/s390/boot/startup.c                           |   1 -
 arch/s390/include/asm/gmap.h                       |   2 +-
 arch/s390/include/asm/mmu.h                        |   5 +
 arch/s390/include/asm/mmu_context.h                |   1 +
 arch/s390/include/asm/pgtable.h                    |  16 +-
 arch/s390/kernel/ipl.c                             |  10 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/s390/kernel/vdso32/Makefile                   |  14 +-
 arch/s390/kernel/vdso64/Makefile                   |  15 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/s390/mm/gmap.c                                | 165 +++++--
 arch/s390/net/bpf_jit_comp.c                       |   8 +-
 arch/sh/kernel/kprobes.c                           |   7 +-
 arch/sh/lib/checksum.S                             |  67 +--
 arch/sparc/Makefile                                |   5 +-
 arch/sparc/vdso/Makefile                           |  27 --
 arch/um/drivers/line.c                             |  14 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/drivers/vector_kern.c                      |   2 +-
 arch/um/include/asm/kasan.h                        |   1 -
 arch/um/include/asm/mmu.h                          |   2 -
 arch/um/include/asm/processor-generic.h            |   1 -
 arch/um/include/shared/kern_util.h                 |   2 +
 arch/um/include/shared/skas/mm_id.h                |   2 +
 arch/um/os-Linux/mem.c                             |   1 +
 arch/x86/Kconfig                                   |   8 +-
 arch/x86/Kconfig.debug                             |   5 +-
 arch/x86/Makefile                                  |   7 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/crypto/nh-avx2-x86_64.S                   |   1 +
 arch/x86/crypto/sha256-avx2-asm.S                  |   1 +
 arch/x86/crypto/sha512-avx2-asm.S                  |   1 +
 arch/x86/entry/vdso/Makefile                       |  27 --
 arch/x86/entry/vsyscall/vsyscall_64.c              |  28 +-
 arch/x86/include/asm/cmpxchg_64.h                  |   2 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +
 arch/x86/include/asm/processor.h                   |   1 -
 arch/x86/include/asm/sparsemem.h                   |   2 -
 arch/x86/kernel/apic/vector.c                      |   9 +-
 arch/x86/kernel/tsc_sync.c                         |   6 +-
 arch/x86/kvm/cpuid.c                               |  21 +-
 arch/x86/lib/x86-opcode-map.txt                    |  10 +-
 arch/x86/mm/fault.c                                |  33 +-
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/mm/pat/set_memory.c                       |  68 ++-
 arch/x86/net/bpf_jit_comp.c                        |  57 ++-
 arch/x86/pci/mmconfig-shared.c                     |  40 +-
 arch/x86/purgatory/Makefile                        |   3 +-
 arch/x86/tools/relocs.c                            |   9 +
 arch/x86/um/shared/sysdep/archsetjmp.h             |   7 +
 arch/x86/xen/enlighten.c                           |  33 ++
 block/blk-cgroup.c                                 |  87 ++--
 block/blk-core.c                                   |   9 +-
 block/blk-merge.c                                  |   2 +
 block/blk-mq.c                                     |   4 +
 block/blk.h                                        |   1 +
 block/fops.c                                       |   2 +-
 block/genhd.c                                      |   2 +-
 block/partitions/cmdline.c                         |  49 +--
 crypto/asymmetric_keys/Kconfig                     |   3 +
 drivers/accel/ivpu/ivpu_job.c                      |   3 +-
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/acpi/acpi_lpss.c                           |   1 +
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/acpi/numa/srat.c                           |   5 +
 drivers/base/base.h                                |   9 +-
 drivers/base/bus.c                                 |   9 +-
 drivers/base/module.c                              |  42 +-
 drivers/block/null_blk/main.c                      |   3 +
 drivers/bluetooth/btmrvl_main.c                    |   9 -
 drivers/bluetooth/btqca.c                          |   4 +-
 drivers/bluetooth/btrsi.c                          |   1 -
 drivers/bluetooth/btsdio.c                         |   8 -
 drivers/bluetooth/btusb.c                          |   5 -
 drivers/bluetooth/hci_bcm4377.c                    |   1 -
 drivers/bluetooth/hci_ldisc.c                      |   6 -
 drivers/bluetooth/hci_serdev.c                     |   5 -
 drivers/bluetooth/hci_uart.h                       |   1 -
 drivers/bluetooth/hci_vhci.c                       |  10 +-
 drivers/bluetooth/virtio_bt.c                      |   2 -
 drivers/char/ppdev.c                               |  21 +-
 drivers/char/tpm/tpm_tis_spi_main.c                |   3 +-
 drivers/clk/clk-renesas-pcie.c                     |  10 +-
 drivers/clk/mediatek/clk-mt8365-mm.c               |   2 +-
 drivers/clk/mediatek/clk-pllfh.c                   |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   1 -
 drivers/clk/qcom/dispcc-sm6350.c                   |  11 +-
 drivers/clk/qcom/dispcc-sm8450.c                   |  20 +-
 drivers/clk/qcom/dispcc-sm8550.c                   |  20 +-
 drivers/clk/qcom/mmcc-msm8998.c                    |   8 +
 drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r9a07g043-cpg.c                |   9 +
 drivers/clk/samsung/clk-exynosautov9.c             |   8 +-
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |   5 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/cpufreq/cpufreq.c                          |  11 +-
 drivers/crypto/bcm/spu2.c                          |   2 +-
 drivers/crypto/ccp/sp-platform.c                   |  14 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   2 +
 drivers/cxl/core/region.c                          |   1 +
 drivers/cxl/core/trace.h                           |   4 +-
 drivers/dma-buf/st-dma-fence-chain.c               |  12 +-
 drivers/dma-buf/st-dma-fence.c                     |   4 +-
 drivers/dma-buf/sync_debug.c                       |   4 +-
 drivers/dma/idma64.c                               |   4 +-
 drivers/dma/idxd/cdev.c                            |   1 -
 drivers/extcon/Kconfig                             |   3 +-
 drivers/firmware/dmi-id.c                          |   7 +-
 drivers/firmware/efi/libstub/fdt.c                 |   4 +-
 drivers/firmware/efi/libstub/x86-stub.c            |  28 +-
 drivers/firmware/qcom_scm.c                        |  10 +-
 drivers/firmware/raspberrypi.c                     |   7 +-
 drivers/fpga/dfl-pci.c                             |   3 +
 drivers/fpga/fpga-bridge.c                         |  57 +--
 drivers/fpga/fpga-mgr.c                            |  82 ++--
 drivers/fpga/fpga-region.c                         |  24 +-
 drivers/gpio/gpiolib-acpi.c                        |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  16 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   8 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 +
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |   8 +
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |  15 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   5 +
 .../gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c   |   2 +
 .../display/dc/link/protocols/link_dp_dpia_bw.c    |  10 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |  25 ++
 drivers/gpu/drm/arm/malidp_mw.c                    |   5 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  15 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   3 +
 drivers/gpu/drm/bridge/chipone-icn6211.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/bridge/tc358775.c                  |  27 +-
 drivers/gpu/drm/bridge/ti-dlpc3433.c               |  17 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   1 -
 drivers/gpu/drm/ci/build.yml                       |   1 +
 drivers/gpu/drm/ci/gitlab-ci.yml                   |  22 +-
 drivers/gpu/drm/ci/image-tags.yml                  |   2 +-
 drivers/gpu/drm/ci/lava-submit.sh                  |   2 +-
 drivers/gpu/drm/ci/test.yml                        |  27 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |  35 ++
 drivers/gpu/drm/drm_bridge.c                       |  10 +-
 drivers/gpu/drm/drm_edid.c                         |   2 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |   4 +-
 drivers/gpu/drm/i915/display/intel_backlight.c     |   6 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   6 +
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c        |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_types.h           |   8 +
 drivers/gpu/drm/i915/gt/selftest_migrate.c         |   4 +-
 drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h      |   6 +-
 drivers/gpu/drm/i915/gvt/interrupt.c               |  13 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   3 +
 drivers/gpu/drm/meson/meson_dw_mipi_dsi.c          |   7 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_irq.h       |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  30 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h   |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |  11 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   4 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  16 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  | 131 +++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h  |  18 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |  20 +
 drivers/gpu/drm/msm/dp/dp_aux.h                    |   1 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   6 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   4 +
 drivers/gpu/drm/msm/dp/dp_link.c                   |  22 +-
 drivers/gpu/drm/msm/dp/dp_link.h                   |  14 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  10 +-
 drivers/gpu/drm/mxsfb/lcdif_drv.c                  |   6 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |  12 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  44 +-
 drivers/gpu/drm/omapdrm/Kconfig                    |   2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |  40 +-
 drivers/gpu/drm/panel/panel-edp.c                  |   3 +
 drivers/gpu/drm/panel/panel-novatek-nt35950.c      |   6 +-
 drivers/gpu/drm/panel/panel-samsung-atna33xc20.c   |  24 +-
 drivers/gpu/drm/panel/panel-simple.c               |   3 +
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c     |  16 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  22 +-
 drivers/gpu/drm/solomon/ssd130x.c                  |   2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   2 +
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |   7 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |  10 +
 drivers/hid/hid-mcp2221.c                          |   2 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   5 +
 drivers/hwmon/intel-m10-bmc-hwmon.c                |   2 +-
 drivers/hwmon/pwm-fan.c                            |   8 +-
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  29 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |  31 +-
 drivers/hwtracing/stm/core.c                       |  11 +-
 drivers/i2c/busses/i2c-cadence.c                   |   1 +
 drivers/i2c/busses/i2c-synquacer.c                 |  18 +-
 drivers/i3c/master/svc-i3c-master.c                |  36 +-
 drivers/iio/Kconfig                                |   9 +
 drivers/iio/Makefile                               |   1 +
 drivers/iio/accel/mxc4005.c                        |  76 ++++
 drivers/iio/adc/Kconfig                            |   6 +-
 drivers/iio/adc/ad9467.c                           | 310 ++++++++-----
 drivers/iio/adc/adi-axi-adc.c                      | 478 +++++++--------------
 drivers/iio/adc/stm32-adc.c                        |   1 +
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   8 +-
 drivers/iio/industrialio-backend.c                 | 418 ++++++++++++++++++
 drivers/iio/industrialio-core.c                    |   6 +-
 drivers/iio/pressure/dps310.c                      |  11 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  59 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   7 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           | 208 +++++----
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |  34 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  19 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |  46 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |  67 ++-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  24 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   7 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  15 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   6 +-
 drivers/infiniband/hw/mlx5/mem.c                   |   8 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   3 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   6 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  12 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   8 +-
 drivers/input/input.c                              | 104 ++++-
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/misc/da7280.c                        |   4 +-
 drivers/input/misc/ims-pcu.c                       |   4 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   7 +-
 drivers/input/misc/pwm-beeper.c                    |   4 +-
 drivers/input/misc/pwm-vibra.c                     |   8 +-
 drivers/input/mouse/cyapa.c                        |  12 +-
 drivers/interconnect/qcom/qcm2290.c                |   2 +-
 drivers/iommu/iommu.c                              |  21 +-
 drivers/irqchip/irq-alpine-msi.c                   |   2 +-
 drivers/irqchip/irq-loongson-pch-msi.c             |   2 +-
 drivers/leds/leds-pwm.c                            |  10 +-
 drivers/leds/rgb/leds-pwm-multicolor.c             |   4 +-
 drivers/macintosh/via-macii.c                      |  11 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/media/cec/core/cec-adap.c                  |  24 +-
 drivers/media/cec/core/cec-api.c                   |   5 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   4 +-
 drivers/media/i2c/ov2680.c                         |  13 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  10 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |  26 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc.c       |  21 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c    |  20 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h    |   3 +-
 .../platform/mediatek/vcodec/encoder/venc_drv_if.c |  11 +-
 drivers/media/platform/renesas/rcar-vin/rcar-vin.h |   2 +-
 drivers/media/platform/renesas/vsp1/vsp1_pipe.c    |   2 +-
 drivers/media/platform/renesas/vsp1/vsp1_rpf.c     |  10 +-
 drivers/media/platform/renesas/vsp1/vsp1_rwpf.c    |   8 +-
 drivers/media/platform/renesas/vsp1/vsp1_rwpf.h    |   4 +-
 drivers/media/platform/renesas/vsp1/vsp1_wpf.c     |  29 +-
 .../platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig    |   1 +
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/rc/ir-rx51.c                         |   4 +-
 drivers/media/rc/pwm-ir-tx.c                       |   4 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  20 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  31 ++
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-subdev.c              |  39 +-
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/misc/lkdtm/perms.c                         |   2 +-
 drivers/misc/pvpanic/pvpanic-mmio.c                |  58 +--
 drivers/misc/pvpanic/pvpanic-pci.c                 |  60 +--
 drivers/misc/pvpanic/pvpanic.c                     |  76 +++-
 drivers/misc/pvpanic/pvpanic.h                     |  10 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |  10 +-
 drivers/mmc/host/sdhci_am654.c                     | 205 ++++++---
 drivers/mtd/mtdcore.c                              |   6 +-
 drivers/mtd/nand/raw/nand_hynix.c                  |   2 +-
 drivers/net/Makefile                               |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  50 ++-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   6 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  89 ++++
 drivers/net/dsa/mv88e6xxx/global1.h                |   2 +
 drivers/net/ethernet/amazon/ena/ena_com.c          | 326 +++++---------
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |  49 +--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h      |  15 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  32 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 +
 drivers/net/ethernet/cortina/gemini.c              |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  36 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |  14 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  19 +-
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c  |  11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |  56 +--
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  46 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   6 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  18 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  12 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   9 +-
 drivers/net/ethernet/smsc/smc91x.h                 |   4 +-
 drivers/net/ethernet/sun/sungem.c                  |  14 -
 drivers/net/ethernet/ti/icssg/icssg_classifier.c   |   2 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  14 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   4 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c     |   8 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   4 +-
 drivers/net/phy/micrel.c                           |  14 +-
 drivers/net/usb/aqc111.c                           |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/usb/smsc95xx.c                         |  26 +-
 drivers/net/usb/sr9700.c                           |  10 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 +
 drivers/net/wireless/ath/ath10k/core.c             |   3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  26 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   9 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  32 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  19 +-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   2 +
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |  46 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   6 +-
 drivers/net/xen-netback/interface.c                |   3 +-
 drivers/nvme/host/core.c                           |  23 +-
 drivers/nvme/host/multipath.c                      |   6 +-
 drivers/nvme/host/nvme.h                           |  22 +
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/nvme/target/auth.c                         |   8 +-
 drivers/nvme/target/configfs.c                     |  20 +
 drivers/nvme/target/core.c                         |   5 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/tcp.c                          |  11 +-
 drivers/of/module.c                                |   7 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   3 +
 drivers/pci/of_property.c                          |   2 +
 drivers/pci/pci.c                                  |   2 +-
 drivers/pci/pcie/edr.c                             |  28 +-
 drivers/perf/arm_dmc620_pmu.c                      |   9 +-
 drivers/perf/hisilicon/hisi_pcie_pmu.c             |  14 +-
 drivers/perf/hisilicon/hns3_pmu.c                  |  16 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |   2 -
 drivers/pinctrl/qcom/pinctrl-sm7150.c              |  20 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |   1 +
 drivers/platform/x86/intel/tpmi.c                  |   7 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   7 +
 drivers/platform/x86/lenovo-yogabook.c             |   2 +-
 drivers/platform/x86/thinkpad_acpi.c               |   5 +-
 drivers/pwm/core.c                                 |  18 +-
 drivers/pwm/pwm-sti.c                              |  46 +-
 drivers/pwm/pwm-twl-led.c                          |   2 +-
 drivers/pwm/pwm-vt8500.c                           |   2 +-
 drivers/pwm/sysfs.c                                |  10 +-
 drivers/regulator/bd71828-regulator.c              |  58 +--
 drivers/regulator/helpers.c                        |  43 +-
 drivers/regulator/irq_helpers.c                    |   3 +
 drivers/regulator/pwm-regulator.c                  |   4 +-
 drivers/regulator/qcom-refgen-regulator.c          |   1 +
 drivers/regulator/tps6287x-regulator.c             |   1 +
 drivers/regulator/tps6594-regulator.c              |  16 +-
 drivers/regulator/vqmmc-ipq4019-regulator.c        |   1 +
 drivers/s390/cio/trace.h                           |   2 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   2 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   5 +-
 drivers/soc/qcom/pmic_glink.c                      |  26 +-
 drivers/soundwire/cadence_master.c                 |   2 +-
 drivers/spi/spi-stm32.c                            |   2 +-
 drivers/spi/spi.c                                  |   4 +
 drivers/staging/greybus/arche-apb-ctrl.c           |   1 +
 drivers/staging/greybus/arche-platform.c           |   9 +-
 drivers/staging/greybus/light.c                    |   8 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |   1 +
 drivers/thermal/qcom/tsens.c                       |   2 +-
 drivers/tty/n_gsm.c                                | 140 ++++--
 drivers/tty/serial/8250/8250_bcm7271.c             |  99 +++--
 drivers/tty/serial/8250/8250_mtk.c                 |   8 +-
 drivers/tty/serial/max3100.c                       |  22 +-
 drivers/tty/serial/sc16is7xx.c                     |  27 +-
 drivers/tty/serial/sh-sci.c                        |   5 +
 drivers/ufs/core/ufs-mcq.c                         |   3 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/ufs/host/cdns-pltfrm.c                     |   2 +-
 drivers/ufs/host/ufs-qcom.c                        |   7 +-
 drivers/ufs/host/ufs-qcom.h                        |  12 +-
 drivers/usb/fotg210/fotg210-core.c                 |   1 +
 drivers/usb/gadget/function/u_audio.c              |  21 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  18 +-
 drivers/usb/usbip/usbip_common.h                   |   6 -
 drivers/vfio/pci/vfio_pci_intrs.c                  |   4 +-
 drivers/video/backlight/lm3630a_bl.c               |   2 +-
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/backlight/pwm_bl.c                   |  12 +-
 drivers/video/fbdev/Kconfig                        |   4 +-
 drivers/video/fbdev/core/Kconfig                   |  12 +
 drivers/video/fbdev/core/Makefile                  |   3 +-
 drivers/video/fbdev/core/fb_io_fops.c              |   3 +
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   3 +-
 drivers/video/fbdev/ssd1307fb.c                    |   2 +-
 drivers/virt/acrn/mm.c                             |  61 ++-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/bd9576_wdt.c                      |  12 +-
 drivers/watchdog/cpu5wdt.c                         |   2 +-
 drivers/watchdog/sa1100_wdt.c                      |   5 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  36 +-
 fs/dlm/ast.c                                       |  14 +
 fs/dlm/dlm_internal.h                              |   1 +
 fs/dlm/user.c                                      |  15 +-
 fs/ecryptfs/keystore.c                             |   4 +-
 fs/eventpoll.c                                     |  38 +-
 fs/ext4/inode.c                                    |   3 -
 fs/ext4/mballoc.c                                  |   1 +
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/checkpoint.c                               |  10 +-
 fs/f2fs/compress.c                                 |  64 ++-
 fs/f2fs/data.c                                     | 148 +++----
 fs/f2fs/debug.c                                    |   6 +-
 fs/f2fs/dir.c                                      |   5 +-
 fs/f2fs/f2fs.h                                     | 165 +++----
 fs/f2fs/file.c                                     | 134 +++---
 fs/f2fs/gc.c                                       | 119 ++---
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/node.h                                     |   4 +-
 fs/f2fs/recovery.c                                 |   2 +-
 fs/f2fs/segment.c                                  | 248 +++++------
 fs/f2fs/segment.h                                  |  66 ++-
 fs/f2fs/super.c                                    | 116 +----
 fs/f2fs/sysfs.c                                    |   6 +-
 fs/gfs2/acl.h                                      |   8 +-
 fs/gfs2/aops.c                                     |  36 +-
 fs/gfs2/aops.h                                     |   6 +-
 fs/gfs2/bmap.c                                     |   4 +-
 fs/gfs2/bmap.h                                     |  38 +-
 fs/gfs2/dir.c                                      |   2 +-
 fs/gfs2/dir.h                                      |  38 +-
 fs/gfs2/file.c                                     |   2 +-
 fs/gfs2/glock.c                                    |  97 +++--
 fs/gfs2/glock.h                                    |  99 ++---
 fs/gfs2/glops.c                                    |   5 +-
 fs/gfs2/glops.h                                    |   4 +-
 fs/gfs2/incore.h                                   |   3 +-
 fs/gfs2/inode.c                                    |  15 +-
 fs/gfs2/inode.h                                    |  48 +--
 fs/gfs2/lock_dlm.c                                 |  40 +-
 fs/gfs2/log.c                                      |  21 +-
 fs/gfs2/log.h                                      |  46 +-
 fs/gfs2/lops.h                                     |  22 +-
 fs/gfs2/meta_io.c                                  |   9 +-
 fs/gfs2/meta_io.h                                  |  20 +-
 fs/gfs2/ops_fstype.c                               |  28 +-
 fs/gfs2/quota.c                                    |   8 +-
 fs/gfs2/quota.h                                    |  35 +-
 fs/gfs2/recovery.c                                 |   2 +-
 fs/gfs2/recovery.h                                 |  18 +-
 fs/gfs2/rgrp.c                                     |  12 +-
 fs/gfs2/rgrp.h                                     |  81 ++--
 fs/gfs2/super.c                                    |  19 +-
 fs/gfs2/super.h                                    |  50 +--
 fs/gfs2/sys.c                                      |   2 +-
 fs/gfs2/trans.c                                    |   2 +-
 fs/gfs2/trans.h                                    |  22 +-
 fs/gfs2/util.c                                     |   5 +-
 fs/gfs2/util.h                                     |  23 +-
 fs/gfs2/xattr.c                                    |   6 +-
 fs/gfs2/xattr.h                                    |  12 +-
 fs/jffs2/xattr.c                                   |   3 +
 fs/nfs/filelayout/filelayout.c                     |   4 +-
 fs/nfs/fs_context.c                                |   9 +-
 fs/nfs/nfs4state.c                                 |  12 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  63 ++-
 fs/ntfs3/dir.c                                     |   1 +
 fs/ntfs3/fslog.c                                   |   3 +-
 fs/ntfs3/index.c                                   |   6 +
 fs/ntfs3/inode.c                                   |  24 +-
 fs/ntfs3/ntfs.h                                    |   2 +-
 fs/ntfs3/record.c                                  |  11 +-
 fs/ntfs3/super.c                                   |   2 -
 fs/openpromfs/inode.c                              |   8 +-
 fs/overlayfs/dir.c                                 |   3 -
 fs/smb/server/mgmt/share_config.c                  |   6 +-
 fs/smb/server/oplock.c                             |  21 +-
 fs/smb/server/smb2pdu.c                            |   4 +-
 fs/tracefs/event_inode.c                           | 156 +++++--
 fs/tracefs/internal.h                              |   9 +-
 fs/udf/inode.c                                     |  27 +-
 include/drm/display/drm_dp_helper.h                |   6 +
 include/drm/drm_displayid.h                        |   1 -
 include/drm/drm_mipi_dsi.h                         |   6 +-
 include/linux/acpi.h                               |   2 +-
 include/linux/bitops.h                             |   1 +
 include/linux/counter.h                            |   1 -
 include/linux/cpu.h                                |  11 +
 include/linux/dev_printk.h                         |  25 +-
 include/linux/f2fs_fs.h                            |   6 -
 include/linux/fb.h                                 |   4 +
 include/linux/fortify-string.h                     |  22 +-
 include/linux/fpga/fpga-bridge.h                   |  10 +-
 include/linux/fpga/fpga-mgr.h                      |  26 +-
 include/linux/fpga/fpga-region.h                   |  13 +-
 include/linux/i3c/device.h                         |   2 +
 include/linux/ieee80211.h                          |   2 +-
 include/linux/iio/adc/adi-axi-adc.h                |  68 ---
 include/linux/iio/backend.h                        |  72 ++++
 include/linux/iio/buffer-dmaengine.h               |   3 +
 include/linux/kthread.h                            |   1 +
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 include/linux/numa.h                               |  26 +-
 include/linux/nvme-tcp.h                           |   6 +
 include/linux/printk.h                             |   2 +-
 include/linux/pwm.h                                |  28 +-
 include/linux/regulator/driver.h                   |   3 +
 include/linux/tracefs.h                            |   3 +
 include/media/cec.h                                |   1 +
 include/media/v4l2-subdev.h                        |   4 +-
 include/net/ax25.h                                 |   3 +-
 include/net/bluetooth/hci.h                        | 114 -----
 include/net/bluetooth/hci_core.h                   |  46 +-
 include/net/bluetooth/hci_sync.h                   |   2 +
 include/net/bluetooth/l2cap.h                      |  11 +-
 include/net/mac80211.h                             |   3 +
 include/net/tcp.h                                  |  11 +-
 include/sound/cs35l56.h                            |   1 +
 include/sound/soc-acpi-intel-match.h               |   2 +
 include/sound/tas2781-dsp.h                        |   7 +-
 include/trace/events/asoc.h                        |   2 +
 include/uapi/drm/nouveau_drm.h                     |  21 +
 include/uapi/linux/bpf.h                           |   2 +-
 include/uapi/linux/user_events.h                   |  11 +-
 include/uapi/linux/virtio_bt.h                     |   1 -
 include/uapi/rdma/bnxt_re-abi.h                    |  10 +
 io_uring/io-wq.c                                   |  13 +-
 io_uring/io_uring.h                                |   2 +-
 io_uring/nop.c                                     |   2 +
 kernel/Makefile                                    |   1 +
 kernel/bpf/syscall.c                               |   5 +
 kernel/bpf/verifier.c                              |  39 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/cpu.c                                       |  14 +-
 kernel/dma/map_benchmark.c                         |  22 +-
 kernel/gen_kheaders.sh                             |   7 +-
 kernel/irq/cpuhotplug.c                            |  16 +-
 kernel/irq/manage.c                                |  15 +-
 kernel/kthread.c                                   |  18 +
 kernel/numa.c                                      |  26 ++
 kernel/rcu/tasks.h                                 |   2 +-
 kernel/rcu/tree_stall.h                            |   3 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/fair.c                                |  53 ++-
 kernel/sched/isolation.c                           |   7 +-
 kernel/sched/topology.c                            |   2 +-
 kernel/smpboot.c                                   |   3 +-
 kernel/softirq.c                                   |  12 +-
 kernel/trace/ftrace.c                              |  39 +-
 kernel/trace/ring_buffer.c                         |   9 +
 kernel/trace/rv/rv.c                               |   2 +
 kernel/trace/trace_events.c                        |  12 +
 kernel/trace/trace_events_user.c                   | 213 ++++++---
 kernel/trace/trace_probe.c                         |   4 +
 lib/fortify_kunit.c                                |  16 +-
 lib/kunit/try-catch.c                              |   9 +-
 lib/slub_kunit.c                                   |   2 +-
 lib/test_hmm.c                                     |   8 +-
 mm/damon/core.c                                    |   3 +-
 mm/userfaultfd.c                                   |  35 ++
 net/ax25/ax25_dev.c                                |  48 +--
 net/bluetooth/hci_conn.c                           |  10 +-
 net/bluetooth/hci_core.c                           | 135 +-----
 net/bluetooth/hci_event.c                          | 310 -------------
 net/bluetooth/hci_sock.c                           |   9 +-
 net/bluetooth/hci_sync.c                           | 138 +-----
 net/bluetooth/l2cap_core.c                         |  77 ++--
 net/bluetooth/l2cap_sock.c                         |  91 +++-
 net/bluetooth/mgmt.c                               |  84 ++--
 net/bridge/br_device.c                             |   6 +
 net/bridge/br_mst.c                                |  16 +-
 net/core/dev.c                                     |   3 +-
 net/core/pktgen.c                                  |   3 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +
 net/ipv4/tcp_dctcp.c                               |  13 +-
 net/ipv4/tcp_ipv4.c                                |  13 +-
 net/ipv4/udp.c                                     |  21 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/seg6.c                                    |   5 +-
 net/ipv6/seg6_hmac.c                               |  42 +-
 net/ipv6/seg6_iptunnel.c                           |  11 +-
 net/ipv6/udp.c                                     |  20 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/rate.c                                |   6 +-
 net/mac80211/scan.c                                |   1 +
 net/mac80211/tx.c                                  |  13 +-
 net/mptcp/sockopt.c                                |   2 -
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/nfnetlink_queue.c                    |   2 +
 net/netfilter/nft_fib.c                            |   8 +-
 net/netfilter/nft_payload.c                        |  95 +++-
 net/netrom/nr_route.c                              |  19 +-
 net/nfc/nci/core.c                                 |  18 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/flow.c                             |   3 +-
 net/packet/af_packet.c                             |   3 +-
 net/qrtr/ns.c                                      |  27 ++
 net/sched/sch_taprio.c                             |  14 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  10 +-
 net/sunrpc/clnt.c                                  |   1 +
 net/sunrpc/svc.c                                   |   2 -
 net/sunrpc/xprtrdma/verbs.c                        |   6 +-
 net/tls/tls_main.c                                 |  10 +-
 net/unix/af_unix.c                                 |  49 ++-
 net/wireless/nl80211.c                             |  14 +-
 net/wireless/trace.h                               |   4 +-
 scripts/Makefile.vdsoinst                          |  45 ++
 scripts/kconfig/symbol.c                           |   6 +-
 scripts/module.lds.S                               |   1 +
 sound/core/init.c                                  |  20 +-
 sound/core/jack.c                                  |  46 +-
 sound/core/seq/seq_ump_convert.c                   |  46 +-
 sound/core/timer.c                                 |  10 +
 sound/hda/intel-dsp-config.c                       |  27 +-
 sound/pci/emu10k1/io.c                             |   1 +
 sound/pci/hda/cs35l56_hda.c                        |  26 +-
 sound/pci/hda/hda_cs_dsp_ctl.c                     |  47 +-
 sound/pci/hda/patch_realtek.c                      |   5 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l41.c                         |  28 +-
 sound/soc/codecs/cs35l56-shared.c                  |  41 ++
 sound/soc/codecs/cs35l56.c                         |  21 +
 sound/soc/codecs/cs42l43.c                         |   5 +-
 sound/soc/codecs/da7219-aad.c                      |   6 +-
 sound/soc/codecs/rt5645.c                          |  25 ++
 sound/soc/codecs/rt715-sdca.c                      |   8 +-
 sound/soc/codecs/rt715-sdw.c                       |   1 +
 sound/soc/codecs/rt722-sdca.c                      |  27 +-
 sound/soc/codecs/rt722-sdca.h                      |   3 +
 sound/soc/codecs/tas2552.c                         |  15 +-
 sound/soc/codecs/tas2781-fmwlib.c                  | 109 ++---
 sound/soc/codecs/tas2781-i2c.c                     |   4 +-
 sound/soc/intel/avs/boards/ssm4567.c               |   1 -
 sound/soc/intel/avs/cldma.c                        |   2 +-
 sound/soc/intel/avs/path.c                         |   1 +
 sound/soc/intel/avs/probes.c                       |  14 +-
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/bxt_rt298.c                 |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  24 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   2 +
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/kbl_da7219_max98927.c       |   4 +
 sound/soc/intel/boards/kbl_rt5660.c                |   1 +
 sound/soc/intel/boards/kbl_rt5663_max98927.c       |   2 +
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   2 +
 sound/soc/intel/boards/skl_nau88l25_max98357a.c    |   1 +
 sound/soc/intel/boards/skl_rt286.c                 |   1 +
 sound/soc/intel/common/Makefile                    |   1 +
 sound/soc/intel/common/soc-acpi-intel-arl-match.c  |  51 +++
 sound/soc/kirkwood/kirkwood-dma.c                  |   3 +
 sound/soc/mediatek/common/mtk-soundcard-driver.c   |   6 +-
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |   4 +-
 sound/soc/sof/intel/hda.h                          |   1 +
 sound/soc/sof/intel/lnl.c                          |   3 +-
 sound/soc/sof/intel/lnl.h                          |  15 +
 sound/soc/sof/intel/mtl.c                          |  87 +++-
 sound/soc/sof/intel/mtl.h                          |   4 +-
 sound/soc/sof/intel/pci-mtl.c                      |  31 ++
 sound/soc/sof/ipc3-pcm.c                           |   1 +
 sound/soc/sof/pcm.c                                |  13 +-
 sound/soc/sof/sof-audio.h                          |   2 +
 tools/arch/x86/intel_sdsi/intel_sdsi.c             |  48 ++-
 tools/arch/x86/lib/x86-opcode-map.txt              |  10 +-
 tools/bpf/bpftool/common.c                         |  96 ++++-
 tools/bpf/bpftool/iter.c                           |   2 +-
 tools/bpf/bpftool/main.h                           |   3 +-
 tools/bpf/bpftool/prog.c                           |   5 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |   4 +-
 tools/bpf/bpftool/struct_ops.c                     |   2 +-
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/include/nolibc/stdlib.h                      |   2 +-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/perf/evlist.c                            |   9 +
 tools/lib/perf/include/internal/evlist.h           |   2 +
 tools/lib/subcmd/parse-options.c                   |   8 +-
 tools/perf/Documentation/perf-list.txt             |   1 +
 tools/perf/arch/arm64/util/pmu.c                   |   6 +-
 tools/perf/bench/inject-buildid.c                  |   2 +-
 tools/perf/bench/uprobe.c                          |   2 +-
 tools/perf/builtin-annotate.c                      |  46 +-
 tools/perf/builtin-daemon.c                        |   4 +-
 tools/perf/builtin-inject.c                        |   6 +
 tools/perf/builtin-record.c                        |  74 ++--
 tools/perf/builtin-report.c                        |  42 +-
 tools/perf/builtin-sched.c                         |   7 +-
 tools/perf/builtin-top.c                           |  44 +-
 .../pmu-events/arch/s390/cf_z16/transaction.json   |  28 +-
 tools/perf/tests/Build                             |   1 +
 tools/perf/tests/attr/system-wide-dummy            |  14 +-
 tools/perf/tests/attr/test-record-C0               |   4 +-
 tools/perf/tests/builtin-test.c                    |   1 +
 tools/perf/tests/code-reading.c                    |  10 +-
 tools/perf/tests/expr.c                            |  31 +-
 tools/perf/tests/shell/test_arm_coresight.sh       |   2 +-
 tools/perf/tests/tests.h                           |   1 +
 tools/perf/tests/util.c                            |  31 ++
 tools/perf/tests/workloads/datasym.c               |  16 +
 tools/perf/ui/browser.c                            |   6 +-
 tools/perf/ui/browser.h                            |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   8 +-
 tools/perf/ui/gtk/annotate.c                       |   6 +-
 tools/perf/ui/gtk/gtk.h                            |   2 -
 tools/perf/util/annotate.c                         | 190 ++++----
 tools/perf/util/annotate.h                         |  32 +-
 tools/perf/util/event.c                            |   4 +-
 tools/perf/util/evlist.c                           |  18 +
 tools/perf/util/evlist.h                           |   1 +
 tools/perf/util/expr.c                             |   2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   2 +
 tools/perf/util/intel-pt.c                         |   2 +
 tools/perf/util/machine.c                          |  10 +-
 tools/perf/util/maps.c                             | 238 ++++++++++
 tools/perf/util/maps.h                             |  12 +
 tools/perf/util/perf_event_attr_fprintf.c          |  26 +-
 tools/perf/util/pmu.c                              | 147 +++++--
 tools/perf/util/pmu.h                              |  10 +-
 tools/perf/util/pmus.c                             |  20 +-
 tools/perf/util/probe-event.c                      |   1 +
 tools/perf/util/python.c                           |  10 +
 tools/perf/util/session.c                          |   5 +
 tools/perf/util/stat-display.c                     |   3 +
 tools/perf/util/string.c                           |  48 +++
 tools/perf/util/string2.h                          |   1 +
 tools/perf/util/symbol.c                           | 259 +----------
 tools/perf/util/symbol.h                           |   1 -
 tools/perf/util/symbol_conf.h                      |   4 +-
 tools/perf/util/thread.c                           |  14 +-
 tools/perf/util/thread.h                           |  14 +
 tools/perf/util/top.h                              |   1 -
 tools/testing/selftests/bpf/network_helpers.c      |   2 +
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   4 +-
 .../bpf/progs/bench_local_storage_create.c         |   5 +-
 tools/testing/selftests/bpf/progs/local_storage.c  |  20 +-
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |   8 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   8 +-
 tools/testing/selftests/cgroup/cgroup_util.h       |   2 +-
 tools/testing/selftests/cgroup/test_core.c         |   7 +-
 tools/testing/selftests/cgroup/test_cpu.c          |   2 +-
 tools/testing/selftests/cgroup/test_cpuset.c       |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c      |   2 +-
 tools/testing/selftests/cgroup/test_kill.c         |   2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   2 +-
 tools/testing/selftests/cgroup/test_zswap.c        |   2 +-
 .../selftests/filesystems/binderfs/Makefile        |   2 -
 .../ftrace/test.d/dynevent/add_remove_btfarg.tc    |   2 +-
 tools/testing/selftests/kcmp/kcmp_test.c           |   2 +-
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |  50 +++
 tools/testing/selftests/lib.mk                     |  12 +-
 tools/testing/selftests/net/amt.sh                 |  20 +-
 tools/testing/selftests/net/config                 |   7 +-
 .../selftests/net/forwarding/bridge_igmp.sh        |   6 +-
 .../testing/selftests/net/forwarding/bridge_mld.sh |   6 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   8 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  10 +-
 tools/testing/selftests/powerpc/dexcr/Makefile     |   2 +-
 tools/testing/selftests/resctrl/Makefile           |   4 +-
 .../selftests/syscall_user_dispatch/sud_test.c     |  14 +
 .../tc-testing/tc-tests/qdiscs/taprio.json         |  44 ++
 tools/tracing/latency/latency-collector.c          |   8 +-
 875 files changed, 9477 insertions(+), 6744 deletions(-)


