Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060590;
	b=WWW8uyjCHvOUYXQCycCRJZhx5UPakr2p1kBlNksHRjvI1br+732X/lgMSD9jbkB+8252
	 /2bQGTIIdCBBUVo2diEOhp6u5WsArYZ11X+ejQVjh/rkIELKUc/k9SH8LGeoCA+pVjQfc
	 SdlyqnTng8sBIuNK1y1UNxHaJsoGROGiKyJTFKog8oopT7jHebEPcebgXqqpLP8uwsipx
	 Z1/5/LhQOurPa/rsqN8C4VGUBkyGiqt/J0VQ2mTrQOwKJjxmILSptipSCKCumR7oBCBYD
	 Tty1ZwM7taZH8Xh8866Vt+41wrSFEXwJrKhMZWg66WFLxIveQYatx/e//nclinhUjdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DspXZ4FfPGhTY+BuasJzDZP0Gsse4h1u/Z3dzpGb6w=;
	b=aFr/7MCf4AwVtrFZfM29P+l1RmoRDpTSonFDIKLUh+yymoJ2Kr65i2nV1GPlSOrRRjge
	 k2RTI6Y0jYCCsynDQG/ZUEWKbfya/GWSonE+sgFuNpe+IIHQjKAVLbeXbRovMEPhY9lGd
	 skx4tKgjV0W8MvBvlTL/Rc1RXLC33JhgDUBGoey6T4xD5z0PzMeQcNmWPpp/SphjMHgqW
	 UUlw4U+ShSITBIFSTwdbIlTxIICgmP6QISj/2Sja+nhKteb2bZlKdRBEhUJ2hYivNUYdx
	 SBZJeg+ZKB5VlG7aSOPQxESic64shs6poizzP1VimBS4ahR30ebOzlHKodO2HB6JPhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf2hu++F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F63606A326;
	Sat,  7 Nov 2026 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf2hu++F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973801F0089F;
	Sat,  7 Nov 2026 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060589;
	bh=9DspXZ4FfPGhTY+BuasJzDZP0Gsse4h1u/Z3dzpGb6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf2hu++FE+kiEDdHyDdDvQTd+nq9YCnyjBo3UQoLehFZHT+SadEY6UpaLoEbbFthW
	 wofpS+ZSt/WOn+3XdGS79MtYZmHwl2oMHwNUuPjVRPdq/GlQFLQxKS0lKCsw2u3TXP
	 +9sDCC0dqFXhOWyn4VXmuCeYJYG5pDHhXe4HceX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0047/1536] spi: bcm63xx-hsspi: return error from failed controller suspend
Date: Sat,  7 Nov 2026 08:34:23 -0500
Message-ID: <20261107134958.978423072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index f5a8edef7b7df..87ec22627c6d6 100644
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



