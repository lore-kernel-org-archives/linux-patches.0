Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064538;
	b=nU1T6sy8sN5c3g1kAWGugPqC7DRecuFuJwrGAicYaEG+qGW0i1Hp3ZqOm6CCYThnVlW7
	 6y4LsTAg2wJezoReZakGZlS1RfivtNMLvEDmAo0+i1vyDagPTsSDcXB13cm26M1PWydg/
	 qV6RVLTvLYmcXWW+AJxfG03AY1KApsb9Rn55BldzNuFZZMmIqQHg8bKbBy+FCIsYVXfEs
	 v/Ww9nzp9ruiRrBihC79OBWE/bAyJLb2adZi2sVozrliFh+nkBerotbiKENFIPFzKiG2h
	 Wvf84OMM1R7u0amAPo6KGpVgNte3D/sXm5ZEZZPAuBNnUGnCDzyDDoSHCLHuf3KRHpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eQ0161naVC1Lq8PNF37rEDC6WVq7IA3QSkFVztKbKac=;
	b=N0cdKynD1EhF8it12moAiM2NRjq5/TzAYALYiuKiFcDH9A7rYdDAZ1TkTsu5uDt41ZOM
	 3e2Ycmh81EzliOkN/LMXDWtYrT3yhuVEMoXn0Ppt5XdAFCEX/Jm2l2DUL0BnhaJcnqK8T
	 UAzFyaEq0sWo5yhzNRO6Pm99Z4tszKH4I18/faV/PyVQE8uI8/jqCmY4g096LZRKnlpvy
	 /u+SXfvAieWd+ku0ipkjLHahk2sAf4j/JapT8depnGEZ1PUzBsYRyn9tnBqbS7qslLxjm
	 GEpiN7o86OZ3pkvZa/uImLxgI+yDCTcN21qzcS8NsQbgcQNJfucgTYYbtbU8PG8clcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lyBplgw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C09606B8A6;
	Sat,  7 Nov 2026 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lyBplgw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B8A1F008A6;
	Sat,  7 Nov 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064537;
	bh=eQ0161naVC1Lq8PNF37rEDC6WVq7IA3QSkFVztKbKac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyBplgw4mOtB54FJ9FD80pPX7TQn+It8Xr7TIQZIlIty/Mv8oI+HHbRcBq6oC+u+s
	 5RVrTXjudP0pkna4bVy7PBQCHEKHCf9Hn+Z2YrLLxrtJEzf4WhK+5IZ9GzbxZm1f1B
	 jb0mhA35VInrIoVORrPj4fbacp17r056O3XT2wPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sarthak Kukreti <sarthakkukreti@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0565/1257] ext4: fix ABBA deadlock in ext4_rmdir()
Date: Sat,  7 Nov 2026 08:47:41 -0500
Message-ID: <20261107134954.969660631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 19e16597f9baf1b5719a3a6c710486446f6808fd ]

We observe the following ABBA deadlock (casefolding enabled):

 INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
 task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
 Call Trace:
  <TASK>
  __schedule+0xc2c/0xe60
  schedule+0x40/0xe0
  jbd2_journal_wait_updates+0x8f/0xf0
  jbd2_journal_commit_transaction+0x321/0x1850
  kjournald2+0xa9/0x230
  kthread+0x226/0x2a0
  ret_from_fork+0x101/0x1e0
  ret_from_fork_asm+0x1a/0x30

 INFO: task Thread-10:4161 blocked for more than 720 seconds.
 task:Thread-10       state:D stack:0     pid:4161  tgid:3848  ppid:540
 Call Trace:
  <TASK>
  __schedule+0xc2c/0xe60
  schedule+0x40/0xe0
  wait_transaction_locked+0x8c/0xd0
  start_this_handle+0x252/0x870
  jbd2__journal_start+0x120/0x280
  __ext4_journal_start_sb+0x11a/0x250
  ext4_evict_inode+0x208/0x760
  iput+0x222/0x5c0
  dput+0x293/0x690
  ____fput+0x145/0x2b0
  task_work_run+0x7a/0xb0
  exit_to_user_mode_loop+0xc0/0xd0
  do_syscall_64+0x14b/0xf10
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 NMI backtrace for cpu 0
 CPU: 0 UID: 1010216 PID: 4160 Comm: Thread-7
 RIP: 0010:d_walk+0x0/0x290
[..]
 Call Trace:
 <TASK>
  shrink_dcache_parent+0xb2/0x100
  d_invalidate+0x50/0x110
  ext4_rmdir+0x3a2/0x3d0
  vfs_rmdir+0x9d/0x1d0
  do_rmdir+0xf0/0x330
  __x64_sys_unlinkat+0x34/0x50
  do_syscall_64+0x61/0xf10

The problem is that ext4_rmdir() calls d_invalidate() before stopping
the jbd2 transaction handle.  Because d_invalidate() traverses child
dentries it can encounter dying or in-use dentries.  If a concurrent
thread executing __dentry_kill() on a child dentry invokes ext4_evict_inode(),
it requests a new transaction handle via ext4_journal_start(), which
waits for all running handles to close.  However, the thread executing
ext4_rmdir() still holds its active transaction handle while looping
in shrink_dcache_parent() waiting for the dying child dentry to complete
eviction.

Stop transaction handle in ext4_rmdir() before calling d_invalidate().

Cc: stable@kernel.org
Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260827125158.4030598-1-senozhatsky@chromium.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a6386c1d237f1..231a274b814ec 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3209,19 +3209,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	ext4_fc_track_unlink(handle, dentry);
 	retval = ext4_mark_inode_dirty(handle, dir);
 
+end_rmdir:
+	brelse(bh);
+	if (handle)
+		ext4_journal_stop(handle);
+
 	/* VFS negative dentries are incompatible with Encoding and
 	 * Case-insensitiveness. Eventually we'll want avoid
 	 * invalidating the dentries here, alongside with returning the
 	 * negative dentries at ext4_lookup(), when it is better
 	 * supported by the VFS for the CI case.
 	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
+	if (!retval && IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
 		d_invalidate(dentry);
 
-end_rmdir:
-	brelse(bh);
-	if (handle)
-		ext4_journal_stop(handle);
 	return retval;
 }
 
-- 
2.53.0



