Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617685;
	b=tOcaDuiJawGMDY8LKuSD2L7O/5rJJ3bOeaOYERIUT4myFGlutp+lKQmBoMj4xHaUxUfJ
	 eXggClqwV9GqzVQUkQuwMo0nmhEB2VlW2sBpCB6JSAzGzOTf+LG+qBx2iO7D8LGa/9g+w
	 gjmZjMVZLmPKzDOuzvLB+/5SiLa4Eonus/1aOdh/rZM/ZVJ9J13tfqBTwNPoXb0/7J8WG
	 G/uL6JhAqwG++EE9NDkHpDGE8TkuDaIrKaZ4lJL8oAtOazA+d7nx9LELn1ya5YL3ERREj
	 sPuTHA90uF6IokleE02ed2oHpetF60/FfV1cqgoGM7OAJx+5EHn8XUgTIdmKPyCOOyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DyqgWdK64+daNw/pCcSOmfy6oTPPJZ5goyetM9S9FhE=;
	b=Ul7aNQdtaTRhBh3RibvLUbJbJCGngRILC/K1oReIs92DFONwsB7tIIPEDAyG36NfmP+o
	 1tJQz2rgVfNzV1nKn1qHxbqQ/jIX6GCFxTkJc6AuvTJXtckbLoumcw3KWpGFvfUr5biqE
	 a4CsRG3CS/pIvz1Iuof5Fkzo1cwdJqQYpSibVyLXnG+H9NJFaqEerZhcZa9YuIYsYuNZ8
	 Fj/Ze0w5jLk3eQHpSvd9OGr+b6kVwSUZZAWsTOQZetO/JeVZ4amWJmZefQwYarAmKIFAj
	 ikjAZklA58O9iSZkODg3FWWllHTzWZLdCOKQFnqo5ntpAqoBPUo9Iv48VLsi+i3rdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipexwJRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242F606A31E;
	Wed, 25 Nov 2026 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipexwJRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAED1F000D2;
	Wed, 25 Nov 2026 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617684;
	bh=DyqgWdK64+daNw/pCcSOmfy6oTPPJZ5goyetM9S9FhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipexwJRG+jRjb7XJ9RE5+c4nqLK2swBbZ5KDVSTZNcPrFfDSMdv3ym/Wj/9Y3mzXM
	 /OPuB2aIeLOOkqAYBvyMbpkfzq/8MYba3TXzgdl7TwDTpOYmnJo+RpnomgjQnRI7pn
	 rSxOqoNyZu90B2mxr0sQO5K5ZTWKGeqbG7EI0D3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0042/1005] fsnotify: preserve 64-bit pre-content ranges
Date: Wed, 25 Nov 2026 15:23:00 +0100
Message-ID: <20261125143822.725246602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 1dcf2be94b9be2d366a0d2b70c2b1c7ebccf1443 ]

vfs_fallocate() and remap_verify_area() pass 64-bit lengths to
fsnotify_file_area_perm(), which truncates them to size_t on
32-bit systems.

Use 64 bit (unsigned) types throughout the entire pre-content
notification chain to keep the full range. The userspace range
field is already 64-bits.

Fixes: 9740d17162de ("fsnotify: pass optional file access range in pre-content event")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261015175701.3674449-1-thnkslprpt@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.h    | 2 +-
 fs/notify/fsnotify.c             | 2 +-
 include/linux/fsnotify.h         | 4 ++--
 include/linux/fsnotify_backend.h | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 87ba788574bff..c25cf5c1fc70f 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -444,7 +444,7 @@ struct fanotify_perm_event {
 	struct fanotify_event fae;
 	struct path path;
 	loff_t pos;			/* FANOTIFY_NO_RANGE if unavailable */
-	size_t count;
+	u64 count;
 	u32 response;			/* userspace answer to the event */
 	unsigned short state;		/* state of the event */
 	unsigned short watchdog_cnt;	/* already scanned by watchdog? */
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 7e2f330fd2837..8657bb94dfa8b 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -157,7 +157,7 @@ static inline __u32 fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 
 /* Report pre-content event with optional range info */
 int fsnotify_pre_content(const struct path *path, const loff_t *ppos,
-			 size_t count)
+			 u64 count)
 {
 	struct file_range range;
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index bda798bc67bc5..a4a29b3650080 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -135,7 +135,7 @@ int fsnotify_open_perm_and_set_mode(struct file *file);
  * fsnotify_file_area_perm - permission hook before access to file range
  */
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
-					  const loff_t *ppos, size_t count)
+					  const loff_t *ppos, u64 count)
 {
 	/*
 	 * filesystem may be modified in the context of permission events
@@ -213,7 +213,7 @@ static inline int fsnotify_open_perm_and_set_mode(struct file *file)
 }
 
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
-					  const loff_t *ppos, size_t count)
+					  const loff_t *ppos, u64 count)
 {
 	return 0;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a6d5c1a89cffa..faf21564380d9 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -323,7 +323,7 @@ struct fs_error_report {
 struct file_range {
 	const struct path *path;
 	loff_t pos;
-	size_t count;
+	u64 count;
 };
 
 static inline const struct path *file_range_path(const struct file_range *range)
@@ -946,12 +946,12 @@ static inline void fsnotify_init_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->list);
 }
 int fsnotify_pre_content(const struct path *path, const loff_t *ppos,
-			 size_t count);
+			 u64 count);
 
 #else
 
 static inline int fsnotify_pre_content(const struct path *path,
-				       const loff_t *ppos, size_t count)
+				       const loff_t *ppos, u64 count)
 {
 	return 0;
 }
-- 
2.53.0



