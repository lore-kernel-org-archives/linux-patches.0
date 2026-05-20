Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BDA369D6E;
	Wed, 20 May 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295872; cv=none; b=tryD6E2/Gz+S5FzexJ2AKirxiHbmIYJ0XtkmQXO7CgK+K7udwbOUTXD/6Hy5h5HC7CyfuYR0qXDOTPTpb05H7MVpfm5VLLCbVjOAwEAYXPrX66xcMxCc+SRluXbLZBEYls9S4udfqziFllbOUfQ9E0MrYE5+6OtKB2SnCfBahvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295872; c=relaxed/simple;
	bh=elMHm1mt/kWDYMGWCuGNTyXTsNXO/k233FBzFBD6Q4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D58rsIvVw+YFDDH5Uj44X3ZokWkpxAUmCeyfQkfhpTmaQHZWXrefdk6aAvt+pwGI2mUav9fsHQ2u94q26BWZzyVXoshPHLyVAofXawndNFnElHj4NcQpCNfalhp5SEI7zn+PCzBPXEzjBupsvQrM0vpxR853XLwRR3qySJ6QxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJpDcxYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJpDcxYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628BF1F00893;
	Wed, 20 May 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295870;
	bh=WW+q1/77OCVjELBdQh3ibTVeBeFNqA0VUDoYnc+zuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJpDcxYK5A22KlhvQ7k3Db9AOj85tEGk4Uvhf//wjMvRxj3F5imBNthSeiegcDX/c
	 Ufg1mTAuI1nufEuxj5IrgePjFGfGNAgn881S6GFTwPi69BkdCPNeDr8xXcCJWVszdg
	 GMs+Oxa/PrTynOiHh5VsElNxiJbC7rwipF+Yvzg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0584/1146] remoteproc: imx_rproc: Check return value of regmap_attach_dev() in imx_rproc_mmio_detect_mode()
Date: Wed, 20 May 2026 18:13:54 +0200
Message-ID: <20260520162201.396021507@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a48c6676912fb808d2af1b8344d8656815a3e108 ]

Add error checking for regmap_attach_dev() call in
imx_rproc_mmio_detect_mode() function to ensure proper error
propagation.

Return the value of regmap_attach_dev() if it fails to prevent
proceeding with an incomplete regmap setup.

Suggested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Fixes: e14168bf3493 ("remoteproc: imx_rproc: Simplify IMX_RPROC_MMIO switch case")
Link: https://lore.kernel.org/r/20260209051407.1467660-1-nichen@iscas.ac.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 23126bc227059..0dd80e688b0ea 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1007,7 +1007,11 @@ static int imx_rproc_mmio_detect_mode(struct rproc *rproc)
 	}
 
 	priv->regmap = regmap;
-	regmap_attach_dev(dev, regmap, &config);
+	ret = regmap_attach_dev(dev, regmap, &config);
+	if (ret) {
+		dev_err(dev, "regmap attach failed\n");
+		return ret;
+	}
 
 	if (priv->gpr) {
 		ret = regmap_read(priv->gpr, dcfg->gpr_reg, &val);
-- 
2.53.0



