Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC003A9DAD;
	Wed, 21 Jan 2026 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020432; cv=none; b=VYrGhWJpJ5fcJpmiOcOe7ozyTxK69XhsGW1tRnZK91P27Cz+P0PxAgE9jRwZ4KqOznULXZs5T3v8QhYNBffE3mI6o73wlWVWiwdEycss8B25cOXtC4brWP+Rn/z4d/SpM0FvPBXa/BcJYA72TvC1VnV5JucWB8OiAwqJzpFIfM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020432; c=relaxed/simple;
	bh=R/Ry9LnNdSqm9DLwgcNcMLwHkPB+3fOwUWBxILxr5TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbMUzvwAXZ+W9qU3yXVEBMo3+Sgw/27p4OVp89Nw5Q3r5ikkOjZx1OySB/q99JlX2RAe2coREtOc6OoG5C2P1ir5SlXgntfkA9/iqIxNWEum7MiXgR66gQM2xyc/MWQ/c/q8DRKU3li7EX3hq9i4YAj9ro87iA9ept5Jm4tPPgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkk1y3U0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkk1y3U0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DECC4CEF1;
	Wed, 21 Jan 2026 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020432;
	bh=R/Ry9LnNdSqm9DLwgcNcMLwHkPB+3fOwUWBxILxr5TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkk1y3U0Ok5YtE9u0MBXLXLlgVZJs2nQg3z0jq/50+lAhNP5TE4tsMRcc2Gj30s5p
	 /xUrBnSgHLiCj8V2zgGj/zE3z9oi0oydsqchKSqpLpe2SvJsE9rSzL8TpAlOZE9AjZ
	 4qZBrA7bs1s9YhPHBbIWs6S0m4fw62KlHMrkeiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 156/198] drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel
Date: Wed, 21 Jan 2026 19:16:24 +0100
Message-ID: <20260121181424.167588198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
@@ -1900,6 +1900,7 @@ static const struct panel_desc dataimage
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct display_timing dlc_dlc0700yzg_1_timing = {


