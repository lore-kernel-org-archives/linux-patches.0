Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9C7280CF1;
	Wed, 23 Apr 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420532; cv=none; b=OH5NF0je2PMJOZD+pgeN3uSlpxppZChshoYzm3RyMXl2CzQ+P+cfEU3h/Bn09EVX0g5FH6BnOoH9MrwSemqWAfB4U18dqcsphYJ6OPJfiUQ4OHqDBqu/otVbXm7QVTROXlGJIcXCBkqKku4dS3IYlIVtRV7CfFFi7o0P0W1YVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420532; c=relaxed/simple;
	bh=ZGzYY7kpIq+KxXOXzoOd6KmRNByf9p9jnNSYNUpEaLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESrleaY9TBka/a6DAjP/ge0HShoHbybKTDcs2yzrEKsTgylQeG7mLWv9BW/WCPMk9CPy/k+jfhapTeEQv/27q9E2acpMZSVR/h9/lsmwjAEelYg+pl3A5JALeV5KWrQnpGQD24Q66xI4JxkUTHMcYBIwDvsJapfTRUBrQIK8HRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/bquHha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/bquHha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AC4C4CEE3;
	Wed, 23 Apr 2025 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420532;
	bh=ZGzYY7kpIq+KxXOXzoOd6KmRNByf9p9jnNSYNUpEaLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/bquHha5WPjP/5sJ+E5loIrJIJpHvEMm/Oji19G/yIY47Jav3pE1Vie9AVwXhkD8
	 8xTejEf8iXERqm3k9KM9tiTTSFH4s56ReiBbCyC5U/J8URXnQcedEAUXgfIwywhQiq
	 fjbMgYm8WG58Y+WQbY998dnNFYBoo6oSgVillIPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/393] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Wed, 23 Apr 2025 16:39:42 +0200
Message-ID: <20250423142646.849143369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 06cccc2ebbe6c8a20f714f3a0ff3ff489d3004bb ]

The TP-Link TL-WDN6200 "Driverless" version cards use a MT7612U chipset.

Add the USB ID to mt76x2u driver.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Link: https://patch.msgid.link/20250317102235.1421726-1-uwu@icenowy.me
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 55068f3252ef3..d804309992196 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -21,6 +21,7 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
 	{ USB_DEVICE(0x045e, 0x02fe) },	/* XBox One Wireless Adapter */
+	{ USB_DEVICE(0x2357, 0x0137) },	/* TP-Link TL-WDN6200 */
 	{ },
 };
 
-- 
2.39.5



