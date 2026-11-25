Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621464;
	b=njUb6yWcOSTOMNR3xbVXtHd6a8laVmYwVffSYPbb5vwkP01YuVpmFcfT/IyPqgTxKMzI
	 wlnPs8e2d6CndcBrYq3+ln6NhappE8BFpAWhNPqk0R3EMeKILRLPH9Uf2T4YB+IrcXRPX
	 ZjYyABimF/U91HijNVLd36wD/MSQT/t9UqnHDahpCIHY7GpK4VhVeP4pelSoei3ppI1F/
	 +gSUYE4imk36QCG/xwSnen+qBzrP8HD54wPBFH4gJPYmcoJZ7GOXjGwFjWnR+SojSJafN
	 DDBJWycwVVeKhxAPQn/p6Doy6znAZ9bQLTRvw2V6VOKEzh//JHnyd5jrjqRncDRqHRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ONDvDGO3CmovF2+y04mcxmEA/G5yhNP3klTwDbrAqFw=;
	b=eN1pbqxV81bcgI6EDjC1T6huiDXaLeycWrQ1ffltc9A4MUvwNjW+o3ja4Srpw+l2144P
	 NP2+RgIcgrLnCxgajABuTyX6CNKWGaZ8dziys8QQ425QyGn2GT2HzV6KA0zRS3xH5Xl8e
	 mRYbW7X3XMBSf+CC0BExqs8+cOs6Gu2iDD1C2vGm2zt7/HEY4mbcC9VgW7/HbWminCFzc
	 mTe+f7AkMou1PbFq8dh/znVEIQfRHl0z7TD/91pmUrqU7A3YBOxg8lmEyT9w50AgfUjPV
	 8jyVy5NZdiMjL+MRotLEVVdkkINAtB+lAbX87Nx1UuS8loXa76ysNvvSX8S2wWsKRzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6uNv8Ak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36953606A329;
	Wed, 25 Nov 2026 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6uNv8Ak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555B81F000CA;
	Wed, 25 Nov 2026 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621463;
	bh=ONDvDGO3CmovF2+y04mcxmEA/G5yhNP3klTwDbrAqFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6uNv8AksXbVpPXs+zo5tI2xVHy07Ie21pAn/JXMEoJj4yWRTBgzRgb4odOv+Q8Q6
	 73NAy62U95GIk7HhxLeDmi98aM2V/BV21lWsQAhS1hT/fegnmqAhyj3RA7HcJWoce+
	 rDUE0Pdh5+ZRB7ZFbKsKNfv8NOmc+5Vyqt7vx2WY=
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
Subject: [PATCH 6.18 233/990] nvme-auth: common: add HMAC helper functions
Date: Wed, 25 Nov 2026 15:26:40 +0100
Message-ID: <20261125143827.546458817@linuxfoundation.org>
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

[ Upstream commit 4263ca1cae5cebc09ba95375c4a8927bf4b39d49 ]

Add some helper functions for computing HMAC-SHA256, HMAC-SHA384, or
HMAC-SHA512 values using the crypto library instead of crypto_shash.
These will enable some significant simplifications and performance
improvements in nvme-auth.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/Kconfig |  2 ++
 drivers/nvme/common/auth.c  | 66 +++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h   | 14 ++++++++
 3 files changed, 82 insertions(+)

diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
index d19988c13af5f..1ec507d1f9b5f 100644
--- a/drivers/nvme/common/Kconfig
+++ b/drivers/nvme/common/Kconfig
@@ -13,6 +13,8 @@ config NVME_AUTH
 	select CRYPTO_DH
 	select CRYPTO_DH_RFC7919_GROUPS
 	select CRYPTO_HKDF
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 
 config NVME_AUTH_KUNIT_TEST
 	tristate "KUnit tests for NVMe authentication" if !KUNIT_ALL_TESTS
diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 854711bff7f9a..a8e205b0411bf 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -12,6 +12,7 @@
 #include <crypto/hash.h>
 #include <crypto/dh.h>
 #include <crypto/hkdf.h>
+#include <crypto/sha2.h>
 #include <linux/nvme.h>
 #include <linux/nvme-auth.h>
 
@@ -234,6 +235,71 @@ void nvme_auth_free_key(struct nvme_dhchap_key *key)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_free_key);
 
+/*
+ * Start computing an HMAC value, given the algorithm ID and raw key.
+ *
+ * The context should be zeroized at the end of its lifetime.  The caller can do
+ * that implicitly by calling nvme_auth_hmac_final(), or explicitly (needed when
+ * a context is abandoned without finalizing it) by calling memzero_explicit().
+ */
+int nvme_auth_hmac_init(struct nvme_auth_hmac_ctx *hmac, u8 hmac_id,
+			const u8 *key, size_t key_len)
+{
+	hmac->hmac_id = hmac_id;
+	switch (hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_init_usingrawkey(&hmac->sha256, key, key_len);
+		return 0;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_init_usingrawkey(&hmac->sha384, key, key_len);
+		return 0;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_init_usingrawkey(&hmac->sha512, key, key_len);
+		return 0;
+	}
+	pr_warn("%s: invalid hash algorithm %d\n", __func__, hmac_id);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_init);
+
+void nvme_auth_hmac_update(struct nvme_auth_hmac_ctx *hmac, const u8 *data,
+			   size_t data_len)
+{
+	switch (hmac->hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_update(&hmac->sha256, data, data_len);
+		return;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_update(&hmac->sha384, data, data_len);
+		return;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_update(&hmac->sha512, data, data_len);
+		return;
+	}
+	/* Unreachable because nvme_auth_hmac_init() validated hmac_id */
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_update);
+
+/* Finish computing an HMAC value.  Note that this zeroizes the HMAC context. */
+void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out)
+{
+	switch (hmac->hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_final(&hmac->sha256, out);
+		return;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_final(&hmac->sha384, out);
+		return;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_final(&hmac->sha512, out);
+		return;
+	}
+	/* Unreachable because nvme_auth_hmac_init() validated hmac_id */
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_final);
+
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn)
 {
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index a4b248c24ccf6..4f9a6599077cc 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -7,6 +7,7 @@
 #define _NVME_AUTH_H
 
 #include <crypto/kpp.h>
+#include <crypto/sha2.h>
 
 struct nvme_dhchap_key {
 	size_t len;
@@ -23,6 +24,19 @@ const char *nvme_auth_hmac_name(u8 hmac_id);
 const char *nvme_auth_digest_name(u8 hmac_id);
 size_t nvme_auth_hmac_hash_len(u8 hmac_id);
 u8 nvme_auth_hmac_id(const char *hmac_name);
+struct nvme_auth_hmac_ctx {
+	u8 hmac_id;
+	union {
+		struct hmac_sha256_ctx sha256;
+		struct hmac_sha384_ctx sha384;
+		struct hmac_sha512_ctx sha512;
+	};
+};
+int nvme_auth_hmac_init(struct nvme_auth_hmac_ctx *hmac, u8 hmac_id,
+			const u8 *key, size_t key_len);
+void nvme_auth_hmac_update(struct nvme_auth_hmac_ctx *hmac, const u8 *data,
+			   size_t data_len);
+void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out);
 
 u32 nvme_auth_key_struct_size(u32 key_len);
 struct nvme_dhchap_key *nvme_auth_extract_key(const char *secret, u8 key_hash);
-- 
2.53.0



