Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A12ED168;
	Thu,  3 Jul 2025 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555194; cv=none; b=m/MR32y8M7N8Phtm/dOMOJ3pEptV+ZufeLPpTGw2rtfz9eRZsCDRpvr4zcvig5S4gJK02gwwnfr2vv3YbP5WhwaYc61jFtx/Jy6Ae1TNV4rgAqG+igrug4YR76bl7fWUO6aaliD09p6p4lgJGlpNaU80/WRNwNMoxzpN/q07NM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555194; c=relaxed/simple;
	bh=dOxeDfG5q9iwBpMm85ONnheAteuPg4TNcpfg4CwnKdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAfOWHbWt0bho2jZPQZ8n3CqihZHOkxiH5rdFy1JUTNeTCT0568agKTgcg3kTtF2LAr9BGuSeVv70FlY8lPpBw3yaxzyC1Zp3Meix9jiNBhzlBwJB0ID6N1UcNKoFRmSAas/kpSfUZZAH4XWy0ZUM1GaFor5Y7pVJno+sTO1GbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0Z02ftz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0Z02ftz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E176C4CEE3;
	Thu,  3 Jul 2025 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555194;
	bh=dOxeDfG5q9iwBpMm85ONnheAteuPg4TNcpfg4CwnKdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0Z02ftz/wyYZ2d8ImX0Doe43c99f43PQmFqDiS5bGL9dcc7iHOl29ULyeQ2I453r
	 8xmOOEx2pEWUZuqo/CEvEsfzfgkca4jIWpxUJFQPdXDRwhdfjJjnAHlqqvjBYUHFXP
	 dWR3drLYY1SiEtACrVh+9R5GYKqeven4bOcdv310=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.15 205/263] drm/panel: simple: Tianma TM070JDHG34-00: add delays
Date: Thu,  3 Jul 2025 16:42:05 +0200
Message-ID: <20250703144012.588133563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 716c75afd83c837f14042309126e838de040658b upstream.

Add power on/off delays for the Tianma TM070JDHG34-00.

Fixes: bf6daaa281f7 ("drm/panel: simple: Add Tianma TM070JDHG34-00 panel support")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250411-tianma-p0700wxf1mbaa-v3-2-acbefe9ea669@bootlin.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250411-tianma-p0700wxf1mbaa-v3-2-acbefe9ea669@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-simple.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4455,6 +4455,12 @@ static const struct panel_desc tianma_tm
 		.width = 150, /* 149.76 */
 		.height = 94, /* 93.60 */
 	},
+	.delay = {
+		.prepare = 15,		/* Tp1 */
+		.enable = 150,		/* Tp2 */
+		.disable = 150,		/* Tp4 */
+		.unprepare = 120,	/* Tp3 */
+	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };


