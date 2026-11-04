Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829329;
	b=F+MnPxlUDpdrSxp8dgJYhU0bkBiSgf63yDchWUkeV4tIiEyoRBzhr64A0+otVgZ49L88
	 jS/JKIFy00cHLuqaN3s49UXYoYY0VMduXP3mNP9FV+H/JZYbiiWHbQfJzmM+Rc0bIHTyw
	 cEz+ZFJP4JMIi5HoNbWb6oow/sd7Fy+lKnO8yHtIBxFRe38CUIOXQC/Kk55Q5Mff/qMRC
	 2QJYUYxkWDXQOCtJ6/8W8hitZov2CUE5fCVE0EG9Pu8/M0WQsRx/RuceK+7+GL/bKlhGY
	 ad/lm6qQD1e+iNpBpWOuVTt0QkaYsm10ofWp+h2QRcPux/uYoBvTDnL1aw8onnZQQqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6BQLIJ7YjZryRw6nE1OSHOb7iAQut2MdZ+fz5jYgcRs=;
	b=qY574fE+7CBq4FxnneflYLktt662sL+TzMwrGwZ6va38TIz1Y3fkms5e2BEdlDkxKaGA
	 k6gMWVJUllbtTqrjpFDyyEwzaIwJfg2hs4YeDvSgbds3hkEndqb7q03k9/6FQmvA9ylTW
	 MbR5Zy++71O58Tpli7xADrAOHI5FlgC4rXuc0jSezjzBZGwyfb6seu9D1VlRPJTlIPxrS
	 bP+SLPXAEiUAHWdwBlscWLmjeVA8FXyYLQ+0nbsnN1moMlKOMKkMf5ZYBWhM3vzZ//LlR
	 pTokZAOMB3Pmp24RKw/I6LA+twb3E969E4gVaF6+D0w1pJWbj9sWgUyuai2lSPTnYNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXw0VUny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D05607491D;
	Wed,  4 Nov 2026 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXw0VUny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB47D1F00A16;
	Wed,  4 Nov 2026 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829329;
	bh=6BQLIJ7YjZryRw6nE1OSHOb7iAQut2MdZ+fz5jYgcRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXw0VUnytYufBDl85jfpPv4HxqJKiYc3Nra6aYV9vcQlMElxEK9oWqVoDStDBKA/d
	 h+1AmjbAhp4NPoNlU/njDaKdMQZE0Mr5YInNJyvRszB76357uyNH2K54dc7w08iMXR
	 4zAO1lKCqPmPaGcUsWzuf7rnlr8C96iQW+7NN3Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0050/1005] spi: bcm63xx: return error from failed controller suspend
Date: Wed,  4 Nov 2026 15:56:23 -0500
Message-ID: <20261104211044.994608952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit bbbc1ef5b35341c5122418a14f8924688a4bb954 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_spi_suspend() ignored that error, disabled the
controller clock, and returned success.

Return the suspend error before tearing down the clock.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803725905@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 8d152e906daac..f73dc14533dcc 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -643,8 +643,11 @@ static int bcm63xx_spi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
+	int ret;
 
-	spi_controller_suspend(host);
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



