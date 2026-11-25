Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618985;
	b=uiY4lmQeDPT6uHRndlovoRd8uAv7PTjfGB34+Pw8zVgJwBrSYpDuiqRfELv2+X4xjgBw
	 GFmPMFEW23unVOm6rMbAX9WbYsnCFjXaJsFdWrLXu0rYpAz3UWKhtr9mEuMIfj7jXiva7
	 CuCvDWMdsEko9VGK+ihPU7MsmjbxW/KP4qi5dTq174v5REQ0CBixMzpMM8y7siBfUFGp4
	 uTAm4vXIDP3VMpaZaClS4RGq6husc9ps+yNm+2URzr117t2Bs5lqsTDIQ6LYn6QhJCQ6G
	 DHjLnjfG5iGgEBbzodidelG8SHvuAeyxNVArhDKOjcliZkuGfj9bap74e+VYdcOalOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L72L/4RNg8bcdGiWi1VR/fQdQWqwCN3r+9SrBlyBO6k=;
	b=LONVmXAsS5SkXUyuFvPCCKQlD5cms2TiMHTFVFiPSi8/PBwm1P9LsdJ5WAbHHVEqtEGR
	 4fYXQWzZWT+CEXhZj/bf7wKZyNOveWsWFbwYtcby6IjQXZkXyQTpjqmkm7FvK4xp9lPBK
	 UjNNXYDfsvMx7Fumo+z5HU0fUVaWOxW7Y+D7x7oxSxN7cUPlH+ZLgnK993Zk/UfZj1anC
	 QJBaFrl1VJ9DPaxIckbUg9T4kvRQdNXUhv0pY6OZ1qjhP8F1Zkkcie6okovpdH8+z4qhC
	 feGwoP1C69AB79ymYjphiQTQoTAIvT9os2hXDtwhybP55OrjSMj2lJyEYfcLl+UFmxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZy3+VnA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED76606A321;
	Wed, 25 Nov 2026 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZy3+VnA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7471F000C0;
	Wed, 25 Nov 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618985;
	bh=L72L/4RNg8bcdGiWi1VR/fQdQWqwCN3r+9SrBlyBO6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZy3+VnAyNE87bPElBsN6D/nfcMrphjAycPERFtpIuLdt9I1ZwwdPF+JYXc3BLsbV
	 t9oXwN2ma7FLRloGmpBd1qK83OmWebpf1kR7twgO/PNwiHmRFgMVQsBSIRyc0qmWQ+
	 VnMnyhaG7+ajIbDz6PtDhL+RGIJCR76M9WASgWbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0450/1005] net: usb: lan78xx: resume phylink on non-reset USB resume
Date: Wed, 25 Nov 2026 15:29:48 +0100
Message-ID: <20261125143832.289276903@linuxfoundation.org>
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
index af845623bf609..e170c1114d8f2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -5370,6 +5370,12 @@ static int lan78xx_resume(struct usb_interface *intf)
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
 
@@ -5384,15 +5390,7 @@ static int lan78xx_reset_resume(struct usb_interface *intf)
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



