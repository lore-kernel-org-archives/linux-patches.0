Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741D28629E;
	Wed, 19 Feb 2025 09:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957348; cv=none; b=dV6WarFUCs2LzdOFnneRNN0bgY1/K34YlllohyLQWtlHlI+bl94q2nogzvP77QS5s6kivZWhThtCn1R3EMydOrjYFSdKGVFiL6KHKAGdKz1H0PChQlc5ixRoZ+7Hz4IXSWBHIrrbBbMfRH2MtdBqeKWIeZhWrvFSDZB1PoenjFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957348; c=relaxed/simple;
	bh=ZaP85YO/Zm7RRwdb9aJEDQtqmV7HkVXLgRqs/iVlORU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxPlTvTS5LCnYJ328HcHxtgk7RF3Hf33gpirig/m8zRIvJRWIKSX0GjPWev1Fp24+KAy0Mov4LF1qLwDA+K0Y5VML62JgZwwgt3RrYXsh0YlPR51qpTzzYzmUutIucmHuEKdLBEv50B3df00QfeUwDoW63M4viY50+VBIh/Yd3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZNfjRSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZNfjRSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5115C4CED1;
	Wed, 19 Feb 2025 09:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957348;
	bh=ZaP85YO/Zm7RRwdb9aJEDQtqmV7HkVXLgRqs/iVlORU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZNfjRSwoIcAmwF39dz3aLgoCLtv81YwVjn4IOwbrHA1r99vEwf4P8py02CW3+gz7
	 Io+LOvkKX6VZrzKdzz41LifqeXluRRVqhiQtztQfIhXOSYkJizpGndycyg0u1NIxwZ
	 d1EdS0/LIn58alWnGGx5JPBaP6f+MIbGQus+6hh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 495/578] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V
Date: Wed, 19 Feb 2025 09:28:19 +0100
Message-ID: <20250219082712.465689317@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7d20011e2884..67b343632a10d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1122,7 +1122,22 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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



