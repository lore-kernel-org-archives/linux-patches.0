Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021830;
	b=liNwVTJ9R/gGuEvI/7UbfIMs24u6t9aM61c4RLffQlJgyk7CMcwHcTLHr05TAzjBlr2g
	 gideaZ6orFWBcHSPTiP7fuzc3d3k/Z0O7IiUfa/42vGFnBISfL/MFqb1tO3H4Vjyos6gb
	 J6mLHXj/6n0p0fSjSBAAtrBgF71jJd1GpW1MIdLx+LWAUTsc4sUWrgddQxONrC4P3h0tJ
	 VX3mMMnaOjm021+Ns644pp5neokb+W6NMHSSp4iVTFTY1R32VJn0t8IYa2s6yKS8yqRo5
	 9UxNKbU3SNntY7/76hhwiCyFCXlG4srpcd7adIaCo78yqDTm7PVy+21buIHlqEFyXeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IoMqjaz3gB2iO2fQI7dFnTGfp9sR61nqd19+pBvmbj0=;
	b=ozPgEVOnV4cUqsvumDKyPIHs4LWl5Mw/u9R7PGelF+1SIfNTLILpLGx5PXHfhusic7fh
	 wPbUq77yVmAM3V+i5dv8RDzRGw4DDf1cLVxQbc/MIT/7FnGcaqDGxX0I9WUuRo+jQ0VWU
	 AFpMwNLNM24eOQWcPuvI9kPwJv1RNrb/uCv535Nz3EtlWjWwhTyQWjbXLHhBDE0R6DPdV
	 LFX8JJMuAM8uYcJ15kZ/0TYjLGpfM7/hVVhcwe2Xd0C1oJT2QsaW2kQZzl6a/fryrP039
	 09dxOzADZyjcYMcIcOCv1F3dTd+H7J9I5CTtqb1o5HYnNy/+uRpqE7XjqkvnMXBcp3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPII08zR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7503606A320;
	Wed, 18 Nov 2026 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPII08zR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F401F000C4;
	Wed, 18 Nov 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021830;
	bh=IoMqjaz3gB2iO2fQI7dFnTGfp9sR61nqd19+pBvmbj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPII08zRWdbbnSV+EQhp8esfSOCtvCMSdSVNPYVvIJCCAn7kUSW2KcHmY5cuwZEO0
	 BuDXQT52PTBlnQA1PE3zkQdbyAAfD0dc4KxCZg36lfPxXsRJA/cIGLFho2fL8fD3Nb
	 e8WUzSL2R9dRI+dCJoUYBAB50FSSiUZkR7Pcrrbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Sengar <prashantsengar25031@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2444/2651] net: usb: lan78xx: avoid NULL PHY dereference in WoL setup
Date: Wed, 18 Nov 2026 16:01:24 +0100
Message-ID: <20261118150413.137463799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Sengar <prashantsengar25031@gmail.com>

[ Upstream commit dacb77e32e2bba78f90a8637fd27e13e2c9775dd ]

LAN7801 supports fixed-link configurations without an attached PHY.
However, lan78xx_set_wol() unconditionally passes netdev->phydev
to phy_ethtool_set_wol(), causing a NULL pointer dereference when
a userspace WoL request reaches this path.

Report no WoL capabilities when no PHY is attached, and return
-EOPNOTSUPP from lan78xx_set_wol() before modifying the wakeup
configuration. Keep the existing phylib WoL handling for devices
with an attached PHY.

The issue was reproduced using USB Raw Gadget and dummy_hcd in QEMU.
An ETHTOOL_SWOL ioctl triggered a kernel Oops with the original
driver. With this change, the PHY-less configuration no longer
advertises unsupported WoL operations, avoiding the crash.

Fixes: e110bc825897 ("net: usb: lan78xx: Convert to PHYLINK for improved PHY and MAC management")
Signed-off-by: Prashant Sengar <prashantsengar25031@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20261020201537.2465655-1-prashantsengar25031@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 2fed938fc7f41..af845623bf609 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1767,6 +1767,12 @@ static void lan78xx_get_wol(struct net_device *netdev,
 	u32 buf;
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 
+	if (!netdev->phydev) {
+		wol->supported = 0;
+		wol->wolopts = 0;
+		return;
+	}
+
 	if (usb_autopm_get_interface(dev->intf) < 0)
 		return;
 
@@ -1798,6 +1804,9 @@ static int lan78xx_set_wol(struct net_device *netdev,
 	if (wol->wolopts & ~WAKE_ALL)
 		return -EINVAL;
 
+	if (!netdev->phydev)
+		return -EOPNOTSUPP;
+
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



