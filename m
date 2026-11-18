Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015598;
	b=DtU7/3+3UIVCkqAGKfsX4h7+6jhbd12NV8/Lme4+w1Y4lH+jYymyk3veDO3zwU8T/tHa
	 me3lYujUqj5eH/Ugn21I2CyyhCMC6H7CDNPugnOY17inrPGGEDk4RMBomDNkip1zAx9Hx
	 Btj+FqABnfSPzu0BwmL6fwyaxf5N0VbaCLa2ZnUutfskhFs6ZhubKeB5YJVU29NkrJ4dq
	 tdzrN12rr6FaaWmiRjHsrT2qThALUarmXEXe+hirv5HrISDkK/CgQPyEWGkMABIsvnAEz
	 oV5la4uPwfJDpMhn4BuXSnyhpiprSWj3NTPYrK4tJfmORZicEa8uKcUiVy5+LR0L/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d6pknIWlQfduE+nICqf9mcE1BUD3srtM/sY2Ogd1v9o=;
	b=3/Qrl3kueyuaPuBSqznOFMVNFQ6xmHfpCOVzTXAO084T4t4JhV/Kwq0pJpzMa/Oi3R7q
	 JXlMOv33PVaYCtVjgmyNf4P9CEC3FGmteB8f5AqOKiZYpPl5LaVjaBzNgxIRECjMh7jky
	 B7/3FUjCGILoAVlpldNk0lT5gL9DWrMrk9IiDCq3TuF44nM4NYRrQJif7NSRrzQ8J8c3r
	 Kd65rssF/0aw5io8ZFr43iL8AyCqbBbQIBNiKdmvCdRMdacdIMjFJI0l4DEv/FMAOI8/i
	 xryavELtU54vazlM8FUiY0Ee3rDZvIgJQCNHfkEM0lt1jP4wAWngQ2e6A85veEsTvFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1FuxYWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6012A606A330;
	Wed, 18 Nov 2026 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1FuxYWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84F01F000C4;
	Wed, 18 Nov 2026 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015598;
	bh=d6pknIWlQfduE+nICqf9mcE1BUD3srtM/sY2Ogd1v9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1FuxYWr3xOcqZqV1pzYEkPJrYVayHilneNFEKN2b1qvnuB9ZT/KPv1D9s86n6d2q
	 zgZfv2hE08nlXCL/1mDKxwkclZmh06rf1c6MPGK2udSMUoLYUL7CV4uQ1nWoBnTiev
	 +L2l7/Tsa1L440MG28E5orRJvl86Aa55KPrAieEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0230/2651] spi: ma35d1-qspi: assert reset on probe error paths
Date: Wed, 18 Nov 2026 15:24:30 +0100
Message-ID: <20261118150256.142804715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit 8992169e7ac6b216f881cb373bb2c6bff0c6162a ]

nuvoton_qspi_probe() pulses the exclusive reset and leaves it
deasserted for normal operation. Later probe failures returned
without re-asserting the reset, leaving the controller out of
reset after a failed probe. Assert the reset on those error
paths.

Fixes: 78b16af159ae ("spi: ma35d1-qspi: Add Nuvoton MA35D1 QSPI controller support")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Link: https://patch.msgid.link/20260901025129.359960-1-dayou5941@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ma35d1-qspi.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-ma35d1-qspi.c b/drivers/spi/spi-ma35d1-qspi.c
index 7f938d0c6f1fc..cf731fa2f7e2d 100644
--- a/drivers/spi/spi-ma35d1-qspi.c
+++ b/drivers/spi/spi-ma35d1-qspi.c
@@ -633,12 +633,16 @@ static int nuvoton_qspi_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "failed to deassert reset\n");
 
 	ret = device_property_read_u32(dev, "num-cs", &num_cs);
-	if (ret && ret != -EINVAL)
-		return dev_err_probe(dev, ret, "failed to read num-cs\n");
+	if (ret && ret != -EINVAL) {
+		ret = dev_err_probe(dev, ret, "failed to read num-cs\n");
+		goto err_assert;
+	}
 
-	if (!num_cs || num_cs > NUVOTON_QSPI_MAX_NUM_CS)
-		return dev_err_probe(dev, -EINVAL, "invalid num-cs %u\n",
+	if (!num_cs || num_cs > NUVOTON_QSPI_MAX_NUM_CS) {
+		ret = dev_err_probe(dev, -EINVAL, "invalid num-cs %u\n",
 				     num_cs);
+		goto err_assert;
+	}
 
 	ctlr->num_chipselect = num_cs;
 	ctlr->max_transfer_size = nuvoton_qspi_max_transfer_size;
@@ -655,14 +659,20 @@ static int nuvoton_qspi_probe(struct platform_device *pdev)
 
 	ret = nuvoton_qspi_hw_init(qspi);
 	if (ret)
-		return ret;
+		goto err_assert;
 
 	ret = devm_spi_register_controller(dev, ctlr);
-	if (ret)
-		return dev_err_probe(dev, ret,
-				     "failed to register spi controller\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret,
+				    "failed to register spi controller\n");
+		goto err_assert;
+	}
 
 	return 0;
+
+err_assert:
+	reset_control_assert(rst);
+	return ret;
 }
 
 static const struct of_device_id nuvoton_qspi_of_match[] = {
-- 
2.53.0



