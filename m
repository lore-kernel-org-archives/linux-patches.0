Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055087;
	b=tgTI6TKsigLBssfJKB2SxtH2m/qrAhPbrA+mnPWc6/NmfK+ZwBmhnfpxwdmGX/vLjZgU
	 LR4m/tsTeyHRD8LW19VtO8v30sSUwNATt4pof8KcqNdIqCQGMudHFqdMyAi7XebppPAjb
	 wcJ1mc4gPrxQmD+0ZylBHD5OJqvMmTdXLpy8xhhygZhvgXzRpIayfvx3n3qXDsMvCAbT+
	 TYpUREUY55WN9VqPZX/MwJLtg2do9h3YQQ9x3N39mtwa7VqF5r0zQG2GFNvQ9uiLqJYM/
	 Gw/gCwiLHXZtK4Elrq8h1YDn7NPGqX5hFP1jqx+jg124Xv7/p3/h8THHIK+UihD7EzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4hCJ43Iuviv1h7clwrcfpcLtEVkAWYaM9Y6pirtIZKw=;
	b=z5oBexNDvixzPsN0rPpcmCIUhTLHATTveT3Ox+RM/4aHqMk4MtactOPfP0OHu4TkiGWK
	 Xt1liXEWgvecSlzZj6rkhd6F5610J+ZoIa8gcG7Ccg276S6kNkyKlJ2bM0lPlUTVDCPsJ
	 fO9FYWqYJ/KyHPIIMLwoOSgvPfI5qk8VuHMP1nImzOfGG0wxfiDdbLr0LwWrVQ3vWI77I
	 SI+O7Pix1jqyvd+jexXTpKjmHDOIInqk4mGWZw3wJoaiVgJxt645elydeWlzMWEVnpw6k
	 8+BTbWzVwgyph+4clABWbAAg9G5aAvLA6j6qYQWY+VoeatAbxWFlAp9Wi/Q3gxDmaRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcMocSFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96C606A31C;
	Thu, 19 Nov 2026 02:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcMocSFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A8C1F000C4;
	Thu, 19 Nov 2026 02:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055087;
	bh=4hCJ43Iuviv1h7clwrcfpcLtEVkAWYaM9Y6pirtIZKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcMocSFYmGQreLSdjCkiZOHsYg+C5QU8ACrNQ50QsMUULEDmFqNZLU8U8a2uWJZ+H
	 A8cG+M5HD9xDWF8KE84cnqeTD7xynIjUHmFfl6Gl6A2jNNYl5SmGVn4IXVUaFGnFZo
	 wwYBpUVSBJYulAh82gyi0wTWUTeYA2/jEpl6wfMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1504/2214] memory: emif: Convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150112.080652339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index ecc78d6f89ed2..ca800aa3c59df 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1170,13 +1170,11 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
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
@@ -1196,7 +1194,7 @@ MODULE_DEVICE_TABLE(of, emif_of_match);
 #endif
 
 static struct platform_driver emif_driver = {
-	.remove		= __exit_p(emif_remove),
+	.remove_new	= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
-- 
2.53.0



