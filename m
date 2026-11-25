Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622062;
	b=BzOec0PSdVW0HcVRUVA13eIcTCUhgOi6uOsDXNUis9OtCEYF09oCLF5NLYBzY1ztiMwq
	 UdUaG5eAjN6YGGvZ96QetLFfYO7QRVKnaHeI6lsjoYk0GHnXhMc/wkfbCClte2ppk3AB2
	 P2Nevqb5f0D7SEUDk3sLRaWRu35H0J/AKc0r6q/FWKD41GmMY+VULfR45Tq7s0Iky5MC/
	 t/QXDHeEaR/UD4a3S357myXLHINwinjQwdysz54WvP7HtbYVxuFBmwfat/HpfZYAoTn1q
	 0iPOtC7TZxoA7V55X8jrr0kQQY9bNincCEMrdZYLB1gu7bOVpY/0btcAXbfET6VQX1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h158Da9hMF1pQv4LQyVi0x6Uek8d2CG8ubSEF9Ddgcc=;
	b=oESO239X+l6vF4uHWPbl9AcjZ0KPn4/gP7LqjvHV4kXt5pg4vGfGX6DAqZnhJ7W04mzU
	 Ckvhlf7smR9QWt2ciGMnqm5ncx4391cdywzqxLUZilL++VB96zpplTKv4kw30c290UnrB
	 fUzRwm/DuWigoJD8DtLYtdfh4j7txuN3T82SJ02MNpj1uiigryVYZI9ZIzV7PfIDOPj7M
	 XdBZna5piQw/1FoHNM9PyOmWnVquNmFM+vJhKqq6Gq+GfX8phDdi2Jpwg+0EwpLWG2z5T
	 I28HUfAK3nEJ6kqeFuB4s+DkuMtIvoPkYQOt+FU/AGSaS9fYUB97IBFYq+knR4hC4Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s7LpEn/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B96D606A689;
	Wed, 25 Nov 2026 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7LpEn/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C21F000F4;
	Wed, 25 Nov 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622062;
	bh=h158Da9hMF1pQv4LQyVi0x6Uek8d2CG8ubSEF9Ddgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7LpEn/EymuXaz1gghRepZJCSy5CpHrORX2Y7zQvaeKoGVcGdlWr9fMsuPSDY9bWZ
	 0pf7buWegFeYiM8c2Csa3oO6tDZ9QgaS9eHlTrKk9vW+E5h0ZQUQuZw3Fh0D8lz1mZ
	 Hfm6IsRKpPISM4dOCkYT+koMWzu5G8Ybz5uhd/yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 401/990] net: usb: lan78xx: resume phylink on non-reset USB resume
Date: Wed, 25 Nov 2026 15:29:28 +0100
Message-ID: <20261125143831.493087760@linuxfoundation.org>
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

From: Stefano Munari <stefanomunari.sm@gmail.com>

[ Upstream commit be9587c47db16faaca5415f533637755c65a4eb0 ]

lan78xx_suspend() calls phylink_suspend(dev->phylink, false) on an open
interface, which always stops phylink and halts the PHY. The matching
phylink_resume() is only called from lan78xx_reset_resume().
When the USB device stays powered across system sleep (e.g. s2idle) and
the USB core calls .resume instead, the link stays down until the interface
is brought down and up by hand. The ifdown triggers:

  WARNING: drivers/net/phy/phy.c:1670 at phy_stop+0x44/0xc8
  called from state HALTED

Move phylink_resume() to the end of lan78xx_resume(), which both resume
paths go through, and call it only if the resume succeeded and the
interface was open, mirroring lan78xx_suspend(). As a side effect,
lan78xx_reset_resume() no longer starts phylink on a closed interface.

Tested on a Raspberry Pi 3B+ (LAN7515) with s2idle: the link now comes
back up on its own after resume and ifdown no longer warns.

Fixes: e110bc825897 ("net: usb: lan78xx: Convert to PHYLINK for improved PHY and MAC management")
Signed-off-by: Stefano Munari <stefanomunari.sm@gmail.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20261102235133.23011-1-stefanomunari.sm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 133ea36388147..785d356a8dd5b 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -5377,6 +5377,12 @@ static int lan78xx_resume(struct usb_interface *intf)
 out:
 	mutex_unlock(&dev->dev_mutex);
 
+	if (!ret && dev_open) {
+		rtnl_lock();
+		phylink_resume(dev->phylink);
+		rtnl_unlock();
+	}
+
 	return ret;
 }
 
@@ -5391,15 +5397,7 @@ static int lan78xx_reset_resume(struct usb_interface *intf)
 	if (ret < 0)
 		return ret;
 
-	ret = lan78xx_resume(intf);
-	if (ret < 0)
-		return ret;
-
-	rtnl_lock();
-	phylink_resume(dev->phylink);
-	rtnl_unlock();
-
-	return 0;
+	return lan78xx_resume(intf);
 }
 
 static const struct usb_device_id products[] = {
-- 
2.53.0



