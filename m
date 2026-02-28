Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321E33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301119; cv=none; b=YD3gKoMmIbtZojVjzhboUa2XFlLtkRoIG3wLZWJUM2i8igVsIsqQGcrNKfos5JS5INZ3MBD1GjI5k71106av9zuQEiQ1rHG6Sdsmyz4cGWQE+tuGsuyZbylEr/cCwHTvMTXEinCnEyPicgab5C20BczCQO1aAdG7Rhn99c4aEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301119; c=relaxed/simple;
	bh=giRcar3JCJclt/BjCfRHpvRQG4hhCmFVp3rLWEXrbLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaEj3L/VX2YR8r6OcoHB7G9OV/GqF9G1cdD2xZ8/DAs3HCSr5R1CrZ6lbshczq1Cr5DOP/8P9IOP7+99NfmUMHEgFsPpkA064ekOt2abbs7NG5pV+j3j332q7b0ZvSBhTS4xQCixvHqZZK9rS2h7zKP3/JKsRn5au6dO4/dbFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTYucb9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTYucb9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5980C116D0;
	Sat, 28 Feb 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301119;
	bh=giRcar3JCJclt/BjCfRHpvRQG4hhCmFVp3rLWEXrbLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTYucb9LtYcS705PhWrm0XQtvwvzytIV5EVGXJ+vVGXTZUL7bN0/8XNFAUBaXKpnj
	 v3xBQmPKsAav+umLEkWeM85k7EC4Rr8SPpguU738C5C1D8dtYk81RSKxHUqXeAZwmL
	 ENpBZK7+WHC73wvukbkK5iylFSUufMxg7SOscGLVkqOuz1rjQhipc3SZJGJ0yfovXu
	 uVeWQntB3EX/mGcealhxnDGiY8w4QypM7tXXdG0WN20h8NLsNotCY/JWSv33PyfgWA
	 cxzcynlMluLX9Ne86OY63RagFeIGJJMPXf7JAZzq+M3D6FH6nBTju1Rms9Wk6XkotI
	 R2HcvATWmH6OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Techie Ernie <techieernie@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/752] Bluetooth: btusb: Add USB ID 0489:e112 for Realtek 8851BE
Date: Sat, 28 Feb 2026 12:39:47 -0500
Message-ID: <20260228174750.1542406-276-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Techie Ernie <techieernie@gmail.com>

[ Upstream commit e07094a51ad8faf98ea64320799ce550828e97cd ]

Add USB ID 0489:e112 for the Realtek 8851BE Bluetooth adapter.
Without this entry, the device is not handled correctly by btusb and Bluetooth fails to initialise.
Adding the ID enables proper Realtek initialization for Bluetooth to work on various motherboards using this Bluetooth adapter.

The device identifies as:
  Bus 001 Device XXX: ID 0489:e112 Foxconn / Hon Hai Bluetooth Radio

Tested on Realtek 8851BE. Bluetooth works after this change is made.

Signed-off-by: Techie Ernie <techieernie@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index adc5a686c0f59..4c802b0f2f516 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -521,6 +521,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3601), .driver_info = BTUSB_REALTEK },
+	{ USB_DEVICE(0x0489, 0xe112), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8851BU Bluetooth devices */
 	{ USB_DEVICE(0x3625, 0x010b), .driver_info = BTUSB_REALTEK |
-- 
2.51.0

