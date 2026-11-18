Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026513;
	b=Yi03+IX/eYwZ0LYmZFjtPg2hKyIVhK27mPrYNefY1dwO8lrD0OGrSUPaMmcevIs53D4h
	 vqxZt4cxvXLKg8EmNoLKoEOxOpftEz3qzer+wuE8l4Vh1xCifveF+FjyXOuSlBWPJn3JQ
	 qr5GFpEeHtUmeMBnsMe1OvoScjVyR31OBJKUQiB/j1+E8uHXLd4xzAgD88WK88YeIyyfe
	 puycPALiRskcMyGBQRK3Gfj9MyFtO3KS+fFJKwWQDSIekZ4qYlb8A0WZih3e3Nas4k7AL
	 b4JOalYLPdVigOhp/fWihE0/Z7TQJdUmh6uTTGClqDVcNDRpJ1+pwp1Jbo1v8A1tZug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxfGtPMBJ4T3vrUjkzFv81kwk5Nlj8htWSpJVxOAGYQ=;
	b=o30akvep4ApYPqlotHTpScOOPUXhZlAlV1TnewpASGtA8rOsirbrXEt/yXp7fzureK1T
	 jpo94rU+CN9kdAeBVx2RZupPQs8y6EgT498hLj6gXb7vvNAPxTZ3DI7qzZ/DmS2BDGzSY
	 J8UKcZWWH7TibFgTol8PD8+gK+MFb633X34vC0sRKYPS1o937QG0+1ng2NwuRwc6cJ+Bb
	 DSIXTAD11k8sYNXI/OrKU305Pgp1+aL8tOrDIYCm9htiqvxKH1Rqkg27IetiFbdDdkiqo
	 53FimBsftDcf8OyyjEvkTYmZadv7xT3apgtfBCcPj/6l/8wpgR/lUcaw2ADjqEV2XnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvSXM0YD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B051606A32C;
	Wed, 18 Nov 2026 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvSXM0YD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD391F000C7;
	Wed, 18 Nov 2026 18:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026513;
	bh=nxfGtPMBJ4T3vrUjkzFv81kwk5Nlj8htWSpJVxOAGYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvSXM0YDZJssep1n6Ye74xHVzmPF9WkMK3L0WJrv+Er3sCI1ZFHwt3HEOquXzpR6m
	 nWj42SQupzv23CooqRhXtZ1AgAklOeILqXmj7yxwJCqtSMdRftc47b70ueEYfW/oe1
	 ifjcvFfA/PWVR5vdunuEH2wfO1tQhgVkd8eMc4Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1460/2151] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150215.095052399@linuxfoundation.org>
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
index f1f8a2d0008ce..3135445805ecf 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -585,21 +585,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
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



