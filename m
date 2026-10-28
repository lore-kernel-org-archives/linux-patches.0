Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215006;
	b=l4K0RjLj+UKKBnrRgxrGjb94qwGyY9lT2Ifnff3d2Ai9i8DbM2wiuTp37FhlUSfFur7D
	 9GV6El3qAWH7gr5BFmS1/eneWpIgo73FfBXHaUiLQGLuddjlEUfemv1dBzxwWl6mCpflp
	 6AMvQR8cxHjtbEZk3PiiHELipT1I6zBC8pz0RIgKm91Ha3ZmlttmIPw3WT1Ti7S16mLqv
	 eVnRqNBsvns/sX0fClEb9nm4zcgbZtALmoSLya09u4GXdx9fMu8V1ouQwxP18BeU+ZkxI
	 gdTZKBVQGjHNZ8HeM8FcEf6uTxJdcDQcuHtMuznImkWZOZHotSpRDNRnm5vksBcYYIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DllCoFylscitAkrNrEJQSGHtJoToP405yxUnts0ZvGI=;
	b=PMOzyMF0SgflOg1oZ9LSRWP0YAQHTghENGNmJp7gLkEwFhxenuWHdqzNYWGDQg5f2ojq
	 G4cKVuGXP3ubnVWaSPQslfDZ/XFTvffBuWl2PTUIRt665Dsj4XRHDQX7h5xpwTkLfv66O
	 aCyRWxEvgvR4O1DjUghOIblQfzVM16C8dLf+n78/hCaEcBpvmjNictk+HpEWeEmgUuz8c
	 pMJdRaE9Onjcx1lde0fHL1pi3/gVwLFazk6ZtSqP4xf4b5KiZNazraaI0K/SoYabBXt2w
	 iuFxf6BhJTvkih1sngz0EjIAfDMvAkBxcOL3Hc2etkIu1t7jCXLK4LZbyymFUcNz59Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qlpl9PHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E630606A31D;
	Wed, 28 Oct 2026 19:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qlpl9PHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05371F01825;
	Wed, 28 Oct 2026 19:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215006;
	bh=DllCoFylscitAkrNrEJQSGHtJoToP405yxUnts0ZvGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qlpl9PHcW845iSQdYeVqgVwsCa+Kuo0qAyQSSwOE1dZpN2Oz+5ABUWyIzAc/cS0nA
	 2Kel8PgYZFsAsbEa0iO7AvxYcgcS45mPV0ZlUClNFia4PvljSXh2osUd7KUBH6EsoE
	 4/Cdmpf3/Pgd8JA/mWbyFayaFqaRyEtcg4W/nAM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1059/1887] spi: fsl-spi: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:52:35 +0100
Message-ID: <20261028170523.505641836@linuxfoundation.org>
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

[ Upstream commit fc4935a0f7ab1521a5f0500a9894d97558067985 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230303172041.2103336-29-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9b7abfed4c37 ("spi: fsl: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 1a32c4f6f1bf7..6775f13e121d7 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -717,13 +717,12 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int of_fsl_spi_remove(struct platform_device *ofdev)
+static void of_fsl_spi_remove(struct platform_device *ofdev)
 {
 	struct spi_master *master = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-	return 0;
 }
 
 static struct platform_driver of_fsl_spi_driver = {
@@ -732,7 +731,7 @@ static struct platform_driver of_fsl_spi_driver = {
 		.of_match_table = of_fsl_spi_match,
 	},
 	.probe		= of_fsl_spi_probe,
-	.remove		= of_fsl_spi_remove,
+	.remove_new	= of_fsl_spi_remove,
 };
 
 #ifdef CONFIG_MPC832x_RDB
@@ -764,20 +763,18 @@ static int plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 	return PTR_ERR_OR_ZERO(master);
 }
 
-static int plat_mpc8xxx_spi_remove(struct platform_device *pdev)
+static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-
-	return 0;
 }
 
 MODULE_ALIAS("platform:mpc8xxx_spi");
 static struct platform_driver mpc8xxx_spi_driver = {
 	.probe = plat_mpc8xxx_spi_probe,
-	.remove = plat_mpc8xxx_spi_remove,
+	.remove_new = plat_mpc8xxx_spi_remove,
 	.driver = {
 		.name = "mpc8xxx_spi",
 	},
-- 
2.53.0



