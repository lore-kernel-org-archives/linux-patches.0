Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026779;
	b=q2ZEvXSC4Tn44M2MVtPNkWhMZ2MMWd2QfbCUSExruIgZKC8q7nl0QtPhzTlc9LRd00vb
	 O0JQCHaejZh19gx0leV5hGRojbJG8uewQlNu3vYQHzFUehM0DZ9K61gkBeOonsTfCxArG
	 8zj94Cad9JOxPblwzoGiT3GqBjMEybzZrJZRZ9LpgmdhmP7lvZng3W4NLrqjG/HT8NomB
	 aXrLGdcbw1BK6BDFc6hUaa9VraydY7Kk9Rz+GcVI1J/ZIXjkfnLTmqa7vQQ7mY9sQgX1S
	 /qBv5Qz0xJpDA50BXVAP/+ArCq1CrVHLUEjKvUB+1+WYqGJLAk3wamQFO1l1HW4SpBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TPmA5ZXdIXfHmcWgkzxuSunVP8mKw7/jMGoSFC07W0I=;
	b=4oqAb9hj7lOPN/b/RlBlQrbGe2lOlCrSh3aywSaS/0mf/O096t8n53aWcO0Rkb4eK5z2
	 3nOatEynswVlkHybpWNyQxa0xXeEPpa1XhHqBVt7zyt4C/kNvDnT00r8ULhgmjMHCfI39
	 eUWRiKMNiMpgLUX/vNuekm1ZKRJZmmvdEwRz8B8ZrIDEKH0ILcRiA9BNXIZPH5TQ+H34J
	 kPbFhbh5PxZeLbKYpPai7+NwhFCYcKSM2sichpvglu+ohtlbFeaOAI/limfJWcKyXasK6
	 KDM0a0NaBs4fnqX9NZc6aFzpDJG1P7AxIjAAMtg1LEOsKpI/s7Ew8DEa8+PGPdDwrTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQL4ppQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21558606A325;
	Wed, 18 Nov 2026 18:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQL4ppQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724BB1F000C4;
	Wed, 18 Nov 2026 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026779;
	bh=TPmA5ZXdIXfHmcWgkzxuSunVP8mKw7/jMGoSFC07W0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQL4ppQG8C1LXRifB3STGXOuL/n6EActFz7kVr58iLrMW50w5O0fX4vBBjX0+CZeK
	 8JRshMIVEuWhDzpcon1NXBq9MF4hTicj+XF7w1BXW9RYDj+HnWxtf3Ha50RiC7tBqD
	 WRtqb6ztZzqImehJ5sar1G3OXSNMHS+ztJUvxU50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1514/2151] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150217.004037882@linuxfoundation.org>
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

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 312be0721b5d8..7c329568ee83b 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



