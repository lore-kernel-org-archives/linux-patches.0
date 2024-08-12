Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA226136338;
	Mon, 12 Aug 2024 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479264; cv=none; b=gfZ5PHcSZvxGprRAH4OYm9vv1Wgr7WySeVpXu16fJtlkc+mbfnjsS4naanEHNkds7mB0M7E5z2Fyt9N89hh4Kh2QC6pbZ+ydShYQQMalW3Rys6anqThfNNZoSXxhScm5zfCTu53zjtXify/2ktce47TyEWFlXMlASu4i7COFlo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479264; c=relaxed/simple;
	bh=elu1mg2KnvRQCN8fxpJz5jAs+N7Ecwddb/SLlp9taT0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=btmxFBZwsZUPdsiEYlWwqsmfgJ6AXT7BQm9TKXDIgBH1oAy/MX0TswKNpNN30g70xw/opJykcQ/BfmzqNmeEF7KYG8If55+qp1Ead8pCS1mtlPCzlJ9pbofibWPTVbAXqZT1gOi0VsVnaCOTodBbSVfSFdEgsaEXMKurNhDVx70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyrW9h/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyrW9h/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB4C32782;
	Mon, 12 Aug 2024 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479263;
	bh=elu1mg2KnvRQCN8fxpJz5jAs+N7Ecwddb/SLlp9taT0=;
	h=From:To:Cc:Subject:Date:From;
	b=GyrW9h/9TFmhDtb41/ruC3FTzOAS8Gk5nPZtybimGF+DN34tu4ksJp2wH+kThBkiN
	 vwfOaBKa22WK572bFODISvwR2TRWJBgH61TeNZQXXT0pGF/2EQoalXzxiWJASHVYCL
	 f4qBRM4hSy5jBywAzLzPOMG5mIgrwE5T14I0ABew=
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
Subject: [PATCH 6.6 000/189] 6.6.46-rc1 review
Date: Mon, 12 Aug 2024 18:00:56 +0200
Message-ID: <20240812160132.135168257@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.46-rc1
X-KernelTest-Deadline: 2024-08-14T16:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.46 release.
There are 189 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.46-rc1

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double inode unlock for direct IO sync writes

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    Revert "selftests: mptcp: simult flows: mark 'unbalanced' tests as flaky"

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: test both signal & subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: ability to invert ADD_ADDR check

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: don't try to create sf if alloc failed

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reduce indentation blocks

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Defer handling mst up request in resume

Christoph Hellwig <hch@lst.de>
    xfs: fix log recovery buffer allocation for the legacy h_size fixup

Dave Airlie <airlied@redhat.com>
    nouveau: set placement to original placement on uvmm validate.

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers arm64: Sync arm64's cputype.h with the kernel sources

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix source address selection with route leak

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Filipe Manana <fdmanana@suse.com>
    btrfs: fix corruption after buffer fault in during direct IO append write

Yang Shi <yang@os.amperecomputing.com>
    mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines

Yang Shi <yang@os.amperecomputing.com>
    mm: huge_memory: don't force huge page alignment on 32 bit

Ivan Lipski <ivlipski@amd.com>
    Revert "drm/amd/display: Add NULL check for 'afb' before dereferencing in amdgpu_dm_plane_handle_cursor_update"

Jens Axboe <axboe@kernel.dk>
    block: use the right type for stub rq_integrity_vec()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: deny endp with signal + subflow + port

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: fix error path

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix backup support in signal endpoints

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fully established after ADD_ADDR echo on MPJ

Bill Wendling <morbo@google.com>
    drm/radeon: Remove __counted_by from StateArray.states[]

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Bind I2C lifetime to DRM device

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Set DDC timeout in milliseconds

Dragan Simic <dsimic@manjaro.org>
    drm/lima: Mark simple_ondemand governor as softdep

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Skip CSN if topology probing is not done yet

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: analogix_dp: properly handle zero sized AUX transactions

Yang Yingliang <yangyingliang@huawei.com>
    sched/core: Fix unbalance set_rq_online/offline() in sched_cpu_deactivate()

Yang Yingliang <yangyingliang@huawei.com>
    sched/core: Introduce sched_set_rq_on/offline() helper

Yang Yingliang <yangyingliang@huawei.com>
    sched/smt: Fix unbalance sched_smt_present dec/inc

Yang Yingliang <yangyingliang@huawei.com>
    sched/smt: Introduce sched_smt_present_inc/dec() helper

Andi Kleen <ak@linux.intel.com>
    x86/mtrr: Check if fixed MTRRs exist before saving them

Chen Yu <yu.c.chen@intel.com>
    x86/paravirt: Fix incorrect virt spinlock setting on bare metal

Qu Wenruo <wqu@suse.com>
    btrfs: avoid using fixed char array size for tree names

Nico Pache <npache@redhat.com>
    selftests: mm: add s390 to ARCH check

Mathias Krause <minipli@grsecurity.net>
    eventfs: Use SRCU for freeing eventfs_inodes

Mathias Krause <minipli@grsecurity.net>
    eventfs: Don't return NULL in eventfs_create_dir()

Steve French <stfrench@microsoft.com>
    smb3: fix setting SecurityFlags when encryption is required

Waiman Long <longman@redhat.com>
    padata: Fix possible divide-by-0 panic in padata_mt_helper()

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    tracing: Fix overflow in get_free_elt()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Round constant_charge_voltage writes down

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Fix constant_charge_voltage writes

Neil Armstrong <neil.armstrong@linaro.org>
    power: supply: qcom_battmgr: return EAGAIN when firmware service is not up

Miao Wang <shankerwangmiao@gmail.com>
    LoongArch: Enable general EFI poweroff method

Shay Drory <shayd@nvidia.com>
    genirq/irqdesc: Honor caller provided affinity in alloc_desc()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    irqchip/xilinx: Fix shift out of bounds

Andrey Konovalov <andreyknvl@gmail.com>
    kcov: properly check for softirq context

Takashi Iwai <tiwai@suse.de>
    ASoC: amd: yc: Add quirk entry for OMEN by HP Gaming Laptop 16-n0xxx

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix a possible DMA corruption

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix unaligned accesses in BPF

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: protect concurrent access to mem_cgroup_idr

George Kennedy <george.kennedy@oracle.com>
    serial: core: check uartclk for zero to avoid divide by zero

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Fix bogus clock_was_set() invocation in do_adjtimex()

Justin Stitt <justinstitt@google.com>
    ntp: Safeguard against time_constant overflow

Steven Rostedt <rostedt@goodmis.org>
    tracefs: Use generic inode RCU for synchronizing freeing

Mathias Krause <minipli@grsecurity.net>
    tracefs: Fix inode allocation

Dan Williams <dan.j.williams@intel.com>
    driver core: Fix uevent_show() vs driver detach race

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()

Feng Tang <feng.tang@intel.com>
    clocksource: Scale the watchdog read retries automatically

Justin Stitt <justinstitt@google.com>
    ntp: Clamp maxerror and esterror to operating range

Jason Wang <jasowang@redhat.com>
    vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Move per CPU pointer access into the atomic section

Vamshi Gajjela <vamshigajjela@google.com>
    scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: core: Do not set link to OFF state while waking up from hibernation

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES

Chris Wulff <crwulff@gmail.com>
    usb: gadget: u_audio: Check return codes from usb_ep_enable and config_ep_by_speed.

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Set start_delayed during suspend

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix the response for FB info with block 0xff

Chris Wulff <crwulff@gmail.com>
    usb: gadget: core: Check for unset descriptor

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    USB: serial: debug: do not echo input by default

Oliver Neukum <oneukum@suse.com>
    usb: vhci-hcd: Do not drop references before new references are gained

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks

Steven 'Steve' Kendall <skend@chromium.org>
    ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix racy access to midibuf

Ma Ke <make24@iscas.ac.cn>
    drm/client: fix null pointer dereference in drm_client_modeset_probe

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Adjust vma offset for framebuffer mmap offset

Joshua Ashton <joshua@froggi.es>
    drm/amdgpu: Forward soft recovery errors to userspace

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Skip Recompute DSC Params if no Stream on Link

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Linus Torvalds <torvalds@linux-foundation.org>
    module: make waiting for a concurrent module loader interruptible

Linus Torvalds <torvalds@linux-foundation.org>
    module: warn about excessively long module waits

Gleb Korobeynikov <gkorobeynikov@astralinux.ru>
    cifs: cifs_inval_name_dfs_link_error: correct the check for fullpath

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: fix irq scheduling issue with PREEMPT_RT

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Re-add ScratchAmp quirk entries

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix scldiv calculation

Gaosheng Cui <cuigaosheng1@huawei.com>
    i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume

Gaosheng Cui <cuigaosheng1@huawei.com>
    i2c: qcom-geni: Add missing clk_disable_unprepare in geni_i2c_runtime_resume

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Fix to check symbol prefixes correctly

Menglong Dong <menglong8.dong@gmail.com>
    bpf: kprobe: remove unused declaring of bpf_kprobe_override

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Send alert notifications to all devices if source not found

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: SOF: Remove libraries from topology lookups

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spidev: Add missing spi_device_id for bh2228fv

Jerome Audu <jau@free.fr>
    ASoC: sti: add missing probe entry for player and reader

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa884x: Correct Soundwire ports mask

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa884x: parse port-mapping information

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: Correct Soundwire ports mask

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa883x: parse port-mapping information

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa881x: Correct Soundwire ports mask

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Improve handling of stuck alerts

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround (again)

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A725 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X1C definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Unify speculative SSBS errata logic

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X925 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A720 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Add workaround for Arm errata 3194386 and 3312417

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X4 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: barrier: Restore spec_bar() macro

Besar Wicaksono <bwicaksono@nvidia.com>
    arm64: Add Neoverse-V2 part

Willem de Bruijn <willemb@google.com>
    net: drop bad gso csum_start and offset in virtio_net_hdr

Zheng Zucheng <zhengzucheng@huawei.com>
    sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongarch-cpu: Fix return value of lpic_gsi_to_irq()

Arseniy Krasnov <avkrasnov@salutedevices.com>
    irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to 'raw_spinlock_t'

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    profiling: remove profile=sleep support

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a race to wake a sync task

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Prevent release of buffer in I/O

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: avoid memleak in jbd2_journal_write_metadata_buffer

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix uninitialized variable in ext4_inlinedir_to_tree

Chi Zhiling <chizhiling@kylinos.cn>
    media: xc2028: avoid use-after-free in load_firmware_cb()

Michal Pecio <michal.pecio@gmail.com>
    media: uvcvideo: Fix the bandwdith quirk on USB 3.x

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Ignore empty TS packets

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Add null checker before passing variables

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for 'afb' before dereferencing in amdgpu_dm_plane_handle_cursor_update

Ming Qian <ming.qian@nxp.com>
    media: amphion: Remove lock in s_ctrl callback

Bob Zhou <bob.zhou@amd.com>
    drm/amd/pm: Fix the null pointer dereference for vega10_hwmgr

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Add lock around VF RLCG interface

Jesse Zhang <jesse.zhang@amd.com>
    drm/admgpu: fix dereferencing null pointer context

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the null pointer dereference in apply_state_adjust_rules

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix the null pointer dereference to ras_manager

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the null pointer dereference for smu7

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the param type of set_power_profile_mode

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix potential resource leak warning

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Add delay to improve LTTPR UHBR interop

Luke Wang <ziniu.wang_1@nxp.com>
    Bluetooth: btnxpuart: Shutdown timer and prevent rearming when driver unloading

Filipe Manana <fdmanana@suse.com>
    btrfs: fix bitmap leak when loading free space cache on duplicate entry

Qu Wenruo <wqu@suse.com>
    btrfs: do not clear page dirty inside extent_write_locked_range()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    net: stmmac: qcom-ethqos: enable SGMII loopback during DMA reset on sa8775p-ride-r3

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: tef: update workaround for erratum DS80000789E 6 of mcp2518fd

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: tef: prepare to workaround broken TEF FIFO tail index erratum

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't give key data to userspace

Roman Smirnov <r.smirnov@omp.ru>
    udf: prevent integer overflow in udf_bitmap_free_blocks()

FUJITA Tomonori <fujita.tomonori@gmail.com>
    PCI: Add Edimax Vendor ID to pci_ids.h

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't retry after unix_state_lock_nested() in unix_stream_connect().

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix send_signal test with nested CONFIG_PARAVIRT

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix invalid WQ linked list unlink

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_dp_rx_peer_frag_setup()

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: disallow setting special AP channel widths

Viresh Kumar <viresh.kumar@linaro.org>
    xen: privcmd: Switch from mutex to spinlock for irqfds

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: SBS: manage alarm sysfs attribute through psy core

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: create alarm sysfs attribute atomically

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    clocksource/drivers/sh_cmt: Address race condition for clock events

Frederic Weisbecker <frederic@kernel.org>
    rcu: Fix rcu_barrier() VS post CPUHP_TEARDOWN_CPU invocation

Mikulas Patocka <mpatocka@redhat.com>
    block: change rq_integrity_vec to respect the iterator

Yu Kuai <yukuai3@huawei.com>
    md/raid5: avoid BUG_ON() while continue reshape after reassembling

Li Nan <linan122@huawei.com>
    md: do not delete safemode_timer in mddev_suspend

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_fwd_cb_cr() data race

Wilken Gottwalt <wilken.gottwalt@posteo.net>
    hwmon: corsair-psu: add USB id of HX1200i Series 2023 psu

Hagar Hemdan <hagarhem@amazon.com>
    gpio: prevent potential speculation leaks in gpio_device_get_desc()

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Stop PPS on driver remove

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: Properly overlay PHY and MAC Wake-on-LAN capabilities

James Chapman <jchapman@katalix.com>
    l2tp: fix lockdep splat

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: dsa: bcm_sf2: Fix a possible memory leak in bcm_sf2_mdio_register()

Zhengchao Shao <shaozhengchao@huawei.com>
    net/smc: add the max value of fallback reason count

Anton Khirnov <anton@khirnov.net>
    Bluetooth: hci_sync: avoid dup filtering when passive scanning with adv monitor

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: Fix reset handler

Eric Dumazet <edumazet@google.com>
    net: linkwatch: use system_unbound_wq

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: wait for previous gc cycles when removing port

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: fix memory leak for not ip packets

Kuniyuki Iwashima <kuniyu@amazon.com>
    sctp: Fix null-ptr-deref in reuseport_add_sock().

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix soft lockup on suspend

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath12k: add CE and ext IRQ flag to indicate irq_handler

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: rename the sc naming convention to ab

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle lack of FSCTL_GET_REPARSE_POINT support

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_entry_text() for i386

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_pgtable() alignment assumption

Peter Zijlstra <peterz@infradead.org>
    jump_label: Fix the fix, brown paper bags galore

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    platform/x86/intel/ifs: Initialize union ifs_status to zero

Jithu Joseph <jithu.joseph@intel.com>
    platform/x86/intel/ifs: Gen2 Scan test support

Jithu Joseph <jithu.joseph@intel.com>
    platform/x86/intel/ifs: Store IFS generation number

Yipeng Zou <zouyipeng@huawei.com>
    irqchip/mbigen: Fix mbigen node address layout


-------------

Diffstat:

 Documentation/admin-guide/cifs/usage.rst           |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |  10 +-
 Documentation/arch/arm64/silicon-errata.rst        |  36 +++++
 Documentation/hwmon/corsair-psu.rst                |   6 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  38 +++++
 arch/arm64/include/asm/barrier.h                   |   4 +
 arch/arm64/include/asm/cputype.h                   |  16 +++
 arch/arm64/kernel/cpu_errata.c                     |  31 +++++
 arch/arm64/kernel/cpufeature.c                     |  12 ++
 arch/arm64/kernel/proton-pack.c                    |  12 ++
 arch/arm64/tools/cpucaps                           |   1 +
 arch/loongarch/kernel/efi.c                        |   6 +
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/cache.h                    |  11 +-
 arch/parisc/net/bpf_jit_core.c                     |   2 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/qspinlock.h                   |  12 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/paravirt.c                         |   7 +-
 arch/x86/mm/pti.c                                  |   8 +-
 drivers/acpi/battery.c                             |  16 ++-
 drivers/acpi/sbs.c                                 |  23 +--
 drivers/base/core.c                                |  13 +-
 drivers/base/module.c                              |   4 +
 drivers/bluetooth/btnxpuart.c                      |   2 +-
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/gpio/gpiolib.c                             |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   5 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 +
 .../hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c    |   5 +
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   8 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |   8 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  55 ++++----
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  14 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  36 ++++-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  16 +--
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  11 ++
 drivers/gpu/drm/drm_client_modeset.c               |   5 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  55 +++++++-
 drivers/gpu/drm/lima/lima_drv.c                    |   1 +
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   8 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   6 +-
 drivers/gpu/drm/radeon/pptable.h                   |   2 +-
 drivers/hwmon/corsair-psu.c                        |   7 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   5 +-
 drivers/i2c/i2c-smbus.c                            |  64 ++++++++-
 drivers/irqchip/irq-loongarch-cpu.c                |   6 +-
 drivers/irqchip/irq-mbigen.c                       |  20 ++-
 drivers/irqchip/irq-meson-gpio.c                   |  14 +-
 drivers/irqchip/irq-xilinx-intc.c                  |   2 +-
 drivers/md/md.c                                    |   1 -
 drivers/md/raid5.c                                 |  20 ++-
 drivers/media/platform/amphion/vdec.c              |   2 -
 drivers/media/platform/amphion/venc.c              |   2 -
 drivers/media/tuners/xc2028.c                      |   9 +-
 drivers/media/usb/uvc/uvc_video.c                  |  37 ++++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |   2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      | 125 +++++++++--------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  13 +-
 drivers/net/dsa/bcm_sf2.c                          |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  14 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  23 +++
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath12k/core.h             |   2 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath12k/hif.h              |  18 +--
 drivers/net/wireless/ath/ath12k/pci.c              |  21 ++-
 drivers/nvme/host/pci.c                            |   6 +-
 drivers/platform/x86/intel/ifs/core.c              |   3 +
 drivers/platform/x86/intel/ifs/ifs.h               |  30 +++-
 drivers/platform/x86/intel/ifs/runtest.c           |  31 +++--
 drivers/power/supply/axp288_charger.c              |  24 ++--
 drivers/power/supply/qcom_battmgr.c                |   8 +-
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  11 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  20 ++-
 drivers/spi/spi-fsl-lpspi.c                        |   6 +-
 drivers/spi/spidev.c                               |   1 +
 drivers/tty/serial/serial_core.c                   |   8 ++
 drivers/ufs/core/ufshcd.c                          |  14 +-
 drivers/usb/gadget/function/f_midi2.c              |  21 ++-
 drivers/usb/gadget/function/u_audio.c              |  42 ++++--
 drivers/usb/gadget/function/u_serial.c             |   1 +
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/xen/privcmd.c                              |  25 ++--
 fs/btrfs/ctree.h                                   |   1 +
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/file.c                                    |  60 ++++++--
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/btrfs/print-tree.c                              |   2 +-
 fs/ext4/inline.c                                   |   6 +-
 fs/jbd2/journal.c                                  |   1 +
 fs/smb/client/cifs_debug.c                         |   2 +-
 fs/smb/client/cifsglob.h                           |   8 +-
 fs/smb/client/inode.c                              |  17 ++-
 fs/smb/client/misc.c                               |   9 +-
 fs/smb/client/reparse.c                            |   4 +
 fs/smb/client/reparse.h                            |  19 ++-
 fs/smb/client/smb2inode.c                          |   2 +
 fs/smb/client/smb2pdu.c                            |   3 +
 fs/tracefs/event_inode.c                           |   4 +-
 fs/tracefs/inode.c                                 |  12 +-
 fs/tracefs/internal.h                              |   5 +-
 fs/udf/balloc.c                                    |  36 ++---
 fs/xfs/xfs_log_recover.c                           |  20 ++-
 include/linux/blk-integrity.h                      |  16 +--
 include/linux/clocksource.h                        |  14 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/pci_ids.h                            |   2 +
 include/linux/profile.h                            |   1 -
 include/linux/trace_events.h                       |   1 -
 include/linux/virtio_net.h                         |  16 +--
 include/net/ip6_route.h                            |  22 ++-
 include/trace/events/intel_ifs.h                   |  16 +--
 kernel/irq/irqdesc.c                               |   1 +
 kernel/jump_label.c                                |   4 +-
 kernel/kcov.c                                      |  15 +-
 kernel/kprobes.c                                   |   4 +-
 kernel/module/main.c                               |  41 ++++--
 kernel/padata.c                                    |   7 +
 kernel/profile.c                                   |  11 +-
 kernel/rcu/rcutorture.c                            |   2 +-
 kernel/rcu/tree.c                                  |  10 +-
 kernel/sched/core.c                                |  68 ++++++---
 kernel/sched/cputime.c                             |   6 +
 kernel/sched/stats.c                               |  10 --
 kernel/time/clocksource-wdtest.c                   |  13 +-
 kernel/time/clocksource.c                          |  10 +-
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |   3 +-
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/tracing_map.c                         |   6 +-
 mm/huge_memory.c                                   |   4 +
 mm/hugetlb.c                                       |  14 +-
 mm/memcontrol.c                                    |  22 ++-
 net/bluetooth/hci_sync.c                           |  14 ++
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bridge/br_multicast.c                          |   4 +-
 net/core/link_watch.c                              |   4 +-
 net/ipv4/tcp_offload.c                             |   3 +
 net/ipv4/udp_offload.c                             |   4 +
 net/ipv6/ip6_output.c                              |   1 +
 net/ipv6/route.c                                   |   2 +-
 net/l2tp/l2tp_core.c                               |  15 +-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/pm.c                                     |  12 ++
 net/mptcp/pm_netlink.c                             |  65 ++++++---
 net/mptcp/pm_userspace.c                           |  18 +++
 net/mptcp/protocol.h                               |   3 +
 net/mptcp/subflow.c                                |   3 +
 net/netfilter/nf_tables_api.c                      | 154 ++-------------------
 net/sctp/input.c                                   |  19 +--
 net/smc/smc_stats.h                                |   2 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/unix/af_unix.c                                 |  34 ++---
 net/wireless/nl80211.c                             |  37 +++--
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/wcd938x-sdw.c                     |   4 +-
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/codecs/wsa883x.c                         |  10 +-
 sound/soc/codecs/wsa884x.c                         |  10 +-
 sound/soc/meson/axg-fifo.c                         |  26 ++--
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   2 +-
 sound/soc/sti/sti_uniperif.c                       |   2 +-
 sound/soc/sti/uniperif.h                           |   1 +
 sound/soc/sti/uniperif_player.c                    |   1 +
 sound/soc/sti/uniperif_reader.c                    |   1 +
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/quirks-table.h                           |   4 +
 tools/arch/arm64/include/asm/cputype.h             |   6 +
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 tools/testing/selftests/mm/Makefile                |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  57 ++++++--
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   6 +-
 tools/testing/selftests/rcutorture/bin/torture.sh  |   2 +-
 192 files changed, 1600 insertions(+), 810 deletions(-)


