Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020628;
	b=OAw6SsrHRM/DnzB2gsqicOk+co8yDVHDc+l/xb+C2sdpl7HuxhleBdcEXsaXBLMo1afP
	 FoLEND7cHDxrE41XHoRbpn2V9pYJabGCWJAxHqc2kwpFXkM/M/ZuOPjkozAsrZGs+z1pM
	 qc4NdWlLxafBpCR2txO21wgClEKe0ftzyTtRxsdQtyRDZOvE0J8B+cgijKFPdUkyX8gNK
	 sgz6DyvDmWfDNhzQjblab1FGES82cN8p+8nMEBaIEyqcMo+u7yaIvrp2GcKD8zKowrrRu
	 86Vfb3B926gf1GYh2WBE+HsPFlEEmmm56HlpekH5ErtuSl778mp9MckzyJ1Nhvb8n8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d0uECeuSFcJIn2m7wTiPE3TZtWGqj1vSh6as9shuUvQ=;
	b=ziApghopX2V7mC5jvT1HgvsSCRqxu/5S14jh48NjVQoA4KWRz972Ie6cksq2hkZmgZ/C
	 9jLfrjc5hhOGjaFb70Y/b1bM6bA6szh650iAt/Lh+S+GbyQcBvprjnAjI3GInA9u06hG1
	 /QOH5RMwA1yylt8XnYo23QNlDyNsWMSQrv6jrJ7TTBECn/jNwoNvWjk/mXec+N/X8msv9
	 5RPTApW8T0v/rP5DVDatq2nNrpyJQnfjN/8FM37MYlbSFBTDPFGenedYf0yntRKVsjOQl
	 3GFdDDTh1rR3eOREESpkcwScfWk/gt11ITEueDDn9S84B5rHTxv/MQpA5NxWh7WOmZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0n87qij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262C606A32A;
	Wed, 18 Nov 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0n87qij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6D1F000C4;
	Wed, 18 Nov 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020628;
	bh=d0uECeuSFcJIn2m7wTiPE3TZtWGqj1vSh6as9shuUvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0n87qijB05SIL4m0SwFR8MIuV7RtC8car/70PsYo+TPzf1mFMEcUcvPcv9cg0t53
	 0RvDOKpJb/OwkCJUdV+aPvCpKDrNyblNP95hb0KuEwqy5Q3mbtWQ+HVG3XUV0x8X5Y
	 fzqlsythTbyH3Q1DjOpsZcSN2dv5lDobWN/BXI18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2020/2651] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150358.939117267@linuxfoundation.org>
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
index 5655941f14783..2fed938fc7f41 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1712,13 +1712,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
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



