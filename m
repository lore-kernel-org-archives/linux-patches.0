Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D14137C55;
	Tue, 23 Jan 2024 01:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972110; cv=none; b=lUNLanB4+Z9jKOnT59KUjeUITDq6q+KR+sji9/U4z8ma6JKbaphkV2/aBDc4Fxtqw+QAq3vaapy3tiKRXg2nt0lDnjvUUneCemSEF/xaFs/JXvaRN77cNs9MEFsBziO2rnG1MBPI+JrHu3AEN1bFq/u9a60BdPnO28PS0i/C0mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972110; c=relaxed/simple;
	bh=dYnv5Gtvhy/C0mwG6L6LmWSoDbAsx9GLuvEXvjM4TpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxm+um5tBrNi/PX3dmE7h1XBolXLkzcFy/8CoubOzIWPkByKiOr6M7q3ZzdF5bp5IkMyVngNrt3bcNOE0jDd5OUtTowEHcDCMF8solSX4WNEHYviLI4BtLQQuEP6Sl6W1VnBrIGsXqOVb3AwS5RuBe0tGMXXH9pT2BTPSEyHbBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6/ttL2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6/ttL2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD46C433C7;
	Tue, 23 Jan 2024 01:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972109;
	bh=dYnv5Gtvhy/C0mwG6L6LmWSoDbAsx9GLuvEXvjM4TpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6/ttL2sWYN5vaUcI3QDYCwWQHU5R4RypAu1WJc7gemL97cZFP0sWBrSJvYP1j2Tr
	 Hqf7jbuw75F+qsNmFj14Z0Ogat6zsL7f+dLopk60EVDm33tkctgkOWe3uKya7J7R27
	 VEUWWrw4EuYQ7+RU4agqzJau6i5i2oDBFqeERVOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/374] ASoC: Intel: bytcr_rt5640: Add quirk for the Medion Lifetab S10346
Date: Mon, 22 Jan 2024 15:55:00 -0800
Message-ID: <20240122235746.149423784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 4df1be8170bb..49dfbd29c545 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -870,6 +870,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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



