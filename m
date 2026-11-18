Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050573;
	b=m81du0Lx7ZQZWE/W+1UYAGDAzAURGvE1TxPA7T4BSHIU4kPiYPkROCul+zj0BiKLbKRO
	 J1bU2BbrQbSAmK+RRWO8cU6mA5SZdKig/VckQ3bNmvGvjlxdIBoL/lVo+HpZ9EWqnu7pU
	 GJFWdznVxzmWu4qsiHx2yf+O8epRve12+4DeRUzyrKocUyPu/loI2HQsffhGQDmeVHFwB
	 NMTADpYnQUTNWk2W6uojZP8S4S5dKnknVxD7IrlZ6pQWbeJVcbbHE7hC1dA13O2QCn6OM
	 HrtJ+ILQNDIxgq62EDdA+JbZ3akGhLNSUdGQE+g0eqaQPeTsNj0VmckYMiuGIsOoarA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKjaQ6JOVzy+YZADf6T1hvTyzprOeMUl5qWfSc982RY=;
	b=K0IoVvN6x5suwJMb+UCuNFMRC+U/8pH+X6jg1Z/lEGc3cQVLvStstnm3qEPWFCpyFBkb
	 qIsVacqmLbH99fDxfDhNQltniLRK088c7r0BKSnrlr70IuPHL+VN0y/LlKKfZ5IAxaiiI
	 uTzofz9OHQhDgHcb8VhqNca6C4iZ6dKlfwHVQv6M5VQTXck7oljEZGsEisKXXBpD3OwUO
	 LLl1CxMmFdQVqoFKPQCUrAHK4DhyliMLYyydI3G3FfIuv7HGBYmMONrEcD03y6ME4sMI9
	 t/wtHYXzmXZ/f75EqNu893gsI7qmhns8MBRGoRBriMrVZMrLx7KkEdVVJnx75MNM2/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YN85LO/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF459606A31C;
	Thu, 19 Nov 2026 01:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YN85LO/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4141F000C4;
	Thu, 19 Nov 2026 01:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050573;
	bh=zKjaQ6JOVzy+YZADf6T1hvTyzprOeMUl5qWfSc982RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YN85LO/cnD6QZO8KeRyouprZ9ifN/GkR9/3yzNkSKTPJl+vH2uCU6gor91K00xOwg
	 pjrxuyPIyRyY5SkUnbPKz7orF7zxTE1O/77YJ64uGuHyc6aoZDsOeTg2E0Qdk/idzO
	 CXjnZABv61ZJPNKPtu09yNvvvqLGfAayfiX4Bt3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2715/2857] tls: reduce size of tls_cipher_size_desc
Date: Wed, 18 Nov 2026 16:02:29 +0100
Message-ID: <20261118150339.370311360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 037303d6760751fdb95ba62cf448ecbc1ac29c98 ]

tls_cipher_size_desc indexes ciphers by their type, but we're not
using indices 0..50 of the array. Each struct tls_cipher_size_desc is
20B, so that's a lot of unused memory. We can reindex the array
starting at the lowest used cipher_type.

Introduce the get_cipher_size_desc helper to find the right item and
avoid out-of-bounds accesses, and make tls_cipher_size_desc's size
explicit so that gcc reminds us to update TLS_CIPHER_MIN/MAX when we
add a new cipher.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/5e054e370e240247a5d37881a1cd93a67c15f4ca.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h                 | 13 ++++++++++++-
 net/tls/tls_device.c          |  4 ++--
 net/tls/tls_device_fallback.c |  8 ++++----
 net/tls/tls_main.c            |  4 ++--
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 8ac493a56f38f..9f76eb5a71727 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -58,7 +58,18 @@ struct tls_cipher_size_desc {
 	unsigned int rec_seq;
 };
 
-extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
+#define TLS_CIPHER_MIN TLS_CIPHER_AES_GCM_128
+#define TLS_CIPHER_MAX TLS_CIPHER_ARIA_GCM_256
+extern const struct tls_cipher_size_desc tls_cipher_size_desc[TLS_CIPHER_MAX + 1 - TLS_CIPHER_MIN];
+
+static inline const struct tls_cipher_size_desc *get_cipher_size_desc(u16 cipher_type)
+{
+	if (cipher_type < TLS_CIPHER_MIN || cipher_type > TLS_CIPHER_MAX)
+		return NULL;
+
+	return &tls_cipher_size_desc[cipher_type - TLS_CIPHER_MIN];
+}
+
 
 /* TLS records are maintained in 'struct tls_rec'. It stores the memory pages
  * allocated or mapped for each TLS record. After encryption, the records are
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 8dd9d3a94aba9..1f44c7a562cb5 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -924,7 +924,7 @@ tls_device_reencrypt(struct sock *sk, struct tls_context *tls_ctx)
 	default:
 		return -EINVAL;
 	}
-	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_recv.info.cipher_type];
+	cipher_sz = get_cipher_size_desc(tls_ctx->crypto_recv.info.cipher_type);
 
 	rxm = strp_msg(tls_strp_msg(sw_ctx));
 	orig_buf = kmalloc(rxm->full_len + TLS_HEADER_SIZE + cipher_sz->iv,
@@ -1120,7 +1120,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		rc = -EINVAL;
 		goto release_netdev;
 	}
-	cipher_sz = &tls_cipher_size_desc[crypto_info->cipher_type];
+	cipher_sz = get_cipher_size_desc(crypto_info->cipher_type);
 
 	/* Sanity-check the rec_seq_size for stack allocations */
 	if (cipher_sz->rec_seq > TLS_MAX_REC_SEQ_SIZE) {
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 7fbb1d0b69b34..0b704a7955fd9 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -69,7 +69,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 	default:
 		return -EINVAL;
 	}
-	cipher_sz = &tls_cipher_size_desc[prot->cipher_type];
+	cipher_sz = get_cipher_size_desc(prot->cipher_type);
 
 	buf_size = TLS_HEADER_SIZE + cipher_sz->iv;
 	len = min_t(int, *in_len, buf_size);
@@ -310,7 +310,7 @@ static void fill_sg_out(struct scatterlist sg_out[3], void *buf,
 			void *dummy_buf)
 {
 	const struct tls_cipher_size_desc *cipher_sz =
-		&tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
+		get_cipher_size_desc(tls_ctx->crypto_send.info.cipher_type);
 
 	sg_set_buf(&sg_out[0], dummy_buf, sync_size);
 	sg_set_buf(&sg_out[1], nskb->data + tcp_payload_offset, payload_len);
@@ -348,7 +348,7 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 	default:
 		goto free_req;
 	}
-	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
+	cipher_sz = get_cipher_size_desc(tls_ctx->crypto_send.info.cipher_type);
 	buf_len = cipher_sz->salt + cipher_sz->iv + TLS_AAD_SPACE_SIZE +
 		  sync_size + cipher_sz->tag;
 	buf = kmalloc(buf_len, GFP_ATOMIC);
@@ -495,7 +495,7 @@ int tls_sw_fallback_init(struct sock *sk,
 		rc = -EINVAL;
 		goto free_aead;
 	}
-	cipher_sz = &tls_cipher_size_desc[crypto_info->cipher_type];
+	cipher_sz = get_cipher_size_desc(crypto_info->cipher_type);
 
 	rc = crypto_aead_setkey(offload_ctx->aead_send, key, cipher_sz->key);
 	if (rc)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index deb3085264311..b1fbba1a6e6a5 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -58,7 +58,7 @@ enum {
 	TLS_NUM_PROTS,
 };
 
-#define CIPHER_SIZE_DESC(cipher) [cipher] = { \
+#define CIPHER_SIZE_DESC(cipher) [cipher - TLS_CIPHER_MIN] = {	\
 	.iv = cipher ## _IV_SIZE, \
 	.key = cipher ## _KEY_SIZE, \
 	.salt = cipher ## _SALT_SIZE, \
@@ -66,7 +66,7 @@ enum {
 	.rec_seq = cipher ## _REC_SEQ_SIZE, \
 }
 
-const struct tls_cipher_size_desc tls_cipher_size_desc[] = {
+const struct tls_cipher_size_desc tls_cipher_size_desc[TLS_CIPHER_MAX + 1 - TLS_CIPHER_MIN] = {
 	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_128),
 	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_256),
 	CIPHER_SIZE_DESC(TLS_CIPHER_AES_CCM_128),
-- 
2.53.0



