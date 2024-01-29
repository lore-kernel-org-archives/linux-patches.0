Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586D15B993;
	Mon, 29 Jan 2024 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548301; cv=none; b=oFq+C0GeKAfGs5wT2uUBh82rDdlRJVd2PRzlN+t0CeVefV3I8n6BFIC4RzZQdnfjcc1xw6PiRk83e7IZ8iNKPN1bGfavD2Jzqh5YFYeLwzX1ZEAKq6d1cEg6p2PDWeAlk9LA6U4UGy0rkBhno3g5FPmyWDik65wX4QuSIkoVUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548301; c=relaxed/simple;
	bh=/x4RDYgmmAye1GFErQHNH0EqztLm2YAMP0DU4DRa6/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBrqRIxhLYikk4Bdlv/DP0RBOtKZo+iS6DDJThXx0CIZGNQt8fzOEpXP7QkHQLa0jaJ5aSCVZXoegnLpafU8UfTGKLUX2AGunANCbtfeH0t0GPIU5zveSwIzpQySiLk95yFLQBU77k0VM8VdSFc9DPJUvKwzqOz9ywcR4DolSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbOKXlhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbOKXlhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFDFC433F1;
	Mon, 29 Jan 2024 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548300;
	bh=/x4RDYgmmAye1GFErQHNH0EqztLm2YAMP0DU4DRa6/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbOKXlhUQmLFfF00Nqc0GzcvrMeIP1Ya2kPJuPVUWpFY00HAZ1y1BpOoaQYn6SSSh
	 d8nC4ILpxQLh/EocQbTYniATUh+z/wPqPwSc+Ke8l0OfpupBzmT/tEJGC4r1vHOV2b
	 XsaXqxxMEnkhQdGjXzPFu2jOYRWexss3ZVMpaemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 307/346] drm: panel-simple: add missing bus flags for Tianma tm070jvhg[30/33]
Date: Mon, 29 Jan 2024 09:05:38 -0800
Message-ID: <20240129170025.495048177@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 45dd7df26cee741b31c25ffdd44fb8794eb45ccd ]

The DE signal is active high on this display, fill in the missing
bus_flags. This aligns panel_desc with its display_timing.

Fixes: 9a2654c0f62a ("drm/panel: Add and fill drm_panel type field")
Fixes: b3bfcdf8a3b6 ("drm/panel: simple: add Tianma TM070JVHG33")

Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/20231012084208.2731650-1-alexander.stein@ew.tq-group.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231012084208.2731650-1-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 9367a4572dcf..1ba633fd5696 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3861,6 +3861,7 @@ static const struct panel_desc tianma_tm070jdhg30 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct panel_desc tianma_tm070jvhg33 = {
@@ -3873,6 +3874,7 @@ static const struct panel_desc tianma_tm070jvhg33 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct display_timing tianma_tm070rvhg71_timing = {
-- 
2.43.0



