Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0377143E08D;
	Thu, 30 Jul 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421716; cv=none; b=Ms2vqk99me2IJh7KK5D4hULVswmltLAHvyp1Bn6tJskbNvrOUYnBdZiy4Cg7wM2yq9XlxMulonaP5dKfGi76It2w4GJkladE8ZvXkY0e7Qd7NBKak2ugfPam6XW6lsZ2P83gEo1jEaQzh7CZKZDque6K+pJmfS6fKr1xycVe6eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421716; c=relaxed/simple;
	bh=pRKq63xOdxNxbRkPRZKYoP4Mz4aY+reHNZ7Rwo0Swd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3D6fRIhowqX7vabyFkOoT/+CJt2YPQPJ4Keu1A2S8Nd7DiXgPOmZRK+5y1iy+lHUabV9cYEoYxjxK/rGFVd/NprrqwWVWCy2BMapzKlo97r059eJF06c9jOB7grapxY/NywhJP0KAFKdWsAJCWHADTmMvOpQDvCWTtJ5YdXGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGFJ+zjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGFJ+zjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510471F000E9;
	Thu, 30 Jul 2026 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421714;
	bh=p/f/fXgtVON4Lo3MaQdoacTqZcgSD2oV6asolutQ96M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGFJ+zjRKUUrlPRtjhjEMJnqhtF8i30JPUTSnHBg7JvdMjD43yWQc+tJc2mUDrtcE
	 5cVwpx/UtqjkEGyDz4qTuwCZTdUM/D0D1uWlHzWBPMaL2ZfUz7OvC02Z8L13sHFtsK
	 zjdly869pkMTwHDSnrnei89rR5gAzLmkR2rFApk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 197/744] ASoC: sun4i-codec: Set quirks.playback_only for H616 codec
Date: Thu, 30 Jul 2026 16:07:50 +0200
Message-ID: <20260730141448.468363467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4e22af594fa35..93f511fb61905e 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -2237,6 +2237,7 @@ static const struct sun4i_codec_quirks sun50i_h616_codec_quirks = {
 	.reg_dac_fifoc	= REG_FIELD(SUN50I_H616_CODEC_DAC_FIFOC, 0, 31),
 	.reg_dac_txdata	= SUN8I_H3_CODEC_DAC_TXDATA,
 	.has_reset	= true,
+	.playback_only	= true,
 	.dma_max_burst	= SUN4I_DMA_MAX_BURST,
 };
 
-- 
2.53.0



