Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE4C134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE2C433C0;
	Mon, 26 Jun 2023 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803577;
	bh=wU4FfD56033/Si1reuDGs9OQsJP5VREbxSRtpZ3wtmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kniaEooONxAJjBYUlSxXD8Mi8MG3QX+tb02xuVcfgIgIk+mDmuOFBBE52D1XMkEr5
	 xvBOhYiIyvD8NiaPwa2q7esYonNJ7Ya8LpomgCNf8+TBs0nPzgEHwUslwQeZOlyK7s
	 2vewZfTWxJCGRMs9eod1ArDq58p3F2BHdj5Ub8qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 091/199] ksmbd: remove internal.h include
Date: Mon, 26 Jun 2023 20:09:57 +0200
Message-ID: <20230626180809.593896061@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 211db0ac9e3dc6c46f2dd53395b34d76af929faf ]

Since vfs_path_lookup is exported, It should not be internal.
Move vfs_path_lookup prototype in internal.h to linux/namei.h.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/internal.h         | 2 --
 fs/ksmbd/vfs.c        | 2 --
 include/linux/namei.h | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index dc4eb91a577a8..071a7517f1a74 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -59,8 +59,6 @@ extern int finish_clean_context(struct fs_context *fc);
  */
 extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, struct path *root);
-extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
-			   const char *, unsigned int, struct path *);
 int do_rmdir(int dfd, struct filename *name);
 int do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index f6a8b26593090..1ad97df1dfb6f 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -19,8 +19,6 @@
 #include <linux/sched/xacct.h>
 #include <linux/crc32c.h>
 
-#include "../internal.h"	/* for vfs_path_lookup */
-
 #include "glob.h"
 #include "oplock.h"
 #include "connection.h"
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 0d797f3367cad..ba9b32b4d1b07 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -63,6 +63,8 @@ extern struct dentry *kern_path_create(int, const char *, struct path *, unsigne
 extern struct dentry *user_path_create(int, const char __user *, struct path *, unsigned int);
 extern void done_path_create(struct path *, struct dentry *);
 extern struct dentry *kern_path_locked(const char *, struct path *);
+int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
+		    unsigned int, struct path *);
 
 extern struct dentry *try_lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
-- 
2.39.2



