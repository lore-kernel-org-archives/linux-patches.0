Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EEC19EEBD;
	Mon,  2 Jun 2025 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874615; cv=none; b=K7YZSw+0Q2TNqcXtTeMpcE4ZF/Dx0DuUwhVGrtKqjcFpxjJbi+4L/iTFaUWtohNYFlmaOrjulUYbdshb9AOm+/CWe3oS6e+/qPkF3jwOTeS8wx/x5K+S5VxjSopQW3hZktNDIxve5/BJTB2pAS0RaJ/vr8jr8EQyWlMDBn7W/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874615; c=relaxed/simple;
	bh=l3mE1+yw0C/d61Ty9HmDqaitD78yHPdK7dN+6BCcpQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqLDQXO66I/03sFAGgp2JOmORZ6xmnmGWDnr9Y5WtT2b9cI/SrXLcX1XsV2Udn2Y1Yi25qv5GotlB/TA09OAwE1MojyBdlP/987KJwamDUudVgCJ+z9QG9HYO6eDX8gLtOuWqVE5q1E+VWDEty2HdXP9gvQyG+OBgJ0KFhzKGXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIUzUo6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIUzUo6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92CEC4CEEE;
	Mon,  2 Jun 2025 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874615;
	bh=l3mE1+yw0C/d61Ty9HmDqaitD78yHPdK7dN+6BCcpQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIUzUo6Oo0d3zrKYFV9VZTgURh0QDgDiqHX1EurjnXt5KiDlspM5cLd3oh60AQsl1
	 0AGJJJwmm56hxqEnrrGijuLIX82iPWGl80iAfzpaWrCBX47xpJvbXuUIczxzGe4d18
	 r3K1mVNkAa/v+vKrZmlM85GUzXLbtnToMTfcAmFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 081/204] phy: renesas: rcar-gen3-usb2: Set timing registers only once
Date: Mon,  2 Jun 2025 15:46:54 +0200
Message-ID: <20250602134258.855176899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 86e70849f4b2b4597ac9f7c7931f2a363774be25 upstream.

phy-rcar-gen3-usb2 driver exports 4 PHYs. The timing registers are common
to all PHYs. There is no need to set them every time a PHY is initialized.
Set timing register only when the 1st PHY is initialized.

Fixes: f3b5a8d9b50d ("phy: rcar-gen3-usb2: Add R-Car Gen3 USB2 PHY driver")
Cc: stable@vger.kernel.org
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-6-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -427,8 +427,11 @@ static int rcar_gen3_phy_usb2_init(struc
 	val = readl(usb2_base + USB2_INT_ENABLE);
 	val |= USB2_INT_ENABLE_UCOM_INTEN | rphy->int_enable_bits;
 	writel(val, usb2_base + USB2_INT_ENABLE);
-	writel(USB2_SPD_RSM_TIMSET_INIT, usb2_base + USB2_SPD_RSM_TIMSET);
-	writel(USB2_OC_TIMSET_INIT, usb2_base + USB2_OC_TIMSET);
+
+	if (!rcar_gen3_is_any_rphy_initialized(channel)) {
+		writel(USB2_SPD_RSM_TIMSET_INIT, usb2_base + USB2_SPD_RSM_TIMSET);
+		writel(USB2_OC_TIMSET_INIT, usb2_base + USB2_OC_TIMSET);
+	}
 
 	/* Initialize otg part */
 	if (channel->is_otg_channel) {


