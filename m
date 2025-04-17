Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7DB257423;
	Thu, 17 Apr 2025 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914227; cv=none; b=XFyl427Lz2i6FRZauH9znMzsz3HsQEd317ecKlNZt+6+7u+JalJfi3OYZ2dSF4EjzGWq1aFKYItYA2gNRw/o3t8htbAWOHJEq/JX6luvz8wMP1RdM2Lt9zacJ4/Y17qFaFJkP171sm/yLzCMBY0T/oxfuOuBKQy8FTEYaeoSK2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914227; c=relaxed/simple;
	bh=O3uk3eHDT2OEypGfXNPe7XpH1gxzNVYVfLnbRQhEYPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfS2gKxjGLrkmDRhCvyVU3cp7GVhXnDnOuJbK4Rmi8fx7O954g+hJTRlLwmM61QqJ5YH/znkNFghft/QJ0A5UmE+FiLim2Py/HXtaHkk7b89PAufccyJ09eXnEsItlL2SkUpFKB2iuo/3COa8Dso5GWJQYr/09emMOAdeD5nUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAj8bsBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAj8bsBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD65C4CEE4;
	Thu, 17 Apr 2025 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914226;
	bh=O3uk3eHDT2OEypGfXNPe7XpH1gxzNVYVfLnbRQhEYPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAj8bsBx+VEfSmiUq6wIVkjBf3P/Qaw8ibTQb782BlQ8bYEAv5y6HgQ8HXw6xKsAw
	 1EVDUq3mOECkbNamS+Bc3cGTnmyTvC4K85cAVbyWQCJ/eZP8u2ftvG/2PVg7kAUi77
	 Xm8USWThEiCRIERJ0jOxnovvJk3O8sx2MMnc6r2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 117/414] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Thu, 17 Apr 2025 19:47:55 +0200
Message-ID: <20250417175116.138648826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



