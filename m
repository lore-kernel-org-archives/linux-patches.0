Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DA5187C8;
	Thu, 17 Sep 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664409; cv=none; b=KjyDQCgad6t410ibZflZnEIW5ytgfPbujzQ60kQIFzxJmpksaMZjjNCBzG1u3iwZH3MdOSYr6OAtTjdxkKspWQ0dp6Bws1pRK7xXUV6BDx8Ew2r1VB4Ws4tOFyylRgMoqfRRWfZtHVytTvo9zQpIy7tfVBicBgL51s7qxS9Eh1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664409; c=relaxed/simple;
	bh=XWE2KQQ4Si6BC/rY9Lt6KzKDTIGXhz4iZnQ4hrEqugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQB+epmWCx5dnqh8hRzCbjk17oEdJMqowpoROeNfgn9jckTeDYyeS2/WIbC3DasIgYrxdog5ADV0F+9la4kZB3zjjF6rjqRJGlCg6GmQZMpxfxsL6nAnRxrEmcgMsIYJD57UhkX6GrUUpQM2ICGuk++TOcjWm9jhE5okKzb2msY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWYsX+/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWYsX+/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8466A1F000FF;
	Thu, 17 Sep 2026 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664408;
	bh=6hp4pe0avpmMUy6TAG5OHC1/l+kaMIU5Ssk0VA0l04A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWYsX+/tGRdC/Z+RCRTb9ZxoP0oCgURX+P5EIlEQfjmvmUoknA4sTJJ5AotiTiJGJ
	 LyRD6Lt6+Oaxwr/pqC9N9Kp52CLLxN9kvMOUzfpz33sF2nF3fqi/NJWfehKdot8BZ7
	 jO0RUwfb5+HJukkO4aARI94gJdUJSl2/qbPWo0+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0363/1250] wifi: mt76: mt7925: add Netgear A8500 USB device ID
Date: Thu, 17 Sep 2026 16:02:38 +0100
Message-ID: <20260917151601.902809546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 291b067a02b9c1fd272057ebf47c365260955fd2 ]

Add USB device ID for the Netgear A8500 (0846:9050) which uses
the mt7925 chipset.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260527144735.10254-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index 16ab139b67488..95047ee48a425 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -12,6 +12,9 @@
 static const struct usb_device_id mt7925u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7925, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
+	/* Netgear, Inc. A8500 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9050, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	/* Netgear, Inc. A9000 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9072, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
-- 
2.53.0



