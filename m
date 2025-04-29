Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B22459C9;
	Tue, 29 Apr 2025 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945269; cv=none; b=fF8SWSHvQpE8uq5VNm8+ARNgJe/VNiJfodfSZv6SegEhgo83UP6YCRw1Ejd/Sh174lQIHvPyX4wNAOtdVslPI2PjnqVnINqIQ8ZUuEdZqPcLVFc/M9cMponPC1QCiV3G7ET/qm1IgecPP5PLwj+/2602Fc2FNwSUqi6+C7I9wyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945269; c=relaxed/simple;
	bh=VqVV+9bMkp8DGRtOScsvF3NrSB3xAFOaL/P+D6SQNTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyZ2zFm1iJGpGMo3GwTBb5F91+agMO0GlAwsdsdzgF+96FcC/0nnyPTjC9MboWfs2YWtfz7sPKJgJ4rJDPV7fz47L3rsLL7++e7X0aqbNp1ufVwF9/vneWXcGEjBL/kJvOYqZifKRWQ5F8OL+AWYw45I2Tc/8uklG3FzXldkGcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVwhZ/Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVwhZ/Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16560C4CEE3;
	Tue, 29 Apr 2025 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945269;
	bh=VqVV+9bMkp8DGRtOScsvF3NrSB3xAFOaL/P+D6SQNTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVwhZ/YzJmgRynVY87H3nVFLwv4xGGxSFteZ4weoPzugySElPe4RMRsAOR3nkEfg3
	 WljZgyIb6xJp1srM2dIDLjXgl6MD/Dw+sf54yoIckz3Ki9kdMDkIK2CHA9eaDXQohd
	 z4NMQXr34F0/gEMn5UFv7G9Ak828YxNEqxWPB6Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/179] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Tue, 29 Apr 2025 18:39:27 +0200
Message-ID: <20250429161050.469225992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 96a2b7ba6764b..8c392d55d59ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -19,6 +19,7 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
 	{ USB_DEVICE(0x045e, 0x02fe) },	/* XBox One Wireless Adapter */
+	{ USB_DEVICE(0x2357, 0x0137) },	/* TP-Link TL-WDN6200 */
 	{ },
 };
 
-- 
2.39.5



