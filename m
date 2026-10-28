Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213821;
	b=XC0A6OYuRhCBf4QLA4OY4AUNmmyg5/UjiCz+6boQLHml+vMQ2YojEZKVUeSuSVp1L+oM
	 D4qQUqQoNQJr67PTpByWI+sKQNR4+6opmwPP8OT5nZQMMaxJJmrAKHiZ16IC7hnggORRp
	 WuhmS6vfTqVUlMkNuA0HWYIWRIjgBF6+/+Qe6bUQ+IGbGJVzcnygRh6P3r36BWNf8/ISC
	 2ls7cq+2qg58Oe3rpDmgHw7guYKz+qkuH0wsOpdXnKwLWzSyHrDhS25E3awgix/hI0iyK
	 Qdb4AnGKL8HQQxIr+/UxQPYGkYFiS0fVF8KZjE0Kvwp/ILwxEax+9PW1vUeHgX2epPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i56M0XgOhjA5DO81mbm8Gc4AsiJ4waoocAcK77c6RCQ=;
	b=mTr5zzDOs75vy4eb09LHaWSe3uI/vhLpFnYAs2zLTiIqBPbv12x1z0WLyFKTY52PsmTs
	 bAwM/JThi01YXUqbi+Uv4laE8LPD7XwJEcp6MrXdqGvjkbQ0jEjg/8ijIF+U4R4AjAdot
	 fAutaXEPwLOrWFfUzdkeWJ0cpAmXHgOMql2RPV7j19eRkK2AlsI7mk4A00FfmPJnQPoyk
	 fgb7WaRbIL5o+wfrUADyAoFVv40c/VmX7mQP/LyojxrmG01r1tzg6ShUwoJsvCv9hLNZs
	 FGyUlODla35k1YphiLv9yUdTR7tw/TjsVe30kBDX5amR47miJp+p2YTOTwKByEFQsyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtGzlO6i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8DC606A31D;
	Wed, 28 Oct 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtGzlO6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6A41F01825;
	Wed, 28 Oct 2026 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213821;
	bh=i56M0XgOhjA5DO81mbm8Gc4AsiJ4waoocAcK77c6RCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtGzlO6iwlKxiXWHxtNxZ5WWn91+aFE/eGBgdlrA2aq4wa1hEKLThNzkpuCAxyTxO
	 mrYmwz+1ixmuqqaAELHTFdM7eDwVhAz+3j3UsUF4SRW2hwCoAhCe3H04mxIYPMfdg0
	 /RVJk2CDBcqeBJgzBNurPOQf83aN+AQzSGCi62DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0624/1887] ext4: refactoring to use the unified helper ext4_quotas_off()
Date: Wed, 28 Oct 2026 17:45:20 +0100
Message-ID: <20261028170513.609516655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f3c1c42e0c40656e73f12ab5dcb1110f83ef8e65 ]

Rename ext4_quota_off_umount() to ext4_quotas_off(), and add type
parameter to replace open code in ext4_enable_quotas().

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230327141630.156875-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: b4b4fda34e53 ("ext4: fix uninitialized ratelimit_state->lock access in __ext4_fill_super()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f2a569868e416..76c8c364c5dd1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1167,12 +1167,12 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 #ifdef CONFIG_QUOTA
 static int ext4_quota_off(struct super_block *sb, int type);
 
-static inline void ext4_quota_off_umount(struct super_block *sb)
+static inline void ext4_quotas_off(struct super_block *sb, int type)
 {
-	int type;
+	BUG_ON(type > EXT4_MAXQUOTAS);
 
 	/* Use our quota_off function to clear inode flags etc. */
-	for (type = 0; type < EXT4_MAXQUOTAS; type++)
+	for (type--; type >= 0; type--)
 		ext4_quota_off(sb, type);
 }
 
@@ -1188,7 +1188,7 @@ static inline char *get_qf_name(struct super_block *sb,
 					 lockdep_is_held(&sb->s_umount));
 }
 #else
-static inline void ext4_quota_off_umount(struct super_block *sb)
+static inline void ext4_quotas_off(struct super_block *sb, int type)
 {
 }
 #endif
@@ -1283,7 +1283,7 @@ static void ext4_put_super(struct super_block *sb)
 		ext4_msg(sb, KERN_INFO, "unmounting filesystem.");
 
 	ext4_unregister_li_request(sb);
-	ext4_quota_off_umount(sb);
+	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 
 	flush_work(&sbi->s_error_work);
 	destroy_workqueue(sbi->rsv_conversion_wq);
@@ -5605,7 +5605,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	return 0;
 
 failed_mount10:
-	ext4_quota_off_umount(sb);
+	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 failed_mount9: __maybe_unused
 	ext4_release_orphan_info(sb);
 failed_mount8:
@@ -7091,20 +7091,8 @@ int ext4_enable_quotas(struct super_block *sb)
 					"(type=%d, err=%d, ino=%lu). "
 					"Please run e2fsck to fix.", type,
 					err, qf_inums[type]);
-				for (type--; type >= 0; type--) {
-					struct inode *inode;
-
-					inode = sb_dqopt(sb)->files[type];
-					if (inode)
-						inode = igrab(inode);
-					dquot_quota_off(sb, type);
-					if (inode) {
-						lockdep_set_quota_inode(inode,
-							I_DATA_SEM_NORMAL);
-						iput(inode);
-					}
-				}
 
+				ext4_quotas_off(sb, type);
 				return err;
 			}
 		}
-- 
2.53.0



