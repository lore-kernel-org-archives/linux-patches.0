Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8479136405A;
	Wed, 20 May 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298563; cv=none; b=GWh5sbDTCLbyzq5gnGSjyyTppG5YSnTKhec7n7OpRCOdq81Cp+NCCAmjQNJwELLwPWjJ41bvhEoeesvSkP+/FFtpAb+sZPtLJ4FVyGrbiTiq6EA4cjshOKLtxPB8faalEl1TeR58yWIk9aC1hNM5f1bpJbczxzugMIQS6ZWHDWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298563; c=relaxed/simple;
	bh=e/CPLpCvbVRaL7fiCZaTFd95mHrbjURfG50GpiI+Fno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNJ+72RnNofYuTdASG1n7iTViiHxA+GL9tS5q9yv8Iq/f6FMx+GRWN3Kvm9494qEXmSWcHZ5LfZo+iALBvZ6rY5OKL8MzA7uZtpLXEUINVHWVCSGNp2WMzG4T2uVUI/XJDO1dW9yO32Xvr8wjhzzcD+QwnqS3lJeAnRAGM2/z8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7ZghZCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7ZghZCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB21F000E9;
	Wed, 20 May 2026 17:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298562;
	bh=Kdpg6A65bT0HgbGEPxbG6aT3uZV3q5wlwwhKdgWp54s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7ZghZCAtesnI7ONqqDcZVG57VLXy3R/lW+V7Sc8JJLwIhOrnfczTNO2cCNb6CSka
	 j7JgOdtz/QVwGeiqE9PmBH1pS45mFKVSEott392CIdFx27p3VoJugvp2YzafnWEji3
	 nFDzroW6QjDJvbADE9Nv/BF3tsNRYGDjpExjHvN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 458/957] remoteproc: imx_rproc: Check return value of regmap_attach_dev() in imx_rproc_mmio_detect_mode()
Date: Wed, 20 May 2026 18:15:41 +0200
Message-ID: <20260520162144.454855268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7ef99eac37f1a..8fa81d3779849 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -899,7 +899,11 @@ static int imx_rproc_mmio_detect_mode(struct rproc *rproc)
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



