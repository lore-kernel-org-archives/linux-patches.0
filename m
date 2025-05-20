Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B3245007;
	Tue, 20 May 2025 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749238; cv=none; b=GDHE1EaD1rrRDfuFg7E33A676jxRP7p50FgJNe5XCrEY9oNBLDaFGrV8H2yzKdoP5SLCP/c94vL2d3gJGko8oneKOzlo0D8YtkhaLLRo/zttWLaiyPxMtwL+M2xLY2dlP5uzd3hPpAH3Ab566pfmiavRduttqJn517o1zzB7+Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749238; c=relaxed/simple;
	bh=AWzLEwor9bhVdzlXCSYTY4qeyBvnsg97jPm73duf5Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtK7iIhnjwWBuMPGaW/ImKaxA4AkJ5K8fO/z43YhpWI4sDwsKHSr7YRh/yimcrIUtO+xGcVV1IOHY+c21EgBga71HJag9tXGwCO839rgchYP6SBD4NirhIGTEXPgWXfUcU+OAJLaeGJ4JvYlTERxed/IRgIL4S90/78BWpSA3tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1ToOxNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1ToOxNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9290C4CEE9;
	Tue, 20 May 2025 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749238;
	bh=AWzLEwor9bhVdzlXCSYTY4qeyBvnsg97jPm73duf5Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1ToOxNkNYfCLrjMKodS1+yppzgzFc7qZ5KJUZg2v4p3giP/Qt8g+oEjLx9s7HwFP
	 lKFhWjt9uec4DzBQ74NRAb9wm1bIhUS5ou9/7gi0o13HyuYPl7Bw51ifcA9S0mbUqb
	 XZmhgdv4F+wyQCd6NRhkx71au92xs7DQiJsW9h+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 40/59] phy: renesas: rcar-gen3-usb2: Set timing registers only once
Date: Tue, 20 May 2025 15:50:31 +0200
Message-ID: <20250520125755.442800703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -453,8 +453,11 @@ static int rcar_gen3_phy_usb2_init(struc
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


