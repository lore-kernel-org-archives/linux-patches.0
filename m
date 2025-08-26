Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0311662E7;
	Tue, 26 Aug 2025 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217559; cv=none; b=XMs5W4/KQcgcef/iT6OLUYY7XX0AUAxcpXpHJWO+I8HP9aThopqBcauSgzPKh9R2Qa5dyWwSh6wbHGFNr3li9mtHMFsxlPbuYOhgY9L/mn6szlpXeAMFfveFJtOloeN4MsRBlQGE9OPkycPYr03liGmiw1vY4Wctwqu8awa1wNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217559; c=relaxed/simple;
	bh=lSviLzpGWb+hZpl+J+DUaN14qrv4TpOib5D+rDGMR8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px3v5HsAZgQYGOnUsL7zoilSXYfVp0sEPZ4crEi6qvHD9C1KO0MWHNdYIsKYQd6sWBsNWge7Ph/Xou7hwpmHOQN4bkmyYpDdddV+rgRcQNw6kEnS9MCaI1GIsijWoojEUoA/TIguwpJ1xeAg2BgnmhPWX/nAC9R0sfRHSj8SNeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXI6hApR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXI6hApR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA7DC4CEF1;
	Tue, 26 Aug 2025 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217559;
	bh=lSviLzpGWb+hZpl+J+DUaN14qrv4TpOib5D+rDGMR8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXI6hApR5j9At/M/rdNR8WSCtgXMlKCCV+Fr/xwmMoBr190jJC3VZc5HPS8egehQv
	 bPdrSJBk1K7x/9S2VE/t2zGjcJt6Uz867YMzOhDOmOZYVV0Y/UzHXrhRa9D8HTIBJA
	 H3gIiXMy1IsL4t8vwhQhsFzqiRXWnkL0OOyTUHbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 188/523] USB: serial: option: add Foxconn T99W709
Date: Tue, 26 Aug 2025 13:06:38 +0200
Message-ID: <20250826110929.089425442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

commit ad1244e1ce18f8c1a5ebad8074bfcf10eacb0311 upstream.

T99W709 is designed based on MTK T300(5G redcap) chip. There are
7 serial ports to be enumerated: AP_LOG, GNSS, AP_META, AT,
MD_META, NPT, DBG. RSVD(5) for ADB port.

test evidence as below:
T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e15f Rev=00.01
S:  Manufacturer=MediaTek Inc.
S:  Product=USB DATA CARD
S:  SerialNumber=355511220000399
C:  #Ifs=10 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
I:  If#=0x6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x8 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x9 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2346,6 +2346,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe145, 0xff),			/* Foxconn T99W651 RNDIS */
 	  .driver_info = RSVD(5) | RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe15f, 0xff),                     /* Foxconn T99W709 */
+	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */


