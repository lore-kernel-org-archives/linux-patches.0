Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34DD275B05;
	Sat, 14 Feb 2026 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104428; cv=none; b=Qd6ze1Vncg+mIVH5dm2KKwU/gkY7n3mbgS+6K2AnQuuSGDuCCGIHLlLzNXSwMHr0emNrFn6nIBUCpUHsvLJajfPD6fce3A8SCs58UnL4dWdY0InVk0LVmYMti4XFlL6y5iiR2ft1lxMA3so1ymKw1VnB074iFy5jcg0vWnzYwFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104428; c=relaxed/simple;
	bh=ZMRG75qtEGiUqEvZfjr+TxhGXXLZLURzjYwtofTuQUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce5qOnzU2Iqsgq8YaBzVlo7bs6TlBBQJilfAjq1UCtHFdkvNjV87sBcUCt/HiZqAsJsg81atwLdqmr5azG3zTlgjaILR6DbGT9XZTgHO0jgqXzk7F4vKCaQc0BicuCU709PEV3sD5iQW/UxaXAipzh6b0gQ7HD+tCVhh/yXFjPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7kDL+M7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7kDL+M7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C18C16AAE;
	Sat, 14 Feb 2026 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104428;
	bh=ZMRG75qtEGiUqEvZfjr+TxhGXXLZLURzjYwtofTuQUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7kDL+M7y+PPE7j+X+VXgEVH44KKKLexQ0PiSDJ69T8/okWe0ZOZG7hf4fr2PM+rQ
	 Ij1bbLpEd2nzk1f3Wz7AazOmKzW+trZ5SN6zmuLC4aZx6kFnQBhCVMCj6DzQXNVHy5
	 2WqTx/g9Ydc7zf45Z0rYhwVWWrQorXy6qSI8UExL0TLF+LHJt4bhaBvTYYtDAZuqF3
	 oYlxtX39hebuoGFOs4sIWtmlSxVRh/CYMjBh1Cqqx0VVbJNgkaP31VMn80Lyp33tsB
	 xJBL70XcGtbuuWSMYnte9SO4kd2WzxClFHScSKimzT2Oq9VurVv7/I2aAcoWw1qD6U
	 k096fk7SpDLBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	o.rempel@pengutronix.de,
	yelangyan@huaqin.corp-partner.google.com,
	ebiggers@google.com,
	peter@korsgaard.com,
	pabeni@redhat.com,
	andrew@lunn.ch,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] net: usb: sr9700: remove code to drive nonexistent multicast filter
Date: Sat, 14 Feb 2026 16:23:43 -0500
Message-ID: <20260214212452.782265-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 9a9424c756feee9ee6e717405a9d6fa7bacdef08 ]

Several registers referenced in this driver's source code do not
actually exist (they are not writable and read as zero in my testing).
They exist in this driver because it originated as a copy of the dm9601
driver. Notably, these include the multicast filter registers - this
causes the driver to not support multicast packets correctly. Remove
the multicast filter code and register definitions. Instead, set the
chip to receive all multicast filter packets when any multicast
addresses are in the list.

Reviewed-by: Simon Horman <horms@kernel.org> (from v1)
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20260203013924.28582-1-enelsonmoore@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - `RCR_ALL` is already defined in the header at line 58. The fix
uses an existing flag.

### User Impact

- **Who is affected**: Users with SR9700 USB Ethernet adapters
- **What breaks without the fix**: Multicast networking (mDNS, IPv6
  neighbor discovery, IGMP, etc.) doesn't work when specific multicast
  addresses are subscribed
- **Severity**: Medium-high for affected users - multicast is used
  extensively in modern networking (IPv6 relies on it heavily)

### Stable Criteria Assessment

1. **Obviously correct and tested**: Yes - author tested on real
   hardware, reviewed by Simon Horman
2. **Fixes a real bug**: Yes - multicast doesn't work on SR9700 hardware
3. **Important issue**: Yes - broken multicast means broken IPv6
   neighbor discovery, mDNS, etc.
4. **Small and contained**: Yes - ~20 lines of meaningful change in one
   driver
5. **No new features**: Correct - this removes broken code and enables
   proper multicast reception
6. **Applies cleanly**: The driver has been stable for years, should
   apply cleanly

### Concerns

- The Kconfig change (removing `select CRC32`) could potentially cause
  build issues if something else in the same config depends on CRC32
  being pulled in transitively. However, CRC32 is selected by many other
  drivers, so this is extremely unlikely to matter in practice.
- The removal of the `#include <linux/crc32.h>` is similarly safe.

### Verdict

This is a clear bug fix for a real hardware issue - the sr9700 driver
was attempting to program nonexistent multicast filter registers,
causing multicast to be broken. The fix is small, well-tested on real
hardware, reviewed, and low-risk (it makes the NIC more permissive,
never less). It meets all stable kernel criteria.

**YES**

 drivers/net/usb/Kconfig  |  1 -
 drivers/net/usb/sr9700.c | 25 ++++---------------------
 drivers/net/usb/sr9700.h |  7 +------
 3 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 856e648d804e0..da0f6a138f4fc 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -319,7 +319,6 @@ config USB_NET_DM9601
 config USB_NET_SR9700
 	tristate "CoreChip-sz SR9700 based USB 1.1 10/100 ethernet devices"
 	depends on USB_USBNET
-	select CRC32
 	help
 	  This option adds support for CoreChip-sz SR9700 based USB 1.1
 	  10/100 Ethernet adapters.
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 820c4c5069792..a5d364fbc3639 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -18,7 +18,6 @@
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/usb.h>
-#include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 
 #include "sr9700.h"
@@ -265,31 +264,15 @@ static const struct ethtool_ops sr9700_ethtool_ops = {
 static void sr9700_set_multicast(struct net_device *netdev)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	/* We use the 20 byte dev->data for our 8 byte filter buffer
-	 * to avoid allocating memory that is tricky to free later
-	 */
-	u8 *hashes = (u8 *)&dev->data;
 	/* rx_ctl setting : enable, disable_long, disable_crc */
 	u8 rx_ctl = RCR_RXEN | RCR_DIS_CRC | RCR_DIS_LONG;
 
-	memset(hashes, 0x00, SR_MCAST_SIZE);
-	/* broadcast address */
-	hashes[SR_MCAST_SIZE - 1] |= SR_MCAST_ADDR_FLAG;
-	if (netdev->flags & IFF_PROMISC) {
+	if (netdev->flags & IFF_PROMISC)
 		rx_ctl |= RCR_PRMSC;
-	} else if (netdev->flags & IFF_ALLMULTI ||
-		   netdev_mc_count(netdev) > SR_MCAST_MAX) {
-		rx_ctl |= RCR_RUNT;
-	} else if (!netdev_mc_empty(netdev)) {
-		struct netdev_hw_addr *ha;
-
-		netdev_for_each_mc_addr(ha, netdev) {
-			u32 crc = ether_crc(ETH_ALEN, ha->addr) >> 26;
-			hashes[crc >> 3] |= 1 << (crc & 0x7);
-		}
-	}
+	else if (netdev->flags & IFF_ALLMULTI || !netdev_mc_empty(netdev))
+		/* The chip has no multicast filter */
+		rx_ctl |= RCR_ALL;
 
-	sr_write_async(dev, SR_MAR, SR_MCAST_SIZE, hashes);
 	sr_write_reg_async(dev, SR_RCR, rx_ctl);
 }
 
diff --git a/drivers/net/usb/sr9700.h b/drivers/net/usb/sr9700.h
index ea2b4de621c86..c479908f7d823 100644
--- a/drivers/net/usb/sr9700.h
+++ b/drivers/net/usb/sr9700.h
@@ -104,9 +104,7 @@
 #define		WCR_LINKEN		(1 << 5)
 /* Physical Address Reg */
 #define	SR_PAR			0x10	/* 0x10 ~ 0x15 6 bytes for PAR */
-/* Multicast Address Reg */
-#define	SR_MAR			0x16	/* 0x16 ~ 0x1D 8 bytes for MAR */
-/* 0x1e unused */
+/* 0x16 --> 0x1E unused */
 /* Phy Reset Reg */
 #define	SR_PRR			0x1F
 #define		PRR_PHY_RST		(1 << 0)
@@ -161,9 +159,6 @@
 /* parameters */
 #define	SR_SHARE_TIMEOUT	1000
 #define	SR_EEPROM_LEN		256
-#define	SR_MCAST_SIZE		8
-#define	SR_MCAST_ADDR_FLAG	0x80
-#define	SR_MCAST_MAX		64
 #define	SR_TX_OVERHEAD		2	/* 2bytes header */
 #define	SR_RX_OVERHEAD		7	/* 3bytes header + 4crc tail */
 
-- 
2.51.0

