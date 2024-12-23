Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522128827;
	Mon, 23 Dec 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970672; cv=none; b=pRTZMbqjZ52uy8sZot3KbadeqnsYghechej0/iaDdijyAfWDXlwa4gNAjGTII4YhAs17VzvV+fX84EEBYA3LmBerR01UAcAR3gZZwIaKb1JrIsJgCKWskTkT7CG0g0oM0mBObQxnZ3JmeFizc3RZr5Kh8i9B0REVGtqhKozePyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970672; c=relaxed/simple;
	bh=p1mGlyIeGlUIzmkCDfRMro/h7WRHlI5UaaAzcAq9+3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s//QEFmA7IpV1lHJbAftBv65hF3y3uM4tjbWG8UVQHLTwXWbqcsZfFEQBACpfj53uqMN3tgJoXKu0LVq39NJPgBxleTNPnOD822wUKAd7mQRsnD2Kuel7mIWw/8+fqUS05UzyteIGXSf1KNS6DWgZ7iPI7HzLYtS9TqlnSdoZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFELriv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFELriv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94D1C4CED3;
	Mon, 23 Dec 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970672;
	bh=p1mGlyIeGlUIzmkCDfRMro/h7WRHlI5UaaAzcAq9+3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFELriv46BcnOhwNFWHZvm7V1ov4uaJp1t7vStqiVkjmgGk6gjjkNH77Nlgt5czt7
	 KYtGRCH6+EP26gmy+mdSvErv0NR4W6C6pL7+9Oo3d4/HuAt5SUVYIpLRySmFdoYSBn
	 q26ny9jomDr4OV3hNhGOz4qdLVfbENWaIN8CuS+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/83] ASoC: Intel: sof_sdw: add quirk for Dell SKU 0B8C
Date: Mon, 23 Dec 2024 16:58:46 +0100
Message-ID: <20241223155353.923708441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 92d5b5930e7d55ca07b483490d6298eee828bbe4 ]

Jack detection needs to rely on JD2, as most other Dell
AlderLake-based devices.

Closes: https://github.com/thesofproject/linux/issues/5021
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20240624121119.91552-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index cf501baf6f14..9cd85ab19c55 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -387,6 +387,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B8C"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.39.5



