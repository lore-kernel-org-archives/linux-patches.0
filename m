Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031850;
	b=fwQkWTtxEGSvH1RoUvOLkEch+hg3vLFOIg5ekHGxveg5EFm0coCNsW72AR48RircTHHk
	 gIKBB05dmAKL30zcbGQQj1Q+rKrRYA2vs7vHtDxOWi8Kt1WRo1oAIi5v2TyaYpOJmx6dh
	 SRpzPy68xaOuCIR2yVVipp+ql//RrvMJZXR7IFX8is9eGFc5jqY0eObMfiu2KYbDCBYro
	 vkJTvGKHJmUUgqEOa1GYxmQuYMWWgzXGhL7tiMmmxUW8aTvMmG/0VRFMu+41LGiSA3Q6Z
	 xFhsXkugoh8hoOMEffM/hSCrdk6pWWx+XDwmNmj5fdHe6brYXUvZMzuCcYIf7vZnTUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4bwrIG0EtLv7Fj17iuq62qqmt35eQLCDiVQS9U7N0E=;
	b=ETDFqFbvGpXXHt2vsGfh2iQKYlTN2IpnB3H99olDvGb+5gMvoMur2mD7O+TiJuLZd0Me
	 TCP/rMbAr2ATmV6F7dav1BnH5v9qE0UmNbNjb1NiXtyJgnSD9pKN21R+UD6H+TDicy+JB
	 iz2Z1R/ZDTENUgvRPhSmrmu8U6ISeONtJ1lLHmkhcYwE3Vw63pYYp100lnOkCVkWvLaRT
	 Rjb8ZBQmwS0RV+q77gTZXC7KG1UKJZ/sr0Rm27V4SOrZisiM4W7BqQ4tg70qdGJMzLerL
	 m70ROE2wSs9xTMJHjKFcds41R69pfa2qOK6PLrvPPPQDFEyLwpIadEgj9Sy1j3F9O4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iK085Ibq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10CA606A31C;
	Wed, 18 Nov 2026 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iK085Ibq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9DF1F000C4;
	Wed, 18 Nov 2026 19:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031849;
	bh=L4bwrIG0EtLv7Fj17iuq62qqmt35eQLCDiVQS9U7N0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iK085IbqjYUBk1O27tvv5M92rgfYaImXCopdLYLvZi4KMcvF+bLD105tSnWM1+RHp
	 U9nWlF52R1uH2HEAl+tjhZf1+w39c+M0YA7JvvGupNc1vRYe7rhqInafmXHQ8Zfxer
	 D3kNEs3ILGtzsbrQxrsWMqEZd5P4RXzjhZq3nE7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1204/1756] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150057.762093820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index efdc242c2edea..6033187ab3588 100644
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



