Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B63803EA;
	Tue, 10 Mar 2026 11:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142110; cv=none; b=FUBQZ/5o+GpwAcncAONBm5Mugh3fKm7eC/fnqDBSPIIc/SjCajXQ//xek8Fnsdz6B3VAzwS7xvwodyIm0qoqN27Dx7VblPyPS2QciezwoE+fdF0vldiXmlLs7Ik15jlYtvxXlaa+ehKQpv++3avE86klzeHv1r9KWmY8px2RmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142110; c=relaxed/simple;
	bh=NUYZOn2Q0n26eTBEFKMEkD+ThcG1k5SdrAojUY2QwzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHkazunbJT7VBr4hRTAwhYDWzVT92EaeVO9PmZg9AXwnB8bHiHx5oNWZ+5Zo0hKy38vQbk88t/XrhdHRIETCQjKq3J2mg1wwiWalnVb8FSqXg5o1ZHYbJIGRH36uya6lx8QW/3+OBVTUkx6r7NeKXZKeKspP1Gry+0mzN6Moh0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK5NyBZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK5NyBZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB680C2BCAF;
	Tue, 10 Mar 2026 11:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142110;
	bh=NUYZOn2Q0n26eTBEFKMEkD+ThcG1k5SdrAojUY2QwzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK5NyBZ8WcIwuql7xp4OQLeRTE+6Zu9Hy2/GZJL2KrLPnh5apwd9g9sNm+AMhfNil
	 ZYlB7ZeSccp1736u+Q4y0ADLmEoX9L56N5pewKvRvyQ3W9l6XLlNhfVhS6qZ+zgkFb
	 kyVhjAjbQX3G0YT5t5lo6IgIBAummNKHf+BbyCphIj9FrMhCZhPHKeA4l2rGoyBrlk
	 JUKRlK4096WKk66hh4VkMQS26+O+5yRm/PfhiZpyZnX1hB/Iul+8Yyu8L40ZYASMor
	 hlSNeq3Jpy8vp9WhMR5o/nV26kU6rraOyyRIjvPTfvOQAqBzv0mFnRpexcd3Z5rUHD
	 2WnppG0r9lJOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Fabio Estevam <festevam@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 198/314] ASoC: fsl_xcvr: provide regmap names
Date: Tue, 10 Mar 2026 07:17:37 -0400
Message-ID: <e1d191055e450a230e53d8fd1fb69e607cf926dc.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 08fd332eeb88515af4f1892d91f6ef4ea7558b71 upstream.

This driver uses multiple regmaps, which will causes name conflicts
in debugfs like:
  debugfs: '30cc0000.xcvr' already exists in 'regmap'
Fix this by adding a name for the non-core regmap configurations.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20251216084931.553328-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_xcvr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 06434b2c9a0fb..a268fb81a2f86 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1323,6 +1323,7 @@ static const struct reg_default fsl_xcvr_phy_reg_defaults[] = {
 };
 
 static const struct regmap_config fsl_xcvr_regmap_phy_cfg = {
+	.name = "phy",
 	.reg_bits = 8,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -1335,6 +1336,7 @@ static const struct regmap_config fsl_xcvr_regmap_phy_cfg = {
 };
 
 static const struct regmap_config fsl_xcvr_regmap_pllv0_cfg = {
+	.name = "pllv0",
 	.reg_bits = 8,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -1345,6 +1347,7 @@ static const struct regmap_config fsl_xcvr_regmap_pllv0_cfg = {
 };
 
 static const struct regmap_config fsl_xcvr_regmap_pllv1_cfg = {
+	.name = "pllv1",
 	.reg_bits = 8,
 	.reg_stride = 4,
 	.val_bits = 32,
-- 
2.51.0

