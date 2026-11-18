Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060584;
	b=xpSwedYOSP6885q+6n9hD6Jbp0kz8gFCAe7IYdutoClXpm7WuMrhFQ8DZZhD//Rms5B0
	 rEkTTfhfIWPeXBtaH5nAOJUh4gY8tWYfiznhzbV1lmxmUkR3HKYVVJuI4rVjrKyaj0EtA
	 g558XjbN1F9rKTsdTEPKab+pRT6DQcLsir46YxkEKBRythDODxdjk6S0Vk0nKE42PPnoJ
	 sm235qIvtTk9oTH0apmcSMQVO5OK/f/DYR1ONIdGyzqgaeP7oNGvRYlD3geDNUHvNeVWi
	 csIgmCHOiBZU/MKLoXecfi2WY7sHndlk+156GanCmvaFRin9u8RikAXW1XZ2acCMlsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uF90nmRaRTjqLnGJtkboUQrP+QjOtCH9rlBZ0iy48Ns=;
	b=uu+KtJ09AlyvchMwGR5Yt+F+01pXcuRlcBqsOGMITrItADjlBAqzeocBu8cD0ZiGNYJC
	 QtAWuMXyHPoziszhfbn09UaPYBBZYqGC3twpUml8sOBqOlfEnKWLejoyMeMm4VuCmhaIh
	 7UjS/+Y0PwcuBCvlo3HN2nc3NL20ebskUVP31MrTWf6ikZJSDSvxXR8scqVsASZt8mLSb
	 UE4D3dP5Y/imZbNjYAt8ll9lKtdSwbICGDeZK6G0/4kj7kWeBDzBonNn6zng7/tXUXs/o
	 QdCJa8GS+qiAwuVnuVYC8+IGb+IGjo41ZPWAmBVZXw8Hm39V7QLntEN+7jd1aS8yDiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9KsxajF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67A606A325;
	Thu, 19 Nov 2026 03:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9KsxajF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8051F000C4;
	Thu, 19 Nov 2026 03:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060583;
	bh=uF90nmRaRTjqLnGJtkboUQrP+QjOtCH9rlBZ0iy48Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9KsxajFf66J21BMuphQH9H5bE6R9/ag56KD1zn1OPA68beiIzRUhnenCrVE+u0Oi
	 XMhnVpsTzWB9/WDsPSrBln3STIMu2ctl85hH2TGQV4IYF9vVej/+ClSCVtiUMALedh
	 QbAXr7uwv1C5/UD75iDfPoyGjs0KePOm9RoAxJrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1252/1848] memory: emif: Convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:54:50 +0100
Message-ID: <20261118150012.187985145@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c8a53461990cb697ca494d6671fab9e196d20ce4 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/da2fa8d040d542edc1318aeae5117317bb22aa06.1702822744.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 314ef67d6732 ("memory: emif: fix device_node reference leak on np_ddr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 5a059be3516c9..234ffddabfc60 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1550,13 +1550,11 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	return -ENODEV;
 }
 
-static int __exit emif_remove(struct platform_device *pdev)
+static void __exit emif_remove(struct platform_device *pdev)
 {
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
-
-	return 0;
 }
 
 static void emif_shutdown(struct platform_device *pdev)
@@ -1875,7 +1873,7 @@ MODULE_DEVICE_TABLE(of, emif_of_match);
 #endif
 
 static struct platform_driver emif_driver = {
-	.remove		= __exit_p(emif_remove),
+	.remove_new	= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
-- 
2.53.0



