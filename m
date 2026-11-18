Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041574;
	b=kutZK+2Szjpf1IKV3wP8yz8Ok2qFqISCeYnQ9WKX7OlYo7W7Ln5O8rS+nrpf4fF/ZPqA
	 6EXfFMlf+Q7X0RPvFf4E8Ibyp1oxtm2+G4gwAyMpwUSc7IPXUC6QgYZMqNez1wbtbDOH0
	 x50EpO30MoYmt5Cr9XTAxKFJMjoQOZnHHUTJde6xpehlIfxQ4dSCYxzmHLFtr427lbcb1
	 wXlpFlv5kzMjFjjKqjN0wJyr17GwRyT4/vspDkx1Bruvt7tqyvGFCouNcK7OXJ6jz+kcY
	 wTFspIqBDzTEki4XHXibwDmUn2hFfq22t+WwOt+NN+SC/TIT3KmNo+eXsq1+cD07hSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LKBgE1n6E3szQPIqDlz98NlwTTjeHoJr+P/M1B/2CPk=;
	b=xljY5c8oWdouMDGtB5XKw+RHs7Jjr1ofehjZPtJjFmxwjMftBN6qWbt4L9nTEGCRamD6
	 NV2dLr3WmgR8G/7LC4b+c24KcWU00DpFypYeRyQwx3SRXcOFqXBZLwP6uRlm5fbMSZXgH
	 m0U0OiTMjdAk/xyOBEed/6Cz0IVjNmfZG0aozwzj3cD3JYd6Yf5XcYkU3DBjIMPRElVFn
	 PhEaYxeK92caKijBAzBUNg4oXwFGficr8f89cC2bcd20I3qk6N4jgJMm0ci+nBPFiTOWy
	 pnzK7gSBHXVD9Ln+wlSpUAFG6qP0SKlbi9+lZwkVXYeGVM4DucNb4CTWuQ98MQ9J1ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zp2YdB6N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCDA606A332;
	Wed, 18 Nov 2026 22:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zp2YdB6N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8D01F000C4;
	Wed, 18 Nov 2026 22:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041574;
	bh=LKBgE1n6E3szQPIqDlz98NlwTTjeHoJr+P/M1B/2CPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zp2YdB6NYE9BQdL6czg4tgMNoLef5tqMtutH5PErGRnX5uO0Y/5hfyG78xONqo/Co
	 yjjRmoI076HAsg61Gl67/NsCpyLQyObG69WUyPalST6+gN8LyVW7IwX/a5Hw0Gj5fk
	 p1RqFrmyocEt9AfvGXW3uXwnh9vo8SSDqczU0KxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2863/3318] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:58:05 +0100
Message-ID: <20261118150446.469246436@linuxfoundation.org>
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

[ Upstream commit 22bfcedd3febd6acc63ecf8bfd9638210e4b9a5e ]

The Right Output Mixer Right Input Volume (MIXINR_MIXOUTR_VOL) is at
bits 2:0 of Output Mixer6, not at bits 8:6, which hold the IN2LN volume
(IN2LN_MIXOUTR_VOL).

Fixes: 942c435ba79f ("ASoC: Add WM8993 CODEC driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/1ea1d115cea5b183dd51bba5cd9e38157b3482ee.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_hubs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 0c881846f485f..3b0cc340bfec9 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -426,7 +426,7 @@ SOC_SINGLE_TLV("Right Output Mixer IN2RP Volume",
 SOC_SINGLE_TLV("Right Output Mixer Left Input Volume",
 	       WM8993_OUTPUT_MIXER6, 3, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer Right Input Volume",
-	       WM8993_OUTPUT_MIXER6, 6, 7, 1, outmix_tlv),
+	       WM8993_OUTPUT_MIXER6, 0, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer DAC Volume",
 	       WM8993_OUTPUT_MIXER6, 9, 7, 1, outmix_tlv),
 
-- 
2.53.0



