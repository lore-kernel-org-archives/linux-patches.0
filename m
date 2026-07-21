Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2397E46D2B3;
	Tue, 21 Jul 2026 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655724; cv=none; b=aHZOirkBS9rYoIpJZO5WLflLKMnM5W2oJHzINsTaQ2yCIprcwwr6bvPDvz/l98z1RituctNiXaJtoeXjTaqgQ35wtZ1BuKgLxK9FB7a5eREcvIhQfbmw0z/3UQuL+Gr6p6Yw94w+P04MZkbK1/HVUjWNV9LFEnU+ilNI4L4HzLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655724; c=relaxed/simple;
	bh=r96qolpRAPEMb22z3MQyUe8JMsubuhK5B/EUp4RF4u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drSHnTI+DxJ7z4E+TEtolEdSyE3Qhcq3k3Wk1xnaeCzfs/qcOnvu4Qf9naokEO8Rw0dM3MV4rvyAwJJvqO4PVlfmPQPqv2ZirWsCYcGlZmEKwa3SrkQKCQBbCCrv1PDYJ6wSzidsCEDpKAi5nWS5qMXsKsj3pYwR2RZZZheNhAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZXqjYm+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZXqjYm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BEB1F000E9;
	Tue, 21 Jul 2026 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655723;
	bh=O6xRogjewWJc+XOfBuLa6DBu3Mij0p14MjR25St1dyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZXqjYm+lCGCuipFLp+/p26hZxmVpvnUalzZbhJaFx2IwBWphta9cKVp9wJ9FXH+G
	 vAcg3YLrWX1QZUO9LBLqSW/5Hc7HUZmEr7Vi/TiUFUcZL5irR5Q1ycZlk8C1SyANZf
	 2Rlb3zyyzqoXY8Y8PxXzqwjuUT7P4YQ2J2SWLkTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@nabladev.com>,
	Chris Brandt <chris.brandt@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0117/1611] drm: renesas: rz-du: mipi_dsi: Fix return path on error
Date: Tue, 21 Jul 2026 17:03:53 +0200
Message-ID: <20260721152517.489523318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chris Brandt <chris.brandt@renesas.com>

[ Upstream commit 79e1afecfe1afbfd06f63bf7bbe854a88155b7bd ]

In case of error, we should unwind correctly.
Switching to using dmam_ instead of dma_ and moving the code earlier
fixes the issue.

Fixes: 6f392f371650 ("drm: renesas: rz-du: Implement MIPI DSI host transfers")
Suggested-by: Pavel Machek <pavel@nabladev.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260501132135.196701-1-chris.brandt@renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
index b164e3a62cc2f7..cbd898a182b564 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -1002,6 +1002,11 @@ static int rzg2l_mipi_dsi_probe(struct platform_device *pdev)
 		return dev_err_probe(dsi->dev, PTR_ERR(dsi->prstc),
 				     "failed to get prst\n");
 
+	dsi->dcs_buf_virt = dmam_alloc_coherent(dsi->dev, RZG2L_DCS_BUF_SIZE,
+						&dsi->dcs_buf_phys, GFP_KERNEL);
+	if (!dsi->dcs_buf_virt)
+		return -ENOMEM;
+
 	platform_set_drvdata(pdev, dsi);
 
 	pm_runtime_enable(dsi->dev);
@@ -1034,11 +1039,6 @@ static int rzg2l_mipi_dsi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm_disable;
 
-	dsi->dcs_buf_virt = dma_alloc_coherent(dsi->host.dev, RZG2L_DCS_BUF_SIZE,
-					       &dsi->dcs_buf_phys, GFP_KERNEL);
-	if (!dsi->dcs_buf_virt)
-		return -ENOMEM;
-
 	return 0;
 
 err_phy:
@@ -1053,8 +1053,6 @@ static void rzg2l_mipi_dsi_remove(struct platform_device *pdev)
 {
 	struct rzg2l_mipi_dsi *dsi = platform_get_drvdata(pdev);
 
-	dma_free_coherent(dsi->host.dev, RZG2L_DCS_BUF_SIZE, dsi->dcs_buf_virt,
-			  dsi->dcs_buf_phys);
 	mipi_dsi_host_unregister(&dsi->host);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



