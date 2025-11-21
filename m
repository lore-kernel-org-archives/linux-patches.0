Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036FF34D917;
	Fri, 21 Nov 2025 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732242; cv=none; b=XmNlnrU29wz8K4jsRNWVWezuFnaaoVN8wVQ8MB6WbwaIXDZTN3K7I9jHJFdnSGj7XeHnpYwZoYYBsg35fZXS+Za+DpwbVsfzdQpoO78OWLReR7YtxOwpPEpapoWOumHaOA8z0Tv8lcExZA9NkG0hF8pFsD2DdvlfjvHv3IS4yFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732242; c=relaxed/simple;
	bh=hC5a4gP42qwR5rnw1vPHnghN3IwSpNnC2bdKZ5YLrR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qc6kNmCHbueDKkwmxagahM+4xRtu0XSS8oTpmdxOkzZQsDWCVJebJeiRq/SvJ10K+XmejeKTq8cFFp2ZR0wtcdFCU5i3NqAFJriCA5mf4nEVaxSWrRLnJHtgQ19ePHfM2+obMtR+sHPyhaZ/kSxKz/7zFAuoEFelV4ypZOD0cVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XU9jBw+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XU9jBw+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2ECC116C6;
	Fri, 21 Nov 2025 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732241;
	bh=hC5a4gP42qwR5rnw1vPHnghN3IwSpNnC2bdKZ5YLrR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XU9jBw+iqaiFW5nROWtsq42J79qEvNLeoLSr3Nw2nwpk2pYtahhoZ4rd5PYjnMKeM
	 sThZRIcGk/1wHX8vagZTcJnpXxZIICFAuucS21xnbB7TpH5vxLWB8UX1oLsocfMhFC
	 R5jaLOKTMEu91dG4f+WHsyQZj+/KDM99CLwTIN2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/529] crypto: aspeed-acry - Convert to platform remove callback returning void
Date: Fri, 21 Nov 2025 14:05:24 +0100
Message-ID: <20251121130231.895793641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8819da7e685008de2c1926c067a388b1ecaeb8aa ]

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
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3c9bf72cc1ce ("crypto: aspeed - fix double free caused by devm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/aspeed/aspeed-acry.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 247c568aa8dfe..b4613bd4ad964 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -794,7 +794,7 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int aspeed_acry_remove(struct platform_device *pdev)
+static void aspeed_acry_remove(struct platform_device *pdev)
 {
 	struct aspeed_acry_dev *acry_dev = platform_get_drvdata(pdev);
 
@@ -802,15 +802,13 @@ static int aspeed_acry_remove(struct platform_device *pdev)
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 	tasklet_kill(&acry_dev->done_task);
 	clk_disable_unprepare(acry_dev->clk);
-
-	return 0;
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
 
 static struct platform_driver aspeed_acry_driver = {
 	.probe		= aspeed_acry_probe,
-	.remove		= aspeed_acry_remove,
+	.remove_new	= aspeed_acry_remove,
 	.driver		= {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = aspeed_acry_of_matches,
-- 
2.51.0



