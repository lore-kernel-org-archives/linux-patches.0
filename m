Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061117;
	b=ldWetcBImZ+dkCpAok833Re23tk0cwgNECaL7Gj8NTEexdgvVojkroawYznrKJ+OU0WI
	 mith/Pwz3Bmy0ZQK+shGVj13GtMuaTqJ6n4cz/KjOGFu36J5mWcJIg8D5f5GGfyL3alfz
	 vfGlSlwJlPsCWQr4jDF6Nbn8718gSTCrDyUKpdVNjY7FQ3FUBPE0iXzD4GCcxLTGVl//T
	 ciD9c/UY1GECuAwg5UgeQE8cpJJ6KOeqSQGxhV0LM/J9+DH16xkXgWXu5YasJTqEXaJve
	 vD116iFAOAa4Pv8FEpJbrFg0/g9FgQI9BCs1to+KMNWR9NYEqSX11sgmGUIqvxPhLMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mABp5Tc8aS6Xul5um/2os+83XDbzeZ7E7G/NOaxHlf8=;
	b=FzoNTkBHLCOsAXK8Nlhb39fNYyFkSTvcQYzpv92xyM+7XVacc4xGHQb23vy25uhQNt1w
	 NHedDrOiIT1S5DiCUxoTlfnnFmqRtmif+HKbXWx7Oq7ZbfakBROaDwJFRtwngqQpOj/WJ
	 iafzkbNoeVuU22OkzTUbsm1wv3rPUk7/mtRrUrOwhzwhc73PZgdPXyRdcrc40Y1cU2E6T
	 RIm/AX1kFMxaN2feqSkh3FMMFXXwarUNsPihJJfGCyx9ErIxEVlbfYprtnY17YBIBqCIm
	 3j43aPfG16gJ46pIGexRO62XhNEmqwD8v5fdEed0q0b4HZ1jRAWK/WQ/sDRu52JVpiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+2LCvMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC4606A325;
	Thu, 19 Nov 2026 04:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+2LCvMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4111F000C4;
	Thu, 19 Nov 2026 04:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061116;
	bh=mABp5Tc8aS6Xul5um/2os+83XDbzeZ7E7G/NOaxHlf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+2LCvMoiTwSDkj4YFTiSjPUvilD+SPehlQtP+p/ej9ZCj6JKTw6HuWpkCLG2Wke8
	 ttpkmAH1l4osWRzSsAjpUvBZoeBZ9NfcTOuPVS0yMUKHgBf/r4vh3EiEO3Rf5A8Y6x
	 skHEubS21z/nu5ofvUGsZty9W3v/oAqObih1qItY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1438/1848] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150019.691528538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 995811c2acb71..439e412700e5f 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



