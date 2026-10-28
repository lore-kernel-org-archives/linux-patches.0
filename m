Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212255;
	b=Z5cxrvlOHulgaIyGG1zQuD4tBrKoR0YisOhp6vQlm9mtYrphs01mU6rZrpP3SHoTXpe3
	 APDMDh+q7jzhdAxAQMYmeY8RzTWakUi6LdMXfBuuG8I50H3j6EVbs1qqt5RJHKnCvLlEK
	 btk95hbgWCaRkNPuNDiSZ2W3fakf3j5ky5m5odSk5yzMGXLbV4mRciu9V+47r78+w9GhB
	 mq03pQ4pZ8FZXwENZQ2v4jrBizWzNfhgr5JpIZ7DdaPTlI324/C4PyjMxTbZSHR+VnzHk
	 7mU/WMdjRAytCXOI8sdSYZI3vwvGv3a3IcUmM72CThsbRkXTlNKoqjRFhdUVbDQFe5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5n0l88v4m4P6ZpNECJ8FHgFLcWN6X7uXv1Q1bCEqOtI=;
	b=1VqT4N+QunHXOOWn83trWmZ2XQY6Uah85yHgqrkqFbnm9Xzjrg8jNdXpLoNyM4kZYkE7
	 /78XU/F6GG2AHSMN1ErsmCi1gJdXjOTwDuc4j5AAKCMfJyp79yS/ibw7EDQoixr0LF9Uf
	 5h68s7y3uLTvaYiMb29Y8hOfbzA+R9R+Pf34LUVuPJJ7dwWVSbladYfpcLns6xBD6wdzA
	 smYX1J/0FmI/G34cz6Bub6/xclrnvhCRoRqqhewr3y8xUTDQlvYYjF6jjw8OoVbXaspPf
	 mJ+SjWlywBPW8+uPNaFWXPOFd6Wm7aI8z5kuOY2NsXDXlMcO7P8xVoVCGKTYM5GGs2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0GWr//C+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0A2606A321;
	Wed, 28 Oct 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GWr//C+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5511F031E0;
	Wed, 28 Oct 2026 18:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212254;
	bh=5n0l88v4m4P6ZpNECJ8FHgFLcWN6X7uXv1Q1bCEqOtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GWr//C+7L395l8N2X6QcIhnrEODY1YqO2SDkx02Tk7bo60MIYU3bzulKkaS1K8E4
	 Rt17OdbM+DVM5ay2C0rIzJfKdLsgmShgEpaHRINZriNsl+ZCBf9jnZglzN9pJYriQd
	 OZL22tHuqlDk0JZC0L3+ar8THUYNmEm1Rfa+Z3jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0091/1887] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Wed, 28 Oct 2026 17:36:27 +0100
Message-ID: <20261028170501.305653954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



