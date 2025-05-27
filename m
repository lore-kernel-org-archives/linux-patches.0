Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2A17B425;
	Tue, 27 May 2025 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366283; cv=none; b=DQuzZHd1jFUbQOals2EzX0Xt26PlYQTfOLlgKtQd1mihNGoYvTJ8UH7CtdG8LOPqe6u8jJn+X50rZlkWmN6O3Ca+nos70xtloxyJJhMPtLjbOnSshDEUXiI2QgSvE7nSiNGSLhr5WrgsEPEYQwEVpgRYxYPbFg997kYB0nuOSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366283; c=relaxed/simple;
	bh=6CfkX03Wmvy5GzRfZxD6Ac408bKvYHgqUAV60R5EeXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2nsWNHR+kaU+2PjoLQE1DXk9SAzhGWYV78USsoInghWiYDk2ekYei5iR1ki6oRHgtpESzDp01MHMtZD3oajXlV/TeFnY9Q79fyVez/qc3vgPmaJ0/Om4lkj5UMK6nR/QdUvS8t7QZy4HveLPXe398ZaDmqM5bXj/LFtgYfuNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9+J+yuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9+J+yuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962A5C4CEE9;
	Tue, 27 May 2025 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366283;
	bh=6CfkX03Wmvy5GzRfZxD6Ac408bKvYHgqUAV60R5EeXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9+J+yuRdckdgKTaWBz2of6J6osACCEJnPOc9E/uvMkbfmdzP4bAi5awpEYbcfJ7d
	 sAPIJrfsS0As6i6kzBRGN+CGpx9qZLyQtO3TzzVqGWXBkFFZP/btmBLRZ0nqMsxSoC
	 SsgP7L2qv3V/yAhAUidirnnllVBsD34yec+/F0e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 006/783] phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off
Date: Tue, 27 May 2025 18:16:43 +0200
Message-ID: <20250527162513.307420661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 9ce71e85b29eb63e48e294479742e670513f03a0 ]

Assert PLL reset on PHY power off. This saves power.

Fixes: f3b5a8d9b50d ("phy: rcar-gen3-usb2: Add R-Car Gen3 USB2 PHY driver")
Cc: stable@vger.kernel.org
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-5-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 7d18bc549f17e..9fdf17e0848a2 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -540,9 +540,17 @@ static int rcar_gen3_phy_usb2_power_off(struct phy *p)
 	struct rcar_gen3_chan *channel = rphy->ch;
 	int ret = 0;
 
-	scoped_guard(spinlock_irqsave, &channel->lock)
+	scoped_guard(spinlock_irqsave, &channel->lock) {
 		rphy->powered = false;
 
+		if (rcar_gen3_are_all_rphys_power_off(channel)) {
+			u32 val = readl(channel->base + USB2_USBCTR);
+
+			val |= USB2_USBCTR_PLL_RST;
+			writel(val, channel->base + USB2_USBCTR);
+		}
+	}
+
 	if (channel->vbus)
 		ret = regulator_disable(channel->vbus);
 
-- 
2.39.5



