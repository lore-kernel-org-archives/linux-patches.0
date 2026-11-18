Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050579;
	b=RkKGep1cpYnSn05JOUPU6Kks/qgbeES3uZqxL1XsQaUBygtTI5InmSIKyYli3gIIvgU8
	 XU94bL6NBX1u20kKRfG5sgpy+CYaenq4m64Afln0Ou+SClVREqEFWc7+TmSbU89FtqgV2
	 8Avu498LnMWtQuFT8r9KZdTACxkSufE6CVJxd4c+lj5XLpAyn4DKcaMJ5zH7Hg7lk4koh
	 WQKmK3z7/D+nX5yTkaxw2QqPevL7s/hste+REWj+a+12RPE71Ikyl3jedlgw6ZtAnuuo5
	 Vbv+dcyTlS0MzwF44JOyDm/F9R7mU7z1ecbg8wBFvAhTqFhVjntOXyfh78jN1iD0T5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lyWMC4QvUTpDv3SsLVy3KnKmXPOu0K87yZm8+EDzzEs=;
	b=QV4PrblAIODMKNAFZWFsOiIeJX+wyFLLMquf2cRwDXqyuHPENvV2+l/yFYNPXjgwgpms
	 Y62MdJydHA5ye84eGLP8h+oGbiqfi5EL+gJ8ch2MO/UdfB0tYyIKESvzhlqtgi0khfz7I
	 xcSpXLTCPNYxgacDhrIlzh3BqRm2rYM7iHdvUjFpXxANOI/kdgyNrbc0Yn/8NdFVZnnhX
	 UvjqASjqWoFlV/lJg/bHlAVGqbywjT2r7YboN5CAv865YNribM0FPzMWwAd0MCOwrxfZT
	 7vTXdlfizDNfLeHbbCCnV76A1scOpRGkoXQ3tp6B7iuLZcaPyt6E/vVV98G+CyrM5Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7QjQYcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB65606A331;
	Thu, 19 Nov 2026 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7QjQYcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64361F000C5;
	Thu, 19 Nov 2026 01:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050579;
	bh=lyWMC4QvUTpDv3SsLVy3KnKmXPOu0K87yZm8+EDzzEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7QjQYcWlyItHf8z3EM0EvF4z8CxGvnqJhfELiV0b3910FI6+fq1qxNOOH/ydt4Ae
	 KcjMTSsNo5BaiH1yRbX31r3ZCYENuhAeyL3N0PNyVGZAmhmo3Fz6LpVKXJTHw7sgJ4
	 0llKlmOaMD6VaQTUrUB65F0DQ/NCfRrlju1xjiVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2717/2857] tls: extend tls_cipher_desc to fully describe the ciphers
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150339.444892378@linuxfoundation.org>
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

[ Upstream commit 176a3f50bc6a327c82c6b051b0bedd19917081a2 ]

- add nonce, usually equal to iv_size but not for chacha
 - add offsets into the crypto_info for each field
 - add algorithm name
 - add offloadable flag

Also add helpers to access each field of a crypto_info struct
described by a tls_cipher_desc.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/39d5f476d63c171097764e8d38f6f158b7c109ae.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h      | 32 ++++++++++++++++++++++++++++++++
 net/tls/tls_main.c | 41 ++++++++++++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index b69952298705e..434e237f797b8 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -51,11 +51,19 @@
 	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
 
 struct tls_cipher_desc {
+	unsigned int nonce;
 	unsigned int iv;
 	unsigned int key;
 	unsigned int salt;
 	unsigned int tag;
 	unsigned int rec_seq;
+	unsigned int iv_offset;
+	unsigned int key_offset;
+	unsigned int salt_offset;
+	unsigned int rec_seq_offset;
+	char *cipher_name;
+	bool offloadable;
+	size_t crypto_info;
 };
 
 #define TLS_CIPHER_MIN TLS_CIPHER_AES_GCM_128
@@ -70,6 +78,30 @@ static inline const struct tls_cipher_desc *get_cipher_desc(u16 cipher_type)
 	return &tls_cipher_desc[cipher_type - TLS_CIPHER_MIN];
 }
 
+static inline char *crypto_info_iv(struct tls_crypto_info *crypto_info,
+				   const struct tls_cipher_desc *cipher_desc)
+{
+	return (char *)crypto_info + cipher_desc->iv_offset;
+}
+
+static inline char *crypto_info_key(struct tls_crypto_info *crypto_info,
+				    const struct tls_cipher_desc *cipher_desc)
+{
+	return (char *)crypto_info + cipher_desc->key_offset;
+}
+
+static inline char *crypto_info_salt(struct tls_crypto_info *crypto_info,
+				     const struct tls_cipher_desc *cipher_desc)
+{
+	return (char *)crypto_info + cipher_desc->salt_offset;
+}
+
+static inline char *crypto_info_rec_seq(struct tls_crypto_info *crypto_info,
+					const struct tls_cipher_desc *cipher_desc)
+{
+	return (char *)crypto_info + cipher_desc->rec_seq_offset;
+}
+
 
 /* TLS records are maintained in 'struct tls_rec'. It stores the memory pages
  * allocated or mapped for each TLS record. After encryption, the records are
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 11e872438bf4e..51fd5c25e968a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -58,23 +58,46 @@ enum {
 	TLS_NUM_PROTS,
 };
 
-#define CIPHER_DESC(cipher) [cipher - TLS_CIPHER_MIN] = {	\
+#define __CIPHER_DESC(ci) \
+	.iv_offset = offsetof(struct ci, iv), \
+	.key_offset = offsetof(struct ci, key), \
+	.salt_offset = offsetof(struct ci, salt), \
+	.rec_seq_offset = offsetof(struct ci, rec_seq), \
+	.crypto_info = sizeof(struct ci)
+
+#define CIPHER_DESC(cipher,ci,algname,_offloadable) [cipher - TLS_CIPHER_MIN] = {	\
+	.nonce = cipher ## _IV_SIZE, \
 	.iv = cipher ## _IV_SIZE, \
 	.key = cipher ## _KEY_SIZE, \
 	.salt = cipher ## _SALT_SIZE, \
 	.tag = cipher ## _TAG_SIZE, \
 	.rec_seq = cipher ## _REC_SEQ_SIZE, \
+	.cipher_name = algname,	\
+	.offloadable = _offloadable, \
+	__CIPHER_DESC(ci), \
+}
+
+#define CIPHER_DESC_NONCE0(cipher,ci,algname,_offloadable) [cipher - TLS_CIPHER_MIN] = { \
+	.nonce = 0, \
+	.iv = cipher ## _IV_SIZE, \
+	.key = cipher ## _KEY_SIZE, \
+	.salt = cipher ## _SALT_SIZE, \
+	.tag = cipher ## _TAG_SIZE, \
+	.rec_seq = cipher ## _REC_SEQ_SIZE, \
+	.cipher_name = algname,	\
+	.offloadable = _offloadable, \
+	__CIPHER_DESC(ci), \
 }
 
 const struct tls_cipher_desc tls_cipher_desc[TLS_CIPHER_MAX + 1 - TLS_CIPHER_MIN] = {
-	CIPHER_DESC(TLS_CIPHER_AES_GCM_128),
-	CIPHER_DESC(TLS_CIPHER_AES_GCM_256),
-	CIPHER_DESC(TLS_CIPHER_AES_CCM_128),
-	CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305),
-	CIPHER_DESC(TLS_CIPHER_SM4_GCM),
-	CIPHER_DESC(TLS_CIPHER_SM4_CCM),
-	CIPHER_DESC(TLS_CIPHER_ARIA_GCM_128),
-	CIPHER_DESC(TLS_CIPHER_ARIA_GCM_256),
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_128, tls12_crypto_info_aes_gcm_128, "gcm(aes)", true),
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_256, tls12_crypto_info_aes_gcm_256, "gcm(aes)", true),
+	CIPHER_DESC(TLS_CIPHER_AES_CCM_128, tls12_crypto_info_aes_ccm_128, "ccm(aes)", false),
+	CIPHER_DESC_NONCE0(TLS_CIPHER_CHACHA20_POLY1305, tls12_crypto_info_chacha20_poly1305, "rfc7539(chacha20,poly1305)", false),
+	CIPHER_DESC(TLS_CIPHER_SM4_GCM, tls12_crypto_info_sm4_gcm, "gcm(sm4)", false),
+	CIPHER_DESC(TLS_CIPHER_SM4_CCM, tls12_crypto_info_sm4_ccm, "ccm(sm4)", false),
+	CIPHER_DESC(TLS_CIPHER_ARIA_GCM_128, tls12_crypto_info_aria_gcm_128, "gcm(aria)", false),
+	CIPHER_DESC(TLS_CIPHER_ARIA_GCM_256, tls12_crypto_info_aria_gcm_256, "gcm(aria)", false),
 };
 
 static const struct proto *saved_tcpv6_prot;
-- 
2.53.0



