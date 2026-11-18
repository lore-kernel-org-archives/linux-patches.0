Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056249;
	b=kOe3K4b0EGES2t6M3t6BGTY7ieK9F0VC1fPcS1KghNoSwPqooo0yaQkNnr9FLvHa6T89
	 AkdS653MS535bq7wjATH6gqqOMGDLii9A2nyB0VxkqJyqiB3vuZD0FOQvqFEyWcuhL1pS
	 mI/L7iyEgPIRFXkyLKqvmXgxwo/AOMIIQbc5N4FbZDSh9rFnfa//Vo05AWCpOYm2IhkW0
	 TC/9wJiIe7iJii0piu/kykrOyutg49gTr+Bp1IElRNmwKcH+9ySNp5O6kFMVVgjzYmgnq
	 oPe815layf20Okn1vK2RhVGKFIfb689Lrzrl4rLiDxfXTqb5fXi1+fmNslbnHHWDkew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TLiNxdY8HRWvDJaYCuMOA1VW2lFH69+atGKGq746ErM=;
	b=oBDDL9UH9GlFs2ETy1xvpGrXSDKYbhi/uSIkPUULwu0TI92mL2Qk2zsnGDu5w5HlYpG5
	 IyeG906xNu9h2wjbEcBqNDrGYGNPaVXdTpnDBJpVymISquCnu4s69HQb59RkL5Ck3bZMo
	 E32ZuSG3pF7NLgKUrbMLn66GD5yHZdngfvJhjmRCxYSUIHayqkVrysoqdwYOSNbDc7o6N
	 K91wn8TMKIFfTC9SNmNiIv+91jlx3KC+/iL8HcuFRLxLKXyA8cwJPT+QNkahN4sc44caD
	 pAh+h61rksTLv9cqBRmYJOx3qdtX1ZxGtL3d/7WdOQTPaTO32ahFb5wM8GIXPXmonFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0qfwRkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71122606A325;
	Thu, 19 Nov 2026 02:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0qfwRkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73191F000C4;
	Thu, 19 Nov 2026 02:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056249;
	bh=TLiNxdY8HRWvDJaYCuMOA1VW2lFH69+atGKGq746ErM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0qfwRkqgVHocoT9a0FO7CIVjBqwwEoW7W9wUZts8rfKzRCFAf27xx9UjY0ZBsUQX
	 Xhs1oMHi5thUWrOg1ZxZzdA+YQNj7hbEa3cg+Mt2lEJpQgNGKQw2+aVRBKZIcN8h22
	 nLmGtdnqq1alX/pOWQAEOLpMXC77uYr7Vf2xYkZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1920/2214] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:59:56 +0100
Message-ID: <20261118150127.859182207@linuxfoundation.org>
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
index 8cd00e7d59b79..3d966f46bcac1 100644
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



