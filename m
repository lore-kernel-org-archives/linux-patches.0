Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045181BD9C6;
	Wed, 19 Mar 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394845; cv=none; b=pIFJ8xbWaTkgoAXJ+OfA3VfWE92WUhFQLSvUJwrkpTSW1jVTmSRQJgaLYMlMLrEqnr9rSrCkkhXLRvd28gYfkBkxn7e3SNdd5vmciAumgu5eft1zcsSxMg5lZP5OxdUl0Ij9zxnizeEepWhaw5yd7cKmDk0E9h4xi60DTNwobvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394845; c=relaxed/simple;
	bh=VXelHwRuyqJKdBU3DHqBw33s/EzvgsI9i7yUjGLxI+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KYKv39To4HPqYJ4kUDmJk7ERC07g7mEnCvGFLsxI0kXkOiV78cMnV9QTb7uYNNUrvnvkfnSFWhpimEpuJO8gF1LLd26UVSTkAt7lhxipBWS2yIOLOKAWX+w+kUpmw/5o87jDsYTJ/ODGVBW7e21wjfr4Hq7iNuKczXMpnQYuUzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbdlLiCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbdlLiCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C50C4CEE8;
	Wed, 19 Mar 2025 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394844;
	bh=VXelHwRuyqJKdBU3DHqBw33s/EzvgsI9i7yUjGLxI+g=;
	h=From:To:Cc:Subject:Date:From;
	b=UbdlLiCssqa+CdCx5ajg5XhhMCLoAbK1jJVqLHX+fiBaOTCIUYe94KnpbVDydOtoV
	 hgvRAn03UddlDbNSDHkAD5R81pQpSYkn3o2t7eHrPfLU9F2uCphUGMOUD4m4G5wtiu
	 OkS1rj7OlyMYaSAPrCfJ9Py1G6MBbgW7oPKCP9i4=
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
Subject: [PATCH 6.13 000/241] 6.13.8-rc1 review
Date: Wed, 19 Mar 2025 07:27:50 -0700
Message-ID: <20250319143027.685727358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.13.8-rc1
X-KernelTest-Deadline: 2025-03-21T14:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.13.8 release.
There are 241 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.13.8-rc1

Max Kellermann <max.kellermann@ionos.com>
    fs/netfs/read_collect: add to next->prev_donated

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: disable Fn key handling on the Omoton KB066

Daniel Wagner <wagi@kernel.org>
    nvme-fc: rely on state transitions to handle connectivity loss

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix corrupted list in hci_chan_del

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/guc: Fix size_t print format

Andrea Righi <arighi@nvidia.com>
    tools/sched_ext: Add helper to check task migration state

Andrea Righi <arighi@nvidia.com>
    sched_ext: selftests/dsp_local_on: Fix selftest on UP systems

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: Fix match_session bug preventing session reuse

Steve French <stfrench@microsoft.com>
    smb3: add support for IAKerb

Ge Yang <yangge1116@126.com>
    mm/hugetlb: wait for hugetlb folios to be freed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: sis630: Fix an error handling path in sis630_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali15x3: Fix an error handling path in ali15x3_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali1535: Fix an error handling path in ali1535_probe()

Ajay Kaher <ajay.kaher@broadcom.com>
    x86/vmware: Parse MP tables for SEV-SNP enabled guests under VMware hypervisors

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing closetimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing actimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acdirmax mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acregmax mount option

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: cdev: use raw notifier for line state events

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: change blk_mq_add_to_batch() third argument type to bool

Tamir Duberstein <tamird@gmail.com>
    scripts: generate_rust_analyzer: add uapi crate

Tamir Duberstein <tamird@gmail.com>
    scripts: generate_rust_analyzer: add missing include_dirs

Tamir Duberstein <tamird@gmail.com>
    scripts: generate_rust_analyzer: add missing macros deps

José Roberto de Souza <jose.souza@intel.com>
    drm/i915: Increase I915_PARAM_MMAP_GTT_VERSION version to indicate support for partial mmaps

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvme: move error logging from nvme_end_req() to __nvme_end_req()

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe/pm: Temporarily disable D3Cold on BMG

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/userptr: Fix an incorrect assert

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe: Release guc ids before cancelling work

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe: cancel pending job timer before freeing scheduler

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: rt722-sdca: add missing readable registers

Alban Kurti <kurti@invicto.ai>
    rust: init: add missing newline to pr_info! calls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Fix maximum ADC Volume

Ivan Abramov <i.abramov@mt-integration.ru>
    drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()

Alban Kurti <kurti@invicto.ai>
    rust: error: add missing newline to pr_warn! calls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: ops: Consistently treat platform_max as control value

Andrea Righi <arighi@nvidia.com>
    sched_ext: Validate prev_cpu in scx_bpf_select_cpu_dfl()

Andrei Botila <andrei.botila@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: add TJA112XB SGMII PCS restart errata

Andrei Botila <andrei.botila@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: add TJA112X PHY configuration errata

Shradha Gupta <shradhagupta@linux.microsoft.com>
    net: mana: cleanup mana struct after debugfs_remove()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix regression with guest option

Haoxiang Li <haoxiang_li2024@163.com>
    qlcnic: fix memory leak issues in qlcnic_sriov_common.c

Piotr Jaroszynski <pjaroszynski@nvidia.com>
    Fix mmu notifiers for range-based invalidates

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    arm64: mm: Populate vmemmap at the page level if not section aligned

Kent Overstreet <kent.overstreet@linux.dev>
    dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature

Mina Almasry <almasrymina@google.com>
    netmem: prevent TX of unreadable skbs

Thomas Mizrahi <thomasmizra@gmail.com>
    ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: Intel: sof_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()

Thorsten Blum <thorsten.blum@linux.dev>
    ASoC: tegra: Fix ADX S24_LE audio format

Peter Griffin <peter.griffin@linaro.org>
    clk: samsung: gs101: fix synchronous external abort in samsung_clk_save()

Varada Pavani <v.pavani@samsung.com>
    clk: samsung: update PLL locktime for PLL142XX used on FSD platform

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent connection release during oplock break notification

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_free_work_struct

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix slab-use-after-free on hdcp_work

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Assign normalized_pix_clk when color depth = 14

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Restore correct backlight brightness after a GPU reset

Aliaksei Urbanski <aliaksei.urbanski@gmail.com>
    drm/amd/display: fix missing .is_two_pixels_per_container

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: fix default brightness

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Disable unneeded hpd interrupts during dm_init

David Rosca <david.rosca@amd.com>
    drm/amdgpu/display: Allow DCC for video formats on GFX12

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/vce2: fix ip block reference

Yifan Zha <Yifan.Zha@amd.com>
    drm/amd/amdkfd: Evict all queues even HWS remove queue failed

Natalie Vock <natalie.vock@gmx.de>
    drm/amdgpu: NULL-check BO's backing store when determining GFX12 PTE flags

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix locking when skipping CSN before topology probing

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/atomic: Filter out redundant DPMS calls

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: fix overindented list items in documentation

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: use `div_ceil` to clean Clippy warning

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Do cdclk post plane programming later

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core: prevent RX overflows when transmit size > FIFO size

Florent Revest <revest@chromium.org>
    x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes

Benno Lossin <benno.lossin@proton.me>
    rust: init: fix `Zeroable` implementation for `Option<NonNull<T>>` and `Option<KBox<T>>`

Matthew Maurer <mmaurer@google.com>
    rust: Disallow BTF generation with Rust + LTO

Tamir Duberstein <tamird@gmail.com>
    rust: alloc: satisfy POSIX alignment requirement

Miguel Ojeda <ojeda@kernel.org>
    rust: remove leftover mentions of the `alloc` crate

Mitchell Levy <levymitchell0@gmail.com>
    rust: lockdep: Remove support for dynamically allocated LockClassKeys

Johan Hovold <johan@kernel.org>
    USB: serial: option: match on interface class for Telit FN990B

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FE990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE990B compositions

Boon Khai Ng <boon.khai.ng@intel.com>
    USB: serial: ftdi_sio: add support for Altera USB Blaster 3

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: fix state transition for SNK_WAIT_CAPABILITIES state in run_state_machine()

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for more devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for several devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add required quirks for missing old boardnames

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for NHxxRZQ

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - rename QH controller to Legion Go S

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - add support for TECNO Pocket Go

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - add support for ZOTAC Gaming Zone

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add multiple supported devices

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - add 8BitDo SN30 Pro, Hyperkin X91 and Gamesir G7 SE controllers

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - preserve system status register

H. Nikolaus Schaller <hns@goldelico.com>
    Input: ads7846 - fix gpiod allocation

Luca Weiss <luca.weiss@fairphone.com>
    Input: goodix-berlin - fix vddio regulator references

Keith Busch <kbusch@kernel.org>
    vhost: return task creation error instead of NULL

Ming Lei <ming.lei@redhat.com>
    block: fix 'kmem_cache of name 'bio-108' already exists'

Frederic Weisbecker <frederic@kernel.org>
    net: Handle napi_schedule() calls from non-interrupt

Thomas Zimmermann <tzimmermann@suse.de>
    drm/nouveau: Do not override forced connector status

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: safety check before fallback

Aaron Ma <aaron.ma@canonical.com>
    perf/x86/rapl: Add support for Intel Arrow Lake U

Arnd Bergmann <arnd@arndb.de>
    x86/irq: Define trace events conditionally

Dmytro Maluka <dmaluka@chromium.org>
    x86/of: Don't use DTB for SMP setup if ACPI is enabled

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Use better start period for frequency mode

Harry Wentland <harry.wentland@amd.com>
    drm/vkms: Round fixp2int conversion in lerp_u16

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: don't check number of sdw links when set dmic_fixup

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: dapm-graph: set fill colour of turned on nodes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't truncate cached, mutated symlink

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Set the SDOUT polarity correctly

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Fix power control mask

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Fix volume scale

Andrew Davis <afd@ti.com>
    phy: ti: gmii-sel: Do not use syscon helper to build regmap

Daniel Wagner <wagi@kernel.org>
    nvme: only allow entering LIVE from CONNECTING state

Yu-Chun Lin <eleanor15x@gmail.com>
    sctp: Fix undefined behavior in left shift operation

Pali Rohár <pali@kernel.org>
    cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes

Pali Rohár <pali@kernel.org>
    cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()

José Roberto de Souza <jose.souza@intel.com>
    drm/xe: Make GUC binaries dump consistent with other binaries in devcoredump

Hector Martin <marcan@marcan.st>
    apple-nvme: Release power domains when probe fails

Ruozhu Li <david.li@jaguarmicro.com>
    nvmet-rdma: recheck queue state is LIVE in state lock in recv done

Christopher Lentocha <christopherericlentocha@gmail.com>
    nvme-pci: quirk Acer FA100 for non-uniqueue identifiers

Uday Shankar <ushankar@purestorage.com>
    io-wq: backoff when retrying worker creation

Stephan Gerhold <stephan.gerhold@linaro.org>
    net: wwan: mhi_wwan_mbim: Silence sequence number glitch errors

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: SOF: amd: Handle IPC replies before FW_BOOT_COMPLETE

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: SOF: amd: Add post_fw_run_delay ACP quirk

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
    ALSA: hda: hda-intel: add Panther Lake-H support

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: pci-ptl: Add support for PTL-H

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
    ALSA: hda: intel-dsp-config: Add PTL-H support

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
    PCI: pci_ids: add INTEL_HDA_PTL_H

Terry Cheong <htcheong@chromium.org>
    ASoC: SOF: Intel: hda: add softdep pre to snd-hda-codec-hdmi module

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ASoC: arizona/madera: use fsleep() in up/down DAPM event delays.

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: adjust convert rate limitation

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't indicate warning on rsnd_kctrl_accept_runtime()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: indicate unsupported clock rate

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on Positivo ARN50

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: simple-card-utils.c: add missing dlc->of_node

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: soc-acpi-intel-mtl-match: declare adr as ull

Uday M Bhat <uday.m.bhat@intel.com>
    ASoC: Intel: sof_sdw: Add support for Fatcat board with BT offload enabled in PTL platform

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add lookup of quirk using PCI subsystem ID

Jiayuan Chen <mrpre@163.com>
    selftests/bpf: Fix invalid flag of recv()

Shigeru Yoshida <syoshida@redhat.com>
    selftests/bpf: Adjust data size to have ETH_HLEN

Maxime Ripard <mripard@kernel.org>
    drm/tests: hdmi: Fix recursive locking

Maxime Ripard <mripard@kernel.org>
    drm/tests: hdmi: Reorder DRM entities variables assignment

Maxime Ripard <mripard@kernel.org>
    drm/tests: hdmi: Remove redundant assignments

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix slab-use-after-free Read in l2cap_send_cmd

Jan Beulich <jbeulich@suse.com>
    Xen/swiotlb: mark xen_swiotlb_fixup() __init

Beata Michalska <beata.michalska@arm.com>
    arm64: amu: Delay allocating cpumask for AMU FIE support

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Set host with kernel mode when switch to VM mode

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix kernel_page_present() for KPRANGE/XKPRANGE

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/cpufreq_cooling: Remove structure member documentation

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Fix CHPID "configure" attribute caching

Sakari Ailus <sakari.ailus@linux.intel.com>
    platform/x86: int3472: Call "reset" GPIO "enable" for INT347E

Sakari Ailus <sakari.ailus@linux.intel.com>
    platform/x86: int3472: Use correct type for "polarity", call it gpio_flags

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Support for V9 DYTC platform profiles

Sybil Isabel Dorsett <sybdorsett@proton.me>
    platform/x86: thinkpad_acpi: Fix invalid fan speed on ThinkPad X120e

Jann Horn <jannh@google.com>
    sched: Clarify wake_up_q()'s write to task->wake_q.next

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Ignore dangling jump table entries

Matthew Wilcox (Oracle) <willy@infradead.org>
    btrfs: fix two misuses of folio_shift()

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: fix up the F6 key on the Omoton KB066 keyboard

Ievgen Vovk <YevgenVovk@ukr.net>
    HID: hid-apple: Apple Magic Keyboard a3203 USB-C support

Bharadwaj Raju <bharadwaj.raju777@gmail.com>
    selftests/cgroup: use bash in test_cpuset_v1_hp.sh

Daniel Brackenbury <daniel.brackenbury@gmail.com>
    HID: topre: Fix n-key rollover on Realforce R3S TKL boards

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: ipc: Add Panther Lake PCI device IDs

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: phy: generic: Use proper helper for property detection

Vicki Pfau <vi@endrift.com>
    HID: hid-steam: Fix issues with disabling both gamepad mode and lizard mode

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: ignore non-functional sensor in HP 5MP Camera

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Send clock sync message immediately after reset

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell

Tejun Heo <tj@kernel.org>
    sched_ext: selftests/dsp_local_on: Fix sporadic failures

Miklos Szeredi <mszeredi@redhat.com>
    selftests: always check mask returned by statmount(2)

Brahmajit Das <brahmajit.xyz@gmail.com>
    vboxsf: fix building with GCC 15

Eric W. Biederman <ebiederm@xmission.com>
    alpha/elf: Fix misc/setarch test of util-linux by removing 32bit support

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix noisy when tree connecting to DFS interlink targets

Gannon Kolding <gannon.kolding@gmail.com>
    ACPI: resource: IRQ override for Eluktronics MECH-17

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: keep symbols for symbol_get() even with CONFIG_TRIM_UNUSED_KSYMS

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix kernel oops when debug level > 2

Seunghui Lee <sh043.lee@samsung.com>
    scsi: ufs: core: Fix error return with query response

Rik van Riel <riel@surriel.com>
    scsi: core: Use GFP_NOIO to avoid circular locking dependency

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix out-of-bound accesses

Dmitry Kandybka <d.kandybka@gmail.com>
    platform/x86/intel: pmc: fix ltr decode in pmc_core_ltr_show()

Christian Loehle <christian.loehle@arm.com>
    sched/debug: Provide slice length for fair tasks

Chengen Du <chengen.du@canonical.com>
    iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()

Xu Lu <luxu.kernel@bytedance.com>
    irqchip/riscv: Ensure ordering of memory writes and IPI writes

Jens Axboe <axboe@kernel.dk>
    futex: Pass in task to futex_queue()

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid starting new transaction when cleaning qgroup during subvolume drop

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    powercap: call put_device() on an error path in powercap_register_control_type()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hrtimers: Mark is_migration_base() with __always_inline

Daniel Wagner <wagi@kernel.org>
    nvme-fc: do not ignore connectivity loss during connecting

Daniel Wagner <wagi@kernel.org>
    nvme-fc: go straight to connecting state when initializing

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5: Bridge, fix the crash caused by LAG state check

Shay Drory <shayd@nvidia.com>
    net/mlx5: Lag, Check shared fdb before creating MultiPort E-Switch

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix incorrect IRQ pool usage when releasing IRQs

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Rightsize bwc matcher priority

Xin Long <lucien.xin@gmail.com>
    Revert "openvswitch: switch to per-action label counting in conntrack"

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove misbehaving actions length check

Guillaume Nault <gnault@redhat.com>
    gre: Fix IPv6 link-local address generation.

Alexey Kashavkin <akashavkin@gmail.com>
    netfilter: nft_exthdr: fix offset with ipv4_find_option()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: Prevent creation of classes with TC_H_ROOT

Dan Carpenter <dan.carpenter@linaro.org>
    ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Kohei Enju <enjuk@amazon.com>
    netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: fix MPDU length parsing for EHT 5/6 GHz

Justin Lai <justinlai0215@realtek.com>
    rtase: Fix improper release of ring list entries in rtase_sw_reset

Hangbin Liu <liuhangbin@gmail.com>
    selftests: bonding: fix incorrect mac address

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix incorrect MAC address setting to receive NS messages

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: unshare packets when reassembling

Amit Cohen <amcohen@nvidia.com>
    net: switchdev: Convert blocking notification chain to a raw one

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix memory leak in queue reset

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix kernel panic in the bnxt_get_queue_stats{rx | tx}

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: do not update checksum in bnxt_xdp_build_skb()

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: do not use BNXT_VNIC_NTUPLE unconditionally in queue restart logic

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: return fail if interface is down in bnxt_queue_mem_alloc()

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix truesize for mb-xdp-pass case

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: handle errors in mlx5_chains_create_table()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()

Saurabh Sengar <ssengar@linux.microsoft.com>
    fbdev: hyperv_fb: Allow graceful removal of framebuffer

Saurabh Sengar <ssengar@linux.microsoft.com>
    fbdev: hyperv_fb: Simplify hvfb_putmem

Michael Kelley <mhklinux@outlook.com>
    fbdev: hyperv_fb: Fix hang in kdump kernel when on Hyper-V Gen 2 VMs

Michael Kelley <mhklinux@outlook.com>
    drm/hyperv: Fix address space leak when Hyper-V DRM device is removed

Breno Leitao <leitao@debian.org>
    netpoll: hold rcu read lock in __netpoll_send_skb()

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp i2c: Copy headers if cloned

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp i3c: Copy headers if cloned

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Verify after ATU Load ops

Jiri Pirko <jiri@resnulli.us>
    net/mlx5: Fill out devlink dev info only for PFs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Revert "Bluetooth: hci_core: Fix sleeping function called from invalid context"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix enabling passive scanning

Pauli Virtanen <pav@iki.fi>
    Bluetooth: SCO: fix sco_conn refcounting on sco_conn_ready

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: cancel wiphy_work before freeing wiphy

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't queue sdata::work for a non-running sdata

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix PNVM timeout for non-MSI-X platforms

Jun Yang <juny24602@gmail.com>
    sched: address a potential NULL pointer dereference in the GRED scheduler.

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: make destruction work queue pernet

Nicklas Bo Jensen <njensen@akamai.com>
    netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix switchdev slow-path in LAG

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix memory leak in aRFS after reset

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: do not configure destination override for switchdev

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.

Charles Han <hanchunchao@inspur.com>
    pinctrl: nuvoton: npcm8xx: Add NULL check in npcm8xx_gpio_fw

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Fix incorrect regmap max_registers value

Michael Kelley <mhklinux@outlook.com>
    fbdev: hyperv_fb: iounmap() the correct memory when removing a device

Alexey Kardashevskiy <aik@amd.com>
    virt: sev-guest: Move SNP Guest Request data pages handling under snp_cmd_mutex

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/slab/kvfree_rcu: Switch to WQ_MEM_RECLAIM wq

Suren Baghdasaryan <surenb@google.com>
    userfaultfd: fix PTE unmapping stack-allocated PTE copies

Barry Song <baohua@kernel.org>
    mm: fix kernel BUG when userfaultfd_move encounters swapcache


-------------

Diffstat:

 Documentation/rust/quick-start.rst                 |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/include/asm/elf.h                       |   6 +-
 arch/alpha/include/asm/pgtable.h                   |   2 +-
 arch/alpha/include/asm/processor.h                 |   8 +-
 arch/alpha/kernel/osf_sys.c                        |  11 +-
 arch/arm64/include/asm/tlbflush.h                  |  22 +--
 arch/arm64/kernel/topology.c                       |  22 ++-
 arch/arm64/mm/mmu.c                                |   5 +-
 arch/loongarch/kvm/switch.S                        |   2 +-
 arch/loongarch/mm/pageattr.c                       |   3 +-
 arch/x86/events/intel/core.c                       |  85 +++++++++
 arch/x86/events/rapl.c                             |   1 +
 arch/x86/include/asm/sev.h                         |   6 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/vmware.c                       |   4 +
 arch/x86/kernel/devicetree.c                       |   3 +-
 arch/x86/kernel/irq.c                              |   2 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 block/bio.c                                        |   2 +-
 drivers/acpi/resource.c                            |   6 +
 drivers/block/null_blk/main.c                      |   4 +-
 drivers/block/virtio_blk.c                         |   5 +-
 drivers/clk/samsung/clk-gs101.c                    |   8 -
 drivers/clk/samsung/clk-pll.c                      |   7 +-
 drivers/firmware/iscsi_ibft.c                      |   5 +-
 drivers/gpio/gpiolib-cdev.c                        |  15 +-
 drivers/gpio/gpiolib.c                             |   8 +-
 drivers/gpio/gpiolib.h                             |   5 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  64 +++++--
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   7 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   7 +-
 .../amd/display/dc/dce60/dce60_timing_generator.c  |   1 +
 .../dc/dml2/dml21/dml21_translation_helper.c       |   4 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |   6 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  40 +++--
 drivers/gpu/drm/drm_atomic_uapi.c                  |   4 +
 drivers/gpu/drm/drm_connector.c                    |   4 +
 drivers/gpu/drm/drm_panic_qr.rs                    |  16 +-
 drivers/gpu/drm/gma500/mid_bios.c                  |   5 +
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c            |   2 +
 drivers/gpu/drm/i915/display/intel_display.c       |   5 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   5 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 -
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 193 ++++++++++-----------
 drivers/gpu/drm/vkms/vkms_composer.c               |   2 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   6 +-
 drivers/gpu/drm/xe/xe_guc_log.c                    |   3 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   4 +-
 drivers/gpu/drm/xe/xe_hmm.c                        |   6 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  13 +-
 drivers/hid/Kconfig                                |   3 +-
 drivers/hid/hid-apple.c                            |  13 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-steam.c                            |   6 +-
 drivers/hid/hid-topre.c                            |   7 +
 drivers/hid/intel-ish-hid/ipc/hw-ish.h             |   2 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |  15 +-
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   7 +
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h        |   2 +
 drivers/hv/vmbus_drv.c                             |  13 ++
 drivers/i2c/busses/i2c-ali1535.c                   |  12 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |  12 +-
 drivers/i2c/busses/i2c-sis630.c                    |  12 +-
 drivers/input/joystick/xpad.c                      |  39 ++++-
 drivers/input/misc/iqs7222.c                       |  50 +++---
 drivers/input/serio/i8042-acpipnpio.h              | 111 ++++++------
 drivers/input/touchscreen/ads7846.c                |   2 +-
 drivers/input/touchscreen/goodix_berlin_core.c     |  24 +--
 drivers/irqchip/irq-riscv-imsic-early.c            |   2 +-
 drivers/irqchip/irq-thead-c900-aclint-sswi.c       |   2 +-
 drivers/md/dm-flakey.c                             |   2 +-
 drivers/net/bonding/bond_options.c                 |  55 +++++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  59 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  25 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   3 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   6 -
 drivers/net/ethernet/intel/ice/ice_lag.c           |  27 +++
 drivers/net/ethernet/intel/ice/ice_lib.c           |  18 --
 drivers/net/ethernet/intel/ice/ice_lib.h           |   4 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   3 +
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.h |   2 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  11 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  10 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   8 +-
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |  10 ++
 drivers/net/mctp/mctp-i2c.c                        |   5 +
 drivers/net/mctp/mctp-i3c.c                        |   5 +
 drivers/net/phy/nxp-c45-tja11xx.c                  |  68 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   6 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   2 +-
 drivers/nvme/host/apple.c                          |   5 +-
 drivers/nvme/host/core.c                           |  14 +-
 drivers/nvme/host/fc.c                             |  59 +------
 drivers/nvme/host/pci.c                            |   7 +-
 drivers/nvme/target/rdma.c                         |  33 ++--
 drivers/phy/ti/phy-gmii-sel.c                      |  15 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c          |   3 +
 drivers/platform/x86/intel/int3472/discrete.c      |  85 ++++++---
 drivers/platform/x86/intel/pmc/core.c              |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |  50 ++++--
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/s390/cio/chp.c                             |   3 +-
 drivers/scsi/qla1280.c                             |   2 +-
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/spi/spi-microchip-core.c                   |  41 ++---
 drivers/thermal/cpufreq_cooling.c                  |   2 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/usb/phy/phy-generic.c                      |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  14 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 ++
 drivers/usb/serial/option.c                        |  48 +++--
 drivers/usb/typec/tcpm/tcpm.c                      |   8 +-
 drivers/vhost/vhost.c                              |   2 +-
 drivers/video/fbdev/hyperv_fb.c                    |  52 ++++--
 drivers/virt/coco/sev-guest/sev-guest.c            |  63 ++++---
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/btrfs/extent_io.c                               |  11 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/namei.c                                         |  24 ++-
 fs/netfs/read_collect.c                            |   2 +-
 fs/smb/client/asn1.c                               |   2 +
 fs/smb/client/cifs_spnego.c                        |   4 +-
 fs/smb/client/cifsglob.h                           |   4 +
 fs/smb/client/connect.c                            |  16 +-
 fs/smb/client/fs_context.c                         |  18 +-
 fs/smb/client/inode.c                              |  13 ++
 fs/smb/client/reparse.c                            |   5 +-
 fs/smb/client/sess.c                               |   3 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/common/smbfsctl.h                           |   3 +
 fs/smb/server/connection.c                         |  20 +++
 fs/smb/server/connection.h                         |   2 +
 fs/smb/server/ksmbd_work.c                         |   3 -
 fs/smb/server/ksmbd_work.h                         |   1 -
 fs/smb/server/oplock.c                             |  43 +++--
 fs/smb/server/oplock.h                             |   1 -
 fs/smb/server/server.c                             |  14 +-
 fs/vboxsf/super.c                                  |   3 +-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/blk-mq.h                             |  16 +-
 include/linux/fs.h                                 |   2 +
 include/linux/hugetlb.h                            |   5 +
 include/linux/module.h                             |   5 +-
 include/linux/pci_ids.h                            |   1 +
 include/net/bluetooth/hci_core.h                   | 108 ++++--------
 include/net/bluetooth/l2cap.h                      |   3 +-
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/sound/soc.h                                |   5 +-
 init/Kconfig                                       |   2 +-
 io_uring/futex.c                                   |   2 +-
 io_uring/io-wq.c                                   |  23 ++-
 kernel/futex/core.c                                |   5 +-
 kernel/futex/futex.h                               |  11 +-
 kernel/futex/pi.c                                  |   2 +-
 kernel/futex/waitwake.c                            |   4 +-
 kernel/rcu/tree.c                                  |  14 +-
 kernel/sched/core.c                                |   5 +-
 kernel/sched/debug.c                               |   2 +
 kernel/sched/ext.c                                 |   3 +
 kernel/time/hrtimer.c                              |  22 +--
 kernel/vhost_task.c                                |   4 +-
 mm/hugetlb.c                                       |   8 +
 mm/page_isolation.c                                |  10 ++
 mm/userfaultfd.c                                   |  91 ++++++++--
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/hci_event.c                          |  37 ++--
 net/bluetooth/iso.c                                |   6 -
 net/bluetooth/l2cap_core.c                         | 181 +++++++++----------
 net/bluetooth/l2cap_sock.c                         |  15 +-
 net/bluetooth/rfcomm/core.c                        |   6 -
 net/bluetooth/sco.c                                |  25 ++-
 net/core/dev.c                                     |   5 +-
 net/core/netpoll.c                                 |   9 +-
 net/ipv6/addrconf.c                                |  15 +-
 net/mac80211/eht.c                                 |   9 +-
 net/mac80211/util.c                                |   8 +-
 net/mctp/route.c                                   |  10 +-
 net/mctp/test/route-test.c                         | 109 ++++++++++++
 net/mptcp/protocol.h                               |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   8 +-
 net/netfilter/nf_conncount.c                       |   6 +-
 net/netfilter/nf_tables_api.c                      |  24 +--
 net/netfilter/nft_compat.c                         |   8 +-
 net/netfilter/nft_ct.c                             |   6 +-
 net/netfilter/nft_exthdr.c                         |  10 +-
 net/openvswitch/conntrack.c                        |  30 ++--
 net/openvswitch/datapath.h                         |   3 +
 net/openvswitch/flow_netlink.c                     |  15 +-
 net/sched/sch_api.c                                |   6 +
 net/sched/sch_gred.c                               |   3 +-
 net/sctp/stream.c                                  |   2 +-
 net/switchdev/switchdev.c                          |  25 ++-
 net/wireless/core.c                                |   7 +
 rust/kernel/alloc/allocator_test.rs                |  18 ++
 rust/kernel/error.rs                               |   2 +-
 rust/kernel/init.rs                                |  23 ++-
 rust/kernel/init/macros.rs                         |   6 +-
 rust/kernel/lib.rs                                 |   2 +-
 rust/kernel/sync.rs                                |  16 +-
 scripts/generate_rust_analyzer.py                  |  71 ++++----
 scripts/mod/modpost.c                              |  35 ++++
 scripts/mod/modpost.h                              |   6 +
 scripts/module.lds.S                               |   1 +
 scripts/rustdoc_test_gen.rs                        |   4 +-
 sound/hda/intel-dsp-config.c                       |   5 +
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/arizona.c                         |  14 +-
 sound/soc/codecs/cs42l43.c                         |   2 +-
 sound/soc/codecs/madera.c                          |  10 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |   4 +
 sound/soc/codecs/tas2764.c                         |  10 +-
 sound/soc/codecs/tas2764.h                         |   8 +-
 sound/soc/codecs/tas2770.c                         |   2 +-
 sound/soc/codecs/wm0010.c                          |  13 +-
 sound/soc/codecs/wm5110.c                          |   8 +-
 sound/soc/generic/simple-card-utils.c              |   1 +
 sound/soc/intel/boards/sof_sdw.c                   |  43 ++++-
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c  |   2 +-
 sound/soc/renesas/rcar/core.c                      |  14 --
 sound/soc/renesas/rcar/rsnd.h                      |   1 -
 sound/soc/renesas/rcar/src.c                       | 116 ++++++++++---
 sound/soc/renesas/rcar/ssi.c                       |   3 +-
 sound/soc/soc-ops.c                                |  15 +-
 sound/soc/sof/amd/acp-ipc.c                        |  23 ++-
 sound/soc/sof/amd/acp.c                            |   1 +
 sound/soc/sof/amd/acp.h                            |   1 +
 sound/soc/sof/amd/vangogh.c                        |  18 ++
 sound/soc/sof/intel/hda-codec.c                    |   1 +
 sound/soc/sof/intel/hda.c                          |  18 +-
 sound/soc/sof/intel/pci-ptl.c                      |   1 +
 sound/soc/tegra/tegra210_adx.c                     |   4 +-
 tools/objtool/check.c                              |   9 +
 tools/sched_ext/include/scx/common.bpf.h           |  11 ++
 tools/sound/dapm-graph                             |   2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   6 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   4 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |   8 +-
 .../testing/selftests/cgroup/test_cpuset_v1_hp.sh  |   2 +-
 .../selftests/drivers/net/bonding/bond_options.sh  |   4 +-
 .../filesystems/statmount/statmount_test.c         |  22 ++-
 .../testing/selftests/sched_ext/dsp_local_on.bpf.c |   2 +-
 266 files changed, 2455 insertions(+), 1273 deletions(-)


