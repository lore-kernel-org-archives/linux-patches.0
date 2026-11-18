Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039263;
	b=QToYpK+ZJNYM5YpBJVmYC3GL7DwTOD49D77mBcSDTc/tObNcfZMXN+vrF/8aVtAK/+rG
	 OBIueCYAFDB234mVIHYXj8mFbNqQzmGFL3C1e7zTceOMtH2ECEXSJjFEyJ6ajzPq4Uu27
	 EKt9rvgaIxSQgoenjBPAfuZeyMDT+yOsU8AAueYvaz8R++gy+umIceORcEIViiLdR7r6k
	 FlvhpQ950aXI2FFxkwFq03PPlqM+niCClba+bZKwo+V23MdOIrUD9ZuTTNzIIdfKy2sna
	 KiEZdAili3GinXiepkt1b/7DMxNjG0FI2FTNRvnFukwVh91mKuQ7cNMTl4O4rbbodbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VoLmamTl33hlPTRfbnzb/WzK64xMWhPAMn91nA9fCOE=;
	b=ShjDmnPXXXss7tZcBqYdHp+vJsqwrRtDLWJ5eopuX/G1uH6Opo2UNEwgT/56p1jd3wIn
	 I0WTwBxAdjS9ikp0rCriSOqbD3DGd6auJA9jbErQ/KXWLS2s1YvwnDlc65gfwA/KjColW
	 NSnZIBoqdrFE7YdIaEBRDGsCznQZcyKga9fnFDZiUtLw/DhO/wry8sJMjpxXf72dNpXMf
	 92LWVX4ECWF4I68z+8Tk5u3jesiso2m2+ml5+DG3VhAixyakMrYH0OsgECKray826VNfg
	 ZHc8yhVJDn2do55EqLqiQa7kmChz26G0oFHBbtD2WEsCDpG7E4J5SR0r+AAsCUbMYlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3Z1lNWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E25606A31C;
	Wed, 18 Nov 2026 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3Z1lNWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD911F000C4;
	Wed, 18 Nov 2026 22:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039263;
	bh=VoLmamTl33hlPTRfbnzb/WzK64xMWhPAMn91nA9fCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3Z1lNWiqVbG+WWzJoGEDdyNLLVfHBKDkasdoDuUFVN8rZoYmz+TH4aY3geU7r9Ld
	 7i8771TPtHwn6VYXJG5c3ZgycuQeBWfOwV3BsLhahwhDv6anx8gR0w7AVb5iUOXOeu
	 x0Nbfl2MZ9/CS3N+bUXCIOvSb0Vk7rqxFcObbIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2037/3318] remoteproc: imx_dsp_rproc: Add support of recovery and coredump process
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150423.153414258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit c4c432dfb00fcb69d56cc9778f527cce71cec9bb ]

When enabled FW recovery, but is broken because software reset is missed
in this recovery flow. So move software reset from
imx_dsp_runtime_resume() to .load() and clear memory before loading
firmware to make recovery work.

Add call rproc_coredump_set_elf_info() to initialize the elf info for
coredump, otherwise coredump will report error "ELF class is not set".

Fixes: ec0e5549f358 ("remoteproc: imx_dsp_rproc: Add remoteproc driver for DSP on i.MX")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20250722075225.544319-1-shengjiu.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 13df1fa4f1a3 ("remoteproc: imx_dsp: Acquire runtime PM before adding carveouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 45 +++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index 960fbd4b1d9b9..85a51b1ceb72a 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -684,7 +684,6 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 {
 	struct imx_dsp_rproc *priv = rproc->priv;
 	struct device *dev = rproc->dev.parent;
-	struct rproc_mem_entry *carveout;
 	int ret;
 
 	ret = imx_dsp_rproc_add_carveout(priv);
@@ -695,15 +694,6 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
 	pm_runtime_get_sync(dev);
 
-	/*
-	 * Clear buffers after pm rumtime for internal ocram is not
-	 * accessible if power and clock are not enabled.
-	 */
-	list_for_each_entry(carveout, &rproc->carveouts, node) {
-		if (carveout->va)
-			memset(carveout->va, 0, carveout->len);
-	}
-
 	return  0;
 }
 
@@ -932,13 +922,39 @@ static int imx_dsp_rproc_parse_fw(struct rproc *rproc, const struct firmware *fw
 	return 0;
 }
 
+static int imx_dsp_rproc_load(struct rproc *rproc, const struct firmware *fw)
+{
+	struct imx_dsp_rproc *priv = rproc->priv;
+	const struct imx_dsp_rproc_dcfg *dsp_dcfg = priv->dsp_dcfg;
+	struct rproc_mem_entry *carveout;
+	int ret;
+
+	/* Reset DSP if needed */
+	if (dsp_dcfg->reset)
+		dsp_dcfg->reset(priv);
+	/*
+	 * Clear buffers after pm rumtime for internal ocram is not
+	 * accessible if power and clock are not enabled.
+	 */
+	list_for_each_entry(carveout, &rproc->carveouts, node) {
+		if (carveout->va)
+			memset(carveout->va, 0, carveout->len);
+	}
+
+	ret = imx_dsp_rproc_elf_load_segments(rproc, fw);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static const struct rproc_ops imx_dsp_rproc_ops = {
 	.prepare	= imx_dsp_rproc_prepare,
 	.unprepare	= imx_dsp_rproc_unprepare,
 	.start		= imx_dsp_rproc_start,
 	.stop		= imx_dsp_rproc_stop,
 	.kick		= imx_dsp_rproc_kick,
-	.load		= imx_dsp_rproc_elf_load_segments,
+	.load		= imx_dsp_rproc_load,
 	.parse_fw	= imx_dsp_rproc_parse_fw,
 	.sanity_check	= rproc_elf_sanity_check,
 	.get_boot_addr	= rproc_elf_get_boot_addr,
@@ -1148,6 +1164,8 @@ static int imx_dsp_rproc_probe(struct platform_device *pdev)
 		goto err_detach_domains;
 	}
 
+	rproc_coredump_set_elf_info(rproc, ELFCLASS32, EM_XTENSA);
+
 	pm_runtime_enable(dev);
 
 	return 0;
@@ -1176,7 +1194,6 @@ static int imx_dsp_runtime_resume(struct device *dev)
 {
 	struct rproc *rproc = dev_get_drvdata(dev);
 	struct imx_dsp_rproc *priv = rproc->priv;
-	const struct imx_dsp_rproc_dcfg *dsp_dcfg = priv->dsp_dcfg;
 	int ret;
 
 	/*
@@ -1197,10 +1214,6 @@ static int imx_dsp_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	/* Reset DSP if needed */
-	if (dsp_dcfg->reset)
-		dsp_dcfg->reset(priv);
-
 	return 0;
 }
 
-- 
2.53.0



