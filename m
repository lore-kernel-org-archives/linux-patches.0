Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21A7C09C;
	Wed, 21 Feb 2024 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522328; cv=none; b=BpdGI1kKM6GrSZ80va+ehLSvl1c6LMnhWnZzFMu9SsiBAtWQNTnGIsB4ahUUaFNhaIPiOZ+yEv3C+CJ2CjZXqvZA+I3b3LK0QCW8sksR73eGk4YnkxL4QiCepZTyA+/tVgXCeH68mK3YZLJ0b8NHbL2sz2ZCal/dC4bNnnNkCXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522328; c=relaxed/simple;
	bh=DRcEepM2aV8hDH8+v2+SX3lBIYYrhDbnV6fqwMueHoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbMPb9nlz3NfjuLLA+wksZ4bUIGlzHNFAJUfxQvDnvwgxGTpMqz7fp22eOMMlAU+Msat7S8qUi+lEwGmiSWHAzMShJihAi1zd/fXidW2n2zRIrdfJx3G/2yBSeo2FrQV+3/EYamglJyMHa9tkkul9qAMLVITcsbqJaJ+LNEoINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFjDD1yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFjDD1yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166E9C433C7;
	Wed, 21 Feb 2024 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522328;
	bh=DRcEepM2aV8hDH8+v2+SX3lBIYYrhDbnV6fqwMueHoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFjDD1yzQlGzpiJFfNfIeJfX/zqXtlGJHYkZ5WO7KFszF+FePh1dxgN1ekLGhXzyQ
	 SBkDnrFal+My5CYT6BHg+vQlkNq6uv5ub++DYboMKL4Ny3Sk3DFEugDDzYZTxFxH1h
	 KoO75WQ97e4X6soSmTHV5elKolbJUCut9ygj/c3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/476] drm: panel-simple: add missing bus flags for Tianma tm070jvhg[30/33]
Date: Wed, 21 Feb 2024 14:02:47 +0100
Message-ID: <20240221130012.283573385@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d9f1675c348e..671bd1d1ad19 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4173,6 +4173,7 @@ static const struct panel_desc tianma_tm070jdhg30 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct panel_desc tianma_tm070jvhg33 = {
@@ -4185,6 +4186,7 @@ static const struct panel_desc tianma_tm070jvhg33 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct display_timing tianma_tm070rvhg71_timing = {
-- 
2.43.0



