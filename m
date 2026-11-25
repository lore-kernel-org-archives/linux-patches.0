Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620779;
	b=d3xkQGeD8fS2vwRYj05BUMjsyi9pS2+vR7I9fB33p8e1w205LjOVQRG4LP5zoOPMNSCu
	 ziGnXiczUVSVDKquzikuLoaPZy5URGdS8vPxIk78LtEtp8/4gURaR/sJwwh9SzuVBAvtZ
	 BhJO9qzJMDSHgpXihmcNGiROZOpK48sftH07FAeqCJ/j0NZrARovfaXxglH1Fo3zkBLU/
	 MdgHTFYYaqp3grc47n6ZRUtDFcUotzM9q4uR+RWZEBeLhVImNTSQ7VyQBw7tUVxoA/n/1
	 d9dPiYvyZZoVJTUDQoSeeVB4QxnJb2BNCOOaifm6I0FmQP8tznPTAnzr/CLlbpSknpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VynmYEDT334Fkc3azGxIjp6h5jRyOsDzUuYkJFpyUu0=;
	b=0q82Ted6YfdsXLQFHz7IUzHwklnV1wTkMtvtMwg7PLmN/1AjSQ49ZSb/HjjVxo7YOeuB
	 3BDqzlNggh/0Psp/4okoFdhaK6qpbSgcJ+Q/0DBSSBHrTiKXv8JdJV3JNpLzqZfzdJj+C
	 lGq9Q9uwKo86JXwlL/AYFs9u40R31f5rj6OBSGWCPWkoAc1s925TbysKwYiboTtaja4SG
	 Bpy2nQUmbl8AZl24Lr7OYYBbhFpOB5+Fyf6Deq3OJB1xygQHYQn20aVlPMr3GaUU468iC
	 Q1pP4EI6o/vo/YCX0nEAeIuYJyABQDQjZqzLTMC2tPAauz7Qjbeg6F1WQBUl5Kd24xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPYuXhmK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16074606A31E;
	Wed, 25 Nov 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPYuXhmK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432CA1F000C0;
	Wed, 25 Nov 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620778;
	bh=VynmYEDT334Fkc3azGxIjp6h5jRyOsDzUuYkJFpyUu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPYuXhmKf7UnxgWzJEnvfGP6Fp7jwNZXnR3vX+uBC7APmuViSPxD2pVu10vIEnz7f
	 DY1bLhOG3p0iKk0oFoQztL0xd8koa+BILMMRkT5/GTS2pyfgDZPzVn21WuW7/KQojY
	 1funHhD2F/9PZBsYJS1lFV+tZCL9D6rS44z6yVEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	=?UTF-8?q?Jordan=20DESNO=C3=8BS?= <jordan.desnoes@francetv.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/990] libceph: generalize ceph_x_encrypt_offset() and ceph_x_encrypt_buflen()
Date: Wed, 25 Nov 2026 15:22:59 +0100
Message-ID: <20261125143822.374645078@linuxfoundation.org>
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

commit 0ee8bccf7396d50726c9c8dd3135fb64a9fe8426 upstream.

- introduce the notion of a data offset for ceph_x_encrypt_offset()
  to allow for e.g. confounder to be prepended before the encryption
  header in the future.  For CEPH_CRYPTO_AES, the data offset is 0
  (i.e. nothing is prepended).

- adjust ceph_x_encrypt_buflen() accordingly and make it account for
  PKCS#7 padding that is used by CEPH_CRYPTO_AES precisely instead of
  just always adding 16.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ Jordan: resolve conflict with 821365487aa5 in __ceph_x_decrypt() ]
Signed-off-by: Jordan DESNOËS <jordan.desnoes@francetv.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/auth_x.c | 44 +++++++++++++++++++++++++++++---------------
 net/ceph/crypto.c | 25 +++++++++++++++++++++++++
 net/ceph/crypto.h |  2 ++
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index f805a813308fd..d1c7b78808279 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -44,23 +44,35 @@ static int ceph_x_should_authenticate(struct ceph_auth_client *ac)
 	return !!need;
 }
 
-static int ceph_x_encrypt_offset(void)
+static int __ceph_x_encrypt_offset(const struct ceph_crypto_key *key)
 {
-	return sizeof(u32) + sizeof(struct ceph_x_encrypt_header);
+	return ceph_crypt_data_offset(key) +
+	       sizeof(struct ceph_x_encrypt_header);
 }
 
-static int ceph_x_encrypt_buflen(int ilen)
+static int ceph_x_encrypt_offset(const struct ceph_crypto_key *key)
 {
-	return ceph_x_encrypt_offset() + ilen + 16;
+	return sizeof(u32) + __ceph_x_encrypt_offset(key);
+}
+
+/*
+ * AES: ciphertext_len | hdr | data... | padding
+ */
+static int ceph_x_encrypt_buflen(const struct ceph_crypto_key *key,
+				 int data_len)
+{
+	int encrypt_len = sizeof(struct ceph_x_encrypt_header) + data_len;
+	return sizeof(u32) + ceph_crypt_buflen(key, encrypt_len);
 }
 
 static int ceph_x_encrypt(struct ceph_crypto_key *secret, void *buf,
 			  int buf_len, int plaintext_len)
 {
-	struct ceph_x_encrypt_header *hdr = buf + sizeof(u32);
+	struct ceph_x_encrypt_header *hdr;
 	int ciphertext_len;
 	int ret;
 
+	hdr = buf + sizeof(u32) + ceph_crypt_data_offset(secret);
 	hdr->struct_v = 1;
 	hdr->magic = cpu_to_le64(CEPHX_ENC_MAGIC);
 
@@ -77,7 +89,7 @@ static int ceph_x_encrypt(struct ceph_crypto_key *secret, void *buf,
 static int __ceph_x_decrypt(struct ceph_crypto_key *secret, void *p,
 			    int ciphertext_len)
 {
-	struct ceph_x_encrypt_header *hdr = p;
+	struct ceph_x_encrypt_header *hdr;
 	int plaintext_len;
 	int ret;
 
@@ -91,6 +103,7 @@ static int __ceph_x_decrypt(struct ceph_crypto_key *secret, void *p,
 		return -EINVAL;
 	}
 
+	hdr = p + ceph_crypt_data_offset(secret);
 	if (le64_to_cpu(hdr->magic) != CEPHX_ENC_MAGIC) {
 		pr_err("%s bad magic\n", __func__);
 		return -EINVAL;
@@ -198,7 +211,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	}
 
 	/* blob for me */
-	dp = *p + ceph_x_encrypt_offset();
+	dp = *p + ceph_x_encrypt_offset(secret);
 	ret = ceph_x_decrypt(secret, p, end);
 	if (ret < 0)
 		goto out;
@@ -225,7 +238,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	ceph_decode_8_safe(p, end, is_enc, bad);
 	if (is_enc) {
 		/* encrypted */
-		tp = *p + ceph_x_encrypt_offset();
+		tp = *p + ceph_x_encrypt_offset(&th->session_key);
 		ret = ceph_x_decrypt(&th->session_key, p, end);
 		if (ret < 0)
 			goto out;
@@ -317,7 +330,7 @@ static int encrypt_authorizer(struct ceph_x_authorizer *au,
 	p = (void *)(msg_a + 1) + le32_to_cpu(msg_a->ticket_blob.blob_len);
 	end = au->buf->vec.iov_base + au->buf->vec.iov_len;
 
-	msg_b = p + ceph_x_encrypt_offset();
+	msg_b = p + ceph_x_encrypt_offset(&au->session_key);
 	msg_b->struct_v = 2;
 	msg_b->nonce = cpu_to_le64(au->nonce);
 	if (server_challenge) {
@@ -373,7 +386,7 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 		goto out_au;
 
 	maxlen = sizeof(*msg_a) + ticket_blob_len +
-		ceph_x_encrypt_buflen(sizeof(*msg_b));
+		ceph_x_encrypt_buflen(&au->session_key, sizeof(*msg_b));
 	dout("  need len %d\n", maxlen);
 	if (au->buf && au->buf->alloc_len < maxlen) {
 		ceph_buffer_put(au->buf);
@@ -512,7 +525,7 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 		struct ceph_x_authenticate *auth = (void *)(head + 1);
 		void *enc_buf = xi->auth_authorizer.enc_buf;
 		struct ceph_x_challenge_blob *blob = enc_buf +
-							ceph_x_encrypt_offset();
+					     ceph_x_encrypt_offset(&xi->secret);
 		u64 *u;
 
 		p = auth + 1;
@@ -639,7 +652,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac, u64 global_id,
 	ceph_decode_need(p, end, len, e_inval);
 	dout("%s connection secret blob len %d\n", __func__, len);
 	if (len > 0) {
-		dp = *p + ceph_x_encrypt_offset();
+		dp = *p + ceph_x_encrypt_offset(&th->session_key);
 		ret = ceph_x_decrypt(&th->session_key, p, *p + len);
 		if (ret < 0)
 			return ret;
@@ -816,7 +829,7 @@ static int decrypt_authorizer_challenge(struct ceph_crypto_key *secret,
 		return ret;
 
 	dout("%s decrypted %d bytes\n", __func__, ret);
-	dp = challenge + sizeof(struct ceph_x_encrypt_header);
+	dp = challenge + __ceph_x_encrypt_offset(secret);
 	dend = dp + ret;
 
 	ceph_decode_skip_8(&dp, dend, e_inval);  /* struct_v */
@@ -863,7 +876,7 @@ static int decrypt_authorizer_reply(struct ceph_crypto_key *secret,
 	u8 struct_v;
 	int ret;
 
-	dp = *p + ceph_x_encrypt_offset();
+	dp = *p + ceph_x_encrypt_offset(secret);
 	ret = ceph_x_decrypt(secret, p, end);
 	if (ret < 0)
 		return ret;
@@ -986,7 +999,8 @@ static int calc_signature(struct ceph_x_authorizer *au, struct ceph_msg *msg,
 			__le32 front_crc;
 			__le32 middle_crc;
 			__le32 data_crc;
-		} __packed *sigblock = enc_buf + ceph_x_encrypt_offset();
+		} __packed *sigblock = enc_buf +
+				       ceph_x_encrypt_offset(&au->session_key);
 
 		sigblock->len = cpu_to_le32(4*sizeof(u32));
 		sigblock->header_crc = msg->hdr.crc;
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 5601732cf4faa..2b98daffe9af7 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -285,6 +285,31 @@ int ceph_crypt(const struct ceph_crypto_key *key, bool encrypt,
 	}
 }
 
+int ceph_crypt_data_offset(const struct ceph_crypto_key *key)
+{
+	switch (key->type) {
+	case CEPH_CRYPTO_NONE:
+	case CEPH_CRYPTO_AES:
+		return 0;
+	default:
+		BUG();
+	}
+}
+
+int ceph_crypt_buflen(const struct ceph_crypto_key *key, int data_len)
+{
+	switch (key->type) {
+	case CEPH_CRYPTO_NONE:
+		return data_len;
+	case CEPH_CRYPTO_AES:
+		/* PKCS#7 padding at the end */
+		return data_len + AES_BLOCK_SIZE -
+		       (data_len & (AES_BLOCK_SIZE - 1));
+	default:
+		BUG();
+	}
+}
+
 static int ceph_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct ceph_crypto_key *ckey;
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index a20bad6d1e964..736ec6d2fbcb2 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -28,6 +28,8 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key);
 /* crypto.c */
 int ceph_crypt(const struct ceph_crypto_key *key, bool encrypt,
 	       void *buf, int buf_len, int in_len, int *pout_len);
+int ceph_crypt_data_offset(const struct ceph_crypto_key *key);
+int ceph_crypt_buflen(const struct ceph_crypto_key *key, int data_len);
 int ceph_crypto_init(void);
 void ceph_crypto_shutdown(void);
 
-- 
2.53.0



