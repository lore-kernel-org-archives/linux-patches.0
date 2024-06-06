Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876D119B3ED;
	Thu,  6 Jun 2024 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683387; cv=none; b=U498P9fTXzuN1lJMa9NtvSA8S7G05UtZgCKxHmX5UqVxiJ3uYJ0Avw6lqhu66LOo9HqUP5MxV7aXgUC76HF1R2LTWkCuHXsuUW8+vJBeXyht9n6n0MYvvI3UVGzI4SoeJe0VLObbbZlDT4yP3FD8rdtIYUgUplRyWcfaUS/CDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683387; c=relaxed/simple;
	bh=CJNzR+XlUbBxPrxcwhAgt4vtI7B7vy05RGDR7m+yFrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZjQRrAUWMiILUxSe3BwDJUIt2/DJK3saqNzdHJ0yjO8QLIjc2plydoyhXo1+5RGiUudWELLCNrXpXcqxl3pm1AutnWQVtDSjfl6026PQqxbuqKb1yZGgePOVBWIoVkws0lL9YZwFVZnbiBawPc1QLcXlBdjM/HAU03a8eSZQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiiRwswV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiiRwswV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67464C2BD10;
	Thu,  6 Jun 2024 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683387;
	bh=CJNzR+XlUbBxPrxcwhAgt4vtI7B7vy05RGDR7m+yFrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiiRwswVT8hOQtwKcPh0pQTOZa5BwAhyESxhV1UVerIIjsGMYestBJxg4hibMe033
	 uYedDcL/iERgH5Co3M2pzL6cDYCz9QHdVzo+V2BPacDGlcwWqm45BwXGgQYM3AW/AB
	 LQ2B2Q/8NMgoiJJe3+oAMfw285PaoDSPLxrpmmQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/744] drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector
Date: Thu,  6 Jun 2024 16:00:00 +0200
Message-ID: <20240606131742.958517386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 51f838befb321..e8d12ec8dbec1 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2407,6 +2407,9 @@ static const struct panel_desc innolux_g121x1_l03 = {
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



