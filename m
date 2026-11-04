Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826756;
	b=DNYoSV5Hdfp1ZHY9AbQs+CXRUxBYE6dxtHZzj0di5OMv6wBh2K7b3qwKDATf4ZnHkfcU
	 wxSVdiCjSodb7dM6iU5h0rZwSadnX/AlhV7qIrO5BwcV60MOFkAE23DkBTP2y5TxeKqVZ
	 JucNel13iVf5w9HB61lCoutmPVDt6aAW7p3OkJdxW+9SVG2y48AcLCAFYk6ll3U/zgzDL
	 7kU3YpoVkgIqS6bUbVdbFVFppwDV3QgcuhtvhAivhdA27OO3oljlYbKpA2K/75w/FyO2k
	 iIf2PxzXmcQSELkjAUh6ORmznDmXyPgehTCH6j6a1ZvIn0pIO+thA8fBofn4PMG3kIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=U+XTEhTBXVeSm7ZLCeBxpS21vzRgJBTHBd5Kwy2tJoY=;
	b=OnCT68H4TFhWSL8HomyJYH6f8FCgksBydFFuQYi18v5NlbD/rG4Yu/tsmAJsRamH+XKG
	 06PUnTrsXaJhms+DTrlDmHu3WiablxY3dMj6bjGoh2fWpQjqiZtas2GjGGHQvWaIvIHJm
	 oxnG8/+CuSUexzXpHA83j4Obc4Fv8jg1tluIYpObTYesxIrb8cthGapoQlY31xf23NxRb
	 SXyN+nWmMylh86c1Znxich8W0w7fjLEYbX8M60QWTzOB8pcYCmvquCLxruvP/ZPyzBKlA
	 ldg37Zwtd/q2vHOTMXlT6jnhM/YDg1MH1MPpbMIobgOzGwM+E9f/+4gl0LjI4HJ7zMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/rS2qoK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074560AB030;
	Wed,  4 Nov 2026 21:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/rS2qoK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF061F00A15;
	Wed,  4 Nov 2026 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826754;
	bh=U+XTEhTBXVeSm7ZLCeBxpS21vzRgJBTHBd5Kwy2tJoY=;
	h=From:To:Cc:Subject:Date;
	b=m/rS2qoK/+6ypWJQtVWaOynM0ju9jWWV0LhfbB1jKY/DGdcsiADTNJc+FrkMed+aK
	 37+XnVDSGf4k9d36vwz6TATVJ7W6clayOtOPDJqX60JX1FY/Oq6UJvtrnni5KYlX8z
	 KgSs0IsLomqoXT4dsKW/DFfp7ONaL/oWjRLzTcbc=
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
Subject: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Wed,  4 Nov 2026 16:03:04 -0500
Message-ID: <20261104211038.406938024@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.3.2-rc1
X-KernelTest-Deadline: 2026-11-06T21:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.3.2 release.
There are 547 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.3.2-rc1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: keep retry timeout clamp bounds constant

Sean Young <sean@mess.org>
    media: rc: Fix build failure with CONFIG_LIRC disabled

Alice Ryhl <aliceryhl@google.com>
    rust_binder: wake epoll on self-work queued to poll thread

Ian Bridges <icb@fastmail.org>
    ksmbd: fix use-after-free after a failed durable reconnect

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rebind completed CREATE replays without draining the old channel

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix named stream write and EOF handling

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: use the existing xattr name for a named stream

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid pointer dereference when get_inode_acl() fails

Ian Bridges <icb@fastmail.org>
    ksmbd: fix app-instance non-durable supersede session UAF

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: retry break notifications on another connection

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: track delivery of queued TCP writes

Daijiamu <3058704216@qq.com>
    ksmbd: use clear_and_wake_up_bit() directly

Ian Bridges <icb@fastmail.org>
    ksmbd: fix out-of-bounds read when padding the final compound response

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ksmbd: fix SMB2 CREATE response buffer overflow

Cheng Yongkang <teel4res@gmail.com>
    io_uring/net: fix multishot recv length limit accounting

Cheng Yongkang <teel4res@gmail.com>
    io_uring/timeout: count cancelled timeouts in cq_timeouts

Kyle Zeng <kylebot@openai.com>
    io_uring: defer foreign io-wq enqueues to task_work

Chris Mason <mason@kernel.org>
    io_uring/sqpoll: don't wait for the thread to exit

Chris Mason <mason@kernel.org>
    io_uring: free the task context after a grace period

Chris Mason <mason@kernel.org>
    io_uring/bpf-ops: clear bpf_ctx while submitting SQEs

Chris Mason <mason@kernel.org>
    io_uring: free XArray nodes left by a failed store

Chris Mason <mason@kernel.org>
    io_uring: charge tctx nodes and personalities

Chris Mason <mason@kernel.org>
    io_uring/rsrc: charge buffer arrays and nodes to memcg

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: no new workers once the exit has begun

Jens Axboe <axboe@kernel.dk>
    io_uring: keep the drain active when a deferred drain request is started

Daan De Meyer <daan@amutable.com>
    io_uring/net: don't retry a non-blocking connect() that fails with -EAGAIN

Dominik Maier <dmnk@google.com>
    io_uring/register: enforce per-task restrictions in io_uring_register_blind()

Dominik Maier <dmnk@google.com>
    io_uring/net: mask socket type with SOCK_TYPE_MASK in io_socket_bpf_populate()

Yichong Chen <chenyichong@uniontech.com>
    io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT

Yichong Chen <chenyichong@uniontech.com>
    io_uring/kbuf: advance head when a pickup empties the buffer ring

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Add support for AIE2 revision 9

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Use devm_kzalloc for drvdata

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Move static led_classdev_mc to drvdata struct

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Add kobject_uevent notify during reset-resume

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Reorganize and rename hid_gos_cfg

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Move attribute init to after device query

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Bound stale reply window before reusing send_cmd_complete

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Add suspend function and gate access under bool.

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Use pm_ptr for reset_resume callback

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Return ret instead of 0 in mcu_property_out()

Derek J. Clark <derekjohn.clark@gmail.com>
    HID: hid-lenovo-go-s: Prevent deadlock if device removed during setup

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

Myeonghun Pak <mhun512@gmail.com>
    HID: mcp2221: always initialize and cancel init_work

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

Panz Dev <panz.development@gmail.com>
    HID: asus: do not send keyboard init reports to touchpads

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Use report type from request node

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Remove unsupported motion-state field from accelerometer report

Jiale Yao <yaojiale02@163.com>
    HID: zydacron: validate key report length

Ahmed Yaseen <yaseen@ghoul.dev>
    HID: usbhid: skip interrupt IN polling for devices with no input reports

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready

Shivank Garg <shivankg@amd.com>
    KVM: guest_memfd: take the invalidate lock when unbinding a dying file

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Split bind() into prepare()+commit() phases

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Enable Bus Lock VM exit

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Don't assume exit_reason[31:16] is all-0 in tdx_to_vmx_exit_reason()

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Stuff exit_reason with UNDEFINED on wait_for_sept_zap return

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Set bits 31:16 to 0 and use UNDEFINED when synthesizing exit reason

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
    KVM: VMX: Formally define KVM's "0xdead" exit reason used for failed VM-Enter

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Disallow using to_vmx() in common VT code

Sean Christopherson <seanjc@google.com>
    KVM: Use goto to handle errors during memslot preparation

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch

Sean Christopherson <seanjc@google.com>
    KVM: Only bind memslot to guest_memfd instance for CREATE operations

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: x86: hdmi: fix chmap array missing terminator entry

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

Chuck Lever <cel@kernel.org>
    SUNRPC: Treat every TLS error alert as fatal

Ameer Hamza <ameer.hamza@truenas.com>
    sunrpc: treat empty auth.unix.gid replies as negative entries

Zhiling Zou <zhilinz@nebusec.ai>
    SUNRPC: trace an accepted transport before publishing it

Chuck Lever <cel@kernel.org>
    SUNRPC: Resume receiving after a TLS control record

Chuck Lever <cel@kernel.org>
    SUNRPC: Reject a TLS alert record that is not two octets

Chuck Lever <cel@kernel.org>
    SUNRPC: Reject a socket that already has an svc_sock attached

Chris Mason <clm@meta.com>
    sunrpc: pin gss module across auth_domain RCU free

Jeff Layton <jlayton@kernel.org>
    SUNRPC: keep the first error in svc_register()

Ameer Hamza <ameer.hamza@truenas.com>
    sunrpc: honor the netlink unix_gid NEGATIVE flag

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: fix oversized GSS proxy token copy

Chuck Lever <cel@kernel.org>
    SUNRPC: Do not credit control-record octets to the RPC stream

Chuck Lever <cel@kernel.org>
    SUNRPC: Copy the deferred RPC Call from the head buffer

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: zero NFSv4 COMPOUND tag padding

Jeff Layton <jlayton@kernel.org>
    NFSD: validate transport name in listener_set before serv creation

Chuck Lever <cel@kernel.org>
    NFSD: Set nn->cld_net before registering the cld pipe

Chuck Lever <cel@kernel.org>
    NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file

Chuck Lever <cel@kernel.org>
    NFSD: Resolve the recall-any mask names in the trace format

Chuck Lever <cel@kernel.org>
    NFSD: Reject an oversized principal hash from nfsdcld

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: propagate SETXATTR value decode errors

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nfsd: preflight SEQUENCE replies before accepting a slot

Chuck Lever <cel@kernel.org>
    NFSD: Map flex file layout IDs through the request's user namespace

Chuck Lever <cel@kernel.org>
    NFSD: map fh_verify() status codes for NFS_ACLv3 replies

NeilBrown <neil@brown.name>
    nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    nfsd: hold cl_lock in client_has_openowners()

Chuck Lever <cel@kernel.org>
    NFSD: Fix out-of-bounds read in the rpc_status dump

Wentao Liang <vulab@iscas.ac.cn>
    nfsd: Fix id-to-name cache entry leak in idtoname_parse()

David Flynn <david.flynn@hammerspace.com>
    nfsd: fetch direct I/O alignment for files handed to the filecache

Chuck Lever <cel@kernel.org>
    NFSD: Fail a pool_threads read whose reply does not fit

Jeff Layton <jlayton@kernel.org>
    nfsd: don't offer flexfiles layouts when NFSv3 isn't being served

Ameer Hamza <ameer.hamza@truenas.com>
    nfsd: don't modify a session slot when replaying its cached reply

Chuck Lever <cel@kernel.org>
    NFSD: Don't complete a cld upcall the daemon has not read

Chuck Lever <cel@kernel.org>
    NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients

Chuck Lever <cel@kernel.org>
    NFSD: Destroy a recalled delegation the client does not hold

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

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: detect a short read or write before the iterator has moved

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a regression in the handling of CB_RECALL_ANY

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: Free the netid when draining a data-server address list

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating

Chuck Lever <cel@kernel.org>
    pnfs/blocklayout: Complete a device upcall when the pipe is closed

Chuck Lever <cel@kernel.org>
    pnfs/blocklayout: Complete a device upcall only on its own reply

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: don't lose IN_DELETE_SELF when decoding a file handle

Daejun Park <daejun7.park@samsung.com>
    xfs: map pNFS layouts to the end of the extent again

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: validate the data area in SMB2_read()

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate SMB1 EA list bounds before parsing

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate NT transaction response layout and offsets

Paulo Alcantara <pc@manguebit.org>
    smb: client: require stable pages for SMB compression

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: reject short SESSION_SETUP responses

Diego Oliva <diego@bynar.io>
    smb: client: reject short or out-of-range FIND response parameters

Diego Oliva <diego@bynar.io>
    smb: client: reject FIND data areas that run past the received response

Paulo Alcantara <pc@manguebit.org>
    smb: client: reclaim credits for decrypted reads with no matching mid

Dominik Maier <dmnk@google.com>
    smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: fix fiemap wild read on empty truncated response

Luxiao Xu <rakukuip@gmail.com>
    smb: client: fix buffer overflow in SMB2_tcon()

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't resurrect an exiting tcon from cached dir workers

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: bound POSIX lock data area by response length

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: fix buffer length underflow in RDMA transfers

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

Andrea Parri <parri.andrea@gmail.com>
    rtnetlink: wait for RCU readers in rtnl_link_unregister()

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: restrict checksum offsets to known values

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

Amir Goldstein <amir73il@gmail.com>
    ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN

Chris Mason <mason@kernel.org>
    ovl: fix a torn path in ovl_get_redirect()

Chris Mason <mason@kernel.org>
    ovl: do not copy up an xattr value that was never read

Chris Mason <mason@kernel.org>
    ovl: do not copy up a dentry that was removed

Chris Mason <mason@kernel.org>
    ovl: check the casefold flag of directories only

Chris Mason <mason@kernel.org>
    ovl: check that the parents of volatile/dirty are dirs

Chris Mason <mason@kernel.org>
    ovl: always encode the origin fh when index is enabled

Chris Mason <mason@kernel.org>
    ovl: use the pinned upper dir in ovl_fix_origin()

Chris Mason <mason@kernel.org>
    ovl: take a snapshot of the name for copy up

Chris Mason <mason@kernel.org>
    ovl: set OVL_WHITEOUTS before publishing the upper dir

Chris Mason <mason@kernel.org>
    ovl: hold a reference on the parent in readdir

Weiming Shi <bestswngs@gmail.com>
    smb: client: stop processing a read response after a receive error

Eduard Zateev <hackerowskiy@gmail.com>
    smb: client: hold server info until cifsd exits

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
    media: rc: Fix race condition during rc_register_device()

Sean Young <sean@mess.org>
    media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister

Weigang He <geoffreyhe2@gmail.com>
    media: rc: fintek-cir: process a full RX buffer instead of overflowing it

Sean Young <sean@mess.org>
    media: rc: Ensure registered is cleared in error path

Sean Young <sean@mess.org>
    media: rc: Ensure that rc_unregister_device() does not free input device

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF

Janne Grunau <j@jannau.net>
    nvmem: core: Fix OOB read for bit offsets of more than one byte

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: don't use the driver's info after unregister

Myeonghun Pak <mhun512@gmail.com>
    power: supply: sbs-battery: disable polling before supply teardown

Myeonghun Pak <mhun512@gmail.com>
    power: supply: pf1550: drain IRQ work before unregistering supplies

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

Andrea Parri <parri.andrea@gmail.com>
    vfio/nvgrace-gpu: Use a core-only open_device in fallback mode

Weiming Shi <bestswngs@gmail.com>
    virtio_net: atomically disable rx mode work

Zhao Li <enderaoelyther@gmail.com>
    wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: delete channel-context timers on deinit

Yuchao Zhang <ndaugoing@gmail.com>
    xen-blkfront: unbind irq before tearing down ring and shadow requests

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix protected RX frame validation in decrypt path

Igor Putko <igorpetindev@gmail.com>
    serial: core: shut down initialized port on removal

Fan Wu <fanwu01@zju.edu.cn>
    scsi: dc395x: sync the waiting_timer before freeing the host

Kyle Zeng <kylebot@openai.com>
    net: sched: prevent scheduling deactivated qdiscs

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    mtd: virt-concat: unlink discarded items before freeing

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    mtd: virt-concat: unlink concat node before freeing it

Daehyeon Ko <4ncienth@gmail.com>
    mshv_vtl: detach poll waiter on POLLFREE

Ruide Cao <caoruide123@gmail.com>
    mptcp: hold MP_JOIN msk ref when cloning reqsk

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix swap entry value to folio_pfn()

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after pte_unmap_unlock()

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after folio_put/unlock()

Zhang Yi <yi.zhang@huawei.com>
    mm/truncate: look up the end-edge straddler by index

Imre Kaloz <kaloz@kernel.org>
    mm/slab: sample slab_state once in kmem_cache_destroy()

Zi Yan <ziy@nvidia.com>
    mm/rmap: don't discard lazyfree THPs at PMD level

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

David Woodhouse <dwmw@amazon.co.uk>
    KVM: pfncache: use a dedicated invalidation sequence for cache refresh

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot

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

Eric Biggers <ebiggers@kernel.org>
    fsverity: Set S_VERITY only after rollback is no longer possible

Ngoc Quy <ngocquy0700@gmail.com>
    fs/proc/task_mmu: pin mm_users in do_pagemap_scan()

Zhao Gongyi <zhaogongyi@bytedance.com>
    filelock: keep superblock active through delegation wait

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

Eva Crystal <0xiviel@gmail.com>
    accel/amdxdna: clear the mailbox channel pointer when starting it fails

Frank Zhang <rmxpzlb@gmail.com>
    rust: rcpufreq_dt: add module alias

Priya Bala Govindasamy <pgovind2@uci.edu>
    rust: module_param: Fix potentially incorrect access of `SetOnce<T>`

Alice Ryhl <aliceryhl@google.com>
    rust: fwctl: declare cfi_encoding for fwctl_rpc_scope

Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>
    rust: cpufreq: reject NULL from cpufreq_cpu_get()

Andreas Hindborg <a.hindborg@kernel.org>
    rust: configfs: fix data offset calculation for subsystem callbacks

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: update the SAFETY comment for warn_slowpath_fmt() on UML

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: pass TAINT_WARN to warn_slowpath_fmt() on UML

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: require `Sync` for `Operations::QueueData`

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: fix `Send` bound for `GenDisk`

Eliot Courtney <ecourtney@nvidia.com>
    rust: bitmap: restrict bitmap length to at most i32::MAX

Lorenzo Stoakes <ljs@kernel.org>
    rust: bindings: fix VM_MAYSHARE value

Miguel Ojeda <ojeda@kernel.org>
    rust: bindings: fix `VM_MAYSHARE` blocklist entry

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
    s390/zcrypt: Guard domain index uses against speculative bypass

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix and improve zcrypt reply message verification checks

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/vmcp: Initialize full session info to zero

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

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Add error cleanup in zpci_directed_irq_init()

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Fix use-after-free race in zpci floating interrupt cleanup

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Fix resource leak in zpci MSI setup

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Fix MSI directed-mode teardown IRQ bit count

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Fix double-free and NULL deref in zpci MSI domain cleanup

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

Yibo Tan <lhfff@tju.edu.cn>
    media: ipu-bridge: Fix use-after-free in IVSC error path

Deepanshu Kartikey <kartikey406@gmail.com>
    media: imon: fix use-after-free in display_close via dev_dbg

Anuj Bolewar <bolewara@gmail.com>
    media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path

Pei Xiao <xiaopei01@kylinos.cn>
    media: cx23885: Fix use-after-free in cx23885_finidev due to race condition

Fan Wu <fanwu01@zju.edu.cn>
    media: au0828: fix use-after-free in bulk_timeout timer on disconnect

Chuck Lever <cel@kernel.org>
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

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: fix use-after-free unregistering kbd_led led

Fan Wu <fanwu01@zju.edu.cn>
    PM: EM: Fix use-after-free of perf domain in netlink doit handlers

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: fix use-after-free when closing a removed device

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in mport_mm_close()

Guangshuo Li <lgs201920130244@gmail.com>
    RDMA/irdma: avoid use-after-free in icrdma_remove

Deep Shah <deepshah146@gmail.com>
    RDMA/uverbs: Fix DMABUF use-after-free during ufile cleanup

Tejun Heo <tj@kernel.org>
    sched_ext: Fix use-after-free of a local reenq node left on an inactive cpu

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

Daehyeon Ko <4ncienth@gmail.com>
    cgroup: serialize migrations of newly forked processes

Eric Dumazet <edumazet@kernel.org>
    vlan: restore HW VLAN tag insertion with reorder_hdr off

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: verify transform SessionId matches the decrypted header

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate security descriptor offsets before pointer arithmetic

Sung Byeongchan <tjdqudcks0424@naver.com>
    ksmbd: validate AppInstanceId takeover target

Karl Mehltretter <kmehltretter@gmail.com>
    ksmbd: use u8 for SMB2 oplock level values

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: return end of file for reads past a named stream's data

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: restore Kerberos logins with released ksmbd-tools

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: reserve space for the UTF-16 terminator in stream info

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reclaim ended sessions on logoff and expiration

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent stale data from being written by SMB2 WRITE requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent share root removal through empty paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent session binding in compound requests

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: preserve unreadable named streams on open

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit sessions on each connection

Jan Koester <j.koester@act-marketing.de>
    ksmbd: ignore network devices of other namespaces

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: hold a connection reference for each session channel

Ian Bridges <icb@fastmail.org>
    ksmbd: fix session reference leak on compounded SESSION_SETUP

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    ksmbd: fix parent dentry lifetime in directory enumeration

Giorgi Kobakhia <gkobakhi@asu.edu>
    ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix extended session security negotiation for raw NTLMSSP

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: drain session procfs readers before dropping table references

Aamir Ahmed <elb12345@hotmail.co.uk>
    ksmbd: deny access for an empty DACL instead of granting the request

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: defer connection scavenging while session locks are busy

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

Mario Peter <mario.peter@leica-geosystems.com>
    driver core: take parent lock in async device attach

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

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Fix standalone IRSes OF probe

Lorenzo Pieralisi <lpieralisi@kernel.org>
    dt-bindings: interrupt-controller: gicv5: Relax IRS properties constraints

Darrick J. Wong <djwong@kernel.org>
    xfs: fix integer overflow problem when setting large free areas

Bui Viet Dung <dungvn2345@gmail.com>
    wwan: wwan_hwsim: Pin module for debugfs file operations

Giorgi Kobakhia <gkobakhi@asu.edu>
    udf: fix return value for non-recorded-allocated extents in udf_map_block()

Jonathan Gopel <jgopel@gmail.com>
    thunderbolt: Do not RPM complete unrelated subtrees on unplug

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix early procfs exposure race

Zikang Gao <2715417602@qq.com>
    smb: client: do not pass a NULL buf to is_oplock_break()

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

Aleksandr Nogikh <nogikh@google.com>
    media: usbtv: fix null-pointer dereference on disconnect

Xiang Mei <xmei5@asu.edu>
    media: go7007: only set audio_enabled if go7007_snd_init() succeeded

Xiang Mei <xmei5@asu.edu>
    media: em28xx: reject audio endpoint with zero packet size

Myeonghun Pak <mhun512@gmail.com>
    media: cx88: Disable PCI device on MPEG initialization failure

Xiang Mei <xmei5@asu.edu>
    libceph: bound mon_command ack decode to front len

Yongjun Gwon <d3bugee@gmail.com>
    ksmbd: serialize directory emptiness checks with readdir

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

ck.chang <ck.chang@mediatek.com>
    wifi: mt76: mt7925: fix reset panic caused by the WM2 rx irq mask

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: forget a peer's RPA once it advertises its identity address

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: line6: Clear prev_fbuf on capture buffer release

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: r9a08g046: Propagate clk rate for ETH TX mux clocks

Christian Brauner <brauner@kernel.org>
    fork: don't create io threads once PF_POSTCOREDUMP is set

Christian Brauner <brauner@kernel.org>
    fork: move the coredump and exec checks into create_io_thread()

Christian Brauner <brauner@kernel.org>
    exec: cancel io_uring requests before de_thread()

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't lose a cancel as io-wq arms a timeout

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't flush with the sequence behind the last flush

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't put a sequence target behind the last flush

Josef Bacik <josef@toxicpanda.com>
    io_uring: look up the file before queueing to io-wq

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: don't end a linked timeout with 1

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: no ABS update of multishot timeouts

Josef Bacik <josef@toxicpanda.com>
    io_uring/net: don't retry recv on uncommitted buffers

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't pass restart error codes to userspace

Josef Bacik <josef@toxicpanda.com>
    io_uring/openclose: keep the lock in io_pipe_fixed()

Josef Bacik <josef@toxicpanda.com>
    io_uring/sqpoll: let the thread sleep on disabled rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/kbuf: handle index wrap in last buffer check

Josef Bacik <josef@toxicpanda.com>
    io_uring/zcrx: fix buffer offsets in areas above 4GB

Josef Bacik <josef@toxicpanda.com>
    io_uring/napi: don't busy poll past an expired timeout

Josef Bacik <josef@toxicpanda.com>
    io_uring/napi: make stale entries time out after 60s

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: no early -ETIME if min_wait finds work

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: use the right clock for ABS updates

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: keep repeat count on multishot update

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: don't skip over reached sequences

Josef Bacik <josef@toxicpanda.com>
    io_uring/fdinfo: fix CQE dump of CQE32 rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: keep 128b SQEs intact on resize

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: handle index wrap when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: don't wrap 32b CQEs when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't split 128b SQEs at the SQPOLL cap

Josef Bacik <josef@toxicpanda.com>
    io_uring: drop the CQE cache if a refill fails

Josef Bacik <josef@toxicpanda.com>
    io_uring/futex: allocate private hash before waiting

Josef Bacik <josef@toxicpanda.com>
    io_uring/poll: drop stale double poll entry on rearm

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: look at all CQ waiters on wake up

Josef Bacik <josef@toxicpanda.com>
    io_uring: wake ring pollers for local task_work

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: let CANCEL_ALL find parked requests

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: recognize "no timeout" on 32-bit

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: don't forget that the work was running

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't lose a cancel as io-wq parks a request

Josef Bacik <josef@toxicpanda.com>
    io_uring/poll: don't lose a cancel as io-wq arms poll

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: let cancel find picked up hashed work

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't exit with a creation pending

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't strand work when a worker exits

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't go to sleep on pending work

Josef Bacik <josef@toxicpanda.com>
    io_uring/mpscq: disable preemption while pushing

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: rearm local work wake up before sleep

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't lose the DEFER_TASKRUN wake up

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't flood a cancelling task with task_work

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't hide a link from cancellations

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't lose the signal that ends work

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: don't spin on a stuck overflow list

Josef Bacik <josef@toxicpanda.com>
    io_uring/cmd: don't leave list poison in ->hash_node

Josef Bacik <josef@toxicpanda.com>
    io_uring/waitid: own the request before clearing ->head

Ridham Khurana <khurana.ridham222@gmail.com>
    platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()

Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
    wifi: ath12k: Increase RXDMA buffer ring size for default memory profile

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: move dp_profile_params to dp.h

Lee Seong Hyeon <ihopenre@gmail.com>
    ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: release failed pending sockets of a listener

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: wait for negotiation before receiving another PDU

Zizhen Liu <pointerliu@126.com>
    net: skbuff: propagate shared-frag marker in skb_zerocopy()


-------------

Diffstat:

 .../bindings/interrupt-controller/arm,gic-v5.yaml  |   9 +-
 Documentation/networking/rxrpc.rst                 |  21 +-
 Makefile                                           |   4 +-
 arch/arm/mm/mmap.c                                 |  11 +-
 arch/powerpc/kvm/book3s_hv.c                       |  76 +-
 arch/powerpc/kvm/book3s_paired_singles.c           |   7 +-
 arch/s390/kernel/kprobes.c                         |   3 +
 arch/s390/kernel/perf_cpum_cf.c                    |   3 +
 arch/s390/kernel/process.c                         |  12 +-
 arch/s390/kernel/signal.c                          |   6 +-
 arch/s390/lib/probes.c                             |   2 +-
 arch/s390/mm/extable.c                             |   4 +-
 arch/s390/pci/pci_irq.c                            |  93 ++-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/cpuid/api.h                   |   1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   7 +
 arch/x86/include/asm/vmx.h                         |   8 +
 arch/x86/kernel/cpu/bugs.c                         |  18 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kvm/hyperv.c                              |   2 +
 arch/x86/kvm/mmu/mmu.c                             |   5 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  13 +-
 arch/x86/kvm/svm/nested.c                          |   6 +
 arch/x86/kvm/svm/svm.c                             |  19 +-
 arch/x86/kvm/vmx/common.h                          |  20 +
 arch/x86/kvm/vmx/main.c                            |  26 +
 arch/x86/kvm/vmx/posted_intr.c                     |   2 +
 arch/x86/kvm/vmx/tdx.c                             |  92 ++-
 arch/x86/kvm/vmx/vmx.c                             |  37 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   1 +
 arch/x86/kvm/x86.c                                 |  69 +-
 arch/x86/kvm/xen.c                                 |  18 +
 arch/x86/mm/pat/set_memory.c                       |   8 +-
 block/blk-crypto-fallback.c                        |   6 +
 drivers/accel/amdxdna/aie2_message.c               |   1 +
 drivers/accel/amdxdna/aie2_msg_priv.h              |   1 +
 drivers/accel/amdxdna/npu4_regs.c                  |   1 +
 drivers/android/binder/thread.rs                   |  38 +-
 drivers/ata/sata_fsl.c                             |  20 +-
 drivers/base/base.h                                |   1 +
 drivers/base/bus.c                                 |  32 +-
 drivers/base/core.c                                |   4 +-
 drivers/base/dd.c                                  |  90 ++-
 drivers/block/xen-blkfront.c                       |  12 +-
 drivers/bluetooth/hci_vhci.c                       |   4 +
 drivers/clk/renesas/r9a08g046-cpg.c                |   6 +-
 drivers/cpufreq/rcpufreq_dt.rs                     |   1 +
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   3 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |  14 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   4 +-
 .../amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h  |   2 -
 .../hid_descriptor/amd_sfh_hid_report_desc.h       |   7 -
 drivers/hid/hid-asus.c                             |  14 +-
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-cougar.c                           |   3 +
 drivers/hid/hid-cp2112.c                           |   9 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-lenovo-go-s.c                      | 663 ++++++++++-----
 drivers/hid/hid-logitech-dj.c                      |   3 +
 drivers/hid/hid-mcp2200.c                          |   5 +
 drivers/hid/hid-mcp2221.c                          |  10 +-
 drivers/hid/hid-picolcd_fb.c                       |  12 +-
 drivers/hid/hid-prodikeys.c                        |   7 +-
 drivers/hid/hid-pxrc.c                             |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-roccat-isku.c                      |   3 +
 drivers/hid/hid-roccat-koneplus.c                  |   3 +
 drivers/hid/hid-roccat-konepure.c                  |   3 +
 drivers/hid/hid-roccat-kovaplus.c                  |   3 +
 drivers/hid/hid-roccat-pyra.c                      |   3 +
 drivers/hid/hid-roccat-ryos.c                      |   3 +
 drivers/hid/hid-roccat-savu.c                      |   3 +
 drivers/hid/hid-zydacron.c                         |   3 +
 drivers/hid/usbhid/hid-core.c                      |   9 +-
 drivers/hid/usbhid/hiddev.c                        |  37 +-
 drivers/hid/wacom_sys.c                            | 198 +++--
 drivers/hid/wacom_wac.c                            |  99 ++-
 drivers/hid/wacom_wac.h                            |   6 +-
 drivers/hv/mshv_vtl_main.c                         |  28 +-
 drivers/hv/ring_buffer.c                           |  29 +-
 drivers/infiniband/core/ib_core_uverbs.c           |  10 +-
 drivers/infiniband/core/uverbs.h                   |  37 +
 drivers/infiniband/core/uverbs_std_types_dmabuf.c  |  39 +-
 drivers/infiniband/hw/irdma/icrdma_if.c            |   9 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/iommufd/eventq.c                     |   4 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |   4 +
 drivers/media/pci/cx23885/cx23885-core.c           |   4 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |  14 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   9 +-
 drivers/media/pci/intel/ipu-bridge.c               |   2 +-
 drivers/media/platform/marvell/mcam-core.c         |  14 +-
 .../media/platform/microchip/microchip-csi2dc.c    |   1 +
 .../media/platform/microchip/microchip-isc-base.c  |   6 +
 .../platform/microchip/microchip-sama5d2-isc.c     |  17 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |  17 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   2 +
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |   4 +-
 drivers/media/rc/bpf-lirc.c                        |  18 +-
 drivers/media/rc/fintek-cir.c                      |   4 +
 drivers/media/rc/imon.c                            |   5 -
 drivers/media/rc/ir-mce_kbd-decoder.c              |   5 +-
 drivers/media/rc/lirc_dev.c                        |   3 +
 drivers/media/rc/rc-ir-raw.c                       |  86 +-
 drivers/media/rc/rc-main.c                         |  61 +-
 drivers/media/rc/redrat3.c                         |   4 +
 drivers/media/usb/au0828/au0828-dvb.c              |   1 +
 drivers/media/usb/em28xx/em28xx-audio.c            |   7 +
 drivers/media/usb/go7007/go7007-driver.c           |   5 +-
 drivers/media/usb/gspca/gspca.c                    |   3 +-
 drivers/media/usb/hackrf/hackrf.c                  |   7 +-
 drivers/media/usb/usbtv/usbtv-core.c               |   2 -
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/mtd/mtd_virt_concat.c                      |   2 +
 drivers/net/usb/pegasus.c                          |   6 +-
 drivers/net/virtio_net.c                           |  26 +-
 drivers/net/wireless/ath/ath12k/core.c             |   2 +
 drivers/net/wireless/ath/ath12k/core.h             |   9 -
 drivers/net/wireless/ath/ath12k/dp.c               |  81 +-
 drivers/net/wireless/ath/ath12k/dp.h               | 108 ++-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  14 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  12 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   2 +
 drivers/net/wireless/broadcom/b43/main.c           |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   1 -
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   4 +-
 drivers/net/wwan/wwan_hwsim.c                      |   4 +
 drivers/nvme/target/auth.c                         |   1 +
 drivers/nvme/target/fabrics-cmd-auth.c             |  32 +-
 drivers/nvme/target/fc.c                           |   8 +-
 drivers/nvme/target/nvmet.h                        |   2 +
 drivers/nvme/target/pr.c                           |   2 +-
 drivers/nvmem/core.c                               |   4 +-
 drivers/phy/phy-core.c                             |  45 +-
 drivers/platform/cznic/turris-omnia-mcu-base.c     |   1 +
 drivers/platform/x86/amd/hfi/hfi.c                 |   5 +
 drivers/platform/x86/asus-wmi.c                    |  12 +
 drivers/power/supply/pf1550-charger.c              |  32 +-
 drivers/power/supply/sbs-battery.c                 |  11 +
 drivers/pps/generators/pps_gen.c                   |  94 ++-
 drivers/rapidio/devices/rio_mport_cdev.c           |   5 +-
 drivers/s390/char/vmcp.c                           |   4 +-
 drivers/s390/crypto/zcrypt_api.c                   |  35 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  22 +-
 drivers/s390/crypto/zcrypt_msgtype50.c             |  95 ++-
 drivers/s390/crypto/zcrypt_msgtype6.c              | 208 +++--
 drivers/scsi/dc395x.c                              |  10 +-
 drivers/spi/spi-pci1xxxx.c                         |  71 ++
 drivers/spmi/spmi.c                                |   3 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |  21 +-
 drivers/thunderbolt/icm.c                          |   6 +-
 drivers/tty/serial/serial_core.c                   |  16 +-
 drivers/usb/core/driver.c                          |   1 -
 drivers/usb/core/message.c                         |   1 +
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/vfio/pci/nvgrace-gpu/main.c                |  17 +-
 drivers/video/backlight/lm3630a_bl.c               |   1 +
 drivers/video/backlight/qcom-wled.c                |  35 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |  11 +-
 drivers/video/fbdev/udlfb.c                        |   5 +
 fs/afs/rxrpc.c                                     |  57 +-
 fs/btrfs/verity.c                                  |   7 +-
 fs/ceph/dir.c                                      |   4 +
 fs/exec.c                                          |  11 +-
 fs/ext4/verity.c                                   |   4 +-
 fs/fuse/dev.c                                      |   3 +-
 fs/iomap/ioend.c                                   |  10 +-
 fs/kernfs/mount.c                                  |  34 +-
 fs/lockd/svclock.c                                 |   2 +
 fs/nfs/blocklayout/blocklayout.h                   |   5 -
 fs/nfs/blocklayout/rpc_pipefs.c                    |  79 +-
 fs/nfs/callback_xdr.c                              |   9 +-
 fs/nfs/delegation.c                                |   3 +-
 fs/nfs/dir.c                                       |   2 +
 fs/nfs/filelayout/filelayout.c                     |   8 +-
 fs/nfs/filelayout/filelayoutdev.c                  |  17 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  52 +-
 fs/nfs/flexfilelayout/flexfilelayout.h             |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |  17 +-
 fs/nfs/localio.c                                   |  31 +-
 fs/nfs/netns.h                                     |   5 +-
 fs/nfs/nfs4_fs.h                                   |   2 +
 fs/nfs/nfs4proc.c                                  |   8 +
 fs/nfs/nfs4state.c                                 |  38 +-
 fs/nfs/nfstrace.h                                  |   5 +-
 fs/nfs/pnfs.c                                      |   2 +
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfs/pnfs_nfs.c                                  |  21 +-
 fs/nfsd/filecache.c                                |   4 +-
 fs/nfsd/flexfilelayout.c                           |  20 +-
 fs/nfsd/flexfilelayoutxdr.c                        |   4 +-
 fs/nfsd/flexfilelayoutxdr.h                        |   5 +-
 fs/nfsd/nfs3acl.c                                  |  15 +
 fs/nfsd/nfs4idmap.c                                |   4 +-
 fs/nfsd/nfs4layouts.c                              |   4 +-
 fs/nfsd/nfs4proc.c                                 |   4 +-
 fs/nfsd/nfs4recover.c                              |  42 +-
 fs/nfsd/nfs4state.c                                | 250 +++++-
 fs/nfsd/nfs4xdr.c                                  |  26 +-
 fs/nfsd/nfsctl.c                                   |  73 +-
 fs/nfsd/nfsproc.c                                  |  19 +-
 fs/nfsd/state.h                                    |  13 +-
 fs/nfsd/xdr4.h                                     |   1 +
 fs/ocfs2/cluster/heartbeat.c                       |  13 +-
 fs/ocfs2/cluster/netdebug.c                        |   4 +
 fs/ocfs2/cluster/nodemanager.c                     |   3 +
 fs/ocfs2/cluster/quorum.c                          |   7 +-
 fs/ocfs2/cluster/quorum.h                          |   1 +
 fs/ocfs2/dlm/dlmconvert.c                          |  10 +-
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +
 fs/ocfs2/dlm/dlmdomain.c                           |   3 +-
 fs/ocfs2/dlm/dlmlock.c                             |   8 +-
 fs/ocfs2/dlmglue.c                                 |   2 +
 fs/ocfs2/file.c                                    | 100 ++-
 fs/ocfs2/filecheck.c                               |   5 +-
 fs/ocfs2/quota_local.c                             |  12 +-
 fs/ocfs2/refcounttree.c                            |  15 +-
 fs/ocfs2/super.c                                   |   1 +
 fs/overlayfs/copy_up.c                             | 110 ++-
 fs/overlayfs/dir.c                                 |  22 +-
 fs/overlayfs/inode.c                               |  16 +-
 fs/overlayfs/namei.c                               |  11 +-
 fs/overlayfs/overlayfs.h                           |   8 +-
 fs/overlayfs/readdir.c                             |  40 +-
 fs/overlayfs/super.c                               |  31 +-
 fs/proc/task_mmu.c                                 |   9 +-
 fs/smb/client/cached_dir.c                         |  30 +-
 fs/smb/client/cifsacl.c                            |   9 +-
 fs/smb/client/cifsfs.c                             |  20 +-
 fs/smb/client/cifsglob.h                           |   2 +
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/cifssmb.c                            | 152 +++-
 fs/smb/client/connect.c                            |  40 +-
 fs/smb/client/inode.c                              |   4 +-
 fs/smb/client/readdir.c                            |  69 +-
 fs/smb/client/sess.c                               |   6 +-
 fs/smb/client/smb2misc.c                           |  16 +
 fs/smb/client/smb2ops.c                            |  37 +-
 fs/smb/client/smb2pdu.c                            |  46 +-
 fs/smb/client/trace.h                              |   3 +
 fs/smb/client/transport.c                          |   2 +
 fs/smb/common/smbglob.h                            |   1 +
 fs/smb/server/auth.c                               |   6 +-
 fs/smb/server/compress.c                           |   1 +
 fs/smb/server/connection.c                         |  55 +-
 fs/smb/server/connection.h                         |  26 +-
 fs/smb/server/ksmbd_netlink.h                      |   8 +-
 fs/smb/server/ksmbd_work.c                         |  19 +
 fs/smb/server/ksmbd_work.h                         |   2 +
 fs/smb/server/mgmt/user_session.c                  | 204 ++++-
 fs/smb/server/mgmt/user_session.h                  |  12 +-
 fs/smb/server/misc.c                               |   8 +-
 fs/smb/server/oplock.c                             | 885 ++++++++++++---------
 fs/smb/server/oplock.h                             |  14 +-
 fs/smb/server/proc.c                               |   2 +
 fs/smb/server/server.c                             |  23 +
 fs/smb/server/server.h                             |   3 +
 fs/smb/server/smb2misc.c                           |   8 +
 fs/smb/server/smb2ops.c                            |  33 +
 fs/smb/server/smb2pdu.c                            | 374 +++++++--
 fs/smb/server/smb2pdu.h                            |   1 +
 fs/smb/server/smb_common.c                         |   6 +-
 fs/smb/server/smbacl.c                             |  49 +-
 fs/smb/server/transport_ipc.c                      |  23 +-
 fs/smb/server/transport_tcp.c                      | 308 ++++++-
 fs/smb/server/vfs.c                                | 107 ++-
 fs/smb/server/vfs.h                                |   3 +-
 fs/smb/server/vfs_cache.c                          | 263 +++---
 fs/smb/server/vfs_cache.h                          |  12 +-
 fs/smb/smbdirect/accept.c                          | 227 ++++--
 fs/smb/smbdirect/connection.c                      |  12 +-
 fs/smb/smbdirect/internal.h                        |   2 +
 fs/smb/smbdirect/listen.c                          | 137 +++-
 fs/smb/smbdirect/rw.c                              |   1 -
 fs/smb/smbdirect/socket.c                          | 113 ++-
 fs/smb/smbdirect/socket.h                          |  42 +
 fs/udf/inode.c                                     |   2 +-
 fs/ufs/dir.c                                       |   2 +-
 fs/verity/enable.c                                 |  12 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  13 +
 fs/xfs/libxfs/xfs_da_btree.c                       |  14 +
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |   2 +-
 fs/xfs/libxfs/xfs_trans_space.c                    |   6 +-
 fs/xfs/scrub/agheader.c                            |  15 +-
 fs/xfs/scrub/agheader_repair.c                     |  13 +-
 fs/xfs/scrub/alloc_repair.c                        |  11 +-
 fs/xfs/scrub/attr.c                                |  17 +-
 fs/xfs/scrub/attr_repair.c                         |  18 +-
 fs/xfs/scrub/bitmap.c                              |  20 +
 fs/xfs/scrub/bmap.c                                |   7 +
 fs/xfs/scrub/btree.c                               |  16 +-
 fs/xfs/scrub/common.c                              |   7 +-
 fs/xfs/scrub/cow_repair.c                          |  84 +-
 fs/xfs/scrub/dabtree.c                             |  27 +-
 fs/xfs/scrub/dir.c                                 |   2 +
 fs/xfs/scrub/dir_repair.c                          |   9 +-
 fs/xfs/scrub/dirtree.c                             |   4 +-
 fs/xfs/scrub/dirtree_repair.c                      |  76 +-
 fs/xfs/scrub/dqiterate.c                           |   1 +
 fs/xfs/scrub/fscounters.c                          |  38 +-
 fs/xfs/scrub/ialloc_repair.c                       |   8 +-
 fs/xfs/scrub/inode.c                               |   2 +-
 fs/xfs/scrub/inode_repair.c                        | 181 ++++-
 fs/xfs/scrub/iscan.c                               |   2 +-
 fs/xfs/scrub/metapath.c                            |  17 +-
 fs/xfs/scrub/newbt.c                               |  15 +-
 fs/xfs/scrub/newbt.h                               |   1 -
 fs/xfs/scrub/parent_repair.c                       |   4 +
 fs/xfs/scrub/quota.c                               |   8 +-
 fs/xfs/scrub/quota_repair.c                        |  39 +-
 fs/xfs/scrub/quotacheck_repair.c                   |  54 +-
 fs/xfs/scrub/readdir.c                             |   2 +-
 fs/xfs/scrub/reap.c                                |  65 +-
 fs/xfs/scrub/refcount.c                            |  17 +-
 fs/xfs/scrub/repair.c                              |  18 +-
 fs/xfs/scrub/repair.h                              |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c                     |   2 +-
 fs/xfs/scrub/rtrefcount.c                          |   2 +
 fs/xfs/scrub/rtsummary.c                           |   9 +-
 fs/xfs/scrub/rtsummary.h                           |   1 +
 fs/xfs/scrub/rtsummary_repair.c                    |   2 +-
 fs/xfs/scrub/stats.c                               |   5 +-
 fs/xfs/scrub/symlink.c                             |  17 +-
 fs/xfs/scrub/trace.c                               |  13 +
 fs/xfs/scrub/trace.h                               |  10 +-
 fs/xfs/scrub/xfarray.c                             |   4 +-
 fs/xfs/xfs_dquot.c                                 |  20 +-
 fs/xfs/xfs_dquot.h                                 |   2 +-
 fs/xfs/xfs_handle.c                                |   2 +-
 fs/xfs/xfs_inode_item_recover.c                    |  20 +-
 fs/xfs/xfs_mount.c                                 |   9 +-
 fs/xfs/xfs_pnfs.c                                  |  19 +-
 fs/xfs/xfs_qm.c                                    |  42 +-
 fs/xfs/xfs_quota.h                                 |   9 +
 fs/xfs/xfs_trans_dquot.c                           |   6 +-
 include/linux/device.h                             |   5 +
 include/linux/device/bus.h                         |   3 -
 include/linux/filelock.h                           |  13 +-
 include/linux/fsverity.h                           |  12 +-
 include/linux/hiddev.h                             |   2 +
 include/linux/interrupt.h                          |   2 +
 include/linux/io_uring_types.h                     |   6 +
 include/linux/kvm_host.h                           |   2 +
 include/linux/pps_gen_kernel.h                     |   4 +-
 include/net/af_rxrpc.h                             |   5 +-
 include/net/mptcp.h                                |   9 +
 include/trace/events/huge_memory.h                 |  18 +-
 include/trace/events/rxrpc.h                       |   2 +-
 include/trace/misc/nfs.h                           |  10 +
 io_uring/bpf-ops.c                                 |  16 +-
 io_uring/cancel.c                                  |  43 +-
 io_uring/cancel.h                                  |   2 +
 io_uring/fdinfo.c                                  |  14 +-
 io_uring/futex.c                                   |  32 +-
 io_uring/io-wq.c                                   | 138 +++-
 io_uring/io_uring.c                                | 174 +++-
 io_uring/io_uring.h                                |  44 +-
 io_uring/kbuf.c                                    |   6 +-
 io_uring/loop.c                                    |   8 +-
 io_uring/mpscq.h                                   |  14 +-
 io_uring/napi.c                                    |   4 +-
 io_uring/net.c                                     |  49 +-
 io_uring/openclose.c                               |  11 +-
 io_uring/poll.c                                    |  21 +
 io_uring/register.c                                |  61 +-
 io_uring/rsrc.c                                    |   7 +-
 io_uring/rw.c                                      |  18 -
 io_uring/sqpoll.c                                  |  35 +-
 io_uring/sqpoll.h                                  |   3 +-
 io_uring/tctx.c                                    |   9 +-
 io_uring/timeout.c                                 | 105 ++-
 io_uring/tw.c                                      |  36 +-
 io_uring/uring_cmd.c                               |   2 +-
 io_uring/wait.c                                    |  32 +-
 io_uring/wait.h                                    |  15 +
 io_uring/waitid.c                                  |  12 +-
 io_uring/zcrx.c                                    |   2 +-
 kernel/cgroup/cgroup.c                             |  28 +
 kernel/fork.c                                      |   4 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/manage.c                                |  31 +-
 kernel/kcov.c                                      |   8 +
 kernel/kcsan/core.c                                |   7 +-
 kernel/power/em_netlink.c                          | 126 +--
 kernel/power/em_netlink.h                          |   8 +-
 kernel/power/energy_model.c                        |   8 +-
 kernel/resource.c                                  |   9 +-
 kernel/sched/ext/ext.c                             |  15 +-
 lib/klist.c                                        |  16 +-
 lib/kobject_uevent.c                               |   6 +-
 mm/hugetlb.c                                       |  15 +-
 mm/khugepaged.c                                    |  21 +-
 mm/rmap.c                                          |  11 -
 mm/slab_common.c                                   |  17 +-
 mm/truncate.c                                      |  30 +-
 net/8021q/vlan_dev.c                               |  33 +-
 net/bluetooth/hci_event.c                          |   9 +
 net/ceph/mon_client.c                              |   2 +-
 net/core/dev.c                                     |   3 +
 net/core/rtnetlink.c                               |   4 +
 net/core/skbuff.c                                  |   2 +
 net/ipv4/inet_connection_sock.c                    |   4 +
 net/ipv4/metrics.c                                 |   5 +
 net/mptcp/subflow.c                                |  35 +-
 net/netfilter/nft_payload.c                        |  40 +-
 net/rxrpc/recvmsg.c                                |  22 +-
 net/rxrpc/rxperf.c                                 |  41 +-
 net/rxrpc/sendmsg.c                                |  86 +-
 net/sched/act_ife.c                                |   4 +
 net/sched/cls_bpf.c                                |  28 +-
 net/sched/cls_flower.c                             |  50 +-
 net/sched/sch_generic.c                            |  14 +-
 net/sched/sch_teql.c                               |  60 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  29 +-
 net/sunrpc/svc.c                                   |   9 +-
 net/sunrpc/svc_xprt.c                              |  24 +-
 net/sunrpc/svcauth_unix.c                          |   9 +
 net/sunrpc/svcsock.c                               |  86 +-
 rust/bindgen_parameters                            |   4 +-
 rust/bindings/bindings_helper.h                    |   2 +-
 rust/kernel/bitmap.rs                              |  70 +-
 rust/kernel/block/mq/gen_disk.rs                   |  10 +-
 rust/kernel/block/mq/operations.rs                 |   2 +-
 rust/kernel/bug.rs                                 |   9 +-
 rust/kernel/configfs.rs                            |  43 +-
 rust/kernel/cpufreq.rs                             |  22 +-
 rust/kernel/fwctl.rs                               |  12 +-
 rust/kernel/module_param.rs                        |   9 +-
 security/apparmor/include/policy_ns.h              |  16 +
 security/apparmor/policy_ns.c                      |   2 +-
 security/landlock/fs.c                             |  10 +-
 sound/core/control.c                               |   2 +
 sound/drivers/pcmtest.c                            |  42 +-
 sound/soc/amd/ps/acp63.h                           |   8 +
 sound/soc/amd/ps/pci-ps.c                          |   2 +
 sound/soc/amd/ps/ps-common.c                       |   2 +
 sound/soc/generic/audio-graph-card2.c              |   3 +-
 sound/synth/emux/emux_synth.c                      |   3 +
 sound/synth/emux/soundfont.c                       |   9 +-
 sound/usb/line6/pcm.c                              |   8 +
 sound/x86/intel_hdmi_audio.c                       |   9 +-
 tools/objtool/check.c                              |   1 +
 virt/kvm/guest_memfd.c                             | 120 +--
 virt/kvm/guest_memfd.h                             |  19 +-
 virt/kvm/kvm_main.c                                |  75 +-
 virt/kvm/pfncache.c                                |  18 +-
 452 files changed, 8695 insertions(+), 3181 deletions(-)


