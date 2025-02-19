Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216BE1E0E16;
	Wed, 19 Feb 2025 08:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954605; cv=none; b=dWQYSSV9903JQtav4eGwzWVYTlp4BRbkYVDKmFPzN7oo/TK5XWvIvjfM7QSPOiacncIbUL6cX7Hurw3cPfnCLEUaWR74e72rtEpRqAOXIhRKvYOQgYMZno4J1XFgP2QRlfAUZ9ebnIUqCdfLtRNotYeftqR8CVxw8YXeK4sumok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954605; c=relaxed/simple;
	bh=CiXEfw5HYlHHz2jWIklL1KsIOQ7CaxdlXrkIJVKgHHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as3Qk3T18XoSRjWpBM0Ty28fiomoNWmQiE9Ve8SUecYILwRd8cX0H/gz+VUS/i1NqKYi/nvGqCqaq8/wxrchp11XpjNJDFlJOoV3bw4LGmJKcx68CX7g1LdAdI8WhlujqOYFJO2wnfvuy5xypyud6npD3ZxMcy6xBIfvCvialaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVk/qvKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVk/qvKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9D3C4CED1;
	Wed, 19 Feb 2025 08:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954604;
	bh=CiXEfw5HYlHHz2jWIklL1KsIOQ7CaxdlXrkIJVKgHHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVk/qvKeePya/Tn7w1UJFw9iTq0WLgpm1hRHR77ug6tht0Y3cMi9ACbVLW8/f3NCG
	 tTuo0162gOUcQEJceqKdwcLRWfJMw9y/5F5LJRuKll+VnovheD8APD475X/cabf+B2
	 CP2onlEH/2iKwSwvjCpWjdaw0rSZnQcEEb+N43ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.13 256/274] drm/rcar-du: dsi: Fix PHY lock bit check
Date: Wed, 19 Feb 2025 09:28:30 +0100
Message-ID: <20250219082619.601125274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit 6389e616fae8a101ce00068f7690461ab57b29d8 upstream.

The driver checks for bit 16 (using CLOCKSET1_LOCK define) in CLOCKSET1
register when waiting for the PPI clock. However, the right bit to check
is bit 17 (CLOCKSET1_LOCK_PHY define). Not only that, but there's
nothing in the documents for bit 16 for V3U nor V4H.

So, fix the check to use bit 17, and drop the define for bit 16.

Fixes: 155358310f01 ("drm: rcar-du: Add R-Car DSI driver")
Fixes: 11696c5e8924 ("drm: Place Renesas drivers in a separate dir")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241217-rcar-gh-dsi-v5-1-e77421093c05@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c      |    2 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c
@@ -587,7 +587,7 @@ static int rcar_mipi_dsi_startup(struct
 	for (timeout = 10; timeout > 0; --timeout) {
 		if ((rcar_mipi_dsi_read(dsi, PPICLSR) & PPICLSR_STPST) &&
 		    (rcar_mipi_dsi_read(dsi, PPIDLSR) & PPIDLSR_STPST) &&
-		    (rcar_mipi_dsi_read(dsi, CLOCKSET1) & CLOCKSET1_LOCK))
+		    (rcar_mipi_dsi_read(dsi, CLOCKSET1) & CLOCKSET1_LOCK_PHY))
 			break;
 
 		usleep_range(1000, 2000);
--- a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
@@ -142,7 +142,6 @@
 
 #define CLOCKSET1			0x101c
 #define CLOCKSET1_LOCK_PHY		(1 << 17)
-#define CLOCKSET1_LOCK			(1 << 16)
 #define CLOCKSET1_CLKSEL		(1 << 8)
 #define CLOCKSET1_CLKINSEL_EXTAL	(0 << 2)
 #define CLOCKSET1_CLKINSEL_DIG		(1 << 2)


