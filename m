Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EE91A2FB1;
	Tue, 18 Jun 2024 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714445; cv=none; b=hoNSAYWRG6C+5OCX+LfuHbEELjrZAEjYmiufvj6Waqhkp8rzuBJI4yrg0RA/kzCXQWJItzYGzeBLLJC4atJ3GIzWo81QzQ6kZO2KZ2xZ+cMTopR0HRhwFFUb3r7x6467MwmtU/oN8L1xGfN/ZU9jUwjn2c04485C1p+tF3DEemA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714445; c=relaxed/simple;
	bh=/9B/4RC90xg+fmmI7AAEtXdZWdD/7x0Is7XUxQpGrOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iam/+CcLy+NSH2OaHIcMwYOfInUhX8DzhOLI6d1ainChOvbBHmrecB+9urqJIgtA+oiiyxMWcm2hCABVaF9ZWfR3BpaznOaDh+9qgUMAJZz9bHg3FkIpWHtJ0iE32KXiHXy7q9l4h+y6IjeSiOm7NT8XUWEmcu1FL0NnqKNwfYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqJ/PbNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqJ/PbNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189E9C3277B;
	Tue, 18 Jun 2024 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714445;
	bh=/9B/4RC90xg+fmmI7AAEtXdZWdD/7x0Is7XUxQpGrOI=;
	h=From:To:Cc:Subject:Date:From;
	b=tqJ/PbNn2kLWAkGqqRJDTaHQLuTkYtR/I/r8kvXP1T9XTQn0jOmHXJKPL32PNFqrt
	 RGWB7IZeXa7F5jeAEUDT/6d5ltWEMYHWBp43jRsmMjnnNbMl3vQB2sJ/fJ/4/Rx20N
	 oyJCD0bEyNsX91AlzkydNCIyY6iSGY98a5dCGY8c=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/770] 5.10.220-rc1 review
Date: Tue, 18 Jun 2024 14:27:33 +0200
Message-ID: <20240618123407.280171066@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.220-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.220-rc1
X-KernelTest-Deadline: 2024-06-20T12:34+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.220 release.
There are 770 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.220-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.220-rc1

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix a regression in nfsd_setattr()

NeilBrown <neilb@suse.de>
    nfsd: don't call locks_release_private() twice concurrently

NeilBrown <neilb@suse.de>
    nfsd: don't take fi_lock in nfsd_break_deleg_cb()

NeilBrown <neilb@suse.de>
    nfsd: fix RELEASE_LOCKOWNER

Jeff Layton <jlayton@kernel.org>
    nfsd: drop the nfsd_put helper

NeilBrown <neilb@suse.de>
    nfsd: call nfsd_last_thread() before final nfsd_put()

NeilBrown <neilb@suse.de>
    NFSD: fix possible oops when nfsd/pool_stats is closed.

Chuck Lever <chuck.lever@oracle.com>
    Documentation: Add missing documentation for EXPORT_OP flags

NeilBrown <neilb@suse.de>
    nfsd: separate nfsd_last_thread() from nfsd_put()

NeilBrown <neilb@suse.de>
    nfsd: Simplify code around svc_exit_thread() call in nfsd()

Chuck Lever <chuck.lever@oracle.com>
    nfsd: don't allow nfsd threads to be signalled.

Tavian Barnes <tavianator@tavianator.com>
    nfsd: Fix creation time serialization order

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd4_encode_nfstime4() helper

NeilBrown <neilb@suse.de>
    lockd: drop inappropriate svc_get() from locked_get()

Dan Carpenter <dan.carpenter@linaro.org>
    nfsd: fix double fget() bug in __write_ports_addfd()

Jeff Layton <jlayton@kernel.org>
    nfsd: make a copy of struct iattr before calling notify_change

Dai Ngo <dai.ngo@oracle.com>
    NFSD: Fix problem of COMMIT and NFS4ERR_DELAY in infinite loop

Jeff Layton <jlayton@kernel.org>
    nfsd: simplify the delayed disposal list code

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Convert filecache to rhltable

Jeff Layton <jlayton@kernel.org>
    nfsd: allow reaping files still under writeback

Jeff Layton <jlayton@kernel.org>
    nfsd: update comment over __nfsd_file_cache_purge

Jeff Layton <jlayton@kernel.org>
    nfsd: don't take/put an extra reference when putting a file

Jeff Layton <jlayton@kernel.org>
    nfsd: add some comments to nfsd_file_do_acquire

Jeff Layton <jlayton@kernel.org>
    nfsd: don't kill nfsd_files because of lease break error

Jeff Layton <jlayton@kernel.org>
    nfsd: simplify test_bit return in NFSD_FILE_KEY_FULL comparator

Jeff Layton <jlayton@kernel.org>
    nfsd: NFSD_FILE_KEY_INODE only needs to find GC'ed entries

Jeff Layton <jlayton@kernel.org>
    nfsd: don't open-code clear_and_wake_up_bit

Jeff Layton <jlayton@kernel.org>
    nfsd: call op_release, even when op_func returns an error

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL

Jeff Layton <jlayton@kernel.org>
    nfsd: don't replace page in rq_pages if it's a continuation of last page

Jeff Layton <jlayton@kernel.org>
    lockd: set file_lock start and end when decoding nlm4 testargs

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against filesystem freezing

Chuck Lever <chuck.lever@oracle.com>
    NFSD: copy the whole verifier in nfsd_copy_write_verifier

Jeff Layton <jlayton@kernel.org>
    nfsd: don't fsync nfsd_files on last close

Jeff Layton <jlayton@kernel.org>
    nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix problems with cleanup on errors in nfsd4_copy

Jeff Layton <jlayton@kernel.org>
    nfsd: don't hand out delegation on setuid files being opened for write

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix leaked reference count of nfsd4_ssc_umount_item

Jeff Layton <jlayton@kernel.org>
    nfsd: clean up potential nfsd_file refcount leaks in COPY codepath

Jeff Layton <jlayton@kernel.org>
    nfsd: allow nfsd_file_get to sanely handle a NULL pointer

Dai Ngo <dai.ngo@oracle.com>
    NFSD: enhance inter-server copy cleanup

Jeff Layton <jlayton@kernel.org>
    nfsd: don't destroy global nfs4_file table in per-net shutdown

Jeff Layton <jlayton@kernel.org>
    nfsd: don't free files unconditionally in __nfsd_file_cache_purge

Dai Ngo <dai.ngo@oracle.com>
    NFSD: replace delayed_work with work_struct for nfsd_client_shrinker

Dai Ngo <dai.ngo@oracle.com>
    NFSD: register/unregister of nfsd-client shrinker at nfsd startup/shutdown time

Xingyuan Mo <hdthky0@gmail.com>
    NFSD: fix use-after-free in nfsd4_ssc_setup_dul()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use set_bit(RQ_DROPME)

Chuck Lever <chuck.lever@oracle.com>
    Revert "SUNRPC: Use RMW bitops in single-threaded hot paths"

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of cached open files in nfsd4_open codepath

Jeff Layton <jlayton@kernel.org>
    nfsd: rework refcounting in filecache

Kees Cook <keescook@chromium.org>
    NFSD: Avoid clashing function prototypes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use only RQ_DROPME to signal the need to drop a reply

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add delegation reaper to react to low memory condition

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add support for sending CB_RECALL_ANY

Dai Ngo <dai.ngo@oracle.com>
    NFSD: refactoring courtesy_client_reaper to a generic low memory shrinker

Brian Foster <bfoster@redhat.com>
    NFSD: pass range end to vfs_fsync_range() instead of count

Jeff Layton <jlayton@kernel.org>
    lockd: fix file selection in nlmsvc_cancel_blocked

Jeff Layton <jlayton@kernel.org>
    lockd: ensure we use the correct file descriptor when unlocking

Jeff Layton <jlayton@kernel.org>
    lockd: set missing fl_flags field when retrieving args

Xiu Jianfeng <xiujianfeng@huawei.com>
    NFSD: Use struct_size() helper in alloc_session()

Jeff Layton <jlayton@kernel.org>
    nfsd: return error if nfs4_setacl fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    lockd: set other missing fields when unlocking files

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd_file_fsync tracepoint

Jeff Layton <jlayton@kernel.org>
    nfsd: fix up the filecache laundrette scheduling

Jeff Layton <jlayton@kernel.org>
    nfsd: reorganize filecache.c

Jeff Layton <jlayton@kernel.org>
    nfsd: remove the pages_flushed statistic from filecache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix licensing header in filecache.c

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use rhashtable for managing nfs4_file objects

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor find_file()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up find_or_add_file()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a nfsd4_file_hash_remove() helper

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd4_init_file()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update file_hashtbl() helpers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use const pointers as parameters to fh_ helpers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Trace delegation revocations

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Trace stateids returned via DELEGRETURN

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfs4_preprocess_stateid_op() call sites

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Flesh out a documenting comment for filecache.c

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Pass the target nfsd_file to nfsd_commit()

David Disseldorp <ddiss@suse.de>
    exportfs: use pr_debug for unreachable debug statements

Jeff Layton <jlayton@kernel.org>
    nfsd: allow disabling NFSv2 at compile time

Jeff Layton <jlayton@kernel.org>
    nfsd: move nfserrno() to vfs.c

Jeff Layton <jlayton@kernel.org>
    nfsd: ignore requests to disable unsupported versions

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Finish converting the NFSv3 GETACL result encoder

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Finish converting the NFSv2 GETACL result encoder

Colin Ian King <colin.i.king@gmail.com>
    NFSD: Remove redundant assignment to variable host_err

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSD: Simplify READ_PLUS

Jeff Layton <jlayton@kernel.org>
    nfsd: use locks_inode_context helper

Jeff Layton <jlayton@kernel.org>
    lockd: use locks_inode_context helper

Jeff Layton <jlayton@kernel.org>
    filelock: add a new locks_inode_context accessor function

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix reads with a non-zero offset that don't end on a page boundary

Jeff Layton <jlayton@kernel.org>
    nfsd: put the export reference in nfsd4_verify_deleg_dentry

Jeff Layton <jlayton@kernel.org>
    nfsd: fix use-after-free in nfsd_file_do_acquire tracepoint

Jeff Layton <jlayton@kernel.org>
    nfsd: fix net-namespace logic in __nfsd_file_cache_purge

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    NFSD: unregister shrinker when nfsd_init_net() fails

Jeff Layton <jlayton@kernel.org>
    nfsd: rework hashtable handling in nfsd_do_file_acquire

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file_unhash_and_dispose

Gaosheng Cui <cuigaosheng1@huawei.com>
    fanotify: Remove obsoleted fanotify_event_has_path()

Gaosheng Cui <cuigaosheng1@huawei.com>
    fsnotify: remove unused declaration

Al Viro <viro@zeniv.linux.org.uk>
    fs/notify: constify path

Jeff Layton <jlayton@kernel.org>
    nfsd: extra checks when freeing delegation stateids

Jeff Layton <jlayton@kernel.org>
    nfsd: make nfsd4_run_cb a bool return function

Jeff Layton <jlayton@kernel.org>
    nfsd: fix comments about spinlock handling with delegations

Jeff Layton <jlayton@kernel.org>
    nfsd: only fill out return pointer on success in nfsd4_lookup_stateid

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap rsize_bop result based on send buffer size

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rename the fields in copy_stateid_t

ChenXiaoSong <chenxiaosong2@huawei.com>
    nfsd: use DEFINE_SHOW_ATTRIBUTE to define nfsd_file_cache_stats_fops

ChenXiaoSong <chenxiaosong2@huawei.com>
    nfsd: use DEFINE_SHOW_ATTRIBUTE to define nfsd_reply_cache_stats_fops

ChenXiaoSong <chenxiaosong2@huawei.com>
    nfsd: use DEFINE_SHOW_ATTRIBUTE to define client_info_fops

ChenXiaoSong <chenxiaosong2@huawei.com>
    nfsd: use DEFINE_SHOW_ATTRIBUTE to define export_features_fops and supported_enctypes_fops

ChenXiaoSong <chenxiaosong2@huawei.com>
    nfsd: use DEFINE_PROC_SHOW_ATTRIBUTE to define nfsd_proc_ops

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Pack struct nfsd4_compoundres

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove unused nfsd4_compoundargs::cachetype field

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove "inline" directives on op_rsize_bop helpers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfs4svc_encode_compoundres()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up WRITE arg decoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use xdr_inline_decode() to decode NFSv3 symlinks

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor common code out of dirlist helpers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reduce amount of struct nfsd4_compoundargs that needs clearing

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Parametrize how much of argsize should be zeroed

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add shrinker to reap courtesy clients on low memory condition

Dai Ngo <dai.ngo@oracle.com>
    NFSD: keep track of the number of courtesy clients in the system

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfsd4_remove() wait before returning NFS4ERR_DELAY

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfsd4_rename() wait before returning NFS4ERR_DELAY

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfsd4_setattr() wait before returning NFS4ERR_DELAY

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd_setattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a mechanism to wait for a DELEGRETURN

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints to report NFSv4 callback completions

Gaosheng Cui <cuigaosheng1@huawei.com>
    nfsd: remove nfsd4_prepare_cb_recall() declaration

Jeff Layton <jlayton@kernel.org>
    nfsd: clean up mounted_on_fileid handling

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix handling of oversized NFSv4 COMPOUND requests

NeilBrown <neilb@suse.de>
    NFSD: drop fname and flen args from nfsd_create_locked()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv3 READ

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv2 READ

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv3 READDIR

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv2 READDIR

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Increase NFSD_MAX_OPS_PER_COMPOUND

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfsd: Propagate some error code returned by memdup_user()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfsd: Avoid some useless tests

Jinpeng Cui <cui.jinpeng2@zte.com.cn>
    NFSD: remove redundant variable status

Olga Kornievskaia <kolga@netapp.com>
    NFSD enforce filehandle check for source file in COPY

Wolfram Sang <wsa+renesas@sang-engineering.com>
    lockd: move from strlcpy with unused retval to strscpy

Wolfram Sang <wsa+renesas@sang-engineering.com>
    NFSD: move from strlcpy with unused retval to strscpy

Al Viro <viro@zeniv.linux.org.uk>
    nfsd_splice_actor(): handle compound pages

NeilBrown <neilb@suse.de>
    NFSD: fix regression with setting ACLs.

Jeff Layton <jlayton@kernel.org>
    lockd: detect and reject lock arguments that overflow

NeilBrown <neilb@suse.de>
    NFSD: discard fh_locked flag and fh_lock/fh_unlock

NeilBrown <neilb@suse.de>
    NFSD: use (un)lock_inode instead of fh_(un)lock for file operations

NeilBrown <neilb@suse.de>
    NFSD: use explicit lock/unlock for directory ops

NeilBrown <neilb@suse.de>
    NFSD: reduce locking in nfsd_lookup()

NeilBrown <neilb@suse.de>
    NFSD: only call fh_unlock() once in nfsd_link()

NeilBrown <neilb@suse.de>
    NFSD: always drop directory lock in nfsd_unlink()

NeilBrown <neilb@suse.de>
    NFSD: change nfsd_create()/nfsd_symlink() to unlock directory before returning.

NeilBrown <neilb@suse.de>
    NFSD: add posix ACLs to struct nfsd_attrs

NeilBrown <neilb@suse.de>
    NFSD: add security label to struct nfsd_attrs

NeilBrown <neilb@suse.de>
    NFSD: set attributes when creating symlinks

NeilBrown <neilb@suse.de>
    NFSD: introduce struct nfsd_attrs

Jeff Layton <jlayton@kernel.org>
    NFSD: verify the opened dentry after setting a delegation

Jeff Layton <jlayton@kernel.org>
    NFSD: drop fh argument from alloc_init_deleg

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move copy offload callback arguments into a separate structure

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd4_send_cb_offload()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove kmalloc from nfsd4_do_async_copy()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd4_do_copy()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd4_cleanup_inter_ssc() (2/2)

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd4_cleanup_inter_ssc() (1/2)

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace boolean fields in struct nfsd4_copy

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfs4_put_copy() static

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reorder the fields in struct nfsd4_op

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Shrink size of struct nfsd4_copy

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Shrink size of struct nfsd4_copy_notify

Chuck Lever <chuck.lever@oracle.com>
    NFSD: nfserrno(-ENOMEM) is nfserr_jukebox

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix strncpy() fortify warning

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd4_encode_readlink()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Use xdr_pad_size()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Simplify starting_len

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Optimize nfsd4_encode_readv()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd4_read::rd_eof field

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up SPLICE_OK in nfsd4_encode_read()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Optimize nfsd4_encode_fattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Optimize nfsd4_encode_operation()

Jeff Layton <jlayton@kernel.org>
    nfsd: silence extraneous printk on nfsd.ko insertion

Dai Ngo <dai.ngo@oracle.com>
    NFSD: limit the number of v4 clients to 1024 per 1GB of system memory

Dai Ngo <dai.ngo@oracle.com>
    NFSD: keep track of the number of v4 clients in the system

Dai Ngo <dai.ngo@oracle.com>
    NFSD: refactoring v4 specific code to a helper in nfs4state.c

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Ensure nf_inode is never dereferenced

Chuck Lever <chuck.lever@oracle.com>
    NFSD: NFSv4 CLOSE should release an nfsd_file immediately

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move nfsd_file_trace_alloc() tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Separate tracepoints for acquire and create

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up unused code after rhashtable conversion

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Convert the filecache to use rhashtable

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Set up an rhashtable for the filecache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace the "init once" mechanism

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove nfsd_file::nf_hashval

Chuck Lever <chuck.lever@oracle.com>
    NFSD: nfsd_file_hash_remove can compute hashval

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor __nfsd_file_close_inode()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove lockdep assertion from unhash_and_release_locked()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: No longer record nf_hashval in the trace log

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Never call nfsd_file_gc() in foreground paths

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix the filecache LRU shrinker

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Leave open files out of the filecache LRU

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Trace filecache LRU activity

Chuck Lever <chuck.lever@oracle.com>
    NFSD: WARN when freeing an item still linked via nf_lru

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Hook up the filecache stat file

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Zero counters when the filecache is re-initialized

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Record number of flush calls

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Report the number of items evicted by the LRU walk

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd_file_lru_scan()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd_file_gc()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_file_lru_dispose_list() helper

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Report average age of filecache items

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Report count of freed filecache items

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Report count of calls to nfsd_file_acquire()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Report filecache LRU size

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Demote a WARN to a pr_warn()

Colin Ian King <colin.i.king@gmail.com>
    nfsd: remove redundant assignment to variable len

Zhang Jiaming <jiaming@nfschina.com>
    NFSD: Fix space and spelling mistake

Benjamin Coddington <bcodding@redhat.com>
    NLM: Defend against file_lock changes after vfs_test_lock()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix xdr_encode_bool()

Jeff Layton <jlayton@kernel.org>
    nfsd: eliminate the NFSD_FILE_BREAK_* flags

Xin Gao <gaoxin@cdjrlc.com>
    fsnotify: Fix comment typo

Amir Goldstein <amir73il@gmail.com>
    fanotify: introduce FAN_MARK_IGNORE

Amir Goldstein <amir73il@gmail.com>
    fanotify: cleanups for fanotify_mark() input validations

Amir Goldstein <amir73il@gmail.com>
    fanotify: prepare for setting event flags in ignore mask

Oliver Ford <ojford@gmail.com>
    fs: inotify: Fix typo in inotify comment

Jeff Layton <jlayton@kernel.org>
    lockd: fix nlm_close_files

Jeff Layton <jlayton@kernel.org>
    lockd: set fl_owner when unlocking files

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Decode NFSv4 birth time attribute

NeilBrown <neilb@suse.de>
    NFS: restore module put when manager exits.

Amir Goldstein <amir73il@gmail.com>
    fanotify: refine the validation checks on non-dir inode mask

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Optimize xdr_reserve_space()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix potential use-after-free in nfsd_file_put()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: nfsd_file_put() can sleep

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add documenting comment for nfsd4_release_lockowner()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Modernize nfsd4_release_lockowner()

Julian Schroeder <jumaco@amazon.com>
    nfsd: destroy percpu stats counters after reply cache shutdown

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    nfsd: Fix null-ptr-deref in nfsd_fill_super()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    nfsd: Unregister the cld notifier when laundry_wq create failed

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Use RMW bitops in single-threaded hot paths

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up the show_nf_flags() macro

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Trace filecache opens

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move documenting comment for nfsd4_process_open2()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix whitespace

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove dprintk call sites from tail of nfsd4_open()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Instantiate a struct file when creating a regular NFSv4 file

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd_open_verified()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove do_nfsd_create()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor NFSv4 OPEN(CREATE)

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor NFSv3 CREATE

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd_create_setattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Avoid calling fh_drop_write() twice in do_nfsd_create()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd3_proc_create()

Dai Ngo <dai.ngo@oracle.com>
    NFSD: Show state of courtesy client in client info

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add support for lock conflict to courteous server

Dai Ngo <dai.ngo@oracle.com>
    fs/lock: add 2 callbacks to lock_manager_operations to resolve conflict

Dai Ngo <dai.ngo@oracle.com>
    fs/lock: add helper locks_owner_has_blockers to check for blockers

Dai Ngo <dai.ngo@oracle.com>
    NFSD: move create/destroy of laundry_wq to init_nfsd and exit_nfsd

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add support for share reservation conflict to courteous server

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add courteous server support for thread with only delegation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd_splice_actor()

Vasily Averin <vvs@openvz.org>
    fanotify: fix incorrect fmode_t casts

Amir Goldstein <amir73il@gmail.com>
    fsnotify: consistent behavior for parent not watching children

Amir Goldstein <amir73il@gmail.com>
    fsnotify: introduce mark type iterator

Amir Goldstein <amir73il@gmail.com>
    fanotify: enable "evictable" inode marks

Amir Goldstein <amir73il@gmail.com>
    fanotify: use fsnotify group lock helpers

Amir Goldstein <amir73il@gmail.com>
    fanotify: implement "evictable" inode marks

Amir Goldstein <amir73il@gmail.com>
    fanotify: factor out helper fanotify_mark_update_flags()

Amir Goldstein <amir73il@gmail.com>
    fanotify: create helper fanotify_mark_user_flags()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: allow adding an inode mark without pinning inode

Amir Goldstein <amir73il@gmail.com>
    dnotify: use fsnotify group lock helpers

Amir Goldstein <amir73il@gmail.com>
    nfsd: use fsnotify group lock helpers

Amir Goldstein <amir73il@gmail.com>
    inotify: use fsnotify group lock helpers

Amir Goldstein <amir73il@gmail.com>
    fsnotify: create helpers for group mark_mutex lock

Amir Goldstein <amir73il@gmail.com>
    fsnotify: make allow_dups a property of the group

Amir Goldstein <amir73il@gmail.com>
    fsnotify: pass flags argument to fsnotify_alloc_group()

Amir Goldstein <amir73il@gmail.com>
    inotify: move control flags from mask to mark flags

Dai Ngo <dai.ngo@oracle.com>
    fs/lock: documentation cleanup. Replace inode->i_lock with flc_lock.

Amir Goldstein <amir73il@gmail.com>
    fanotify: do not allow setting dirent events in mask of non-dir

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Clean up nfsd_file_put()

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix a write performance regression

Haowen Bai <baihaowen@meizu.com>
    SUNRPC: Return true/false (not 1/0) from bool functions

Bang Li <libang.linuxer@gmail.com>
    fsnotify: remove redundant parameter judgment

Amir Goldstein <amir73il@gmail.com>
    fsnotify: optimize FS_MODIFY events with no ignored masks

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix merge with parent's ignored mask

Jakob Koschel <jakobkoschel@gmail.com>
    nfsd: fix using the correct variable for sizeof()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up _lm_ operation names

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove CONFIG_NFSD_V3

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move svc_serv_ops::svo_function into struct svc_serv

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove svc_serv_ops::svo_module

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove svc_shutdown_net()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Rename svc_close_xprt()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Rename svc_create_xprt()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove svo_shutdown method

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Merge svc_do_enqueue_xprt() into svc_enqueue_xprt()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove the .svo_enqueue_xprt method

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Streamline the rare "found" case

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Skip extra computation for RC_NOCACHE case

Chuck Lever <chuck.lever@oracle.com>
    NFSD: De-duplicate hash bucket indexing

Ondrej Valousek <ondrej.valousek.xm@renesas.com>
    nfsd: Add support for the birth time attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Deprecate NFS_OFFSET_MAX

Chuck Lever <chuck.lever@oracle.com>
    NFSD: COMMIT operations must not return NFS?ERR_INVAL

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix NFSv3 SETATTR/CREATE's handling of large file sizes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix ia_size underflow

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix the behavior of READ near OFFSET_MAX

J. Bruce Fields <bfields@redhat.com>
    lockd: fix failure to cleanup client locks

J. Bruce Fields <bfields@redhat.com>
    lockd: fix server crash on reboot of client holding lock

Yang Li <yang.lee@linux.alibaba.com>
    fanotify: remove variable set but not used

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix crash on COPY_NOTIFY with special stateid

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move fill_pre_wcc() and fill_post_wcc()

Chuck Lever <chuck.lever@oracle.com>
    Revert "nfsd: skip some unnecessary stats in the v4 case"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Trace boot verifier resets

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rename boot verifier functions

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up the nfsd_net::nfssvc_boot field

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Write verifier might go backwards

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Add a tracepoint for errors in nfsd4_clone_file_range()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: De-duplicate net_generic(nf->nf_net, nfsd_net_id)

Chuck Lever <chuck.lever@oracle.com>
    NFSD: De-duplicate net_generic(SVC_NET(rqstp), nfsd_net_id)

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd_vfs_write()

Jeff Layton <jeff.layton@primarydata.com>
    nfsd: Retry once in nfsd_open on an -EOPENSTALE return

Jeff Layton <jeff.layton@primarydata.com>
    nfsd: Add errno mapping for EREMOTEIO

Peng Tao <tao.peng@primarydata.com>
    nfsd: map EBADF

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix zero-length NFSv3 WRITEs

Vasily Averin <vvs@virtuozzo.com>
    nfsd4: add refcount for nfsd4_blocked_lock

J. Bruce Fields <bfields@redhat.com>
    nfs: block notification on fs with its own ->lock

Chuck Lever <chuck.lever@oracle.com>
    NFSD: De-duplicate nfsd4_decode_bitmap4()

J. Bruce Fields <bfields@redhat.com>
    nfsd: improve stateid access bitmask documentation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Combine XDR error tracepoints

NeilBrown <neilb@suse.de>
    NFSD: simplify per-net file cache management

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    NFSD: Fix inconsistent indenting

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove be32_to_cpu() from DRC hash function

NeilBrown <neilb@suse.de>
    NFS: switch the callback service back to non-pooled.

NeilBrown <neilb@suse.de>
    lockd: use svc_set_num_threads() for thread start and stop

NeilBrown <neilb@suse.de>
    SUNRPC: always treat sv_nrpools==1 as "not pooled"

NeilBrown <neilb@suse.de>
    SUNRPC: move the pool_map definitions (back) into svc.c

NeilBrown <neilb@suse.de>
    lockd: rename lockd_create_svc() to lockd_get()

NeilBrown <neilb@suse.de>
    lockd: introduce lockd_put()

NeilBrown <neilb@suse.de>
    lockd: move svc_exit_thread() into the thread

NeilBrown <neilb@suse.de>
    lockd: move lockd_start_svc() call into lockd_create_svc()

NeilBrown <neilb@suse.de>
    lockd: simplify management of network status notifiers

NeilBrown <neilb@suse.de>
    lockd: introduce nlmsvc_serv

NeilBrown <neilb@suse.de>
    NFSD: simplify locking for network notifier.

NeilBrown <neilb@suse.de>
    SUNRPC: discard svo_setup and rename svc_set_num_threads_sync()

NeilBrown <neilb@suse.de>
    NFSD: Make it possible to use svc_set_num_threads_sync

NeilBrown <neilb@suse.de>
    NFSD: narrow nfsd_mutex protection in nfsd thread

NeilBrown <neilb@suse.de>
    SUNRPC: use sv_lock to protect updates to sv_nrthreads.

NeilBrown <neilb@suse.de>
    nfsd: make nfsd_stats.th_cnt atomic_t

NeilBrown <neilb@suse.de>
    SUNRPC: stop using ->sv_nrthreads as a refcount

NeilBrown <neilb@suse.de>
    SUNRPC/NFSD: clean up get/put functions.

NeilBrown <neilb@suse.de>
    SUNRPC: change svc_get() to return the svc.

NeilBrown <neilb@suse.de>
    NFSD: handle errors better in write_ports_addfd()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix sparse warning

Eric W. Biederman <ebiederm@xmission.com>
    exit: Rename module_put_and_exit to module_put_and_kthread_exit

Eric W. Biederman <ebiederm@xmission.com>
    exit: Implement kthread_exit

Amir Goldstein <amir73il@gmail.com>
    fanotify: wire up FAN_RENAME event

Amir Goldstein <amir73il@gmail.com>
    fanotify: report old and/or new parent+name in FAN_RENAME event

Amir Goldstein <amir73il@gmail.com>
    fanotify: record either old name new name or both for FAN_RENAME

Amir Goldstein <amir73il@gmail.com>
    fanotify: record old and new parent and name in FAN_RENAME event

Amir Goldstein <amir73il@gmail.com>
    fanotify: support secondary dir fh and name in fanotify_info

Amir Goldstein <amir73il@gmail.com>
    fanotify: use helpers to parcel fanotify_info buffer

Amir Goldstein <amir73il@gmail.com>
    fanotify: use macros to get the offset to fanotify_info buffer

Amir Goldstein <amir73il@gmail.com>
    fsnotify: generate FS_RENAME event with rich information

Amir Goldstein <amir73il@gmail.com>
    fanotify: introduce group flag FAN_REPORT_TARGET_FID

Amir Goldstein <amir73il@gmail.com>
    fsnotify: separate mark iterator type from object type enum

Amir Goldstein <amir73il@gmail.com>
    fsnotify: clarify object type argument

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix READDIR buffer overflow

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix exposure in nfsd4_decode_bitmap()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: remove obselete comment

Changcheng Deng <deng.changcheng@zte.com.cn>
    NFSD:fix boolreturn.cocci warning

J. Bruce Fields <bfields@redhat.com>
    nfsd: update create verifier comment

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Change return value type of .pc_encode

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Replace the "__be32 *p" parameter to .pc_encode

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Save location of NFSv4 COMPOUND status

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Change return value type of .pc_decode

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Replace the "__be32 *p" parameter to .pc_decode

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Have legacy NFSD WRITE decoders use xdr_stream_subsegment()

Colin Ian King <colin.king@canonical.com>
    NFSD: Initialize pointer ni with NULL and not plain integer 0

NeilBrown <neilb@suse.de>
    NFSD: simplify struct nfsfh

NeilBrown <neilb@suse.de>
    NFSD: drop support for ancient filehandles

NeilBrown <neilb@suse.de>
    NFSD: move filehandle format declarations out of "uapi".

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Optimize DRC bucket pruning

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Trace calls to .rpc_call_done

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Allow users to request FAN_FS_ERROR events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Emit generic error info for error event

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Report fid info for file related file system errors

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: WARN_ON against too large file handles

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Add helpers to decide whether to report FID/DFID

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Wrap object_fh inline space in a creator macro

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Support merging of error events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Support enqueueing of error events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Pre-allocate pool of error events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Reserve UAPI bits for FAN_FS_ERROR

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Support FS_ERROR event type

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Require fid_mode for any non-fd event

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Encode empty file handle when no inode is provided

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Allow file handle encoding for unhashed events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Support null inode event in fanotify_dfid_inode

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Pass group argument to free_event

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Protect fsnotify_handle_inode_event from no-inode events

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Retrieve super block from the data field

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Add wrapper around fsnotify_add_event

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Add helper to detect overflow_event

Gabriel Krisman Bertazi <krisman@collabora.com>
    inotify: Don't force FS_IN_IGNORED

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Split fsid check from other fid mode checks

Gabriel Krisman Bertazi <krisman@collabora.com>
    fanotify: Fold event size calculation to its own function

Gabriel Krisman Bertazi <krisman@collabora.com>
    fsnotify: Don't insert unmergeable events in hashtable

Amir Goldstein <amir73il@gmail.com>
    fsnotify: clarify contract for create event hooks

Amir Goldstein <amir73il@gmail.com>
    fsnotify: pass dentry instead of inode data

Amir Goldstein <amir73il@gmail.com>
    fsnotify: pass data_type to fsnotify_name()

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix a warning for nfsd_file_close_inode

Chuck Lever <chuck.lever@oracle.com>
    NLM: Fix svcxdr_encode_owner()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix sb_connectors leak

Chuck Lever <chuck.lever@oracle.com>
    NFS: Remove unused callback void decoder

Chuck Lever <chuck.lever@oracle.com>
    NFS: Add a private local dispatcher for NFSv4 callback operations

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Eliminate the RQ_AUTHERR flag

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Set rq_auth_stat in the pg_authenticate() callout

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add svc_rqst::rq_auth_stat

J. Bruce Fields <bfields@redhat.com>
    nfs: don't allow reexport reclaims

J. Bruce Fields <bfields@redhat.com>
    lockd: don't attempt blocking locks on nfs reexports

J. Bruce Fields <bfields@redhat.com>
    nfs: don't atempt blocking locks on nfs reexports

J. Bruce Fields <bfields@redhat.com>
    Keep read and write fds with each nlm_file

J. Bruce Fields <bfields@redhat.com>
    lockd: update nlm_lookup_file reexport comment

J. Bruce Fields <bfields@redhat.com>
    nlm: minor refactoring

J. Bruce Fields <bfields@redhat.com>
    nlm: minor nlm_lookup_file argument change

Jia He <hejianet@gmail.com>
    lockd: change the proc_handler for nsm_use_hostnames

Jia He <hejianet@gmail.com>
    sysctl: introduce new proc handler proc_dobool

NeilBrown <neilb@suse.de>
    NFSD: remove vanity comments

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Batch release pages during splice read

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add svc_rqst_replace_page() API

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up splice actor

Amir Goldstein <amir73il@gmail.com>
    fsnotify: optimize the case of no marks of any type

Amir Goldstein <amir73il@gmail.com>
    fsnotify: count all objects with attached connectors

Amir Goldstein <amir73il@gmail.com>
    fsnotify: count s_fsnotify_inode_refs for attached connectors

Amir Goldstein <amir73il@gmail.com>
    fsnotify: replace igrab() with ihold() on attach connector

Matthew Bobrowski <repnop@google.com>
    fanotify: add pidfd support to the fanotify API

Matthew Bobrowski <repnop@google.com>
    fanotify: introduce a generic info record copying helper

Matthew Bobrowski <repnop@google.com>
    fanotify: minor cosmetic adjustments to fid labels

Matthew Bobrowski <repnop@google.com>
    kernel/pid.c: implement additional checks upon pidfd_create() parameters

Matthew Bobrowski <repnop@google.com>
    kernel/pid.c: remove static qualifier from pidfd_create()

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix NULL dereference in nfs3svc_encode_getaclres

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a possible oops in the nfs_dirent() tracepoint

Colin Ian King <colin.king@canonical.com>
    nfsd: remove redundant assignment to pointer 'this'

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 SHARE results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 nlm_res results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 TEST results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 void results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 FREE_ALL arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 SHARE arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 SM_NOTIFY arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 nlm_res arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 UNLOCK arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 CANCEL arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 LOCK arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 TEST arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv4 void arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 SHARE results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 nlm_res results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 TEST results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 void results encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 FREE_ALL arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 SHARE arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 SM_NOTIFY arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 nlm_res arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 UNLOCK arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 CANCEL arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 LOCK arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 TEST arguments decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Update the NLMv1 void argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    lockd: Common NLM XDR helpers

Chuck Lever <chuck.lever@oracle.com>
    lockd: Create a simplified .vs_dispatch method for NLM requests

Chuck Lever <chuck.lever@oracle.com>
    lockd: Remove stale comments

J. Bruce Fields <bfields@redhat.com>
    nfsd: rpc_peeraddr2str needs rcu lock

Wei Yongjun <weiyongjun1@huawei.com>
    NFSD: Fix error return code in nfsd4_interssc_connect()

Dai Ngo <dai.ngo@oracle.com>
    nfsd: fix kernel test robot warning in SSC code

Dave Wysochanski <dwysocha@redhat.com>
    nfsd4: Expose the callback address and state of each NFS4 client

J. Bruce Fields <bfields@redhat.com>
    nfsd: move fsnotify on client creation outside spinlock

Dai Ngo <dai.ngo@oracle.com>
    NFSD: delay unmount source's export after inter-server copy completed.

Olga Kornievskaia <kolga@netapp.com>
    NFSD add vfs_fsync after async copy is done

J. Bruce Fields <bfields@redhat.com>
    nfsd: move some commit_metadata()s outside the inode lock

Yu Hsiang Huang <nickhuang@synology.com>
    nfsd: Prevent truncation of an unlinked inode from blocking access to its directory

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update nfsd_cb_args tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove the nfsd_cb_work and nfsd_cb_done tracepoints

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd_cb_probe tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace the nfsd_deleg_break tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd_cb_offload tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd_cb_lm_notify tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Enhance the nfsd_cb_setup tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Adjust cb_shutdown tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add cb_lost tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Drop TRACE_DEFINE_ENUM for NFSD4_CB_<state> macros

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Capture every CB state transition

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Constify @fh argument of knfsd_fh_hash()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints for EXCHANGEID edge cases

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints for SETCLIENTID edge cases

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a couple more nfsd_clid_expired call sites

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_destroyed tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_reclaim_complete tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_confirmed tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove trace_nfsd_clid_inuse_err

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_verf_mismatch tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add nfsd_clid_cred_mismatch tracepoint

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an RPC authflavor tracepoint display helper

Amir Goldstein <amir73il@gmail.com>
    fanotify: fix permission model of unprivileged group

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: fix nfs_fetch_iversion()

Dai Ngo <dai.ngo@oracle.com>
    NFSv4.2: Remove ifdef CONFIG_NFSD from NFSv4.2 client SSC code.

Gustavo A. R. Silva <gustavoars@kernel.org>
    nfsd: Fix fall-through warnings for Clang

J. Bruce Fields <bfields@redhat.com>
    nfsd: grant read delegations to clients holding writes

J. Bruce Fields <bfields@redhat.com>
    nfsd: reshuffle some code

J. Bruce Fields <bfields@redhat.com>
    nfsd: track filehandle aliasing in nfs4_files

J. Bruce Fields <bfields@redhat.com>
    nfsd: hash nfs4_files by inode number

Vasily Averin <vvs@virtuozzo.com>
    nfsd: removed unused argument in nfsd_startup_generic()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    nfsd: remove unused function

Christian Brauner <christian.brauner@ubuntu.com>
    fanotify_user: use upper_32_bits() to verify mask

Amir Goldstein <amir73il@gmail.com>
    fanotify: support limited functionality for unprivileged users

Amir Goldstein <amir73il@gmail.com>
    fanotify: configurable limits via sysfs

Amir Goldstein <amir73il@gmail.com>
    fanotify: limit number of event merge attempts

Amir Goldstein <amir73il@gmail.com>
    fsnotify: use hash table for faster events merge

Amir Goldstein <amir73il@gmail.com>
    fanotify: mix event info and pid into merge key hash

Amir Goldstein <amir73il@gmail.com>
    fanotify: reduce event objectid to 29-bit hash

Chuck Lever <chuck.lever@oracle.com>
    Revert "fanotify: limit number of event merge attempts"

Amir Goldstein <amir73il@gmail.com>
    fsnotify: allow fsnotify_{peek,remove}_first_event with empty queue

Guobin Huang <huangguobin4@huawei.com>
    NFSD: Use DEFINE_SPINLOCK() for spinlock

Gustavo A. R. Silva <gustavoars@kernel.org>
    UAPI: nfsfh.h: Replace one-element array with flexible-array member

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Export svc_xprt_received()

NeilBrown <neilb@suse.de>
    nfsd: report client confirmation status in "info" file

J. Bruce Fields <bfields@redhat.com>
    nfsd: don't ignore high bits of copy count

J. Bruce Fields <bfields@redhat.com>
    nfsd: COPY with length 0 should copy to end of file

Ricardo Ribalda <ribalda@chromium.org>
    nfsd: Fix typo "accesible"

Paul Menzel <pmenzel@molgen.mpg.de>
    nfsd: Log client tracking type log message as info instead of warning

J. Bruce Fields <bfields@redhat.com>
    nfsd: helper for laundromat expiry calculations

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up NFSDDBG_FACILITY macro

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a tracepoint to record directory entry encoding

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up after updating NFSv3 ACL encoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 SETACL result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 GETACL result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up after updating NFSv2 ACL encoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 ACL ACCESS result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 ACL GETATTR result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 SETACL result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 GETACL result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an xdr_stream-based encoder for NFSv2/3 ACLs

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove unused NFSv2 directory entry encoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READDIR entry encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READDIR result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Count bytes instead of pages in the NFSv2 READDIR encoder

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a helper that encodes NFSv3 directory offset cookies, again

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 STATFS result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READ result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READLINK result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 diropres encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 attrstat encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 stat encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reduce svc_rqst::rq_pages churn during READDIR operations

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove unused NFSv3 directory entry encoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update NFSv3 READDIR entry encoders to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 READDIR3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Count bytes instead of pages in the NFSv3 READDIR encoder

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a helper that encodes NFSv3 directory offset cookies

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 COMMIT3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 PATHCONF3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 FSINFO3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 FSSTAT3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 LINK3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 RENAMEv3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 CREATE family of encoders to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 WRITE3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 READ3res encode to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 READLINK3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 wccstat result encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 LOOKUP3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 ACCESS3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the GETATTR3res encoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Extract the svcxdr_init_encode() helper

Christian Brauner <christian.brauner@ubuntu.com>
    namei: introduce struct renamedata

Christian Brauner <christian.brauner@ubuntu.com>
    fs: add file and path permissions helpers

Christoph Hellwig <hch@lst.de>
    kallsyms: only build {,module_}kallsyms_on_each_symbol when required

Christoph Hellwig <hch@lst.de>
    kallsyms: refactor {,module_}kallsyms_on_each_symbol

Christoph Hellwig <hch@lst.de>
    module: use RCU to synchronize find_module

Christoph Hellwig <hch@lst.de>
    module: unexport find_module and module_mutex

Shakeel Butt <shakeelb@google.com>
    inotify, memcg: account inotify instances to kmemcg

J. Bruce Fields <bfields@redhat.com>
    nfsd: skip some unnecessary stats in the v4 case

J. Bruce Fields <bfields@redhat.com>
    nfs: use change attribute for NFS re-exports

Dai Ngo <dai.ngo@oracle.com>
    NFSv4_2: SSC helper should use its own config.

J. Bruce Fields <bfields@redhat.com>
    nfsd: cstate->session->se_client -> cstate->clp

J. Bruce Fields <bfields@redhat.com>
    nfsd: simplify nfsd4_check_open_reclaim

J. Bruce Fields <bfields@redhat.com>
    nfsd: remove unused set_client argument

J. Bruce Fields <bfields@redhat.com>
    nfsd: find_cpntf_state cleanup

J. Bruce Fields <bfields@redhat.com>
    nfsd: refactor set_client

J. Bruce Fields <bfields@redhat.com>
    nfsd: rename lookup_clientid->set_client

J. Bruce Fields <bfields@redhat.com>
    nfsd: simplify nfsd_renew

J. Bruce Fields <bfields@redhat.com>
    nfsd: simplify process_lock

J. Bruce Fields <bfields@redhat.com>
    nfsd4: simplify process_lookup1

Amir Goldstein <amir73il@gmail.com>
    nfsd: report per-export stats

Amir Goldstein <amir73il@gmail.com>
    nfsd: protect concurrent access to nfsd stats counters

Amir Goldstein <amir73il@gmail.com>
    nfsd: remove unused stats counters

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up after updating NFSv3 ACL decoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 SETACL argument decoder to use struct xdr_stream, again

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 GETACL argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up after updating NFSv2 ACL decoders

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 ACL ACCESS argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 ACL GETATTR argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 SETACL argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an xdr_stream-based decoder for NFSv2/3 ACLs

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 GETACL argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove argument length checking in nfsd_dispatch()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 SYMLINK argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 CREATE argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 SETATTR argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 LINK argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 RENAME argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update NFSv2 diropargs decoding to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READDIR argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to set up the pages where the dirlist is encoded, again

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READLINK argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 WRITE argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 READ argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv2 GETATTR argument decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the MKNOD3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the SYMLINK3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the MKDIR3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the CREATE3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the SETATTR3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the LINK3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the RENAME3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update the NFSv3 DIROPargs decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update COMMIT3arg decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update READDIR3args decoders to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to set up the pages where the dirlist is encoded

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix returned READDIR offset cookie

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update READLINK3arg decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update WRITE3arg decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update READ3arg decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update ACCESS3arg decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Update GETATTR3args decoder to use struct xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Move definition of XDR_UNIT

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Display RPC procedure names instead of proc numbers

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Make trace_svc_process() display the RPC procedure symbolically

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Restore NFSv4 decoding's SAVEMEM functionality

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix sparse warning in nfssvc.c

Zheng Yongjun <zhengyongjun3@huawei.com>
    fs/lockd: convert comma to semicolon

Waiman Long <longman@redhat.com>
    inotify: Increase default inotify.max_user_watches limit to 1048576

Eric W. Biederman <ebiederm@xmission.com>
    file: Replace ksys_close with close_fd

Eric W. Biederman <ebiederm@xmission.com>
    file: Rename __close_fd to close_fd and remove the files parameter

Eric W. Biederman <ebiederm@xmission.com>
    file: Merge __alloc_fd into alloc_fd

Eric W. Biederman <ebiederm@xmission.com>
    file: In f_dupfd read RLIMIT_NOFILE once.

Eric W. Biederman <ebiederm@xmission.com>
    file: Merge __fd_install into fd_install

Eric W. Biederman <ebiederm@xmission.com>
    proc/fd: In fdinfo seq_show don't use get_files_struct

Eric W. Biederman <ebiederm@xmission.com>
    proc/fd: In proc_readfd_common use task_lookup_next_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    file: Implement task_lookup_next_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    kcmp: In get_file_raw_ptr use task_lookup_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    proc/fd: In tid_fd_mode use task_lookup_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    file: Implement task_lookup_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    file: Rename fcheck lookup_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    file: Replace fcheck_files with files_lookup_fd_rcu

Eric W. Biederman <ebiederm@xmission.com>
    file: Factor files_lookup_fd_locked out of fcheck_files

Eric W. Biederman <ebiederm@xmission.com>
    file: Rename __fcheck_files to files_lookup_fd_raw

Chuck Lever <chuck.lever@oracle.com>
    Revert "fget: clarify and improve __fget_files() implementation"

Eric W. Biederman <ebiederm@xmission.com>
    proc/fd: In proc_fd_link use fget_task

Eric W. Biederman <ebiederm@xmission.com>
    bpf: In bpf_task_fd_query use fget_task

Eric W. Biederman <ebiederm@xmission.com>
    kcmp: In kcmp_epoll_target use fget_task

Eric W. Biederman <ebiederm@xmission.com>
    exec: Remove reset_files_struct

Eric W. Biederman <ebiederm@xmission.com>
    exec: Simplify unshare_files

Eric W. Biederman <ebiederm@xmission.com>
    exec: Move unshare_files to fix posix file locking during exec

Eric W. Biederman <ebiederm@xmission.com>
    exec: Don't open code get_close_on_exec

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Record NFSv4 pre/post-op attributes as non-atomic

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Set PF_LOCAL_THROTTLE on local filesystems only

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix up nfsd to ensure that timeout errors don't result in ESTALE

Trond Myklebust <trond.myklebust@hammerspace.com>
    exportfs: Add a function to return the raw output from fh_to_dentry()

Jeff Layton <jeff.layton@primarydata.com>
    nfsd: close cached files prior to a REMOVE or RENAME that would replace target

Jeff Layton <jeff.layton@primarydata.com>
    nfsd: allow filesystems to opt out of subtree checking

Jeff Layton <jeff.layton@primarydata.com>
    nfsd: add a new EXPORT_OP_NOWCC flag to struct export_operations

J. Bruce Fields <bfields@redhat.com>
    Revert "nfsd4: support change_attr_type attribute"

J. Bruce Fields <bfields@redhat.com>
    nfsd4: don't query change attribute in v2/v3 case

J. Bruce Fields <bfields@redhat.com>
    nfsd: minor nfsd4_change_attribute cleanup

J. Bruce Fields <bfields@redhat.com>
    nfsd: simplify nfsd4_change_info

J. Bruce Fields <bfields@redhat.com>
    nfsd: only call inode_query_iversion in the I_VERSION case

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove macros that are no longer used

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_compound()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfsd4_ops::opnum a u32

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_listxattrs()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_setxattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_xattr_name()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_clone()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_seek()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_offload_status()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_copy_notify()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_copy()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_nl4_server()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_fallocate()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_reclaim_complete()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_destroy_clientid()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_test_stateid()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_sequence()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_secinfo_no_name()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_layoutreturn()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_layoutget()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_layoutcommit()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_getdeviceinfo()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_free_stateid()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_destroy_session()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_create_session()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a helper to decode channel_attrs4

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a helper to decode nfs_impl_id4

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a helper to decode state_protect4_a

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a separate decoder for ssv_sp_parms

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add a separate decoder to handle state_protect_ops

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_bind_conn_to_session()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_backchannel_ctl()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_cb_sec()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_release_lockowner()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_write()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_verify()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_setclientid_confirm()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_setclientid()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_setattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_secinfo()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_renew()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_rename()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_remove()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_readdir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_read()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_putfh()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_open_downgrade()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_open_confirm()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_open()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to decode OPEN's open_claim4 argument

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_share_deny()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_share_access()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to decode OPEN's openflag4 argument

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to decode OPEN's createhow4 argument

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper to decode NFSv4 verifiers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_lookup()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_locku()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_lockt()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_lock()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helper for decoding locker4

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add helpers to decode a clientid4 and an NFSv4 state owner

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Relocate nfsd4_decode_opaque()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_link()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_getattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_delegreturn()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_create()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_fattr()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 umask attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 security label attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 time_set attributes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 owner_group attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 owner attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 mode attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 acl attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros that decode the fattr4 size attribute

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Change the way the expected length of a fattr4 is checked

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_commit()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_close()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace READ* macros in nfsd4_decode_access()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace the internals of the READ_BUF() macro

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints in nfsd4_decode/encode_compound()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints in nfsd_dispatch()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add common helpers to decode void args and encode void results

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Prepare for xdr_stream-style decoding on the server-side

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add xdr_set_scratch_page() and xdr_reset_scratch_buffer()

Huang Guobin <huangguobin4@huawei.com>
    nfsd: Fix error return code in nfsd_file_cache_init()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add SPDX header for fs/nfsd/trace.c

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove extra "0x" in tracepoint format specifier

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up the show_nf_may macro

Alex Shi <alex.shi@linux.alibaba.com>
    nfsd/nfs3: remove unused macro nfsd3_fhandleres

Tom Rix <trix@redhat.com>
    NFSD: A semicolon is not needed after a switch statement.

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Invoke svc_encode_result_payload() in "read" NFSD encoders

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Rename svc_encode_read_payload()


-------------

Diffstat:

 Documentation/filesystems/files.rst          |    8 +-
 Documentation/filesystems/locking.rst        |   10 +-
 Documentation/filesystems/nfs/exporting.rst  |   78 +
 Makefile                                     |    4 +-
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
 crypto/algboss.c                             |    4 +-
 fs/Kconfig                                   |    6 +-
 fs/autofs/dev-ioctl.c                        |    5 +-
 fs/cachefiles/namei.c                        |    9 +-
 fs/cifs/connect.c                            |    2 +-
 fs/coredump.c                                |    5 +-
 fs/ecryptfs/inode.c                          |   10 +-
 fs/exec.c                                    |   29 +-
 fs/exportfs/expfs.c                          |   40 +-
 fs/file.c                                    |  177 +-
 fs/init.c                                    |    6 +-
 fs/lockd/clnt4xdr.c                          |    9 +-
 fs/lockd/clntproc.c                          |    3 -
 fs/lockd/host.c                              |    4 +-
 fs/lockd/svc.c                               |  262 +-
 fs/lockd/svc4proc.c                          |   70 +-
 fs/lockd/svclock.c                           |   67 +-
 fs/lockd/svcproc.c                           |   62 +-
 fs/lockd/svcsubs.c                           |  123 +-
 fs/lockd/svcxdr.h                            |  142 +
 fs/lockd/xdr.c                               |  448 +--
 fs/lockd/xdr4.c                              |  472 ++--
 fs/locks.c                                   |  102 +-
 fs/namei.c                                   |   21 +-
 fs/nfs/blocklayout/blocklayout.c             |    2 +-
 fs/nfs/blocklayout/dev.c                     |    2 +-
 fs/nfs/callback.c                            |  111 +-
 fs/nfs/callback_xdr.c                        |   33 +-
 fs/nfs/dir.c                                 |    2 +-
 fs/nfs/export.c                              |   17 +
 fs/nfs/file.c                                |    3 +
 fs/nfs/filelayout/filelayout.c               |    4 +-
 fs/nfs/filelayout/filelayoutdev.c            |    2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c       |    4 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c    |    2 +-
 fs/nfs/nfs42xdr.c                            |    2 +-
 fs/nfs/nfs4state.c                           |    2 +-
 fs/nfs/nfs4xdr.c                             |    6 +-
 fs/nfs/pagelist.c                            |    3 -
 fs/nfs/super.c                               |    8 +
 fs/nfs/write.c                               |    3 -
 fs/nfs_common/Makefile                       |    2 +-
 fs/nfs_common/nfs_ssc.c                      |    2 -
 fs/nfs_common/nfsacl.c                       |  123 +
 fs/nfsd/Kconfig                              |   36 +-
 fs/nfsd/Makefile                             |    8 +-
 fs/nfsd/acl.h                                |    6 +-
 fs/nfsd/blocklayout.c                        |    1 +
 fs/nfsd/blocklayoutxdr.c                     |    1 +
 fs/nfsd/cache.h                              |    2 +-
 fs/nfsd/export.c                             |   74 +-
 fs/nfsd/export.h                             |   16 +-
 fs/nfsd/filecache.c                          | 1229 +++++----
 fs/nfsd/filecache.h                          |   23 +-
 fs/nfsd/flexfilelayout.c                     |    3 +-
 fs/nfsd/lockd.c                              |   10 +-
 fs/nfsd/netns.h                              |   63 +-
 fs/nfsd/nfs2acl.c                            |  214 +-
 fs/nfsd/nfs3acl.c                            |  140 +-
 fs/nfsd/nfs3proc.c                           |  396 ++-
 fs/nfsd/nfs3xdr.c                            | 1763 ++++++------
 fs/nfsd/nfs4acl.c                            |   45 +-
 fs/nfsd/nfs4callback.c                       |  168 +-
 fs/nfsd/nfs4idmap.c                          |    9 +-
 fs/nfsd/nfs4layouts.c                        |    4 +-
 fs/nfsd/nfs4proc.c                           | 1111 +++++---
 fs/nfsd/nfs4recover.c                        |   20 +-
 fs/nfsd/nfs4state.c                          | 1725 ++++++++----
 fs/nfsd/nfs4xdr.c                            | 3763 ++++++++++++++------------
 fs/nfsd/nfscache.c                           |  115 +-
 fs/nfsd/nfsctl.c                             |  169 +-
 fs/nfsd/nfsd.h                               |   50 +-
 fs/nfsd/nfsfh.c                              |  291 +-
 fs/nfsd/nfsfh.h                              |  179 +-
 fs/nfsd/nfsproc.c                            |  262 +-
 fs/nfsd/nfssvc.c                             |  356 ++-
 fs/nfsd/nfsxdr.c                             |  834 +++---
 fs/nfsd/state.h                              |   69 +-
 fs/nfsd/stats.c                              |  126 +-
 fs/nfsd/stats.h                              |   96 +-
 fs/nfsd/trace.c                              |    1 +
 fs/nfsd/trace.h                              |  894 +++++-
 fs/nfsd/vfs.c                                |  931 +++----
 fs/nfsd/vfs.h                                |   60 +-
 fs/nfsd/xdr.h                                |   68 +-
 fs/nfsd/xdr3.h                               |  116 +-
 fs/nfsd/xdr4.h                               |  127 +-
 fs/nfsd/xdr4cb.h                             |    6 +
 fs/notify/dnotify/dnotify.c                  |   17 +-
 fs/notify/fanotify/fanotify.c                |  487 +++-
 fs/notify/fanotify/fanotify.h                |  252 +-
 fs/notify/fanotify/fanotify_user.c           |  882 ++++--
 fs/notify/fdinfo.c                           |   19 +-
 fs/notify/fsnotify.c                         |  183 +-
 fs/notify/fsnotify.h                         |   19 +-
 fs/notify/group.c                            |   38 +-
 fs/notify/inotify/inotify.h                  |   11 +-
 fs/notify/inotify/inotify_fsnotify.c         |   12 +-
 fs/notify/inotify/inotify_user.c             |   87 +-
 fs/notify/mark.c                             |  172 +-
 fs/notify/notification.c                     |   78 +-
 fs/open.c                                    |   49 +-
 fs/overlayfs/overlayfs.h                     |    9 +-
 fs/proc/fd.c                                 |   48 +-
 fs/udf/file.c                                |    2 +-
 fs/verity/enable.c                           |    2 +-
 include/linux/dnotify.h                      |    2 +-
 include/linux/errno.h                        |    1 +
 include/linux/exportfs.h                     |   15 +
 include/linux/fanotify.h                     |   74 +-
 include/linux/fdtable.h                      |   37 +-
 include/linux/fs.h                           |   54 +-
 include/linux/fsnotify.h                     |   77 +-
 include/linux/fsnotify_backend.h             |  372 ++-
 include/linux/iversion.h                     |   13 +
 include/linux/kallsyms.h                     |   17 +-
 include/linux/kthread.h                      |    1 +
 include/linux/lockd/bind.h                   |    3 +-
 include/linux/lockd/lockd.h                  |   17 +-
 include/linux/lockd/xdr.h                    |   35 +-
 include/linux/lockd/xdr4.h                   |   33 +-
 include/linux/module.h                       |   24 +-
 include/linux/nfs.h                          |    8 -
 include/linux/nfs4.h                         |   21 +-
 include/linux/nfs_ssc.h                      |   14 +
 include/linux/nfsacl.h                       |    6 +
 include/linux/pid.h                          |    1 +
 include/linux/sched/user.h                   |    3 -
 include/linux/sunrpc/msg_prot.h              |    3 -
 include/linux/sunrpc/svc.h                   |  151 +-
 include/linux/sunrpc/svc_rdma.h              |    4 +-
 include/linux/sunrpc/svc_xprt.h              |   16 +-
 include/linux/sunrpc/svcauth.h               |    4 +-
 include/linux/sunrpc/svcsock.h               |    7 +-
 include/linux/sunrpc/xdr.h                   |  153 +-
 include/linux/syscalls.h                     |   12 -
 include/linux/sysctl.h                       |    2 +
 include/linux/user_namespace.h               |    4 +
 include/trace/events/sunrpc.h                |   26 +-
 include/uapi/linux/fanotify.h                |   42 +
 include/uapi/linux/nfs3.h                    |    6 +
 include/uapi/linux/nfsd/nfsfh.h              |  105 -
 kernel/audit_fsnotify.c                      |    8 +-
 kernel/audit_tree.c                          |    2 +-
 kernel/audit_watch.c                         |    5 +-
 kernel/bpf/inode.c                           |    2 +-
 kernel/bpf/syscall.c                         |   20 +-
 kernel/bpf/task_iter.c                       |    2 +-
 kernel/fork.c                                |   12 +-
 kernel/kallsyms.c                            |    8 +-
 kernel/kcmp.c                                |   29 +-
 kernel/kthread.c                             |   23 +-
 kernel/livepatch/core.c                      |    7 +-
 kernel/module.c                              |   26 +-
 kernel/pid.c                                 |   15 +-
 kernel/sys.c                                 |    2 +-
 kernel/sysctl.c                              |   54 +-
 kernel/trace/trace_kprobe.c                  |    4 +-
 kernel/ucount.c                              |    4 +
 mm/madvise.c                                 |    2 +-
 mm/memcontrol.c                              |    2 +-
 mm/mincore.c                                 |    2 +-
 net/bluetooth/bnep/core.c                    |    2 +-
 net/bluetooth/cmtp/core.c                    |    2 +-
 net/bluetooth/hidp/core.c                    |    2 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.c            |    2 +-
 net/sunrpc/auth_gss/svcauth_gss.c            |   47 +-
 net/sunrpc/sched.c                           |    1 +
 net/sunrpc/svc.c                             |  314 ++-
 net/sunrpc/svc_xprt.c                        |  104 +-
 net/sunrpc/svcauth.c                         |    8 +-
 net/sunrpc/svcauth_unix.c                    |   18 +-
 net/sunrpc/svcsock.c                         |   32 +-
 net/sunrpc/xdr.c                             |  112 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c   |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c        |   32 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c     |    2 +-
 net/unix/af_unix.c                           |    2 +-
 tools/objtool/check.c                        |    3 +-
 184 files changed, 13912 insertions(+), 8825 deletions(-)


