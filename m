Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBD374CC;
	Wed,  7 Aug 2024 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043588; cv=none; b=U/6e90YpFCK8ril3CNfaZTxBv0y2JBaaGfe1qsik4pebz8v5WlKU8EwguZjVW08E8xP42fnpNDfSLVi2zx1X4Oy+BLzd7XselOvINJarqO3DsRRj0K6ZNZhNO9aMkgyXyUZaqxLlkt6molcaq1XbJYkPzJowu83NrSUFqSFNs1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043588; c=relaxed/simple;
	bh=ajnQ/yXCIYCBLp+Hu6iLcP2r578qYIhNG2MlvRB0HUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVZWCo4SenIIfvggQoqcUTIF1CPwObmbV7aa2ycpCNgwinyoJ54uCOTlnxMET14djOnTIizoEq2iRE6e2YCYLvHOmVc/AmjhUlFK9+XfiCIzDusUh5k+kzXrK8ZFKmoSIcUWgtzBySiIRohdZkWrgmpEqxUDYKbM/JtHAHHr9to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNohIeZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNohIeZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B5FC32781;
	Wed,  7 Aug 2024 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043588;
	bh=ajnQ/yXCIYCBLp+Hu6iLcP2r578qYIhNG2MlvRB0HUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNohIeZQBa6dsoegP3SFsDUVJagM8BIj7+YRMsyZztFX6My4g/uUA2BoSdJPAP3g3
	 awnsxwVWapb72AfoJWAifR8das9afBQsxah4fQVVqskcMdmqW/V4cRpauoyk+3yPuf
	 iDm9jrXGBnkGnAhpbgbS3iQdYC/oMitR10a6jjZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/86] sysctl: treewide: drop unused argument ctl_table_root::set_ownership(table)
Date: Wed,  7 Aug 2024 16:59:45 +0200
Message-ID: <20240807150039.462314088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4a4c04a3b1a0a..c468cc0f6d69b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -484,7 +484,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	}
 
 	if (root->set_ownership)
-		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
+		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
 	else {
 		inode->i_uid = GLOBAL_ROOT_UID;
 		inode->i_gid = GLOBAL_ROOT_GID;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index a207c7ed41bd2..9f24feb94b24d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -185,7 +185,6 @@ struct ctl_table_root {
 	struct ctl_table_set default_set;
 	struct ctl_table_set *(*lookup)(struct ctl_table_root *root);
 	void (*set_ownership)(struct ctl_table_header *head,
-			      struct ctl_table *table,
 			      kuid_t *uid, kgid_t *gid);
 	int (*permissions)(struct ctl_table_header *head, struct ctl_table *table);
 };
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 29c1d3ae2a5c8..d7ca2bdae9e82 100644
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
index ce03930aced55..c960691fc24d9 100644
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
index 4b45ed631eb8b..2edb8040eb6c7 100644
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



