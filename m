Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22D51C040;
	Wed, 30 Sep 2026 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789791; cv=none; b=BfgmIIq2XPNgtOqzEOJ5ccVVGh6a/c1xGsN34YJQj5ETfDvuAsmaBEC8BN6TBfkAiIXn3awhsScZl9ynNbefoEVFeYchUwwGwRxDik948YHYNWAvUBF9afgcdLxLMXNduMhQLdOMiGILnQbjZqrKBOBjoxvWo0+aWk81hD/c7kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789791; c=relaxed/simple;
	bh=FckL/sFm2WJZWVB5pbcQLG6WyHElaxIT27bsoPLk2I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcS+kJv0Rc3/3Mb6cFJLo0pfo/46v1ysCxF/3ndXXgCSXreqGJ5vbPKzcGPuWSCwz/1IZmIQ5ydRqW1mYmSQT7Lqs1eSbATb8irBIyExIG6Q+CHWL9S6hoRVhE5CxiODsAyi41nP0QRJ27g7viz/Jz5fh+uE+DimAIGfnmwTXDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hivKXi+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hivKXi+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E521F000FF;
	Wed, 30 Sep 2026 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789789;
	bh=UI+Q1i06uRZwciOvXOq7xnFuImg+i2vR/3s4HBOZbto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hivKXi+qCzj0aX/qRB9KYVwK6DWLZCl8wD/5MfXUK03vqY3eYRtfgLOjpJoB1uqM2
	 O/fEVe/3FB4ZL/Wf0KmJOoNxYP7GIpWk/cIuzyLuGom5bTRRYSHAHwsKQYcr9puQQB
	 6EThjxLGWdO0TbY0dg80oQuvg+EmNNovgqIUOMyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 602/877] hwrng: drivers - Switch back to struct platform_driver::remove()
Date: Wed, 30 Sep 2026 17:25:13 +0200
Message-ID: <20260930152427.648457594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit d11c8b87a36267a2861b9010ce0393de8ff3d278 ]

After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
return void") .remove() is (again) the right callback to implement for
platform drivers.

Convert all platform drivers below drivers/char/hw_random to use
.remove(), with the eventual goal to drop struct
platform_driver::remove_new(). As .remove() and .remove_new() have the
same prototypes, conversion is done by just changing the structure
member name in the driver initializer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1163a476a568 ("hwrng: stm32 - Fix runtime PM cleanup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/atmel-rng.c      |    2 +-
 drivers/char/hw_random/cctrng.c         |    2 +-
 drivers/char/hw_random/exynos-trng.c    |    2 +-
 drivers/char/hw_random/ingenic-rng.c    |    2 +-
 drivers/char/hw_random/ks-sa-rng.c      |    2 +-
 drivers/char/hw_random/mxc-rnga.c       |    2 +-
 drivers/char/hw_random/n2-drv.c         |    2 +-
 drivers/char/hw_random/npcm-rng.c       |    2 +-
 drivers/char/hw_random/omap-rng.c       |    2 +-
 drivers/char/hw_random/stm32-rng.c      |    2 +-
 drivers/char/hw_random/timeriomem-rng.c |    2 +-
 drivers/char/hw_random/xgene-rng.c      |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -216,7 +216,7 @@ MODULE_DEVICE_TABLE(of, atmel_trng_dt_id
 
 static struct platform_driver atmel_trng_driver = {
 	.probe		= atmel_trng_probe,
-	.remove_new	= atmel_trng_remove,
+	.remove		= atmel_trng_remove,
 	.driver		= {
 		.name	= "atmel-trng",
 		.pm	= pm_ptr(&atmel_trng_pm_ops),
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -653,7 +653,7 @@ static struct platform_driver cctrng_dri
 		.pm = &cctrng_pm,
 	},
 	.probe = cctrng_probe,
-	.remove_new = cctrng_remove,
+	.remove = cctrng_remove,
 };
 
 module_platform_driver(cctrng_driver);
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -335,7 +335,7 @@ static struct platform_driver exynos_trn
 		.of_match_table = exynos_trng_dt_match,
 	},
 	.probe = exynos_trng_probe,
-	.remove_new = exynos_trng_remove,
+	.remove = exynos_trng_remove,
 };
 
 module_platform_driver(exynos_trng_driver);
--- a/drivers/char/hw_random/ingenic-rng.c
+++ b/drivers/char/hw_random/ingenic-rng.c
@@ -132,7 +132,7 @@ MODULE_DEVICE_TABLE(of, ingenic_rng_of_m
 
 static struct platform_driver ingenic_rng_driver = {
 	.probe		= ingenic_rng_probe,
-	.remove_new	= ingenic_rng_remove,
+	.remove		= ingenic_rng_remove,
 	.driver		= {
 		.name	= "ingenic-rng",
 		.of_match_table = ingenic_rng_of_match,
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -272,7 +272,7 @@ static struct platform_driver ks_sa_rng_
 		.of_match_table = ks_sa_rng_dt_match,
 	},
 	.probe		= ks_sa_rng_probe,
-	.remove_new	= ks_sa_rng_remove,
+	.remove		= ks_sa_rng_remove,
 };
 
 module_platform_driver(ks_sa_rng_driver);
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -188,7 +188,7 @@ static struct platform_driver mxc_rnga_d
 		.of_match_table = mxc_rnga_of_match,
 	},
 	.probe = mxc_rnga_probe,
-	.remove_new = mxc_rnga_remove,
+	.remove = mxc_rnga_remove,
 };
 
 module_platform_driver(mxc_rnga_driver);
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -858,7 +858,7 @@ static struct platform_driver n2rng_driv
 		.of_match_table = n2rng_match,
 	},
 	.probe		= n2rng_probe,
-	.remove_new	= n2rng_remove,
+	.remove		= n2rng_remove,
 };
 
 module_platform_driver(n2rng_driver);
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -176,7 +176,7 @@ static struct platform_driver npcm_rng_d
 		.of_match_table = of_match_ptr(rng_dt_id),
 	},
 	.probe		= npcm_rng_probe,
-	.remove_new	= npcm_rng_remove,
+	.remove		= npcm_rng_remove,
 };
 
 module_platform_driver(npcm_rng_driver);
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -558,7 +558,7 @@ static struct platform_driver omap_rng_d
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-	.remove_new	= omap_rng_remove,
+	.remove		= omap_rng_remove,
 };
 
 module_platform_driver(omap_rng_driver);
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -565,7 +565,7 @@ static struct platform_driver stm32_rng_
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove_new = stm32_rng_remove,
+	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -193,7 +193,7 @@ static struct platform_driver timeriomem
 		.of_match_table	= timeriomem_rng_match,
 	},
 	.probe		= timeriomem_rng_probe,
-	.remove_new	= timeriomem_rng_remove,
+	.remove		= timeriomem_rng_remove,
 };
 
 module_platform_driver(timeriomem_rng_driver);
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -375,7 +375,7 @@ MODULE_DEVICE_TABLE(of, xgene_rng_of_mat
 
 static struct platform_driver xgene_rng_driver = {
 	.probe = xgene_rng_probe,
-	.remove_new = xgene_rng_remove,
+	.remove = xgene_rng_remove,
 	.driver = {
 		.name		= "xgene-rng",
 		.of_match_table = xgene_rng_of_match,


