Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43475346AFB;
	Fri,  7 Aug 2026 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116604; cv=none; b=Br+DWrapHgmYeGNPOJtZge1svJxeigCQU2WBQHqakGBaXEzkmDWdOFahTWIStuXE8jFEWtdt+XwHmy4rCqF19BfmeD5QcEKqKcGRgxh8YRUqFvpy9xkFVS6zkCp9+51uGh2E4qQKtq7w4hiOLp6QuMcTTrDonu9KNi69D2YsvqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116604; c=relaxed/simple;
	bh=m1OUkSOu8mjDzO6ImiW2ue2pghibxLj+McPvYSMLqf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B3P5LeZ2dEo+lPXPQGw7ELr0znUJU69SgTrQigGSjgRAZAFKibB63rkmJI1rLpKG7JET8UCaMBEN8effm270enqYwi8oBZGr90aTyor5fnE7e/g1xpidKwGAYO9Woxkz1beiUAmbscGCsEM8ZSHSanoiP6Aa3S8qTq+okoXKIPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y89MCm9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y89MCm9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A6A1F000E9;
	Fri,  7 Aug 2026 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116600;
	bh=hSWU8sHaUK/2cpoFe74u7NngL9JozcJ9gM3/ce/aVc4=;
	h=From:To:Cc:Subject:Date;
	b=y89MCm9wvqydirywMNhgRjicks9ZrvGtJRs+1RvFL8Ecjz4SI+PSnFSbNZIB7/YvY
	 xpD6fc1gxV7yXmjqZ5HNbPvdQqJNzJnRmwb1mmJLRSr//lNQ2h1LzPQvUl08hJ2Suv
	 pw7nfkY7l7ueL6j2dpykGLbdjfMeZkTVpeoUD70Q=
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
Subject: [PATCH 7.1 000/438] 7.1.8-rc1 review
Date: Fri,  7 Aug 2026 16:33:16 +0200
Message-ID: <20260807143428.008222056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.1.8-rc1
X-KernelTest-Deadline: 2026-08-09T14:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.1.8 release.
There are 438 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.1.8-rc1

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Exit idle optimizations before programming

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: check GRPH_FLIP status before sending event

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Support CBP profile

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Wait on external BO kernel fences in exec IOCTL

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/exec: Remove the index parameter from drm_exec_for_each_locked_obj[_reverse]

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Set TTM device beneficial_order to 9 (2M)

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Separate early xe_device initialization

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Move xe->info.devid|revid initialization

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Move xe->info.force_execlist initialization

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Drop unused param from xe_device_create()

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix race condition and ordering in port unregistration

Sergey Senozhatsky <senozhatsky@chromium.org>
    usb: typec: ucsi: split connector lock classes

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Ensure locking/ref counting for OA whitelists

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: (De-)whitelist OA registers on OA stream open/release

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: (De-)whitelist OA registers for all hwe's for a gt

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Toggle 'deny' bit to (de-)whitelist OA regs

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Save OA nonpriv registers to register save/restore lists

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Generalize whitelist_apply_to_hwe

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Keep track of non-OA nonpriv slots

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Maintain OA whitelists separately

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate external BO copy bounds for both stride paths

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: use check_add_overflow for shader size+offset bound

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: enforce cursor size limits for MOB cursors

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: avoid destroy_workqueue(NULL) on vkms init failure

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: bound DMA command body size against suffix pointer

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate DRAW_PRIMITIVES header size before division

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: drop dma_buf reference on foreign-fd prime import

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: take fman->lock around fence list mutation in fifo_down

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: clamp dirty-page range with min, not max

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: reject DX_BIND_QUERY without a DX context

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: fix guest_memory_dirty bitfield clobbered as size

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: hold event_mutex while checkpointing CRIU events

David Francis <David.Francis@amd.com>
    drm/amdkfd: Handle invalid event type in CRIU event restore

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: fix uint32_t overflow in EOP ring buffer size alignment

Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
    drm/amdkfd: fix QID bit leak in pqm_create_queue()

Gang Ba <Gang.Ba@amd.com>
    drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    drm/amd/display: use proper context for logging

Alan Swanson <reiver@improbability.net>
    drm/amd/display: Silence link_dpms I2C retimer failures

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Increase HDMI AV mute wait from 2 to 3 frames

George Zhang <george.zhang@amd.com>
    drm/amd/display: Fix divide-by-zero in calculate_mcache_setting on zero viewport

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: check if dml21_add_phantom_plane() is successful

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: use milliwatts for GPU power sensors

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: hide pp_table sysfs on APUs

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix pptable use-after-free

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix torn gpu metrics reads

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: cap GTT size to physical RAM on APUs

Candice Li <candice.li@amd.com>
    drm/amdgpu: restore UMD profile pstate after runtime resume

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: move debug_vm handling to amdgpu_cs_parser_fini

Myeonghun Pak <mhun512@gmail.com>
    drm/mediatek: ovl_adaptor: balance component registrations

Guangshuo Li <lgs201920130244@gmail.com>
    drm/mediatek: mtk_hdmi: Fix DDC adapter double put in v2

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: validate firmware interface structure sizes

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: reject firmware sections with oversized data

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm/bridge: display-connector: Fix I2C adapter resource leak

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Zero the tile state data array before each BIN job

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/vc4: Supply the overflow slot size in BPOS, not the whole bin BO size

Alexander Kaplan <alexander.kaplan@sms-medipool.de>
    drm/dp: Read the PCON max FRL bandwidth only for HDMI DFPs

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: mark error-active controller status valid

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: handle bus error interrupts

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: unmap BAR0 using base address

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: use self-test mode for PRESUME_ACK

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ctucanfd: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: peak_usb: validate uCAN receive record lengths

Maoyi Xie <maoyixie.tju@gmail.com>
    can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error

James Gao <jamesgao5@outlook.com>
    can: peak_usb: add bounds check for USB channel index

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: softing: fw_parse(): validate firmware record spans

Tu Nguyen <tu.nguyen.xg@renesas.com>
    can: rcar_canfd: change the initializing flow for clocks and resets

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: use netdevice_tracker for j1939_{priv,session,ecu} tracking

Oleksij Rempel <o.rempel@pengutronix.de>
    can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure

Guangshuo Li <lgs201920130244@gmail.com>
    can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ems_usb: validate CPC message lengths

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    can: c_can: c_can_chip_config(): keep controller in init mode until bittiming is configured

Liem <liem16213@gmail.com>
    i2c: imx: Cancel hrtimer before clearing slave pointer

Liem <liem16213@gmail.com>
    i2c: imx: Fix slave registration race and error handling

Carlos Song <carlos.song@nxp.com>
    i2c: imx: mark I2C adapter when hardware is powered down

Jonas Gorski <jonas.gorski@bisdn.de>
    i2c: iproc: reset bus after timeout if START_BUSY is stuck

H. Nikolaus Schaller <hns@goldelico.com>
    i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock

Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
    i2c: qcom-cci: drop custom suspend/resume and rely on runtime PM helpers

Linmao Li <lilinmao@kylinos.cn>
    i2c: spacemit: request IRQ after controller initialization

Dawei Feng <dawei.feng@seu.edu.cn>
    ice: fix memory leak in ice_lbtest_prepare_rings()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: fix VF interrupts cleanup

Aaron Ma <aaron.ma@canonical.com>
    ice: wait for reset completion in ice_resume()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during ct

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during recirculation

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix potential UAF on meter attach failure

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: keep SERDES scrambler and 8b/10b enabled for USB

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: use read-modify-write for SERDES scrambler bypass

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: fix L0_TM_DISABLE_SCRAMBLE_ENCODER mask

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA ECC private key requests

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA AES cipher key requests

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix buffer over-read in cca_cipher2protkey

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Close speculative mem read possibility

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix undersized format-check buffer

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix potential NULL pointer dereference

Aswin Karuvally <aswin@linux.ibm.com>
    s390/qeth: Check CAP_NET_ADMIN for private ioctls

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix s390_pci_mmio_write syscall error return without MIO

Jianing Li <m13940358460@163.com>
    power: supply: max17040: handle missing status supplier

Sasha Finkelstein <k@chaosmail.tech>
    power: supply: macsmc: Support macOS 27 SMC firmware

Xu Rao <raoxu@uniontech.com>
    power: supply: bq25890: fix the -10 C NTC lookup entry

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Publish util hooks only after all sg_cpu are initialized

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()

Christian Loehle <christian.loehle@arm.com>
    cpufreq: cppc: Sanitize lockless policy limit snapshots

Frank Sorenson <sorenson@redhat.com>
    cifs: add fscache_resize_cookie() to cifs_setsize()

Junjie Cao <junjie.cao@intel.com>
    gpio: pch: use raw_spinlock_t for the register lock

bui duc phuc <phucduc.bui@gmail.com>
    gpio: pca953x: fix cache_only and IRQ state on restore_context() failure

Daniel Golle <daniel@makrotopia.org>
    gpiolib: tolerate gpio-hogs lacking a hogging state

Hardik Prakash <hardikprakash.official@gmail.com>
    i2c: designware: defer probe if child GpioInt controllers are not bound

Myeonghun Pak <mhun512@gmail.com>
    i2c: amd-mp2: Unregister callback on adapter add failure

Vincent Jardin <vjardin@free.fr>
    hwmon: (pmbus/core) notify on the hwmon device, not the i2c client

Hongyan Xu <getshell@seu.edu.cn>
    hwmon: (npcm750-pwm-fan): stop fan timer on device detach

Asim Viladi Oglu Manizada <manizada@pm.me>
    sctp: prevent peer transport count overflow

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    sctp: reject stale cookies with mismatched verification tags

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc

Ibrahim Hashimov <security@auditcode.ai>
    scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Damien Le Moal <dlemoal@kernel.org>
    scsi: libsas: terminate deferred commands on time out

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/clone3: fix wild pointer access of getline due to missing init

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/mm: fix potential wild pointer access of getline due to missing init

Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>
    spi: qcom-qspi: Correct max DMA length to avoid 64K boundary failure

Stanislaw Pal <kuncy7@gmail.com>
    spi: spi-qpic-snand: write the feature value before executing SET_FEATURE

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/filters: Fix false positive match in regex_match_full()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Check return value of __register_event() in trace_module_add_events()

Ming Lei <tom.leiming@gmail.com>
    ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()

Eric Dumazet <edumazet@google.com>
    vxlan: use pskb_network_may_pull() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: use pskb_network_may_pull() for transmit path header pulls

Eric Dumazet <edumazet@google.com>
    vxlan: use neigh_ha_snapshot() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: unclone skb head before modifying eth header in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: re-fetch eth header after route_shortcircuit()

Matt Fleming <mfleming@cloudflare.com>
    veth: convert frag_list skbs before running XDP

Breno Leitao <leitao@debian.org>
    uprobes: Fix NULL pointer dereference in hprobe_expire()

Michael Bommarito <michael.bommarito@gmail.com>
    um: vector: fix use-after-free in vector_mmsg_rx()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()

Jiakai Xu <xujiakai2025@iscas.ac.cn>
    riscv/mm: use physical alignment for vmemmap_start_pfn

Chengfeng Ye <nicoyip.dev@gmail.com>
    net: pktgen: fix proc entry use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    net: ipv6: clear suppressed fib6 rule result

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: stop fast-leave after deleting a port group

Breno Leitao <leitao@debian.org>
    mm: memcg: initialize *locked in memcg1_oom_prepare() stub

Link Lin <linkl@google.com>
    mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Kyumin Lee <fyonglkm@gmail.com>
    io_uring: preserve task restrictions across exec

Jens Axboe <axboe@kernel.dk>
    io_uring/net: initialize mshot_len for send

Christian Brauner <brauner@kernel.org>
    binfmt_misc: don't leak the user namespace when the mount fails

Christian Brauner <brauner@kernel.org>
    binfmt_misc: don't let an 'F' entry pin its own instance

Christian Brauner <brauner@kernel.org>
    binfmt_misc: reject a flag character as the field delimiter

Christian Brauner <brauner@kernel.org>
    binfmt_misc: use exe_file_deny_write_access() for the interpreter clone

Christian Brauner <brauner@kernel.org>
    binfmt_misc: restore write access when removing an entry

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: fix tid_tx use-after-free on BA session stop

Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
    x86/CPU/AMD: Carve out a Zen5 models range

Zihan Xi <zihanx@nebusec.ai>
    tipc: avoid use-after-free in poll trace queue dumps

Soeren Moch <smoch@web.de>
    PCI: imx6: Keep i.MX6 Root Port MSI/MSI-X Capabilities with iMSI-RX to work around hardware bug

Carlo Caione <ccaione@baylibre.com>
    of/address: Fix NULL bus dereference in of_pci_range_parser_one()

David Lee <david.lee@trailofbits.com>
    netfilter: ipset: do not update comments from kernel-side hash adds

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/smc: fix socket use-after-free during link group termination

Wei Liu <wei.liu@kernel.org>
    mshv: fix hv_input_get_system_property struct

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject repeated SMB2 NEGOTIATE requests

Zhiling Zou <roxy520tt@gmail.com>
    ipvs: do not propagate one-packet flag to synced conns

David Carlier <devnexen@gmail.com>
    igc: remove napi_synchronize() in igc_down()

Matt Vollrath <tactii@gmail.com>
    igbvf: Fix leak in TX DMA error cleanup

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fou: Fix use-after-free in fou_create()

Dawei Feng <dawei.feng@seu.edu.cn>
    e1000: fix memory leak in e1000_probe()

Md Sadre Alam <md.alam@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Fix command element mask field for BAM v1.6.0+

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Clamp frame size in implicit-feedback mode

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix stack info leak in RME Digiface status

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix use-after-free in ump_to_endpoint()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: schedule deferred atapi command

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: terminate deferred commands on time out

Niklas Cassel <cassel@kernel.org>
    ata: libata-sata: fix ata_scsi_lpm_supported() iteration

Matt Vollrath <tactii@gmail.com>
    ata: libata-eh: Increase STANDBY IMMEDIATE timeout

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix broken entries in the volume lookup table

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix DVC coefficient write order

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: fix m2m_init error path to use goto instead of bare return

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: fix m2m_init error path to use goto instead of bare return

Baul Lee <baul.lee@xbow.com>
    ALSA: ump: fix double free of out_cvts on rawmidi error

Norbert Szetei <norbert@doyensec.com>
    ALSA: timer: Clear SNDRV_TIMER_IFLG_DEAD once the close completes

Norbert Szetei <norbert@doyensec.com>
    ALSA: seq: Fix division by zero in initialize_timer()

Norbert Szetei <norbert@doyensec.com>
    ALSA: pcm: wake linked drain waiters on unlink

Xu Rao <raoxu@uniontech.com>
    ALSA: lx6464es: fix period byte count for 16-bit streams

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang X6SP45xU

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix UAF at error handling during probe

David Howells <dhowells@redhat.com>
    afs: Fix UAF when sending a message

David Howells <dhowells@redhat.com>
    afs: Fix afs_fs_fetch_data() to subtract transferred from len

David Howells <dhowells@redhat.com>
    afs: Fix afs_fs_fetch_data() to set call->async

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    bpf: lwt: Fix dst reference leak on reroute failure

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: validate numbered report payloads

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: reject frames without a transaction header

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix advertising data UAFs

Zihan Xi <xizh2024@lzu.edu.cn>
    Bluetooth: mgmt: fix UAF in pair command cancellation

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: SCO: give the socket its own sco_conn reference

Zihan Xi <zihanx@nebusec.ai>
    Bluetooth: mgmt: fix pending command UAF in EIR updates

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Bluetooth: btmtk: Fix short read errors in btmtk_usb_reg_read()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Bluetooth: btmtk: Fix short read errors in btmtk_usb_uhw_reg_read()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Bluetooth: btusb: Fix short read errors in btusb_qca_send_vendor_req()

Luxiao Xu <rakukuip@gmail.com>
    audit: fix potential use-after-free in audit_del_rule()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    audit: fix potential integer overflow in audit_log_n_string()

Charles Vosburgh <trilobyte777@gmail.com>
    sctp: validate Adaptation Indication parameter length

Hidayath Khan <hidayath@linux.ibm.com>
    dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Validate AIBV and AISB before pinning guest pages

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix NULL dereference on AIBV allocation failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix resource leak on IRQ registration failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix missing error codes and memory unaccounting

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix memory accounting for pinned/unpinned pages

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Reject adapter interrupt forwarding if already enabled

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active

Paolo Bonzini <pbonzini@redhat.com>
    KVM: VMX: add memory clobber to asm for VMX instructions

Raushan Patel <raushan.jhon@gmail.com>
    tracing/fprobe: Roll back on enable_trace_fprobe() failure

Raushan Patel <raushan.jhon@gmail.com>
    tracing/probes: Reject $arg0 in meta argument expansion

Weiming Shi <bestswngs@gmail.com>
    KVM: x86: Cancel delayed I/O APIC EOI handling before destroying vCPUs

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Usama Arif <usama.arif@linux.dev>
    userfaultfd: wait on source PMD during UFFDIO_MOVE

Xiangfeng Cai <caixiangfeng@bytedance.com>
    mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan <ziy@nvidia.com>
    mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes

Jori Koolstra <jkoolstra@xs4all.nl>
    selftest: fix headers in fclog.c

Aboorva Devarajan <aboorvad@linux.ibm.com>
    mm/util: don't read __page_2 for order-1 folios in snapshot_page()

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset

Guanghui Yang <3497809730@qq.com>
    btrfs: zoned: fix missing chunk metadata reservation

Stanislav Kinsburskii <skinsburskii@gmail.com>
    lib: test_hmm: use device devt for coherent device range selection

Nathan Chancellor <nathan@kernel.org>
    fortify: Disable -Wstringop-overread in tests

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: bm1880: add missing select GENERIC_PINCONF

Michael Bommarito <michael.bommarito@gmail.com>
    erofs: cap LZMA stream pool size

Mykola Lysenko <nickolay.lysenko@gmail.com>
    btrfs: raid56: fix scrub read assembly submitting no reads

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: devicetree: don't free uninitialized dev_name on error path

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: microchip-sgpio: add missing select REGMAP_MMIO

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()

Qi Zheng <qi.zheng@linux.dev>
    mm: mglru: fix stale batch updates after memcg reparenting

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Check all controls for fast switching

Nicolas Schier <n.schier@fritz.com>
    kbuild: Stop modifying $(objtree)/Makefile when building oot-kmods oos

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommu/iommufd: Fix IOPF group ownership UAF

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommufd: Fix wrong hwpt passed to iommufd_auto_response_faults on replace

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommufd: Reject DMABUF pages from the access pin path

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/viommu: Publish a vDEVICE only after vdevice_init() succeeds

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/viommu: Release the igroup lock on the vdevice_size error path

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    ring-buffer: Fix subbuf_ids memory leak in rb_allocate_cpu_buffer() error path

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Publish VP to pt_vp_array before installing the file descriptor

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Order pt_vp_array publish against irqfd assertion path

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix missing error code on VP allocation failure

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix level-triggered check on uninitialized data

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix race in mshv_irqfd_deassign

Christoph Hellwig <hch@lst.de>
    iomap: add a separate bio_set for iomap_split_ioend

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use memcmp() to compare ClientGUIDs

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __close_file_table_ids()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return success for deferred final close

Jerome Tollet <jerome.tollet@gmail.com>
    drm/i915/hdmi: Poll for 200 msec for TMDS_Scrambler_Status

Denis V. Lunev <den@openvz.org>
    qede: sync udp_tunnel ports outside qede_lock in the recovery path

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: add per-SoC SDR/DTR clock rate limits for all supported SoCs

Gabriele Monaco <gmonaco@redhat.com>
    sched/deadline: Use revised wakeup rule only for running dl_server

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Set correct sequence for carrier off and tx queue stop

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix FDIR ATR queue mismatch for software VLAN packets

Wei Fang <wei.fang@nxp.com>
    ptp: netc: fix potential interrupt storm caused by incorrect unbind order

Aditya Garg <gargaditya@linux.microsoft.com>
    net: mana: Return error code from mana_create_rxq()

Long Li <longli@microsoft.com>
    net: mana: Create separate EQs for each vPort

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: Fix E2E delay mechanism

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed reads in MT7531 PHY polling

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed reads in ATC/VTCR command polling

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check bus->read() errors in the MDIO regmap backend

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    riscv: vdso: Only try to install vDSO when present

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    ipv6: release fib6_null_entry on subtree failure

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Fix reader page read offset for remote buffers

Karl Mehltretter <kmehltretter@gmail.com>
    riscv: mm: Fix out-of-bounds page-table walk during memory hot-remove

Muhammad Bilal <meatuni001@gmail.com>
    accel/qaic: use sizeof(*trans_hdr) for transaction length check

Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
    riscv: drop __init from vec_check_unaligned_access_speed_all_cpus

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Reset dropped_count in mmio_reset_data()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    fprobe: Fix module reference count leak on error in register_fprobe()

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/pt: check no-DMA huge-pte cases before DMA segment test

Alexander Kaplan <alexander.kaplan@sms-medipool.de>
    drm/i915/dp: Ignore the sink's DSC max FRL rate without a PCON DSC encoder

Minhong He <heminhong@kylinos.cn>
    can: isotp: check register_netdevice_notifier() error in module init

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: check descriptor ring allocation failures

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: free TX rings on RX allocation failure

Ao Sun <ao.sun@transsion.com>
    scsi: ufs: core: Initialize hba->rpmbs list in ufshcd

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Block VFs from clobbering special CGX PKIND state

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2: cn20k: Coordinate default rules with NIX LF lifecycle

Leon Romanovsky <leon@kernel.org>
    scsi: target: Clear cmd_cnt when initial counter enrollment fails

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"

Guangshuo Li <lgs201920130244@gmail.com>
    scsi: ufs: core: Cancel RTC work in active-active suspend

TanZheng <tanzheng@kylinos.cn>
    scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE

Christian Marangi <ansuelsmth@gmail.com>
    net: phylink: put link_gpio if phylink_create fails

Mauricio Faria de Oliveira <mfo@igalia.com>
    x86/boot: Add volatile, clobbers and zero-length test in memcmp()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_past_sync() callback

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_pa_sync() callback

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_acl/le_sync() callbacks

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_conn: hold conn reference in abort_conn_sync()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btintel: Validate length before parsing diagnostics TLV

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix refcounting of iso_conn

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: ensure no dangling hcon references in iso_conn

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: avoid deadlocks in iso_sock_timeout

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix leaking sk after socket release

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: hold sk properly in iso_conn_ready

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: validate sockaddr_iso first in iso_sock_rebind_bis()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: lock sk in iso_connect_ind

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: lock sk in iso_sock_getname

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix CONNECTED -> CLOSED transition on shutdown/release

Jiale Yao <yaojiale02@163.com>
    Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: clear iso_data always when detaching conn from hcon

Przemyslaw Korba <przemyslaw.korba@intel.com>
    ice: suppress DPLL errors during reset recovery

Yuho Choi <dbgh9129@gmail.com>
    idpf: Fix mailbox IRQ name leak on request failure

Joshua Hay <joshua.a.hay@intel.com>
    idpf: adjust TxQ ring count minimum

Michael Bommarito <michael.bommarito@gmail.com>
    idpf: bound interrupt-vector register fill to the allocated array

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value from pmbus_update_byte_data()

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller

David Howells <dhowells@redhat.com>
    netfs: Fix folio_queue ENOMEM in writeback by adding a mempool

Yichong Chen <chenyichong@uniontech.com>
    netfs: release readahead folios on iterator preparation failure

Yichong Chen <chenyichong@uniontech.com>
    netfs: handle single writeback rolling buffer allocation failure

Yichong Chen <chenyichong@uniontech.com>
    netfs: clear PG_private_2 on copy-to-cache append failure

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate individual TWT params before driver setup

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-akebono CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-currituck CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix simpleboot CPU node lookup check

Eric Joyner <eric.joyner@amd.com>
    ethtool: Embed FEC hist ranges as buffer in struct

Yun Lu <luyun@kylinos.cn>
    rtase: fix double free of multi-frag skb on DMA map failure

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix PWM auto temp state array and bounds check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Use cached PWM frequency value

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix cache updated before hardware write on I2C error

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors

Chenguang Zhao <zhaochenguang@kylinos.cn>
    forcedeth: fix UAF of txrx_stats in nv_remove

Surendra Singh Chouhan <kr494167@gmail.com>
    ASoC: sophgo: return 1 on volume change in cv1800b_adc_volume_set()

David Corvaglia <david@corvaglia.dev>
    net: bridge: mrp: fix Option TLV length in MRP_Test frames

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Prevent access to unsupported weight registers

Eric Dumazet <edumazet@google.com>
    net: do not send ICMP/NDISC Redirects when peer allocation fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-smart2) DMA-align output buffer

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Only report alarms if driver is ready

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht3x) Fix unaligned accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ltc4282) Fix reading the minimum alarm voltage

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ina2xx) Fix various overflow issues

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix number of temperature registers for NCT6116

Srikanth Boyapally <srikanth.boyapally@amd.com>
    spi: spi-cadence: Move TX FIFO full busy-wait into FIFO

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: tas2781: Use correct calibration data for SINEGAIN2 register

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Skip writes to unsupported performance controls

Alex Tran <alex.tran@oss.qualcomm.com>
    gpio: gpio-by-pinctrl: Apply initial value in direction output wrapper

Gao Xiang <xiang@kernel.org>
    erofs: ensure valid f_path for page cache sharing

Gao Xiang <xiang@kernel.org>
    erofs: remove fscache backend entirely

Gao Xiang <xiang@kernel.org>
    erofs: clean up erofs_ishare_fill_inode()

Dawei Feng <dawei.feng@seu.edu.cn>
    smb: client: fix buffer leaks in SMB1 read and write

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl-amd: Don't clear S4 wake bits at probe

Jonas Köppeler <j.koeppeler@tu-berlin.de>
    net/sched: sch_cake: skip clearing unused tins during rate adjustment

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: reclaim invalid Tx descriptors in ZC batch path

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: provide sufficient space in pool->tx_descs

Jason Xing <kerneljasonxing@gmail.com>
    xsk: drain continuation descs after overflow in xsk_build_skb()

Jason Xing <kerneljasonxing@gmail.com>
    xsk: fix buffer leak in xsk_drop_skb() for AF_XDP multi-buffer Tx

John Ericson <mail@johnericson.me>
    selftests/net/af_unix: test listen() rejects wrong socket states

John Ericson <mail@johnericson.me>
    af_unix: fix listen() succeeding on sockets in the wrong state

Xiang Mei (Microsoft) <xmei5@asu.edu>
    nexthop: avoid unlocked f6i_list walk in nh_rt_cache_flush

Xiang Mei (Microsoft) <xmei5@asu.edu>
    nexthop: take nh->lock for f6i_list walks in replace check and notify

Xiang Mei <xmei5@asu.edu>
    rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Ensure that Control Range is large enough for header

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Make UMP message size check more robust

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Always free firmware in FDL path

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Correct pointer passed to devm_acpi_table_put

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: nft_payload: fix mask build for partial field offload

Julian Anastasov <ja@ssi.bg>
    ipvs: clear the nfct flag under lock

Julian Anastasov <ja@ssi.bg>
    ipvs: do not mangle ICMP replies for non-first fragments

Julian Anastasov <ja@ssi.bg>
    ipvs: fix places with wrong packet offsets

Julian Anastasov <ja@ssi.bg>
    ipvs: fix the checksum validations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: make nft_object rhltable per table

Julian Anastasov <ja@ssi.bg>
    ipvs: adjust double hashing when fwd method changes

Michael Bommarito <michael.bommarito@gmail.com>
    assoc_array: trim the final shortcut word using the current chunk end

Michael Bommarito <michael.bommarito@gmail.com>
    keys: make keyring key-chunk byte order agree with keyring_diff_objects()

Michael Bommarito <michael.bommarito@gmail.com>
    keys: fix out-of-bounds read in keyring_get_key_chunk()

Fabrice Derepas <fabrice.derepas@canonical.com>
    KEYS: trusted: dcp: fix key_len validation and calc_blob_len() return type

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Reject guest_memfd memslots when the VM has MTE

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Add missing hyp_enter when trapping sysreg

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Fix hyp_trace clock disabling

Carlos López <clopez@suse.de>
    KVM: arm64: vgic: Mitigate potential LPI registration failure

Carlos López <clopez@suse.de>
    KVM: arm64: vgic: Fix race between LPI release and re-registration

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix sleeping under spinlock in mshv_portid_alloc

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix duplicate GSI detection for GSI 0

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Drivers: hv: vmbus: Replace lockdep_hardirq_threaded() with lockdep annotation

Yi Xie <xieyi@kylinos.cn>
    mshv_vtl: fix fd leak in mshv_ioctl_create_vtl()

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/mediatek: Check CRTC state before freeing

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()

Lorenzo Bianconi <lorenzo@kernel.org>
    selftests: netfilter: nft_flowtable.sh: fix offload counter verification for tunnel tests

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix runtime PM leak on probe allocation failure

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix clock error handling in xpsgtr_phy_init()

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Fix on-threshold actions firing on signal

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: drop stale page-cache when shrinking a non-resident attr

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: harden runlist realloc size calculations

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: skip fully truncated ordered extents at zone finish

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: fix an incorrect csum skip during scrub

Dongjiang Zhu <zhudongjiang@fnnas.com>
    btrfs: skip global block reserve accounting for rescue mounts

Qu Wenruo <wqu@suse.com>
    btrfs: warn about extent buffer that can not be released

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: reset meta_write_pointer on zone reset

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix deadlock between metadata writeback and transaction commit

Qu Wenruo <wqu@suse.com>
    btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag

Sang-Heon Jeon <ekffu200098@gmail.com>
    of: reserved_mem: prevent OOB when too many dynamic regions are defined

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    phy: qcom: m31-eusb2: Fix return value of init call

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()

Rosen Penev <rosenp@gmail.com>
    ata: sata_mv: accept 1 or 2 resources in platform probe

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: preserve RECALL_ON_OPEN on WSL special-file reparse points

Kuan-Ying Lee <kuan-ying.lee@canonical.com>
    selftests/seccomp: Fix pointer type mismatch build error

Haofeng Li <lihaofeng@kylinos.cn>
    selftests/lkdtm: rename STACKLEAK_ERASING to KSTACK_ERASE

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    gpio: sloppy-logic-analyzer: Fix memory leak in gpio_la_poll_probe()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3-iommufd: Require exactly one Stream ID for a vDEVICE

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix double free of wq, engine, and group structs

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: sc8280xp: Add missing wakeup entries for GPIO143/151

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    pinctrl: qcom: Unconditionally mark gpio as wakeup enable

David Carlier <devnexen@gmail.com>
    dmaengine: switchtec-dma: fix FIELD_GET misuse when programming SE threshold

D Scott Phillips <scott@os.amperecomputing.com>
    KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Michael Diesen <michael.diesen@posteo.de>
    ALSA: hda/realtek: Add quirk for HP Dragonfly Folio G3 2-in-1 (103c:8a05)

Harry Yoo (Oracle) <harry@kernel.org>
    mm/slab: prevent unbounded recursion in free path with new kmalloc type

Harry Yoo (Oracle) <harry@kernel.org>
    lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()

Harry Yoo (Oracle) <harry@kernel.org>
    mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: mpls: initialize rtm_tos in mpls_getroute()


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   4 +
 .../bindings/ufs/qcom,sa8255p-ufshc.yaml           |   9 +-
 Documentation/filesystems/erofs.rst                |   9 +-
 Documentation/networking/af_xdp.rst                |  54 +-
 Documentation/virt/kvm/api.rst                     |   6 +
 Makefile                                           |  12 +-
 arch/arm64/include/asm/kvm_hypevents.h             |   1 +
 arch/arm64/kvm/arm.c                               |  25 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   1 +
 arch/arm64/kvm/hyp_trace.c                         |  36 +-
 arch/arm64/kvm/mmu.c                               |   4 +
 arch/arm64/kvm/vgic/vgic-its.c                     |  25 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   8 +-
 arch/arm64/kvm/vgic/vgic.c                         |  18 +-
 arch/powerpc/boot/simpleboot.c                     |   2 +-
 arch/powerpc/boot/treeboot-akebono.c               |   2 +-
 arch/powerpc/boot/treeboot-currituck.c             |   2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   1 +
 arch/riscv/Makefile                                |   2 +-
 arch/riscv/kernel/unaligned_access_speed.c         |   4 +-
 arch/riscv/mm/init.c                               |   7 +-
 arch/s390/kvm/pci.c                                | 107 +++-
 arch/s390/kvm/pci.h                                |   2 +
 arch/s390/pci/pci_mmio.c                           |   1 +
 arch/um/drivers/vector_kern.c                      |   3 +
 arch/x86/boot/string.c                             |  11 +-
 arch/x86/kernel/cpu/amd.c                          |   4 +-
 arch/x86/kvm/svm/avic.c                            |   8 -
 arch/x86/kvm/vmx/vmx_ops.h                         |   8 +-
 arch/x86/kvm/x86.c                                 |   6 +
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/acpi/cppc_acpi.c                           |  29 +-
 drivers/ata/ahci_ceva.c                            |  18 +-
 drivers/ata/libata-eh.c                            |  37 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/libata-scsi.c                          | 119 +++-
 drivers/ata/libata.h                               |   3 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/block/ublk_drv.c                           |   9 +
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/bluetooth/btmtk.c                          |  86 ++-
 drivers/bluetooth/btusb.c                          |  30 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  35 +-
 drivers/cpufreq/powernow-k8.c                      |   1 +
 drivers/dibs/dibs_loopback.c                       |  47 +-
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/dma/idxd/init.c                            |  36 +-
 drivers/dma/sun6i-dma.c                            |  11 +-
 drivers/dma/switchtec_dma.c                        |   2 +-
 drivers/gpio/gpio-by-pinctrl.c                     |  18 +-
 drivers/gpio/gpio-pca953x.c                        |  15 +-
 drivers/gpio/gpio-pch.c                            |  28 +-
 drivers/gpio/gpio-sloppy-logic-analyzer.c          |  10 +
 drivers/gpio/gpiolib.c                             |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  39 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  12 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  23 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 243 ++++++--
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  45 ++
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |  20 +-
 .../drm/amd/display/dc/dml2_0/dml21/dml21_utils.c  |  15 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |  31 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |  16 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |  16 +-
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   6 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |  39 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  29 +-
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |   6 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   4 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   4 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |   5 +-
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h       |   5 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   2 +-
 .../drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c    |   6 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   8 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c  |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c   |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c   |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c   |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_0_ppt.c   |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c   |   3 +-
 drivers/gpu/drm/bridge/display-connector.c         |  11 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |  12 +
 drivers/gpu/drm/drm_exec.c                         |   6 +-
 drivers/gpu/drm/drm_gpuvm.c                        |   3 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |   2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   9 +-
 drivers/gpu/drm/i915/display/intel_hdmi.c          |  26 +
 drivers/gpu/drm/i915/display/intel_hdmi.h          |   2 +
 drivers/gpu/drm/mediatek/mtk_crtc.c                |   6 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |   7 +-
 drivers/gpu/drm/mediatek/mtk_hdmi_v2.c             |   8 -
 drivers/gpu/drm/panthor/panthor_fw.c               |  47 +-
 drivers/gpu/drm/vc4/vc4_irq.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_validate.c                 |  29 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c               |  39 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c       |  49 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c               |  17 +-
 drivers/gpu/drm/xe/tests/xe_pci.c                  |   6 +
 drivers/gpu/drm/xe/xe_device.c                     |  56 +-
 drivers/gpu/drm/xe/xe_device.h                     |   4 +-
 drivers/gpu/drm/xe/xe_exec.c                       |  22 +-
 drivers/gpu/drm/xe/xe_gt_debugfs.c                 |   4 +-
 drivers/gpu/drm/xe/xe_hw_engine.c                  |   2 +
 drivers/gpu/drm/xe/xe_hw_engine_types.h            |   8 +
 drivers/gpu/drm/xe/xe_oa.c                         |   7 +
 drivers/gpu/drm/xe/xe_oa_types.h                   |   3 +
 drivers/gpu/drm/xe/xe_pci.c                        |  15 +-
 drivers/gpu/drm/xe/xe_pt.c                         |  13 +-
 drivers/gpu/drm/xe/xe_reg_whitelist.c              |  87 ++-
 drivers/gpu/drm/xe/xe_reg_whitelist.h              |   4 +
 drivers/gpu/drm/xe/xe_vm.c                         |   3 +-
 drivers/hv/mshv_eventfd.c                          |  41 +-
 drivers/hv/mshv_irq.c                              |   2 +-
 drivers/hv/mshv_portid_table.c                     |   6 +-
 drivers/hv/mshv_root_main.c                        |  41 +-
 drivers/hv/mshv_vtl_main.c                         |   1 +
 drivers/hv/vmbus_drv.c                             |  13 +-
 drivers/hwmon/adt7470.c                            | 131 ++--
 drivers/hwmon/ina2xx.c                             |  61 +-
 drivers/hwmon/lm90.c                               |   4 +-
 drivers/hwmon/ltc4282.c                            |   4 +-
 drivers/hwmon/nct6775-core.c                       |  20 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |  11 +
 drivers/hwmon/nzxt-smart2.c                        |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   7 +-
 drivers/hwmon/sht3x.c                              |   9 +-
 drivers/i2c/busses/i2c-amd-mp2-plat.c              |   4 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  11 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |  80 +++
 drivers/i2c/busses/i2c-imx.c                       |  54 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/i2c/busses/i2c-k1.c                        |  10 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |  18 +-
 drivers/infiniband/hw/mana/main.c                  |  40 +-
 drivers/infiniband/hw/mana/mana_ib.h               |  14 +
 drivers/infiniband/hw/mana/qp.c                    |  68 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    |  15 +
 drivers/iommu/io-pgfault.c                         |  24 +-
 drivers/iommu/iommufd/device.c                     |   2 +-
 drivers/iommu/iommufd/eventq.c                     |   2 +
 drivers/iommu/iommufd/pages.c                      |   3 +
 drivers/iommu/iommufd/viommu.c                     |  22 +-
 .../media/platform/chips-media/wave5/wave5-hw.c    |   3 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |   5 +-
 .../platform/chips-media/wave5/wave5-vpuapi.h      |   1 +
 drivers/net/can/c_can/c_can_main.c                 |   8 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  14 +-
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |   3 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  32 +-
 drivers/net/can/softing/softing_fw.c               |  46 +-
 drivers/net/can/usb/ems_usb.c                      |  43 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   1 -
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  13 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  40 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  20 +-
 drivers/net/dsa/mt7530-mdio.c                      |  11 +-
 drivers/net/dsa/mt7530.c                           |  86 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_dpll.c          |  19 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  27 +
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |   1 +
 drivers/net/ethernet/intel/ice/virt/queues.c       |  21 +
 drivers/net/ethernet/intel/idpf/idpf_dev.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   5 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c      |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   5 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 -
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  12 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  79 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  97 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  49 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  19 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 143 +++--
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  23 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  44 +-
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |   3 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   2 +
 drivers/net/phy/phylink.c                          |  29 +-
 drivers/net/veth.c                                 |   4 +-
 drivers/net/vxlan/vxlan_core.c                     |  21 +-
 drivers/net/vxlan/vxlan_mdb.c                      |   4 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/of/address.c                               |  22 +-
 drivers/of/of_reserved_mem.c                       |  14 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   9 +-
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c          |   2 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |  62 +-
 drivers/pinctrl/Kconfig                            |   2 +
 drivers/pinctrl/devicetree.c                       |   4 +
 drivers/pinctrl/pinctrl-amd.c                      |   3 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   8 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  21 +-
 drivers/power/supply/bq25890_charger.c             |   2 +-
 drivers/power/supply/macsmc-power.c                |  52 +-
 drivers/power/supply/max17040_battery.c            |   6 +-
 drivers/ptp/ptp_netc.c                             |  15 +-
 drivers/s390/block/dasd_eckd.c                     |  11 +-
 drivers/s390/block/dasd_ioctl.c                    |   2 +-
 drivers/s390/crypto/pkey_cca.c                     |  15 +-
 drivers/s390/crypto/zcrypt_api.c                   |   4 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  89 ++-
 drivers/s390/crypto/zcrypt_ccamisc.h               |   6 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/scsi/zfcp_aux.c                       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  10 +-
 drivers/scsi/libiscsi.c                            |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   8 +-
 drivers/scsi/libsas/sas_init.c                     |  37 +-
 drivers/scsi/libsas/sas_scsi_host.c                |  15 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   9 +-
 drivers/scsi/scsi_debug.c                          |   8 +-
 drivers/spi/spi-cadence.c                          |  26 +-
 drivers/spi/spi-nxp-fspi.c                         |  83 ++-
 drivers/spi/spi-qcom-qspi.c                        |   3 +-
 drivers/spi/spi-qpic-snand.c                       |  22 +-
 drivers/target/target_core_iblock.c                |   6 +-
 drivers/target/target_core_transport.c             |  12 +-
 drivers/thunderbolt/xdomain.c                      |  40 +-
 drivers/ufs/core/ufs-rpmb.c                        |   2 -
 drivers/ufs/core/ufshcd.c                          |  46 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  88 +--
 drivers/usb/typec/ucsi/ucsi.h                      |   1 +
 fs/afs/fsclient.c                                  |   5 +-
 fs/afs/internal.h                                  |   3 +-
 fs/binfmt_misc.c                                   |  54 +-
 fs/btrfs/block-group.c                             |  34 +-
 fs/btrfs/block-rsv.c                               |  19 +-
 fs/btrfs/disk-io.c                                 |  58 +-
 fs/btrfs/extent_io.c                               |   6 -
 fs/btrfs/extent_io.h                               |   6 +
 fs/btrfs/fs.h                                      |   9 +
 fs/btrfs/raid56.c                                  |  15 +-
 fs/btrfs/super.c                                   |   8 +-
 fs/btrfs/zoned.c                                   |  27 +-
 fs/erofs/Kconfig                                   |  36 +-
 fs/erofs/Makefile                                  |   1 -
 fs/erofs/data.c                                    |   4 +-
 fs/erofs/decompressor_lzma.c                       |   3 +-
 fs/erofs/fscache.c                                 | 664 ---------------------
 fs/erofs/inode.c                                   |   2 +-
 fs/erofs/internal.h                                |  76 +--
 fs/erofs/ishare.c                                  | 101 ++--
 fs/erofs/super.c                                   |  94 +--
 fs/erofs/zdata.c                                   |   6 -
 fs/iomap/ioend.c                                   |  21 +-
 fs/netfs/buffered_read.c                           |  10 +-
 fs/netfs/internal.h                                |   1 +
 fs/netfs/main.c                                    |   7 +
 fs/netfs/objects.c                                 |  30 +-
 fs/netfs/read_pgpriv2.c                            |   3 +-
 fs/netfs/rolling_buffer.c                          |  22 +-
 fs/netfs/write_issue.c                             |  15 +-
 fs/ntfs/attrib.c                                   |  10 +
 fs/ntfs/namei.c                                    |   3 +-
 fs/ntfs/runlist.c                                  |  50 +-
 fs/ocfs2/dir.c                                     |   5 +-
 fs/proc/task_mmu.c                                 |  34 +-
 fs/smb/client/cifssmb.c                            |  12 +-
 fs/smb/client/inode.c                              |   1 +
 fs/smb/server/connection.h                         |   5 +
 fs/smb/server/smb2pdu.c                            |  14 +-
 fs/smb/server/smb_common.c                         |  37 +-
 fs/smb/server/vfs_cache.c                          |   6 +-
 include/acpi/cppc_acpi.h                           |   5 +-
 include/drm/drm_exec.h                             |  20 +-
 include/hyperv/hvhdk_mini.h                        |   3 +-
 include/kvm/arm_vgic.h                             |   3 -
 include/linux/alloc_tag.h                          |   3 +
 include/linux/dma/qcom_bam_dma.h                   |  21 +-
 include/linux/ethtool.h                            |   1 +
 include/linux/iommu.h                              |   5 +
 include/linux/libata.h                             |   6 +-
 include/linux/memcontrol.h                         |  25 +
 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/linux/netfs.h                              |   1 +
 include/linux/rolling_buffer.h                     |   6 +-
 include/linux/slab.h                               |  19 +-
 include/linux/thunderbolt.h                        |   3 +
 include/net/bluetooth/hci_core.h                   |   4 +-
 include/net/ip_vs.h                                |  45 +-
 include/net/mana/mana.h                            |  15 +-
 include/net/netfilter/nf_conntrack_expect.h        |   3 +
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/net/xdp_sock.h                             |   1 +
 include/net/xsk_buff_pool.h                        |   9 +-
 include/scsi/libsas.h                              |   3 +-
 io_uring/cancel.c                                  |   2 +-
 io_uring/net.c                                     |   1 +
 io_uring/tctx.c                                    |   7 +-
 io_uring/tctx.h                                    |   1 +
 kernel/audit.c                                     |  11 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/events/uprobes.c                            |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |  11 +
 kernel/sched/deadline.c                            |   3 +-
 kernel/trace/fprobe.c                              |   6 +-
 kernel/trace/ring_buffer.c                         |   2 +
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   3 +
 kernel/trace/trace_fprobe.c                        |  12 +-
 kernel/trace/trace_mmiotrace.c                     |  13 +-
 kernel/trace/trace_probe.c                         |   6 +-
 lib/alloc_tag.c                                    |   9 +
 lib/assoc_array.c                                  |   3 +-
 lib/test_fortify/Makefile                          |   1 +
 lib/test_hmm.c                                     |   2 +-
 mm/huge_memory.c                                   |  14 +-
 mm/hugetlb.c                                       |  12 +-
 mm/memcontrol-v1.h                                 |   6 +-
 mm/migrate_device.c                                |   5 +-
 mm/mm_init.c                                       |  15 +-
 mm/page_reporting.c                                |   6 +-
 mm/percpu-km.c                                     |   2 +-
 mm/slab.h                                          |  28 +-
 mm/slab_common.c                                   |  13 +
 mm/slub.c                                          |  97 ++-
 mm/util.c                                          |   2 +-
 mm/vmscan.c                                        |  11 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_sync.c                           | 220 ++++---
 net/bluetooth/hidp/core.c                          |  30 +-
 net/bluetooth/iso.c                                | 273 ++++++---
 net/bluetooth/l2cap_core.c                         |   5 +
 net/bluetooth/mgmt.c                               |  84 ++-
 net/bluetooth/sco.c                                |  22 +-
 net/bridge/br_mrp.c                                |   2 +-
 net/bridge/br_multicast.c                          |   1 +
 net/can/isotp.c                                    | 334 ++++++++---
 net/can/j1939/bus.c                                |   2 +
 net/can/j1939/j1939-priv.h                         |   3 +
 net/can/j1939/main.c                               |   8 +-
 net/can/j1939/transport.c                          |   4 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/pktgen.c                                  |   4 +-
 net/core/skbuff.c                                  |  18 +-
 net/ipv4/fou_core.c                                |   2 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |  22 +-
 net/ipv4/nexthop.c                                 |  25 +-
 net/ipv4/route.c                                   |   2 -
 net/ipv4/udp_tunnel_nic.c                          |  32 +-
 net/ipv6/fib6_rules.c                              |   1 +
 net/ipv6/ip6_fib.c                                 |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/ndisc.c                                   |   2 +
 net/mac80211/agg-tx.c                              |   4 +-
 net/mac80211/s1g.c                                 |   4 +
 net/mpls/af_mpls.c                                 |   1 +
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    | 192 ++++--
 net/netfilter/ipvs/ip_vs_core.c                    | 190 +++---
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  19 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  48 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  54 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  42 +-
 net/netfilter/nf_conntrack_expect.c                |  35 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_nat_sip.c                         |  22 +-
 net/netfilter/nf_tables_api.c                      |  34 +-
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 net/openvswitch/actions.c                          |  12 +-
 net/openvswitch/meter.c                            |  33 +-
 net/rds/tcp.c                                      |   8 +-
 net/sched/cls_u32.c                                |   7 +
 net/sched/sch_cake.c                               |   8 +-
 net/sctp/associola.c                               |   3 +
 net/sctp/sm_make_chunk.c                           |  17 +-
 net/smc/smc_core.c                                 |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/unix/af_unix.c                                 |   1 +
 net/xdp/xsk.c                                      | 257 +++++++-
 net/xdp/xsk_buff_pool.c                            |  13 +-
 net/xdp/xsk_queue.h                                |  65 +-
 security/keys/keyring.c                            |  14 +-
 security/keys/trusted-keys/trusted_dcp.c           |  15 +-
 sound/core/pcm_native.c                            |   7 +
 sound/core/seq/seq_timer.c                         |   9 +-
 sound/core/timer.c                                 |   2 +
 sound/core/ump.c                                   |   1 +
 sound/hda/codecs/realtek/alc269.c                  |   4 +-
 sound/pci/lx6464es/lx6464es.c                      |   5 +-
 sound/pci/lx6464es/lx_core.c                       |   5 +-
 sound/soc/codecs/max98090.c                        |   5 +-
 sound/soc/codecs/max98095.c                        |   5 +-
 sound/soc/codecs/tas2562.c                         |  30 +-
 sound/soc/codecs/tas2781-i2c.c                     |   4 +-
 sound/soc/fsl/fsl_asrc.c                           |   2 +-
 sound/soc/fsl/fsl_easrc.c                          |   2 +-
 sound/soc/sdca/sdca_device.c                       |   2 +-
 sound/soc/sdca/sdca_fdl.c                          |   5 +-
 sound/soc/sdca/sdca_functions.c                    |   2 +
 sound/soc/sdca/sdca_ump.c                          |   4 +-
 sound/soc/sophgo/cv1800b-sound-adc.c               |  10 +-
 sound/usb/6fire/chip.c                             |   4 +
 sound/usb/endpoint.c                               |  14 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/midi2.c                                  |   4 +-
 sound/usb/mixer_quirks.c                           |   2 +-
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 tools/testing/selftests/filesystems/fclog.c        |   4 +-
 tools/testing/selftests/lkdtm/tests.txt            |   2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  56 +-
 tools/testing/selftests/net/af_unix/.gitignore     |   1 +
 tools/testing/selftests/net/af_unix/Makefile       |   1 +
 tools/testing/selftests/net/af_unix/unix_listen.c  | 187 ++++++
 .../selftests/net/netfilter/nft_flowtable.sh       |  14 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   3 +-
 tools/tracing/rtla/src/timerlat_top.c              |   2 +-
 455 files changed, 6043 insertions(+), 3365 deletions(-)


