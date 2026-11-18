Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026731;
	b=dTS2yowdsExMyhTNo0dkeVRKnMlOv79fntEUpRvcHhIeZ14xfWI635ZBkjK+oxAhJIco
	 1vTbfADLRB+QkeWp7MuImse2wiDoDvz9g2U/Rtg82LEkduy04HyukasXUm4kHp6ipTIcd
	 Fh2tmGXG3Eg8jgsh0ROL8DEKN8IWDtG5MYLiyYKqmSwuyd+2QK83lYbNTEHFbYe03WpLh
	 wrDJS2zLz9H2FrNfKMlt3mxww3qRlyXTZ9oPc6j1ftkvU2nV2Z4UTirxW52lO0bCCU4DV
	 G5my+YqYNhcMo+rKvYLHyeAvJNul6rbokllGlNegFc/sxeCHq/yc7jmJC282VgwpPmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JzCvas0Q8RznN/RkHcuineKLnQ8VWqyS/Q8WD/30Zok=;
	b=EVfiasrIAhT1VnjdRJ4PZMxzokSyDPKP0l1pJj7JhAl1jvxrS6v+Gbnwd4axfRmRW6kC
	 QsoDNMXIHxfyh3D03ugOcw1CT45sLqNMJ13ewukyEOX32dlm44ha6xtUS2B8CkNudKZIS
	 sjqFJaEhyqfU3S8+jSFVDiXKPtSE6ArvPD7MP/jE5AnGo/3Cj0QlTsa+rK5kgJ7q3qRn2
	 ZGIxxT+bhrNMP1RBhbMbjhalH093H+BE1jTox1+2o8VzXywlAgD6Vo3xug82cdn7+BYDv
	 j5rPzSsARap8IMvX0z/zL1rG8S11LSuxrVdOdyzkgUX0XbWSuf7la3hemD5br/vnkrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IWW9thM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEE606A31C;
	Wed, 18 Nov 2026 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IWW9thM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F59A1F000C4;
	Wed, 18 Nov 2026 18:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026731;
	bh=JzCvas0Q8RznN/RkHcuineKLnQ8VWqyS/Q8WD/30Zok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IWW9thMOX7WekUQCeKN2i7EJcAYex7yYmev6mMczNJDnVrnHUFRGinCuorp62jiw
	 KVNiACj4yqxfLs7/GcKG2Gc1sDYYH1p4elNLYbBNvk07mrPI8HNOnHDZ/cLXPaqZYg
	 aZ+nVri51bPWTNXdcP/ljFTsHksLobQzgVqZPBgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1512/2151] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:54:07 +0100
Message-ID: <20261118150216.932259023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f7e48f27649de..14c3e1a7659a6 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -149,13 +149,13 @@ SOC_DOUBLE_R_TLV("Mic Boost Volume", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
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



