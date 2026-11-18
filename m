Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015425;
	b=dBaA2EhKenExPtQbvLp5hUOn++ZEpVe/rILLxqOQrk65hYfiRJk0R16/dWZetB0/UMKa
	 EQhI3z/vmIPOtQhXFIN7E9RIhu8MK0Aq5yzbSWI1ngysJu5nRYyn/iapTXI8elJYX22YY
	 l14BhHw+ZjrW5m5AtkJa2ovkDGVLvDerTzzwCO6QWQ+DVNiShjL1VkKSiBBFpHgukycVQ
	 sFKZKX9g87WpkxtZcsbgabzf0sbUCufSkS2KI8ABVByiZQASfK/1vnmEz0kPcvCGpTKKl
	 Y/CfmqF02vbMY7x+GDW+EmXf3MRcm/+MPZ7wvZANyHvO7OJwXsja9U4Keqyo+DGXO8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bEluPjGMmBsiQ4canQQAP9YUnDWCemXK4YeSw/vygcM=;
	b=Pm+8GvzPSdFEC4h0MJyif7TgQXn9LeKX4r5OgwHbkLjzZbzTLp7eNUxC53g0wEDwmc2x
	 //w4puSNTih3mQ84NhAx0d27+lcH3huUZ/Xyfr49Y6xCjkeHUXkLhJ/WNjI960HZa4bMJ
	 4QJACRJFV0cuFm+LrxHWNh/OhpRGBCPIMrAGr5Uk8FCv9jcJwWh1099ZFVrGPDqthyw66
	 gpi+RkyWPCuw9tZobP27m7wsz8eJAYAolN/oSd4ZeBcpaVOIGiQ7kc7sQHLr6nXS61Toc
	 u4xOqky/2PWfR9dSpfEL72+3HGGiykYMt2h5qmykjB7Ab4nXpT1ALAHhqeQQo1NWORQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKVHYbOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D393660A2600;
	Wed, 18 Nov 2026 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKVHYbOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382381F000C4;
	Wed, 18 Nov 2026 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015425;
	bh=bEluPjGMmBsiQ4canQQAP9YUnDWCemXK4YeSw/vygcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKVHYbOsS0ydrsAL0WHNcuI7UHzlsTxSeKXFT2AoqQt957zjTeQhfCC8qqWOcyBAG
	 8DtZUXv4ym6a4lViE6/MWX+n5bYCZjrEJpz7YAQ+D74gYfn/HGmCXAYZLAy5099i9a
	 aZpeThRNfwnSEIifzUcVbSMcXb2/9hUDFU59zhrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0170/2651] remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
Date: Wed, 18 Nov 2026 15:23:30 +0100
Message-ID: <20261118150253.976556480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 13df1fa4f1a30571442eda64c73d6cac7b9b5c95 ]

The prepare callback publishes DSP carveouts before acquiring the
runtime-PM reference that establishes required clocks and mailbox state.
A PM failure therefore leaves the prepare transaction partially
published.

Acquire runtime PM first and drop that reference if carveout
construction fails, so a failed prepare does not add resources before
its hardware prerequisite.

Fixes: ec0e5549f358 ("remoteproc: imx_dsp_rproc: Add remoteproc driver for DSP on i.MX")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260830133310.6926-1-pengpeng@iscas.ac.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index fd60c67ba8a9f..96d619daf3f5b 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -726,14 +726,17 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 	struct device *dev = rproc->dev.parent;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
 	ret = imx_dsp_rproc_add_carveout(priv);
 	if (ret) {
 		dev_err(dev, "failed on imx_dsp_rproc_add_carveout\n");
+		pm_runtime_put_sync(dev);
 		return ret;
 	}
 
-	pm_runtime_get_sync(dev);
-
 	return 0;
 }
 
-- 
2.53.0



