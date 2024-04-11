Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69C963A2;
	Thu, 11 Apr 2024 10:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831562; cv=none; b=YA3UseRtJkYzcbu5jiU2+3rTtjJOrZ3JLk7ahtyOh8W+WbCzvtqEJVLXPFs0fo5a+vHn6Aa3h3sZNEvEjY6pSd1HczFJh0ZWUBDtzEXjr58yXGAut2G+yKrPOKs71u2wO5ayFmCsqFHTM7gQPUkcNkyicnuQSQ2EKl6/Z8IDqPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831562; c=relaxed/simple;
	bh=BoGDVzBw9ZtOm9YI+e/jEUgh1ee6V9wSdyoH4ALHWxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuQfmpEoWzBWoHvo99zK8CzWFo3rAan+6BnjObpm8FhYQwpD4HK23jzTmomC++L1SOjcWunRGCnwSTHCH8ma2JOhDBvCuP77kK+98w6+URLooVSE69WI98i+9741wYy1bfIL3ONzwULdXTfMqEc8RDAU/oARzpXl2w2UEu0beKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaH3SHLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaH3SHLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B1C433F1;
	Thu, 11 Apr 2024 10:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831562;
	bh=BoGDVzBw9ZtOm9YI+e/jEUgh1ee6V9wSdyoH4ALHWxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaH3SHLDfJsVSWjI7goyqHc1s6z17/XaupPBZiFyo4w3l83Ar+S/M25BG8Ov5EVe0
	 ORdOK4hya0jszHeHNHncXGl8HXWsrJ5pPnKoyv4sZ5YQifc0O5dbyqiyV3NoIqN9xY
	 auLbvNSoehP/7h5UvGI7Sjd3qeT1xYTlQXDqo/Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Jacobs?= <aurel@gnuage.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/294] USB: serial: option: add MeiG Smart SLM320 product
Date: Thu, 11 Apr 2024 11:53:32 +0200
Message-ID: <20240411095437.118668148@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurélien Jacobs <aurel@gnuage.org>

[ Upstream commit 46809c51565b83881aede6cdf3b0d25254966a41 ]

Update the USB serial option driver to support MeiG Smart SLM320.

ID 2dee:4d41 UNISOC UNISOC-8910

T: Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 9 Spd=480 MxCh= 0
D: Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs= 1
P: Vendor=2dee ProdID=4d41 Rev=00.00
S: Manufacturer=UNISOC
S: Product=UNISOC-8910
C: #Ifs= 8 Cfg#= 1 Atr=e0 MxPwr=400mA
I: If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I: If#= 7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E: Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Tested successfully a PPP LTE connection using If#= 0.
Not sure of the purpose of every other serial interfaces.

Signed-off-by: Aurélien Jacobs <aurel@gnuage.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/option.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 43e8cb17b4c7a..fb1eba835e508 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -613,6 +613,11 @@ static void option_instat_callback(struct urb *urb);
 /* Luat Air72*U series based on UNISOC UIS8910 uses UNISOC's vendor ID */
 #define LUAT_PRODUCT_AIR720U			0x4e00
 
+/* MeiG Smart Technology products */
+#define MEIGSMART_VENDOR_ID			0x2dee
+/* MeiG Smart SLM320 based on UNISOC UIS8910 */
+#define MEIGSMART_PRODUCT_SLM320		0x4d41
+
 /* Device flags */
 
 /* Highest interface number which can be used with NCTRL() and RSVD() */
@@ -2282,6 +2287,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, TOZED_PRODUCT_LT70C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM320, 0xff, 0, 0) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
2.43.0



