Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585414;
	b=AWjEOwF8H1AYLlQYFDEcHZ/Evj9iIFSYQrrjxB2aPBDCaXC9lZPWdRPSuN49aB5FKWda
	 QT/UjzgVcfaxilrd2x3KbgdcS3kpRZm7g8Sl0fqLaLW6BNtX2RbtuJVVZJhEBPINAOMTY
	 hTC4Q9Cpm3QyoQgbeGBXWX4ScXE0qcjEGsh9F+RaKi+38MSf+vAs0/M1M+I6O4h7D9dPT
	 BvZvr1RB+AaaLn6DKAcrLIBmNeywGegV3Jri5alDlAyLGziXaQg4hc363KINEZtlDJ+wT
	 1eK9AkfdPcZLsThffSmeOYcXfoAKu6nlNDEvrhiaX3HIt20b4o77QiSGFQ4rrsmu9AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBoTnikl2Xohi06t9cpOIa0kQ/8RTvLmhUXu/E+gFQE=;
	b=a3d7mRfUxMNl4d5S6Bf1gfr5uRxpk85YSdgrJaavtf2iKxAYwZ7bJubOqgdIo/Gmcz3u
	 2TXsYNUAyqAMAGmhe2t/yA0FIbxGzsWdrchVb2F/YBeJf2K4qK+Nnsbq6ivEwh73pYyB7
	 pKQI+nXjJyugkGTsj5ds/BAbSTULCQmdL1ReckcQe/jvTKoJHJUwYfC95AL+m/sG/m/LD
	 m6VUCb9hE3PBIx5z7p5in5x4zJZwKfsdVkBuZ9ByFAlGNxFCozIfZBQILBKemlzkPlHJU
	 3nG0Pha8UWJgdkA4gs9oFLzjuufCk7EMUn7xcbDwdqB7uDXpq6+VtMcWERMyf4E5p/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnAGqAaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D2F606B2ED;
	Fri, 13 Nov 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnAGqAaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A001F000C4;
	Fri, 13 Nov 2026 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585414;
	bh=cBoTnikl2Xohi06t9cpOIa0kQ/8RTvLmhUXu/E+gFQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnAGqAaAVFJcBBlR9HUMcR6y588/qxQRQoNjQa3Qfx/2TgYYVD9gRdkO64VtUw4Nn
	 Y9Ovmxz95dIQp2ff/tGfXLaYZvyMKN+D4E2c674AJqoiKmhyCkwTT41INxVjY5weP8
	 KaGXd5P4qMF8G4rAWJCUCWMDG39p9CNMtZzOmq7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 080/507] lib/crypto: mldsa: Explicitly check that alg is a valid value
Date: Fri, 13 Nov 2026 10:46:24 -0500
Message-ID: <20261113153756.463014934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit efb621a57d7e4ce28e12082ba5692231858c4a3a ]

C doesn't guarantee at the language level that an enum actually has one
of the declared values.

For robustness, make mldsa_verify() handle invalid values of 'alg'.

No effect on current callers, who always pass a valid value for 'alg'.
(Except for the KUnit test case that this commit adds.)

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261029054534.68481-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/crypto/mldsa.h         |  1 +
 lib/crypto/mldsa.c             | 10 ++++++++--
 lib/crypto/tests/mldsa_kunit.c |  9 +++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/crypto/mldsa.h b/include/crypto/mldsa.h
index 3ef2676787c9e..e0754879e7452 100644
--- a/include/crypto/mldsa.h
+++ b/include/crypto/mldsa.h
@@ -48,6 +48,7 @@ enum mldsa_alg {
  * Return:
  * * 0 if the signature is valid
  * * -EBADMSG if the signature and/or public key is malformed
+ * * -EINVAL if @alg is not a valid value
  * * -EKEYREJECTED if the signature is invalid but otherwise well-formed
  * * -ENOMEM if out of memory so the validity of the signature is unknown
  */
diff --git a/lib/crypto/mldsa.c b/lib/crypto/mldsa.c
index 68a1b432315b1..80e0e63b418a7 100644
--- a/lib/crypto/mldsa.c
+++ b/lib/crypto/mldsa.c
@@ -528,8 +528,8 @@ static size_t encode_w1(u8 out[MAX_W1_ENCODED_LEN],
 int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 		 const u8 *msg, size_t msg_len, const u8 *pk, size_t pk_len)
 {
-	const struct mldsa_parameter_set *params = &mldsa_parameter_sets[alg];
-	const int k = params->k, l = params->l;
+	const struct mldsa_parameter_set *params;
+	int k, l;
 	/* For now this just does pure ML-DSA with an empty context string. */
 	static const u8 msg_prefix[2] = { /* dom_sep= */ 0, /* ctx_len= */ 0 };
 	const u8 *ctilde; /* The signer's commitment hash */
@@ -537,6 +537,12 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	u8 *h; /* The signer's hint vector, length k * N */
 	size_t w1_enc_len;
 
+	if (alg != MLDSA44 && alg != MLDSA65 && alg != MLDSA87)
+		return -EINVAL;
+	params = &mldsa_parameter_sets[alg];
+	k = params->k;
+	l = params->l;
+
 	/* Validate the public key and signature lengths. */
 	if (pk_len != params->pk_len || sig_len != params->sig_len)
 		return -EBADMSG;
diff --git a/lib/crypto/tests/mldsa_kunit.c b/lib/crypto/tests/mldsa_kunit.c
index ec64e10c97f25..d0ee704a36944 100644
--- a/lib/crypto/tests/mldsa_kunit.c
+++ b/lib/crypto/tests/mldsa_kunit.c
@@ -372,6 +372,14 @@ static void test_mldsa_use_hint(struct kunit *test)
 	}
 }
 
+static void test_mldsa_invalid_alg(struct kunit *test)
+{
+	KUNIT_ASSERT_EQ(test, -EINVAL,
+			mldsa_verify(MLDSA44 - 1, NULL, 0, NULL, 0, NULL, 0));
+	KUNIT_ASSERT_EQ(test, -EINVAL,
+			mldsa_verify(MLDSA87 + 1, NULL, 0, NULL, 0, NULL, 0));
+}
+
 static void benchmark_mldsa(struct kunit *test,
 			    const struct mldsa_testvector *tv)
 {
@@ -414,6 +422,7 @@ static struct kunit_case mldsa_kunit_cases[] = {
 	KUNIT_CASE(test_mldsa65),
 	KUNIT_CASE(test_mldsa87),
 	KUNIT_CASE(test_mldsa_use_hint),
+	KUNIT_CASE(test_mldsa_invalid_alg),
 	KUNIT_CASE(benchmark_mldsa44),
 	KUNIT_CASE(benchmark_mldsa65),
 	KUNIT_CASE(benchmark_mldsa87),
-- 
2.53.0



