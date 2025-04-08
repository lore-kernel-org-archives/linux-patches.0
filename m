Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE226A096;
	Tue,  8 Apr 2025 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113823; cv=none; b=WN60eHKxnkn6wmvkWSYMh4ccrRnWCRuVe1snTpXsIPtE+SObGTKRsm3JEwjCGMehDigZ10FE/CqywX3N6SJdbJtEtWhwHvBOEw+CrjrUT/KLAXPPi8mtw5NCZ0CJeTOBxsfy3Ry1oLr3TDf7y4C950yi/NunaWZHzlQULnKg6zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113823; c=relaxed/simple;
	bh=TD4sdiXWWDgvmee9K58FHEg4BOebB6Ihemj9QacQQ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S0EQWW5Eque8EbV76kUsrkt47xFOt7V+kRmEIaptm070zUqL0hjUt0DRFRO3G425ENJ4CiLnAO7AZAAIWzDJbJCaIA6FI4eFPdRhBEms7cvgd+zuJdkmgpFuPAq/pmOV0brxg3OgHEAB5RijkSrPwlgHBp1EK8TaMDrOL0wlsDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ot3yOvP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ot3yOvP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E18FC4CEE5;
	Tue,  8 Apr 2025 12:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113823;
	bh=TD4sdiXWWDgvmee9K58FHEg4BOebB6Ihemj9QacQQ6M=;
	h=From:To:Cc:Subject:Date:From;
	b=Ot3yOvP0sgHISB3e/M8X0JhYJzRlZZoVGmISImiIs1tOkBg2K5zI4qg8nNXnkEMlC
	 hrpttrN1RTp1j9D301OQck0W3+kjCGlqhH9X7rDzHKo83i+EG2dJpFSTdGekADLfxr
	 Zb8Pn7BTILVUjXDSA/0xgLWi1UxtwhiBkHzHV2mE=
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
Subject: [PATCH 5.4 000/154] 5.4.292-rc1 review
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104815.295196624@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.292-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.292-rc1
X-KernelTest-Deadline: 2025-04-10T10:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.292 release.
There are 154 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.292-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.292-rc1

Roman Smirnov <r.smirnov@omp.ru>
    jfs: add index corruption check to DT_GETPAGE()

Qasim Ijaz <qasdev00@gmail.com>
    jfs: fix slab-out-of-bounds read in ea_get()

Tengda Wu <wutengda@huaweicloud.com>
    tracing: Fix use-after-free in print_graph_function_flags during tracer switching

Karel Balej <balejk@matfyz.cz>
    mmc: sdhci-pxav3: set NEED_RSP_BUSY capability

Paul Menzel <pmenzel@molgen.mpg.de>
    ACPI: resource: Skip IRQ override on ASUS Vivobook 14 X1404VAP

Jann Horn <jannh@google.com>
    x86/mm: Fix flush_tlb_range() when used for zapping normal PMDs

Guilherme G. Piccoli <gpiccoli@igalia.com>
    x86/tsc: Always save/restore TSC sched_clock() on suspend/resume

Markus Elfring <elfring@users.sourceforge.net>
    ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: only change CAN state when link up in system PM

Henry Martin <bsdhenrymartin@gmail.com>
    arcnet: Add NULL check in com20020pci_probe()

David Oberhollenzer <david.oberhollenzer@sigma-star.at>
    net: dsa: mv88e6xxx: propperly shutdown PPU re-enable timer on destroy

Fernando Fernandez Mancera <ffmancera@riseup.net>
    ipv6: fix omitted netlink attributes when using RTEXT_FILTER_SKIP_STATS

Stefano Garzarella <sgarzare@redhat.com>
    vsock: avoid timeout during connect() if the socket is closing

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: skbprio: Remove overly strict queue assertions

Debin Zhu <mowenroot@163.com>
    netlabel: Fix NULL pointer exception caused by CALIPSO on IPv4 sockets

Nikita Shubin <n.shubin@yadro.com>
    ntb: intel: Fix using link status DB's

Yajun Deng <yajun.deng@linux.dev>
    ntb_hw_switchtec: Fix shift-out-of-bounds in switchtec_ntb_mw_set_trans

Al Viro <viro@zeniv.linux.org.uk>
    spufs: fix a leak in spufs_create_context()

Al Viro <viro@zeniv.linux.org.uk>
    spufs: fix a leak on spufs_new_file() failure

Tasos Sahanidis <tasos@tasossah.com>
    hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}

Oliver Hartkopp <socketcan@hartkopp.net>
    can: statistics: use atomic access in hot path

Waiman Long <longman@redhat.com>
    locking/semaphore: Use wake_q to wake up processes outside lock critical section

Shrikanth Hegde <sshegde@linux.ibm.com>
    sched/deadline: Use online cpus for validating runtime

Simon Tatham <anakin@pobox.com>
    affs: don't write overlarge OFS data block size fields

Simon Tatham <anakin@pobox.com>
    affs: generate OFS sequence numbers starting at 1

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fw: allocate chained SG tables for dump

Josh Poimboeuf <jpoimboe@kernel.org>
    sched/smt: Always inline sched_smt_active()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix mbox INTR handler when num VFs > 64

Feng Yang <yangfeng@kylinos.cn>
    ring-buffer: Fix bytes_dropped calculation issue

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()

Bart Van Assche <bvanassche@acm.org>
    fs/procfs: fix the comment above proc_pid_wchan()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Check if there is space to copy all the event

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Decrement the refcount of just created event on failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Fixup description of sample.id event member

Vasiliy Kovalev <kovalev@altlinux.org>
    ocfs2: validate l_tree_depth to avoid out-of-bounds access

Sourabh Jain <sourabhjain@linux.ibm.com>
    kexec: initialize ELF lowest address to ULONG_MAX

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf units: Fix insufficient array space

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: mma8452: Ensure error return on failure to matching oversampling ratio

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    coresight: catu: Fix number of pages while using 64k pages

Qasim Ijaz <qasdev00@gmail.com>
    isofs: fix KMSAN uninit-value bug in do_isofs_readdir()

Jann Horn <jannh@google.com>
    x86/dumpstack: Fix inaccurate unwinding from exception stacks due to misplaced assignment

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    mfd: sm501: Switch to BIT() to mitigate integer overflows

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix mlx5_poll_one() cur_qp update flow

Artur Weber <aweber.kernel@gmail.com>
    power: supply: max77693: Fix wrong conversion of charge input threshold value

Jann Horn <jannh@google.com>
    x86/entry: Fix ORC unwinder for PUSH_REGS with save_ret=1

Jerome Brunet <jbrunet@baylibre.com>
    clk: amlogic: g12a: fix mmc A peripheral clock

Jerome Brunet <jbrunet@baylibre.com>
    clk: amlogic: gxbb: drop non existing 32k clock parent

Jerome Brunet <jbrunet@baylibre.com>
    clk: amlogic: g12b: fix cluster A parent data

Maher Sanalla <msanalla@nvidia.com>
    IB/mad: Check available slots before posting receive WRs

Peter Geis <pgwipeout@gmail.com>
    clk: rockchip: rk3328: fix wrong clk_ref_usb3otg parent

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    pinctrl: renesas: rza2: Fix missing of_node_put() call

Tanya Agarwal <tanyaagarwal25699@gmail.com>
    lib: 842: Improve error handling in sw842_compress()

Hou Tao <houtao1@huawei.com>
    bpf: Use preempt_count() directly in bpf_send_signal_common()

Jerome Brunet <jbrunet@baylibre.com>
    clk: amlogic: gxbb: drop incorrect flag on 32k clock

Danila Chernetsov <listdansp@mail.ru>
    fbdev: sm501fb: Add some geometry checks.

Arnd Bergmann <arnd@arndb.de>
    mdacon: rework dependency list

Markus Elfring <elfring@users.sourceforge.net>
    fbdev: au1100fb: Move a variable assignment behind a null pointer check

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: pciehp: Don't enable HPIE when resuming in poll mode

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: Remove stray put_device() in pci_register_host_bridge()

Feng Tang <feng.tang@linux.alibaba.com>
    PCI/portdrv: Only disable pciehp interrupts early when needed

Daniel Stodden <daniel.stodden@gmail.com>
    PCI/ASPM: Fix link state exit during switch upstream function removal

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_hdmi: Fix typo for aud_sampe_size member

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Always honor no_shutup_pins

Tao Chen <chen.dylane@linux.dev>
    perf/ring_buffer: Allow the EPOLLRDNORM flag for poll

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    lockdep: Don't disable interrupts on RT in disable_irq_nosync_lockdep.*()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix handling devices with direct_complete set on errors

Chenyuan Yang <chenyuan0y@gmail.com>
    thermal: int340x: Add NULL check for adev

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/ie31200: Fix the error path order of ie31200_init()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/ie31200: Fix the DIMM size mask for several SoCs

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/ie31200: Fix the size of EDAC_MC_LAYER_CHIP_SELECT layer

Tim Schumacher <tim.schumacher1@huawei.com>
    selinux: Chain up tool resolving errors in install_policy.sh

Arnd Bergmann <arnd@arndb.de>
    x86/platform: Only allow CONFIG_EISA for 32-bit

Benjamin Berg <benjamin.berg@intel.com>
    x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()

Jie Zhan <zhanjie9@hisilicon.com>
    cpufreq: governor: Fix negative 'idle_time' handling in dbs_update()

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: cpa-test: fix length for CPA_ARRAY test

John Keeping <jkeeping@inmusicbrands.com>
    serial: 8250_dma: terminate correct DMA in tx_dma_flush()

Luo Qiu <luoqiu@kylinsec.com.cn>
    memstick: rtsx_usb_ms: Fix slab-use-after-free in rtsx_usb_ms_drv_remove

Dominique Martinet <dominique.martinet@atmark-techno.com>
    net: usb: usbnet: restore usb%d name exception for local mac addresses

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FE990B composition

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FN990B composition

Cameron Williams <cang1@live.co.uk>
    tty: serial: 8250: Add some more device IDs

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix error handling when enabling

Maxim Mikityanskiy <maxtram95@gmail.com>
    netfilter: socket: Lookup orig tuple for IPv6 SNAT

Yanjun Yang <yangyj.ee@gmail.com>
    ARM: Remove address checking for MMUless devices

Kees Cook <keescook@chromium.org>
    ARM: 9351/1: fault: Add "cut here" line for prefetch aborts

Kees Cook <keescook@chromium.org>
    ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()

Minjoong Kim <pwn9uin@gmail.com>
    atm: Fix NULL pointer dereference

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: hid-plantronics: Add mic mute mapping and generalize quirks

Terry Junge <linuxhid@cosmicgizmosystems.com>
    ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore own maximum aggregation size during RX

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: smp: Enforce shmobile_smp_* alignment

Gu Bowen <gubowen5@huawei.com>
    mmc: atmel-mci: Add missing clk_disable_unprepare()

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Don't run jobs that have errors flagged in its fence

Andreas Kemnade <andreas@kemnade.info>
    i2c: omap: fix IRQ storms

Lin Ma <linma@zju.edu.cn>
    net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES

Dan Carpenter <dan.carpenter@linaro.org>
    net: atm: fix use after free in lec_send()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: Fix error code in chan_alloc_skb_cb()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong value of max_sge_rd

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm_output: Force software GSO only in tunnel mode

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    firmware: imx-scu: fix OF node leak in .probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: sis630: Fix an error handling path in sis630_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali15x3: Fix an error handling path in ali15x3_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali1535: Fix an error handling path in ali1535_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()

Ivan Abramov <i.abramov@mt-integration.ru>
    drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()

Haoxiang Li <haoxiang_li2024@163.com>
    qlcnic: fix memory leak issues in qlcnic_sriov_common.c

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Assign normalized_pix_clk when color depth = 14

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/atomic: Filter out redundant DPMS calls

Florent Revest <revest@chromium.org>
    x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes

Johan Hovold <johan@kernel.org>
    USB: serial: option: match on interface class for Telit FN990B

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FE990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE990B compositions

Boon Khai Ng <boon.khai.ng@intel.com>
    USB: serial: ftdi_sio: add support for Altera USB Blaster 3

Ming Lei <ming.lei@redhat.com>
    block: fix 'kmem_cache of name 'bio-108' already exists'

Thomas Zimmermann <tzimmermann@suse.de>
    drm/nouveau: Do not override forced connector status

Arnd Bergmann <arnd@arndb.de>
    x86/irq: Define trace events conditionally

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't truncate cached, mutated symlink

Daniel Wagner <wagi@kernel.org>
    nvme: only allow entering LIVE from CONNECTING state

Yu-Chun Lin <eleanor15x@gmail.com>
    sctp: Fix undefined behavior in left shift operation

Ruozhu Li <david.li@jaguarmicro.com>
    nvmet-rdma: recheck queue state is LIVE in state lock in recv done

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't indicate warning on rsnd_kctrl_accept_runtime()

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Fix CHPID "configure" attribute caching

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: ignore non-functional sensor in HP 5MP Camera

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell

Gannon Kolding <gannon.kolding@gmail.com>
    ACPI: resource: IRQ override for Eluktronics MECH-17

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix kernel oops when debug level > 2

Chengen Du <chengen.du@canonical.com>
    iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    powercap: call put_device() on an error path in powercap_register_control_type()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hrtimers: Mark is_migration_base() with __always_inline

Daniel Wagner <wagi@kernel.org>
    nvme-fc: go straight to connecting state when initializing

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices

Alexey Kashavkin <akashavkin@gmail.com>
    netfilter: nft_exthdr: fix offset with ipv4_find_option()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: Prevent creation of classes with TC_H_ROOT

Dan Carpenter <dan.carpenter@linaro.org>
    ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Kohei Enju <enjuk@amazon.com>
    netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()

Davidlohr Bueso <dave@stgolabs.net>
    drivers/hv: Replace binary semaphore with mutex

Breno Leitao <leitao@debian.org>
    netpoll: hold rcu read lock in __netpoll_send_skb()

Eric Dumazet <edumazet@google.com>
    netpoll: netpoll_send_skb() returns transmit status

Eric Dumazet <edumazet@google.com>
    netpoll: move netpoll_send_skb() out of line

Eric Dumazet <edumazet@google.com>
    netpoll: remove dev argument from netpoll_send_skb_on_dev()

Yunjian Wang <wangyunjian@huawei.com>
    netpoll: Fix use correct return type for ndo_start_xmit()

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Fix incorrect regmap max_registers value

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: auth_enable: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy

Magali Lemes <magali.lemes@canonical.com>
    Revert "sctp: sysctl: auth_enable: avoid using current->nsproxy"

Magali Lemes <magali.lemes@canonical.com>
    Revert "sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy"

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Prevent boot crash when the boot CPU is nohz_full

David Woodhouse <dwmw@amazon.co.uk>
    clockevents/drivers/i8253: Fix stop sequence for timer 0

Eric Dumazet <edumazet@google.com>
    vlan: fix memory leak in vlan_newlink()


-------------

Diffstat:

 Documentation/timers/no_hz.rst                     |   7 +-
 Makefile                                           |   4 +-
 arch/arm/mach-shmobile/headsmp.S                   |   1 +
 arch/arm/mm/fault.c                                |   8 ++
 arch/powerpc/platforms/cell/spufs/inode.c          |   9 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/entry/calling.h                           |   2 +
 arch/x86/include/asm/tlbflush.h                    |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  11 --
 arch/x86/kernel/dumpstack.c                        |   5 +-
 arch/x86/kernel/irq.c                              |   2 +
 arch/x86/kernel/process.c                          |   7 +-
 arch/x86/kernel/tsc.c                              |   4 +-
 arch/x86/mm/pageattr-test.c                        |   2 +-
 block/bio.c                                        |   2 +-
 drivers/acpi/resource.c                            |  13 ++
 drivers/base/power/main.c                          |   8 +-
 drivers/clk/meson/g12a.c                           |  38 ++++--
 drivers/clk/meson/gxbb.c                           |  14 +-
 drivers/clk/rockchip/clk-rk3328.c                  |   2 +-
 drivers/clocksource/i8253.c                        |  36 ++++--
 drivers/counter/stm32-lptimer-cnt.c                |  24 ++--
 drivers/cpufreq/cpufreq_governor.c                 |  45 +++----
 drivers/edac/ie31200_edac.c                        |  19 +--
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/firmware/iscsi_ibft.c                      |   5 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   7 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   4 +
 drivers/gpu/drm/drm_connector.c                    |   4 +
 drivers/gpu/drm/gma500/mid_bios.c                  |   5 +
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |   8 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 -
 drivers/gpu/drm/radeon/radeon_vce.c                |   2 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-plantronics.c                      | 144 ++++++++++-----------
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |   6 +-
 drivers/hv/vmbus_drv.c                             |  23 +++-
 drivers/hwmon/nct6775.c                            |   4 +-
 drivers/hwtracing/coresight/coresight-catu.c       |   2 +-
 drivers/i2c/busses/i2c-ali1535.c                   |  12 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |  12 +-
 drivers/i2c/busses/i2c-omap.c                      |  26 +---
 drivers/i2c/busses/i2c-sis630.c                    |  12 +-
 drivers/iio/accel/mma8452.c                        |  10 +-
 drivers/infiniband/core/mad.c                      |  38 +++---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 -
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   2 +-
 drivers/media/dvb-frontends/dib8000.c              |   5 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/mfd/sm501.c                                |   6 +-
 drivers/mmc/host/atmel-mci.c                       |   4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   1 +
 drivers/net/arcnet/com20020-pci.c                  |  17 ++-
 drivers/net/can/flexcan.c                          |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  11 +-
 drivers/net/dsa/mv88e6xxx/phy.c                    |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/usbnet.c                           |  21 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  86 ++++++++----
 drivers/ntb/hw/intel/ntb_hw_gen3.c                 |   3 +
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |   2 +-
 drivers/ntb/test/ntb_perf.c                        |   4 +-
 drivers/nvme/host/core.c                           |   2 -
 drivers/nvme/host/fc.c                             |   3 +-
 drivers/nvme/target/rdma.c                         |  33 +++--
 drivers/pci/hotplug/pciehp_hpc.c                   |   4 +-
 drivers/pci/pcie/aspm.c                            |  17 +--
 drivers/pci/pcie/portdrv_core.c                    |   8 +-
 drivers/pci/probe.c                                |   5 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/pinctrl/pinctrl-rza2.c                     |   2 +
 drivers/power/supply/max77693_charger.c            |   2 +-
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/s390/cio/chp.c                             |   3 +-
 drivers/scsi/qla1280.c                             |   2 +-
 .../intel/int340x_thermal/int3402_thermal.c        |   3 +
 drivers/tty/serial/8250/8250_dma.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  16 +++
 drivers/usb/serial/ftdi_sio.c                      |  14 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 ++
 drivers/usb/serial/option.c                        |  48 ++++---
 drivers/video/console/Kconfig                      |   2 +-
 drivers/video/fbdev/au1100fb.c                     |   4 +-
 drivers/video/fbdev/sm501fb.c                      |   7 +
 fs/affs/file.c                                     |   9 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/isofs/dir.c                                     |   3 +-
 fs/jfs/jfs_dtree.c                                 |   3 +-
 fs/jfs/xattr.c                                     |  13 +-
 fs/namei.c                                         |  24 +++-
 fs/ocfs2/alloc.c                                   |   8 ++
 fs/proc/base.c                                     |   2 +-
 include/linux/fs.h                                 |   2 +
 include/linux/i8253.h                              |   1 -
 include/linux/interrupt.h                          |   8 +-
 include/linux/netpoll.h                            |  10 +-
 include/linux/sched/smt.h                          |   2 +-
 kernel/events/ring_buffer.c                        |   2 +-
 kernel/kexec_elf.c                                 |   2 +-
 kernel/locking/semaphore.c                         |  13 +-
 kernel/sched/deadline.c                            |   2 +-
 kernel/time/hrtimer.c                              |  22 ++--
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ring_buffer.c                         |   4 +-
 kernel/trace/trace_functions_graph.c               |   1 +
 kernel/trace/trace_irqsoff.c                       |   2 -
 kernel/trace/trace_sched_wakeup.c                  |   2 -
 lib/842/842_compress.c                             |   2 +
 net/8021q/vlan_netlink.c                           |  10 +-
 net/atm/lec.c                                      |   3 +-
 net/atm/mpc.c                                      |   2 +
 net/batman-adv/bat_iv_ogm.c                        |   3 +-
 net/batman-adv/bat_v_ogm.c                         |   3 +-
 net/bluetooth/6lowpan.c                            |   7 +-
 net/can/af_can.c                                   |  12 +-
 net/can/af_can.h                                   |  12 +-
 net/can/proc.c                                     |  46 ++++---
 net/core/neighbour.c                               |   1 +
 net/core/netpoll.c                                 |  38 ++++--
 net/ipv6/addrconf.c                                |  37 ++++--
 net/ipv6/calipso.c                                 |  21 ++-
 net/ipv6/netfilter/nf_socket_ipv6.c                |  23 ++++
 net/ipv6/route.c                                   |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   8 +-
 net/netfilter/nf_conncount.c                       |   2 +
 net/netfilter/nft_exthdr.c                         |  10 +-
 net/sched/sch_api.c                                |   6 +
 net/sched/sch_skbprio.c                            |   3 -
 net/sctp/stream.c                                  |   2 +-
 net/sctp/sysctl.c                                  |   6 +-
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/xfrm/xfrm_output.c                             |   2 +-
 scripts/selinux/install_policy.sh                  |  15 +--
 sound/pci/hda/patch_realtek.c                      |   6 +-
 sound/soc/codecs/wm0010.c                          |  13 +-
 sound/soc/sh/rcar/core.c                           |  14 --
 sound/soc/sh/rcar/rsnd.h                           |   1 -
 sound/soc/sh/rcar/src.c                            |  18 ++-
 sound/usb/mixer_quirks.c                           |  51 ++++++++
 tools/perf/util/python.c                           |  13 +-
 tools/perf/util/units.c                            |   2 +-
 148 files changed, 1002 insertions(+), 535 deletions(-)


