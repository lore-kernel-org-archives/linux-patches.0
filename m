Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04483594D;
	Thu, 17 Apr 2025 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915404; cv=none; b=N9tRf2Qqo6txqop+10MqCtCRIyI3Hw2Hebpbfn43ClZvFIjBEM1zA8nom6gyLKC1Xo/5WUImyJnCb4a0pO2OgWkURJjn7ifULM61vhtNgOwqIXebxnucXTSrQeaYYdzebrR1aFFwFi4Aw1JTeZTr5ZLd1d89QZ11PUjSdgRMpBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915404; c=relaxed/simple;
	bh=8m3PMMapRSmuU6io7468brYZoLl6jWHl5yNEpsazP/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkhpueN77Id5EAUxtfpVhRkiYs01uOy7MBDpvm5li4+ZsJrGbgK4JZ8pRpDne2dXxDwfT/B9khHReWeTs5cqebh5kwUF5Gbul7IJA6amkYg8j0AgbHWEgH5K7JggKmq/iBfW7MAHPKWBDDkIEmBXAPzAi5sIPZ9s6wjgOdddxxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG1Fag/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG1Fag/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5301DC4CEE4;
	Thu, 17 Apr 2025 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915403;
	bh=8m3PMMapRSmuU6io7468brYZoLl6jWHl5yNEpsazP/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG1Fag/ARyAKAnbbDXZT9xM1sp1fnhaVEAciq6dUO9yopS4ZnwcyJ+D3z4NhLn823
	 lxwVvN1YdN4pWCv7+7qVYdSJ6y/m9HVgNo5gr2WXq2GAI5cEb8oCv5UFKSWDE/38Sj
	 bDlv8sIX8TYum3pms6Mo5n7yTDdo09rWS+/ol1Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/393] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Thu, 17 Apr 2025 19:48:45 +0200
Message-ID: <20250417175112.262219305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



