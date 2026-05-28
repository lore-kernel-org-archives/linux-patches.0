Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C633A702;
	Thu, 28 May 2026 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998736; cv=none; b=DmaGTtSCNBOsBciEQ8vENWzdzDGBUVC/vhV2mLown7XSmQVpXx9Ho0Unle3iW3e6gt36a6pjiEi2H9Yqg45+2pFMMmBiYHZBqdrlIWnoauiS0MBMPQziJxuIE85aS2QPTzIn6qmCRvt5zcop4ZbG6JpX4sHKefS1Wfiqb9Jn+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998736; c=relaxed/simple;
	bh=tetbYVVteLubKttNPlCOzimkYYoh/XyqT44bw4H3Gzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXMZyzto6+SsX4k1pw1Tat1DpYbDuU5p+hMGZwUc3pIolo9LCS2cU/zym9QUM7HHsFdM/BCofAUWRO6EF/8NhEL9bhwlrDkNTx77EGkk43pEuHQSwjLRFht+H5Duc00sWjjGuRCih0EZXZB7Z1g6Zdfe8J6bL2Ush401l1SCotM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ae+XLsxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ae+XLsxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A063D1F000E9;
	Thu, 28 May 2026 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998735;
	bh=D1GLTuInEpsBtaqUWzjbQJiXmLcFAvzUBYrQvoBSsfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ae+XLsxVu8uPyi50e1KkS0c5gXS+cghg4fUWUZo+Mk5ZGoQZcibUE4WDVImiIx5J6
	 QoyIglbHd92UBOQufHo7HB0rE4Pz4uenvkXOdUCyqiIquHD9zwJRMM/WcaOR6CJ5D8
	 DEyLpfFu4OeVpWIryd+i3nWNkhndEDR6qk99s11I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 233/461] ASoC: sdw_utils: Add quirk to ignore RT721 CODEC_MIC
Date: Thu, 28 May 2026 21:46:02 +0200
Message-ID: <20260528194653.886641154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mac Chiang <mac.chiang@intel.corp-partner.google.com>

[ Upstream commit fa749a77bdc50f0d695aaf81f1bd55967d77d10f ]

Add a quirk to skip the CODEC_MIC DAI when it is not present.
This ensures PCH_DMIC is used as the fallback; otherwise,
CODEC_MIC remains the default.

Fixes: 846a8d3cf3ba ("ASoC: Intel: soc-acpi-intel-ptl-match: Add rt721 support")
Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260508093224.1246282-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 827243d09f008..f54043e5ff450 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -463,6 +463,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 				.dai_type = SOC_SDW_DAI_TYPE_MIC,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_DMIC_DAI_ID},
 				.rtd_init = asoc_sdw_rt_dmic_rtd_init,
+				.quirk = SOC_SDW_CODEC_MIC,
+				.quirk_exclude = true,
 			},
 		},
 		.dai_num = 3,
-- 
2.53.0



