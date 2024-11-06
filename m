Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA421F8933;
	Wed,  6 Nov 2024 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898261; cv=none; b=c8hxc+0ppZAaN71bbllY2q/mHp4L/PrUbgKY+m0TNAJfulGYscwv+3iU1A5jCHE4Dft99Ar1SHM6S9BhuyJORkmaEv5dzTCV4YQW+UrEeoRRlfqkPkLk5fgzfFQqsVzPlE3JL5D2uoatWi3D3WIXNifko7eI3IIgANwdtiBiLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898261; c=relaxed/simple;
	bh=P0+uomQdHA9TVfQsVqdlvtpg8+4DD5FoiZmOnVRZkno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7DGx6Oj696KmTARV6fhGuhO/L+x8226aD2qgezVHxNzWtsYmgLBCfPl9z5iWUOE2dkdMUXSlzCNW0tz16JCS4WwfahsJsokmwItEHpTPQ5XBAKlzX3bnongjODGoECwya2EVJKetpFROY8kSdusmW3JTlYfLq2UtcU0BnC70lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNY01RJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNY01RJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E33BC4CECD;
	Wed,  6 Nov 2024 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898260;
	bh=P0+uomQdHA9TVfQsVqdlvtpg8+4DD5FoiZmOnVRZkno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNY01RJ197FkqPuwppPZffHDgS3jLgVYdD9krkml1DeFGFTVfJFpeh0us1V3ejD3x
	 hZ963H4/i1Kq0uQg76n3SRyCCADugEZnsjmoIp3rTWja/hcthLf6lXhvSVdJsGIkOC
	 EouEm7x4KJHmAY8xC5X71YQc9e/DDsero7r5qg6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/462] drivers: net: Fix Kconfig indentation, continued
Date: Wed,  6 Nov 2024 13:01:10 +0100
Message-ID: <20241106120335.889549846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 5421cf84af69a94ebb179fec252f3772c4681cca ]

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style.  This fixes various indentation mixups (seven spaces,
tab+one space, etc).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: addf89774e48 ("ieee802154: Fix build error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Kconfig                           | 64 +++++++++----------
 drivers/net/caif/Kconfig                      | 36 +++++------
 .../net/ethernet/freescale/fs_enet/Kconfig    |  8 +--
 drivers/net/ieee802154/Kconfig                | 12 ++--
 drivers/net/wireless/ath/Kconfig              | 12 ++--
 drivers/net/wireless/ath/ar5523/Kconfig       | 14 ++--
 drivers/net/wireless/ath/ath9k/Kconfig        | 58 ++++++++---------
 drivers/net/wireless/atmel/Kconfig            | 42 ++++++------
 drivers/net/wireless/ralink/rt2x00/Kconfig    | 44 ++++++-------
 drivers/net/wireless/ti/wl12xx/Kconfig        |  8 +--
 10 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index df3cd2589bcfe..e148bbd9e783e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -154,22 +154,22 @@ config IPVLAN_L3S
 	select NET_L3_MASTER_DEV
 
 config IPVLAN
-    tristate "IP-VLAN support"
-    depends on INET
-    depends on IPV6 || !IPV6
-    ---help---
-      This allows one to create virtual devices off of a main interface
-      and packets will be delivered based on the dest L3 (IPv6/IPv4 addr)
-      on packets. All interfaces (including the main interface) share L2
-      making it transparent to the connected L2 switch.
+	tristate "IP-VLAN support"
+	depends on INET
+	depends on IPV6 || !IPV6
+	---help---
+	  This allows one to create virtual devices off of a main interface
+	  and packets will be delivered based on the dest L3 (IPv6/IPv4 addr)
+	  on packets. All interfaces (including the main interface) share L2
+	  making it transparent to the connected L2 switch.
 
-      Ipvlan devices can be added using the "ip" command from the
-      iproute2 package starting with the iproute2-3.19 release:
+	  Ipvlan devices can be added using the "ip" command from the
+	  iproute2 package starting with the iproute2-3.19 release:
 
-      "ip link add link <main-dev> [ NAME ] type ipvlan"
+	  "ip link add link <main-dev> [ NAME ] type ipvlan"
 
-      To compile this driver as a module, choose M here: the module
-      will be called ipvlan.
+	  To compile this driver as a module, choose M here: the module
+	  will be called ipvlan.
 
 config IPVTAP
 	tristate "IP-VLAN based tap driver"
@@ -186,11 +186,11 @@ config IPVTAP
 	  will be called ipvtap.
 
 config VXLAN
-       tristate "Virtual eXtensible Local Area Network (VXLAN)"
-       depends on INET
-       select NET_UDP_TUNNEL
-       select GRO_CELLS
-       ---help---
+	tristate "Virtual eXtensible Local Area Network (VXLAN)"
+	depends on INET
+	select NET_UDP_TUNNEL
+	select GRO_CELLS
+	---help---
 	  This allows one to create vxlan virtual interfaces that provide
 	  Layer 2 Networks over Layer 3 Networks. VXLAN is often used
 	  to tunnel virtual network infrastructure in virtualized environments.
@@ -201,12 +201,12 @@ config VXLAN
 	  will be called vxlan.
 
 config GENEVE
-       tristate "Generic Network Virtualization Encapsulation"
-       depends on INET
-       depends on IPV6 || !IPV6
-       select NET_UDP_TUNNEL
-       select GRO_CELLS
-       ---help---
+	tristate "Generic Network Virtualization Encapsulation"
+	depends on INET
+	depends on IPV6 || !IPV6
+	select NET_UDP_TUNNEL
+	select GRO_CELLS
+	---help---
 	  This allows one to create geneve virtual interfaces that provide
 	  Layer 2 Networks over Layer 3 Networks. GENEVE is often used
 	  to tunnel virtual network infrastructure in virtualized environments.
@@ -245,8 +245,8 @@ config MACSEC
 config NETCONSOLE
 	tristate "Network console logging support"
 	---help---
-	If you want to log kernel messages over the network, enable this.
-	See <file:Documentation/networking/netconsole.txt> for details.
+	  If you want to log kernel messages over the network, enable this.
+	  See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
@@ -363,12 +363,12 @@ config NET_VRF
 	  support enables VRF devices.
 
 config VSOCKMON
-    tristate "Virtual vsock monitoring device"
-    depends on VHOST_VSOCK
-    ---help---
-     This option enables a monitoring net device for vsock sockets. It is
-     mostly intended for developers or support to debug vsock issues. If
-     unsure, say N.
+	tristate "Virtual vsock monitoring device"
+	depends on VHOST_VSOCK
+	---help---
+	  This option enables a monitoring net device for vsock sockets. It is
+	  mostly intended for developers or support to debug vsock issues. If
+	  unsure, say N.
 
 endif # NET_CORE
 
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index 66ea15f067025..f330c9f4c6c85 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -10,37 +10,37 @@ config CAIF_TTY
 	depends on CAIF && TTY
 	default n
 	---help---
-	The CAIF TTY transport driver is a Line Discipline (ldisc)
-	identified as N_CAIF. When this ldisc is opened from user space
-	it will redirect the TTY's traffic into the CAIF stack.
+	  The CAIF TTY transport driver is a Line Discipline (ldisc)
+	  identified as N_CAIF. When this ldisc is opened from user space
+	  it will redirect the TTY's traffic into the CAIF stack.
 
 config CAIF_SPI_SLAVE
 	tristate "CAIF SPI transport driver for slave interface"
 	depends on CAIF && HAS_DMA
 	default n
 	---help---
-	The CAIF Link layer SPI Protocol driver for Slave SPI interface.
-	This driver implements a platform driver to accommodate for a
-	platform specific SPI device. A sample CAIF SPI Platform device is
-	provided in <file:Documentation/networking/caif/spi_porting.txt>.
+	  The CAIF Link layer SPI Protocol driver for Slave SPI interface.
+	  This driver implements a platform driver to accommodate for a
+	  platform specific SPI device. A sample CAIF SPI Platform device is
+	  provided in <file:Documentation/networking/caif/spi_porting.txt>.
 
 config CAIF_SPI_SYNC
 	bool "Next command and length in start of frame"
 	depends on CAIF_SPI_SLAVE
 	default n
 	---help---
-	Putting the next command and length in the start of the frame can
-	help to synchronize to the next transfer in case of over or under-runs.
-	This option also needs to be enabled on the modem.
+	  Putting the next command and length in the start of the frame can
+	  help to synchronize to the next transfer in case of over or under-runs.
+	  This option also needs to be enabled on the modem.
 
 config CAIF_HSI
-       tristate "CAIF HSI transport driver"
-       depends on CAIF
-       default n
-       ---help---
-       The CAIF low level driver for CAIF over HSI.
-       Be aware that if you enable this then you also need to
-       enable a low-level HSI driver.
+	tristate "CAIF HSI transport driver"
+	depends on CAIF
+	default n
+	---help---
+	  The CAIF low level driver for CAIF over HSI.
+	  Be aware that if you enable this then you also need to
+	  enable a low-level HSI driver.
 
 config CAIF_VIRTIO
 	tristate "CAIF virtio transport driver"
@@ -50,7 +50,7 @@ config CAIF_VIRTIO
 	select GENERIC_ALLOCATOR
 	default n
 	---help---
-	The CAIF driver for CAIF over Virtio.
+	  The CAIF driver for CAIF over Virtio.
 
 if CAIF_VIRTIO
 source "drivers/vhost/Kconfig.vringh"
diff --git a/drivers/net/ethernet/freescale/fs_enet/Kconfig b/drivers/net/ethernet/freescale/fs_enet/Kconfig
index 245d9a68a71fb..7f20840fde074 100644
--- a/drivers/net/ethernet/freescale/fs_enet/Kconfig
+++ b/drivers/net/ethernet/freescale/fs_enet/Kconfig
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config FS_ENET
-       tristate "Freescale Ethernet Driver"
-       depends on NET_VENDOR_FREESCALE && (CPM1 || CPM2 || PPC_MPC512x)
-       select MII
-       select PHYLIB
+	tristate "Freescale Ethernet Driver"
+	depends on NET_VENDOR_FREESCALE && (CPM1 || CPM2 || PPC_MPC512x)
+	select MII
+	select PHYLIB
 
 config FS_ENET_MPC5121_FEC
 	def_bool y if (FS_ENET && PPC_MPC512x)
diff --git a/drivers/net/ieee802154/Kconfig b/drivers/net/ieee802154/Kconfig
index 8af5b7e9f4eda..c92a62dbf3982 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -74,9 +74,9 @@ config IEEE802154_ATUSB
 	  The module will be called 'atusb'.
 
 config IEEE802154_ADF7242
-       tristate "ADF7242 transceiver driver"
-       depends on IEEE802154_DRIVERS && MAC802154
-       depends on SPI
+	tristate "ADF7242 transceiver driver"
+	depends on IEEE802154_DRIVERS && MAC802154
+	depends on SPI
 	---help---
 	  Say Y here to enable the ADF7242 SPI 802.15.4 wireless
 	  controller.
@@ -107,9 +107,9 @@ config IEEE802154_CA8210_DEBUGFS
 	  management entities.
 
 config IEEE802154_MCR20A
-       tristate "MCR20A transceiver driver"
-       depends on IEEE802154_DRIVERS && MAC802154
-       depends on SPI
+	tristate "MCR20A transceiver driver"
+	depends on IEEE802154_DRIVERS && MAC802154
+	depends on SPI
 	---help---
 	  Say Y here to enable the MCR20A SPI 802.15.4 wireless
 	  controller.
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 56616d988c965..7b90b8546162f 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -30,12 +30,12 @@ config ATH_DEBUG
 	  Right now only ath9k makes use of this.
 
 config ATH_TRACEPOINTS
-       bool "Atheros wireless tracing"
-       depends on ATH_DEBUG
-       depends on EVENT_TRACING
-       ---help---
-	 This option enables tracepoints for atheros wireless drivers.
-	 Currently, ath9k makes use of this facility.
+	bool "Atheros wireless tracing"
+	depends on ATH_DEBUG
+	depends on EVENT_TRACING
+	---help---
+	  This option enables tracepoints for atheros wireless drivers.
+	  Currently, ath9k makes use of this facility.
 
 config ATH_REG_DYNAMIC_USER_REG_HINTS
 	bool "Atheros dynamic user regulatory hints"
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 65b39c7d035d7..e82df5f1ea67e 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: ISC
 config AR5523
-       tristate "Atheros AR5523 wireless driver support"
-       depends on MAC80211 && USB
-       select ATH_COMMON
-       select FW_LOADER
-       ---help---
-	 This module add support for AR5523 based USB dongles such as D-Link
-	 DWL-G132, Netgear WPN111 and many more.
+	tristate "Atheros AR5523 wireless driver support"
+	depends on MAC80211 && USB
+	select ATH_COMMON
+	select FW_LOADER
+	---help---
+	  This module add support for AR5523 based USB dongles such as D-Link
+	  DWL-G132, Netgear WPN111 and many more.
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index c99f422844655..78620c6b64a20 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -144,13 +144,13 @@ config ATH9K_RFKILL
 	  a platform that can toggle the RF-Kill GPIO.
 
 config ATH9K_CHANNEL_CONTEXT
-       bool "Channel Context support"
-       depends on ATH9K
-       default n
-       ---help---
-	 This option enables channel context support in ath9k, which is needed
-	 for multi-channel concurrency. Enable this if P2P PowerSave support
-	 is required.
+	bool "Channel Context support"
+	depends on ATH9K
+	default n
+	---help---
+	  This option enables channel context support in ath9k, which is needed
+	  for multi-channel concurrency. Enable this if P2P PowerSave support
+	  is required.
 
 config ATH9K_PCOEM
 	bool "Atheros ath9k support for PC OEM cards" if EXPERT
@@ -162,32 +162,32 @@ config ATH9K_PCI_NO_EEPROM
 	depends on ATH9K_PCI
 	default n
 	help
-	 This separate driver provides a loader in order to support the
-	 AR500X to AR92XX-generation of ath9k PCI(e) WiFi chips, which have
-	 their initialization data (which contains the real PCI Device ID
-	 that ath9k will need) stored together with the calibration data out
-	 of reach for the ath9k chip.
+	  This separate driver provides a loader in order to support the
+	  AR500X to AR92XX-generation of ath9k PCI(e) WiFi chips, which have
+	  their initialization data (which contains the real PCI Device ID
+	  that ath9k will need) stored together with the calibration data out
+	  of reach for the ath9k chip.
 
-	 These devices are usually various network appliances, routers or
-	 access Points and such.
+	  These devices are usually various network appliances, routers or
+	  access Points and such.
 
-	 If unsure say N.
+	  If unsure say N.
 
 config ATH9K_HTC
-       tristate "Atheros HTC based wireless cards support"
-       depends on USB && MAC80211
-       select ATH9K_HW
-       select MAC80211_LEDS
-       select LEDS_CLASS
-       select NEW_LEDS
-       select ATH9K_COMMON
-       ---help---
-	 Support for Atheros HTC based cards.
-	 Chipsets supported: AR9271
-
-	 For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
-
-	 The built module will be ath9k_htc.
+	tristate "Atheros HTC based wireless cards support"
+	depends on USB && MAC80211
+	select ATH9K_HW
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
+	select ATH9K_COMMON
+	---help---
+	  Support for Atheros HTC based cards.
+	  Chipsets supported: AR9271
+
+	  For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
+
+	  The built module will be ath9k_htc.
 
 config ATH9K_HTC_DEBUGFS
 	bool "Atheros ath9k_htc debugging"
diff --git a/drivers/net/wireless/atmel/Kconfig b/drivers/net/wireless/atmel/Kconfig
index 4c0556b3a5ba8..c2142c70f25db 100644
--- a/drivers/net/wireless/atmel/Kconfig
+++ b/drivers/net/wireless/atmel/Kconfig
@@ -13,29 +13,29 @@ config WLAN_VENDOR_ATMEL
 if WLAN_VENDOR_ATMEL
 
 config ATMEL
-      tristate "Atmel at76c50x chipset  802.11b support"
-      depends on CFG80211 && (PCI || PCMCIA)
-      select WIRELESS_EXT
-      select WEXT_PRIV
-      select FW_LOADER
-      select CRC32
-       ---help---
-	A driver 802.11b wireless cards based on the Atmel fast-vnet
-	chips. This driver supports standard Linux wireless extensions.
-
-	Many  cards based on this chipset do not have flash memory
-	and need their firmware loaded at start-up. If yours is
-	one of these, you will need to provide a firmware image
-	to be loaded into the card by the driver. The Atmel
-	firmware package can be downloaded from
-	<http://www.thekelleys.org.uk/atmel>
+	tristate "Atmel at76c50x chipset  802.11b support"
+	depends on CFG80211 && (PCI || PCMCIA)
+	select WIRELESS_EXT
+	select WEXT_PRIV
+	select FW_LOADER
+	select CRC32
+	---help---
+	  A driver 802.11b wireless cards based on the Atmel fast-vnet
+	  chips. This driver supports standard Linux wireless extensions.
+
+	  Many  cards based on this chipset do not have flash memory
+	  and need their firmware loaded at start-up. If yours is
+	  one of these, you will need to provide a firmware image
+	  to be loaded into the card by the driver. The Atmel
+	  firmware package can be downloaded from
+	  <http://www.thekelleys.org.uk/atmel>
 
 config PCI_ATMEL
-      tristate "Atmel at76c506 PCI cards"
-      depends on ATMEL && PCI
-       ---help---
-	Enable support for PCI and mini-PCI cards containing the
-	Atmel at76c506 chip.
+	tristate "Atmel at76c506 PCI cards"
+	depends on ATMEL && PCI
+	---help---
+	  Enable support for PCI and mini-PCI cards containing the
+	  Atmel at76c506 chip.
 
 config PCMCIA_ATMEL
 	tristate "Atmel at76c502/at76c504 PCMCIA cards"
diff --git a/drivers/net/wireless/ralink/rt2x00/Kconfig b/drivers/net/wireless/ralink/rt2x00/Kconfig
index f8a9244ce012b..d4969d6178220 100644
--- a/drivers/net/wireless/ralink/rt2x00/Kconfig
+++ b/drivers/net/wireless/ralink/rt2x00/Kconfig
@@ -95,20 +95,20 @@ config RT2800PCI_RT35XX
 
 
 config RT2800PCI_RT53XX
-       bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
-       default y
-       ---help---
-	 This adds support for rt53xx wireless chipset family to the
-	 rt2800pci driver.
-	 Supported chips: RT5390
+	bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
+	default y
+	---help---
+	  This adds support for rt53xx wireless chipset family to the
+	  rt2800pci driver.
+	  Supported chips: RT5390
 
 config RT2800PCI_RT3290
-       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
-       default y
-       ---help---
-	 This adds support for rt3290 wireless chipset family to the
-	 rt2800pci driver.
-	 Supported chips: RT3290
+	bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
+	default y
+	---help---
+	  This adds support for rt3290 wireless chipset family to the
+	  rt2800pci driver.
+	  Supported chips: RT3290
 endif
 
 config RT2500USB
@@ -174,18 +174,18 @@ config RT2800USB_RT3573
 	  in the rt2800usb driver.
 
 config RT2800USB_RT53XX
-       bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
-       ---help---
-	 This adds support for rt53xx wireless chipset family to the
-	 rt2800usb driver.
-	 Supported chips: RT5370
+	bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
+	---help---
+	  This adds support for rt53xx wireless chipset family to the
+	  rt2800usb driver.
+	  Supported chips: RT5370
 
 config RT2800USB_RT55XX
-       bool "rt2800usb - Include support for rt55xx devices (EXPERIMENTAL)"
-       ---help---
-	 This adds support for rt55xx wireless chipset family to the
-	 rt2800usb driver.
-	 Supported chips: RT5572
+	bool "rt2800usb - Include support for rt55xx devices (EXPERIMENTAL)"
+	---help---
+	  This adds support for rt55xx wireless chipset family to the
+	  rt2800usb driver.
+	  Supported chips: RT5572
 
 config RT2800USB_UNKNOWN
 	bool "rt2800usb - Include support for unknown (USB) devices"
diff --git a/drivers/net/wireless/ti/wl12xx/Kconfig b/drivers/net/wireless/ti/wl12xx/Kconfig
index e409042ee9a01..9c4511604b67a 100644
--- a/drivers/net/wireless/ti/wl12xx/Kconfig
+++ b/drivers/net/wireless/ti/wl12xx/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config WL12XX
-       tristate "TI wl12xx support"
+	tristate "TI wl12xx support"
 	depends on MAC80211
-       select WLCORE
-       ---help---
+	select WLCORE
+	---help---
 	  This module adds support for wireless adapters based on TI wl1271,
 	  wl1273, wl1281 and wl1283 chipsets. This module does *not* include
 	  support for wl1251.  For wl1251 support, use the separate homonymous
-	   driver instead.
+	  driver instead.
-- 
2.43.0



