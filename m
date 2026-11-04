Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831651;
	b=5qghXabCKLUtvX65M+ZNXQM9UEmEH8z1WSk4DVL1ODLc+B48ZpbNVuRBPUFbvtCmO/tL
	 o947AwUFMPFL/LpLfi1Gff6voW3ALoHQ73jT8lXu/K/ayZ/d2k61ZkpJPqCs7zi6+wvMb
	 onSCKRb26zs3B91NtRn6mqacc4U0ZEWE9O2j0AP03kOehsFAHzPezo0V2ZfJmBHQbD4xY
	 3ifmLQpDZY0GY5Hg2inF3T2DTewRBa/bo4TmWJCnbzhNIvnAZlPdYGgqw3l0t6mESTX6V
	 8s91ZT4f/GIbqwfYGC42fRJaNpegkcrgEPKRpZgz5oVe+HRMGxKnt9KzJqcXIkDgd+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IFTNZIOktLf5nvICDdwrs4DdJKZU6O5xNIL3FBfV59E=;
	b=Xxk7UlMwNUrtLtxlcBYn9rEm3wFO7h+knhl63yyzdMYBFb1Wct8SS3yIsQ5rTRXKsMLu
	 onSGaTZ5h1M4W5jVN6zGicek0VFvWZ5xKNqn9xOPohjZ7K3ltUZNSg7xYOGHFE1wI6pbb
	 boz6dSN7TKniDSqQV7wbFZrphPLPT9itYiGlgXHQRAmSqu8V/LYktrPWUrPk+7NhCHvfQ
	 Kqs7TDGciohcMG5l1DJZOsdHcKuJXpYAM2JtyxPGK1/cluR6+pT3W9tDJLwNe6XIlOf1Z
	 B/uGcaZpufk/8Lussf8ppTxPn4q7pcgMlZyx2hMEhGB4u9Q0L4yZoMBW043vFBeQbQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lRL/jGIn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BE3606B2F1;
	Wed,  4 Nov 2026 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRL/jGIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B421F000C1;
	Wed,  4 Nov 2026 22:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831650;
	bh=IFTNZIOktLf5nvICDdwrs4DdJKZU6O5xNIL3FBfV59E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRL/jGInSL4AkZ/6G4SurKXwYtkcYRq82qiLSJw4I5yQQbD1XeRG5pwP49T/Y8JUZ
	 9cHJfpcMxzuJwgwESsqJPEK4utau1lueKMC+GWp/IpPZXTnmEOFAhmaJoxhnEfesEv
	 38VCy6GmmP69ehUky51rt4vAZ3lhmHoI+5aB9Ois=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0833/1005] xfs: update quota flags on secondary supers when metadir enabled
Date: Wed,  4 Nov 2026 16:09:26 -0500
Message-ID: <20261104211106.658491699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 9d9ea6e6cbc4cb1a36fb79f873d97e1ac2fe1a64 upstream.

xfs/085 exposes an interesting bug when metadir is enabled, quotas are
enabled via mount option, and the primary superblock crc fails
validation:

 Phase 1 - find and verify superblock...
 bad primary superblock - bad CRC in superblock !!!

 attempting to find secondary superblock...
 .found candidate secondary superblock...
 verified secondary superblock...
 quota accounting and enforcement flags lost

<snip>

 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
 unexpected regular file inode 16908418 with metadata flag will zap
 cleared inode 16908418
 unexpected regular file inode 16908419 with metadata flag will zap
 cleared inode 16908419
 unexpected regular file inode 16908420 with metadata flag will zap
 cleared inode 16908420
         - agno = 3
         - process newly discovered inodes...

Quota files have been created, but xfs_repair thinks that quotas aren't
enabled and trashes the quota files.  Looking at the filesystem reveals
that the quota accounting flags were indeed persisted to the primary
superblock but not the secondary:

 # xfs_db -c 'sb 0' -c 'print qflags' -c 'sb 1' -c 'print qflags' /dev/sdf
 Metadata corruption detected at 0x561c68436080, inode 0x81 dinode
 xfs_db: Failed to load metadir root directory, error 117
 Metadata corruption detected at 0x561c683f7c80, xfs_agf block 0x1/0x200
 xfs_db: cannot init perag data (117). Continuing anyway.
 Metadata CRC error detected at 0x561c6844d1b5, xfs_sb block 0x0/0x200
 qflags = 0x7cf
 qflags = 0

On a metadir filesystem, quota state is supposed to persist across
mount cycles if the sysadmin doesn't provide any quota mount options.
Therefore, any time we update the quota flags on a metadir filesystem,
we should write the same change to the secondary supers so that
xfs_repair will find the quota data if it ever has to restore from a
secondary.

Cc: stable@vger.kernel.org # v6.13
Fixes: d5d9dd5b3026a8 ("xfs: persist quota flags with metadir")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    9 ++++++++-
 fs/xfs/xfs_qm.c    |   36 +++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_quota.h |    9 +++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -448,6 +448,8 @@ int
 xfs_mount_reset_sbqflags(
 	struct xfs_mount	*mp)
 {
+	int			error;
+
 	mp->m_qflags = 0;
 
 	/* It is OK to look at sb_qflags in the mount path without m_sb_lock. */
@@ -460,7 +462,12 @@ xfs_mount_reset_sbqflags(
 	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
 		return 0;
 
-	return xfs_sync_sb(mp, false);
+	error = xfs_sync_sb(mp, false);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 static const char *const xfs_free_pool_name[] = {
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -742,6 +742,32 @@ xfs_qm_create_metadir_qinos(
 }
 
 /*
+ * For metadir filesystems, quota flag state persists across mounts, so update
+ * secondary superblocks in case xfs_repair ever has to recover the primary
+ * from a secondary.  growfs also updates backup supers so lock against that.
+ * Note that the secondary backups are opportunistic, so we log but do not
+ * return write errors.
+ */
+void
+__xfs_qm_update_secondary_sb(
+	struct xfs_mount	*mp,
+	const char		*func)
+{
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return;
+
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+
+	if (error)
+		xfs_alert(mp, "%s: Secondary super update failed, err=%d!",
+				func, error);
+}
+
+/*
  * Add QUOTABIT to sb_versionnum and initialize qflags in preparation for
  * creating quota files on a metadir filesystem.
  */
@@ -766,7 +792,12 @@ xfs_qm_prep_metadir_sb(
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	xfs_qm_update_secondary_sb(mp);
+	return 0;
 }
 
 /*
@@ -1721,6 +1752,9 @@ xfs_qm_mount_quotas(
 			ASSERT(!(XFS_IS_QUOTA_ON(mp)));
 			xfs_alert(mp, "%s: Superblock update failed!",
 				__func__);
+		} else {
+			/* Primary update succeeded, try to write secondary */
+			xfs_qm_update_secondary_sb(mp);
 		}
 	}
 
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -151,6 +151,8 @@ void xfs_dqtrx_hook_setup(struct xfs_dqt
 		xfs_trans_mod_dquot((tp), (dqp), (field), (delta))
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -216,8 +218,15 @@ static inline int xfs_quota_reserve_blkr
 #  define xfs_dqtrx_hook_disable()		((void)0)
 # endif /* CONFIG_XFS_LIVE_HOOKS */
 
+static inline void __xfs_qm_update_secondary_sb(struct xfs_mount *mp,
+		const char *func)
+{
+}
 #endif /* CONFIG_XFS_QUOTA */
 
+#define xfs_qm_update_secondary_sb(mp) \
+	__xfs_qm_update_secondary_sb((mp), __func__)
+
 static inline void
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, uint64_t blocks)
 {


