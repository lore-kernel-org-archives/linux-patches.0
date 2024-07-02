Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2DB1BE22A;
	Tue,  2 Jul 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940066; cv=none; b=QgPTx3kUe6k+604oXflPneCTF/D+e2xcs4gL4/DlaDHtgRjwYU0zFdC1j0sbxKs4lqEH7CzejXbW4az6KBkQZOC7BXvCFpt3fIA+pdqLhi7hAt1szcA9qN8hv+jOK4MXPpm5ekgmONCpzIuI9QDAGNamWS0J97+ICJ7yW+FWsnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940066; c=relaxed/simple;
	bh=WF8IOG8ZwW7onlW0mmxyl410i4XyKJGhSfncyZlyJKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9Rh3yIo3KrxuucSh/wLcXtCec87GcHls5uEm53w+bKrsCgSQORG2DA3qC52EzXcRfLjmklphOeFQl7Vr1+GmGXhtyQkqnOEOvedMBOJMOrpHkBfY+NlWum+cM8qkrp+kz7Ow6+0IPaDzKa+d0IqHCoXEtSrLt8ZKmdgZKzjuuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0teGZMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0teGZMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C222C4AF07;
	Tue,  2 Jul 2024 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940066;
	bh=WF8IOG8ZwW7onlW0mmxyl410i4XyKJGhSfncyZlyJKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0teGZMccXZQuff9JhuTPRiWWGje6MyABr58tolzjdrPIy+ZKOKEtRci9sHkIb4Nr
	 GvPQrIcDR6f5rB2YBh723KTbt3cETlqhpGz/aHJ3djfPhTSQ+pvZrj3bMxsobctAGl
	 TQN65JcbJwnNA8RMmpLe7XHAzIKHSqXWAW6DZfBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Woojung Huh <Woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 041/222] net: dsa: microchip: use collision based back pressure mode
Date: Tue,  2 Jul 2024 19:01:19 +0200
Message-ID: <20240702170245.545649349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

[ Upstream commit d963c95bc9840d070a788c35e41b715a648717f7 ]

Errata DS80000758 states that carrier sense back pressure mode can cause
link down issues in 100BASE-TX half duplex mode. The datasheet also
recommends to always use the collision based back pressure mode.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Woojung Huh <Woojung.huh@microchip.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c     | 4 ++++
 drivers/net/dsa/microchip/ksz9477_reg.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 05767d3025f77..dde5c65c2c366 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1303,6 +1303,10 @@ int ksz9477_setup(struct dsa_switch *ds)
 	/* Enable REG_SW_MTU__2 reg by setting SW_JUMBO_PACKET */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_JUMBO_PACKET, true);
 
+	/* Use collision based back pressure mode. */
+	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_BACK_PRESSURE,
+		SW_BACK_PRESSURE_COLLISION);
+
 	/* Now we can configure default MTU value */
 	ret = regmap_update_bits(ksz_regmap_16(dev), REG_SW_MTU__2, REG_SW_MTU_MASK,
 				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index f3a205ee483f2..fb124be8edd30 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -247,6 +247,7 @@
 #define REG_SW_MAC_CTRL_1		0x0331
 
 #define SW_BACK_PRESSURE		BIT(5)
+#define SW_BACK_PRESSURE_COLLISION	0
 #define FAIR_FLOW_CTRL			BIT(4)
 #define NO_EXC_COLLISION_DROP		BIT(3)
 #define SW_JUMBO_PACKET			BIT(2)
-- 
2.43.0



