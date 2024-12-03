Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E41F668D;
	Tue,  3 Dec 2024 14:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236421; cv=none; b=N5w5KrkKrrQxJsL7kuFS/SAdft+ZflymS1ljSRCo4IOJuL5/dIKvKc/5NjAA0WWEU9TdfoYRmKf8yDbxDGyxasM4qpYigx4kZTQ+ITIKkVIFBbhk9aNjQlridRNdeuSxmTN9dSob5XsbFOUMzqruQmKjI3XLBg1uKzDcHpBer0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236421; c=relaxed/simple;
	bh=vg9OOXxJUgd1jISEjWTnc8zDCB+/HseQJL+tSZ4fn40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLbdoZ3cF233z9r/CzeHmlaWM3WyuCuZdgcot4ev0XWSiKl1tVP8Spzu2GHaUZ1jfJEaMK8+KAm4vW82BQbBNMQ4aZjOUeCPHfHpXI/ibTZYD5JiQRfXAVnowJL2S1GapgoeDht1hxuvl3Nl0b4egbHQwbKmhqX4vt8OyY32Fxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCZAUQcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCZAUQcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59726C4CED6;
	Tue,  3 Dec 2024 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236418;
	bh=vg9OOXxJUgd1jISEjWTnc8zDCB+/HseQJL+tSZ4fn40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCZAUQcvdvFunv8luk/cgx+tNbdmyAjI2+F1wH9Cf8M7yo0HXoHG9CYbnXCzQf8AD
	 RyJOmhG3jB5Z3N3l9yaeH4ldAaNmSQAAvfXMC2ers1c7CzQRzC+kITaNKRAPu0rC+s
	 VeBgKbejR5NkUYCIC13StvhAF9g/id9Aa11wwWFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/138] net: usb: qmi_wwan: add Quectel RG650V
Date: Tue,  3 Dec 2024 15:30:43 +0100
Message-ID: <20241203141924.088948277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 57ccbc8a6c059..32b25462a573c 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1045,6 +1045,7 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
-- 
2.43.0



