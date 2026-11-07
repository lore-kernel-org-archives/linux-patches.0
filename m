Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063958;
	b=jdPif6ak7gYZnN7yG+K9nDx6QHMzDbt03M6J7A20ncGBQOq5qpRrdI5WCkh4ObuaDogK
	 +zTXf1OwrTAM+goXactBnbFEKUN0ekAM0QYRazZmVD9ChlKOy8HBF1PaBKSP/AkdjFUQn
	 sYZzabDCldNYOAvaBtJ4ppkKCPJEudAu211/rCTvx+P80BAYZcEUGSuK8gyoMGLorpryW
	 pucjXtagIWupRMjM17wbk6VYe3pV0DkzTMAoZM6VUV/vtR78PruBvy79O7h2CFdt2XDmo
	 LSRGWLlQNB5l7HLZbHLxgqDSV2wHB6CTxSgYQk0wHMHDtiGuCfNdTcRMVhI5tTYqzaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUL89zczg/+10RA+b9ON4Tn8dlRAumVcCfUHb4BlrOI=;
	b=hgyiWI6v3BNXcSD6xOpaPAs/ltuMqAvuFRWQq+r8COpLWJHOaxx/rZ4v25/cNOf3kZNw
	 h2qPWmT4hMcVzy7MWFWvM5PC1BNAMPBKHWsK+dQLzPQH49Nmpnc/ExMJhIwepAe6Wupqv
	 VFdbEkjgY64WjQpdlyEYXFH73sxFHv0EOxWsm9pebzmbIDBM4Wj/usGN0fd5QE97JOGn2
	 6vmk+wW8xMxO3MMuthFTUFRAUW+eVx7Ko0YVeWERn6dZm2Fbe27fHGYZzA7A85TJoEjmO
	 lvWwV8LrFrQf4sQe7rTwsLCdUPKB4MU9sVoCMNTnavTox2lhJc0hiYeDA7+yEn4vaqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHh4Fses;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03B3608360F;
	Sat,  7 Nov 2026 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHh4Fses
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498BD1F0089F;
	Sat,  7 Nov 2026 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063957;
	bh=tUL89zczg/+10RA+b9ON4Tn8dlRAumVcCfUHb4BlrOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHh4Fses+YLQqExqS45vse9gBqf+TWKBTOCZlN2cStMsKYBJppMePyVgS5sOToHGr
	 +SIydBWY75x+WwpW0aAO0aFT00stO8tA1hVKrkiYW0muqzdccqut1WEJLV5kVhz9Iq
	 VzLqOrJRz+zrg/AhSkw7JSH983c8NayK1Cvpvfq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0146/1257] crypto: atmel-tdes - zero-initialize device state
Date: Sat,  7 Nov 2026 08:40:42 -0500
Message-ID: <20261107134943.344658991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit dbe70508d507acd677e67eaf029040f5e3a3b2b3 ]

Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
device state is no longer zeroed.

atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
every request queued and never dispatched.

Seen on a SAM9X75 Curiosity: the first TDES request after boot never
completes and the TDES interrupt count stays at zero, while the AES and
SHA engines on the same SoC work normally.

Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.

Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index ffea1db74651d..2756dab3f4c7f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -933,7 +933,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



