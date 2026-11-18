Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031733;
	b=nzMKXb8FQeuVkB54rkQmupcPcoA1vqGtbpV+PEqnZjm40V1H+j0cpl0akolm7J4FkPCq
	 L4RtDA676cPlpDrxPyObcM1w8u2d94z0dn/9DR9qoLAL5SkDZ+Gd40UeK8H3rEld0cby+
	 fNBQS/Glvym8AIyyvRgjDobqhVB46EsAlO7Vq7QDem8UN0CHvn+u2zZisgPOKH3aKq8ZD
	 nK0xr9uEEtCOQgosE/u7Bd42JQrFB9RiaIx7/8IJa1yf5YK0o5QMnrWUEzfYxTZh16Et4
	 T/gW5n/cRNMAQDZl1Nc59ofZmW9gPWpf3lvKOjjYmNFbQXcBvmy2TmlZYyWpL3+VfFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WF+E5vaP6vGPyl4Ps8GQpmSzoY3YtWK4/PkjdI97Kcg=;
	b=GChFGS5GkV0G0km2GvwPfkKm2KF32JUef/QDJitxvTy74fBtqnPk+fenstnxLiR0I8g1
	 JFmPOYH4BpH42+v8ozBzqf0Xb1M4J+rxfy0IQkAVzr67vpcjfAqi0s9mFV6UfkZiOPTnD
	 CP1gsNDPuPln+rF/Kv45EInFGoWrW6FyuThwUyxrTohNAc8nrYc/caD25YzK5IF8gKgXo
	 rGteVC1OoZ3ZraCHWA2GzRgOEFNz/UchmdGDp+22T2junqlvLC8N77HrYv54i/u1Ypi7w
	 kktE3D0n8Q0kC5A2laXOVTWhZ4PK2M1+c+dTAc9MBsWRmaMPp4Xj2PfHbPXaDusPG9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Edcw9RLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5A1606A320;
	Wed, 18 Nov 2026 19:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Edcw9RLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03791F000C4;
	Wed, 18 Nov 2026 19:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031733;
	bh=WF+E5vaP6vGPyl4Ps8GQpmSzoY3YtWK4/PkjdI97Kcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Edcw9RLAFDL4bni06s0T4+4HO3MRzX4q13hUMu/5o8bwNfmO4zKpzwxFpFlFeygOk
	 j3QsVmpVvcdUPrj58b3SRwdnYA9oNxE+LEYp3UFEy5Ja2PELdBccKQEEug6E7v0Os+
	 +KW0JIoD4B3QZODDjeyfpteh24/p+XjbPPuMLbXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1163/1756] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:54:50 +0100
Message-ID: <20261118150056.293708967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



