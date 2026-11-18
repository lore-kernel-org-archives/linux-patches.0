Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015789;
	b=Ly/YzC50JGsNFh1Lmhi4ShhcHC5QHstTs5ob5U7DR7MGoV//mR4ZzWkOgAaVMLAzdTBi
	 N3fJBap/HEZvYxptx5kK/3/X11fW1Smlvprrz0NTp+C/sF5bMuxgZ281AXvLNGSoVl7Cd
	 TjRrWODuNWjOS25TIXravusZlv5IXr/nSBc26w247krA2n2Ir1wIA0ro29zrRWcFosJkq
	 2nLXA3qjm6CQg1k7tuU9YexPtFBMJzbcgKNpK3bfuqafcsaD0a3lIn9ZEdOF5BfGezQJs
	 MORel9c8A6GikdkstfumLclVg5kq9KWI9JiIUQ41O7Ja4zn/0t+diMOl8Ilt26kGKDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yByuEu7Cp6A+ojpOTAuGjoSVj5Dxltgz0yZpRxdhL2E=;
	b=ylHm8m1ojnBJK79ITgF+Ui5SfvQT8V9hCkPNhf4+1bK81tmv0OVKNfUco9uWVBCRwuM4
	 zQ/DDeiGNx33uyeeRUc1roEN5L0eTFLu6A99LmSA5ee850GmyhDA+ToVuhgivDA0OwoEa
	 1bTjVbZaP7bNvzR6hC0gJyeoScBK6sKMHkjRhBEShzu3KDqpJlKA980Q7htgP3Hyzf1sy
	 TikeVwhfy0C2Zp2wImSKMqjlSchOtu5Ws80lxNd38mc3m/uhdtiPixVldqfezZ/DNKCRM
	 OK03NxKU3/aw+kO7wpr4CB1E/lVKFQLwYlf1MsPm55yosId4V7ohfae+BXXcoPaVuFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TqlBPpFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E97606A31C;
	Wed, 18 Nov 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TqlBPpFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823441F000C4;
	Wed, 18 Nov 2026 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015789;
	bh=yByuEu7Cp6A+ojpOTAuGjoSVj5Dxltgz0yZpRxdhL2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqlBPpFa3HMENWeJoSV78jfBqTNc2CeHdF3W7WQ1C2ktq2cwypy0uspBHm1J5QUMf
	 NQR2clFW5IbPye9YQavrq034yHAxXDN5YerQUa/Fn1FiO1cHBt2m2mENtNkf9THucd
	 M3o0TV0nvObi5e3xb0vIaiWrdVNZj6CAkiz0ZHcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0256/2651] spi: ma35d1-qspi: Allow DTR operations with the regular SPI API
Date: Wed, 18 Nov 2026 15:24:56 +0100
Message-ID: <20261118150257.076741363@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 2448f25cc839739fe576d31d85c7d0df4844bb3a ]

The feature was implemented but not actually enabled for regular SPI
operations (as opposed to spi-mem operations). Make sure the missing
capability is actually set.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/09c3928f-4b58-4ac6-8e1a-84dfe3ff6b92@sirena.org.uk/
Fixes: 15e9362f6190 ("spi: ma35d1-qspi: Add DTR support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260904-perso-ma35d1-master-v1-2-b6936e8c6fa1@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ma35d1-qspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ma35d1-qspi.c b/drivers/spi/spi-ma35d1-qspi.c
index cf731fa2f7e2d..30e3239f777d6 100644
--- a/drivers/spi/spi-ma35d1-qspi.c
+++ b/drivers/spi/spi-ma35d1-qspi.c
@@ -649,6 +649,7 @@ static int nuvoton_qspi_probe(struct platform_device *pdev)
 	ctlr->max_message_size = nuvoton_qspi_max_message_size;
 	ctlr->mem_ops = &nuvoton_qspi_mem_ops;
 	ctlr->mem_caps = &nuvoton_qspi_mem_caps;
+	ctlr->dtr_caps = true;
 	ctlr->set_cs = nuvoton_qspi_set_cs;
 	ctlr->transfer_one = nuvoton_qspi_transfer_one;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
-- 
2.53.0



