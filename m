Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9826C14A4DB;
	Tue, 26 Aug 2025 12:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213082; cv=none; b=Fqqd5ev+rln5TOqJ/Vp4rSl0RZsN+bq3Nhb4ydel3JuOOqc+LFEJMvGXWHj5WZsf6wzXyZvtuN9Sn282X7WBQYXi8JSh4l2zz0B4hnRRtt4UlJG7XipzOItDev8lP3mXbZddbeBfSLcAL3nUyiyn8bT8PrzorW7eLRCRuFvuEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213082; c=relaxed/simple;
	bh=6r8QW3x51xuBI/JI5DLrFoi0AvRC6UKosWKvl5jQSfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcscHhF1hOktgPZGumR23nDWuhT56G/3lTMHa6qaygCEUzF21OfCgXo86x09bn0P+mnfVnYYRGZBYnQ+MHLEwg6jkNWaqZY+HWdQUOQ1Fprh0BIjTGMcE2yffnK7Qr5uD/hPMP9BH2OQlJSMEUYK7p/v6+PzNzDGWLgTBBaUrGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heI1baF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heI1baF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3547C4CEF1;
	Tue, 26 Aug 2025 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213082;
	bh=6r8QW3x51xuBI/JI5DLrFoi0AvRC6UKosWKvl5jQSfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heI1baF2Ekk+OaTU2K6RBsT4KsWE8ntIV30/RGCk4jaz6ajmk8wETJjhShx1GdeUT
	 2n/VEwoG2Pernq0hXJHE1efepthQF5vEa49mO4UHXVaWurozIRjdUq9KogpCk1Xx3H
	 vIUgx4Q7vWMFOj15OB330Kl0bzO4D1CRHgUQqzB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/587] net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325
Date: Tue, 26 Aug 2025 13:06:03 +0200
Message-ID: <20250826110958.381052180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6378e3f0f1fe..b00bac468677 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -344,14 +344,18 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
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
index 390290ddb1ea..3179fe58de6b 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -104,6 +104,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
+#define  B53_IP_MCAST_25		BIT(0)
 #define  B53_IPMC_FWD_EN		BIT(1)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
-- 
2.39.5



