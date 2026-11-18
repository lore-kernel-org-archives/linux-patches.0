Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055324;
	b=OTzPT09wd4e4JAVHgbW5joogotRzm+0Idrix/3l06JKIO0jRp31gAk2+5T/MWrbGekyR
	 ilFdFMi7U32iXb2CAguLbcrTC3mww0yXLyCr4H1FvYyiWFjeU2nvffFwfEGXFiH4twZDf
	 2MZWElXqXd2AK6cwbBHQYgyrG47uo4USGkopwTQhlUUbmPh1PHxxXtAl4BBPrSg+WsXEv
	 PzTnuGrvoPa9NtseCLH9678Lydq80LZRcRjBaMK3DWMzBTnnkkQpLXJgRkqIHNdVWVcmm
	 RS3D1N/I34bJnSUlNVXBz+ZWT2Ex1eCg80893tG1u/EyvnjA5yqrk3DLyqCEQKsJe3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qQx7Mk3jyh+tnYYtGfR+edslO7fxMwxivSTpoxq3pck=;
	b=uIzNX1GFMrwuG2lYePal/q3z+ukkG7bcdfez9dXcyMy434+WFj08WoQXVSa9Ic50wc3j
	 smj4eoH3kfzATSExfkSkkac7YjEubcUrCsVq9thYjWU97JCU4XWVRqizrEOEudrmSGyHh
	 4FI++qXkupn4tHSjrTvsezG0FO7xS3vLyNbhMXe3u8UhjxC+Fovg6y7On7YMO6eaLfro9
	 TvbQyY5ES3clnpUb915wFj7jAicbviKjeFJodM2LNp3RV5jjEd5UTIKnkTCBoeMARI8+I
	 MU8R92oPeCldfxCdARVnScYTB4oLnB02mKFW0x29yhk7wN2pBVm5/q+xncun6PHZcXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riZNN1PF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E3B606A339;
	Thu, 19 Nov 2026 02:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riZNN1PF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FA21F000C4;
	Thu, 19 Nov 2026 02:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055323;
	bh=qQx7Mk3jyh+tnYYtGfR+edslO7fxMwxivSTpoxq3pck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riZNN1PFlIxesRLlmilJmwqiJE/JkSDtvD377/yzSUgPfyQlp714q7EwWBwKL0lYE
	 1LGSvvFcjfzI8g2cw8Ib9D3J5hiPZtQs++Shuu1q7+pNn1t41324HkB9Bw/ZvoILtK
	 p1FBboinX3GaBP886sOXO3y34QhBaV5V1ifRPSeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1553/2214] wifi: rtl8xxxu: Use dev_* instead of pr_info
Date: Wed, 18 Nov 2026 15:53:49 +0100
Message-ID: <20261118150114.233005889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit bd954a7e4aa0739630884fc572d2d0e4dcd16e25 ]

Replace two instances of bare pr_info with dev_info and dev_warn.

Also make their messages a little more informative.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/c9f3ebb2-769b-7d80-cac2-5a9d1bcc010a@gmail.com
Stable-dep-of: 9f7edf4e8584 ("wifi: rtl8xxxu: free RX skb when URB submission fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 526491b1ec082..d95ac983177af 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1996,7 +1996,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
 	if (val8 & MCU_FW_RAM_SEL) {
-		pr_info("do the RAM reset\n");
+		dev_info(&priv->udev->dev,
+			 "Firmware is already running, resetting the MCU.\n");
 		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
 		priv->fops->reset_8051(priv);
 	}
@@ -5228,7 +5229,8 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
-			pr_info("failed to requeue urb %i\n", ret);
+			dev_warn(&priv->udev->dev,
+				 "failed to requeue urb with error %i\n", ret);
 			skb = (struct sk_buff *)rx_urb->urb.context;
 			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
-- 
2.53.0



