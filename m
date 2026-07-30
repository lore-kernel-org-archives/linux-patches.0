Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245543E079;
	Thu, 30 Jul 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421085; cv=none; b=aFFMBX7Scf042xZxNCI9My+6QbfOhJjcd4BtdL+UngY0zyzgqHNOlXDBL2/mleoL2eULJxyC3ISEdNLM23jveYtT0WMSK6pbjqKQLftmhLG1XpDVWyVnHFlw5Z29OvHwUyjoS4GFCHGdQuKzsEGa9HtG36NY5fHn//sZ+NWXoFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421085; c=relaxed/simple;
	bh=uAIBRet9XeusfQwM3vRDXrAMS1j+M3PKQWF3lr233+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mDZHZcz7bSIyBJbzEENBWzJ/LWw9toOzkwIaWavLPES07CRyqDqttT5/wMylBgQ/et0cQODlPk14F4x6ga7yQKR5fsofk/kH1qUAZh5T3qSl4uR6lAGRy3GX9KtSnnlgwQAFQvgi1+dsTZGKWU3Kt4RDBTyO5+JQwzG15QsIQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOe+EEyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOe+EEyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B6A1F00A3A;
	Thu, 30 Jul 2026 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421075;
	bh=1DkplWi2k4V4EJICV83yleG5EYyJMjpiLGZuF+ogXPo=;
	h=From:To:Cc:Subject:Date;
	b=GOe+EEyyDvpV5dj2RBmeHNWHIXTsRX/dolqBjL1xS5L3WL576Yj1/veMNnxq4oNBq
	 f/jX6QEMRWDU1qdJ9950lnyRksEGJwqLdytI9gBtlEmJDz0LTiPeJzMY3QcwV2M/gc
	 /fc3SztIkIE4s7JCBfRhiOF8I060zdh6eXbUS1Zg=
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
Subject: [PATCH 6.18 000/675] 6.18.42-rc1 review
Date: Thu, 30 Jul 2026 16:05:30 +0200
Message-ID: <20260730141445.110192266@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.42-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.42-rc1
X-KernelTest-Deadline: 2026-08-01T14:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.42 release.
There are 675 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Aug 2026 14:13:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.42-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.42-rc1

Nikunj A Dadhania <nikunj@amd.com>
    KVM: SVM: Bump asid_generation on CPU online to avoid ASID collision after hotplug

Koen Koning <koen.koning@linux.intel.com>
    gpu: Fix uninitialized buddy for built-in drivers

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: fix dwmac4 transmit performance regression

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix NULL pointer dereference in ioctl module EEPROM query

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Alice Ryhl <aliceryhl@google.com>
    rust: device: avoid trailing ; in printing macros

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `suspicious_runtime_symbol_definitions` lint for Rust >= 1.98

SJ Park <sj@kernel.org>
    mm/damon/core: disallow overlapping input ranges for damon_set_regions()

SJ Park <sj@kernel.org>
    mm/damon/core: validate ranges in damon_set_regions()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix handling of shared IRQs during early initialization

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix Hot-Join NACK

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI

Marco Felsch <m.felsch@pengutronix.de>
    pmdomain: imx93-blk-ctrl: convert to devm_* only

Haoxiang Li <haoxiang_li2024@163.com>
    net: ipa: fix SMEM state handle leaks in SMP2P init

Bryam Vargas <hexlabsecurity@proton.me>
    ata: libata-core: Reject an invalid concurrent positioning ranges count

Breno Leitao <leitao@debian.org>
    bootconfig: fix NULL-pointer arithmetic in xbc_snprint_cmdline()

Breno Leitao <leitao@debian.org>
    bootconfig: move xbc_snprint_cmdline() to lib/bootconfig.c

Junrui Luo <moonafterrain@outlook.com>
    octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF

Michael Bommarito <michael.bommarito@gmail.com>
    octeontx2-af: validate body pcifunc in rvu_mbox_handler_rep_event_notify

Shradha Gupta <shradhagupta@linux.microsoft.com>
    net: mana: Optimize irq affinity for low vcpu configs

Dexuan Cui <decui@microsoft.com>
    net: mana: Validate the packet length reported by the NIC

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Fix use-after-free during unmount

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Move RMID initialization to first mount

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]

Tony Luck <tony.luck@intel.com>
    x86,fs/resctrl: Rename some L3 specific functions

Tony Luck <tony.luck@intel.com>
    x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Split L3 dependent parts out of __mon_event_count()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: rename probe error labels

Ingo Blechschmidt <iblech@speicherleck.de>
    dm: avoid leaking the caller's thread keyring via the table device file

Christian Brauner <brauner@kernel.org>
    cred: add kernel_cred() helper

Doruk Tan Ozturk <doruk@0sec.ai>
    accel/amdxdna: reject command submission on devices without a submit op

Souvik Banerjee <souvik@amlalabs.com>
    ovl: use linked upper dentry in copy-up tmpfile

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma-pcie: Reject devices without driver data

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    dmaengine: dw-edma: Fix confusing cleanup.h syntax

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove XDomain from the bus without holding tb->lock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Remove service debugfs entries during unregister

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Pratyush Yadav (Google) <pratyush@kernel.org>
    kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES

Muchun Song <muchun.song@linux.dev>
    mm/sparse-vmemmap: fix vmemmap accounting underflow

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: xlnx: Check remote core state

Terry Bowman <terry.bowman@amd.com>
    cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Remove CXL VH handling in CONFIG_PCIEAER_CXL conditional blocks from core/pci.c

Terry Bowman <terry.bowman@amd.com>
    cxl/pci: Remove unnecessary CXL RCH handling helper functions

Terry Bowman <terry.bowman@amd.com>
    cxl/pci: Remove unnecessary CXL Endpoint handling helper functions

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Return an error from xdr_buf_to_bvec() on overflow

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add helpers to convert xdr_buf byte ranges to scatterlists

Jeff Layton <jlayton@kernel.org>
    sunrpc: allocate a separate bvec array for socket sends

Mike Snitzer <snitzer@kernel.org>
    NFSD: pass nfsd_file to nfsd_iter_read()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    gpu/buddy: bail out of try_harder when alignment cannot be honoured

Joel Fernandes <joelagnelf@nvidia.com>
    gpu: Move DRM buddy allocator one level up (part two)

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_sip: validate skb_dst() before accessing it

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: remove net variable shadowing

Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_fib: reject fib expression on the netdev egress hook

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: remove register tracking infrastructure

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: Fix OPP tables for all DisplayPort controllers

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: correct RBR opp entry

Jason Wang <jasowang@redhat.com>
    VDUSE: avoid leaking information to userspace

Eugenio Pérez <eperezma@redhat.com>
    vduse: take out allocations from vduse_dev_alloc_coherent

Eugenio Pérez <eperezma@redhat.com>
    vduse: remove unused vaddr parameter of vduse_domain_free_coherent

Eugenio Pérez <eperezma@redhat.com>
    vduse: return internal vq group struct as map token

Darrick J. Wong <djwong@kernel.org>
    xfs: don't replace the wrong part of the cow fork

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: fix race between registration and connection abortion

Ricardo Robaina <rrobaina@redhat.com>
    audit: fix recursive locking deadlock in audit_dupe_exe()

Ricardo Robaina <rrobaina@redhat.com>
    audit: use 'unsigned int' instead of 'unsigned'

Jeff Layton <jlayton@kernel.org>
    audit: widen ino fields to u64

Mickaël Salaün <mic@digikod.net>
    landlock: Account all audit data allocations to user space

Mickaël Salaün <mic@digikod.net>
    landlock: Fix formatting

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix DTB DTO updates breaking live pixel rate sources

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Avoid dynamic allocation in fscrypt_get_devices()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate ACE size against SID sub-authorities

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: bound DACL dedup walk to copied ACEs

Wentao Guan <guanwentao@uniontech.com>
    ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    net: qrtr: ns: Raise node count limit to 512

Ming Lei <tom.leiming@gmail.com>
    ublk: wait on ublk_dev_ready() instead of ub->completion

Jia Yao <jia.yao@intel.com>
    drm/xe/uapi: Reject coh_none PAT index for CPU_ADDR_MIRROR

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix buffer overflow in FEC calculation

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: fix reading parity bytes split across blocks (take 3)

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: fix the size of dm_verity_fec_io::erasures

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix check in amdgpu_hmm_invalidate_gfx

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu13 power limit range calculation

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: fix aperture mapping leak

Ce Sun <cesun102@amd.com>
    drm/amdgpu: invoke pm_genpd_remove() before freeing genpd

Ce Sun <cesun102@amd.com>
    drm/amdgpu: fix resource leak on ACP reset timeout

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu: fix division by zero with invalid uvd dimensions

Luca Coelho <luciano.coelho@intel.com>
    drm/dp_mst: Handle torn-down topology gracefully in drm_dp_mst_topology_queue_probe()

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn4: avoid rereading IB param length

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vce: fix integer overflow in image size

Jakob Linke <jakob@linke.cx>
    drm/amdgpu/soc24: reset dGPU if suspend got aborted

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: replace BUG_ON() with WARN_ON()

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

Coia Prant <coiaprant@gmail.com>
    net: pcs: xpcs: fix SGMII state reading

Fan Wu <fanwu01@zju.edu.cn>
    net: hip04: fix RX buffer leak on build_skb failure

Shiming Cheng <shiming.cheng@mediatek.com>
    net: gro: fix double aggregation of flush-marked skbs

David Lee <david.lee@trailofbits.com>
    net/x25: fix use-after-free in x25_kill_by_neigh()

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

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Disallow SVA if page walk is not coherent

Zhang Yi <yi.zhang@huawei.com>
    iomap: fix out-of-bounds bitmap_set() with zero-length range

Yitang Yang <yi1tang.yang@gmail.com>
    io_uring/rw: fix missing ERESTARTSYS conversion in read paths

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Add global mutex to serialize trace_parser access

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

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix multiplication overflow in decode_new_up_state_weight()

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

Breno Leitao <leitao@debian.org>
    mm/kmemleak: fix checksum computation for per-cpu objects

David Howells <dhowells@redhat.com>
    afs: Fix afs_edit_dir_remove() to get, not find, block 0

Geliang Tang <geliang@kernel.org>
    mptcp: pm: userspace: fix use-after-free in get_local_id

Michael Bommarito <michael.bommarito@gmail.com>
    mptcp: only set DATA_FIN when a mapping is present

Chenguang Zhao <zhaochenguang@kylinos.cn>
    mptcp: decrement subflows counter on failed passive join

Will Deacon <will@kernel.org>
    Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"

Will Deacon <will@kernel.org>
    arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates

Dev Jain <dev.jain@arm.com>
    arm64: make huge_ptep_get handled unaligned addresses

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix potential underflow in LEN_OR_ZERO macro

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix union collision of module and refcnt for dynamic events

deepakraog <gaikwad.dcg@gmail.com>
    tracing: Fix resource leak on mmiotrace trace_pipe close

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev

Usama Arif <usama.arif@linux.dev>
    tracing: Fix context switch counter truncation

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

Haoran Jiang <jianghaoran@kylinos.cn>
    LoongArch: Fix oops during single-step debugging

George Guo <guodongtai@kylinos.cn>
    LoongArch: Fix address space mismatch in kexec command line lookup

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.99.0

Alexandre Courbot <acourbot@nvidia.com>
    rust: allow `clippy::unwrap_or_default` globally

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

Wentao Liang <vulab@iscas.ac.cn>
    wifi: ath11k: fix refcount leak in ath11k_ahb_fw_resources_init()

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: make release_scratchbuffers idempotent

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

Myeonghun Pak <mhun512@gmail.com>
    media: ti: vpe: unwind v4l2 device registration on probe error

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

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    media: rzg2l-cru: Skip ICnMC configuration when ICnSVC is used

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: Return queued buffers on start_streaming() failure

Deepanshu Kartikey <kartikey406@gmail.com>
    media: rtl2832: fix use-after-free in rtl2832_remove()

Myeonghun Pak <mhun512@gmail.com>
    media: radio-si476x: Unregister v4l2_device on probe failure

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

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: Fix use IRQF_NO_AUTOEN when requesting the IRQ

Marco Nenciarini <mnencia@kcore.it>
    media: intel/ipu6: Improve DWC PHY HSFREQRANGE band selection for overlapping ranges

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Martin Hecht <mhecht73@gmail.com>
    media: i2c: alvium: fix critical pointer access in alvium_ctrl_init

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

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Prevent shader BO mappings from becoming writable

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate vmw_surface_metadata::array_size

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix missing DCE check in dm_gpureset_toggle_interrupts()

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Shut down BO cache timer before teardown

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix flip-done timeouts on mode1 reset

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
    drm/amdgpu: Fix VFCT bus number matching with soft filter

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Release VFCT ACPI table reference

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: return error on truncated firmware

Matthew Brost <matthew.brost@intel.com>
    drm/ttm: Account for NULL and handle pages in ttm_pool_backup

Jason Macnak <natsu@google.com>
    drm/virtio: Don't detach GEM from a non-created context

Alex Deucher <alexander.deucher@amd.com>
    drm/gfx10: Program DB_RING_CONTROL

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu14 power limit range calculation

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: limit DP MST ESI service loop

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Do not leak siblings[] on proto context error

Shahyan Soltani <shahyan.soltani@amd.com>
    drm/amdgpu: fix lifetime issue of amdgpu_vm_get_task_info_pasid()

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: disable ASPM on VI if pcie dpm is disabled

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

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

Bryam Vargas <hexlabsecurity@proton.me>
    drm/virtio: bound EDID block reads to the response buffer

WenTao Liang <vulab@iscas.ac.cn>
    drm/amd/display: detect_link_and_local_sink: DP alt mode timeout path leaks prev_sink reference

Thomas Zimmermann <tzimmermann@suse.de>
    drm/amd/display: Handle struct drm_plane_state.ignore_damage_clips

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix 32-bit overflow in CWSR total size calculation

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on CRIU restore queue type and mqd size

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds in allocate_event_notification_slot

David Francis <David.Francis@amd.com>
    drm/amdkfd: Use kvcalloc to allocate arrays

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm/imagination: acquire vm_ctx->lock before mapping memory to GPU VM

Luigi Santivetti <luigi.santivetti@imgtec.com>
    drm/imagination: fix error checking of pvr_vm_context_lookup()

Shuvam Pandey <shuvampandey1@gmail.com>
    drm/imagination: Fix user array stride in pvr_set_uobj_array()

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix double call to drm_sched_entity_fini()

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe: Hold a dma-buf reference for imported BOs

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Fix PTE index in xe_vm_populate_pgtable() for chunked binds

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Return error on non-migratable faults requiring devmem

Pavel Ondračka <pavel.ondracka@gmail.com>
    drm/radeon: fix r100_copy_blit for large BOs

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Add missing nospec on parallel submit slot

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: fix Tiled Display Topology ID size

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Return errno code from drm_sysfb_get_visible_size()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Avoid possible truncation with calculating visible size

Junrui Luo <moonafterrain@outlook.com>
    drm/nouveau: fix reversed error cleanup order in ucopy functions

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: validate CP_GFX_SHADOW chunk size in CS pass1

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT

Jiqian Chen <Jiqian.Chen@amd.com>
    drm/amdgpu/gfx9: Fix Ring and IB test fail after mode2

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

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Fit paired fragment job in the correct CCCB

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix buffer overflows in sideband chunk accumulation

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers

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

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()

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

Gal Pressman <gal@nvidia.com>
    net/mlx5: Refactor EEPROM query error handling to return status separately

Runyu Xiao <runyu.xiao@seu.edu.cn>
    raw: annotate lockless match fields in raw_v4_match()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net: qrtr: restrict socket creation to the initial network namespace

Chenguang Zhao <zhaochenguang@kylinos.cn>
    hinic: remove unused ethtool RSS user configuration buffers

Eric Dumazet <edumazet@google.com>
    ppp: annotate data races in ppp_generic

Eric Dumazet <edumazet@google.com>
    ipv4: icmp: fill flow parameters in icmp_route_lookup decoy lookup

Suman Ghosh <sumang@marvell.com>
    octeontx2-vf: set TC flower flag on MCAM entry allocation

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

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: cores: remove many xxx_SHIFT definitions

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: socfpga: Add hardware supported cross-timestamp

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: socfpga: Enable TBS support for Agilex5

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: socfpga: Agilex5 EMAC platform configuration

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: remove xstats.pcs_* members

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bpf: tcp: fix double sock release on batch realloc

José Expósito <jose.exposito@redhat.com>
    drm/tests: shmem: Set DMA mask to 64-bit in drm_gem_shmem

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix u16 MTU truncation in media and bearer MTU validation

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

Michael Walle <mwalle@kernel.org>
    net: dpaa: fix mode setting

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

Christian Brauner <brauner@kernel.org>
    ovl: port ovl_copyfile() to cred guard

Christian Brauner <brauner@kernel.org>
    ovl: add override_creds cleanup guard extension for overlayfs

Christian Brauner <brauner@kernel.org>
    cred: add scoped_with_kernel_creds()

Julian Braha <julianbraha@gmail.com>
    drm/panel: s6e3ha8: fix unmet dependency on DRM_DISPLAY_HELPER

Yichong Chen <chenyichong@uniontech.com>
    ovl: fix trusted xattr escape prefix matching

Shelley Yang <shelley.yang@infineon.com>
    wifi: brcmfmac: fix 802.1X-SHA256 call trace warning

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: fix crash in reset link replay

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

Qingfang Deng <dqfext@gmail.com>
    ppp: don't store tx skb in the fastpath

Qingfang Deng <dqfext@gmail.com>
    ppp: enable TX scatter-gather

Helen Koike <koike@igalia.com>
    tipc: fix infinite loop in __tipc_nl_compat_dumpit

Xiang Mei (Microsoft) <xmei5@asu.edu>
    nexthop: initialize extack in nh_res_bucket_migrate()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    gtp: check skb_pull_data() return in gtp1u_send_echo_resp()

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

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call net_enable_timestamp() before failure in sk_clone().

Kuniyuki Iwashima <kuniyu@google.com>
    soreuseport: Clear sk_reuseport_cb before failure in sk_clone().

Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>
    amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN

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

David Lee <david.lee@trailofbits.com>
    net/packet: avoid fanout hook re-registration after unregister

Danielle Ratson <danieller@nvidia.com>
    netlink: specs: rt-link: convert bridge port flag attributes to u8

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

Yichong Chen <chenyichong@uniontech.com>
    smb: client: validate DFS referral PathConsumed

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) add missed handle for ENOMEM

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix EC read intervals

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix looping over banks while reading from EC

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

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Don't use devres to unregister component

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI

Guangshuo Li <lgs201920130244@gmail.com>
    ALSA: hda: cs35l41: validate and free ACPI mute object

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

Ruoyu Wang <ruoyuw560@gmail.com>
    firewire: net: Fix fragmented datagram reassembly

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    wifi: ath12k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()

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

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/wopcm: fix WOPCM size for LNL+

Matthew Brost <matthew.brost@intel.com>
    drm/xe/vf: Fix VF CCS attach/detach race with in-flight BO moves

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/vf: Shadow buffer management for CCS read/write operations

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/sa: Shadow buffer support in the sub-allocator pool

Michał Winiarski <michal.winiarski@intel.com>
    drm/xe: Allow the caller to pass guc_buf_cache size

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

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw: add locking for raw flags bitfield

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/i915/gt: use correct selftest config symbol

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: handle overlapping allocated ranges in fallocate

Ruoyu Wang <ruoyuw560@gmail.com>
    Bluetooth: hci_qca: Clear memdump state on invalid dump size

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Make cpufreq_update_pressure() fall back to cpuinfo.max_freq

Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>
    firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context

Uday Khare <udaykhare77@gmail.com>
    ASoC: tas2562: fix deprecated 'shut-down' GPIO always cleared after lookup

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Correct report for forced microphone jack

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
    wifi: mac80211: free AP_VLAN bc_buf SKBs outside IRQ lock

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: avoid non-S1G AID fallback for S1G assoc

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

Jacob Moroni <jmoroni@google.com>
    RDMA/umem: Add pinned revocable dmabuf import interface

Or Gerlitz <ogerlitz@ddn.com>
    RDMA/cma: Fix hardware address comparison length in netevent callback

Antony Antony <antony.antony@secunet.com>
    xfrm: reject optional IPTFS templates in outbound policies

Tejun Heo <tj@kernel.org>
    sched_ext: Don't warn on core-sched forced idle in put_prev_task_scx()

John Stultz <jstultz@google.com>
    sched/ext: Avoid null ptr traversal when ->put_prev_task() is called with NULL next

Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
    firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()

Boris Burkov <boris@bur.io>
    btrfs: fallback to transaction csum tree on a commit root csum miss

Filipe Manana <fdmanana@suse.com>
    btrfs: use bool type for btrfs_path members used as booleans

Filipe Manana <fdmanana@suse.com>
    btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()

Xiang Mei <xmei5@asu.edu>
    btrfs: reject free space cache with more entries than pages

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: mtk-ecc: stop on ECC idle timeouts

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: mtdswap: remove debugfs stats file on teardown

Michael Bommarito <michael.bommarito@gmail.com>
    IB/mad: Drop unmatched RMPP responses before reassembly

Seth Forshee <sforshee@nvidia.com>
    firmware: arm_ffa: Respect firmware advertised RX/TX buffer size limits

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: fix stale skb->prev after async crypto steals a GSO segment

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: propagate -EINPROGRESS from validate_xmit_xfrm()

Eric Dumazet <edumazet@google.com>
    net: plumb drop reasons to __dev_queue_xmit()

Eric Dumazet <edumazet@google.com>
    net: dropreason: add SKB_DROP_REASON_RECURSION_LIMIT

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234

Akhil R <akhilrajeev@nvidia.com>
    arm64: tegra: Remove fallback compatible for GPCDMA

Junxi Qian <qjx1298677004@gmail.com>
    fuse: fix writeback array overflow when max_pages is one

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix logic error in packet reset

Seungjin Bae <eeodqql09@gmail.com>
    Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Clear receive-side ownership pointers on release

Mikko Perttunen <mperttunen@nvidia.com>
    crypto: tegra - Don't touch bo refcount in host1x bo pin/unpin

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    dmaengine: sh: rz-dmac: Move interrupt request after everything is set up

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: track a single source interface for ANYDEV timeout/throttle ops

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix data race on rx_stamp/rx_ifindex in bcm_rx_handler()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix stale rx/tx ops after device removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing device refcount for CAN filter removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: validate frame length in bcm_rx_setup() for RTR replies

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: extend bcm_tx_lock usage for data and timer updates

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix CAN frame rx/tx statistics

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking when updating filter and timer values

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

Peter Zijlstra <peterz@infradead.org>
    seqlock: Allow KASAN to fail optimizing

Peter Zijlstra <peterz@infradead.org>
    seqlock: Cure some more scoped_seqlock() optimization fails

Kiryl Shutsemau <kas@kernel.org>
    fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race

Ryosuke Yasuoka <ryasuoka@redhat.com>
    drm/virtio: fix deadlock in display_info_cb by removing hotplug from dequeue worker

Brian Witte <brianwitte@mailfence.com>
    netfilter: nf_tables: revert commit_mutex usage in reset path

Brian Witte <brianwitte@mailfence.com>
    netfilter: nft_quota: use atomic64_xchg for reset

Brian Witte <brianwitte@mailfence.com>
    netfilter: nft_counter: serialize reset with spinlock

Daniel Borkmann <daniel@iogearbox.net>
    selftests/bpf: Add tests for ld_{abs,ind} failure path in subprogs

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix ld_{abs,ind} failure path analysis in subprogs

Guixiong Wei <weiguixiong@bytedance.com>
    platform/x86/intel-uncore-freq: Fix current_freq_khz after CPU hotplug


-------------

Diffstat:

 Documentation/gpu/drm-mm.rst                       |   10 +-
 Documentation/netlink/specs/rt-link.yaml           |   40 +-
 MAINTAINERS                                        |   13 +
 Makefile                                           |    9 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   24 +-
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |    2 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   12 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   32 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   77 +-
 arch/arm64/include/asm/esr.h                       |    2 +-
 arch/arm64/mm/hugetlbpage.c                        |    2 +-
 arch/loongarch/kernel/acpi.c                       |   27 +-
 arch/loongarch/kernel/kgdb.c                       |    3 +-
 arch/loongarch/kernel/machine_kexec.c              |    5 +-
 arch/loongarch/kernel/setup.c                      |    3 +-
 arch/loongarch/kernel/smp.c                        |    4 +-
 arch/powerpc/kernel/time.c                         |   43 +
 arch/powerpc/platforms/85xx/common.c               |    2 +
 arch/riscv/include/asm/kvm_host.h                  |   10 +-
 arch/riscv/kernel/sys_hwprobe.c                    |    1 +
 arch/riscv/kvm/aia.c                               |   35 +-
 arch/riscv/kvm/vcpu.c                              |   68 +-
 arch/riscv/kvm/vcpu_onereg.c                       |    8 +-
 arch/s390/lib/csum-partial.c                       |    2 +-
 arch/x86/boot/compressed/Makefile                  |    1 +
 arch/x86/kernel/cpu/resctrl/core.c                 |   32 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   18 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   36 +-
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/mmu/mmu.c                             |   11 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   10 +-
 arch/x86/kvm/svm/svm.c                             |    7 +-
 arch/x86/kvm/vmx/nested.c                          |   11 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |    8 +
 drivers/accel/ivpu/ivpu_hw_btrs.c                  |    2 +-
 drivers/android/binder/thread.rs                   |   14 +-
 drivers/ata/libata-core.c                          |   18 +
 drivers/ata/libata-scsi.c                          |    2 -
 drivers/ata/libata.h                               |    9 +
 drivers/ata/sata_dwc_460ex.c                       |   38 +-
 drivers/block/rbd.c                                |    7 +-
 drivers/block/ublk_drv.c                           |   52 +-
 drivers/bluetooth/btqca.c                          |    2 +-
 drivers/bluetooth/btusb.c                          |    4 +-
 drivers/bluetooth/hci_qca.c                        |    4 +
 drivers/cdrom/cdrom.c                              |    1 +
 drivers/comedi/drivers/comedi_parport.c            |   13 +-
 drivers/cpufreq/cpufreq.c                          |    3 +
 drivers/crypto/tegra/tegra-se-main.c               |    3 +-
 drivers/cxl/Kconfig                                |    4 +
 drivers/cxl/core/Makefile                          |    2 +-
 drivers/cxl/core/core.h                            |   31 +
 drivers/cxl/core/pci.c                             |  215 +---
 drivers/cxl/core/ras.c                             |  197 ++-
 drivers/cxl/core/trace.h                           |   24 +-
 drivers/cxl/cxl.h                                  |   22 +-
 drivers/cxl/cxlpci.h                               |   16 +
 drivers/dma-buf/udmabuf.c                          |    9 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |    7 +-
 drivers/dma/sh/rz-dmac.c                           |   96 +-
 drivers/dpll/dpll_netlink.c                        |    3 +
 drivers/firewire/net.c                             |   37 +-
 drivers/firmware/arm_ffa/driver.c                  |   54 +-
 drivers/firmware/arm_scmi/notify.c                 |    6 +-
 drivers/firmware/stratix10-svc.c                   |   10 +-
 drivers/firmware/xilinx/zynqmp.c                   |    1 +
 drivers/gpu/Kconfig                                |   13 +
 drivers/gpu/Makefile                               |    4 +-
 drivers/gpu/buddy.c                                | 1347 ++++++++++++++++++++
 drivers/gpu/drm/Kconfig                            |    5 +-
 drivers/gpu/drm/Kconfig.debug                      |    1 -
 drivers/gpu/drm/Makefile                           |    1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   62 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |    6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_res_cursor.h     |   12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   54 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   58 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   79 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h       |   20 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   22 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |    3 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   49 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   11 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |    2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |    2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |    4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/soc24.c                 |   28 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   15 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   12 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |    6 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |    2 +
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |    3 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    3 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   23 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  374 +++---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   81 +-
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |    9 +-
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |    9 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |    5 +-
 .../display/dc/resource/dce100/dce100_resource.c   |    7 +-
 .../amd/display/modules/info_packet/info_packet.c  |    2 -
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   26 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |    7 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   11 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   15 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   28 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |   11 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   36 +-
 drivers/gpu/drm/drm_buddy.c                        | 1278 +------------------
 drivers/gpu/drm/drm_connector.c                    |   12 +-
 drivers/gpu/drm/drm_displayid_internal.h           |    2 +-
 drivers/gpu/drm/drm_gpusvm.c                       |    4 +-
 drivers/gpu/drm/drm_panel_backlight_quirks.c       |    9 +
 drivers/gpu/drm/i915/display/intel_bios.c          |   36 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |    8 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   12 +-
 drivers/gpu/drm/i915/display/skl_watermark.c       |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   25 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |    3 +-
 drivers/gpu/drm/i915/gt/intel_engine_user.c        |    2 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |    8 +-
 drivers/gpu/drm/i915/i915_active.c                 |    7 +-
 drivers/gpu/drm/i915/i915_scatterlist.c            |   10 +-
 drivers/gpu/drm/i915/i915_ttm_buddy_manager.c      |   59 +-
 drivers/gpu/drm/i915/i915_ttm_buddy_manager.h      |    4 +-
 .../gpu/drm/i915/selftests/intel_memory_region.c   |   20 +-
 drivers/gpu/drm/imagination/pvr_context.c          |   22 +-
 drivers/gpu/drm/imagination/pvr_drv.c              |   13 +-
 drivers/gpu/drm/imagination/pvr_queue.c            |   65 +-
 drivers/gpu/drm/imagination/pvr_queue.h            |    2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |    2 +
 drivers/gpu/drm/nouveau/nouveau_exec.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |    4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c     |    1 +
 drivers/gpu/drm/panel/Kconfig                      |    1 +
 drivers/gpu/drm/panthor/panthor_device.c           |    5 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |    1 +
 drivers/gpu/drm/radeon/r100.c                      |   13 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |   18 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |    2 +
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |    2 +
 drivers/gpu/drm/sysfb/drm_sysfb_helper.h           |    2 +-
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c      |   13 +-
 drivers/gpu/drm/sysfb/efidrm.c                     |    7 +-
 drivers/gpu/drm/sysfb/vesadrm.c                    |    6 +-
 drivers/gpu/drm/tests/Makefile                     |    1 -
 drivers/gpu/drm/tests/drm_exec_test.c              |    2 -
 drivers/gpu/drm/tests/drm_gem_shmem_test.c         |   16 +-
 drivers/gpu/drm/tests/drm_mm_test.c                |    2 -
 drivers/gpu/drm/tidss/tidss_encoder.c              |    2 +
 drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c   |    4 +-
 drivers/gpu/drm/ttm/tests/ttm_mock_manager.c       |   18 +-
 drivers/gpu/drm/ttm/tests/ttm_mock_manager.h       |    4 +-
 drivers/gpu/drm/ttm/ttm_pool.c                     |   34 +-
 drivers/gpu/drm/v3d/v3d_gem.c                      |   12 +
 drivers/gpu/drm/vc4/vc4_bo.c                       |   12 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   14 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |    5 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |   22 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   58 +-
 drivers/gpu/drm/xe/xe_bo.h                         |    3 +-
 drivers/gpu/drm/xe/xe_bo_types.h                   |    2 +
 drivers/gpu/drm/xe/xe_dma_buf.c                    |    2 +-
 drivers/gpu/drm/xe/xe_guc_buf.c                    |   44 +-
 drivers/gpu/drm/xe/xe_guc_buf.h                    |    1 +
 drivers/gpu/drm/xe/xe_i2c.c                        |    5 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |   62 +-
 drivers/gpu/drm/xe/xe_migrate.h                    |    4 +
 drivers/gpu/drm/xe/xe_pt.c                         |   14 +-
 drivers/gpu/drm/xe/xe_res_cursor.h                 |   34 +-
 drivers/gpu/drm/xe/xe_sa.c                         |   67 +-
 drivers/gpu/drm/xe/xe_sa.h                         |   20 +-
 drivers/gpu/drm/xe/xe_sa_types.h                   |    3 +
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.c               |   42 +-
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.h               |    4 +-
 drivers/gpu/drm/xe/xe_svm.c                        |   18 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c               |   71 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h         |    4 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   10 +-
 drivers/gpu/drm/xe/xe_wopcm.c                      |   15 +-
 drivers/gpu/host1x/bus.c                           |    4 +-
 drivers/gpu/tests/Makefile                         |    4 +
 .../drm_buddy_test.c => tests/gpu_buddy_test.c}    |  358 +++---
 .../{drm/lib/drm_random.c => tests/gpu_random.c}   |   18 +-
 .../{drm/lib/drm_random.h => tests/gpu_random.h}   |   18 +-
 drivers/hwmon/asus-ec-sensors.c                    |   18 +-
 drivers/hwmon/corsair-cpro.c                       |    1 +
 drivers/hwmon/corsair-psu.c                        |    1 +
 drivers/hwmon/gigabyte_waterforce.c                |    4 +-
 drivers/hwmon/nzxt-kraken3.c                       |    6 +-
 drivers/hwmon/nzxt-smart2.c                        |    2 +-
 drivers/hwmon/occ/common.c                         |   38 +-
 drivers/hwtracing/intel_th/core.c                  |   10 -
 drivers/hwtracing/intel_th/msu.c                   |    2 +
 drivers/i3c/master/mipi-i3c-hci/core.c             |   16 +-
 drivers/i3c/master/mipi-i3c-hci/hci.h              |    1 +
 drivers/infiniband/core/cma.c                      |    2 +-
 drivers/infiniband/core/mad.c                      |   30 +
 drivers/infiniband/core/umem_dmabuf.c              |   61 +
 drivers/infiniband/hw/erdma/erdma_qp.c             |    2 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |    2 +-
 drivers/infiniband/hw/irdma/uk.c                   |    9 +-
 drivers/infiniband/hw/irdma/user.h                 |    1 -
 drivers/infiniband/hw/irdma/verbs.c                |   33 +-
 drivers/infiniband/hw/mana/wr.c                    |    2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |   44 +-
 drivers/input/misc/ims-pcu.c                       |   32 +-
 drivers/iommu/amd/init.c                           |    6 +
 drivers/iommu/amd/iommu.c                          |   22 +-
 drivers/iommu/intel/perf.c                         |    2 +-
 drivers/iommu/intel/svm.c                          |    2 +-
 drivers/md/dm-verity-fec.c                         |  110 +-
 drivers/md/dm-verity-fec.h                         |    6 +-
 drivers/md/dm.c                                    |   11 +-
 drivers/media/cec/platform/seco/seco-cec.c         |    6 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   12 +-
 drivers/media/dvb-frontends/rtl2832.c              |    4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   19 +-
 drivers/media/i2c/alvium-csi2.c                    |   21 +-
 drivers/media/i2c/imx219.c                         |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   14 +-
 drivers/media/pci/dm1105/dm1105.c                  |    1 +
 drivers/media/pci/intel/ipu6/ipu6-isys-dwc-phy.c   |   24 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   25 +-
 .../media/platform/amlogic/c3/isp/c3-isp-params.c  |    4 +
 drivers/media/platform/aspeed/aspeed-video.c       |    1 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |   29 +-
 drivers/media/platform/marvell/cafe-driver.c       |    1 +
 drivers/media/platform/nuvoton/npcm-video.c        |   34 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-core.c    |    2 +
 .../media/platform/nxp/imx8-isi/imx8-isi-core.h    |   16 +
 .../platform/nxp/imx8-isi/imx8-isi-crossbar.c      |    1 +
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c  |    9 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c |   11 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-pipe.c    |   20 +-
 drivers/media/platform/qcom/camss/camss-csid-680.c |   30 +-
 .../media/platform/qcom/camss/camss-csid-gen2.c    |   47 +-
 .../media/platform/qcom/camss/camss-csid-gen3.c    |   28 +-
 drivers/media/platform/qcom/iris/iris_probe.c      |    6 +-
 .../platform/renesas/rzg2l-cru/rzg2l-cru-regs.h    |    1 +
 .../media/platform/renesas/rzg2l-cru/rzg2l-video.c |   17 +-
 drivers/media/platform/st/stm32/stm32-dcmi.c       |    1 +
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c         |    6 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |    6 +-
 .../media/platform/synopsys/hdmirx/snps_hdmirx.c   |    4 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |    2 +-
 drivers/media/platform/ti/vpe/vpe.c                |    3 +-
 drivers/media/platform/verisilicon/hantro_v4l2.c   |    6 +-
 drivers/media/radio/radio-si476x.c                 |    1 +
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |    4 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |    1 +
 drivers/media/test-drivers/vivid/vivid-core.c      |    6 +-
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |   15 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   38 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.h   |    1 +
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |    6 +
 drivers/media/usb/airspy/airspy.c                  |    8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   16 +-
 drivers/media/usb/msi2500/msi2500.c                |   32 +-
 drivers/media/usb/pwc/pwc-if.c                     |   13 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   13 +
 drivers/media/v4l2-core/v4l2-ctrls-request.c       |   14 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |    6 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    4 +
 drivers/misc/mei/bus.c                             |   16 +-
 drivers/misc/nsm.c                                 |    3 +-
 drivers/mmc/host/vub300.c                          |   24 +-
 drivers/mtd/maps/vmu-flash.c                       |    8 +-
 drivers/mtd/mtdcore.c                              |   23 +-
 drivers/mtd/mtdswap.c                              |    5 +-
 drivers/mtd/nand/ecc-mtk.c                         |   16 +-
 drivers/net/amt.c                                  |  101 +-
 drivers/net/bonding/bond_main.c                    |    3 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |    3 +-
 drivers/net/ethernet/airoha/airoha_npu.c           |    4 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |    1 +
 drivers/net/ethernet/amd/pds_core/adminq.c         |   12 +-
 drivers/net/ethernet/amd/pds_core/auxbus.c         |   17 +-
 drivers/net/ethernet/amd/pds_core/core.c           |   22 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |    6 +
 drivers/net/ethernet/amd/pds_core/main.c           |   14 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   11 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |    1 +
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   17 +-
 drivers/net/ethernet/google/gve/gve.h              |    3 +
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   34 +
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   11 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |    2 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |   21 -
 drivers/net/ethernet/intel/ice/ice.h               |    3 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |    3 -
 drivers/net/ethernet/intel/ice/ice_lag.c           |    2 +-
 drivers/net/ethernet/intel/ice/ice_parser.c        |    3 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |    7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   14 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |    9 +
 .../net/ethernet/marvell/octeontx2/af/rvu_rep.c    |    8 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |    1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   15 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    4 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   39 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   78 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   13 +
 .../ethernet/netronome/nfp/nfpcore/nfp_resource.c  |    3 +
 drivers/net/ethernet/realtek/rtase/rtase.h         |    8 +
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |  197 +++
 drivers/net/ethernet/stmicro/stmmac/common.h       |    3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   31 +
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |    5 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  162 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac100.h     |    9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   16 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   49 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |   16 +-
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |    3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   49 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   53 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   44 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   16 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |   10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   10 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   34 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   45 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   75 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   92 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   35 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |    1 +
 drivers/net/geneve.c                               |    3 +
 drivers/net/gtp.c                                  |   17 +-
 drivers/net/ipa/ipa_smp2p.c                        |   30 +-
 drivers/net/mctp/mctp-i3c.c                        |   11 +-
 drivers/net/mctp/mctp-serial.c                     |    2 +-
 drivers/net/ovpn/io.c                              |    4 +-
 drivers/net/ovpn/peer.c                            |   16 +-
 drivers/net/ovpn/tcp.c                             |    6 +-
 drivers/net/pcs/pcs-xpcs.c                         |   34 +-
 drivers/net/phy/marvell.c                          |    2 +-
 drivers/net/ppp/ppp_generic.c                      |  239 ++--
 drivers/net/ppp/pppoe.c                            |    1 +
 drivers/net/slip/slip.c                            |    4 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   22 +-
 drivers/net/vxlan/vxlan_core.c                     |    3 +
 drivers/net/vxlan/vxlan_mdb.c                      |   30 +-
 drivers/net/wan/wanxl.c                            |    3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    3 +
 drivers/net/wireless/ath/ath11k/pci.c              |    4 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   11 +-
 drivers/net/wireless/ath/ath12k/pci.c              |    4 +
 drivers/net/wireless/ath/ath6kl/txrx.c             |   12 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   20 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    7 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    9 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   10 +
 drivers/net/wireless/intersil/p54/txrx.c           |    8 +
 drivers/net/wireless/marvell/libertas/firmware.c   |    1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   14 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    6 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   19 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |    5 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |    1 +
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |    8 +-
 drivers/platform/loongarch/loongson-laptop.c       |    1 +
 .../uncore-frequency/uncore-frequency-common.c     |    7 +-
 drivers/pmdomain/imx/imx93-blk-ctrl.c              |  126 +-
 drivers/ptp/ptp_netc.c                             |    1 +
 drivers/ptp/ptp_s390.c                             |    6 +-
 drivers/regulator/mt6358-regulator.c               |    2 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |   50 +-
 drivers/scsi/hosts.c                               |    2 +
 drivers/scsi/scsi_error.c                          |   22 +-
 drivers/scsi/scsi_priv.h                           |    1 +
 drivers/staging/media/meson/vdec/vdec.c            |    4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |    6 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |    3 +
 drivers/staging/media/tegra-video/vi.c             |    4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |    9 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |    2 +-
 drivers/thunderbolt/debugfs.c                      |    2 +
 drivers/thunderbolt/domain.c                       |   30 +
 drivers/thunderbolt/icm.c                          |    5 +
 drivers/thunderbolt/switch.c                       |   14 +
 drivers/thunderbolt/tb.c                           |   59 +-
 drivers/thunderbolt/tb.h                           |    2 +
 drivers/thunderbolt/xdomain.c                      |  100 +-
 drivers/tty/serial/8250/8250_mid.c                 |   14 +-
 drivers/tty/serial/sc16is7xx.c                     |   12 +
 drivers/uio/uio_hv_generic.c                       |    8 +-
 drivers/usb/atm/ueagle-atm.c                       |   17 +
 drivers/usb/chipidea/core.c                        |    1 +
 drivers/usb/core/port.c                            |    2 +
 drivers/usb/core/sysfs.c                           |    8 +-
 drivers/usb/gadget/function/f_midi.c               |    1 +
 drivers/usb/gadget/function/f_ncm.c                |   17 +-
 drivers/usb/gadget/function/f_printer.c            |   23 +-
 drivers/usb/gadget/function/f_tcm.c                |  192 ++-
 drivers/usb/gadget/function/tcm.h                  |   13 +
 drivers/usb/gadget/function/uvc_v4l2.c             |    2 +
 drivers/usb/gadget/udc/bdc/bdc_core.c              |   20 +
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |    7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   40 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   93 +-
 drivers/usb/gadget/udc/fsl_usb2_udc.h              |    1 +
 drivers/usb/gadget/udc/snps_udc_core.c             |    1 -
 drivers/usb/host/xhci-pci.c                        |    1 +
 drivers/usb/host/xhci.c                            |   15 +-
 drivers/usb/host/xhci.h                            |    1 +
 drivers/usb/musb/omap2430.c                        |    2 -
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    5 +
 drivers/usb/serial/io_edgeport.c                   |    3 +-
 drivers/usb/serial/keyspan_pda.c                   |   44 +-
 drivers/usb/serial/option.c                        |    1 +
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/typec/ucsi/ucsi.c                      |  158 ++-
 drivers/vdpa/vdpa_user/iova_domain.c               |   29 +-
 drivers/vdpa/vdpa_user/iova_domain.h               |    8 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  112 +-
 drivers/vhost/net.c                                |    8 +-
 drivers/video/Kconfig                              |    1 +
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c      |    2 +-
 drivers/watchdog/airoha_wdt.c                      |    3 +
 drivers/watchdog/s32g_wdt.c                        |    3 +-
 drivers/watchdog/watchdog_pretimeout.c             |    2 +
 fs/afs/dir_edit.c                                  |    2 +-
 fs/binfmt_elf_fdpic.c                              |    4 +
 fs/binfmt_misc.c                                   |    5 +-
 fs/btrfs/backref.c                                 |   16 +-
 fs/btrfs/block-group.c                             |    8 +-
 fs/btrfs/ctree.c                                   |   28 +-
 fs/btrfs/ctree.h                                   |   16 +-
 fs/btrfs/defrag.c                                  |    4 +-
 fs/btrfs/dev-replace.c                             |    4 +-
 fs/btrfs/extent-tree.c                             |    8 +-
 fs/btrfs/extent_io.c                               |    4 +-
 fs/btrfs/extent_map.c                              |    4 +-
 fs/btrfs/file-item.c                               |   38 +-
 fs/btrfs/free-space-cache.c                        |    7 +-
 fs/btrfs/free-space-tree.c                         |    4 +-
 fs/btrfs/inode-item.c                              |    2 +-
 fs/btrfs/inode.c                                   |    4 +-
 fs/btrfs/qgroup.c                                  |    4 +-
 fs/btrfs/raid-stripe-tree.c                        |    4 +-
 fs/btrfs/relocation.c                              |   10 +-
 fs/btrfs/scrub.c                                   |   20 +-
 fs/btrfs/send.c                                    |   14 +-
 fs/btrfs/tree-log.c                                |   20 +-
 fs/btrfs/volumes.c                                 |    6 +-
 fs/btrfs/xattr.c                                   |    2 +-
 fs/ceph/addr.c                                     |    9 +
 fs/ceph/caps.c                                     |    1 +
 fs/ceph/dir.c                                      |    7 +-
 fs/ceph/ioctl.c                                    |    6 +
 fs/crypto/inline_crypt.c                           |   57 +-
 fs/crypto/keysetup_v1.c                            |    8 +-
 fs/exec.c                                          |    2 +-
 fs/f2fs/super.c                                    |   25 +-
 fs/fuse/dev_uring.c                                |   22 +-
 fs/fuse/file.c                                     |    5 +-
 fs/iomap/buffered-io.c                             |   34 +-
 fs/nfsd/nfs4xdr.c                                  |    8 +-
 fs/nfsd/vfs.c                                      |   15 +-
 fs/nfsd/vfs.h                                      |    2 +-
 fs/overlayfs/copy_up.c                             |   12 +-
 fs/overlayfs/file.c                                |   47 +-
 fs/overlayfs/overlayfs.h                           |    5 +
 fs/overlayfs/xattrs.c                              |    2 +-
 fs/posix_acl.c                                     |    7 +
 fs/proc/namespaces.c                               |    4 +-
 fs/proc/task_mmu.c                                 |   14 +-
 fs/resctrl/ctrlmondata.c                           |    6 +-
 fs/resctrl/internal.h                              |   22 +-
 fs/resctrl/monitor.c                               |  200 +--
 fs/resctrl/rdtgroup.c                              |   75 +-
 fs/smb/client/misc.c                               |   34 +-
 fs/smb/client/smb2file.c                           |   21 +
 fs/smb/client/smb2inode.c                          |   23 +-
 fs/smb/client/smb2ops.c                            |   25 +-
 fs/smb/server/oplock.c                             |    6 +-
 fs/smb/server/smb2misc.c                           |    5 +
 fs/smb/server/smb2pdu.c                            |    9 +-
 fs/smb/server/smbacl.c                             |   42 +-
 fs/super.c                                         |   34 +-
 fs/xfs/scrub/cow_repair.c                          |  203 +--
 fs/xfs/scrub/trace.h                               |   28 +-
 include/drm/drm_buddy.h                            |  165 +--
 include/drm/drm_connector.h                        |    6 +-
 include/drm/drm_utils.h                            |    1 +
 include/linux/arm_ffa.h                            |    2 +-
 include/linux/audit.h                              |    6 +-
 include/linux/audit_arch.h                         |   12 +-
 include/linux/bootconfig.h                         |    3 +
 include/linux/cred.h                               |   15 +
 include/linux/firmware/xlnx-zynqmp.h               |   13 +
 include/linux/fscrypt.h                            |   18 +-
 include/linux/gpu_buddy.h                          |  177 +++
 include/linux/mlx5/mlx5_ifc.h                      |   13 +-
 include/linux/resctrl.h                            |   28 +-
 include/linux/seqlock.h                            |   10 +-
 include/linux/sunrpc/svcsock.h                     |    3 +
 include/linux/sunrpc/xdr.h                         |   19 +-
 include/linux/virtio.h                             |    6 +-
 include/linux/vtime.h                              |    6 +
 include/media/v4l2-async.h                         |    4 +-
 include/media/videobuf2-core.h                     |    8 +-
 include/net/bluetooth/rfcomm.h                     |    3 +
 include/net/cfg80211.h                             |    2 +-
 include/net/dropreason-core.h                      |    3 +
 include/net/ip6_tunnel.h                           |    2 +-
 include/net/netfilter/nf_tables.h                  |   32 -
 include/net/netfilter/nft_fib.h                    |    2 -
 include/net/netfilter/nft_meta.h                   |    3 -
 include/net/sctp/structs.h                         |    3 +-
 include/net/tcp.h                                  |    2 +
 include/rdma/ib_umem.h                             |   19 +
 include/scsi/scsi_host.h                           |    3 +
 include/uapi/linux/btrfs.h                         |    2 +-
 init/Kconfig                                       |    3 +
 init/main.c                                        |   45 -
 io_uring/rw.c                                      |   42 +-
 kernel/audit.c                                     |    2 +-
 kernel/audit.h                                     |   32 +-
 kernel/audit_fsnotify.c                            |   36 +-
 kernel/audit_tree.c                                |    2 +-
 kernel/audit_watch.c                               |   35 +-
 kernel/auditfilter.c                               |   17 +-
 kernel/auditsc.c                                   |    6 +-
 kernel/bpf/verifier.c                              |   17 +
 kernel/kexec_handover.c                            |   32 +-
 kernel/sched/ext.c                                 |    9 +-
 kernel/trace/ftrace.c                              |   13 +
 kernel/trace/trace.c                               |    2 +-
 kernel/trace/trace_eprobe.c                        |    3 +-
 kernel/trace/trace_events.c                        |    4 +-
 kernel/trace/trace_mmiotrace.c                     |    4 +-
 kernel/trace/trace_probe.c                         |   13 +-
 lib/bootconfig.c                                   |   65 +
 lib/compat_audit.c                                 |   12 +-
 lib/rhashtable.c                                   |    1 +
 mm/damon/core.c                                    |   13 +
 mm/huge_memory.c                                   |   12 +-
 mm/kmemleak.c                                      |    7 +-
 mm/sparse.c                                        |   32 +-
 net/bluetooth/hci_sync.c                           |   55 +-
 net/bluetooth/mgmt.c                               |   86 +-
 net/bluetooth/rfcomm/core.c                        |   17 +
 net/bluetooth/rfcomm/tty.c                         |    7 +-
 net/bridge/br_netlink_tunnel.c                     |    3 +-
 net/bridge/br_private.h                            |    6 +-
 net/bridge/br_vlan.c                               |   10 +-
 net/bridge/br_vlan_options.c                       |    3 +-
 net/bridge/netfilter/nft_meta_bridge.c             |   20 -
 net/bridge/netfilter/nft_reject_bridge.c           |    1 -
 net/can/bcm.c                                      |  528 ++++++--
 net/can/j1939/transport.c                          |   18 +-
 net/can/raw.c                                      |   66 +-
 net/ceph/auth_x.c                                  |    9 +-
 net/ceph/ceph_common.c                             |    4 +-
 net/ceph/mon_client.c                              |    4 +-
 net/ceph/osdmap.c                                  |   12 +-
 net/core/dev.c                                     |  111 +-
 net/core/filter.c                                  |    6 +-
 net/core/gro.c                                     |    4 +-
 net/core/sock.c                                    |   10 +-
 net/core/sock_map.c                                |    2 +
 net/hsr/hsr_slave.c                                |    2 +
 net/ipv4/datagram.c                                |    4 +-
 net/ipv4/fib_trie.c                                |    2 +-
 net/ipv4/icmp.c                                    |   18 +-
 net/ipv4/ip_gre.c                                  |    4 +-
 net/ipv4/ip_tunnel_core.c                          |    2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |    1 -
 net/ipv4/netfilter/nft_fib_ipv4.c                  |    2 -
 net/ipv4/netfilter/nft_reject_ipv4.c               |    1 -
 net/ipv4/nexthop.c                                 |    2 +-
 net/ipv4/raw.c                                     |   23 +-
 net/ipv4/tcp_bpf.c                                 |    2 +-
 net/ipv4/tcp_input.c                               |   56 +-
 net/ipv4/tcp_ipv4.c                                |   14 +-
 net/ipv4/tcp_minisocks.c                           |   12 +-
 net/ipv6/ila/ila_common.c                          |   12 +
 net/ipv6/ip6_gre.c                                 |    4 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |    1 -
 net/ipv6/netfilter/nft_fib_ipv6.c                  |    2 -
 net/ipv6/netfilter/nft_reject_ipv6.c               |    1 -
 net/ipv6/raw.c                                     |    2 +-
 net/ipv6/route.c                                   |    4 +-
 net/ipv6/tcp_ipv6.c                                |    8 +-
 net/ipv6/xfrm6_policy.c                            |    1 +
 net/iucv/af_iucv.c                                 |   21 +-
 net/mac80211/cfg.c                                 |   11 +-
 net/mac80211/iface.c                               |    8 +-
 net/mac80211/link.c                                |    4 +
 net/mac80211/mlme.c                                |    6 +-
 net/mac80211/rx.c                                  |    2 +
 net/mac80211/sta_info.c                            |   15 +-
 net/mac802154/llsec.c                              |    5 +
 net/mac802154/scan.c                               |   11 +
 net/mctp/device.c                                  |    4 +-
 net/mpls/af_mpls.c                                 |    3 +
 net/mptcp/options.c                                |   12 +-
 net/mptcp/pm_userspace.c                           |    7 +-
 net/mptcp/protocol.c                               |    1 +
 net/netfilter/nf_conntrack_sip.c                   |   10 +-
 net/netfilter/nf_tables_api.c                      |  315 +----
 net/netfilter/nft_bitwise.c                        |  104 --
 net/netfilter/nft_byteorder.c                      |   11 -
 net/netfilter/nft_cmp.c                            |    3 -
 net/netfilter/nft_compat.c                         |   10 -
 net/netfilter/nft_connlimit.c                      |    1 -
 net/netfilter/nft_counter.c                        |   21 +-
 net/netfilter/nft_ct.c                             |   46 -
 net/netfilter/nft_dup_netdev.c                     |    1 -
 net/netfilter/nft_dynset.c                         |    1 -
 net/netfilter/nft_exthdr.c                         |   34 -
 net/netfilter/nft_fib.c                            |   51 +-
 net/netfilter/nft_fib_inet.c                       |    1 -
 net/netfilter/nft_fib_netdev.c                     |   30 +-
 net/netfilter/nft_flow_offload.c                   |    1 -
 net/netfilter/nft_fwd_netdev.c                     |    2 -
 net/netfilter/nft_hash.c                           |   36 -
 net/netfilter/nft_immediate.c                      |   12 -
 net/netfilter/nft_last.c                           |    1 -
 net/netfilter/nft_limit.c                          |    2 -
 net/netfilter/nft_log.c                            |    1 -
 net/netfilter/nft_lookup.c                         |   12 -
 net/netfilter/nft_masq.c                           |    3 -
 net/netfilter/nft_meta.c                           |   45 -
 net/netfilter/nft_nat.c                            |    2 -
 net/netfilter/nft_numgen.c                         |   22 -
 net/netfilter/nft_objref.c                         |    2 -
 net/netfilter/nft_osf.c                            |   25 -
 net/netfilter/nft_payload.c                        |   47 -
 net/netfilter/nft_queue.c                          |    2 -
 net/netfilter/nft_quota.c                          |   14 +-
 net/netfilter/nft_range.c                          |    1 -
 net/netfilter/nft_redir.c                          |    3 -
 net/netfilter/nft_reject_inet.c                    |    1 -
 net/netfilter/nft_reject_netdev.c                  |    1 -
 net/netfilter/nft_rt.c                             |    1 -
 net/netfilter/nft_socket.c                         |   26 -
 net/netfilter/nft_synproxy.c                       |    1 -
 net/netfilter/nft_tproxy.c                         |    1 -
 net/netfilter/nft_tunnel.c                         |   26 -
 net/netfilter/nft_xfrm.c                           |   27 -
 net/openvswitch/actions.c                          |   19 +-
 net/openvswitch/datapath.c                         |   25 +-
 net/openvswitch/datapath.h                         |    2 +-
 net/openvswitch/vport.c                            |    2 +-
 net/packet/af_packet.c                             |    6 +-
 net/phonet/pep.c                                   |    2 +
 net/qrtr/af_qrtr.c                                 |    8 +
 net/qrtr/ns.c                                      |    4 +-
 net/rds/recv.c                                     |   15 +
 net/rds/tcp.c                                      |    4 +-
 net/rxrpc/ar-internal.h                            |    6 +-
 net/sched/act_tunnel_key.c                         |   14 +-
 net/sctp/auth.c                                    |    2 +-
 net/sctp/protocol.c                                |   21 +-
 net/sctp/sm_make_chunk.c                           |    6 +
 net/sctp/sm_statefuns.c                            |    2 +-
 net/sctp/stream.c                                  |    6 +-
 net/sctp/sysctl.c                                  |    9 +-
 net/sunrpc/svcsock.c                               |   69 +-
 net/sunrpc/xdr.c                                   |  210 ++-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |    4 +
 net/sunrpc/xprtrdma/verbs.c                        |   12 +-
 net/tipc/netlink.c                                 |    6 +-
 net/tipc/netlink_compat.c                          |    4 +
 net/tipc/socket.c                                  |    1 +
 net/tls/tls_device.c                               |    6 +-
 net/vmw_vsock/virtio_transport_common.c            |  165 ++-
 net/wireless/core.c                                |    4 +-
 net/wireless/core.h                                |    2 +-
 net/wireless/nl80211.c                             |   22 +-
 net/wireless/pmsr.c                                |   29 +-
 net/wireless/scan.c                                |   13 +-
 net/x25/af_x25.c                                   |    8 +-
 net/xfrm/xfrm_device.c                             |   12 +-
 net/xfrm/xfrm_iptfs.c                              |    1 +
 net/xfrm/xfrm_policy.c                             |    4 +-
 net/xfrm/xfrm_state.c                              |    7 +-
 net/xfrm/xfrm_user.c                               |    3 +-
 rust/bindings/lib.rs                               |    4 +
 rust/kernel/device.rs                              |   16 +-
 rust/kernel/time.rs                                |   11 +-
 rust/uapi/lib.rs                                   |    4 +
 security/landlock/domain.c                         |    8 +-
 security/landlock/domain.h                         |    5 +-
 security/landlock/ruleset.c                        |    7 +-
 sound/core/seq/seq_timer.c                         |   13 +-
 sound/core/timer.c                                 |   21 +-
 sound/hda/codecs/hdmi/hdmi.c                       |    3 +
 sound/hda/codecs/hdmi/hdmi_local.h                 |    9 +
 sound/hda/codecs/hdmi/intelhdmi.c                  |   36 +-
 sound/hda/codecs/realtek/alc269.c                  |    9 +
 sound/hda/codecs/side-codecs/cs35l41_hda.c         |   11 +-
 sound/soc/amd/ps/pci-ps.c                          |   33 +-
 sound/soc/codecs/bt-sco.c                          |   10 +-
 sound/soc/codecs/cs35l56-i2c.c                     |    4 +-
 sound/soc/codecs/cs35l56-spi.c                     |    4 +-
 sound/soc/codecs/cs35l56.c                         |   25 +-
 sound/soc/codecs/cs42l43-jack.c                    |    3 +-
 sound/soc/codecs/tas2562.c                         |    5 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |   63 +-
 sound/soc/fsl/fsl_sai.c                            |   29 +-
 sound/soc/fsl/imx-card.c                           |   12 +-
 sound/soc/meson/aiu-fifo-spdif.c                   |    5 +
 sound/soc/sunxi/sun4i-codec.c                      |    1 +
 sound/usb/quirks.c                                 |    2 +
 tools/objtool/check.c                              |    1 +
 tools/testing/cxl/Kbuild                           |    2 +-
 tools/testing/selftests/alsa/mixer-test.c          |    1 +
 .../testing/selftests/bpf/progs/verifier_ld_ind.c  |  142 +++
 .../testing/selftests/bpf/progs/verifier_map_ptr.c |   36 +-
 tools/testing/selftests/drivers/net/settings       |    1 +
 tools/testing/selftests/drivers/ntsync/config      |    2 +-
 tools/testing/selftests/ftrace/ftracetest          |    1 +
 tools/testing/selftests/net/af_unix/config         |    1 +
 tools/testing/selftests/net/openvswitch/config     |   16 +
 tools/testing/selftests/net/ovpn/config            |    2 +
 tools/testing/selftests/net/ovpn/ovpn-cli.c        |    4 +-
 tools/testing/selftests/net/ovpn/settings          |    1 +
 776 files changed, 10812 insertions(+), 6601 deletions(-)


