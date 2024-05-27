Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA58A17E90E;
	Mon, 27 May 2024 19:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837084; cv=none; b=mXppcIp070lJDK9aH3INXuoHwb5E7ridIL84nBiK3LCS7puKBpx/S67NbbB+kqGPrWk/qKvABjyG7K3tLusdJbZo8eczYwp/faQJiheFGW337qJqif3GK+9Dcv8qoZeY+90CHBvBp4c4cpWTILLiFPMml5/sTCV2/T2PLoS1px0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837084; c=relaxed/simple;
	bh=N56PM2I6jK550Ze6e99MJQeMcEZLSHnMYQFDcjp40cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwYJzHeLAVdi3hThVB/cFlVQsRLNUZfYtOGBRbTnivy0Y2vXn9btCwLn2n6S+rGp6k3PozNuK8xVvYsKj2gszEwT5vBYwwaau78BqP6JvnpwM0yseLdff1GQM/MGrFUKL71Tnoii74m4s+FFDjL5AaWDMw5SfWHkQ2OJT4YI9k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9a64cbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9a64cbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242E9C2BBFC;
	Mon, 27 May 2024 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837083;
	bh=N56PM2I6jK550Ze6e99MJQeMcEZLSHnMYQFDcjp40cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9a64cbA51NuTGk5WG/i+PxZveaw9LrBZtLgF6wc6BwAd0M4B1O9t85x32mjH9oHG
	 kDlHnCWf1t1VmLeZ5GFZfz7OpsBJrt4CnLJ1PV70TqVnXxsD1M8H/NMXe6AfwJAd+v
	 8BOqUZzuPrQPCdfg30NiuQsh+u1Uwi872N27nRtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 303/427] ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed
Date: Mon, 27 May 2024 20:55:50 +0200
Message-ID: <20240527185630.403393054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 26187f44aabdf3df7609b7c78724a059c230a2ad ]

In case of error during the firmware boot we need to disable the interrupts
which were enabled as part of the boot sequence.

Fixes: 064520e8aeaa ("ASoC: SOF: Intel: Add support for MeteorLake (MTL)")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://msgid.link/r/20240403105210.17949-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 1454e2a98c3b0..fbd7cf77e8174 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -503,6 +503,7 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 	dump_msg = kasprintf(GFP_KERNEL, "Boot iteration failed: %d/%d",
 			     hda->boot_iteration, HDA_FW_BOOT_ATTEMPTS);
 	snd_sof_dsp_dbg_dump(sdev, dump_msg, flags);
+	mtl_enable_interrupts(sdev, false);
 	mtl_dsp_core_power_down(sdev, SOF_DSP_PRIMARY_CORE);
 
 	kfree(dump_msg);
-- 
2.43.0



