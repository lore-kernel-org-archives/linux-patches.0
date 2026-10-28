Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210576;
	b=aDf+Z4jfmDg/k8xY1ZepbIZt8buiNFL10tnR5RBRhJcdGLlPXnUDOhSSjCq4py0F0W6r
	 rez139ZSOu1snBPAdGl4cMs3sKysocsYNLiuos0AiiJvBvwx5BnJh9EJBR7qy5caMBGrP
	 EU5vhGSpHEPRWJJYCid2q9v7Nl/bkyVs7hPCOtqpIGhyaJrOkN/gHvkiP++uUebnX2/wh
	 dGZBkkzuzSZP8FNjUaf8TvmLca4ctDQOlUn1W15Yf5JVVJogl/oUdeD/ykP1WV+wvYC0C
	 SdoGAvFCjSYZfeORAbB299ShisPlOmPYLP+aiINlQ+L0XnrUAGtWZTmk3lwHYxAhpVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NVP2ockrnfuDJ2EQmKLFzIHnco1LjYU6VtVYFshSjRc=;
	b=Bg1aAutO4IJdNuH2rmKIcnFpYDRYv6VM+Ma/eppfPARiGDmUMhSazD357aOItCwFsPxY
	 ICCSUXx4b8in6Pu5zKXH+IRU9sClAZxjRRm0keBC9kSIWo2h4v+bHGIeJ/xNx7YHgTy6S
	 Fl+yrQJnMiXCSptiuhdmdc3vRL2aZDG6okf2IrPqhAWO86dc+9Uyc4zFJalllxYLNND4t
	 ljVPGyBOPzyn+IpNsraIJlcstNMvzOu/h82hCR/Q8tGZ1MsotgX4QYAoVcpSvd4QhgJWS
	 8CjU/TDKYHOQ72fEe1zNtQmmawPH7O9wkoG1otFGYGIgt8ofcWuZVT88gH3IqSAsUaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zhKOayj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA6606A31D;
	Wed, 28 Oct 2026 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zhKOayj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1CF1F01825;
	Wed, 28 Oct 2026 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210575;
	bh=NVP2ockrnfuDJ2EQmKLFzIHnco1LjYU6VtVYFshSjRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zhKOayjiYKHs5Vc0p0W7bM7rJHnPAagdaFHG1HhcNLpP/x+t/gsS9KhdhU88e2xQ
	 7YtjROKcsjSXYDTaS3slXlK6TmxBEUuvUhpMz6kHNb3Zr812kFUf8y9w49TiDq8yUG
	 g8ZAeBgVxQMXVTZ9ECkHjn2foklb5TlIWM/ZKKow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/571] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Wed, 28 Oct 2026 17:53:39 +0100
Message-ID: <20261028170009.734826015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 1163a476a568f6c0f852d469c8e4c5a5f805adac ]

stm32_rng_probe() enables autosuspend and runtime PM before registering the
hwrng. If devm_hwrng_register() fails, probe returns with runtime PM left
enabled and autosuspend still selected.

The remove callback also only disables runtime PM and does not undo
pm_runtime_use_autosuspend().

Use devm_pm_runtime_enable() so runtime PM is unwound automatically on
probe failure and driver detach. Since the managed cleanup also disables
runtime PM,drop the remove callback.

Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ adapted to the older driver’s relocated int-returning remove callback and existing err variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index bc22178f83e83..440c001c746b1 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -156,18 +156,13 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	err = devm_pm_runtime_enable(dev);
+	if (err)
+		return err;
 
 	return devm_hwrng_register(dev, &priv->rng);
 }
 
-static int stm32_rng_remove(struct platform_device *ofdev)
-{
-	pm_runtime_disable(&ofdev->dev);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static int stm32_rng_runtime_suspend(struct device *dev)
 {
@@ -209,7 +204,6 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
-- 
2.53.0



