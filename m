Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061612;
	b=Cv7ExVmG6fFrW/2juEkS6LMO6nIbeD+TApSHU/+CzJXRtc+aYRmTFxI6HVBXjy7RoEBo
	 etBfvywfwZo/r+fV5lzuoBJ9rDD7oVNzp6OVyKGfUCSUx3YEvrEeAX6OoaAmE4Dxinxld
	 VDf/uD84P/aLGA8/NotpszjDyAxyyDWRMos+ej5jFAk7WvoAfocjEfIkgph/xG8pgclFD
	 W7htDUAxUBaZxBaf5bMGZ79YG49UZ9GVCTSjr/G7plHbBQBiyCyK5yoJxOl0qzgqCoBk0
	 qGGR6Ew/t7ejrQTcSTY2UiYnfnwhTmE6CrXLcUHAymTww5rSxXJXUxnlxCAqKciQ5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvsstqAAz1ME4qF42ZT9MSCBRcC7Q+SMi6ZqDy5R8R8=;
	b=wiNDbZapqemHnMaSwGlE6FjExqUD1UXQwQ19k36PfI5QKiHvonPdlOlexxw/s/jx1Qac
	 9OTs4Ho5mpkXhsR39mhpuFlfnh8Gs9A1iboHTPDuxHIUYKrFw3fhWqt3cHIn1us5hxRVh
	 z1thiMMNbCz6XwWgycC6TdPOg1ejUs26ybuLyKfycTrZAmdFnFwGDnZSSPrDuP+PRsFuH
	 3VJApLM+yDKPOMeS+AWxYsY3/Ib3BrqN32M8d6Fu7wMjRByxsVfCGvRtK9q8VbGd9S5EO
	 ziV6fcN5o1AspMi28mvjxro01cisMiAXvB1B+jfuKkoBKBE7Xb5hBu842cDvCr4Juaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAzEXq1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5973860A2607;
	Thu, 19 Nov 2026 04:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAzEXq1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD77B1F000C4;
	Thu, 19 Nov 2026 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061612;
	bh=rvsstqAAz1ME4qF42ZT9MSCBRcC7Q+SMi6ZqDy5R8R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAzEXq1D0BgV0zl9sNDoZKz8BFUjPOZMHkaQCzf5QisLsM9a/2tqRWauzmDOt7aN3
	 1kjmKrEXpqeJDxrbUX4tBf+W8mIgORr3NTywuGiD1gC9S/vP8OTm843Tvmr88/lYw3
	 nhFdATidMSopMaqrvMJb0pvwD/SN+B4Ep4EbUk5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1615/1848] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150027.140001832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit be952abd69c1f2c845e42e72147751e4c910cd81 ]

The muxclk is an optional clock according to the device tree
binding.

Use devm_clk_get_optional() to handle the optional muxclk instead of
handling the missing clock explicitly.

When muxclk is not available, devm_clk_get_optional() returns NULL.
clk_set_parent() returns 0 when passed NULL, preserving the existing
behavior.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 8f0d517b8facf..8fdfe8230e160 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -583,21 +583,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 				      struct device_node *np)
 {
 	struct clk *muxclk;
-	int err;
 
 	if (!dev->gclk)
 		return 0;
 
-	/* muxclk is optional, so we return error for probe defer only */
-	muxclk = devm_clk_get(dev->dev, "muxclk");
-	if (IS_ERR(muxclk)) {
-		err = PTR_ERR(muxclk);
-		if (err == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_dbg(dev->dev,
-			"failed to get the I2S clock control: %d\n", err);
-		return 0;
-	}
+	/* muxclk is optional */
+	muxclk = devm_clk_get_optional(dev->dev, "muxclk");
+	if (IS_ERR(muxclk))
+		return dev_err_probe(dev->dev, PTR_ERR(muxclk),
+				     "failed to get the I2S clock control\n");
 
 	return clk_set_parent(muxclk, dev->gclk);
 }
-- 
2.53.0



