Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00A733A02E;
	Mon, 18 Aug 2025 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525739; cv=none; b=l4zVwbEb/QUO5oTPRxbT3XXBn0wm8U8cSp23vxtz3deX8nhzy8EVvYa5l0AGBdK5ucz8bB3MOOQhUUHrzjBys7rSQAsFJtUZmr6FKURmZdP0iqCxF1Nx1GEvVkggO/sTr+w91GCbqkL6VI4UQ3yePeVdcTJh+kNrgdAPe/Mc36o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525739; c=relaxed/simple;
	bh=3KXjPZ0MZ+sfC6tmfPiKF1wk7D5sGkCTWnIHgoFTl1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLcftnEkVNuFWH9/7oS/oYo83hjTvRUx5beDpLdTvLpcKovOrlEV4nu7ADcMltpOZbd1yaoyi8vHwnth0RHvkCggVMiIOu4iolaybwiZhxDRHs36WyBaSMAhOmADH53d/iV7nIjZvSOd5dA8LFwIwcfTZGvbQuZy50tB4a0Sb18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEpMT+hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEpMT+hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1F9C4CEEB;
	Mon, 18 Aug 2025 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525738;
	bh=3KXjPZ0MZ+sfC6tmfPiKF1wk7D5sGkCTWnIHgoFTl1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEpMT+hI9osUMMXCebjE7p66Lp86PL2SA0tK2PJQRIDrfe5JcFQ4lO3T14Y1Wy5L0
	 8tkuufSlAu2urjNaFK7PFme1OULy37XLfPSmNnAk58aQEeNK6GxFoAbCfkg3j9bpPC
	 mzCgdCugVmsGewwJOXVwNzJOVxwRr7FXc7Fil0ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 353/570] net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325
Date: Mon, 18 Aug 2025 14:45:40 +0200
Message-ID: <20250818124519.459631832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 044d5ce2788b165798bfd173548e61bf7b6baf4d ]

BCM5325 doesn't implement B53_UC_FWD_EN, B53_MC_FWD_EN or B53_IPMC_FWD_EN.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-9-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 18 +++++++++++-------
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bb0a5fd6a372..d15d912690c4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -366,14 +366,18 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 		b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
 		mgmt |= B53_MII_DUMB_FWDG_EN;
 		b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
-	}
 
-	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
-	 * frames should be flooded or not.
-	 */
-	b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
-	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+		/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
+		 * frames should be flooded or not.
+		 */
+		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
+		mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
+		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+	} else {
+		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
+		mgmt |= B53_IP_MCAST_25;
+		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+	}
 }
 
 static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 25d25bd1071f..f2caf8fe5699 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -110,6 +110,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
+#define  B53_IP_MCAST_25		BIT(0)
 #define  B53_IPMC_FWD_EN		BIT(1)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
-- 
2.39.5



