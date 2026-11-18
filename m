Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027970;
	b=W4v4arYwG73974p6C9r15cV/Q34/Atxed9ayopPvSATOHHtaWsVkxU7ylpJz8mUst2CW
	 276U1CQCdMCB7IGhQ2kNfg7/5EqIUMK0+2+Vp/Nncl58Qtu0SacVetkiQJSrNWfmxYti5
	 eGTAfYAZiqoXKD5geb8iASRkSTrDS0Qy+jfzPKTVcmE9nx2+nOu6cupcdSDRdEm1ddg09
	 MMa1TqJT2yvX2P6fV+BNH1fuiSS22RMQGgrmAK+K2kiwG0/0dM9YL6hCwqF/T9X7FHYlY
	 q2amWO96L+nu3wskjlHB3lvC+ckY2blFC5ZK87oORN+eemP3o0WwDVWiIL1EtMIbV6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIG1M5THEXDsBhdeji5aOZzRV1xPudwQhGZnQXoFvHE=;
	b=sdbQvr7CKQVp8h+tswvRRJm/O6riDuj9kJLtQJzaB5mzttZY1wMi7AIPxXpo6gqn1N8f
	 8HyS2Q57vwJxNT1m+Jbrb/ixU+ka5qQGyu91BrZoGk6hixo0oOF7jzW/z/ZHAVXUrbjrW
	 WgivApVgIRO137YswWV87lEDi0hAVKRytz9lEStJFNqt8icjPau35hbeW4BgrDLkQPVdl
	 66VXwkvAwx9SD+ZgOjABgihqXCIErPD1t4OQQ5cuSDlQyoMqANSDv5EgZTOeydW7AtM04
	 IlTKJwGeSOv1EoZrmP6pR/FbhaGu/Z4OF9OJrijPAqznPgeB9W8J5CmcALeLyjiFBOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="To6Xkdm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF65606A31C;
	Wed, 18 Nov 2026 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=To6Xkdm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4E91F000C4;
	Wed, 18 Nov 2026 18:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027970;
	bh=sIG1M5THEXDsBhdeji5aOZzRV1xPudwQhGZnQXoFvHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=To6Xkdm/Iahw5e/M8/+MmltredPpIvcyzRiuDARgzBLAmmfw6p55qX6TXiAi7LNHX
	 kOURvqqkH8Mu3xwU71TpHLgNS0NoChQFXBRY+hh3qn+NUqD3sDij39KCBj0Gz4ENKo
	 Z0xG6iTOZ52yRTxTdYIriaIcQV9IfLEDVvWqhY54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1978/2151] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150233.793978852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5c7c0cbf81bba69695efa12e451f0f2ecd4b92a5 ]

devm_gpiod_get_optional() may return -EPROBE_DEFER or other errors,
but lmk04832_probe() currently ignores them.

Check the return value and propagate errors from the reset GPIO lookup.

Fixes: 3bc61cfd6f4a ("clk: add support for the lmk04832")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261006110501.57051-1-phucduc.bui@gmail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-lmk04832.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-lmk04832.c b/drivers/clk/clk-lmk04832.c
index b2107b31efa28..1265529ec8d9a 100644
--- a/drivers/clk/clk-lmk04832.c
+++ b/drivers/clk/clk-lmk04832.c
@@ -1422,6 +1422,9 @@ static int lmk04832_probe(struct spi_device *spi)
 
 	lmk->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
 						  GPIOD_OUT_LOW);
+	if (IS_ERR(lmk->reset_gpio))
+		return dev_err_probe(lmk->dev, PTR_ERR(lmk->reset_gpio),
+				     "failed to get reset GPIO\n");
 
 	lmk->dclk = devm_kcalloc(lmk->dev, info->num_channels >> 1,
 				 sizeof(struct lmk_dclk), GFP_KERNEL);
-- 
2.53.0



