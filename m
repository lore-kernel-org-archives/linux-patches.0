Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516D84052DC;
	Thu, 30 Jul 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423854; cv=none; b=A547jSsxHE25G/mqrCEk1OxsgjT/bXZilPpVnVfRvxcvk4N1KxC28Uk57V9ch3ecBMG7F1n5kJY1D2L7TJYmkAdFo0vYqI4uFmBenDx06hDpQ5dFSjJ5TvnospRC0oowYOXUUte9G2BgEwr8owrcagbK+Uu8Ym7bEJBbEmGAuQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423854; c=relaxed/simple;
	bh=K5WcePJa/jKQcA7CaVu/6XzDnO47n9NY6UIFEHVwuRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6uXwz9279HDkAUCvWeL85a0oOOwW6Oy2E8S9hJvbwzn9D9rd8TsjGRurG1ZuKBizkJFb0OgeOx740OX8OTFkMsrhpKNNFedqvjZxEGfFTMGHE7431moilGGM5yHhkzaGOFjqtXlbK/UEc92prNTvzp1AopCxIBdcJKnMB5kVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4aFShjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4aFShjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE61F000E9;
	Thu, 30 Jul 2026 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423853;
	bh=1T37zPKsjNj1POQDCpomAkZrjPSYKbgvUHH9HMS1JMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4aFShjqmgpISw6ey3BtPpCEUwiF8A3QHLp362kkUX86Npg/f5crdg9tquHfB+c0v
	 H0Ku/sbM6EMpJN/cnr5ZSwID7M4Mn7OE657YpdDCbusqC1XqWIwguRJrjN71qgzQXC
	 1X0o6ODIAgG/WPFh5vI5grdwxBjnp2cSLu19yEqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/675] ASoC: sun4i-codec: Set quirks.playback_only for H616 codec
Date: Thu, 30 Jul 2026 16:08:39 +0200
Message-ID: <20260730141449.161733685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit d9e96f859de3ea3e99bce927a988449a1816483c ]

The H616 codec does not have capture capabilities. Set the
.playback_only quirks flag to denote this.

This was somehow missing from the original driver patch, even though
the patch prior to it in the series added this quirk.

Fixes: 9155c321a1d0 ("ASoC: sun4i-codec: support allwinner H616 codec")
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260714113304.270224-1-wens@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index 93733ff2e32a03..3b92318e18ba6f 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -2236,6 +2236,7 @@ static const struct sun4i_codec_quirks sun50i_h616_codec_quirks = {
 	.reg_dac_fifoc	= REG_FIELD(SUN50I_H616_CODEC_DAC_FIFOC, 0, 31),
 	.reg_dac_txdata	= SUN8I_H3_CODEC_DAC_TXDATA,
 	.has_reset	= true,
+	.playback_only	= true,
 	.dma_max_burst	= SUN4I_DMA_MAX_BURST,
 };
 
-- 
2.53.0



