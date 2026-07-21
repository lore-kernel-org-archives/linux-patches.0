Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909144AB9F;
	Tue, 21 Jul 2026 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674536; cv=none; b=ATvf3yO45JmT3Mk6tGe+L8NZ2wQ+waqNSP1qUDYaX3g5Rlh1MYdyBj6R1zrTBiMbDGZwLMdieasUlaR4OFlhY7+vc82A2HalcdozLXCKeT8iMty0eFhKCjKXB14ZoukDyA8T9x4EdfhwVBH5SoziKJOTyTC1r7A1ORxSzqux4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674536; c=relaxed/simple;
	bh=ipIcprCd36z6h9PaifxtQ0LrAqet8SAdiwfiNLMmWeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAG0HSdw0OauWvj5NLGcdNhkaG7BPBuzrMSSM7QFUmMfLr4b608Q+66kbdWnJ93+I2DoGnTGQaTOiXj+wCc9cbwA3d6dojSg1CWPvf9PN138l34knSged5pkkZ7X4xENLkqKGshNDgVa/cvA1VPd8eUur24HxmRMzhDbJICNyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVY3nCiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVY3nCiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7751F000E9;
	Tue, 21 Jul 2026 22:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674535;
	bh=7gQhiwFCjxGLdtb8mYnNl1cpDP7cIWOz12pfiiCOYkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVY3nCiGWmXz2mB3kTh/n+dhm+5Y+kDivETyDHGX2kTI13YNanFxmYJtfRgbdwUjj
	 Nc9x2P5VTQcnjCCI/aQj1+6t6kArp36buUmQq7PvVwUzRpcuR68+O5tF41vTIZP2yp
	 jHy1j5bm1rpbenuMWOQD1T0WdzR5Uy0vfK/pjADk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Srivastava <yashsri421@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 577/699] crypto: amcc - fix incorrect kernel-doc comment syntax in files
Date: Tue, 21 Jul 2026 17:25:36 +0200
Message-ID: <20260721152408.726773508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Srivastava <yashsri421@gmail.com>

commit 73f04d3d800f3c8058bb00447e3e1c4cdc85a2b0 upstream.

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in drivers/crypto/amcc, which follow this syntax,
but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in
drivers/crypto/amcc/crypto4xx_alg.c at header, and some other lines,
causes these warnings by kernel-doc:

"warning: expecting prototype for AMCC SoC PPC4xx Crypto Driver(). Prototype was for set_dynamic_sa_command_0() instead"
"warning: Function parameter or member 'dir' not described in 'set_dynamic_sa_command_0'"
etc..

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/amcc/crypto4xx_alg.c     |   12 ++++++------
 drivers/crypto/amcc/crypto4xx_core.c    |   18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_core.h    |    4 ++--
 drivers/crypto/amcc/crypto4xx_reg_def.h |    8 ++++----
 drivers/crypto/amcc/crypto4xx_sa.h      |   18 +++++++++---------
 drivers/crypto/amcc/crypto4xx_trng.h    |    2 +-
 6 files changed, 31 insertions(+), 31 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -115,7 +115,7 @@ int crypto4xx_decrypt_iv_block(struct sk
 	return crypto4xx_crypt(req, AES_IV_SIZE, true, true);
 }
 
-/**
+/*
  * AES Functions
  */
 static int crypto4xx_setkey_aes(struct crypto_skcipher *cipher,
@@ -374,7 +374,7 @@ static int crypto4xx_aead_setup_fallback
 	return crypto_aead_setkey(ctx->sw_cipher.aead, key, keylen);
 }
 
-/**
+/*
  * AES-CCM Functions
  */
 
@@ -489,7 +489,7 @@ int crypto4xx_setauthsize_aead(struct cr
 	return crypto_aead_setauthsize(ctx->sw_cipher.aead, authsize);
 }
 
-/**
+/*
  * AES-GCM Functions
  */
 
@@ -617,7 +617,7 @@ int crypto4xx_decrypt_aes_gcm(struct aea
 	return crypto4xx_crypt_aes_gcm(req, true);
 }
 
-/**
+/*
  * HASH SHA1 Functions
  */
 static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
@@ -711,7 +711,7 @@ int crypto4xx_hash_digest(struct ahash_r
 				  ctx->sa_len, 0, NULL);
 }
 
-/**
+/*
  * SHA1 Algorithm
  */
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -44,7 +44,7 @@
 
 #define PPC4XX_SEC_VERSION_STR			"0.5"
 
-/**
+/*
  * PPC4xx Crypto Engine Initialization Routine
  */
 static void crypto4xx_hw_init(struct crypto4xx_device *dev)
@@ -159,7 +159,7 @@ void crypto4xx_free_sa(struct crypto4xx_
 	ctx->sa_len = 0;
 }
 
-/**
+/*
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
  * gdr_tail, gdr_head and gdr_count are initialized by this function
@@ -268,7 +268,7 @@ static u32 crypto4xx_put_pd_to_pdr(struc
 	return tail;
 }
 
-/**
+/*
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
  * gdr_tail, gdr_head and gdr_count are initialized by this function
@@ -346,7 +346,7 @@ static inline struct ce_gd *crypto4xx_ge
 	return &dev->gdr[idx];
 }
 
-/**
+/*
  * alloc memory for the scatter ring
  * need to alloc buf for the ring
  * sdr_tail, sdr_head and sdr_count are initialized by this function
@@ -928,7 +928,7 @@ int crypto4xx_build_pd(struct crypto_asy
 	return is_busy ? -EBUSY : -EINPROGRESS;
 }
 
-/**
+/*
  * Algorithm Registration Functions
  */
 static void crypto4xx_ctx_init(struct crypto4xx_alg *amcc_alg,
@@ -1095,7 +1095,7 @@ static void crypto4xx_bh_tasklet_cb(unsi
 	} while (head != tail);
 }
 
-/**
+/*
  * Top Half of isr.
  */
 static inline irqreturn_t crypto4xx_interrupt_handler(int irq, void *data,
@@ -1184,7 +1184,7 @@ static int crypto4xx_prng_seed(struct cr
 	return 0;
 }
 
-/**
+/*
  * Supported Crypto Algorithms
  */
 static struct crypto4xx_alg_common crypto4xx_alg[] = {
@@ -1367,7 +1367,7 @@ static struct crypto4xx_alg_common crypt
 	} },
 };
 
-/**
+/*
  * Module Initialization Routine
  */
 static int crypto4xx_probe(struct platform_device *ofdev)
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -188,7 +188,7 @@ int crypto4xx_hash_final(struct ahash_re
 int crypto4xx_hash_update(struct ahash_request *req);
 int crypto4xx_hash_init(struct ahash_request *req);
 
-/**
+/*
  * Note: Only use this function to copy items that is word aligned.
  */
 static inline void crypto4xx_memcpy_swab32(u32 *dst, const void *buf,
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -104,7 +104,7 @@
 #define CRYPTO4XX_PRNG_LFSR_L			0x00070030
 #define CRYPTO4XX_PRNG_LFSR_H			0x00070034
 
-/**
+/*
  * Initialize CRYPTO ENGINE registers, and memory bases.
  */
 #define PPC4XX_PDR_POLL				0x3ff
@@ -123,7 +123,7 @@
 #define PPC4XX_INT_TIMEOUT_CNT			0
 #define PPC4XX_INT_TIMEOUT_CNT_REVB		0x3FF
 #define PPC4XX_INT_CFG				1
-/**
+/*
  * all follow define are ad hoc
  */
 #define PPC4XX_RING_RETRY			100
@@ -131,7 +131,7 @@
 #define PPC4XX_SDR_SIZE				PPC4XX_NUM_SD
 #define PPC4XX_GDR_SIZE				PPC4XX_NUM_GD
 
-/**
+/*
   * Generic Security Association (SA) with all possible fields. These will
  * never likely used except for reference purpose. These structure format
  * can be not changed as the hardware expects them to be layout as defined.
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.
@@ -14,7 +14,7 @@
 
 #define AES_IV_SIZE				16
 
-/**
+/*
  * Contents of Dynamic Security Association (SA) with all possible fields
  */
 union dynamic_sa_contents {
@@ -122,7 +122,7 @@ union sa_command_0 {
 #define SA_AES_KEY_LEN_256			4
 
 #define SA_REV2					1
-/**
+/*
  * The follow defines bits sa_command_1
  * In Basic hash mode  this bit define simple hash or hmac.
  * In IPsec mode, this bit define muting control.
@@ -172,7 +172,7 @@ struct dynamic_sa_ctl {
 	union sa_command_1 sa_command_1;
 } __attribute__((packed));
 
-/**
+/*
  * State Record for Security Association (SA)
  */
 struct  sa_state_record {
@@ -184,7 +184,7 @@ struct  sa_state_record {
 	};
 } __attribute__((packed));
 
-/**
+/*
  * Security Association (SA) for AES128
  *
  */
@@ -213,7 +213,7 @@ struct dynamic_sa_aes192 {
 #define SA_AES192_LEN		(sizeof(struct dynamic_sa_aes192)/4)
 #define SA_AES192_CONTENTS	0x3e000062
 
-/**
+/*
  * Security Association (SA) for AES256
  */
 struct dynamic_sa_aes256 {
@@ -228,7 +228,7 @@ struct dynamic_sa_aes256 {
 #define SA_AES256_CONTENTS	0x3e000082
 #define SA_AES_CONTENTS		0x3e000002
 
-/**
+/*
  * Security Association (SA) for AES128 CCM
  */
 struct dynamic_sa_aes128_ccm {
@@ -242,7 +242,7 @@ struct dynamic_sa_aes128_ccm {
 #define SA_AES128_CCM_CONTENTS	0x3e000042
 #define SA_AES_CCM_CONTENTS	0x3e000002
 
-/**
+/*
  * Security Association (SA) for AES128_GCM
  */
 struct dynamic_sa_aes128_gcm {
@@ -258,7 +258,7 @@ struct dynamic_sa_aes128_gcm {
 #define SA_AES128_GCM_CONTENTS	0x3e000442
 #define SA_AES_GCM_CONTENTS	0x3e000402
 
-/**
+/*
  * Security Association (SA) for HASH160: HMAC-SHA1
  */
 struct dynamic_sa_hash160 {
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/**
+/*
  * AMCC SoC PPC4xx Crypto Driver
  *
  * Copyright (c) 2008 Applied Micro Circuits Corporation.


