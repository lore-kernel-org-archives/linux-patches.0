Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061604;
	b=cR9s6m22hIBw7sso8TCExdZLv4H0GWrXGpo47LNSzqu4TMSfMF7Oa3U9yx8Grf65MReL
	 JI7oD6ME7BD2iBd6mkflRdoeMOZV/1PJwJ5uYVbJU9qSq5eOKDSkSw4iFjbfxbpp5BBNg
	 qG9RUhZe1oDZI6cQxg0WCmFbUbaUfGrK5eLOT2t+BlZkjyGaAMYrsT7PYCt9f2zeOS3/B
	 81STVYGE7FT8ydD+a+hF/aLzBNBk/kB3gjOL65j4vmkzcpO6gdXmEd6HblegHgmLGZM9D
	 cMwEsW+27/if24oG1dNhr3rq+Aqm3SoNdblCXTNNGw/yqHAoY1Va2Q4yvYL+FqnutkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BfnHyFBHC2HwFg6PmBrKR4sEbM/S39YjTOFsh2cTF2Q=;
	b=dm2p3LuvmzSrAr2SvSpjMZKCLCCH0rI0frP5LijZcx6lVrxMdl5I5rKy7dRxEAvtYKct
	 l+yRplq+j1h2GV1ec84XGGeIKvogU+2NeLxFE1i921NwW6aWkbuceAZm0J14TEWizEEzc
	 6gEl4ySaz9jF7qQABgY/l54JuWrP34Q5OxZALCeSdJzAtBo82lAkvfWmDPHaV3FCKmiiP
	 vXmicgu1IIm6gRRZLOOwNsSsM1aO2WJMs4+uhGbhn27auv346pPSzLIUWzg8ZekzbD+07
	 M3Z5yrVR9Ljr5CCEaxOIZcli8ONO8TuRO46/NJ8igZzAr4wdiqkgxGcV5aCJ5fr5LkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWjvbxPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC1606A33E;
	Thu, 19 Nov 2026 04:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWjvbxPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683DE1F000C4;
	Thu, 19 Nov 2026 04:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061604;
	bh=BfnHyFBHC2HwFg6PmBrKR4sEbM/S39YjTOFsh2cTF2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWjvbxPtdj/Jng9WUB4ytdkq7lt22ob117hvOXjq6bfRdC2GHyAk6R/cOvWuU5jjb
	 DqZjdw6ej7fydQtSAR+XpzFNGetz/j6eV/M6Qr6itaoWGgW8ClSD4SIKhkCPoAxsqb
	 HrSUMMjkToBrrmiwxyKTbg5Hy2quCvub0zgq5RHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1613/1848] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 16:00:51 +0100
Message-ID: <20261118150027.065654400@linuxfoundation.org>
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

[ Upstream commit 2e2da92de9bffd2cdbb9a2558fe60de7f1bb09e3 ]

Disable the gclk and reset the MCK configuration when an error occurs
while enabling the MCK generator.

This prevents the gclk from remaining enabled after a failed clock
configuration.

Fixes: 73ad0df57290 ("ASoC: atmel-i2s: Remove unnecessary audio PLL clock (aclk)")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 0341b31197670..d133bfeca496b 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -466,11 +466,21 @@ static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
 	mr |= ATMEL_I2SC_MR_IMCKMODE_I2SMCK;
 	ret = regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 	if (ret)
-		return ret;
+		goto err_disable_gclk;
 
 	/* Finally enable the I2S Master Clock generator. */
-	return regmap_write(dev->regmap, ATMEL_I2SC_CR,
-			    ATMEL_I2SC_CR_CKEN);
+	ret = regmap_write(dev->regmap, ATMEL_I2SC_CR, ATMEL_I2SC_CR_CKEN);
+	if (ret)
+		goto err_reset_mr;
+
+	return 0;
+
+err_reset_mr:
+	regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, 0);
+err_disable_gclk:
+	clk_disable_unprepare(dev->gclk);
+
+	return ret;
 }
 
 static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
-- 
2.53.0



