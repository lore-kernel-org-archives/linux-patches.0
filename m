Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031841;
	b=v4Qd99FS/ojztzRJZe0nO4XiY7A/JgfiPPPMrGjBn5N3Z8fTclEp6iiebwoQnmFsqBFT
	 BHzEJn2K9cZumze11Qbd2OAwkmtpa3GDMevigU/3eKgByASViUGVdwsW3ekqvXbaxRtVP
	 fFYZ6jsOJo3qalSSUaGEbjBxZvW6J8rOb6RaCd7PiLi2qY71ZSMsJWIChbKgl9Nx4EoNJ
	 ZK4ALXw0M8ybWlgS3ceJxjGEFjaMFL117/ZzIS+gtUKulWXufkmBFo+zzdyr8giZqzJAj
	 pGcIeX86+XrO9ngKi/mY72xwKpAOtVHxCh48ADFsIdI2UvpTuUwFiJrLrXYT2cerz5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dhKxr3U7xqufemyuKToHyhtof8/JCFtpj17AigqTH7E=;
	b=HtcQCjo8x1sei5c7d0xCL1kFtabTEyehbI1/AoXPF8GuCwQT0pOuNnSA0AtymX7Y4jX/
	 Knox6VdS/fallyAXmY5Mg/amy8dtvX1JGBv5zvIebFM+2xStioVSezTAH1A2V1m8xz+9r
	 Dej+PxQpaywX/gOJsdbnPO1FK+W+82pnu38lLL8h1Xh24sEHvzyytc85YanOQo+h6KPEH
	 VaKMiH9HIiuL8moGBFnxfrlYzSwABuqaOkZ30lqNuu7+NRzHYjMq8NrlKY/n7TpNF76EP
	 xFPOMGYIib/Zc18JFXhd2G3Bs4QLZiHGAyXwofUfz2VejVOM8PxqqbX06lXpGpF07Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kgK/KEFX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EFA606A31C;
	Wed, 18 Nov 2026 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgK/KEFX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4C21F000C4;
	Wed, 18 Nov 2026 19:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031841;
	bh=dhKxr3U7xqufemyuKToHyhtof8/JCFtpj17AigqTH7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgK/KEFX52lTOsvXjfhv4M65XhzkrFVFCgrAF2T70POG5OPQnO2NokHV2VeaTWug5
	 k2g8MkCImj4Cp+rGm+jQXUBrp7JFjtLtSMi2Sx+eR2GZrrQx/h5JYKIOKDBkRG5M5B
	 uOG7BXXpAWYdtjF1cT/VahV+i3q2TmeRePepCP60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1201/1756] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:55:28 +0100
Message-ID: <20261118150057.652028315@linuxfoundation.org>
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
index e3f0c68b26782..0f02d134ba178 100644
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



