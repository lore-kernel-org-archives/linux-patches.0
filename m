Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208303;
	b=20w5zv4JZwbtb3lQS0xSu+LcfEwvw8P+JycRS99wGY14GfVHsYsGgQoBO4MhoYi7Io1c
	 JyLb4ZUn5/oZu4ogiCVdk4Ys0B9wV1BR78e3ZWyBuNYjFVP1Yzbreb0ycsSXW+C42CeHE
	 WBhNH6uJE8kyXigzVi1CfCjjIv/2a4kPIZU+qp3G63QtFqVJQOy9S4tp3xI+JtEDWreGr
	 bJDhzE43uv6ZHJ4WJSwrwHDG/yLUlHqVdGflDBBt+Q4PSYG/mg3xrMdaiXmOc2rdnbpyy
	 WOa3CkkN+RHztBTqq42/gzmbAahZWIGktRrhR4vtm0ZLSbgy3Av76XAkH40+Ud16kgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DYNZdyVfO4XD1f2DQtRDBH3QuJwJWvmLILRYfVwIuA0=;
	b=mtENzRFOlzuZQRKvwGdcqYQ1UXELqgpGas7qxcMbfjERLn+YkGU0p1QdVXLRUnLxOw+k
	 DsFFW5Xp8TyRcy5zukfB+vv5nN+FWaHOjF/RPrSaDXPL3nW1eJ0HWBrixpeKVzD9zYU7l
	 qXccN5fwMyfM8a4UVgnehYs/Rd+rykVIoY1tqLYyMIyGxHH/2Gr5FuinZhcXVVoJI5Ddr
	 vVMeXLR8rugTrVRalC7AGP8Rt9oUGjmw1Q3LXuzxBQ/OrDPRx89XPkABQHkxlURjPSnwl
	 50Hs3YGOJPCAKaiVcCuuAvDkfNlLxyqGcJAHTy3riw3oIZ82atYyfzY/vZYbG0L8DyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Rqs4G/Hy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C9606A326;
	Wed, 28 Oct 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rqs4G/Hy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FED1F01825;
	Wed, 28 Oct 2026 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208303;
	bh=DYNZdyVfO4XD1f2DQtRDBH3QuJwJWvmLILRYfVwIuA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rqs4G/HyW9Ao/ftWj9hGDF4us1yw4xXtd7ZzbS5YTzjTANV9Vo2TbFX3vYfNLs3EH
	 DxBaSqrB28riO5z/BhnB27fZRA7znU4Tk0HowvREMQVHS0Dcr7DWQXnQmY9IyMAqOU
	 A1myfqN/8wxqh1oFXuoy1uMl9DkfQtf74UieWkcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/516] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Wed, 28 Oct 2026 17:53:44 +0100
Message-ID: <20261028170005.229118012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



