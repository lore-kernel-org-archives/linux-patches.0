Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826766;
	b=HFmIkpzGA7AvzotAFxwMLKEEUrBsGGsDjuh635FPAc7XudsKwmbQkC8gpm3jOto+kMcL
	 fcuPtVii59fVd59nc6yNmKO8PZJxHaviDL8fxiaQShBouxaQ2tE96xZPTLCP3oYvQuXyi
	 mDAX/6glqBZLNMws/Hp6XmXwsNrmnoVv5eLgvN14y4u5dKcoH04xe13EdufPq/V4JZTAH
	 BK2Y98bjQRajuYGwCSFcWNRUT6zeLREylAO0ivfKIiZybbZ2pyjVyquB65D2GNX6rrNgj
	 iuYa93OSh+51NZpTBdF80aJddx65EV/+VEKyRaHyQtizuUKwliIbbI0wypvnOm6IgGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=k1C1ckgYpjMfvsAHr6bu1J0extPI3cQq9r3mEzdEqT0=;
	b=5tBXbtjMpJbJEPVLCe7ktdTEdiDrxgHRPShnDOWNhVjX9Mxu7y9lqHiCRI6COSjWMlZl
	 etv6V/5BbnLF7BItncUvreS3+VPV9S/Hyz1thBCyTfA9x19kQOv4r52t+3I12eJB1VhYX
	 fyl6v3po25x1/7KyFRD5bGTYnwZY+sY0xl+hpYPZfE3LHK9PwV5VCt1FiARl2qlbxGAzX
	 5I9fBW29UKpJeg14tXgB0J4GxV9hM3/ngAtAAVFGqWU1L2wMjmuGQDhZpOYqwRKBYWbd5
	 6kva+239w9RT+spl3pXnKoQt9AIc5kI4AFYsN64Xofr6Y16pozrlBzh3X/bzx9Smhgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irhnSQ+1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4EA60ABB1F;
	Wed,  4 Nov 2026 21:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irhnSQ+1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522101F00A15;
	Wed,  4 Nov 2026 21:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826765;
	bh=k1C1ckgYpjMfvsAHr6bu1J0extPI3cQq9r3mEzdEqT0=;
	h=From:To:Cc:Subject:Date;
	b=irhnSQ+1bTs04Y0DoNnNkC9NnfZW7ixoOi8IhkbznKiRJLDQwwibq/l1uAVlTH6cl
	 UGfWJUeo+QaBlE2BmxdTUJxGIjNqhjwHq9KYVUE94i7IGOEB0E1owZYfEuGUR7Dc+R
	 WZovGaQS62UroyzQ0m/eArdOZbu/1dKYdv1WcWnk=
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
Subject: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Date: Wed,  4 Nov 2026 15:55:33 -0500
Message-ID: <20261104211043.516122098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.61-rc1
X-KernelTest-Deadline: 2026-11-06T21:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.61 release.
There are 1005 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.61-rc1

Scott Gauche <scott-dev@scottgauche.com>
    ALSA: hda/realtek: Fix audio after Windows reboot on ASUS Q423SA

Peter Griffin <peter.griffin@linaro.org>
    opp: fix use after free in _update_opp_table_clk()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: always lower timeout for non-closing RST packets

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype

Alexander Atanasov <alex@zazolabs.com>
    selftests: ublk: add missing gitignore for metadata_size binary

Sean Young <sean@mess.org>
    media: rc: Fix build failure with CONFIG_LIRC disabled

Zi Yan <ziy@nvidia.com>
    mm/rmap: don't discard lazyfree THPs at PMD level

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: fix use-after-free when closing a removed device

Jori Koolstra <jkoolstra@xs4all.nl>
    pps: change pps_gen_class to a const struct

Yibo Tan <lhfff@tju.edu.cn>
    media: ipu-bridge: Fix use-after-free in IVSC error path

Ian Bridges <icb@fastmail.org>
    ksmbd: fix use-after-free after a failed durable reconnect

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: verify transform SessionId matches the decrypted header

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix named stream write and EOF handling

Ian Bridges <icb@fastmail.org>
    ksmbd: fix out-of-bounds read when padding the final compound response

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: use the existing xattr name for a named stream

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid pointer dereference when get_inode_acl() fails

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent stale data from being written by SMB2 WRITE requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent share root removal through empty paths

Ian Bridges <icb@fastmail.org>
    ksmbd: fix session reference leak on compounded SESSION_SETUP

Aamir Ahmed <elb12345@hotmail.co.uk>
    ksmbd: deny access for an empty DACL instead of granting the request

Mario Peter <mario.peter@leica-geosystems.com>
    driver core: take parent lock in async device attach

Vincent Liu <vincent.liu@nutanix.com>
    driver core: Check drivers_autoprobe for all added devices

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix early procfs exposure race

Zikang Gao <2715417602@qq.com>
    smb: client: do not pass a NULL buf to is_oplock_break()

Cheng Yongkang <teel4res@gmail.com>
    io_uring/net: fix multishot recv length limit accounting

Cheng Yongkang <teel4res@gmail.com>
    io_uring/timeout: count cancelled timeouts in cq_timeouts

Kyle Zeng <kylebot@openai.com>
    io_uring: defer foreign io-wq enqueues to task_work

Chris Mason <mason@kernel.org>
    io_uring/sqpoll: don't wait for the thread to exit

Chris Mason <mason@kernel.org>
    io_uring: free XArray nodes left by a failed store

Chris Mason <mason@kernel.org>
    io_uring: charge tctx nodes and personalities

Chris Mason <mason@kernel.org>
    io_uring/rsrc: charge buffer arrays and nodes to memcg

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: no new workers once the exit has begun

Daan De Meyer <daan@amutable.com>
    io_uring/net: don't retry a non-blocking connect() that fails with -EAGAIN

Yichong Chen <chenyichong@uniontech.com>
    io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT

Yichong Chen <chenyichong@uniontech.com>
    io_uring/kbuf: advance head when a pickup empties the buffer ring

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: fix buffer length underflow in RDMA transfers

Amir Goldstein <amir73il@gmail.com>
    ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN

Chris Mason <mason@kernel.org>
    ovl: do not copy up a dentry that was removed

Chris Mason <mason@kernel.org>
    ovl: hold a reference on the parent in readdir

Chris Mason <mason@kernel.org>
    ovl: check that the parents of volatile/dirty are dirs

Jiale Yao <yaojiale02@163.com>
    HID: roccat: savu: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: ryos: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: pyra: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: kovaplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: konepure: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: koneplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: isku: reject short button reports

Gabor Tanz <gabor.tanz@gmail.com>
    HID: quirks: Always poll the Anne Pro 2 with product ID a292

Jiale Yao <yaojiale02@163.com>
    HID: pxrc: reject short input reports

Jiale Yao <yaojiale02@163.com>
    HID: prodikeys: validate fixed-format MIDI reports

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    HID: picoLCD: check for fb_deferred_io_init() error

Jiale Yao <yaojiale02@163.com>
    HID: mcp2221: validate response report length

Jiale Yao <yaojiale02@163.com>
    HID: mcp2200: validate READ_ALL response length

Jiale Yao <yaojiale02@163.com>
    HID: logitech-dj: validate unnumbered keyboard reports

Jiale Yao <yaojiale02@163.com>
    HID: elo: reject short touchscreen reports

Jiale Yao <yaojiale02@163.com>
    HID: cp2112: validate response report lengths

Jiale Yao <yaojiale02@163.com>
    HID: cougar: reject short special-key reports

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix out-of-bounds left shift by 32 in s32ton()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Use report type from request node

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Remove unsupported motion-state field from accelerometer report

Jiale Yao <yaojiale02@163.com>
    HID: zydacron: validate key report length

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Enable Bus Lock VM exit

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Enable Notify VM exit

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Check if there is valid exit infos based on vp_enter_ret

Sean Christopherson <seanjc@google.com>
    KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak

Chengfeng Ye <nicoyip.dev@gmail.com>
    KVM: x86: Take SRCU in kvm_zap_gfn_range()

Loc Nguyen <loc@ryzome.com>
    KVM: x86: Request event processing for exception VM-Exits

Sean Christopherson <seanjc@google.com>
    KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload

Keqiang Duan <duankeqiangcym@gmail.com>
    KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Enforce 4-byte alignment of vcpu_info registration

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Make handle_bus_lock_vmexit() a shared helper

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Disallow using to_vmx() in common VT code

Sean Christopherson <seanjc@google.com>
    KVM: Use goto to handle errors during memslot preparation

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()

Sean Christopherson <seanjc@google.com>
    x86/cpuid: Mark CPUID function 0x23 as being indexed

David Howells <dhowells@redhat.com>
    rxrpc: Fix return in rxrpc_recvmsg_data() for service calls

David Howells <dhowells@redhat.com>
    rxrpc: Fix double IRQ enablement

David Howells <dhowells@redhat.com>
    afs: Fix afs to abort the rxrpc call on send error

David Howells <dhowells@redhat.com>
    rxrpc: Fix lack of short-send handling in rxrpc_kernel_send_data()

David Howells <dhowells@redhat.com>
    rxrpc: Fix update of call->tx_pending without holding lock

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Treat every TLS error alert as fatal

Ameer Hamza <ameer.hamza@truenas.com>
    sunrpc: treat empty auth.unix.gid replies as negative entries

Zhiling Zou <zhilinz@nebusec.ai>
    SUNRPC: trace an accepted transport before publishing it

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Resume receiving after a TLS control record

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject a TLS alert record that is not two octets

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject a socket that already has an svc_sock attached

Chris Mason <clm@meta.com>
    sunrpc: pin gss module across auth_domain RCU free

Jeff Layton <jlayton@kernel.org>
    SUNRPC: keep the first error in svc_register()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: fix oversized GSS proxy token copy

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Do not credit control-record octets to the RPC stream

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Copy the deferred RPC Call from the head buffer

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: zero NFSv4 COMPOUND tag padding

Jeff Layton <jlayton@kernel.org>
    NFSD: validate transport name in listener_set before serv creation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Set nn->cld_net before registering the cld pipe

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Resolve the recall-any mask names in the trace format

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reject an oversized principal hash from nfsdcld

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: propagate SETXATTR value decode errors

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nfsd: preflight SEQUENCE replies before accepting a slot

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Map flex file layout IDs through the request's user namespace

Chuck Lever <chuck.lever@oracle.com>
    NFSD: map fh_verify() status codes for NFS_ACLv3 replies

NeilBrown <neil@brown.name>
    nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    nfsd: hold cl_lock in client_has_openowners()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix out-of-bounds read in the rpc_status dump

Wentao Liang <vulab@iscas.ac.cn>
    nfsd: Fix id-to-name cache entry leak in idtoname_parse()

David Flynn <david.flynn@hammerspace.com>
    nfsd: fetch direct I/O alignment for files handed to the filecache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fail a pool_threads read whose reply does not fit

Ameer Hamza <ameer.hamza@truenas.com>
    nfsd: don't modify a session slot when replaying its cached reply

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Don't complete a cld upcall the daemon has not read

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    NFSD: copy SETXATTR data from all XDR buffer segments

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: clear XDR padding in GETXATTR replies

Jeff Layton <jlayton@kernel.org>
    NFSD: cap the number of listeners accepted in listener_set

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: report the stability a DIO WRITE actually has

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: fix nfs_local_dio_misaligned tracepoint

Jimmy Zuber <jamz@amazon.com>
    NFS: Fix stale negative cache on failed nfs_mkdir()

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Bound page coalescing on the absolute stripe offset

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Use the full 64-bit stripe_unit

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Use the full 64-bit offset for read DS selection

Benjamin Coddington <bcodding@hammerspace.com>
    NFSv4/flexfiles: fail I/O to the data server once a lock is lost

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/filelayout: Anchor page coalescing on pattern_offset

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: Free the netid when draining a data-server address list

Chuck Lever <chuck.lever@oracle.com>
    pnfs/blocklayout: Complete a device upcall when the pipe is closed

Chuck Lever <chuck.lever@oracle.com>
    pnfs/blocklayout: Complete a device upcall only on its own reply

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate NT transaction response layout and offsets

Dominik Maier <dmnk@google.com>
    smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: fix fiemap wild read on empty truncated response

Luxiao Xu <rakukuip@gmail.com>
    smb: client: fix buffer overflow in SMB2_tcon()

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't resurrect an exiting tcon from cached dir workers

VeroFess <coderzeng@hotmail.com>
    smb: server: size directory name conversion buffer correctly

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Adapt SRSO mitigation to Zen6

Darrick J. Wong <djwong@kernel.org>
    xfs: reattach dquots after changing inode ids

Darrick J. Wong <djwong@kernel.org>
    xfs: range-check bc_levels array access in scrub tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: propagate errors while checking null siblings

Darrick J. Wong <djwong@kernel.org>
    xfs: opportunistically skip btree block checks

Darrick J. Wong <djwong@kernel.org>
    xfs: only written file data blocks can be shared

Darrick J. Wong <djwong@kernel.org>
    xfs: never reset the default quota timer

Darrick J. Wong <djwong@kernel.org>
    xfs: init inode number for tracepoint

Darrick J. Wong <djwong@kernel.org>
    xfs: fix data fork block count check in xrep_inode_blockcounts

Darrick J. Wong <djwong@kernel.org>
    xfs: fix correction of unwritten extents in quota file data fork

Darrick J. Wong <djwong@kernel.org>
    xfs: don't try to scrub self-referential dirent in metapath checker

Darrick J. Wong <djwong@kernel.org>
    xfs: don't try to repair rtsummary if the summary file isn't computed

Darrick J. Wong <djwong@kernel.org>
    xfs: don't subtract excess usage twice when computing agf_btreeblks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't set a metadata directory's parent to sb_rootino

Darrick J. Wong <djwong@kernel.org>
    xfs: don't scan across metadata/regular directory trees for dirents

Darrick J. Wong <djwong@kernel.org>
    xfs: don't rescan ifree and icount when frozen

Darrick J. Wong <djwong@kernel.org>
    xfs: don't queue rmap update twice when reaping a fork

Darrick J. Wong <djwong@kernel.org>
    xfs: don't overrun incore inode when cleaning attr forks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't clear COWEXTSIZE on directories on reflink filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: don't allow sm_agno for non-group metadir path checking

Darrick J. Wong <djwong@kernel.org>
    xfs: complain loudly when dirtree checker finds broken links

Darrick J. Wong <djwong@kernel.org>
    xfs: clear set[ug]id mode bits when zapping attr fork

Darrick J. Wong <djwong@kernel.org>
    xfs: clarify various parts of the bitmap API

Darrick J. Wong <djwong@kernel.org>
    xfs: check for termination during rmap btree walk

Darrick J. Wong <djwong@kernel.org>
    xfs: check for fragments when full-extent sharing matches

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound inode fork length against the fork size during log recovery

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound da-node entry count against the correct geometry

Darrick J. Wong <djwong@kernel.org>
    xfs: always zero the whole shortform header when zeroing attr fork

Darrick J. Wong <djwong@kernel.org>
    xfs: always report scrub errors in tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: always report inode repair setup failures

Darrick J. Wong <djwong@kernel.org>
    xfs: always forget cached ACLs if the attr fork swap succeeds

Darrick J. Wong <djwong@kernel.org>
    xfs: abort directory tree repair whenever dl->aborted is set

Darrick J. Wong <djwong@kernel.org>
    xfs: update quota flags on secondary supers when metadir enabled

Darrick J. Wong <djwong@kernel.org>
    xfs: rescan the AGs if incore delalloc counter is negative

Darrick J. Wong <djwong@kernel.org>
    xfs: release ip after unlinked list store failure

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject remote xattr entries with an out-of-range value length

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value

Darrick J. Wong <djwong@kernel.org>
    xfs: reject absurdly large xattr value lengths in xchk_xattr_actor

Darrick J. Wong <djwong@kernel.org>
    xfs: reduce new btree slack factor if free space is negative

Aleksandr Nogikh <nogikh@google.com>
    media: usbtv: fix null-pointer dereference on disconnect

Johan Hovold <johan@kernel.org>
    media: usbtv: drop redundant device reference

Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
    Revert "net: Convert proto_ops bind() callbacks to use sockaddr_unsized"

Jean Delvare <jdelvare@suse.de>
    EDAC/mc: Really fix error path ordering in edac_mc_alloc()

Andrea Parri <parri.andrea@gmail.com>
    rtnetlink: wait for RCU readers in rtnl_link_unregister()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ksmbd: fix breaking_cnt leak on early return in oplock_break()

Yongjun Gwon <d3bugee@gmail.com>
    ksmbd: serialize directory emptiness checks with readdir

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix netdev hook allocation memleak with dormant tables

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: restrict checksum offsets to known values

Zhiling Zou <zhilinz@nebusec.ai>
    netfilter: validate L4 headers after userspace packet writes

Florian Westphal <fw@strlen.de>
    netfilter: nftables: restrict checkum update offset

Florian Westphal <fw@strlen.de>
    netfilter: nftables: restrict linklayer and network header writes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_meta: add double-tagged vlan and pppoe support

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: restrict writes to network header

Daniel Borkmann <daniel@iogearbox.net>
    ipv6: Implement limits on extension header parsing

Florian Westphal <fw@strlen.de>
    netfilter: disable payload mangling in userns

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Fix scx_flush_disable_work() UAF race

Richard Cheng <icheng@nvidia.com>
    sched_ext: sync disable_irq_work in bpf_scx_unreg()

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null

Darrick J. Wong <djwong@kernel.org>
    xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks

Darrick J. Wong <djwong@kernel.org>
    xfs: adjust checks for cross-AG reaping issues

Darrick J. Wong <djwong@kernel.org>
    xfs: cross-reference the primary superblock

Darrick J. Wong <djwong@kernel.org>
    xfs: jump out of xchk_bmap_check_rmap if fatal signals

Darrick J. Wong <djwong@kernel.org>
    xfs: mark overfull dabtree node blocks as corrupt

Darrick J. Wong <djwong@kernel.org>
    xfs: check fork type against dabtree block magic number

Darrick J. Wong <djwong@kernel.org>
    xfs: abort dirtree repair if the live update hook dies

Darrick J. Wong <djwong@kernel.org>
    xfs: fix revalidation of xchk_dquot_iter cached mappings

Darrick J. Wong <djwong@kernel.org>
    xfs: bail out of directory tree repairs on error

Darrick J. Wong <djwong@kernel.org>
    xfs: assign an owner to scrub_stats_fops

Darrick J. Wong <djwong@kernel.org>
    xfs: allow softlimit with no hardlimit in quota scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: fix lost errno returned from xfarray_foliosort

Darrick J. Wong <djwong@kernel.org>
    xfs: don't repair fs summary counters with garbage

Darrick J. Wong <djwong@kernel.org>
    xfs: fix skipped inode mask handling in iscan

Darrick J. Wong <djwong@kernel.org>
    xfs: don't proceed with xattr repair if the live update fails

Eric Sandeen <sandeen@redhat.com>
    xfs: validate rc_domain in xchk_rtrefcount_mergeable

Darrick J. Wong <djwong@kernel.org>
    xfs: don't fix the directory tree if live update fails

Darrick J. Wong <djwong@kernel.org>
    xfs: flag excessive delalloc rt extents as corruption

Darrick J. Wong <djwong@kernel.org>
    xfs: zero out di_metatype when removing the metadir file iflag

Darrick J. Wong <djwong@kernel.org>
    xfs: don't pass iget failures up when marking ondisk inodes

Darrick J. Wong <djwong@kernel.org>
    xfs: always reset incore attr fork buffer when resetting fork

Darrick J. Wong <djwong@kernel.org>
    xfs: fix inode btree repair when a cluster is larger than a chunk

Darrick J. Wong <djwong@kernel.org>
    xfs: actually report corrupt xattrs as XFAIL during cross-referencing

Darrick J. Wong <djwong@kernel.org>
    xfs: fix buffer overflow in corrupt inline attr structure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix unnecessary dapos truncation in xchk_dir_walk

Darrick J. Wong <djwong@kernel.org>
    xfs: actually lock the metafile reservation when adjusting after repair

Darrick J. Wong <djwong@kernel.org>
    xfs: avoid cross-rtgroup reaping after a repair

Darrick J. Wong <djwong@kernel.org>
    xfs: online quotacheck must dirty dquot if enforcement adjustments needed

Darrick J. Wong <djwong@kernel.org>
    xfs: fix buffer overruns in xfs_ioc_attr_list

Darrick J. Wong <djwong@kernel.org>
    xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xfs_rename_space_res for non-pptr filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork

Darrick J. Wong <djwong@kernel.org>
    xfs: compute the correct fdblocks/frextents for repair when they're negative

Darrick J. Wong <djwong@kernel.org>
    xfs: mark cow extents bad if there's no rmap mapping for them

Darrick J. Wong <djwong@kernel.org>
    xfs: clear the symlink zapped flag if inline symlink is ok

Amir Goldstein <amir73il@gmail.com>
    ovl: skip copy up of empty security.capability

Chris Mason <mason@kernel.org>
    ovl: set the revalidate flags after d_instantiate()

Hungyu Lin <dennylin0707@gmail.com>
    ovl: reserve space for the casefolded name terminator

Chris Mason <mason@kernel.org>
    ovl: read the nlink xattr of every indexed non-dir

Amir Goldstein <amir73il@gmail.com>
    ovl: fortify ovl_copy_xattr() against underlying layer modifications

Chris Mason <mason@kernel.org>
    ovl: fix a torn path in ovl_get_redirect()

Chris Mason <mason@kernel.org>
    ovl: do not copy up an xattr value that was never read

Chris Mason <mason@kernel.org>
    ovl: check the casefold flag of directories only

Chris Mason <mason@kernel.org>
    ovl: always encode the origin fh when index is enabled

Chris Mason <mason@kernel.org>
    ovl: use the pinned upper dir in ovl_fix_origin()

Chris Mason <mason@kernel.org>
    ovl: take a snapshot of the name for copy up

Chris Mason <mason@kernel.org>
    ovl: set OVL_WHITEOUTS before publishing the upper dir

Weiming Shi <bestswngs@gmail.com>
    smb: client: stop processing a read response after a receive error

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB last_entry pointer from unbounded LastNameOffset

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot dentry names in file and setattr traces

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin refcount trees before dropping the lookup lock

Jiaming Zhang <r772577952@gmail.com>
    ocfs2: fix chunk number of the first chunk in a local quota file

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cancel quota sync work before freeing quota info

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2/dlm: hold the lookup reference across convert AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: hold a lock reference across grant AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/heartbeat: unlink live slots when their node is missing

Sean Young <sean@mess.org>
    media: rc: Fix ABBA deadlock by making locks more fine grained

Sean Young <sean@mess.org>
    media: rc: Fix use after free in bpf progs

Sean Young <sean@mess.org>
    media: rc: After rc_unregister_device() timers can be re-armed

Sean Young <sean@mess.org>
    media: rc: Use after free in ir_raw_event_handle()

Sean Young <sean@mess.org>
    media: rc: mce_kbd: Fix inconsistent locking of keylock

Sean Young <sean@mess.org>
    media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister

Weigang He <geoffreyhe2@gmail.com>
    media: rc: fintek-cir: process a full RX buffer instead of overflowing it

Sean Young <sean@mess.org>
    media: rc: Ensure registered is cleared in error path

Sean Young <sean@mess.org>
    media: rc: Ensure that rc_unregister_device() does not free input device

Janne Grunau <j@jannau.net>
    nvmem: core: Fix OOB read for bit offsets of more than one byte

Myeonghun Pak <mhun512@gmail.com>
    power: supply: sbs-battery: disable polling before supply teardown

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    phy: core: Fix race-condition between _of_phy_get() and try_module_get()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    resource: report a devm_request_resource() conflict under the lock

Weibin Liu <liuwb@xiaopeng.com>
    spi: spi-pci1xxxx: quiesce DMA engines on transfer timeout

YANXIN LI <fadouse@pm.me>
    ufs: use u64 for directory size in ufs_last_byte

Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>
    usb: gadget: fix refcount underflow in gadgetfs_bind() error path

Zhao Li <enderaoelyther@gmail.com>
    wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: delete channel-context timers on deinit

Yuchao Zhang <ndaugoing@gmail.com>
    xen-blkfront: unbind irq before tearing down ring and shadow requests

Igor Putko <igorpetindev@gmail.com>
    serial: core: shut down initialized port on removal

Fan Wu <fanwu01@zju.edu.cn>
    scsi: dc395x: sync the waiting_timer before freeing the host

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after folio_put/unlock()

Imre Kaloz <kaloz@kernel.org>
    mm/slab: sample slab_state once in kmem_cache_destroy()

Fan Wu <fanwu01@zju.edu.cn>
    media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog

Rik van Riel <riel@surriel.com>
    media: redrat3: fix UAF in probe error path leaving rc device registered

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: take a reference on the parsed endpoints

Cong Nguyen <congnt264@gmail.com>
    media: microchip-csi2dc: fix async notifier leak on probe error path

Fan Wu <fanwu01@zju.edu.cn>
    media: marvell: mcam: stop DMA and cancel s_bh_work before freeing DMA buffers

Fan Wu <fanwu01@zju.edu.cn>
    media: imx-jpeg: cancel timeout worker when streaming stops

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: gspca: use vb2_video_unregister_device() on disconnect

Myeonghun Pak <mhun512@gmail.com>
    media: cx23885: unregister DVB bus when SP2 CI setup fails

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add SRCU protection for virtual-mode HPT hcalls

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Disable the impl before disabling the SMMU on shutdown

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't resubmit an ioend after ->writeback_submit() failed

Kyle Zeng <kylebot@openai.com>
    io_uring/io-wq: save worker type before dropping its reference

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: hiddev: keep state alive through disconnect unlock

Richard Patel <ripatel@wii.dev>
    genirq: Move interrupt thread exit_work object to irqaction

Richard Patel <ripatel@wii.dev>
    genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes

Ngoc Quy <ngocquy0700@gmail.com>
    fs/proc/task_mmu: pin mm_users in do_pagemap_scan()

Xiang Mei <xmei5@asu.edu>
    fbdev: udlfb: don't rebuild the mode list while the framebuffer is in use

Yibo Tan <lhfff@tju.edu.cn>
    fbdev: atmel_lcdfb: Prevent FIFO work after removal

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: Fix TOCTOU race between GROUP_REGISTERED check and erase

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: hci_vhci: Pin module for debugfs file operations

Fan Wu <fanwu01@zju.edu.cn>
    ASoC: amd: ps: fix snd_acp63_remove() teardown ordering

Sung Byeongchan <tjdqudcks0424@naver.com>
    ALSA: pcmtest: handle multiple wraps in random capture fill

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Fix UAF of soundfont zones at note-on

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect

Frank Zhang <rmxpzlb@gmail.com>
    rust: rcpufreq_dt: add module alias

Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>
    rust: cpufreq: reject NULL from cpufreq_cpu_get()

Andreas Hindborg <a.hindborg@kernel.org>
    rust: configfs: fix data offset calculation for subsystem callbacks

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: require `Sync` for `Operations::QueueData`

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: fix `Send` bound for `GenDisk`

Eliot Courtney <ecourtney@nvidia.com>
    rust: bitmap: restrict bitmap length to at most i32::MAX

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.101.0

Karl Mehltretter <kmehltretter@gmail.com>
    klist: avoid accesses after waking klist_remove()

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Write shared touch initial status only once

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration

Lee Jones <lee@kernel.org>
    HID: wacom: Redesign shared sibling data lifecycle

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_bamboo_pad

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_intuos_pad

Lee Jones <lee@kernel.org>
    HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration

Lee Jones <lee@kernel.org>
    HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()

Heiko Carstens <hca@linux.ibm.com>
    s390/signal: Fix incorrect return address in signal frame

Heiko Carstens <hca@linux.ibm.com>
    s390/probes: Fix wrong opcode for cgrb fixup

Heiko Carstens <hca@linux.ibm.com>
    s390/kprobes: Prevent kprobes on instructions with exception table entry

Heiko Carstens <hca@linux.ibm.com>
    s390/extable: Fix mvcos instruction decoding

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/cpum_cf: Check session mask before cpu offline

Wentao Liang <vulab@iscas.ac.cn>
    drm/msm: Fix vm_bo use-after-free in with_vm_locks()

Niklas Cassel <cassel@kernel.org>
    ata: sata_fsl: Fix use-after-free of host_priv on probe() failure

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: audio-graph-card2: Fix use-after-free in audio_graph2_link_c2c()

Binbin Deng <18983559317@163.com>
    apparmor: fix a use-after-free in aa_lookupn_ns()

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: fix use-after-free of a new anon folio

David Hildenbrand (Arm) <david@kernel.org>
    mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()

Deepanshu Kartikey <kartikey406@gmail.com>
    media: imon: fix use-after-free in display_close via dev_dbg

Anuj Bolewar <bolewara@gmail.com>
    media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path

Pei Xiao <xiaopei01@kylinos.cn>
    media: cx23885: Fix use-after-free in cx23885_finidev due to race condition

Fan Wu <fanwu01@zju.edu.cn>
    media: au0828: fix use-after-free in bulk_timeout timer on disconnect

Chuck Lever <chuck.lever@oracle.com>
    lockd: Fix use-after-free in nlmsvc_retry_blocked

Günther Noack <gnoack@google.com>
    landlock: Fix superblock use-after-free in release_inode()

Nirmoy Das <nirmoyd@nvidia.com>
    iommufd: Fix event queue release use-after-free

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvmet-fc: fix use-after-free in nvmet_fc_ls_create_connection()

Daejun Park <daejun7.park@samsung.com>
    nvmet: fix use-after-free of the old registrant in nvmet_pr_preempt()

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: hfi: Fix a use-after-free when unloading the driver

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in mport_mm_close()

Guangshuo Li <lgs201920130244@gmail.com>
    RDMA/irdma: avoid use-after-free in icrdma_remove

Henry Martin <bsdhenrymartin@gmail.com>
    smb: client: fix use-after-free in cifs_ses_add_channel()

Diego Oliva <diego@bynar.io>
    smb: client: fix use-after-free infoleak via the readdir resume name

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    spmi: Fix potential use-after-free by grabbing of_node reference

Zijing Yin <yzjaurora@gmail.com>
    SUNRPC: fix netns use-after-free in write_gssp()

Andreas Wendleder <gonsolo@gmail.com>
    wifi: b43: fix use-after-free in b43_bcma_remove()

Li RongQing <lirongqing@baidu.com>
    x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap

Kevin Cheng <chengkev@google.com>
    KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits

Sean Christopherson <seanjc@google.com>
    KVM: x86: Tell ->inject_page_fault() whether or a fault came from hardware

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK to kvm_translate_gpa

Christoph Zwerschke <cito@online.de>
    Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"

Christoph Zwerschke <cito@online.de>
    Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"

Daehyeon Ko <4ncienth@gmail.com>
    cgroup: serialize migrations of newly forked processes

Eric Dumazet <edumazet@kernel.org>
    vlan: restore HW VLAN tag insertion with reorder_hdr off

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Fix potential UAF in reqsk_timer_handler().

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate security descriptor offsets before pointer arithmetic

Karl Mehltretter <kmehltretter@gmail.com>
    ksmbd: use u8 for SMB2 oplock level values

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: return end of file for reads past a named stream's data

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: reserve space for the UTF-16 terminator in stream info

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: preserve unreadable named streams on open

Jan Koester <j.koester@act-marketing.de>
    ksmbd: ignore network devices of other namespaces

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    ksmbd: fix parent dentry lifetime in directory enumeration

Giorgi Kobakhia <gkobakhi@asu.edu>
    ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix extended session security negotiation for raw NTLMSSP

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: avoid restoring only in-memory EOF after allocation change

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: accept share config responses from ksmbd-tools before 3.5.3

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix WLED3 brightness register stride

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix unbalanced OVP IRQ enable at probe

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()

Myeonghun Pak <mhun512@gmail.com>
    backlight: lm3630a: Cancel delayed work before destroying workqueue

Kameron Carr <kameroncarr@linux.microsoft.com>
    Drivers: hv: vmbus: Bounds check the shared ring buffer indices

Johan Hovold <johan@kernel.org>
    driver core: fix parent lock use-after-free on USB disconnect

Josef Bacik <josef@toxicpanda.com>
    driver core: Limit the messages on a refused uevent

Johan Hovold <johan@kernel.org>
    driver core: take parent lock on deferred probe

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: do not consume the inner header on egress

Antonio Quartulli <antonio@mandelbit.com>
    net/sched: fix packet reordering on requeue

owen kwan <owen@verialabs.com>
    net/sched: sch_teql: fix use-after-free on lower qdisc drop

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: fix slaves_lock IRQ deadlock

Yuhang Zheng <z1652074432@gmail.com>
    net/sched: cls_flower: avoid stale mask references after delete

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_bpf: accept dev-bound programs on shared blocks

Hengyu Liang <hengyul@cs.unc.edu>
    serial: core: fix TIOCSSERIAL and TIOCSERCONFIG on uninitialised ports

Jiakai Xu <xujiakai2025@iscas.ac.cn>
    RISC-V: KVM: Fix double-free of sdata in kvm_pmu_clear_snapshot_area()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix NULL dereference when copying keys for a field variable

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Bound histogram expression strings with seq_buf

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Return ERR_PTR() from expr_str()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Use __free() for expr_str() buffer

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix fully-qualified variable reference printing in histograms

Christian Brauner <brauner@kernel.org>
    ntfs3: free replaced mount options after a grace period

Christian Brauner <brauner@kernel.org>
    ipc: drop the mqueue mount with kern_unmount() on setup failure

Vlad Kulikov <vlad.kulikov.c@gmail.com>
    ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure

Igor Paunovic <royalnet026@gmail.com>
    accel/rocket: search every core slot when looking up a scheduler

Hari Mishal <harimishal1@gmail.com>
    drm/amd/display: guard dc_sink dereferences in MST mode validation

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: remove gart_window_lock usage from gmc v12

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fast updates on DCE 6.x

Ali Ahmet Memis <ali@iusegentoo.com>
    tools/power turbostat: Read complete CPU lists

Paulo Alcantara <pc@manguebit.org>
    smb: client: require stable pages for signed connections

Paulo Alcantara <pc@manguebit.org>
    smb: client: only require read lease for size-extending zero range

Paulo Alcantara <pc@manguebit.org>
    smb: client: drain and invalidate before server-side copy/clone

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via clone range

Paulo Alcantara <pc@manguebit.org>
    smb: client: clear post-EOF pagecache when extending a file via truncate

Jakub Gawlik <jakubgawlik13@gmail.com>
    ALSA: hda/realtek: Add micmute LED quirk for Acer Swift SFG16-72

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: add quirk for Acer Nitro ANV15-51

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: remove 'add_helper' dead code

Johan Hovold <johan@kernel.org>
    serial: abort TIOCMIWAIT on hangup

Johan Hovold <johan@kernel.org>
    serial: fix ioctl hangup race

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: serial_core: simplify uart_ioctl() returns

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fill kvm_run exit fields in common get_nested_state_pages() error paths

Adarsh Das <adarshdas950@gmail.com>
    smb: client: delete compound mids on send failure before unlock

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow in EOP ring size calculation.

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size

Darrick J. Wong <djwong@kernel.org>
    xfs: don't cross reference rmapbt with bitmaps if they're incomplete

Zongmin Zhou <zhouzongmin@kylinos.cn>
    RISC-V: KVM: Fix sdata leak and stale snapshot_addr in snapshot_set_shmem

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Release unused page after MMU invalidation

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix fattr leaking on wsl_to_fattr() failure

Mahmoud Nagy Adam <mngyadam@amazon.de>
    selftests: ublk: install test_common.sh and trace/ scripts

Ming Lei <ming.lei@redhat.com>
    selftests: ublk: increase timeout to 150 seconds

Caleb Sander Mateos <csander@purestorage.com>
    selftests: ublk: add utility to get block device metadata size

Ming Lei <ming.lei@redhat.com>
    selftests/ublk: fix Makefile to rebuild on header changes

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Synchronize HID command and report handling

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Validate HID report lengths

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Add per-device configuration

Guenter Roeck <linux@roeck-us.net>
    hwmon: (asus_rog_ryujin) Rely on subsystem locking

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix WSL reparse point uid/gid override

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix uid/gid override in getattr with posix extensions

Théo Lebrun <theo.lebrun@bootlin.com>
    mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC from CONFIG_EYEQ

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: Fix HOTPLUG_PARALLEL dependency

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix handling of EBUSY in PAES when req is pushed to crypto engine

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix use of mutex in atomic context in PAES

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms

Peter Zijlstra <peterz@infradead.org>
    s390/crypto: Replace cond_resched() with msleep(1)

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Fix resource leak in kvm_loongarch_env_init() error path

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Add unregister helpers for the KVM interrupt devices

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Remove const Qualifier From Non-Pointer Fields

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: add const qualifiers to watermark params struct

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Update P-state naming for clarity.

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: DML2.1 Reintegration

Sven Peter <sven@kernel.org>
    thunderbolt: Make the DP tunnel activation callback mandatory

Ido Schimmel <idosch@nvidia.com>
    ipv6: udp: Create exceptions before socket matching

Andy Chiu <tchiu@tenstorrent.com>
    riscv: hwprobe: initialize pair->value in hwprobe_one_pair()

Yunpeng Tian <shionthanatos@gmail.com>
    smb: client: reject SetEA requests that do not fit the request buffer

Arvind Yadav <arvind.yadav@intel.com>
    mm/migrate_device: clear stale mapping after freeing swapcache

Breno Leitao <leitao@debian.org>
    mm/kmemleak: report RCU-tasks quiescent states during the scan

Breno Leitao <leitao@debian.org>
    mm/kmemleak: stop the task stack scan early when interrupted

Gary Guo <gary@garyguo.net>
    rust: cfi: disable function merging if CFI is enabled

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Expand module virtual address space to 2GB

Jeff Layton <jlayton@kernel.org>
    nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update

Jeff Layton <jlayton@kernel.org>
    nfsd: dedup nfs4_client_to_reclaim inserts

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: fix warn_on macro build error on UML

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Deliver interrupt after IN_GUEST_MODE is set

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Check kvm_request_pending() in kvm_late_check_requests()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix potential UAF in i3c_device_uevent()

Brendan Jackman <jackmanb@google.com>
    mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: input: read battery capacity from its actual report offset

Dev Jain <dev.jain@arm.com>
    mm/migrate: use huge_ptep_get() in remove_migration_pte()

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Always initialize EFER reserved bits on vendor initialization

Matthew Auld <matthew.auld@intel.com>
    drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Fix standalone IRSes OF probe

Lorenzo Pieralisi <lpieralisi@kernel.org>
    dt-bindings: interrupt-controller: gicv5: Relax IRS properties constraints

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: discard auth_chunk when skb_clone fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: do not expose expectation DEAD flag

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Darrick J. Wong <djwong@kernel.org>
    xfs: fix integer overflow problem when setting large free areas

Bui Viet Dung <dungvn2345@gmail.com>
    wwan: wwan_hwsim: Pin module for debugfs file operations

Giorgi Kobakhia <gkobakhi@asu.edu>
    udf: fix return value for non-recorded-allocated extents in udf_map_block()

Jonathan Gopel <jgopel@gmail.com>
    thunderbolt: Do not RPM complete unrelated subtrees on unplug

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: publish the filecheck owner before adding sysfs attributes

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin owning modules for open debugfs files

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: drain quorum work before removing the cluster

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: drain join handlers before releasing module text

Ameer Hamza <ameer.hamza@truenas.com>
    nfsd: fix race between client_info_show() and free_client()

Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
    net: usb: pegasus: do not advance rx_skb->data on dropped frames

Kaho Jiang <kj2864@nyu.edu>
    net: ipv4: add zero check for snd_cwnd_clamp

Xiang Mei <xmei5@asu.edu>
    media: go7007: only set audio_enabled if go7007_snd_init() succeeded

Xiang Mei <xmei5@asu.edu>
    media: em28xx: reject audio endpoint with zero packet size

Myeonghun Pak <mhun512@gmail.com>
    media: cx88: Disable PCI device on MPEG initialization failure

Xiang Mei <xmei5@asu.edu>
    libceph: bound mon_command ack decode to front len

Andrea Parri <parri.andrea@gmail.com>
    kcsan: Avoid division by zero in kcsan_prandom_u32_max()

Fang Xieyan <fangxy@xiaopeng.com>
    kcov: ignore an out-of-range comparison count in write_comp_data()

Xiang Mei <xmei5@asu.edu>
    fuse: don't BUG when the copy buffer is exhausted

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    ceph: fail readdir when the MDS reply carries no dirfrag

Baokun Li <libaokun@linux.alibaba.com>
    blk-crypto: fix NULL deref and UAF in __blk_crypto_evict_key()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9524/1: mm: align hugetlb mappings to the huge page size

Rohinthan P <rokinthanp03@gmail.com>
    media: em28xx: use video_unregister_device for radio_dev

Christian Brauner <brauner@kernel.org>
    Revert "namei: don't reveal overmounted entries in refwalk"

Petr Mladek <pmladek@suse.com>
    nbcon/reboot: Switch NBCON consoles into the emergency mode in emergency_restart()

Michael Reeves <michael.reeves077@gmail.com>
    regmap: Remove debugfs before cache teardown

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    RISC-V: errata: Add SiFive MAL-9092 workaround

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx11: set KMD_QUEUE for kernel gfx queues

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx12: set KMD_QUEUE for kernel gfx queues

Matus Gajdos <matuszpd@gmail.com>
    ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers

Jaidheer Sirigineedi <jaidheer7@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg3xxx (103c:8bfd)

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix status polling with octal DTR chips

Zeyu Li <13776528859@163.com>
    ALSA: hda/realtek: Add ALC235 support for headset mode

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Rolling Wireless RN947R

Vladimir Murzin <vladimir.murzin@arm.com>
    usb: mtu3: Fix double dereference in TP_printk

renpanpan <renpanpan@kylinos.cn>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU

Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>
    ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45

Krish Gulati <krishgulati7@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Victus 15-fb2xxx

Tarun Noonemunthala <ntarun2000@gmail.com>
    ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx

Luis Banha <luisbanha26@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo ThinkBook G8+

KIM MinWoo <phrimm136@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo ThinkBook 16p Gen 3 ARH (21EK)

Tomasz Bojanowski <tomasz@bojanowski.me>
    ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI

Hernan Ganzo <gp@sneemgp.com>
    ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)

Christian Brauner <brauner@kernel.org>
    docs: update the unmount propagation rule

Eric Dumazet <edumazet@google.com>
    nvme-tcp: delay nvme_tcp_reclassify_socket()

Jasper Firth <jasper.m.f@hotmail.com>
    ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quicki2c: Fix buffer overflow

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quickspi: Fix buffer overflow

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: universal-pidff: Add support for Turtle Beach VelocityOne Race

Daniel Ortiz <letargopausado@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP

Andy Moreton <andy.moreton@amd.com>
    sfc: add X4D PF support

Rosen Penev <rosenp@gmail.com>
    gpio: mvebu: keep resume masks within the irqchip cache

Seiji Adachi <seiji_adachi@yahoo.co.jp>
    ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks

Ewan D. Milne <emilne@redhat.com>
    scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix

Dmitry Antipov <dmantipov@yandex.ru>
    HID: roccat: fix locking in roccat_connect() and roccat_disconnect()

Maurizio Lombardi <mlombard@redhat.com>
    nvme-fc: do not warn on controller removal race

Berke Durak <berke.durak@gmail.com>
    HID: elecom: Add support for ELECOM M-XT4DRBK (018E)

Oleg Keri <okerixx@gmail.com>
    HID: i2c-hid: add reset quirk for Lenovo Yoga Slim 7x Gen 11 keyboard

Youth Cao <cocoh2os08@gmail.com>
    HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device

Mark Brown <broonie@kernel.org>
    regmap: irq: Free the irqdomain we create

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle allocated range queries on dense files

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()

Mehmet Aysel <mehmet4ysel@gmail.com>
    ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/conexant: Always enable the headset-mic pin on plugin

Xiubo Li <xiubo.li@clyso.com>
    ceph: do not cache negative dentries for snapped directories

Mehmet Aysel <mehmet4ysel@gmail.com>
    ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk

Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
    ALSA: usb-audio: Skip mixer creation on M-Audio Venom

Karl Mehltretter <kmehltretter@gmail.com>
    tpm: atmel: depend on X86

Li Jun <lijun01@kylinos.cn>
    tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Fix stale MT slots when contact count drops to zero

Vadim Klishko <vadim@cirque.corp-partner.google.com>
    HID: i2c-hid: Add a quirk for a Cirque I2C device.

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD

Jimmy Zuber <jamz@amazon.com>
    fuse: zero the partial EOF page when extending a file

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8

Md Rabbani <rabbanyhmm@gmail.com>
    net: stmmac: fix device node reference leaks in stmmac_mtl_setup()

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: intel_rapl: Fix kernel panic during PMU unbind

Helge Deller <deller@gmx.de>
    fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo

Shiji Yang <yangshiji66@outlook.com>
    net: ethernet: mtk_wed: increase WED v2 WDMA RESV_BUFF to 0x80

Jenson Johnathon Reggentin <mail@jregg.de>
    docs: block: fix dead http link in blk-mq.rst

Chen Changcheng <chenchangcheng@kylinos.cn>
    scsi: snic: Fix SCSI host leak on workqueue allocation failure

Will Porter <mrwillporter@gmail.com>
    ALSA: usb-audio: Add iD14 MkI to monitor-mix volume quirk

Csaba Budai <ilyr73@gmail.com>
    ALSA: hda/realtek: Fix ALC700 audio on Intel Hades Canyon

Daeho Jeong <daehojeong@google.com>
    f2fs: avoid setting SBI_NEED_FSCK on transient resize failure

Robin Everaars <robineveraars@pm.me>
    ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch

Tao Cui <cuitao@kylinos.cn>
    sched_ext/scx_flatcg: expire cached hweights on weight changes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: enable TCP keepalive for accepted connections

BingKun Yue <yuebingkun@kylinos.cn>
    fbdev: platinumfb: add error checking for ioremap calls

Randy Dunlap <rdunlap@infradead.org>
    fbdev: maxine: fix 64-bit build error

Carlos Song <carlos.song@nxp.com>
    i2c: imx-lpi2c: properly unwind resources on probe failure

Li Jun <lijun01@kylinos.cn>
    spi: loongson: pm: add .freeze .poweroff .thaw .restore

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()

Robert Leussler <robert.leussler@leica-geosystems.com>
    rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode

Jack Yu <jack.yu@realtek.com>
    ASoC: rt712-sdca: Pull high JD2 to prevent from entering TV mode

Jinqian Yang <yangjinqian1@huawei.com>
    virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken

Szymon Durawa <szymon.durawa@linux.intel.com>
    PCI: vmd: Add Nova Lake (NVL) and Dunlow (DNL) Device IDs

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()

Denis V. Lunev <den@openvz.org>
    virtio_balloon: warn on failed buffer add in tell_host()

Chad Talbott <chad.talbott@gmail.com>
    ALSA: usb-audio: Add MIN_MUTE quirk for Creative Sound Blaster Play! 3

Weimin Xiong <xiongwm2026@163.com>
    vdpa/mlx5: roll back MR update after VQ setup failure

Gilles Risch <gilles.risch@gmail.com>
    drm/radeon: fix internal display on iMac11, 1 (RV770/DCE3.1)

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa_sim: hold iommu_lock across dma_unmap passthrough transition

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: codec: max98926: fixup invert setup mask

Andrew Onyshchuk <andryk.rv@gmail.com>
    platform/x86: thinkpad_acpi: Fix fan speed reporting on Edge E330

Yaroslav Dudkov <aroslavdudkov622@gmail.com>
    platform/x86: msi-ec: Add MSI Katana GF76 11UEK EC firmware

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: report cancelled I/O as a layout error

Alex Elder <elder@riscstar.com>
    net: stmmac: use dma_addr_t for DMA addresses

Jia Zhu <zhujia.zj@bytedance.com>
    NFSv4: pin the superblock for active state owners

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Add Lisuan HDMI controller and codec support

ZhangGuoDong <zhangguodong@kylinos.cn>
    NFS: Verify symlink inode before caching target

Thomas Huth <thuth@redhat.com>
    smb: server: Free session data in user_session.c with kfree_sensitive()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: notify parent directory leases on child create

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: honor clora_changed when recalling a layout

Thomas Huth <thuth@redhat.com>
    smb: server: Make sure that passkey is not leaked on the heap in user_config.c

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: honor client signing-required in all modes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject blocking compound lock requests

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix SMB2 byte-range lock end offset

Yashraj Ghule <yashrajghule.221@gmail.com>
    ALSA: hda/realtek: Fix mute LED for HP Victus 15-fa1xxx (MB 8C3F)

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: cancel async requests when closing connection

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: report actual xattr value length in stream enumeration

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow FSCTL_SET_SPARSE without input buffer

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: honor byte-range locks for zero data

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle empty QUERY_ALLOCATED_RANGES output

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return buffer too small for short security queries

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject SMB3.1.1 binding with mismatched cipher

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix durable handle v2 default timeout units (60 -> 60000)

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow I/O on directory named streams

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve access denied status for copychunk

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: protect private extended attributes

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: keembay - use crypto_memneq() to compare CCM AEAD tags

Israel Téllez García <i.tellez@btesa.com>
    libbpf: Fix ring buffer consumer loop on 32-bit position wrap

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: sa2ul - use crypto_memneq() to compare AEAD tag

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: keembay - use crypto_memneq() to compare GCM AEAD tags

Eric Dumazet <edumazet@google.com>
    gre: fix ERSPAN o_flags race/corruption in xmit and fill_info

Yang Wen <anmuxixixi@gmail.com>
    exfat: keep FITRIM within the requested range

Anuj Bolewar <bolewara@gmail.com>
    drm/virtio: reclaim pending vbufs before tearing down vqs

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Serialize access to the shared emp2 pointer

Neil Andrews <neil@androos.io>
    ALSA: usb-audio: Rename the Audient iD14 monitor mix volume control

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: include all root port children in recovery prevention on link error

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/intel: Add sanity check for BAR0 size

Farhan Ali <alifm@linux.ibm.com>
    PCI: Avoid saving config space state if inaccessible

Michail Tatas <michail.tatas@gmail.com>
    ipmi: Fix leak in __ipmi_bmc_register

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo

Arash Golgol <arash.golgol@gmail.com>
    regulator: fan53555: Add support for FAN53555BUC23X type

Jiaming Zhang <r772577952@gmail.com>
    hfsplus: validate extent record length before writing it back

Dmytro Moroziuk <dmorozyk1@gmail.com>
    ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5

Matt Turner <mattst88@gmail.com>
    alpha: run the remote RTC access in a worker, not an IPI callback

Chao Shi <coshi036@gmail.com>
    nvme: ratelimit the completion-path messages driven by device data

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: nxp-nci: Add remove on IRQ error

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: mrvl: spi: Unregister dev on allocation fail

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix missing CMD_COMPLETE_PPR response for invalid PPR requests

Feng Tang <feng.tang@linux.alibaba.com>
    selftests: net: reuseport_bpf_numa: consider cpuless numa node

John Johansen <john.johansen@canonical.com>
    apparmor: fix auditing of mount binary data

Rongguang Wei <weirongguang@kylinos.cn>
    tap: fix incorrect variable used for USO check in set_offload()

Geliang Tang <geliang@kernel.org>
    nvme-tcp: look up host_iface in the current netns

Zhe Liu <liuzhe1@kylinos.cn>
    docs: cgroup-v2: fix stale "io" controller introduction

Brian Grech <bgrech@redhat.com>
    selftests/net: fin_ack_lat: fix latency threshold typo

Hari Mishal <harimishal1@gmail.com>
    nvmet: passthru: fix OOB reads when parsing ns id descriptor list

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86: Free hybrid state on PMU init failure

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86: Unregister PMI handler on PMU init failure

Michal Pecio <michal.pecio@gmail.com>
    ALSA: usx2y: Stop clearing urb->hcpriv before submission

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluting shared variables in flush loop

Pengpeng Hou <pengpeng@iscas.ac.cn>
    fbdev: udlfb: validate vendor descriptor items

Andreas Kemnade <andreas@kemnade.info>
    fbdev: omap2: dsi: do not copy isr table

Atish Patra <atishp@meta.com>
    RISC-V: perf: fix resource cleanup on driver probe failure

Rui Qi <qirui.001@bytedance.com>
    riscv: kprobes: Prevent probes in breakpoint handlers

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check CORE_PLL_GROUP4 access in mt7531_setup()

Daniel Golle <daniel@makrotopia.org>
    net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check bus->read() error in core_rmw()

Laxman Acharya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed PHY_IAC command writes

Muhammad Saheed <muhammad.saheed.iam@gmail.com>
    Bluetooth: hci_sync: Disable legacy instance's ext adv before setup snapshot

Iva Kasprzaková <iva@yenya.net>
    Bluetooth: fix BT dependency for submodules

Li Qiang <liqiang01@kylinos.cn>
    Bluetooth: hci_bcsp: validate received packet lengths

Chen Changcheng <chenchangcheng@kylinos.cn>
    Bluetooth: btrsi: Move set_bt_context after successful HCI registration

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Acer Nitro ANV16-42 headset mic

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/conexant: Add pin config quirk for Huawei Matebook

Garrett Blackmon <garrett@blackmon.dev>
    ALSA: hda/realtek: Fix speakers on ASUS ROG Zephyrus G14 GA403UM

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA

Junhao He <hejunhao3@h-partners.com>
    ACPI: APEI: Handle repeated SEA error storms

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add DCN6 register headers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory barrier order in reloc_root_is_dead()

Li Qiang <liqiang01@kylinos.cn>
    Bluetooth: bfusb: validate received block boundaries

Zhao Dongdong <zhaodongdong@kylinos.cn>
    Bluetooth: btnxpuart: Fix use-after-free in probe error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: hci_nokia: validate firmware packet bounds

Pavel Zverev <playximik29@gmail.com>
    Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device

Gustavo Evgucci <monesss315@gmail.com>
    Bluetooth: btusb: Add USB ID 13d3:3625 for MediaTek MT7922

Rui Qi <qirui.001@bytedance.com>
    selftests/ftrace: Force C locale in ftracetest

Andreas Haufler <andreas@haufler.info>
    tools/lib/thermal: Fix misplaced extern "C" closing brace

Yunye Zhao <yunye.zhao@linux.alibaba.com>
    md: add cond_resched() to md_do_sync()'s skip path

Yu Kuai <yukuai@fygo.io>
    md: skip bitmap accounting for empty write ranges

Yu Kuai <yukuai@fygo.io>
    md/raid5: reject zero-sector reshape chunks

Shang En Sim <sim@shangen.org>
    ALSA: hda/realtek: Enable mute LEDs on HP Spectre x360 16-aa0xxx

Junzhe Yu <junzheyu1@gmail.com>
    ext4: guard against NULL s_group_info in ext4_get_group_info

Pengpeng Hou <pengpeng@iscas.ac.cn>
    HID: rmi: check report length before trimming sentinel bytes

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: derive stable PPT limits from PPTable

liulhong617 <liulhong617@gmail.com>
    arm64: mm: fix accidental linear mapping of no-map reserved memory

Stefan Hansson <newbyte@postmarketos.org>
    wifi: rsi: Fix types to appease CFI

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo

Praveen Talari <praveen.talari@oss.qualcomm.com>
    opp: Use clk_get_optional() to avoid leaving opp_table->clk as an error pointer

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on Positivo N15RPE-S

Carl Quist <equalizerjr@gmail.com>
    ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx

Zihan Xi <zihanx@nebusec.ai>
    xsk: account ring allocations to memcg

Jinhui Guo <guojinhui.liam@bytedance.com>
    net: usb: cdc_ether: add quirk for AMI BMC stale link events

Johan Alvarado <contact@c127.dev>
    net: stmmac: raise TX completion interrupt at the end of an xmit burst

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211

Marcos Paulo Medeiros <maarcospm1996@gmail.com>
    ACPI: video: force native backlight on Acer Nitro AN515-46

Luca Castaldini <luca.castaldini96@gmail.com>
    ALSA: hda/realtek: Add mute LED support for HP Pavilion 15-eh2xxx

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Snapshot intrc before freeing the request block

Simon Glass <sjg@chromium.org>
    kconfig: abort rather than loop for ever on EOF

Allison Henderson <achender@kernel.org>
    net/rds: unpin MR pages with unpin_user_pages_dirty_lock()

Sharath Srinivasan <sharath.srinivasan@oracle.com>
    net/rds: fix rds_message leak in the rds_send_xmit() drop path

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: hold the socket while an rds_mr references it

Allison Henderson <achender@kernel.org>
    net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Wahid Khan <wahidzk0091@gmail.com>
    HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware

Yuxiang Lin <mclyxfdw@gmail.com>
    HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle

Aaron Ma <mapengyu@gmail.com>
    HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle

Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
    HID: logitech-hidpp: Add support for G502 X Plus USB mouse

Mauricio Orozco <maudob@live.com>
    ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP

Mariano Baragiola <mbaragiola@linux.com>
    wifi: wilc1000: validate monitor transmit frame headers

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: validate msgbuf flowring IDs before use

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: Set DMA direction for msgbuf packet IDs

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: restore hardware PS buffering after a service period

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: fix U-APSD service period termination

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: set the EOSP bit in the QoS header of the last released frame

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Power down DSP if it is left enabled in pre_fw_run()

ZhaoJinming <zhaojinming@uniontech.com>
    wifi: ath11k: fix resource leak on error in ext IRQ setup

Geetha sowjanya <gakula@marvell.com>
    perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: call skb_valid_dst() before skb_dst()

Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
    netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets

Zhi-Jun You <hujy652@gmail.com>
    wifi: mt76: wed: fix kernel panic on non-DBDC MT7986

Ahmed Naseef <naseefkm@gmail.com>
    wifi: mt76: mt7603: add 0x7592 EEPROM chip ID

Prashant Rahul <prashantrahul23@gmail.com>
    wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7915: configure noise floor reporting on reset

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt76x02: report rx FCS errors to mac80211

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7603: free beacon SKB on error

Hari Mishal <harimishal1@gmail.com>
    virtio_console: take a kref in find_port_by_vq() to fix port UAF

Rosen Penev <rosenp@gmail.com>
    nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data

Rosen Penev <rosenp@gmail.com>
    nvmem: brcm_nvram: reject empty NVRAM partition

이상호 <kudo3228@gmail.com>
    romfs: detect hard link cycles

Genjian Zhang <zhanggenjian@kylinos.cn>
    md/raid5: complete discard bios while reshape is active

bui duc phuc <phucduc.bui@gmail.com>
    regulator: rt6245: Restore state on enable failure

Oleg Proshkin <oleg.pro171@gmail.com>
    mfd: axp20x: Preserve other control bits when powering off

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing error checks for COEF index reads in alc269

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix memory leak in indx_find_sort()

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing NULL check for codec->bus->pci

Yichong Chen <chenyichong@uniontech.com>
    exfat: free new directory cluster if zeroing fails

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: mediatek: add missing MODULE_DEVICE_TABLE()

Weiji Wang <nebclllo0444@gmail.com>
    drm/panel-edp: Add BOE NE140QDM-NX2

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix handling of vmalloc area in do_secure_storage_access()

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Add missing mm check to do_secure_storage_access()

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-smbios-wmi: Fix chardev resource management

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix barriers accessing ctx vm

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Move nr_cmds initialization

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Add NULL check for dc_mode_path

Yichong Chen <chenyichong@uniontech.com>
    exfat: clean up new entry on add entry failure

K Prateek Nayak <kprateek.nayak@amd.com>
    arm64/runtime-const: Use aarch64_insn_patch_text_nosync() for patching

Matthew Stewart <Matthew.Stewart2@amd.com>
    drm/amd/display: Fix rounding errors in CalculatePrefetchSchedule

Amber Lin <amber.lin@amd.com>
    drm/amdkfd: Fix signal reset event

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Add new PCI device-ids

Pengpeng Hou <pengpeng@iscas.ac.cn>
    i2c: qup: Propagate clock enable failures

Gary Guo <gary@garyguo.net>
    ata: ata_generic: Don't store pci_device_id

Colin Foster <colin.foster@in-advantage.com>
    clk: clocking-wizard: fix clock difference detection

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: support 48MHz clock for pll_p_out1

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: mediatek: mt6735-vencsys: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: mediatek: mt6735-vdecsys: add missing MODULE_DEVICE_TABLE()

Chen Changcheng <chenchangcheng@kylinos.cn>
    media: cx88: fix memory leak in cx8802_register_driver() error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Rate-limit the error ISR's log message

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Force shutdown during device removal

Yichong Chen <chenyichong@uniontech.com>
    exfat: write moved entry before removing source

Jay Vadayath <jay@artiphishell.com>
    udf: bound lengthAllocDescs from unallocated space entry

Jan Kara <jack@suse.cz>
    udf: Fix bh leak for unallocated space entries

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: free ibmvfc_target allocations with mempool_free

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path

Jiaxing Hu <gahing@gahingwoo.com>
    iommu/rockchip: Clear stale page faults before enabling stall

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hsi: omap_ssi: remove debugfs on port creation failure

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: move GPIO IRQ setup into request_resources

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: fix debounce register selection

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: clear pending GPIO events during init

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: enable RMII outputs from RMII groups

Pengpeng Hou <pengpeng@iscas.ac.cn>
    firmware: imx: scu: manage mailbox channels and global handle

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix info leak in parse_package()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records

Senjin <senjin@hatchling.org>
    fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    ntfs3: fix info-leak in ntfs_rename()

Kyle Zeng <kylebot@openai.com>
    fs/ntfs3: reserve NUL byte when converting UTF-16 names

Brian Norris <briannorris@chromium.org>
    PCI/portdrv: Allow probing even without child services

Ruoyu Wang <ruoyuw560@gmail.com>
    ntfs3: initialize err in attr_wof_frame_info

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()

Randolph Sapp <rs@ti.com>
    drm/etnaviv: force flush on power register ops

Rosen Penev <rosenp@gmail.com>
    ata: pata_ep93xx: fix PIO fallback when DMA init fails

Benjamin Marzinski <bmarzins@redhat.com>
    bitops: make the *_bit_le functions use unsigned long

Zhang Yi <yi.zhang@huawei.com>
    ext4: use FGP_WRITEBEGIN for tail block zeroing

Zhang Yi <yi.zhang@huawei.com>
    ext4: check return value of ext4_get_block() in ext4_load_tail_bh()

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    wifi: ath12k: fix scan command endianness on big endian

Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
    wifi: ath10k: trigger hardware recovery upon rx failures

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: ath11k: validate regulatory capability phy_id

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: disable TX VLAN offload for packets with >2 VLAN tags

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Publish pgtbl_ops before releasing init_mutex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    thermal: intel: int340x: clean up RFIM groups on DVFS failure

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Enable clocks before hardware access in qcom_iommu_ctx_probe()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Check pm_runtime_resume_and_get() return in probe

Heiko Schocher <hs@nabladev.com>
    drm/panel: simple: Add Kyocera tcg070wvlq panel

Esteban Urrutia <esteuwu@proton.me>
    iommu/arm-smmu-qcom: Add SM8450 MDSS compatible

Baokun Li <libaokun@linux.alibaba.com>
    ext4: reject mount if clusters/inodes per group are not 8-aligned

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211: include cf1 offset when sending chandef

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_MOVSX in RV32 JIT

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()

Yuyang Huang <yuyanghuang@google.com>
    net: prestera: ignore duplicate RIF destruction events

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: sfp: add quirk for HORACO copper SFP+ module

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: supply: cros_pchg: unregister EC notifier

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT

Thomas Renninger <trenn@suse.de>
    ACPI: sysfs: Properly map BERT and CCEL data to their ACPI tables

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211_hwsim: clear PMSR request state on abort

Shahar Tzarfati <shahar.tzarfati@intel.com>
    wifi: mac80211: ibss: read deauth reason_code after frame length check

Yun Zhou <yun.zhou@windriver.com>
    ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode

Ali Alaei <ali.alaei.tabatabaei@gmail.com>
    PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX

Baokun Li <libaokun@linux.alibaba.com>
    ext4: reduce max cluster size to match documented 256MB limit

Yap Weei Choong <ywc8891@gmail.com>
    platform/x86/amd/pmc: Add T14 Gen2 AMD (20XL) to s2idle quirk list

Kate Hsuan <hpa@redhat.com>
    ACPI: battery: Sanitise model_number by dropping unprintable characters

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: FPDT: validate table and record lengths

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda: Check snd_hda_power_pm construct error before executing verb

Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
    platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3

Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>
    drm/panel: panel-edp: Adjust T8 timing for AUO B116XAK01.6 and B140XTK02.4

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: s2250: propagate control I/O failures

Rituparna Warwatkar <rwarwatkar@gmail.com>
    media: dvb-core: fix feed leak on failed DMX_ADD_PID

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: ignore sync frames when sync is disabled

Ayala Beker <ayala.beker@intel.com>
    wifi: iwlwifi: mld: drop connection on D3 resume failure

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mld: validate wake packet crypto overhead

Aditya Sherawat <asherawa@qti.qualcomm.com>
    drm/msm/adreno: Add support for A704 GPU

Yuho Choi <dbgh9129@gmail.com>
    driver core: attribute_container: Unwind device_add() on attr failure

Logan Gunthorpe <logang@deltatee.com>
    PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk

Logan Gunthorpe <logang@deltatee.com>
    PCI: switchtec: Add Microchip PCI1008 device ID

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: ibmvmc: reject oversized inbound messages

Pei Xiao <xiaopei01@kylinos.cn>
    ipack: ipoctal: add rwsem to guard against TOCTOU in remove path

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: ibmvmc: release send buffer on write errors

Pengpeng Hou <pengpeng@iscas.ac.cn>
    greybus: manifest: validate string descriptor header

Pengpeng Hou <pengpeng@iscas.ac.cn>
    misc: rp1: clear chained IRQ handlers on teardown

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: hpilo: validate device queue entries before use

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: genwqe: handle a first DMA address of zero

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: bcm-vk: validate write size before allocation

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmuio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm816: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmmio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm711: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: dt2811: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: quatech_daqp_cs: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm818: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_at_a2150: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_atmio16d: Add sanity check to interrupt handler

Pengpeng Hou <pengpeng@iscas.ac.cn>
    uio: sercos3: add missing MODULE_DEVICE_TABLE()

Michail Tatas <michail.tatas@gmail.com>
    USB: misc: uss720: Fix leak in get_1284_register

Oliver Neukum <oneukum@suse.com>
    usb: misc: cypress_cy7c63: check result of IO

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    usb: musb: host: clear stale RX interrupt on three-strikes error

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec/core: drop cec_post_state_event call

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec: tegra_cec: don't break off msg on NACK

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    scsi: qla2xxx: Handle INTx not connected while passing through

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mld: support aborting an ongoing ftm request

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Wait for timeout worker completion on channel free

Namhyung Kim <namhyung@kernel.org>
    tools/lib/api: Fix potential double-free from fdarray__grow()

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: cs35l56: Add support for CS35L62 for SoundWire

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mld: reset the driver state upon firmware recovery

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: cancel crash_handler work in rproc_add() error path

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mld: validate D3_END notif size

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: iwlwifi: validate UEFI reduced-power SKU TLV length

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: support TTL platform device ID

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: iwlwifi: validate PNVM SKU TLV length

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: qcom: Check subdev start status in rproc_stop()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: avoid undefined shifts in MPEG-4 headers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cx18: stop VBI start-code scan before short tail

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: ivtv: stop VBI start-code scan before short tail

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Program the sensor on stream start

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check MMUv2 status after reset

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check all modules for idle after reset

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Drop the runtime PM usage count on stream failure

Hari Mishal <harimishal1@gmail.com>
    nvme: clamp FDP nruhsd to allocated RUH status descriptor count

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    iwlwifi: dvm: add missing cleaup for on error path

Hari Mishal <harimishal1@gmail.com>
    nvme: bound ns descriptor header and body to identify buffer

David Maximiliano Hermitte <davemadmaxxx@gmail.com>
    hfs: validate catalog CNIDs before instantiating inodes

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: intel_auxdevice: Add cs42l44 to wake_capable_list

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: dmi-quirks: add a global ghost list

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: only resume exec queues that were actually suspended

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: use vb2_video_unregister_device

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: requeue buffers if start_streaming fails

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: dev_info->pr_info since dev has been freed

Sean Rhodes <sean@starlabs.systems>
    mmc: rtsx_usb_sdmmc: suppress false CD after init timeout

Mike Tipton <mike.tipton@oss.qualcomm.com>
    pmdomain: qcom: rpmhpd: Skip retention by default

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: vf610: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: keembay - add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: inode: fix mm lifetime handling

David Laight <david.laight.linux@gmail.com>
    usb_string_copy: Use kzalloc() to avoid leaking old data

Xu Rao <raoxu@uniontech.com>
    usb: gadget: u_audio: clean up capture endpoint on feedback failure

Haoxiang Li <haoxiang_li2024@163.com>
    usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()

Aniket Randive <aniket.randive@oss.qualcomm.com>
    serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout

Haoxiang Li <haoxiang_li2024@163.com>
    tty: serial: pch_uart: add check for pci_get_slot()

Rahul Bukte <rahul.bukte@sony.com>
    serial: 8250: force synchronous probe for the ISA and PNP drivers

Xu Rao <raoxu@uniontech.com>
    mmc: block: reject invalid perdev_minors before division

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-tpg: reduce stack usage for kasan builds

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: tegra: add missing MODULE_DEVICE_TABLE()

Chris Lew <christopher.lew@oss.qualcomm.com>
    rpmsg: char: Check for ongoing chrdev destroy

Pranjal Shrivastava <praan@google.com>
    PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs

Muralidhara M K <muralidhara.mk@amd.com>
    platform/x86/amd/hsmp: Validate _DSD mailbox sub-package element count

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: max98396: Unwind supplies on resume failure

Muralidhara M K <muralidhara.mk@amd.com>
    platform/x86/amd/hsmp: Validate ACPI UID before parsing socket index

Qingtao Cao <qingtao.cao.au@gmail.com>
    bus: mhi: core: Fix sys error transition latency

John Garry <john.g.garry@oracle.com>
    nvme: don't reference NS after unlocking in nvme_ns_head_ctrl_ioctl()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: WARN() rather than BUG()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: uda1342: Leave cache-only mode before syncing

Deepanshu Kartikey <kartikey406@gmail.com>
    udf: avoid recursive s_alloc_mutex deadlock when freeing AED blocks

Kyle Zeng <kylebot@openai.com>
    udf: validate extent partition references in udf_current_aext()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: typec: mux: tusb1046: add missing MODULE_DEVICE_TABLE()

Devansh Soni <devanshsoni874@gmail.com>
    staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure

Xixin Liu <liuxixin@kylinos.cn>
    nvme: zns: cap zone report nr_zones by DMA buffer size

Xixin Liu <liuxixin@kylinos.cn>
    nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison

John Garry <john.g.garry@oracle.com>
    nvme: handle positive error codes in nuse_show()

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: core: Full attach detach during recovery

Jerome Brunet <jbrunet@baylibre.com>
    clk: sunxi-ng: fix ccu probe clock unregister on error

Marek Szyprowski <m.szyprowski@samsung.com>
    mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_TABLE()

Ben Dooks <ben.dooks@codethink.co.uk>
    mmc: cqhci: fix to missed endian conversions

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mmc: moxart: report DMA completion timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: sifive: add missing MODULE_DEVICE_TABLE()

David Heidelberg <david@ixit.cz>
    dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850

Zhiwei Zhang <202275009@qq.com>
    RDMA/rxe: Check PDs for memory window binds

David Heidelberg <david@ixit.cz>
    soc: qcom: socinfo: Add SoC ID for SDM850

Seyeong Kim <seyeong.kim@canonical.com>
    RDMA/irdma: Suppress PF reset on HMC error

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: max1241: add missing MODULE_DEVICE_TABLE()

Yun Zhou <yun.zhou@windriver.com>
    block: reject block device inodes with i_rdev == 0 in lookup_bdev()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: amlogic: meson-clk-measure: remove debugfs tree

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()

Ben Dooks <ben.dooks@codethink.co.uk>
    dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID

Yun Zhou <yun.zhou@windriver.com>
    net: mvneta_bm: add suspend/resume support to prevent crash after resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    dmaengine: pl330: remove debugfs file on teardown

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook

Jiayuan Chen <jiayuan.chen@linux.dev>
    netfilter: ebtables: bound num_counters like nentries in do_replace()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    net: usb: rtl8150: handle link status read failures

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Skip bpf_object__probe_loading() when BPF token is in use

Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
    drm/panel-edp: Support MB116AS01'3 edp panel

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: add sanity check in svm_range_is_valid

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate legacy hwmgr PP table offsets

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Vega10 PPTable subtable bounds

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PPTable subtable bounds

Xiang Liu <xiang.liu@amd.com>
    drm/amd/pm: Guard VBIOS AC timing table walk

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PowerPlay state array bounds

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: use node XCC count for v9 CRIU control stack restore

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Use uploaded size for legacy custom PPTable

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate pp_table header before reading size

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds

Gangliang Xie <ganglxie@amd.com>
    drm/amdgpu: add check for xcp id

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Guard reads in pcie state readout

Matthew Jacob <mjacob@feralsw.com>
    drm/amdgpu: Support some Barco AMD based graphics adapters

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: validate vega10 profile mode inputs

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: validate XCP topology counts before division

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Validate ATIF buffer length before use

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix kobject cleanup in xcp sysfs

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Validate ATPX buffer length before use

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add checks to vbios fetch through ATRM

Abhijeeth Babu <babu.jeeth@gmail.com>
    i2c: acpi: Force ELAN1300 touchpads to 100 kHz

Breno Leitao <leitao@debian.org>
    netpoll: do not warn when the best-effort pool refill fails

Paritosh Potukuchi <paritoshpotukuchi@gmail.com>
    i2c: amd-asf: Validate firmware-reported length

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath12k: avoid setting 320MHz support on non 6GHz band

Ruoyu Wang <ruoyuw560@gmail.com>
    memory: stm32_omm: initialize ret in stm32_omm_set_amcr

Jiawen Liu <1298662399@qq.com>
    spi: bcmbca-hsspi: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: nxp-fspi: disable runtime PM on probe failures

Jiawen Liu <1298662399@qq.com>
    spi: fsl-dspi: clean up after failed suspend and resume

Damon Ding <damon.ding@rock-chips.com>
    drm/panel-edp: Add BOE NE160QDM-NY1 panel

Jiawen Liu <1298662399@qq.com>
    spi: bcm63xx-hsspi: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: bcm63xx: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: bcm-qspi: return error from failed controller suspend

Guopeng Zhang <zhangguopeng@kylinos.cn>
    fs/namespace: notify pollers of legacy propagation changes

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure

Zizhi Wo <wozizhi@huawei.com>
    fat: reject name longer than NAME_MAX in msdos_format_name()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/core: Fix kernel register info leak via hardware skid

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Validate mmap size against framebuffer size

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fallback to sw branch type decoding if no hw decoding

Bryam Vargas <hexlabsecurity@proton.me>
    iio: accel: fxls8962af: clamp the device-reported FIFO sample count

Mithil Bavishi <bavishimithil@gmail.com>
    ARM: OMAP2+: Add CFI type for omap4_finish_suspend

Joe Simmons-Talbott <joest@redhat.com>
    selftests/cgroup: Adjust cpu test duration based on HZ

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    regmap: maple: Workaround for another false-positive compiler warning

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hdmi: Fix resource cleanup on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: tlv320aic26: remove keyclick sysfs file

William Theesfeld <william@theesfeld.net>
    clk: zynq: handle kasprintf() failure in periph_clk registration

Pengpeng Hou <pengpeng@iscas.ac.cn>
    spi: qpic-snand: free OOB buffer with ECC context

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: sma1303: remove fault-check sysfs group on remove

Kemeng Shi <shikemeng@huaweicloud.com>
    irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path

Cen Zhang <zzzccc427@gmail.com>
    ALSA: usb-audio: Release components on probe errors

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: stm32: return an error when log-address wait times out

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ALSA: hda: Force resume if acomp notified during system suspend

Fu Hao <fuhao@open-hieco.net>
    ALSA: hda: Add support for Hygon family 18h model 5h HD-Audio

Kryštof Černý <cleverline1mc@gmail.com>
    w1: ds2482: add OF device match table

Ruoyu Wang <ruoyuw560@gmail.com>
    HID: wacom: avoid copying Bluetooth input reports

Christian Brauner <brauner@kernel.org>
    selftests/filesystems/overlayfs: fix set_layers_via_fds link error

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: pca9570: Use I2C match data

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: add bounds check to prevent array overflow

Gangliang Xie <ganglxie@amd.com>
    drm/amdgpu: add buf length check

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/radeon: avoid double free in r600 DPM cleanup

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix max dispclk_khz/dppclk_khz double 1000

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: Gate debugfs MMIO access on kernel lockdown

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: Validate OD DPM triples before mutating tables

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/mes_v12_0: use mes schedule pipe for legacy queues on unified MES

Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
    drm/panel-edp: Add BOE NV116WH2-M30, BOE NT116WHM-N21, BOE NV116FH1-M31, BOE NV116FH1-M30

Ryosuke Yasuoka <ryasuoka@redhat.com>
    drm/virtio: abort virtqueue wait on device removal to avoid hung task

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: line6: Clear prev_fbuf on capture buffer release

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: move bond_should_notify_peers, e.g. into rtnl lock block

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: use workqueue to make sure peer notify updated in lacp mode

Christian Brauner <brauner@kernel.org>
    coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps

Christian Brauner <brauner@kernel.org>
    fork: don't create io threads once PF_POSTCOREDUMP is set

Christian Brauner <brauner@kernel.org>
    fork: move the coredump and exec checks into create_io_thread()

Christian Brauner <brauner@kernel.org>
    exec: cancel io_uring requests before de_thread()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Rely on subsystem locking

André Draszik <andre.draszik@linaro.org>
    kbuild: link-vmlinux.sh: improve detection of third pass requirement

Ridham Khurana <khurana.ridham222@gmail.com>
    platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()

Daniel Schaefer <dhs@frame.work>
    iio: hid-sensor: als: scale each channel individually

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: wait for negotiation before receiving another PDU

Zizhen Liu <pointerliu@126.com>
    net: skbuff: propagate shared-frag marker in skb_zerocopy()


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v2.rst            |    10 +-
 Documentation/block/blk-mq.rst                     |     2 +-
 .../bindings/interrupt-controller/arm,gic-v5.yaml  |     9 +-
 Documentation/filesystems/sharedsubtree.rst        |    20 +-
 Documentation/networking/rxrpc.rst                 |    21 +-
 Makefile                                           |     7 +-
 arch/alpha/kernel/rtc.c                            |    37 +-
 arch/arm/mach-omap2/sleep44xx.S                    |     5 +-
 arch/arm/mm/mmap.c                                 |    11 +-
 arch/arm64/include/asm/runtime-const.h             |    17 +-
 arch/arm64/mm/mmu.c                                |    14 +
 arch/loongarch/include/asm/kvm_eiointc.h           |     1 +
 arch/loongarch/include/asm/kvm_ipi.h               |     1 +
 arch/loongarch/include/asm/kvm_pch_pic.h           |     1 +
 arch/loongarch/include/asm/pgtable.h               |     2 +-
 arch/loongarch/kvm/intc/eiointc.c                  |     5 +
 arch/loongarch/kvm/intc/ipi.c                      |     5 +
 arch/loongarch/kvm/intc/pch_pic.c                  |     5 +
 arch/loongarch/kvm/main.c                          |    23 +-
 arch/loongarch/kvm/vcpu.c                          |    24 +-
 arch/loongarch/mm/init.c                           |    17 +-
 arch/mips/Kconfig                                  |     3 +-
 arch/powerpc/kvm/book3s_hv.c                       |    76 +-
 arch/powerpc/kvm/book3s_paired_singles.c           |     7 +-
 arch/riscv/Kconfig.errata                          |    14 +
 arch/riscv/errata/sifive/errata.c                  |    20 +
 arch/riscv/include/asm/errata_list_vendors.h       |     3 +-
 arch/riscv/include/asm/insn-def.h                  |    16 +-
 arch/riscv/kernel/sys_hwprobe.c                    |     4 +-
 arch/riscv/kernel/traps.c                          |     3 +
 arch/riscv/kvm/mmu.c                               |     8 +-
 arch/riscv/kvm/vcpu_pmu.c                          |     9 +
 arch/riscv/net/bpf_jit_comp32.c                    |    47 +-
 arch/s390/crypto/paes_s390.c                       |   213 +-
 arch/s390/crypto/phmac_s390.c                      |    25 +-
 arch/s390/include/asm/pkey.h                       |    16 +
 arch/s390/kernel/kprobes.c                         |     3 +
 arch/s390/kernel/perf_cpum_cf.c                    |     3 +
 arch/s390/kernel/process.c                         |    12 +-
 arch/s390/kernel/signal.c                          |     6 +-
 arch/s390/lib/probes.c                             |     2 +-
 arch/s390/mm/extable.c                             |     4 +-
 arch/s390/mm/fault.c                               |     7 +-
 arch/x86/events/core.c                             |    19 +-
 arch/x86/events/intel/lbr.c                        |     2 +-
 arch/x86/events/intel/uncore.c                     |     5 +-
 arch/x86/include/asm/cpufeatures.h                 |     1 +
 arch/x86/include/asm/cpuid/api.h                   |     1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |     1 +
 arch/x86/include/asm/kvm_host.h                    |    25 +-
 arch/x86/kernel/cpu/bugs.c                         |    18 +-
 arch/x86/kernel/cpu/scattered.c                    |     1 +
 arch/x86/kernel/process.c                          |     1 +
 arch/x86/kvm/hyperv.c                              |     5 +-
 arch/x86/kvm/mmu/mmu.c                             |     8 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    39 +-
 arch/x86/kvm/regs.c                                |     3 +-
 arch/x86/kvm/svm/nested.c                          |    15 +-
 arch/x86/kvm/svm/svm.c                             |    35 +-
 arch/x86/kvm/svm/svm.h                             |     1 +
 arch/x86/kvm/vmx/common.h                          |    20 +
 arch/x86/kvm/vmx/main.c                            |    26 +
 arch/x86/kvm/vmx/nested.c                          |    41 +-
 arch/x86/kvm/vmx/posted_intr.c                     |     2 +
 arch/x86/kvm/vmx/tdx.c                             |    56 +-
 arch/x86/kvm/vmx/vmx.c                             |    33 +-
 arch/x86/kvm/vmx/x86_ops.h                         |     1 +
 arch/x86/kvm/x86.c                                 |    99 +-
 arch/x86/kvm/xen.c                                 |    18 +
 arch/x86/mm/pat/set_memory.c                       |     8 +-
 block/bdev.c                                       |    12 +
 block/blk-crypto-fallback.c                        |     6 +
 crypto/af_alg.c                                    |     2 +-
 drivers/accel/rocket/rocket_job.c                  |     2 +-
 drivers/acpi/acpi_fpdt.c                           |    55 +-
 drivers/acpi/apei/ghes.c                           |    10 +-
 drivers/acpi/battery.c                             |    14 +
 drivers/acpi/button.c                              |    11 +
 drivers/acpi/sysfs.c                               |     9 +-
 drivers/acpi/video_detect.c                        |     8 +
 drivers/ata/ata_generic.c                          |     6 +-
 drivers/ata/pata_ep93xx.c                          |    30 +-
 drivers/ata/sata_fsl.c                             |    20 +-
 drivers/base/attribute_container.c                 |     7 +-
 drivers/base/base.h                                |     1 +
 drivers/base/bus.c                                 |    45 +-
 drivers/base/core.c                                |     4 +-
 drivers/base/dd.c                                  |    92 +-
 drivers/base/regmap/regcache-maple.c               |     2 +-
 drivers/base/regmap/regmap-debugfs.c               |     1 +
 drivers/base/regmap/regmap-irq.c                   |     2 +-
 drivers/base/regmap/regmap.c                       |    15 +-
 drivers/block/drbd/drbd_receiver.c                 |     4 +-
 drivers/block/xen-blkfront.c                       |    12 +-
 drivers/bluetooth/bfusb.c                          |    37 +-
 drivers/bluetooth/btnxpuart.c                      |     4 +-
 drivers/bluetooth/btrsi.c                          |     3 +-
 drivers/bluetooth/btusb.c                          |    10 +-
 drivers/bluetooth/hci_bcsp.c                       |     5 +-
 drivers/bluetooth/hci_nokia.c                      |    20 +
 drivers/bluetooth/hci_vhci.c                       |     4 +
 drivers/bus/mhi/host/pm.c                          |    14 +-
 drivers/char/ipmi/ipmi_msghandler.c                |     1 +
 drivers/char/tpm/Kconfig                           |     3 +-
 drivers/char/tpm/tpm_tis_spi.h                     |     8 +-
 drivers/char/virtio_console.c                      |    13 +-
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |     1 +
 drivers/clk/imx/clk-imx8qxp.c                      |     1 +
 drivers/clk/mediatek/clk-mt6735-vdecsys.c          |     1 +
 drivers/clk/mediatek/clk-mt6735-vencsys.c          |     1 +
 drivers/clk/sunxi-ng/ccu_common.c                  |    12 +-
 drivers/clk/tegra/clk-pll.c                        |     1 +
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |     2 +-
 drivers/clk/zynq/clkc.c                            |     8 +
 drivers/comedi/drivers/aio_iiro_16.c               |     3 +
 drivers/comedi/drivers/das6402.c                   |    10 +-
 drivers/comedi/drivers/dt2811.c                    |     7 +-
 drivers/comedi/drivers/ni_at_a2150.c               |    13 +-
 drivers/comedi/drivers/ni_atmio16d.c               |     3 +
 drivers/comedi/drivers/pcl711.c                    |     3 +-
 drivers/comedi/drivers/pcl816.c                    |     3 +-
 drivers/comedi/drivers/pcl818.c                    |     3 +-
 drivers/comedi/drivers/pcmmio.c                    |     3 +
 drivers/comedi/drivers/pcmuio.c                    |     5 +-
 drivers/comedi/drivers/quatech_daqp_cs.c           |     4 +-
 drivers/cpufreq/rcpufreq_dt.rs                     |     1 +
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |     3 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c     |     1 +
 drivers/crypto/intel/keembay/ocs-aes.c             |     3 +-
 drivers/crypto/sa2ul.c                             |     3 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |     2 +-
 drivers/dma/pl330.c                                |    19 +-
 drivers/edac/edac_mc.c                             |     6 +-
 drivers/firmware/imx/imx-scu.c                     |    25 +-
 drivers/gpio/gpio-mvebu.c                          |    33 +-
 drivers/gpio/gpio-pca9570.c                        |     2 +-
 drivers/gpio/gpio-sifive.c                         |     1 +
 drivers/gpio/gpio-vf610.c                          |     1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    68 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c |     3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |     2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c   |    33 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |    10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |     7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |     4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |     5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |     7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c            |    11 +-
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |    61 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |     2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |     2 +
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |     4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |    27 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |     2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |    17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |     6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |     7 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |     2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |     8 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |     3 +
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |     8 +-
 .../dc/dml2/dml21/inc/dml_top_display_cfg_types.h  |    11 +
 .../dml2/dml21/inc/dml_top_soc_parameter_types.h   |     7 +-
 .../amd/display/dc/dml2/dml21/inc/dml_top_types.h  |    13 +
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |    66 +-
 .../dml2/dml21/src/dml2_core/dml2_core_factory.c   |     2 +
 .../dml21/src/dml2_core/dml2_core_shared_types.h   |    54 +-
 .../dc/dml2/dml21/src/dml2_core/dml2_core_utils.c  |     2 +
 .../dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c  |   445 +-
 .../dml21/src/inc/dml2_internal_shared_types.h     |    36 +-
 .../amd/display/dc/resource/dce60/dce60_resource.c |     7 +
 .../amd/include/asic_reg/dcn/dcn_6_0_0_offset.h    | 15799 +++++
 .../amd/include/asic_reg/dcn/dcn_6_0_0_sh_mask.h   | 58556 +++++++++++++++++++
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_offset.h  |    47 +
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_sh_mask.h |    55 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_offset.h    |    17 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_sh_mask.h   |    17 +
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |    21 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |    28 +-
 .../amd/pm/powerplay/hwmgr/process_pptables_v1_0.c |   673 +-
 .../drm/amd/pm/powerplay/hwmgr/processpptables.c   |   446 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |    36 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |    48 +-
 .../pm/powerplay/hwmgr/vega10_processpptables.c    |   623 +-
 .../pm/powerplay/hwmgr/vega12_processpptables.c    |     7 +
 .../pm/powerplay/hwmgr/vega20_processpptables.c    |     7 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |    19 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |    25 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |    32 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |    28 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |     8 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |     2 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |     4 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |    33 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |     6 +
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |     2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |    13 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |     3 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |     5 +-
 drivers/gpu/drm/panel/panel-edp.c                  |    11 +-
 drivers/gpu/drm/panel/panel-simple.c               |     3 +
 drivers/gpu/drm/panthor/panthor_sched.c            |    14 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |     5 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |    23 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |    21 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |     7 +-
 drivers/gpu/drm/sysfb/simpledrm.c                  |    24 +
 drivers/gpu/drm/virtio/virtgpu_drv.c               |    15 +
 drivers/gpu/drm/virtio/virtgpu_drv.h               |     2 +
 drivers/gpu/drm/virtio/virtgpu_kms.c               |     1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    38 +-
 drivers/gpu/drm/xe/display/intel_fb_bo.c           |     3 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |     3 +-
 drivers/gpu/drm/xe/xe_exec_queue_types.h           |    12 +
 drivers/gpu/drm/xe/xe_preempt_fence.c              |     7 +
 drivers/gpu/drm/xe/xe_vm.c                         |    18 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |     2 +-
 drivers/greybus/manifest.c                         |     2 +
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |     4 +-
 .../amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h  |     2 -
 .../hid_descriptor/amd_sfh_hid_report_desc.h       |     7 -
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c |     6 +
 drivers/hid/hid-core.c                             |     4 +-
 drivers/hid/hid-cougar.c                           |     3 +
 drivers/hid/hid-cp2112.c                           |     9 +-
 drivers/hid/hid-elecom.c                           |     6 +-
 drivers/hid/hid-elo.c                              |     3 +
 drivers/hid/hid-ids.h                              |    13 +-
 drivers/hid/hid-input.c                            |    17 +-
 drivers/hid/hid-logitech-dj.c                      |     3 +
 drivers/hid/hid-logitech-hidpp.c                   |     2 +
 drivers/hid/hid-mcp2200.c                          |     5 +
 drivers/hid/hid-mcp2221.c                          |     2 +-
 drivers/hid/hid-multitouch.c                       |    19 +-
 drivers/hid/hid-picolcd_fb.c                       |    12 +-
 drivers/hid/hid-prodikeys.c                        |     7 +-
 drivers/hid/hid-pxrc.c                             |     3 +
 drivers/hid/hid-quirks.c                           |     7 +-
 drivers/hid/hid-rmi.c                              |     2 +-
 drivers/hid/hid-roccat-isku.c                      |     3 +
 drivers/hid/hid-roccat-koneplus.c                  |     3 +
 drivers/hid/hid-roccat-konepure.c                  |     3 +
 drivers/hid/hid-roccat-kovaplus.c                  |     3 +
 drivers/hid/hid-roccat-pyra.c                      |     3 +
 drivers/hid/hid-roccat-ryos.c                      |     3 +
 drivers/hid/hid-roccat-savu.c                      |     3 +
 drivers/hid/hid-roccat.c                           |     8 +-
 drivers/hid/hid-universal-pidff.c                  |     1 +
 drivers/hid/hid-zydacron.c                         |     3 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |     6 +-
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |     5 +-
 .../intel-thc-hid/intel-quicki2c/pci-quicki2c.c    |     6 +-
 .../intel-thc-hid/intel-quickspi/pci-quickspi.c    |     3 +-
 drivers/hid/usbhid/hiddev.c                        |    37 +-
 drivers/hid/wacom_sys.c                            |   198 +-
 drivers/hid/wacom_wac.c                            |   107 +-
 drivers/hid/wacom_wac.h                            |     6 +-
 drivers/hsi/controllers/omap_ssi_core.c            |     3 +
 drivers/hv/ring_buffer.c                           |    29 +-
 drivers/hwmon/asus_rog_ryujin.c                    |   151 +-
 drivers/hwmon/lm90.c                               |    25 +-
 drivers/i2c/busses/i2c-amd-asf-plat.c              |     4 +
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |    21 +-
 drivers/i2c/busses/i2c-qup.c                       |    31 +-
 drivers/i2c/i2c-core-acpi.c                        |     1 +
 drivers/i3c/master.c                               |     3 +-
 drivers/iio/accel/fxls8962af-core.c                |     2 +
 drivers/iio/adc/max1241.c                          |     1 +
 drivers/iio/light/hid-sensor-als.c                 |    22 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |     4 +-
 drivers/infiniband/hw/irdma/i40iw_hw.c             |     4 +-
 drivers/infiniband/hw/irdma/icrdma_hw.c            |     2 +
 drivers/infiniband/hw/irdma/icrdma_hw.h            |     2 +
 drivers/infiniband/hw/irdma/icrdma_if.c            |    17 +-
 drivers/infiniband/hw/irdma/irdma.h                |     2 +
 drivers/infiniband/sw/rxe/rxe_mw.c                 |    20 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |     6 +-
 drivers/iommu/amd/amd_iommu_types.h                |     1 +
 drivers/iommu/amd/iommu.c                          |    38 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |     2 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |    16 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |     1 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    18 +-
 drivers/iommu/intel/cache.c                        |     5 +-
 drivers/iommu/iommufd/eventq.c                     |     4 +-
 drivers/iommu/rockchip-iommu.c                     |    13 +
 drivers/ipack/devices/ipoctal.c                    |    16 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |     4 +
 drivers/isdn/mISDN/l1oip_core.c                    |     2 +-
 drivers/isdn/mISDN/socket.c                        |     4 +-
 drivers/md/md.c                                    |    13 +-
 drivers/md/raid5.c                                 |    13 +-
 drivers/media/cec/core/cec-adap.c                  |     1 -
 drivers/media/cec/platform/stm32/stm32-cec.c       |    16 +-
 drivers/media/cec/platform/tegra/tegra_cec.c       |    14 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    14 +-
 drivers/media/dvb-core/dmxdev.c                    |    11 +-
 drivers/media/i2c/ov8865.c                         |    48 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |     2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |     4 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |    14 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    10 +-
 drivers/media/pci/intel/ipu-bridge.c               |     2 +-
 drivers/media/pci/ivtv/ivtv-vbi.c                  |     2 +-
 drivers/media/platform/marvell/mcam-core.c         |    14 +-
 .../media/platform/microchip/microchip-csi2dc.c    |     1 +
 .../media/platform/microchip/microchip-isc-base.c  |     6 +
 .../platform/microchip/microchip-sama5d2-isc.c     |    17 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |    17 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |     2 +
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |     4 +-
 drivers/media/rc/bpf-lirc.c                        |    18 +-
 drivers/media/rc/fintek-cir.c                      |     4 +
 drivers/media/rc/imon.c                            |     5 -
 drivers/media/rc/ir-mce_kbd-decoder.c              |     5 +-
 drivers/media/rc/lirc_dev.c                        |     3 +
 drivers/media/rc/rc-ir-raw.c                       |    66 +-
 drivers/media/rc/rc-main.c                         |    42 +-
 drivers/media/rc/redrat3.c                         |     4 +
 drivers/media/usb/au0828/au0828-dvb.c              |     1 +
 drivers/media/usb/em28xx/em28xx-audio.c            |     7 +
 drivers/media/usb/em28xx/em28xx-cards.c            |     2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    26 +-
 drivers/media/usb/go7007/go7007-driver.c           |     5 +-
 drivers/media/usb/go7007/go7007-fw.c               |    28 +-
 drivers/media/usb/go7007/s2250-board.c             |    54 +-
 drivers/media/usb/gspca/gspca.c                    |     3 +-
 drivers/media/usb/hackrf/hackrf.c                  |     7 +-
 drivers/media/usb/usbtv/usbtv-core.c               |     6 +-
 drivers/media/usb/usbtv/usbtv-video.c              |     4 +
 drivers/memory/stm32_omm.c                         |     2 +-
 drivers/mfd/axp20x.c                               |     2 +-
 drivers/mfd/ipaq-micro.c                           |     2 +-
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |    18 +-
 drivers/misc/genwqe/card_utils.c                   |     2 +-
 drivers/misc/hpilo.c                               |     7 +-
 drivers/misc/ibmvmc.c                              |    17 +-
 drivers/misc/rp1/rp1_pci.c                         |     3 +
 drivers/mmc/core/block.c                           |     5 +
 drivers/mmc/host/cqhci-core.c                      |    14 +-
 drivers/mmc/host/dw_mmc.c                          |     1 +
 drivers/mmc/host/moxart-mmc.c                      |    11 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |    13 +-
 drivers/mmc/host/sdhci-of-ma35d1.c                 |     1 +
 drivers/net/bonding/bond_3ad.c                     |     7 +-
 drivers/net/bonding/bond_main.c                    |    96 +-
 drivers/net/dsa/mt7530.c                           |    44 +-
 drivers/net/ethernet/marvell/mvneta.c              |    18 +
 drivers/net/ethernet/marvell/mvneta_bm.c           |    72 +
 .../ethernet/marvell/prestera/prestera_router.c    |     6 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |     5 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h       |     1 +
 drivers/net/ethernet/sfc/efx.c                     |     4 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |     3 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |     3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |     4 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |     6 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |    24 +
 drivers/net/pcs/pcs-mtk-lynxi.c                    |     7 +-
 drivers/net/phy/sfp.c                              |     3 +
 drivers/net/ppp/pptp.c                             |     4 +-
 drivers/net/tap.c                                  |     5 +-
 drivers/net/usb/cdc_ether.c                        |    16 +
 drivers/net/usb/pegasus.c                          |     6 +-
 drivers/net/usb/qmi_wwan.c                         |     1 +
 drivers/net/usb/rtl8150.c                          |     4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |     6 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    79 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |     6 +
 drivers/net/wireless/ath/ath12k/wmi.c              |    37 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |    10 +
 drivers/net/wireless/ath/ath9k/channel.c           |     2 +
 drivers/net/wireless/broadcom/b43/main.c           |     5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    47 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |     6 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |     6 +
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |    76 +-
 .../net/wireless/intel/iwlwifi/mld/ftm-initiator.c |    21 +
 .../net/wireless/intel/iwlwifi/mld/ftm-initiator.h |     1 +
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |    19 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.h  |     2 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |     4 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h |     4 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |     1 +
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |     2 +
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |     1 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    73 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    78 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |     4 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |     5 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |     5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     3 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    16 +-
 drivers/net/wireless/mediatek/mt76/wed.c           |     7 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |    30 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    39 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |     6 -
 drivers/net/wireless/realtek/rtw89/fw.c            |    31 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |     3 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |     3 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |     7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |     3 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |     7 +-
 drivers/net/wireless/rsi/rsi_common.h              |     2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |     2 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |     2 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |    10 +-
 drivers/net/wwan/wwan_hwsim.c                      |     4 +
 drivers/nfc/nfcmrvl/spi.c                          |     4 +
 drivers/nfc/nxp-nci/i2c.c                          |     4 +-
 drivers/nvme/host/auth.c                           |     3 +-
 drivers/nvme/host/core.c                           |     6 +-
 drivers/nvme/host/fc.c                             |     2 +-
 drivers/nvme/host/ioctl.c                          |     2 +-
 drivers/nvme/host/nvme.h                           |     6 +-
 drivers/nvme/host/pci.c                            |     6 +-
 drivers/nvme/host/sysfs.c                          |     4 +-
 drivers/nvme/host/tcp.c                            |     8 +-
 drivers/nvme/host/zns.c                            |     8 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |     3 +-
 drivers/nvme/target/fc.c                           |     8 +-
 drivers/nvme/target/passthru.c                     |     9 +
 drivers/nvme/target/pr.c                           |     2 +-
 drivers/nvme/target/tcp.c                          |     2 +-
 drivers/nvmem/brcm_nvram.c                         |    15 +-
 drivers/nvmem/core.c                               |     4 +-
 drivers/opp/core.c                                 |    54 +-
 drivers/pci/ats.c                                  |     7 +-
 drivers/pci/controller/vmd.c                       |     7 +
 drivers/pci/pci.c                                  |    25 +
 drivers/pci/pcie/portdrv.c                         |    28 +-
 drivers/pci/quirks.c                               |     1 +
 drivers/pci/switch/switchtec.c                     |     1 +
 drivers/perf/marvell_cn10k_ddr_pmu.c               |     6 +
 drivers/perf/riscv_pmu_sbi.c                       |    33 +-
 drivers/phy/phy-core.c                             |    45 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c          |    96 +-
 drivers/pinctrl/pinctrl-sx150x.c                   |     1 +
 drivers/platform/cznic/turris-omnia-mcu-base.c     |     1 +
 drivers/platform/x86/amd/hfi/hfi.c                 |     5 +
 drivers/platform/x86/amd/hsmp/acpi.c               |    15 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |     8 +
 drivers/platform/x86/asus-nb-wmi.c                 |     1 +
 drivers/platform/x86/dell/dell-smbios-wmi.c        |    69 +-
 drivers/platform/x86/intel/int1092/intel_sar.c     |     8 +-
 drivers/platform/x86/lenovo/thinkpad_acpi.c        |     1 +
 drivers/platform/x86/msi-ec.c                      |     1 +
 drivers/pmdomain/qcom/rpmhpd.c                     |    14 +-
 drivers/power/reset/piix4-poweroff.c               |     1 +
 drivers/power/supply/cros_peripheral_charger.c     |    13 +-
 drivers/power/supply/sbs-battery.c                 |    11 +
 drivers/powercap/intel_rapl_common.c               |     4 +-
 drivers/pps/generators/pps_gen.c                   |    81 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |     5 +-
 drivers/regulator/fan53555.c                       |     6 +
 drivers/regulator/rt6245-regulator.c               |     5 +-
 drivers/remoteproc/remoteproc_core.c               |   118 +-
 drivers/rpmsg/rpmsg_char.c                         |     5 +
 drivers/rtc/rtc-ab-eoz9.c                          |     1 +
 drivers/rtc/rtc-brcmstb-waketimer.c                |     1 +
 drivers/rtc/rtc-ds1307.c                           |     2 +-
 drivers/s390/block/dasd.c                          |    10 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |    22 +-
 drivers/scsi/dc395x.c                              |    10 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    10 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    15 +-
 drivers/scsi/scsi_devinfo.c                        |     2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |    36 +
 drivers/scsi/snic/snic_main.c                      |     1 +
 drivers/soc/amlogic/meson-clk-measure.c            |    14 +
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |     1 +
 drivers/soc/mediatek/mtk-dvfsrc.c                  |     1 +
 drivers/soc/qcom/socinfo.c                         |     1 +
 drivers/soundwire/dmi-quirks.c                     |    42 +-
 drivers/soundwire/intel_auxdevice.c                |     1 +
 drivers/spi/spi-bcm-qspi.c                         |     6 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |     6 +-
 drivers/spi/spi-bcm63xx.c                          |     5 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |     6 +-
 drivers/spi/spi-cadence-quadspi.c                  |     3 +-
 drivers/spi/spi-fsl-dspi.c                         |    21 +-
 drivers/spi/spi-loongson-core.c                    |     6 +-
 drivers/spi/spi-nxp-fspi.c                         |    31 +-
 drivers/spi/spi-pci1xxxx.c                         |    71 +
 drivers/spi/spi-qpic-snand.c                       |     6 +-
 drivers/spmi/spmi.c                                |     3 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |     5 +-
 drivers/target/iscsi/iscsi_target_login.c          |     2 +-
 .../intel/int340x_thermal/processor_thermal_rfim.c |    11 +-
 drivers/thunderbolt/icm.c                          |     6 +-
 drivers/thunderbolt/tb.c                           |     4 +-
 drivers/thunderbolt/test.c                         |    37 +-
 drivers/thunderbolt/tunnel.c                       |    47 +-
 drivers/thunderbolt/tunnel.h                       |     8 +-
 drivers/tty/serial/8250/8250_platform.c            |     1 +
 drivers/tty/serial/8250/8250_pnp.c                 |     1 +
 drivers/tty/serial/pch_uart.c                      |     5 +
 drivers/tty/serial/qcom_geni_serial.c              |     8 +
 drivers/tty/serial/serial_core.c                   |    91 +-
 drivers/uio/uio_sercos3.c                          |     1 +
 drivers/usb/core/driver.c                          |     1 -
 drivers/usb/core/message.c                         |     1 +
 drivers/usb/gadget/configfs.c                      |     4 +-
 drivers/usb/gadget/function/u_audio.c              |    12 +-
 drivers/usb/gadget/legacy/inode.c                  |    20 +-
 drivers/usb/gadget/udc/fsl_qe_udc.c                |     8 +-
 drivers/usb/host/xhci-ring.c                       |    27 +-
 drivers/usb/host/xhci.c                            |     4 +-
 drivers/usb/host/xhci.h                            |     9 +-
 drivers/usb/misc/cypress_cy7c63.c                  |     8 +-
 drivers/usb/misc/uss720.c                          |     1 +
 drivers/usb/mtu3/mtu3_trace.h                      |     4 +-
 drivers/usb/musb/musb_host.c                       |    14 +-
 drivers/usb/typec/mux/tusb1046.c                   |     1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    23 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |     3 +-
 drivers/video/backlight/lm3630a_bl.c               |     1 +
 drivers/video/backlight/qcom-wled.c                |    35 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |    11 +-
 drivers/video/fbdev/core/fbcon.c                   |     7 +
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |     9 +-
 drivers/video/fbdev/platinumfb.c                   |    35 +-
 drivers/video/fbdev/udlfb.c                        |    27 +-
 drivers/virtio/virtio_balloon.c                    |     6 +-
 drivers/virtio/virtio_ring.c                       |     8 +
 drivers/w1/masters/ds2482.c                        |     8 +
 drivers/xen/pvcalls-back.c                         |     2 +-
 fs/afs/rxrpc.c                                     |    63 +-
 fs/btrfs/relocation.c                              |    13 +-
 fs/ceph/caps.c                                     |    17 +-
 fs/ceph/dir.c                                      |    14 +-
 fs/ceph/inode.c                                    |     3 +-
 fs/coredump.c                                      |     2 +
 fs/dlm/lowcomms.c                                  |     6 +-
 fs/exec.c                                          |    11 +-
 fs/exfat/balloc.c                                  |    31 +-
 fs/exfat/dir.c                                     |     8 +-
 fs/exfat/namei.c                                   |    27 +-
 fs/ext4/balloc.c                                   |     4 +
 fs/ext4/ext4.h                                     |     2 +-
 fs/ext4/inode.c                                    |     7 +-
 fs/ext4/super.c                                    |    10 +-
 fs/f2fs/gc.c                                       |     9 +-
 fs/fat/namei_msdos.c                               |     3 +
 fs/fuse/dev.c                                      |     3 +-
 fs/fuse/dir.c                                      |     3 +
 fs/fuse/file.c                                     |     9 +
 fs/hfs/catalog.c                                   |    41 +-
 fs/hfs/hfs_fs.h                                    |    19 +
 fs/hfs/inode.c                                     |    13 +-
 fs/hfs/super.c                                     |     5 +
 fs/hfsplus/extents.c                               |     2 +
 fs/iomap/ioend.c                                   |    10 +-
 fs/lockd/svclock.c                                 |     2 +
 fs/namei.c                                         |    29 -
 fs/namespace.c                                     |     7 +
 fs/nfs/blocklayout/blocklayout.h                   |     5 -
 fs/nfs/blocklayout/rpc_pipefs.c                    |    79 +-
 fs/nfs/callback_proc.c                             |     3 +-
 fs/nfs/callback_xdr.c                              |     2 +-
 fs/nfs/dir.c                                       |     8 +
 fs/nfs/filelayout/filelayout.c                     |     8 +-
 fs/nfs/filelayout/filelayoutdev.c                  |    17 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    75 +-
 fs/nfs/flexfilelayout/flexfilelayout.h             |     2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |    17 +-
 fs/nfs/localio.c                                   |    16 +-
 fs/nfs/netns.h                                     |     5 +-
 fs/nfs/nfs4_fs.h                                   |     2 +
 fs/nfs/nfs4proc.c                                  |     8 +
 fs/nfs/nfs4state.c                                 |    78 +-
 fs/nfs/nfstrace.h                                  |     5 +-
 fs/nfs/pnfs.c                                      |    24 +-
 fs/nfs/pnfs.h                                      |     3 +-
 fs/nfs/pnfs_nfs.c                                  |    21 +-
 fs/nfsd/filecache.c                                |     4 +-
 fs/nfsd/flexfilelayout.c                           |    20 +-
 fs/nfsd/flexfilelayoutxdr.c                        |     4 +-
 fs/nfsd/flexfilelayoutxdr.h                        |     5 +-
 fs/nfsd/netns.h                                    |     6 +-
 fs/nfsd/nfs3acl.c                                  |    15 +
 fs/nfsd/nfs4idmap.c                                |     4 +-
 fs/nfsd/nfs4proc.c                                 |     4 +-
 fs/nfsd/nfs4recover.c                              |    78 +-
 fs/nfsd/nfs4state.c                                |   116 +-
 fs/nfsd/nfs4xdr.c                                  |    26 +-
 fs/nfsd/nfsctl.c                                   |    73 +-
 fs/nfsd/nfsproc.c                                  |    19 +-
 fs/nfsd/xdr4.h                                     |     1 +
 fs/ntfs3/attrib.c                                  |     2 +-
 fs/ntfs3/dir.c                                     |    14 +-
 fs/ntfs3/index.c                                   |     1 +
 fs/ntfs3/inode.c                                   |    10 +-
 fs/ntfs3/namei.c                                   |     9 +-
 fs/ntfs3/ntfs_fs.h                                 |     2 +
 fs/ntfs3/super.c                                   |    18 +-
 fs/ocfs2/cluster/heartbeat.c                       |    13 +-
 fs/ocfs2/cluster/netdebug.c                        |     4 +
 fs/ocfs2/cluster/nodemanager.c                     |     3 +
 fs/ocfs2/cluster/quorum.c                          |     7 +-
 fs/ocfs2/cluster/quorum.h                          |     1 +
 fs/ocfs2/cluster/tcp.c                             |     4 +-
 fs/ocfs2/dlm/dlmconvert.c                          |    10 +-
 fs/ocfs2/dlm/dlmdebug.c                            |     5 +
 fs/ocfs2/dlm/dlmdomain.c                           |     3 +-
 fs/ocfs2/dlm/dlmlock.c                             |     8 +-
 fs/ocfs2/dlmglue.c                                 |     2 +
 fs/ocfs2/file.c                                    |   100 +-
 fs/ocfs2/filecheck.c                               |     5 +-
 fs/ocfs2/quota_local.c                             |    12 +-
 fs/ocfs2/refcounttree.c                            |    15 +-
 fs/ocfs2/super.c                                   |     1 +
 fs/overlayfs/copy_up.c                             |   112 +-
 fs/overlayfs/dir.c                                 |    22 +-
 fs/overlayfs/inode.c                               |    16 +-
 fs/overlayfs/namei.c                               |    11 +-
 fs/overlayfs/overlayfs.h                           |     8 +-
 fs/overlayfs/readdir.c                             |    33 +-
 fs/overlayfs/super.c                               |    34 +-
 fs/proc/task_mmu.c                                 |     9 +-
 fs/romfs/super.c                                   |     8 +
 fs/smb/client/cached_dir.c                         |    30 +-
 fs/smb/client/cifsacl.c                            |     9 +-
 fs/smb/client/cifsfs.c                             |    62 +-
 fs/smb/client/cifsfs.h                             |     5 +-
 fs/smb/client/cifssmb.c                            |    69 +-
 fs/smb/client/connect.c                            |     6 +-
 fs/smb/client/file.c                               |     3 +-
 fs/smb/client/inode.c                              |    32 +-
 fs/smb/client/readdir.c                            |     3 +
 fs/smb/client/reparse.c                            |    40 +-
 fs/smb/client/sess.c                               |     6 +-
 fs/smb/client/smb2ops.c                            |    74 +-
 fs/smb/client/smb2pdu.c                            |    12 +-
 fs/smb/client/transport.c                          |     6 +
 fs/smb/server/auth.c                               |     3 +-
 fs/smb/server/connection.c                         |    22 +
 fs/smb/server/mgmt/user_config.c                   |     6 +-
 fs/smb/server/mgmt/user_session.c                  |     4 +-
 fs/smb/server/misc.c                               |     8 +-
 fs/smb/server/oplock.c                             |    16 +-
 fs/smb/server/server.c                             |    21 +
 fs/smb/server/smb2pdu.c                            |   423 +-
 fs/smb/server/smb2pdu.h                            |     1 +
 fs/smb/server/smb_common.c                         |     6 +-
 fs/smb/server/smbacl.c                             |    53 +-
 fs/smb/server/transport_ipc.c                      |    16 +-
 fs/smb/server/transport_rdma.c                     |     1 -
 fs/smb/server/transport_tcp.c                      |    19 +-
 fs/smb/server/vfs.c                                |   137 +-
 fs/smb/server/vfs.h                                |     3 +-
 fs/smb/server/vfs_cache.c                          |    46 +-
 fs/smb/server/vfs_cache.h                          |     2 +
 fs/udf/balloc.c                                    |    12 +-
 fs/udf/inode.c                                     |    33 +-
 fs/udf/truncate.c                                  |     2 +-
 fs/udf/udfdecl.h                                   |     3 +-
 fs/ufs/dir.c                                       |     2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    13 +
 fs/xfs/libxfs/xfs_da_btree.c                       |    14 +
 fs/xfs/libxfs/xfs_inode_fork.c                     |     4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |     8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |     2 +-
 fs/xfs/libxfs/xfs_trans_space.c                    |     6 +-
 fs/xfs/scrub/agheader.c                            |    15 +-
 fs/xfs/scrub/agheader_repair.c                     |    13 +-
 fs/xfs/scrub/alloc_repair.c                        |    11 +-
 fs/xfs/scrub/attr.c                                |    17 +-
 fs/xfs/scrub/attr_repair.c                         |    18 +-
 fs/xfs/scrub/bitmap.c                              |    20 +
 fs/xfs/scrub/bmap.c                                |     7 +
 fs/xfs/scrub/btree.c                               |    16 +-
 fs/xfs/scrub/common.c                              |     7 +-
 fs/xfs/scrub/cow_repair.c                          |    84 +-
 fs/xfs/scrub/dabtree.c                             |    27 +-
 fs/xfs/scrub/dir.c                                 |     2 +
 fs/xfs/scrub/dir_repair.c                          |     9 +-
 fs/xfs/scrub/dirtree.c                             |     4 +-
 fs/xfs/scrub/dirtree_repair.c                      |    76 +-
 fs/xfs/scrub/dqiterate.c                           |     1 +
 fs/xfs/scrub/fscounters.c                          |    38 +-
 fs/xfs/scrub/ialloc_repair.c                       |     8 +-
 fs/xfs/scrub/inode.c                               |     2 +-
 fs/xfs/scrub/inode_repair.c                        |   181 +-
 fs/xfs/scrub/iscan.c                               |     2 +-
 fs/xfs/scrub/metapath.c                            |    17 +-
 fs/xfs/scrub/newbt.c                               |    15 +-
 fs/xfs/scrub/newbt.h                               |     1 -
 fs/xfs/scrub/parent_repair.c                       |     4 +
 fs/xfs/scrub/quota.c                               |     8 +-
 fs/xfs/scrub/quota_repair.c                        |    39 +-
 fs/xfs/scrub/quotacheck_repair.c                   |    54 +-
 fs/xfs/scrub/readdir.c                             |     2 +-
 fs/xfs/scrub/reap.c                                |    65 +-
 fs/xfs/scrub/refcount.c                            |    17 +-
 fs/xfs/scrub/repair.c                              |    18 +-
 fs/xfs/scrub/repair.h                              |     2 +-
 fs/xfs/scrub/rmap.c                                |    20 +-
 fs/xfs/scrub/rtbitmap_repair.c                     |     2 +-
 fs/xfs/scrub/rtrefcount.c                          |     2 +
 fs/xfs/scrub/rtsummary.c                           |     9 +-
 fs/xfs/scrub/rtsummary.h                           |     1 +
 fs/xfs/scrub/rtsummary_repair.c                    |     2 +-
 fs/xfs/scrub/stats.c                               |     5 +-
 fs/xfs/scrub/symlink.c                             |    17 +-
 fs/xfs/scrub/trace.c                               |    13 +
 fs/xfs/scrub/trace.h                               |    10 +-
 fs/xfs/scrub/xfarray.c                             |     4 +-
 fs/xfs/xfs_dquot.c                                 |    20 +-
 fs/xfs/xfs_dquot.h                                 |     2 +-
 fs/xfs/xfs_handle.c                                |     2 +-
 fs/xfs/xfs_inode_item_recover.c                    |    20 +-
 fs/xfs/xfs_mount.c                                 |     9 +-
 fs/xfs/xfs_qm.c                                    |    42 +-
 fs/xfs/xfs_quota.h                                 |     9 +
 fs/xfs/xfs_trans_dquot.c                           |     6 +-
 include/asm-generic/bitops/le.h                    |    18 +-
 include/dt-bindings/arm/qcom,ids.h                 |     1 +
 include/linux/device.h                             |     5 +
 include/linux/device/bus.h                         |     3 -
 include/linux/hid.h                                |     1 +
 include/linux/hiddev.h                             |     2 +
 include/linux/interrupt.h                          |     2 +
 include/linux/net.h                                |     4 +-
 include/linux/pps_gen_kernel.h                     |     2 +-
 include/linux/remoteproc.h                         |     2 +
 include/linux/socket.h                             |    17 -
 include/net/af_rxrpc.h                             |     5 +-
 include/net/bonding.h                              |     2 +
 include/net/dropreason-core.h                      |     6 +
 include/net/inet_common.h                          |     2 +-
 include/net/ipv6.h                                 |     5 +-
 include/net/netfilter/nf_conntrack_expect.h        |    19 +-
 include/net/netfilter/nf_tables.h                  |     4 +
 include/net/netfilter/nf_tables_ipv4.h             |    17 +-
 include/net/netfilter/nf_tables_ipv6.h             |    16 +-
 include/net/sock.h                                 |     2 +-
 include/sound/hda_codec.h                          |     1 +
 include/trace/events/huge_memory.h                 |     6 +-
 include/trace/events/rxrpc.h                       |     2 +-
 include/trace/misc/nfs.h                           |    10 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |     1 +
 include/video/maxinefb.h                           |     4 +-
 io_uring/io-wq.c                                   |    14 +-
 io_uring/io_uring.c                                |    30 +-
 io_uring/kbuf.c                                    |     4 +-
 io_uring/net.c                                     |    23 +-
 io_uring/rsrc.c                                    |     6 +-
 io_uring/sqpoll.c                                  |    28 +-
 io_uring/sqpoll.h                                  |     3 +-
 io_uring/tctx.c                                    |     6 +-
 io_uring/timeout.c                                 |     3 +
 ipc/namespace.c                                    |     9 +-
 kernel/cgroup/cgroup.c                             |    28 +
 kernel/events/core.c                               |    37 +-
 kernel/fork.c                                      |     4 +
 kernel/irq/internals.h                             |     2 +
 kernel/irq/irqdomain.c                             |     4 +-
 kernel/irq/manage.c                                |    31 +-
 kernel/kcov.c                                      |     8 +
 kernel/kcsan/core.c                                |     7 +-
 kernel/reboot.c                                    |     9 +
 kernel/resource.c                                  |     9 +-
 kernel/sched/ext.c                                 |    23 +-
 kernel/trace/trace_events_hist.c                   |   105 +-
 lib/klist.c                                        |    16 +-
 lib/kobject_uevent.c                               |     6 +-
 mm/hugetlb.c                                       |    15 +-
 mm/khugepaged.c                                    |     4 +-
 mm/kmemleak.c                                      |    32 +-
 mm/migrate.c                                       |     6 +-
 mm/migrate_device.c                                |     6 +
 mm/page_alloc.c                                    |     4 +-
 mm/rmap.c                                          |    11 -
 mm/slab_common.c                                   |    17 +-
 mm/vmscan.c                                        |    17 +-
 net/8021q/vlan_dev.c                               |    33 +-
 net/9p/trans_fd.c                                  |     2 +-
 net/appletalk/ddp.c                                |     2 +-
 net/atm/pvc.c                                      |     4 +-
 net/atm/svc.c                                      |     2 +-
 net/ax25/af_ax25.c                                 |     2 +-
 net/bluetooth/Kconfig                              |     2 +-
 net/bluetooth/bnep/Kconfig                         |     2 +-
 net/bluetooth/hci_event.c                          |     7 +
 net/bluetooth/hci_sock.c                           |     2 +-
 net/bluetooth/hci_sync.c                           |    30 +
 net/bluetooth/hidp/Kconfig                         |     2 +-
 net/bluetooth/iso.c                                |     4 +-
 net/bluetooth/l2cap_sock.c                         |     2 +-
 net/bluetooth/rfcomm/Kconfig                       |     2 +-
 net/bluetooth/rfcomm/core.c                        |     4 +-
 net/bluetooth/rfcomm/sock.c                        |     2 +-
 net/bluetooth/sco.c                                |     2 +-
 net/bridge/netfilter/ebtables.c                    |    12 +-
 net/can/isotp.c                                    |     2 +-
 net/can/j1939/socket.c                             |     2 +-
 net/can/raw.c                                      |     2 +-
 net/ceph/mon_client.c                              |     2 +-
 net/core/netpoll.c                                 |     2 +-
 net/core/rtnetlink.c                               |     4 +
 net/core/skbuff.c                                  |     2 +
 net/core/sock.c                                    |     2 +-
 net/ieee802154/socket.c                            |     4 +-
 net/ipv4/af_inet.c                                 |     4 +-
 net/ipv4/inet_connection_sock.c                    |     2 +-
 net/ipv4/ip_gre.c                                  |    42 +-
 net/ipv4/metrics.c                                 |     5 +
 net/ipv4/netfilter/nf_nat_h323.c                   |    22 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |     6 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |     2 +-
 net/ipv4/udp_tunnel_core.c                         |     2 +-
 net/ipv6/af_inet6.c                                |     4 +-
 net/ipv6/exthdrs_core.c                            |     7 +
 net/ipv6/ip6_gre.c                                 |     5 +-
 net/ipv6/ip6_input.c                               |     5 +
 net/ipv6/ip6_tunnel.c                              |     4 +
 net/ipv6/ip6_udp_tunnel.c                          |     2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |     8 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |     2 +-
 net/ipv6/udp.c                                     |    13 +
 net/iucv/af_iucv.c                                 |     2 +-
 net/l2tp/l2tp_core.c                               |     4 +-
 net/llc/af_llc.c                                   |     2 +-
 net/mac80211/ibss.c                                |     4 +-
 net/mctp/af_mctp.c                                 |     2 +-
 net/mctp/test/route-test.c                         |     2 +-
 net/mctp/test/utils.c                              |     2 +-
 net/mptcp/protocol.c                               |     6 +-
 net/mptcp/subflow.c                                |     2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |     4 +-
 net/netfilter/nf_conntrack_core.c                  |    33 +-
 net/netfilter/nf_conntrack_expect.c                |   180 +-
 net/netfilter/nf_conntrack_h323_main.c             |     4 +-
 net/netfilter/nf_conntrack_helper.c                |    10 +-
 net/netfilter/nf_conntrack_netlink.c               |    24 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |     6 +-
 net/netfilter/nf_conntrack_sip.c                   |    13 +-
 net/netfilter/nf_nat_sip.c                         |    20 +-
 net/netfilter/nf_tables_api.c                      |    34 +-
 net/netfilter/nf_tables_core.c                     |     2 +-
 net/netfilter/nfnetlink_queue.c                    |   242 +-
 net/netfilter/nft_ct.c                             |     3 +-
 net/netfilter/nft_meta.c                           |    60 +-
 net/netfilter/nft_payload.c                        |   314 +-
 net/netfilter/nft_rt.c                             |     6 +-
 net/netfilter/nft_xfrm.c                           |     9 +-
 net/netlink/af_netlink.c                           |     2 +-
 net/netrom/af_netrom.c                             |     2 +-
 net/nfc/llcp_sock.c                                |     4 +-
 net/packet/af_packet.c                             |    11 +-
 net/phonet/socket.c                                |     8 +-
 net/qrtr/af_qrtr.c                                 |     2 +-
 net/qrtr/ns.c                                      |     2 +-
 net/rds/bind.c                                     |     2 +-
 net/rds/ib_rdma.c                                  |     4 +-
 net/rds/message.c                                  |    26 +
 net/rds/rdma.c                                     |    63 +-
 net/rds/rds.h                                      |    17 +-
 net/rds/send.c                                     |    18 +-
 net/rds/tcp_connect.c                              |     2 +-
 net/rds/tcp_listen.c                               |     2 +-
 net/rose/af_rose.c                                 |     2 +-
 net/rxrpc/af_rxrpc.c                               |     2 +-
 net/rxrpc/recvmsg.c                                |    22 +-
 net/rxrpc/rxperf.c                                 |    43 +-
 net/rxrpc/sendmsg.c                                |    86 +-
 net/sched/act_ct.c                                 |     5 +-
 net/sched/act_ife.c                                |     4 +
 net/sched/cls_bpf.c                                |    28 +-
 net/sched/cls_flower.c                             |    50 +-
 net/sched/sch_generic.c                            |    10 +-
 net/sched/sch_teql.c                               |    60 +-
 net/sctp/associola.c                               |     4 +
 net/sctp/endpointola.c                             |     4 +
 net/smc/af_smc.c                                   |     2 +-
 net/smc/smc.h                                      |     2 +-
 net/socket.c                                       |     6 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |    29 +-
 net/sunrpc/clnt.c                                  |     4 +-
 net/sunrpc/svc.c                                   |     9 +-
 net/sunrpc/svc_xprt.c                              |    24 +-
 net/sunrpc/svcauth_unix.c                          |     7 +
 net/sunrpc/svcsock.c                               |    88 +-
 net/sunrpc/xprtsock.c                              |     4 +-
 net/tipc/socket.c                                  |     4 +-
 net/unix/af_unix.c                                 |     4 +-
 net/vmw_vsock/af_vsock.c                           |     4 +-
 net/wireless/nl80211.c                             |     4 +
 net/x25/af_x25.c                                   |     2 +-
 net/xdp/xsk.c                                      |     2 +-
 net/xdp/xsk_queue.c                                |    12 +-
 rust/kernel/bitmap.rs                              |    70 +-
 rust/kernel/block/mq/gen_disk.rs                   |    10 +-
 rust/kernel/block/mq/operations.rs                 |     2 +-
 rust/kernel/bug.rs                                 |     2 +-
 rust/kernel/configfs.rs                            |    43 +-
 rust/kernel/cpufreq.rs                             |    22 +-
 scripts/kconfig/conf.c                             |    17 +
 scripts/link-vmlinux.sh                            |    20 +-
 security/apparmor/include/policy_ns.h              |    16 +
 security/apparmor/mount.c                          |     4 +-
 security/apparmor/policy_ns.c                      |     2 +-
 security/landlock/fs.c                             |    10 +-
 sound/core/control.c                               |     2 +
 sound/drivers/pcmtest.c                            |    42 +-
 sound/hda/codecs/conexant.c                        |    26 +-
 sound/hda/codecs/hdmi/hdmi.c                       |     5 +-
 sound/hda/codecs/realtek/alc269.c                  |   109 +-
 sound/hda/codecs/realtek/realtek.c                 |     6 +
 sound/hda/common/codec.c                           |    11 +-
 sound/hda/controllers/intel.c                      |    18 +
 sound/hda/core/device.c                            |     1 +
 sound/soc/amd/acp-config.c                         |    14 +
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |     8 +
 sound/soc/amd/ps/acp63.h                           |     8 +
 sound/soc/amd/ps/pci-ps.c                          |     2 +
 sound/soc/amd/ps/ps-common.c                       |     2 +
 sound/soc/amd/yc/acp6x-mach.c                      |    21 +
 sound/soc/codecs/cs35l56-sdw.c                     |     2 +
 sound/soc/codecs/cs35l56-shared.c                  |     4 +
 sound/soc/codecs/cs35l56.c                         |     1 +
 sound/soc/codecs/hdac_hdmi.c                       |    10 +-
 sound/soc/codecs/max98396.c                        |    24 +-
 sound/soc/codecs/max98926.c                        |     2 +-
 sound/soc/codecs/rt712-sdca.c                      |     1 +
 sound/soc/codecs/rt712-sdca.h                      |     1 +
 sound/soc/codecs/sma1303.c                         |     2 +
 sound/soc/codecs/tlv320aic26.c                     |     6 +
 sound/soc/codecs/uda1342.c                         |     9 +-
 sound/soc/generic/audio-graph-card2.c              |     3 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |    17 +
 sound/soc/sof/intel/mtl.c                          |    23 +
 sound/synth/emux/emux_synth.c                      |     3 +
 sound/synth/emux/soundfont.c                       |     9 +-
 sound/usb/card.c                                   |    70 +-
 sound/usb/line6/pcm.c                              |     8 +
 sound/usb/mixer_maps.c                             |    27 +
 sound/usb/quirks-table.h                           |    22 +
 sound/usb/quirks.c                                 |     4 +
 sound/usb/usx2y/usbusx2yaudio.c                    |     1 -
 tools/lib/api/fd/array.c                           |     5 +-
 tools/lib/bpf/libbpf.c                             |    10 +-
 tools/lib/bpf/ringbuf.c                            |     2 +-
 tools/lib/thermal/include/thermal.h                |     4 +-
 tools/objtool/check.c                              |     1 +
 tools/power/x86/turbostat/turbostat.c              |    22 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |     3 +
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |     2 +-
 .../selftests/cgroup/lib/include/cgroup_util.h     |     1 +
 tools/testing/selftests/cgroup/test_cpu.c          |    43 +-
 .../filesystems/overlayfs/set_layers_via_fds.c     |    16 +-
 tools/testing/selftests/ftrace/ftracetest          |     3 +
 tools/testing/selftests/net/fin_ack_lat.c          |     2 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |    24 +
 tools/testing/selftests/ublk/.gitignore            |     6 +-
 tools/testing/selftests/ublk/Makefile              |    11 +-
 tools/testing/selftests/ublk/metadata_size.c       |    36 +
 tools/testing/selftests/ublk/settings              |     1 +
 virt/kvm/kvm_main.c                                |    31 +-
 969 files changed, 86932 insertions(+), 4449 deletions(-)


