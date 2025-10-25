Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C231064B;
	Sat, 25 Oct 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409340; cv=none; b=SN6OhUJGNiCX/7di58IyPpbHan39rWT6Ftvjv2uRHKuMBx99Lmq9gbV8NZHKXpdrQ21QQhg/AQxGg66YEBvMg6oipJP5fQasBXxAvXmPfcLNUZMr75Z/K3OCRdHs1Zbdu9PU7lgR9dxtzLqK1GpXgL6DG5XZYm7h7eZcZ1eOZv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409340; c=relaxed/simple;
	bh=9OTVpVCF5DtNbGlQFrrxYxz6PfUX+wljjRCRcsw6P4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIuQFJpE0XHOHhyPHa3+v0YqJypUm39j4MDgqg8/VmFddxs3Z+UGRf6DWBwv1qnQLb++EKIcz2i+rD5qKsZkAq8U0oAgxHmJPs52k+cyqGtSJSNeyfTYe+EuCbA0ZsowMCzw1vKG7ZS0heSbSeAWS6I4dX9Hp/REB9MmMmn7/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2aayUqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2aayUqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D938C4CEF5;
	Sat, 25 Oct 2025 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409339;
	bh=9OTVpVCF5DtNbGlQFrrxYxz6PfUX+wljjRCRcsw6P4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2aayUqanR4cWZU0O4+hJyJR0CIwKqrfrBF8qsbm53SBoKvG30mPmRKlWbo7N6ZsN
	 nnS1NeQG3dr1pj7jvdTuWecZnvpsTqcczWjcxKSFHePdcRDj95yiBG4/uOD+uuSKKm
	 bzmE4UMOc7RXZdvTsIsB3c1mBqL3H4YZLExaM+hxL6SPIKBt1rnxXBkLoiTghnsk09
	 yV0ijf2VXDL1hD6bhIOrkz77JOiq2Lkvw4bKQGG1mYp1Xv3KP4PXtKsW0+kcbmDD9G
	 E150yzDW5u4tZEn0QLsa6wmq/oP1y7cl+f8gVIpkXHGZD33ZZFMoldOqgFopoe0FXP
	 JNUr++mC093vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] microchip: lan865x: add ndo_eth_ioctl handler to enable PHY ioctl support
Date: Sat, 25 Oct 2025 11:58:36 -0400
Message-ID: <20251025160905.3857885-285-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 34c21e91192aa1ff66f9d6cef8132717840d04e6 ]

Introduce support for standard MII ioctl operations in the LAN865x
Ethernet driver by implementing the .ndo_eth_ioctl callback. This allows
PHY-related ioctl commands to be handled via phy_do_ioctl_running() and
enables support for ethtool and other user-space tools that rely on ioctl
interface to perform PHY register access using commands like SIOCGMIIREG
and SIOCSMIIREG.

This feature enables improved diagnostics and PHY configuration
capabilities from userspace.

Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250828114549.46116-1-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- What changed: The driver adds a single netdev op in
  drivers/net/ethernet/microchip/lan865x/lan865x.c to forward Ethernet
  ioctls to the PHY layer:
  - drivers/net/ethernet/microchip/lan865x/lan865x.c:330 sets
    `.ndo_eth_ioctl = phy_do_ioctl_running,` alongside existing ops such
    as `.ndo_open`, `.ndo_stop`, and `.ndo_set_mac_address`.
- Behavior enabled: With `.ndo_eth_ioctl` wired to
  `phy_do_ioctl_running`, standard MII ioctls are handled by the PHY
  core’s generic handler, enabling tools to read/write PHY registers:
  - `phy_do_ioctl_running()` checks the device is up (`netif_running`)
    and defers to `phy_do_ioctl()` (drivers/net/phy/phy.c:456).
  - `phy_do_ioctl()` dispatches to `phy_mii_ioctl()`, which implements
    SIOCGMIIPHY/SIOCGMIIREG/SIOCSMIIREG and hwtstamp handling
    (drivers/net/phy/phy.c:310, 322, 326, 345, 407).
- Preconditions are satisfied in this driver: The LAN865x stack actually
  attaches a PHY to the netdev via the OA-TC6 framework, so
  `dev->phydev` is valid:
  - `phy_connect_direct(tc6->netdev, tc6->phydev, ...)` in
    drivers/net/ethernet/oa_tc6.c:565 ensures the PHY is registered and
    attached, making the generic PHY ioctl path applicable.
- User impact fixed: Without this hook, standard userspace
  diagnostics/configuration via ioctl (mii-tool, legacy ethtool ioctl
  paths, register access) fail against this device. Enabling
  `.ndo_eth_ioctl` restores expected, widely used functionality for PHY
  access (SIOCGMIIREG/SIOCSMIIREG).
- Small, low-risk change:
  - Single-line addition in the driver’s `net_device_ops`, no
    architectural changes, no behavioral changes in normal TX/RX paths.
  - The chosen helper is the conservative variant:
    `phy_do_ioctl_running()` returns `-ENODEV` if the interface is down
    (drivers/net/phy/phy.c:456), reducing risk.
  - This pattern is standard across many Ethernet drivers (e.g.,
    drivers/net/usb/lan78xx.c:4600,
    drivers/net/ethernet/ti/cpsw_new.c:1135), indicating established
    practice and low regression potential.
- Stable criteria fit:
  - Fixes a user-visible deficiency (inability to use standard PHY
    ioctls) with a minimal, contained change.
  - No new kernel ABI; it wires the driver into existing, generic PHY
    ioctl support.
  - Touches only one driver; no core subsystem churn.
  - Although the commit message frames it as “introduce support,”
    functionally it corrects missing standard behavior expected by
    tooling, which is commonly accepted as a fix.

Recommendation
- Backport to stable series that include both the LAN865x driver and the
  `ndo_eth_ioctl`/`phy_do_ioctl_running` API (for older series lacking
  `ndo_eth_ioctl`, the analogous `.ndo_do_ioctl = phy_do_ioctl_running`
  pattern may be necessary).

 drivers/net/ethernet/microchip/lan865x/lan865x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index 79b800d2b72c2..b428ad6516c5e 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -326,6 +326,7 @@ static const struct net_device_ops lan865x_netdev_ops = {
 	.ndo_start_xmit		= lan865x_send_packet,
 	.ndo_set_rx_mode	= lan865x_set_multicast_list,
 	.ndo_set_mac_address	= lan865x_set_mac_address,
+	.ndo_eth_ioctl          = phy_do_ioctl_running,
 };
 
 static int lan865x_probe(struct spi_device *spi)
-- 
2.51.0

