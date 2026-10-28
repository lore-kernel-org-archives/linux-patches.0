Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208756;
	b=j4X8ZOMYjOPr0XQYllRC41WSR8Kz+oKnFRy1WfSTNrvMdskEBIXCCDaL1/Kqnh1qcJRf
	 pWAED/aKrln8AmacwNuUwJWWVt5W3+/CAbIK8HPajhJv1lYXED0TSxRjbBpioBJsb5Ke4
	 pCdgWFN06YAahZtyrEEFfVMVNXEfENuqKgCTqoNEP49IyDmGZlvDvVX8OxDuQAfw9AgRc
	 24aTKIk8C9YCdxLkG1YtnaGs+O9MKhar+kM9MFsq3oIHEcx8Vy9EqV/KhqTtHgsn+CTYy
	 OaRWh3Xk32OCJBpFP3BIRs9TJlBCpf58gARAJSbBWzYNGB2N7Lr2rymKO1i7mWdE+lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X+E9HLJyUWeo+swkIiightOI0CSNtQVCL0tEpGaXnSg=;
	b=XnEJzoVKkUY+w1mbsMNFyshGycYDNo02LejoijdyOs/5UKJx23hvKbuB5pov6qvIsVFa
	 bCSHvK35TVBeDoinC9qo6YK8H9/Vhgl6fqsGvE0ofHHw7eNqZjEdzjcMBbgAv6vCdA68h
	 n2QLYCYY9urRRRFhREs5zuR9sumbRlCYzxpeIQ3K4viwxXvZRL27r+8AJ4xUwREUjBjiK
	 1vFeN/RHCF82fEN/1VeLOTtThiQknSaNBCh0x6aK1iiMV3cqf5kK4kuwt4QjjqplO3BvT
	 bgizpyZ9YBI8cfNdu6EmsKtzUjtGX3YjDC0dq1V8bkQU9036v/RQs15hTS0VmH6Ss5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqRokmDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EEC606A31C;
	Wed, 28 Oct 2026 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqRokmDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588D71F01828;
	Wed, 28 Oct 2026 17:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208755;
	bh=X+E9HLJyUWeo+swkIiightOI0CSNtQVCL0tEpGaXnSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqRokmDkf1XreTT6iSf4wRiwxwx427o+Z+nP/IqtRsr18AOWfvP1lJe/pnvB2Pb7e
	 vUaUd+tEIKwOMXYtw4GY0JXK2m3Jkb2byflrkeZqapT08biW+9CnXPiVTY2bSb3eLe
	 xD6RCgMcusApLtCFGncS8GUF0r8lDt6mwIloB9WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <jisayme@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 229/516] USB: serial: option: add Compal EXM-G1x support
Date: Wed, 28 Oct 2026 17:56:21 +0100
Message-ID: <20261028170008.930418471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Lin <jisayme@gmail.com>

commit 7f11480cda081de78a05d8c97073df66326b50b3 upstream.

The Compal EXM-G1x is a Qualcomm SDX12-based LTE modem. Add support for
its vendor-specific serial interfaces with protocols 0x30, 0x40, and
0x60.

Relevant output from usb-devices:

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=04b7 ProdID=8217 Rev=05.04
S:  Manufacturer=COMPAL
S:  Product=EXM-G1x
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#= 4 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan

Tested on a Compal EXM-G1x modem.

Assisted-by: Codex:GPT-5
Signed-off-by: Ian Lin <jisayme@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2434,6 +2434,9 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */


