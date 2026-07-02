Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604BC31F9A8;
	Thu,  2 Jul 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011384; cv=none; b=pBjcwH3c3x6Mr9l8s6FaBbn1pCuT86ceiVyNsaGmkHpgrG633BwdgU9oeQpqaSxoN2b6VFC1o8+EVKcuCu9XJy7OCov0vikv/O3FYEZXB2BOuxKnTidcBjbgch4H4da+Mbq5SoHKpAqEZ5gJ5Q3QhIsgn1lDbEmhURjmznWA4dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011384; c=relaxed/simple;
	bh=QwYL2q02EmcAE6OHY4y/z0Cjnk+lyxtNO0sD/L5kseE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVM2q+9Ajz5QbU1gZXoCAdIZz0wnAie//C6r30miKUresG2Q+AOoNM5UyelD1JPe+mnuV9IYVkyb8kCydU01DMH0UVZYPaifo/fjFC0V60/AO1tdEWvcHFoknm1eF+fIFttol2/X77RcC0AVss5WFE7pStlKQGoXacAOF+wseVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqunNnFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqunNnFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63751F000E9;
	Thu,  2 Jul 2026 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011383;
	bh=kuhGwoSzujDdLoh8EaCeMbxeQu3mdipEOeScUIxn6hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqunNnFvg0tWvgqsSKnFuT2VyCsIivWsQcIHCyCwkmyrTgzDIZFkK6WMPbSxPfBi5
	 G5inGKKZlc/7f5JZxE33NcC2Ph0i8U+uATsSeuPGCDS3AQycp2beAaGZwqGsW+1MYw
	 /7B5v64Fs8CX93/89TcYDxsS/EzsF7HJtOM6ZBYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 051/108] wifi: mt76: mt76x2u: Add support for ELECOM WDC-867SU3S
Date: Thu,  2 Jul 2026 18:20:48 +0200
Message-ID: <20260702155113.166419659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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


