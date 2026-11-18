Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039776;
	b=knybMS/WozExypdPGdMdMXsSV1Sj5eHjoZtkfgaWt/S1GfLPotKcbLbN0S9XlwdDKnLf
	 9us8F7/XvKkvUCzhAroaElMOyDWAGObmSPqvTwRwylCwAANpHEqlGePfk6j6Hk/mKTIXI
	 Ne7KzQjGbIq/K+8ZVFGw2P37UaV5/fRHygoo8I0enxa3L6LjjRCMbtOCQsgBtKrmvpqIE
	 2ffFbZGE4k+crgDkmLgbMCXuPXcdRTIaC0COkMaAeXTiLaEUMo6OVQ6yN3cOZdnYjbvYZ
	 A7c2Rbk+Z6zE+GFcUtkc+b98QFZnxA5pi183aGm2KBgd/SYMD1kMsGG48CD+uQ8YY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=om6SkVk0g0DhtsM67IM4JSQoL9hIrIQkcjQdMGuOeV4=;
	b=wsveqDtUZh0FFnZg0fqlUkw5qsYYlSLvh6PZ4+9O/qYQ2BVA9+8dso9io36i6IuNXMkQ
	 qYrAVNhlJvIkKUMi6LSXsBPXRNs8uyqTGV/1yqqX+XxM88BYDDxV3jcr91tQD9rSKVSfa
	 srm6H3iS1c+etjbAxmKtpFLAnk0dY62Dy6PJ/hW6QLLaiVLAL++5DViTj/GgTVEu0EUvm
	 DuPJE78hUmXpY/7niq7S1Px6tvQQCtbd++ifF0xm5NUeL+cYdfHAxWbepGaxITPAIqnWt
	 TiXMbvIbkeGZN5i5eAOnJqxSh85fvWDfTtfZ0QyDNXZwQ448ohIxfYJtnyJkGa6dZAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvrlPy8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C29606A31C;
	Wed, 18 Nov 2026 22:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvrlPy8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620A91F000C4;
	Wed, 18 Nov 2026 22:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039775;
	bh=om6SkVk0g0DhtsM67IM4JSQoL9hIrIQkcjQdMGuOeV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvrlPy8VNbdoE4dDQT3PS5je8Ui8JR8uI5VRJO3zLAU+WXlGJm69EE0rdF+cc0PFp
	 eU+3et91tKZi2gzt3mzW8eQa1h4okJBBu1uGZi8oQCGvbsY5DmYY6NpjPLZbKpgNEv
	 tB81nfegOMxtir7WZC0MfXsXiILrCE91W4AjPW3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2220/3318] memory: emif: Convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150428.494200477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f305643209f03..434982545be63 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1159,13 +1159,11 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
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
@@ -1185,7 +1183,7 @@ MODULE_DEVICE_TABLE(of, emif_of_match);
 #endif
 
 static struct platform_driver emif_driver = {
-	.remove		= __exit_p(emif_remove),
+	.remove_new	= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
-- 
2.53.0



