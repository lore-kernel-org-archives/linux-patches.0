Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021247;
	b=G80ob8gA6hKDAnCk0sxqYPKKjIAhDCQoIOhs5B8wzpLtR5N7dXuTA99StBk0dx6DC/8s
	 zLISKIdTSKgUCGqm5IB29vSmovFc+ikI+UPxj9pwhtTR19uRuh+axdHKIr2Nf/DjX8LFR
	 nGUs15yZXmt40wzO3Vo+AoEVCGjlbDHODUD+flv96dRdKvdRaLTNk5zlZv1I+11TDsS9y
	 68oESeN9NTRVdNbhGhHA3u2piSdKg4ZPzRU5KXMaGkGN8YNbRn+1dzrnHT5dlboLvhc18
	 fjhtvBvdZ2BVvgURjRzB3l3AtHArUfkmD2ypcDf5nk1g26nS3UgQ/L/3xqQVOMhwZwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgC0R9cizsE0hci6RYdgHj7ahquIQBe3uUpxhIvk/dU=;
	b=Pb1SrLAXoSI5+suVdiiQ09UrgB174dpzBKFacdo8pDGwKEOiHmhnaDZxZ4qSQWfE8n0L
	 IwBYNij9V/1LzYmShq5XuTP8yQtD8lol2EHuMK5xyYKcwHhtSyc9+mEOaBwd9qJ8iGYPO
	 E9SqJ4CdTad/o5dx5o3tHvIR9EW6KSttI1RBNURFIGaxQZkBtMpC136RZ9KOGgDpwCMab
	 uZ435CEnsdMtqXpRuaoaQ40A0uASW6KiYrkNiJ1Ns+mtqfsqhLNSbdmt0kArWCTgWF5Kf
	 Ap0j/9Azbj3tsJhTIauzBnRKWDVqpj6yhx5gHAxYgvUVZP3m2YEuA3ozqGwlmUIQfmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh0kDnWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B496606A32F;
	Wed, 18 Nov 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh0kDnWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EC01F000C4;
	Wed, 18 Nov 2026 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021247;
	bh=RgC0R9cizsE0hci6RYdgHj7ahquIQBe3uUpxhIvk/dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh0kDnWttH6fzIHKec0vw1SKdq7orJ0pRLfif7eUsm0f/jf1RgTq7tkewCx+xvL6U
	 AudylICqjjibLaiiO5bHqZ7NdVCNoksImuuuAu4bi76C1IjWCBmNz1VN6aazwI3Hhu
	 XVDb8lB63lUpuldPUlHBHapkNgyEaVg55XZwrS9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2240/2651] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150406.128499095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ff404ef11b975baf38c4472c51a6674c239e8021 ]

The ADC Mute Switch control writes bits 2 and 3 of the Misc ADC Control
register. These are the ADCA Invert and ADCB Invert bits, which have
their own controls. The ADC mute bits are bits 0 and 1, and the DAI mute
callback already sets them.

So the control has never muted the ADCs, and nobody can be relying on
it. Remove it rather than point it at the mute bits, so the ADCs are
muted in one place only.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Suggested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/all/atXh3Br+fuH83S0q@opensource.cirrus.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20261019124022.3410793-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index f0ea5309a6d49..a259440db0f57 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -419,7 +419,6 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			      CS42L56_PGAB_MUX_VOLUME, 0, 0x34, 0x24, pga_tlv),
 	SOC_DOUBLE_R_TLV("ADC Volume", CS42L56_ADCA_ATTENUATOR,
 			      CS42L56_ADCB_ATTENUATOR, 0, 0x00, 1, adc_tlv),
-	SOC_DOUBLE("ADC Mute Switch", CS42L56_MISC_ADC_CTL, 2, 3, 1, 1),
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-- 
2.53.0



