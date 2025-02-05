Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7EC70825;
	Wed,  5 Feb 2025 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766763; cv=none; b=fM6VZWJOR4PuGAckIcxeXPMRjJNmOdtkt0cMD4A3yfp9yXX0muObtVRb8sw+KRdf00c6CM0NzWgVmaXQ7ghSVZpv3wiCBZ9J82NUCDMY/yOoDy6W5wq02oK8NO/RSzkGAUE83hSeZQ+U2lrEnyBIiqCaAuimZpj/rUsEPujHsOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766763; c=relaxed/simple;
	bh=VLY6TjEwuPB8cIPrPa/5Xi1X9ERGC4V7LniTb7AP78o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe9xFQ609j/tdF6GUPNr/ZRzpN3buLIOhxsO+3T/siFN1xMkYfBFZ17sBPGoSRGIDczJLO6g3mTWMO0LdOynA5RGmp8lHbeJMxRWXsZF1GicSsxQr9wW9Z20U0r0NadwR+zNRcLGBV/Yii6OWvR1xaEO0HJuw5BgbtboVubS1fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9fGjyXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9fGjyXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D60C4CED1;
	Wed,  5 Feb 2025 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766763;
	bh=VLY6TjEwuPB8cIPrPa/5Xi1X9ERGC4V7LniTb7AP78o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9fGjyXbxwBE3ukWBFxpDd9OaNCr8y0aCJtQrNZbA09i3iYZIoajY1zfSd6zKxg7K
	 45JFHisymcEH73Vu13KX2j+A7ZcpTlYgVZLQNjSPN9pzU11bSb6vp95MDr66O7iR1V
	 vJFvohAdC+JDVM1WwxpDclnjhvxn6YkNX8O9F8vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 305/623] ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 83LC
Date: Wed,  5 Feb 2025 14:40:47 +0100
Message-ID: <20250205134507.895278302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit c9e05763f334845ba69494dd71d7cbfd05fd0e6e ]

Update the DMI match for a Lenovo laptop to the new DMI identifier.

This laptop ships with a different DMI identifier to what was expected,
and also has the DMICs connected to the host rather than the cs42l43
codec.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Fixes: 83c062ae81e8 ("ASoC: Intel: sof_sdw: Add quirks for some new Lenovo laptops")
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250102123335.256698-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 46f1c2d368dee..d42b012a6bb9d 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -618,9 +618,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "3832")
+			DMI_MATCH(DMI_PRODUCT_NAME, "83LC")
 		},
-		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.5



