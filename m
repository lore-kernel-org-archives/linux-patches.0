Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716FF280CFB;
	Mon, 13 Apr 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098398; cv=none; b=SLpx4YZaQRhOV8MB4cbiwwWYWN74O9OwJZvaNXSYfVwV/je+KDVQZK5NMYwwbuxEcmVU3k9+Gdc8E3dZ2FgeUJTZds8YmfbGVr5DT/vR5qiO3mLNNoJkTGekDmFVHDCnCX2f57Dbj10YwNw9MUNAKVUNR4G6wPzVZM9n3fmfQXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098398; c=relaxed/simple;
	bh=uogVi+hf+K1zkBMNkQXPe6iAgIESmQfWDpo16966Rkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HadpRWaHrEfLo0PrPFeceuCLFNZa2LMbfUpXAynZvPONLotnr6R7Aufhn8DwYuXPSdvZKPDAvegioypKme7yBzKwIaWgbP2yiDX60yU/Wibqc6ybIoBPikU0jokpXf2tuye+MJMH/sueadUQReECCHPLRPJ3AwFPpTQN79NKC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nT4G1Xv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nT4G1Xv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07364C2BCAF;
	Mon, 13 Apr 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098398;
	bh=uogVi+hf+K1zkBMNkQXPe6iAgIESmQfWDpo16966Rkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nT4G1Xv6TanO+p6olRCVByEzrtGHgYSdlEiHDg2Z0I0qRItfv7YKKSxD184oklkul
	 et8OhwRhEuLgvIQ5Gui7P1aem331nBzQweio4A+fv/tUdreeQK31VfHFui6eB9/cN8
	 QWbyq8Yemn5oQwLuiBZnlIAQQ/2glPpJQBQiruMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/570] phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off
Date: Mon, 13 Apr 2026 18:00:08 +0200
Message-ID: <20260413155848.330586030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 0626e00ccea7e..7e25c0e053a44 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -540,6 +540,13 @@ static int rcar_gen3_phy_usb2_power_off(struct phy *p)
 
 	spin_lock_irqsave(&channel->lock, flags);
 	rphy->powered = false;
+
+	if (rcar_gen3_are_all_rphys_power_off(channel)) {
+		u32 val = readl(channel->base + USB2_USBCTR);
+
+		val |= USB2_USBCTR_PLL_RST;
+		writel(val, channel->base + USB2_USBCTR);
+	}
 	spin_unlock_irqrestore(&channel->lock, flags);
 
 	if (channel->vbus)
-- 
2.53.0



