Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216245;
	b=NqYus2XpYtjxgg/VFPRQ1QwetjvtR+j8umCVGqEAAJ8GCEJvUnuO14c4YZzUTDwTIuq5
	 mgCMvJQPD05G/NuoPBdPQsxfbxDQpIzv0NZFWHbaKYKZnL0gXHw8tpcCccFzBEnZuB80i
	 sknX/85KJPFbHXN3S1NQwzkY5J/Br6JV5vN+06+4BnnKfJjOG3tjgwzFxxN0WoAXkcdX1
	 InM/kPR4gYqvNto43U5RtmcLbhqu4rVZvBNWExLqqdKS1xoc7W4+sXZsXcd8NIvPTboYA
	 5yt+AlngM7jAKOkJHlrPKzN4mkO9nsRH7e1zJUOpgiPluMeoKNRmbQzKTqyLoVPWUfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TahMk1v1O0gZXHo2AC3TWzQTO9HAbIfVNPRT1PJ6pJU=;
	b=RoZMk+ygzUsrb9Qi2RgS/HWPxVb9I8Wr55dRYuQjKJQhc2vrghLfOHQrlZMxCYxoM1kq
	 jw0SSE9SrBlOsew6zlD1sUsEN9oOILXOywOW2A+sfsJm8MF3VUf9aqOc7jXS4GRvDrZj8
	 VrC+xaD5eryfZ4t8Blor7OSF4t6UMqWviGAWTtruExdibqVYNGhueeMLSXdx0mYgV/Gfr
	 blAmdL5QehrTbP/xJUTWGJ2T/N8O1d22k5ipqAe3ujvkClD7bjzQVYNvjdcX8nZUCi1xe
	 OZpJfLvTb6c0MEI/pQ7T70ffCCPk9h6EQQ7fzXeOM17fdsotv4ecaC8tqjsdnwZpU1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XuT9qsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F37606A31D;
	Wed, 28 Oct 2026 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XuT9qsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91981F01825;
	Wed, 28 Oct 2026 19:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216245;
	bh=TahMk1v1O0gZXHo2AC3TWzQTO9HAbIfVNPRT1PJ6pJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XuT9qsglf0eX3xtaQJfY8OFYjkMP1sYEqJudQaOy6KB4bjuDrnu7vvK8QPI/7xCs
	 ydbHzv2LGogdxug1AQ0QcHYHp4dlf6ZDOScKA63tRLmYAjzj2kSUYJUcS9W+6aMdZH
	 z1Exd3HmWU9h+javQbe9OosBP4MREvAN8GVYeZ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1490/1887] f2fs: avoid NULL checkpoint thread access in sysfs
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028170533.362997880@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 5cb33b00c8fbb6e8f1fa3d281c3036d5f7c7c41f ]

checkpoint_merge can be enabled even when no checkpoint merge thread is
running. A read-only mount is one case: f2fs does not start
f2fs_issue_ckpt there, but ckpt_thread_ioprio is still writable through
sysfs.

The ckpt_thread_ioprio store path updates the saved ioprio value and,
when checkpoint_merge is enabled, calls set_task_ioprio() for the
checkpoint thread. If cprc->f2fs_issue_ckpt is NULL, that dereferences a
NULL task pointer.

Protect ckpt_thread_ioprio sysfs writes with s_umount as well, so the
checkpoint thread cannot disappear under the store path while updating
its ioprio.

Fixes: e65920661708 ("f2fs: add ckpt_thread_ioprio sysfs node")
Cc: stable@kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index f6f5da3b2a376..52457176e95ee 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -471,7 +471,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			return -EINVAL;
 
 		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
-		if (test_opt(sbi, MERGE_CHECKPOINT)) {
+		if (cprc->f2fs_issue_ckpt) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
 			if (ret)
@@ -703,13 +703,14 @@ static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
 	ssize_t ret;
 	bool gc_entry = (!strcmp(a->attr.name, "gc_urgent") ||
 					a->struct_type == GC_THREAD);
+	bool thread_entry = !strcmp(a->attr.name, "ckpt_thread_ioprio");
 
-	if (gc_entry) {
+	if (gc_entry || thread_entry) {
 		if (!down_read_trylock(&sbi->sb->s_umount))
 			return -EAGAIN;
 	}
 	ret = __sbi_store(a, sbi, buf, count);
-	if (gc_entry)
+	if (gc_entry || thread_entry)
 		up_read(&sbi->sb->s_umount);
 
 	return ret;
-- 
2.53.0



