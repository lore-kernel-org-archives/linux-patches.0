Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061013;
	b=yFZ+JMWSzf3X5Wv04BY7GTisv38sa2pMnuQQJtSxPTRneKtujLjGzPL0x5pwKW1O7Kua
	 4oXOyF1sYNOmiUpMp9i5qM+Ev92I0bDknDrO5kG2YHRMJXR1Cu8Unr5EJwxqgub4cZ8rb
	 ko3veixkdP+bPrtqCwxnYdZkri/aw0XMgxT6G3NVQB12A18VvyC+PvY+EMQIb8jyrWAN5
	 UpAHYRbxxHJsu7/R40DgEayJBYEJ+LU3bFXfzE7DsDms8JVxYrDPBjCW1FYqzU8fa7Anj
	 RJhCYejlqb7NSF0ETzLNzImwagulKCOvgmZ5jwMH04lPwfT4hWpds3pLc5Ac7z59fQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hH1QOdLmh9l4bVngSL2YAx0W9V9BlO45ZQbPBLupz3M=;
	b=uZ+Mfe7SpjqcdrasO+7sxovjfcRnvQw974sUp/374tveOFml/rgIZhynu+ZdHE4lSXKJ
	 Kf9IT1nj+QbKKVTpXnWPnE1U/OL38vAJ3VgcIeEhA2WB7UCoDLO+EgHtKv1qUIDiONpIp
	 aadQtQ1jXpIc0nti8RAGthIlKMSz/a37ASxiMG+IP6NgFW3HEY/XRdLPsv005/ptb+p8N
	 F2kfB1gmdySsNKgzGpqY2ap93SSc6d9qgev3TfDHypLbv9kMBsfHI+UBq2xzRbkxxHuHN
	 aLxmojSAX5V/WNXKtSUYM/yJSO+XQVhNPxyZeKb0mfhokaWmQIIBRjsrNkppauS6Egg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUzzXkZH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB97606D80E;
	Sat,  7 Nov 2026 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUzzXkZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35171F0089F;
	Sat,  7 Nov 2026 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061013;
	bh=hH1QOdLmh9l4bVngSL2YAx0W9V9BlO45ZQbPBLupz3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUzzXkZH/mqfVNEvARGUG+RtngyeM07NTzCC1jGzkHCoxh586XRG4IHoEol4L5+gy
	 KRM44f7C6w0TVhpLxVWi2dsuRlBtsuExgMl475NfSQsa4YJUDnD8mIFQ9d3uMUIzsk
	 9+2ZZQfXaYsOS5Rm775kuSz8lfSbhwuyDMgzslNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0355/1536] smb: server: Make sure that passkey is not leaked on the heap in user_config.c
Date: Sat,  7 Nov 2026 08:39:31 -0500
Message-ID: <20261107135007.637361531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 2c5a176882695f73b52482df03b0017b006ef2d1 ]

Use kfree_sensitive() to free the user->passkey (and the struct
ksmbd_login_response in ksmbd_login_user() that contains the same
information) to avoid that this information could leak somewhere
else via the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_config.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index 0e5fcd6f95c15..909f219c79faa 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -28,7 +28,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 	user = ksmbd_alloc_user(resp, resp_ext);
 	kvfree(resp_ext);
 out:
-	kvfree(resp);
+	kvfree_sensitive(resp, sizeof(*resp));
 	return user;
 }
 
@@ -82,7 +82,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 
 err_free:
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 	return NULL;
 }
@@ -92,7 +92,7 @@ void ksmbd_free_user(struct ksmbd_user *user)
 	ksmbd_ipc_logout_request(user->name, user->flags);
 	kfree(user->sgid);
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 }
 
-- 
2.53.0



