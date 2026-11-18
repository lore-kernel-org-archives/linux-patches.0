Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049768;
	b=PIckzv1WnV8Jo0shvc3zF/BnXz0hKgFVBmgvtxAP4y9vbuY6wB2VrLULDfZAn1uT0yZ2
	 wt78WIW4Eg+LsPCVuTpFpq2X+jARwDZaraTeg+Ph6MRMZfJT9q/arpdsTHNYsz8pgm2tr
	 XOPMQnY8Dds7KNdzVmlEkSx3C/rZzaHXDAE4nnfg2y2TgGTuVoVXLIFaKY66or1AR4VI9
	 n9KN1MH74L4ddaX+Mrz8ynG+JHslrcQdX2sZNEFvcvQOw82Pgi2U2SsGxD3KYxq1d9c1h
	 rZX4ajHpiivn8yiDfNmLwScERucRnk4J9KNfJOTh7do7QTAdePpq9cNJ81imU25js1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qtSNIERa1dgjKydoVY1RtnUJf9UrtveV2DY9x28v7I=;
	b=sgs+1woJgFNt6wDVNJCOpNXgGJvxfZ24Jp1BdfYUL8UC8wUGLcJJcl/sCNzncR2XHRDM
	 v8nLV+Ap3YoemLkISS/57T1/HQC488ZxhSKgSTuh8nABvpvshFfNTaiSY+RcIZMqRQ8Qs
	 l8sKp2Q+D57hQJ1CqrXwyeiHABnLRI2FVOqjutqY5sAV5NvN2LIpJjiikHgvAtVn5Sc9e
	 s7c3z19R3+XEEGTOatKH1f9LUZ6mWwjGIoyI4ps0T0MhjRkYPvpOYv1B22SmKPXYWJsmc
	 TOlxxbiEHDAwYFBFvvOQ3qaoewb8tsGze5V1YHOeFokJyL6fmRS6RP4FD4T+djjxHnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZWlhfdd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F7B606A31C;
	Thu, 19 Nov 2026 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZWlhfdd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D331F000C4;
	Thu, 19 Nov 2026 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049767;
	bh=/qtSNIERa1dgjKydoVY1RtnUJf9UrtveV2DY9x28v7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZWlhfdd437/x1/ucI5gyI/74gjxkgRKWljE/PhVJCfPVevN3d7TjOlfLRTCF1kQ+
	 iOX2yiGiKrIt6pCArDsoPAMOVBp5cKMoauMCJJ4f/JjoqDgGX+wg0jJ3NX2H9boZis
	 WJlVa0gZ5KHPyY08FRaPissae2UKljXIrHCvuutM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2469/2857] ASoC: codecs: wm8991: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:58:23 +0100
Message-ID: <20261118150330.466080577@linuxfoundation.org>
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

[ Upstream commit 2dfecdc25d4937a36675c0c36ee0addc99e1e7f9 ]

The right input PGA boost (R12MNBST, R34MNBST) and routing (R12MNB,
R34MNB) bits are in Input Mixer4 (R42), not in Input Mixer3 (R41),
where these controls write the left channel bits.

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/5c0196e45dff1769682d885fc26e613648e05436.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 30121993b7b4f..72079b73f044a 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -169,8 +169,8 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE("LIN12 PGA Boost", WM8991_INPUT_MIXER3, WM8991_L12MNBST_BIT, 1, 0),
 	SOC_SINGLE("LIN34 PGA Boost", WM8991_INPUT_MIXER3, WM8991_L34MNBST_BIT, 1, 0),
 	/* INMIXR */
-	SOC_SINGLE("RIN12 PGA Boost", WM8991_INPUT_MIXER3, WM8991_R12MNBST_BIT, 1, 0),
-	SOC_SINGLE("RIN34 PGA Boost", WM8991_INPUT_MIXER3, WM8991_R34MNBST_BIT, 1, 0),
+	SOC_SINGLE("RIN12 PGA Boost", WM8991_INPUT_MIXER4, WM8991_R12MNBST_BIT, 1, 0),
+	SOC_SINGLE("RIN34 PGA Boost", WM8991_INPUT_MIXER4, WM8991_R34MNBST_BIT, 1, 0),
 
 	/* LOMIX */
 	SOC_SINGLE_TLV("LOMIX LIN3 Bypass Volume", WM8991_OUTPUT_MIXER3,
@@ -446,9 +446,9 @@ static const struct snd_kcontrol_new wm8991_dapm_inmixr_controls[] = {
 		WM8991_RDBVOL_SHIFT, WM8991_RDBVOL_MASK, 0, in_mix_tlv),
 	SOC_DAPM_SINGLE_TLV("RIN2 Volume", WM8991_INPUT_MIXER6, WM8991_RI2BVOL_SHIFT,
 		7, 0, in_mix_tlv),
-	SOC_DAPM_SINGLE("RINPGA12 Switch", WM8991_INPUT_MIXER3, WM8991_L12MNB_BIT,
+	SOC_DAPM_SINGLE("RINPGA12 Switch", WM8991_INPUT_MIXER4, WM8991_R12MNB_BIT,
 		1, 0),
-	SOC_DAPM_SINGLE("RINPGA34 Switch", WM8991_INPUT_MIXER3, WM8991_L34MNB_BIT,
+	SOC_DAPM_SINGLE("RINPGA34 Switch", WM8991_INPUT_MIXER4, WM8991_R34MNB_BIT,
 		1, 0),
 };
 
-- 
2.53.0



