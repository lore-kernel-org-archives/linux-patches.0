Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411E43DA3C;
	Thu, 30 Jul 2026 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421095; cv=none; b=OOPVLElhn2zttVbaYvGXgcj3Ep+9kGV6T9qISXz8fOINGqDWwgWBG7kayPGjRlUJvJR1nhDefdB4raHuDQyTVvFymQuHdYWdElmxu28KuPM8fFKbDg/y9c8348S2ZcpB218IsGnRPHn/UFwUmlpl0uZTLj/1inEblK2P2IG1vtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421095; c=relaxed/simple;
	bh=6009AOc7Yr/EBahmlhbElK+tiILWllGl3MGJHF/m+MI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mUaXbh3Y/tPW3sgb90FQWQHA9GXnw6CltlXfA8Hbi3zFQT6XbIL2G1yTqrbRG0AAKrVaysrsNfaOtH66+rWi9JdaifCk0GiPPlKW27q8s7GLQIpGiD78aKetwkDJo13d2DFev2Lym8LhrlG+/Fm3afbCyoMkn2l/Agu9Sln2EII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyCGxL2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyCGxL2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9501F000E9;
	Thu, 30 Jul 2026 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421088;
	bh=HNH0GbKNIeFCbcM17SXpUyWrBpkzmLFE8Oc/sJb+PzA=;
	h=From:To:Cc:Subject:Date;
	b=ZyCGxL2TItP8BPUOgu+xfClc6bLs0ozyLTM/di7+c3X7xL8ApYOwdEYoCxwBmuK3a
	 FD43yoV4z8++rjZrbfPJ9OT5fAmYlSF6qHHxZJsL5INJm1jt1ug8WfQ/NhbKaksnTo
	 RR6FTo9JZvGzHWgUrlF/IUjdLmhC18ze9F0fgqqc=
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
Subject: [PATCH 7.1 000/744] 7.1.6-rc1 review
Date: Thu, 30 Jul 2026 16:04:33 +0200
Message-ID: <20260730141444.267951807@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.1.6-rc1
X-KernelTest-Deadline: 2026-08-01T14:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.1.6 release.
There are 744 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.1.6-rc1

Nikunj A Dadhania <nikunj@amd.com>
    KVM: SVM: Bump asid_generation on CPU online to avoid ASID collision after hotplug

Willem de Bruijn <willemb@google.com>
    selftests: drv-net: so_txtime: relax variance bounds

Willem de Bruijn <willemb@google.com>
    selftests: drv-net: cope with slow env in so_txtime.py test

Andrea Righi <arighi@nvidia.com>
    sched_ext: Preserve rq tracking across local DSQ dispatch

Tejun Heo <tj@kernel.org>
    sched_ext: Move shared helpers from ext.c into internal.h and cid.h

Breno Leitao <leitao@debian.org>
    bootconfig: fix NULL-pointer arithmetic in xbc_snprint_cmdline()

Breno Leitao <leitao@debian.org>
    bootconfig: move xbc_snprint_cmdline() to lib/bootconfig.c

Shradha Gupta <shradhagupta@linux.microsoft.com>
    net: mana: Optimize irq affinity for low vcpu configs

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove XDomain from the bus without holding tb->lock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove service debugfs entries during unregister

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Muchun Song <muchun.song@linux.dev>
    mm/sparse-vmemmap: fix DAX vmemmap accounting with optimization

Muchun Song <muchun.song@linux.dev>
    mm/sparse-vmemmap: pass @pgmap argument to memory deactivation paths

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Return an error from xdr_buf_to_bvec() on overflow

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add helpers to convert xdr_buf byte ranges to scatterlists

Darrick J. Wong <djwong@kernel.org>
    xfs: don't replace the wrong part of the cow fork

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: fix race between registration and connection abortion

Ricardo Robaina <rrobaina@redhat.com>
    audit: fix recursive locking deadlock in audit_dupe_exe()

Ricardo Robaina <rrobaina@redhat.com>
    audit: use 'unsigned int' instead of 'unsigned'

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix DTB DTO updates breaking live pixel rate sources

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate ACE size against SID sub-authorities

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: bound DACL dedup walk to copied ACEs

Wentao Guan <guanwentao@uniontech.com>
    ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: drv-net: add missing kconfig for psp.py

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix check in amdgpu_hmm_invalidate_gfx

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu13 power limit range calculation

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: fix aperture mapping leak

Zhu Lingshan <lingshan.zhu@amd.com>
    drm/amdgpu: reject mapping a reserved doorbell to a new queue

Ce Sun <cesun102@amd.com>
    drm/amdgpu: invoke pm_genpd_remove() before freeing genpd

Ce Sun <cesun102@amd.com>
    drm/amdgpu: fix resource leak on ACP reset timeout

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdgpu: Fix kernel panic during driver load failure

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu: fix division by zero with invalid uvd dimensions

Luca Coelho <luciano.coelho@intel.com>
    drm/dp_mst: Handle torn-down topology gracefully in drm_dp_mst_topology_queue_probe()

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn4: avoid rereading IB param length

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vce: fix integer overflow in image size

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma7.1: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu/mes11: set doorbell offset for suspending userq

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/jpeg: fix jpeg_v5_0_1_is_idle detection

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/jpeg: fix jpeg_v4_0_3_is_idle detection

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9.4.3: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx8: drop unecessary BUG_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx12: replace BUG_ON() with WARN_ON()

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx12: fix EOP interrupt routing for KQ and userq

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx11: fix EOP interrupt routing for KQ and userq

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx12.1: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: make pp_features read-only when scpm is enabled

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix amdgpu_pm_info power display units

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    watchdog: s32g_wdt: remove incorrect options in watchdog_info struct

James Raphael Tiovalen <jamestiotio@gmail.com>
    vxlan: mdb: Fix source list corruption on a failed replace

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: collapse receive queue under memory pressure

Daehyeon Ko <4ncienth@gmail.com>
    tipc: clear sock->sk on the failed-insert path in tipc_sk_create()

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    tcp: challenge ACK for non-exact RST in SYN-RECEIVED

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    tcp: initialize standalone TCP-AO response padding

Justin Lai <justinlai0215@realtek.com>
    rtase: Workaround for TX hang caused by hardware packet parsing

Asim Viladi Oglu Manizada <manizada@pm.me>
    pppoe: reload header pointer after dev_hard_header()

Shuvam Pandey <shuvampandey1@gmail.com>
    ovpn: hold peer before scheduling keepalive work

Pavitra Jha <jhapavitra98@gmail.com>
    ovpn: fix peer refcount leak in TCP error paths

Kyle Zeng <kylebot@openai.com>
    openvswitch: fix GSO userspace truncation underflow

Doruk Tan Ozturk <doruk@0sec.ai>
    mctp: serial: handle zero-length frames to prevent rx buffer overflow

Doruk Tan Ozturk <doruk@0sec.ai>
    mac802154: llsec: reject frames shorter than the authentication tag

Ibrahim Hashimov <security@auditcode.ai>
    mac802154: hold an interface reference across the scan worker

Michael Bommarito <michael.bommarito@gmail.com>
    ila: reload IPv6 header after pskb_may_pull in checksum adjust

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: use READ_ONCE() to access cached PHC time

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    ice: reject out-of-range ptype in ice_parser_profile_init

Eddie Phillips <eddiephillips@google.com>
    gve: fix Rx queue stall on alloc failure

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate minimum PDU size for transform requests

James Montgomery <james_montgomery@disroot.org>
    ksmbd: defer destroy_previous_session() until after NTLM authentication

Carl Johnson <carl@jpartners.org>
    smb: client: handle STATUS_STOPPED_ON_SYMLINK responses without a symlink target

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    rbd: Reset positive result codes to zero in object map update path

Christian Brauner <brauner@kernel.org>
    super: fix emergency thaw deadlock on frozen block devices

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Reset triggers at top level before instance loop

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix PTP Call Trace during PTP release

Sven Schnelle <svens@linux.ibm.com>
    ptp: ptp_s390: Add missing facility check

Jann Horn <jannh@google.com>
    proc: Fix broken error paths for namespace links

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    net: qrtr: ns: Raise node count limit to 512

Coia Prant <coiaprant@gmail.com>
    net: pcs: xpcs: fix SGMII state reading

Fan Wu <fanwu01@zju.edu.cn>
    net: hip04: fix RX buffer leak on build_skb failure

Shiming Cheng <shiming.cheng@mediatek.com>
    net: gro: fix double aggregation of flush-marked skbs

David Lee <david.lee@trailofbits.com>
    net/x25: fix use-after-free in x25_kill_by_neigh()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net/sched: serialize qdisc_rtab_list against concurrent get/put

Manjunath Patil <manjunath.b.patil@oracle.com>
    net/mlx5e: Use sender devcom for MPV master-up

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: fix use-after-free of a severed iucv_path

Hidayath Khan <hidayath@linux.ibm.com>
    net/af_iucv: fix NULL deref in afiucv_hs_callback_syn()

Doruk Tan Ozturk <doruk@0sec.ai>
    geneve: require CAP_NET_ADMIN in the device netns for changelink

Sungmin Kang <726ksm@gmail.com>
    net: slip: serialize receive against buffer reallocation

Doruk Tan Ozturk <doruk@0sec.ai>
    vxlan: require CAP_NET_ADMIN in the device netns for changelink

Breno Leitao <leitao@debian.org>
    phonet: pep: fix use-after-free in pep_get_sb()

Markus Breitenberger <bre@keba.com>
    net: stmmac: intel: skip SerDes reconfig when rate is unchanged

Harry Yoo (Oracle) <harry@kernel.org>
    mm/slab: fix a memory leak due to bootstrapping sheaves twice

Shengming Hu <hu.shengming@zte.com.cn>
    mm/slub: fix lost local objects when bulk remote free batch fills

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Disallow SVA if page walk is not coherent

Zhang Yi <yi.zhang@huawei.com>
    iomap: fix out-of-bounds bitmap_set() with zero-length range

Yitang Yang <yi1tang.yang@gmail.com>
    io_uring/rw: fix missing ERESTARTSYS conversion in read paths

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Add global mutex to serialize trace_parser access

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Avoid dynamic allocation in fscrypt_get_devices()

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Add missing superblock check in find_or_insert_direct_key()

Amir Goldstein <amir73il@gmail.com>
    fs: preserve ACL_DONT_CACHE state in forget_cached_acl()

Chen Changcheng <chenchangcheng@kylinos.cn>
    fs/super: fix emergency thaw double-unlock of s_umount

Christian Brauner <brauner@kernel.org>
    binfmt_elf_fdpic: only honour the first PT_INTERP

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_sai: Fix spurious BCLK on resume by clearing BYP

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl: imx-card: Skip sysclk reset for active DAIs in shutdown

Shihuang Liu <shlomojune6@gmail.com>
    amt: fix use-after-free in AMT delayed works

Douya Le <ldy3087146292@gmail.com>
    libceph: remove debugfs files before client teardown

Douya Le <ldy3087146292@gmail.com>
    libceph: reject zero bucket types in crush_decode

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Reject monmaps advertising zero monitors

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    libceph: refresh auth->authorizer_buf{,_len} after authorizer update

Zhao Zhang <zzhan461@ucr.edu>
    libceph: guard missing CRUSH type name lookup

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix two unsafe bare decodes in decode_lockers()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix multiplication overflow in decode_new_up_state_weight()

Xiang Mei <xmei5@asu.edu>
    libceph: bound pg_{temp,upmap,upmap_items} length to CEPH_PG_MAX_SIZE

Douya Le <ldy3087146292@gmail.com>
    libceph: bound get_version reply decode to front len

Wentao Liang <vulab@iscas.ac.cn>
    ceph: fix writeback_count leak in write_folio_nounlock()

WenTao Liang <vulab@iscas.ac.cn>
    ceph: fix refcount leak in ceph_readdir()

Bryam Vargas <hexlabsecurity@proton.me>
    ceph: fix pre-auth out-of-bounds read on snaptrace in ceph_handle_caps()

Max Kellermann <max.kellermann@ionos.com>
    ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*

Zhiling Zou <roxy520tt@gmail.com>
    sctp: close UDP tunnel sockets during netns teardown

Zhiling Zou <roxy520tt@gmail.com>
    sctp: avoid auth_enable sysctl UAF during netns teardown

Jun Yang <junvyyang@tencent.com>
    sctp: don't free the ASCONF's own transport in DEL-IP processing

Rik van Riel <riel@surriel.com>
    mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established

Wei Yang <richard.weiyang@gmail.com>
    mm/page_vma_mapped: fix device-private PMD handling

Xie Yuanbin <xieyuanbin1@huawei.com>
    mm/memory-failure: trace: change memory_failure_event to ras subsystem

Breno Leitao <leitao@debian.org>
    mm/kmemleak: fix checksum computation for per-cpu objects

SJ Park <sj@kernel.org>
    mm/damon/core: disallow overlapping input ranges for damon_set_regions()

Thomas Weißschuh <linux@weissschuh.net>
    m68k: avoid -Wunused-but-set-parameter in clear_user_page()

SJ Park <sj@kernel.org>
    mm/damon/core: validate ranges in damon_set_regions()

Mike Rapoport (Microsoft) <rppt@kernel.org>
    userfaultfd: prevent registration of special VMAs

Qu Wenruo <wqu@suse.com>
    btrfs: do not try compression for data reloc inodes

David Howells <dhowells@redhat.com>
    afs: Fix afs_edit_dir_remove() to get, not find, block 0

Geliang Tang <geliang@kernel.org>
    selftests: mptcp: userspace_pm: fix undefined variable port

Geliang Tang <geliang@kernel.org>
    mptcp: pm: userspace: fix use-after-free in get_local_id

Michael Bommarito <michael.bommarito@gmail.com>
    mptcp: only set DATA_FIN when a mapping is present

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: fix stale skb->sk reference on subflow close

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fix BUILD_BUG_ON on legacy ARM config

Chenguang Zhao <zhaochenguang@kylinos.cn>
    mptcp: decrement subflows counter on failed passive join

Will Deacon <will@kernel.org>
    Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"

Will Deacon <will@kernel.org>
    arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates

Dev Jain <dev.jain@arm.com>
    arm64: make huge_ptep_get handled unaligned addresses

Fuad Tabba <fuad.tabba@linux.dev>
    tracing/remotes: Fix page_va[] access before counter update in trace_remote_alloc_buffer()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix potential underflow in LEN_OR_ZERO macro

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()

Ming Lei <tom.leiming@gmail.com>
    ublk: wait on ublk_dev_ready() instead of ub->completion

Jackie Liu <liuyun01@kylinos.cn>
    tracing: Propagate errors from remote event bulk updates

Steven Rostedt <rostedt@goodmis.org>
    tracing: perf: Fix stale head for perf syscall tracing

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix union collision of module and refcnt for dynamic events

deepakraog <gaikwad.dcg@gmail.com>
    tracing: Fix resource leak on mmiotrace trace_pipe close

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev

Usama Arif <usama.arif@linux.dev>
    tracing: Fix context switch counter truncation

Steven Rostedt <rostedt@goodmis.org>
    tracing: Delay module ref count for "enable_event" trigger

Xu Rao <raoxu@uniontech.com>
    misc: nsm: pin the module while the device is open

Runyu Xiao <runyu.xiao@seu.edu.cn>
    misc: nsm: only unlock nsm_dev on post-lock error paths

Guangshuo Li <lgs201920130244@gmail.com>
    intel_th: fix MSC output device reference leak

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: access mei_device under device_lock on cleanup

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    selftests: ntsync: correct CONFIG_NTSYNC name

Jiangshan Yi <yijiangshan@kylinos.cn>
    serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: implement gpio get_direction() callback

Ben Hutchings <benh@debian.org>
    uio_hv_generic: Bind to FCopy device by default

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_parport: deal with premature interrupt

Nathan Chancellor <nathan@kernel.org>
    x86/boot/compressed: Disable jump tables

Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
    firmware: stratix10-svc: handle NO_RESPONSE in async poll

Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
    firmware: stratix10-svc: fix teardown order in remove to prevent race

Tze Yee Ng <tze.yee.ng@altera.com>
    firmware: stratix10-svc: fix memory leaks and list corruption bugs

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rhashtable: clear stale iter->p on table restart

Xu Rao <raoxu@uniontech.com>
    cdrom: fix stack out-of-bounds read in CDROMVOLCTRL

Rong Bao <rong.bao@csmantle.top>
    LoongArch: Retrieve CPU package ID from PPTT when available

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Move jump_label_init() before parse_early_param()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Increase TASK_STRUCT_OFFSET up to 2040 for 32BIT

Haoran Jiang <jianghaoran@kylinos.cn>
    LoongArch: Fix oops during single-step debugging

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build errors due to wrong instructions for 32BIT

George Guo <guodongtai@kylinos.cn>
    LoongArch: Fix address space mismatch in kexec command line lookup

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.99.0

Alexandre Courbot <acourbot@nvidia.com>
    rust: allow `clippy::unwrap_or_default` globally

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `suspicious_runtime_symbol_definitions` lint for Rust >= 1.98

Alice Ryhl <aliceryhl@google.com>
    rust: device: avoid trailing ; in printing macros

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: time: fix as_micros_ceil() to round correctly for negative Delta

Alice Ryhl <aliceryhl@google.com>
    rust_binder: only print failure if error has source

Zixing Liu <liushuyu@aosc.io>
    platform/loongarch: laptop: Explicitly reset bl_powered state when suspend

Christian Brauner <brauner@kernel.org>
    binfmt_misc: set have_execfd only once the interpreter is opened

Christian Brauner <brauner@kernel.org>
    exec: fix unsigned loop counter wrap in transfer_args_to_stack()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix session UAF in set_termios

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Protect UUID list traversal

MinJea Kim <qndkdrnl@gmail.com>
    staging: rtl8723bs: fix inverted HT40 secondary channel offset

Moksh Panicker <mokshpanicker.7@gmail.com>
    staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath12k: fix NULL pointer dereference in rhash table destroy

Wentao Liang <vulab@iscas.ac.cn>
    wifi: ath11k: fix refcount leak in ath11k_ahb_fw_resources_init()

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: make release_scratchbuffers idempotent

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: restrict NPU/PPE active checks to MMIO devices

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: drop TXRX_NOTIFY on non-mmio buses

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses

Huihui Huang <hhhuang@smu.edu.sg>
    wifi: wilc1000: validate assoc response length before subtracting header

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper

Daniel Hodges <git@danielhodges.dev>
    wifi: ath6kl: fix use-after-free in aggr_reset_state()

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB access from firmware ADDBA window size

Norbert Szetei <norbert@doyensec.com>
    ALSA: timer: don't re-enter an instance callback that is still running

Norbert Szetei <norbert@doyensec.com>
    ALSA: timer: drain a slave's callback before its master detaches it

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: codecs: hdmi: disable keep-alive before audio format change

Norbert Szetei <norbert@doyensec.com>
    ALSA: seq: close a re-opened queue timer in the destructor

Nikita Maksimov <nickstogramm@yandex.ru>
    ALSA: hda/realtek: Fix speakers on Lunnen Ground 14

Johan Hovold <johan@kernel.org>
    media: vpif_capture: fix OF node reference imbalance

Guangshuo Li <lgs201920130244@gmail.com>
    media: vivid: fix cleanup bugs in vivid_init()

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: check for vb2_is_busy() when toggling caps

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: add vivid_update_reduced_fps()

Guangshuo Li <lgs201920130244@gmail.com>
    media: vimc: fix reference leak on failed device registration

Guangshuo Li <lgs201920130244@gmail.com>
    media: vidtv: fix reference leak on failed device registration

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: verisilicon: Export only needed pixels formats

Zile Xiong <xiongzile99@gmail.com>
    media: vb2: use ssize_t for vb2_read/vb2_write

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-subdev: Fail {enable,disable}_streams and s_streaming nicely

Mirela Rabulea <mirela.rabulea@nxp.com>
    media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: v4l2-ctrls: validate HEVC active reference counts

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    media: v4l2-ctrls-request: add NULL check in v4l2_ctrl_request_complete()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: uapi: rkisp: Correct name version enum

Myeonghun Pak <mhun512@gmail.com>
    media: ti: vpe: unwind v4l2 device registration on probe error

Felix Gu <ustc.gu@gmail.com>
    media: ti: vpe: Fix the error code of devm_request_irq()

Felix Gu <ustc.gu@gmail.com>
    media: ti: vpe: Fix the error code of devm_kzalloc() in vip_probe_slice()

Felix Gu <ustc.gu@gmail.com>
    media: ti: vpe: Fix fwnode_handle leak in vip_probe_complete()

Hungyu Lin <dennylin0707@gmail.com>
    media: tegra-video: vi: fix invalid u32 return value in format lookup

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    media: synopsys: hdmirx: Fix HPD lane hold time

Valery Borovsky <vebohr@gmail.com>
    media: sun4i-csi: Return queued buffers on start_streaming() failure

Myeonghun Pak <mhun512@gmail.com>
    media: stm32: dcmi: unregister notifier on probe failure

Valery Borovsky <vebohr@gmail.com>
    media: stm32-dcmipp: Return queued buffers on start_streaming() failure

Ma Ke <make24@iscas.ac.cn>
    media: saa7134: Fix a possible memory leak in saa7134_video_init1

Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
    media: rzv2h-ivc: Wait for frame end in stop_streaming

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    media: rzg2l-cru: Skip ICnMC configuration when ICnSVC is used

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: Return queued buffers on start_streaming() failure

Deepanshu Kartikey <kartikey406@gmail.com>
    media: rtl2832: fix use-after-free in rtl2832_remove()

Myeonghun Pak <mhun512@gmail.com>
    media: radio-si476x: Unregister v4l2_device on probe failure

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix RDI streaming for CSID 340

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix RDI streaming for CSID GEN3

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix RDI streaming for CSID GEN2

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix RDI streaming for CSID 680

Valery Borovsky <vebohr@gmail.com>
    media: pwc: Return queued buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: pwc: Drain fill_buf on start_streaming() failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    media: pci: dm1105: Free allocated workqueue

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: Fix scale factor calculation for hardware rounding

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: Fix potential out-of-bounds issues

Xiaolei Wang <xiaolei.wang@windriver.com>
    media: nxp: imx8-isi: Fix missing v4l2_subdev_cleanup() in pipe init error path

Xiaolei Wang <xiaolei.wang@windriver.com>
    media: nxp: imx8-isi: Clean up already-initialized pipes on probe failure

Xiaolei Wang <xiaolei.wang@windriver.com>
    media: nxp: imx8-isi: Add missing v4l2_subdev_cleanup() in crossbar and pipe

David Carlier <devnexen@gmail.com>
    media: nuvoton: npcm-video: fix memory leaks in probe and remove

David Carlier <devnexen@gmail.com>
    media: nuvoton: npcm-video: fix error handling in npcm_video_init()

Valery Borovsky <vebohr@gmail.com>
    media: msi2500: Return queued buffers on start_streaming() failure

Anand Moon <linux.amoon@gmail.com>
    media: meson: vdec: Fix memory leak in error path of vdec_open

Guangshuo Li <lgs201920130244@gmail.com>
    media: marvell-cam: fix missing pci_disable_device() on remove

David Carlier <devnexen@gmail.com>
    media: mali-c55: Power-off the peripheral in remove()

Alper Ak <alperyasinak1@gmail.com>
    media: mali-c55: Fix possible ERR_PTR in enable_streams

David Carlier <devnexen@gmail.com>
    media: mali-c55: Disable pm_runtime on probe error

David Carlier <devnexen@gmail.com>
    media: mali-c55: Add missing of_reserved_mem_device_release()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: Fix use IRQF_NO_AUTOEN when requesting the IRQ

Marco Nenciarini <mnencia@kcore.it>
    media: intel/ipu6: Improve DWC PHY HSFREQRANGE band selection for overlapping ranges

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Martin Hecht <mhecht73@gmail.com>
    media: i2c: alvium: fix critical pointer access in alvium_ctrl_init

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: dw9719: Add back the I²C device id table

Wang Jun <1742789905@qq.com>
    media: cx23885: add ioremap return check and cleanup

Johan Hovold <johan@kernel.org>
    media: cx231xx: fix devres lifetime

Brandon Brnich <b-brnich@ti.com>
    media: chips-media: wave5: Move src_buf Removal to finish_encode

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cedrus: skip invalid H.264 reference list entries

Samuel Holland <samuel@sholland.org>
    media: cedrus: Fix missing cleanup in error path

Myeonghun Pak <mhun512@gmail.com>
    media: cedrus: clean up media device on probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: cec: seco: unregister adapter on IR probe failure

David Carlier <devnexen@gmail.com>
    media: aspeed: fix missing of_reserved_mem_device_release() on probe failure

Ricardo Ribalda <ribalda@chromium.org>
    media: amlogic-c3: Add validations for ae and awb config

Valery Borovsky <vebohr@gmail.com>
    media: airspy: Return queued buffers on start_streaming() failure

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Reach the GMP through the hub registers on V3D 7.x

Matthew Brost <matthew.brost@intel.com>
    drm/gpusvm: Fix MM reference leak in drm_gpusvm_range_evict

Stanislav Kinsburskii <skinsburskii@gmail.com>
    drm/gpusvm: Zero HMM PFNs before scanning ranges

Matthew Brost <matthew.brost@intel.com>
    drm/ttm/pool: back up at native page order

Matthew Brost <matthew.brost@intel.com>
    drm/pagemap: Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Prevent shader BO mappings from becoming writable

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate vmw_surface_metadata::array_size

Matthew Brost <matthew.brost@intel.com>
    drm/pagemap: Clear driver-provided PFNs from migration PFN array

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix missing DCE check in dm_gpureset_toggle_interrupts()

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Shut down BO cache timer before teardown

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix flip-done timeouts on mode1 reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: always emit the job vm fence

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Print vmid, pasid and more task info in devcoredump

Zhu Lingshan <lingshan.zhu@amd.com>
    drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Disable PCIe dynamic speed switching on Ryzen Pinnacle Ridge

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix backlight max_brightness to match exported range

Alessandro Rinaldi <ale@alerinaldi.it>
    drm/amd/display: Force PWM backlight on Lenovo Legion 5 15ARH05

Andriy Korud <a.korud@gmail.com>
    drm/amd/display: dce100: skip non-DP stream encoders for DP MST

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock

WenTao Liang <vulab@iscas.ac.cn>
    drm/amd/display: set new_stream to NULL after release

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Don't disable MCLK DPM on Bonaire 0x6658 (R7 260X)

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Create a device link between APU display and XHCI devices

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/userq: fix indefinite fence wait during GPU reset

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Fix VFCT bus number matching with soft filter

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Release VFCT ACPI table reference

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: return error on truncated firmware

Matthew Brost <matthew.brost@intel.com>
    drm/ttm: Account for NULL and handle pages in ttm_pool_backup

Honglei Huang <honghuan@amd.com>
    drm/gpusvm: publish dpagemap early to avoid device mapping leak on error

Jason Macnak <natsu@google.com>
    drm/virtio: Don't detach GEM from a non-created context

Alex Deucher <alexander.deucher@amd.com>
    drm/gfx10: Program DB_RING_CONTROL

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu14 power limit range calculation

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: limit DP MST ESI service loop

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gt: Fix NULL deref on sched_engine alloc failure

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Do not leak siblings[] on proto context error

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: trigger GPU recovery when userq destroy fails to unmap a hung queue

Shahyan Soltani <shahyan.soltani@amd.com>
    drm/amdgpu: fix lifetime issue of amdgpu_vm_get_task_info_pasid()

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: disable ASPM on VI if pcie dpm is disabled

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: replace BUG_ON() with WARN_ON()

Jakob Linke <jakob@linke.cx>
    drm/amdgpu/soc24: reset dGPU if suspend got aborted

Jani Nikula <jani.nikula@intel.com>
    drm/i915/bios: range check LFP Data Block panel_type2

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915: Return NULL on error in active_instance

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma7.0: replace BUG_ON() with WARN_ON()

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: add the doorbell index input for suspending userq

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vrr: require valid min/max vfreq for VRR

Bryam Vargas <hexlabsecurity@proton.me>
    drm/virtio: bound EDID block reads to the response buffer

Leo Li <sunpeng.li@amd.com>
    Revert "drm/amd/display: Restore 5s vbl offdelay for NV3x+ DGPUs"

WenTao Liang <vulab@iscas.ac.cn>
    drm/amd/display: detect_link_and_local_sink: DP alt mode timeout path leaks prev_sink reference

Honglei Huang <honghuan@amd.com>
    drm/amd/display: use kvzalloc to allocate struct dc

Thomas Zimmermann <tzimmermann@suse.de>
    drm/amd/display: Handle struct drm_plane_state.ignore_damage_clips

Leorize <leorize+oss@disroot.org>
    drm/amd/display: set MSA MISC1 bit 6 when using VSC SDP for DCE 11.x

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdkfd: free MQD managers on DQM init failures

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix 32-bit overflow in CWSR total size calculation

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on CRIU restore queue type and mqd size

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds in allocate_event_notification_slot

David Francis <David.Francis@amd.com>
    drm/amdkfd: Use kvcalloc to allocate arrays

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: clamp v9 CRIU control stack checkpoint copy to BO size

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm/imagination: acquire vm_ctx->lock before mapping memory to GPU VM

Luigi Santivetti <luigi.santivetti@imgtec.com>
    drm/imagination: fix error checking of pvr_vm_context_lookup()

Shuvam Pandey <shuvampandey1@gmail.com>
    drm/imagination: Fix user array stride in pvr_set_uobj_array()

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix double call to drm_sched_entity_fini()

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe/madvise: Skip invalidation for purgeable state updates

Alexander Usyskin <alexander.usyskin@intel.com>
    drm/xe/nvm: fix writable override for CRI

Zongyao Bai <zongyao.bai@intel.com>
    drm/xe/pt: Reset current_op in xe_pt_update_ops_init()

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe: Hold a dma-buf reference for imported BOs

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Fix PTE index in xe_vm_populate_pgtable() for chunked binds

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/rtp: Add RING_FORCE_TO_NONPRIV_DENY to OA whitelists

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Fix offset alignment for MERT WHITELIST_OA_MERT_MMIO_TRG

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Return error on non-migratable faults requiring devmem

Matthew Auld <matthew.auld@intel.com>
    drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs

Pavel Ondračka <pavel.ondracka@gmail.com>
    drm/radeon: fix r100_copy_blit for large BOs

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()

Imre Deak <imre.deak@intel.com>
    drm/i915/mtl+: Enable PPS before PLL

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Add missing nospec on parallel submit slot

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: fix Tiled Display Topology ID size

Gerhard Schwanzer <geschw@pm.me>
    drm/amdkfd: Use exclusive bounds for SVM split alignment checks

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Return errno code from drm_sysfb_get_visible_size()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Avoid possible truncation with calculating visible size

Junrui Luo <moonafterrain@outlook.com>
    drm/nouveau: fix reversed error cleanup order in ucopy functions

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: validate CP_GFX_SHADOW chunk size in CS pass1

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Fix context pstate override handling

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT

Jiqian Chen <Jiqian.Chen@amd.com>
    drm/amdgpu/gfx9: Fix Ring and IB test fail after mode2

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Restore periodic detection for DCN35

Brian Nguyen <brian3.nguyen@intel.com>
    drm/xe: Add compact-PT and addr mask handling for page reclaim

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe/guc: Fix buffer overflow in steered register list allocation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Avoid truncating maximum stride

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Do not page-align visible size of the framebuffer

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: check amdgpu_vm_bo_find() result in GET_MAPPING_INFO

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd: Place VCPU BO only in VRAM for UVD 4.x and older

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd: Fix forcing MSG, FB BOs into VCPU segment when it isn't at 0 (v2)

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/gfx: fix cleaner shader IB buffer overflow

Shubhankar Milind Sardeshpande <Shubhankar.MilindSardeshpande@amd.com>
    drm/amd/pm: re-enable MC access after PrepareMp1ForUnload on SMU V15 APUs

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Fix up CDCLK_FREQ_DECIMAL without a full PLL re-enable

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Fit paired fragment job in the correct CCCB

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix buffer overflows in sideband chunk accumulation

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers

Thomas Zimmermann <tzimmermann@suse.de>
    drm/exynos: fbdev: Remove offset into screen_buffer

Vitor Soares <vitor.soares@toradex.com>
    drm/bridge: cdns-dsi: Replace deprecated UNIVERSAL_DEV_PM_OPS()

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Count paired job fence as dependency in prepare_job()

Chen Ni <nichen@iscas.ac.cn>
    drm/rockchip: analogix_dp: Add missing error check for platform_get_resource()

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Fix missing drm_bridge_add() call

Biju Das <biju.das.jz@bp.renesas.com>
    drm: renesas: rzg2l_mipi_dsi: Move rzg2l_mipi_dsi_set_display_timing()

Biju Das <biju.das.jz@bp.renesas.com>
    drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay

David Carlier <devnexen@gmail.com>
    tracing: Fix use-after-free freeing trigger private data

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()

Pu Lehui <pulehui@huawei.com>
    LoongArch: BPF: Fix memory leak in bpf_jit_free()

Mateusz Guzik <mjguzik@gmail.com>
    pidfs: make pidfs_ino_lock static

Eric Dumazet <edumazet@google.com>
    drop_monitor: perform u64_stats updates under IRQ-disabled section

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix size calculations for 64-bit attributes

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge/bng_re: fix ring ID widths

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: fix ETS channel derivation in airoha_tc_setup_qdisc_ets()

Minhong He <heminhong@kylinos.cn>
    mctp: check register_netdevice_notifier() error in mctp_device_init()

Clark Wang <xiaoning.wang@nxp.com>
    ptp: netc: explicitly clear TMR_OFF during initialization

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rds: tcp: unregister sysctl before tearing down listen socket

Nikola Z. Ivanov <zlatistiv@gmail.com>
    ipv6: Change allocation flags to match rcu_read_lock section requirements

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix max_vport related crash on allocation error during init

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: prevent tstamp ring allocation for non-PF VSI types

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: fix LAG recipe to profile association

Vincent Chen <vincent.chen@sifive.com>
    ice: allow creating VFs when !CONFIG_ICE_SWITCHDEV

Li RongQing <lirongqing@baidu.com>
    net: ipv6: fix dif and sdif mismatch in raw6_icmp_error

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: tc: fix egress ratelimiting

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Report zero bandwidth for non-ETS traffic classes

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix MCIA register buffer overflow on 32 dword reads

Runyu Xiao <runyu.xiao@seu.edu.cn>
    raw: annotate lockless match fields in raw_v4_match()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net: qrtr: restrict socket creation to the initial network namespace

Nicholas Dudar <main.kalliope@gmail.com>
    LoongArch: BPF: Zero-extend signed ALU32 div/mod results

Chenguang Zhao <zhaochenguang@kylinos.cn>
    hinic: remove unused ethtool RSS user configuration buffers

Eric Dumazet <edumazet@google.com>
    ppp: annotate data races in ppp_generic

Eric Dumazet <edumazet@google.com>
    ipv4: icmp: fill flow parameters in icmp_route_lookup decoy lookup

Suman Ghosh <sumang@marvell.com>
    octeontx2-vf: set TC flower flag on MCAM entry allocation

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Set rt->rt_nhn just before returning from mpls_nh_build_multi().

Yun Zhou <yun.zhou@windriver.com>
    net: gre: fix lltx regression for GRE tunnels with SEQ/CSUM

vadik likholetov <vadikas@gmail.com>
    net: stmmac: enable the MAC on link up for all supported speeds

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: reset residual action in L3L4 filters on delete

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: fix l3l4 filter rejecting unsupported offload requests

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: xgmac: fix l4 filter port overwrite on register update

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bpf: tcp: fix double sock release on batch realloc

José Expósito <jose.exposito@redhat.com>
    drm/tests: shmem: Set DMA mask to 64-bit in drm_gem_shmem

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix u16 MTU truncation in media and bearer MTU validation

Zhang Yi <yi.zhang@huawei.com>
    iomap: fix incorrect did_zero setting in iomap_zero_iter()

Zhang Yi <yi.zhang@huawei.com>
    iomap: correct the range of a partial dirty clear

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/vm: Fix SVM leak on resv obj alloc failure in xe_vm_create()

Raag Jadav <raag.jadav@intel.com>
    drm/xe/i2c: Allow per domain unique id

Harshaka Narayana <harshaka.narayana@broadcom.com>
    vmxnet3: fix BUG_ON in vmxnet3_get_hdr_len() for Geneve packets

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: verify auth requirement when auth_chunk is NULL

Luis Lang <luis.la@mail.de>
    net: stmmac: dwmac4: mask interrupts when stopping DMA in suspend

Michael Walle <mwalle@kernel.org>
    net: dpaa: fix mode setting

Chuyi Zhou <zhouchuyi@bytedance.com>
    smp: Make CSD lock acquisition atomic for debug mode

Chuyi Zhou <zhouchuyi@bytedance.com>
    smp: Avoid invalid per-CPU CSD lookup with CSD lock debug

Eric Dumazet <edumazet@google.com>
    net: hsr: fix memory leak on slave unregistration by removing synced VLANs

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix vlan range dumps starting with pvid

Michael Bommarito <michael.bommarito@gmail.com>
    amt: make the head writable before rewriting the L2 header

Michael Bommarito <michael.bommarito@gmail.com>
    amt: re-read skb header pointers after every pull

Amir Goldstein <amir73il@gmail.com>
    ovl: check access to copy_file_range source with src mounter creds

Gregor Herburger <gregor.herburger@linutronix.de>
    drm/vc4: hvs/v3d: Fix null dereference in unbind

Julian Braha <julianbraha@gmail.com>
    drm/panel: fix unmet dependency bug for DRM_PANEL_HIMAX_HX83121A

Julian Braha <julianbraha@gmail.com>
    drm/panel: s6e3ha8: fix unmet dependency on DRM_DISPLAY_HELPER

Julian Braha <julianbraha@gmail.com>
    drm/panel: ilitek-ili9882t: fix unmet dependency for DRM_PANEL_ILITEK_ILI9882T

Yichong Chen <chenyichong@uniontech.com>
    ovl: fix trusted xattr escape prefix matching

Shelley Yang <shelley.yang@infineon.com>
    wifi: brcmfmac: fix 802.1X-SHA256 call trace warning

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/vf: Add drm_dev guards when detaching CCS read/write buffers

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: fix crash in reset link replay

Arnd Bergmann <arnd@arndb.de>
    wifi: mt76: fix airoha_npu dependency tracking

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()

Ruoyu Wang <ruoyuw560@gmail.com>
    wifi: mt76: mt7915: guard HE capability lookups

Guangshuo Li <lgs201920130244@gmail.com>
    wifi: mt76: mt7925: guard link STA in decap offload

Eric Dumazet <edumazet@google.com>
    ppp: annotate concurrent dev->stats accesses

Frank Sorenson <sorenson@redhat.com>
    cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths

Frank Sorenson <sorenson@redhat.com>
    cifs: prevent readdir from changing file size due to stale directory metadata

Helen Koike <koike@igalia.com>
    tipc: fix infinite loop in __tipc_nl_compat_dumpit

Xiang Mei (Microsoft) <xmei5@asu.edu>
    nexthop: initialize extack in nh_res_bucket_migrate()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    gtp: check skb_pull_data() return in gtp1u_send_echo_resp()

Willem de Bruijn <willemb@google.com>
    selftests: drv-net: convert so_txtime to drv-net

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: drv-net: increase timeout

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: ovpn: increase timeout

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: ovpn: add IPV6 and VETH configs

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: openvswitch: add config file

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: af_unix: add USER_NS config

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: device: push pending open record on splice EOF

Myeonghun Pak <mhun512@gmail.com>
    net: mctp i3c: clean up notifier and buses if driver register fails

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    sctp: validate stream count in sctp_process_strreset_inreq()

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Handle U85 internal chaining buffer

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Fix element size accounting for cmd stream validation

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: check for workqueue allocation failure

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix auxiliary device add/del races

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: order completion reads after the ownership check

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: yield the CPU while waiting for the adminq to drain

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix use-after-free on workqueue during remove

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix deadlock between reset thread and remove

HanQuan <eilaimemedsnaimel@gmail.com>
    sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: txgbe: fix FDIR filter leak on remove

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: txgbe: fix heap overflow when reading module EEPROM

Weiming Shi <bestswngs@gmail.com>
    tipc: serialize udp bearer replicast list updates

Antoine Tenart <atenart@kernel.org>
    geneve: ensure the skb is writable before fixing its headers

Antoine Tenart <atenart@kernel.org>
    geneve: fix hint header definition wrt endianness

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call net_enable_timestamp() before failure in sk_clone().

Kuniyuki Iwashima <kuniyu@google.com>
    soreuseport: Clear sk_reuseport_cb before failure in sk_clone().

Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>
    amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN

Richard Cheng <icheng@nvidia.com>
    arm64/mm: Check the requested PFN range during memory removal

Steven Price <steven.price@arm.com>
    arm64: Correct value returned by ESR_ELx_FSC_ADDRSZ_nL()

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: reject component parameter in legacy firmware update

Andrew Pope <andrew.pope@morsemicro.com>
    wifi: mac80211: recalculate TIM when a station enters power save

Li RongQing <lirongqing@baidu.com>
    iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iommu/amd: Bound the early ACPI HID map

HE WEI (ギカク) <skyexpoc@gmail.com>
    wifi: mwifiex: bound uAP association event IEs to the event buffer

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: copy aggregation information

Enrico Zanda <enrico.zanda@arm.com>
    vhost-net: fix TX stall when vhost owns virtio-net header

Ruoyu Wang <ruoyuw560@gmail.com>
    wan: wanxl: Only reset hardware after BAR mapping

Ruoyu Wang <ruoyuw560@gmail.com>
    nfp: Check resource mutex allocation

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: tear down new links on vif update error path

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/amd: Wait for completion instead of returning early in iommu_completion_wait()

Wayen Yan <win847@gmail.com>
    net: airoha: Fix DMA direction for NPU mailbox buffer

Guangshuo Li <lgs201920130244@gmail.com>
    dpaa2-eth: put MAC endpoint device on disconnect

Wayen Yan <win847@gmail.com>
    net: airoha: Fix potential use-after-free in airoha_ppe_deinit()

Guangshuo Li <lgs201920130244@gmail.com>
    dpaa2-switch: put MAC endpoint device on disconnect

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    rxrpc: fix io_thread race in rxrpc_wake_up_io_thread()

Zhixing Chen <running910@gmail.com>
    gtp: parse extension headers before reading inner protocol

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    rds: drop incoming messages that cross network namespace boundaries

Zhaolong Zhang <zhangzl68@chinatelecom.cn>
    bonding: fix devconf_all NULL dereference when IPv6 is disabled

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject redirect helpers without a bpf_net_context

David Lee <david.lee@trailofbits.com>
    net/packet: avoid fanout hook re-registration after unregister

Danielle Ratson <danieller@nvidia.com>
    netlink: specs: rt-link: convert bridge port flag attributes to u8

Ricardo B. Marlière <rbm@suse.com>
    selftests/net: Fix tun IPv6 test addresses to avoid 6to4 range

Michael Walle <mwalle@kernel.org>
    net: phy: marvell: fix return code

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: btusb: validate Realtek vendor event length

Daniel Golle <daniel@makrotopia.org>
    regulator: mt6358: use regmap helper to read fixed LDO calibration

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: occ: validate poll response sensor blocks

Marco Baffo <marco@mandelbit.com>
    ovpn: use monotonic clock for peer keepalive timeouts

Marco Baffo <marco@mandelbit.com>
    ovpn: fix use after free in unlock_ovpn()

longlong yan <yanlonglong@kylinos.cn>
    selftests/net: ovpn: fix getaddrinfo memory leak in ovpn_parse_remote()

Qing Ming <a0yami@mailbox.org>
    ovpn: avoid putting unrelated P2P peer on socket release

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/backlight: Remove DP_EDP_BACKLIGHT_AUX_ENABLE_CAP check for DPCD backlight

Yichong Chen <chenyichong@uniontech.com>
    smb: client: validate DFS referral PathConsumed

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) add missed handle for ENOMEM

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix EC read intervals

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix looping over banks while reading from EC

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) block unsupported VIN and IIN limit registers

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440): add support adpm12250

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    hwmon: Use named initializers for arrays of i2c_device_data

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    hwmon: Drop unused i2c driver_data

Mostafa Saleh <smostafa@google.com>
    drivers/virt: pkvm: Fix end calculation in mmio_guard_ioremap_hook()

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect

Shahar Tzarfati <shahar.tzarfati@intel.com>
    wifi: iwlwifi: mvm: fix read in wake packet notification handler

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: validate payload length in iwl_pnvm_complete_fn

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: mvm: validate SAR GEO response payload size

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Use complete_all() to signal init_completion

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix potential probe() deadlock

Guangshuo Li <lgs201920130244@gmail.com>
    arm_mpam: guard MBWU state before adding it to garbage

Fenghua Yu <fenghuay@nvidia.com>
    arm_mpam: Fix MPAMCFG_MBW_PBM register setting

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Fix software reset values of MPAMCFG_PRI

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI

Guangshuo Li <lgs201920130244@gmail.com>
    ALSA: hda: cs35l41: validate and free ACPI mute object

Tycho Andersen (AMD) <tycho@kernel.org>
    iommu/amd: Fix nested domain leak

Tycho Andersen (AMD) <tycho@kernel.org>
    iommu/amd: Fix IRQ unsafe locking in gdom allocation

Chen-Yu Tsai <wens@kernel.org>
    ASoC: sun4i-codec: Set quirks.playback_only for H616 codec

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: tas2781: bound firmware description string parsing

Guanghui Yang <3497809730@qq.com>
    btrfs: free mapping node on duplicate reloc root insert

Leo Martins <loemra.dev@gmail.com>
    btrfs: don't propagate EXTENT_FLAG_LOGGING to split extent maps

Dave Chen <davechen@synology.com>
    btrfs: fix u32 to s64 type conversion in dirty_metadata_bytes accounting

You-Kai Zheng <ykzheng@synology.com>
    btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: fix buffer overflow in rx_stream failover path

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: fix OOB read from off-by-two in TX status handler

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB read from firmware IE lengths in connect event

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler

Yingying Tang <yingying.tang@oss.qualcomm.com>
    wifi: ath12k: Fix low MLO RX throughput on WCN7850

Ruoyu Wang <ruoyuw560@gmail.com>
    firewire: net: Fix fragmented datagram reassembly

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: temporarily revert to setting a charge limit

Yousef Alhouseen <alhouseenyousef@gmail.com>
    platform/x86/intel/vsec: free ACPI discovery data on early errors

Rosen Penev <rosenp@gmail.com>
    platform/x86/intel/vsec: allocate res with intel_vsec_dev

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    wifi: ath12k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()

Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
    wifi: ath10k: fix skb leak on incomplete msdu during rx pop

Wayen Yan <win847@gmail.com>
    watchdog: airoha: Prevent division by zero when clock frequency is zero

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-kraken3) Stop device IO before calling hid_hw_stop

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop

Guenter Roeck <linux@roeck-us.net>
    hwmon: (gigabyte_waterforce) Stop device IO before calling hid_hw_stop

Guenter Roeck <linux@roeck-us.net>
    hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop

Edward Adam Davis <eadavis@qq.com>
    hwmon: (corsair-psu) Stop device IO before calling hid_hw_stop

Gaole Zhang <gaole.zhang@oss.qualcomm.com>
    wifi: ath11k: fix NULL pointer dereference in ath11k_hal_srng_access_begin

Cheng Yongkang <teel4res@gmail.com>
    wifi: ath9k: hif_usb: don't dereference hif_dev after re-arming firmware request

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    watchdog: ni903x_wdt: Check ACPI_COMPANION() against NULL

Daniel Borkmann <daniel@iogearbox.net>
    selftests/bpf: Keep verifier_map_ptr exercising ops pointer access

KP Singh <kpsingh@kernel.org>
    selftests/bpf: Adjust verifier_map_ptr for the map's excl field

Xincheng Zhang <zhangxincheng@ultrarisc.com>
    usb: xhci-pci: Limit VIA VL805 DMA addressing to 36 bits

Sasha Levin <sashal@kernel.org>
    Revert "drm/amd/display: Add missing kdoc for ALLM parameters"

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Serialize virtual interrupt pending state updates

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add dp_skip_rbr flag for NUTMEG

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix preferred link rate for NUTMEG

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Fix ISM dc_lock deadlock during suspend

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    usb: typec: ucsi: Add duplicate detection to nvidia registration path

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    usb: typec: ucsi: Detect and skip duplicate altmodes from buggy firmware

Chukun Pan <amadeus@jmu.edu.cn>
    USB: serial: option: add TDTECH MT5710-CN

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix data loss on receive throttling

Sunho Park <shpark061104@gmail.com>
    USB: serial: io_edgeport: cap received transmit credits

Tim Pambor <timpambor@gmail.com>
    USB: serial: ftdi_sio: add support for E+H FXA291

Muhammad Bilal <meatuni001@gmail.com>
    usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_ncm: validate datagram bounds in ncm_unwrap_ntb()

Johan Hovold <johan@kernel.org>
    USB: gadget: fsl-udc: fix dev_printk() device

Johan Hovold <johan@kernel.org>
    USB: gadget: fsl-udc: fix device name leak on probe failure

Johan Hovold <johan@kernel.org>
    USB: gadget: snps-udc: fix device name leak on probe failure

Melbin K Mathew <mlbnkm1@gmail.com>
    usb: gadget: printer: fix infinite loop in printer_read()

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: f_midi: cancel pending IN work before freeing the midi object

Jinchao Wang <wangjinchao600@gmail.com>
    usb: gadget: dummy_hcd: prevent fifo_req reuse during giveback

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: fix usage_count leak when autosuspend_delay is negative

Huang Wei <huangwei@kylinos.cn>
    USB: storage: add NO_ATA_1X quirk for Longmai USB Key

Guangshuo Li <lgs201920130244@gmail.com>
    usb: musb: omap2430: Do not put borrowed of_node in probe

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    usb: core: port: Deattach Type-C connector on component unbind

Huihui Huang <hhhuang@smu.edu.sg>
    wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: core: sysfs: add lock to bos_descriptors_read()

Weiming Shi <bestswngs@gmail.com>
    mpls: fix NULL deref in mpls_valid_fib_dump_req() on CONFIG_INET=n

Andre Carvalho <asantostc@gmail.com>
    selftests: netconsole: only restore MAC when it changed on resume

Ruoyu Wang <ruoyuw560@gmail.com>
    bnxt_en: Handle partially initialized auxiliary devices

Xin Long <lucien.xin@gmail.com>
    sctp: fix auth_hmacs array size in struct sctp_cookie

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_tunnel_key: Defer dst_release to RCU callback

Ivan Vecera <ivecera@redhat.com>
    dpll: fix NULL pointer dereference in dpll_msg_add_pin_ref_sync()

Eric Dumazet <edumazet@google.com>
    tcp: fix TIME_WAIT socket reference leak on PSP policy failure

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix use-after-free of mm_struct in job scheduler

Emre Cecanpunar <emreleno@gmail.com>
    drm/i915/selftests: Fix GT PM sort comparators

Vinod Govindapillai <vinod.govindapillai@intel.com>
    drm/i915/wm: clear the plane ddb_y entries on plane disable

Xiang Mei (Microsoft) <xmei5@asu.edu>
    ksmbd: validate compound request size before reading StructureSize2

Qihang <q.h.hack.winter@gmail.com>
    ksmbd: pin conn during async oplock break notification

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe/guc: Hold device ref until queue teardown completes

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe/guc: Keep scheduler timeline name alive

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/xe: Assign queue name in time for drm_sched_init

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/wopcm: fix WOPCM size for LNL+

Matthew Brost <matthew.brost@intel.com>
    drm/xe/vf: Fix VF CCS attach/detach race with in-flight BO moves

Shuhao Fu <sfual@cse.ust.hk>
    can: j1939: fix lockless local-destination check

Mark Harris <mark.hsj@gmail.com>
    riscv: hwprobe: Avoid uninitialized read in hwprobe_get_cpus()

Vasily Gorbik <gor@linux.ibm.com>
    s390/checksum: Fix csum_partial() without vector facility

Linmao Li <lilinmao@kylinos.cn>
    drm/panthor: Check debugfs GEM lock initialization

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Reject unhashed UDP sockets on sockmap update

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/vtime: Initialize starttime at boot for native accounting

Frederic Weisbecker <frederic@kernel.org>
    powerpc/time: Prepare to stop elapsing in dynticks-idle

Rosen Penev <rosenp@gmail.com>
    powerpc/85xx: Add fsl,ifc to common device ids

Srikanth Boyapally <srikanth.boyapally@amd.com>
    spi: cadence-quadspi: Fix indirect write timeout when DMA read mode is enabled

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw: add locking for raw flags bitfield

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/i915/gt: use correct selftest config symbol

Rui Qi <qirui.001@bytedance.com>
    riscv: Gate FUNCTION_ALIGNMENT_4B on DYNAMIC_FTRACE

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: handle overlapping allocated ranges in fallocate

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: mgmt: Translate HCI reason in Device Disconnected event

Ruoyu Wang <ruoyuw560@gmail.com>
    Bluetooth: hci_qca: Clear memdump state on invalid dump size

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold hdev->lock for hci_conn_params lookups

Pauli Virtanen <pav@iki.fi>
    Bluetooth: mgmt: hold reference for hci_conn in mgmt_pending_cmds

Pauli Virtanen <pav@iki.fi>
    Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: extend conn_hash lookup critical sections

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: MGMT: revalidate LOAD_CONN_PARAM queued update

Xiang Mei <xmei5@asu.edu>
    Bluetooth: qca: fix NVM tag length underflow in TLV parser

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Skip DSD quirk for Musical Fidelity M6s DAC

Karol Wachowski <karol.wachowski@linux.intel.com>
    accel/ivpu: Fix wrong register read in LNL failure diagnostics

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: use platform_get_irq()

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered

David Jeffery <djeffery@redhat.com>
    scsi: core: wake eh reliably when using scsi_schedule_eh

Robert Mader <robert.mader@collabora.com>
    udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: take a reference on the socket found in afiucv_hs_rcv()

Weiming Shi <bestswngs@gmail.com>
    ipv4: fib: free fib_alias with kfree_rcu() on insert error path

Norbert Szetei <norbert@doyensec.com>
    ppp: defer channel free to an RCU grace period to fix pppol2tp RX UAF

Tejun Heo <tj@kernel.org>
    sched_ext: Record an error on errno-only sub-enable failure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Make cpufreq_update_pressure() fall back to cpuinfo.max_freq

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Fix UAF in sock clone early bailouts

Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>
    firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context

Uday Khare <udaykhare77@gmail.com>
    ASoC: tas2562: fix deprecated 'shut-down' GPIO always cleared after lookup

Andrea Righi <arighi@nvidia.com>
    sched_ext: Enable tick for finite slices on nohz_full

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Correct report for forced microphone jack

Gao Xiang <xiang@kernel.org>
    erofs: relax sanity check for tail pclusters due to ztailpacking

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: replace bitwise OR with logical OR in IRQ return check

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: disable MSI on resume in ACP PCI driver

Christian Hewitt <christianshewitt@gmail.com>
    ASoC: meson: aiu: fifo-spdif: soft reset the S/PDIF datapath on start/stop

Sebastian Ene <sebastianene@google.com>
    firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset calculation

Mostafa Saleh <smostafa@google.com>
    firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()

HE WEI (ギカク) <skyexpoc@gmail.com>
    wifi: cfg80211: bound element ID read when checking non-inheritance

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: brcmfmac: initialize SDIO data work before cleanup

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: use wiphy work for socket owner autodisconnect

Cen Zhang <zzzccc427@gmail.com>
    wifi: mac80211: free AP_VLAN bc_buf SKBs outside IRQ lock

Syed Saba Kareem <Syed.SabaKareem@amd.com>
    ASoC: amd: acp: Fix linker error with SDCA quirks

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: avoid non-S1G AID fallback for S1G assoc

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: reject empty PMSR peer lists

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: reject unsupported PMSR FTM location requests

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate PMSR FTM preamble range

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate PMSR measurement type data

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: constrain MBSSID TX link ID range

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: validate nested MBSSID IE blobs

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: derive S1G beacon TSF from S1G fields

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: free RNR data on MBSSID mismatch

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock

Xiang Mei <xmei5@asu.edu>
    wifi: p54: validate RX frame length in p54_rx_eeprom_readback()

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: mac80211: defer link RX stats percpu free to RCU

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: libertas: fix memory leak in helper_firmware_cb()

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix fils_discovery double free on alloc failure

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix unsol_bcast_probe_resp double free on alloc failure

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mac80211_hwsim: clamp virtio RX length before skb_put

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: cfg80211: Fix an error handling path in cfg80211_wext_siwscan()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: cancel sched scan results work on unregister

Rong Zhang <i@rong.moe>
    ALSA: usb-audio: Fix imbalance per-channel volume of sticky mixers

Arnd Bergmann <arnd@arndb.de>
    wifi: mac80211: allocate backup ieee80211_nan_sched_cfg off stack

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: policy: preallocate inexact bins before xfrm_hash_rebuild reinsert

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm6: clear dst.dev on error to avoid double netdev_put in xfrm6_fill_dst()

Chen YanJun <moomichen@tencent.com>
    xfrm: iptfs: propagate SKBFL_SHARED_FRAG in iptfs_skb_add_frags()

Cen Zhang <zzzccc427@gmail.com>
    xfrm: clear mode callbacks after failed mode setup

Aleksandrova Alyona <aga@itb.spb.ru>
    RDMA/irdma: Prevent overflows in memory contiguity checks

Malaya Kumar Rout <malayarout91@gmail.com>
    selftests/alsa: Fix memory leak in find_controls error path

Xue Lei <Xue.Lei@windriver.com>
    mtd: fix double free and WARN_ON in add_mtd_device() error paths

Ruoyu Wang <ruoyuw560@gmail.com>
    RDMA/siw: publish QP after initialization

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hns: Fix potential integer overflow in mhop hem cleanup

Chenguang Zhao <zhaochenguang@kylinos.cn>
    RDMA/core: Fix memory leak in __ib_create_cq() on invalid cqe

Ruoyu Wang <ruoyuw560@gmail.com>
    RDMA/mana_ib: initialize err for empty send WR lists

Ruoyu Wang <ruoyuw560@gmail.com>
    RDMA/erdma: initialize ret for empty receive WR lists

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Prevent user-triggered null deref on QP create

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Remove redundant legacy_mode checks

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Prevent rereg_mr for non-mem regions

Or Gerlitz <ogerlitz@ddn.com>
    RDMA/cma: Fix hardware address comparison length in netevent callback

Antony Antony <antony.antony@secunet.com>
    xfrm: reject optional IPTFS templates in outbound policies

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Yixun Lan <dlan@kernel.org>
    reset: spacemit: k3: fix USB2 ahb reset

Tejun Heo <tj@kernel.org>
    sched_ext: Don't warn on core-sched forced idle in put_prev_task_scx()

Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
    firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()

Boris Burkov <boris@bur.io>
    btrfs: fallback to transaction csum tree on a commit root csum miss

Filipe Manana <fdmanana@suse.com>
    btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()

Xiang Mei <xmei5@asu.edu>
    btrfs: reject free space cache with more entries than pages

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: mtk-ecc: stop on ECC idle timeouts

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: mtdswap: remove debugfs stats file on teardown

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    mtd: virt_concat: fix use-after-free in mtd_virt_concat_destroy()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    mtd: virt_concat: fix use-after-free in mtd_virt_concat_destroy_joins()

Michael Bommarito <michael.bommarito@gmail.com>
    IB/mad: Drop unmatched RMPP responses before reassembly

Seth Forshee <sforshee@nvidia.com>
    firmware: arm_ffa: Respect firmware advertised RX/TX buffer size limits

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: fix stale skb->prev after async crypto steals a GSO segment

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: propagate -EINPROGRESS from validate_xmit_xfrm()

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234

Tejun Heo <tj@kernel.org>
    sched_ext: Annotate ksyncs with __rcu in alloc/free_kick_syncs()

Doehyun Baek <doehyunbaek@gmail.com>
    Docs/admin-guide/cgroup-v2: fix memory.stat doc details

Akhil R <akhilrajeev@nvidia.com>
    arm64: tegra: Remove fallback compatible for GPCDMA

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Clear receive-side ownership pointers on release

Mikko Perttunen <mperttunen@nvidia.com>
    crypto: tegra - Don't touch bo refcount in host1x bo pin/unpin

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings

Phil Rosenthal <phil@phil.gs>
    KVM: x86/mmu: Fix use-after-free on vendor module reload

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: nVMX: Hide shadow VMCS right after VMCLEAR

Venkatesh Srinivas <venkateshs@chromium.org>
    KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN

Sean Christopherson <seanjc@google.com>
    KVM: x86: Check for invalid/obsolete root *after* making MMU pages available

Heiko Carstens <hca@linux.ibm.com>
    seqlock: Allow UBSAN_ALIGNMENT to fail optimizing

Ryosuke Yasuoka <ryasuoka@redhat.com>
    drm/virtio: fix deadlock in display_info_cb by removing hotplug from dequeue worker

Kuba Piecuch <jpiecuch@google.com>
    sched_ext: Skip ops.set_weight() for disabled tasks

Guixiong Wei <weiguixiong@bytedance.com>
    platform/x86/intel-uncore-freq: Fix current_freq_khz after CPU hotplug


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v2.rst            |   4 +-
 Documentation/hwmon/max34440.rst                   |  27 +-
 Documentation/netlink/specs/rt-link.yaml           |  40 +-
 Makefile                                           |   9 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |  24 +-
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |   2 +-
 arch/arm64/include/asm/esr.h                       |   2 +-
 arch/arm64/mm/hugetlbpage.c                        |   2 +-
 arch/arm64/mm/mmu.c                                |   7 +-
 arch/loongarch/include/asm/asmmacro.h              |   2 +-
 arch/loongarch/kernel/acpi.c                       |  27 +-
 arch/loongarch/kernel/kgdb.c                       |   3 +-
 arch/loongarch/kernel/machine_kexec.c              |   5 +-
 arch/loongarch/kernel/rethook_trampoline.S         |  18 +-
 arch/loongarch/kernel/setup.c                      |   3 +-
 arch/loongarch/kernel/smp.c                        |   4 +-
 arch/loongarch/mm/init.c                           |   5 +-
 arch/loongarch/net/bpf_jit.c                       |   9 +-
 arch/m68k/include/asm/page_mm.h                    |   2 +
 arch/powerpc/kernel/time.c                         |  43 +++
 arch/powerpc/mm/mem.c                              |   5 +-
 arch/powerpc/platforms/85xx/common.c               |   2 +
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/include/asm/kvm_host.h                  |  10 +-
 arch/riscv/kernel/sys_hwprobe.c                    |   1 +
 arch/riscv/kvm/aia.c                               |  35 +-
 arch/riscv/kvm/vcpu.c                              |  68 +++-
 arch/riscv/kvm/vcpu_onereg.c                       |   8 +-
 arch/riscv/mm/init.c                               |   5 +-
 arch/s390/lib/csum-partial.c                       |   2 +-
 arch/s390/mm/init.c                                |   5 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  11 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  10 +-
 arch/x86/kvm/svm/svm.c                             |   7 +-
 arch/x86/kvm/vmx/nested.c                          |  11 +-
 arch/x86/mm/init_64.c                              |   5 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |   4 +
 drivers/accel/ethosu/ethosu_gem.c                  |  54 ++-
 drivers/accel/ivpu/ivpu_hw_btrs.c                  |   2 +-
 drivers/android/binder/thread.rs                   |  14 +-
 drivers/ata/sata_dwc_460ex.c                       |  38 +-
 drivers/block/rbd.c                                |   7 +-
 drivers/block/ublk_drv.c                           |  47 ++-
 drivers/bluetooth/btqca.c                          |   2 +-
 drivers/bluetooth/btusb.c                          |   4 +-
 drivers/bluetooth/hci_qca.c                        |   4 +
 drivers/cdrom/cdrom.c                              |   1 +
 drivers/comedi/drivers/comedi_parport.c            |  13 +-
 drivers/cpufreq/cpufreq.c                          |   3 +
 drivers/crypto/tegra/tegra-se-main.c               |   3 +-
 drivers/dma-buf/udmabuf.c                          |   9 +-
 drivers/dpll/dpll_netlink.c                        |   3 +
 drivers/firewire/net.c                             |  37 +-
 drivers/firmware/arm_ffa/driver.c                  |  54 ++-
 drivers/firmware/arm_scmi/notify.c                 |   6 +-
 drivers/firmware/stratix10-svc.c                   |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  62 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  73 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c   |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.h   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  54 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |  58 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  35 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  22 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  56 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  69 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c             |  24 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  49 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/soc24.c                 |  28 ++
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  15 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  12 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  10 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |   2 +
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |  25 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |  23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 417 +++++++++++----------
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  81 ++--
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.c  |  56 ++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_ism.h  |   1 +
 .../amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |   2 -
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |   2 -
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |   9 +-
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |  11 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   6 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +
 .../drm/amd/display/dc/dce/dce_stream_encoder.c    |  15 +-
 .../drm/amd/display/dc/dce/dce_stream_encoder.h    |   3 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   7 +-
 .../display/dc/link/protocols/link_dp_capability.c |   6 +-
 .../display/dc/resource/dce100/dce100_resource.c   |   7 +-
 .../amd/display/modules/info_packet/info_packet.c  |   2 -
 drivers/gpu/drm/amd/include/mes_v11_api_def.h      |   2 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  26 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  12 +
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |  12 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  11 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  15 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c   |  45 +++
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  28 +-
 .../gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_0_ppt.c   |   7 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  11 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  36 +-
 drivers/gpu/drm/drm_connector.c                    |  12 +-
 drivers/gpu/drm/drm_displayid_internal.h           |   2 +-
 drivers/gpu/drm/drm_gpusvm.c                       |  22 +-
 drivers/gpu/drm/drm_pagemap.c                      |  24 +-
 drivers/gpu/drm/drm_panel_backlight_quirks.c       |   9 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   6 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  36 +-
 drivers/gpu/drm/i915/display/intel_cdclk.c         |  41 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |  11 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   8 +-
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |   7 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |  12 +-
 drivers/gpu/drm/i915/display/intel_vrr.c           |   4 +
 drivers/gpu/drm/i915/display/skl_watermark.c       |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  25 +-
 drivers/gpu/drm/i915/gt/intel_engine_user.c        |   2 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  19 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   8 +-
 drivers/gpu/drm/i915/i915_active.c                 |   7 +-
 drivers/gpu/drm/imagination/pvr_context.c          |  22 +-
 drivers/gpu/drm/imagination/pvr_drv.c              |  13 +-
 drivers/gpu/drm/imagination/pvr_queue.c            |  65 ++--
 drivers/gpu/drm/imagination/pvr_queue.h            |   2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   2 +
 drivers/gpu/drm/nouveau/nouveau_exec.c             |   4 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c     |   1 +
 drivers/gpu/drm/panel/Kconfig                      |   3 +
 drivers/gpu/drm/panthor/panthor_device.c           |   5 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |   1 +
 drivers/gpu/drm/radeon/r100.c                      |  13 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |  18 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   2 +
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +
 drivers/gpu/drm/sysfb/drm_sysfb_helper.h           |   2 +-
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c      |  13 +-
 drivers/gpu/drm/sysfb/efidrm.c                     |   7 +-
 drivers/gpu/drm/sysfb/vesadrm.c                    |   6 +-
 drivers/gpu/drm/tegra/fbdev.c                      |   8 +-
 drivers/gpu/drm/tests/drm_gem_shmem_test.c         |  16 +-
 drivers/gpu/drm/tidss/tidss_encoder.c              |   2 +
 drivers/gpu/drm/ttm/ttm_backup.c                   | 123 ++++--
 drivers/gpu/drm/ttm/ttm_pool.c                     | 123 +++++-
 drivers/gpu/drm/ttm/ttm_pool_internal.h            |   8 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |  12 +
 drivers/gpu/drm/vc4/vc4_bo.c                       |  12 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   2 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |  14 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   5 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  22 +-
 drivers/gpu/drm/xe/display/xe_display_bo.c         |   3 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |   3 +-
 drivers/gpu/drm/xe/regs/xe_gtt_defs.h              |   6 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  58 ++-
 drivers/gpu/drm/xe/xe_bo.h                         |   3 +-
 drivers/gpu/drm/xe/xe_bo_types.h                   |   2 +
 drivers/gpu/drm/xe/xe_device.c                     |   2 +-
 drivers/gpu/drm/xe/xe_device_types.h               |   2 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/gpu/drm/xe/xe_guc_capture.c                |  10 +-
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h       |   5 +
 drivers/gpu/drm/xe/xe_guc_submit.c                 | 140 ++++---
 drivers/gpu/drm/xe/xe_guc_types.h                  |   2 -
 drivers/gpu/drm/xe/xe_i2c.c                        |   5 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |  21 +-
 drivers/gpu/drm/xe/xe_migrate.h                    |   4 +-
 drivers/gpu/drm/xe/xe_module.c                     |  49 +++
 drivers/gpu/drm/xe/xe_module.h                     |   5 +
 drivers/gpu/drm/xe/xe_nvm.c                        |   9 +-
 drivers/gpu/drm/xe/xe_pci.c                        |   6 +
 drivers/gpu/drm/xe/xe_pt.c                         | 148 +++++---
 drivers/gpu/drm/xe/xe_reg_whitelist.c              |  10 +-
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.c               |  32 +-
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.h               |   3 +-
 drivers/gpu/drm/xe/xe_svm.c                        |   6 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  33 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c                 |  19 +-
 drivers/gpu/drm/xe/xe_wopcm.c                      |  15 +-
 drivers/gpu/host1x/bus.c                           |   4 +-
 drivers/hwmon/ad7414.c                             |   4 +-
 drivers/hwmon/ad7418.c                             |   6 +-
 drivers/hwmon/adc128d818.c                         |   2 +-
 drivers/hwmon/adm1025.c                            |   4 +-
 drivers/hwmon/adm1026.c                            |   2 +-
 drivers/hwmon/adm1029.c                            |   2 +-
 drivers/hwmon/adm1031.c                            |   4 +-
 drivers/hwmon/adm1177.c                            |   4 +-
 drivers/hwmon/adm9240.c                            |   6 +-
 drivers/hwmon/ads7828.c                            |   4 +-
 drivers/hwmon/adt7410.c                            |   8 +-
 drivers/hwmon/adt7411.c                            |   2 +-
 drivers/hwmon/adt7462.c                            |   2 +-
 drivers/hwmon/adt7470.c                            |   2 +-
 drivers/hwmon/adt7475.c                            |   8 +-
 drivers/hwmon/aht10.c                              |   8 +-
 drivers/hwmon/amc6821.c                            |   2 +-
 drivers/hwmon/asb100.c                             |   2 +-
 drivers/hwmon/asc7621.c                            |   6 +-
 drivers/hwmon/asus-ec-sensors.c                    |  18 +-
 drivers/hwmon/atxp1.c                              |   2 +-
 drivers/hwmon/chipcap2.c                           |  16 +-
 drivers/hwmon/corsair-cpro.c                       |   1 +
 drivers/hwmon/corsair-psu.c                        |   1 +
 drivers/hwmon/dme1737.c                            |   4 +-
 drivers/hwmon/ds1621.c                             |  10 +-
 drivers/hwmon/ds620.c                              |   4 +-
 drivers/hwmon/emc1403.c                            |  24 +-
 drivers/hwmon/emc2103.c                            |   2 +-
 drivers/hwmon/emc2305.c                            |   8 +-
 drivers/hwmon/emc6w201.c                           |   2 +-
 drivers/hwmon/f75375s.c                            |   6 +-
 drivers/hwmon/fschmd.c                             |  14 +-
 drivers/hwmon/ftsteutates.c                        |   2 +-
 drivers/hwmon/g760a.c                              |   2 +-
 drivers/hwmon/g762.c                               |   6 +-
 drivers/hwmon/gigabyte_waterforce.c                |   4 +-
 drivers/hwmon/gl518sm.c                            |   2 +-
 drivers/hwmon/gl520sm.c                            |   2 +-
 drivers/hwmon/hih6130.c                            |   2 +-
 drivers/hwmon/hs3001.c                             |   4 +-
 drivers/hwmon/htu31.c                              |   2 +-
 drivers/hwmon/ina209.c                             |   2 +-
 drivers/hwmon/ina238.c                             |  12 +-
 drivers/hwmon/ina2xx.c                             |  16 +-
 drivers/hwmon/ina3221.c                            |   2 +-
 drivers/hwmon/isl28022.c                           |   2 +-
 drivers/hwmon/jc42.c                               |   2 +-
 drivers/hwmon/lineage-pem.c                        |   4 +-
 drivers/hwmon/lm63.c                               |   6 +-
 drivers/hwmon/lm73.c                               |   2 +-
 drivers/hwmon/lm75.c                               |  62 +--
 drivers/hwmon/lm77.c                               |   2 +-
 drivers/hwmon/lm78.c                               |   4 +-
 drivers/hwmon/lm80.c                               |   4 +-
 drivers/hwmon/lm83.c                               |   4 +-
 drivers/hwmon/lm85.c                               |  24 +-
 drivers/hwmon/lm87.c                               |   4 +-
 drivers/hwmon/lm90.c                               |  96 ++---
 drivers/hwmon/lm92.c                               |   6 +-
 drivers/hwmon/lm93.c                               |   4 +-
 drivers/hwmon/lm95234.c                            |   4 +-
 drivers/hwmon/lm95241.c                            |   4 +-
 drivers/hwmon/lm95245.c                            |   4 +-
 drivers/hwmon/ltc2945.c                            |   2 +-
 drivers/hwmon/ltc2947-i2c.c                        |   4 +-
 drivers/hwmon/ltc2990.c                            |   4 +-
 drivers/hwmon/ltc2991.c                            |   4 +-
 drivers/hwmon/ltc2992.c                            |   4 +-
 drivers/hwmon/ltc4151.c                            |   2 +-
 drivers/hwmon/ltc4215.c                            |   2 +-
 drivers/hwmon/ltc4222.c                            |   2 +-
 drivers/hwmon/ltc4245.c                            |   2 +-
 drivers/hwmon/ltc4260.c                            |   2 +-
 drivers/hwmon/ltc4261.c                            |   4 +-
 drivers/hwmon/max127.c                             |   2 +-
 drivers/hwmon/max16065.c                           |  12 +-
 drivers/hwmon/max1619.c                            |   2 +-
 drivers/hwmon/max1668.c                            |   6 +-
 drivers/hwmon/max31730.c                           |   2 +-
 drivers/hwmon/max31760.c                           |   2 +-
 drivers/hwmon/max31790.c                           |   2 +-
 drivers/hwmon/max31827.c                           |   6 +-
 drivers/hwmon/max6620.c                            |   2 +-
 drivers/hwmon/max6621.c                            |   2 +-
 drivers/hwmon/max6639.c                            |   2 +-
 drivers/hwmon/max6650.c                            |   4 +-
 drivers/hwmon/max6697.c                            |  20 +-
 drivers/hwmon/mc34vr500.c                          |   4 +-
 drivers/hwmon/mcp3021.c                            |   4 +-
 drivers/hwmon/nct6775-i2c.c                        |  26 +-
 drivers/hwmon/nct7802.c                            |   2 +-
 drivers/hwmon/nct7904.c                            |   4 +-
 drivers/hwmon/nzxt-kraken3.c                       |   6 +-
 drivers/hwmon/nzxt-smart2.c                        |   2 +-
 drivers/hwmon/occ/common.c                         |  38 +-
 drivers/hwmon/pcf8591.c                            |   2 +-
 drivers/hwmon/pmbus/acbel-fsg032.c                 |   4 +-
 drivers/hwmon/pmbus/adm1266.c                      |   2 +-
 drivers/hwmon/pmbus/adm1275.c                      |  20 +-
 drivers/hwmon/pmbus/aps-379.c                      |   4 +-
 drivers/hwmon/pmbus/bel-pfe.c                      |   6 +-
 drivers/hwmon/pmbus/bpa-rs600.c                    |   6 +-
 drivers/hwmon/pmbus/crps.c                         |   4 +-
 drivers/hwmon/pmbus/delta-ahe50dc-fan.c            |   2 +-
 drivers/hwmon/pmbus/dps920ab.c                     |   4 +-
 drivers/hwmon/pmbus/fsp-3y.c                       |   4 +-
 drivers/hwmon/pmbus/hac300s.c                      |   4 +-
 drivers/hwmon/pmbus/ibm-cffps.c                    |   8 +-
 drivers/hwmon/pmbus/ina233.c                       |   4 +-
 drivers/hwmon/pmbus/inspur-ipsps.c                 |   4 +-
 drivers/hwmon/pmbus/ir35221.c                      |   4 +-
 drivers/hwmon/pmbus/ir36021.c                      |   4 +-
 drivers/hwmon/pmbus/ir38064.c                      |  10 +-
 drivers/hwmon/pmbus/irps5401.c                     |   4 +-
 drivers/hwmon/pmbus/isl68137.c                     |  92 ++---
 drivers/hwmon/pmbus/lm25066.c                      |  10 +-
 drivers/hwmon/pmbus/lt3074.c                       |   4 +-
 drivers/hwmon/pmbus/lt7182s.c                      |   4 +-
 drivers/hwmon/pmbus/ltc2978.c                      |  60 +--
 drivers/hwmon/pmbus/ltc3815.c                      |   2 +-
 drivers/hwmon/pmbus/max15301.c                     |   8 +-
 drivers/hwmon/pmbus/max16064.c                     |   4 +-
 drivers/hwmon/pmbus/max16601.c                     |  10 +-
 drivers/hwmon/pmbus/max17616.c                     |   2 +-
 drivers/hwmon/pmbus/max20730.c                     |  10 +-
 drivers/hwmon/pmbus/max20751.c                     |   4 +-
 drivers/hwmon/pmbus/max31785.c                     |   8 +-
 drivers/hwmon/pmbus/max34440.c                     | 143 ++++++-
 drivers/hwmon/pmbus/max8688.c                      |   2 +-
 drivers/hwmon/pmbus/mp2856.c                       |   6 +-
 drivers/hwmon/pmbus/mp2888.c                       |   4 +-
 drivers/hwmon/pmbus/mp2891.c                       |   2 +-
 drivers/hwmon/pmbus/mp2925.c                       |   6 +-
 drivers/hwmon/pmbus/mp29502.c                      |   4 +-
 drivers/hwmon/pmbus/mp2975.c                       |   8 +-
 drivers/hwmon/pmbus/mp2993.c                       |   2 +-
 drivers/hwmon/pmbus/mp5920.c                       |   2 +-
 drivers/hwmon/pmbus/mp5926.c                       |   4 +-
 drivers/hwmon/pmbus/mp5990.c                       |   4 +-
 drivers/hwmon/pmbus/mp9941.c                       |   2 +-
 drivers/hwmon/pmbus/mp9945.c                       |   4 +-
 drivers/hwmon/pmbus/mpq7932.c                      |   6 +-
 drivers/hwmon/pmbus/mpq8785.c                      |  10 +-
 drivers/hwmon/pmbus/pim4328.c                      |  18 +-
 drivers/hwmon/pmbus/pli1209bc.c                    |   4 +-
 drivers/hwmon/pmbus/pm6764tr.c                     |   4 +-
 drivers/hwmon/pmbus/pmbus.c                        |  60 +--
 drivers/hwmon/pmbus/pxe1610.c                      |   8 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |   8 +-
 drivers/hwmon/pmbus/stef48h28.c                    |   4 +-
 drivers/hwmon/pmbus/stpddc60.c                     |   6 +-
 drivers/hwmon/pmbus/tda38640.c                     |   4 +-
 drivers/hwmon/pmbus/tps25990.c                     |   4 +-
 drivers/hwmon/pmbus/tps40422.c                     |   4 +-
 drivers/hwmon/pmbus/tps53679.c                     |  18 +-
 drivers/hwmon/pmbus/tps546d24.c                    |   4 +-
 drivers/hwmon/pmbus/ucd9000.c                      |  16 +-
 drivers/hwmon/pmbus/ucd9200.c                      |  18 +-
 drivers/hwmon/pmbus/xdp710.c                       |   2 +-
 drivers/hwmon/pmbus/xdp720.c                       |   4 +-
 drivers/hwmon/pmbus/xdpe12284.c                    |   8 +-
 drivers/hwmon/pmbus/xdpe152c4.c                    |   6 +-
 drivers/hwmon/pmbus/xdpe1a2g7b.c                   |   6 +-
 drivers/hwmon/pmbus/zl6100.c                       |  44 +--
 drivers/hwmon/powr1220.c                           |   4 +-
 drivers/hwmon/pt5161l.c                            |   4 +-
 drivers/hwmon/sbtsi_temp.c                         |   4 +-
 drivers/hwmon/sg2042-mcu.c                         |   2 +-
 drivers/hwmon/sht21.c                              |   6 +-
 drivers/hwmon/sht3x.c                              |   8 +-
 drivers/hwmon/sht4x.c                              |   4 +-
 drivers/hwmon/shtc1.c                              |   6 +-
 drivers/hwmon/smsc47m192.c                         |   2 +-
 drivers/hwmon/spd5118.c                            |   2 +-
 drivers/hwmon/stts751.c                            |   2 +-
 drivers/hwmon/tc654.c                              |   6 +-
 drivers/hwmon/tc74.c                               |   4 +-
 drivers/hwmon/thmc50.c                             |   4 +-
 drivers/hwmon/tmp102.c                             |   2 +-
 drivers/hwmon/tmp103.c                             |   2 +-
 drivers/hwmon/tmp108.c                             |   8 +-
 drivers/hwmon/tmp401.c                             |  10 +-
 drivers/hwmon/tmp421.c                             |  10 +-
 drivers/hwmon/tmp464.c                             |   4 +-
 drivers/hwmon/tmp513.c                             |   4 +-
 drivers/hwmon/tsc1641.c                            |   2 +-
 drivers/hwmon/w83773g.c                            |   2 +-
 drivers/hwmon/w83781d.c                            |   8 +-
 drivers/hwmon/w83791d.c                            |   2 +-
 drivers/hwmon/w83792d.c                            |   2 +-
 drivers/hwmon/w83793.c                             |   2 +-
 drivers/hwmon/w83795.c                             |   4 +-
 drivers/hwmon/w83l785ts.c                          |   2 +-
 drivers/hwmon/w83l786ng.c                          |   2 +-
 drivers/hwtracing/intel_th/core.c                  |  10 -
 drivers/hwtracing/intel_th/msu.c                   |   2 +
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/mad.c                      |  30 ++
 drivers/infiniband/core/verbs.c                    |   6 +-
 drivers/infiniband/hw/bng_re/bng_dev.c             |   6 +-
 drivers/infiniband/hw/erdma/erdma_qp.c             |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   2 +-
 drivers/infiniband/hw/irdma/uk.c                   |   9 +-
 drivers/infiniband/hw/irdma/user.h                 |   1 -
 drivers/infiniband/hw/irdma/verbs.c                |  33 +-
 drivers/infiniband/hw/mana/wr.c                    |   2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  44 ++-
 drivers/iommu/amd/init.c                           |   6 +
 drivers/iommu/amd/iommu.c                          |  22 +-
 drivers/iommu/amd/nested.c                         |  34 +-
 drivers/iommu/intel/perf.c                         |   2 +-
 drivers/iommu/intel/svm.c                          |   2 +-
 drivers/media/cec/platform/seco/seco-cec.c         |   6 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  12 +-
 drivers/media/dvb-frontends/rtl2832.c              |   4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  19 +-
 drivers/media/i2c/alvium-csi2.c                    |  21 +-
 drivers/media/i2c/dw9719.c                         |  10 +
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  14 +-
 drivers/media/pci/dm1105/dm1105.c                  |   1 +
 drivers/media/pci/intel/ipu6/ipu6-isys-dwc-phy.c   |  24 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  25 +-
 .../media/platform/amlogic/c3/isp/c3-isp-params.c  |   4 +
 .../media/platform/arm/mali-c55/mali-c55-core.c    |  21 +-
 drivers/media/platform/arm/mali-c55/mali-c55-isp.c |   7 +
 drivers/media/platform/aspeed/aspeed-video.c       |   1 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |  29 +-
 drivers/media/platform/marvell/cafe-driver.c       |   1 +
 drivers/media/platform/nuvoton/npcm-video.c        |  34 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-core.c    |   2 +
 .../media/platform/nxp/imx8-isi/imx8-isi-core.h    |  16 +
 .../platform/nxp/imx8-isi/imx8-isi-crossbar.c      |   1 +
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c  |   9 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c |  11 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-pipe.c    |  20 +-
 drivers/media/platform/qcom/camss/camss-csid-340.c |  18 +-
 drivers/media/platform/qcom/camss/camss-csid-680.c |  30 +-
 .../media/platform/qcom/camss/camss-csid-gen2.c    |  47 +--
 .../media/platform/qcom/camss/camss-csid-gen3.c    |  28 +-
 drivers/media/platform/qcom/iris/iris_probe.c      |   6 +-
 .../platform/renesas/rzg2l-cru/rzg2l-cru-regs.h    |   1 +
 .../media/platform/renesas/rzg2l-cru/rzg2l-video.c |  17 +-
 .../platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c   |  31 +-
 drivers/media/platform/st/stm32/stm32-dcmi.c       |   1 +
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c         |   6 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |   6 +-
 .../media/platform/synopsys/hdmirx/snps_hdmirx.c   |   4 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |   2 +-
 drivers/media/platform/ti/vpe/vip.c                |  16 +-
 drivers/media/platform/ti/vpe/vpe.c                |   3 +-
 drivers/media/platform/verisilicon/hantro_v4l2.c   |   6 +-
 drivers/media/radio/radio-si476x.c                 |   1 +
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |   1 +
 drivers/media/test-drivers/vivid/vivid-core.c      |   6 +-
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |  15 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  38 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.h   |   1 +
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |   6 +
 drivers/media/usb/airspy/airspy.c                  |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  16 +-
 drivers/media/usb/msi2500/msi2500.c                |  32 +-
 drivers/media/usb/pwc/pwc-if.c                     |  13 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  13 +
 drivers/media/v4l2-core/v4l2-ctrls-request.c       |  14 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   6 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   4 +
 drivers/misc/mei/bus.c                             |  16 +-
 drivers/misc/nsm.c                                 |   3 +-
 drivers/mtd/mtd_virt_concat.c                      |   4 +-
 drivers/mtd/mtdcore.c                              |  23 +-
 drivers/mtd/mtdswap.c                              |   5 +-
 drivers/mtd/nand/ecc-mtk.c                         |  16 +-
 drivers/net/amt.c                                  | 101 +++--
 drivers/net/bonding/bond_main.c                    |   3 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   3 +-
 drivers/net/ethernet/airoha/airoha_npu.c           |   4 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |   1 +
 drivers/net/ethernet/amd/pds_core/adminq.c         |  12 +-
 drivers/net/ethernet/amd/pds_core/auxbus.c         |  17 +-
 drivers/net/ethernet/amd/pds_core/core.c           |  22 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |   6 +
 drivers/net/ethernet/amd/pds_core/main.c           |  14 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  11 +-
 drivers/net/ethernet/broadcom/bnge/bnge.h          |   1 +
 drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c |   8 +-
 drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.h |   2 +-
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.c   |  50 ++-
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.h   |   4 +-
 drivers/net/ethernet/broadcom/bnge/bnge_rmem.h     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |  39 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   1 +
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |  17 +-
 drivers/net/ethernet/google/gve/gve.h              |   3 +
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  34 ++
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  11 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   2 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  21 --
 drivers/net/ethernet/intel/ice/ice.h               |   3 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   3 -
 drivers/net/ethernet/intel/ice/ice_lag.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_parser.c        |   3 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  14 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   3 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   7 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   4 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  78 +++-
 .../ethernet/netronome/nfp/nfpcore/nfp_resource.c  |   3 +
 drivers/net/ethernet/realtek/rtase/rtase.h         |   8 +
 drivers/net/ethernet/realtek/rtase/rtase_main.c    | 197 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  31 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  24 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  28 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  96 ++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  35 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c     |   6 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   1 +
 drivers/net/geneve.c                               |  27 +-
 drivers/net/gtp.c                                  |  17 +-
 drivers/net/mctp/mctp-i3c.c                        |  11 +-
 drivers/net/mctp/mctp-serial.c                     |   2 +-
 drivers/net/ovpn/io.c                              |   4 +-
 drivers/net/ovpn/peer.c                            |  16 +-
 drivers/net/ovpn/tcp.c                             |   6 +-
 drivers/net/pcs/pcs-xpcs.c                         |  34 +-
 drivers/net/phy/marvell.c                          |   2 +-
 drivers/net/ppp/ppp_generic.c                      | 100 +++--
 drivers/net/ppp/pppoe.c                            |   1 +
 drivers/net/slip/slip.c                            |   4 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  22 +-
 drivers/net/vxlan/vxlan_core.c                     |   3 +
 drivers/net/vxlan/vxlan_mdb.c                      |  30 +-
 drivers/net/wan/wanxl.c                            |   3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +
 drivers/net/wireless/ath/ath11k/pci.c              |   4 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  11 +-
 drivers/net/wireless/ath/ath12k/dp_peer.c          |  11 +-
 drivers/net/wireless/ath/ath12k/dp_peer.h          |   1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   7 +-
 drivers/net/wireless/ath/ath12k/hw.h               |  16 +
 drivers/net/wireless/ath/ath12k/mac.c              |  10 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   4 +
 drivers/net/wireless/ath/ath12k/peer.c             |   3 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  33 ++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |   6 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   3 +
 drivers/net/wireless/ath/ath6kl/txrx.c             |  12 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  20 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   7 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  14 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  46 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 +
 drivers/net/wireless/intersil/p54/txrx.c           |   8 +
 drivers/net/wireless/marvell/libertas/firmware.c   |   1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  14 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |   4 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   6 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  19 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   5 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   1 +
 drivers/platform/loongarch/loongson-laptop.c       |   1 +
 drivers/platform/x86/asus-wmi.c                    |  26 +-
 .../uncore-frequency/uncore-frequency-common.c     |   7 +-
 drivers/platform/x86/intel/vsec.c                  |  31 +-
 drivers/platform/x86/intel/vsec_tpmi.c             |  13 +-
 drivers/ptp/ptp_netc.c                             |   1 +
 drivers/ptp/ptp_s390.c                             |   6 +-
 drivers/regulator/mt6358-regulator.c               |   2 +-
 drivers/resctrl/mpam_devices.c                     |  36 +-
 drivers/reset/spacemit/reset-spacemit-k3.c         |   2 +-
 drivers/scsi/hosts.c                               |   2 +
 drivers/scsi/scsi_error.c                          |  22 +-
 drivers/scsi/scsi_priv.h                           |   1 +
 drivers/spi/spi-cadence-quadspi.c                  |  12 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   6 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   3 +
 drivers/staging/media/tegra-video/vi.c             |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   9 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   2 +-
 drivers/thunderbolt/debugfs.c                      |   2 +
 drivers/thunderbolt/domain.c                       |  30 ++
 drivers/thunderbolt/icm.c                          |   5 +
 drivers/thunderbolt/switch.c                       |  14 +
 drivers/thunderbolt/tb.c                           |  59 ++-
 drivers/thunderbolt/tb.h                           |   2 +
 drivers/thunderbolt/xdomain.c                      | 100 +++--
 drivers/tty/serial/8250/8250_mid.c                 |  14 +-
 drivers/tty/serial/sc16is7xx.c                     |  12 +
 drivers/uio/uio_hv_generic.c                       |   8 +-
 drivers/usb/atm/ueagle-atm.c                       |  17 +
 drivers/usb/chipidea/core.c                        |   1 +
 drivers/usb/core/port.c                            |   2 +
 drivers/usb/core/sysfs.c                           |   8 +-
 drivers/usb/gadget/function/f_midi.c               |   1 +
 drivers/usb/gadget/function/f_ncm.c                |  17 +-
 drivers/usb/gadget/function/f_printer.c            |  23 +-
 drivers/usb/gadget/function/f_tcm.c                | 192 ++++++++--
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   2 +
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  20 +
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  40 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |  93 +++--
 drivers/usb/gadget/udc/fsl_usb2_udc.h              |   1 +
 drivers/usb/gadget/udc/snps_udc_core.c             |   1 -
 drivers/usb/host/xhci-pci.c                        |   1 +
 drivers/usb/host/xhci.c                            |  15 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/musb/omap2430.c                        |   2 -
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/io_edgeport.c                   |   3 +-
 drivers/usb/serial/keyspan_pda.c                   |  44 ++-
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/usb/typec/ucsi/ucsi.c                      | 158 +++++++-
 drivers/vhost/net.c                                |   8 +-
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c      |   2 +-
 drivers/watchdog/airoha_wdt.c                      |   3 +
 drivers/watchdog/ni903x_wdt.c                      |   7 +-
 drivers/watchdog/s32g_wdt.c                        |   3 +-
 drivers/watchdog/watchdog_pretimeout.c             |   2 +
 fs/afs/dir_edit.c                                  |   2 +-
 fs/binfmt_elf_fdpic.c                              |   4 +
 fs/binfmt_misc.c                                   |   5 +-
 fs/btrfs/btrfs_inode.h                             |   2 +
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/extent_map.c                              |   4 +-
 fs/btrfs/file-item.c                               |  26 +-
 fs/btrfs/free-space-cache.c                        |   3 +
 fs/btrfs/relocation.c                              |   2 +
 fs/ceph/addr.c                                     |   9 +
 fs/ceph/caps.c                                     |   1 +
 fs/ceph/dir.c                                      |   7 +-
 fs/ceph/ioctl.c                                    |   6 +
 fs/crypto/inline_crypt.c                           |  57 +--
 fs/crypto/keysetup_v1.c                            |   8 +-
 fs/erofs/zmap.c                                    |   3 +-
 fs/exec.c                                          |   2 +-
 fs/f2fs/super.c                                    |  25 +-
 fs/fuse/dev_uring.c                                |  22 +-
 fs/iomap/buffered-io.c                             |  42 ++-
 fs/nfsd/vfs.c                                      |   6 +-
 fs/overlayfs/file.c                                |  16 +-
 fs/overlayfs/xattrs.c                              |   2 +-
 fs/pidfs.c                                         |   2 +-
 fs/posix_acl.c                                     |   7 +
 fs/proc/namespaces.c                               |   4 +-
 fs/smb/client/cifsfs.c                             |   1 +
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/file.c                               |  69 +++-
 fs/smb/client/inode.c                              |   6 +
 fs/smb/client/misc.c                               | 106 +++++-
 fs/smb/client/smb2file.c                           |  21 ++
 fs/smb/client/smb2inode.c                          |  23 +-
 fs/smb/client/smb2ops.c                            |  25 +-
 fs/smb/server/connection.c                         |  16 +-
 fs/smb/server/oplock.c                             |   6 +-
 fs/smb/server/smb2misc.c                           |   5 +
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/smbacl.c                             |  42 ++-
 fs/super.c                                         |  34 +-
 fs/xfs/scrub/cow_repair.c                          | 203 ++++++----
 fs/xfs/scrub/trace.h                               |  28 +-
 include/drm/drm_connector.h                        |   6 +-
 include/drm/drm_utils.h                            |   1 +
 include/drm/ttm/ttm_backup.h                       |  12 +-
 include/linux/arm_ffa.h                            |   2 +-
 include/linux/audit.h                              |   4 +-
 include/linux/audit_arch.h                         |  12 +-
 include/linux/bnge/hsi.h                           |   7 +-
 include/linux/bootconfig.h                         |   3 +
 include/linux/firmware/intel/stratix10-smc.h       |   4 +
 include/linux/fscrypt.h                            |  18 +-
 include/linux/intel_vsec.h                         |   6 +-
 include/linux/memory_hotplug.h                     |   8 +-
 include/linux/mlx5/mlx5_ifc.h                      |  13 +-
 include/linux/seqlock.h                            |   7 +-
 include/linux/sunrpc/xdr.h                         |  19 +-
 include/linux/vtime.h                              |   6 +
 include/media/v4l2-async.h                         |   4 +-
 include/media/videobuf2-core.h                     |   8 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bluetooth/rfcomm.h                     |   3 +
 include/net/cfg80211.h                             |   4 +-
 include/net/pkt_cls.h                              |  14 +-
 include/net/sctp/structs.h                         |   3 +-
 include/net/tcp.h                                  |   2 +
 include/scsi/scsi_host.h                           |   3 +
 include/trace/events/memory-failure.h              |   6 +-
 include/uapi/linux/btrfs.h                         |   2 +-
 include/uapi/linux/rkisp1-config.h                 |   6 +-
 init/Kconfig                                       |   3 +
 init/main.c                                        |  45 ---
 io_uring/rw.c                                      |  42 ++-
 kernel/audit.c                                     |   2 +-
 kernel/audit.h                                     |  19 +-
 kernel/audit_fsnotify.c                            |  32 +-
 kernel/audit_tree.c                                |   2 +-
 kernel/audit_watch.c                               |  25 +-
 kernel/auditfilter.c                               |  17 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/sched/ext.c                                 | 134 ++++---
 kernel/sched/ext_internal.h                        |  30 ++
 kernel/smp.c                                       |  30 +-
 kernel/trace/ftrace.c                              |  13 +
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace.h                               |   1 +
 kernel/trace/trace_eprobe.c                        |   3 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_hist.c                   |   2 +
 kernel/trace/trace_events_trigger.c                |  22 +-
 kernel/trace/trace_mmiotrace.c                     |   4 +-
 kernel/trace/trace_probe.c                         |  13 +-
 kernel/trace/trace_remote.c                        |  16 +-
 kernel/trace/trace_syscalls.c                      |   5 +
 lib/bootconfig.c                                   |  65 ++++
 lib/compat_audit.c                                 |  12 +-
 lib/rhashtable.c                                   |   1 +
 mm/damon/core.c                                    |  13 +
 mm/huge_memory.c                                   |  12 +-
 mm/kmemleak.c                                      |   7 +-
 mm/memory_hotplug.c                                |  13 +-
 mm/memremap.c                                      |   4 +-
 mm/page_vma_mapped.c                               |  33 +-
 mm/slub.c                                          |  21 +-
 mm/sparse-vmemmap.c                                |  46 ++-
 mm/userfaultfd.c                                   |   5 +-
 net/bluetooth/hci_event.c                          |  18 +-
 net/bluetooth/hci_sync.c                           |  79 +++-
 net/bluetooth/mgmt.c                               | 105 +++++-
 net/bluetooth/rfcomm/core.c                        |  17 +
 net/bluetooth/rfcomm/tty.c                         |   7 +-
 net/bridge/br_netlink_tunnel.c                     |   3 +-
 net/bridge/br_private.h                            |   6 +-
 net/bridge/br_vlan.c                               |  10 +-
 net/bridge/br_vlan_options.c                       |   3 +-
 net/can/j1939/transport.c                          |  18 +-
 net/can/raw.c                                      |  66 ++--
 net/ceph/auth_x.c                                  |   9 +-
 net/ceph/ceph_common.c                             |   4 +-
 net/ceph/cls_lock_client.c                         |   8 +-
 net/ceph/mon_client.c                              |   4 +-
 net/ceph/osdmap.c                                  |  16 +-
 net/core/bpf_sk_storage.c                          |   2 -
 net/core/dev.c                                     |  10 +-
 net/core/drop_monitor.c                            |  18 +-
 net/core/filter.c                                  |  17 +-
 net/core/gro.c                                     |   4 +-
 net/core/sock.c                                    |  13 +-
 net/core/sock_map.c                                |   2 +
 net/hsr/hsr_slave.c                                |   2 +
 net/ipv4/datagram.c                                |   4 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/icmp.c                                    |  18 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/raw.c                                     |  23 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |  56 ++-
 net/ipv4/tcp_ipv4.c                                |  14 +-
 net/ipv4/tcp_minisocks.c                           |  12 +-
 net/ipv6/ila/ila_common.c                          |  12 +
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |   4 +-
 net/ipv6/tcp_ipv6.c                                |   8 +-
 net/ipv6/xfrm6_policy.c                            |   1 +
 net/iucv/af_iucv.c                                 |  21 +-
 net/mac80211/cfg.c                                 |  14 +-
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/link.c                                |   4 +
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/nan.c                                 |  35 +-
 net/mac80211/rx.c                                  |   2 +
 net/mac80211/sta_info.c                            |  15 +-
 net/mac802154/llsec.c                              |   5 +
 net/mac802154/scan.c                               |  11 +
 net/mctp/device.c                                  |   4 +-
 net/mpls/af_mpls.c                                 |  11 +-
 net/mptcp/options.c                                |  17 +-
 net/mptcp/pm_userspace.c                           |   7 +-
 net/mptcp/protocol.c                               |  34 +-
 net/openvswitch/actions.c                          |  19 +-
 net/openvswitch/datapath.c                         |  25 +-
 net/openvswitch/datapath.h                         |   2 +-
 net/openvswitch/vport.c                            |   2 +-
 net/packet/af_packet.c                             |   6 +-
 net/phonet/pep.c                                   |   2 +
 net/qrtr/af_qrtr.c                                 |   8 +
 net/qrtr/ns.c                                      |   4 +-
 net/rds/ib.c                                       |   4 +
 net/rds/ib_cm.c                                    |   4 +
 net/rds/recv.c                                     |  15 +
 net/rds/tcp.c                                      |  12 +-
 net/rxrpc/ar-internal.h                            |   6 +-
 net/sched/act_tunnel_key.c                         |  14 +-
 net/sched/cls_api.c                                |   6 +-
 net/sched/sch_api.c                                |  24 +-
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_drr.c                                |   2 +-
 net/sched/sch_dualpi2.c                            |   2 +-
 net/sched/sch_ets.c                                |   2 +-
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sched/sch_fq_pie.c                             |   2 +-
 net/sched/sch_hfsc.c                               |   2 +-
 net/sched/sch_htb.c                                |   2 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sched/sch_qfq.c                                |   2 +-
 net/sched/sch_sfb.c                                |   2 +-
 net/sched/sch_sfq.c                                |   2 +-
 net/sctp/auth.c                                    |   2 +-
 net/sctp/protocol.c                                |  21 +-
 net/sctp/sm_make_chunk.c                           |   6 +
 net/sctp/sm_statefuns.c                            |   2 +-
 net/sctp/stream.c                                  |   6 +-
 net/sctp/sysctl.c                                  |   9 +-
 net/sunrpc/svcsock.c                               |  14 +-
 net/sunrpc/xdr.c                                   | 210 ++++++++++-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   4 +
 net/sunrpc/xprtrdma/verbs.c                        |  12 +-
 net/tipc/netlink.c                                 |   6 +-
 net/tipc/netlink_compat.c                          |   4 +
 net/tipc/socket.c                                  |   5 +-
 net/tipc/udp_media.c                               |  56 ++-
 net/tls/tls_device.c                               |   6 +-
 net/vmw_vsock/virtio_transport_common.c            | 165 +++++++-
 net/wireless/core.c                                |  14 +-
 net/wireless/core.h                                |   4 +-
 net/wireless/nl80211.c                             |  25 +-
 net/wireless/pmsr.c                                |  34 +-
 net/wireless/scan.c                                |  13 +-
 net/wireless/sme.c                                 |   6 +-
 net/x25/af_x25.c                                   |   8 +-
 net/xfrm/xfrm_device.c                             |  12 +-
 net/xfrm/xfrm_iptfs.c                              |   1 +
 net/xfrm/xfrm_policy.c                             |   4 +-
 net/xfrm/xfrm_state.c                              |  11 +-
 net/xfrm/xfrm_user.c                               |   3 +-
 rust/bindings/lib.rs                               |   4 +
 rust/kernel/device.rs                              |  20 +-
 rust/kernel/time.rs                                |  11 +-
 rust/uapi/lib.rs                                   |   4 +
 sound/core/seq/seq_timer.c                         |  13 +-
 sound/core/timer.c                                 |  21 +-
 sound/hda/codecs/hdmi/hdmi.c                       |   3 +
 sound/hda/codecs/hdmi/hdmi_local.h                 |   9 +
 sound/hda/codecs/hdmi/intelhdmi.c                  |  36 +-
 sound/hda/codecs/realtek/alc269.c                  |   9 +
 sound/hda/codecs/side-codecs/cs35l41_hda.c         |  11 +-
 sound/soc/amd/acp/Kconfig                          |  10 +-
 sound/soc/amd/acp/Makefile                         |   3 +-
 sound/soc/amd/acp/amd-acp70-acpi-match.c           |   2 +-
 sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c       |   4 -
 sound/soc/amd/ps/pci-ps.c                          |  33 +-
 sound/soc/codecs/bt-sco.c                          |  10 +-
 sound/soc/codecs/cs35l56-i2c.c                     |   4 +-
 sound/soc/codecs/cs35l56-spi.c                     |   4 +-
 sound/soc/codecs/cs35l56.c                         |  17 +-
 sound/soc/codecs/cs42l43-jack.c                    |   3 +-
 sound/soc/codecs/tas2562.c                         |   5 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |  63 +++-
 sound/soc/fsl/fsl_sai.c                            |  29 +-
 sound/soc/fsl/imx-card.c                           |  12 +-
 sound/soc/meson/aiu-fifo-spdif.c                   |   5 +
 sound/soc/sunxi/sun4i-codec.c                      |   1 +
 sound/usb/mixer.c                                  |   2 +-
 sound/usb/quirks.c                                 |   2 +
 tools/objtool/check.c                              |   1 +
 tools/testing/selftests/alsa/mixer-test.c          |   1 +
 .../testing/selftests/bpf/progs/verifier_map_ptr.c |  36 +-
 tools/testing/selftests/drivers/net/.gitignore     |   1 +
 tools/testing/selftests/drivers/net/Makefile       |   2 +
 tools/testing/selftests/drivers/net/config         |   5 +
 .../drivers/net/netconsole/netcons_resume.sh       |   3 +-
 tools/testing/selftests/drivers/net/settings       |   1 +
 .../selftests/{ => drivers}/net/so_txtime.c        |  35 +-
 tools/testing/selftests/drivers/net/so_txtime.py   | 103 +++++
 tools/testing/selftests/drivers/ntsync/config      |   2 +-
 tools/testing/selftests/ftrace/ftracetest          |   1 +
 tools/testing/selftests/net/.gitignore             |   1 -
 tools/testing/selftests/net/Makefile               |   2 -
 tools/testing/selftests/net/af_unix/config         |   1 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   2 +-
 tools/testing/selftests/net/openvswitch/config     |  16 +
 tools/testing/selftests/net/ovpn/config            |   2 +
 tools/testing/selftests/net/ovpn/ovpn-cli.c        |   4 +-
 tools/testing/selftests/net/ovpn/settings          |   1 +
 tools/testing/selftests/net/so_txtime.sh           | 110 ------
 tools/testing/selftests/net/tun.c                  |   8 +-
 946 files changed, 9236 insertions(+), 4123 deletions(-)


