Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619550;
	b=2uRctJJk5PpgQ0S6TFW79aOy4ebzr9plooBkONm5pAOz73Vnlk10mhrv6AGcy3GGCzjo
	 zYKv5IGxXuTKpp5HSgckigbq1jAyHIeqytMO6HRm3H9ZxLXj4CQOjRAv3o0K/bSLIAuX4
	 z5yUHwH6NWd0q9Gs6QZhPA6+Ut8gcrIQRjzoC44Xfxqqh2KD7cnvqHruUXxt0Rs1ZmD1x
	 EH4vNmoWUAkAMjJKHZ53LOaRbJZq10j1H5NykuHSW/6k8d99yc6sZ9PRVDqU2QYSS8SWZ
	 y3SLHuy+AVKwJf2li/19txvUJ///KUg3SjWgjbVjC2uMCrejVTMHgnUtB91zEwdqafg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+jwiQlwJGNuxlbVtkPZ9vk4yODuF0rFmFzFub5Cj6E=;
	b=FB+8Dc3f0WryOkpO3tZeyn79vupSZ70N1MTDWMVtvLJJiG7VftAJ8WtZAtr/BPGVRHg0
	 3nIs6cNVBixp3CKoeRUGsBzvaXFfiSeUCXyaA6Ahi9vx0i1QV8Lb6I7LTbU/XJE9F46HT
	 yv6s0DrcaADqtMThmAK2+G6CgSz2mlhd4Vf9bpJ/mB8hqoiOn4CYGjDnxyApojkHIb212
	 OnikyOzEEDBox+lUtrnpSzu9RV2cIQBiz7KPKh9haeEehlCeoAvUCM894TYXPNHbsAaLG
	 DzzM77tRduLk9J29ZaXiUOsBa62eiCc6TZYFg3DrX3WsTc1MWP0x/ceBJDONfXeURyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L4/wZF02";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAB3606A326;
	Wed, 25 Nov 2026 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4/wZF02
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8251F000C4;
	Wed, 25 Nov 2026 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619550;
	bh=T+jwiQlwJGNuxlbVtkPZ9vk4yODuF0rFmFzFub5Cj6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4/wZF02O5rwq5fE4JLLekjW7WAt47sfwqqQPyeMb72jg2op6KIU6mo7/zQcdPZmI
	 xB099CG65xqGuoqfl6FWUU2LNnpATRTXzSNnk0JPy1uTmLQN/artLB5a43NZfyaa/r
	 /ZImw8n9TbZSOJhd6MJBGJcIUXD+WGPv3FFsIqO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0632/1005] net: usb: lan78xx: let unregister_netdev() stop phylink
Date: Wed, 25 Nov 2026 15:32:50 +0100
Message-ID: <20261125143836.555380299@linuxfoundation.org>
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
@@ -4592,13 +4592,12 @@ static void lan78xx_disconnect(struct us
 
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


