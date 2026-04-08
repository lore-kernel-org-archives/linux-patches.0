Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F6E3ACF16;
	Wed,  8 Apr 2026 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673277; cv=none; b=DWwgqGB861B2cNp/C3IB+ReRcvHaV9j1yJ4kzIGMdSg8glcu/GAXG5nBMxJQA8IMPUlcjD5YBLU9fceEg8LuCHjisw6LH2FGXMPB2Y6x+0zo7j7KWXNyBXg5/XiPCoFJCw6pRb27mz6phi8Ola3eXP64dNM428bJpeiq5nB4NDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673277; c=relaxed/simple;
	bh=H/nlugm2LDHMf6iEWDoDN0RdxvAEHzYmbeTR0t+Fx0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2MZfk5Mf11LIyWosn5uieeqhdbb3ldRjvW7tK+nUwAceLYqiujzS2fKtwjk4HB3Zy/ToNVwJbxTur1yxVnXlHy+0c0nrKw2nOZY1hT7qO5X/B9r/YK5yH1y3Q2ZsW/sEdZOqcOViRvzR+M+eqR6zlP/y1l2Jk7CSpk1qNkrB1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6Z/c3kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6Z/c3kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B5C19421;
	Wed,  8 Apr 2026 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673276;
	bh=H/nlugm2LDHMf6iEWDoDN0RdxvAEHzYmbeTR0t+Fx0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6Z/c3kRvQQ7puVJBuaT7YfqAaxHXtY8HnoVm8R219CgnL8uE6AX0YjXzZ4YlLdqb
	 zBID0TEYK6rHZ4jsPrIKNAVGcjWzSchy11MFdGbxDNxLp1l8dp6mlwsy91NtugYAk6
	 6ZY1+EK+MqUrI4StA4ma7pQwFVxIn3Dk5QRPes+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanquan Zhong <wanquan.zhong@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 169/277] USB: serial: option: add support for Rolling Wireless RW135R-GL
Date: Wed,  8 Apr 2026 20:02:34 +0200
Message-ID: <20260408175940.178313404@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanquan Zhong <wanquan.zhong@fibocom.com>

commit 01e8d0f742222f1e68f48180d5480097adf7ae9f upstream.

Add VID/PID 33f8:1003 for the Rolling Wireless RW135R-GL M.2 module,
which is used in laptop debug cards with MBIM interface for
Linux/Chrome OS. The device supports mbim, pipe functionalities.

Here are the outputs of usb-devices:
T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=33f8 ProdID=1003 Rev=05.15
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW135R-GL Module
S:  SerialNumber=12345678
C:  #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Wanquan Zhong <wanquan.zhong@fibocom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2464,6 +2464,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0302, 0xff) },			/* Rolling RW101R-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0802, 0xff),			/* Rolling RW350-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x1003, 0xff) },			/* Rolling RW135R-GL (laptop MBIM) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x40) },


