Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061037;
	b=WWesir6mMM5rAnp+Rzt9RWXE01+ZWq/zA+I+um6Eyj/8iXFSbuLebp+vyu5mmPgSMGep
	 wck9hX6fnO9qorXlSHehxnkvfvOgXWjlQ4IeLBIfnjw9N+Gmli4ZBKfhdl3RWpYyrZTXs
	 QM6OwGS1nf5jygxntLfpbVcP8E4SsxN1VnC9Wu/Ik2rK2MiNZDRRlCSsGQvUr6F13yjiz
	 ULV4e2FTjhYbzB2C8RWIxSYb9VxZ3Zs/xxV0a/Vx2LaUDYrIbDu3pCYiJr1A1kHckLpNj
	 hVzWYYVgaLpBjBrcbf4g+6XSVWc9jsRpqswNMyG9ajNNtmYzag4e7hbdFgzFfAmEhvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wja4XIJ7JAwcQgerbVHLNDqRysphczCnLqysw5XmB6k=;
	b=3PB7ssbl8sHUM6Ob60WMG1L77xbLyPJgsBl2tjhwIx8B8SPfmyVxsSPrPSs1deuUTY4D
	 3utPpHykG4ozx8cCcD3nYiw2QjK7/sJ9+7qgS8VqeBBwTlSFsPI0/8qUsexYQ5yypmm1X
	 FNHitPYWRNTgKceHg0eO5MpXwWn8i9V0RZE1S0f87KGto+NMJLQoe1uK87HhFP0/vW06u
	 AR+My+1GZ062NttCflHHUGB/guZ6mQ4tFDfEdX/JDjwMW4M7qV9myEIw7y44QzZLf+IzI
	 BIP2Qzv24JyepFcZuzpmqXvdVhxK9ou4+sSFB0SvNh8MnXdE35SuhWSusEnDSXOS05A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9dIj1LG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A92606D825;
	Sat,  7 Nov 2026 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9dIj1LG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EF81F008A2;
	Sat,  7 Nov 2026 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061037;
	bh=wja4XIJ7JAwcQgerbVHLNDqRysphczCnLqysw5XmB6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9dIj1LGFsYD2555lTO6Qe/IgtjrY2pUYkCInmUzZwde0MVvoF8Mx5zurq4xAyBDg
	 tyHutzS9LtvIrK21jgkgdRsZCQtUlXZN0irRw5ubRQf/K+34dxQ8ngUriUyjNF4pbj
	 d6m2n3Aow2VtM/DfmeY/tntkp6kOe8VROMasb6yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0333/1536] crypto: keembay - use crypto_memneq() to compare GCM AEAD tags
Date: Sat,  7 Nov 2026 08:39:09 -0500
Message-ID: <20261107135007.050102530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9ef6a6d58c68e..f27b0044c561a 100644
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



