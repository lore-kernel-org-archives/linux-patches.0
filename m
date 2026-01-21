Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34089352C46;
	Wed, 21 Jan 2026 18:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019765; cv=none; b=JLJu94kKp2ldxctdjZ6wxqcbUn709hsfbktkvtq6RRzD3zCCLOwJ/Zk+9CuVwkJhQ/FhJbARx+XXAc4XLObIkUqcWUYk+iDjyYnrpdEBHIOEyM1IgMb3p2AGS1OXNH0MTke4WHOAMfP6wPYUmL36rhYDkSviHejcvOnn91Bdurk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019765; c=relaxed/simple;
	bh=rDoMhFJqVxjIQlhIWsyOD9abqvHZUKuuGqwAdlEV9Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msxzWy9r08vIkJR6hymL6Eb/pwo9fNWgnB4+966edwlNDWcGrQgg1QzEcSqUy2kfnvzSgvFJRgAj3hMWYWSy2HPSoj91frYrcPTPnrmUZfzq0sG2Ix8cLpsXqZj7YBi3XGWglETBjHohMVlc3/7OvAdSJySi9ZCMe5AZxFk4A28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jvcee6ZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jvcee6ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9444EC4CEF1;
	Wed, 21 Jan 2026 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019765;
	bh=rDoMhFJqVxjIQlhIWsyOD9abqvHZUKuuGqwAdlEV9Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jvcee6ZIIIQVRm7gss+fRImgW+E4Mv/weenJBxBFUW4lWGUCRy0b9B81XkOUZk+8y
	 wea8jmTjBVg50BT4YqA/cn4oY6VAe11FDS62aXeLunSSmfm/K4fV9vXwAfV2BN1bYN
	 r99NG/SKXqEAz7B3TTwa8XjA16SeZyHuwvCiliRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 102/139] drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel
Date: Wed, 21 Jan 2026 19:15:50 +0100
Message-ID: <20260121181415.121411940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit 6ab3d4353bf75005eaa375677c9fed31148154d6 upstream.

The connector type for the DataImage SCF0700C48GGU18 panel is missing and
devm_drm_panel_bridge_add() requires connector type to be set. This leads
to a warning and a backtrace in the kernel log and panel does not work:
"
WARNING: CPU: 3 PID: 38 at drivers/gpu/drm/bridge/panel.c:379 devm_drm_of_get_bridge+0xac/0xb8
"
The warning is triggered by a check for valid connector type in
devm_drm_panel_bridge_add(). If there is no valid connector type
set for a panel, the warning is printed and panel is not added.
Fill in the missing connector type to fix the warning and make
the panel operational once again.

Cc: stable@vger.kernel.org
Fixes: 97ceb1fb08b6 ("drm/panel: simple: Add support for DataImage SCF0700C48GGU18")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260110152750.73848-1-marex@nabladev.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-simple.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1782,6 +1782,7 @@ static const struct panel_desc dataimage
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct display_timing dlc_dlc0700yzg_1_timing = {


