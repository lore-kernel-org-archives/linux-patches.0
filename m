Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621454;
	b=FyaMi4/kBBWpys1DcOY2PwAiUtN5fS7Jf+7EDFfT5yD5ps91BpNFJTXIPAAIvjIVVkaS
	 UGj4WnxJDPqjQheupeVi+JknaKVW7j0Sv8hyPu9U0PONKkXUC2T1CIknystGv6fzCBpyH
	 Qe2PPEZKYgnmq96zLK3z/UzLlV1Br41xFWKqM4nGps/4smntRew07TeoKBjS+Q9QI8xid
	 TfGGbydlo5T8IV5f5pbUWK6KszxBzmr6fYS771DZ6BWXCQPGk/aRVhlxJ35IqC0V8hPAV
	 SaEpshQBV+KP13HG6pHRNf9i48mPAnNkwdWmyIo7jGBuMpgHk8n4c1lX/PqWhbVTB8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EifOHJSFZtR3bKsFCr8gBQVCtcR2sEkWrEU9/j3oEow=;
	b=zB5kgee8LM4Yjjr70nwFYg/zNhIuMRvERiNPnuxDekSjpbhKDeJ3ctjaScVyGZlgH6PY
	 qazIAclGsAbEIuCiPaHJ0TgClhsuvMW7Js/XmtgikV1FSqGRm6K9tuRiw7mj9E78KjkOL
	 s3uY+pg55pxg2t5f46RdjLxVIhnnlK0/CrziM7FJ3EzGrHPK2rcFXNwwM6DMoz0eW64Jl
	 YrrTDVTZlh9c7s1iseRKiFDoP66P34SHKo0CzofbZ+3LIJ8N6t6MfCRj2VOsSvKNdLIbd
	 9f+UTtaj4hpPa2xVbE08y8wrl1olxc9hUOE9/XWBmhA0JNIZvVWhs+tY1uEqj57QpDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i00W25GQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966BC606A31E;
	Wed, 25 Nov 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i00W25GQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13ED1F000C0;
	Wed, 25 Nov 2026 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621454;
	bh=EifOHJSFZtR3bKsFCr8gBQVCtcR2sEkWrEU9/j3oEow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i00W25GQ3zgJgGj6YAK/+j4sGluIjLk0fNKEOI0XU3n0O0cYb542q449FS63nF92/
	 WSfAIukC/P8N1VgEi6xa3Z1NIb4NXfu6TYIWhVpwZR458o1xZBUOxUZ2fYTa8rNE40
	 KJaZ79wf8vl5qZbQPqgWySeXWtYHQyFLMcEU+whU=
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
Subject: [PATCH 6.18 230/990] nvme-auth: add NVME_AUTH_MAX_DIGEST_SIZE constant
Date: Wed, 25 Nov 2026 15:26:37 +0100
Message-ID: <20261125143827.476732269@linuxfoundation.org>
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

[ Upstream commit 9100a28c8bb4270744942cf834efcd80f1acda7d ]

Define a NVME_AUTH_MAX_DIGEST_SIZE constant and use it in the
appropriate places.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/auth.c | 6 ++----
 drivers/nvme/host/auth.c   | 6 +++---
 include/linux/nvme.h       | 5 +++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 1f51fbebd9fac..aab06fc8ac774 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -15,8 +15,6 @@
 #include <linux/nvme.h>
 #include <linux/nvme-auth.h>
 
-#define HKDF_MAX_HASHLEN 64
-
 static u32 nvme_dhchap_seqnum;
 static DEFINE_MUTEX(nvme_dhchap_mutex);
 
@@ -769,7 +767,7 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 	struct crypto_shash *hmac_tfm;
 	const char *hmac_name;
 	const char *label = "nvme-tls-psk";
-	static const char default_salt[HKDF_MAX_HASHLEN];
+	static const char default_salt[NVME_AUTH_MAX_DIGEST_SIZE];
 	size_t prk_len;
 	const char *ctx;
 	unsigned char *prk, *tls_key;
@@ -798,7 +796,7 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 		goto out_free_shash;
 	}
 
-	if (WARN_ON(prk_len > HKDF_MAX_HASHLEN)) {
+	if (WARN_ON(prk_len > NVME_AUTH_MAX_DIGEST_SIZE)) {
 		ret = -EINVAL;
 		goto out_free_prk;
 	}
diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 38506314248f6..044f6cc6493bf 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -39,9 +39,9 @@ struct nvme_dhchap_queue_context {
 	u8 hash_id;
 	u8 sc_c;
 	size_t hash_len;
-	u8 c1[64];
-	u8 c2[64];
-	u8 response[64];
+	u8 c1[NVME_AUTH_MAX_DIGEST_SIZE];
+	u8 c2[NVME_AUTH_MAX_DIGEST_SIZE];
+	u8 response[NVME_AUTH_MAX_DIGEST_SIZE];
 	u8 *ctrl_key;
 	u8 *host_key;
 	u8 *sess_key;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 2a5d2d941d845..8aa83abc78638 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1837,6 +1837,11 @@ enum {
 	NVME_AUTH_HASH_INVALID	= 0xff,
 };
 
+/* Maximum digest size for any NVME_AUTH_HASH_* value */
+enum {
+	NVME_AUTH_MAX_DIGEST_SIZE = 64,
+};
+
 /* Defined Diffie-Hellman group identifiers for DH-HMAC-CHAP authentication */
 enum {
 	NVME_AUTH_DHGROUP_NULL		= 0x00,
-- 
2.53.0



