Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621467;
	b=QkM4S37FV3xqC5D9v9XRHq3AyEwblfvbjUmEAfPJf/N/LexVPBZ5bhq/reQXWENip1GP
	 CKHMlms3lohS7QQgaHEr/rgkOl4hHddo8hJ5vQWwnXNvYoEVA774bTbfk+ftQ+4RaJ0xJ
	 yr5Iy5lOq0s8s+ZdcUG+ux0oD5xXJrU5dE+Uckf440alH2r8OIyb1BsPk7XvOtG07A4YG
	 gIp+s50TyfshjzNpkHngH4uvoptG5pVtkaJJKOjuG0DVocurXwTkWpncYxMDvnOmXrcyA
	 T6pprp8c64uAAZ+PIUfNZcvr5PDinEMYekdgwfpJPk88G38MCwW1zRlIdTbk397liOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vssCX4GAPu3KFjevKt82YaLoZYzi57ztRs1J2yB7akM=;
	b=iSnRqeFbA0PVfGJDxi6JharNpb46nfoMV3Ihvyl5R980h0mBfyQ0G/MnOh0+j9fP1dSH
	 USqcwMqXOOAKMpVcAqqmkgcL517hI0WoPDrK7n+9lQxTLL9Q+JkB1oSK77Ap/ncF1zv2J
	 S/bmN7nqb0O8ZhmEo9vUA9AXCcxrtMJbcnN6CQ3NbFNtkEEHRGcuS6Pb4m0+8OosvJlL+
	 4iMhJrxD9Khx0bV7vKWlENGDOeYddTzjSqEIEKzU3TSU+bqm22xy+0YawVb5LaiLZKLMR
	 6p5mTyKSvRXs57rJ5STsuhERk497Kk7MamU7TNXfgcwWLtsDt5UaetUmQl3P0Qe48gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QTj7O4jE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFD2606A329;
	Wed, 25 Nov 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QTj7O4jE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B31F000CA;
	Wed, 25 Nov 2026 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621466;
	bh=vssCX4GAPu3KFjevKt82YaLoZYzi57ztRs1J2yB7akM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTj7O4jEig3oL+WBOidXO7CMVBNtlw3qrJlt6GpuworAePsW59lOJ4PiK45jQyzXA
	 eC320+JJhIa8L028OO29JLVJu/gOuHNFz1iXal+OkdEmDkaXisqH9mT+TCxzJ6PZaH
	 BPC+huH2ko7bjUKkXCuFG3BQmex53SvdUr0QngAQ=
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
Subject: [PATCH 6.18 234/990] nvme-auth: common: use crypto library in nvme_auth_augmented_challenge()
Date: Wed, 25 Nov 2026 15:26:41 +0100
Message-ID: <20261125143827.569546448@linuxfoundation.org>
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

[ Upstream commit a67d096fe9761e3e503f40643228bca6d69c7c4e ]

For the hash and HMAC computations in nvme_auth_augmented_challenge(),
use the crypto library instead of crypto_shash.  This is simpler,
faster, and more reliable.  Notably, this eliminates two crypto
transformation object allocations for every call, which was very slow.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/auth.c | 96 ++++++++++++++------------------------
 1 file changed, 36 insertions(+), 60 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index a8e205b0411bf..28e3de1584611 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -300,6 +300,37 @@ void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_hmac_final);
 
+static int nvme_auth_hmac(u8 hmac_id, const u8 *key, size_t key_len,
+			  const u8 *data, size_t data_len, u8 *out)
+{
+	struct nvme_auth_hmac_ctx hmac;
+	int ret;
+
+	ret = nvme_auth_hmac_init(&hmac, hmac_id, key, key_len);
+	if (ret == 0) {
+		nvme_auth_hmac_update(&hmac, data, data_len);
+		nvme_auth_hmac_final(&hmac, out);
+	}
+	return ret;
+}
+
+static int nvme_auth_hash(u8 hmac_id, const u8 *data, size_t data_len, u8 *out)
+{
+	switch (hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		sha256(data, data_len, out);
+		return 0;
+	case NVME_AUTH_HASH_SHA384:
+		sha384(data, data_len, out);
+		return 0;
+	case NVME_AUTH_HASH_SHA512:
+		sha512(data, data_len, out);
+		return 0;
+	}
+	pr_warn("%s: invalid hash algorithm %d\n", __func__, hmac_id);
+	return -EINVAL;
+}
+
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn)
 {
@@ -367,72 +398,17 @@ struct nvme_dhchap_key *nvme_auth_transform_key(
 }
 EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
 
-static int nvme_auth_hash_skey(int hmac_id, const u8 *skey, size_t skey_len,
-			       u8 *hkey)
-{
-	const char *digest_name;
-	struct crypto_shash *tfm;
-	int ret;
-
-	digest_name = nvme_auth_digest_name(hmac_id);
-	if (!digest_name) {
-		pr_debug("%s: failed to get digest for %d\n", __func__,
-			 hmac_id);
-		return -EINVAL;
-	}
-	tfm = crypto_alloc_shash(digest_name, 0, 0);
-	if (IS_ERR(tfm))
-		return -ENOMEM;
-
-	ret = crypto_shash_tfm_digest(tfm, skey, skey_len, hkey);
-	if (ret < 0)
-		pr_debug("%s: Failed to hash digest len %zu\n", __func__,
-			 skey_len);
-
-	crypto_free_shash(tfm);
-	return ret;
-}
-
 int nvme_auth_augmented_challenge(u8 hmac_id, const u8 *skey, size_t skey_len,
 				  const u8 *challenge, u8 *aug, size_t hlen)
 {
-	struct crypto_shash *tfm;
-	u8 *hashed_key;
-	const char *hmac_name;
+	u8 hashed_key[NVME_AUTH_MAX_DIGEST_SIZE];
 	int ret;
 
-	hashed_key = kmalloc(hlen, GFP_KERNEL);
-	if (!hashed_key)
-		return -ENOMEM;
-
-	ret = nvme_auth_hash_skey(hmac_id, skey,
-				  skey_len, hashed_key);
-	if (ret < 0)
-		goto out_free_key;
-
-	hmac_name = nvme_auth_hmac_name(hmac_id);
-	if (!hmac_name) {
-		pr_warn("%s: invalid hash algorithm %d\n",
-			__func__, hmac_id);
-		ret = -EINVAL;
-		goto out_free_key;
-	}
-
-	tfm = crypto_alloc_shash(hmac_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		ret = PTR_ERR(tfm);
-		goto out_free_key;
-	}
-
-	ret = crypto_shash_setkey(tfm, hashed_key, hlen);
+	ret = nvme_auth_hash(hmac_id, skey, skey_len, hashed_key);
 	if (ret)
-		goto out_free_hash;
-
-	ret = crypto_shash_tfm_digest(tfm, challenge, hlen, aug);
-out_free_hash:
-	crypto_free_shash(tfm);
-out_free_key:
-	kfree_sensitive(hashed_key);
+		return ret;
+	ret = nvme_auth_hmac(hmac_id, hashed_key, hlen, challenge, hlen, aug);
+	memzero_explicit(hashed_key, sizeof(hashed_key));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_augmented_challenge);
-- 
2.53.0



