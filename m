Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4217819066B;
	Tue, 15 Jul 2025 13:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585367; cv=none; b=SQzLyb+qnnroqdGN3AYDhpFplfIfbmpGv/M8rFGuweKi1nAM110MSYrozOz1GuIAuJjWBtgDFgBKK2n8+ZLtt2ExbStxSjy0I67rfd4TsSXBNdu9R56BSYmW5uYHCvDxrtujNd09bk5KoBRFYb0G+C0nAu0oP8xZYVW5C6mcf60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585367; c=relaxed/simple;
	bh=0aRSjdDffhwHIBHUm2MNvC0Rt21qopTmCLnmH7CzQWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZbt57QaWPZ+zPSqK3NgqxU/+8/GQxzsUeToX2YSEgyeCGZAEX9dRo6Sn++jFc9E0rmtkzRxei/1ciuPc8+4zspmsOjkK2O1uwgmaKaejQpEPE+6bYaxOBjX5YcAAWMvLXflvgt8VxQ/NQ5HP16uVzfscqxEJVnooDyzFvTf3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGMvthgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGMvthgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85DCC4CEE3;
	Tue, 15 Jul 2025 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585367;
	bh=0aRSjdDffhwHIBHUm2MNvC0Rt21qopTmCLnmH7CzQWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGMvthgdn1vUYZKIMimC1NACp/0msYjgP04cCRhzWKyPP3eDkTbkRqLAvbc/zyPj+
	 UcetuVJfMLqmO0f1/wbeDujEEXhov9KTawN03IewIOZFRHGFt0ZbHObmx9BwoXS6F6
	 +BEy7yjNOJhkE4Y1LqJf1KRQoNq44QcgOx738YsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/163] ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches
Date: Tue, 15 Jul 2025 15:11:22 +0200
Message-ID: <20250715130809.346910664@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit a7528e9beadbddcec21b394ce5fa8dc4e5cdaa24 ]

Matches should go from more specific to less specific, correct the
ordering of two cs42l43 entries.

Fixes: c0524067653d ("ASoC: Intel: soc-acpi: arl: Add match entries for new cs42l43 laptops")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250626141841.77780-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-arl-match.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 73e581e937554..1ad704ca2c5f2 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -468,17 +468,17 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
 		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
-		.link_mask = BIT(2),
-		.links = arl_cs42l43_l2,
+		.link_mask = BIT(2) | BIT(3),
+		.links = arl_cs42l43_l2_cs35l56_l3,
 		.drv_name = "sof_sdw",
-		.sof_tplg_filename = "sof-arl-cs42l43-l2.tplg",
+		.sof_tplg_filename = "sof-arl-cs42l43-l2-cs35l56-l3.tplg",
 		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
-		.link_mask = BIT(2) | BIT(3),
-		.links = arl_cs42l43_l2_cs35l56_l3,
+		.link_mask = BIT(2),
+		.links = arl_cs42l43_l2,
 		.drv_name = "sof_sdw",
-		.sof_tplg_filename = "sof-arl-cs42l43-l2-cs35l56-l3.tplg",
+		.sof_tplg_filename = "sof-arl-cs42l43-l2.tplg",
 		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
-- 
2.39.5



