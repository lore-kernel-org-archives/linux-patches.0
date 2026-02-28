Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA821332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301212; cv=none; b=G0+BOP4M92dJW2llzJClkBuaIQTC+p+qOJp0rCFBedhNOVbq7HFHf4jrDm3PsK22BWZ9N6xWH0TKYmie+kvt4JR+M5Vgbl6g2yK04nyVQoN58x2rdFmzApu4xRVLxdQKCITU1a/uAhaT4Yugn5tY/Tz1NsnxjGMN3lJ/MBWMULY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301212; c=relaxed/simple;
	bh=67MVi+QWuTxAL0YcIsBaGx9K7NNV9SZyIXHlkpgP4w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIVm5GxN6gMMfYmb3otjcUfc9yAkFDF85yuSozxrwsZrU6duTK1ivgod/9Szc/cI+6ocV01egIYORFFpyqu1Ek4e8iyvXTNdoRDVMVtJAwn4XH6l4mcKkLyIqXZHwaosKzjQ/qo3H9xPeIudlIdcIal5h7wMdsX1taVnSqIibwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCrrquzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCrrquzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D5FC19423;
	Sat, 28 Feb 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301212;
	bh=67MVi+QWuTxAL0YcIsBaGx9K7NNV9SZyIXHlkpgP4w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCrrquzE38VWGpBI3iEM5OgHUaX1mH9AlVJJaUooHYrcRxTwFomI4v56gKYpFAyEo
	 eTWJTdKZHwYPrYjzW1+7d4j4ioTSOr38SLPxuta287z4wPnx3JATzYF/jABXzisCrk
	 z79hLpuSAzmTKJjbxzQCWt/xpMpT8rWCcHNNPaWSNQsS/JEiyavKbUyzKcwrI9/KRk
	 sE5om2jZnarZgNEAlpYlqrH7sndL7adC4Vic1T1VutNDHQxJRXkRq5xRmccQ6Lq6bf
	 rQX6pbdKVRMiYAD6EtObxnWkL46bPuYKFAviGXlGfmZje/tsum3thGuup1qZllMqUm
	 LdoRuwzNYiMmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/752] ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models
Date: Sat, 28 Feb 2026 12:41:39 -0500
Message-ID: <20260228174750.1542406-388-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 3acf517e1ae05ef66561b7a2782690387ce46e21 ]

This patch adds a quirk to include the codec amplifier function for Lenovo
models listed in the quirk table.

Note: In these models, the RT722 codec amplifier is excluded, and an
external amplifier is used instead.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260218104734.3641481-3-Vijendar.Mukunda@amd.com
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 5a3cfedacbafd..86c534d827448 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -95,6 +95,22 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YW"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YX"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
 	{}
 };
 
-- 
2.51.0

