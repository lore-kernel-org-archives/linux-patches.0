Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050003;
	b=FeO5grWfw4UHR+00LZz68lsFZpQrzceXsbNlNdJJjOGBotKl/bV6L4I7VhflpD+IaCjc
	 AzVIYJBQBmC44nFnPDFEUGTEy8TP2p+U8Xr8tXn9hlOx3r/7IPQlT6TAohe/GnUTsmDS2
	 MjIPTZY05iVBeby352+gRpXKvjas6X2lyLxk+0wAp1fOJbFH9DkoGrJyTpx08ChljbXOo
	 Q7lUFLSbTmr3ylx84h7500rFgRUH98ubgDhLvke/olguiSnoRn/m3Mr7AmeZ9q+TQEEmV
	 ezBMI7ISxFI0X41kdyvLI4TXoF+tw0W0OfAsPAuD16IO9KkBuW8wwTHP03HiagkHo3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GDWo7yCn1GH9DgB18GjCGpmC2fv7FFHMR8xoFDm8Z+Q=;
	b=kLOi4J1oamlDpwFshx6xMPJAcnGyx1Z0RuxWSLz9phbNHt/3EyBBkRrEpZ+MGbEz0zsL
	 yN3Mmi9jOw7JnmioWgFSuaGevqlqi6XzQS9RY+OCsPJg73zOMk3rIW8y3YPAywTYACUQz
	 LW+3AzNDkyC4QtCBXm9GqcUPmHcpX7+ZC7kUVJ7lRXadW0gcyWeN7qFLqH2iCDNdNmpDJ
	 vsJhX1cK68/vWiAo/synKBqRnsApXHf1paPXrHJscDhg1DRmQrStEeJLt9GlWjW4WCV6C
	 tzyy0eMQ9+GAY3RZv/12RUIXE4i+cqY1pywILYpwDkmgX6q9d+80EtANbsiGtnBAXzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNrmRqbL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6904260A2607;
	Thu, 19 Nov 2026 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNrmRqbL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EE61F000C6;
	Thu, 19 Nov 2026 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050003;
	bh=GDWo7yCn1GH9DgB18GjCGpmC2fv7FFHMR8xoFDm8Z+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNrmRqbL3E9l/I6ypHmXYi6aRAcOPuO9vbJ2IyNewyZVdYsmSAMfKepdIL32/xXyP
	 nJykvFos+hK/oIzLSXQ45CcItm3nu05J2MMAG7S3kpy0mHezZRMoT5acqae2uVdKAv
	 yW2i2PG+/RVHxE/AgzRvi/uR+Pco6TQHrouMiPBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2554/2857] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150333.467313631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index f2c9a1fdbe0d0..eed2f10d943cb 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1500,9 +1500,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



