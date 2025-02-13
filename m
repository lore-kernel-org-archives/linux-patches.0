Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879F281375;
	Thu, 13 Feb 2025 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457320; cv=none; b=ifTZDyJ78mUtjdPtUOZycf5tI/UUsyCNGcGFRzIxQOGpNckyM8275g7Ym3WmpbP0VtZgAbZY0hkMWoStjpbLic8B36r+9lm5u3DjtV/xs2ZhU+QA1CT6sNmvPCHQTH1F4udD/RS+sQtJuHtdE1NGVpiggpQg3j9M6N2afwNzbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457320; c=relaxed/simple;
	bh=dCCsG6rRVKgYAVb+qc+SNp1WyQRVVseP+kOF9gpeOGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1XfBlxYBG1UkAtxVegvsPvFPsSz7jXpg79osMnZ06PMmGSVBAWO9oWtErvtRtj28x3KhdAtkT1/yzUloNOF+p9R+h4Ucg3xO1f25x0V59v3KdkML9XNLTvLRpQ/8m+tWe7ZHtNB+04RKOPtbZtzvqbiWjK6fKjvkuW37GDE8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWeF/B5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWeF/B5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87AAC4CED1;
	Thu, 13 Feb 2025 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457320;
	bh=dCCsG6rRVKgYAVb+qc+SNp1WyQRVVseP+kOF9gpeOGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWeF/B5sS2xYS6fGGHTOeeHy4xH12Do8rnBbL5+tIcclSeXXE5/Sy65WjAjuRLNdu
	 FWzLS3d+uTGnJiCE/XOM4tadTd6VhaxBEqX9O5V+ZB2F6/yOq3q/PjRQXxRuXKjE1X
	 K+cdLePJAea9JHXfIucbW48TcbpMOrhxI+KWuWQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/422] ASoC: Intel: sof_sdw: Correct quirk for Lenovo Yoga Slim 7
Date: Thu, 13 Feb 2025 15:23:47 +0100
Message-ID: <20250213142439.566323470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 7662f0e5d55728a009229112ec820e963ed0e21c ]

In addition to changing the DMI match to examine the product name rather
than the SKU, this adds the quirk to inform the machine driver to not
bind in the cs42l43 microphone DAI link.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241206075903.195730-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 9f2dc24d44cb5..84fc35d88b926 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -617,9 +617,10 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "380E")
+			DMI_MATCH(DMI_PRODUCT_NAME, "83HM")
 		},
-		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS |
+					SOC_SDW_CODEC_MIC),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.5



