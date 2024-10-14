Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCEC13B7A1;
	Mon, 14 Oct 2024 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916152; cv=none; b=cBUfWpAc3Vq39DGIVjqEotqXlrY0El+qlb5690kKtXhoD+kmV5qkNe11x7xj34NSXSjMiF0qCgeqD5Phqv00B4e4FEy3eXGi+tW6LQlkMU2zr4CXtIkL++g4rfp4IDFQopwAkuO+fSwUqmmgMtuwXYZOjATKK8J/G8c23mhYG2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916152; c=relaxed/simple;
	bh=tDuCTZrMkuWXD/4GK0NeDyZ3WGyImIvPITUZSBL8uIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WErqINR5s+CSiKmmibKF6f3N0gXuSGx6uCXpfF1Lq/P1ni3xtHClY3tky/LJ9EeBTTY1mplc9zeGrPcQIThvnkoX/NcMDZbrn7hzxvMXEQ7GNB74v/1IagplGsGlRq/lJen5d49px43/eMVJx4qiyM4jG2cVrovpft/x97MkUFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNk/4M0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNk/4M0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6F4C4CED0;
	Mon, 14 Oct 2024 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916152;
	bh=tDuCTZrMkuWXD/4GK0NeDyZ3WGyImIvPITUZSBL8uIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNk/4M0xxRQ5FUVZWKlCzgRH8bWSKLFuxO6pMYnir27fi/q6ibXYxymMjr6x/O1I0
	 urmAgwliBWkQxsAw2+tF1eyua8iQErgMpuZeXzKPATEyQZfWbb18Rb0sbLUk7zASwO
	 toKvsbU6Zp6/LtsnE+GevbjvDrUdkKZnWf5nLl+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Chauhan <quic_abchauha@quicinc.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 092/214] net: phy: aquantia: AQR115c fix up PMA capabilities
Date: Mon, 14 Oct 2024 16:19:15 +0200
Message-ID: <20241014141048.586158868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Chauhan <quic_abchauha@quicinc.com>

[ Upstream commit 17cbfcdd85f6c93b2e9565d61110ad0b90440436 ]

AQR115c reports incorrect PMA capabilities which includes
10G/5G and also incorrectly disables capabilities like autoneg
and 10Mbps support.

AQR115c as per the Marvell databook supports speeds up to 2.5Gbps
with autonegotiation.

Fixes: 0ebc581f8a4b ("net: phy: aquantia: add support for aqr115c")
Link: https://lore.kernel.org/all/20240913011635.1286027-1-quic_abchauha@quicinc.com/T/
Signed-off-by: Abhishek Chauhan <quic_abchauha@quicinc.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20241001224626.2400222-2-quic_abchauha@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/phy/aquantia/aquantia_main.c b/drivers/net/phy/aquantia/aquantia_main.c
index 4d156d406bab9..1bb39664a5cb1 100644
--- a/drivers/net/phy/aquantia/aquantia_main.c
+++ b/drivers/net/phy/aquantia/aquantia_main.c
@@ -731,6 +731,19 @@ static int aqr113c_fill_interface_modes(struct phy_device *phydev)
 	return aqr107_fill_interface_modes(phydev);
 }
 
+static int aqr115c_get_features(struct phy_device *phydev)
+{
+	unsigned long *supported = phydev->supported;
+
+	/* PHY supports speeds up to 2.5G with autoneg. PMA capabilities
+	 * are not useful.
+	 */
+	linkmode_or(supported, supported, phy_gbit_features);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, supported);
+
+	return 0;
+}
+
 static int aqr113c_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -1046,6 +1059,7 @@ static struct phy_driver aqr_driver[] = {
 	.get_sset_count = aqr107_get_sset_count,
 	.get_strings    = aqr107_get_strings,
 	.get_stats      = aqr107_get_stats,
+	.get_features   = aqr115c_get_features,
 	.link_change_notify = aqr107_link_change_notify,
 	.led_brightness_set = aqr_phy_led_brightness_set,
 	.led_hw_is_supported = aqr_phy_led_hw_is_supported,
-- 
2.43.0



