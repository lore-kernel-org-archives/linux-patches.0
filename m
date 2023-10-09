Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1334EEA7
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5YR2EHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B11C433C9;
	Mon,  9 Oct 2023 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857007;
	bh=p8vMcipGOWxcLKhygMo4l0Ga4J3wbXeb+jxFUbHxCSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5YR2EHBZ5vqxKPpbjsZZZtWIeWu1Uc2b3jm6VNKMkkB3+7/Zcd+q4oc4uihZAVEx
	 2qpDJF7BFHkOyTIH3a36PPnOf3oD01+OdNSJPsCKZdN7i5fhleSDIU5yqSm1fMTLFk
	 S5xvg+GEVDbGcQmgeFISCpL6DWrEuVmG6Q86KQNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Yanik Fuchs <Yanik.fuchs@mbv.ch>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.5 038/163] wifi: rtw88: rtw8723d: Fix MAC address offset in EEPROM
Date: Mon,  9 Oct 2023 15:00:02 +0200
Message-ID: <20231009130125.056472844@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 2e1b3ae3e1f2cf5a3c9c05d5f961d7d4257b489f upstream.

The MAC address is stored at offset 0x107 in the EEPROM, like correctly
stated in the comment. Add a two bytes reserved field right before the
MAC address to shift it from offset 0x105 to 0x107.

With this the MAC address returned from my RTL8723du wifi stick can be
correctly decoded as "Shenzhen Four Seas Global Link Network Technology
Co., Ltd."

Fixes: 87caeef032fc ("wifi: rtw88: Add rtw8723du chipset support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reported-by: Yanik Fuchs <Yanik.fuchs@mbv.ch>
Cc: stable@vger.kernel.org
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230907071614.2032404-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
@@ -46,6 +46,7 @@ struct rtw8723du_efuse {
 	u8 vender_id[2];                /* 0x100 */
 	u8 product_id[2];               /* 0x102 */
 	u8 usb_option;                  /* 0x104 */
+	u8 res5[2];			/* 0x105 */
 	u8 mac_addr[ETH_ALEN];          /* 0x107 */
 };
 


