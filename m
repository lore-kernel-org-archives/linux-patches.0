Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031847;
	b=MMWVk8/1bqIRgeA0cSOoVM6LHNF9cxoiNirA/V7nq5Jzmv+vLflAM9OJUpzFFb8SCH4m
	 5PSV99J+lTfmA973K1AxninYyId8gDAzaxF+FK3V85CAW+1DHmaRDjbEEtDsfiHwOLSeh
	 QMlw73CgvV1i+QKDhb1vrGd6YE4Cdu5+9IuhqaAaVPWlHD7fLi3ENPqD9/TIRE7LneVgy
	 XQ4LVcltYeMVwq7AjnguwpVhG9baTDWTz3SIlhYYfGcD4X6acVfxPSAx790AHF/8tGLZ+
	 fIwZW0V+yhrVTZVWsI8iIumwlX2nbGygdrsdf3LRsjHl/dOrw/1124yt7d38cqibzDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MwO/5cmO0gyaLFcV97ls735UKXwn6bAvEFBc8dgfcg=;
	b=T2Mgzr5aNnfzoAOVImyAcEuDzwdQapin5CPeoZ2HDYzpf3kcb/xZyL2BFIy1EuTsNpdE
	 6LGZpdQCDfcuHhsH3+QfaA53JjUpdm6P1SvPaaGqsO0dbk1GelTYI97XZH7v0X08HpVJY
	 j3KPJKi+VzUhFJ2Hubwrk0zNjwWRE9yTn26a1hwANly7ASgB1hGgpAQj5jsgTBizs99Iq
	 B4OAV2JqlrpV7WbEeh9jPedqIX4mRQLH6DSRee0slH+B5rjdEpJdvlliZb27CmAisk/V6
	 C7X5rRuFi0RDFGPV8ctoG6ajZR2J81E1XCvv0NlBSIbDdLOMsLb72jBVLKX76by8EOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jME/tmFh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F81A606A31C;
	Wed, 18 Nov 2026 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jME/tmFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6741F000C4;
	Wed, 18 Nov 2026 19:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031846;
	bh=9MwO/5cmO0gyaLFcV97ls735UKXwn6bAvEFBc8dgfcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jME/tmFhxKMVDO0j+tKuLl8O1hvyvh9Z5IVdM/p5YS77e3B9axj6MfXErUL/S80kE
	 +tuNrJe/hzTGMrhLIW06zB0qhxZCCd9AmjY8coEIud2qZi83r3vGL7CitzcgCx/pUl
	 i4rPvD9ntuB9eIQcteGsahtvagEBQp5I2aAMYVf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1203/1756] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150057.726023133@linuxfoundation.org>
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



