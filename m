Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216717;
	b=j6AUkjk+txk6j18DiefV+g/bQ5X11NODudVS7QDqe9RW8jt3i30a8wThpqa454EfBxDV
	 qXzr3CF2tPxqqjJI2aZWemQY8hIRAJ7mG/sOiNyNXQPjlQt3RMU8pugLSlDY6Ot++uASJ
	 2BP6mMNWFZr0QFcfCFxEfHssrGg/FvaJOK0AKBKQc0WLyqkh4OSDU/CC47sqklSJfvL0n
	 opydndIHOV0l0gqzjrXCuydnKEKJGxYwckMKpwJiEPC08vKIy/MBXwrmWgfkhxgcO6aZd
	 WGf4BmQWSVbKvkIEwzeUkYBjlSDWHe9nM5t01Kow3X75MqdHPQJrnyoAFSxxRq81hlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBAhN0inZdRnQ6X2ZLihcPiL+JVuqPmY2+0bQlXcNHw=;
	b=ErGacgy8whDWkdXs5to2v1IQbWCubNZOJexNE6G9jq5gK/0rvLSLL0UHkABfYoMr6dOp
	 +ckY5Y77vu1aKqVUi6orFLlJjIEcfkYS18J5FZZgBguMO0Yh2OErx5kij8sLqM/qWeQGb
	 RRGTmleY7IEsBVjEkKhUrxEl6Nm76AxWGnuXsGohqGCxMbOouWGeI8y40Qx4wKopslD1c
	 yITV/D4sTlxY0JmPljzCSM11r2hU/Yu5OdSltrSr1EQPiNUZ6nBQze6RjwfWKeVocih+7
	 lOGlVPCfLSVVwzvmR/Zn+SBvprxMjkI2pWNER9V1ZpUlpIuYuZH8so5bN52nWGUd8lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApORjQhe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6159606A322;
	Wed, 28 Oct 2026 19:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApORjQhe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401D61F01828;
	Wed, 28 Oct 2026 19:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216716;
	bh=bBAhN0inZdRnQ6X2ZLihcPiL+JVuqPmY2+0bQlXcNHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApORjQhexidAzmg3ikJpH0LiocMh9qbfLkonVZQWug1c045blqquwdvswwZayNWKi
	 2/TZgQSNNvXPudUfypT7ns/937SMRFhxtoPgIxlRXv693cuMWo/8rwPwv12tLbIJ3v
	 S+ee7tQRIhy7Qfbwj7VGkrDncvZmcP5zjzdfns4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1655/1887] ksmbd: preserve VFS inherited POSIX ACL mask
Date: Wed, 28 Oct 2026 18:02:31 +0100
Message-ID: <20261028170537.121633288@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e148e567a9252643baa125cb65d7ae9c2c6cf68a ]

The VFS initializes a child's POSIX ACL from the parent's default ACL and
the requested creation mode. Do not mutate the parent ACL or overwrite the
child's VFS-computed access and default ACLs afterwards.

This preserves restrictive ACL_MASK entries and prevents SMB object creation
from widening effective permissions.

Reported-by: Charles Vosburgh <trilobyte777@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 67989d577aeda..8631e57df5994 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1953,9 +1953,6 @@ int ksmbd_vfs_inherit_posix_acl(struct user_namespace *user_ns,
 				struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
-	struct posix_acl_entry *pace;
-	struct inode *inode = d_inode(path->dentry);
-	int rc, i;
 
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL))
 		return -EOPNOTSUPP;
@@ -1963,27 +1960,7 @@ int ksmbd_vfs_inherit_posix_acl(struct user_namespace *user_ns,
 	acls = get_acl(parent_inode, ACL_TYPE_DEFAULT);
 	if (IS_ERR_OR_NULL(acls))
 		return -ENOENT;
-	pace = acls->a_entries;
-
-	for (i = 0; i < acls->a_count; i++, pace++) {
-		if (pace->e_tag == ACL_MASK) {
-			pace->e_perm = 0x07;
-			break;
-		}
-	}
-
-	rc = set_posix_acl(user_ns, inode, ACL_TYPE_ACCESS, acls);
-	if (rc < 0)
-		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
-			    rc);
-	if (S_ISDIR(inode->i_mode)) {
-		rc = set_posix_acl(user_ns, inode, ACL_TYPE_DEFAULT,
-				   acls);
-		if (rc < 0)
-			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
-				    rc);
-	}
 
 	posix_acl_release(acls);
-	return rc;
+	return 0;
 }
-- 
2.53.0



