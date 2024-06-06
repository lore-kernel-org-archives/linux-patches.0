Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C019AD95;
	Thu,  6 Jun 2024 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683356; cv=none; b=rEYTNaV/jQZ5VcW+cpLUS7WuCgUSfVwD8avEutP1W+Enob7QUF4agV3KsJGEvpoj8qW+Vc2a4k2dJki5eefNxzIDCsLDC5J5+ZZO/+9rkXYDW2VpzfBzAh3qoDrgu/LdWoFCZ0sIsXd0j0tu5BpXhCQT9nBbgEX76CTIPWetoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683356; c=relaxed/simple;
	bh=3F25pkdWUVoDziwh43X1HEmC2/eLMGafS9FVZ6QOxfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV47wilWgEn2eJ8M+WxqqWb8dth+Mq7ntzlrNwvyKK80DtxB/8VtLzUsme39ucqzOZArCqJYmhNSZa5+ftGD29bu01xFgj4Tybq/DuLlMc+FYLeFpGppeKV856vyId9lmLdWiH4PHgCY/dBvcUse91Mj3nL+DyQACZpLvwXek2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aib/cg4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aib/cg4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9DDC2BD10;
	Thu,  6 Jun 2024 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683356;
	bh=3F25pkdWUVoDziwh43X1HEmC2/eLMGafS9FVZ6QOxfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aib/cg4vUetGFv7nzOa4354UAxFa2Ukt7UXXd8pnefm7IslQD0XJtxttRlGGQ0ShV
	 NmnfIBWkNGWMS4pvPLchRDuCvPR5+DeQ2ceVBeszl6tcTEaHZKMt3IBqegAsvbkD7t
	 UwVe84Qd4Ps8i9Qi0W5yjnf3gfxATenjSHBvhE2o=
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
Subject: [PATCH 6.6 296/744] ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed
Date: Thu,  6 Jun 2024 15:59:28 +0200
Message-ID: <20240606131741.888010491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 19709588aa5c2..e3ecd48ccc4da 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -500,6 +500,7 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 	dump_msg = kasprintf(GFP_KERNEL, "Boot iteration failed: %d/%d",
 			     hda->boot_iteration, HDA_FW_BOOT_ATTEMPTS);
 	snd_sof_dsp_dbg_dump(sdev, dump_msg, flags);
+	mtl_enable_interrupts(sdev, false);
 	mtl_dsp_core_power_down(sdev, SOF_DSP_PRIMARY_CORE);
 
 	kfree(dump_msg);
-- 
2.43.0



