Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830916;
	b=Wmfgm4V35F3YunwrAI4+9IoB2SonmogJlp6yS4l2DTD5Ue46kPDDljpP7fg0LG40fR0Z
	 puTmARbhnBmYdAv8r5eh3sYvbuIj73mGFscNRWYc5KqYus+dS3V4mIkD+09nMRdtAWfPC
	 7vAVFMv8WVD+ur0qccfSkGbqoy5Y9fjqwgrZeC+G3zxYi56x7yPDm+P8ICeRDbGl7BCEk
	 L9y9G2xejjFl+hfk9+WdVHsVDtf8LjXz7e/xlhJKz+FZ6T3ZBaMu1shKu8GZcl/nSV/0q
	 tXxPWik8LpKNchv+8T9m7Jwlg6ShQczfVBxSRgYBvrxY4vFhGjoAeUP2wgULpINkzXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/b64ZUOdqeMkK89CcdwWWPoTgTtpwh9J9MQP7XNUJk=;
	b=dxA3Cc+PrIZZc9TpZnNsu2OiJvdt1UyMSPTCc1sP+mG8Sdppouu/QiraOqslMR+j5ZV+
	 SpODfxYngDRVVgdQ12ovH9HKe/o+PPhtLzm+oYMFjtxoL1SrlwgTz+fHWZC+8fqI4UNJ1
	 o/BEZTTjoC6Renxub911wKwaNAaUMUAeEOS3S81KZxSuGmaApS3SmZXYLcGMqoDehi1oO
	 FW7G96BLPzrgX8rJ+ykS7DOF0wiPK21pqIlE5i4zJ+17zIce27+Vv7XsCCKzzxnmEmMhQ
	 ibLVLGghjAr+9VPlsS5Wgxn0JKVDg9eaKbuDjjx5k6nuYwjuxyrnQ7mLmLeEPkU7X4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cThTFiZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA16606A841;
	Wed,  4 Nov 2026 22:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cThTFiZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350921F00A15;
	Wed,  4 Nov 2026 22:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830916;
	bh=k/b64ZUOdqeMkK89CcdwWWPoTgTtpwh9J9MQP7XNUJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cThTFiZbC6bCcF+7oXUEKM53NjYk2ZYmY9zB+/l2DF1TenbUl8pDBWKr2iovxI9Vr
	 j2Y4Q8JE9/unkC7RsnqF1gsJpvYiF4UHlMiXZwQ/6gy8pWjlubsP9EYSstqU1TZEgM
	 oXfkqoLP70+c1kYTnigP1ddN3kNFUKjWpMIf4g0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0400/1005] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Date: Wed,  4 Nov 2026 16:02:13 -0500
Message-ID: <20261104211055.276493607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: David C.C.M. Gall <david.ccm.gall@googlemail.com>

[ Upstream commit 7064af16d2b418d61571dba9bb0116a547ade124 ]

Use crypto_memneq() for a constant-time comparison.

sa_aead_dma_in_callback() compares the computed authentication tag
against the received tag with memcmp(), which short-circuits on the
first differing byte. An attacker who can submit decrypt requests and
observe completion latency could recover the expected tag byte by byte.

Valid tag forgery for AEAD breaks the INT-CTXT guarantee.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 73034aeb63862..4a766e4351970 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <crypto/des.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
@@ -1688,7 +1689,7 @@ static void sa_aead_dma_in_callback(void *data)
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
 
-		err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
+		err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
 	sa_free_sa_rx_data(rxd);
-- 
2.53.0



