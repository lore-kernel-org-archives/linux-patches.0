Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B415336EE7;
	Fri, 17 Oct 2025 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715361; cv=none; b=XfZR4I+y3IEmRTbZQc/dFS1+Raquhdyk1VJyR+PmO8P1QdCCQYuxiH+e+2My153Rdf4NKPFFBAOlPUIX/fp9TlHh3QiTJKghZ1o+12CZkW1WEc/jXR4WJtpK/wXvCJjhFUTtWp3qHVfTiPW1ZeGsbDLSzsQAbdDdGfDwLU5dAl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715361; c=relaxed/simple;
	bh=6KxM+rrZADtaDKG6AXfMt7JpQGEzUJxR0sZfli734Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkEGyy0Dg3kfBNlt0y2Ma+kWcfRNuf3YNQFhDPHsP8cJGMlZd0xSx5zG4V3CmUyw4yESb4Tb4wDL8twsaPN07wLi3h0ADTTF/0AM1DvWaqavOffyvH6u1xJ7FlCUryxYJ9JoJQ7wyLyk4mkWwpEQlHE0e6089feMpVqhXMC+m1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLphSnr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLphSnr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6446C4CEFE;
	Fri, 17 Oct 2025 15:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715361;
	bh=6KxM+rrZADtaDKG6AXfMt7JpQGEzUJxR0sZfli734Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLphSnr3zBRsZsnhOeMcDOqqCpcu0iWNKkgHy3cZ2pXSPbjl/beFaGnH/q4Q0MHv6
	 jkBccD5ci3JaWack4OmVPPYoTZocA/dD2FTBiGo9DETiGY371C2mewQwHvdBkqZpU2
	 iwbsipOxmYHJjGlfj3vkc2fSEU7NK4Zbjh6A9EFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.17 189/371] drm/rcar-du: dsi: Fix 1/2/3 lane support
Date: Fri, 17 Oct 2025 16:52:44 +0200
Message-ID: <20251017145208.761207823@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit d83f1d19c898ac1b54ae64d1c950f5beff801982 upstream.

Remove fixed PPI lane count setup. The R-Car DSI host is capable
of operating in 1..4 DSI lane mode. Remove the hard-coded 4-lane
configuration from PPI register settings and instead configure
the PPI lane count according to lane count information already
obtained by this driver instance.

Configure TXSETR register to match PPI lane count. The R-Car V4H
Reference Manual R19UH0186EJ0121 Rev.1.21 section 67.2.2.3 Tx Set
Register (TXSETR), field LANECNT description indicates that the
TXSETR register LANECNT bitfield lane count must be configured
such, that it matches lane count configuration in PPISETR register
DLEN bitfield. Make sure the LANECNT and DLEN bitfields are
configured to match.

Fixes: 155358310f01 ("drm: rcar-du: Add R-Car DSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/20250813210840.97621-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c      |    5 ++++-
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h |    8 ++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c
@@ -576,7 +576,10 @@ static int rcar_mipi_dsi_startup(struct
 	udelay(10);
 	rcar_mipi_dsi_clr(dsi, CLOCKSET1, CLOCKSET1_UPDATEPLL);
 
-	ppisetr = PPISETR_DLEN_3 | PPISETR_CLEN;
+	rcar_mipi_dsi_clr(dsi, TXSETR, TXSETR_LANECNT_MASK);
+	rcar_mipi_dsi_set(dsi, TXSETR, dsi->lanes - 1);
+
+	ppisetr = ((BIT(dsi->lanes) - 1) & PPISETR_DLEN_MASK) | PPISETR_CLEN;
 	rcar_mipi_dsi_write(dsi, PPISETR, ppisetr);
 
 	rcar_mipi_dsi_set(dsi, PHYSETUP, PHYSETUP_SHUTDOWNZ);
--- a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
@@ -12,6 +12,9 @@
 #define LINKSR_LPBUSY			(1 << 1)
 #define LINKSR_HSBUSY			(1 << 0)
 
+#define TXSETR				0x100
+#define TXSETR_LANECNT_MASK		(0x3 << 0)
+
 /*
  * Video Mode Register
  */
@@ -80,10 +83,7 @@
  * PHY-Protocol Interface (PPI) Registers
  */
 #define PPISETR				0x700
-#define PPISETR_DLEN_0			(0x1 << 0)
-#define PPISETR_DLEN_1			(0x3 << 0)
-#define PPISETR_DLEN_2			(0x7 << 0)
-#define PPISETR_DLEN_3			(0xf << 0)
+#define PPISETR_DLEN_MASK		(0xf << 0)
 #define PPISETR_CLEN			(1 << 8)
 
 #define PPICLCR				0x710


