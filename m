Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061682;
	b=YP77FEx2/bCpTXxAL7ATzi9BezmOH1U+T9jH0DOPzqa8BNGn8dwpNOx7hYNAKlTWHbHv
	 +MoWGDU+vbSbY7azfPS7/4C/RiHLDY4iDDB+C4FJlUyjuChCzpilVBh67lycBaCDbpF0L
	 3ldU2xe9eVsC7ir+NxC8gGoR6L00ISRR+WMjcdehn/ZEE/uaDAtYbLewpJEtmFi6KWMQb
	 uzzAu4CjXgGmqQceVR6tHlppba/81W7QNsWHDHpbhLMLkIDf/2NQcnAZrc8dJ4lV5DxTm
	 4ycwPYhYJ0zosrI3Dllm5CbMB43hZ5Oxh23aHQj22jyHb8aq4oGwP31OlqPRZgdHvCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ISGeAQBdnKeDsdcOe0mnfu9hnpTBifF2tSck8VJ73A=;
	b=1DcRCVdKNg/3HUWGpmn488YWlqVJs0/jnheK+S4a+TZAFY16E3riWiv/KXqVgc3IMOgu
	 rGgcMW9KzGP+BlLsH//FtJqt3sga6OQKAdnBwbPs0WS7Q+RanqI0iLL6DC23T0ssIAOiA
	 GKvRYCJmy1XS3Q9emHUFXteKLfwTOZSAU/WY72uLXysmUovtZVH+2Mn0cVYJGCkokScbq
	 S1WNB+7RBpAIl+MGjTph+9F6oWKb9KGFosJ2FSeqG3MhJ4Lndk4qjGNuvfZesjcap+2lc
	 2hDP0nAmu2ckLfnignZJW/aMaBwoqwO8iJm7fJopeW7f95KbbZrjvUUVBCL6dVm+WRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kAgAgo/2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442C606A325;
	Thu, 19 Nov 2026 04:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAgAgo/2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1841F000C4;
	Thu, 19 Nov 2026 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061681;
	bh=2ISGeAQBdnKeDsdcOe0mnfu9hnpTBifF2tSck8VJ73A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAgAgo/2AkRpDadF6TAmc7dtA5Fo9UQnbzeIgolaXbI2kbb7aquVR5k2Aaq6JBKxj
	 XpzYO7tOPqk8I3V21lrlSnCU6KgdufuVeqLAoS19QOwRP/LsFn3FykTxy6dGKgeqE3
	 +yjJRut/RvquFtFUsOvLNM6K7yv0bQWaZ29UaOo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1638/1848] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150028.219302013@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 291d81d628f3453026b029507a26b856056e4fdc ]

The noise gate hold time (NG_HLD) is at bits 6:5 of each WM8958 DAC
noise gate register, not at bits 3:1, which hold the threshold
(NG_THR).

Fixes: 1ddc07d0f13a ("ASoC: Add WM8958 noise gate support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/8acff0f7314eef9eb3d290ca7855a87052d7e706.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 2cfe067a9d823..eb9e34063db26 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -700,17 +700,17 @@ static const char *wm8958_ng_text[] = {
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac1_ng_hold,
 			    WM8958_AIF1_DAC1_NOISE_GATE,
-			    WM8958_AIF1DAC1_NG_THR_SHIFT,
+			    WM8958_AIF1DAC1_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac2_ng_hold,
 			    WM8958_AIF1_DAC2_NOISE_GATE,
-			    WM8958_AIF1DAC2_NG_THR_SHIFT,
+			    WM8958_AIF1DAC2_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif2dac_ng_hold,
 			    WM8958_AIF2_DAC_NOISE_GATE,
-			    WM8958_AIF2DAC_NG_THR_SHIFT,
+			    WM8958_AIF2DAC_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static const struct snd_kcontrol_new wm8958_snd_controls[] = {
-- 
2.53.0



