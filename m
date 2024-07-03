Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A51F185E68;
	Wed,  3 Jul 2024 10:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004163; cv=none; b=eTt4Pb/1w02KucnQgTBidlnd4D0f49uadOswAmAYE2SvTvPh49a1sXUUw4IvyXHtQ/AQwqilA/2Ro4H+RUEh2lcL9BLKi2flsUC+iC8O36Ne4/4FJAAndseSrdW39A4hmdhHJVU0q+xfDZRPYUQc7ILNy/O54ulftoUVJqnTmM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004163; c=relaxed/simple;
	bh=R59SU8yk5aoyh3xnpAqoxUNwtje3vekArKWI7JPoUSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzMtXFcsDX88ECVWtkPUR29chRPn9Z0wLYW4BhExiqPo6l7EvKWpGmAGEG9XP+w8iApUaA6s6JR+nFBTe9ZQiMk0oerQCHE29ENW3eyBKCso0NcMhXrZuz2/T0WT66IC9mThFJ9BPChFYM8+fmPatXZkcBkRYQP1NZUjlkNwIEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLojUaeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLojUaeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB8BC2BD10;
	Wed,  3 Jul 2024 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004163;
	bh=R59SU8yk5aoyh3xnpAqoxUNwtje3vekArKWI7JPoUSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLojUaeHeleXJAi/AvZ7ZS1FGFu3E5zQU9TwxJOkLT6tn/x0IWHmSrGSbQEqYW9wx
	 2zLax/BNtJqofeCVXmSnBcZ0KKE63H5gFMiul6DOrQiME4Uld/P8WGXcOSsZJPk3W6
	 jXt0CLuE7cqAyokRmmIclXARuOJ8/w7Olvmyc7FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Divya Koppera <divya.koppera@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/189] net: phy: mchp: Add support for LAN8814 QUAD PHY
Date: Wed,  3 Jul 2024 12:40:03 +0200
Message-ID: <20240703102846.839273017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Divya Koppera <Divya.Koppera@microchip.com>

[ Upstream commit 1623ad8ec04c771a54975fb84b22bc21c2dbcac1 ]

LAN8814 is a low-power, quad-port triple-speed (10BASE-T/100BASETX/1000BASE-T)
Ethernet physical layer transceiver (PHY). It supports transmission and
reception of data on standard CAT-5, as well as CAT-5e and CAT-6, unshielded
twisted pair (UTP) cables.

LAN8814 supports industry-standard QSGMII (Quad Serial Gigabit Media
Independent Interface) and Q-USGMII (Quad Universal Serial Gigabit Media
Independent Interface) providing chip-to-chip connection to four Gigabit
Ethernet MACs using a single serialized link (differential pair) in each
direction.

The LAN8814 SKU supports high-accuracy timestamping functions to
support IEEE-1588 solutions using Microchip Ethernet switches, as well as
customer solutions based on SoCs and FPGAs.

The LAN8804 SKU has same features as that of LAN8814 SKU except that it does
not support 1588, SyncE, or Q-USGMII with PCH/MCH.

This adds support for 10BASE-T, 100BASE-TX, and 1000BASE-T,
QSGMII link with the MAC.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 54a4e5c16382 ("net: phy: micrel: add Microchip KSZ 9477 to the device table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c   | 14 ++++++++++++++
 include/linux/micrel_phy.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index caaa51a70cbdc..2cd812c097baf 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1149,6 +1149,19 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+}, {
+	.phy_id		= PHY_ID_LAN8814,
+	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.name		= "Microchip INDY Gigabit Quad PHY",
+	.driver_data	= &ksz9021_type,
+	.probe		= kszphy_probe,
+	.soft_reset	= genphy_soft_reset,
+	.read_status	= ksz9031_read_status,
+	.get_sset_count	= kszphy_get_sset_count,
+	.get_strings	= kszphy_get_strings,
+	.get_stats	= kszphy_get_stats,
+	.suspend	= genphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1221,6 +1234,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 75f880c25bb86..416ee6dd25743 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -27,6 +27,7 @@
 #define PHY_ID_KSZ8061		0x00221570
 #define PHY_ID_KSZ9031		0x00221620
 #define PHY_ID_KSZ9131		0x00221640
+#define PHY_ID_LAN8814		0x00221660
 
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
-- 
2.43.0



