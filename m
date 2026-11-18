Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032533;
	b=xDlqzCS6aN/81H37u6pKjCol8tTcKXu9ow3sTFTU+2wP8x0O/9r+iPJOfHOAd662iQqI
	 NPPM/WWPzBu82eBfKzjNq/P/JGvM/xWNrsQRYU260aO25Z34jA56A8VSxj6ss6s7NEpPG
	 Esyr/Xq1CpM8vZweh7QjH2Aj7NB+o38ifphFQ6CEGFz54SvHUXTslX9E7cgsMc0Jv13iw
	 OF1HW3tTLyS3repojJ4mB70lzlE7nRZeLd8TNKNCsSQPfc5/yLMK6znoV4OBY9vEkhncj
	 h4eh1HEmgh8dC181SRZa9TRqx1WUHAr41c2uvGUULAgjZ4MImBL/HNk3dlSIfGkNV+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rXwtQVtnEOs81MEiFJVQeWkzsABXl4TZnP67NUmdXKY=;
	b=pG8nb85ydirR89ipVVtVqMSDqdmbX21manfXLzpPbi9RSmtXIUObkgsAMbQjYxoDE7Em
	 Kmh8pzzEhbD7rOpnkhmPcXZJAnCGiFguJwZBEHHbbEWhtn2qDL50ArgqvEg/Re3JO0yvA
	 7qagkX3aXGn9lwO3HRK2IUR7kqva1SSQc6c0klvbMTlE284Gc7N08HzFKRPvS1xNGs5Wu
	 tDELrh3d29r1ChwudBNVv1dSzX5+Lgg8BDG+D/uIFC6VQR7dUHJnbHrGRD5D77D3TnuV5
	 idTQHbTqEH8YznTycdPuhnI6Jf0ana5juN7C5hy7w3Jq44+CFf9uyeSGrIDtyuxfktg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsZOI9zi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23553606A325;
	Wed, 18 Nov 2026 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsZOI9zi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755491F000C4;
	Wed, 18 Nov 2026 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032533;
	bh=rXwtQVtnEOs81MEiFJVQeWkzsABXl4TZnP67NUmdXKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsZOI9ziKrn3bY5vTdSlvnHwS+THOMR94EAp1GyH+qdc1VgzNAtutypxSwO2mZkOw
	 QYrPVrErD+ysS4sgVWkZ1yOyTOt4yekXeyPnSO35fXsePTAU14FRTizH7P0GKrmf6N
	 PocjBbWkE/0PhUAfwuEU8DsekUKhSBnu1qlfh/Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1444/1756] net: phy: realtek: disable PHY-mode EEE
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150106.614602426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit bfc17c1658353f22843c7c13e27c2d31950f1887 ]

Realtek RTL8211F has a "PHY-mode" EEE support which interferes with an
IEEE 802.3 compliant implementation. This mode defaults to enabled, and
results in the MAC receive path not seeing the link transition to LPI
state.

Fix this by disabling PHY-mode EEE.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/E1ttnHW-00785s-Uq@rmk-PC.armlinux.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 36406c0b4056d..33eb91dd34fbc 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -31,6 +31,9 @@
 
 #define RTL8211F_PHYCR1				0x18
 #define RTL8211F_PHYCR2				0x19
+#define RTL8211F_CLKOUT_EN			BIT(0)
+#define RTL8211F_PHYCR2_PHY_EEE_ENABLE		BIT(5)
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_LEDCR				0x10
@@ -53,8 +56,6 @@
 #define RTL8211E_TX_DELAY			BIT(12)
 #define RTL8211E_RX_DELAY			BIT(11)
 
-#define RTL8211F_CLKOUT_EN			BIT(0)
-
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_ISR_ANERR			BIT(15)
 #define RTL8201F_ISR_DUPLEX			BIT(13)
@@ -440,6 +441,12 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			str_enabled_disabled(val_rxdly));
 	}
 
+	/* Disable PHY-mode EEE so LPI is passed to the MAC */
+	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+			       RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
+	if (ret)
+		return ret;
+
 	if (priv->has_phycr2) {
 		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
 				       RTL8211F_CLKOUT_EN, priv->phycr2);
-- 
2.53.0



