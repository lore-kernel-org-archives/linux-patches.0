Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D8A305665;
	Fri,  7 Aug 2026 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113806; cv=none; b=a0v7paYJticK4V26a7f9HK+KX0yMNwp+5hvXLZxUmaZ7SK4GtCeqWdFaYjZnb0acTlMZeKcnQk8mUe1nAD+ECdxjB9fU5a8lvR+5oPHfXnBhQYX1SqMROgYgaKlOeSSqKvogvOVataZ8aG9kRrIzACSQ8+zSPpjPNJLZt6JOAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113806; c=relaxed/simple;
	bh=mfporCSxJkLCFw6VoGN2e/fJbi/ve8IT/x6hL4x/Lmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=awr7ATP1jRSTjZ5Ht6omIJ2COV47H0+QLdOrSm1eY2nzm79I6VPuBF372b560jI3Z2q9ob5quV4MK3E16+hiHm1+u0WX9B6M6JZaHMSW+6v+FhyNBCPgc4iOd7glGihr52ASHgNR2AxLq+dvxlHL66w3GYEjibJfU/gDKHBokhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5KHmWWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5KHmWWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877681F00A3F;
	Fri,  7 Aug 2026 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113785;
	bh=cRUaoVIlW1BmcB84RNy9HyXqQNic2K6MwXOkvKkLDYE=;
	h=From:To:Cc:Subject:Date;
	b=v5KHmWWsc/kK++3zlBZfyoM5IiyrUIjIvbnJtwNvTavjXOIWQ7hHuylqbJCX79TXf
	 tyubONy20uAe6BcMRYyXIpVHqt04qf4om3gjFwqDaAQYeZVwIBzPPUYA5nz0peO0hH
	 jSUUZj6wIeIypuR6BZPXV6aFino9ok9YxY/3V4AI=
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
	sr@sladewatkins.com,
	Ilya Maximets <i.maximets@ovn.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 000/337] 6.12.103-rc1 review
Date: Fri,  7 Aug 2026 16:33:24 +0200
Message-ID: <20260807143418.516897842@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.103-rc1
X-KernelTest-Deadline: 2026-08-09T14:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.103 release.
There are 337 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.103-rc1

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info

Bart Van Assche <bvanassche@acm.org>
    drm/fb-helper: Fix a locking bug in an error path

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Oliver Hartkopp <socketcan@hartkopp.net>
    can: use skb hash instead of private variable in headroom

David Howells <dhowells@redhat.com>
    rxrpc: Fix irq-disabled in local_bh_enable()

David Howells <dhowells@redhat.com>
    rxrpc: Manage RTT per-call rather than per-peer

David Howells <dhowells@redhat.com>
    rxrpc: Fix the calculation and use of RTO

David Howells <dhowells@redhat.com>
    rxrpc: Adjust the rxrpc_rtt_rx tracepoint

David Howells <dhowells@redhat.com>
    rxrpc: Generate rtt_min

Zongyao Bai <zongyao.bai@intel.com>
    drm/xe/pt: Reset current_op in xe_pt_update_ops_init()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Stub out new pagefault layer

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Skip inactive MST connectors when building stream list

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Move to using intel_display in intel_hdcp

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe: Hold a dma-buf reference for imported BOs

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Rename ___xe_bo_create_locked()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vrr: require valid min/max vfreq for VRR

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Wait on external BO kernel fences in exec IOCTL

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/exec: Remove the index parameter from drm_exec_for_each_locked_obj[_reverse]

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fb-helper: Allocate and release fb_info in single place

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/gfx: fix cleaner shader IB buffer overflow

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: give each kernel job a unique id

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/sched: Store the drm client_id in drm_sched_fence

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Fix context pstate override handling

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions

Breno Leitao <leitao@debian.org>
    mm/kmemleak: fix checksum computation for per-cpu objects

Catalin Marinas <catalin.marinas@arm.com>
    kmemleak: iommu/iova: fix transient kmemleak false positive

Geliang Tang <geliang@kernel.org>
    mptcp: pm: userspace: fix use-after-free in get_local_id

Geliang Tang <geliang@kernel.org>
    mptcp: pm: use addr entry for get_local_id

Geliang Tang <geliang@kernel.org>
    mptcp: add mptcp_userspace_pm_lookup_addr helper

Geliang Tang <geliang@kernel.org>
    mptcp: pm: avoid code duplication to lookup endp

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: codecs: hdmi: disable keep-alive before audio format change

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)

Daniel Hodges <git@danielhodges.dev>
    wifi: ath6kl: fix use-after-free in aggr_reset_state()

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: uapi: rkisp: Correct name version enum

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Support CBP profile

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx219: Rename VTS to FRM_LENGTH

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix race condition and ordering in port unregistration

Sergey Senozhatsky <senozhatsky@chromium.org>
    usb: typec: ucsi: split connector lock classes

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Junjie Cao <junjie.cao@intel.com>
    gpio: pch: use raw_spinlock_t for the register lock

Harry Yoo (Oracle) <harry@kernel.org>
    mm/slab: prevent unbounded recursion in free path with new kmalloc type

Harry Yoo (Oracle) <harry@kernel.org>
    lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()

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

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Add RING_FORCE_TO_NONPRIV_DENY to OA whitelists

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Apply whitelist to engine save-restore

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Introduce xe_gt_dbg_printer()

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Refactor OAG MMIO trigger register whitelisting

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix CONNECTED -> CLOSED transition on shutdown/release

Wandun Chen <chenwandun@lixiang.com>
    of: reserved_mem: avoid post-init UAF when alloc_reserved_mem_array() fails

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Make ahci_ignore_port() handle empty mask_port_map

Damien Le Moal <dlemoal@kernel.org>
    ata: libahci_platform: Do not set mask_port_map when not needed

HyeongJun An <sammiee5311@gmail.com>
    HID: logitech-dj: Fix maxfield check in DJ short report validation

Jun Guo <jun.guo@cixtech.com>
    spi: spi-cadence: enable SPI_CONTROLLER_MUST_TX

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate external BO copy bounds for both stride paths

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: use check_add_overflow for shader size+offset bound

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: avoid destroy_workqueue(NULL) on vkms init failure

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: bound DMA command body size against suffix pointer

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate DRAW_PRIMITIVES header size before division

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: drop dma_buf reference on foreign-fd prime import

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

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Increase HDMI AV mute wait from 2 to 3 frames

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: cap GTT size to physical RAM on APUs

Candice Li <candice.li@amd.com>
    drm/amdgpu: restore UMD profile pstate after runtime resume

Myeonghun Pak <mhun512@gmail.com>
    drm/mediatek: ovl_adaptor: balance component registrations

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: validate firmware interface structure sizes

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: reject firmware sections with oversized data

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

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: use netdevice_tracker for j1939_{priv,session,ecu} tracking

Oleksij Rempel <o.rempel@pengutronix.de>
    can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer

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

Jonas Gorski <jonas.gorski@bisdn.de>
    i2c: iproc: reset bus after timeout if START_BUSY is stuck

H. Nikolaus Schaller <hns@goldelico.com>
    i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock

Dawei Feng <dawei.feng@seu.edu.cn>
    ice: fix memory leak in ice_lbtest_prepare_rings()

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

Xu Rao <raoxu@uniontech.com>
    power: supply: bq25890: fix the -10 C NTC lookup entry

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Publish util hooks only after all sg_cpu are initialized

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()

bui duc phuc <phucduc.bui@gmail.com>
    gpio: pca953x: fix cache_only and IRQ state on restore_context() failure

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

Ibrahim Hashimov <security@auditcode.ai>
    scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/clone3: fix wild pointer access of getline due to missing init

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/mm: fix potential wild pointer access of getline due to missing init

Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>
    spi: qcom-qspi: Correct max DMA length to avoid 64K boundary failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/filters: Fix false positive match in regex_match_full()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Check return value of __register_event() in trace_module_add_events()

Ming Lei <tom.leiming@gmail.com>
    ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()

Eric Dumazet <edumazet@google.com>
    vxlan: use pskb_network_may_pull() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: use neigh_ha_snapshot() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: unclone skb head before modifying eth header in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: re-fetch eth header after route_shortcircuit()

Matt Fleming <mfleming@cloudflare.com>
    veth: convert frag_list skbs before running XDP

Michael Bommarito <michael.bommarito@gmail.com>
    um: vector: fix use-after-free in vector_mmsg_rx()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()

Zhiling Zou <zhilinz@nebusec.ai>
    net: ipv6: clear suppressed fib6 rule result

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: stop fast-leave after deleting a port group

Breno Leitao <leitao@debian.org>
    mm: memcg: initialize *locked in memcg1_oom_prepare() stub

Link Lin <linkl@google.com>
    mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Christian Brauner <brauner@kernel.org>
    binfmt_misc: don't let an 'F' entry pin its own instance

Christian Brauner <brauner@kernel.org>
    binfmt_misc: reject a flag character as the field delimiter

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames

Zihan Xi <zihanx@nebusec.ai>
    tipc: avoid use-after-free in poll trace queue dumps

David Lee <david.lee@trailofbits.com>
    netfilter: ipset: do not update comments from kernel-side hash adds

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/smc: fix socket use-after-free during link group termination

Zhiling Zou <roxy520tt@gmail.com>
    ipvs: do not propagate one-packet flag to synced conns

Matt Vollrath <tactii@gmail.com>
    igbvf: Fix leak in TX DMA error cleanup

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

Niklas Cassel <cassel@kernel.org>
    ata: libata-sata: fix ata_scsi_lpm_supported() iteration

Matt Vollrath <tactii@gmail.com>
    ata: libata-eh: Increase STANDBY IMMEDIATE timeout

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix broken entries in the volume lookup table

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix DVC coefficient write order

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

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix UAF at error handling during probe

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

Zihan Xi <zihanx@nebusec.ai>
    Bluetooth: mgmt: fix pending command UAF in EIR updates

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

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Validate AIBV and AISB before pinning guest pages

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix NULL dereference on AIBV allocation failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Reject adapter interrupt forwarding if already enabled

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active

Raushan Patel <raushan.jhon@gmail.com>
    tracing/probes: Reject $arg0 in meta argument expansion

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Xiangfeng Cai <caixiangfeng@bytedance.com>
    mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan <ziy@nvidia.com>
    mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE

Nathan Chancellor <nathan@kernel.org>
    fortify: Disable -Wstringop-overread in tests

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: bm1880: add missing select GENERIC_PINCONF

Michael Bommarito <michael.bommarito@gmail.com>
    erofs: cap LZMA stream pool size

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: devicetree: don't free uninitialized dev_name on error path

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: microchip-sgpio: add missing select REGMAP_MMIO

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rhashtable: clear stale iter->p on table restart

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __close_file_table_ids()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return success for deferred final close

Denis V. Lunev <den@openvz.org>
    qede: sync udp_tunnel ports outside qede_lock in the recovery path

Gabriele Monaco <gmonaco@redhat.com>
    sched/deadline: Use revised wakeup rule only for running dl_server

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Set correct sequence for carrier off and tx queue stop

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix FDIR ATR queue mismatch for software VLAN packets

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed reads in MT7531 PHY polling

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check bus->read() errors in the MDIO regmap backend

Karl Mehltretter <kmehltretter@gmail.com>
    riscv: mm: Fix out-of-bounds page-table walk during memory hot-remove

Muhammad Bilal <meatuni001@gmail.com>
    accel/qaic: use sizeof(*trans_hdr) for transaction length check

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions

Zheng Yejian <zhengyejian@huaweicloud.com>
    tracing: Remove TRACE_EVENT_FL_FILTERED logic

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Reset dropped_count in mmio_reset_data()

Minhong He <heminhong@kylinos.cn>
    can: isotp: check register_netdevice_notifier() error in module init

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: check descriptor ring allocation failures

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: free TX rings on RX allocation failure

Leon Romanovsky <leon@kernel.org>
    scsi: target: Clear cmd_cnt when initial counter enrollment fails

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req

Guangshuo Li <lgs201920130244@gmail.com>
    scsi: ufs: core: Cancel RTC work in active-active suspend

TanZheng <tanzheng@kylinos.cn>
    scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE

Christian Marangi <ansuelsmth@gmail.com>
    net: phylink: put link_gpio if phylink_create fails

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_conn: hold conn reference in abort_conn_sync()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: make hci_cmd_sync_run_once return -EEXIST if exists

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btintel: Validate length before parsing diagnostics TLV

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: avoid deadlocks in iso_sock_timeout

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix leaking sk after socket release

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: validate sockaddr_iso first in iso_sock_rebind_bis()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos

Jiale Yao <yaojiale02@163.com>
    Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: clear iso_data always when detaching conn from hcon

Yuho Choi <dbgh9129@gmail.com>
    idpf: Fix mailbox IRQ name leak on request failure

Joshua Hay <joshua.a.hay@intel.com>
    idpf: adjust TxQ ring count minimum

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value from pmbus_update_byte_data()

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller

Frank Wunderlich <frank-w@public-files.de>
    net: ethernet: mtk_eth_soc: add consts for irq index

Frank Wunderlich <frank-w@public-files.de>
    net: ethernet: mtk_eth_soc: support named IRQs

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate individual TWT params before driver setup

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-akebono CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-currituck CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix simpleboot CPU node lookup check

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

Jonas Rebmann <jre@pengutronix.de>
    hwmon: (ina2xx) Shift INA234 shunt and current registers

Ian Ray <ian.ray@gehealthcare.com>
    hwmon: (ina2xx) Add support for INA234

Ian Ray <ian.ray@gehealthcare.com>
    hwmon: (ina2xx) Make it easier to add more devices

Wenliang Yan <wenliang202407@163.com>
    hwmon: (ina226) Add support for SY24655

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ina2xx) Add support for INA260

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ina2xx) Add support for has_alerts configuration flag

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix number of temperature registers for NCT6116

Srikanth Boyapally <srikanth.boyapally@amd.com>
    spi: spi-cadence: Move TX FIFO full busy-wait into FIFO

Jun Guo <jun.guo@cixtech.com>
    spi: spi-cadence: supports transmission with bits_per_word of 16 and 32

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

Xiang Mei <xmei5@asu.edu>
    rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: nft_payload: fix mask build for partial field offload

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

Michael Bommarito <michael.bommarito@gmail.com>
    assoc_array: trim the final shortcut word using the current chunk end

Michael Bommarito <michael.bommarito@gmail.com>
    keys: make keyring key-chunk byte order agree with keyring_diff_objects()

Michael Bommarito <michael.bommarito@gmail.com>
    keys: fix out-of-bounds read in keyring_get_key_chunk()

Fabrice Derepas <fabrice.derepas@canonical.com>
    KEYS: trusted: dcp: fix key_len validation and calc_blob_len() return type

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Drivers: hv: vmbus: Replace lockdep_hardirq_threaded() with lockdep annotation

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/mediatek: Check CRTC state before freeing

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix runtime PM leak on probe allocation failure

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix clock error handling in xpsgtr_phy_init()

Mike Looijmans <mike.looijmans@topic.nl>
    phy-zynqmp: Postpone getting clock rate until actually needed

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix deadlock between metadata writeback and transaction commit

Qu Wenruo <wqu@suse.com>
    btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag

Sang-Heon Jeon <ekffu200098@gmail.com>
    of: reserved_mem: prevent OOB when too many dynamic regions are defined

Oreoluwa Babatunde <quic_obabatun@quicinc.com>
    of: reserved_mem: Add code to dynamically allocate reserved_mem array

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()

Damien Le Moal <dlemoal@kernel.org>
    ahci: Introduce ahci_ignore_port() helper

Josua Mayer <josua@solid-run.com>
    ata: libahci_platform: support non-consecutive port numbers

Rosen Penev <rosenp@gmail.com>
    ata: sata_mv: accept 1 or 2 resources in platform probe

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    gpio: sloppy-logic-analyzer: Fix memory leak in gpio_la_poll_probe()

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: sc8280xp: Add missing wakeup entries for GPIO143/151

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    pinctrl: qcom: Unconditionally mark gpio as wakeup enable

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Jakub Kicinski <kuba@kernel.org>
    netconsole: avoid OOB reads, msg is not nul-terminated

Tristan Madani <tristan@talencesecurity.com>
    bpf: Reset register bounds before narrowing retval range in check_mem_access()

Benjamin Tissoires <bentiss@kernel.org>
    HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Standardise hid_report_enum variable nomenclature

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: mpls: initialize rtm_tos in mpls_getroute()

Wayen.Yan <win847@gmail.com>
    net: airoha: Fix register index for Tx-fwd counter configuration

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Preserve errno within signal handler

Shuvam Pandey <shuvampandey1@gmail.com>
    kunit: tool: skip stty when stdin is not a tty

David Gow <david@davidgow.net>
    kunit: tool: Terminate kernel under test on SIGINT

Benjamin Berg <benjamin.berg@intel.com>
    um: Set parent death signal for userspace process

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Set parent-death signal for write_sigio thread/process

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Set parent-death signal for ubd io thread/process

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Use os_set_pdeathsig helper in winch thread/process

Benjamin Berg <benjamin.berg@intel.com>
    um: Set parent death signal for winch thread/process

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Add os_set_pdeathsig helper function

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: restore helper propagation via expectation


-------------

Diffstat:

 Documentation/dev-tools/kmemleak.rst               |   1 +
 Documentation/hwmon/ina2xx.rst                     |  67 +-
 Makefile                                           |   4 +-
 arch/powerpc/boot/simpleboot.c                     |   2 +-
 arch/powerpc/boot/treeboot-akebono.c               |   2 +-
 arch/powerpc/boot/treeboot-currituck.c             |   2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   1 +
 arch/riscv/mm/init.c                               |   4 +-
 arch/s390/kvm/pci.c                                |  28 +-
 arch/s390/pci/pci_mmio.c                           |   1 +
 arch/um/drivers/chan_user.c                        |   2 +
 arch/um/drivers/ubd_kern.c                         |   1 +
 arch/um/drivers/vector_kern.c                      |   3 +
 arch/um/include/shared/os.h                        |   2 +
 arch/um/os-Linux/process.c                         |   6 +
 arch/um/os-Linux/sigio.c                           |   1 +
 arch/um/os-Linux/signal.c                          |   3 +
 arch/um/os-Linux/skas/process.c                    |   3 +
 arch/x86/kvm/svm/avic.c                            |   8 -
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/ata/ahci.h                                 |  17 +-
 drivers/ata/ahci_brcm.c                            |   3 +
 drivers/ata/ahci_ceva.c                            |  24 +-
 drivers/ata/libahci.c                              |   1 +
 drivers/ata/libahci_platform.c                     |  38 +-
 drivers/ata/libata-eh.c                            |   8 +
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/block/ublk_drv.c                           |   9 +
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/bluetooth/btmtk.c                          |  50 +-
 drivers/bluetooth/btusb.c                          |  30 +-
 drivers/cpufreq/powernow-k8.c                      |   1 +
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/dma/sun6i-dma.c                            |  11 +-
 drivers/gpio/gpio-pca953x.c                        |  15 +-
 drivers/gpio/gpio-pch.c                            |  28 +-
 drivers/gpio/gpio-sloppy-logic-analyzer.c          |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  73 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h            |  22 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  40 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |  12 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   2 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |  20 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |  16 +-
 drivers/gpu/drm/armada/armada_fbdev.c              |  12 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |  12 +
 drivers/gpu/drm/drm_exec.c                         |   6 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  41 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |  12 +-
 drivers/gpu/drm/drm_fbdev_shmem.c                  |  12 +-
 drivers/gpu/drm/drm_fbdev_ttm.c                    |  12 +-
 drivers/gpu/drm/drm_gpuvm.c                        |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   9 +-
 drivers/gpu/drm/gma500/fbdev.c                     |  13 +-
 drivers/gpu/drm/i915/display/intel_fbdev.c         |   9 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          | 699 +++++++++++----------
 drivers/gpu/drm/i915/display/intel_hdcp_gsc.c      |   9 +-
 drivers/gpu/drm/i915/display/intel_hdcp_gsc.h      |   5 +-
 .../gpu/drm/i915/display/intel_hdcp_gsc_message.h  |   3 +-
 drivers/gpu/drm/i915/display/intel_vrr.c           |  10 +-
 drivers/gpu/drm/imagination/pvr_job.c              |   2 +-
 drivers/gpu/drm/imagination/pvr_queue.c            |   5 +-
 drivers/gpu/drm/imagination/pvr_queue.h            |   2 +-
 drivers/gpu/drm/lima/lima_gem.c                    |   2 +-
 drivers/gpu/drm/lima/lima_sched.c                  |   6 +-
 drivers/gpu/drm/lima/lima_sched.h                  |   3 +-
 drivers/gpu/drm/mediatek/mtk_crtc.c                |   6 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |   7 +-
 drivers/gpu/drm/msm/msm_fbdev.c                    |   9 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   8 +-
 drivers/gpu/drm/nouveau/nouveau_sched.c            |   3 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |   9 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   2 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |   3 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |  47 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |   2 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   5 +-
 drivers/gpu/drm/panthor/panthor_sched.h            |   3 +-
 drivers/gpu/drm/radeon/radeon_fbdev.c              |  13 +-
 drivers/gpu/drm/scheduler/sched_fence.c            |   4 +-
 drivers/gpu/drm/scheduler/sched_main.c             |   7 +-
 drivers/gpu/drm/tegra/fbdev.c                      |  18 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   |   2 +-
 drivers/gpu/drm/vc4/vc4_irq.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_validate.c                 |  29 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c               |  39 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c               |  17 +-
 drivers/gpu/drm/xe/Makefile                        |   1 +
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c           |   7 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  33 +-
 drivers/gpu/drm/xe/xe_bo.h                         |  10 +-
 drivers/gpu/drm/xe/xe_bo_types.h                   |   2 +
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   6 +-
 drivers/gpu/drm/xe/xe_exec.c                       |  22 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   4 +-
 drivers/gpu/drm/xe/xe_gt_debugfs.c                 |   4 +-
 drivers/gpu/drm/xe/xe_gt_printk.h                  |  31 +
 drivers/gpu/drm/xe/xe_hw_engine.c                  |   3 +-
 drivers/gpu/drm/xe/xe_hw_engine_types.h            |   8 +
 drivers/gpu/drm/xe/xe_oa.c                         |   7 +
 drivers/gpu/drm/xe/xe_oa_types.h                   |   3 +
 drivers/gpu/drm/xe/xe_pagefault.c                  |  65 ++
 drivers/gpu/drm/xe/xe_pagefault.h                  |  19 +
 drivers/gpu/drm/xe/xe_pagefault_types.h            | 136 ++++
 drivers/gpu/drm/xe/xe_pt.c                         |   3 +
 drivers/gpu/drm/xe/xe_reg_sr.c                     |  53 --
 drivers/gpu/drm/xe/xe_reg_whitelist.c              | 147 ++++-
 drivers/gpu/drm/xe/xe_reg_whitelist.h              |   4 +
 drivers/gpu/drm/xe/xe_sched_job.c                  |   3 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   3 +-
 drivers/hid/hid-logitech-dj.c                      |  28 +-
 drivers/hv/vmbus_drv.c                             |  13 +-
 drivers/hwmon/Kconfig                              |   5 +-
 drivers/hwmon/adt7470.c                            | 131 ++--
 drivers/hwmon/ina2xx.c                             | 251 ++++++--
 drivers/hwmon/lm90.c                               |   4 +-
 drivers/hwmon/ltc4282.c                            |   4 +-
 drivers/hwmon/nct6775-core.c                       |  20 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |  11 +
 drivers/hwmon/nzxt-smart2.c                        |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   7 +-
 drivers/hwmon/sht3x.c                              |   9 +-
 drivers/i2c/busses/i2c-amd-mp2-plat.c              |   4 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  11 +
 drivers/i2c/busses/i2c-imx.c                       |   9 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/iommu/iova.c                               |   6 +
 drivers/media/i2c/imx219.c                         |  31 +-
 .../media/platform/chips-media/wave5/wave5-hw.c    |   3 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |   5 +-
 .../platform/chips-media/wave5/wave5-vpuapi.h      |   1 +
 drivers/net/can/c_can/c_can_main.c                 |   8 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  14 +-
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |   3 +-
 drivers/net/can/dev/skb.c                          |   2 -
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
 drivers/net/dsa/mt7530.c                           |  58 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   5 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  58 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   7 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  44 +-
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |   3 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  14 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   2 +
 drivers/net/netconsole.c                           |   3 +-
 drivers/net/phy/phylink.c                          |  29 +-
 drivers/net/veth.c                                 |   4 +-
 drivers/net/vxlan/vxlan_core.c                     |  15 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  46 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/of/of_reserved_mem.c                       |  87 ++-
 drivers/phy/xilinx/phy-zynqmp.c                    | 130 ++--
 drivers/pinctrl/Kconfig                            |   2 +
 drivers/pinctrl/devicetree.c                       |   4 +
 drivers/pinctrl/pinctrl-amd.c                      |   3 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   8 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  21 +-
 drivers/power/supply/bq25890_charger.c             |   2 +-
 drivers/power/supply/max17040_battery.c            |   6 +-
 drivers/s390/block/dasd_eckd.c                     |  11 +-
 drivers/s390/block/dasd_ioctl.c                    |   2 +-
 drivers/s390/crypto/zcrypt_api.c                   |   2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |   6 +
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/scsi/zfcp_aux.c                       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  10 +-
 drivers/scsi/libiscsi.c                            |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   8 +-
 drivers/scsi/libsas/sas_init.c                     |  37 +-
 drivers/scsi/scsi_debug.c                          |   8 +-
 drivers/spi/spi-cadence.c                          | 129 +++-
 drivers/spi/spi-qcom-qspi.c                        |   3 +-
 drivers/target/target_core_iblock.c                |   6 +-
 drivers/target/target_core_transport.c             |  12 +-
 drivers/thunderbolt/xdomain.c                      |  40 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/usb/gadget/function/f_tcm.c                | 192 +++++-
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/usb/typec/ucsi/ucsi.c                      |  88 +--
 drivers/usb/typec/ucsi/ucsi.h                      |   1 +
 fs/binfmt_misc.c                                   |   8 +
 fs/btrfs/super.c                                   |   8 +-
 fs/btrfs/zoned.c                                   |   6 +-
 fs/erofs/Kconfig                                   |  14 +
 fs/erofs/decompressor_lzma.c                       |   3 +-
 fs/proc/task_mmu.c                                 |  33 +-
 fs/smb/client/cifssmb.c                            |  12 +-
 fs/smb/server/vfs_cache.c                          |   6 +-
 include/drm/drm_exec.h                             |  20 +-
 include/drm/drm_fb_helper.h                        |  12 -
 include/drm/gpu_scheduler.h                        |  12 +-
 include/linux/alloc_tag.h                          |   3 +
 include/linux/can/core.h                           |   1 +
 include/linux/can/skb.h                            |   2 -
 include/linux/dma/qcom_bam_dma.h                   |  21 +-
 include/linux/kmemleak.h                           |   4 +
 include/linux/libata.h                             |   2 +-
 include/linux/mmc/sdio_ids.h                       |   2 +-
 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/linux/slab.h                               |   8 +-
 include/linux/thunderbolt.h                        |   3 +
 include/linux/trace_events.h                       |   4 -
 include/net/ip_vs.h                                |  45 +-
 include/net/neighbour.h                            |   8 +-
 include/net/netfilter/nf_conntrack_expect.h        |   5 +-
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/scsi/libsas.h                              |   1 -
 include/trace/events/rxrpc.h                       |  14 +-
 include/uapi/linux/rkisp1-config.h                 |   6 +-
 kernel/audit.c                                     |  11 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/verifier.c                              |   1 +
 kernel/sched/cpufreq_schedutil.c                   |  11 +
 kernel/sched/deadline.c                            |   3 +-
 kernel/trace/trace.c                               |  44 +-
 kernel/trace/trace.h                               |   4 -
 kernel/trace/trace_branch.c                        |   4 +-
 kernel/trace/trace_events.c                        |   6 +-
 kernel/trace/trace_events_filter.c                 |   3 +
 kernel/trace/trace_functions_graph.c               |   8 +-
 kernel/trace/trace_hwlat.c                         |   4 +-
 kernel/trace/trace_mmiotrace.c                     |  21 +-
 kernel/trace/trace_osnoise.c                       |  12 +-
 kernel/trace/trace_probe.c                         |   6 +-
 kernel/trace/trace_sched_wakeup.c                  |   8 +-
 lib/alloc_tag.c                                    |   9 +
 lib/assoc_array.c                                  |   3 +-
 lib/rhashtable.c                                   |   1 +
 lib/test_fortify/Makefile                          |   1 +
 lib/win_minmax.c                                   |   1 +
 mm/huge_memory.c                                   |  16 +-
 mm/hugetlb.c                                       |  12 +-
 mm/kmemleak.c                                      |  44 +-
 mm/memcontrol-v1.h                                 |   6 +-
 mm/migrate_device.c                                |   5 +-
 mm/mm_init.c                                       |  15 +-
 mm/page_reporting.c                                |   6 +-
 mm/percpu-km.c                                     |   2 +-
 mm/slab.h                                          |  28 +-
 mm/slab_common.c                                   |  13 +
 mm/slub.c                                          |  34 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_sync.c                           | 154 +++--
 net/bluetooth/hidp/core.c                          |  30 +-
 net/bluetooth/iso.c                                | 113 ++--
 net/bluetooth/l2cap_core.c                         |   5 +
 net/bluetooth/mgmt.c                               |  84 ++-
 net/bridge/br_mrp.c                                |   2 +-
 net/bridge/br_multicast.c                          |   1 +
 net/bridge/br_netfilter_hooks.c                    |   6 +-
 net/can/af_can.c                                   |  14 +-
 net/can/bcm.c                                      |   2 -
 net/can/isotp.c                                    | 337 +++++++---
 net/can/j1939/bus.c                                |   2 +
 net/can/j1939/j1939-priv.h                         |   3 +
 net/can/j1939/main.c                               |   8 +-
 net/can/j1939/socket.c                             |   1 -
 net/can/j1939/transport.c                          |   6 +-
 net/can/raw.c                                      |   7 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/skbuff.c                                  |  18 +-
 net/ipv4/route.c                                   |   2 -
 net/ipv4/udp_tunnel_nic.c                          |  32 +-
 net/ipv6/fib6_rules.c                              |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/ndisc.c                                   |   2 +
 net/mac80211/s1g.c                                 |   4 +
 net/mpls/af_mpls.c                                 |   1 +
 net/mptcp/pm.c                                     |   9 +-
 net/mptcp/pm_netlink.c                             |  29 +-
 net/mptcp/pm_userspace.c                           |  87 ++-
 net/mptcp/protocol.h                               |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   3 +
 net/netfilter/ipvs/ip_vs_core.c                    | 180 +++---
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  19 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  48 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  54 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  42 +-
 net/netfilter/nf_conntrack_broadcast.c             |   1 +
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_conntrack_expect.c                |   1 +
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |   5 +
 net/netfilter/nf_conntrack_netlink.c               |  18 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_nat_sip.c                         |   2 +-
 net/netfilter/nf_tables_api.c                      |  34 +-
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 net/openvswitch/actions.c                          |  12 +-
 net/openvswitch/meter.c                            |  33 +-
 net/rds/ib.c                                       |   4 +
 net/rds/ib_cm.c                                    |   4 +
 net/rds/tcp.c                                      |  14 +-
 net/rxrpc/ar-internal.h                            |  38 +-
 net/rxrpc/call_accept.c                            |   1 +
 net/rxrpc/call_event.c                             |  19 +-
 net/rxrpc/call_object.c                            |   2 +
 net/rxrpc/input.c                                  |  12 +-
 net/rxrpc/output.c                                 |  14 +-
 net/rxrpc/peer_object.c                            |  20 +-
 net/rxrpc/proc.c                                   |   6 +-
 net/rxrpc/rtt.c                                    | 103 +--
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sctp/associola.c                               |   3 +
 net/sctp/sm_make_chunk.c                           |  17 +-
 net/smc/smc_core.c                                 |   2 +-
 net/tipc/socket.c                                  |   2 +-
 security/keys/keyring.c                            |  14 +-
 security/keys/trusted-keys/trusted_dcp.c           |  15 +-
 sound/core/pcm_native.c                            |   7 +
 sound/core/seq/seq_timer.c                         |   9 +-
 sound/core/timer.c                                 |   2 +
 sound/core/ump.c                                   |   1 +
 sound/pci/hda/patch_hdmi.c                         |  48 +-
 sound/pci/lx6464es/lx6464es.c                      |   5 +-
 sound/pci/lx6464es/lx_core.c                       |   5 +-
 sound/soc/codecs/max98090.c                        |   5 +-
 sound/soc/codecs/max98095.c                        |   5 +-
 sound/soc/codecs/tas2562.c                         |  30 +-
 sound/usb/6fire/chip.c                             |   4 +
 sound/usb/endpoint.c                               |  14 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/midi2.c                                  |   4 +-
 sound/usb/mixer_quirks.c                           |   2 +-
 tools/testing/kunit/kunit_kernel.py                |  39 +-
 tools/testing/kunit/kunit_tool_test.py             |  42 ++
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |   2 +-
 387 files changed, 4750 insertions(+), 2372 deletions(-)


From gregkh@linuxfoundation.org Fri Aug  7 16:34:18 2026
Message-ID: <20260807143418.550667215@linuxfoundation.org>
User-Agent: quilt/0.69
Date: Fri, 07 Aug 2026 16:34:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com,
 Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Sasha Levin <sashal@kernel.org>
X-stable: review
X-Patchwork-Hint: ignore
Subject: [PATCH 6.12 001/337] netfilter: nf_conntrack_expect: restore helper propagation via
 expectation
MIME-Version: 1.0

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a ]

A recent series to fix expectations broke helper propagation via
expectation, this mechanism is used by the sip and h323 helper. This
also propagates the conntrack helper to expected connections. I changed
semantics of exp->helper which now tells us the actual helper that
created the expectation.

Add an explicit assign_helper field to expectations for this purpose
and update helpers to use it.

Restore this feature for userspace conntrack helper via ctnetlink
nfqueue integration so it is again possible to attach a helper to an
expectation, where it makes sense. This is not restored via ctnetlink
expectation creation as there is no client for such feature. Use the
expectation layer 4 protocol number for the helper lookup for
consistency.

Make sure the expectation using this helper propagation mechanism also
go away when the helper is unregistered.

Fixes: 9c42bc9db90a ("netfilter: nf_conntrack_expect: honor expectation helper field")
Fixes: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Tested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  5 ++++-
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_core.c           |  7 +++++--
 net/netfilter/nf_conntrack_expect.c         |  1 +
 net/netfilter/nf_conntrack_h323_main.c      | 12 ++++++------
 net/netfilter/nf_conntrack_helper.c         |  5 +++++
 net/netfilter/nf_conntrack_netlink.c        | 18 ++++++++++++++++--
 net/netfilter/nf_conntrack_sip.c            |  2 +-
 8 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index e9a8350e7ccf..80f50fd0f7ad 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -45,9 +45,12 @@ struct nf_conntrack_expect {
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
 
-	/* Helper to assign to new connection */
+	/* Helper that created this expectation */
 	struct nf_conntrack_helper __rcu *helper;
 
+	/* Helper to assign to new connection */
+	struct nf_conntrack_helper __rcu *assign_helper;
+
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index f9528d4db0a8..93c501d9d399 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -72,6 +72,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, NULL);
 	write_pnet(&exp->net, net);
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 423080cf86a4..0c457e159727 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1773,14 +1773,17 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		spin_lock_bh(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
 		if (exp) {
+			struct nf_conntrack_helper *assign_helper;
+
 			/* Welcome, Mr. Bond.  We've been expecting you... */
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
 			ct->master = exp->master;
-			if (exp->helper) {
+			assign_helper = rcu_dereference(exp->assign_helper);
+			if (assign_helper) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 				if (help)
-					rcu_assign_pointer(help->helper, exp->helper);
+					rcu_assign_pointer(help->helper, assign_helper);
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index bb8b87f9ee50..a8929885485b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -344,6 +344,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		helper = rcu_dereference(help->helper);
 
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, NULL);
 	write_pnet(&exp->net, net);
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 791aafe9f396..c42547284f35 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -642,7 +642,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, &nf_conntrack_helper_h245);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_h245);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -766,7 +766,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1233,7 +1233,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1305,7 +1305,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_ras);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1522,7 +1522,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1576,7 +1576,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 9150bcfd7ca8..ea0cdb7ec915 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -419,6 +419,11 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 
 	this = rcu_dereference_protected(exp->helper,
 					 lockdep_is_held(&nf_conntrack_expect_lock));
+	if (this == me)
+		return true;
+
+	this = rcu_dereference_protected(exp->assign_helper,
+					 lockdep_is_held(&nf_conntrack_expect_lock));
 	return this == me;
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eacbbc342c3f..80fdb875c977 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2630,6 +2630,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
+		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
@@ -2856,6 +2857,7 @@ static int
 ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 			     u32 portid, u32 report)
 {
+	struct nf_conntrack_helper *assign_helper = NULL;
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
 	struct nf_conntrack_expect *exp;
@@ -2871,8 +2873,18 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
+	if (cda[CTA_EXPECT_HELP_NAME]) {
+		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
+
+		assign_helper = __nf_conntrack_helper_find(helpname,
+							   nf_ct_l3num(ct),
+							   tuple.dst.protonum);
+		if (!assign_helper)
+			return -EOPNOTSUPP;
+	}
+
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     &tuple, &mask);
+				     assign_helper, &tuple, &mask);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3511,6 +3523,7 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
+		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
@@ -3564,6 +3577,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	exp->zone = ct->zone;
 #endif
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, assign_helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
@@ -3619,7 +3633,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	exp = ctnetlink_alloc_expect(cda, ct, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index bd91b8b47f4b..852c0b74b8a7 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1386,7 +1386,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-- 
2.53.0



