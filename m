Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3617A31C;
	Mon, 20 Apr 2026 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700310; cv=none; b=UPdbJsA9NeVU2qguUPo5TrorRbMEkkbzIsqFJVbbSgRFvSbsdMESJRsOKRrN+mjT5cikd96Q7DIp9CCM3IyzbtCRgmnUo2x8f1vJqK3FuUHW5DHIiK9Tz3xEVY389iiLbEELcdWIeU1hBbPuBc5hvTSk0lnCu/ksRk6I7OL3FxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700310; c=relaxed/simple;
	bh=VXGXWMLUjLlFODd7fbbKq9xdgOFH/knJ0fT3botpvnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgHY64h+GnhX+7kdZrIfu7q9oOGuGvs5TsEuDdvi8vpBtajeBfc84FUlgn9nb8n/2JIhzlMdCtUoU5IIhFaF+3FeDIuqM40efb+2Rf1bFkDp9yL8jCbyarVYGBBckICFAtiNMQTTgkZqlF578p/SAhC9vbqYUm3WXU7WAO8hHhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwwSoAPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwwSoAPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B81C19425;
	Mon, 20 Apr 2026 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700310;
	bh=VXGXWMLUjLlFODd7fbbKq9xdgOFH/knJ0fT3botpvnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwwSoAPmqaYmXGv3hXsQj/3XqGhOZFEjfdSeGh/7hz27gCyb1J05lZhcFadXXe3Bf
	 KB76t7OxBXLMYNJMYeKLv/Pr8uI9OXWQbHHR/pP90iStE1fY1N2ymhrTpektyvNCeC
	 0BefeOuFy9hSSgyw1JNrwHxhXZ0VFxpZyhUZC9Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 123/220] ASoC: amd: acp: update DMI quirk and add ACP DMIC for Lenovo platforms
Date: Mon, 20 Apr 2026 17:41:04 +0200
Message-ID: <20260420153938.457424263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit 6b6f7263d626886a96fce6352f94dfab7a24c339 ]

Replace DMI_EXACT_MATCH with DMI_MATCH for Lenovo SKU entries (21YW,
21YX) so the quirk applies to all variants of these models, not just
exact SKU matches.

Add ASOC_SDW_ACP_DMIC flag alongside ASOC_SDW_CODEC_SPKR in driver_data
for these Lenovo platform entries, as these platforms use ACP PDM DMIC
instead of SoundWire DMIC for digital microphone support.

Fixes: 3acf517e1ae0 ("ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260408133029.1368317-1-syed.sabakareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 2e0f751afe250..9d67443672768 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -99,17 +99,17 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YW"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YW"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YX"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YX"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
-- 
2.53.0



