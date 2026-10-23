Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788287;
	b=kPbhhOfZIqq1NFcHceUTQMp1K+gDVeTZWiDqkxxj8/tVqExkVMtrUtbPcEohQ3duxtYT
	 tvsdRFDA6l1/19lZ1hDhhavRujcT7o0rETVy0x6XgZj0oWBhogd5lFJjPVgv79Vy2J8xk
	 O16kuBMAua9sZVvWOKIahsUVi2sUZT8KEK/SfI1WWeosN41Unk+lxy2EcxzLjmVoJNuUd
	 olbZ72rcJc9+P4Sx760ES+7V0Y70zYytgzdWpnm2dhQlJycikMMEnkXah3Jz4/ZrgDzW5
	 VuGQkZAe4bgdutTUMg1Hs2Tc8yBzGp433jYbw0JY3SbqCqLJBFUE++quWerxwkt0csg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788287;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=3UpHorWhhnkz2ndk39qv35r3RyqUcUEnnqKCaU/8H6k=;
	b=qYDfD1ElOPCyvfXzRwqwL3foUVm6TtxBdqB7BxiDTZMdRezm1vL7RykSDwScS5fklqsx
	 3SSStCK/MAJwv6YZQ0aiYN1YYyw4ZIw93104lfQLErGIEVnz6c20KCtl5ikA5NqnVqURv
	 NKEi50dvD+K3KB4RGmunvJy0h8ZNB47En74272gBiNjs9yqzLBD1OOYKqXDANCffjS2Nd
	 kr79gDs1uTkfIE+rdbXQQgFzMmufusXdpa4Ra2sI12r2g5ps5mdacVPEusGndh9fO2Kr0
	 hGu8veOLrm8YcieTX7+j88k0Oay2mMkEIALNO/gVu8HONSof1p++aat5nzpnlv/eXDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=abPDhAud;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF922606A31B
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 20:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF922606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=abPDhAud
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7C95810AFEB;
	Fri, 23 Oct 2026 22:44:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792788272;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3UpHorWhhnkz2ndk39qv35r3RyqUcUEnnqKCaU/8H6k=;
	b=abPDhAud6V8Rh3CtR6HR+9i6bJxVZeqt/tMcaRFSgg71zKAjZR+mEijmyxL9/4IJv2hb/s
	9odzaHDX0sFRJJIoBEA14N/P5n77wKt4hS1ie+c09bbamHq05baMBQ7Q0+/sNetbQGGd/k
	QW+RBMSuq+Hq3PCS9H8XO/m7gTxa+vHLyQZLOzbc0vaE+uKWhlaSqVhdQ1m7ZsOrIPvxV5
	Hu+sZAzH5cwtmzRXqB1DDGkaZT9KxbOdy026VUUIwHavZYnFq1ShxgU1VboNuG7XWPxf/b
	qnM20RobjvprhP9zLScPCmHOlXJotIkgu5dYWLTQAtWNZRFdAzxH/4Uwlq1Fng==
Date: Fri, 23 Oct 2026 22:44:26 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
Message-ID: <atvHKoRHHjKV4l8A@duo.ucw.cz>
References: <20261023163713.816071858@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0XAjP8Jk4Nbn4Hv"
Content-Disposition: inline
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--t0XAjP8Jk4Nbn4Hv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Either something went very wrong with our testing, or this fails on
all our targets. 6.18.59-rc1 does not seem to have those widespread
failures.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
982452623

Example failure is:

I'll look some more to try to figure out what is going on there.

Best regards,

								Pavel


[    1.238864] Yama: becoming mindful.
L426[    1.238864] Mount-cache hash table entries: 8192 (order: 4, 65536 by=
tes, linear)
L427[    1.238864] Mountpoint-cache hash table entries: 8192 (order: 4, 655=
36 bytes, linear)
L428[    1.238864] VFS: Finished mounting rootfs on nullfs
L431[    1.238864] BUG: kernel NULL pointer dereference, address: 000000000=
000002c
L436[    1.238864] #PF: supervisor write access in kernel mode
L437[    1.238864] #PF: error_code(0x0002) - not-present page
L438[    1.238864] PGD 0 P4D 0=20
L441[    1.238864] Oops: Oops: 0002 [#1] SMP PTI
L446[    1.238864] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G S       =
           7.2.13-rc1+ #1 PREEMPT(lazy)=20
L447[    1.238864] Tainted: [S]=3DCPU_OUT_OF_SPEC
L448[    1.238864] Hardware name: SIEMENS AG SIMATIC IPC227E/A5E42630598, B=
IOS V20.01.11 03/15/2018
L449[    1.238864] RIP: 0010:rest_init+0x33/0xd0
L450[    1.238864] Code: 34 ff ba 00 02 00 00 31 f6 48 c7 c7 70 a2 e6 b2 e8=
 52 d3 28 ff 89 c3 e8 bb 2d 34 ff 89 df 48 c7 c6 80 db 85 b3 e8 9d d7 2b ff=
 <81> 48 2c 00 00 00 04 65 8b 15 63 6e 45 01 48 89 c7 89 d0 c1 ea 06
L451[    1.238864] RSP: 0000:ffffffffb3803ee0 EFLAGS: 00010246
L452[    1.238864] RAX: 0000000000000000 RBX: 00000000ffffffea RCX: 0000000=
000000000
L453[    1.238864] RDX: 0000000000000000 RSI: ffffffffffffffea RDI: fffffff=
fffffffea
L454[    1.238864] RBP: ffff8cf23ffed080 R08: ffffffffb385db88 R09: fffffff=
fb385db80
L455[    1.238864] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8cf=
23ffed0ab
L456[    1.238864] R13: 0000000000000000 R14: ffffffffb380c040 R15: 0000000=
0b43e8000
L457[    1.238864] FS:  0000000000000000(0000) GS:ffff8cf287953000(0000) kn=
lGS:0000000000000000
L458[    1.238864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
L459[    1.238864] CR2: 000000000000002c CR3: 000000000d630000 CR4: 0000000=
0001006f0
L460[    1.238864] Call Trace:
L461[    1.238864]  <TASK>
L462[    1.238864]  start_kernel+0x7a2/0x7b0
L463[    1.238864]  x86_64_start_reservations+0x24/0x30
L464[    1.238864]  x86_64_start_kernel+0xcd/0xd0
L465[    1.238864]  common_startup_64+0x13e/0x158
L466[    1.238864]  </TASK>
L467[    1.238864] Modules linked in:
L468[    1.238864] CR2: 000000000000002c
L469[    1.238864] ---[ end trace 0000000000000000 ]---
L470[    1.238864] RIP: 0010:rest_init+0x33/0xd0

> Responses should be made by Sun, 25 Oct 2026 16:36:45 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-7.2.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 7.2.13-rc1
>=20
> Paulo Alcantara <pc@manguebit.org>
>     smb: client: drain outstanding I/O before truncating on O_TRUNC open
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     ntfs: fix memmove overlap in ntfs_new_attr_flags
>=20
> Namjae Jeon <linkinjeon@kernel.org>
>     ntfs: move attribute payload before shrinking its record
>=20
> Hyunchul Lee <hyc.lee@gmail.com>
>     ntfs: fix resident conversion in ntfs_new_attr_flags
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     ntfs: take invalidate_lock in ntfs_setattr_size()
>=20
> Namjae Jeon <linkinjeon@kernel.org>
>     ntfs: use pagecache_isize_extended() on size extension
>=20
> Yao Kai <yaokai34@huawei.com>
>     workqueue: Fix unbound pool lifetime for pending pwqs
>=20
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix the bypass dispatch claim for schedulers bypassed by a=
n ancestor
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Fix NULL dereference when copying keys for a field variable
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     tracing: Bound histogram expression strings with seq_buf
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     tracing: Use __free() for expr_str() buffer
>=20
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands bac=
k on its CPU's local DSQ
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: free the userptr ranges when a CS fails after parser_bos
>=20
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     drm/amdgpu: Remove the bo list mutex
>=20
> Haris Okanovic <harisokn@amazon.com>
>     genirq/proc: Fix missing CPU header in /proc/interrupts
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     ntfs: fix undefined behavior in mft/index record size calculation
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     ntfs: fix incorrect MFT record pointer passed to ntfs_attr_record_res=
ize
>=20
> Jacopo Labardi <jacopolabardi@gmail.com>
>     ntfs: fix FITRIM range alignment
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     ntfs: handle signal interruption in fallocate
>=20
> Yunpeng Tian <shionthanatos@gmail.com>
>     smb: client: reject SetEA requests that do not fit the request buffer
>=20
> Paulo Alcantara <pc@manguebit.org>
>     smb: client: fix multiuser mount with krb5
>=20
> Frank Sorenson <sorenson@redhat.com>
>     smb: client: fix heap overflow in cifs_do_set_acl()
>=20
> Paulo Alcantara <pc@manguebit.org>
>     smb: client: fix data corruption with concurrent writes and O_TRUNC
>=20
> Aohan Mei <henrymei@tencent.com>
>     net/sched: cls_flower: validate mask pointer after nla_next()
>=20
> Aleksandr Khromov <haa@amicon.ru>
>     ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
>=20
> Aleksandr Khromov <haa@amicon.ru>
>     ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
>=20
> Aleksandr Khromov <haa@amicon.ru>
>     ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
>=20
> Norbert Szetei <norbert@doyensec.com>
>     net: psp: do not inherit the Rx association on clone
>=20
> Koichiro Den <den@valinux.co.jp>
>     net: ntb_netdev: Fix statistics races
>=20
> Jun Yang <littleddfu@gmail.com>
>     net: bridge: mcast: don't truncate the port group walk on teardown
>=20
> Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
>     drm/i915/dmc: Harden DMC firmware payload parsing
>=20
> Benjamin Cheng <benjamin.cheng@amd.com>
>     drm/amdgpu/userq: actually validate userq BOs
>=20
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdgpu: correct reservation fence slots for userq per-vm BOs evic=
tion
>=20
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: x86/mmu: Cope with the SS bit being set in #NPF exit codes
>=20
> David Rosca <david.rosca@amd.com>
>     drm/amdgpu: Fix VCE 3 ring align_mask
>=20
> Zihan Xi <zihanx@nebusec.ai>
>     ipv4: avoid divide by zero in fib_rebalance
>=20
> Daehyeon Ko <4ncienth@gmail.com>
>     vsock/vmci: validate packet source for connected sockets
>=20
> Daehyeon Ko <4ncienth@gmail.com>
>     vsock/virtio: validate packet source for connected sockets
>=20
> Niklas Schnelle <schnelle@linux.ibm.com>
>     s390/pci: Fix leak of uninitialized kernel data in SCLP report
>=20
> Thomas Richter <tmricht@linux.ibm.com>
>     s390/pai: Handle multiple PMU stop callback invocations
>=20
> Aswin Karuvally <aswin@linux.ibm.com>
>     s390/ctcm: Prevent XID null dereference
>=20
> Florian Schauer <florian@schauer.to>
>     page_pool: keep frag_offset aligned for odd-sized requests
>=20
> Charles Vosburgh <theminershive@gmail.com>
>     sctp: validate chunk length in the inqueue parser
>=20
> Paul Moore <paul@paul-moore.com>
>     selinux: fix BPF token permission checks
>=20
> Chengfeng Ye <nicoyip.dev@gmail.com>
>     tipc: protect node reset trace dump with node lock
>=20
> Tejun Heo <tj@kernel.org>
>     workqueue: Annotate cb_lock nesting when draining a dead BH pool
>=20
> Zqiang <qiang.zhang@linux.dev>
>     workqueue: Use raise_softirq() to trigger softirq in irq_work handler
>=20
> Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
>     io_uring/cancel: don't spin on local work the task can't run
>=20
> Ilya Maximets <i.maximets@ovn.org>
>     netlink: specs: add missing mask attributes for conntrack dump
>=20
> Ilya Maximets <i.maximets@ovn.org>
>     netlink: specs: fix the conntrack filter type
>=20
> Christoph Hellwig <hch@lst.de>
>     xfs: fix zoned write iomap flags assignments
>=20
> Carlos Maiolino <cem@kernel.org>
>     xfs: fix capability check in xfs
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     xfs: don't hold buffer locks across sync transaction commit in xfs_sy=
nc_sb_buf
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     net/iucv: fix the recvmsg window update
>=20
> Kaiwen Shi <skwkevin@mail.ustc.edu.cn>
>     mac802154: fix data race and NULL deref on local->assoc_dev
>=20
> Chen Cheng <chencheng@fnnas.com>
>     dm-integrity: require stable writes for internal hash modes
>=20
> Ben Cressey <ben@cressey.dev>
>     dm-integrity: fix infinite loop on discard with large tag size
>=20
> Genjian Zhang <zhanggenjian@kylinos.cn>
>     dm-ebs: fix incorrect device offset check in ebs_ctr()
>=20
> Ben Cressey <ben@cressey.dev>
>     dm-crypt: fix a tiny race condition in crypt_dec_pending
>=20
> Benjamin Marzinski <bmarzins@redhat.com>
>     dm cache: fix issue with background work locking
>=20
> Ming-Hung Tsai <mtsai@redhat.com>
>     dm cache: fix demotion stats in passthrough mode
>=20
> Frank Sorenson <sorenson@redhat.com>
>     cifs: don't update i_size in cifs_do_truncate without a cached handle
>=20
> Frank Sorenson <sorenson@redhat.com>
>     cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
>=20
> Etienne Perot <eperot@google.com>
>     cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children
>=20
> Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
>     tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)
>=20
> Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
>     tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONGESTION)
>=20
> Heyang Tan <thy15333007817@163.com>
>     wifi: p54: validate firmware record lengths
>=20
> Dmitry Kandybka <d.kandybka@gmail.com>
>     tracing: Fix ignored return value of resize_buffer_duplicate_size()
>=20
> Tengda Wu <wutengda@huaweicloud.com>
>     tracing: Fix hist trigger timestamps for buffered events
>=20
> Hao Ge <hao.ge@linux.dev>
>     tracing: Fix crash in print_graph_function_event()
>=20
> Amit Machhiwal <amachhiw@linux.ibm.com>
>     tracing: Do not initialize tracefs work if tracing is disabled
>=20
> Taeyang Lee <0wn@theori.io>
>     tracing: Check operator stack capacity before pushing
>=20
> David Carlier <devnexen@gmail.com>
>     tracing: Take trace_types_lock when dropping the buffer_meta reference
>=20
> Taeyang Lee <0wn@theori.io>
>     tracing: Keep the predicate limit separate from program capacity
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Fix the shift out of bounds in the log2 histogram modifier
>=20
> Tejun Heo <tj@kernel.org>
>     sched_ext: Propagate every bypass depth change to the descendants
>=20
> Hui Su <sh_def@163.com>
>     sched_ext: idle: Respect task affinity in restricted CPU selection
>=20
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix use-after-free of a destroyed user DSQ by a deferred r=
eenqueue
>=20
> Thomas Hellstr=F6m <thomas.hellstrom@linux.intel.com>
>     drm/xe: Don't transfer shrinker pages for pinned bos on purgeable sta=
te change
>=20
> Thomas Hellstr=F6m <thomas.hellstrom@linux.intel.com>
>     drm/xe: Bump LRU for external objects on exec and rebind
>=20
> Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
>     drm/i915/dmc: Add sanity check for DMC load address
>=20
> Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
>     drm/i915/cx0_phy: Fix ARL-S host bridge detection
>=20
> Christian K=F6nig <ckoenig.leichtzumerken@gmail.com>
>     drm/exec: don't immediately add prelocked obj to array of locked objs
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: report the BO alignment in bytes in GEM_LIST_HANDLES
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: keep the eviction fence until the last handle is closed
>=20
> Perry Yuan <perry.yuan@amd.com>
>     drm/amdgpu: fix sched entity leak in ttm buffer entity init
>=20
> Perry Yuan <perry.yuan@amd.com>
>     drm/amdgpu: fix GEM object leak on ENOMEM in userptr ioctl
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: don't drop the runtime PM reference twice in amdgpu_gpr
>=20
> Perry Yuan <perry.yuan@amd.com>
>     drm/amdgpu: destroy mutex when tearing down ttm buffer entity
>=20
> Timur Krist=F3f <timur.kristof@gmail.com>
>     drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was al=
ready set
>=20
> Timur Krist=F3f <timur.kristof@gmail.com>
>     drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang
>=20
> Kenneth Feng <kenneth.feng@amd.com>
>     drm/amd/pm: add zero fan stop temperature support on smu 14.0.2
>=20
> Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
>     drm/amd/display: Fix NULL sink dereference in USB4 bandwidth functions
>=20
> Yehyeong Lee <yhlee@isslab.korea.ac.kr>
>     scsi: libiscsi: Validate the task named by a management response
>=20
> Yehyeong Lee <yhlee@isslab.korea.ac.kr>
>     scsi: libiscsi: Validate the ITT reflected in a Reject PDU
>=20
> Yehyeong Lee <yhlee@isslab.korea.ac.kr>
>     scsi: libiscsi: Reject a negative task index from parse_pdu_itt
>=20
> Yehyeong Lee <yhlee@isslab.korea.ac.kr>
>     scsi: xen/scsifront: Check for a NULL shadow entry on a backend respo=
nse
>=20
> Laurence Oberman <loberman@redhat.com>
>     scsi: st: Fix use-after-free race between st_remove() and st_open()
>=20
> Stanley Jhu <stanleyjhu@google.com>
>     scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB repli=
es
>=20
> Krystian Kaniewski <krystianmkaniewski@gmail.com>
>     ring-buffer: Fix false warning in ring_buffer_map_get_reader()
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     ring-buffer: Fix the sub-buffer array base in rb_meta_subbuf_idx()
>=20
> David Carlier <devnexen@gmail.com>
>     ring-buffer: Do not show buffer_meta for CPUs without a buffer
>=20
> Antoine Huret <antoine.huret@bull.com>
>     perf: Update cgroup time when rotating multiplexed events
>=20
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>     perf: Track the perf mlock gift separately
>=20
> Abdurrahman Hussain <abdurrahman@nexthop.ai>
>     i2c: xiic: restore non-managed runtime PM to fix clk WARN flood
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
>=20
> Loic Poulain <loic.poulain@oss.qualcomm.com>
>     i2c: qcom-cci: Fix HALT_ACK reset request being dropped
>=20
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     gpio: shared: gracefully handle no-device lookup of shared GPIOs
>=20
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     gpio: shared: fix use-after-free bug when adding shared proxies
>=20
> Lee Jones <lee@kernel.org>
>     tracing/histograms: Reject non-stacktrace fields for synthetic stackt=
race fields
>=20
> Sasha Levin <sashal@kernel.org>
>     tools: gpio: fix building from the top level with O=3D
>=20
> Ali Ahmet Memis <ali@iusegentoo.com>
>     tools/power turbostat: Read complete CPU lists
>=20
> Richard Leitner <richard.leitner@linux.dev>
>     spi: imx: fix slab corruption from undersized DMA bounce buffers
>=20
> Daehyeon Ko <4ncienth@gmail.com>
>     sctp: revalidate output stream after association connect wait
>=20
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: dts: microchip: beaglev-fire: remove double definition of gpio=
 interrupts
>=20
> Fran=E7ois Roux <franzelfranzel@gmail.com>
>     power: sequencing: qcom-wcn: power off WLAN at probe
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     pinctrl: amd: Clear S4 wake bits when firmware has _AEI
>=20
> Aohan Mei <henrymei@tencent.com>
>     net: rds: fix uninitialized trans dereference in CM event handler
>=20
> J=E9r=E9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     net/sched: fix use-after-free in __tcf_action_put()
>=20
> Hardik Garg <hargar@linux.microsoft.com>
>     mshv_vtl: Check per-CPU register page before mmap
>=20
> Eric Biggers <ebiggers@kernel.org>
>     lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
>=20
> J=E9r=E9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
>=20
> Jann Horn <jannh@google.com>
>     futex: Fix mm reuse handling for FUT_OFF_MMSHARED
>=20
> Christian Brauner <brauner@kernel.org>
>     namei: test for a negative dentry the way traverse_mounts() does
>=20
> Christian Brauner <brauner@kernel.org>
>     namespace: a mount that copy_tree() leaves out can't take over a lock
>=20
> Christian Brauner <brauner@kernel.org>
>     ntfs3: free the sbi after a grace period
>=20
> Christian Brauner <brauner@kernel.org>
>     ipc: drop the mqueue mount with kern_unmount() on setup failure
>=20
> Christian Brauner <brauner@kernel.org>
>     eventfs: Free the eventfs_inode after an rcu grace period too
>=20
> Christian Brauner <brauner@kernel.org>
>     ext4: free the sbi after a grace period
>=20
> Aviv Vaknin <vaknins33@gmail.com>
>     pid_namespace: make zap_pid_ns_processes() freezable
>=20
> Kyle Zeng <kylebot@openai.com>
>     fsnotify: prevent mark additions during connector teardown
>=20
> Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
>     KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails f=
or !VM-Entry
>=20
> Jann Horn <jannh@google.com>
>     KVM: SEV: Fix page dirtying in sev_gmem_post_populate()
>=20
> EJ Campbell <ejc3@meta.com>
>     x86/kvm: Don't consume async #PF flags on a kernel #PF in NMI context
>=20
> Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
>     watch_queue: Fix note pool publication race in watch_queue_set_size()
>=20
> Christian Brauner <brauner@kernel.org>
>     unicode: free the map after a grace period
>=20
> Sasha Levin <sashal@kernel.org>
>     bootconfig: give the footer size static_assert a message
>=20
> Sung Byeongchan <tjdqudcks0424@naver.com>
>     autofs: ignore notification errors from a replaced pipe
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: sof-client: Use event-handler mutex consistently
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH =
capture
>=20
> Christian Brauner <brauner@kernel.org>
>     afs: free the super info after a grace period
>=20
> Igor Paunovic <royalnet026@gmail.com>
>     accel/rocket: search every core slot when looking up a scheduler
>=20
> Igor Paunovic <royalnet026@gmail.com>
>     accel/rocket: search every core slot when a core is removed
>=20
> Christian Brauner <brauner@kernel.org>
>     9p: free the session after a grace period
>=20
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     firewire: core: fix race condition in split transaction handling
>=20
> Lukas Zobernig <lukas.zobernig@gmail.com>
>     x86/insn-eval: Fix shadowed segment index in get_seg_reg_override_idx=
()
>=20
> Alexander Gruhlke <gruhlke@mailbox.org>
>     PCI: Don't treat ~0 as ready in pci_dev_wait() with RRS SV
>=20
> Alexander Gruhlke <gruhlke@mailbox.org>
>     PCI: Ignore Immediate Readiness on Samsung 990 PRO and 990 EVO Plus N=
VMe
>=20
> John Ogness <john.ogness@linutronix.de>
>     printk: Postpone kthread startup
>=20
> Haris Okanovic <harisokn@amazon.com>
>     perf: Fix perf_pmu_migrate_context() leaving events behind
>=20
> Guixiong Wei <weiguixiong@bytedance.com>
>     perf/x86/intel/uncore: Fix DMR CXL CM invert filter
>=20
> Igor Velkov <iav@iav.lv>
>     net: stmmac: dwmac1000: clear the RGMII status interrupt
>=20
> Vincent Donnefort <vdonnefort@google.com>
>     ring-buffer: Use subbuf_order in available memory estimation
>=20
> Peng Fan <peng.fan@nxp.com>
>     gpio: mxc: fix race between gpiochip registration and IRQ domain setup
>=20
> Peng Fan <peng.fan@nxp.com>
>     gpio: mxc: fix wakeup_pads bit operations
>=20
> Peng Fan <peng.fan@nxp.com>
>     gpio: mxc: fix both_edges bit operations
>=20
> Peng Fan <peng.fan@nxp.com>
>     gpio: mxc: fix race between chained IRQ handler install and probe com=
pletion
>=20
> Kent Gibson <warthog618@gmail.com>
>     gpiolib: fix memory leak in gpiod_set_array_value_complex() on error =
paths
>=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>     calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: bcmgenet: unshare the skb before writing the control block
>=20
> David Yang <mmyangfl@gmail.com>
>     net: ti: icssm-prueth: Move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: ethernet: aeroflex: move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: ethoc: move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: au1000: move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: mv643xx: move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: ethernet: actions: Move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: hisilicon: hip04_eth: Move setting of netops to fix crash
>=20
> David Yang <mmyangfl@gmail.com>
>     net: hisilicon: hisi_femac: Move setting of netops to fix crash
>=20
> Kyle Zeng <kylebot@openai.com>
>     netlink: avoid hashing the network namespace pointer
>=20
> Xingui Yang <yangxingui@huawei.com>
>     scsi: libsas: Fix SMP IO deadlock during HA resume
>=20
> Martin Kaiser <martin@kaiser.cx>
>     tracing: probes: error if BTF is required but unavailable
>=20
> Vincent Donnefort <vdonnefort@google.com>
>     ring-buffer: Skip si_mem_available() for persistent and remote buffers
>=20
> Vincent Donnefort <vdonnefort@google.com>
>     tracing: Fix simple_ring_buffer undef check on sparc64
>=20
> Vincent Donnefort <vdonnefort@google.com>
>     tracing: Fix simple_ring_buffer undef check on parisc
>=20
> Vincent Donnefort <vdonnefort@google.com>
>     tracing: Fix empty symbol names in simple_ring_buffer undef check
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: let idle threads share init_fs
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: pass flags to copy_fs()
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: add umh argument to struct kernel_clone_args
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: make userspace_init_fs a dynamically-initialized pointer
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: add real_fs to track task's actual fs_struct
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: add scoped_with_init_fs()
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: notice when init abandons fs sharing
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: add switch_fs_struct()
>=20
> Kyle Zeng <kylebot@openai.com>
>     pipe: preserve existing fasync readers on writer setup failure
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     exit: fix lost-update race on the child_subreaper bitfields
>=20
> Sasha Levin <sashal@kernel.org>
>     samples: pidfd: fix userprogs typo
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ocfs2/dlm: Protect the recovery list during debugfs reads
>=20
> Erik Faye-Lund <erik.faye-lund@arm.com>
>     drm/panthor: fix immortalis condition
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommupt/kunit: Use if_changed_rule for the kunit
>=20
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>     entry: Account the deferred hrtimer rearm as hardirq context for lock=
dep
>=20
> K Prateek Nayak <kprateek.nayak@amd.com>
>     sched/core: Call wakeup_preempt() for queued tasks during class change
>=20
> Linfeng Sun <linfeng.sun.dev@gmail.com>
>     scsi: target: iscsi: Fix race in discovery auth updates
>=20
> Yu Zhang <yuz08559@gmail.com>
>     scsi: target: Disable interrupts while holding delayed_cmd_lock
>=20
> Laurence Oberman <loberman@redhat.com>
>     scsi: st: Save the visited block for the partition the drive is in
>=20
> Keith Busch <kbusch@kernel.org>
>     nios2: fix __wsum type degradation in csum_fold()
>=20
> Carlos Jones Jr <carlosjr.jones@analog.com>
>     spi: tegra114: assert CS GPIO for every transfer in a message
>=20
> Bommu Krishnaiah <krishnaiah.bommu@intel.com>
>     drm/xe/oa: Zero OA buffer at allocation
>=20
> Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
>     drm/xe: skip eviction of a BO with no resource
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     ASoC: amd: yc: disable MSI on resume
>=20
> Alexandre Cassen <acassen@corp.free.fr>
>     net/mlx5: HWS, fix flow meter offset within its bulk
>=20
> Alexandre Cassen <acassen@corp.free.fr>
>     net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     accel/rocket: clear rdev on device init failure
>=20
> Kyle Zeng <kylebot@openai.com>
>     netlink: reset skb headers before unicast and multicast filtering
>=20
> Michael Reeves <michael.reeves077@gmail.com>
>     regmap: Drop map lock during cache init and exit
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: nau8822: Fix the 128x oversampling switch bits
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: wm8978: Fix the 128x oversampling switch bits
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: max98371: Fix the Speaker DHT Min Volume bits
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: pcm3168a: Fix the DAC zero flag polarity bit
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: cs42l52: Fix the NG Type Switch bit
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
>=20
> Avi Weiss <thnkslprpt@gmail.com>
>     ASoC: stm32: spdifrx: fix synchronization state check
>=20
> Sergey Tiraspolsky <stiraspo@gmail.com>
>     ASoC: Intel: avs: Reset the stream unless it is already prepared
>=20
> Liam R. Howlett <liam@infradead.org>
>     accel/amdxdna: Fix Kconfig invalid configuration
>=20
> Allison Henderson <achender@kernel.org>
>     net/rds: don't let the rdma_cm destroy an id RDS still owns on route =
failure
>=20
> Michal Luczaj <mhal@rbox.co>
>     vsock: treat TCP_CLOSING as once-established
>=20
> Ming Yu <a0282524688@gmail.com>
>     gpio: nct6694: Mark the GPIO controller as sleeping
>=20
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>     drm/vc4: hdmi: Move packet RAM enable to PM runtime
>=20
> Pablo Mazzini <pmazzini@gmail.com>
>     pinctrl: sunxi: dt: do not accumulate npins across probe attempts
>=20
> Adriel Santos <adriel@adriel.eu>
>     pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12
>=20
> Alexey Charkov <alchark@flipper.net>
>     power: supply: core: prevent unregistering a power supply while a cal=
lback runs
>=20
> Svyatoslav Ryhel <clamor95@gmail.com>
>     power: supply: generic-adc-battery: Fix temperature IIO channel conve=
rsion
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix add_counter issue if > 24 counters.
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix PMT error path fd handling
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix CWF PMT off-by-one
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix fd_perf leak on reset
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Warn, but don't Err on out-dated perf systems
>=20
> Shawn Guo <shengchao.guo@oss.qualcomm.com>
>     pinctrl: qcom: spmi-gpio: make direction changes exclusive
>=20
> Gilberto Conde <gilbertorconde@gmail.com>
>     pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ARM: configs: sama5: enable current Microchip KSZ DSA symbols
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     pinctrl: qcom: qcs8300: Fix intr_target_width
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     pinctrl: qcom: hawi: Fix intr_target_width
>=20
> Zhangfei Gao <zhangfei.gao@oss.qualcomm.com>
>     pinctrl: qcom: nord: fix GPIO interrupt target width
>=20
> Michael Kelley <mhkelley58@gmail.com>
>     Drivers: hv: Don't reset VMBus connection state on error/exit paths
>=20
> Michael Kelley <mhkelley58@gmail.com>
>     x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()
>=20
> Waiman Long <longman@redhat.com>
>     Drivers: hv: Avoid infinite retry loop in init_vp_index()
>=20
> Jon Hunter <jonathanh@nvidia.com>
>     soc/tegra: pmc: Fix uninitialised clock rate
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     power: supply: Fix maintenance charge table kernel-doc
>=20
> David Oberhollenzer <david.oberhollenzer@sigma-star.at>
>     ARM: dts: ti/omap: dra7: fix PCIe PHY clock divider definition
>=20
> Jinhui Guo <guojinhui.liam@bytedance.com>
>     soc/tegra: fuse: Add missing newline to APBMISC error message
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     i2c: qcom-geni: Restore the source-clock selection policy
>=20
> Gael Blivet <gael.blivet@gmail.com>
>     ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/netlink/specs/conntrack.yaml         |  21 +++-
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi       |   2 +-
>  arch/arm/configs/sama5_defconfig                   |   4 +-
>  arch/nios2/include/asm/checksum.h                  |   2 +-
>  .../riscv/boot/dts/microchip/mpfs-beaglev-fire.dts |  18 ---
>  arch/s390/kernel/perf_pai.c                        |  25 +++-
>  arch/s390/pci/pci_sysfs.c                          |   3 +
>  arch/x86/events/intel/uncore_snbep.c               |   5 +-
>  arch/x86/hyperv/hv_init.c                          |   3 +-
>  arch/x86/include/asm/insn.h                        |   2 +-
>  arch/x86/kernel/kvm.c                              |  32 +++++-
>  arch/x86/kvm/mmu.h                                 |  16 ++-
>  arch/x86/kvm/mmu/paging_tmpl.h                     |   3 +-
>  arch/x86/kvm/svm/sev.c                             |   2 +-
>  arch/x86/kvm/vmx/nested.c                          |   4 +-
>  block/bsg-lib.c                                    |  13 ++-
>  drivers/accel/amdxdna/Kconfig                      |   1 +
>  drivers/accel/rocket/rocket_device.c               |   2 +
>  drivers/accel/rocket/rocket_device.h               |   1 +
>  drivers/accel/rocket/rocket_drv.c                  |   7 +-
>  drivers/accel/rocket/rocket_job.c                  |   2 +-
>  drivers/base/regmap/regcache-maple.c               |   9 +-
>  drivers/base/regmap/regcache.c                     |   6 -
>  drivers/firewire/core-transaction.c                |   8 +-
>  drivers/gpio/gpio-mxc.c                            |  36 +++---
>  drivers/gpio/gpio-nct6694.c                        |   2 +-
>  drivers/gpio/gpiolib-shared.c                      |  19 +++-
>  drivers/gpio/gpiolib.c                             |   9 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   3 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h        |   4 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  22 ++--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  23 +---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  17 ++-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   7 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  13 ++-
>  drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +++-
>  drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |   2 +-
>  drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
>  drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |  18 ++-
>  .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  55 ++++++++-
>  drivers/gpu/drm/drm_exec.c                         |  77 +++++++------
>  drivers/gpu/drm/i915/display/intel_cx0_phy.c       |  12 +-
>  drivers/gpu/drm/i915/display/intel_dmc.c           |  76 ++++++++++++-
>  drivers/gpu/drm/i915/display/intel_dmc_regs.h      |  12 ++
>  drivers/gpu/drm/panthor/panthor_hw.c               |   2 +-
>  drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 ++--
>  drivers/gpu/drm/xe/xe_bo.c                         |  11 +-
>  drivers/gpu/drm/xe/xe_exec.c                       |   7 +-
>  drivers/gpu/drm/xe/xe_oa.c                         |   7 ++
>  drivers/gpu/drm/xe/xe_vm.c                         |  31 ++++-
>  drivers/gpu/drm/xe/xe_vm.h                         |   2 +
>  drivers/hv/channel_mgmt.c                          |  12 +-
>  drivers/hv/connection.c                            |   1 -
>  drivers/hv/mshv_vtl_main.c                         |   3 +
>  drivers/hv/vmbus_drv.c                             |   1 -
>  drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
>  drivers/i2c/busses/i2c-qcom-geni.c                 |  37 +++---
>  drivers/i2c/busses/i2c-viai2c-wmt.c                |   2 +-
>  drivers/i2c/busses/i2c-xiic.c                      |  49 ++++++--
>  drivers/iommu/generic_pt/fmt/Makefile              |   2 +-
>  drivers/md/dm-cache-target.c                       |  59 +++++-----
>  drivers/md/dm-crypt.c                              |   3 +-
>  drivers/md/dm-ebs-target.c                         |   3 +-
>  drivers/md/dm-integrity.c                          |   6 +-
>  drivers/net/ethernet/actions/owl-emac.c            |   3 +-
>  drivers/net/ethernet/aeroflex/greth.c              |   3 +-
>  drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 ++
>  drivers/net/ethernet/ethoc.c                       |   3 +-
>  drivers/net/ethernet/hisilicon/hip04_eth.c         |   3 +-
>  drivers/net/ethernet/hisilicon/hisi_femac.c        |   3 +-
>  drivers/net/ethernet/marvell/mv643xx_eth.c         |   4 +-
>  .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   5 +-
>  .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   6 +
>  drivers/net/ethernet/ti/icssm/icssm_prueth.c       |   3 +-
>  drivers/net/ntb_netdev.c                           |  47 +++++---
>  drivers/net/wireless/intersil/p54/fwio.c           |  42 ++++++-
>  drivers/pci/pci.c                                  |  15 ++-
>  drivers/pci/quirks.c                               |  12 ++
>  drivers/pinctrl/pinctrl-amd.c                      |   9 ++
>  drivers/pinctrl/qcom/pinctrl-hawi.c                |   1 +
>  drivers/pinctrl/qcom/pinctrl-ipq5018.c             |  10 +-
>  drivers/pinctrl/qcom/pinctrl-nord.c                |   1 +
>  drivers/pinctrl/qcom/pinctrl-qcs8300.c             |   1 +
>  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  37 ++++--
>  drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c           |   1 +
>  drivers/power/sequencing/pwrseq-qcom-wcn.c         |  16 +--
>  drivers/power/supply/ds2780_battery.c              |   2 +-
>  drivers/power/supply/generic-adc-battery.c         |   9 +-
>  drivers/power/supply/power_supply_core.c           |  26 ++++-
>  drivers/s390/net/ctcm_mpc.c                        |   3 +-
>  drivers/scsi/libiscsi.c                            |  14 ++-
>  drivers/scsi/libsas/sas_expander.c                 |  14 ++-
>  drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
>  drivers/scsi/scsi_transport_fc.c                   |   6 +-
>  drivers/scsi/scsi_transport_iscsi.c                |   2 +-
>  drivers/scsi/scsi_transport_sas.c                  |   6 +-
>  drivers/scsi/st.c                                  |  18 ++-
>  drivers/scsi/xen-scsifront.c                       |   1 +
>  drivers/soc/tegra/fuse/tegra-apbmisc.c             |   2 +-
>  drivers/soc/tegra/pmc.c                            |   1 +
>  drivers/spi/spi-imx.c                              |   9 +-
>  drivers/spi/spi-tegra114.c                         |   7 ++
>  drivers/target/iscsi/iscsi_target_configfs.c       |  26 +++--
>  drivers/target/target_core_transport.c             |   8 +-
>  drivers/ufs/core/ufs_bsg.c                         |   2 +-
>  fs/9p/v9fs.h                                       |   1 +
>  fs/9p/vfs_super.c                                  |   4 +-
>  fs/afs/internal.h                                  |   2 +
>  fs/afs/super.c                                     |   2 +-
>  fs/autofs/waitq.c                                  |  25 +++-
>  fs/ext4/ext4.h                                     |   2 +
>  fs/ext4/extents-test.c                             |   2 +
>  fs/ext4/extents.c                                  |   1 +
>  fs/ext4/extents_status.c                           |   7 +-
>  fs/ext4/extents_status.h                           |   1 +
>  fs/ext4/super.c                                    |  13 ++-
>  fs/fs_struct.c                                     | 100 +++++++++++++++-
>  fs/namei.c                                         |   3 +-
>  fs/namespace.c                                     |  19 +++-
>  fs/notify/mark.c                                   |  11 ++
>  fs/ntfs/attrib.c                                   |   8 +-
>  fs/ntfs/bitmap.c                                   |   8 +-
>  fs/ntfs/ea.c                                       | 126 +++++++++++++++=
++----
>  fs/ntfs/file.c                                     |  41 ++++---
>  fs/ntfs/super.c                                    |   4 +-
>  fs/ntfs3/ntfs_fs.h                                 |   1 +
>  fs/ntfs3/super.c                                   |  33 ++++--
>  fs/ocfs2/dlm/dlmcommon.h                           |   2 +
>  fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
>  fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
>  fs/pipe.c                                          |   6 +-
>  fs/proc/array.c                                    |   4 +-
>  fs/proc/base.c                                     |   8 +-
>  fs/proc_namespace.c                                |   4 +-
>  fs/smb/client/cifssmb.c                            |  24 +++-
>  fs/smb/client/connect.c                            |  21 +++-
>  fs/smb/client/file.c                               |  38 ++++++-
>  fs/smb/client/smb2ops.c                            |   7 +-
>  fs/smb/server/smb2pdu.c                            |   6 +
>  fs/tracefs/event_inode.c                           |  10 +-
>  fs/unicode/utf8-core.c                             |  21 +++-
>  fs/xfs/libxfs/xfs_rtgroup.h                        |   6 +-
>  fs/xfs/libxfs/xfs_sb.c                             |  37 +++---
>  fs/xfs/xfs_aops.c                                  |   3 +-
>  fs/xfs/xfs_fsmap.c                                 |   2 +-
>  fs/xfs/xfs_ioctl.c                                 |   2 +-
>  fs/xfs/xfs_iomap.c                                 |   3 +-
>  fs/xfs/xfs_iops.c                                  |   2 +-
>  include/drm/drm_exec.h                             |  15 ++-
>  include/linux/bsg-lib.h                            |   3 +-
>  include/linux/cgroup-defs.h                        |   5 +-
>  include/linux/fs_struct.h                          |  34 ++++++
>  include/linux/fsnotify_backend.h                   |   1 +
>  include/linux/futex.h                              |  19 ++--
>  include/linux/futex_types.h                        |   2 +
>  include/linux/init_task.h                          |   1 +
>  include/linux/irq-entry-common.h                   |  23 +++-
>  include/linux/maple_tree.h                         |   4 +
>  include/linux/power_supply.h                       |  16 ++-
>  include/linux/sched.h                              |   1 +
>  include/linux/sched/signal.h                       |   4 +-
>  include/linux/sched/task.h                         |   1 +
>  include/linux/sched/user.h                         |   8 +-
>  include/linux/unicode.h                            |   1 +
>  include/net/af_vsock.h                             |   3 +
>  init/init_task.c                                   |   1 +
>  init/main.c                                        |   3 +
>  io_uring/cancel.c                                  |   7 +-
>  ipc/namespace.c                                    |   2 +-
>  kernel/cgroup/cgroup.c                             |   6 +-
>  kernel/events/core.c                               |  33 +++---
>  kernel/exit.c                                      |   2 +-
>  kernel/fork.c                                      |  67 +++++++----
>  kernel/futex/core.c                                |  55 +++++----
>  kernel/irq/proc.c                                  |  24 ++--
>  kernel/kcmp.c                                      |   2 +-
>  kernel/pid_namespace.c                             |   2 +-
>  kernel/printk/printk.c                             |   2 +-
>  kernel/sched/core.c                                |  19 ++--
>  kernel/sched/ext/ext.c                             |  95 +++++++++++-----
>  kernel/sched/ext/idle.c                            |  50 ++++++--
>  kernel/sched/ext/internal.h                        |   5 +-
>  kernel/trace/Makefile                              |   5 +-
>  kernel/trace/ring_buffer.c                         |  60 +++++-----
>  kernel/trace/trace.c                               |  28 ++++-
>  kernel/trace/trace_events_filter.c                 |   9 +-
>  kernel/trace/trace_events_hist.c                   |  90 ++++++++-------
>  kernel/trace/trace_probe.c                         |   3 +-
>  kernel/trace/trace_snapshot.c                      |   5 +-
>  kernel/trace/undefsyms_base.c                      |   5 +-
>  kernel/umh.c                                       |   6 +-
>  kernel/watch_queue.c                               |  11 +-
>  kernel/workqueue.c                                 |  27 +++--
>  lib/crypto/arm64/poly1305-armv8.pl                 |   2 +-
>  lib/crypto/poly1305.c                              |   2 +-
>  net/bridge/br_multicast.c                          |  13 ++-
>  net/core/page_pool.c                               |   3 +-
>  net/core/sock.c                                    |   3 +
>  net/ipv4/fib_semantics.c                           |   2 +-
>  net/ipv4/tcp.c                                     |  18 ++-
>  net/ipv4/tcp_cong.c                                |   4 +-
>  net/ipv4/tcp_dctcp.c                               |   4 +-
>  net/ipv4/tcp_minisocks.c                           |   2 +-
>  net/ipv4/tcp_output.c                              |   2 +-
>  net/ipv6/calipso.c                                 |   6 +-
>  net/iucv/af_iucv.c                                 |  42 ++++---
>  net/mac802154/ieee802154_i.h                       |   7 +-
>  net/mac802154/main.c                               |   1 +
>  net/mac802154/scan.c                               |  51 ++++++---
>  net/netlink/af_netlink.c                           |  10 +-
>  net/rds/rdma_transport.c                           |  38 ++++++-
>  net/sched/act_api.c                                |  11 +-
>  net/sched/cls_flower.c                             |   5 +
>  net/sctp/inqueue.c                                 |   6 +-
>  net/sctp/socket.c                                  |  33 ++++--
>  net/tipc/node.c                                    |   2 +
>  net/vmw_vsock/af_vsock.c                           |  49 ++++++--
>  net/vmw_vsock/virtio_transport_common.c            |   3 +-
>  net/vmw_vsock/vmci_transport.c                     |  34 +++++-
>  samples/pidfd/Makefile                             |   2 +-
>  security/selinux/hooks.c                           |  36 ++----
>  sound/soc/amd/yc/pci-acp6x.c                       |  38 ++++++-
>  sound/soc/codecs/cs42l52.c                         |   2 +-
>  sound/soc/codecs/cs42l56.c                         |   2 +-
>  sound/soc/codecs/max98371.c                        |   2 +-
>  sound/soc/codecs/nau8822.c                         |   4 +-
>  sound/soc/codecs/pcm3168a.c                        |   2 +-
>  sound/soc/codecs/wm8978.c                          |   4 +-
>  sound/soc/intel/avs/pcm.c                          |   2 +-
>  sound/soc/sof/ipc4-topology.c                      |   9 +-
>  sound/soc/sof/sof-client.c                         |   6 +-
>  sound/soc/stm/stm32_spdifrx.c                      |   2 +-
>  tools/arch/x86/include/asm/insn.h                  |   2 +-
>  tools/bootconfig/main.c                            |   3 +-
>  tools/gpio/Makefile                                |   6 +
>  tools/power/x86/turbostat/turbostat.c              |  74 +++++++-----
>  238 files changed, 2279 insertions(+), 949 deletions(-)
>=20
>=20

--=20

--t0XAjP8Jk4Nbn4Hv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatvHKgAKCRAw5/Bqldv6
8nrIAKCpwZQxGudlayNZh7CK3O8IWcFRZwCcC9Ed+1XkhmF97esQZauwVt/7L6A=
=EgfB
-----END PGP SIGNATURE-----

--t0XAjP8Jk4Nbn4Hv--
