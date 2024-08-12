Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DC134AC;
	Mon, 12 Aug 2024 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479851; cv=none; b=iEn66U2JYrxVza9bVY0/a9FnfYcpVuhxIJpPel1HmyZ8WBa0D1q01SD8sRPgOaKYfZINWoJcpLQRBx9hH3IADPznXccJe2iym69nx3GNcEz86hmLE4IIocMpPejs9Tls/ltBSW/aJDyaOab8MCbcvJTWI1PJRS4PWuTCqdePV/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479851; c=relaxed/simple;
	bh=MSNTTcEiGSll5DO3RyHqtJo9frFNZUPgJ0VpSU1HdUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EezRbRojq25yGMVv3selgG/1fP98lwI1MFZ1aoaCdseGZkMYzV6qiGH1Gxxl2K5ngIFI9cVnQY0CkMiwMlEAMSBURmUTYv73eF9CgiPf3b79MYy6im2w6LHqS9LzDwoSRPHWb/UskcdzqXCRPW3S+ybqtzBjVkfekyeBzIjhPF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7wATNLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7wATNLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713CEC4AF09;
	Mon, 12 Aug 2024 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479851;
	bh=MSNTTcEiGSll5DO3RyHqtJo9frFNZUPgJ0VpSU1HdUg=;
	h=From:To:Cc:Subject:Date:From;
	b=T7wATNLqIXaNgaMfxY2HU9ylpLjhcDFc1Rw5ZDQbVbIEY9x0VITTvR0V9zApDsCpj
	 ynQs1SJiiCP3wzcpF4f0NSGhkX6KDnIPiFDjI3mWwMlEbZYCgRDNrv+ehkmUO/SC+0
	 4lPDXNjlvsvy0eUrtakX58vAurbs98GJ81acmmrw=
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
Subject: [PATCH 6.10 000/263] 6.10.5-rc1 review
Date: Mon, 12 Aug 2024 18:00:01 +0200
Message-ID: <20240812160146.517184156@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.5-rc1
X-KernelTest-Deadline: 2024-08-14T16:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.5 release.
There are 263 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.5-rc1

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double inode unlock for direct IO sync writes

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

Swapnil Patel <swapnil.patel@amd.com>
    drm/amd/display: Change ASSR disable sequence

Natanel Roizenman <natanel.roizenman@amd.com>
    drm/amd/display: Add null check in resource_log_pipe_topology_update

Michal Kubiak <michal.kubiak@intel.com>
    idpf: fix memleak in vport interrupt configuration

Filipe Manana <fdmanana@suse.com>
    btrfs: fix corruption after buffer fault in during direct IO append write

Ivan Lipski <ivlipski@amd.com>
    Revert "drm/amd/display: Add NULL check for 'afb' before dereferencing in amdgpu_dm_plane_handle_cursor_update"

Sung-huai Wang <danny.wang@amd.com>
    Revert "drm/amd/display: Handle HPD_IRQ for internal link"

Jens Axboe <axboe@kernel.dk>
    block: use the right type for stub rq_integrity_vec()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: deny endp with signal + subflow + port

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

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp: Disable TCP-AO static key after RCU grace period

Muchun Song <muchun.song@linux.dev>
    mm: list_lru: fix UAF for memory cgroup

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

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have format file honor EVENT_FILE_FL_FREED

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

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    irqchip/riscv-aplic: Retrigger MSI interrupt on source configuration

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    irqchip/xilinx: Fix shift out of bounds

Andrey Konovalov <andreyknvl@gmail.com>
    kcov: properly check for softirq context

Konrad Dybcio <konrad.dybcio@linaro.org>
    spmi: pmic-arb: Pass the correct of_node to irq_domain_add_tree

Takashi Iwai <tiwai@suse.de>
    ASoC: amd: yc: Add quirk entry for OMEN by HP Gaming Laptop 16-n0xxx

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix a possible DMA corruption

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix unaligned accesses in BPF

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: protect concurrent access to mem_cgroup_idr

Max Krummenacher <max.krummenacher@toradex.com>
    tty: vt: conmakehash: cope with abs_srctree no longer in env

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix invalid FIFO access with special register set

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix TX fifo corruption

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

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin-dahlia: Keep CTRL_SLEEP_MOCI# regulator on

Dan Williams <dan.j.williams@intel.com>
    driver core: Fix uevent_show() vs driver detach race

Justin Stitt <justinstitt@google.com>
    ntp: Clamp maxerror and esterror to operating range

David Collins <quic_collinsd@quicinc.com>
    spmi: pmic-arb: add missing newline in dev_err format strings

Jason Wang <jasowang@redhat.com>
    vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    media: v4l: Fix missing tabular column hint for Y14P format

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Move per CPU pointer access into the atomic section

Vamshi Gajjela <vamshigajjela@google.com>
    scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: core: Do not set link to OFF state while waking up from hibernation

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix deadlock during RTC update

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES

Chris Wulff <crwulff@gmail.com>
    usb: gadget: u_audio: Check return codes from usb_ep_enable and config_ep_by_speed.

Tudor Ambarus <tudor.ambarus@linaro.org>
    usb: gadget: f_fs: restore ffs_func_disable() functionality

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Set start_delayed during suspend

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix the response for FB info with block 0xff

Chris Wulff <crwulff@gmail.com>
    usb: gadget: core: Check for unset descriptor

Konrad Dybcio <konrad.dybcio@linaro.org>
    usb: typec: fsa4480: Check if the chip is really there

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

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't pick multiple buffers for non-bundle send

Jens Axboe <axboe@kernel.dk>
    io_uring/net: ensure expanded bundle send gets marked for cleanup

Jens Axboe <axboe@kernel.dk>
    io_uring/net: ensure expanded bundle recv gets marked for cleanup

Dave Airlie <airlied@redhat.com>
    drm/test: fix the gem shmem test to map the sg table.

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/i915/display: correct dual pps handling for MTL_PCH+

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

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Take ref to VM in delayed snapshot

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: Minor cleanup in LRC handling

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Fix PL1 disable flow in xe_hwmon_power_max_write

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use dma_fence_chain_free in chain fence unused as a sync

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/rtp: Fix off-by-one when processing rules

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Re-add ScratchAmp quirk entries

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix scldiv calculation

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Replace dm_execute_dmub_cmd with dc_wake_and_execute_dmub_cmd

David Gow <david@davidgow.net>
    drm/i915: Attempt to get pages without eviction first

David Gow <david@davidgow.net>
    drm/i915: Allow evicting to use the requested placement

Gaosheng Cui <cuigaosheng1@huawei.com>
    i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume

Simon Ser <contact@emersion.fr>
    drm/atomic: allow no-op FB_ID updates for async flips

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Handle OTP read latency over SoundWire

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Revert support for dual-ownership of ASP registers

Gaosheng Cui <cuigaosheng1@huawei.com>
    i2c: qcom-geni: Add missing clk_disable_unprepare in geni_i2c_runtime_resume

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib: Fix NULL pointer crash if efi.get_variable is NULL

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
    ASoC: codecs: wcd939x-sdw: Correct Soundwire ports mask

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Improve handling of stuck alerts

Jeff Layton <jlayton@kernel.org>
    nfsd: don't set SVC_SOCK_ANONYMOUS when creating nfsd sockets

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

Willem de Bruijn <willemb@google.com>
    net: drop bad gso csum_start and offset in virtio_net_hdr

Zheng Zucheng <zhengzucheng@huawei.com>
    sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongarch-cpu: Fix return value of lpic_gsi_to_irq()

Arseniy Krasnov <avkrasnov@salutedevices.com>
    irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to 'raw_spinlock_t'

Bingbu Cao <bingbu.cao@intel.com>
    media: intel/ipu6: select AUXILIARY_BUS in Kconfig

Arnd Bergmann <arnd@arndb.de>
    media: ipu-bridge: fix ipu6 Kconfig dependencies

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES

Johan Hovold <johan+linaro@kernel.org>
    scsi: Revert "scsi: sd: Do not repeat the starting disk message"

Paul E. McKenney <paulmck@kernel.org>
    clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    profiling: remove profile=sleep support

Rik van Riel <riel@surriel.com>
    mm, slub: do not call do_slab_free for kfence object

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a race to wake a sync task

Wojciech Gładysz <wojciech.gladysz@infogain.com>
    ext4: sanity check for NULL pointer after ext4_force_shutdown

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Prevent release of buffer in I/O

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix null pointer deref in dcn20_resource.c

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: avoid memleak in jbd2_journal_write_metadata_buffer

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix uninitialized variable in ext4_inlinedir_to_tree

Chi Zhiling <chizhiling@kylinos.cn>
    media: xc2028: avoid use-after-free in load_firmware_cb()

Rodrigo Siqueira <rodrigo.siqueira@amd.com>
    drm/amd/display: Fix NULL pointer dereference for DTN log in DCN401

Michal Pecio <michal.pecio@gmail.com>
    media: uvcvideo: Fix the bandwdith quirk on USB 3.x

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Ignore empty TS packets

Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
    media: i2c: ov5647: replacing of_node_put with __free(device_node)

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Add null checker before passing variables

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: remove dpp pipes on failure to update pipe params

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: reduce ODM slice count to initial new dc state only when needed

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Wake DMCUB before sending a command for replay feature

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for 'afb' before dereferencing in amdgpu_dm_plane_handle_cursor_update

Ming Qian <ming.qian@nxp.com>
    media: amphion: Remove lock in s_ctrl callback

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null checks for 'stream' and 'plane' before dereferencing

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

Jonathan Cavitt <jonathan.cavitt@intel.com>
    drm/xe/xe_guc_submit: Fix exec queue stop race condition

Ramesh Errabolu <Ramesh.Errabolu@amd.com>
    drm/amd/amdkfd: Fix a resource leak in svm_range_validate_and_map()

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu/pm: Fix the param type of set_power_profile_mode

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix potential resource leak warning

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Add delay to improve LTTPR UHBR interop

Sung-huai Wang <danny.wang@amd.com>
    drm/amd/display: Handle HPD_IRQ for internal link

Matthew Auld <matthew.auld@intel.com>
    drm/xe/preempt_fence: enlarge the fence critical section

Luke Wang <ziniu.wang_1@nxp.com>
    Bluetooth: btnxpuart: Shutdown timer and prevent rearming when driver unloading

Filipe Manana <fdmanana@suse.com>
    btrfs: fix bitmap leak when loading free space cache on duplicate entry

Filipe Manana <fdmanana@suse.com>
    btrfs: fix data race when accessing the last_trans field of a root

Filipe Manana <fdmanana@suse.com>
    btrfs: reduce nesting for extent processing at btrfs_lookup_extent_info()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() when freeing tree block after error

Qu Wenruo <wqu@suse.com>
    btrfs: do not clear page dirty inside extent_write_locked_range()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: pci: Lock configuration space of upstream bridge during reset

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    net: stmmac: qcom-ethqos: enable SGMII loopback during DMA reset on sa8775p-ride-r3

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: tef: update workaround for erratum DS80000789E 6 of mcp2518fd

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: tef: prepare to workaround broken TEF FIFO tail index erratum

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't give key data to userspace

Matt Bobrowski <mattbobrowski@google.com>
    bpf: add missing check_func_arg_reg_off() to prevent out-of-bounds memory accesses

Roman Smirnov <r.smirnov@omp.ru>
    udf: prevent integer overflow in udf_bitmap_free_blocks()

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: mac80211: fix NULL dereference at band check in starting tx ba session

FUJITA Tomonori <fujita.tomonori@gmail.com>
    PCI: Add Edimax Vendor ID to pci_ids.h

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't retry after unix_state_lock_nested() in unix_stream_connect().

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: fix RX tag race condition resulting in wrong RX length

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix send_signal test with nested CONFIG_PARAVIRT

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix invalid WQ linked list unlink

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_dp_rx_peer_frag_setup()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtlwifi: handle return value of usb init TX/RX

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix race due to setting ATH12K_FLAG_EXT_IRQ_ENABLED too early

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: disallow setting special AP channel widths

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: hfi: Give HFI instances package scope

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MJ

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MU

Viresh Kumar <viresh.kumar@linaro.org>
    xen: privcmd: Switch from mutex to spinlock for irqfds

Sibi Sankar <quic_sibis@quicinc.com>
    soc: qcom: icc-bwmon: Allow for interrupts to be shared across instances

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: auto-load pstate driver by default

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq: amd-pstate: Allow users to write 'default' EPP string

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

Keith Busch <kbusch@kernel.org>
    nvme: apple: fix device reference counting

Breno Leitao <leitao@debian.org>
    debugobjects: Annotate racy debug variables

Yu Kuai <yukuai3@huawei.com>
    md/raid5: avoid BUG_ON() while continue reshape after reassembling

Li Nan <linan122@huawei.com>
    md: change the return value type of md_write_start to void

Li Nan <linan122@huawei.com>
    md: do not delete safemode_timer in mddev_suspend

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_fwd_cb_cr() data race

Ben Walsh <ben@jubnut.com>
    platform/chrome: cros_ec_lpc: Add a new quirk for ACPI id

Frederic Weisbecker <frederic@kernel.org>
    Revert "rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()"

Wilken Gottwalt <wilken.gottwalt@posteo.net>
    hwmon: corsair-psu: add USB id of HX1200i Series 2023 psu

Hagar Hemdan <hagarhem@amazon.com>
    gpio: prevent potential speculation leaks in gpio_device_get_desc()

Richard Fitzgerald <rf@opensource.cirrus.com>
    regmap: kunit: Fix memory leaks in gen_regmap() and gen_raw_regmap()

Martin Whitaker <foss@martin-whitaker.me.uk>
    net: dsa: microchip: disable EEE for KSZ8567/KSZ9567/KSZ9896/KSZ9897.

Arnd Bergmann <arnd@arndb.de>
    net: pse-pd: tps23881: include missing bitfield.h header

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Stop PPS on driver remove

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: Properly overlay PHY and MAC Wake-on-LAN capabilities

James Chapman <jchapman@katalix.com>
    l2tp: fix lockdep splat

Alexander Lobakin <aleksander.lobakin@intel.com>
    idpf: fix UAFs when destroying the queues

Alexander Lobakin <aleksander.lobakin@intel.com>
    idpf: fix memory leaks and crashes while performing a soft reset

Michael Chan <michael.chan@broadcom.com>
    bnxt_en : Fix memory out-of-bounds in bnxt_fill_hw_rss_tbl()

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

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix Wake-on-LAN check to not return an error

Eric Dumazet <edumazet@google.com>
    net: linkwatch: use system_unbound_wq

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: wait for previous gc cycles when removing port

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: fix memory leak for not ip packets

Heng Qi <hengqi@linux.alibaba.com>
    virtio-net: unbreak vq resizing when coalescing is not negotiated

Praveen Kaligineedi <pkaligineedi@google.com>
    gve: Fix use of netif_carrier_ok()

Kyle Swenson <kyle.swenson@est.tech>
    net: pse-pd: tps23881: Fix the device ID check

Kuniyuki Iwashima <kuniyu@amazon.com>
    sctp: Fix null-ptr-deref in reuseport_add_sock().

Nikita Travkin <nikita@trvn.ru>
    power: supply: rt5033: Bring back i2c_set_clientdata

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle lack of FSCTL_GET_REPARSE_POINT support

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_entry_text() for i386

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_pgtable() alignment assumption

Laura Nao <laura.nao@collabora.com>
    selftests: ksft: Fix finished() helper exit code on skipped tests

Li Huafei <lihuafei1@huawei.com>
    perf/x86: Fix smp_processor_id()-in-preemptible warnings

Kan Liang <kan.liang@linux.intel.com>
    perf/x86: Support counter mask

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Support the PEBS event mask

Uros Bizjak <ubizjak@gmail.com>
    perf/x86/amd: Use try_cmpxchg() in events/amd/{un,}core.c

Peter Zijlstra <peterz@infradead.org>
    jump_label: Fix the fix, brown paper bags galore

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    platform/x86/intel/ifs: Initialize union ifs_status to zero

Yipeng Zou <zouyipeng@huawei.com>
    irqchip/mbigen: Fix mbigen node address layout

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Protect ACPI notify handler against recursion

Zhenyu Wang <zhenyuw@linux.intel.com>
    perf/x86/intel/cstate: Add pkg C2 residency counter for Sierra Forest

Zhang Rui <rui.zhang@intel.com>
    perf/x86/intel/cstate: Add Lunarlake support

Zhang Rui <rui.zhang@intel.com>
    perf/x86/intel/cstate: Add Arrowlake support

Uros Bizjak <ubizjak@gmail.com>
    locking/pvqspinlock: Correct the type of "old" variable in pv_kick_node()

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Refactor function dm_dp_mst_is_port_support_mode()


-------------

Diffstat:

 Documentation/admin-guide/cifs/usage.rst           |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |   4 +-
 Documentation/arch/arm64/silicon-errata.rst        |  34 ++-
 Documentation/hwmon/corsair-psu.rst                |   6 +-
 .../userspace-api/media/v4l/pixfmt-yuv-luma.rst    |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  58 +++--
 arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi  |  22 --
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   6 -
 arch/arm64/include/asm/cpucaps.h                   |   2 +-
 arch/arm64/include/asm/cputype.h                   |  10 +
 arch/arm64/kernel/cpu_errata.c                     |  26 ++-
 arch/arm64/kernel/proton-pack.c                    |   2 +-
 arch/loongarch/kernel/efi.c                        |   6 +
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/cache.h                    |  11 +-
 arch/parisc/net/bpf_jit_core.c                     |   2 +-
 arch/x86/events/amd/core.c                         |  28 +--
 arch/x86/events/amd/uncore.c                       |   8 +-
 arch/x86/events/core.c                             | 116 +++++-----
 arch/x86/events/intel/core.c                       | 164 +++++++------
 arch/x86/events/intel/cstate.c                     |  35 ++-
 arch/x86/events/intel/ds.c                         |  34 ++-
 arch/x86/events/intel/knc.c                        |   2 +-
 arch/x86/events/intel/p4.c                         |  10 +-
 arch/x86/events/intel/p6.c                         |   2 +-
 arch/x86/events/perf_event.h                       |  62 ++++-
 arch/x86/events/zhaoxin/core.c                     |  12 +-
 arch/x86/include/asm/intel_ds.h                    |   1 +
 arch/x86/include/asm/qspinlock.h                   |  12 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/paravirt.c                         |   7 +-
 arch/x86/mm/pti.c                                  |   8 +-
 drivers/acpi/battery.c                             |  16 +-
 drivers/acpi/resource.c                            |  14 ++
 drivers/acpi/sbs.c                                 |  23 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/module.c                              |   4 +
 drivers/base/regmap/regmap-kunit.c                 |  72 +++---
 drivers/bluetooth/btnxpuart.c                      |   2 +-
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/cpufreq/amd-pstate.c                       |  32 ++-
 drivers/cpufreq/amd-pstate.h                       |   1 +
 drivers/gpio/gpiolib.c                             |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   5 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    | 255 +++++++++++++--------
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  58 +++--
 drivers/gpu/drm/amd/display/dc/core/dc_state.c     |  67 ++++--
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c   |   9 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  49 ++--
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |   3 +
 .../hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c    |   5 +
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   3 +-
 .../dc/link/protocols/link_dp_irq_handler.c        |   3 +-
 .../amd/display/dc/resource/dcn20/dcn20_resource.c |   9 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   8 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |   8 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  55 ++---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |  14 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  36 ++-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  16 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  11 +
 drivers/gpu/drm/drm_atomic_uapi.c                  |  15 +-
 drivers/gpu/drm/drm_client_modeset.c               |   5 +
 drivers/gpu/drm/i915/display/intel_backlight.c     |   3 +
 drivers/gpu/drm/i915/display/intel_pps.c           |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  55 ++++-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  13 +-
 drivers/gpu/drm/lima/lima_drv.c                    |   1 +
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   8 +-
 drivers/gpu/drm/radeon/pptable.h                   |   2 +-
 drivers/gpu/drm/tests/drm_gem_shmem_test.c         |  11 +
 drivers/gpu/drm/xe/regs/xe_engine_regs.h           |   4 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   2 +-
 drivers/gpu/drm/xe/xe_hwmon.c                      |   3 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |  17 +-
 drivers/gpu/drm/xe/xe_preempt_fence.c              |  14 +-
 drivers/gpu/drm/xe/xe_rtp.c                        |   2 +-
 drivers/gpu/drm/xe/xe_sync.c                       |   2 +-
 drivers/hwmon/corsair-psu.c                        |   7 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   5 +-
 drivers/i2c/i2c-smbus.c                            |  64 +++++-
 drivers/irqchip/irq-loongarch-cpu.c                |   6 +-
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/irqchip/irq-meson-gpio.c                   |  14 +-
 drivers/irqchip/irq-riscv-aplic-msi.c              |  32 ++-
 drivers/irqchip/irq-xilinx-intc.c                  |   2 +-
 drivers/md/md.c                                    |  15 +-
 drivers/md/md.h                                    |   2 +-
 drivers/md/raid1.c                                 |   3 +-
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5.c                                 |  23 +-
 drivers/media/i2c/ov5647.c                         |  11 +-
 drivers/media/pci/intel/ipu6/Kconfig               |   3 +-
 drivers/media/platform/amphion/vdec.c              |   2 -
 drivers/media/platform/amphion/venc.c              |   2 -
 drivers/media/tuners/xc2028.c                      |   9 +-
 drivers/media/usb/uvc/uvc_video.c                  |  37 ++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |   2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      | 125 +++++-----
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  13 +-
 drivers/net/dsa/bcm_sf2.c                          |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |  16 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  13 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  14 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  12 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  48 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  43 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   6 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  23 ++
 drivers/net/pse-pd/tps23881.c                      |   5 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath12k/pci.c              |   4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  34 ++-
 drivers/net/wireless/realtek/rtw89/pci.c           |  13 +-
 drivers/nvme/host/apple.c                          |  27 ++-
 drivers/nvme/host/pci.c                            |   6 +-
 drivers/platform/chrome/cros_ec_lpc.c              |  50 +++-
 drivers/platform/x86/intel/ifs/runtest.c           |   2 +-
 drivers/platform/x86/intel/vbtn.c                  |   9 +
 drivers/power/supply/axp288_charger.c              |  24 +-
 drivers/power/supply/qcom_battmgr.c                |   8 +-
 drivers/power/supply/rt5033_battery.c              |   1 +
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  11 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  20 +-
 drivers/scsi/sd.c                                  |   5 +-
 drivers/soc/qcom/icc-bwmon.c                       |  12 +-
 drivers/spi/spi-fsl-lpspi.c                        |   6 +-
 drivers/spi/spidev.c                               |   1 +
 drivers/spmi/spmi-pmic-arb.c                       |  11 +-
 drivers/thermal/intel/intel_hfi.c                  |  30 +--
 drivers/tty/serial/sc16is7xx.c                     |  25 +-
 drivers/tty/serial/serial_core.c                   |   8 +
 drivers/tty/vt/conmakehash.c                       |  20 +-
 drivers/ufs/core/ufshcd-priv.h                     |   5 +
 drivers/ufs/core/ufshcd.c                          |  19 +-
 drivers/usb/gadget/function/f_fs.c                 |   6 +-
 drivers/usb/gadget/function/f_midi2.c              |  21 +-
 drivers/usb/gadget/function/u_audio.c              |  42 +++-
 drivers/usb/gadget/function/u_serial.c             |   1 +
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/typec/mux/fsa4480.c                    |  14 ++
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/xen/privcmd.c                              |  25 +-
 fs/btrfs/ctree.c                                   |  57 +++--
 fs/btrfs/ctree.h                                   |  11 +
 fs/btrfs/defrag.c                                  |   2 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/extent-tree.c                             |  46 ++--
 fs/btrfs/extent-tree.h                             |   8 +-
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/file.c                                    |  60 +++--
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/btrfs/free-space-tree.c                         |  10 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/btrfs/print-tree.c                              |   2 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/btrfs/relocation.c                              |   8 +-
 fs/btrfs/transaction.c                             |   8 +-
 fs/buffer.c                                        |   2 +
 fs/ext4/inline.c                                   |   6 +-
 fs/ext4/inode.c                                    |   5 +
 fs/jbd2/journal.c                                  |   1 +
 fs/nfsd/nfsctl.c                                   |   3 +-
 fs/smb/client/cifs_debug.c                         |   2 +-
 fs/smb/client/cifsglob.h                           |   8 +-
 fs/smb/client/inode.c                              |  17 +-
 fs/smb/client/misc.c                               |   9 +-
 fs/smb/client/reparse.c                            |   4 +
 fs/smb/client/reparse.h                            |  19 +-
 fs/smb/client/smb2inode.c                          |   2 +
 fs/smb/client/smb2pdu.c                            |   3 +
 fs/tracefs/event_inode.c                           |   4 +-
 fs/tracefs/inode.c                                 |  12 +-
 fs/tracefs/internal.h                              |   5 +-
 fs/udf/balloc.c                                    |  36 ++-
 include/linux/blk-integrity.h                      |  16 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/pci_ids.h                            |   2 +
 include/linux/profile.h                            |   1 -
 include/linux/rcupdate.h                           |   2 -
 include/linux/trace_events.h                       |   1 -
 include/linux/virtio_net.h                         |  16 +-
 include/sound/cs35l56.h                            |  14 +-
 io_uring/net.c                                     |   7 +-
 kernel/bpf/verifier.c                              |  17 +-
 kernel/irq/irqdesc.c                               |   1 +
 kernel/jump_label.c                                |   4 +-
 kernel/kcov.c                                      |  15 +-
 kernel/kprobes.c                                   |   4 +-
 kernel/locking/qspinlock_paravirt.h                |   2 +-
 kernel/module/main.c                               |  41 +++-
 kernel/padata.c                                    |   7 +
 kernel/pid_namespace.c                             |  17 --
 kernel/profile.c                                   |  11 +-
 kernel/rcu/rcutorture.c                            |   2 +-
 kernel/rcu/tasks.h                                 |  16 +-
 kernel/rcu/tree.c                                  |  10 +-
 kernel/sched/core.c                                |  68 ++++--
 kernel/sched/cputime.c                             |   6 +
 kernel/sched/stats.c                               |  10 -
 kernel/time/clocksource.c                          |   2 +-
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |   3 +-
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/trace.h                               |  23 ++
 kernel/trace/trace_events.c                        |  33 +--
 kernel/trace/trace_events_hist.c                   |   4 +-
 kernel/trace/trace_events_inject.c                 |   2 +-
 kernel/trace/trace_events_trigger.c                |   6 +-
 kernel/trace/tracing_map.c                         |   6 +-
 lib/debugobjects.c                                 |  21 +-
 mm/list_lru.c                                      |  28 ++-
 mm/memcontrol.c                                    |  22 +-
 mm/slub.c                                          |   3 +
 net/bluetooth/hci_sync.c                           |  14 ++
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bridge/br_multicast.c                          |   4 +-
 net/core/link_watch.c                              |   4 +-
 net/ipv4/tcp_ao.c                                  |  43 ++--
 net/ipv4/tcp_offload.c                             |   3 +
 net/ipv4/udp_offload.c                             |   4 +
 net/l2tp/l2tp_core.c                               |  15 +-
 net/mac80211/agg-tx.c                              |   4 +-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/pm_netlink.c                             |  47 ++--
 net/sctp/input.c                                   |  19 +-
 net/smc/smc_stats.h                                |   2 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/unix/af_unix.c                                 |  34 +--
 net/wireless/nl80211.c                             |  37 ++-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs-amp-lib.c                      |   2 +-
 sound/soc/codecs/cs35l56-sdw.c                     |  77 +++++++
 sound/soc/codecs/cs35l56-shared.c                  | 101 ++------
 sound/soc/codecs/cs35l56.c                         | 205 ++---------------
 sound/soc/codecs/cs35l56.h                         |   1 -
 sound/soc/codecs/wcd938x-sdw.c                     |   4 +-
 sound/soc/codecs/wcd939x-sdw.c                     |   4 +-
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/codecs/wsa883x.c                         |  10 +-
 sound/soc/codecs/wsa884x.c                         |  10 +-
 sound/soc/meson/axg-fifo.c                         |  26 +--
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   2 +-
 sound/soc/sti/sti_uniperif.c                       |   2 +-
 sound/soc/sti/uniperif.h                           |   1 +
 sound/soc/sti/uniperif_player.c                    |   1 +
 sound/soc/sti/uniperif_reader.c                    |   1 +
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/quirks-table.h                           |   4 +
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 tools/testing/selftests/devices/ksft.py            |   2 +-
 tools/testing/selftests/mm/Makefile                |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  55 +++--
 274 files changed, 2691 insertions(+), 1727 deletions(-)


