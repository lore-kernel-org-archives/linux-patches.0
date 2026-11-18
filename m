Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030781;
	b=h0S2d3M+wBdXBcHzL064UbB2vpyf2g+niC4D9Sh+pYZ20jXtKPlw30b3VKOuqN1FJqw+
	 Y+/y90dRb+j6R+6lT9SCeyN3utOdswbOZ+OP0mlrDO3w/OcuKLez/Duzx+ee9GKKZ2LaF
	 fSh9/nkI8DAIj+ivl6/UdqmeMrCxggtYBmFBf/utdmwUFqKcZHIX0LcJyQj1lbykWit8L
	 zZWHSIgL3DCgnA6X5fmW6luswzJjEWlPA6EnkXQ9dq8ML20M/Rpgq7nSdiGjpkex7hJ7g
	 co5aZiOIEGQ0g4qFLNeXpQXaXP6XypR964fRKqF6K/zGu/frx3fXoPsoHcCfg95sXtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwY7xFvl21U3RTmE7LrnFVNZF5yGVgDRewfnfG+IQd4=;
	b=eYGGBACECXZDTlZ44btK8X5hvMseJSwaIbmmO8p8dZDwa3oDc0tpNwLis7meIjCDVcRc
	 bTackFt5iqpV4/b7Omar1BsU7ZMnRos1a/RiTBzYBuxBIv+wsOF7i8IH3sZpsHdlbkv77
	 26Zh77KL2L9LiuxpBFqetUSXbIJRVzs08f1W+CLD2+MoH7X70ScPNzBc11PgRzkkibPJI
	 FI77YgjwySYRdWGfgMVIs1/awQ8zh/N93ck42o1EGPPcbwS6kz4GnwLSUbFnAPlzmgpHX
	 n4roDvJvrTajv0TrQzxaQ69Jzg8zJJZaTWwZEegcEzjDa/kFa6YPIS4ElKtmrPel74g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qLV44cD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3942606A92E;
	Wed, 18 Nov 2026 19:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qLV44cD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450951F000C6;
	Wed, 18 Nov 2026 19:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030780;
	bh=zwY7xFvl21U3RTmE7LrnFVNZF5yGVgDRewfnfG+IQd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qLV44cDkIJWUUG/LFcodySVGN3qh1TPxr42/s5epIS1G3dgshcIoauHH7uU37Ne1
	 dTpfM+yl4SrDtEonKtmnAcgZuXrlWM110DhjZoFKn8HlQWz/hEP93mwR+D1w5lx+5Z
	 Ncfo17CQuFNW7r4kAEDZfTc4sW5QNBT/Qx1Aqgbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0825/1756] spi: fsl: switch to managed controller allocation
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118150042.382001339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6afe041c2ce9068b2b6c64eddb5537911752050c ]

Switch to device managed controller allocation to simplify error
handling and to avoid having to take another reference during
deregistration.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260429091333.165363-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: af1d882d421d ("spi: fsl: unmap immr_spi_cs on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 358c2a7e4cad3..94d81f6163bea 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -535,7 +535,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 	u32 regval;
 	int ret = 0;
 
-	host = spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
+	host = devm_spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -559,7 +559,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 	ret = fsl_spi_cpm_init(mpc8xxx_spi);
 	if (ret)
-		goto err_cpm_init;
+		goto err;
 
 	mpc8xxx_spi->reg_base = devm_ioremap_resource(dev, mem);
 	if (IS_ERR(mpc8xxx_spi->reg_base)) {
@@ -625,8 +625,6 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 err_probe:
 	fsl_spi_cpm_free(mpc8xxx_spi);
-err_cpm_init:
-	spi_controller_put(host);
 err:
 	return ERR_PTR(ret);
 }
@@ -705,13 +703,9 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
 	struct spi_controller *host = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
-	spi_controller_get(host);
-
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-
-	spi_controller_put(host);
 }
 
 static struct platform_driver of_fsl_spi_driver = {
@@ -757,13 +751,9 @@ static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
-	spi_controller_get(host);
-
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-
-	spi_controller_put(host);
 }
 
 MODULE_ALIAS("platform:mpc8xxx_spi");
-- 
2.53.0



