Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029041;
	b=uKqHXdf1uKdEF5TjrcwwneNrAdHMpmfxEL8zfA382uPWezcDsfGL+zeWMjSIhkL/BKVl
	 z4m0OMKBCMINznlXRgx356tN2Nn2sSQ+GanyJoOkCm5nf/70gLzPJx+eO2s31ICntG6YC
	 2OMBGJI29l9MmPA/XH/+3jvI43CdBuJA5QWY10W5Nbh5XiY52o7HCgtXTafBMDDtyJ4R8
	 oqDsdTpw63LEt1GJVCRK+FJisb7ze6O/0knNErJAaoBynEnIprBRUfXfwiByomJ66ybtM
	 IEBroisgr/hQnHQv9enDEA1FeWwOlhGk1JxxR3THXoonQLdOv0Cj9hnPlRf5NceHVFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=behYgfMBeMQa9k261YVkn8xiefzCUbOMVN0r/JkhCRc=;
	b=gIzhwuB/nIy+nNBDIGSvteraEVz7LwdiQIUABrK2UwmODg1rGLHZmnmLYRCWjVJlHU2J
	 oyjMdqAG7A/SSe7qoyQimyib47qTPiTppQme+Z6mQKw3CTYEdjZUDi9mj3hempLA1+jRf
	 LCev3yUalElBItv5PpIVs6xjZe5TqxEZeYUqq8VHxRj2nM5K3bfZys7gjN774HaHt5NHU
	 zsRtQ14TleR+nTYENMcn0w5JPPnuDnyHLblMkSD8UYplGDzVtLJvEfZMQzhG2rvuX/B8b
	 onJipTUirLp3cNWOeptj0SPKsg573MS9XEA6+sKCmEoqSEWUCd8GsOrqmY4M1be/Rtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOKm9fvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF87606A325;
	Wed, 18 Nov 2026 19:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOKm9fvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716AB1F000C8;
	Wed, 18 Nov 2026 19:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029041;
	bh=behYgfMBeMQa9k261YVkn8xiefzCUbOMVN0r/JkhCRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOKm9fvDmKoxunQsYCE4NoYQOVML+ym7aG04HWTIjAEOKyxFQoVwmXfcTR+Sm2eaf
	 Zl/MnTxGIcAarKbmw7qkBQcdmjK0wYkW/VArDH4rvkdRVaW0qf6XuWHfhLuQ2PuvKi
	 4/BNPmulRoLdB4X92Q9FC0Ciir8RGS9QylJb52DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0207/1756] remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150016.598236655@linuxfoundation.org>
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
index 2a999f0283142..df633aaf865b5 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -682,14 +682,17 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
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



