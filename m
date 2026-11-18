Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023645;
	b=MAq28fuk9a3Eht+f8l8NfO7/F12qXJXhTzMuek1QmREJnah+ECfTihUpLLUUPxMMdu/t
	 aY9BHHMPG3SZh3EyjeSArIFU9NvgnFUQsJdGYqS1kdQKfy5tOpUEAmZoN4rQcdmhv5UKS
	 526PHZvDcm5BlISiDyJN18k0pQ10Oh1NkVbJmjyVW12YaZgLIWuK7g4DNWU1hCdDFgDkf
	 Q5U55N/6b9rKs1c6ESM+b6v7EBqH6xP7LU1c3HVRXgF+aMSTzPQUcr2RazhXz2y5uB57m
	 qNXztZW1T08rIMvBcCQ7+SBd+tZf9F3M6pmX0Qt5YFSowZK0J4ZuiZyj0NlCZ3pTWXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cy/nCOAnYaeCr2YOxYBR1Z5QVXwEH+imjuQVjT98VgY=;
	b=QpehW54SsVdVIH7wCRDwZk0By7NaO3fDEA/GDDGZWfx2kr6J9ftUHpzm7FSjSvuNfpMV
	 5FOb/Q1spuUPyAC4sH7tkc3A0nGFo6WXmGxuklgkvVMKt/R/Tcvmb3Z9oSfUJLWtSmpIg
	 PP5+jZhgDTCpkMLAzxAAe8uLj40CmJiNH/D5jYFcxtCGTtrtCb5gWfmUfxM9bAt8F3vKK
	 J9GcQlfQvVD03cc+YE0w5PhYp5AS/nNCBbMRO7uxA+FuUEPqNvsNG4xkA3dGLdaD32zih
	 DUb7oCcdSOHxUK++Wr5p+9l/7QqUPlQyihPMVFUdAAu5FwweedjijAB20jFGyxH1/xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2hqmefS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0E606A32A;
	Wed, 18 Nov 2026 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2hqmefS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD781F000C4;
	Wed, 18 Nov 2026 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023645;
	bh=Cy/nCOAnYaeCr2YOxYBR1Z5QVXwEH+imjuQVjT98VgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2hqmefSY7uVkbIt5I7BaqFPFKXgNP0C4relBth0KelOmQkjpR765plvgQv9ee8v/
	 RLH5BjUdV1ic1OdmzAIl5mnU5pIdN5DiztGd0uLN/ETXLBfbWtLmRVNxTxArvTN6q1
	 y1ZhN7R3EhUNUrYODo2IYoz50v1GDLupvq+lhvYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0444/2151] f2fs: quota: fix stale lock holder on remount failure
Date: Wed, 18 Nov 2026 15:36:19 +0100
Message-ID: <20261118150138.210019403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jianan Huang <jnhuang95@gmail.com>

[ Upstream commit 3f140a60c92a5e2e9885adac70cd3686ba4ee19a ]

F2FS remount can fail while duplicating a journalled quota file name.

f2fs_remount()
- sbi->umount_lock_holder = current
- kstrdup(F2FS_OPTION(sbi).s_qf_names[i])
  : fails
- free previously duplicated names
- return -ENOMEM

The direct return leaves umount_lock_holder pointing at the failed
remount context.  A later checkpoint may then wrongly treat another
context as the s_umount lock holder.

Add a restore_holder cleanup path and use it before returning -ENOMEM.

Fixes: eb85c2410d6f ("f2fs: quota: fix to avoid warning in dquot_writeback_dquots()")
Signed-off-by: Jianan Huang <jnhuang95@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 93e6575706add..e0257f6eff868 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2733,7 +2733,8 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 			if (!org_mount_opt.s_qf_names[i]) {
 				for (j = 0; j < i; j++)
 					kfree(org_mount_opt.s_qf_names[j]);
-				return -ENOMEM;
+				err = -ENOMEM;
+				goto restore_holder;
 			}
 		} else {
 			org_mount_opt.s_qf_names[i] = NULL;
@@ -2991,6 +2992,7 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 	sbi->mount_opt = org_mount_opt;
 	sb->s_flags = old_sb_flags;
 
+restore_holder:
 	sbi->umount_lock_holder = NULL;
 	return err;
 }
-- 
2.53.0



