Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8893A1D5ABA;
	Wed, 25 Feb 2026 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983094; cv=none; b=HduzEgv9CECCZcGFSs60HRsWfcIKdsDRPGfGSuSdvkPP0eg5TSf3DBWZPvjM3D5+5S0J5FC/44YAjmdmsLr+GIGbkalZmhEnByloiUJIGSRFivDr7rQCVJE8cLvvlkJ+Q83CzsW2ugGq6c0+bn2qczpV42hTq2XnXFZXOqtMK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983094; c=relaxed/simple;
	bh=N2QjWbxoIgrDkrJZwgKOrNwhOdvyaDeVli2bdADIRuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcQxMrPu082KgpL5V9i09fMI/ryhAjqM73STyyXdxWOKUyEgFY90zSp+SKAE243yMdtSU9Fy2ndNW02tQxqvmT4tt5QTTNVF6HMdCMuPHJPjToLnXmM/Digxdckcf8fLytHpCUl8shH0rf3x/l4lsdEsa17b/gk/IIHxA19L8dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJmP7pXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJmP7pXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0755AC19424;
	Wed, 25 Feb 2026 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983094;
	bh=N2QjWbxoIgrDkrJZwgKOrNwhOdvyaDeVli2bdADIRuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJmP7pXLw5ogwDU/04M6xWMx52uctUMZZzk5wTVrlvvEpFZOkJPibNrkro55+2a+Q
	 dkHOFx6s9dgRh/7/YmXMpbj1fcL4zS3otRw/WV/rM7n5Vioq1MzQVgz0Sj0NQIQOr7
	 xHx8mSKCPT92UN19RGg1vuuwqsrrbTgYDK90gTq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 212/781] drm/panel: sw43408: Remove manual invocation of unprepare at remove
Date: Tue, 24 Feb 2026 17:15:21 -0800
Message-ID: <20260225012404.912823202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit cbc1e99a9e0a6c8b22ddcbb40ca37457066f9493 ]

The drm_panel_remove should take care of disable/unprepare. Remove the
manual call from the sw43408_remove function.

Fixes: 069a6c0e94f9 ("drm: panel: Add LG sw43408 panel driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251214-pixel-3-v7-5-b1c0cf6f224d@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-lg-sw43408.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lg-sw43408.c b/drivers/gpu/drm/panel/panel-lg-sw43408.c
index 46a56ea92ad9f..6e307fba658f7 100644
--- a/drivers/gpu/drm/panel/panel-lg-sw43408.c
+++ b/drivers/gpu/drm/panel/panel-lg-sw43408.c
@@ -294,10 +294,6 @@ static void sw43408_remove(struct mipi_dsi_device *dsi)
 	struct sw43408_panel *ctx = mipi_dsi_get_drvdata(dsi);
 	int ret;
 
-	ret = sw43408_unprepare(&ctx->base);
-	if (ret < 0)
-		dev_err(&dsi->dev, "failed to unprepare panel: %d\n", ret);
-
 	ret = mipi_dsi_detach(dsi);
 	if (ret < 0)
 		dev_err(&dsi->dev, "failed to detach from DSI host: %d\n", ret);
-- 
2.51.0



