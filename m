Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061811;
	b=W5Yj0DfNHrRSJAvxuIoJPE5fNrNRIRtIoe0R0vrNF1XvqhBjbkUzUnhfTmvZYxqboCJ2
	 Ar6uRpOZnoYbJruOvYwfGg/sYTngMUe7aXmUzhT4ftXAO87KcqWefnQJwnUAunGaFG5jA
	 HHUyVGJYuHDc1CJaA4jJDkr/p0Ur53bShJstO4N7n6UV3LJgtiXHlT8WsXRf2IOAF7TPv
	 PiRXEW/HTTLhqtRTBF/Mu8A/smMvtVhXcKfh7OaRUUvA7jWh2MFLrLzFpB2zaB4hD5H1E
	 ecJxpa/H3J/xjA4XafC6riy/d9kWMYjqcdK8wU1ft2V8fpznvIZJoMoWQXShnrGxBfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWgLZZigzowmHGCrjE5hb9Ebh53JeXveKBtM2BcMPhM=;
	b=ig8VFYyDcUoLKh/cjQGTRsPzpRRMIOptlQ1xy1wPPeOQ+E+eaj+ZObFQIIW5t69fmjTz
	 154uu6911VPti3hW9RrtLnkZumZ5sRB5A2U5PEY06Xhd9dQYFmPi65VSCofHpR3a7LFuG
	 26D7MrgbbMLcAR7HL+tkrctsrNQEaRF1Mba97zi4psy+6TOgfPuLmAMmp4fld4ha04znH
	 sEqcKmvOwqvR94F93Y4nNrHPRVpuh7HI6Awh1kQG3V120sAD0wp0TuJ4R9KEPXd9fcbfZ
	 sRV9N/3vvUBHEQ3GhGvceu9Pw36O0uskHYRYl1T/kX1EKmEN0k5VazfYJO5ex5nydGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QasmRGd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091DF606A320;
	Thu, 19 Nov 2026 04:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QasmRGd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FBE1F000C4;
	Thu, 19 Nov 2026 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061810;
	bh=DWgLZZigzowmHGCrjE5hb9Ebh53JeXveKBtM2BcMPhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QasmRGd9PSMpXbnel/cpolGeQW5TA4DYab5dGHxbRB0DHUJaqILb0ox9o0Us4xCZ3
	 BmrkOrqEMOvH4qF74f+3uJv//Rd1bL1WkwpVOgqTkdKxgvsh50KKtjcKPlOVbT2adP
	 nZFW/zIHxXwNP2dQ8TaE7B8fFKAyl5cF3F5lbAXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1644/1848] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150028.545016112@linuxfoundation.org>
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

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 73c4a8b9f59e3..2ce559de3e126 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -135,7 +135,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



