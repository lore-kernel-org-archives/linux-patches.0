Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4EA17727;
	Mon, 27 May 2024 19:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838403; cv=none; b=pFql3urVU/sT79PhiAwzz9Gg1RCdoTFWmyFP/dh4vLiIBOOVlkm/J8ksFR+HVhWfnrmhIbNt69kZEQVFaXYOPk58u8JnpZxD9ApJmhCxrJ+N8oOeuQLAbVOtUURM3PPEi2+RZ6Q7Xfr/dOTyfa2whGl8plvHEgJUjtn1dE+UlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838403; c=relaxed/simple;
	bh=pv5tuZsngFVi4tM7zZa7cMXa9CHAssCvXpyMHFOmlh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxtQGcPhqxm8M26ewbQWXqJwFg8ugtsxDy1OiAQ2uS7ckOB3BBTwFE32vV+1RRycrwfavZzkL2UaghZQZs5ja10QuwcBwWDbpp8kPo3w34KWhcE9slQeP7Lo+a6/KVl4pUMJiCu6+CMMLPu0cQvSi8F/1JxS+GCNaFTr2ijeFKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOSv8Qz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOSv8Qz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2E9C2BBFC;
	Mon, 27 May 2024 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838403;
	bh=pv5tuZsngFVi4tM7zZa7cMXa9CHAssCvXpyMHFOmlh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOSv8Qz3ppMl4P2pKjUQZRFlCogUNBM1YKlm8OhfOOcXqYxX9LOHRRMFtY6eas9Wj
	 BJFNbHAZvkEFC2MrzwER9rWYTb326ljdGKNx9o/hI73eR9CVNM5D81WgH44xe8wed0
	 Bq54l1a2sX1ZqliByN0M3fAAHaXgCSFERpPrwCyU=
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
Subject: [PATCH 6.8 379/493] ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed
Date: Mon, 27 May 2024 20:56:21 +0200
Message-ID: <20240527185642.675107981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



