Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C55C433C7;
	Mon, 28 Aug 2023 10:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218413;
	bh=Nz4q5Iv5i/e8E1fJ7GTQfvU3fjBKzQwQ9WhZBq2UVYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhHydN6GvFi1h79op+kelUqC5QbAVN+qxPH8O8G4BY/M61Wp1b1OfpH843hNDygPy
	 jgwMmmZAtB2J16H11Lhp+4ejhhFZRKTwOPwGC82WeNtS5yKNYHGVGDAB3HJ+p7mCi6
	 SM2l+Q7ryU1Fttim1s3DMYpPyaccxTfYM8yJz0l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 078/129] net: phy: broadcom: stub c45 read/write for 54810
Date: Mon, 28 Aug 2023 12:12:52 +0200
Message-ID: <20230828101156.208596742@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

commit 096516d092d54604d590827d05b1022c8f326639 upstream.

The 54810 does not support c45. The mmd_phy_indirect accesses return
arbirtary values leading to odd behavior like saying it supports EEE
when it doesn't. We also see that reading/writing these non-existent
MMD registers leads to phy instability in some cases.

Fixes: b14995ac2527 ("net: phy: broadcom: Add BCM54810 PHY entry")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/1691901708-28650-1-git-send-email-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[florian: resolved conflicts in 4.19]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/broadcom.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -421,6 +421,17 @@ static int bcm5482_read_status(struct ph
 	return err;
 }
 
+static int bcm54810_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+{
+	return -EOPNOTSUPP;
+}
+
+static int bcm54810_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+			      u16 val)
+{
+	return -EOPNOTSUPP;
+}
+
 static int bcm5481_config_aneg(struct phy_device *phydev)
 {
 	struct device_node *np = phydev->mdio.dev.of_node;
@@ -684,6 +695,8 @@ static struct phy_driver broadcom_driver
 	.name           = "Broadcom BCM54810",
 	.features       = PHY_GBIT_FEATURES,
 	.flags          = PHY_HAS_INTERRUPT,
+	.read_mmd	= bcm54810_read_mmd,
+	.write_mmd	= bcm54810_write_mmd,
 	.config_init    = bcm54xx_config_init,
 	.config_aneg    = bcm5481_config_aneg,
 	.ack_interrupt  = bcm_phy_ack_intr,


