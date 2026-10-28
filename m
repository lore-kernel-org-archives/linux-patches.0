Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209940;
	b=yKoWkaEXg6BTJY3fqgF2JDA37kzjSOm2v/UGt06KtyL2pSJco1+XQOKPEdRDQGvkYpBs
	 wfas3oQqWJjWoFU/sMedwyNTHbNH+m/KWOGZvh4mG7RMMKtlEPL8Xjvqk/8Aive7j57ai
	 whqSJUNqU3opl6Fi8H9ybJBZ4Wi9zcQDwbsOjaVFWxl51H01YvzsvG9mGqvMC9od2zIJy
	 qJJXL2/dbc409heYX1lmyWjzEo2u7Kg/q6BsGJrwfa/OeXkz/5bt2xT+MYoKUUvwnp9FK
	 olYDz82QABaRZ1EMYPDjOLjoO8tltiNNTeidzFQ/QyCJG+rNK77uslXU89MSUrhcpxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BT7Zfqw+/FBLCWctWREpM86uk55x70p/iFieelvGPlQ=;
	b=VRwfgY5jxOgJioAs2XNgLcsgrgo8dn9902ldOJLE1glMyY7tMhUrBx8W/vPwaYVVuTKh
	 4YBLx3D9fnkM5fyVwCGQbnEjm8xxxgl3eu9cbBSfjUOYZHLLS/taNMnNm0TSD8gTI+YHf
	 Sh8pZaNO90ZdLLzZr/XRH6XQ9LfFoTzdDhRUxSARiFF1eV91PUPNhjF3KVF0n4garMuMW
	 GKwsruDha3B1J2/MImbj0gj3NFuVEKFWIPZNxk6y6IwgLKq4mjQtNXlhD7whpPGTkLOz1
	 TqEceq74dJ6U6W8nBqNBlCqYizEuL10aRc1EY2kRG49bMG1LM1f9XerM16Qqvb+hk4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SDeRM/9Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5096606A31C;
	Wed, 28 Oct 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDeRM/9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1164A1F01825;
	Wed, 28 Oct 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209939;
	bh=BT7Zfqw+/FBLCWctWREpM86uk55x70p/iFieelvGPlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDeRM/9ZU+yg7A7spE8ERiHpsXgw9i0sGh+UHcxscU96twPyrAXOfbGInw7/GZlo7
	 sPHvDsoPLyNpwvNBxHWrWCXtENC8J4bp5q6eRYGmUQRHL1ZoMpF9iMFgb2vA569uVs
	 DXkl4r+2hsvTGfe3HpAZl3BClePa5FxBLruAfjec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/168] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 17:59:16 +0100
Message-ID: <20261028165943.576358901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit d0567ca9a2faa33efbe5ae84ef7b86423a93bffd ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
Table 66 of the WM8978 datasheet puts DACOSR128 and ADCOSR128 at bit 3
of those registers.

In R14, bit 5 is inside HPFCUT[6:4], which the High Pass Cut Off
control owns. So turning on ADC oversampling changes the high pass
cut-off, and the oversampling bit cannot be set. In R10, bit 5 is
reserved, so the DAC switch has no effect.

Use bit 3 for both.

Fixes: 823dba519122 ("ASoC: Fix broken bitfield definitions in WM8978")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-6-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8978.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 718bfef302cc6..6042a2fb7329c 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -255,9 +255,9 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 
 	/* DAC / ADC oversampling */
 	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */
-- 
2.53.0



