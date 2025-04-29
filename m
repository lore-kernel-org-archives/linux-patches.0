Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3DC3FFD;
	Tue, 29 Apr 2025 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949654; cv=none; b=eN2CH1kdWoFNW7zfxzeF01KfswtHaqPT1aKYDBoUy0etoBtIsBaUHGAkrHkzKoT/fAYfRwAh8L0EnXfQiCE33nYskw4mSxIcgQ7BzFw217iBXrs0hDpGJ+hOat4f0Mvfxzbbpi/UsTMdnVYLyhsw0hUNMZZZ6itNofA3E8loDjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949654; c=relaxed/simple;
	bh=Gtc+4jiHd4mKXEOZ5hYIqvBzUA22SY7/nJZvWPvD5Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oapj2p+GXZG3dZ0zVXqdJ127f24DYSq6L5XOZBq82uqBDrLov/pZm/YaVVtKxO8NzzPjKrmcMHGWF6XQm9vVcNo+rcn8jkeAw+M04L+LMAnA8nYCs/5d9M1TMi2o7xLg7hzlLwo9foebv3OD6t+Mb4oTnujtfSUQzjee1opP0Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7jyPa0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7jyPa0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DACDC4CEE3;
	Tue, 29 Apr 2025 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949654;
	bh=Gtc+4jiHd4mKXEOZ5hYIqvBzUA22SY7/nJZvWPvD5Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7jyPa0Er10fIBbYVHSjxkv0IVnQiI0MHyeky6CxBzMyZO+glZZGGvUF8m6LEs3f6
	 7PJoOwz1sevHdX9055NgXiiZLJFPsbeXRH5xUgqsLeGXOavIzsPscHSXQwZAGOpaIL
	 Lj1u5sfODqZCdC4j6FGvw9rAN3AMJbeaMwiivmyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/167] net: dsa: mv88e6xxx: add field to specify internal phys layout
Date: Tue, 29 Apr 2025 18:42:02 +0200
Message-ID: <20250429161052.328815989@linuxfoundation.org>
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

[ Upstream commit 3ba89b28adb21a5d5d78e905e2c3972816606bb4 ]

mv88e6xxx currently assumes that switch equipped with internal phys have
those phys mapped contiguously starting from port 0 (see
mv88e6xxx_phy_is_internal). However, some switches have internal PHYs but
NOT starting from port 0. For example 88e6393X, 88E6193X and 88E6191X have
integrated PHYs available on ports 1 to 8
To properly support this offset, add a new field to allow specifying an
internal PHYs layout. If field is not set, default layout is assumed (start
at port 0)

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 52fdc41c3278 ("net: dsa: mv88e6xxx: fix internal PHYs for 6320 family")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 4 +++-
 drivers/net/dsa/mv88e6xxx/chip.h    | 5 +++++
 drivers/net/dsa/mv88e6xxx/global2.c | 5 ++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index cabf97a902b52..c1a322d6432c0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -472,7 +472,9 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 
 static int mv88e6xxx_phy_is_internal(struct mv88e6xxx_chip *chip, int port)
 {
-	return port < chip->info->num_internal_phys;
+	return port >= chip->info->internal_phys_offset &&
+		port < chip->info->num_internal_phys +
+			chip->info->internal_phys_offset;
 }
 
 static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index b34e96e689d5c..4a8b56ed1bd6c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -167,6 +167,11 @@ struct mv88e6xxx_info {
 
 	/* Supports PTP */
 	bool ptp_support;
+
+	/* Internal PHY start index. 0 means that internal PHYs range starts at
+	 * port 0, 1 means internal PHYs range starts at port 1, etc
+	 */
+	unsigned int internal_phys_offset;
 };
 
 struct mv88e6xxx_atu_entry {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 79954e580c335..8480d08e6f944 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1184,9 +1184,12 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
 				struct mii_bus *bus)
 {
+	int phy_start = chip->info->internal_phys_offset;
+	int phy_end = chip->info->internal_phys_offset +
+		      chip->info->num_internal_phys;
 	int phy, irq;
 
-	for (phy = 0; phy < chip->info->num_internal_phys; phy++) {
+	for (phy = phy_start; phy < phy_end; phy++) {
 		irq = irq_find_mapping(chip->g2_irq.domain, phy);
 		if (irq < 0)
 			return irq;
-- 
2.39.5



