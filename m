Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B069678B4C;
	Wed,  7 Aug 2024 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043229; cv=none; b=eOWvhIy1GxiyLwLeG4D8UZOF+WHWzpTkA00Qxo2Dcribjt35a1+EfWcklivZtAjvnIMqehSEzlXxkMk/9gyeNvufR5tNh0PTGH90eFvVxj7fHSJ/EMVZ2t805BOR048YGwKzr1KsZP+UZ2JtWGq7zYevWexudoql+iCK6iVbu9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043229; c=relaxed/simple;
	bh=NznqCjOiF7EBXQ8n2ZCtDS4Pf1rX9fBjfelnwhwGoxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgZiE258WAjS6QL8bVcvAIjmH3hRmtFa4HU+lyT4BgXy/RWxRkTJ9rVUbG8eiASDNG37Xl5n88GupoSMzCsg1jHo1qByWCGrhv0u0nLwkcNphH7hJ/HZBO0K/12/D3Utb5rfQhvZCJLJmZRGZNLmXdbhlg5MIygtGAZbvtizBo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnU937/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnU937/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D27C32781;
	Wed,  7 Aug 2024 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043229;
	bh=NznqCjOiF7EBXQ8n2ZCtDS4Pf1rX9fBjfelnwhwGoxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnU937/+r6ZgjxPUYlLi3AY2AtvKWgRJZbQ6WKWR1rhKrbP/ZumKwioV26A5oKNNV
	 HTXN0/umTdSmUuK/NI++lJfucNeldBpN6zmZO++3m/MESLp4QO3UzQn0zyj5IcsJYp
	 tnWfD7s1CGE2wfNgI+oBmkBqLs3dDRd+oZ2TYOWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/121] sysctl: treewide: drop unused argument ctl_table_root::set_ownership(table)
Date: Wed,  7 Aug 2024 16:59:07 +0200
Message-ID: <20240807150019.868023928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 520713a93d550406dae14d49cdb8778d70cecdfd ]

Remove the 'table' argument from set_ownership as it is never used. This
change is a step towards putting "struct ctl_table" into .rodata and
eventually having sysctl core only use "const struct ctl_table".

The patch was created with the following coccinelle script:

  @@
  identifier func, head, table, uid, gid;
  @@

  void func(
    struct ctl_table_header *head,
  - struct ctl_table *table,
    kuid_t *uid, kgid_t *gid)
  { ... }

No additional occurrences of 'set_ownership' were found after doing a
tree-wide search.

Reviewed-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Joel Granados <j.granados@samsung.com>
Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c  | 2 +-
 include/linux/sysctl.h | 1 -
 ipc/ipc_sysctl.c       | 3 +--
 ipc/mq_sysctl.c        | 3 +--
 net/sysctl_net.c       | 1 -
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5b5cdc747cef3..cec67e6a6678f 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -481,7 +481,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	}
 
 	if (root->set_ownership)
-		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
+		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
 	else {
 		inode->i_uid = GLOBAL_ROOT_UID;
 		inode->i_gid = GLOBAL_ROOT_GID;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 61b40ea81f4d3..698a71422a14b 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -205,7 +205,6 @@ struct ctl_table_root {
 	struct ctl_table_set default_set;
 	struct ctl_table_set *(*lookup)(struct ctl_table_root *root);
 	void (*set_ownership)(struct ctl_table_header *head,
-			      struct ctl_table *table,
 			      kuid_t *uid, kgid_t *gid);
 	int (*permissions)(struct ctl_table_header *head, struct ctl_table *table);
 };
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 01c4a50d22b2d..b2f39a86f4734 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -192,7 +192,6 @@ static int set_is_seen(struct ctl_table_set *set)
 }
 
 static void ipc_set_ownership(struct ctl_table_header *head,
-			      struct ctl_table *table,
 			      kuid_t *uid, kgid_t *gid)
 {
 	struct ipc_namespace *ns =
@@ -224,7 +223,7 @@ static int ipc_permissions(struct ctl_table_header *head, struct ctl_table *tabl
 		kuid_t ns_root_uid;
 		kgid_t ns_root_gid;
 
-		ipc_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+		ipc_set_ownership(head, &ns_root_uid, &ns_root_gid);
 
 		if (uid_eq(current_euid(), ns_root_uid))
 			mode >>= 6;
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 21fba3a6edaf7..6bb1c5397c69b 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -78,7 +78,6 @@ static int set_is_seen(struct ctl_table_set *set)
 }
 
 static void mq_set_ownership(struct ctl_table_header *head,
-			     struct ctl_table *table,
 			     kuid_t *uid, kgid_t *gid)
 {
 	struct ipc_namespace *ns =
@@ -97,7 +96,7 @@ static int mq_permissions(struct ctl_table_header *head, struct ctl_table *table
 	kuid_t ns_root_uid;
 	kgid_t ns_root_gid;
 
-	mq_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+	mq_set_ownership(head, &ns_root_uid, &ns_root_gid);
 
 	if (uid_eq(current_euid(), ns_root_uid))
 		mode >>= 6;
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 051ed5f6fc937..a0a7a79991f9f 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -54,7 +54,6 @@ static int net_ctl_permissions(struct ctl_table_header *head,
 }
 
 static void net_ctl_set_ownership(struct ctl_table_header *head,
-				  struct ctl_table *table,
 				  kuid_t *uid, kgid_t *gid)
 {
 	struct net *net = container_of(head->set, struct net, sysctls);
-- 
2.43.0



