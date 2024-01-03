Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256F1BDEC;
	Wed,  3 Jan 2024 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B53htcAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F99CC433C9;
	Wed,  3 Jan 2024 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301044;
	bh=vyI8Y1hu54plw2Z/XU4Ti2UunlnUmmtuPxdkA2arm7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B53htcAB1NcVSn8Bmj3n6nP7BONm0WnHkOM+6IyaJbo0bOlQ+97zt2DN0LNQzeRkE
	 kBU3veyw5aGnh0IuWZijJzatwMiue/z3O+Ok69HKqWa0ZA/dLFqXe7P6V6sWdHZL/f
	 A5IOuaxs/hoXS6mInsCU155xNJTU5VptM+bLw6V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/100] ksmbd: remove unused ksmbd_tree_conn_share function
Date: Wed,  3 Jan 2024 17:54:13 +0100
Message-ID: <20240103164859.660085300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 7bd9f0876fdef00f4e155be35e6b304981a53f80 ]

Remove unused ksmbd_tree_conn_share function.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.c | 11 -----------
 fs/smb/server/mgmt/tree_connect.h |  3 ---
 2 files changed, 14 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index f07a05f376513..408cddf2f094a 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -120,17 +120,6 @@ struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 	return tcon;
 }
 
-struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
-						 unsigned int id)
-{
-	struct ksmbd_tree_connect *tc;
-
-	tc = ksmbd_tree_conn_lookup(sess, id);
-	if (tc)
-		return tc->share_conf;
-	return NULL;
-}
-
 int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess)
 {
 	int ret = 0;
diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index 700df36cf3e30..562d647ad9fad 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -53,9 +53,6 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 						  unsigned int id);
 
-struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
-						 unsigned int id);
-
 int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess);
 
 #endif /* __TREE_CONNECT_MANAGEMENT_H__ */
-- 
2.43.0



