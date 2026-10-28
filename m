Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211709;
	b=EVkmkpnzZ/5zgdOwwFJPVCpYMW44OYv+fa7eisWTlLGIEZIF50Bm82q7d2xkZm4KSr2r
	 Uqrr9tHbFLXchv6IWBdZ3MPgGNJ6U6SAtqGDZMXgZvedZ+O+tPLgnkQquUF9kwLYFkxU7
	 2+FvvYGAx6gaoIMb8cdET0Og8Anon9aPWYBBIu1iu+Vh8FjMf+zkayOL8AN9R8yQxrVXc
	 ObKLYfpbXIiKvTAW5AMVAQPIt8nqZWnwuokko5MUdTEyW53vUlyg/3xGeFkh/GHBboeW8
	 U93A0hJ9jLJFNUYSGGD5TYKIMYtcEbr1duOjTWlMFlYhPvNlkCEPWh3AyuqJQUr9R6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QgzgDbhewHi0FexE7orMsUHpgQ7brg1UWfuWj0sm1zA=;
	b=1kyj4K6tYR3am9dtjdcfLxKph3wViJj/cuMdizgKvHU04mNO0cHZezi+rW0Tu816ov1t
	 zdhM+GQOsVi/7Vc0BTOhkuHCkUuBq5ckJwAmmAGfbuH9C+/G99gvQ4I2SB2KPc5ZkdaGI
	 BlsJB9kC3c5oBZsSA4qeUMPaJ11XGTCbRV5bG2gMw2uQfgCNvteSH9BgwobsOpsmXebCZ
	 vkZDf59t5ECQp6svGoYer3LE1YlIAswjc35chrNZTxNNZ6tlAp3Xcv+pxFk4HP6FPAy+E
	 xoc1j5YQTzKGZSEExeG5hy2OFk8q6DTDFr/B6LpaqgGoIy7MX5eb9N0wPHEHR5q7ZyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YPVpsNcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED260A263B;
	Wed, 28 Oct 2026 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YPVpsNcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EE11F01828;
	Wed, 28 Oct 2026 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211709;
	bh=QgzgDbhewHi0FexE7orMsUHpgQ7brg1UWfuWj0sm1zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPVpsNcLEqYAxVVOmj0csb3SUsG/is10g/hq4jVjyqN7pIly9hACRvk3gxK4xyhkv
	 QMLbQXfhGoHfZnWNIzrxOkulETfK/1f28sq9SaCmOhmS/Lxk7NZaGpOY4xeYr6vKge
	 PFuPeg3KitI48PZrpxHFQ1obMPwSjN7+KPyzK4ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/571] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028170019.268398335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 203436d2aeb7093290459e344e1912a418a6ebfd ]

The Limiter Cushion control writes bits 4:2 of the ALC Thresholds
register. Those bits are ALCMIN, which the ALC MIN control owns. The
datasheet puts CUSH at bits 4:2 of the Limit Thresholds Control
register, next to LMAX, which the Limiter MAX control already uses.

So setting the limiter cushion changes the ALC minimum threshold, and
the cushion itself cannot be set.

Use CS42L56_LIM_THRESHOLD_CTL.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L56_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index f0af8c18e5efa..7e75b98a40059 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -449,7 +449,7 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			0, 0x3f, 0, 0),
 	SOC_SINGLE_TLV("Limiter MAX", CS42L56_LIM_THRESHOLD_CTL,
 			5, 0x07, 1, alc_tlv),
-	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_ALC_THRESHOLD,
+	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_LIM_THRESHOLD_CTL,
 			2, 0x07, 1, alc_tlv),
 
 	SOC_SINGLE("NG Switch", CS42L56_NOISE_GATE_CTL, 6, 1, 1),
-- 
2.53.0



