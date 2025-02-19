Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE11CBA18;
	Wed, 19 Feb 2025 09:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955864; cv=none; b=QS9DBdjTczRjCzLXpa/CVCXZ9CvlMbG1X5HBumxYaCqptXr11tqHub6xLhuSZMJvm+HR4x27cX7I88SxW0oKnjMU8dFyedo4hVLGqx/nffrPVwUbBlVLjj5m4Exam/M1nObkpP3aueqbpVd4TFBK+W5iPuzAiw6OsD86KHUrp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955864; c=relaxed/simple;
	bh=IsAat3KNe9y9hLn++qPlUL2jLEfVuwagSvNiqYOOvIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDxGiS+YhnGqGqBhs9bvmF/ukFzZjCIeBIgay0/Js+pznnxQnS301UnoLraR24066yx+l1D0vtKPf6WiZ4us8LU1pviv/Wcj+FOnI4O6Gem/27b6Itw6tGiJlRRAuCoK+qm80Rs3MhfHizqOSwYZn73c7dp1XyQOddEh6Neqki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOq4P6Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOq4P6Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905D2C4CED1;
	Wed, 19 Feb 2025 09:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955864;
	bh=IsAat3KNe9y9hLn++qPlUL2jLEfVuwagSvNiqYOOvIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOq4P6FqnmlYAxbl61LCO7uFXoVDS+sITyI9w4zByIejOLTsbJSPQQQ8wHSaDOZFM
	 vJcTdBa0nLdyzaQJjrSYANiB/db5uja6ll9g/C69XlZpTALnz+cjS7x4RIkPYDJkq9
	 6TgpiJDi0w/Nb7yfA/pFsZPSxSsvIuWhvcQX4qA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.6 131/152] drm/rcar-du: dsi: Fix PHY lock bit check
Date: Wed, 19 Feb 2025 09:29:04 +0100
Message-ID: <20250219082555.229884453@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


