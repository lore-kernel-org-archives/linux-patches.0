Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A341774B;
	Thu, 18 Jan 2024 10:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575363; cv=none; b=d7nKdzPxtHNrBDzqvL4//hdr/StWq0MCUxTbtSSswXgk/AwvvFjpV1JVdaNeltM+uh5MPlO4os0YyPtNrnHJJuETrbwsn24OI6w49leq0ITa1N9qsHrr4aETIQIJmBJkBWtFi163nh1Qu35lXHSBr1NNXML+q4ZF6pwm6Doyslc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575363; c=relaxed/simple;
	bh=Uv6KvKaOL0s11vjvb+VbHhtFRq6+OAxyuOVD8N8VYhI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=upDCp6B/Uk4rCMHJXj8zMh+qVyRO7xqcXb3QhNEuYQpMLrgBgEFxvefYAQwv5gJ5ihn99XVqrCMOMoqWyzGvYIiK4tz5UIrFNUCnz92qlAgrrRwmZeGbLne38RTGUVbG/o7LImNnCoerIAJu0fg85zfOeJ3KMZZHGqdIdBnTYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mWdZUqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mWdZUqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B46C433F1;
	Thu, 18 Jan 2024 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575363;
	bh=Uv6KvKaOL0s11vjvb+VbHhtFRq6+OAxyuOVD8N8VYhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mWdZUqmXuQ9C5EFH+2+ITbZRRZ3GVFOdhuLuKjmqpjMHhkPgNr8BTy4JFvzWFzNt
	 UcBJOzC75/ZIxYdN1Pg7HXizhYxWrkMB/5mLQyuVGZbjbCuKadkZojFNDbS8cRgthg
	 YXJI7A5RFtFzdWsrIth06tj/S3xIs1kSzVV3wEyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/150] ASoC: Intel: bytcr_rt5640: Add quirk for the Medion Lifetab S10346
Date: Thu, 18 Jan 2024 11:48:48 +0100
Message-ID: <20240118104324.959047909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 99c7bb44f5749373bc01b73af02b50b69bcbf43d ]

Add a quirk for the Medion Lifetab S10346, this BYTCR tablet has no CHAN
package in its ACPI tables and uses SSP0-AIF1 rather then SSP0-AIF2 which
is the default for BYTCR devices.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20231217213221.49424-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 630784b6cb6d..f184d23deaa0 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -894,6 +894,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		/* Medion Lifetab S10346 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are much too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Mele PCG03 Mini PC */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Mini PC"),
-- 
2.43.0



