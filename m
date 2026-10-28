Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212931;
	b=Ftz0reD8c4pNMMWSTthxtX9ScDYtV2577Pb+QrQTSUiYGqHDEYG41rb1KM0LDSXdxMn+
	 VGJBsOhD7lysjOc8ZgFVLUf3aIkUCo4fVjPoUnuJmiCDDbU40bmnqcbRNSnN8s0Hy16Wu
	 uNsnxIx8G/EBEL936Jik/oz/UA5I9M5qkL1ENlCNjPdOlqENxzjpAUfpaMWQgfm4Bz60K
	 8eVVhxarWp3OWTahJejS93LNztwL2bumzgrBaXxdRb/mBM+DMafVZ3spdfGt6cr8TiTys
	 rKJ4Znu5C4gpxdDc4/uF+Y0ilyB3hgGpoyU7aAT+3gfE0qiLzIpP5bo1zw+DlYz5X4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr6VJeV4tynOFa5ap+a3EriZPlQHVwCDykuWi+ZA/Wg=;
	b=ZxbcMqR+XObJMtKT7eipaHLGGqoYHfWUIDOxhrGxuHmuRO1Pl/hZjq2lAcyCs1AA7EHF
	 dACRoyTkQhMVcuGgXSulY7a5sZLXWI2GupXtI39uVjW8gilHNtchOuT9/uJzaUPTdz+8g
	 CJZg5IC3Cp4kuC7gr8EK7iLnE87iZV80r43I6iMYjz9vXyPl/2OoiqByTB7toYoom9pN5
	 tnzxaWwT4PpgNHRZht2ASpEll+uiFQzRZOMHLLm+nC1mK7PkjRBTMzQhKnzMvisTHKaQa
	 gJUyaJv92Nl5/AC0apYRN+E1EH3At2G5CgP21OIDBm1b9BtuXGKReVolaro5NvB5SSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rjX+YtT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53904606A31A;
	Wed, 28 Oct 2026 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjX+YtT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9711F01825;
	Wed, 28 Oct 2026 18:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212930;
	bh=Cr6VJeV4tynOFa5ap+a3EriZPlQHVwCDykuWi+ZA/Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjX+YtT/cqrMCi6qYnr3sTdl9npp+1poYWdLvU2GvUKqJVMIv6/CishDHmZjHYBdV
	 Gr7mKiKVw5vjAR09WyTxY5dHGThrb3MKBLeGfeCGDDB1ZW/TEDnUoZryoKgjpmeSYp
	 3vVbSKYphBzW4hwud885DiaBFG91v474yVplYi8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <jisayme@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0326/1887] USB: serial: option: add Compal EXM-G1x support
Date: Wed, 28 Oct 2026 17:40:22 +0100
Message-ID: <20261028170506.650945933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


