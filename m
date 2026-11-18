Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019158;
	b=nu2pxD9DE02Kbym21iVEWACtnz/4suT58G8byWa3nc7JGFfhXWJaY6ozdOyKk1MRjK89
	 +rkjpEGjZypnc34GZlJauKgLj9F/XIQ9NbGwxbGIXu5vXtn3zcjx5lDgp5a8bkvkG8On4
	 9x0vxD1mqWwPrpQC7CNc6drEZKrUAoCAvH0JzQeebb/bTIx99Tsus64AVynunXcn65jPb
	 EddRWt8s5EH/OvR2AmDxC/TOtBu6dB6zh+iFFF1v2/pvbpSKRJd2f1oK2dUzFsgcdJrsE
	 QSlbcsuQjPv+iu9qf7uQJrm9ATxWy7wd7CtcQqFyfwPhDmH8o97EmevKHpdrCsQws0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dht9OQhPLHNVISWTq7Hjw+TjSZvVcK8BsczR2IY7Eys=;
	b=ZyPgmJ7/w1z2UlXeJSn71zp/wUx9Dc/Xb14JHMiRHoifaAA+WLZ4Vx9O7ttJIFRz4Qje
	 5eVx3ZXwCTqqLS0kXlW4/G7pu7ONvn2ygGBpdNTdY7c1jd1rgJNzciuUXJ9ivcxkrime1
	 2gCAmLM22kbk5Q+HjhAiV0z0Ye0Hs1xij42qPjLsSa08DsUpwJCUf+MfenZdKWOS5cjjV
	 ilaTr8vh0LFdkoT9W0seuJq9EbuVdyJdWNbHhaP+4dKXv5AOntXhS4M6NzMX7VA9IksqX
	 RBGjV2a1CtW9/Pn0q6EfbtIheH154c/zIXiVp9OKNa+bZMg7azcF4LhWL4lWaagq6mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W82hKZ7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2108F606A325;
	Wed, 18 Nov 2026 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W82hKZ7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2919E1F000C7;
	Wed, 18 Nov 2026 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019157;
	bh=Dht9OQhPLHNVISWTq7Hjw+TjSZvVcK8BsczR2IY7Eys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W82hKZ7wnhmeZ7wwQdz4IsYdM7Qs3Fh0Qied0oCA4Kxw40ROc6MLSPowbPMPXd/qQ
	 hO040NYC4fnnOsefddClVatS2GBRau6cpNKlY0Lcm9fMyICYySGbReCt5W1ospdCK4
	 wJSXMCDyaM8/Urd1qPUKJTZ7r6ICfnjiNAqyLO7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1497/2651] ASoC: tas2781: Fix TAS2781/TAS5825 PPC version logic conflict
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118150341.912526456@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 3a05cc2d739486fa3c63aa32e6653ce55dae4819 ]

Fix cross-team code conflict in shared PPC version check path, ensure
TAS2781 and TAS5825 apply their respective correct firmware parsing
routines, eliminate version matching misbehavior between the two models.

Fixes: f4ee43ae6ea8 ("ALSA: hda: Add TAS5825 support")

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20261002025230.1959-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 2b9efccf1a0b0..c2f79c18fcd59 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -1960,7 +1960,8 @@ static void dspbin_type_check(struct tasdevice_priv *tas_priv,
 			tas_priv->dspbin_typ = TASDEV_ALPHA;
 	}
 	if ((tas_priv->dspbin_typ != TASDEV_BASIC) &&
-		(ppcver < PPC3_VERSION_TAS5825_BASE))
+		(ppcver < PPC3_VERSION_TAS5825_BASE ||
+		tas_priv->chip_id == TAS2781))
 		tas_priv->fw_parse_fct_param_address =
 			fw_parse_fct_param_address;
 }
@@ -1971,7 +1972,8 @@ static int dspfw_default_callback(struct tasdevice_priv *tas_priv,
 	int rc = 0;
 
 	if (drv_ver == 0x100) {
-		if (ppcver >= PPC3_VERSION_TAS5825_BASE) {
+		if (ppcver >= PPC3_VERSION_TAS5825_BASE &&
+			tas_priv->chip_id == TAS5825) {
 			tas_priv->fw_parse_variable_header =
 				fw_parse_variable_header_kernel;
 			tas_priv->fw_parse_program_data =
-- 
2.53.0



