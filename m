Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041569;
	b=3mJItse/Ut8zRg8BbxIFdYSWnoMihNx6B6qUlolI230sWQcA1bB3csLUHAY7Y+S+DloU
	 u5963bD6CgYgkf0sYZSTvwcyPLlij4ADXoKHow49R0yuJ85vPFqiosqN+VKh0L8eUIOMG
	 pr9XXWkWmERcs8bsXJfQ5mFDWR3T2Uq9QPOOiaX0Utg8+8PzAtujHiHOl3hKG93ExnoMG
	 8JHBZ0JYSSFFzLxyYqd7JP9Ph9O2WZtxwr0Hv5eD25lkrSdRKx90hFfK2EscmqLCPMLgP
	 OrjI5sz1+K5kezUqstFJCqZg9VsNnA2nXm0wtDYZgz5jmw+D0NiUX17LJ2hDZMtxk4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxNhOZ3jsPoHL035pTImHoeEnaIIPeVpKGy2ucmDXvU=;
	b=ALa2C5aJd4n1kJQO6lKDJ3GXD1iOzQVaCAtKsp/u7EGzHn3WNeHOyoFZJgGDblADQ+P1
	 FI0TtiaEA7i3a54WQnvtOBxj55RMEcJpJfj9zhd56hH/jOkLkkyFLjCONTa3VQvu5hOgM
	 ahILjJMmnA++mg4LILIBgUdccuX95hMbbcPn5qQO0WspZYSXuPfoVJ4dDpPH5q8W9Xq2b
	 V6oe7MixB+scTpTuHO7seyU2cHEkqK4BeWJpyPYqOhVJxXpXZ29sJlAd5nt3OBBLcPw45
	 3V56REdtgJ81/8IU2DQEhLkfJ+CnJCXbvjgMhVqEQkOXlHcq0u5qQN9IK/JyIQUWCzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dn8eCwb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2017606A6C6;
	Wed, 18 Nov 2026 22:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dn8eCwb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5611F000C5;
	Wed, 18 Nov 2026 22:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041568;
	bh=fxNhOZ3jsPoHL035pTImHoeEnaIIPeVpKGy2ucmDXvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dn8eCwb4nw+pyDZDgF/7GIq9Bpo4bo7j370clMPeQAG/vGNYBjnGhsdhaK+BycsAw
	 M+5JZzmgfExPhz7EYOBUxzlx5h60x0254KfOENsbxsYoiCDjhiogVV0GzrFZMB3UKV
	 nrjsuLPOeSyr+pCldRTklkDht7+z57Nhefcb5AeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2861/3318] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150446.413293824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
index 5c7d55212838d..008cb460bcb00 100644
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



