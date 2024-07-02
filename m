Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E7781F;
	Tue,  2 Jul 2024 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940593; cv=none; b=uvr9I/RUmKQvVlEVDRASlZA35YT4zV1mym0K+vAGKs3x9eyOBWp76tZY58Gj6NW5sEFEReBN7s65/i1tbNXp5S28m8M15KQ2oVjBfTrRoME0b0D8Fjb/cgzwO0GayTKFaAX5Sd1E+YpHRAcGQvHcX9KlXLAGUtIM8fMRg6FyVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940593; c=relaxed/simple;
	bh=j9DCMALPyXlvu4HPk1kfc4Aqi0DsUeygrF16AszFKj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eahEo21pwtYzCTAGWqZz0SrV8G6gqtu1yVvyLuglLrAV0wNeSluQCJc2YSG36tvZmfDOLInFR4ctgFiPv8Wd6NdAeR1lipllmZASvIsWpWtpSK1OnVhhdRkzKh9la1c6fHPaHDLfCZHljGg1PstCX7y1ViYxGGqrafMzO9RPCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+uNhh+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+uNhh+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D2AC116B1;
	Tue,  2 Jul 2024 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940593;
	bh=j9DCMALPyXlvu4HPk1kfc4Aqi0DsUeygrF16AszFKj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+uNhh+U8kBuJ3t0xDSp4jr37tLZGtCZUMdStjo3CPmSIMwXGo5RmFtKIzOU8xJJG
	 +hUbayE+5adXXWFMHbmpsIlhyCatKa9+t6ffSZ0s+gsO23hlK+pM7ElK4RJbq8bKBS
	 C3tOGtk0yNSdSlV5ebz6DGSnBl2N/zPdn3dbtkS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 201/222] Revert "net: sfp: enhance quirk for Fibrestore 2.5G copper SFP module"
Date: Tue,  2 Jul 2024 19:03:59 +0200
Message-ID: <20240702170251.666861248@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b3dcad0bfd62fcc9367d8092a71918db53804f53 which is
commit cd4a32e60061789676f7f018a94fcc9ec56732a0 upstream.

Turned out that this should not have been applied to the stable tree.

Link: https://lore.kernel.org/r/20240628172211.17ccefe9@dellmb
Reported-by: Marek Behún <kabel@kernel.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -385,23 +385,18 @@ static void sfp_fixup_rollball(struct sf
 	sfp->phy_t_retry = msecs_to_jiffies(1000);
 }
 
-static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
+static void sfp_fixup_fs_10gt(struct sfp *sfp)
 {
+	sfp_fixup_10gbaset_30m(sfp);
 	sfp_fixup_rollball(sfp);
 
-	/* The RollBall fixup is not enough for FS modules, the PHY chip inside
+	/* The RollBall fixup is not enough for FS modules, the AQR chip inside
 	 * them does not return 0xffff for PHY ID registers in all MMDs for the
 	 * while initializing. They need a 4 second wait before accessing PHY.
 	 */
 	sfp->module_t_wait = msecs_to_jiffies(4000);
 }
 
-static void sfp_fixup_fs_10gt(struct sfp *sfp)
-{
-	sfp_fixup_10gbaset_30m(sfp);
-	sfp_fixup_fs_2_5gt(sfp);
-}
-
 static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 {
 	/* Ignore the TX_FAULT and LOS signals on this module.
@@ -477,10 +472,6 @@ static const struct sfp_quirk sfp_quirks
 	// Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("FS", "SFP-10G-T", sfp_fixup_fs_10gt),
 
-	// Fiberstore SFP-2.5G-T uses Rollball protocol to talk to the PHY and
-	// needs 4 sec wait before probing the PHY.
-	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_fs_2_5gt),
-
 	// Fiberstore GPON-ONU-34-20BI can operate at 2500base-X, but report 1.2GBd
 	// NRZ in their EEPROM
 	SFP_QUIRK("FS", "GPON-ONU-34-20BI", sfp_quirk_2500basex,
@@ -497,6 +488,9 @@ static const struct sfp_quirk sfp_quirks
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault),
 
+	// FS 2.5G Base-T
+	SFP_QUIRK_M("FS", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
+
 	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
 	// 2500MBd NRZ in their EEPROM
 	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),


