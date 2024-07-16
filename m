Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B4627733;
	Tue, 16 Jul 2024 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145010; cv=none; b=lq1VSqxD1FQhaR3OdztKvncyjJW537BNqVxzPRuE+aJBf5I7PsZNflbHENPeCZr+KBg1Cl5RyFIfcbcXtk0tiFITH4p1US1GMQ7Gb84mLUHtaP8sAh7ALPcSe+zs8RDxFzhvhffA6mOcGRU16I0hUE4suJhPRwts8hGaNFLLNIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145010; c=relaxed/simple;
	bh=h75ehIqoW2aWoQ4pq0SXyaGw8dgivVcY9sUIF/FB4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRhoBYahVU8JCi7p2l+ikaNpGYUPWkhS4ZWS239Cwe5zuvjPmGChxw4DOHu+6/rsRSrp/B135vl7rJ341WJNji7Ld49K38Z/vJ8JkZSN1SyFkHTI967UUIJu3FwH3/f0Tf0YI29e+nwliSwkowO5ntgJUo9ae69eVH1ZLuUQqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgRA6V2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgRA6V2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9232BC116B1;
	Tue, 16 Jul 2024 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145010;
	bh=h75ehIqoW2aWoQ4pq0SXyaGw8dgivVcY9sUIF/FB4t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgRA6V2SAv0GMx8PvrJ5D6dPMgGlrmoKP37p7VPoGnAXogHkEbWF5XR5CKYvRXm+B
	 2CIBZp32EhpcS7aJSlFsvD1lczsZUIhIyC75m++im3dT4gDJOuRQT+q2Q1QrbEvU3m
	 KSnWoJgamTiY7K0sGpDBoz99+/lJO+4rGs9DCZOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.9 069/143] USB: serial: option: add Telit generic core-dump composition
Date: Tue, 16 Jul 2024 17:31:05 +0200
Message-ID: <20240716152758.633162033@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 4298e400dbdbf259549d69c349e060652ad53611 upstream.

Add the following core-dump composition, used in different Telit modems:

0x9000: tty (sahara)
T:  Bus=03 Lev=01 Prnt=03 Port=07 Cnt=01 Dev#= 41 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=9000 Rev=00.00
S:  Manufacturer=Telit Cinterion
S:  Product=FN990-dump
S:  SerialNumber=e815bdde
C:  #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=2mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=10 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1433,6 +1433,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701b, 0xff),	/* Telit LE910R1 (ECM) */
 	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x9000, 0xff),	/* Telit generic core-dump device */
+	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */


