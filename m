Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618236;
	b=cnOl0MKj+0s6CBhD3l/+lpNGxtUSRM+u2p1iLpV/yMPWX7YhcMrsmOL1E2HqWgM3h0Iw
	 DmKT4jOJsjpzp/HPNIjMOVUsRWL3fHQnBK8YGw5M/Zf7UsI+wYXAyfh0exdzE4FiHVR0X
	 0M+dbTmUiB1yq4BIxob8wuekc2AQIUxaX3pP1qWxDgrOj+Rcx8HDaUE4O+mgPl2z8fzYC
	 Zto1LuDdaxCldwOdMsWFiIGhU62HCfPCmgJtg4tYoOQ4Aw6CEDdByHhn6Sn5RoTrQmFFD
	 kaT3sl2/uFzR3oyJNftmx3l6gVsQpMXscWof/CpAxlhxveMNVIr3KZMJNtGt2Gdox9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j8AX5ErYCqcnGgfb24JSlsg3ln4GN0KEv6HrKbCQ6eg=;
	b=3QWuGY2+RYRlTVohn7VD9D+FcB3LM1zlCE4iGbIFZOzt18Ng+6jAOArNCZ5ef5Fnq0Jj
	 SrM8zh/ny7uehYCi2jQIWmCZRQgyZNNDUz6LE+29qnI3bhguzcGSBjUysbZMbq3IYOFoU
	 eVcNtRLDN/iqyrC7lKXAEvE5Go6XkRNtjAXs7uvLXa4FWF7MZHeBrh98N9zG+mceNEQY8
	 iUqAdwyZeyzPdtvQZNrGX5Mpt9eh+pRnXEKbUv1F66WKOORRKXKFfzHT3UGiLsgu3COsr
	 cqN7+cEmGuIKbN0EZ36zHLWaOIouVttbHh/v+h4Z7cIuud0BNfztkZQIBcE3QxBrMcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7ZRhUDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79357606A321;
	Wed, 25 Nov 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7ZRhUDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7841F000CA;
	Wed, 25 Nov 2026 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618236;
	bh=j8AX5ErYCqcnGgfb24JSlsg3ln4GN0KEv6HrKbCQ6eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7ZRhUDwOEF94L9+OXI4q0wf5hreDCQmx/vyzjsPbi/YTcSg7zsYZcrIO6DOKsn1d
	 ES3fIWTeN6955Yrgev7ltQ9FEfTVgr7C99EQgSeNAy8gTzWNoiGKT1v4YLzppNbpnv
	 AWtGFi+NhFFvGyTG+BaxhJSNiZxAidiRDkIc6tzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+583f42a41879bb60de32@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0170/1005] net: phy: dont require RTNL to detach a PHY from an unregistered netdev
Date: Wed, 25 Nov 2026 15:25:08 +0100
Message-ID: <20261125143825.723930261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit d1cf56164dc25c2c54853b23eab42369f53c8329 ]

phy_detach_internal() reads dev->hwprov with rtnl_dereference(), but
MAC drivers commonly attach and detach PHYs while their net_device is
not registered, without holding RTNL. Before register_netdev(), a failed
phylink_connect_phy() or phy_attach_direct() unwinds through
phy_detach_internal(). After unregister_netdev(), a driver's remove path
may call phy_disconnect(). Both trip lockdep:

  WARNING: suspicious RCU usage
  drivers/net/phy/phy_device.c:1831 suspicious rcu_dereference_protected() usage!
   phy_detach_internal+0x6a5/0x830 drivers/net/phy/phy_device.c:1831
   phylink_connect_phy+0x22e/0x2b0 drivers/net/phy/phylink.c:2452
   ax88772_bind+0xbb1/0x1520 drivers/net/usb/asix_devices.c:925
   usbnet_probe+0xbb3/0x27e0 drivers/net/usb/usbnet.c:1812

syzbot hits this with an emulated asix device. phy_eee_rx_clock_stop()
fails on a USB MDIO error, so phylink_bringup_phy() fails and the PHY is
detached from inside usbnet_probe(), before the netdev is registered.

hwprov is only set through ethtool, under RTNL, on a registered device.
reg_state also changes only under RTNL. So if the device is not
registered, no one else can reach hwprov, and RTNL is not needed. Tell
lockdep that. A detach from a registered device without RTNL still
warns.

Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwtstamp in netdevice")
Reported-by: syzbot+583f42a41879bb60de32@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=583f42a41879bb60de32
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261029142423.93573-1-ngocthang2710.1999@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2827d2226d6a9..5ec2bfdb23370 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1767,9 +1767,13 @@ static void phy_detach_internal(struct phy_device *phydev)
 		struct hwtstamp_provider *hwprov;
 
 		/* hwprov may technically be protected by ops lock but
-		 * not for devices with a phydev, see phy_link_topo_add_phy()
+		 * not for devices with a phydev, see phy_link_topo_add_phy().
+		 * Drivers may detach without RTNL while dev is unregistered,
+		 * but then nothing else can reach hwprov.
 		 */
-		hwprov = rtnl_dereference(dev->hwprov);
+		hwprov = rcu_dereference_protected(dev->hwprov,
+						   lockdep_rtnl_is_held() ||
+						   dev->reg_state != NETREG_REGISTERED);
 		/* Disable timestamp if it is the one selected */
 		if (hwprov && hwprov->phydev == phydev) {
 			rcu_assign_pointer(dev->hwprov, NULL);
-- 
2.53.0



