Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6445E223323;
	Wed,  4 Feb 2026 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216829; cv=none; b=OX/vQEZaVBuDD3DvWwo/1FOit2HdCcl+qDtknzBbS3aQWjbbZWGxllwzrR6hKBqTPTbHpC92bya/91r5o4AKyRQqmZcOyJbSlpCRDhEZWUnfzAIgufneRPTlG0lVB5XgNovN2cH+Halji9gFY4WXa+s8oP8qc9i0m6TV1BccTsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216829; c=relaxed/simple;
	bh=TJmX4XwAEixdkezmbL+7qgnUm1CuncVC7gGHna2H12E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btqDUr8rByyh9zQs11dMRHA+iy+u8Tp71WY8oSynnv5ayrQPpJqkrylsXLIyUXETfQ62EICiTK6v22jfPLSIXlVGd+beV2WzJO37etbBrdTIlXnwaQYbL10Vu14dwFl80Nzl4/zQ6JCkdulOwZDIIxthY0ps5rfEx6ArOWYF/u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Btm/d5GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Btm/d5GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD9C4CEF7;
	Wed,  4 Feb 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216829;
	bh=TJmX4XwAEixdkezmbL+7qgnUm1CuncVC7gGHna2H12E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Btm/d5GE1rD89Qp0HRgSuXWmYVvQ19N1uobWxHVfIpVFDglZywUX3/lySIr4huFs+
	 rZdP6EaoWoiAbiCTjp4tAF4ZrtFqYHELlBldGH4TpBHbk0YwgiRC/Ub3LcsR9/yIAM
	 abzWcuYvKTcY3f3tyJ0DHooIFQNxzNoBieXnthd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 043/206] drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel
Date: Wed,  4 Feb 2026 15:37:54 +0100
Message-ID: <20260204143859.763120328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1921,6 +1921,7 @@ static const struct panel_desc dataimage
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct display_timing dlc_dlc0700yzg_1_timing = {


