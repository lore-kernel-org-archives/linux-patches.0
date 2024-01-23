Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AD83D69;
	Tue, 23 Jan 2024 02:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975792; cv=none; b=q5iniAvX/UUMGYn+O+FLnk/FEsxQkcCkd4TrWU/0mtMmn9qh9R9enqRtJPRjte50+dd+snFeOo8OKbIeuCyHVfcE4wdQK8SRMjvhYEDVJy8UkTt0SqDkm1zBFL/DTZToQlw+tcWfXLy2/yDXtb/29NV9mXrU1QyLbjO8PNMc+rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975792; c=relaxed/simple;
	bh=cAqsoXe6r0Jo8H3UD2xHqLnQ4x6hRPsCzwlqWjpvmJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNl3fn4ypamaEnQ1klCNvScS7H7hInALFtQTsoYHJyhsLQiXtP1yM9iVddhhJgX6oXQonPmFEdalsVcAM8fGN6i4vCCREZn+Mowh2bNegEfMTcvhOLSCX0v2TXHCfoQb5ARQElRatV9J94YefYyboJnvJfh34EkDMWZvQLadsqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLfU+iHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLfU+iHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F8DC433C7;
	Tue, 23 Jan 2024 02:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975792;
	bh=cAqsoXe6r0Jo8H3UD2xHqLnQ4x6hRPsCzwlqWjpvmJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLfU+iHIZB+mzsea9Ul0WDuYC9FngirD38PuPdFqqlZ1o7D0Qk2/51kaSsbsNa6IV
	 04vFrQK3v2aw8GKOUZD31SeJzn7HBC3pNxmIkTkMowi2tBYcCJ6IOLd0eLWMMey3T9
	 KFqEoJR+5/STdzo3rD6czIQNLx8QMyVcKsEc4pD0=
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
Subject: [PATCH 6.6 550/583] ASoC: SOF: ipc4-loader: remove the CPC check warnings
Date: Mon, 22 Jan 2024 16:00:01 -0800
Message-ID: <20240122235828.976300110@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



