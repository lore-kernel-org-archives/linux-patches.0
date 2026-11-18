Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056235;
	b=d1/CIzTEiYFZD+LzF4AeN+/ROTAjTZFJrYfnvFKveNNuqNbEhsXm9OCgyaJYNUH21Vye
	 jbKUweCrN1Yk0VzmBaF4b2d2Os9yNV1myIspJMKd4gdlZ/Ej9cp8Ruy+BWs/vJkDYTk1q
	 FpSDehhHQhrX+R/MEQdjkPKkLc3H3fXpLZH1VfJFrmhTtS1Z9i6cme9CuXycQFado/pVp
	 w+erqfRtToCBPdqO6M8B/R60hNydVYEfOFSD5LC8ZywhvB4uKH3oHQvxUG5loKnKk33gs
	 NbQWa3XECqV6B0nipFtFzaQj1AGcMLLCVROESqygl6YEDbMHlBV1xzRHt3SDxF+yRdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QoQrJIpcmdWIGerqp7QQewGiQMqL75lIxePHxfXqneU=;
	b=IHOYxVpNwrWd9NVmeOFARpPIk3w/DrPQD5Tzu5q9oUN0WW23PiTu9l9gMQ3E/HvD0u1a
	 9xfWmw5y+Ms5XVA0jfucgXMWdLsxmrs6tPzfMoD8Or0bclusZGxqoneGk/esSNOor+vqT
	 1nU2s/lplCd+mdfCFZjjVpq9cgO8AvhhJ282ow21+JgmrEyDsEWDcppqzlYMdWM//P/YL
	 S2noqvyI/lQxXRk6BAKiEowPTInk73XACAxolc5HnK/uAlo3590QDMsrS3Jus/UKfpKzE
	 vVhqovx5bZpwDBWhqQW2+JGFTCzoSC4UUj7WwxZ9eJtn+YT4yh4fKwyN5UNIJocDpqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iN0ecmL6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9EF606A31C;
	Thu, 19 Nov 2026 02:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iN0ecmL6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B71F000C4;
	Thu, 19 Nov 2026 02:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056235;
	bh=QoQrJIpcmdWIGerqp7QQewGiQMqL75lIxePHxfXqneU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iN0ecmL6D5nfSXJ0ftYTJ5Ep+zgpzAS8PStmKtJ1Iltfkt2wXzKaIihd4O6d/irn/
	 399Z900mXpglVZmIBsNjM5HIs0O4GIHlf7XQBXuEa1KAt5BK15chDY8Gb2deyEBIMG
	 C15s0OmQNr8/a9QDfXX2CDSE8wuH/cEcgr5w3oG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1916/2214] ASoC: codecs: wm8991: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150127.713011482@linuxfoundation.org>
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
index 16bc8609d0d20..79f7a64845f78 100644
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



