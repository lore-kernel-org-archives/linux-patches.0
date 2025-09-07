Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CDB4315A;
	Sun,  7 Sep 2025 20:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277465; cv=none; b=SplMWarVT60vTj5R/fpBeeRNts/Mc4hesOF8E5E4UuBfOFSDHvnzwQ2w1yryW03VnnOX+2JH4xc5rpBBMvbVIUV8GwhuLJHlUug9lt2owozzUDqnTGGycqBGY68c24uxSr9P/5c8Z03A5jvrx5MYtd+v6LKSimRWXL9ZwlgzXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277465; c=relaxed/simple;
	bh=KRWFuruJqHfAeyBqceZ7b8WnpLeg3fZkFVD4H0HtJR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTPkW2WFT3yBd6ORPBeogsfg9Wbl2f4pxaBW4RfxOKQ0znjdxgmvSJpVAjNUw+GdfO62tCveIoxYVFgEmIjg6j55JTzxJQ5dFybhluZd/27VfLd6XElrBSiFelBSSV47AJ46veDk6BWUp9yO7aOiFny3PaDAxlYwKP6K79d8Rg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+g97APp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+g97APp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2166C4CEF0;
	Sun,  7 Sep 2025 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277465;
	bh=KRWFuruJqHfAeyBqceZ7b8WnpLeg3fZkFVD4H0HtJR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+g97APpcHdTYBW3cwNQHvYL1DTt1jSk6LWSxUpBj7Tcuh9Co/EiARd1DHRvHqCVw
	 khyUPNB4J8vA15c7QYbjF0OQEXQ/i+xzEpIhYb7kqgbRwXz/0RBlvhwHiZzwpY9aqg
	 KQ79eRbF2+rD6KerNpkR6cBrimHOrrTPOtLK2yPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ajye Huang <ajye_huang@compal.corp-partner.google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 006/183] ASoC: SOF: Intel: WCL: Add the sdw_process_wakeen op
Date: Sun,  7 Sep 2025 21:57:13 +0200
Message-ID: <20250907195615.951395630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajye Huang <ajye_huang@compal.corp-partner.google.com>

[ Upstream commit 3e7fd1febc3156d3d98fba229399a13b12d69707 ]

Add the missing op in the device description to avoid issues with jack
detection.

Fixes: 6b04629ae97a ("ASoC: SOF: Intel: add initial support for WCL")
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Ajye Huang <ajye_huang@compal.corp-partner.google.com>
Message-ID: <20250826154040.2723998-1-ajye_huang@compal.corp-partner.google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/ptl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/ptl.c b/sound/soc/sof/intel/ptl.c
index 1bc1f54c470df..4633cd01e7dd4 100644
--- a/sound/soc/sof/intel/ptl.c
+++ b/sound/soc/sof/intel/ptl.c
@@ -143,6 +143,7 @@ const struct sof_intel_dsp_desc wcl_chip_info = {
 	.read_sdw_lcount =  hda_sdw_check_lcount_ext,
 	.check_sdw_irq = lnl_dsp_check_sdw_irq,
 	.check_sdw_wakeen_irq = lnl_sdw_check_wakeen_irq,
+	.sdw_process_wakeen = hda_sdw_process_wakeen_common,
 	.check_ipc_irq = mtl_dsp_check_ipc_irq,
 	.cl_init = mtl_dsp_cl_init,
 	.power_down_dsp = mtl_power_down_dsp,
-- 
2.50.1



