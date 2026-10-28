Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214655;
	b=5DnOasqckfM4NkXoVDG0qQb+hD44KeiqGjpfYn/ixaY+xT82ng/3XXYPwEy5bRBUfGE7
	 73/OYblmp+SWcjIljH0UnEUYeExFNaL4BLAEImOBldassNHLsIhOXeBBnm0Kud8qOpsEb
	 nox/8x6oKbUfgLtBiG7VjDu3n1di8qDW297EFAAEY0ULTNc00uUCEiAWAhXt/1XHj9B94
	 kgxPY/JUPoL0K9HlJndWuV/8Is/DZXBpZxWRrgaeOAgtQYHxyUaYtb9JJfuJinUBOcvE9
	 Wwzj92/mVMDEpUvi/xn9rV1+4Qtj5cvhiVerKVBJ/Upj8fOs1C67/uAGlzEXGacFniA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Pf36+kstbtfoRyGtpUyHnXVSWJ/oyF1xDL45XANKvM=;
	b=rufFtuU/8BbNDYUh+R0/nkC9pU8AC2tJhcXWbIvdotIVhxSJLDCgTyjnev79BBgFXpq/
	 PTAkIuqEoKZrxEGOif6j95veuSRNfTwZ9jr3ot5hTbJZyg0+QM2DjqImtbVM+WWMgc3Xl
	 BWwTjZNfpogU+Iz8IcYUvO0CYdUf4mp/+RkvtNISr98Jlfp48KRoMMYIRiNacnaWdu7/A
	 R0p17QvLRCsWMluwqC0N7xFMbxYH4KAGEmX9hnMV/dQUAjn9ru+BvfGV+8zvdbW8okK0C
	 Wvq32kFwnfGRCKni5SGH8Y5I8xb8DxH5hULVHmlKdvOlbj7kNBkCKHXLXZYUOUIm8lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8fpQR6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB59606A31F;
	Wed, 28 Oct 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8fpQR6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B701F01825;
	Wed, 28 Oct 2026 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214654;
	bh=3Pf36+kstbtfoRyGtpUyHnXVSWJ/oyF1xDL45XANKvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8fpQR6Q6sgzu3C4HKMtm12ilnGvSjoQvva7LY4UOjHdtJ8AIsW+F8iU0W+jPyPO2
	 0QCroNSSXJ2r1WnWY31KAUdXFHSgHgYzool5yqlHAYCFNJiuBKMk2n8cVRiLmex0I0
	 Nq8bWRxmr9SOg616BHEqOeqE6upuGgaQPhzYkX8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Stepansky <igor.stepansky@orca.security>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0934/1887] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Wed, 28 Oct 2026 17:50:30 +0100
Message-ID: <20261028170520.667447497@linuxfoundation.org>
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

[ Upstream commit 4f3a06cc57976cafa8c6f716646be6c79a99e485 ]

ksmbd_chann_list xarray lacks synchronization, allowing use-after-free in
multi-channel sessions (between lookup_chann_list() and ksmbd_chann_del).

Adds rw_semaphore chann_lock to struct ksmbd_session and protects
all xa_load/xa_store/xa_erase accesses.

Cc: stable@vger.kernel.org
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c |  5 +++++
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2pdu.c           | 12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 605e17c7b2a17..33ae100fd07ed 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -32,12 +32,14 @@ static void free_channel_list(struct ksmbd_session *sess)
 	struct channel *chann;
 	unsigned long index;
 
+	down_write(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 		xa_erase(&sess->ksmbd_chann_list, index);
 		kfree(chann);
 	}
 
 	xa_destroy(&sess->ksmbd_chann_list);
+	up_write(&sess->chann_lock);
 }
 
 static void __session_rpc_close(struct ksmbd_session *sess,
@@ -220,7 +222,9 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;
 
+	down_write(&sess->chann_lock);
 	chann = xa_erase(&sess->ksmbd_chann_list, (long)conn);
+	up_write(&sess->chann_lock);
 	if (!chann)
 		return -ENOENT;
 
@@ -422,6 +426,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->rpc_lock);
+	init_rwsem(&sess->chann_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 011362e975b00..90ae30ba402f4 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -49,6 +49,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];
 
 	struct hlist_node		hlist;
+	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 16477ad9dde8d..b05a9488aaa4d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -78,7 +78,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)
 
 struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn *conn)
 {
-	return xa_load(&sess->ksmbd_chann_list, (long)conn);
+	struct channel *chann;
+
+	down_read(&sess->chann_lock);
+	chann = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+
+	return chann;
 }
 
 /**
@@ -1580,7 +1586,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}
 
@@ -1673,7 +1681,9 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}
 
-- 
2.53.0



