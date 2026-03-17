Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C63EBF3F;
	Tue, 17 Mar 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765527; cv=none; b=FBJV04ZJok6w7xqGOD++AYj0uNi9kjFygzSdCIz0rfAZ49Mp/16yuDnROPpei8+xC2cZycvflKw/BNV9nVjVnvua8DMOIZTfe2ALKm0HTAkR61kvVjUJftEOwfg1XSceseiaJEo4okQZpu/ooly3fKSxiJqaz/rDg3rLzRkrgIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765527; c=relaxed/simple;
	bh=GGP4uufR0Kbt3BfgK9aDzYIT9JM/fDXd+/WnRW8WBME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ApqXUKeb29RhnZFwUpXkCew7Cca5XEk9cuFeWv4eYsES9IFQ4qeVyQ8GvPKcZZR5Hsy2RH7BKe2uwTw2vGrkc3g/cAAcZvYZu+XEtq+mtVTjlZsiHh1lDqwQHaN2hTVScCdL6lM/Vd36I68RPhDbi3dYfaCszbEqWVEeu4tRY8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePn99DLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePn99DLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD420C4CEF7;
	Tue, 17 Mar 2026 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765526;
	bh=GGP4uufR0Kbt3BfgK9aDzYIT9JM/fDXd+/WnRW8WBME=;
	h=From:To:Cc:Subject:Date:From;
	b=ePn99DLeHhuZ2Y5f8+vy94nHdAJn/F6CnB1z9OoXgAXwW3flT/0VT6YQ4BhQmjTWI
	 7+YbEdBxOydAp3Jhoew0pjTdQRolaEY3t1IwPUzUvm5iGV7HyxOoyJ4e6Vt8vXsHLe
	 j8irbM2rw934Y/MQxidh4CD3uWn+r2jBlH+Jvlyw=
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
Subject: [PATCH 6.19 000/378] 6.19.9-rc1 review
Date: Tue, 17 Mar 2026 17:29:17 +0100
Message-ID: <20260317163006.959177102@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.9-rc1
X-KernelTest-Deadline: 2026-03-19T16:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.9 release.
There are 378 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.9-rc1

Keith Busch <kbusch@kernel.org>
    cxl/acpi: Fix CXL_ACPI and CXL_PMEM Kconfig tristate mismatch

Jens Axboe <axboe@kernel.dk>
    io_uring/eventfd: use ctx->rings_rcu for flags checking

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure ctx->rings is stable for task work flags manipulation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Eagerly init vgic dist/redist on vgic creation

Sascha Bischoff <Sascha.Bischoff@arm.com>
    KVM: arm64: gic: Set vgic_model before initing private IRQs

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow non-power of two min_region_sz

SeongJae Park <sj@kernel.org>
    mm/damon: rename min_sz_region of damon_ctx to min_region_sz

SeongJae Park <sj@kernel.org>
    mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix race in DMA ring dequeue

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Add missing TID field to no-op command descriptor

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Consolidate spinlocks

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Factor out DMA mapping from queuing path

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors

Yasin Lee <yasin.lee.x@gmail.com>
    iio: proximity: hx9023s: Protect against division by zero in set_samp_freq

Yasin Lee <yasin.lee.x@gmail.com>
    iio: proximity: hx9023s: fix assignment order for __counted_by

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch when turning buffer off

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch to the same value

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm45600: fix INT1 drive bit inverted

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: light: bh1780: fix PM runtime leak on error path

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm45600: fix regulator put warning when probe fails

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-i2c: fix pm_runtime error handling

Radu Sabau <radu.sabau@analog.com>
    iio: imu: adis: Fix NULL pointer dereference in adis_init

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-core: fix pm_runtime error handling

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: Fix wait_queue not being removed

Chris Spencer <spencercw@gmail.com>
    iio: chemical: bme680: Fix measurement wait duration calculation

Lukas Schmid <lukas.schmid@netcube.li>
    iio: potentiometer: mcp4131: fix double application of wiper shift

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: magnetometer: tlv493d: remove erroneous shift in X-axis data

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()

SeungJu Cheon <suunj1331@gmail.com>
    iio: frequency: adf4377: Fix duplicated soft reset mask

Oleksij Rempel <o.rempel@pengutronix.de>
    iio: dac: ds4424: reject -128 RAW value

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update root in the received subvol ioctl

Bart Van Assche <bvanassche@acm.org>
    btrfs: add missing RCU unlock in error path in try_release_subpage_extent_buffer()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on set received ioctl due to item overflow

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on file creation due to name hash collision

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort when snapshotting received subvolumes

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix iface port assignment in parse_server_interfaces

Bharath SM <bharathsm@microsoft.com>
    smb: client: fix in-place encryption corruption in SMB2_write()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix atomic open with O_DIRECT & O_SYNC

Josh Law <objecting@objecting.org>
    lib/bootconfig: check bounds before writing in __xbc_open_brace()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()

Shashank Balaji <shashank.mahadasyam@sony.com>
    x86/apic: Disable x2apic on resume if the kernel expects so

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: core: Fix error handling for scsi_alloc_sdev()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/bpf: fix the address returned by bpf_get_func_ip

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/bpf: fix kfunc call support

Nam Cao <namcao@linutronix.de>
    powerpc/pseries: Correct MSI allocation tracking

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Copy detected format information to secondary device

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Move quiesce state with pprc swap

Mehul Rao <mehulrao@gmail.com>
    ublk: fix NULL pointer dereference in ublk_ctrl_set_size()

Abel Vesa <abel.vesa@oss.qualcomm.com>
    dt-bindings: display: msm: Fix reg ranges and clocks on Glymur

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Enable AUTOSEL_DOM for CCA serialnr sysfs attribute

Tejun Heo <tj@kernel.org>
    sched_ext: Fix enqueue_task_scx() truncation of upper enqueue flags

Long Li <leo.lilong@huawei.com>
    xfs: ensure dquot item is deleted from AIL only after log shutdown

Darrick J. Wong <djwong@kernel.org>
    xfs: fix undersized l_iclog_roundoff values

Carlos Maiolino <cem@kernel.org>
    xfs: fix returned valued from xfs_defer_can_append

Long Li <leo.lilong@huawei.com>
    xfs: fix integer overflow in bmap intent sort comparator

Shyam Prasad N <sprasad@microsoft.com>
    cifs: make default value of retrans as zero

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: check if target buffer list is still legacy on recycle

Haibo Chen <haibo.chen@nxp.com>
    can: dev: keep the max bitrate error at 5%

Laurent Vivier <lvivier@redhat.com>
    qmi_wwan: allow max_mtu above hard_mtu to control rx_urb_size

Paul Moses <p@1g4.org>
    net-shapers: don't free reply skb after genlmsg_reply()

Calvin Owens <calvin@wbinvd.org>
    tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G

Andrei-Alexandru Tachici <andrei-alexandru.tachici@oss.qualcomm.com>
    tracing: Fix enabling multiple events on the kernel command line and bootconfig

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Configure VRR timings after enabling TRANS_DDI_FUNC_CTL

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: Correct the SA8775P intr_underrun/intr_underrun index

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix a few more NULL pointer dereference in device cleanup

Thomas Fourier <fourier.thomas@gmail.com>
    drm/msm: Fix dma_free_attrs() buffer size

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Repeat Selective Update area alignment

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Fix potential overflow of shmem scatterlist length

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: halve horizontal syncs for dual LVDS output

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: fix CHA_DSI_CLK_RANGE rounding

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix NULL pointer dereference in device cleanup

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Set num IP blocks to 0 if discovery fails

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdgpu: Fix use-after-free race in VM acquire

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x

Kevin Hao <haokexin@gmail.com>
    net: macb: Shuffle the tx ring before enabling tx

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Fix error path in PTP IRQ setup

Fan Wu <fanwu01@zju.edu.cn>
    net: ethernet: arc: emac: quiesce interrupts before requesting IRQ

Jian Zhang <zhangjian.3032@bytedance.com>
    net: ncsi: fix skb leak in error paths

Mehul Rao <mehulrao@gmail.com>
    net: nexthop: fix percpu use-after-free in remove_nh_grp_entry

Johan Hovold <johan@kernel.org>
    net: mctp: fix device leak on probe failure

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free by using call_rcu() for oplock_info

Thorsten Blum <thorsten.blum@linux.dev>
    ksmbd: Don't log keys in SMB3 signing and encryption key generation

Marios Makassikis <mmakassikis@freebox.fr>
    smb: server: fix use-after-free in smb2_open()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()

Hao Li <hao.li@linux.dev>
    memcg: fix slab accounting in refill_obj_stock() trylock path

Vlastimil Babka <vbabka@suse.cz>
    slab: distinguish lock and trylock for sheaf_flush_main()

Vasily Gorbik <gor@linux.ibm.com>
    s390/xor: Fix xor_xc_5() inline assembly

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fallback to boot snapshot for dispclk

Heiko Carstens <hca@linux.ibm.com>
    s390/xor: Fix xor_xc_2() inline assembly constraints

Maximilian Pezzullo <maximilianpezzullo@gmail.com>
    ata: libata-core: Disable LPM on ST1000DM010-2EP102

Heiko Carstens <hca@linux.ibm.com>
    s390/stackleak: Fix __stackleak_poison() inline assembly constraint

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp - allow callers to use HV-Fixed page API when SEV is disabled

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/ttm: Fix ttm_pool_beneficial_order() return type

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Fix broken reset status read

Franz Schnyder <franz.schnyder@toradex.com>
    regulator: pf9453: Respect IRQ trigger settings from firmware

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: reject SEND_VECTORIZED when unsupported

Helge Deller <deller@gmx.de>
    parisc: Check kernel mapping earlier at bootup

Piotr Jaroszynski <pjaroszynski@nvidia.com>
    arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults

Helge Deller <deller@gmx.de>
    parisc: Fix initial page table creation for boot

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: use READ_ONCE with user shared RQEs

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/q54sj108a2) fix stack overflow in debugfs read

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation

Dave Airlie <airlied@redhat.com>
    nouveau/dpcd: return EBUSY for aux xfer if the device is asleep

Helge Deller <deller@gmx.de>
    parisc: Increase initial mapping to 64 MB with KALLSYMS

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: Fix PD_VCODEC for RK3588

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/xe2_hpg: Correct implementation of Wa_16025250150

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid double-rtnl_lock ELP metric worker

Eric Biggers <ebiggers@kernel.org>
    net/tcp-md5: Fix MAC comparison to be constant-time

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Fix thresh_return nosleeptime double-adjust

Eric Biggers <ebiggers@kernel.org>
    net/tcp-ao: Fix MAC comparison to be constant-time

Huiwen He <hehuiwen@kylinos.cn>
    tracing: Fix syscall events activation by ensuring refcount hits zero

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Fix thresh_return clear per-task notrace

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: fix retry for AQ command 0x06EE

YiFei Zhu <zhuyifei@google.com>
    net: Fix rcu_tasks stall in threaded busypoll

Long Li <longli@microsoft.com>
    net: mana: Ring doorbell at 4 CQ wraparounds

Ariel Silver <arielsilver77@gmail.com>
    media: dvb-net: fix OOB access in ULE extension header tables

Christian Brauner <brauner@kernel.org>
    selftests: fix mntns iteration selftests

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Don't miss reading the last bank registers

Luka Gejak <luka.gejak@linux.dev>
    staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()

Artem Lytkin <iprintercanon@gmail.com>
    staging: sm750fb: add missing pci_release_region on error and removal

Harry Yoo <harry.yoo@oracle.com>
    mm/slab: fix an incorrect check in obj_exts_alloc_size()

Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
    mm/damon/core: clear walk_control on inactive context in damos_walk()

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: fix a folio_split() race condition with folio_try_get()

Pratyush Yadav (Google) <pratyush@kernel.org>
    mm: memfd_luo: always dirty all folios

Pratyush Yadav (Google) <pratyush@kernel.org>
    mm: memfd_luo: always make all folios uptodate

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix link setup issue

Eric Biggers <ebiggers@kernel.org>
    kunit: irq: Ensure timer doesn't fire too frequently

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: reintroduce retry mechanism for indirect AQ

Christian Brauner <brauner@kernel.org>
    nstree: tighten permission checks for listing

Christian Brauner <brauner@kernel.org>
    nsfs: tighten permission checks for handle opening

Darrick J. Wong <djwong@kernel.org>
    iomap: reject delalloc mappings during writeback

Joanne Koong <joannelkoong@gmail.com>
    iomap: don't mark folio uptodate if read IO has bytes pending

Tejun Heo <tj@kernel.org>
    sched_ext: Fix starvation of scx_enable() under fair-class saturation

Tejun Heo <tj@kernel.org>
    sched_ext: Disable preemption between scx_claim_exit() and kicking helper work

Mark Harmstone <mark@harmstone.com>
    btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow secondary lookup in fwnode_get_next_child_node()

Kuniyuki Iwashima <kuniyu@google.com>
    nfsd: Fix cred ref leak in nfsd_nl_listener_set_doit().

Catalin Marinas <catalin.marinas@arm.com>
    arm64: gcs: Honour mprotect(PROT_NONE) on shadow stack mappings

Jiri Olsa <jolsa@kernel.org>
    bpf: Fix kprobe_multi cookies access in show_fdinfo callback

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/pfault: Fix virtual vs physical address confusion

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/sync: Cleanup partially initialized sync on parse failure

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/sync: Fix user fence leak on alloc failure

Corey Minyard <corey@minyard.net>
    ipmi:si: Fix check for a misbehaving BMC

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpiolib: normalize the return value of gc->get() on behalf of buggy drivers

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/alpm: ALPM disable fixes

Dave Airlie <airlied@redhat.com>
    nouveau/gsp: drop WARN_ON in ACPI probes

Corey Minyard <corey@minyard.net>
    ipmi:si: Handle waiting messages when BMC failure detected

Franz Schnyder <franz.schnyder@toradex.com>
    drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/bridge: samsung-dsim: Fix memory leak in error path

Corey Minyard <corey@minyard.net>
    ipmi:si: Use a long timeout when the BMC is misbehaving

Corey Minyard <corey@minyard.net>
    ipmi:si: Don't block module unload if the BMC is messed up

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Disable MES LR compute W/A

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: add upper bound check on user inputs in wait ioctl

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu/userq: Fix reference leak in amdgpu_userq_wait_ioctl

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: add upper bound check on user inputs in signal ioctl

David Arcari <darcari@redhat.com>
    cpufreq: intel_pstate: Fix NULL pointer dereference in update_cpu_qos_request()

Christian Brauner <brauner@kernel.org>
    kthread: consolidate kthread exit paths to prevent use-after-free

Pratyush Yadav (Google) <pratyush@kernel.org>
    liveupdate: luo_file: remember retrieve() status

Christian Brauner <brauner@kernel.org>
    nsfs: tighten permission checks for ns iteration ioctls

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    mm: Fix a hmm_range_fault() livelock / starvation problem

Axel Rasmussen <axelrasmussen@google.com>
    Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"

Xu Yang <xu.yang_2@nxp.com>
    Revert "tcpm: allow looking for role_sw device in the main node"

Ilya Dryomov <idryomov@gmail.com>
    libceph: admit message frames only in CEPH_CON_S_OPEN state

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Use u32 for non-negative values in ceph_monmap_decode()

Ilya Dryomov <idryomov@gmail.com>
    libceph: prevent potential out-of-bounds reads in process_message_header()

Ilya Dryomov <idryomov@gmail.com>
    libceph: reject preamble if control segment is empty

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()

Max Kellermann <max.kellermann@ionos.com>
    ceph: add a bunch of missing ceph_path_info initializers

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: avoid crash when rmmod/insmod after ftrace killed

Liwei Song <liwei.song@windriver.com>
    firmware: stratix10-rsu: Fix NULL pointer dereference when RSU is disabled

Mehul Rao <mehulrao@gmail.com>
    tipc: fix divide-by-zero in tipc_sk_filter_connect()

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: qcom: qdsp6: Fix q6apm remove ordering during ADSP stop and start

Penghe Geng <pgeng@nvidia.com>
    mmc: core: Avoid bitfield RMW for claim/retune flags

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: dw_mmc-rockchip: Fix runtime PM support for internal phase support

Kamal Dasu <kamal.dasu@broadcom.com>
    mmc: sdhci-brcmstb: use correct register offset for V1 pin_sel restore

Alexander Potapenko <glider@google.com>
    mm/kfence: disable KFENCE upon KASAN HW tags enablement

Felix Gu <ustc.gu@gmail.com>
    mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()

Alexander Potapenko <glider@google.com>
    mm/kfence: fix KASAN hardware tag faults during late enablement

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix NULL pointer exception during user_scan()

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    scsi: qla2xxx: Completely fix fcport double free

Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
    scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend

Viktor Malik <vmalik@redhat.com>
    powerpc, perf: Check that current->mm is alive before getting user callchain

Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
    i3c: dw-i3c-master: Set SIR_REJECT in DAT on device attach and reattach

Thomas Gleixner <tglx@kernel.org>
    sched/mmcid: Avoid full tasklist walks

Thomas Gleixner <tglx@kernel.org>
    sched/mmcid: Remove pointless preempt guard

Thomas Gleixner <tglx@kernel.org>
    sched/mmcid: Handle vfork()/CLONE_VM correctly

Thomas Gleixner <tglx@kernel.org>
    sched/mmcid: Prevent CID stalls due to concurrent forks

Steven Rostedt <rostedt@goodmis.org>
    time/jiffies: Mark jiffies_64_to_clock_t() notrace

Jessica Liu <liu.xuemei1@zte.com.cn>
    irqchip/riscv-aplic: Register syscore operations only once

Jessica Liu <liu.xuemei1@zte.com.cn>
    irqchip/riscv-aplic: Do not clear ACPI dependencies on probe failure

Nick Hu <nick.hu@sifive.com>
    irqchip/riscv-aplic: Preserve APLIC states across suspend/resume

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix another stack overflow in validate_branch()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix data alignment in elf_add_data()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix detection of corrupt static branch/call entries

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Improve Focusrite sample rate filtering

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix memory leaks in ceph_mdsc_build_path()

Hristo Venev <hristo@venev.name>
    ceph: do not skip the first folio of the next object in writeback

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix i_nlink underrun during async unlink

Kalesh Singh <kaleshsingh@google.com>
    mm/tracing: rss_stat: ensure curr is false from kthread context

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: gadget: u_ether: add gether_opts for config caching"

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: gadget: f_ncm: align net_device lifecycle with bind/unbind"

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: gadget: u_ether: Add auto-cleanup helper for freeing net_device"

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: legacy: ncm: Fix NPE in gncm_bind"

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: gadget: f_ncm: Fix atomic context locking issue"

Kuen-Han Tsai <khtsai@google.com>
    usb: legacy: ncm: Fix NPE in gncm_bind

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Fix atomic context locking issue

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    usb: gadget: f_tcm: Fix NULL pointer dereferences in nexus handling

Ziyi Guo <n7l8m4@u.northwestern.edu>
    usb: image: mdc800: kill download URB on timeout

Junzhong Pan <panjunzhong@linux.spacemit.com>
    usb: gadget: uvc: fix interval_duration calculation

Oliver Neukum <oneukum@suse.com>
    usb: mdc800: handle signal and read racing

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: f_hid: fix SuperSpeed descriptors

Fan Wu <fanwu01@zju.edu.cn>
    usb: renesas_usbhs: fix use-after-free in ISR during device removal

Oliver Neukum <oneukum@suse.com>
    usb: class: cdc-wdm: fix reordering issue in read code path

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Limit the length of unkillable synchronous timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbtmc: Use usb_bulk_msg_killable() with user-specified timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Introduce usb_bulk_msg_killable()

RD Babiera <rdbabiera@google.com>
    usb: typec: altmode/displayport: set displayport signaling rate in configure message

Xu Yang <xu.yang_2@nxp.com>
    usb: roles: get usb role switch from parent only for usb-b-connector

Marc Zyngier <maz@kernel.org>
    usb: cdc-acm: Restore CAP_BRK functionnality to CH343

Gabor Juhos <j4g8y7@gmail.com>
    usb: core: don't power off roothub PHYs if phy_set_mode() fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: misc: uss720: properly clean up reference in uss720_probe()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Nova Lake -H

Oliver Neukum <oneukum@suse.com>
    usb: yurex: fix race in probe

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix NULL pointer dereference when reading portli debugfs files

Dayu Jiang <jiangdayu@xiaomi.com>
    usb: xhci: Prevent interrupt storm on host controller error (HCE)

Zilin Guan <zilin@seu.edu.cn>
    usb: xhci: Fix memory leak in xhci_disable_slot()

Vyacheslav Vahnenko <vahnenko2003@gmail.com>
    USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed

Christoffer Sandberg <cs@tuxedo.de>
    usb/core/quirks: Add Huawei ME906S-device to wakeup quirk

A1RM4X <dev@a1rm4x.com>
    USB: add QUIRK_NO_BOS for video capture several devices

Marc Zyngier <maz@kernel.org>
    KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail

Marc Zyngier <maz@kernel.org>
    KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC

Jim Mattson <jmattson@google.com>
    KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix protected mode handling of pages larger than 4kB

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA

Pedro Falcato <pfalcato@suse.de>
    ata: libata-core: Add BRIDGE_OK quirk for QEMU drives

Alexandre Courbot <acourbot@nvidia.com>
    rust: str: make NullTerminatedFormatter public

Gary Guo <gary@garyguo.net>
    rust: kbuild: emit dep-info into $(depfile) directly

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: allow `unused_features`

Alice Ryhl <aliceryhl@google.com>
    rust_binder: call set_notification_done() without proc lock

Alice Ryhl <aliceryhl@google.com>
    rust_binder: avoid reading the written value in offsets array

Alice Ryhl <aliceryhl@google.com>
    rust_binder: check ownership before using vma

Carlos Llamas <cmllamas@google.com>
    rust_binder: fix oneway spam detection

Johan Hovold <johan@kernel.org>
    gpib: lpvo_usb: fix unintended binding of FTDI 8U232AM devices

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: skip LTM configuration for LAN7850

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix WARN in __netif_napi_del_locked on disconnect

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix TX byte statistics for small packets

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix silent drop of packets with checksum errors

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): always configure bitrates before starting device

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check endpoint numbers at parsing Scarlett2 mixer interfaces

Mehul Rao <mehulrao@gmail.com>
    ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    cgroup: Don't expose dead tasks in cgroup

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Remove redundant css_put() in scx_cgroup_init()

Qingye Zhao <zhaoqingye@honor.com>
    cgroup: fix race between task migration and iteration

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: ensure no_hw_access is visible before MMIO

Seungjin Bae <eeodqql09@gmail.com>
    usb: gadget: f_mass_storage: Fix potential integer overflow in check_command_size_in_blocks()

Andreas Kemnade <andreas@kemnade.info>
    iio: imu: inv-mpu9150: fix irq ack preventing irq storms

Eric Dumazet <edumazet@google.com>
    net: prevent NULL deref in ip[6]tunnel_xmit()

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter recovery condition

Chintan Vankar <c-vankar@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix rx_filter value for PTP support

Shiraz Saleem <shirazsaleem@microsoft.com>
    net/mana: Null service_wq on setup error to prevent double destroy

Sabrina Dubroca <sd@queasysnail.net>
    neighbour: restore protocol != 0 check in pneigh update

Marek Behún <kabel@kernel.org>
    net: dsa: realtek: Fix LED group port bit for non-zero LED group

Ricardo B. Marlière <rbm@suse.com>
    net: bonding: Fix nd_tbl NULL dereference when IPv6 is disabled

Chuck Lever <chuck.lever@oracle.com>
    perf synthetic-events: Fix stale build ID in module MMAP2 records

Tom Ryan <ryan36005@gmail.com>
    io_uring: fix physical SQE bounds check for SQE_MIXED 128-byte ops

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp-mach-common: Add missing error check for clock acquisition

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Unreserve bo if queue update failed

Casey Connolly <casey.connolly@linaro.org>
    ASoC: detect empty DMI strings

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition

Ben Dooks <ben.dooks@codethink.co.uk>
    ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: fix broken EEE by converting to phylib-managed state

Jakub Kicinski <kuba@kernel.org>
    page_pool: store detach_time as ktime_t to avoid false-negatives

Matt Vollrath <tactii@gmail.com>
    e1000/e1000e: Fix leak in DMA error cleanup

Alok Tiwari <alok.a.tiwari@oracle.com>
    i40e: fix src IP mask checks and memcpy argument names in cloud filter

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: codecs: rt1011: Use component to get the dapm context in spk_mode_put

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix runtime suspend deadlock when there is pending job

Petr Oros <poros@redhat.com>
    iavf: fix incorrect reset handling in callbacks

Petr Oros <poros@redhat.com>
    iavf: fix PTP use-after-free during reset

Nikolay Aleksandrov <razor@blackwall.org>
    drivers: net: ice: fix devlink parameters get without irdma

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix race bug in nvme_poll_irqdisable()

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix slab-out-of-bounds in nvme_dbbuf_set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Make skipping governor callbacks more consistent

Chen Ni <nichen@iscas.ac.cn>
    perf ftrace: Fix hashmap__new() error checking

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Correct probed name for PCA9452

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Correct interrupt type

Chen Ni <nichen@iscas.ac.cn>
    perf annotate: Fix hashmap__new() error checking

Yuan Tan <tanyuan98@outlook.com>
    netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path

David Dull <monderasdor@gmail.com>
    netfilter: x_tables: guard option walkers against 1-byte tail reads

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: always walk all pending catchall elements

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Fix for duplicate device in netdev hooks

Weiming Shi <bestswngs@gmail.com>
    net: add xmit recursion limit to tunnel xmit functions

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: reset PHY settings before starting PHY

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: prevent CRC errors during RX adaptation with AN disabled

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix link status handling in xgbe_rx_adaptation

Chengfeng Ye <dg573847474@gmail.com>
    mctp: route: hold key->lock in mctp_flow_prepare_output()

Jiayuan Chen <jiayuan.chen@shopee.com>
    bonding: fix type confusion in bond_setup_by_slave()

Wenyuan Li <2063309626@qq.com>
    can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value

Haiyue Wang <haiyuewa@163.com>
    mctp: i2c: fix skb memory leak in receive path

Wei Fang <wei.fang@nxp.com>
    net: enetc: do not skip setting LaBCR[MDIO_PHYAD_PRTAD] for addr 0

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix incorrect fallback PHY address handling

Arun R Murthy <arun.r.murthy@intel.com>
    drm/i915/dp: Read ALPM caps after DPCD init

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix RSS table size check when changing ethtool channels

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    serial: caif: hold tty->link reference in ldisc_open and ser_release

Álvaro Fernández Rojas <noltari@gmail.com>
    net: sfp: improve Huawei MA5671a fixup

Sen Wang <sen@ti.com>
    ASoC: simple-card-utils: fix graph_util_is_ports0() for DT overlays

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: flush delayed work before removing DAIs and widgets

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: drop delayed_work_pending() check before flush

Felix Gu <ustc.gu@gmail.com>
    spi: rockchip-sfc: Fix double-free in remove() callback

Felix Gu <ustc.gu@gmail.com>
    spi: amlogic: spifc-a4: Fix DMA mapping error handling

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Fix fragmentation regression in firmware download

David Lechner <dlechner@baylibre.com>
    drm/sitronix/st7586: fix bad pixel data due to byte swap

Vivian Wang <wangruikang@iscas.ac.cn>
    net: spacemit: Fix error handling in emac_tx_mem_map()

Vivian Wang <wangruikang@iscas.ac.cn>
    net: spacemit: Fix error handling in emac_alloc_rx_desc_buffers()

Miaoqian Lin <linmq006@gmail.com>
    rxrpc, afs: Fix missing error pointer check after rxrpc_kernel_lookup_peer()

Weiming Shi <bestswngs@gmail.com>
    net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for legacy RQ

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for striding RQ

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Fix peer miss rules host disabled checks

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix crash when moving to switchdev mode

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Fix deadlock between devlink lock and esw->wq

Hangbin Liu <liuhangbin@gmail.com>
    bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states

Hangbin Liu <liuhangbin@gmail.com>
    bonding: do not set usable_slaves for broadcast mode

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/amdgpu: Fix kernel-doc comments for some LUT properties

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v14

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v13

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix pclk rate calculation for bonded dsi

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: remove ifOutDiscards from rx_packets

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    dt-bindings: display/msm: qcom,sm8750-mdss: Fix model typo

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a8xx: Fix ubwc config related to swizzling

Peter Collingbourne <pcc@google.com>
    perf disasm: Fix off-by-one bug in outside check

Breno Leitao <leitao@debian.org>
    workqueue: Use POOL_BH instead of WQ_BH when checking pool flags

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix the bogus protect error on X2-85

Sun YangKai <sunk67188@gmail.com>
    btrfs: hold space_info->lock when clearing periodic reclaim ready

Eric Badger <ebadger@purestorage.com>
    xprtrdma: Decrement re_receiving on the early exit paths

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix hdisplay calculation when programming dsi registers

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Fix LM size on a number of platforms

Roberto Bergantinos Corpas <rbergant@redhat.com>
    nfs: return EISDIR on nfs3_proc_create if d_alias is a dir

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check max frame size for implicit feedback mode, too

sguttula <suresh.guttula@amd.com>
    drm/amdgpu/vcn5: Add SMU dpm interface type

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid implicit feedback mode on DIYINHK USB Audio 2.0

wangshuaiwei <wangshuaiwei1@xiaomi.com>
    scsi: ufs: core: Fix shift out of bounds when MAXQ=32

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Report insert for exotic peripherals

Azamat Almazbek uulu <almazbek1608@gmail.com>
    ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix devices attaching to different hosts

Sofia Schneider <sofia@schn.dev>
    ACPI: OSI: Add DMI quirk for Acer Aspire One D255

Ramanathan Choodamani <quic_rchoodam@quicinc.com>
    wifi: mac80211: set default WMM parameters on all links

Al Viro <viro@zeniv.linux.org.uk>
    unshare: fix unshare_fs() handling

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Add NULL checks when resetting request and reply queues

Edward Adam Davis <eadavis@qq.com>
    fs: init flags_valid before calling vfs_fileattr_get

Won Jung <wone.jung@samsung.com>
    scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode

Piotr Mazek <pmazek@outlook.com>
    ACPI: PM: Save NVS memory on Lenovo G70-35

Jan Kiszka <jan.kiszka@siemens.com>
    scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT

Guenter Roeck <linux@roeck-us.net>
    smb/server: Fix another refcount leak in smb2_open()

J. Neuschäfer <j.ne@posteo.net>
    powerpc: 83xx: km83xx: Fix keymile vendor prefix

Tzung-Bi Shih <tzungbi@kernel.org>
    remoteproc: mediatek: Unprepare SCP clock during system suspend

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: sysmon: Correct subsys_name_len type in QMI request

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: adjust the elfcorehdr size

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kexec/core: use big-endian types for crash variables

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    powerpc/uaccess: Fix inline assembly for clang build on PPC32

Rob Herring (Arm) <robh@kernel.org>
    remoteproc: qcom_wcnss: Fix reserved region mapping failure


-------------

Diffstat:

 .../bindings/display/msm/dp-controller.yaml        |  21 ++-
 .../bindings/display/msm/qcom,glymur-mdss.yaml     |  16 +-
 .../bindings/display/msm/qcom,sm8750-mdss.yaml     |   2 +-
 Documentation/virt/kvm/api.rst                     |   8 +
 Makefile                                           |   5 +-
 arch/arm64/include/asm/kvm_host.h                  |   3 +
 arch/arm64/include/asm/pgtable-prot.h              |  10 +-
 arch/arm64/kernel/cpufeature.c                     |   9 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   2 +-
 arch/arm64/kvm/mmu.c                               |  12 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  34 ++--
 arch/arm64/kvm/vgic/vgic-v2.c                      |   4 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  12 +-
 arch/arm64/kvm/vgic/vgic.c                         |   6 +
 arch/arm64/mm/contpte.c                            |  53 +++++-
 arch/arm64/mm/mmap.c                               |   6 +-
 arch/parisc/include/asm/pgtable.h                  |   2 +-
 arch/parisc/kernel/head.S                          |   7 +-
 arch/parisc/kernel/setup.c                         |  20 ++-
 arch/powerpc/include/asm/uaccess.h                 |   2 +-
 arch/powerpc/kexec/core.c                          |  17 +-
 arch/powerpc/kexec/file_load_64.c                  |  14 +-
 arch/powerpc/net/bpf_jit_comp.c                    |  30 ++--
 arch/powerpc/net/bpf_jit_comp64.c                  | 101 ++++++++++-
 arch/powerpc/perf/callchain.c                      |   5 +
 arch/powerpc/perf/callchain_32.c                   |   1 -
 arch/powerpc/perf/callchain_64.c                   |   1 -
 arch/powerpc/platforms/83xx/km83xx.c               |   4 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/lib/xor.c                                |   5 +-
 arch/s390/mm/pfault.c                              |   4 +-
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kernel/apic/apic.c                        |   6 +
 arch/x86/kvm/svm/avic.c                            |   9 +-
 arch/x86/kvm/svm/svm.c                             |   9 +-
 arch/x86/kvm/vmx/nested.c                          |  22 ++-
 drivers/accel/amdxdna/aie2_ctx.c                   |  14 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |  10 ++
 drivers/acpi/osi.c                                 |  13 ++
 drivers/acpi/osl.c                                 |   2 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/android/binder/page_range.rs               |  83 ++++++---
 drivers/android/binder/process.rs                  |   3 +-
 drivers/android/binder/range_alloc/array.rs        |  35 +++-
 drivers/android/binder/range_alloc/mod.rs          |   4 +-
 drivers/android/binder/range_alloc/tree.rs         |  18 +-
 drivers/android/binder/thread.rs                   |  17 +-
 drivers/ata/libata-core.c                          |   2 +
 drivers/base/property.c                            |  27 ++-
 drivers/block/ublk_drv.c                           |  12 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  37 ++--
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/cpuidle/cpuidle.c                          |  10 --
 drivers/crypto/ccp/sev-dev.c                       |  10 +-
 drivers/cxl/Kconfig                                |   1 +
 drivers/firmware/cirrus/cs_dsp.c                   |  24 ++-
 drivers/firmware/stratix10-rsu.c                   |   2 +
 drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c         |   7 +-
 drivers/gpio/gpiolib.c                             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h           |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |  14 ++
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   4 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   1 +
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  11 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   3 +-
 drivers/gpu/drm/bridge/samsung-dsim.c              |  25 ++-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |  13 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   6 +-
 drivers/gpu/drm/i915/display/intel_alpm.c          |  13 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   1 -
 drivers/gpu/drm/i915/display/intel_dp.c            |   7 +
 drivers/gpu/drm/i915/display/intel_psr.c           |  50 ++++--
 drivers/gpu/drm/i915/display/intel_vrr.c           |  14 ++
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |  12 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpummu.c           |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |   3 +-
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c              |  14 +-
 .../drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h   |  12 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h |  12 +-
 .../drm/msm/disp/dpu1/catalog/dpu_8_4_sa8775p.h    |   4 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h |  12 +-
 .../drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h   |  12 +-
 .../drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h   |  12 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  43 +++--
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |  12 +-
 drivers/gpu/drm/sitronix/st7586.c                  |  15 +-
 drivers/gpu/drm/ttm/ttm_pool_internal.h            |   2 +-
 drivers/gpu/drm/xe/xe_sync.c                       |  30 +++-
 drivers/gpu/drm/xe/xe_wa.c                         |  13 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |  19 ++-
 drivers/i3c/master/dw-i3c-master.c                 |   4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd.h              |   1 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |   9 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |  94 +++++++----
 drivers/i3c/master/mipi-i3c-hci/hci.h              |   2 +
 drivers/i3c/master/mipi-i3c-hci/pio.c              |  16 +-
 drivers/iio/chemical/bme680_core.c                 |   2 +-
 drivers/iio/chemical/sps30_i2c.c                   |   2 +-
 drivers/iio/chemical/sps30_serial.c                |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/iio/frequency/adf4377.c                    |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  18 +-
 drivers/iio/gyro/mpu3050-i2c.c                     |   3 +-
 drivers/iio/imu/adis.c                             |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   4 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   2 +
 drivers/iio/imu/inv_icm45600/inv_icm45600.h        |   2 +-
 drivers/iio/imu/inv_icm45600/inv_icm45600_core.c   |  11 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   8 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |   2 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |   5 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/iio/light/bh1780.c                         |   2 +-
 drivers/iio/magnetometer/tlv493d.c                 |   2 +-
 drivers/iio/potentiometer/mcp4131.c                |   2 +-
 drivers/iio/proximity/hx9023s.c                    |   6 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +
 drivers/irqchip/irq-riscv-aplic-direct.c           |  10 ++
 drivers/irqchip/irq-riscv-aplic-main.c             | 187 ++++++++++++++++++++-
 drivers/irqchip/irq-riscv-aplic-main.h             |  19 +++
 drivers/media/dvb-core/dvb_net.c                   |   3 +
 drivers/mmc/host/dw_mmc-rockchip.c                 |  38 ++++-
 drivers/mmc/host/mmci_qcom_dml.c                   |   1 +
 drivers/mmc/host/sdhci-brcmstb.c                   |   2 +-
 drivers/net/bonding/bond_main.c                    |  70 +++++++-
 drivers/net/caif/caif_serial.c                     |   3 +
 drivers/net/can/dev/calc_bittiming.c               |   2 +-
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/usb/gs_usb.c                       |  22 ++-
 drivers/net/dsa/microchip/ksz_ptp.c                |  11 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   3 +-
 drivers/net/dsa/realtek/rtl8366rb-leds.c           |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  19 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  82 ++++++++-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/arc/emac_main.c               |  11 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  31 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   5 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  10 +-
 drivers/net/ethernet/cadence/macb_main.c           |  98 ++++++++++-
 .../net/ethernet/freescale/enetc/netc_blk_ctrl.c   |  24 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  14 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  19 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  81 +++------
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   1 -
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  13 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  35 ++--
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   3 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |   6 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   1 -
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  23 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  45 ++---
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  23 ++-
 drivers/net/ethernet/spacemit/k1_emac.c            |  19 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  16 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   2 +-
 drivers/net/mctp/mctp-i2c.c                        |   1 +
 drivers/net/mctp/mctp-usb.c                        |   3 +-
 drivers/net/phy/sfp.c                              |   8 +-
 drivers/net/usb/lan78xx.c                          |  12 +-
 drivers/net/usb/lan78xx.h                          |   3 +
 drivers/net/usb/qmi_wwan.c                         |   4 +-
 drivers/net/usb/usbnet.c                           |   7 +-
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/pinctrl/pinctrl-cy8c95x0.c                 |   4 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |   6 +-
 drivers/pmdomain/rockchip/pm-domains.c             |   2 +-
 drivers/regulator/pca9450-regulator.c              |  14 +-
 drivers/regulator/pf9453-regulator.c               |   2 +-
 drivers/remoteproc/mtk_scp.c                       |  39 +++++
 drivers/remoteproc/qcom_sysmon.c                   |   2 +-
 drivers/remoteproc/qcom_wcnss.c                    |   2 +-
 drivers/s390/block/dasd_eckd.c                     |  16 ++
 drivers/s390/crypto/zcrypt_ccamisc.c               |  12 +-
 drivers/s390/crypto/zcrypt_cex4.c                  |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  32 ++--
 drivers/scsi/qla2xxx/qla_iocb.c                    |   2 -
 drivers/scsi/scsi_scan.c                           |   8 +-
 drivers/scsi/ses.c                                 |   5 +-
 drivers/scsi/storvsc_drv.c                         |   5 +-
 drivers/spi/spi-amlogic-spifc-a4.c                 |   5 +-
 drivers/spi/spi-rockchip-sfc.c                     |   2 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  15 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   5 +-
 drivers/staging/sm750fb/sm750.c                    |   1 +
 drivers/staging/sm750fb/sm750_hw.c                 |  22 +--
 drivers/ufs/core/ufshcd.c                          |  11 +-
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/class/usbtmc.c                         |   6 +-
 drivers/usb/core/message.c                         | 100 ++++++++---
 drivers/usb/core/phy.c                             |   8 +-
 drivers/usb/core/quirks.c                          |  16 ++
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/gadget/function/f_hid.c                |   4 +
 drivers/usb/gadget/function/f_mass_storage.c       |  12 +-
 drivers/usb/gadget/function/f_ncm.c                | 144 +++++++++-------
 drivers/usb/gadget/function/f_tcm.c                |  14 ++
 drivers/usb/gadget/function/u_ether.c              |  67 +++-----
 drivers/usb/gadget/function/u_ether.h              |  56 +++---
 drivers/usb/gadget/function/u_ether_configfs.h     | 176 -------------------
 drivers/usb/gadget/function/u_ncm.h                |   4 +-
 drivers/usb/gadget/function/uvc_video.c            |   2 +-
 drivers/usb/host/xhci-debugfs.c                    |  10 +-
 drivers/usb/host/xhci-ring.c                       |   1 +
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/image/mdc800.c                         |   6 +-
 drivers/usb/misc/uss720.c                          |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   9 +
 drivers/usb/roles/class.c                          |   7 +-
 drivers/usb/typec/altmodes/displayport.c           |   7 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 fs/afs/addr_list.c                                 |   8 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/btrfs/inode.c                                   |  19 +++
 fs/btrfs/ioctl.c                                   |  24 ++-
 fs/btrfs/space-info.c                              |   5 +-
 fs/btrfs/transaction.c                             |  16 ++
 fs/btrfs/uuid-tree.c                               |  38 +++++
 fs/btrfs/uuid-tree.h                               |   2 +
 fs/btrfs/volumes.c                                 |   6 +-
 fs/ceph/addr.c                                     |   1 -
 fs/ceph/debugfs.c                                  |   4 +-
 fs/ceph/dir.c                                      |  17 +-
 fs/ceph/file.c                                     |   4 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/ceph/mds_client.c                               |   3 +
 fs/file_attr.c                                     |   2 +-
 fs/iomap/buffered-io.c                             |  15 +-
 fs/iomap/ioend.c                                   |  13 +-
 fs/nfs/nfs3proc.c                                  |   7 +-
 fs/nfsd/nfsctl.c                                   |   2 +-
 fs/nsfs.c                                          |  15 +-
 fs/smb/client/cifsglob.h                           |  11 ++
 fs/smb/client/dir.c                                |   1 +
 fs/smb/client/file.c                               |  18 +-
 fs/smb/client/fs_context.c                         |   2 +-
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smb2pdu.c                            |   5 +-
 fs/smb/server/auth.c                               |  22 +--
 fs/smb/server/oplock.c                             |  35 ++--
 fs/smb/server/oplock.h                             |   5 +-
 fs/smb/server/smb2pdu.c                            |   8 +-
 fs/xfs/libxfs/xfs_defer.c                          |   2 +-
 fs/xfs/xfs_bmap_item.c                             |   2 +-
 fs/xfs/xfs_dquot.c                                 |   8 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/kunit/run-in-irq-context.h                 |  44 +++--
 include/linux/damon.h                              |  10 +-
 include/linux/io_uring_types.h                     |   1 +
 include/linux/irqchip/arm-gic-v3.h                 |   1 +
 include/linux/kthread.h                            |  21 ++-
 include/linux/liveupdate.h                         |   9 +-
 include/linux/migrate.h                            |  10 +-
 include/linux/mm.h                                 |  17 +-
 include/linux/mmc/host.h                           |   9 +-
 include/linux/netdevice.h                          |  32 ++++
 include/linux/ns_common.h                          |   2 +
 include/linux/rseq_types.h                         |   6 +-
 include/linux/sched.h                              |   2 -
 include/linux/usb.h                                |   8 +-
 include/linux/usb/usbnet.h                         |   1 +
 include/net/ip6_tunnel.h                           |  14 ++
 include/net/ip_tunnels.h                           |   7 +
 include/net/page_pool/types.h                      |   2 +-
 include/trace/events/kmem.h                        |   8 +-
 io_uring/eventfd.c                                 |  10 +-
 io_uring/io_uring.c                                |  26 ++-
 io_uring/kbuf.c                                    |  13 +-
 io_uring/net.c                                     |   2 +
 io_uring/register.c                                |  12 ++
 io_uring/zcrx.c                                    |   5 +-
 kernel/cgroup/cgroup.c                             |   7 +
 kernel/exit.c                                      |   6 +
 kernel/fork.c                                      |   5 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/kthread.c                                   |  41 +----
 kernel/liveupdate/luo_file.c                       |  41 +++--
 kernel/nscommon.c                                  |   6 +
 kernel/nstree.c                                    |  29 +---
 kernel/sched/core.c                                |  81 ++++-----
 kernel/sched/ext.c                                 |  84 +++++++--
 kernel/sched/idle.c                                |  11 +-
 kernel/time/time.c                                 |   2 +-
 kernel/trace/bpf_trace.c                           |   4 +-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_events.c                        |  58 +++++--
 kernel/trace/trace_functions_graph.c               |  19 ++-
 kernel/workqueue.c                                 |   2 +-
 lib/bootconfig.c                                   |   6 +-
 mm/damon/core.c                                    |  79 +++++----
 mm/damon/lru_sort.c                                |   4 +-
 mm/damon/reclaim.c                                 |   4 +-
 mm/damon/stat.c                                    |   2 +-
 mm/damon/sysfs.c                                   |  11 +-
 mm/damon/tests/vaddr-kunit.h                       |   2 +-
 mm/damon/vaddr.c                                   |  24 +--
 mm/filemap.c                                       |  15 +-
 mm/huge_memory.c                                   |  13 +-
 mm/kfence/core.c                                   |  29 +++-
 mm/memcontrol.c                                    |   2 +-
 mm/memfd_luo.c                                     |  56 +++++-
 mm/memory.c                                        |   3 +-
 mm/migrate.c                                       |   8 +-
 mm/migrate_device.c                                |   2 +-
 mm/page_alloc.c                                    |   3 +-
 mm/slub.c                                          |  54 ++++--
 net/batman-adv/bat_v_elp.c                         |  10 +-
 net/batman-adv/hard-interface.c                    |   8 +-
 net/batman-adv/hard-interface.h                    |   1 +
 net/ceph/auth.c                                    |   6 +-
 net/ceph/messenger_v2.c                            |  31 ++--
 net/ceph/mon_client.c                              |   6 +-
 net/core/dev.c                                     |  17 +-
 net/core/dev.h                                     |  35 ----
 net/core/neighbour.c                               |   3 +-
 net/core/page_pool_user.c                          |   4 +-
 net/ipv4/Kconfig                                   |   2 +
 net/ipv4/ip_tunnel_core.c                          |  15 ++
 net/ipv4/nexthop.c                                 |  14 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_ao.c                                  |   3 +-
 net/ipv4/tcp_ipv4.c                                |   3 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/mac80211/link.c                                |   2 +
 net/mctp/route.c                                   |  13 +-
 net/ncsi/ncsi-aen.c                                |   3 +-
 net/ncsi/ncsi-rsp.c                                |  16 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nfnetlink_queue.c                    |   4 +-
 net/netfilter/nft_chain_filter.c                   |   2 +-
 net/netfilter/nft_set_pipapo.c                     |   3 +-
 net/netfilter/xt_IDLETIMER.c                       |   6 +
 net/netfilter/xt_dccp.c                            |   4 +-
 net/netfilter/xt_tcpudp.c                          |   6 +-
 net/rxrpc/af_rxrpc.c                               |   8 +-
 net/sched/sch_teql.c                               |   1 +
 net/shaper/shaper.c                                |  11 +-
 net/sunrpc/xprtrdma/verbs.c                        |   7 +-
 net/tipc/socket.c                                  |   2 +
 rust/Makefile                                      |   6 +-
 rust/kernel/str.rs                                 |   4 +-
 sound/core/pcm_native.c                            |  19 ++-
 sound/hda/codecs/realtek/alc269.c                  |  25 +++
 sound/soc/amd/acp/acp-mach-common.c                |  18 +-
 sound/soc/amd/acp3x-rt5682-max9836.c               |   9 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 sound/soc/codecs/cs42l43-jack.c                    |   1 +
 sound/soc/codecs/rt1011.c                          |   2 +-
 sound/soc/generic/simple-card-utils.c              |  12 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   1 +
 sound/soc/qcom/qdsp6/q6apm.c                       |   1 +
 sound/soc/soc-core.c                               |  11 +-
 sound/usb/endpoint.c                               |   1 +
 sound/usb/format.c                                 |  70 +++++++-
 sound/usb/mixer_scarlett2.c                        |   2 +
 sound/usb/quirks.c                                 |   2 +
 tools/objtool/check.c                              |  10 +-
 tools/objtool/elf.c                                |   2 +-
 tools/objtool/klp-diff.c                           |   3 +
 tools/perf/builtin-ftrace.c                        |   9 +-
 tools/perf/util/annotate.c                         |   5 +-
 tools/perf/util/disasm.c                           |   2 +-
 tools/perf/util/synthetic-events.c                 |   5 +
 .../selftests/filesystems/nsfs/iterate_mntns.c     |  25 +--
 393 files changed, 3522 insertions(+), 1769 deletions(-)


