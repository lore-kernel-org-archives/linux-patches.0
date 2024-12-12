Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ABF2185A0;
	Thu, 12 Dec 2024 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017836; cv=none; b=d33WKj9aDV68Wwc1fIAKrnW/c7DY5fGQTFWE+BlyJ6tzKVO6oSMFYzR9HWr+VX0gFELFr0l3+Cnhe1Uc2QQc9Y1y9CzP9rCbIBS1F2JcPC9UbtIi29mZeLDdBremKHprAvmIVryrH+TWLln/3qUgbKRhhh/fgy/p8KtOmtVJazc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017836; c=relaxed/simple;
	bh=fhp052IMS7XQju/F4YLNwrN31hYJMsoFAKd/wWPTwhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mDd9ZnSVBubblqOMQXIBqqLh9jKeDja7k4lIT67BaYrKYbh5fDwxdQJYdDsZqMtIc5oJlMk/52sp+J0dNp13WefnCLOT1uemHJdVAMZMBenT34smNy4x8/nfQfK3VhBbAEOuG9aXeDBVubqtcdulBMEVzZNG1CXV/FRXzZZz26c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY844Rkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY844Rkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E007C4CECE;
	Thu, 12 Dec 2024 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017836;
	bh=fhp052IMS7XQju/F4YLNwrN31hYJMsoFAKd/wWPTwhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY844RkfV8VsttNR0xE2UNpB47do321DQrB4du2kTXpnUT2XlyTVlDudhuUALlLNd
	 gqT1mrHCoJFtzy/vuoa/7AQxCvwO/Shd7+7/oloxDR2WbXpqrJnqdcIxie88eVl4zd
	 wWNzoesyXAnzaSE1HwaRKh3KqVE0c9q2fvCrurYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/356] ASoC: SOF: ipc3-topology: Convert the topology pin index to ALH dai index
Date: Thu, 12 Dec 2024 15:57:22 +0100
Message-ID: <20241212144249.510971426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit e9db1b551774037ebe39dde4a658d89ba95e260b ]

Intel SoundWire machine driver always uses Pin number 2 and above.
Currently, the pin number is used as the FW DAI index directly. As a
result, FW DAI 0 and 1 are never used. That worked fine because we use
up to 2 DAIs in a SDW link. Convert the topology pin index to ALH dai
index, the mapping is using 2-off indexing, iow, pin #2 is ALH dai #0.

The issue exists since beginning. And the Fixes tag is the first commit
that this commit can be applied.

Fixes: b66bfc3a9810 ("ASoC: SOF: sof-audio: Fix broken early bclk feature for SSP")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20241127092955.20026-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index d96555438c6bf..a1eab10211b0e 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -20,6 +20,9 @@
 /* size of tplg ABI in bytes */
 #define SOF_IPC3_TPLG_ABI_SIZE 3
 
+/* Base of SOF_DAI_INTEL_ALH, this should be aligned with SOC_SDW_INTEL_BIDIR_PDI_BASE */
+#define INTEL_ALH_DAI_INDEX_BASE 2
+
 struct sof_widget_data {
 	int ctrl_type;
 	int ipc_cmd;
@@ -1509,6 +1512,17 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 	if (ret < 0)
 		goto free;
 
+	/* Subtract the base to match the FW dai index. */
+	if (comp_dai->type == SOF_DAI_INTEL_ALH) {
+		if (comp_dai->dai_index < INTEL_ALH_DAI_INDEX_BASE) {
+			dev_err(sdev->dev,
+				"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
+				comp_dai->dai_index, INTEL_ALH_DAI_INDEX_BASE);
+			return -EINVAL;
+		}
+		comp_dai->dai_index -= INTEL_ALH_DAI_INDEX_BASE;
+	}
+
 	dev_dbg(scomp->dev, "dai %s: type %d index %d\n",
 		swidget->widget->name, comp_dai->type, comp_dai->dai_index);
 	sof_dbg_comp_config(scomp, &comp_dai->config);
@@ -2076,8 +2090,16 @@ static int sof_ipc3_dai_config(struct snd_sof_dev *sdev, struct snd_sof_widget *
 	case SOF_DAI_INTEL_ALH:
 		if (data) {
 			/* save the dai_index during hw_params and reuse it for hw_free */
-			if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS)
-				config->dai_index = data->dai_index;
+			if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS) {
+				/* Subtract the base to match the FW dai index. */
+				if (data->dai_index < INTEL_ALH_DAI_INDEX_BASE) {
+					dev_err(sdev->dev,
+						"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
+						config->dai_index, INTEL_ALH_DAI_INDEX_BASE);
+					return -EINVAL;
+				}
+				config->dai_index = data->dai_index - INTEL_ALH_DAI_INDEX_BASE;
+			}
 			config->alh.stream_id = data->dai_data;
 		}
 		break;
-- 
2.43.0



