Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020172;
	b=AUcSTVPWgh4oyI67YuKa1y3KIRUoPknoqSH3259TJsfIxiYhmzSwFZFNGJGf7J7WzyHF
	 iqyKDsZu0eqOo3R9MkYDsE3j0MSOdoPWnU5GRfnjMZbct+SUwG4Qcr+3rcR4LiwU13yEr
	 wH3fOMRqrdWEaxbZ09izBanR6p9dJm5YhRPltPOwtYu0UiRCiofQc6taOh69dowLlYt4E
	 v8eTlWWkXVf+5q6d5B9NA1+4tmw6hxMOTno32x0qOdMoFOxsfSW+7pQWq0Jq5RCeXNbM5
	 ZBEXPONZ1d30fujrA504Gx937Nqshyf/Tu2rdTU0cfQgpdIThkGOaA1ou0Pxw1mG0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8fgbhg+uyFigy0hDmGVkEWb2IxfpxThuLJggRqHrvg=;
	b=P7zg7p5Rw/eWnANMZlGemptpndrlG/xARrdsV9ROBPNPf9h6rKcHoH44LNi9dSqnDsqj
	 gHv2yqnoYvehaifw1mLSUQr5EVM5RWocyuiJHN10cb5uIAJF412EdcJhJ5LKowI3nFpy9
	 gsjGF4jv61u1RLrhUMOfrRI8IKRYnJ2/7wN5JjvrJmtJ0Ge8Buwl+me0w8wyJxkV4mcS7
	 nPlmlwynY7s+02D0gwxnnrsxrOobApF3nDoxpBUyUgspP1O7V810RZ0j3XK1G245/xry9
	 qSjvrF20si5fI1d4GflqXMMJIal79aPup4bOjkNeICQAMNh3lBDV57AkL/OT06T0ftg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djRu2KV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260D9606A336;
	Wed, 18 Nov 2026 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djRu2KV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF0E1F000C4;
	Wed, 18 Nov 2026 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020171;
	bh=Q8fgbhg+uyFigy0hDmGVkEWb2IxfpxThuLJggRqHrvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djRu2KV0+j+Nlytsm4ZCW03Q+DXXH6F+ybDdJ7vsEdmr5xaHKTImaz//6F0+O+Gkt
	 63A4lUh2LDxfKM63rEV6S+Poclgp4ftwoM1rHPV9uliWY1KPz6S/dZ6/rVVSL5VKDG
	 YzUyV6JZF5oCuvMc0Opxx0AJYTOl6iWYtw7kmnwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1857/2651] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150353.869002948@linuxfoundation.org>
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

[ Upstream commit 121963197200ca89050f05a704f53c281702ec16 ]

The mic (xMZC) and PGA (xPZC) zero cross bits are bits 3 and 2 of each
channel's Audio Path register. SOC_DOUBLE takes one register and two
shifts, so both controls only write the left register. Use
SOC_DOUBLE_R, as the Mic Boost Switch next to them does.

Fixes: 2a9ae13a2641 ("ASoC: Add initial WM8737 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/36cab58287bd24955e73bfe3a6fb24cae8fad7b8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8737.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index 33a3f88fffb3c..0734f6032c8d9 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -148,13 +148,13 @@ SOC_DOUBLE_R_TLV("Mic Boost Volume", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 		 6, 3, 0, micboost_tlv),
 SOC_DOUBLE_R("Mic Boost Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 	     4, 1, 0),
-SOC_DOUBLE("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   3, 1, 0),
+SOC_DOUBLE_R("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     3, 1, 0),
 
 SOC_DOUBLE_R_TLV("Capture Volume", WM8737_LEFT_PGA_VOLUME,
 		 WM8737_RIGHT_PGA_VOLUME, 0, 255, 0, pga_tlv),
-SOC_DOUBLE("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   2, 1, 0),
+SOC_DOUBLE_R("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     2, 1, 0),
 
 SOC_DOUBLE("INPUT1 DC Bias Switch", WM8737_MISC_BIAS_CONTROL, 0, 1, 1, 0),
 
-- 
2.53.0



