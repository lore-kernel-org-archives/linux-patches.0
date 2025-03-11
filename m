Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3811625E834;
	Tue, 11 Mar 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705849; cv=none; b=HnSOOSm8viUfM99dgv01z+6g9HJWPXD/gFuogX8INxuboLLzBxhlytfS9vKL5KA31eqdupFDTUJvT1dFxNkdShBF5iGe+mW3LOnTBtMS8FClcYzWqCrVlOhkKlTnY/psLFE0IVaB+4gA04U82jkLEU120hw+VB/YUBCJiCBjetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705849; c=relaxed/simple;
	bh=cvHdeCs1Jebf3vKz7HC9zkK1cID5kycjmHZiHHN/bS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+YBzbGV1rNdOk9wN7XCi1OhqNJjxcX8MeHaNZIX3vyKiVHByH2eAt/bKeSO14zwPVxu2jGL5Rg8Evv5UfzRgS02LeckMSH9v83GefKcnqqlhQZNajHhB8Y+AdL7HNo6REy6v9THpK8Jx/rgwShsNWxmanSYgNsF7MudJMevs9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3BzJKwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3BzJKwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FABC4CEE9;
	Tue, 11 Mar 2025 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705849;
	bh=cvHdeCs1Jebf3vKz7HC9zkK1cID5kycjmHZiHHN/bS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3BzJKwzsqET1sCjmpqtpUf0nfZSAOPS/pNXQk80+Ug0vHl1oOdFO8mU7y0FP4LBM
	 KvHbeHj/ep5OBBSOVq/4GM7qNV54dHyl3kZncawTOQJW+zJnUhp3QqKBi0/f1gwg9r
	 chyYUzv5Vi4xpF/cG2BJZYpukmTAWwlhEBNco1C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/328] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V
Date: Tue, 11 Mar 2025 15:59:06 +0100
Message-ID: <20250311145721.902331290@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 53a15be38b56f..104cfb56d225f 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -909,7 +909,22 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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



