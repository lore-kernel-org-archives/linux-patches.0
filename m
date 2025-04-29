Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4632472B0;
	Tue, 29 Apr 2025 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946698; cv=none; b=RE/X80gp7MttlxOGOFuSjDQXJ/5QmnqZeIi7rPvdjxhqFpCmb36lR43KED+hQn7AyQmC0/XGRL9c/CbepBScDDN1pnXSoozIgF3saebZ/MsChAA+Lg+gxa7lpFwGR7Vsz/pUOHNXSO2Vtdjha2zJIRXXdQyos0lj44KMLfWonso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946698; c=relaxed/simple;
	bh=cdPXczjclI38eroLHocv2tmff3LGIOBohjYy78zMkqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ/roGk5Wef6mj3EkraHs/918hwCLIq8dTT4GCVlNBIsoY1ibFTpKurmR3xP3td8XxUCOmwfUoQ9Z7Cd3zNy62GYo2+8VBjLwGo7TywyAVxsyFi9+KtdpoY16uMFig1hAmi1Y2ryorLPH6rrBej7dJzxGwA0c7rWrWWGEZm+544=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txCleSnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txCleSnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FE4C4CEE9;
	Tue, 29 Apr 2025 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946697;
	bh=cdPXczjclI38eroLHocv2tmff3LGIOBohjYy78zMkqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txCleSnZiLvefSmghhpuMERqvYY/+r20hw7v7L0oq/sG4plTMI5V56bO5fhZV+4ct
	 xxOwEDACxchfX4GmK/vfBVi6W2R3jg6ghhzIgbkeltoiwcP1KCg6feBHYuQUqiIZYS
	 7cjBfe6J3isEi9lGBV2lTJTWxA6VpbE7WmL0XZJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/286] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Tue, 29 Apr 2025 18:38:56 +0200
Message-ID: <20250429161109.178336187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e003c7b62cf6..82a193aac09d7 100644
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



