Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061662;
	b=O5rTmhz3wIQec2+hwNfdSFYZEl8jE7vwPhJ+L4B8xHbl1hoMm8zWKBOPASZSOSXy/kgH
	 jd56Di8yqE+dvmVjPflLnzhQ3mA7kpMcaBaW/KLjvajTbNGDLY9cMIjv6xvIpiVwMLniI
	 bMyjpCux+xEO0umIomj758EgXucpaznkYyIBcWMMLJadvcA9mzo/ts162Mub/0/exuGli
	 mjKI8mSNJ1wNop9Fdt3ezc8+Qnf1PG/O3wGIPxdfC8k/TYpXJ86yF+jM33majGZ5qSPYr
	 T4auMYHgskJlHbho479xOQRz1yUgVBdqPZo6XOELpmGtGTZ5GDNFjYjpnqflayWQfPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BkOPXgUdka7TGYe3e/mWaaTc+BGShqXC4i6vx7VuwFQ=;
	b=JWOyUOTsmz1BkGdWcR978N3x9wMumbavEkfpNG9seDpq5HuW5UYImBPTfL1eByuOg9b2
	 F28HetiLU6oqF6ln/ghvAkZS8V/KwB/ivmmVfOfTOqmJRIwibYhlnAKjPTj16XLdWQq5l
	 fEw0LX8/+ZDVsNFFvyTlAJ6Txth3T1bZof8ku3DNm59DVjUF7UZPKY5noupAuGY+3FP/h
	 8kEL4SE4i/0GabjdmkMjjyppvgquMigEV9k2+fqw8cY5KrWZx0s+EA+x3FPwWa0zPaumI
	 Nm8W6Fph84hbuuzg0WAVQYW6lCh6aOLINMnGodq6tZ5QDaGGN4u6tPjnLVfi+OVBK/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBx2NJKM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE160A260A;
	Thu, 19 Nov 2026 04:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mBx2NJKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AFC1F000C5;
	Thu, 19 Nov 2026 04:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061662;
	bh=BkOPXgUdka7TGYe3e/mWaaTc+BGShqXC4i6vx7VuwFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBx2NJKMiRKX5M7/5B+VZ5/evnu094IvBC1SqFLB8025ivyxF2zHfNHJ0lV8+6Aim
	 HNVNZt3dXn5rF4/G9BEYANx8Pmw4UpVBM4P1U8E6wj2UpcBVjs0ierZn3gPBYKFIx6
	 0V6WmGZH1HErTQ6Z1gaKxWw8Y8DwjaS5fxW5wsuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1632/1848] ASoC: codecs: wm8990: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150027.902897282@linuxfoundation.org>
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

[ Upstream commit 5bd6d05197affaf5a2d7fae0e06e7373fd839b7c ]

The right input PGA boost (R12MNBST, R34MNBST) and routing (R12MNB,
R34MNB) bits are in Input Mixer4 (R42), not in Input Mixer3 (R41),
where these controls write the left channel bits.

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/818cf8d7ae81fa46c67cd5b4d01291a63f44c9a1.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 938940777e5dc..5a1570598771c 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -97,8 +97,8 @@ static const struct snd_kcontrol_new wm8990_snd_controls[] = {
 SOC_SINGLE("LIN12 PGA Boost", WM8990_INPUT_MIXER3, WM8990_L12MNBST_BIT, 1, 0),
 SOC_SINGLE("LIN34 PGA Boost", WM8990_INPUT_MIXER3, WM8990_L34MNBST_BIT, 1, 0),
 /* INMIXR */
-SOC_SINGLE("RIN12 PGA Boost", WM8990_INPUT_MIXER3, WM8990_R12MNBST_BIT, 1, 0),
-SOC_SINGLE("RIN34 PGA Boost", WM8990_INPUT_MIXER3, WM8990_R34MNBST_BIT, 1, 0),
+SOC_SINGLE("RIN12 PGA Boost", WM8990_INPUT_MIXER4, WM8990_R12MNBST_BIT, 1, 0),
+SOC_SINGLE("RIN34 PGA Boost", WM8990_INPUT_MIXER4, WM8990_R34MNBST_BIT, 1, 0),
 
 /* LOMIX */
 SOC_SINGLE_TLV("LOMIX LIN3 Bypass Volume", WM8990_OUTPUT_MIXER3,
@@ -377,9 +377,9 @@ SOC_DAPM_SINGLE_TLV("Record Right Volume", WM8990_INPUT_MIXER4,
 	WM8990_RDBVOL_SHIFT, WM8990_RDBVOL_MASK, 0, in_mix_tlv),
 SOC_DAPM_SINGLE_TLV("RIN2 Volume", WM8990_INPUT_MIXER6, WM8990_RI2BVOL_SHIFT,
 	7, 0, in_mix_tlv),
-SOC_DAPM_SINGLE("RINPGA12 Switch", WM8990_INPUT_MIXER3, WM8990_L12MNB_BIT,
+SOC_DAPM_SINGLE("RINPGA12 Switch", WM8990_INPUT_MIXER4, WM8990_R12MNB_BIT,
 	1, 0),
-SOC_DAPM_SINGLE("RINPGA34 Switch", WM8990_INPUT_MIXER3, WM8990_L34MNB_BIT,
+SOC_DAPM_SINGLE("RINPGA34 Switch", WM8990_INPUT_MIXER4, WM8990_R34MNB_BIT,
 	1, 0),
 };
 
-- 
2.53.0



