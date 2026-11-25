Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622949;
	b=hJEOv5g3NcE+nd+Yh5utdgcvYbllMEykmbck5klXwVXeoCAQDyLKsDo/ACIkAC0YKoGk
	 hKUZ6jy/vkSihUYdLgMNpVxB8xBBg3u/yxF98kf4YlLGMxN+4JJ8Bt308e7/v7j1fb+Cm
	 STDHqkldefJ+RUzxwi3zZtz0EiTFpALHs1LnftG1C/as86zpeCtgQMOcWxHZzvrIRMDED
	 4CmXcF4tufNbG7DnpUc0BAHH01otBBJa/M73Nu7iyCa9WUDjxgtLWwes6byA+TsQJ5M3M
	 naRI/Fj5Y1EbnvNkE3YUK03cPB9mqCJm3FaHW1Az/N+TtxVO6T5dNOEhDxLlJ9aiMJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hi93+7zxYBHN+Ijw8XFAmp3AjM7PPoWwT/wjFZq6NM4=;
	b=FzuxOqb1Mjq5Dzn41N1CIdRHrndPuDB/a84viIC82p5Cv+dBRi1J3PdSdEjkm7PaVSr+
	 jqH8nhQcukkqxjPd4v85NsSzGYcDHMeD3HcvoWGnTrexyk87zA/V/tXEuo3XQk3lwGyrb
	 cxLb5PvCxqOSzvPW578ybvltw6+jDeI83fqwMWt+Y1YotjJwE5a8jw0fwaeG8hI61auJf
	 VHUfh8W6W7Z+yJGQz2BxSsFI+oY2Isi76OUReAJoq9lEoS0WyU1bbAJZMfwJWcukozTiL
	 zk1lkmYEx6guGWIgkWmDt/vmNxK6U2c1QEQhu5AemLT3jAee1Ly1kbrQI/l1AUdz6zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZ0z7M6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15224606A321;
	Wed, 25 Nov 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZ0z7M6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF591F000CA;
	Wed, 25 Nov 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622948;
	bh=Hi93+7zxYBHN+Ijw8XFAmp3AjM7PPoWwT/wjFZq6NM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ0z7M6ekf662A2bPtt/ghqtv6YVQtc6Ajz+7tP6HnLUSnNirFvMR3ePRUK5EpHC1
	 UCsTYXifZiQGX/XmX9HpqGZ8LW77T/pf5YJSreHTk+ZSLulGuWCivyNGSTa7CQFQ6L
	 CveHXTo+AEO+LmBIXbJE0j6UGsfM85cKRLAD1nX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 702/990] net: usb: lan78xx: let unregister_netdev() stop phylink
Date: Wed, 25 Nov 2026 15:34:29 +0100
Message-ID: <20261125143838.525770434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit 9280128245612b30ca4a238daa6a777b0f4e583e upstream.

lan78xx_disconnect() stops phylink before unregistering the net device.
phylink_start() is only called from lan78xx_open(), so when the device is
unplugged before the interface has been brought up, the attached PHY is
still in PHY_READY and phy_stop() reports:

  called from state READY
  WARNING: drivers/net/phy/phy.c:1670 at phy_stop+0xad/0x380

The same warning is emitted after an ifup/ifdown cycle, where the PHY is
already in PHY_HALTED.

unregister_netdev() already closes a running device, which calls
lan78xx_stop() and phylink_stop() with dev->dev_mutex held and after the
URBs have been terminated. Unregister first and disconnect the PHY
afterwards, so the interface is stopped exactly once and only while it is
running, and the net device can no longer be opened while its phylink
instance has no PHY attached.

Fixes: e110bc825897 ("net: usb: lan78xx: Convert to PHYLINK for improved PHY and MAC management")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20261031165213.2738-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4594,13 +4594,12 @@ static void lan78xx_disconnect(struct us
 	udev = interface_to_usbdev(intf);
 	net = dev->net;
 
+	unregister_netdev(net);
+
 	rtnl_lock();
-	phylink_stop(dev->phylink);
 	phylink_disconnect_phy(dev->phylink);
 	rtnl_unlock();
 
-	unregister_netdev(net);
-
 	timer_shutdown_sync(&dev->stat_monitor);
 	set_bit(EVENT_DEV_DISCONNECT, &dev->flags);
 	cancel_delayed_work_sync(&dev->wq);


