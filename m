Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041883;
	b=JDptJziwyWW2GUf5puvv02oaqXt0M1mW8Y1jl1SbBq3PRTrZLvukI7ux6+w/lvHkFpSY
	 luN/9zoGzQIAkUT4l1aZ71Rnl97bYjm4k4jyZHItnZnqzZF70AkBDBzCLv9bdWErPuzRD
	 DVcoQgBIuIwgc53kPxI7IZ+t6bp5ROgbifYNWj3BqXfh36ZNGgMK8BxKyMdGVo35mbSce
	 2fhQdm4De8acRp011n6RPWz0lmMNLN8784dm/dJ99Y2cd1awsCbc6Sc20Wgd2EFt6yee5
	 hxY8WyWpkX28tQlhl+/GwDadWehVBPjbFkSCeVcSqiMFCemGrf/m6KmA7C/wyQ1oVrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UTZkQ5hpkBQ8i084gHP4pW8BPuflkIb21POeZpy2Oys=;
	b=2+9lMEH8B+S0YpFmmYZTNO3b89QXOUWs5WWNSEedFHsTFGVfPfSilddYedm1aY5dEDDf
	 bo+SnqKBW2fE8TLPTNVGIKS+HisBRh+QU9uLYqm90TrmS4vBd/F8act4sXKzRSdwc0aOI
	 Y5IHE7IqlRDuOHK2FvlzVzcb6+icfxCF6PgzVqYM3U3qduX/s3EQ7Nl8VqEZ3h1DLdRzJ
	 J1D2UwMeUzZUsh2qt8gHUc5h73gBjGzt/ed0cpZOG970JPOum2VFuM8vPJzbUh/zag4w0
	 TjC0qTQE0ti34CeTIovR81rjH4PM/C16x1ujV9P70TC5jr6K9e2qLkV6Pow8nZXCn9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr8F138i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0969606A31C;
	Wed, 18 Nov 2026 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rr8F138i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499D91F000C4;
	Wed, 18 Nov 2026 22:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041882;
	bh=UTZkQ5hpkBQ8i084gHP4pW8BPuflkIb21POeZpy2Oys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rr8F138iZ2B3p+ZfK0q3/tLoEaGxPxXZ8eCXUaRWVAQoVeluhnv4yUmoPPbcyuMan
	 PqRs4m3IAq/euzWXv1agJhno8OBDoqqmbKqssyAab9ymeyRBgX5PpWBjv8XQHD31ky
	 nM3iFqY9tptR3xyt6a5qm5Jbd9+MPWctcakRDlKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2971/3318] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150449.415211667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 36d20a952b032..919f25aeb4b2d 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1745,13 +1745,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
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



