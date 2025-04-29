Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3761227E95;
	Tue, 29 Apr 2025 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948524; cv=none; b=r/FrRNz0xAa4//UobCE4uAEmM4nUCktYv97iP/ubx+6EMe+ok4K3GRuZwIM1QwOXi8UGV7s8fyiy/8WA40HouTfe8CpvObUeE9RNFN7wkh3HjBBRN+OYCJNcD//ahEIEjApO+YCGyzjMmKeeTEDAIM3LkJLFP6ZV6ZeyrJ7N9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948524; c=relaxed/simple;
	bh=cGJHWs9EkGbR86yYBCWN6Lp89ODULDhJqP2zu0RhEQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZYPyotvtKxLUbm2LPcck9T1fpM6baIxJ5gQrTOjbEZVYPr+KN40nR8JAf311UhlRySohIxJy8KmiL/qcyK0py797ji5Ev3SKYpBx3cbWlf0FDAIMJAoxnJwQNKoav5hDaA2Q+tMFlyxCZzIHLahvUUqIOyGLP9sa9HZtX7Wze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlEoZ+uQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlEoZ+uQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B429C4CEE3;
	Tue, 29 Apr 2025 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948523;
	bh=cGJHWs9EkGbR86yYBCWN6Lp89ODULDhJqP2zu0RhEQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlEoZ+uQeEfMBNiyJ+k5/dcogt04tNCMAl9+waByajNOfjLy+Y9Cfr+G+LAWTbllJ
	 fycWuewEKC+jfyE74JIcEIsX/URS+tI71iUPGAIcGFOSwWeT7mOrbkfx3px7mas1bB
	 yTXRvgF/YWzGtiM0NYhoMRomw3key+5Sv1Gcxu8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/373] wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table
Date: Tue, 29 Apr 2025 18:38:32 +0200
Message-ID: <20250429161124.578902989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2575369e44e20..9369515f36a3a 100644
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



