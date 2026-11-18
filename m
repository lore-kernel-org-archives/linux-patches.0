Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056246;
	b=hbi/tKtk1UoUOrtwsRboerGkoxt6ZzTcDpInCxudhE3+Uawks462PZ8KSlk8RBWZprv4
	 /vqFYFbz10tT36e0hTt2+PuczND21CgZEIZ3WkJg7dNCn68DReAKpBSFQCjKcT5zxLiQj
	 9Ix4Jl8V8FEhkMJRet72mvlTDZCRy9PCcjn/EyjxPVfM3KuSEd9pmE9JxEibUN9lvjZcK
	 FQC4XmXGVNCZOwwrdKtK82Bdp/OjQVgXYwWj5Dq9VNU+H4Y/lrnYHP3KdLY7XiI4LjYiV
	 U3RqPDeSjYsU/pA41R5cYtg8a41CIoMpP1FBh8RQ3Q4Rm8+CNEH7pnjCBMX8HY3KFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rga+7D64W9D9cUTjgujawlmO49Q3JlMzpXrqECBtR9o=;
	b=QZB4WBoTE4ikdtVjOhW9FTMp8OnFojvoQ5Nnd7/qLLUmNoZfFauJ4BxpbYtImLbUKXYS
	 aEmJDuv+XgGGMqZU/WHBEjutsVNU+MX+F22q7UpGLPUD0NlCkUmAIh8ij2ruXUOLOwtNe
	 NxXiZhcEteMFMkzPiGn/7aAvaaJ33zd0k4Fgeh/00Zi2+xReipBFy5rYpsp6eSHGgSXJH
	 VuUdzERm0wG494ouFpXF79j6QDYqceaWYtt38R8ziOZxqDB2/yXKPhbPQV293mVcv/oY6
	 RPpBWQgVImLoKgGZU1vx3wJ5bBhhFFf+mQvQJN2/NmCxncJ239oHkXWhPsFR3WgD9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viewYNpO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF71D606A32A;
	Thu, 19 Nov 2026 02:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viewYNpO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB111F000C4;
	Thu, 19 Nov 2026 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056246;
	bh=Rga+7D64W9D9cUTjgujawlmO49Q3JlMzpXrqECBtR9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viewYNpOUWD+OZZ2lXd1aZ8wWi3UvBeucyT81qSpJ4s1JtyJ0tfVkSA9LM+RyealP
	 6sFxWf8kIv5Q63hlgHCCatZoestctofknkeb95hNzKrWcgzUU52ZWl2/MNn41beEeQ
	 Unf8oyVnFaKxGgdaB2SEp1RcXNM/tDEUE+z3kMb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1919/2214] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:59:55 +0100
Message-ID: <20261118150127.823935651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

[ Upstream commit a747ec6e12cf7a71e42567a479af18b930890d9d ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6d6f8b832705 ("ASoC: WM8985: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/00ae032401aaad740b61d664c861b72d2e5ed520.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8985.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index a7e01106fbc0a..19b1f305162e0 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -327,7 +327,7 @@ static const struct snd_kcontrol_new wm8985_common_snd_controls[] = {
 		8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8985_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8985_LEFT_DAC_DIGITAL_VOL,
 		WM8985_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



