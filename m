Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034342;
	b=hCUFegtsie2jA3wB4DdDQtrWJcUCrZy4KgNcKbgiL76r1Yx60D7SsOSjEvMGbFeKsbkz
	 m/vw1q8ngy2PUeAGbUMjoYoRhY7ak7nQQrHOAE+9ueqL52412uP/SFELGHed/m4VAfUht
	 2s78bJb5tbK03WskCu98wbhkwMX74cJ5nSzNptY9j8i6c0Hjml6amA4PlwBlZaqHjcDjJ
	 l75RTvN3RlD4gGaTrj8czs48VCxz81ggcQvSKC2XXJNBcv14EfdX8fmziWBmSHhe6HYRB
	 yQ7GtVkf26TzyjstJekUJNhH7lUbQFmDykG7KzY9Z7wDK3R2I15RUi54VJj+vArlijg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQdGLpjU15tw/JoaHxEsOtyKdS1Fcvfc1MkcrUay2QU=;
	b=w66SFSXQsfuzx8y/8QAxxuAJoscaOxk2X/wY/58OGlhruDWC6KFpYlDl3iKQ1GA8mGFE
	 MftVv084d2plZGqJm6pb6+r6tKPnypOZT2G3z4LmfmfbmMw8Uj0WoT5vvQXBPQcvTGvs8
	 7oBqfogCQeBpp8RpbsgTGR7IfnMJb0jUzAIkNhLSgi3y/dPvmIcioC9gCWMqrG9LgB/9i
	 TY4z3+fqf4SQn8kawpYO8JBrf3uN5hq9OZaTPVVtA0slN0yWhMiG7YoSQv6uEXmmuVbCj
	 duZa5diTLmKEsKpYNWtbwfFOIUx4/WoiBp5OMGjFakerd+qqOM2ioVlktoJFc9T+6+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU2J5cRH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E062606A320;
	Wed, 18 Nov 2026 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU2J5cRH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3381F000C4;
	Wed, 18 Nov 2026 20:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034342;
	bh=kQdGLpjU15tw/JoaHxEsOtyKdS1Fcvfc1MkcrUay2QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gU2J5cRHv7QEc2e6yJyUQX3DpSCm/kZcwoOAt+C59RSwwkROdN4t9scOcw0WeyU6G
	 pnAJm7W9IDGFEK81r7mEk7ZN2vsXTbhYW4pC/g1cTxiFRl/b5046ioK4IklScsLiTI
	 ow5nWKA4lKi/XBcUEm+/RLCiB4N3Mgu34uT4Ja10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0284/3318] crypto: keembay - use crypto_memneq() to compare CCM AEAD tags
Date: Wed, 18 Nov 2026 15:15:06 +0100
Message-ID: <20261118150324.068251829@linuxfoundation.org>
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

[ Upstream commit ff2ac77a034e03b64e2ba34f775097427dfa5547 ]

Use crypto_memneq() for constant-time comparison.

The CCM path in ocs-aes.c verifes the received authentication tag with
memcmp(), which returns early on the first mismatched byte. This leaks
valid-prefix length and allows for valid tag forgery which violates the
INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/ocs-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/ocs-aes.c b/drivers/crypto/intel/keembay/ocs-aes.c
index be9f32fc8f42a..b159d949d6246 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -16,6 +16,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
+#include <crypto/utils.h>
 
 #include "ocs-aes.h"
 
@@ -1282,7 +1283,7 @@ static inline int ccm_compare_tag_to_yr(struct ocs_aes_dev *aes_dev,
 				 (i * sizeof(u32)));
 	}
 
-	return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
+	return crypto_memneq(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
 }
 
 /**
-- 
2.53.0



