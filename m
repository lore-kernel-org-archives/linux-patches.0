Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147811F757F;
	Tue, 21 Jan 2025 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482968; cv=none; b=UBcib4dq23HY5huAebu5kTsbCGpHwHoz6A0mMDT8HLpNZ2WkzFc/p+cyiHJzR+Hn/l3CJWeIZfi7YO/u9QN3dNLwvLXmVSsNTtGuF53l/P628BOA2CnfN77RKBJ1yxdCO/OVFCmWBNrVH5Jd9k9C8hTBulZaDxW8ZGPx2GKVFk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482968; c=relaxed/simple;
	bh=DOI2kV2Z/Ogbzfr0jg5Q1HUke2pE4JWzLWYmNYYJfsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swhnlo/6I2TA+fX1VlofCiqX+2p8wVlrU4RaU4CdaBNMiWE8+nOD4Keqkj4qPtJ1R1pEZY22p8sJANU/gn68gdGP8JUmHGsdf+Vq1Q9yF7JRvPrR7WLxui50TjFKE6wiq2MxfLazRpPolNRgCxtm6vkhPzSnjxo0oNnuND+afGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD9Bwm0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD9Bwm0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8064FC4CEDF;
	Tue, 21 Jan 2025 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482967;
	bh=DOI2kV2Z/Ogbzfr0jg5Q1HUke2pE4JWzLWYmNYYJfsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD9Bwm0GfSN1mlQ2HwtPWPCjbLsnYmRuI+65pOFVErqVjPRDWSLpKhqALmgaWrAM6
	 XAzA5/kjgXKiuIuBEj4J1Anc4l0LzpBEKPWW220o0h1nX02C4fckoEstDcYhQaqVCh
	 DnHCM4DEE4DAdZ0vI5odlQKs1QVeBGzj+Nl0gRio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hrusecky <michal.hrusecky@turris.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 040/127] USB: serial: option: add Neoway N723-EA support
Date: Tue, 21 Jan 2025 18:51:52 +0100
Message-ID: <20250121174531.223530315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hrusecky <michal.hrusecky@turris.com>

commit f5b435be70cb126866fa92ffc6f89cda9e112c75 upstream.

Update the USB serial option driver to support Neoway N723-EA.

ID 2949:8700 Marvell Mobile Composite Device Bus

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2949 ProdID=8700 Rev= 1.00
S:  Manufacturer=Marvell
S:  Product=Mobile Composite Device Bus
S:  SerialNumber=200806006809080000
C:* #Ifs= 5 Cfg#= 1 Atr=c0 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=03
I:* If#= 0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0e(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=88(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Tested successfully connecting to the Internet via rndis interface after
dialing via AT commands on If#=4 or If#=6.

Not sure of the purpose of the other serial interface.

Signed-off-by: Michal Hrusecky <michal.hrusecky@turris.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2413,6 +2413,7 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0640, 0xff),			/* TCL IK512 ECM */
 	  .driver_info = NCTRL(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2949, 0x8700, 0xff) },			/* Neoway N723-EA */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


