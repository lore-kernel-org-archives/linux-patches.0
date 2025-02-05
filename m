Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE5D7DA6A;
	Wed,  5 Feb 2025 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766058; cv=none; b=I4s6hU7sw9ZkP8LlBW7wNDjyJsEXcTFhv6mdnhsD7EflWo/QXjh9oQkvDPIr9+AHQtfcvRhRK+7orZ8Pb++3eunutKQfmaIyI7H6BoVp15kGmEjZ8zR/E7Tydr15XXdSYYyKHq6foji0Kl6hWWbDmyL9NXWUmvyfDrWAmVdCY78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766058; c=relaxed/simple;
	bh=VmXnRXC4T+qg2YljcbXNMYLa0edyjt+sYOGBtuGrkPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkgVIvjKcq8CpooNRbZuMasxx9bdjf8t7yRYjkB/S6W+orUdq22B947hGu5F9Yq6CMphU6rk+EIjfmsE3LmiqM5DuIv0cZNChSHdcjSG+okudHgzXhgdSkL5QLh14VajAag495LhMrLxFUaiZkzRNB5nrxVW8aur7UKU4HjPm8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1tSQkg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1tSQkg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215D4C4CED1;
	Wed,  5 Feb 2025 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766055;
	bh=VmXnRXC4T+qg2YljcbXNMYLa0edyjt+sYOGBtuGrkPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1tSQkg/Jxjar0tc/6ZnZl4OIk6bPbI+IrvgV3JNcjKqa++xigO5WH1JYjJaOBeKU
	 sMBq5By9AeVAT1iE3RKNqmeRMCImCMOXrSEErs0A5j8ojd9QB0ozlnTxUMORdqR3/L
	 YA+4Mq8T7pq4OvFQfaL2tMx02T70O5VbrK/oM1Tw=
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
Subject: [PATCH 6.12 283/590] ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 83LC
Date: Wed,  5 Feb 2025 14:40:38 +0100
Message-ID: <20250205134506.105892591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index b6f9e5ee7e347..9350a1ea146b0 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -594,9 +594,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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



