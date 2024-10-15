Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F033D1E6DEE;
	Tue, 15 Oct 2024 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992348; cv=none; b=rQj3il1ZS3ZGfYRWRctIzktksO7Rs91xbBWFIQ5PYYbx7kBhwX9J4/sqTFIlCdaJ0LYU5AT0Q4YMUQiVy/NYeeK+VxQfuxcABem4+AOT6V1UGc9Y2JRnqaMtFrEHewf0HUNHmrHd47qGVhfB91rEaWJBDgGnWDqyuvuCBGcHYnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992348; c=relaxed/simple;
	bh=FbU08X9K0djtWfu86ELpWjQ20gZffCnkdFNdLsFz88E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlF9wcNmfUFEmCI53FGlXisMntHc9U3rvh2Cs2SveK+gPP3kPlpMu9qs36Y2tOhM0d2K3NRlboQfo1Rh0z52SxBC84iISTKtfDABmB4sGHBuVliJqxBUYIcGde7oHUOjvHdCqRUVZPCpmBGSMaJvf2QcSmJQDDG3q5yiXhHCPec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jW/XeANv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jW/XeANv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616CBC4CECE;
	Tue, 15 Oct 2024 11:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992347;
	bh=FbU08X9K0djtWfu86ELpWjQ20gZffCnkdFNdLsFz88E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jW/XeANvwT6ZPLULMMHp7Oob5x4kNBGqd4PPmZsbQ8qvKVv+pRhG9FNT6ZZQtGAwg
	 SaIGCx9Z/RSBUS+uKGDVP0oo4vErBgqHgw7caQPQuWEiShYLSeZDRMBuy24vMfMa+3
	 Ic8WXiGi63j8iWddnXuBP5tK73NEMC2RKsdmSaCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Borislav Petkov <bp@suse.de>,
	Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/691] EDAC/synopsys: Use the correct register to disable the error interrupt on v3 hw
Date: Tue, 15 Oct 2024 13:20:39 +0200
Message-ID: <20241015112443.976159900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit be76ceaf03bc04e74be5e28f608316b73c2b04ad ]

v3.x Synopsys EDAC DDR doesn't have the QOS Interrupt register. Use the
ECC Clear Register to disable the error interrupts instead.

Fixes: f7824ded4149 ("EDAC/synopsys: Add support for version 3 of the Synopsys EDAC DDR")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427015137.8406-2-sherry.sun@nxp.com
Stable-dep-of: 35e6dbfe1846 ("EDAC/synopsys: Fix error injection on Zynq UltraScale+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 40b1abeca8562..88a481043d4c3 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -865,8 +865,11 @@ static void enable_intr(struct synps_edac_priv *priv)
 static void disable_intr(struct synps_edac_priv *priv)
 {
 	/* Disable UE/CE Interrupts */
-	writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-			priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(0x0, priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
 }
 
 static int setup_irq(struct mem_ctl_info *mci,
-- 
2.43.0



