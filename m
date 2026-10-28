Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211067;
	b=muiBZcFsbISSgZp5hxh9LCBg1WlcY3JwEY8BG8BrKZP2p4MkvZm9T3u5R0gjja/fs1HV
	 5bNLSTYRvskywnA8KE87S8HU07CkmJZTXveNltsCJn4m4L0GxkvcnLBwRxyUBFUfgIw6P
	 F+wbPE/RPT5OLscbUTo9UkVOmc68YMuW/z2xT/6xipiGsOzHo5EMAAHmNMNRMxPvMcNtv
	 t/bYN/VJ3jRUXBQHZSswCggjAdl9lxRYJxBH5XjRp0MuVcE+8+zNVDVxtrBkwOmnK+SAY
	 UwL8O+2hfyasjgCDdenEdioEhEutMCHEJ5qLVSlbcmU4icQAQYlJfVr4gT4c1tLXqyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ld6MsVD3RaRmIn1kT6si4pFlTnfAsHK9hsL5DGu9bw=;
	b=k2cUQjancBnGB36NXRxSffS3ktRQYFa9LMY1+HidExeIrCbGWxKiHYh/mKlZhhF0m6jw
	 W98WMnaWkvkhsUOxGJgnc+ZvZTTmGSQ/g786FmZE30Ih64GWQz6fCHje6XukognNhsDdX
	 TSV+uyg+r8AeLNu8ICb719waLD/2OL8pWh/HyLgqNfbg0Sfic6vLPKF8EFMwFjFwBzfrL
	 l0hZsPHZ7hdExt+TJg5f3/tLa0Jj+kwupIO9W2PJKZ5KVH7Xqv43N2ixYbqaB5Dgptak1
	 MvcGV+xAIDMtNoX0GMmyyzdE8KzVVIDH7ZumQ/5nXrQr1wpF9Pr6C42RoyTir6fhd7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=METeI0Vl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F260A2620;
	Wed, 28 Oct 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=METeI0Vl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED271F01829;
	Wed, 28 Oct 2026 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211066;
	bh=4ld6MsVD3RaRmIn1kT6si4pFlTnfAsHK9hsL5DGu9bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=METeI0Vl0OPMdXj2FlWcCOhYP4Hkm3IZ5cj+p2vM1avo1j3pvGkYCbluzSGXfe+og
	 Jw6ihJGQCwrPgCUTsFUDqYzBYz046Ahmd00ENj0uFlfFxcxk6JeFpxTy/LEiOJ04Mu
	 /zIyDmsEB5fQW76x4J5c8UOeKPe/OXqAYs8y5iT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <jisayme@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 247/571] USB: serial: option: add Compal EXM-G1x support
Date: Wed, 28 Oct 2026 17:56:34 +0100
Message-ID: <20261028170013.866370175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


