Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8A615E97;
	Wed,  9 Apr 2025 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744200227; cv=none; b=A9xp1IHM24I30RHhV5KtpTfRpqMq/l8j1ouT74tNwmfsgrf8g7IQBFFwONR0E3ezLKoxD6bw0RTJe+CfCe3L0yO6P7XwM5RMQdQ9SzPAbFDvWClbtZavx2kERX727rGGZWjdMQst3cF+y5x6rlE7VfEE587tBUJnh7C8h6WrpBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744200227; c=relaxed/simple;
	bh=H7ZV9L9JjZXARGve1wtaaER779oTUCKTk2fl8yJPEvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=svZ1Ce0pAVJH6HAGWwtNTaDig+X/+I9CbB+Arm07W0bknQUUzLD4O0HFCxWossCsQzvgnZZY5jeH7MGvvqsgfMR8M1EomQ//wTL+JIqK4VOV20iTBd+KtvYLt1YUYrikXgBATH6FnTPAiK9J5j1O8shrCQzj4LKb5gkpLPc6It0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlivuDO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlivuDO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BAEC4CEE3;
	Wed,  9 Apr 2025 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744200227;
	bh=H7ZV9L9JjZXARGve1wtaaER779oTUCKTk2fl8yJPEvc=;
	h=From:To:Cc:Subject:Date:From;
	b=PlivuDO+heL1NdJeKIuE1A69yliVC4HVo4otCJpUQWG0tNEyYMRTKi3eEaLdUKVto
	 kXq5hf/8VTPHLraI5R0/xTi913Vy/LSb9tKgHdwua8fuPgwSoNh7I7o/zRYOI/Y+9q
	 IxbsUk4dSUj/IbA7VAadhsyrI0bulRSgCZSNONYc=
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
Subject: [PATCH 5.10 000/228] 5.10.236-rc2 review
Date: Wed,  9 Apr 2025 14:02:11 +0200
Message-ID: <20250409115831.755826974@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.236-rc2
X-KernelTest-Deadline: 2025-04-11T11:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.236 release.
There are 228 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Apr 2025 11:57:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.236-rc2

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not use PERF enums when perf is not defined

Takashi Iwai <tiwai@suse.de>
    x86/kexec: Fix double-free of elf header buffer

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix crash due to confirmed bit load reordering

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Skip sending CB_RECALL_ANY when the backchannel isn't up

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: put dl_stid if fail to queue dl_recall

Roman Smirnov <r.smirnov@omp.ru>
    jfs: add index corruption check to DT_GETPAGE()

Qasim Ijaz <qasdev00@gmail.com>
    jfs: fix slab-out-of-bounds read in ea_get()

Acs, Jakub <acsjakub@amazon.de>
    ext4: fix OOB read when checking dotdot dir

Theodore Ts'o <tytso@mit.edu>
    ext4: don't over-report free space or inodes in statvfs

Douglas Raillard <douglas.raillard@arm.com>
    tracing: Ensure module defining synth event cannot be unloaded while tracing

Tengda Wu <wutengda@huaweicloud.com>
    tracing: Fix use-after-free in print_graph_function_flags during tracer switching

Karel Balej <balejk@matfyz.cz>
    mmc: sdhci-pxav3: set NEED_RSP_BUSY capability

Paul Menzel <pmenzel@molgen.mpg.de>
    ACPI: resource: Skip IRQ override on ASUS Vivobook 14 X1404VAP

Murad Masimov <m.masimov@mt-integration.ru>
    acpi: nfit: fix narrowing conversion in acpi_nfit_ctl

Jann Horn <jannh@google.com>
    x86/mm: Fix flush_tlb_range() when used for zapping normal PMDs

Guilherme G. Piccoli <gpiccoli@igalia.com>
    x86/tsc: Always save/restore TSC sched_clock() on suspend/resume

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle errors from btrfs_dec_ref() properly

Markus Elfring <elfring@users.sourceforge.net>
    ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Skip inactive planes within ModeSupportAndSystemConfiguration

Jesse Zhang <jesse.zhang@amd.com>
    drm/amd/pm: Fix negative array index read

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: use UARTMODIR register bits for lpuart32 platform

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: only change CAN state when link up in system PM

Henry Martin <bsdhenrymartin@gmail.com>
    arcnet: Add NULL check in com20020pci_probe()

Lin Ma <linma@zju.edu.cn>
    net: fix geneve_opt length integer overflow

David Oberhollenzer <david.oberhollenzer@sigma-star.at>
    net: dsa: mv88e6xxx: propperly shutdown PPU re-enable timer on destroy

Fernando Fernandez Mancera <ffmancera@riseup.net>
    ipv6: fix omitted netlink attributes when using RTEXT_FILTER_SKIP_STATS

Lin Ma <linma@zju.edu.cn>
    netfilter: nft_tunnel: fix geneve_opt type confusion addition

Guillaume Nault <gnault@redhat.com>
    tunnels: Accept PACKET_HOST in skb_tunnel_check_pmtu().

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

Navon John Lukose <navonjohnlukose@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion x360 14-dy1xxx

Waiman Long <longman@redhat.com>
    locking/semaphore: Use wake_q to wake up processes outside lock critical section

Shrikanth Hegde <sshegde@linux.ibm.com>
    sched/deadline: Use online cpus for validating runtime

Dmitry Panchenko <dmitry@d-systems.ee>
    platform/x86: intel-hid: fix volume buttons on Microsoft Surface Go 4 tablet

Simon Tatham <anakin@pobox.com>
    affs: don't write overlarge OFS data block size fields

Simon Tatham <anakin@pobox.com>
    affs: generate OFS sequence numbers starting at 1

Icenowy Zheng <uwu@icenowy.me>
    nvme-pci: skip CMB blocks incompatible with PCI P2P DMA

Icenowy Zheng <uwu@icenowy.me>
    nvme-pci: clean up CMBMSC when registering CMB fails

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible UAF in nvme_tcp_poll

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fw: allocate chained SG tables for dump

Josh Poimboeuf <jpoimboe@kernel.org>
    sched/smt: Always inline sched_smt_active()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix mbox INTR handler when num VFs > 64

Giovanni Gherdovich <ggherdovich@suse.cz>
    ACPI: processor: idle: Return an error if both P_LVL{2,3} idle states are invalid

Feng Yang <yangfeng@kylinos.cn>
    ring-buffer: Fix bytes_dropped calculation issue

Mark Zhang <markzhang@nvidia.com>
    rtnetlink: Allocate vfinfo size for VF GUIDs when supported

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix the infinite loop in exfat_find_last_cluster()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()

Bart Van Assche <bvanassche@acm.org>
    fs/procfs: fix the comment above proc_pid_wchan()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Check if there is space to copy all the event

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Don't keep a raw_data pointer to consumed ring buffer space

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Decrement the refcount of just created event on failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Fixup description of sample.id event member

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't trigger uneccessary scans for return-on-close delegations

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

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for aead auth key length

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

Prathamesh Shete <pshete@nvidia.com>
    pinctrl: tegra: Set SFIO mode to Mux Register

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

Will McVicker <willmcvicker@google.com>
    clk: samsung: Fix UBSAN panic in samsung_clk_init()

Luca Weiss <luca@lucaweiss.eu>
    remoteproc: qcom_q6v5_pas: Make single-PD handling more robust

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
    drm/mediatek: dsi: fix error codes in mtk_dsi_host_transfer()

Thippeswamy Havalige <thippeswamy.havalige@amd.com>
    PCI: xilinx-cpm: Fix IRQ domain leak in error path of probe

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: Remove stray put_device() in pci_register_host_bridge()

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    drm/amd/display: fix type mismatch in CalculateDynamicMetadataParameters()

Feng Tang <feng.tang@linux.alibaba.com>
    PCI/portdrv: Only disable pciehp interrupts early when needed

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Use internal register to change link capability

Hans Zhang <18255117159@163.com>
    PCI: cadence-ep: Fix the driver to send MSG TLP for INTx without data payload

Daniel Stodden <daniel.stodden@gmail.com>
    PCI/ASPM: Fix link state exit during switch upstream function removal

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_hdmi: Fix typo for aud_sampe_size member

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_hdmi: Unregister audio platform device on failure

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm: xlnx: zynqmp: Fix max dma segment size

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Fix drm RAD print

Jayesh Choudhary <j-choudhary@ti.com>
    ASoC: ti: j721e-evm: Fix clock configuration for ti,j7200-cpb-audio compatible

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Adjust check before setting power.must_resume

Arnd Bergmann <arnd@arndb.de>
    x86/platform: Only allow CONFIG_EISA for 32-bit

Benjamin Berg <benjamin.berg@intel.com>
    x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()

Jie Zhan <zhanjie9@hisilicon.com>
    cpufreq: governor: Fix negative 'idle_time' handling in dbs_update()

zuoqian <zuoqian113@gmail.com>
    cpufreq: scpi: compare kHz instead of Hz

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: cpa-test: fix length for CPA_ARRAY test

Eric Sandeen <sandeen@redhat.com>
    watch_queue: fix pipe accounting mismatch

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: dev: check return value when calling dev_set_name()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    media: i2c: et8ek8: Don't strip remove function when driver is builtin

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

William Breathitt Gray <wbg@kernel.org>
    counter: microchip-tcb-capture: Fix undefined counter channel state on probe

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix error handling when enabling

Dhruv Deshpande <dhrv.d@proton.me>
    ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx

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

Saranya R <quic_sarar@quicinc.com>
    soc: qcom: pdr: Fix the potential deadlock

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore own maximum aggregation size during RX

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix race between element replace and close()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/amdgpu: Fix even more out of bound writes from debugfs

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: smp: Enforce shmobile_smp_* alignment

Ye Bin <yebin10@huawei.com>
    proc: fix UAF in proc_get_inode()

Gu Bowen <gubowen5@huawei.com>
    mmc: atmel-mci: Add missing clk_disable_unprepare()

Christian Eggers <ceggers@arri.de>
    regulator: check that dummy regulator has been probed before using it

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

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix soft lockup during bt pages loop

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Remove redundant 'phy_addr' in hns_roce_hem_list_find_mtt()

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: Don't mark timer regs unconfigured

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: PL011 UARTs are actually r1p5

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm_output: Force software GSO only in tunnel mode

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    firmware: imx-scu: fix OF node leak in .probe()

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Check for invalid input params when building scaling params

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix odm scaling

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Reject too small viewport size when validating plane

Lee Jones <lee.jones@linaro.org>
    drm/amd/display/dc/core/dc_resource: Staticify local functions

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Check plane scaling against format specific hw plane caps.

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

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix slab-use-after-free on hdcp_work

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: safety check before fallback

Arnd Bergmann <arnd@arndb.de>
    x86/irq: Define trace events conditionally

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't truncate cached, mutated symlink

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Set the SDOUT polarity correctly

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Fix power control mask

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Fix volume scale

Daniel Wagner <wagi@kernel.org>
    nvme: only allow entering LIVE from CONNECTING state

Yu-Chun Lin <eleanor15x@gmail.com>
    sctp: Fix undefined behavior in left shift operation

Ruozhu Li <david.li@jaguarmicro.com>
    nvmet-rdma: recheck queue state is LIVE in state lock in recv done

Terry Cheong <htcheong@chromium.org>
    ASoC: SOF: Intel: hda: add softdep pre to snd-hda-codec-hdmi module

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ASoC: arizona/madera: use fsleep() in up/down DAPM event delays.

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't indicate warning on rsnd_kctrl_accept_runtime()

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/cpufreq_cooling: Remove structure member documentation

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Fix CHPID "configure" attribute caching

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: ignore non-functional sensor in HP 5MP Camera

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell

Brahmajit Das <brahmajit.xyz@gmail.com>
    vboxsf: fix building with GCC 15

Eric W. Biederman <ebiederm@xmission.com>
    alpha/elf: Fix misc/setarch test of util-linux by removing 32bit support

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

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: handle errors in mlx5_chains_create_table()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()

Breno Leitao <leitao@debian.org>
    netpoll: hold rcu read lock in __netpoll_send_skb()

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix memory leak in aRFS after reset

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: fix use after free when attaching zone template

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: convert to refcount_t api

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Fix incorrect regmap max_registers value

Michael Kelley <mhklinux@outlook.com>
    fbdev: hyperv_fb: iounmap() the correct memory when removing a device

Baoquan He <bhe@redhat.com>
    x86/kexec: fix memory leak of elf header buffer

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't in-kernel

Wang Yufen <wangyufen@huawei.com>
    ipv6: Fix signed integer overflow in __ip6_append_data

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
 arch/alpha/include/asm/elf.h                       |   6 +-
 arch/alpha/include/asm/pgtable.h                   |   2 +-
 arch/alpha/include/asm/processor.h                 |   8 +-
 arch/alpha/kernel/osf_sys.c                        |  11 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  11 +-
 arch/arm/mach-shmobile/headsmp.S                   |   1 +
 arch/arm/mm/fault.c                                |   8 +
 arch/powerpc/platforms/cell/spufs/inode.c          |   9 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/entry/calling.h                           |   2 +
 arch/x86/include/asm/tlbflush.h                    |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  11 -
 arch/x86/kernel/crash.c                            |   4 +-
 arch/x86/kernel/dumpstack.c                        |   5 +-
 arch/x86/kernel/irq.c                              |   2 +
 arch/x86/kernel/machine_kexec_64.c                 |  12 +-
 arch/x86/kernel/process.c                          |   7 +-
 arch/x86/kernel/tsc.c                              |   4 +-
 arch/x86/kvm/hyperv.c                              |   6 +-
 arch/x86/mm/pat/cpa-test.c                         |   2 +-
 block/bio.c                                        |   2 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/acpi/processor_idle.c                      |   4 +
 drivers/acpi/resource.c                            |  13 +
 drivers/base/power/main.c                          |  21 +-
 drivers/base/power/runtime.c                       |   2 +-
 drivers/clk/meson/g12a.c                           |  38 +-
 drivers/clk/meson/gxbb.c                           |  14 +-
 drivers/clk/rockchip/clk-rk3328.c                  |   2 +-
 drivers/clk/samsung/clk.c                          |   2 +-
 drivers/clocksource/i8253.c                        |  36 +-
 drivers/counter/microchip-tcb-capture.c            |  19 +
 drivers/counter/stm32-lptimer-cnt.c                |  24 +-
 drivers/cpufreq/cpufreq_governor.c                 |  45 +-
 drivers/cpufreq/scpi-cpufreq.c                     |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   8 +-
 drivers/edac/ie31200_edac.c                        |  19 +-
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/firmware/iscsi_ibft.c                      |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 106 +++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  14 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  | 589 ++++++++-------------
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 drivers/gpu/drm/amd/display/dc/dc_types.h          |   5 -
 .../gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c  |  12 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  14 +-
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |  12 +-
 .../drm/amd/display/dc/dml/display_mode_structs.h  |   2 +
 .../gpu/drm/amd/display/dc/dml/display_mode_vba.c  |  40 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/transform.h  |   4 -
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  21 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   4 +
 drivers/gpu/drm/drm_connector.c                    |   4 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |   8 +-
 drivers/gpu/drm/gma500/mid_bios.c                  |   5 +
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   6 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |  33 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 -
 drivers/gpu/drm/radeon/radeon_vce.c                |   2 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |   2 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-plantronics.c                      | 144 +++--
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |   6 +-
 drivers/hv/vmbus_drv.c                             |  13 +
 drivers/hwmon/nct6775.c                            |   4 +-
 drivers/hwtracing/coresight/coresight-catu.c       |   2 +-
 drivers/i2c/busses/i2c-ali1535.c                   |  12 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |  12 +-
 drivers/i2c/busses/i2c-omap.c                      |  26 +-
 drivers/i2c/busses/i2c-sis630.c                    |  12 +-
 drivers/i2c/i2c-dev.c                              |  15 +-
 drivers/iio/accel/mma8452.c                        |  10 +-
 drivers/infiniband/core/mad.c                      |  38 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  23 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   2 +-
 drivers/media/dvb-frontends/dib8000.c              |   5 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   4 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/mfd/sm501.c                                |   6 +-
 drivers/mmc/host/atmel-mci.c                       |   4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   1 +
 drivers/net/arcnet/com20020-pci.c                  |  17 +-
 drivers/net/can/flexcan.c                          |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  11 +-
 drivers/net/dsa/mv88e6xxx/phy.c                    |   3 +
 drivers/net/ethernet/intel/ice/ice_arfs.c          |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   5 +
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/usbnet.c                           |  21 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  86 ++-
 drivers/ntb/hw/intel/ntb_hw_gen3.c                 |   3 +
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |   2 +-
 drivers/ntb/test/ntb_perf.c                        |   4 +-
 drivers/nvme/host/core.c                           |   2 -
 drivers/nvme/host/fc.c                             |   3 +-
 drivers/nvme/host/pci.c                            |  21 +-
 drivers/nvme/host/tcp.c                            |   5 +-
 drivers/nvme/target/rdma.c                         |  33 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   3 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |   4 +-
 drivers/pci/controller/pcie-xilinx-cpm.c           |  10 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   4 +-
 drivers/pci/pcie/aspm.c                            |  17 +-
 drivers/pci/pcie/portdrv_core.c                    |   8 +-
 drivers/pci/probe.c                                |   5 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c             |   2 +
 drivers/pinctrl/tegra/pinctrl-tegra.c              |   3 +
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/power/supply/max77693_charger.c            |   2 +-
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/regulator/core.c                           |  12 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  10 +-
 drivers/s390/cio/chp.c                             |   3 +-
 drivers/scsi/qla1280.c                             |   2 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/thermal/cpufreq_cooling.c                  |   2 -
 .../intel/int340x_thermal/int3402_thermal.c        |   3 +
 drivers/tty/serial/8250/8250_dma.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  16 +
 drivers/tty/serial/fsl_lpuart.c                    |  25 +-
 drivers/usb/serial/ftdi_sio.c                      |  14 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 +
 drivers/usb/serial/option.c                        |  48 +-
 drivers/video/console/Kconfig                      |   2 +-
 drivers/video/fbdev/au1100fb.c                     |   4 +-
 drivers/video/fbdev/hyperv_fb.c                    |   2 +-
 drivers/video/fbdev/sm501fb.c                      |   7 +
 fs/affs/file.c                                     |   9 +-
 fs/btrfs/extent-tree.c                             |   5 +-
 fs/exfat/fatent.c                                  |   2 +-
 fs/ext4/dir.c                                      |   3 +
 fs/ext4/super.c                                    |  27 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/isofs/dir.c                                     |   3 +-
 fs/jfs/jfs_dtree.c                                 |   3 +-
 fs/jfs/xattr.c                                     |  13 +-
 fs/namei.c                                         |  24 +-
 fs/nfs/delegation.c                                |  33 +-
 fs/nfsd/nfs4state.c                                |  31 +-
 fs/ocfs2/alloc.c                                   |   8 +
 fs/proc/base.c                                     |   2 +-
 fs/proc/generic.c                                  |  10 +-
 fs/proc/inode.c                                    |   6 +-
 fs/proc/internal.h                                 |  14 +
 fs/vboxsf/super.c                                  |   3 +-
 include/drm/drm_dp_mst_helper.h                    |   7 +
 include/linux/fs.h                                 |   2 +
 include/linux/i8253.h                              |   1 -
 include/linux/interrupt.h                          |   8 +-
 include/linux/netfilter/nf_conntrack_common.h      |   8 +-
 include/linux/pm_runtime.h                         |   2 +
 include/linux/proc_fs.h                            |   7 +-
 include/linux/sched/smt.h                          |   2 +-
 include/net/ipv6.h                                 |   4 +-
 kernel/events/ring_buffer.c                        |   2 +-
 kernel/kexec_elf.c                                 |   2 +-
 kernel/locking/semaphore.c                         |  13 +-
 kernel/sched/deadline.c                            |   2 +-
 kernel/time/hrtimer.c                              |  22 +-
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ring_buffer.c                         |   4 +-
 kernel/trace/trace_events_synth.c                  |  34 +-
 kernel/trace/trace_functions_graph.c               |   1 +
 kernel/trace/trace_irqsoff.c                       |   2 -
 kernel/trace/trace_sched_wakeup.c                  |   2 -
 kernel/watch_queue.c                               |   9 +
 lib/842/842_compress.c                             |   2 +
 net/8021q/vlan_netlink.c                           |  10 +-
 net/atm/lec.c                                      |   3 +-
 net/atm/mpc.c                                      |   2 +
 net/batman-adv/bat_iv_ogm.c                        |   3 +-
 net/batman-adv/bat_v_ogm.c                         |   3 +-
 net/bluetooth/6lowpan.c                            |   7 +-
 net/bluetooth/hci_event.c                          |  13 +-
 net/can/af_can.c                                   |  12 +-
 net/can/af_can.h                                   |  12 +-
 net/can/proc.c                                     |  46 +-
 net/core/neighbour.c                               |   1 +
 net/core/netpoll.c                                 |   9 +-
 net/core/rtnetlink.c                               |   3 +
 net/core/sock_map.c                                |   5 +-
 net/ipv4/ip_tunnel_core.c                          |   4 +-
 net/ipv6/addrconf.c                                |  37 +-
 net/ipv6/calipso.c                                 |  21 +-
 net/ipv6/ip6_output.c                              |   6 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |  23 +
 net/ipv6/route.c                                   |   5 +-
 net/mptcp/protocol.h                               |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   8 +-
 net/netfilter/nf_conncount.c                       |   2 +
 net/netfilter/nf_conntrack_core.c                  |  48 +-
 net/netfilter/nf_conntrack_expect.c                |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   7 +-
 net/netfilter/nf_conntrack_standalone.c            |   7 +-
 net/netfilter/nf_flow_table_core.c                 |   2 +-
 net/netfilter/nf_synproxy_core.c                   |   1 -
 net/netfilter/nft_ct.c                             |  11 +-
 net/netfilter/nft_exthdr.c                         |  10 +-
 net/netfilter/nft_tunnel.c                         |   6 +-
 net/netfilter/xt_CT.c                              |   3 +-
 net/openvswitch/actions.c                          |   6 -
 net/openvswitch/conntrack.c                        |   1 -
 net/sched/act_ct.c                                 |   1 -
 net/sched/act_tunnel_key.c                         |   2 +-
 net/sched/cls_flower.c                             |   2 +-
 net/sched/sch_api.c                                |   6 +
 net/sched/sch_skbprio.c                            |   3 -
 net/sctp/stream.c                                  |   2 +-
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/xfrm/xfrm_output.c                             |   2 +-
 scripts/selinux/install_policy.sh                  |  15 +-
 sound/pci/hda/patch_realtek.c                      |  28 +-
 sound/soc/codecs/arizona.c                         |  14 +-
 sound/soc/codecs/madera.c                          |  10 +-
 sound/soc/codecs/tas2764.c                         |  10 +-
 sound/soc/codecs/tas2764.h                         |   8 +-
 sound/soc/codecs/tas2770.c                         |   2 +-
 sound/soc/codecs/wm0010.c                          |  13 +-
 sound/soc/codecs/wm5110.c                          |   8 +-
 sound/soc/sh/rcar/core.c                           |  14 -
 sound/soc/sh/rcar/rsnd.h                           |   1 -
 sound/soc/sh/rcar/src.c                            |  18 +-
 sound/soc/sof/intel/hda-codec.c                    |   1 +
 sound/soc/ti/j721e-evm.c                           |   2 +
 sound/usb/mixer_quirks.c                           |  51 ++
 tools/perf/util/python.c                           |  17 +-
 tools/perf/util/units.c                            |   2 +-
 243 files changed, 1867 insertions(+), 1177 deletions(-)


