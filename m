Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ED317727;
	Mon, 27 May 2024 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838491; cv=none; b=U0mr56DtV6AU6UMNXY8ZE9Yv/bEh+YoL+6JF05FV4dZHQRjQVZG8196rGGBcEZus4wrPpamJCUBYhcwDOKTDki93tKa9PoSpgZ56UvJjttAtNU6rXIRUPTfaIfcHk18ekR10OkcCvB4/rRj5vobu4M4BwUiBnJalNrKbURJ9zdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838491; c=relaxed/simple;
	bh=ONBEHZ+yu5U5iIzXtqDLvaLdkDdiZUaQR+bjJo/0dRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THFiFjxJ9VCmhm3/w90MVXNdFwVEvzycXpDbTvQPwnjwSfzpe3DHPI0NAtC6KIyfqKUZmuQyhF2jeqh9OTp+ym4Xf4gOvzxFk2c49bNQyG5olMABY/moqMFWMOyjx+M1ZtsWYJWK866vcj7iUoMZLKw7ot5X7PCC8Rz+sk2p1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV/CMluo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV/CMluo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89402C2BBFC;
	Mon, 27 May 2024 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838490;
	bh=ONBEHZ+yu5U5iIzXtqDLvaLdkDdiZUaQR+bjJo/0dRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV/CMluo5hyA4DQ7H7wM2HYrLunxujXBJXsOyqCJTJMWQ21wfczx7oUyGo0xNDSrt
	 mU7O6V6BjsKZLtH+eawZM51zBCY4kmolPg6vYsCDETaXHSTLcEcGGOgLCoEpckpwHc
	 Tt01KRV4rcaMdts+zG+EHFz6NJcHeTwEtBrDMQGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 413/493] drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector
Date: Mon, 27 May 2024 20:56:55 +0200
Message-ID: <20240527185643.811660966@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 11ac72d033b9f577e8ba0c7a41d1c312bb232593 ]

The .bpc = 6 implies .bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG ,
add the missing bus_format. Add missing connector type and bus_flags
as well.

Documentation [1] 1.4 GENERAL SPECIFICATI0NS indicates this panel is
capable of both RGB 18bit/24bit panel, the current configuration uses
18bit mode, .bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG , .bpc = 6.

Support for the 24bit mode would require another entry in panel-simple
with .bus_format = MEDIA_BUS_FMT_RGB666_1X7X4_SPWG and .bpc = 8, which
is out of scope of this fix.

[1] https://www.distec.de/fileadmin/pdf/produkte/TFT-Displays/Innolux/G121X1-L03_Datasheet.pdf

Fixes: f8fa17ba812b ("drm/panel: simple: Add support for Innolux G121X1-L03")
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328102746.17868-2-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 72fdab8adb088..228c5c48e1588 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2564,6 +2564,9 @@ static const struct panel_desc innolux_g121x1_l03 = {
 		.unprepare = 200,
 		.disable = 400,
 	},
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 static const struct display_timing innolux_g156hce_l01_timings = {
-- 
2.43.0



