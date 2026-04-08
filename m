Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6B13BE146;
	Wed,  8 Apr 2026 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655074; cv=none; b=bZ+taCnxp8ZTDlp32a7O2AVITqu7RL3UTu/KwZvDpWhzqAZKsUo7M4HPRmazwBaCO9dfzctjJklvWU1CiDwi6IubE76ltax+xPOhl0uq9D+anC4jyZ49lDHEhYtrgt+fwIekcLJSwLFgnz15F9ZsaI40+yVOIKJeHaQNVJNLyKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655074; c=relaxed/simple;
	bh=MdShFLWH5QPjrXvRDQGuCSptNh4eJfQ1ZFDMbiT05D0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=g4Iq5+CUrqJhZskdL0y9MwESI4dCaOkMgZueFoadJGx9/6GbGffCLZ0RmTAmPgtNYKsWHpQIsVmrewQq+jFP7DOR4FJUjpk/zyGPVSWhgLF5pbjS3u512IWFqsbW6T4phG16T//3GyGWGqZ9cJ5/NdS5h45vNTJrTMjrWn24jqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwkcLktS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwkcLktS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A78C19421;
	Wed,  8 Apr 2026 13:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775655074;
	bh=MdShFLWH5QPjrXvRDQGuCSptNh4eJfQ1ZFDMbiT05D0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JwkcLktSCKf1NlUL5ShsfIAEZ7wi+jn7PsaiOsu2hWLRk16/LLi5/NRkmkt1Y6OcX
	 1HpiKz/gIxXlye9bUa/z0nsY7EuCvhIqgC71VARhMeDYTQUGDTBY0GaTiUtHJurA9A
	 XOYkBHDQIKjKJJqLmijAjGc2FpLQE88quy+A4lMY=
Subject: Patch "net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY" has been added to the 6.1-stable tree
To: 681739313@139.com,Z-1tiW9zjcoFkhwc@shell.armlinux.org.uk,andrew@lunn.ch,davem@davemloft.net,edumazet@google.com,f.fainelli@gmail.com,gregkh@linuxfoundation.org,hkallweit1@gmail.com,kuba@kernel.org,linux-arm-kernel@lists.infradead.org,linux-mediatek@lists.infradead.org,linux@armlinux.org.uk,matthias.bgg@gmail.com,pabeni@redhat.com,patches@lists.linux.dev,vladimir.oltean@nxp.com,wei.fang@nxp.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 08 Apr 2026 15:30:52 +0200
In-Reply-To: <20260327015237.1713008-1-681739313@139.com>
Message-ID: <2026040852-unpinned-dollop-b158@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-phy-allow-mdio-bus-pm-ops-to-start-stop-state-machine-for-phylink-controlled-phy.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 681739313@139.com Fri Mar 27 02:52:59 2026
From: Rajani Kantha <681739313@139.com>
Date: Fri, 27 Mar 2026 09:52:37 +0800
Subject: net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, vladimir.oltean@nxp.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, wei.fang@nxp.com
Message-ID: <20260327015237.1713008-1-681739313@139.com>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fc75ea20ffb452652f0d4033f38fe88d7cfdae35 ]

DSA has 2 kinds of drivers:

1. Those who call dsa_switch_suspend() and dsa_switch_resume() from
   their device PM ops: qca8k-8xxx, bcm_sf2, microchip ksz
2. Those who don't: all others. The above methods should be optional.

For type 1, dsa_switch_suspend() calls dsa_user_suspend() -> phylink_stop(),
and dsa_switch_resume() calls dsa_user_resume() -> phylink_start().
These seem good candidates for setting mac_managed_pm = true because
that is essentially its definition [1], but that does not seem to be the
biggest problem for now, and is not what this change focuses on.

Talking strictly about the 2nd category of DSA drivers here (which
do not have MAC managed PM, meaning that for their attached PHYs,
mdio_bus_phy_suspend() and mdio_bus_phy_resume() should run in full),
I have noticed that the following warning from mdio_bus_phy_resume() is
triggered:

	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
		phydev->state != PHY_UP);

because the PHY state machine is running.

It's running as a result of a previous dsa_user_open() -> ... ->
phylink_start() -> phy_start() having been initiated by the user.

The previous mdio_bus_phy_suspend() was supposed to have called
phy_stop_machine(), but it didn't. So this is why the PHY is in state
PHY_NOLINK by the time mdio_bus_phy_resume() runs.

mdio_bus_phy_suspend() did not call phy_stop_machine() because for
phylink, the phydev->adjust_link function pointer is NULL. This seems a
technicality introduced by commit fddd91016d16 ("phylib: fix PAL state
machine restart on resume"). That commit was written before phylink
existed, and was intended to avoid crashing with consumer drivers which
don't use the PHY state machine - phylink always does, when using a PHY.
But phylink itself has historically not been developed with
suspend/resume in mind, and apparently not tested too much in that
scenario, allowing this bug to exist unnoticed for so long. Plus, prior
to the WARN_ON(), it would have likely been invisible.

This issue is not in fact restricted to type 2 DSA drivers (according to
the above ad-hoc classification), but can be extrapolated to any MAC
driver with phylink and MDIO-bus-managed PHY PM ops. DSA is just where
the issue was reported. Assuming mac_managed_pm is set correctly, a
quick search indicates the following other drivers might be affected:

$ grep -Zlr PHYLINK_NETDEV drivers/ | xargs -0 grep -L mac_managed_pm
drivers/net/ethernet/atheros/ag71xx.c
drivers/net/ethernet/microchip/sparx5/sparx5_main.c
drivers/net/ethernet/microchip/lan966x/lan966x_main.c
drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
drivers/net/ethernet/freescale/ucc_geth.c
drivers/net/ethernet/freescale/enetc/enetc_pf_common.c
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
drivers/net/ethernet/marvell/mvneta.c
drivers/net/ethernet/marvell/prestera/prestera_main.c
drivers/net/ethernet/mediatek/mtk_eth_soc.c
drivers/net/ethernet/altera/altera_tse_main.c
drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
drivers/net/ethernet/meta/fbnic/fbnic_phylink.c
drivers/net/ethernet/tehuti/tn40_phy.c
drivers/net/ethernet/mscc/ocelot_net.c

Make the existing conditions dependent on the PHY device having a
phydev->phy_link_change() implementation equal to the default
phy_link_change() provided by phylib. Otherwise, we implicitly know that
the phydev has the phylink-provided phylink_phy_change() callback, and
when phylink is used, the PHY state machine always needs to be stopped/
started on the suspend/resume path. The code is structured as such that
if phydev->phy_link_change() is absent, it is a matter of time until the
kernel will crash - no need to further complicate the test.

Thus, for the situation where the PM is not managed by the MAC, we will
make the MDIO bus PM ops treat identically the phylink-controlled PHYs
with the phylib-controlled PHYs where an adjust_link() callback is
supplied. In both cases, the MDIO bus PM ops should stop and restart the
PHY state machine.

[1] https://lore.kernel.org/netdev/Z-1tiW9zjcoFkhwc@shell.armlinux.org.uk/

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Reported-by: Wei Fang <wei.fang@nxp.com>
Tested-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250407094042.2155633-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -247,6 +247,33 @@ static void phy_link_change(struct phy_d
 		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
 }
 
+/**
+ * phy_uses_state_machine - test whether consumer driver uses PAL state machine
+ * @phydev: the target PHY device structure
+ *
+ * Ultimately, this aims to indirectly determine whether the PHY is attached
+ * to a consumer which uses the state machine by calling phy_start() and
+ * phy_stop().
+ *
+ * When the PHY driver consumer uses phylib, it must have previously called
+ * phy_connect_direct() or one of its derivatives, so that phy_prepare_link()
+ * has set up a hook for monitoring state changes.
+ *
+ * When the PHY driver is used by the MAC driver consumer through phylink (the
+ * only other provider of a phy_link_change() method), using the PHY state
+ * machine is not optional.
+ *
+ * Return: true if consumer calls phy_start() and phy_stop(), false otherwise.
+ */
+static bool phy_uses_state_machine(struct phy_device *phydev)
+{
+	if (phydev->phy_link_change == phy_link_change)
+		return phydev->attached_dev && phydev->adjust_link;
+
+	/* phydev->phy_link_change is implicitly phylink_phy_change() */
+	return true;
+}
+
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
@@ -307,7 +334,7 @@ static __maybe_unused int mdio_bus_phy_s
 	 * may call phy routines that try to grab the same lock, and that may
 	 * lead to a deadlock.
 	 */
-	if (phydev->attached_dev && phydev->adjust_link)
+	if (phy_uses_state_machine(phydev))
 		phy_stop_machine(phydev);
 
 	if (!mdio_bus_phy_may_suspend(phydev))
@@ -361,7 +388,7 @@ no_resume:
 		}
 	}
 
-	if (phydev->attached_dev && phydev->adjust_link)
+	if (phy_uses_state_machine(phydev))
 		phy_start_machine(phydev);
 
 	return 0;


Patches currently in stable-queue which might be from 681739313@139.com are

queue-6.1/net-phy-move-phy_link_change-prior-to-mdio_bus_phy_may_suspend.patch
queue-6.1/net-phy-fix-phy_uses_state_machine.patch
queue-6.1/net-phy-allow-mdio-bus-pm-ops-to-start-stop-state-machine-for-phylink-controlled-phy.patch
