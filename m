Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F7316199;
	Thu, 28 May 2026 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999865; cv=none; b=nWq8+S5KG2gTjsD2ucy6Z9ZEUGsBiIXjo1y8H5fnUiEKUakFf+dRnlRuy7YYEsB0y08WnlRT73vDdOSvZCHRDsPC2V1JuXdo+IjBRBEuc54rNgFja+mgMbmHuLANuGBH1yUh4QoFbRsFczuMelQdFTaUwSeCtcZIujt7E/6l85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999865; c=relaxed/simple;
	bh=Y/98wAKQsQklHVZuCuVDy4eCscqOFQaTfrKgcKsNvq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wzw6kCOaYJByGC2V3lT0h5lr+ZslZuWvvE8vrInpMvAbDJvGrNpmqqFsWMzkwYv1/iVRr9pNQaQ6rRrk5jUpqlTzLO+4BkE0nv8VjvawbrE5XV8zT8HwtcG7R3q4AUFRfj2LaToBhcHtPtt61biAUqkz5pwbmdJfFZKQZeyH6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNruIvsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNruIvsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBA51F000E9;
	Thu, 28 May 2026 20:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999864;
	bh=XtFxiIFR8ZMXfKSSEOPCh4NKNpZEEpKNFgQHgvlsR84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNruIvslL8m/RSQsO/GeSN8NDUlbvqDzQTdgcfvRwwZdtIzVEADi/6QbsNBFit0c0
	 m9kRt9j6lrI/D/l8Lu+UpnjiJ3k/JosltFYhCZbsS7zz6AgumPcgaoXdDaZ85+dsHf
	 yFayRebDeVCGVRQOrIhgjkOBqWuU3ZY2t588ay74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/377] ASoC: sdw_utils: Add quirk to ignore RT721 CODEC_MIC
Date: Thu, 28 May 2026 21:47:36 +0200
Message-ID: <20260528194644.709016266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 050ca17ff105d..3facb78748acf 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -431,6 +431,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
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



