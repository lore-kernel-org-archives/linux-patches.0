Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059508;
	b=SjfoWes0fPwt+rx/Gr1Wj7IRFT8F0AwcLohnXgtsI0l2/mSqCzP5k7JiIlXEHN9u5NyQ
	 BC6mxIzvSU0wKsY90dJp9pjbA17hxwn1YFjErzAzl61VV7vr/QcMYF7zenoUGSK5OMqp9
	 YRcEEN2q6/oZwGbd1+NAHsPjdG8LD5S78aUn29XnUvcDnqZGSz/bP4wQYdK4D2QYuHsg/
	 X4V85q9FKUUQayUgtsDbIk8mRUR0IEKVgRzCw06hHHt8WMNJ4vLiuwoseWUO484kwkYQy
	 73ctua0qmcrMyMLxp2Mz+fvvVZNIVRXxqJoGT7U7X8VgRX9xhHAlXoPEbuxWweAre9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1FHYXq3/zHmNT5gPfyYPoJOCXLuZ3nauVuXnF7JMTZ0=;
	b=MUxyeS4N6ireDBVXuJOWWtB0f+aNxTEFPgiZ4EYRBCCjWgPLQurrFNbEh/Ssws1lMVDb
	 Gks0yDvrTfW4fUDyoCHyvhQ1B2Ba/ERYFAzBTOic4O1DPLrND1Dh13PXeL1JAxOnAeTBz
	 3VavuM6ewJnnEAZ0fJa5fIMsd4rmK6JHj+rjQLR8HfiLHRIEGP9lkctLCJqK7+zLPfhAR
	 WH3mOC+0n0W9lPT/uae4H5w1O0iVUY1nTzwACqpxhnxxrfE/kmFsMwvcQfRv2HFePQW/Z
	 VEkXITmL7s/w9gGbJDLX20RMwOddmoBZE4364vm3EA/bjtf9BpkOjO08uvABEZhwbsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynJYpETR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4482606A320;
	Thu, 19 Nov 2026 03:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynJYpETR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032AF1F000C4;
	Thu, 19 Nov 2026 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059508;
	bh=1FHYXq3/zHmNT5gPfyYPoJOCXLuZ3nauVuXnF7JMTZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynJYpETR2HRBY8rgyXxFSW/yu8h4/cVn5kp031MF9Z8tFul7SdExps+b1IpgF4rc0
	 OLU9GFFYEyR4RqfCc1WOUronLJB0zj11imf8B8vWCQ2bcfpcyOROrF+197/JvewrxX
	 67K6T4RNl6Ahs+GJHOyn2D/vYxljCY9dvrpLaZ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com,
	Wang Jianjian <wangjianjian3@huawei.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0867/1848] nilfs2: ignore non-fatal signals during synchronous log write wait
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118145952.761979351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 7131aaa74bcc7c9da1f1d1c8724da75c775557a0 ]

Based on a syzbot report, Wang Jianjian pointed out that following a
successful directory operation in nilfs_rename(), a synchronous write
requested within nilfs_transaction_commit(), triggered by a sync flag
set by nilfs_commit_chunk(), could be interrupted by a user signal.
This interruption leaves in-memory metadata updates intact while
returning an error, causing inconsistency with the VFS dentry cache and
ultimately triggering a kernel warning.

According to "signal(7)", local disks are not classified as "slow
devices" (such as terminals, FIFOs, or pipes) and their I/O operations
on disk devices are not interrupted by signals.  In kernel space,
waiting for such disk I/O should therefore not be aborted by ordinary
(non-fatal) signals.

Suppress this issue by modifying nilfs_segctor_sync(), which waits for
the log writer thread to complete synchronous writes, to catch only
fatal signals via fatal_signal_pending() and return -EINTR rather than
-ERESTARTSYS.  To complement this change and prevent the wait loop from
busy-looping when schedule() returns immediately due to a pending
non-fatal signal, switch the wait state from TASK_INTERRUPTIBLE to
TASK_KILLABLE.

This serves as an effective interim stabilization measure without
structural changes until a comprehensive fix for metadata consistency
is implemented.

Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6c7e1f1809f235eeb90
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Tested-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
Cc: Wang Jianjian <wangjianjian3@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
[ sashal: preserved the older return-code comment layout instead of upstream's reformatted lists ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/ioctl.c    |  2 +-
 fs/nilfs2/recovery.c |  2 +-
 fs/nilfs2/segment.c  | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 9f10a9cec3e0a..e6db5b8190e3c 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1011,7 +1011,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
  *
  * %-ENOSPC - No space left on device (only in a panic state).
  *
- * %-ERESTARTSYS - Interrupted.
+ * %-EINTR - Interrupted.
  *
  * %-ENOMEM - Insufficient memory available.
  *
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 33c4a97519de8..bf64a9eff4d15 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -750,7 +750,7 @@ static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
  *
  * %-ENOSPC - No space left on device (only in a panic state).
  *
- * %-ERESTARTSYS - Interrupted.
+ * %-EINTR - Interrupted.
  *
  * %-ENOMEM - Insufficient memory available.
  */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 18964331ee3d9..cc12f4dd2eee2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2236,7 +2236,7 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	wake_up(&sci->sc_wait_daemon);
 
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_KILLABLE);
 
 		/*
 		 * Synchronize only while the log writer thread is alive.
@@ -2250,11 +2250,11 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 			err = wait_req.err;
 			break;
 		}
-		if (!signal_pending(current)) {
+		if (!fatal_signal_pending(current)) {
 			schedule();
 			continue;
 		}
-		err = -ERESTARTSYS;
+		err = -EINTR;
 		break;
 	}
 	finish_wait(&sci->sc_wait_request, &wait_req.wq);
@@ -2295,7 +2295,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
  *
  * %-ENOSPC - No space left on device (only in a panic state).
  *
- * %-ERESTARTSYS - Interrupted.
+ * %-EINTR - Interrupted.
  *
  * %-ENOMEM - Insufficient memory available.
  */
@@ -2332,7 +2332,7 @@ int nilfs_construct_segment(struct super_block *sb)
  *
  * %-ENOSPC - No space left on device (only in a panic state).
  *
- * %-ERESTARTSYS - Interrupted.
+ * %-EINTR - Interrupted.
  *
  * %-ENOMEM - Insufficient memory available.
  */
-- 
2.53.0



