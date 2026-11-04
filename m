Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829347;
	b=1pON69JjAU+RfkPq+5g/yeSlXQwSq97K8BQvHBB6IrekCDDGktu9iKiDraJa4q2cr7Id
	 Cc32P5LRCsYBR0KSR3ir65VvDDetHr3Z37AJ++XsHE+1bsuBLDs7w/kjlLaak6Ur+IrKh
	 pZEsG0cjjoS6a1r2j3SDndiy9o0q2UUQJ9vGDzPuCTbJUuCNlLOGkX1E7haXm7vJ58KCh
	 TaaF/Zswwt7M9IS9TNhjtewAEytHlwDr9xEwe4N7mYMxKM1hHkuj2EK1EzVSF+s3FT82t
	 GeAMr1WxApxR2BBIGpx64EARF3EMfNUfbx0T9ja2kTZ1DEzlQz+RVuHmaAyy9zhK5nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oAradKJIXKfHmIYjSOuF1Yyp/juTUA8SRpRCAdWmgqk=;
	b=fQrFpqjxl4gWu8QQPGLUpw4OP5eMNRpVii4vlnCsC7HYMECLLzOdAZ9Gunr859PTnC9h
	 fKXjFjY/X6XpgLK4MWhGToTbYozGE8m6rT5JRPer6938+a9xZBVwyzmkBGLTZWhQQVdoK
	 Uy+YrCIuLhwSRPYlSESEKu+lJJ7uYvCx631ydV20gJM7rTikIoc0PajTYUkskEpzUn96O
	 tZ6zIRRV/ktMa1xtXKkMgAqph667DEIZy4G2+KlG42VTNkt7UUr1ipqFSa8OFf6F7NU55
	 Ef84P0Ie7QJHLCxOD1YId1PXJr06vDoAoDBzG6Az/Ox+gzJWjmGXSL6sZEPx0h5PVBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XNxyZ6/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50960A6F43;
	Wed,  4 Nov 2026 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNxyZ6/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512861F00A15;
	Wed,  4 Nov 2026 21:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829346;
	bh=oAradKJIXKfHmIYjSOuF1Yyp/juTUA8SRpRCAdWmgqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNxyZ6/dusppYA7eRxACG4eebCOyRZehta7S5zlkgVUhpJ+IFpTxVJ92ZcW7gvHcR
	 H/wmxaVD4HgRahH1SoxTPecDrsllyTsi3T2wB3lRFSD0YnLuAfTTaBP66M4OD09XVa
	 rbuE8NkUPBXNTMC76yESmIbMw2vNUVBOi6ZV9YOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0051/1005] spi: bcm63xx-hsspi: return error from failed controller suspend
Date: Wed,  4 Nov 2026 15:56:24 -0500
Message-ID: <20261104211045.021131991@linuxfoundation.org>
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

[ Upstream commit 3b5414d76a0381db77b9694537254af7acfa187a ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_hsspi_suspend() ignored that error, disabled the
PLL and core clocks, and returned success.

Return the suspend error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Acked-by: William Zhang <william.zhang@broadcom.com>
Link: https://patch.msgid.link/tencent_B5A06807924A77C8690730EBF7A052AABE05@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b8bf8b5be2cf7..719f0dfd96c96 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -895,8 +895,12 @@ static int bcm63xx_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_hsspi *bs = spi_controller_get_devdata(host);
+	int ret;
+
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
-	spi_controller_suspend(host);
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



