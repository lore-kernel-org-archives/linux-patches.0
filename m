Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060907;
	b=WtHUFvqh7O8r05CZVlPZ9hzdtwY+GvZRfBhnzcKsTWGsZHcZLEEyvkd/sG44hNMAQgZc
	 DgXgriYXi/A+MQkgsPSPqdigvpZWhnklp/fd3PZmzv2yL23F5gwHN1+OgT4GD48+3F2fX
	 zxbkoH7/ujng92Qg+7dvVtkZZVZMK3ixG313VDic7inpnR/LZpERV7gOSqA8OPZzJIjLN
	 3F1c0OGhXxBvnN/5h6nRB2uFOMrcsWwoYHf+VV7FkUL+yxws10d9sGN0vI2liHdBqsGGt
	 9yQlhau8W1br/sGnZWYYyabZDuOQgFg746V6RiHc5ekFevDfRrpjEyC4VRRNHMyInnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMGC496JWDes6PsjHzQ17p+xo5OCo1Zv0BzLmdN4e3k=;
	b=HYUPLW2Ai6RTr5xRgD9txb47CUqK23b5IGP9hTWqbi3jFoQQ3oSKcmncX6DVGjo/cu5z
	 Shcx2OrzQBuuutwtpKESHUuBdhMRhYqo2E4uuo2S8c8/awfI5IvfRW9WLzMaG+1GLQVso
	 Pi+ojCpbvZNmNbb7NL/6YLQNNCL6KsgUdBcCsjuh8hbRdOGIuzkiRApndG13A2qx0v8nH
	 w49RtCjPTGns/rsgvJEDUFSnQHqoF2cR8m1W+RJq4s4OkcqxfD6MRuoLlDzh1o5uInY3D
	 g41JJv2/bUmr8pT/bq9gvjO/NmaTQ/ScKn+2sthf/su6Yu3YhesX+AVvif1eXRpCf9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJEe9WHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC1606D823;
	Sat,  7 Nov 2026 14:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJEe9WHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C700F1F0089F;
	Sat,  7 Nov 2026 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060907;
	bh=TMGC496JWDes6PsjHzQ17p+xo5OCo1Zv0BzLmdN4e3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJEe9WHrbJtkHS5EXOPHTdbwGAC3Pp4o3Epgrg6iK+yqvtjL3PDj2lzMdIn4isvdw
	 9CIRBK5JT3sIYRJcIJOsJ3WOVXMP9X8MywWiADetGx0IpVJYjN939cpoIjpFMQlMTO
	 L3e03lWUBbAuS/sDhG+7ibHwml09dJ1xkSgyF5cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0251/1536] ASoC: SOF: Intel: mtl: Power down DSP if it is left enabled in pre_fw_run()
Date: Sat,  7 Nov 2026 08:37:47 -0500
Message-ID: <20261107135004.732836284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b9d22ccf345b..f8ed7db15d949 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -236,6 +236,17 @@ int mtl_enable_interrupts(struct snd_sof_dev *sdev, bool enable)
 }
 EXPORT_SYMBOL_NS(mtl_enable_interrupts, SND_SOC_SOF_INTEL_MTL);
 
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
 int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
 {
@@ -249,6 +260,18 @@ int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
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



