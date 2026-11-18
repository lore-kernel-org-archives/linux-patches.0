Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053769;
	b=Fm7WXxUyeZqrfYlI3mI/LD+0LffgCW+wX7MtdZzNq4cDvdtxxklvjfvWKTqOBVO1Mdvy
	 INNdqInWLZ0iBDK2GfxkBpC1bVEMFxbqLfl4ufg93QI4V3OM4IZftJkYjk2UzYoG/IKt6
	 o5GSHvHsCQnMiKEReJE9klPwr+7U36SsB6IIc1NP5xjUPEzbc+DYtVQ3a1ys/4pbPqkHg
	 RIllXc/7dEv3Ck5G15Fvjoxfan8baXBPu2zOYbOGJPrnTWAvqsOaxzFrHQs/kp8hnYMBW
	 lzwkgj1sSW41gxiTeGyo665Rzar47ZFe+eL09CYDSb06fNOkVYwmm2XLzsrtCsYQgLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sU4lRWPS48OIMX2JBDcqFrXs3Jy5cHZFRQGC4U1Yvyc=;
	b=ls7zzOO1c+HJ8liB4kEpUHr37scb9veV2p3I3m98YSCSVa5J/er4/nBPR1mt5o5aZoaR
	 K625yZWsqOTpCjE1crZ7Uic0Ay58zLu4AVR77VtmPT3uGaY9uOmEIiYoZTFnVdD/E7+Jd
	 GphjF90J0ndlS5oe4c/ZgekGHNHj4lO2Y4LbWzhzIFb24EUGuK9ug/pkesExYzlEoBLLw
	 bT262qhRROWaiwyvTfeAoEHhhx1chOgnGsQpn0BPfmYCK1uQ+z72goCnrK+HWpTbbgBqt
	 HrD4/LBkaLlrNOc/wut8p7G6qfW0iG/t7OTwzfUjryq3gOmJk62iu3Rs2jjXR4bpRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhLwrY3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3970606A320;
	Thu, 19 Nov 2026 02:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhLwrY3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37DA1F000C4;
	Thu, 19 Nov 2026 02:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053769;
	bh=sU4lRWPS48OIMX2JBDcqFrXs3Jy5cHZFRQGC4U1Yvyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhLwrY3VKtI7nbkop43WSIRITnhdzszakuJZf6Ph5JZDszY8b/E5OE11nPw/6mYy9
	 0oomsuCsRWLMlfBjPkQTJbTlAzzrEWcjMt3gIkbqVYDaO2eXi3mjP33fYr/r40s+eX
	 Tp86dSaVw+37BsR181/wWEDIJlioJxUxwh+oOcS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com,
	Wang Jianjian <wangjianjian3@huawei.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1037/2214] nilfs2: ignore non-fatal signals during synchronous log write wait
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118150053.849169003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/ioctl.c    |  2 +-
 fs/nilfs2/recovery.c |  2 +-
 fs/nilfs2/segment.c  | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index baa43a13b7a87..3f3909b77bcdf 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -960,10 +960,10 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
  * * %-EFAULT		- Failure during execution of requested operation.
+ * * %-EINTR		- Interrupted.
  * * %-EIO		- I/O error.
  * * %-ENOMEM		- Insufficient memory available.
  * * %-ENOSPC		- No space left on device (only in a panic state).
- * * %-ERESTARTSYS	- Interrupted.
  * * %-EROFS		- Read only filesystem.
  */
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 10c59d2c83447..0f5161df0709b 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -743,11 +743,11 @@ static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
  *
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
+ * * %-EINTR		- Interrupted.
  * * %-EINVAL		- Inconsistent filesystem state.
  * * %-EIO		- I/O error.
  * * %-ENOMEM		- Insufficient memory available.
  * * %-ENOSPC		- No space left on device (only in a panic state).
- * * %-ERESTARTSYS	- Interrupted.
  */
 int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			      struct super_block *sb,
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a1a091a20d041..3efadc2c6a031 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2234,7 +2234,7 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	wake_up(&sci->sc_wait_daemon);
 
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_KILLABLE);
 
 		/*
 		 * Synchronize only while the log writer thread is alive.
@@ -2248,11 +2248,11 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
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
@@ -2286,10 +2286,10 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
  *
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
+ * * %-EINTR		- Interrupted.
  * * %-EIO		- I/O error (including metadata corruption).
  * * %-ENOMEM		- Insufficient memory available.
  * * %-ENOSPC		- No space left on device (only in a panic state).
- * * %-ERESTARTSYS	- Interrupted.
  * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_segment(struct super_block *sb)
@@ -2318,10 +2318,10 @@ int nilfs_construct_segment(struct super_block *sb)
  *
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
+ * * %-EINTR		- Interrupted.
  * * %-EIO		- I/O error (including metadata corruption).
  * * %-ENOMEM		- Insufficient memory available.
  * * %-ENOSPC		- No space left on device (only in a panic state).
- * * %-ERESTARTSYS	- Interrupted.
  * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
-- 
2.53.0



