Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D15939B6DC;
	Tue, 16 Dec 2025 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888671; cv=none; b=oB/7p/4UYILzYAS6vw/wOYBNIlXuYHxNbplYsnnCn81RQ+1P+dlXE6tBg9jdVDA+5BM8x1RPEO822Xr3W9RKhx2aS0d2LkNS+6qJWYiJfQpN/CpyORzLwUVJOifFfg4n1m1SDizrpfNAG3Lp4GW0u3BCFtSPQIY/eyZ8LImE9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888671; c=relaxed/simple;
	bh=LHDLUN/UG06xuBscLgVCHuSa/6K9LaghPdzC9WvztxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHAQU8bC9Xwk/5yoiCnqNrrFB06ZQ4PTHwUzQsBNyYYJnMm6X4ZgI2KwrBsIsIYLDSoG3hHeKpYqQsct0+zifxS5GMz55zUX5yhCAbnTsWBSrksTz8ML2N7E/x84olRKQ5qqcFHo6P87rVkQGq2WBeFsicGQFQ1qs11RWA9qN/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TP4tAx2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TP4tAx2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF124C4CEF1;
	Tue, 16 Dec 2025 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888671;
	bh=LHDLUN/UG06xuBscLgVCHuSa/6K9LaghPdzC9WvztxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TP4tAx2XxNuGZ63nFH4sa5ZV0DckEQcyf0h/nzKeUJbKH6KDtPBQ3ByERwJNRBnO5
	 4H1p08K1DW4wEAvVNZ5n+g4vyuYrlf93UkV8opTjXD0+7VQZWJwOcaU7HSynG7o4cb
	 dY8GkxVQY9iTJY+4G5oLHtNT2Ut8YmiLJF2LINaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/614] drm/panel: novatek-nt35560: avoid on-stack device structure
Date: Tue, 16 Dec 2025 12:15:27 +0100
Message-ID: <20251216111421.669981918@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1a7a7b80a22448dff55e1ad69a4681fd8b760b85 ]

A cleanup patch apparently by accident used a local device structure
instead of a pointer to one in the nt35560_read_id() function, causing
a warning about stack usage:

drivers/gpu/drm/panel/panel-novatek-nt35560.c: In function 'nt35560_read_id':
drivers/gpu/drm/panel/panel-novatek-nt35560.c:249:1: error: the frame size of 1296 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Change this to a pointer as was liley intended here.

Fixes: 5fbc0dbb92d6 ("drm/panel: novatek-nt35560: Clean up driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251204094550.1030506-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35560.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35560.c b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
index 561e6643dcbb6..6e5173f98a226 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35560.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
@@ -213,7 +213,7 @@ static const struct backlight_properties nt35560_bl_props = {
 
 static void nt35560_read_id(struct mipi_dsi_multi_context *dsi_ctx)
 {
-	struct device dev = dsi_ctx->dsi->dev;
+	struct device *dev = &dsi_ctx->dsi->dev;
 	u8 vendor, version, panel;
 	u16 val;
 
@@ -225,7 +225,7 @@ static void nt35560_read_id(struct mipi_dsi_multi_context *dsi_ctx)
 		return;
 
 	if (vendor == 0x00) {
-		dev_err(&dev, "device vendor ID is zero\n");
+		dev_err(dev, "device vendor ID is zero\n");
 		dsi_ctx->accum_err = -ENODEV;
 		return;
 	}
@@ -236,12 +236,12 @@ static void nt35560_read_id(struct mipi_dsi_multi_context *dsi_ctx)
 	case DISPLAY_SONY_ACX424AKP_ID2:
 	case DISPLAY_SONY_ACX424AKP_ID3:
 	case DISPLAY_SONY_ACX424AKP_ID4:
-		dev_info(&dev,
+		dev_info(dev,
 			 "MTP vendor: %02x, version: %02x, panel: %02x\n",
 			 vendor, version, panel);
 		break;
 	default:
-		dev_info(&dev,
+		dev_info(dev,
 			 "unknown vendor: %02x, version: %02x, panel: %02x\n",
 			 vendor, version, panel);
 		break;
-- 
2.51.0



