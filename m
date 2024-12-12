Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFE216E3B;
	Thu, 12 Dec 2024 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021887; cv=none; b=mRNOb58WqCoo/VdhGYs93TKRsrU7gCX5hDV0F/j76QEFPhzDAnsQTFv8J6PLG8AN2qKQoYoyu2yGc97RSzpez4dJtj/8g0o4G7vT3g/DzSLkDGCJfwOR7zjc7QNhWEtczTwTPjYDRKk3A68vqJvsCbLIySWoKmEekD9LNoZfqv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021887; c=relaxed/simple;
	bh=LW6dVpuoquCt31Nmg67radDi6F+sZNEeqg9KKsjiWX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mB2PyAvx0T32IIEHq69Txw8xdus0bz0nqy7Q0qsnoU4kX22vVKaz88gOtiER/Wf1c5aVWs8/vhjdlgawfVIL4haa5fC65vikZy9oZIwbOyToM/D9KLy6MydnwUUxYsad9T8qInq/TuTFEnSUKaxPkRuQ40O2YVe+c4LzzXgcFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJ0sY9HG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJ0sY9HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4E2C4CECE;
	Thu, 12 Dec 2024 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021886;
	bh=LW6dVpuoquCt31Nmg67radDi6F+sZNEeqg9KKsjiWX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJ0sY9HGzYqrWESPeF64C+RBsgFcAFxaVbFQcD4dBqx30fHhBDQwxC6UaKpEQPEcf
	 2fBTagmHU2ZZ4FU21BQ+Atf1fjYpJH28pFbfpxL/T9YdrK0FHAw2s7NAnOQe6CSGrn
	 3JZ5q4Xx9LACRBIatc8/bNSDtyhNjM2WxSu6inuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/565] net: usb: qmi_wwan: add Quectel RG650V
Date: Thu, 12 Dec 2024 15:54:15 +0100
Message-ID: <20241212144313.866284253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 74e3ba53f5b44..758af6ea861ba 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1081,6 +1081,7 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
-- 
2.43.0



