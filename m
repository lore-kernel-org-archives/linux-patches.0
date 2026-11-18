Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050045;
	b=cyhm9iJBfveQDeO6rhCR7IdM8MRz13Pzmdkkayw4YQ8cW+XB7XULQIp6fDUAULChMizr
	 SMtJcsIr0nCC2x/LeHRYxkK9JQlVJ6zXgxd30uwXagqhxLZQep3w4bhwVtwuK0mM3TFpb
	 cneSDR2YymvtE/ou5hOO9jOWbFt86zcnEfqpcfy4XmBB8KVNZrGwnumsM+8fai42PGc66
	 uXslbQUvM80ykr1TnvIitMUPStM65nTZ1mpPuQy92DfIa331savX9Lr6H3TvA5mQmQUeZ
	 kjVlwsbbyTA9Fd62Yd7YaD0avJfXYHkg4RQZpPiJVS4o2MRSo2YzaF1Sp+f90OlJmcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vyFfuce2YOv4GNujtm/W7ug+C9BOMFWf2z5jI1/kpgo=;
	b=wrJt00uTDSQ4dLNp5kPcEqOK4HWXbX6uW37kMIYZEHcQUEG/r0z4z/33gQP0gGb0Elxb
	 mNvZSWB0W9gUitLyISRcOIrSK1XA2DNLxFR8pPNePwmQ1ehFonkabnTCsUr/q3K+Mv+QN
	 JHbAZquQoASbUDlg6Wlvs0jLGI9/dbaGVEE09CMs/GASpl64YlXlnDwqgXgB1T4zmFnQn
	 2EPbzVQQqk8cMb12ym9VE3YWn1FYrOAVsTC2Z6IdZEROdrnGR0tiTmujH3uS2+ObhBL62
	 BtDu0Py5G8DyiBk/CpY5tlx/53PIA4i9DAKdmF1CKJ42T4GBEgmFu5XWGb5/VyXcBhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pD8OG6cY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF75606A32F;
	Thu, 19 Nov 2026 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pD8OG6cY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204851F000C4;
	Thu, 19 Nov 2026 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050044;
	bh=vyFfuce2YOv4GNujtm/W7ug+C9BOMFWf2z5jI1/kpgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pD8OG6cYotPa+/kyUWI2VUZHicsROSazbODSeYW/V+yf4qpfnHuehOwAQAhaRAX7E
	 lt9kttsc0/A7YO/Se+cenjQfJWDxjvtMZeBcuvKNLClZcYsvE+GeJ3nhmTbw/wuXNc
	 uBVRmybra+Ak99UoENRJnC6nMsaZZBYQXTkW87G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2567/2857] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150333.916316729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3b7915b79af8c..dbc0bae2ee19e 100644
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



