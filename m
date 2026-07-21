Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF443B637F;
	Tue, 21 Jul 2026 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666047; cv=none; b=A6cihQ1PhfKEim3kyX/2e23tlogTatbf50mU8HLou6vT6LW//ZJYSg1aHPDl5nfArWbmnBzJqWzLfoqrZifFyT04ewDgcvIfdof2TZY7QkP9/7TSWmcaWicuHgm+srh/c98MSVMtnsxDTgjgbbwOjbnJ/GlyqmtSvhPVb5K3Gt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666047; c=relaxed/simple;
	bh=b0Mjs9ci11T49yAV3dO+4+yJ+Qbe9zMahfZ0KEjV9ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siPvtjIFgNJENb6CinyxSwCW61/RjzBFhNUhlvfm0CV0s+9SjP8pa0Q+FikUOuwaGj3utnj1JV2DMMg1ZQ6W8U+dhaqKMziFtm6czF2YJ/5HzSBst8Dyus5iSeepNp1l0Y894Et6+JFfXV3TkH848ItoLBLPYsBU/u6CEJTTxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv2iwEjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv2iwEjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34701F000E9;
	Tue, 21 Jul 2026 20:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666045;
	bh=L1zWhaWUqSJOHSbnHEOf2LfKo/6ue5KiwmDiZPGq57I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tv2iwEjCKe7o512Cvf3bHbMW6VjthdahgMFiRlrwhhBGPk4ACavxoTF/3Iv9/PMFZ
	 Pl8A8Ap82AOf1vOUMXsY1zP0KXVj5+xR3+Nm7TqP1rQqggG1GhdEvRflxEGXIDNSUG
	 5Pfbo0f70NviLsp8Jo3cBeEtb6aVOCx/pHttnM1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0533/1266] ASoC: codecs: aw88261: fix incorrect masks for boost regs
Date: Tue, 21 Jul 2026 17:16:10 +0200
Message-ID: <20260721152453.785735842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f2a9c33ff4a649..eed05b2508dd79 100644
--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -284,22 +284,22 @@ static void aw88261_reg_force_set(struct aw88261 *aw88261)
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



