Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061701;
	b=t439i5KFQZJSLItpwaIIHfrdDoDniAZ7q5Y+ob+vRTmCDuG5bu8K8R0cafUjLwOs/DOR
	 ZGc4C3VB+TSBqK82XvlYSBNUoGVbYtgm6pphauq5RLAu6X5kIs6ic5iY03bhA7I5WcV0+
	 qAvRYf6AVPCYWhGe3Dpmib+SunV57J8zmB4LOHzu3OyHqMe8qE9oR8txeefBzcu9o6mDo
	 GXdV/xCz4gzYD7mqlgvH0/V/COTCq011Y+sTUI3dT6RPGjGUWMyPe3wBqwJZKaKUA5/1+
	 dJbysmKvxI+Pk+qHjNtGyKR5J71fX07Sa1vEGpLQ8jb8sghN0pEmZpwrS/F96+7O6lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LijPKvN1px3IY4DwcpekjrPfFBhStdgAiVahAYH8vfg=;
	b=wabsHyeSpKy+h1eyq17MH1FFdiDh1jmCYmIcupSjByugvx/jho5JdKAW4bfJl5AEwJ0p
	 htz343mJwG/yNdYPN2kTt+QG6CnGLeT6WnD4Q66skeMNi9a8E/d68SMnlqw4O5ZSUd4tR
	 6TidoBDd8VYjC77nUq8sq+s0ZhwTn9aUSry6RqD/ciA9ft5fPxXKgM5CtBrXhKyNzGHtW
	 OCMxtBgEWM/vQyA/gPc2LhYsy76Rd3j6FsAjFsBSqLTkiNI4K2e1HmzkVlkwk1b9Lpmt9
	 zdLd4M9fR2o7VfLQEltdUzC4RdwrzeMqZOIeqiv5L9G/ZAuckT7NU0pfmm2fxtt899Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f665kxON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76400606A32A;
	Thu, 19 Nov 2026 04:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f665kxON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85011F000C4;
	Thu, 19 Nov 2026 04:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061701;
	bh=LijPKvN1px3IY4DwcpekjrPfFBhStdgAiVahAYH8vfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f665kxONQaM7M+CihF4CqSfPlYMYNBnQpgv1/79ersX2nWX+g9NHEJoIYMrtkWIuV
	 swyTgrub6aZezb+JaaXaD3uFqqowVQAxOnDntfSMd5R31V0WNZyyt/B42Kjc3d7hk+
	 cjGyKKoQPnduRGMtPwDmcSj/NIHshRLHHFwHM6/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1640/1848] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150028.299691078@linuxfoundation.org>
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



