Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061733;
	b=l2qnghKFyW0zmp9SDs5UQOfj8hnQiAMyOZEumTjPWmI5FROe3gYxhxZmKH2r27eMd89S
	 OCXCO2ZXYwW7ZVYU3LGkYP5FTV3uH+A1XRe00iJCdqjeDCD/XrwMuYBawrj6eLEepbq/F
	 HG0n6FxVx5aYcJurtUXc301UIqiyql5hzs2+n8F4P3BP1r10P10t2ALFYdIvC+5+fdqz2
	 8nKouxrX6UoLYRkNalS7llQFo5aA5G3ZcmMS9Pi/+anoDZ4dowaWhEqo73FPYsbh68YHW
	 YN1BcLNReXUMHO7zJl/BxPbobAD2/LGd0z17oiE9ymlXarncuaDXPfcJZwpmWrbK6AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G3Ylg0onGl58D6CmGBhJ6v/GW2Oizgkpj86VWp/8di8=;
	b=2wnO9bPCegyuFAJxcoBXry93dp+UpgsLdrtuLv5v0RUXInbvpcgelAO9eKmBI0M/BoCc
	 GV2PdIkZFG30fXIrrGhnfGFOUSYu4vchNc/Z0HvSiLNFchbalZrAVjFCIm0LHL+zbamqr
	 L1VneRC1VCTH146xCiDIMSIW+xkwisGVHPv2kEgTJgCXm6w/JU7/Zd49sT2xAJQXM9R3x
	 1wFYcO7di0b82NupIHUuey5z7K3+2JyCAMvTmxcV5T2sm0vZVHSpqh5R3pTB86hH+qU5v
	 8Z4TN1eNhubcN/mYs4EY852HzrFTp3WwVUIdbR6RvgFRb7LFdjOOwdh2LIEI0QYTmXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEee1xYw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D645606A320;
	Thu, 19 Nov 2026 04:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEee1xYw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD86A1F000C4;
	Thu, 19 Nov 2026 04:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061733;
	bh=G3Ylg0onGl58D6CmGBhJ6v/GW2Oizgkpj86VWp/8di8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEee1xYwLJ/T194aNWZSfNr+zuZd1W+7FWeUje6ph16BH2eC1YWINRUceyFnp8xCi
	 xO11kQ0emPupQ9TMDKzsUIwzhDS7qt/jfCCPxeP3L54Iwck/pbbLRzzvhR0S0dT6Pg
	 tVck9btOw4Ub3KK9JGzYkkaBN77VvMkXkNImM+qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1641/1848] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150028.356652403@linuxfoundation.org>
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
index 7a3f9fbe8d53d..9156a28a548d2 100644
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



