Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215939;
	b=oXnfIU+JWpSjkRBJQ8QQtO75WRHaoCF+pjhjTfVSgfvNuvjuinAjbaoSfHgYRXzplwgm
	 82Y3uWkNXhKPW4cDxG2UTeO7uqCpVENhmNGEqUaRtmeWVAUF0lxEQW08pLa71Dp5ZS+UU
	 pA/k07/16uoT648iOYFghvWVAu+nQwFdjBv2XwwMqlwN9zIH9AQqLBBshH5oNz+Amd9SZ
	 XlMnaV/MQEk1LdpQJvRjp/FC+hr/lg2pOycnEWZzQQrb3k+gY7e18jVGaF/D1KcafLQ62
	 J4ZiCjCx9dp5bD75lkHlreLmyLhOLHv4X72sa/picVc+c8rzJ5t26Hf8o+7ex9Nd9zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ecAz86FbxkDtARFlz7YvuGwemGxecH2cwCTqTOqN5bk=;
	b=I2XPh1uucm3YOTxPpBH20AGvJwmzJNHaqsdxz0BqYEHklSxqps4spuqy/HQ1Vr3tceHN
	 1A02jceCTkdwnTU5UGlchrnu6k8UG2roNf9i/tUqEtYrbLWmijK86nuEKxPbWa6GQPTGb
	 tx4Dr2seSkOV4mTC8KajTxTx12vhVBo0E2HXjvCQkKdZa/2g4aApSDIlhEctLQ+gb7TOP
	 cksB0LFpJVpsObmIldEHv1O1kbgOf7aOUjhNenmriD2A9lF7QrbWwkOuZ6SXT8IlZWOz3
	 9p43QBxaXk4m8OOIl+c4tZbzv17SS9iCG2vUX7iAkERxxWuxOemL+89M+nvOknF5K5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T8q/6RBz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8C8606A31A;
	Wed, 28 Oct 2026 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T8q/6RBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3C01F01825;
	Wed, 28 Oct 2026 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215939;
	bh=ecAz86FbxkDtARFlz7YvuGwemGxecH2cwCTqTOqN5bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8q/6RBz7waeEymnQtdvH5+fdVGpqi51nFFLRceeu2swHvi+yAuo/ajP7gTM9g2gs
	 qYpGJ0iIvlo1cgZiW+7TZMuPfm69IgIC7aXIm3N5i+h4PNCco8CyukwxLetK/qzUw0
	 6BSPa5xOHiSyc+5xbrU5Lay8m+f7geYDsUaawipc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1385/1887] power: supply: lp8788-charger: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:58:01 +0100
Message-ID: <20261028170530.962571525@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 7810ba3c5110ce66652ec6bd2abb92da5d726c3b ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230918133700.1254499-17-u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 831c29a12d56 ("power: supply: lp8788-charger: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 56c57529c2287..3cf8cec8cca6b 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -715,20 +715,18 @@ static int lp8788_charger_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_charger_remove(struct platform_device *pdev)
+static void lp8788_charger_remove(struct platform_device *pdev)
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
 	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
 	lp8788_psy_unregister(pchg);
-
-	return 0;
 }
 
 static struct platform_driver lp8788_charger_driver = {
 	.probe = lp8788_charger_probe,
-	.remove = lp8788_charger_remove,
+	.remove_new = lp8788_charger_remove,
 	.driver = {
 		.name = LP8788_DEV_CHARGER,
 	},
-- 
2.53.0



