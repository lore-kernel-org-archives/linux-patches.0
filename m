Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA222687A;
	Thu, 12 Dec 2024 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021756; cv=none; b=cLaEGCL66fALABLPB15H0PFhNjIukI6f6TRTz/2dTnEw2oN7lqXpFw4FYWivyH8qGZqL8a2+B/w/YSySS19RwV7l2TW4+2ktfHDDk7pxfJAzKT7pyr3zmoSb0LytNEyUtL4kHq88OhQ5qR6I4vhJa5ZRBrWw4fnbnjr+/pKpMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021756; c=relaxed/simple;
	bh=eXcVip5XV+xa1ZjtIH3YOEZjw2bpgiGhQKw8B7yhFhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Civ9zy+PwugM3xXiw8tVuKy7UsMHU93hlJNMGPIiFFP9fNHKgCvr9X2npZN6Un2ivL/VV0IJ7k+eLnSUmOMQAtK4OOxKO+8R4lRQzk/GADyYEgG8fFUNps2/BFnLKKjwBYaGOzEWCgd46a6FSbDCmABJtChK8oiXTnU0e9+8dYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVtDgRqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVtDgRqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB42C4CECE;
	Thu, 12 Dec 2024 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021756;
	bh=eXcVip5XV+xa1ZjtIH3YOEZjw2bpgiGhQKw8B7yhFhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVtDgRqQ7cBQORvSU2+ereYdBdZ2wJp1uwJepmW0lmdP2EUB4kCfFB5YUuvMOX4QR
	 BCr96SR+YuKLXS5L4Dru1ehXlBr+ehGqcWQx+6DknY295IbG3/jwMQTYO/UI2P7d9C
	 5omSOfgOqn6rgkA5FZiVaXhW5jTYoC7cAo5YN95U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/565] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet
Date: Thu, 12 Dec 2024 15:54:07 +0100
Message-ID: <20241212144313.552743097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0107f28f135231da22a9ad5756bb16bd5cada4d5 ]

The Vexia Edu Atla 10 tablet mostly uses the BYTCR tablet defaults,
but as happens on more models it is using IN1 instead of IN3 for
its internal mic and JD_SRC_JD2_IN4N instead of JD_SRC_JD1_IN4P
for jack-detection.

Add a DMI quirk for this to fix the internal-mic and jack-detection.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241024211615.79518-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 899a8435a1eb8..8706fef8ccce8 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1102,6 +1102,21 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Vexia Edu Atla 10 tablet */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "08/25/2014"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF2 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Voyo Winpad A15 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
-- 
2.43.0



