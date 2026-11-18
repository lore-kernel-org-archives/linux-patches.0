Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034191;
	b=v38mUJKA7nHkW5kQRIjzmFjR+WvxdmGsq8y7tSvXyjTnf5p1by5qumtl6ot/7FaljwNr
	 Na5ZCEPjw/zawLHdNp1N183oQqNzQQYbycX0NdO+1D/AXvE/KBRtLX2qUr3qSndGFKq75
	 AKHonpiVl5v8y4xDBtvWCbVYMpFmOFfWAcbPmF90E9jOozmoOQOy2a3hfzTPrWQxmwnwO
	 qqxXllZoLLEJizll3x1WOBcPl6TTcyJyPYbSLBWMLxu31ATC63+sZUswGyS7yU2ZUbPq7
	 W31XTJgjFI6d4cpqARepmKT9px3aa1AvOlzcVxwqMgaoTgQJXDth0Cjj4YaDp8KigOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WS3bIlmbO3Yv1QNDYKxQtJ/v3lzdKrL//i7ymM4jiss=;
	b=MY4q2zn6CvJrlANm8LW5WnSY7a6IWCqEDNsvyOhZpt4a/8AaFGXarpUjriKO3s0YJqfI
	 mVbdN6WMfAJsmVYCd2dQan4d5HsMX4svM3AUwoKw7YqbtpgdZgF6rNPSiYD6gvn1eIfCF
	 Kh9HRx/5uw0J1S9O/V1NUOC7h1kGV9d+DMqT383EQI3RbeHyTFI7oyXgxb2ov8J8nfU4A
	 G7pnJ7gaolmQNEKnP5LLmJV09xa5wQZvPRKM5/YPHH5B5nFvgguKLg/rayeuq/OCn8DgI
	 HinJXtddF05allpqLGMacL4t/bnfi8k2TBO9h2i0p5zAThIGlT8vKDM5ZFFN5mqZ+8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Od/71UgY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338A060A383B;
	Wed, 18 Nov 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Od/71UgY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5021F000C4;
	Wed, 18 Nov 2026 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034190;
	bh=WS3bIlmbO3Yv1QNDYKxQtJ/v3lzdKrL//i7ymM4jiss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Od/71UgYt/otg+KLGphvvOK5ZnAbY2Y/ysbMtqSHjr+VFsty0eCGjaS0yTE22Fejq
	 kqDK1StYvAlseC3aPlPT6pfRPeODtYwtg2flM4Q/m9l0rp/+u0AZytTAUdtUQe9VIO
	 U12T7fssj4q3FtfyAuxG25MU7euzltEMylOFm3Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0281/3318] crypto: keembay - use crypto_memneq() to compare GCM AEAD tags
Date: Wed, 18 Nov 2026 15:15:03 +0100
Message-ID: <20261118150323.953050110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David C.C.M. Gall <david.ccm.gall@googlemail.com>

[ Upstream commit 353b3a85136f2a0cf3e872acf8ad6c1dec0b7a8e ]

Use crypto_memneq() for constant-time comparison.

The GCM path in keembay-ocs-aes-core.c verifes the received
authentication tag with memcmp(), which returns early on the first
mismatched byte. This leaks valid-prefix length and allows for valid
tag forgery which violates the INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 2003805f08daa..87cc75aaa4036 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -919,7 +920,7 @@ static int kmb_ocs_aead_run(struct aead_request *req)
 
 	/* For GCM decrypt, we have to compare in_tag with out_tag. */
 	if (rctx->instruction == OCS_DECRYPT) {
-		rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?
+		rc = crypto_memneq(rctx->in_tag, rctx->out_tag, tag_size) ?
 		     -EBADMSG : 0;
 		goto exit;
 	}
-- 
2.53.0



