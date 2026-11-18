Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041588;
	b=Gl6RNqodwNRY91jm2iPXJVq62YqITvCJS/pRU2y1oMnVsYzEWzub1neCvJ0k9WGKQrhN
	 JDpEh2/lGNlnkwx4kEH3WGFm1BkFxgBmrfojSl2ST8ZnGdfotrgDxUUBB6oofI9DcDkQN
	 FUd8DAUa3fOeoWhcHiVoBrYRVbozBDa4HHNAb2ORwxSRS1fVZlARLuAWawC91R9r+Skko
	 q8Ryn9cDfJiBcZvVVnU2bZU+Jmvx22nEGU03AtocON8tPgh25c8QH6GrPMfVEi2sOnzD+
	 vGYthyhikLtTK1Mufh8OLhzyJVwpCPC0jj5VvE03vVLcQXhkZLA9PBEZyLvLuP0t0tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DUmdDnUy5BQkcqegwNFjQEQT8LYpk+O/LtRdb4Z0Qw=;
	b=D196za/VeVc0HrH051QvkvDgWy3KO0/OxNpl1Hg0dUelSJQ6ebGeL1BV8yBTXVMUuuOq
	 gNohdwlIok+ebEGqvllRKLl9FRcjJTKTlgN+/UWKCsqZjwy9nsK94OHm/a5xHN3oQ07Ej
	 gVL7PSD5dNf1FdhFt0baVX92UKU05A1NlCE7mleXfn2c78Tr5ooj+uRG+Pr8v+DRbX7mj
	 By78sXMDyIHNPl1z6EMRC8ehvoo5gW0yhm9EMIHSRIrb69yCZehJO8DRiwAtjKHeByiRD
	 JZ0Sk/9ECQCgec4Sa2pW9BFxyxUPTpyXYs96KpPI8/N440/cGtA5bcordCdpd4D4Ssw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGzAnymS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886B8606A332;
	Wed, 18 Nov 2026 22:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGzAnymS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD41F000C4;
	Wed, 18 Nov 2026 22:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041588;
	bh=9DUmdDnUy5BQkcqegwNFjQEQT8LYpk+O/LtRdb4Z0Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGzAnymSMAS6m7OACd99j0sJ3yeFQ+IBrAuc5eXnSywNSd4nwK4/TmHTZnR6xJkur
	 F9eSE6N8tbgFi6+/xXc8ADX0LTQBaUqMNyUAAP7Q/2qSNDtViV4PrVfddepJHu8OiY
	 v4zoOowURgtcXmIz8HlYVAFM29vY1zdTSAQIyHBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2867/3318] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 15:58:09 +0100
Message-ID: <20261118150446.578023553@linuxfoundation.org>
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
index 6636a70f3895c..9db4b8caa9a2d 100644
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



