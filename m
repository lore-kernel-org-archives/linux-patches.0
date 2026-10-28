Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214207;
	b=Rmw+UTbccUCLj+WglK8ZFbEe6ct4VixVk5J2z0gKSjc08w7e38WEtrizP15SCaUIP8tC
	 SdkDUBcLSOt30XXJM6EL8465JzNDDoKCNfkHNWdc7UnvQLE/IyQf6HZk4zJfAXWqyF3PH
	 NYlKWtSfEcn4wkJfwZww05HkzfmsbM1RKXlAXevqG2ZOh0KCcK2Q/ZJ4bSKQm2VIgb8Ou
	 9D4bRytiwsPBw0JMqKx/Gp1ZQXrnFW3QWl2YwjS24QGcWaB1isWvcRyqyYlPhZ3vXz6i+
	 SfwVKTlZkwIwwk7AKSLrvpTEz8mlYZ3HwvnhOE2UAdxPp+FZ4yAYwFiwCiY4pmcacrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h3G+NpH65TL575Mmzl2V1G6T1Bg1ZUBNhPaWv153Lhk=;
	b=g1jiQ8qdVVf8z6qZm22+z8rUqyi/VKbYHGrguCH97bhWEaG5yPFX5bldY4dcjXZlJpqj
	 TDweu46ZkY3nActfLjBy5L2uCZApEDMc7ypOLQb7/fifOTHquf1VVdJ4bJhj0wgSuTJ/G
	 ZZfpGVwRvR+nei94abTNPhWu3M+H6W3GOytJg7diUmusgvt9ViDh2LcCtI5LQTuDI16Ua
	 D/TZHRdcJt/o7daZvYDH6K6JLp26azxDysliG12EBQg9XHoTKq03en7O9VfAMqUrI9SyM
	 kD7C+oFI1Tm56fmRxiA15qoy74z8U/cVvR+rCa9dmNRxYiGvBUSbgCXXWamkc3xSXqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4KQVf7Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08212606BFAC;
	Wed, 28 Oct 2026 19:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4KQVf7Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D9D1F013C6;
	Wed, 28 Oct 2026 19:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214206;
	bh=h3G+NpH65TL575Mmzl2V1G6T1Bg1ZUBNhPaWv153Lhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4KQVf7YqSk75tPL1uJwLlgpaYJ3Xtrym9cKFDc+uJ0O7fOgIXaGCU29y2pX1p90N
	 5ovHQy+5xqeKKlxNcGucA2qLyUnOhuOVXRTanDF3g2GF6rgEmfZX81UUYabPpVPG8v
	 xworMJ4Hi8BB7LrWF1RNMSyl+CtgF7nrN5+kzKIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0778/1887] ksmbd: Fix UAF in __close_file_table_ids
Date: Wed, 28 Oct 2026 17:47:54 +0100
Message-ID: <20261028170517.142623121@linuxfoundation.org>
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

From: Sean Heelan <seanheelan@gmail.com>

[ Upstream commit 36991c1ccde2d5a521577c448ffe07fcccfe104d ]

A use-after-free is possible if one thread destroys the file
via __ksmbd_close_fd while another thread holds a reference to
it. The existing checks on fp->refcount are not sufficient to
prevent this.

The fix takes ft->lock around the section which removes the
file from the file table. This prevents two threads acquiring the
same file pointer via __close_file_table_ids, as well as the other
functions which retrieve a file from the IDR and which already use
this same lock.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 9eb9f892ac2b5..4b35e4f960694 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -648,21 +648,46 @@ __close_file_table_ids(struct ksmbd_file_table *ft,
 		       bool (*skip)(struct ksmbd_tree_connect *tcon,
 				    struct ksmbd_file *fp))
 {
-	unsigned int			id;
-	struct ksmbd_file		*fp;
-	int				num = 0;
+	struct ksmbd_file *fp;
+	unsigned int id = 0;
+	int num = 0;
+
+	while (1) {
+		write_lock(&ft->lock);
+		fp = idr_get_next(ft->idr, &id);
+		if (!fp) {
+			write_unlock(&ft->lock);
+			break;
+		}
 
-	idr_for_each_entry(ft->idr, fp, id) {
-		if (skip(tcon, fp))
+		if (skip(tcon, fp)) {
+			id++;
+			write_unlock(&ft->lock);
 			continue;
+		}
 
 		set_close_state_blocked_works(fp);
 
-		if (!atomic_dec_and_test(&fp->refcount))
+		if (!atomic_dec_and_test(&fp->refcount)) {
+			id++;
+			write_unlock(&ft->lock);
 			continue;
+		}
+
+		idr_remove(ft->idr, fp->volatile_id);
+		fp->volatile_id = KSMBD_NO_FID;
+		write_unlock(&ft->lock);
+
+		write_lock(&fp->f_ci->m_lock);
+		list_del_init(&fp->node);
+		write_unlock(&fp->f_ci->m_lock);
+
 		__ksmbd_close_fd(ft, fp);
+
 		num++;
+		id++;
 	}
+
 	return num;
 }
 
-- 
2.53.0



