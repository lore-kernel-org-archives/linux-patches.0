Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062852;
	b=U9gMLcpOgYyGNEPAWqnOkQ1Q7vWiVkobBoGKhLCKT/Wy2xzz9lnCl1RkioDW2jkaEo8A
	 T0HVSBiupkDgxQmxuMVt03MfjV72PnF2vpaMTFkGr0g8+k8uPliTGoLASsoysIKhtzIco
	 s2f4rNoy0PrbmT3hGJqjIN02/nLaJ4ItuwCVzMq59+gGidg6q10hfTilnz081R6YDwtmo
	 fJSi+m49AP43HWqgkNwAhDsyd1OowgMyr1DnaUE9jfz6qdsWGuxXhRTuwSHHwNIwmXpLM
	 H4Tpy1v/RJ87k4Ps7dlRKQn0LZMnlCf8ZoyRWl9zPPS4x3ojGZKf2EJ7bY6tX8yu8lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2m7+DPj1qBB/C0LXWVsNTvpDLlf/aUHcTvvhlA7otIo=;
	b=Xxb1St0B5N2BBwo0rtsGEdPkuprLCVXhDWBUIGKXAj8Lm4CjD+tujt4kXBiEVJ1UNPFA
	 bXFJD4zMmBIBnk8v8kf/HsW1WKo+Q+Vpf79cekFOJQWm9vt4nR2UVVLgSVLve+3goC9T0
	 yvzuRsuSGa8zAi7z7E9m/eWKwW6o12YUkmP/G+pcEwLO2KVZxeM4wLjZKuUEYdH5WST2K
	 KfOtUL2rh2tUdDyX4SoeRO0xkXeK0lVGQ2ucgSg6BYNJ31NMW1BgiLzd02gQQIfidztL0
	 8P0eP35SF9lKYYT3Akx+0M13HUdmizx/4e7wSWLnzmkXXIO9A68KePSkHptL061GjLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HunVAwok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C7606A333;
	Sat,  7 Nov 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HunVAwok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3818D1F0089F;
	Sat,  7 Nov 2026 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062852;
	bh=2m7+DPj1qBB/C0LXWVsNTvpDLlf/aUHcTvvhlA7otIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HunVAwokQGXSkijgU/UL9cOhf5TP7VluFJ54/pARYriw/HHp7ktklh7t0Uham935v
	 AF2G1cSVypzvFYXTQwg33HB77Xb2CeqqohITQ5XY3Sy+uJ9ODE0plzKCFUj5ki4A6j
	 TMKddpVnDqwVUNieOhy+IOudJN9p3YOu20JQIJi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/869] crypto: atmel-tdes - zero-initialize device state
Date: Sat,  7 Nov 2026 08:46:48 -0500
Message-ID: <20261107134856.760984726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d380f6741a2c5..72e91e0bb1b47 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -945,7 +945,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



