Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213575;
	b=xS10xxonavNGt4hpCUPzk0wx2nPgqnJ7hgU/hNk5Q6DOH97QWZ2jLaTAyvIbeMTg8Pmo
	 9rMMeEEGpD0fs8Hs/7RPKwyEf+/lvj5NiVF//XiFCRGORjtl2EEnxpDI3v9JVHPwg1VPp
	 5durc1brStba1G3cJ9NnDHm6ESqbQMk1Ff31J79tLicWeHQwELN6PgM/ePJgyS9Fa63oS
	 dJf+zcP+4W1KS4TDRNWj1PmYVAXqsSIQ/XWt3mRXW4lg/9eYZF7ZL66QnZq3dgggxwwKc
	 g6eh0VDj6hQEyKBWoqVzyl1d4nP+atDs41p/X0kLpTKnt9E0n5IqNVWiOtjU5jfdmZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ek4wFVye/DfV5xYQFuaGodnOq4bfMH23UllFaPS5CGU=;
	b=c54JoFRnVSCnHHzT1cssfEz3IxxpJWV+cQonx4HT53BRDpC2AeuoJ7d3h2jbJEc/T1ue
	 dC3l7xqwofueyg7e4EzHiPcP2w1CfcXp/pcpOq4WEqvcuAzD9t4Yt19bWYZyJzuyiM1+3
	 XVYBVIqIlifPuB5fiZp3KOussqBvsyDd+Osh0FTshrMlUdyFOB2LMc7lHFnXVqWQTnS3L
	 cGdFo3p/leriRvNXA9hgMhAJcz7pqVyIBVnlSmlX5wULNXa0DACZy7vUEKxQVRF9W6SxZ
	 8fiWYLKt3PQJXG8CTKaZb5xBoZ6YCEViMhTqnO0IuvCZt/TmYYdNrsndxeoW7iuOxWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S+4U0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4A606A31D;
	Wed, 28 Oct 2026 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S+4U0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AD01F01825;
	Wed, 28 Oct 2026 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213574;
	bh=ek4wFVye/DfV5xYQFuaGodnOq4bfMH23UllFaPS5CGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2S+4U0SOo+2otutKuRAeyTGESWmaN59+X3SDC1Z6usTJAEau9M2U6iyahLS7/OU9
	 gLg2p53aLifoHDIgkF4CNR4NQMtwsqZB/g7HMwWvTaTePfnzvXihjf79KELbmAMoC2
	 uBB4uRdt8F6dNtmghvhe5ERPfqXgaS4OsaawhVN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0554/1887] reiserfs: convert to simple_rename_timestamp
Date: Wed, 28 Oct 2026 17:44:10 +0100
Message-ID: <20261028170511.986116403@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 298d35ef763de3393bd1f60d35ff4203cbb4f26a ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-Id: <20230705190309.579783-12-jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 49db9b1b86a8 ("reiserfs: Avoid touching renamed directory if parent does not change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/namei.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b916859992ec8..fe840620fafae 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1327,7 +1327,6 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 	int jbegin_count;
 	umode_t old_inode_mode;
 	unsigned long savelink = 1;
-	struct timespec64 ctime;
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1578,14 +1577,11 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 
 	mark_de_hidden(old_de.de_deh + old_de.de_entry_num);
 	journal_mark_dirty(&th, old_de.de_bh);
-	ctime = current_time(old_dir);
-	old_dir->i_ctime = old_dir->i_mtime = ctime;
-	new_dir->i_ctime = new_dir->i_mtime = ctime;
 	/*
 	 * thanks to Alex Adriaanse <alex_a@caltech.edu> for patch
 	 * which adds ctime update of renamed object
 	 */
-	old_inode->i_ctime = ctime;
+	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
 
 	if (new_dentry_inode) {
 		/* adjust link number of the victim */
@@ -1594,7 +1590,6 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 		} else {
 			drop_nlink(new_dentry_inode);
 		}
-		new_dentry_inode->i_ctime = ctime;
 		savelink = new_dentry_inode->i_nlink;
 	}
 
-- 
2.53.0



