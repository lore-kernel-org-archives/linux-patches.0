Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5C4F204;
	Tue, 23 Jan 2024 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970318; cv=none; b=WM2tqM2WWYmmoYMbwmfsIPKj7GdqTZc6RtADTNJlP6qg3LCkuFwkkwtMLtyMoQw9efmfQitl3U9li7w/wqU4FSlSaN6+LTSr6KhKEuhiCrE+B/FPUV2Rxz2JbobYhd4qEWcfYwlG2LpES7cpALvRwoHEQdLdOV7fWbGnyP6Lt+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970318; c=relaxed/simple;
	bh=HZhgzkqof9RJd4k1zhDkHP4QfYBogxhHoBvkvVGMugE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VOdL9pt11UhRek20LYlWd9jhSwdaJ1SH0nVF1O8LsHQ+rIaqvbOgH4cFiYrIphiddeKAk3Ymm38+/C45QfcgA+ZXihThGlVmPHac4vNYj/KNZ/Ed2eubFr2/qMQDecMA6sfRlEqt+0+z9xfBNkywxsJDTrRvEb69iAz5slQoMxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtwKwXFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtwKwXFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D223BC433F1;
	Tue, 23 Jan 2024 00:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970318;
	bh=HZhgzkqof9RJd4k1zhDkHP4QfYBogxhHoBvkvVGMugE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtwKwXFGDZvjWNxDMYcQ9UoIpUuRQLy0FykFR8q7OlkVpiQArrESbos11HYHWbjxU
	 0xqL2E0Idji5GVbqmi3eKVS4EPhv+smp3bjPfsIE4eeLYxlOLqiIbXweBN5I8RPAx/
	 d1BL0kwiluWRB5MaJyZ7pEJ6f9Rmv8esQsFPAJ7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 608/641] ASoC: SOF: ipc4-loader: remove the CPC check warnings
Date: Mon, 22 Jan 2024 15:58:32 -0800
Message-ID: <20240122235837.267622906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit ab09fb9c629ed3aaea6a82467f08595dbc549726 ]

Warnings related to missing data in firmware manifest have
proven to be too verbose. This relates to description of
DSP module cost expressed in cycles per chunk (CPC). If
a matching value is not found in the manifest, kernel will
pass a zero value and DSP firmware will use a conservative
value in its place.

Downgrade the warnings to dev_dbg().

Fixes: d8a2c9879349 ("ASoC: SOF: ipc4-loader/topology: Query the CPC value from manifest")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://msgid.link/r/20240115092209.7184-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-loader.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sof/ipc4-loader.c b/sound/soc/sof/ipc4-loader.c
index eaa04762eb11..4d37e89b592a 100644
--- a/sound/soc/sof/ipc4-loader.c
+++ b/sound/soc/sof/ipc4-loader.c
@@ -479,13 +479,10 @@ void sof_ipc4_update_cpc_from_manifest(struct snd_sof_dev *sdev,
 		msg = "No CPC match in the firmware file's manifest";
 
 no_cpc:
-	dev_warn(sdev->dev, "%s (UUID: %pUL): %s (ibs/obs: %u/%u)\n",
-		 fw_module->man4_module_entry.name,
-		 &fw_module->man4_module_entry.uuid, msg, basecfg->ibs,
-		 basecfg->obs);
-	dev_warn_once(sdev->dev, "Please try to update the firmware.\n");
-	dev_warn_once(sdev->dev, "If the issue persists, file a bug at\n");
-	dev_warn_once(sdev->dev, "https://github.com/thesofproject/sof/issues/\n");
+	dev_dbg(sdev->dev, "%s (UUID: %pUL): %s (ibs/obs: %u/%u)\n",
+		fw_module->man4_module_entry.name,
+		&fw_module->man4_module_entry.uuid, msg, basecfg->ibs,
+		basecfg->obs);
 }
 
 const struct sof_ipc_fw_loader_ops ipc4_loader_ops = {
-- 
2.43.0



