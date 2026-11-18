Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029035;
	b=ZG+taH6v7mt84omneab5XcIqCHZYSPgwW6im81NcG1fur48w0ntZ12a4GJGid8dGgN89
	 CPZnEyRjkALlmPu6rcXUUUrn05tJxBso4K/+igkpl6V1w4wqH02hKU9+QhspAqO71d+sD
	 KlBqf9PAtecCpnM01G2KEQa28oIil6Swhy7dWJaqXyOs5kFf0UeO7lNfw2AqkdIHjVIps
	 iJduE5Nuh3liqBpXJyDv4kSe1fF9cpLQA9tohStx2yAbEEQW+fC9ciJq5sb2D5qSYghAQ
	 dP7rO1q0LaP9xBqAa+nUgt94dtqUIVsLjLGgla2akCDGHrPZPJRMltuGUI6NSCcCF3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yLosPnvm0MXEft4/dfAEjcnRwRbG5Hi1kvZFAQjkqts=;
	b=qL6mupA2pL58jHEh9jsBsy9lLAngZb8jkXfgqQcvJW70EWk6eHvxXcolUuNw6uoc1znw
	 nk+jWQ4ik6yDi6se3fFABmi4/9VGdTrGyIZbCOjbkoL9uQF6AQDUuZD9t0oCAmmyHJIVz
	 Lq3Zo72igU0VvOsH0ZZNp8thvJmqwnxAwkJGAj2FA5HJlqSn7ikcpkCayP17AkkQLU6xD
	 rfjHYox1iwCq79VVitaR2W/ZEBH6xmix/FmBOOoqLXgX68kuQKJVJFaSQc7I6QrTX5X4+
	 W7Svx+8mzRxy8MwzlO0mrXn2KrKxs9Q2bs5j58s0XM+93JBgdzwZm9feHbNmI26EnMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bDuw6ID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D59D60A2617;
	Wed, 18 Nov 2026 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bDuw6ID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF14C1F000C4;
	Wed, 18 Nov 2026 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029035;
	bh=yLosPnvm0MXEft4/dfAEjcnRwRbG5Hi1kvZFAQjkqts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bDuw6ID+yI3FhcV6ZHII9xx+y/GpspOJRGRR5BAfA3VzYDC7Xps7DRWJ2F59tU0v
	 sRr+naZ1qsybC5Wn7+p2ZbTTuMOXNwVielUr9/RjdeITBeGfolrAklHdooO0LwluSc
	 2EOdSZvjVIpT4uYdTQhOlDxp+MHdZmeb67nDhP4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0205/1756] remoteproc: imx_dsp_rproc: Add support of recovery and coredump process
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118150016.522500521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 427c200a175c3..af0b9d39a8eb3 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -680,7 +680,6 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 {
 	struct imx_dsp_rproc *priv = rproc->priv;
 	struct device *dev = rproc->dev.parent;
-	struct rproc_mem_entry *carveout;
 	int ret;
 
 	ret = imx_dsp_rproc_add_carveout(priv);
@@ -691,15 +690,6 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
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
 
@@ -928,13 +918,39 @@ static int imx_dsp_rproc_parse_fw(struct rproc *rproc, const struct firmware *fw
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
 	.find_loaded_rsc_table = rproc_elf_find_loaded_rsc_table,
 	.sanity_check	= rproc_elf_sanity_check,
@@ -1085,6 +1101,8 @@ static int imx_dsp_rproc_probe(struct platform_device *pdev)
 		goto err_detach_domains;
 	}
 
+	rproc_coredump_set_elf_info(rproc, ELFCLASS32, EM_XTENSA);
+
 	pm_runtime_enable(dev);
 
 	return 0;
@@ -1110,7 +1128,6 @@ static int imx_dsp_runtime_resume(struct device *dev)
 {
 	struct rproc *rproc = dev_get_drvdata(dev);
 	struct imx_dsp_rproc *priv = rproc->priv;
-	const struct imx_dsp_rproc_dcfg *dsp_dcfg = priv->dsp_dcfg;
 	int ret;
 
 	/*
@@ -1131,10 +1148,6 @@ static int imx_dsp_runtime_resume(struct device *dev)
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



