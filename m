Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214981;
	b=ISCGk8N70ljR43AlW3+kcQny+5MUmUeDWDUTFrveTzscB/TzSvitJyvsQeldoMjH9SNl
	 Qmm0K6JewsgjTPtMZSIV2PR9WsvriLNc+u9dnNoiPRLDqP5CJJBjH1F3Pq4h+mm7NJjSq
	 4fO4zP45kWScTpsBOcgBDcaDBZuWXT37md9Mi6dPxqX4VkavqQ7ZR3noKd3vm9r1n8Rp0
	 vn80y+potTYA8FYXfXjcXFFA0whLbBAHrxpxrSlr2ld2OLAXpZm3hFTBzIG80N/NcOhzc
	 ZhAsz1CtN5tYu/gGssnWPFaV9B7/E/ksl1Nnav6d2K7CXwmRt9dY6KAXC2GXXMyCD7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kdKnEa9ACA7jQsSiVUgFdhO8oyp733whKNBzjLtdz94=;
	b=1JHF9YrAsn2lsSCWpJyMwkckV5GYbk/IErL9/z5ju+NqOuiUSHWDLMaLPINHMXsVwx1e
	 tH6OwGIkPoAJxGjjqQFzsLGe9oD4xLgH1YHU0T9fO8EsmAD405c77h8oKsLoa0Id8Oudw
	 pFZ6amrthakWgZdYMFyMfukvxBjPe3/jeleim1C97bjFh2RmE1BjEC5K1J7iCgjU6fZwa
	 kxHou69Ey7acvOZH2rIJ0j183FBQrDGrqP+ED5HEeDmzVeXsTmMF4M9TS5RtTXxxWs6y2
	 xL2e78lWaimL+PvgxEw4Hhj4iC13zsV5U+1C8UYtgOmAuWTBKyreCS+tBCSFx3O9RQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sOG72n4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020D606A31C;
	Wed, 28 Oct 2026 19:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sOG72n4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D19A1F01825;
	Wed, 28 Oct 2026 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214980;
	bh=kdKnEa9ACA7jQsSiVUgFdhO8oyp733whKNBzjLtdz94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sOG72n4b9H51fKUFcGMAuhW8Hv2gGWzXZlWikT9jWR5YekCkLsF0wOh+sIa7daVe
	 qLNpgpOhk0MvFVaExu8sW7H8ff7eCCT6eMWHiXQJy6+jfMVAFoNwoYruDW2uorcNIP
	 tCeICNvkJ2sjw9anpZcfOJp68hj1HdIRmXy7Jy2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1051/1887] spi: mpc52xx: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:52:27 +0100
Message-ID: <20261028170523.325174449@linuxfoundation.org>
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

[ Upstream commit 3fa689a85df4664a62ea931be31e5276cde1e8fe ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-41-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0f997fdae819 ("spi: mpc52xx: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index c4d005c3363e9..f49859632d663 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -513,7 +513,7 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 	return rc;
 }
 
-static int mpc52xx_spi_remove(struct platform_device *op)
+static void mpc52xx_spi_remove(struct platform_device *op)
 {
 	struct spi_master *master = spi_master_get(platform_get_drvdata(op));
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
@@ -531,8 +531,6 @@ static int mpc52xx_spi_remove(struct platform_device *op)
 	spi_unregister_master(master);
 	iounmap(ms->regs);
 	spi_master_put(master);
-
-	return 0;
 }
 
 static const struct of_device_id mpc52xx_spi_match[] = {
@@ -547,6 +545,6 @@ static struct platform_driver mpc52xx_spi_of_driver = {
 		.of_match_table = mpc52xx_spi_match,
 	},
 	.probe = mpc52xx_spi_probe,
-	.remove = mpc52xx_spi_remove,
+	.remove_new = mpc52xx_spi_remove,
 };
 module_platform_driver(mpc52xx_spi_of_driver);
-- 
2.53.0



