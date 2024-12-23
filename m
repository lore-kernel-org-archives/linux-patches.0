Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAC61B21B5;
	Mon, 23 Dec 2024 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970405; cv=none; b=mwfJaDnJgXNqW9BnD8m9f4+x2rIQDUBSwMm6d+vR/WIerCJo/JnR/gfDCd0IesoejWwBd06f8ATyS1tYiopsg7rpbo2NpCvyZogHpBZeEqiee6MGD8zsrr/Nqa8JXp298IhO++V9jLrDny5rpnofW19wNBiulyoHICfG7REisjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970405; c=relaxed/simple;
	bh=RHpM3A+7v1/xt7sZ994T/Hr0WPLk3gtzDhRR8A1Hizs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6SNnIh8FY316q/WnDOM5AJWrm3XxfXHeesSN5Mom0V1mQ63ghxftFTwXaPxbE9JP08eKyCrA99YSpEPeNxhFikmmSG8DEBvWmNYMfcGqmmeADuVjgZ4WJUcmtQ4oUG2sCb6s/Z4uVbr8fcrr8C9VJNBgffDe++AQoa2eJN+sf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG4FhHcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG4FhHcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B80C4CED3;
	Mon, 23 Dec 2024 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970405;
	bh=RHpM3A+7v1/xt7sZ994T/Hr0WPLk3gtzDhRR8A1Hizs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG4FhHcCf8wFETCbNd/XmzfmtR3v24fHmnALbuEQ46Y5/0JsdkgpqaQIoEaYhL7CI
	 O71fKF6en3Pd3NJsFUfk5Vl/s/Y22Py59l/5ZlKqw3+e/+VR/v0lVCjF/Exuq8RLwI
	 uy32jYBK91iFAChOrKSQBubql7gvmZsQJf3vIZcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/116] drm/panel: novatek-nt35950: fix return value check in nt35950_probe()
Date: Mon, 23 Dec 2024 16:59:04 +0100
Message-ID: <20241223155402.442464844@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f8fd0968eff52cf092c0d517d17507ea2f6e5ea5 ]

mipi_dsi_device_register_full() never returns NULL pointer, it
will return ERR_PTR() when it fails, so replace the check with
IS_ERR().

Fixes: 623a3531e9cf ("drm/panel: Add driver for Novatek NT35950 DSI DriverIC panels")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241029123957.1588-1-yangyingliang@huaweicloud.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029123957.1588-1-yangyingliang@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index 4be5013330ec..a7e1c2db5e24 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -569,9 +569,9 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 			return dev_err_probe(dev, -EPROBE_DEFER, "Cannot get secondary DSI host\n");
 
 		nt->dsi[1] = mipi_dsi_device_register_full(dsi_r_host, info);
-		if (!nt->dsi[1]) {
+		if (IS_ERR(nt->dsi[1])) {
 			dev_err(dev, "Cannot get secondary DSI node\n");
-			return -ENODEV;
+			return PTR_ERR(nt->dsi[1]);
 		}
 		num_dsis++;
 	}
-- 
2.39.5



