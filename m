Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C1382391;
	Tue, 10 Mar 2026 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140780; cv=none; b=HxgZPm6SIoXbRBYWzhbMLnwbmXvNGEAjg3yWmo9DIjSK4VELvUfJuanUANelPVAirIP3An0M6W63KvZH3Ski/JxSWLdJhBE4uKo2iUVNaFoIJ9Hr/TiAhh7OBGbgT6q+caaVC0Nh9nq/fmbWLZ6+kbP69gWiw3Is6P+OmT28YCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140780; c=relaxed/simple;
	bh=BkACEwMeZADwQnE3z1a6tUC6KkG+r5fL5LAL/78NAHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtbD92tQfu6+aB2n4Xx41wMy7+oCLSJI7hmO5XwMEQohuZ2op+ohd9OcUM/TW7X/IHMDyumYNugoUpeo8zNJj3UNmGZzwGUPuZML9wJdEcSodplygkHYAuQiHKRssQ7ADcKDdLY+CL0MeFvT5ZnxYy1PpdGhTqD7xQkFL568roo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GclVuJf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GclVuJf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76071C2BC86;
	Tue, 10 Mar 2026 11:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140780;
	bh=BkACEwMeZADwQnE3z1a6tUC6KkG+r5fL5LAL/78NAHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GclVuJf612e0vgAPN4CAL4dR2Lq6lrIXFDb7GUHf+5gvybxHms4ibaz6KFmQYA7D5
	 dE/VPhnK3pin4juIbrp7bU72r5lcHOO+tlIUtlWARuwJepYGd6fJjvrdwZWCDagig0
	 fIg9nno+8fhH8ZJZqUWaEzkths+gxf+PdVk8z0vAruxrvDv72oClJ5a5oshKR8w3/R
	 fK+YLNyCqHzHzlsAw6XeOoiT1dljPHNJi6lorO/p41RyZdQ1OxwdQuWWwPA2zFS0f4
	 L379F96R3hSO2EzZaEhnr217ByXYfCzqvwmcraokBt3hk1Mm2631KrVjxPMB0Qj3wt
	 LTJMMECiE3Y8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 014/311] drm/imx: parallel-display: check return value of devm_drm_bridge_add() in imx_pd_probe()
Date: Tue, 10 Mar 2026 07:01:01 -0400
Message-ID: <918d85a06d49439559c1c3531e2330a4bbf5a589.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit c5f8658f97ec392eeaf355d4e9775ae1f23ca1d3 ]

Return the value of devm_drm_bridge_add() in order to propagate the
error properly, if it fails due to resource allocation failure or bridge
registration failure.

This ensures that the probe function fails safely rather than proceeding
with a potentially incomplete bridge setup.

Fixes: bf7e97910b9f ("drm/imx: parallel-display: add the bridge before attaching it")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260204090629.2209542-1-nichen@iscas.ac.cn
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 6fbf505d2801d..590120a33fa07 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -256,7 +256,9 @@ static int imx_pd_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, imxpd);
 
-	devm_drm_bridge_add(dev, &imxpd->bridge);
+	ret = devm_drm_bridge_add(dev, &imxpd->bridge);
+	if (ret)
+		return ret;
 
 	return component_add(dev, &imx_pd_ops);
 }
-- 
2.51.0

