Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E132572F;
	Thu,  2 Jul 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010031; cv=none; b=fr6UXzmcYEnhMlCBAiAo8CUZguax1FCcnjWFI79tj21IsWh5c8nIK8y0T/KX+Q+X25QzDK98+s/mX2MEbg1sLk+obLsv1nHWG4lBqQ30SDXBK5znhfHEIvdN3CUya00eNbLtvTmlZnkJGWCTaDT+yeYmo8B7MCX+vdZXZaV3Nys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010031; c=relaxed/simple;
	bh=3w7ppdnjngixtX85WOIJxq+zT1eKtJlo+VekDispItg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsIkcl83wiI0h6ea0BslNccyJkT3UhvSyERFZS/Jf7T0zlqEBz1YySQ2kgdhk/VW+kaRuXwJr2NBmhgA4OD3ZifCH330sqZdGj7psJEhof1a5y1e9bCMViWHH0rC5LiE29eGWusaRJB2IIsktknQOpuHSs90g6cu+gWEg6a7ozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adVkr2Tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adVkr2Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A630A1F000E9;
	Thu,  2 Jul 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010030;
	bh=r2s0/7gloW0KRjiyZBWTjJR3KAZniagHtQSN/l6EncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adVkr2TwlElriqaMIfmq9/0BPof3OFp+MNbJ13WdJGJV9+YwuWqCpTHDPASVtXP5C
	 PTQVzFNyCSi6UOhn/lH6hHbmlc9OVedjGvIc9fpz3Pu11hT/M6vWdeGjUkFdnx4VG+
	 R7bAyr8L6f7K6blNmSCnF8sQT2q8DHSZckOVtHew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 084/129] wifi: mt76: mt76x2u: Add support for ELECOM WDC-867SU3S
Date: Thu,  2 Jul 2026 18:20:03 +0200
Message-ID: <20260702155113.880881501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

commit f4ce0664e9f0387873b181777891741c33e19465 upstream.

Add the ID 056e:400a to the table to support an additional MT7612U
adapter: ELECOM WDC-867SU3S.

Compile tested only.

Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260407154430.9184-1-zenmchen@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -16,6 +16,7 @@ static const struct usb_device_id mt76x2
 	{ USB_DEVICE(0x0e8d, 0x7612) },	/* Aukey USBAC1200 - Alfa AWUS036ACM */
 	{ USB_DEVICE(0x057c, 0x8503) },	/* Avm FRITZ!WLAN AC860 */
 	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
+	{ USB_DEVICE(0x056e, 0x400a) },	/* ELECOM WDC-867SU3S */
 	{ USB_DEVICE(0x0e8d, 0x7632) },	/* HC-M7662BU1 */
 	{ USB_DEVICE(0x0471, 0x2126) }, /* LiteOn WN4516R module, nonstandard USB connector */
 	{ USB_DEVICE(0x0471, 0x7600) }, /* LiteOn WN4519R module, nonstandard USB connector */


