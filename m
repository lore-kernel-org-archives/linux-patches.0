Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D1E1C3C00;
	Wed, 19 Feb 2025 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956280; cv=none; b=ltztuRX7aiEJqI2oGuXy87E5cvoO1TffYaqCRP53wDhVO+hSOzyFlj8wsB6bAScjrKnkafpviHJZ9Zz0kwcE+CGqGAnlb1caMCjs9Ck6QZFzEBr0pvyRzMIdqqtTM08uRNuyMHlEXn7Tpr4dL7eUdhRG+MkIXERjhEvIAsQNmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956280; c=relaxed/simple;
	bh=MCajxj9XY320pQI8eJ3KOPbn1npDE7V8HiVIP1M1Iq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fzhm6+qL/36c3oj0tyROsvAP1CFPVrN+dUnb5/dB9rv83T0Yhj8yynC81/W20R0sgW0Cx1yTnW3omoTSdB5RgjezROMHr6KMCKPAfhpP1XNetltroonN0yc2z5AegwuwGpmTzo8c9l0M8ghbOvRgohXf/z8MqYWG+Sg7dOgVAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5gozzxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5gozzxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0041BC4CED1;
	Wed, 19 Feb 2025 09:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956280;
	bh=MCajxj9XY320pQI8eJ3KOPbn1npDE7V8HiVIP1M1Iq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5gozzxv6piMnVMKF6WiYQqNWqTWmmfvZkKe8PPqiiMRhF/9IQDgOuxCuqhPy2sFD
	 +qgECXgKCCTwGYmxUyNPFbC1aTZLPIYNjb80/mGhPdNDHugtlw1LeoD5oFIB7uF8v5
	 BxXkgu+nIHSPUkuDZ1o2Cs80HL0ccOW9Eu8v0gH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/578] ASoC: renesas: rz-ssi: Use only the proper amount of dividers
Date: Wed, 19 Feb 2025 09:21:53 +0100
Message-ID: <20250219082657.271391179@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 55c209cd4318c701e6e88e0b2512a0f12dd02a7d ]

There is no need to populate the ckdv[] with invalid dividers as that
part will not be indexed anyway. The ssi->audio_mck/bclk_rate should
always be >= 0. While at it, change the ckdv type as u8, as the divider
128 was previously using the s8 sign bit.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Fixes: 03e786bd43410fa9 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20241210170953.2936724-6-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 5d6bae33ae34c..468050467bb39 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -244,8 +244,7 @@ static void rz_ssi_stream_quit(struct rz_ssi_priv *ssi,
 static int rz_ssi_clk_setup(struct rz_ssi_priv *ssi, unsigned int rate,
 			    unsigned int channels)
 {
-	static s8 ckdv[16] = { 1,  2,  4,  8, 16, 32, 64, 128,
-			       6, 12, 24, 48, 96, -1, -1, -1 };
+	static u8 ckdv[] = { 1,  2,  4,  8, 16, 32, 64, 128, 6, 12, 24, 48, 96 };
 	unsigned int channel_bits = 32;	/* System Word Length */
 	unsigned long bclk_rate = rate * channels * channel_bits;
 	unsigned int div;
-- 
2.39.5



