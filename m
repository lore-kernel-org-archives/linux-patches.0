Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624722;
	b=paQPb5beTW5+08mCxwcWFgdVkAFMBc7I/gh6rZfXRm6ONknk0Tb9qRr76tpjFgBrciqW
	 VaMz9DkVKzicTo8hQFoiXIwkHJUPPXikyBBfnIVD/RnZVBRot1B9zcy/Hiac9qBDojQNj
	 s+R/rYcc9F0M8ktZ4OWYSKRUM4DGsElYFc4lvuQM2A5w5o9ojkyWiLrAVw3WWwwtg9KoG
	 /4Y6EfJYTvPfV78JY53wzMyiBo4pZYBVw4gqjTtr9gweAv79lpbDKfKayR0oly92yj/Ci
	 xpXoV6EUc2oYo7i3HSDFrX2IdojmvFQSEo2mYD813lf3hzVib9Z1aB/mZLNa7f9Wfvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sU+o1gzmIvcN7NXNJwQWGHvGNE8860sK0xxK+ak1Vik=;
	b=ru7qR6dIBjyY68s7/3T5BW0HTj4wfmrM72EwiiU8MiYcY2OGNu9HlrUpdbbUuHFuRO+8
	 6S+9edb71BineSU9H+jRiS3jRJIKK6CJp1s+NEea5HjxIVUfcP9st+gCRcXMjqYq2k/M8
	 xzAHtS8EE8MRqzRZ/4sdMDOvTeAYwqcSqhH2vfYkWtfIIaWrQyVnNN+138SzZy+rO3uJ/
	 wVB0vdyj0wl/DdR82CoRG7Cb9IhmBhj2LDqy1apraLyr8ZN8TurrXqrXuVcrlBWmR+XuI
	 dlq7KxcN9comsD0dvoNPdm9xMqn6h/KRdcSYy4cVU5srK+mtf9gn3skvlT+VFwrQt1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn88gsKO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B56C606A33B;
	Wed, 25 Nov 2026 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn88gsKO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6321F000C4;
	Wed, 25 Nov 2026 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624722;
	bh=sU+o1gzmIvcN7NXNJwQWGHvGNE8860sK0xxK+ak1Vik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn88gsKOLSAZWhV5dTyj1MikWpTYsRC7V4AGN9MXe65o7203Ng0UAiPXm2L5DiIP/
	 P0/RikDjTM0hboiF3Ii68ukRTHBj3vDwQTwTVmEVTK0Dt3LElj1tAgveWUjewXBHrH
	 ktUzclytrl0mYGsejeP07Cpoz4nBg/sGa17PQvko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/816] ASoC: SOF: amd: enable ACP_PME_EN register for ACP7.0 & ACP7.1 platforms
Date: Wed, 25 Nov 2026 15:30:35 +0100
Message-ID: <20261125143855.850175970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit cc489cced17b2e32170ee87a3b64aaa3c7c6fddb ]

As per design flow for ACP7.0 & ACP7.1 platforms, enable ACP_PME_EN
register for below scenarios.
1. During acp init sequence
2. During resume sequence for SoundWire ClockStop power mode.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-6-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 34ea81a7f284 ("ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-dsp-offset.h |  1 +
 sound/soc/sof/amd/acp.c            | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp-dsp-offset.h b/sound/soc/sof/amd/acp-dsp-offset.h
index ecdcae07ace7f..414151187b449 100644
--- a/sound/soc/sof/amd/acp-dsp-offset.h
+++ b/sound/soc/sof/amd/acp-dsp-offset.h
@@ -130,4 +130,5 @@
 
 #define ACP_SW0_EN				0x3000
 #define ACP_SW1_EN				0x3C00
+#define ACP70_PME_EN				0x1400
 #endif
diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 64f7562c5486a..e5a36dc6583cb 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -582,9 +582,11 @@ static int acp_dsp_reset(struct snd_sof_dev *sdev)
 
 static int acp_init(struct snd_sof_dev *sdev)
 {
+	struct acp_dev_data *acp_data;
 	int ret;
 
 	/* power on */
+	acp_data = sdev->pdata->hw_pdata;
 	ret = acp_power_on(sdev);
 	if (ret) {
 		dev_err(sdev->dev, "ACP power on failed\n");
@@ -593,7 +595,16 @@ static int acp_init(struct snd_sof_dev *sdev)
 
 	snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP_CONTROL, 0x01);
 	/* Reset */
-	return acp_reset(sdev);
+	ret = acp_reset(sdev);
+	if (ret)
+		return ret;
+	switch (acp_data->pci_rev) {
+	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP70_PME_EN, 1);
+		break;
+	}
+	return 0;
 }
 
 static bool check_acp_sdw_enable_status(struct snd_sof_dev *sdev)
@@ -658,6 +669,12 @@ int amd_sof_acp_resume(struct snd_sof_dev *sdev)
 		}
 		return acp_memory_init(sdev);
 	}
+	switch (acp_data->pci_rev) {
+	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP70_PME_EN, 1);
+		break;
+	}
 
 	return acp_dsp_reset(sdev);
 }
-- 
2.53.0



