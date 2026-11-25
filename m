Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621458;
	b=pn+sHplOYHrwoY18UacVmXLd3xTPjJ0e0PF32h1iKnpKT87EwWZxJdUGhAdLUfGTPNXc
	 gAnDwK0Eqr9/s4hMBLtnfcpQe3s5H5X29bTxebFi4SfhuztYf+hWv4UK+tcNIE/PKiJnW
	 HZESQn8f/D7KG77wL1J2eCTvb+TDTgw7jEtPF6nlb6U8zZJmvX2+P//cKen6OK2kWPKvh
	 Myxi06UFytC84OuUUs2hh25Kc0jHE+lhD1FpQ+VU745iwS7jbtKi6Jokx4BNeowVhwso6
	 BYvhjjquRSJJJ8MsKdmKfZzx9OrqCwJ3CikmREI4VnYx9zFCExsZYWWHiYvtt5a+2kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SOuHZeEb6Z8QZ1d6GZaiHMtAu8GHb1QnZQlHnZXWSRs=;
	b=iw/29kPANFsBp7rjKgb16XB5BDyrL+0PgsiIlknf3QEnM45X7eQSucN1qZG+eQgx3CHm
	 DZ1gpzdXo/idF2x1z4YmxDumx5uPeJV/fZr7lhqoMGjtPI+C6iHGmK+r0qT6DSeVmXpJG
	 zD9WEWXU741uvUP4iCyvzz4Xy7j6Sa8qfzfaFI3OBxFy98e5kyWzVYxvbrTPhtMrOuCoW
	 m52lVqmFp1+9VPpPNxLGG5znBsKTXKtdFWdbv4DHucXKxWlGDdqucFhqnr9m3z3Dr0QwY
	 LiRUV4DlddNbSKXU2/S/BDp4rkFwPdjkuu+BPtXLl3oD4vDMsvM1rMQWWRsYitO9b2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xUeoL7D/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00109606A31E;
	Wed, 25 Nov 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUeoL7D/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A501F000C6;
	Wed, 25 Nov 2026 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621457;
	bh=SOuHZeEb6Z8QZ1d6GZaiHMtAu8GHb1QnZQlHnZXWSRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUeoL7D/fy1ZmkKTUpsngvlJC7yeniZDSOqEBe2NDvx24HrhH4RyPOMC5FuslpThz
	 KCTVd5U4vGKn2AzlaYCpJJ51vYcPfZ54zOWyQgxtLwNPh/O8O/xRZY8OQGbPaD82+D
	 HMpdL/FSPfeXHAbDBT6lCwlOI21QlZSkY2DPCG+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/990] nvme-auth: use proper argument types
Date: Wed, 25 Nov 2026 15:26:38 +0100
Message-ID: <20261125143827.499394201@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit bf0e2567a639c455110f9be5db8c92032175e222 ]

For input parameters, use pointer to const.  This makes it easier to
understand which parameters are inputs and which are outputs.

In addition, consistently use char for strings and u8 for binary.  This
makes it easier to understand what is a string and what is binary data.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/auth.c  | 47 ++++++++++++++++++++-----------------
 drivers/nvme/host/auth.c    |  3 ++-
 drivers/nvme/target/auth.c  |  5 ++--
 drivers/nvme/target/nvmet.h |  2 +-
 include/linux/nvme-auth.h   | 26 ++++++++++----------
 5 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index aab06fc8ac774..854711bff7f9a 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -159,11 +159,10 @@ u32 nvme_auth_key_struct_size(u32 key_len)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_key_struct_size);
 
-struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
-					      u8 key_hash)
+struct nvme_dhchap_key *nvme_auth_extract_key(const char *secret, u8 key_hash)
 {
 	struct nvme_dhchap_key *key;
-	unsigned char *p;
+	const char *p;
 	u32 crc;
 	int ret, key_len;
 	size_t allocated_len = strlen(secret);
@@ -181,14 +180,14 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 		pr_debug("base64 key decoding error %d\n",
 			 key_len);
 		ret = key_len;
-		goto out_free_secret;
+		goto out_free_key;
 	}
 
 	if (key_len != 36 && key_len != 52 &&
 	    key_len != 68) {
 		pr_err("Invalid key len %d\n", key_len);
 		ret = -EINVAL;
-		goto out_free_secret;
+		goto out_free_key;
 	}
 
 	/* The last four bytes is the CRC in little-endian format */
@@ -203,12 +202,12 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 		pr_err("key crc mismatch (key %08x, crc %08x)\n",
 		       get_unaligned_le32(key->key + key_len), crc);
 		ret = -EKEYREJECTED;
-		goto out_free_secret;
+		goto out_free_key;
 	}
 	key->len = key_len;
 	key->hash = key_hash;
 	return key;
-out_free_secret:
+out_free_key:
 	nvme_auth_free_key(key);
 	return ERR_PTR(ret);
 }
@@ -236,7 +235,7 @@ void nvme_auth_free_key(struct nvme_dhchap_key *key)
 EXPORT_SYMBOL_GPL(nvme_auth_free_key);
 
 struct nvme_dhchap_key *nvme_auth_transform_key(
-		struct nvme_dhchap_key *key, char *nqn)
+		const struct nvme_dhchap_key *key, const char *nqn)
 {
 	const char *hmac_name;
 	struct crypto_shash *key_tfm;
@@ -302,7 +301,8 @@ struct nvme_dhchap_key *nvme_auth_transform_key(
 }
 EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
 
-static int nvme_auth_hash_skey(int hmac_id, u8 *skey, size_t skey_len, u8 *hkey)
+static int nvme_auth_hash_skey(int hmac_id, const u8 *skey, size_t skey_len,
+			       u8 *hkey)
 {
 	const char *digest_name;
 	struct crypto_shash *tfm;
@@ -327,8 +327,8 @@ static int nvme_auth_hash_skey(int hmac_id, u8 *skey, size_t skey_len, u8 *hkey)
 	return ret;
 }
 
-int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
-		u8 *challenge, u8 *aug, size_t hlen)
+int nvme_auth_augmented_challenge(u8 hmac_id, const u8 *skey, size_t skey_len,
+				  const u8 *challenge, u8 *aug, size_t hlen)
 {
 	struct crypto_shash *tfm;
 	u8 *hashed_key;
@@ -409,7 +409,7 @@ int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
 EXPORT_SYMBOL_GPL(nvme_auth_gen_pubkey);
 
 int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
-		u8 *ctrl_key, size_t ctrl_key_len,
+		const u8 *ctrl_key, size_t ctrl_key_len,
 		u8 *sess_key, size_t sess_key_len)
 {
 	struct kpp_request *req;
@@ -436,7 +436,7 @@ int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
 }
 EXPORT_SYMBOL_GPL(nvme_auth_gen_shared_secret);
 
-int nvme_auth_generate_key(u8 *secret, struct nvme_dhchap_key **ret_key)
+int nvme_auth_generate_key(const char *secret, struct nvme_dhchap_key **ret_key)
 {
 	struct nvme_dhchap_key *key;
 	u8 key_hash;
@@ -484,8 +484,9 @@ EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
  * Returns 0 on success with a valid generated PSK pointer in @ret_psk and
  * the length of @ret_psk in @ret_len, or a negative error number otherwise.
  */
-int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
-		u8 *c1, u8 *c2, size_t hash_len, u8 **ret_psk, size_t *ret_len)
+int nvme_auth_generate_psk(u8 hmac_id, const u8 *skey, size_t skey_len,
+			   const u8 *c1, const u8 *c2, size_t hash_len,
+			   u8 **ret_psk, size_t *ret_len)
 {
 	struct crypto_shash *tfm;
 	SHASH_DESC_ON_STACK(shash, tfm);
@@ -582,12 +583,14 @@ EXPORT_SYMBOL_GPL(nvme_auth_generate_psk);
  * Returns 0 on success with a valid digest pointer in @ret_digest, or a
  * negative error number on failure.
  */
-int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
-		char *subsysnqn, char *hostnqn, u8 **ret_digest)
+int nvme_auth_generate_digest(u8 hmac_id, const u8 *psk, size_t psk_len,
+			      const char *subsysnqn, const char *hostnqn,
+			      char **ret_digest)
 {
 	struct crypto_shash *tfm;
 	SHASH_DESC_ON_STACK(shash, tfm);
-	u8 *digest, *enc;
+	u8 *digest;
+	char *enc;
 	const char *hmac_name;
 	size_t digest_len, hmac_len;
 	int ret;
@@ -761,16 +764,16 @@ static int hkdf_expand_label(struct crypto_shash *hmac_tfm,
  * Returns 0 on success with a valid psk pointer in @ret_psk or a negative
  * error number otherwise.
  */
-int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
-		u8 *psk_digest, u8 **ret_psk)
+int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
+			     const char *psk_digest, u8 **ret_psk)
 {
 	struct crypto_shash *hmac_tfm;
 	const char *hmac_name;
 	const char *label = "nvme-tls-psk";
-	static const char default_salt[NVME_AUTH_MAX_DIGEST_SIZE];
+	static const u8 default_salt[NVME_AUTH_MAX_DIGEST_SIZE];
 	size_t prk_len;
 	const char *ctx;
-	unsigned char *prk, *tls_key;
+	u8 *prk, *tls_key;
 	int ret;
 
 	hmac_name = nvme_auth_hmac_name(hmac_id);
diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 044f6cc6493bf..d0c3679acdc19 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -722,7 +722,8 @@ EXPORT_SYMBOL_GPL(nvme_auth_revoke_tls_key);
 static int nvme_auth_secure_concat(struct nvme_ctrl *ctrl,
 				   struct nvme_dhchap_queue_context *chap)
 {
-	u8 *psk, *digest, *tls_psk;
+	u8 *psk, *tls_psk;
+	char *digest;
 	struct key *tls_key;
 	size_t psk_len;
 	int ret = 0;
diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index eb2b6c7a80838..99f16b1a7e886 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -539,7 +539,7 @@ int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
 }
 
 int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
-			    u8 *pkey, int pkey_size)
+			    const u8 *pkey, int pkey_size)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	int ret;
@@ -565,7 +565,8 @@ int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
 void nvmet_auth_insert_psk(struct nvmet_sq *sq)
 {
 	int hash_len = nvme_auth_hmac_hash_len(sq->ctrl->shash_id);
-	u8 *psk, *digest, *tls_psk;
+	u8 *psk, *tls_psk;
+	char *digest;
 	size_t psk_len;
 	int ret;
 #ifdef CONFIG_NVME_TARGET_TCP_TLS
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 9abf67fae1882..232768f1b24f1 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -932,7 +932,7 @@ static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq)
 int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
 				u8 *buf, int buf_size);
 int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
-			    u8 *buf, int buf_size);
+			    const u8 *pkey, int pkey_size);
 void nvmet_auth_insert_psk(struct nvmet_sq *sq);
 #else
 static inline u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl,
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index 60e069a6757ff..a4b248c24ccf6 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -25,27 +25,27 @@ size_t nvme_auth_hmac_hash_len(u8 hmac_id);
 u8 nvme_auth_hmac_id(const char *hmac_name);
 
 u32 nvme_auth_key_struct_size(u32 key_len);
-struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
-					      u8 key_hash);
+struct nvme_dhchap_key *nvme_auth_extract_key(const char *secret, u8 key_hash);
 void nvme_auth_free_key(struct nvme_dhchap_key *key);
 struct nvme_dhchap_key *nvme_auth_alloc_key(u32 len, u8 hash);
 struct nvme_dhchap_key *nvme_auth_transform_key(
-				struct nvme_dhchap_key *key, char *nqn);
-int nvme_auth_generate_key(u8 *secret, struct nvme_dhchap_key **ret_key);
-int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
-				  u8 *challenge, u8 *aug, size_t hlen);
+		const struct nvme_dhchap_key *key, const char *nqn);
+int nvme_auth_generate_key(const char *secret, struct nvme_dhchap_key **ret_key);
+int nvme_auth_augmented_challenge(u8 hmac_id, const u8 *skey, size_t skey_len,
+				  const u8 *challenge, u8 *aug, size_t hlen);
 int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, u8 dh_gid);
 int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
 			 u8 *host_key, size_t host_key_len);
 int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
-				u8 *ctrl_key, size_t ctrl_key_len,
+				const u8 *ctrl_key, size_t ctrl_key_len,
 				u8 *sess_key, size_t sess_key_len);
-int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
-			   u8 *c1, u8 *c2, size_t hash_len,
+int nvme_auth_generate_psk(u8 hmac_id, const u8 *skey, size_t skey_len,
+			   const u8 *c1, const u8 *c2, size_t hash_len,
 			   u8 **ret_psk, size_t *ret_len);
-int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
-		char *subsysnqn, char *hostnqn, u8 **ret_digest);
-int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
-		u8 *psk_digest, u8 **ret_psk);
+int nvme_auth_generate_digest(u8 hmac_id, const u8 *psk, size_t psk_len,
+			      const char *subsysnqn, const char *hostnqn,
+			      char **ret_digest);
+int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
+			     const char *psk_digest, u8 **ret_psk);
 
 #endif /* _NVME_AUTH_H */
-- 
2.53.0



