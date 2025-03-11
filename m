Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B473225E83C;
	Tue, 11 Mar 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707131; cv=none; b=PbHk6ufCr5scupvYazcVGblcTrX8n+XSQy3UUjnAFjAalxkMq8W/K1Kxlw0s6vLK84FOc5wrgVIq/V0x20rIKcbgGDI/Gb2w9MhtF1fukcRPW6FwvxUBnBLMUqR5BMf8974n//NhA6+DkgvlFnD3z2h017gPaYhjANNN/ho3R8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707131; c=relaxed/simple;
	bh=sNVOQT7P+Ywk8VoCs99T9KU0DYWXA/0vpJpVRphaYbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcT//xBFnu8IYN3lNTH2SCK/v6gCQqVgz68K2uFXRFCyZKD47cfyz79X2Nz595kFcUi2Nvfmf1qTVoz1ISY3ctNrA59Q/wnoA03OXlYfXRt8V9+HTSpO7Mcc3HSG4ouSbjfkDO9tahNWul/2397w+VOjdIB6XbvNFUFi3o34EDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGF9dePV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGF9dePV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBD9C4CEEA;
	Tue, 11 Mar 2025 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707131;
	bh=sNVOQT7P+Ywk8VoCs99T9KU0DYWXA/0vpJpVRphaYbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGF9dePVkUfGICvMkSEvcL144ts7DDPSOu+AeHRqDQ8dLFVvKRY5h0IXR7sP1njyF
	 0AWPh9LjDwuqcZZLSt86O0ilT0acTzaFbX86oAGe3KEpUz0GxM/RZZsyg/rLyX7vnx
	 z9lz3RA39Qt3vwWdg4ZespmbY33D4g+ObqCDqlOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/462] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V
Date: Tue, 11 Mar 2025 15:58:29 +0100
Message-ID: <20250311145807.968055466@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6917192378c1ce17ba31df51c4e0d8b1c97a453b ]

The Vexia EDU ATLA 10 tablet comes in 2 different versions with
significantly different mainboards. The only outward difference is that
the charging barrel on one is marked 5V and the other is marked 9V.

The 5V version mostly works with the BYTCR defaults, except that it is
missing a CHAN package in its ACPI tables and the default of using
SSP0-AIF2 is wrong, instead SSP0-AIF1 must be used. That and its jack
detect signal is not inverted as it usually is.

Add a DMI quirk for the 5V version to fix sound not working.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20250123132507.18434-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 6fc6a1fcd935e..06559f2afe326 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -935,7 +935,22 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
-	{	/* Vexia Edu Atla 10 tablet */
+	{
+		/* Vexia Edu Atla 10 tablet 5V version */
+		.matches = {
+			/* Having all 3 of these not set is somewhat unique */
+			DMI_MATCH(DMI_SYS_VENDOR, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_BOARD_NAME, "To be filled by O.E.M."),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "05/14/2015"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_JD_NOT_INV |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
+	{	/* Vexia Edu Atla 10 tablet 9V version */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
-- 
2.39.5



