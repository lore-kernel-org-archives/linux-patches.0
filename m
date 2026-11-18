Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049787;
	b=4X+LEQjq6lPHFhJrYI2LUbzQMt08Jabu9q6YtJp1uFZB0plv5xz6izvLyv7Q5aO0AuLi
	 XZ4Lu9NUz5fBhouz7NPHb1u1O8dmTTSrjokDBaHFV1KFPP2XOFhucsPc+OlMi3j+XG/Rl
	 TSKlV2/TUag/0OYhaEoIYNBuDWyjTqpSHtZ5vxSdOSvL9ZUc0fM3Vejfx40VuXmADWrm1
	 T3WTu32Bo0yvYBW4q89KJarsobpVzROR1cu95ojo9vQ3VKl3EmkB9aACpCA3MxPVa2a1/
	 Y/Tim3hSFvtb0rUQuxgurBrvJk4qstI4Vd4P+HSOQx3J1z1+5fCHXfK4wjbn2avRICQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2+mQDVbizm+Du+6nl3ZxAymhPg8ahBkijvypuQSCqlA=;
	b=YlSkHRjOrYMg2LlU/6OL7ApzfKe4mZugukuiKYYznmguwI9gn82amO2Uy0mqjLu0kM/2
	 jB2ByNE6TATBcvlTgv1JgDtG0kyv1Kl5wFytpfpV1LsfFDuoYYMEIP9xK9rObzKqYMkoc
	 Yz1edKb0prE38HnI/cCDxcSUFpAn9aiGqfRd4Zv5I4GDf4XIB1qtXSvM70o+Ng9lSqTG9
	 00C3UdtbmyjuKI/epfjIgz140VRqgiNJHLaw0eBIYqib+68bBm9QdkFcCPSEXuwWk8v/O
	 fM7T90BXdfPWvIS3eIiji32ays7Qymff8n5qoQ2kx/QtK/+Ne1j6N4yqvfw2D1ohjBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wVv+ft/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99DC606A31C;
	Thu, 19 Nov 2026 00:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVv+ft/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361DE1F000C4;
	Thu, 19 Nov 2026 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049787;
	bh=2+mQDVbizm+Du+6nl3ZxAymhPg8ahBkijvypuQSCqlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVv+ft/h8L0GIxB7xA/VjyNJUrc5YEob7+M3gNRcY2/gAg9853TO7vOVo2TIgR05A
	 YRerVSihORX1VnjptJpDQ4tIKkxauZCrDkVTq/IfVe57ekeYlS4nGy0nKMwAV/tifc
	 DI7FuPeVnYhkv/Xve9N/N/V5pfwN2dCkkZuvuqIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2476/2857] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:58:30 +0100
Message-ID: <20261118150330.715121435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 90b54343370c4..04fdbcbdf0d9c 100644
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



