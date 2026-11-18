Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041560;
	b=f7v2WY2S49eYeo8l/j04DnaP4FCnl2RPeUYD15YmVu0eH+bh8dY9pmMzN+hKUTY1NjrJ
	 kOhJmiB7HNThyLoPO2YqMUyYpJpg24y5+YCXaf3BFQMYsOQoXs9vd+mMQsYnLvFJFv87N
	 XdCRUepxgnRGZyZKl/BqX42ooMDiARyxvuViK8B0xWFX1IL6LE4FFMejJqs+vJE/tu8/U
	 CDt6Vd1yBa2oCkWB2irUfHozfE+V7dj7Gp9zYVgSLNy7ZhTJCc7a9rG80h9FB0u46eFJk
	 3cZYIJLXBd9y+HVpoJNwQGPoeB/8bEwPJqa2/ZSg4/nD1CxZgXE2E6fj9Eflt6kiEtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i95m18WJqdcKVaf40RbSwJNk5ckUH/939eszy/PLsrQ=;
	b=hxiLTJiM1ZBY2w/3dLSjp+lZzADvqbSpY5KKKyeCNfE2TP/XPM0hwI58xuO9hvgKTnGA
	 FrQsbnuhrbkEGBbEq8NxBmxBHvofd88mnEILWcN5rqVSZCsXFSf1RIW6VQn+aLtZiO/xg
	 EMhe00yEqXnVq0qO1YAJ/8bRm7x/yYE9cS4JFG+50TVZnJLgdAqsMWClsqyM2LvZAcv1v
	 7xey3ddNZXbDckCHxo/wDLFHRrw0lJqwPHaM7CzPgG3QU3/p7BLGqn+xqS+ZKgMIQgLKb
	 ngFuODVGhJYzjtBQ39+S67fiFxLATc0Zkv8LdpC+dsflszlkiq1AN7YJ8ZAyWy+mT6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6GuunRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78EC606B60B;
	Wed, 18 Nov 2026 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6GuunRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27B41F000C4;
	Wed, 18 Nov 2026 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041560;
	bh=i95m18WJqdcKVaf40RbSwJNk5ckUH/939eszy/PLsrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6GuunRm9JoU38PpHwEC0skJmhbI/o4R9sgNcRPjXhoTAhKwYLfSBGMGWL5dm1TS+
	 rDPHlAW64T9U9Lh1EThRdWmdXOBf160m+4bEgvuojbHA13uPZar0umvwFOCTH/mpsp
	 wJ+YgBJ4utuQkS3MaJzpOWZmeVK92cIeSksoVcqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2858/3318] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150446.331945074@linuxfoundation.org>
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

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index a7f1e810a2b09..b115e4996ab2d 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



