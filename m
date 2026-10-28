Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213739;
	b=TLOXMy423X3LTTQoQLxWgaVzkqYjaK1pNXxqAQvY0JV3EvFHyg7qtlLVSHYjtuH8+g1t
	 VI+ZjfOeuMYmSQEOXZjgeQ2Z/9DkUdf0Dae6x5jkxF3Go2LQpScZuoHtBksKqpQEmvCBk
	 bXP4WemLs7kFfP11z/bLxISfwdYSt6k7BHqXW1Hn9bntu0QDZUGa83I0BfX6GH1UyM0y6
	 z6zPa5V0uRHu5DhwFpwtTbPE4MrvY4Cn/14FjEBRD0uI9kOcE7vk2qaBjnDcrA+/aylca
	 uPz7VCvfSUk+yYU3bpDdVfqlVNlvpCVabMLhSx3brAhSvuMtoUz/+z1RLVOJM/uMOjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i07dAP0YzpT27C8YK7Egf1YW7NlA705O6w0HsaQgGFs=;
	b=X/xMdnsHaOudF/cGdRMKzNUOw+hodle9Gtko2chEdgZJDpnb7SjhB/LsFKjMeWSPkvrt
	 GL+U/xwFewRCDCLbeQb2DQaD9LiLzYI9N70wMIK2KHRxOMEPcAI5c6HjyHzivXTemH9BG
	 1tPkxWxx/Bid+54x1qdmZEl5zfYho922lCFX/Eb7FLts973l+NWigoJzS1sLzJ8gIQf+z
	 On7+gfLTVcAlNyAy1P3k1ypIuozcYTCVoV5R5JMkZTrQAGKHJGfuBeZesPQPwKC+wBjPi
	 VnZ09VmgEae1MhGt37b8XXR+xqbUlwdmZtUhwWcqbH7FfA9A0J2quWQOO99B4XMrN1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8xQBs1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55222606A31A;
	Wed, 28 Oct 2026 18:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8xQBs1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A976A1F01825;
	Wed, 28 Oct 2026 18:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213739;
	bh=i07dAP0YzpT27C8YK7Egf1YW7NlA705O6w0HsaQgGFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8xQBs1gs9f7e3B2NPSyfik0FlZtFg+AmU6zmoqXhqFqcol/tekq8g7k2JlkJ24Mt
	 Kbf72iT5F/wX6kU6s3dd/JiwcwbFF3azGTsyOxBx951hfQvQHGUm5BR/6JHHl9yoAA
	 zgabxE99zt+nxbDtCGgXJ1oYwg4yEi0O2ZNrUbuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Werner <andre.werner@systec-electronic.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0611/1887] net: phy: phy_device: Prevent nullptr exceptions on ISR
Date: Wed, 28 Oct 2026 17:45:07 +0100
Message-ID: <20261028170513.316277716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Werner <andre.werner@systec-electronic.com>

[ Upstream commit 61c81872815f46006982bb80460c0c80a949b35b ]

If phydev->irq is set unconditionally, check
for valid interrupt handler or fall back to polling mode to prevent
nullptr exceptions in interrupt service routine.

Signed-off-by: Andre Werner <andre.werner@systec-electronic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240129135734.18975-2-andre.werner@systec-electronic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9b0c88c19795e..96dcd1d70bf4a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1404,6 +1404,11 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+static bool phy_drv_supports_irq(struct phy_driver *phydrv)
+{
+	return phydrv->config_intr && phydrv->handle_interrupt;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1513,6 +1518,9 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->interrupts = PHY_INTERRUPT_DISABLED;
 
+	if (!phy_drv_supports_irq(phydev->drv) && phy_interrupt_is_valid(phydev))
+		phydev->irq = PHY_POLL;
+
 	/* Port is set to PORT_TP by default and the actual PHY driver will set
 	 * it to different value depending on the PHY configuration. If we have
 	 * the generic PHY driver we can't figure it out, thus set the old
@@ -2951,11 +2959,6 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 }
 EXPORT_SYMBOL(phy_get_internal_delay);
 
-static bool phy_drv_supports_irq(struct phy_driver *phydrv)
-{
-	return phydrv->config_intr && phydrv->handle_interrupt;
-}
-
 /**
  * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
  * @fwnode: pointer to the mdio_device's fwnode
-- 
2.53.0



