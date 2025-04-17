Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8524C255E2B;
	Thu, 17 Apr 2025 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912896; cv=none; b=QIFzWuGipcof0Ak/5F/Ts7mMhi/TGHEt1P0LqBGQ+t+5mcsd1A8AKVXCiz5kL9vOBX+csK9Mj1Hr0pHsKIyO8zKSEKnZsHniUQ6c1+HURkcFz+ztprkUoBJHUvN8HR8m9/XFLWQZHnWDWOySUQ/q3STR8iR8UkR8yEOgFdh9Wu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912896; c=relaxed/simple;
	bh=5nAB6lgnyUzDQahYY1F5AUD4La0/NITGu7yLxjE+p1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgU2Ck/HPWgrcmR7c2eIZPHUrBew5xzB9KjD/Mk8Rjm9eDsAyAo2Zoy2u4bmXNvBT24pVyQrszEIQKVkZlbrFw0doh1JajJQ2Z19POCr369QyKLh8he0FGRqoh3IVBbs7cRMUlCfBD/v7oQlrxw3LQEC4tZtG1R051AaQUhJlr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3eTGt8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3eTGt8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DA5C4CEE4;
	Thu, 17 Apr 2025 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912896;
	bh=5nAB6lgnyUzDQahYY1F5AUD4La0/NITGu7yLxjE+p1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3eTGt8I4UujL9FzdyIlrlusNtwbqO+fZq1jOowXl4q59od/wTfwxsIeynwYnPQ9s
	 nLWZigceXRlo+045BX3AYSUQHwfa+lqeCjQ12xQy2pDcm1LSG8C90sGQ/bLsOqEydo
	 Bh+T3YtrZPA0kdc5LyZeZeaJ8L/3hXw9E1XSLz58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 133/449] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Thu, 17 Apr 2025 19:47:01 +0200
Message-ID: <20250417175123.320584777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e832ad53e2393..a4f4d12f904e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -22,6 +22,7 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
 	{ USB_DEVICE(0x045e, 0x02fe) },	/* XBox One Wireless Adapter */
+	{ USB_DEVICE(0x2357, 0x0137) },	/* TP-Link TL-WDN6200 */
 	{ },
 };
 
-- 
2.39.5



