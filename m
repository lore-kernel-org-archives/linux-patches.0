Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353544643B;
	Wed, 20 Dec 2023 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDnkj9pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0204C433C7;
	Wed, 20 Dec 2023 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088912;
	bh=qTevE+YknbP8scf0odu8k9gETsbzmAXflc/uA95OXT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDnkj9pSfNYRMGJRA5Rg1SYIfVN4OTt0hgXRCyGv2dmp2hM9peof/I/eyPwSRjTWL
	 ArkA2RNnjj5nch1KU2AdhCxp+xKHoScc8nCEYsNvyLpJT0qILjo0P95RSTF9oKN1NR
	 9/bUION/fCfIlcLOXVHx46mCNYhmxB30+Pb2q73Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 104/159] ksmbd: remove unused ksmbd_tree_conn_share function
Date: Wed, 20 Dec 2023 17:09:29 +0100
Message-ID: <20231220160936.216644485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 7bd9f0876fdef00f4e155be35e6b304981a53f80 ]

Remove unused ksmbd_tree_conn_share function.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/tree_connect.c |   11 -----------
 fs/ksmbd/mgmt/tree_connect.h |    3 ---
 2 files changed, 14 deletions(-)

--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -120,17 +120,6 @@ struct ksmbd_tree_connect *ksmbd_tree_co
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
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -53,9 +53,6 @@ int ksmbd_tree_conn_disconnect(struct ks
 struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 						  unsigned int id);
 
-struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
-						 unsigned int id);
-
 int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess);
 
 #endif /* __TREE_CONNECT_MANAGEMENT_H__ */


