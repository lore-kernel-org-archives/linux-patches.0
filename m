Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468A146A9D;
	Tue, 25 Jun 2024 09:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308910; cv=none; b=kmeT3uF7QsksEGdeIDlXtmFcJELM/l8qmUupZ2fi0x6vR9auOGeHGuX2jtwV8LEkrzunO+ZvKoVzYjywadhbRK3rBB1l6mKk49adZsfzL4r3r59I90XYDUft62YzMriD7TRBE3QDCRYOHatkpZ4HLLyx8SsIDfg/lbAeLtnaQiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308910; c=relaxed/simple;
	bh=LrISNkV/RknwHDxfXr4QT1IjJ7AuMc2g/Hn7WxIY/eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZsg4ZBumRAfq4XfUt95YWCjZZ/Ym2DElrut1prTdNezD92AGGreiHstszXnY/n04Xj+7CMgra+mtGvtcV4AQuWm/s32eKFeqBYIVwTfsYt+zi1lppuo3PVWca32J6UIX960kkrWfzZAkcG14d6wjVkiznNo+bPOGWJhYtqTaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPPb2b5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPPb2b5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D59C32781;
	Tue, 25 Jun 2024 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308909;
	bh=LrISNkV/RknwHDxfXr4QT1IjJ7AuMc2g/Hn7WxIY/eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPPb2b5zEuvCPh1R+AR78SihZc6j5bDYofsfNiEZ/0fY0lbYDGBQPiPi8Dq0R8xAx
	 5ojBWK1+OKotedWy2A79X+WH60Toz++v+iPNoxdbNGIs3Qe+81EePOqDM2x5KofMhj
	 QXy9E/QauNUhzfrWSZyFLv+kIQn+qj1l5QKazxy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/192] ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14
Date: Tue, 25 Jun 2024 11:31:43 +0200
Message-ID: <20240625085538.356509771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 4fee07fbf47d2a5f1065d985459e5ce7bf7969f0 ]

The default JD1 does not seem to work, use JD2 instead.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240411220347.131267-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 0ea7812125fee..59621a9c389c7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -502,6 +502,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_BT_OFFLOAD_SSP(1) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN Transcend Gaming Laptop"),
+		},
+		.driver_data = (void *)(RT711_JD2),
+	},
+
 	/* LunarLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.43.0



