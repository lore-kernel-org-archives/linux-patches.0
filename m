Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BDA31F9BC;
	Mon, 13 Apr 2026 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099576; cv=none; b=ihfkdCLSqKa/pvE2YnjAVrFJwgmkX+BdkqgjVN+SP0Qo1GqlKj51PDMtVlSPN/EgA92ufG/0qG2stjJ6gHs/2E7o+qNxoa+X5nr5SikkKoDAqIwTXwYkzSiqzCOf2FFOlhTw8FQOr/v+uBg6nQxbnct3m0dGPjbGqnydBAiVk/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099576; c=relaxed/simple;
	bh=ZnIRNTrhp+lKHBIdGvIQHA3JYajQBaBNkSXqdBiOSKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4KSxfUVGnXx+ig+664s1gSpnnwwG3G4Fz18R69LqFcZ/Er5xw+10NlKLX91VK4pL8h5Wd+gHAQyyNaaJ0KKkal+bOUsUjl8lZMIk77MDgZNUauYXAby4cct2yEBQCBSG4SaX/1rNHSVHUWZ8BIWQ8v5ZakztdJ/hpi2z3dlTFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDvxh5LV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDvxh5LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27DDC2BCAF;
	Mon, 13 Apr 2026 16:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099576;
	bh=ZnIRNTrhp+lKHBIdGvIQHA3JYajQBaBNkSXqdBiOSKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDvxh5LVdTVaSI/j3j+9I5TPmYCwo9Ox385wX5EwCYg5ZoEpoLhtMWiCseLDRQIjp
	 h6Ua6uDo6XLiJ/p9gxibtSmJoiPGLyHlUSXDLYVNqS1h1A/7amDuVbwXbwN1J7T2Ab
	 dEKnWFZl/48cxaEjUbbr9py6OEMWuHQMyVj6B96E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/491] phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off
Date: Mon, 13 Apr 2026 18:00:39 +0200
Message-ID: <20260413155833.784846993@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 9ce71e85b29eb63e48e294479742e670513f03a0 upstream.

Assert PLL reset on PHY power off. This saves power.

[claudiu.beznea: fixed conflict in rcar_gen3_phy_usb2_power_off() by
 using spin_lock_irqsave()/spin_unlock_irqrestore() instead of
 scoped_guard()]

Fixes: f3b5a8d9b50d ("phy: rcar-gen3-usb2: Add R-Car Gen3 USB2 PHY driver")
Cc: stable@vger.kernel.org
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-5-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 558c07512c05b..9fcbde094699d 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -516,8 +516,15 @@ static int rcar_gen3_phy_usb2_power_off(struct phy *p)
 
 	spin_lock_irqsave(&channel->lock, flags);
 	rphy->powered = false;
-	spin_unlock_irqrestore(&channel->lock, flags);
 
+	if (rcar_gen3_are_all_rphys_power_off(channel)) {
+		u32 val = readl(channel->base + USB2_USBCTR);
+
+		val |= USB2_USBCTR_PLL_RST;
+		writel(val, channel->base + USB2_USBCTR);
+	}
+	spin_unlock_irqrestore(&channel->lock, flags);
+
 	if (channel->vbus)
 		ret = regulator_disable(channel->vbus);
 
-- 
2.53.0



