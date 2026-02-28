Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36674341674
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301202; cv=none; b=A7ksz32NApw1+lsgxNGLe6qDDiJYwAmoZRQxdInSUckJuUVhoXRX4gCkiHyBWrsjGc4fE7D2ODYseSXVShA9qojC7ANLKG1SL3QMyjbSjjVEWUSmVUF16rNiR6u9G5RY5UoqVqHtArI+wDs8HUnE/s5yob2RutzJ+iNd7ws/pxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301202; c=relaxed/simple;
	bh=6Qso9r6u69JTBCvIc5ianu2/g1XD02SfiWBTrKGkfMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8FE8+y92GJqYzkNJbwYVpIyqF5wA1BsHWqoeQ/PDM+J0PX1pCBr68RpPtvo9s2M0o6bum42r602qYeyToaGNFbjSg7PVsVH5Fy+I2PcQjYw6aHhnbZE2ep6Bd5Ww7Ckvh9T0bI8f5NtTjd3Pu90g3A8sB1l59L5JaTmU05HL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTxZ4NeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTxZ4NeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9847FC19424;
	Sat, 28 Feb 2026 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301202;
	bh=6Qso9r6u69JTBCvIc5ianu2/g1XD02SfiWBTrKGkfMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTxZ4NeWqFkrDqeDvwrdxQLbnbYLX/2WFyQ1IhweacXnPEG1aEumD6PEUGty0/OM/
	 xNG47P7SlB01kYioeRMx4eARBBie5Yu3R7UZzEy8I+MOi7hBelzh/Lt8Nr3QSkMSyo
	 l+mbOC24CfNNKYv63CyOFga1i/uOj9g/qQWqWjlb3uqnk0iinpITEVfGDNJKOrR8bZ
	 nT/Y/TnV7VyEssi5IcRv8iMwgY4fbxRQ6Lpzj5ytsUdYCl37bzSNen7nQPNgENYRLJ
	 c7xRu9YFUotnxptxi4lGqx1GxVaCoL7tBA4oQr5pNjmEziLs5XlDwvT+yWr+sDNhzL
	 B3kSddseduv3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/752] ALSA: hda/tas2781: Ignore reset check for SPI device
Date: Sat, 28 Feb 2026 12:41:26 -0500
Message-ID: <20260228174750.1542406-375-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 908ef80e31e4d3bd953a0088fe57640cd9ae7b3e ]

In the SPI driver probe, the device should be in the default state, so the
device status check is not necessary. It should be forced to do the
firmware download as I2C device.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260211030946.2330-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hda/codecs/side-codecs/tas2781_hda_spi.c  | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
index b9a55672bf15d..488e35dac9524 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -634,7 +634,7 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 	struct tasdevice_priv *tas_priv = context;
 	struct tas2781_hda *tas_hda = dev_get_drvdata(tas_priv->dev);
 	struct hda_codec *codec = tas_priv->codec;
-	int ret, val;
+	int ret;
 
 	pm_runtime_get_sync(tas_priv->dev);
 	guard(mutex)(&tas_priv->codec_lock);
@@ -673,20 +673,14 @@ static void tasdev_fw_ready(const struct firmware *fmw, void *context)
 	tas_priv->rcabin.profile_cfg_id = 0;
 
 	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
-	ret = tasdevice_spi_dev_read(tas_priv, tas_priv->index,
-		TAS2781_REG_CLK_CONFIG, &val);
-	if (ret < 0)
-		goto out;
 
-	if (val == TAS2781_REG_CLK_CONFIG_RESET) {
-		ret = tasdevice_prmg_load(tas_priv, 0);
-		if (ret < 0) {
-			dev_err(tas_priv->dev, "FW download failed = %d\n",
-				ret);
-			goto out;
-		}
-		tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
+	ret = tasdevice_prmg_load(tas_priv, 0);
+	if (ret < 0) {
+		dev_err(tas_priv->dev, "FW download failed = %d\n", ret);
+		goto out;
 	}
+	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
+
 	if (tas_priv->fmw->nr_programs > 0)
 		tas_priv->tasdevice[tas_priv->index].cur_prog = 0;
 	if (tas_priv->fmw->nr_configurations > 0)
-- 
2.51.0

