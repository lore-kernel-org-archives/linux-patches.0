Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028807;
	b=EOGZuTwZBoiepsyvmdVObNS0J6JUZdy1r74kXufKNkUZud8PG//9jwqB4lLxxPIfmp0p
	 gXzfpynwOf2D50TnOiC3Iyl7nd0GEuMWKWaUMTrtSgJah/9d9x3ck/BqRxvBz+X+3TsRC
	 6kGOsNYaVz8YUZ8cced4J1AQiaFsAN0MuBBS49sNGTbcTGcwLFj1rfKH+GJ0Mm1Dk2vg2
	 544Am+GB1bYz9bNu3TpDR9QmbtenRE5ywN555vHmP2Dj1XODg79bSO30ugvRfmjXyuJNF
	 jdvD8GkbdIIJyJkjSivH7u/OAx+cXk3CKi/bbCFz5Y3OemnZE5+to9mGxWEyZ++vffA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEL6Usi4gC1wiXJWkLhVjfp3gXgl362mi9HtAplWy8g=;
	b=favB+G66Qr3J5/J9bhWY2Edhu02Q0o5F6LH++7oFIhSXNXE3YGWzjEbkATthVcMIgsgg
	 mBXzzI8QbDNNvGskmA7aDXUZmvSpXFgLwHqFKuZggV99edUZ0buV/SP6VD8FA+g/oxwGP
	 Io1E4TTyFsNSBmFnjYJ4rbanazWsRmIqIzb8G7ajmV260mBbIYkMnaqJvsc0ROcDCOdMy
	 jp/jrU1q4VJTPWf/2QbPdnYJMv3QehJMjNllZq1FnNC7O7F82gBrW0fMZAr5LjZd1IyuR
	 rtyUoNlW5VNoZV0luq0SeWcgh23S9QE2W/5cAqjYnXyll9/BJBqbSEmntWfpoiVI0BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1vpTUtD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722B2606A339;
	Wed, 18 Nov 2026 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1vpTUtD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C741F000C4;
	Wed, 18 Nov 2026 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028807;
	bh=qEL6Usi4gC1wiXJWkLhVjfp3gXgl362mi9HtAplWy8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1vpTUtDJDVtktEtdSWqUZOtKuKS+f2zxxnO+CQM+mBRLXjjOmkPNoGIIdI/q8Owa
	 wkMaGA8vRMjFE3cX4Kgm5w5gr7sYTo5E+JUeLJeSks3nO6Iuuq4kmtdIAmBv/YBnFV
	 4pcYtBGSOS78ts4JR9XaSDezmZ07tqk8AOX8yJWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0127/1756] r8169: align RTL8125/RTL8126 PHY config with vendor driver
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150013.256725241@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 4af2f60bf7378bd5c92b15a528d8c6c7d02bed6c ]

This aligns some parameters with vendor driver r8125/r8126 to avoid
compatibility issues. Note that for RTL8125B there's no functional
change, just the open-coded version of the function is replaced.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/a8a9d896-fbe6-41f2-bf87-666567d3cdb3@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index d09b2a41cd062..b8442e6ee2496 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1068,8 +1068,8 @@ static void rtl8125b_hw_phy_config(struct rtl8169_private *tp,
 				   struct phy_device *phydev)
 {
 	r8169_apply_firmware(tp);
+	rtl8168g_enable_gphy_10m(phydev);
 
-	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
 	phy_modify_paged(phydev, 0xac4, 0x13, 0x00f0, 0x0090);
 	phy_modify_paged(phydev, 0xad3, 0x10, 0x0003, 0x0001);
 
@@ -1108,6 +1108,7 @@ static void rtl8125d_hw_phy_config(struct rtl8169_private *tp,
 				   struct phy_device *phydev)
 {
 	r8169_apply_firmware(tp);
+	rtl8168g_enable_gphy_10m(phydev);
 	rtl8125_legacy_force_mode(phydev);
 	rtl8168g_disable_aldps(phydev);
 	rtl8125b_config_eee_phy(phydev);
@@ -1117,6 +1118,9 @@ static void rtl8126a_hw_phy_config(struct rtl8169_private *tp,
 				   struct phy_device *phydev)
 {
 	r8169_apply_firmware(tp);
+	rtl8168g_enable_gphy_10m(phydev);
+	rtl8125_legacy_force_mode(phydev);
+	rtl8168g_disable_aldps(phydev);
 }
 
 void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
-- 
2.53.0



