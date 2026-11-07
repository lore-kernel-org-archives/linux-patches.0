Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065142;
	b=dKDP4RZaitL080r6FNFW/tfQznRBmiPr5hSzRkAZV9L9BVkARUz6wxT6GfFhTm36bPH7
	 6pzCMQWLhU5WY1JfrB0Ovm0+8qcINQNA15h0aZv+zQBDBrlB2FjQsOU51Cpe2rrtq96cW
	 8pIOjwmlzK5PsTZttZKqFRZCSZrj2MPiYWwAK8XG+2hbbdWReHZ2rb7i/dm9ETgyyOYQl
	 8blrkP2deYijpWcy7Yez/n5uVhAGXoLDCS2PUAYuUeoJBTd+6Wb4TntyxUZBCla1dvC7e
	 7RDOtTQN+RU72a1chpcG/1X/s+wtrM278yVonHUPwZpJgKFsytkMT5Tr+Q8LC50z95A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1yvmyQqjrveK1yWdqq3m0hLAp6Yu64ro4vqkjEKRN4=;
	b=G6Mc74x5Hyb4ClsXgg6GzYeYyCQ9wBi8eDXPwIgfaf4kL5wknftrSB0TSZBmWMiWqX7T
	 VhWNbm8AqXsLnk3qNwNgkXea6i+GMWXn1ypE1kJY0ocqgs4obR/R6LZp13gkz4r9qiMAa
	 xzfIXOrSx4AJBKUrvqRVREqkn83WSuVszE4dOaWvVbFkOauAzbNIWMmJjfWRNHyz4HQTq
	 oFyffWwoUGcQ3DR1NPN/jaHkgBbi6SIKn3NZTYB6bXS/r8bPhIZjPpk2p9KWbj7O89rmn
	 s8Vor4lySd0silHwTtFxySBdD9VrD3F/acSAPDiCttkzHRyG6Ix+Gg7UmysWwNoPYrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4lzHozg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43750606A32F;
	Sat,  7 Nov 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4lzHozg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F1D1F0089F;
	Sat,  7 Nov 2026 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065141;
	bh=V1yvmyQqjrveK1yWdqq3m0hLAp6Yu64ro4vqkjEKRN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4lzHozgrjfojXOgeDnQeCtjJ2T3NQHhsBp8CHqhFVcqZUc+u2+MLs5VzQdURpwOu
	 lg/etyuFo04gW5nCLgnmSB1wbpLIn8L+aaCmxkBFa5NzUo24Gj7nhW5RHpUAIQFbOQ
	 sx0awXtBSrTxoED2uxzZRmhaAWy54RzRoZDFcvD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0923/1257] ntfs: check the dirty-state commit on remount and unmount
Date: Sat,  7 Nov 2026 08:53:39 -0500
Message-ID: <20261107135004.846017922@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 1a3883b3685cc4c8bc41927cc9df539239d7c961 ]

The remount-to-read-only path commits the updated volume flags with
ntfs_commit_inode(), a void wrapper around __ntfs_write_inode(), and
ignores the blkdev_issue_flush() return value, so a failed commit or
flush is reported as success.  Once the remount has succeeded no
persistence point is ever reached again: ntfs_put_super() skips
read-only superblocks and the VFS never syncs one, so fail the
remount unless the commit and the flush succeed.  The superblock
then stays read-write and ntfs_put_super() retries the persistence
at unmount.  The errors=remount-ro downgrade does not go through
ntfs_reconfigure() and is unchanged.

A zero-return commit is not trusted blindly: write_mft_record()
redirties the record on allocation failure and reports success, so
the $Volume inode is required to be clean afterwards.

ntfs_put_super() discards the same commit error.  Call
__ntfs_write_inode() there with the same dirty re-check and warn on
failure, as put_super() cannot return an error.  The commit is
skipped when the dirty-state sync itself failed, as that could write
back an inconsistent flag state; a record left dirty by an earlier
update is still committed at evict time.

NVolErrors() is deliberately not used to detect the failure: it is
sticky for the lifetime of the mount, so it cannot distinguish a
fresh commit failure from errors recorded before the remount.

Hibernated volumes: ntfs_sync_volume_dirty_state() is a no-op for
them and never dirties the $Volume inode on such a mount, since the
on-disk flags are already dirty and ntfs_set_volume_flags() has
nothing to change.  The commit only runs if something dirtied the
inode independently, as before this patch; mounting hibernated
volumes read-only removes even that.

Reported-by: Baolin Liu <liubaolin@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 76 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index c3d73cd6909eb..486336508b8c7 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -269,6 +269,7 @@ static int ntfs_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 	struct ntfs_volume *vol = NTFS_SB(sb);
+	int err;
 
 	ntfs_debug("Entering with remount");
 
@@ -331,14 +332,39 @@ static int ntfs_reconfigure(struct fs_context *fc)
 		 * and ntfs_put_super() skips them, so the only remaining
 		 * write would be the evict-time commit at unmount, which
 		 * a crash never reaches.  An error recorded only after
-		 * the remount is still never persisted.
+		 * the remount is still never persisted; a failed commit
+		 * or flush fails the remount, leaving the superblock
+		 * read-write so ntfs_put_super() retries at unmount.
 		 */
-		if (ntfs_sync_volume_dirty_state(vol)) {
+		err = ntfs_sync_volume_dirty_state(vol);
+		if (err) {
 			ntfs_warning(sb,
 				"Failed to update dirty bit in volume information flags.  Run chkdsk.");
-		} else if (NInoDirty(NTFS_I(vol->vol_ino))) {
-			ntfs_commit_inode(vol->vol_ino);
-			blkdev_issue_flush(sb->s_bdev);
+			return err;
+		}
+		if (NInoDirty(NTFS_I(vol->vol_ino))) {
+			/* ntfs_commit_inode() would discard the error. */
+			err = __ntfs_write_inode(vol->vol_ino, 1);
+			if (err) {
+				ntfs_warning(sb,
+					"Failed to commit volume information flags.  Run chkdsk.");
+				return err;
+			}
+			/*
+			 * write_mft_record() redirties the record on
+			 * -ENOMEM and still reports success.
+			 */
+			if (NInoDirty(NTFS_I(vol->vol_ino))) {
+				ntfs_warning(sb,
+					"Volume information flags remain dirty after commit.  Run chkdsk.");
+				return -EIO;
+			}
+			err = blkdev_issue_flush(sb->s_bdev);
+			if (err) {
+				ntfs_warning(sb,
+					"Failed to flush volume information flags.  Run chkdsk.");
+				return err;
+			}
 		}
 	}
 
@@ -1950,26 +1976,32 @@ static void ntfs_put_super(struct super_block *sb)
 		if (ntfs_sync_volume_dirty_state(vol)) {
 			ntfs_warning(sb,
 				"Failed to sync dirty bit in volume information flags.  Run chkdsk.");
-		} else if (NVolErrors(vol)) {
+		} else {
 			/*
-			 * The dirty bit is on disk now; only warn when the
-			 * sync actually succeeded, or this message would
-			 * contradict the one above.
+			 * __ntfs_write_inode(), not the void
+			 * ntfs_commit_inode() wrapper: the error can only
+			 * be warned about here.  The mirror inode is only
+			 * released below: writing the $Volume record (mft
+			 * record number 3, below vol->mftmirr_size) mirrors
+			 * it through ntfs_sync_mft_mirror(), which fails
+			 * with -EIO once vol->mftmirr_ino is gone.
 			 */
-			ntfs_warning(sb,
-				"Volume has errors.  Leaving volume marked dirty.  Run chkdsk.");
+			if (__ntfs_write_inode(vol->vol_ino, 1)) {
+				ntfs_warning(sb,
+					"Failed to commit volume information flags.  Run chkdsk.");
+			} else if (NInoDirty(NTFS_I(vol->vol_ino))) {
+				ntfs_warning(sb,
+					"Volume information flags remain dirty after commit.  Run chkdsk.");
+			} else if (NVolErrors(vol)) {
+				/*
+				 * Only warn once the commit has succeeded,
+				 * or this could contradict a failure
+				 * reported above.
+				 */
+				ntfs_warning(sb,
+					"Volume has errors.  Leaving volume marked dirty.  Run chkdsk.");
+			}
 		}
-		/*
-		 * Commits the updated volume flags if they were written.
-		 * The mft mirror must still be around for this: the
-		 * $Volume record (mft record number 3, below
-		 * vol->mftmirr_size) is mirrored by write_mft_record()
-		 * through ntfs_sync_mft_mirror(), which fails with -EIO
-		 * and leaves the mirror stale once vol->mftmirr_ino is
-		 * gone, so the mirror inode is only released after this
-		 * commit.
-		 */
-		ntfs_commit_inode(vol->vol_ino);
 	}
 
 	/*
-- 
2.53.0



