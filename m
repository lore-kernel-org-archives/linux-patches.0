Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2801754B;
	Mon, 27 May 2024 19:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837176; cv=none; b=rdcnqKQThzIgrFnQzZzi4B8us2UISLBL3bwrrVfKnDQEYFB4Y/zY6CvqPT+5McNUWN0aqFU0Jl29+y0R+ZMGBm/8EA8Mvw0Ae+mCwy1il3GFDPVbyfOg1GINqu6FqH8qONsA8xLlVa3cGu0OBL9FpoyP3oDelWzi6HKBC/FJnv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837176; c=relaxed/simple;
	bh=7smauYWnwi4yzhvPS8iuAIp4uR6j3XkDlwl6jwcpNcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxGCaigxrdGUYe9PazN5GW2FvYwYXc9uOjq0gkCZ+VDXXiIMdc+V28k1ZBBwNHJb7vOxYb7ccrd/U+RTqxequNQRnfwmT6Z+UcAiUp2/XjZZLmBNTtYSNOkXOU5cUHvuWcSS5K37DdxaEec1rur4H0X9G5viJF5KaNhbX4akLn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdIgA801; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdIgA801"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D21C2BBFC;
	Mon, 27 May 2024 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837175;
	bh=7smauYWnwi4yzhvPS8iuAIp4uR6j3XkDlwl6jwcpNcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdIgA801YAzOXWhJOCnfNs0plb+D/UFb7BmAyYq3KWV5F/mQkUn6dU2lSVEXNNYi5
	 DQf1LiN27Eo1lxWKh+sEY1nOB7ZHlIBl/M5+dUVkHww/HBlXswIf0p0iEH0Nf4CdvS
	 Q345jXCMMOOceRrPqpf/pspjphqsH/LVFZpkCg/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 339/427] drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector
Date: Mon, 27 May 2024 20:56:26 +0200
Message-ID: <20240527185632.764865505@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 20e3df1c59d48..e8fe5a69454d0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2591,6 +2591,9 @@ static const struct panel_desc innolux_g121x1_l03 = {
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



