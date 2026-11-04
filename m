Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830824;
	b=GFmx7S+0sHRzV3lgPXe7lVD07emi8UrmPXVFRzJeGzQVq9VNHxi++i5SycmROG9H02PE
	 w1VVbxp48EP5pVd5Z0pPmIEmag0ke3zI/sMvAKMt70tqK+GY8AjlIBYtRWfzOmWp58hv0
	 KMY0HGFQeD6xh7I3+la5BB01zppy4KkYOXWBcPkdQOG0PNml3nUPkCbkgxeneAsW2CoTf
	 D6rnxNKvcrBua65dCiizMTb/QZjhb5ip++vqh6/dcP0REc4AD01kqJIoFpKvGFyRoascR
	 vjFrebYVfNczYpX6ZhnBrPVLA2VlMW9c64OpljMc6mO4Cdqw91AmmqHO1cXFydySonQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkzGhh3ffF8+CtVzJH0eYQvRrmPYjEfCZ9XLTUz3kt4=;
	b=r+8fMgDavcdktUWGxtJYrPOlZntSvtsoUhM8bDk9+xsUyqQfF11bNBRzU9Cr+ibKGN21
	 69UFZeYfqgQ9kcI/CHCRr90+Mz34fB0ZqtRYv9xYBC8+saXfOviuUdOPSHVgEszKNBFTi
	 NzfkP+NVC2UqWiJwz0QZGN5tpLPZWlO2bwmYZ+RkXqdMWWr6gbxPNsn4miZX3UOUVh5n1
	 mJoA/AbbqlDPNif4tEphMQbe+ZgzFrzEKF3qv3DA9h0CWMNbYjjNp4lWL6Q7IytBG5Ysi
	 iW7UHv/MQDkgNbRwt2Hp9zfoLcA3JKBY/uvcBg6IPD0gycw9+63K8pdfQOG7sbidd6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1bzsU2r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C536C606A326;
	Wed,  4 Nov 2026 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1bzsU2r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB61F00919;
	Wed,  4 Nov 2026 22:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830823;
	bh=RkzGhh3ffF8+CtVzJH0eYQvRrmPYjEfCZ9XLTUz3kt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1bzsU2rgO8I5zBhXyC16aqksl+t3VQkoxBKhtfYPZT/x4swxGJR7diaHGssu73y+
	 Wd7H4ugJDmmC9LKxkRtxym8tj8ftZc0OunrbnP75pYu98JfRUt/IT3eCAAG6wOGJQb
	 0eVL5WFC8u+REnLiV35Ot0esuQxAH8aMRJs/JpnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0305/1005] ASoC: SOF: Intel: mtl: Power down DSP if it is left enabled in pre_fw_run()
Date: Wed,  4 Nov 2026 16:00:38 -0500
Message-ID: <20261104211052.469262059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 31fd7a0bbfa4b7e8aff11f278e817664c6a5f68b ]

It is expected that the DSP is in power down state when the firmware boot
is attempted.
If the DSP for any reason was left powered up then the DSP boot will
fail since the ROM boot sequence might not be able to run.

Make sure that the DSP is off before proceeding to boot it up.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20260730122857.5294-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 2242c96bfa519..f119e0e0651a2 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -236,6 +236,17 @@ int mtl_enable_interrupts(struct snd_sof_dev *sdev, bool enable)
 }
 EXPORT_SYMBOL_NS(mtl_enable_interrupts, "SND_SOC_SOF_INTEL_MTL");
 
+static bool mtl_dsp_is_enabled(struct snd_sof_dev *sdev)
+{
+	int val;
+
+	val = snd_sof_dsp_read(sdev, HDA_DSP_BAR, MTL_HFDSSCS);
+	if (val & MTL_HFDSSCS_CPA_MASK)
+		return true;
+
+	return false;
+}
+
 /* pre fw run operations */
 static int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
 {
@@ -249,6 +260,18 @@ static int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
 	u32 dsppwrsts;
 	const struct sof_intel_dsp_desc *chip;
 
+	/* Power down the DSP if it is left enabled to ensure clean boot state */
+	if (mtl_dsp_is_enabled(sdev)) {
+		dev_dbg(sdev->dev, "powering down DSP first\n");
+
+		ret = mtl_power_down_dsp(sdev);
+		if (ret < 0) {
+			dev_warn(sdev->dev,
+				 "%s: failed to power down already-enabled DSP\n", __func__);
+			/* Continue anyway to attempt recovery */
+		}
+	}
+
 	chip = get_chip_info(sdev->pdata);
 	if (chip->hw_ip_version > SOF_INTEL_ACE_2_0) {
 		dsppwrctl = PTL_HFPWRCTL2;
-- 
2.53.0



