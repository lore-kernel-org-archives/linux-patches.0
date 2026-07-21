Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365E142DA53;
	Tue, 21 Jul 2026 19:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662049; cv=none; b=mPhsnAHovBYrygVdmbBQGpdeGLcLKJHlnIDv7GctBDuYnlIuBbf7nSpHrp8MP4eQ/SXqb8ekaeXQIcxXkp9TZ51IOuV/Z7lNBKO0zGlLIKlNwGF0p9uZo3OtakzuIKA8HcGx8U9mvf/H33ffKNhakvhQWatpBbhdNDZHnFVPM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662049; c=relaxed/simple;
	bh=ViaFko4Y2e1B87iQ9dYo8CNNOxBWj3dxAwP8hidjUXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NboOy2hQ81NlsAXW1MPBRD4zY47yD1DsGuiRIzQ+gNZlEKfv+SAi4G4IZ0Z6GnKsWT8e7+AaiMZSMYOqGXWBEzVxkUkZTEMwXQ/z6HFM50kjyrUlGvGder5kSdepRtx2f6Vsoq62tj7SiL86qzMfpYFK4ePEPz9waqtI5gwVCd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6UmcFRL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6UmcFRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DBC1F000E9;
	Tue, 21 Jul 2026 19:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662048;
	bh=zkeQFDVI8cYJGTNL3EjfOMnwFKYGNWv21fDf/6/o3qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6UmcFRLguyMFKfWe/HKIdIRFFKm2HtFRZSttTYSQ73sgEqb/iiTUsBlFRtiQNnZ0
	 PWF1mhJ7ZI9vISFfiUORde7UuKS31a7nwc3fGazLXhPLIlMaE84jBABi66v7tO1qTU
	 TV9atC19Y7qGEr9hV1WX6oRPHf8vk7c/IPIg43A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0297/1276] ASoC: codecs: aw88261: fix incorrect masks for boost regs
Date: Tue, 21 Jul 2026 17:12:20 +0200
Message-ID: <20260721152452.737996880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 79c053a1ff9d3ab31cefbc791e8d7816ba830491 ]

The boost-related register fields used in aw88261_reg_force_set use the
exact same definitions as the rest of the fields, where the mask must be
inverted when passing it to regmap_update_bits, but they weren't
inverted here.

Fixes: 028a2ae25691 ("ASoC: codecs: Add aw88261 amplifier driver")
Signed-off-by: Val Packett <val@packett.cool>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://patch.msgid.link/20260529200550.529719-7-val@packett.cool
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88261.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/aw88261.c b/sound/soc/codecs/aw88261.c
index 38f362b022aa36..999461885a62ec 100644
--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -283,22 +283,22 @@ static void aw88261_reg_force_set(struct aw88261 *aw88261)
 	if (aw88261->frcset_en == AW88261_FRCSET_ENABLE) {
 		/* set FORCE_PWM */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL3_REG,
-				AW88261_FORCE_PWM_MASK, AW88261_FORCE_PWM_FORCEMINUS_PWM_VALUE);
+				~AW88261_FORCE_PWM_MASK, AW88261_FORCE_PWM_FORCEMINUS_PWM_VALUE);
 		/* set BOOST_OS_WIDTH */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL5_REG,
-				AW88261_BST_OS_WIDTH_MASK, AW88261_BST_OS_WIDTH_50NS_VALUE);
+				~AW88261_BST_OS_WIDTH_MASK, AW88261_BST_OS_WIDTH_50NS_VALUE);
 		/* set BURST_LOOPR */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL6_REG,
-				AW88261_BST_LOOPR_MASK, AW88261_BST_LOOPR_340K_VALUE);
+				~AW88261_BST_LOOPR_MASK, AW88261_BST_LOOPR_340K_VALUE);
 		/* set RSQN_DLY */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL7_REG,
-				AW88261_RSQN_DLY_MASK, AW88261_RSQN_DLY_35NS_VALUE);
+				~AW88261_RSQN_DLY_MASK, AW88261_RSQN_DLY_35NS_VALUE);
 		/* set BURST_SSMODE */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL8_REG,
-				AW88261_BURST_SSMODE_MASK, AW88261_BURST_SSMODE_FAST_VALUE);
+				~AW88261_BURST_SSMODE_MASK, AW88261_BURST_SSMODE_FAST_VALUE);
 		/* set BST_BURST */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL9_REG,
-				AW88261_BST_BURST_MASK, AW88261_BST_BURST_30MA_VALUE);
+				~AW88261_BST_BURST_MASK, AW88261_BST_BURST_30MA_VALUE);
 	} else {
 		dev_dbg(aw88261->aw_pa->dev, "needn't set reg value");
 	}
-- 
2.53.0



