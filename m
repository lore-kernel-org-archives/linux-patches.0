Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFE219AD59;
	Tue, 16 Jul 2024 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145797; cv=none; b=GzTYu8OjqXKuTPVJP1UW/E0SNlGT4qn9UaNd+ktOqtWMKyJFPvU6Y3yXQCgUDoRDGIHv1BjoqBSkKc4/e86Wg7fTdHQWvVmtvxydOsZSjG6maPazYswAfU5M1KmMdSkW8SD055PKeZTfhXLqjUtYBdnSOeIAROsOj4YHliB0dsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145797; c=relaxed/simple;
	bh=OkvL7wex+7lAye6OJAauD/p+4T/yWRJqi8d7ZAmYzDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTYXbqE0J0wTFf0SXna/RA8YFRcSnepPaUz2I6G8Gk9lNIRGq9OKzxoguwme3GfdVEDOJnjod+JQYvZ74hlCZMx6ONqjb34w7a4GB6vGHkIVC0SgT/S7U/SnFTTCfIZM9tgzBX9RRLngB6syM1e9QJEcVmQF4B/WPKHaEVYHQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKtTBzya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKtTBzya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66360C116B1;
	Tue, 16 Jul 2024 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145796;
	bh=OkvL7wex+7lAye6OJAauD/p+4T/yWRJqi8d7ZAmYzDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKtTBzyaCA/1HMTXPHEOlB4xo9By/FrgTlGHM2yiKAlTZRz7v5kn6bmLmlM0mvahw
	 NsvxyXMF8zCJ4loL2+A6vlVpjVKBUV8bP4NZ/7D3LIZJ1HSVfBDtLpwh5lzx8bWzc1
	 9K/hzAklKGLCbTtSiXzcV6v1CUlAgtm2ZX//yUpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 057/121] USB: serial: option: add Telit generic core-dump composition
Date: Tue, 16 Jul 2024 17:31:59 +0200
Message-ID: <20240716152753.521054407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


