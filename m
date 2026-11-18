Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056238;
	b=FqyZAZPWTalcJGBDBNbi/vhIOOQBdPYmDlcNabnalvSRNa71UZkCjFEFAxf1+CfSQGSV
	 mUKOYM2U1Q8AS/ahoGBnl7dO9SxlA9Izrl72gh0ohtfLbzGicHOufcJZ2TvzcxJSKtDhp
	 R8EmzEMvtvyIoWAl+N1LPQO4NndD77B4D8/sVNRm1v1E7EKXonZ5n82KPKd0q3cCZggcD
	 Pn7ngQPCelrHAaQ4LwQxlCBYZCCnYSkNS/7721OEHnDEZgry/xIgbA4nVzAW7ismsh2Ih
	 H2/iY4cG21xA0GxlYF3IIAJM8AsngcMWdbUhYaPaPoIQnQ9FB8Cpxh29o/9XoVQGrbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o1Xg2Tr2mqggaQd5y3Hf8O90RFo78v2IQqOM02pigOk=;
	b=F+PVPycJ6TRqsDPbA7MK3S9xJkRpX7t9cql7/LBwiDIrlYmP73Fpk5sLaPFetExkKkkq
	 S/VF8VIFcG2xI1F8FgGuj5nmS4BirwmBNelPFEoVdAT/0Ep2XFY/bKw+Z+ZBly7IygvE+
	 UVg7z+9pS1w9ERGcjckI1EJTM3oXhidBCEZgDJHt+o6ClNGOHfMWJPdsWzru/UKqk5E6U
	 eoGfloDHG1ers7tviL4BQ/d3N4zOyveSfBah/bjCrXV68avARjX1/vB5DeQyCo5nTbRv4
	 /bbBCqdq6KXGlYIz+kgdEVxzN/dBCNWMmhfZgcwdyhZQYzd1cabiPmD5Lh/d0b64QCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FNkjBidU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F29606A31C;
	Thu, 19 Nov 2026 02:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FNkjBidU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13361F000C4;
	Thu, 19 Nov 2026 02:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056238;
	bh=o1Xg2Tr2mqggaQd5y3Hf8O90RFo78v2IQqOM02pigOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNkjBidUOfQP7DzUOCQCRF8DegvNOh662l7NTJWpdlH6YiIzdNsKHnqYZMqEU8Ck+
	 h8W35YYUkiTJkGuFJIqgfiqcePfOCaD5UyrhzDbzifwtG/wX+p8Og1Oz86VPfNH0aH
	 spAFZi9RTeP8s8cHpZfC3OjmyzhrOGCw+PtT1cPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1917/2214] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150127.752541454@linuxfoundation.org>
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
index 79f7a64845f78..92275d7f9994b 100644
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



