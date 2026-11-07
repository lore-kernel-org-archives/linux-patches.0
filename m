Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065116;
	b=qLDfZDPRB3Cv7m0QIrmiLVM7rPW1X8uyICfi4VacErvnLCw+QZkUHQU+fBHECjtqEHax
	 SyxqA73JUrlDFYPVxGogrXMAJ4H3X4QYtx8T3QkUaJ9oUY5XJUpLvv2FVbOtbt40PH2Ld
	 w/8zqdXWNsG270GVcnmS+OU5oTpKyTkreVbQjfTfdulXfMQ1O3hk5rfHlx4LVj7vv8bOx
	 GoqZWrepEZ6ZTi3G32yBLA5fruoKzz8sNuWB1k/TSm6irbbUqNB8f5tPvS45S5ve3hN/Q
	 D9P0fZ5c7boiwCWwmU70pTl+LD8KLxT0lacpGZaUBvZl798M4RrKBUpqPwonVmxHc3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTjp3kODkV+KCYrLA4dw891PGpDPqqtkvbXEZ6slNnI=;
	b=dyKM7fQlTtPIG65Ib4h1CoS/c1NJ2+10My8Ogs4esU4T+Fso2Fb49tGW8C0s5QMibkvH
	 lZcKHp5oO669IlwlDECqqy+PJKU0MWuiHBVIlrWWH0cv8/xRBxWDXwfkWeili4z7Pp3iV
	 dcwp4Ce+mLvFeTnn9SMyGZ3Uq3RD7xoXQlQo2xttldv5kKgtQ+MV9RHpX2TU6UfL7byAR
	 EndPSzx5obWQQdGI1HD3D82xeGDC/PjxeTtcuV6jssUjJzHaKY7RP7iM81CXhS2Jsnzci
	 Fj+E8VHXmtY1RZf67TKwdmwJvUZsc9H8FyfND37P1JNXzNNnpHW3IICeO2z6gmRoHWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSXC+bPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E74606A326;
	Sat,  7 Nov 2026 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSXC+bPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757E41F0089F;
	Sat,  7 Nov 2026 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065115;
	bh=KTjp3kODkV+KCYrLA4dw891PGpDPqqtkvbXEZ6slNnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSXC+bPrqyp2GcMrVN1iRkXM+EjS9Bjkgo+8F0IWENANkNtz+IqM9Atb96HK8+08Z
	 RssOLLkgjSh9ec2R4THDh6wAABMRZE7cBOiAcc2WJD7zl+tysYTNUAqh3/20EYH5u3
	 gSso1d8O7gTI/zYKYslLVNaTZ+fBU8uoodXuM5nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0941/1257] ntfs: roll back the ACL xattr commit when the WSL mode update fails
Date: Sat,  7 Nov 2026 08:53:57 -0500
Message-ID: <20261107135005.343012254@linuxfoundation.org>
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

[ Upstream commit 89467388e8afc6b55ea7cd38bc1f469df7747db0 ]

ntfs_set_acl_ex() commits the ACL xattr before it rewrites the WSL
mode EA, and removes it again when the rewrite fails.  That only
undoes a set that created the xattr: when the update replaced or
removed an existing one, the old ACL is discarded along with the
failed update.  No error is recorded when the undo fails, so the
new, typically more permissive, ACL is left on disk while i_mode,
the mode EA and the cached ACL keep the old values.  After a
remount, a chmod 0640 -> 0777 that reported failure leaves the file
accessible to the relaxed ACL while stat() still reports 0640.

Save the previous xattr before committing the update, and restore it
when the mode EA rewrite fails.  A removed xattr is created again,
since XATTR_REPLACE fails with -ENODATA once the removal dropped the
entry.  Remove the new xattr only when there was no previous one, and
skip the undo when the commit changed nothing.  A failed rollback is
recorded: NVolSetErrors(), which the next persistence point persists
as VOLUME_IS_DIRTY, and a log message the errors= policy acts on.
The flag cannot be written to disk here directly: the target inode's
mrec_lock is held and the $Volume mrec_lock cannot be nested under
it.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Cc: stable@vger.kernel.org
Suggested-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index b4fcfbe2da4c9..6ac551fe8ea64 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -1027,8 +1027,9 @@ static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
 {
 	const char *name;
 	size_t size, name_len;
-	void *value;
-	int err;
+	void *value, *old_value = NULL;
+	int err, old_len = -ENODATA;
+	bool acl_committed = false;
 	int flags;
 	umode_t mode;
 
@@ -1072,7 +1073,34 @@ static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
 	}
 
 	mutex_lock(&NTFS_I(inode)->mrec_lock);
+	if (!init_acl) {
+		/* Save the old xattr for rollback. */
+		old_len = ntfs_get_ea(inode, name, name_len, NULL, 0);
+		if (old_len >= 0) {
+			/* kmalloc(0) returns the non-NULL ZERO_SIZE_PTR. */
+			old_value = kmalloc(old_len, GFP_NOFS);
+			if (!old_value) {
+				err = -ENOMEM;
+				goto out_unlock;
+			}
+			err = ntfs_get_ea(inode, name, name_len,
+					  old_value, old_len);
+			if (err != old_len) {
+				kfree(old_value);
+				old_value = NULL;
+				if (err >= 0)
+					err = -EIO;
+				goto out_unlock;
+			}
+		} else if (old_len != -ENODATA) {
+			err = old_len;
+			goto out_unlock;
+		}
+	}
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags, NULL);
+	if (!err)
+		acl_committed = true;
+out_unlock:
 	mutex_unlock(&NTFS_I(inode)->mrec_lock);
 	if (err == -ENODATA && !size)
 		err = 0; /* Removing non existed xattr. */
@@ -1084,8 +1112,38 @@ static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
 		mutex_lock(&NTFS_I(inode)->mrec_lock);
 		err = ntfs_ea_set_wsl_inode(inode, 0, &ea_size, NTFS_EA_MODE);
 		if (err) {
-			ntfs_set_ea(inode, name, name_len, NULL, 0,
-				    XATTR_REPLACE, NULL);
+			if (acl_committed) {
+				int undo_err;
+
+				if (old_len >= 0) {
+					/*
+					 * A removed or zero-length xattr must
+					 * be recreated without XATTR_REPLACE.
+					 */
+					int undo_flags = acl && old_len ?
+						XATTR_REPLACE : 0;
+
+					undo_err = ntfs_set_ea(inode, name,
+							name_len, old_value,
+							old_len, undo_flags,
+							NULL);
+				} else {
+					undo_err = ntfs_set_ea(inode, name,
+							name_len, NULL, 0,
+							XATTR_REPLACE, NULL);
+				}
+				if (undo_err) {
+					/*
+					 * Record a failed rollback so the next
+					 * persistence point marks the volume
+					 * dirty.  Run chkdsk.
+					 */
+					NVolSetErrors(NTFS_I(inode)->vol);
+					ntfs_error(inode->i_sb,
+						   "Failed to undo the ACL xattr: %d",
+						   undo_err);
+				}
+			}
 			mutex_unlock(&NTFS_I(inode)->mrec_lock);
 			inode->i_mode = old_mode;
 			goto out;
@@ -1098,6 +1156,7 @@ static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
 	}
 
 out:
+	kfree(old_value);
 	kfree(value);
 
 	return err;
-- 
2.53.0



