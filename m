Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF04D1B0112;
	Thu,  6 Jun 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683354; cv=none; b=B4fY5Fq1TEcW+RMgYW630uZgK6QNM+YnntAP/bBqHfbEdu1MUwhdgjrlgenTAWZdUU8kjCPLuAy8v7NFWSmsAXp6cK9biv4HkNSBJyHghvweN0iFIXoJaoGNMH3vSnI+pkP59nzgL04T1A6xlCgSRpYntoxOIlHJ3YJs6/Xw19I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683354; c=relaxed/simple;
	bh=TvLqWJ92wVTozJkUgxMQwO+4ghNB0EEB+klfAER45n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGYpaAVOky3tA6t3z41xKJKuZ2CqFfb/gPoQU/TwtDnimQ5ACnJ9ss9gBs69mxeLda1/nTEp8gcrJahp7oHB6xenplexSANM27pNjedJNV1pFnnYEIP1P842RCX7hgPfLxPEx3RiIdX0xUW/oLocPs3W/hhmD2ygqe1sAijF77s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq/HxYCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq/HxYCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC037C32781;
	Thu,  6 Jun 2024 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683354;
	bh=TvLqWJ92wVTozJkUgxMQwO+4ghNB0EEB+klfAER45n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq/HxYCW8JYz8wDG2boxV2AvsjYTFQ8eYBWtU78tuyC4Hz6KddFAAA+pnRDMsv3sN
	 HUzXFqsKq4/Ww1V9nNGG8tDseFrVOmO9u4j8O/A4SHqeDV2amXyrJZetldtkohfVZw
	 2wiLf6z7EXmkcya7s2iyH/seMxEo3IIv8Pe46ako=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Yong Zhi <yong.zhi@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/744] ASoC: SOF: Intel: mtl: call dsp dump when boot retry fails
Date: Thu,  6 Jun 2024 15:59:27 +0200
Message-ID: <20240606131741.858271286@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit d5070d0c10326e09276c34568b9a19fb9a727b6e ]

Call snd_sof_dsp_dbg_dump() with the same flags/dump_msg
as used in function hda_loader.c/cl_dsp_init().

Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20231127105235.30071-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 26187f44aabd ("ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 834eb31cd9332..19709588aa5c2 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -437,7 +437,8 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_intel_dsp_desc *chip = hda->desc;
 	unsigned int status;
-	u32 ipc_hdr;
+	u32 ipc_hdr, flags;
+	char *dump_msg;
 	int ret;
 
 	/* step 1: purge FW request */
@@ -490,8 +491,18 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 	return 0;
 
 err:
-	snd_sof_dsp_dbg_dump(sdev, "MTL DSP init fail", 0);
+	flags = SOF_DBG_DUMP_PCI | SOF_DBG_DUMP_MBOX | SOF_DBG_DUMP_OPTIONAL;
+
+	/* after max boot attempts make sure that the dump is printed */
+	if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
+		flags &= ~SOF_DBG_DUMP_OPTIONAL;
+
+	dump_msg = kasprintf(GFP_KERNEL, "Boot iteration failed: %d/%d",
+			     hda->boot_iteration, HDA_FW_BOOT_ATTEMPTS);
+	snd_sof_dsp_dbg_dump(sdev, dump_msg, flags);
 	mtl_dsp_core_power_down(sdev, SOF_DSP_PRIMARY_CORE);
+
+	kfree(dump_msg);
 	return ret;
 }
 
-- 
2.43.0



