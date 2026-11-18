Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020180;
	b=OY4PrIolOj4Q+ONnCUZXBlk1PLapfqMFv7dToyYM7ZcMBmszXQpF8iWvkk3e0tH+/si1
	 Gew/RAueCCOQkqZsCONDaAkjc9xXUZ/OYGgmq7p5JWZYUl1W0CEAlp762t5cGxvk003Cf
	 VTyS99tpRt8gJbkHCjupAHpvcpmSN3CQnJWJWdvEs3ZLEyHJ5ltigF54wzBrgsehqA72E
	 C7qgulmn3HPYXEjFmwZQxJjxbuJcrmZr6rN4KO98KNPUnRtfeWx5m84ZSEE9E2inBGa18
	 asAE7qt8iW9YhLzCOuMWdFgmWQvRlJy5CnkpEgwjERhBeBHbkMrVLMvumpQIVueGnjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PjJUEq1y5wxTGkeDIGwdKT/tmG0XgPCNDPOK+hvpAqc=;
	b=ckD2PFhmFp3GI0SL9JfUQiOfSroOsRd9/YtwbhAfvg7NO3HecHYVD6Dd1vSuFaVVxDrg
	 wULGca+jUYlCrLA8ZlOYNZ/bNFKYh0NmuWLVmFYNWPSqifLk+nrdaWaCMU9UWtcMh1Okd
	 AyrH61URBO60dJiLa/gX9LSQ8uqCECJ8OXnjVLjv016H6EukL6M6chv0pZce6NMqYT6RX
	 xqw+03E689APrcighS5YccnZZNi8ywjA+rIuhNX//SgUAaQzdagftI6dTYCEtB6pCdfAy
	 rp+NyfEMtdrSdok8+Vmpkk2Z1T2PoNxTQZFJb7gLxlC0SzKuNnu08JCmFU95lmq4XAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vv+qIkaT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1A2606A325;
	Wed, 18 Nov 2026 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vv+qIkaT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08861F000C4;
	Wed, 18 Nov 2026 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020180;
	bh=PjJUEq1y5wxTGkeDIGwdKT/tmG0XgPCNDPOK+hvpAqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vv+qIkaThdHoPo0g96OqGBA58GI1RpTQULS+pxLFn1lEMMIskMsVbTy9jUzxyKdiy
	 xhBdAHQp88UhsnpU98KiiVtrN23vK9X5oJ9VSM34d5hnDuAbjEPbK3S0gG6Z6K1oc2
	 sX2MSMUrjCzNvrtpANyoLxKWM81TB/r7EZOm96ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1860/2651] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 15:51:40 +0100
Message-ID: <20261118150353.962701869@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 137dcd3d74874..c611eaf0ef5d6 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -134,7 +134,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



