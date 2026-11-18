Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061791;
	b=0xzk/gdw3SKKpKJ07Na2LMBxZcqY8hIKRVAJkJ67j5DIDPDJQ882rNk2LVFbakOU7B2g
	 VA9/PkjOAGKAU4i0pP0+jtMsmXuafEeAYoF/5X+HHapRLQbTP7UedWUrtYxRHPbk+ujOh
	 ixlDy0Xvt6fWPT9/crSHLpNNDeZVRGthV37PR5UU7RAFYpoagi2z8fbLfPWiUob0HwSaF
	 b/Hn/LOdwzMXo2Ci8sJU/kSOuGz8Vm8ILWomKGvh45zIeFdI14r23/LTFMH3pzUmigNoF
	 Y0Qr2BDX/CTXm8PhkLLyJpYt9Be+fZmZY8m/L/7E/PlUjapeFwiBjbNTksl6PKkPL6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CW7s0UUERgTF3tqcvenlrNCHoOjsR1cxEOukzkLV8EY=;
	b=NpM8q4VOQAoWo6+Mcvh5rsbzAh7I1aL838OhtcDV9ngxQ/HbYa5zE0XWMqVcRKidECIG
	 /DRUkjPxZKg9Li5iWLNZRtfqOhUeciPkI9X+4gqo3neTXF/PmwnoyS0+Ch6L9G5XcFrre
	 N9JeywegstZG7hBWKRtPyfSP4VrhFUFnhBO9N4o0P2SV5wRm7lJBCT1l8kXJ/d+8XUC1A
	 Dy5D+4v5GIu3mhtZKvDQm3hPnigmMe4FZsw5SU6qZLg7A79x2GryjMz2KA5eJonPVsQRE
	 w6xuSIOu+MiADJSeWLdflSNa5zhtvkr9jfYbehycE4wb9my1hKOAIKlkv01hbYQnqNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Skjhp77o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EA606A320;
	Thu, 19 Nov 2026 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Skjhp77o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EEB1F000C4;
	Thu, 19 Nov 2026 04:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061791;
	bh=CW7s0UUERgTF3tqcvenlrNCHoOjsR1cxEOukzkLV8EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Skjhp77ot9KxUMcUn7RfwRK4rjmhTlifkPSr0JPB/mP8TygZl8Zq5e6xGMDK4aFX3
	 npQDrYxgsHzbaFLpR7Vq8etkMwCE0UftlN2guUOXk22AecP95gWoBvwff/PCMomS/V
	 O3azee4dR/BCKoxzKFjYUSzu9pAQ6hiGbFYCyu4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1678/1848] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 16:01:56 +0100
Message-ID: <20261118150030.041855713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Munari <stefanomunari.sm@gmail.com>

[ Upstream commit 9272297df14124fe603c81e40b52ff0c5dd88652 ]

The runtime PM handling removed the -EINVAL return for invalid
EEPROM/OTP write requests. These requests now return zero from a
successful usb_autopm_get_interface() call, even though no data is
written.

Set ret to -EINVAL for invalid requests while preserving the runtime
PM reference release.

Fixes: 8a7ffeb795f8 ("lan78xx: Fix for eeprom read/write when device auto suspend")
Signed-off-by: Stefano Munari <stefanomunari.sm@gmail.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de> # Raspberry Pi 3B+ (LAN7515)
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261010213248.15938-1-stefanomunari.sm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 7306a5c79180c..9ee96cc085641 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1374,13 +1374,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
 	/* Invalid EEPROM_INDICATOR at offset zero will result in a failure
 	 * to load data from EEPROM
 	 */
-	if (ee->magic == LAN78XX_EEPROM_MAGIC)
+	if (ee->magic == LAN78XX_EEPROM_MAGIC) {
 		ret = lan78xx_write_raw_eeprom(dev, ee->offset, ee->len, data);
-	else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
+	} else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
 		 (ee->offset == 0) &&
 		 (ee->len == 512) &&
-		 (data[0] == OTP_INDICATOR_1))
+		 (data[0] == OTP_INDICATOR_1)) {
 		ret = lan78xx_write_raw_otp(dev, ee->offset, ee->len, data);
+	} else {
+		ret = -EINVAL;
+	}
 
 	usb_autopm_put_interface(dev->intf);
 
-- 
2.53.0



