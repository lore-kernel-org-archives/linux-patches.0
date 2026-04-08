Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A6F32A3FD;
	Wed,  8 Apr 2026 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673184; cv=none; b=LHHj7rrTMMW2XrsfccIfg2zjU4+whrkAse8WNeSoxBZWpBalpPv4jIjNjMhigsiwGC2PeUVKc5c6sJQ5DiRe4pjuQMAKEdl304lJ4WNTpF1K8zhRU/MVRTSV0pTxKqOcrTv2u2W0dpIqjbjkWH/oUMHgPIsAII1Cq3cI4SbX4bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673184; c=relaxed/simple;
	bh=1OWHU2K79V4Cfg3JaSXo4V8tz/Lx0fq6bSwbUCY1s4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYQgsGhkRH91Lbzm3SkGsD/gvZhuj3QRpcxzPoJorIwolaoVkBVz99XRogjgav1eVpDuKXYwJiCU/aaSjdpVUd+/EXkUsBkH8y18pCPXnfjbNzaVg0TLR2302MNTeVyCS+rLJL5dG5CbFFRTSbpIzNthpTNtD2RAgmQ9efj9YyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPB3vMkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPB3vMkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF776C19421;
	Wed,  8 Apr 2026 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673184;
	bh=1OWHU2K79V4Cfg3JaSXo4V8tz/Lx0fq6bSwbUCY1s4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPB3vMkrRYsGbTveDd2qBtVbKgKUFpN+3BLRV3pWhpcaEDEk+yYVOyYWiM/xFolsA
	 sBnSHI0UX6Sa2aCVL9glIJ56xEJffFauSIh5uv11eMR4j6sjDWH5mcKDqq2C+17xkK
	 6TZqkE16AwGBKCHztY1b3imlXcGKepHw3H7CP0zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ernestas Kulik <ernestas.k@iconn-networks.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 133/277] USB: serial: option: add MeiG Smart SRM825WN
Date: Wed,  8 Apr 2026 20:01:58 +0200
Message-ID: <20260408175938.840623219@linuxfoundation.org>
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

From: Ernestas Kulik <ernestas.k@iconn-networks.com>

commit e8d0ed37bd51da52da6225d278e330c2f18a6198 upstream.

Add support for the SDX62-based MeiG Smart SRM825WN module.

If#= 0: RNDIS
If#= 1: RNDIS
If#= 2: Diag
If#= 3: AT
If#= 4: AT
If#= 5: NMEA

T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#= 19 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2dee ProdID=4d38 Rev= 5.04
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=da47a175
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=03
I:* If#= 0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Ernestas Kulik <ernestas.k@iconn-networks.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2441,6 +2441,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x30) },	/* MeiG Smart SRM815 and SRM825L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x40) },	/* MeiG Smart SRM825L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d22, 0xff, 0xff, 0x60) },	/* MeiG Smart SRM825L */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d38, 0xff, 0xff, 0x30) },	/* MeiG Smart SRM825WN (Diag) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d38, 0xff, 0xff, 0x40) },	/* MeiG Smart SRM825WN (AT) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d38, 0xff, 0xff, 0x60) },	/* MeiG Smart SRM825WN (NMEA) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */


