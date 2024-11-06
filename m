Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428911DDA15;
	Wed,  6 Nov 2024 12:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896150; cv=none; b=hJlC0DY/7nazkLwMqX+W587pmc24s+Xo6dzIjPZBvpFuu9J2Mwe/ZUWrKs1vNCsQzWHeL3JrCyfbkC/G+2ROET72+Gy1ovFuwZt7LF23H46alcW91WZ1eODTQZHZUcc5MNc76l6v4E7SW1wZsAyGAbwVzeso+YfgcaDH1nV6jlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896150; c=relaxed/simple;
	bh=jJhtcxRY6XtKFnDmvn46WIbFY2cpALXXWYBwZMKTx88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXdK/dxHvCSKuQ4VvHTI6CIWBiNqtwTXILBD5Cg6axgjh6nTwXZQRWHcK9ANIYJ4QSaeqcXPp2KLYHeXec97Vj0YrweEn3CZoJrbF4NBIQfBUmBafQK9QxpSDn9KxHLT+NVuDQrMpd4yt8TBoPf72ScRImequa9y6ncDcpGIRAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0PHPVnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0PHPVnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA95AC4CECD;
	Wed,  6 Nov 2024 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896150;
	bh=jJhtcxRY6XtKFnDmvn46WIbFY2cpALXXWYBwZMKTx88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0PHPVnEkh2CdiPnvLTi4lloESRuo8/E+HNKavr55+QyoXz8iIbyBc9I7lmgsY1qc
	 LEjuOhspsJUZyWaJnK6pitDfLnMVTAFrbasXIl/EBqKimLEnwjpIsOcvrkOWEzivgr
	 NH1kR3Gz0v8aAZvCPLgg9DBBs/U9KWAHVfUyJhSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.11 106/245] wifi: rtlwifi: rtl8192du: Dont claim USB ID 0bda:8171
Date: Wed,  6 Nov 2024 13:02:39 +0100
Message-ID: <20241106120321.824496598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit a95d28a8a2f76c591a195c06ea15f5b15c66c3d1 upstream.

This ID appears to be RTL8188SU, not RTL8192DU. This is the wrong driver
for RTL8188SU. The r8712u driver from staging handles this ID.

I think this ID comes from the original rtl8192du driver from Realtek.
I don't know if they added it by mistake, or it was actually used for
two different chips.

RTL8188SU with this ID exists in the wild. RTL8192DU with this ID
probably doesn't.

Fixes: b5dc8873b6ff ("wifi: rtlwifi: Add rtl8192du/sw.c")
Cc: stable@vger.kernel.org # v6.11
Closes: https://github.com/lwfinger/rtl8192du/issues/105
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/40245564-41fe-4a5e-881f-cd517255b20a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
index d069a81ac617..cc699efa9c79 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
@@ -352,7 +352,6 @@ static const struct usb_device_id rtl8192d_usb_ids[] = {
 	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8194, rtl92du_hal_cfg)},
 	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8111, rtl92du_hal_cfg)},
 	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x0193, rtl92du_hal_cfg)},
-	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8171, rtl92du_hal_cfg)},
 	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0xe194, rtl92du_hal_cfg)},
 	{RTL_USB_DEVICE(0x2019, 0xab2c, rtl92du_hal_cfg)},
 	{RTL_USB_DEVICE(0x2019, 0xab2d, rtl92du_hal_cfg)},
-- 
2.47.0



