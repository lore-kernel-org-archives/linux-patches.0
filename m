Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2698B47F53;
	Fri,  6 Dec 2024 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496465; cv=none; b=aKMQMZ2NDteBY28BCUB3flY+RW2cmP5apyEWk4ZJBe8U5YJRpRnI+fcAuX4hEji9g6wRpSZ9NwoLgiTT1F8GryH6bQjkfY3/o4a9sCmSX20JwZuqQfdr2JSOVtkHxYa9DGPS+tiIoGKWB8GVWXhiu/he89zBY8UOA0fRt6uxSxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496465; c=relaxed/simple;
	bh=PtE3AWoKiAzlem5yGQAfeHCiJzkA40BkyoOePYmaWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQJvhPHX5UerVE6WdbKrHRHIwwk+vD+svHfq/CACWwEoNGXOgZfQiwXhlWw821vPHlzz5CtJh+J3dfvG4+xFDvdGJON1t/UTsHgCdXkvQQe/0qpnxT189agF0BpS7JAznH2+bHFzW9bghJpSCj6LfPxcHP1bYU9CqYkXHrLU8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILYaeH5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILYaeH5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86035C4CED1;
	Fri,  6 Dec 2024 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496465;
	bh=PtE3AWoKiAzlem5yGQAfeHCiJzkA40BkyoOePYmaWVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILYaeH5TwKuoDfx3HqVg6kIJoFZqcrWA8pAOu/DKTtmFBLPh9va89WCAvnSgQi+Tf
	 g9QsjtZDnJc/CS1eYeXJi8GsZDItigd6kfI3BLHzDbGMHKxpFDG7RRf1uz8iBeR8y7
	 luGTap82BtS4dKim1l7Ov6aGT5Javom9BXad9zdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/676] net: usb: qmi_wwan: add Quectel RG650V
Date: Fri,  6 Dec 2024 15:27:13 +0100
Message-ID: <20241206143653.915077754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@gmx.fr>

[ Upstream commit 6b3f18a76be6bbd237c7594cf0bf2912b68084fe ]

Add support for Quectel RG650V which is based on Qualcomm SDX65 chip.
The composition is DIAG / NMEA / AT / AT / QMI.

T: Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D: Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P: Vendor=2c7c ProdID=0122 Rev=05.15
S: Manufacturer=Quectel
S: Product=RG650V-EU
S: SerialNumber=xxxxxxx
C: #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=896mA
I: If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E: Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I: If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=9ms
I: If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=9ms
I: If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E: Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=87(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E: Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=9ms

Signed-off-by: Benoît Monin <benoit.monin@gmx.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241024151113.53203-1-benoit.monin@gmx.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 2cf4324a12fd1..89775b6d0699a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1084,6 +1084,7 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
-- 
2.43.0



