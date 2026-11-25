Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620754;
	b=adVdz6TVJnTv5YhY4WIwChE5PHuqrY5by1wDbVXJy21CnxY7kzM0AWLGsOHzEI6ohHit
	 L3c1NIxUrw4h3biU8J8D35HZWQ7NAxpDWA2Y9sGLAVi7ijKqfUMAoROYnTmKFSw4oy5qk
	 b/R+kWR2xGo1wC0yTzZgDMAsg80kE7OSP/LDZBlCsblExpy9/LgBWibJNOwg8Tt3jZlxQ
	 WxqpQpfdaUo+CSYHFbHq6ij7ZMqe1HBCAdtYH2mvdc5pCr1XMNuEE6FdmBrDQqByvKpFk
	 X7IjzRilsZshryz2A9gFhK6oI4pJoj+ATAiqSuJHObd5CQ9xrLeTy6yZ11xrx836NIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RTBnaO5wWp890CvD3O1EawOvXCRixq/ycgk6FipJd/8=;
	b=UHN9ZMdqPKIOkibdqlxiHjp1aW2jhQeOD2OZlRezkVdYx/Rzzchnsq5dNWQOn+BklwMQ
	 FhVR0pZddea5gLSCEIEoUFGC3iYrn7lTiaNjDfjPC6oFcAzVx6HGclaFt9l3sA+piyngA
	 5NokeSwzRzhlVeYjlaMR00q2/y/jxnMiS9jSbzCjb0VlVpHlxWodlGzrXzz5q8oDBOPGi
	 oa8vgSdyE+WPOoIkOeeajPSotCPx4ofBHMhn7NlzO2oygGjMJT7ihBpB2T4mb6Nij23Up
	 YnsgbI0Vk6UnvqowgP1pmkxl1RE6jGZK1lZahKRJXUJjdQN5N03ztOBKblSCZK9EbVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KO9fZ9zv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE8606A326;
	Wed, 25 Nov 2026 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KO9fZ9zv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA8F1F000CA;
	Wed, 25 Nov 2026 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620753;
	bh=RTBnaO5wWp890CvD3O1EawOvXCRixq/ycgk6FipJd/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO9fZ9zvd9MYVrKq/MBAKCNodrWzCXuQ1JD097/UMvST/7+trDDo0SwkubZzDdcCH
	 YbuuN2syjkU0HVHIOgmJi8umuh3Tiwp7d1D3uL5BH0sB8q8T+e5WnvBZpfvy0NojbI
	 ANnmHumcKfD4yPrycPfRap2sAEFcNZUGO5newQlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	=?UTF-8?q?Jordan=20DESNO=C3=8BS?= <jordan.desnoes@francetv.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/990] libceph: introduce ceph_crypto_key_prepare()
Date: Wed, 25 Nov 2026 15:23:00 +0100
Message-ID: <20261125143822.397238488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 6cec0b61aacce4da5125b21c718189f0dc11eb51 upstream.

In preparation for bringing in a new encryption scheme/key type,
decouple decoding or cloning the key from allocating required crypto
API objects and setting them up.  The rationale is that a) in some
cases a shallow clone is sufficient and b) ceph_crypto_key_prepare()
may grow additional parameters that would be inconvenient to provide
at the point the key is originally decoded.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Jordan DESNOËS <jordan.desnoes@francetv.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/auth_x.c | 26 +++++++++++++----
 net/ceph/crypto.c | 71 +++++++++++++++++++++++------------------------
 net/ceph/crypto.h |  1 +
 3 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index d1c7b78808279..a23e0e2b8011d 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -226,6 +226,10 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	if (ret)
 		goto out;
 
+	ret = ceph_crypto_key_prepare(&new_session_key);
+	if (ret)
+		goto out;
+
 	ceph_decode_need(&dp, dend, sizeof(struct ceph_timespec), bad);
 	ceph_decode_timespec64(&validity, dp);
 	dp += sizeof(struct ceph_timespec);
@@ -385,6 +389,10 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 	if (ret)
 		goto out_au;
 
+	ret = ceph_crypto_key_prepare(&au->session_key);
+	if (ret)
+		goto out_au;
+
 	maxlen = sizeof(*msg_a) + ticket_blob_len +
 		ceph_x_encrypt_buflen(&au->session_key, sizeof(*msg_b));
 	dout("  need len %d\n", maxlen);
@@ -1118,21 +1126,26 @@ int ceph_x_init(struct ceph_auth_client *ac)
 	int ret;
 
 	dout("ceph_x_init %p\n", ac);
-	ret = -ENOMEM;
 	xi = kzalloc(sizeof(*xi), GFP_NOFS);
 	if (!xi)
-		goto out;
+		return -ENOMEM;
 
 	ret = -EINVAL;
 	if (!ac->key) {
 		pr_err("no secret set (for auth_x protocol)\n");
-		goto out_nomem;
+		goto err_xi;
 	}
 
 	ret = ceph_crypto_key_clone(&xi->secret, ac->key);
 	if (ret < 0) {
 		pr_err("cannot clone key: %d\n", ret);
-		goto out_nomem;
+		goto err_xi;
+	}
+
+	ret = ceph_crypto_key_prepare(&xi->secret);
+	if (ret) {
+		pr_err("cannot prepare key: %d\n", ret);
+		goto err_secret;
 	}
 
 	xi->starting = true;
@@ -1143,8 +1156,9 @@ int ceph_x_init(struct ceph_auth_client *ac)
 	ac->ops = &ceph_x_ops;
 	return 0;
 
-out_nomem:
+err_secret:
+	ceph_crypto_key_destroy(&xi->secret);
+err_xi:
 	kfree(xi);
-out:
 	return ret;
 }
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 2b98daffe9af7..3453dc3033156 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -16,65 +16,61 @@
 #include <linux/ceph/decode.h>
 #include "crypto.h"
 
-/*
- * Set ->key and ->tfm.  The rest of the key should be filled in before
- * this function is called.
- */
-static int set_secret(struct ceph_crypto_key *key, void *buf)
+static int set_aes_tfm(struct ceph_crypto_key *key)
 {
 	unsigned int noio_flag;
 	int ret;
 
-	key->key = NULL;
-	key->tfm = NULL;
-
-	switch (key->type) {
-	case CEPH_CRYPTO_NONE:
-		return 0; /* nothing to do */
-	case CEPH_CRYPTO_AES:
-		break;
-	default:
-		return -ENOTSUPP;
-	}
-
-	key->key = kmemdup(buf, key->len, GFP_NOIO);
-	if (!key->key) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	/* crypto_alloc_sync_skcipher() allocates with GFP_KERNEL */
 	noio_flag = memalloc_noio_save();
 	key->tfm = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
 	memalloc_noio_restore(noio_flag);
 	if (IS_ERR(key->tfm)) {
 		ret = PTR_ERR(key->tfm);
 		key->tfm = NULL;
-		goto fail;
+		return ret;
 	}
 
 	ret = crypto_sync_skcipher_setkey(key->tfm, key->key, key->len);
 	if (ret)
-		goto fail;
+		return ret;
 
 	return 0;
+}
 
-fail:
-	ceph_crypto_key_destroy(key);
-	return ret;
+int ceph_crypto_key_prepare(struct ceph_crypto_key *key)
+{
+	switch (key->type) {
+	case CEPH_CRYPTO_NONE:
+		return 0; /* nothing to do */
+	case CEPH_CRYPTO_AES:
+		return set_aes_tfm(key);
+	default:
+		return -ENOTSUPP;
+	}
 }
 
+/*
+ * @dst should be zeroed before this function is called.
+ */
 int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
 			  const struct ceph_crypto_key *src)
 {
-	memcpy(dst, src, sizeof(struct ceph_crypto_key));
-	return set_secret(dst, src->key);
+	dst->type = src->type;
+	dst->created = src->created;
+	dst->len = src->len;
+
+	dst->key = kmemdup(src->key, src->len, GFP_NOIO);
+	if (!dst->key)
+		return -ENOMEM;
+
+	return 0;
 }
 
+/*
+ * @key should be zeroed before this function is called.
+ */
 int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 {
-	int ret;
-
 	ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
 	key->type = ceph_decode_16(p);
 	ceph_decode_copy(p, &key->created, sizeof(key->created));
@@ -85,10 +81,13 @@ int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 		return -EINVAL;
 	}
 
-	ret = set_secret(key, *p);
+	key->key = kmemdup(*p, key->len, GFP_NOIO);
+	if (!key->key)
+		return -ENOMEM;
+
 	memzero_explicit(*p, key->len);
 	*p += key->len;
-	return ret;
+	return 0;
 
 bad:
 	dout("failed to decode crypto key\n");
@@ -322,7 +321,7 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
 		goto err;
 
 	ret = -ENOMEM;
-	ckey = kmalloc(sizeof(*ckey), GFP_KERNEL);
+	ckey = kzalloc(sizeof(*ckey), GFP_KERNEL);
 	if (!ckey)
 		goto err;
 
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 736ec6d2fbcb2..2b8f8f68ff7a8 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -19,6 +19,7 @@ struct ceph_crypto_key {
 	struct crypto_sync_skcipher *tfm;
 };
 
+int ceph_crypto_key_prepare(struct ceph_crypto_key *key);
 int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
 			  const struct ceph_crypto_key *src);
 int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
-- 
2.53.0



