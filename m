Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A663FFD;
	Tue, 29 Apr 2025 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949652; cv=none; b=Tqm0wRKCetJujTEKnpelqIDv4OcybxCAyrIDOtxwagjByuBgWfTEAtG/K4+4WQ84W35PBAV/RHaUNcu60CT27jUiC9nUVfOtIUJcMzXPJAU63MZ3eAcC2U30ugmblKLdc1LIjeahTgUgAvE3xLe/IEYvJ2PeO5qgU2D2Q5n5Wyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949652; c=relaxed/simple;
	bh=6xgZk3Npr0OmivYe+5zD4iXn66ucoJQbxXoMFsxSoCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbJc4i1KOXNhyVC+9BuvHrm8kvbCSfuBi/3WHBC9qHxv4hEcS5nTRxDuiG/jXF5mWsYZzCDD4AkgAyCVpa33GTA6blFv2Y8iECE0pRA4uzbERjDJjkFlwaKRsN0+9YtItyHstCh9DPpFFv9mOdF6Ga19RccjYcoL18WAedJd2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygEJNJMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygEJNJMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88653C4CEE3;
	Tue, 29 Apr 2025 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949651;
	bh=6xgZk3Npr0OmivYe+5zD4iXn66ucoJQbxXoMFsxSoCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygEJNJMzIgOVvAnxkKk3kIq+NPcqs7ot7T1aI7p92A4R36cULjBGod//sXXq3HhZa
	 kJqK252DjrnbDRfrgDcCiL8VoiGyG7AkGfv6/1tI6toy1iXtJutOTaePc+YC/62Yez
	 xGi6RNuGJ9zfCo8vVL+ukIhrFmlQVGSvGCu+xUcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/167] net: dsa: mv88e6xxx: pass directly chip structure to mv88e6xxx_phy_is_internal
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161052.288006278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit ca345931907ff1893f02f5fe1349b16c9fc27e4c ]

Since this function is a simple helper, we do not need to pass a full
dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
Doing so will allow to share this function with any other function
not manipulating dsa_switch structure but needing info about number of
internal phys

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 52fdc41c3278 ("net: dsa: mv88e6xxx: fix internal PHYs for 6320 family")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b3744f2ea0f48..cabf97a902b52 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -470,10 +470,8 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
-static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
+static int mv88e6xxx_phy_is_internal(struct mv88e6xxx_chip *chip, int port)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
-
 	return port < chip->info->num_internal_phys;
 }
 
@@ -591,7 +589,7 @@ static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
 
-	if (mv88e6xxx_phy_is_internal(chip->ds, port)) {
+	if (mv88e6xxx_phy_is_internal(chip, port)) {
 		__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
 	} else {
 		if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
@@ -839,7 +837,7 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	chip->info->ops->phylink_get_caps(chip, port, config);
 	mv88e6xxx_reg_unlock(chip);
 
-	if (mv88e6xxx_phy_is_internal(ds, port)) {
+	if (mv88e6xxx_phy_is_internal(chip, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
 		/* Internal ports with no phy-mode need GMII for PHYLIB */
@@ -879,7 +877,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
+	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(chip, port)) {
 		err = mv88e6xxx_port_config_interface(chip, port,
 						      state->interface);
 		if (err && err != -EOPNOTSUPP)
-- 
2.39.5



