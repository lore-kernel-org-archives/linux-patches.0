Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064522;
	b=i4jsC37xMhxnLwPbPWcKqOOkjx/Gj3mdG9+g+zFfOc+Wcos7LXZ0bhZCJXG4dwEVVDpb
	 UAug//bG/9TCyFVvK2UiiazRARwabL+9XujbdV6Pid9jnMXwKvPgtct7YSk/IZmKmsnf7
	 eBFKGtRJdGotgAkXFxzi5jgOdbf6olkYLU9CdfgJ1FM8F4JXKKjkLbKUc2TSFNPwhEFlw
	 PnEi0NXKM8K9u0UbSfpvKEmOf88/UfftBbKnUkR4Q/PtvAB83t7HJEMYiVgAwZuntp2Zk
	 07e0p2OF//f4llW9z5cEPNTrcusSVoVijh27zakvHzAD3yRGSsHe4sktJsCMmKIpVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Iaer0xno81RyuIRdaK45560/iKH4UpCFAAE2rIykow=;
	b=ezcFgUzYd33bKr3JQCE2Cb42+h0ECCeW0EG4D2ghNIIONue/l4QN2As0z2m/ED90a8CV
	 D75zNwvScz4u9t9mb80uUXzcxL5qs3fLdmUfpbjRbR3ZVThrVGLQulwOdHtGQ+mqCF+GF
	 9Nz7a1NU4PyTxDc5ql+qjMM/ujcXm9MqcnSoaGdBcciCtCPVc7dbIyVdK0qRYozuy8rzY
	 KavN9H8aARtzFdA7sbcqu6r+pNQ9k15jhutDl1ywsELsrSeb22vswKtCJYZVyU6K2Z43H
	 iImLV7YHwceiq095sSHWa9I2eRG+rNSr9yjAbrDACf3PGAZiHqGdIyf3shr1zVmr7eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSnFnpS5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D534606A32C;
	Sat,  7 Nov 2026 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSnFnpS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF431F0089F;
	Sat,  7 Nov 2026 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064522;
	bh=9Iaer0xno81RyuIRdaK45560/iKH4UpCFAAE2rIykow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSnFnpS5ZAup6lrvJwg2U5ff7NGZCw1QG85hgmquvc3EfQzXfacjNJo28KNd92Dxb
	 da2ojHzagRW6u9Ru2YR1VUrNnFOgKQTiasYj2e8qQK/IUKw25Jl7ukGt5ThyKbpipt
	 bCYCd2aJCV6uuyopk63WHyAAMNpVAc+d0Ok/D8+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0553/1257] wifi: rtw89: usb: shorten the RX aggregation hold on RTL8922AU over USB 3
Date: Sat,  7 Nov 2026 08:47:29 -0500
Message-ID: <20261107134954.661108198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 83de3a16c7b37064a59305040ba9b0f93b832794 ]

The RTL8922AU holds received frames for up to a millisecond before
handing them to the host, a value carried over from the RTL8852CU.
On USB 3 that adds up to a millisecond of round trip, and under load
at 160 MHz the access point drops to lower rates and download suffers.

Shorten the hold on USB 3 only. On USB 2 the bus is the limit, and a
slow host needs the long hold to keep up.

RTL8922AU on USB 3 at 160 MHz, power save off for the round trip:

                         x86, 6 GHz    x86, 5 GHz    Pi 5, 6 GHz
                        before after  before after  before after
  TCP down, 1 flow        613  1002     579   948     587  1010  Mbps
  TCP down, 8 flows       656  1187     629  1080     605  1122  Mbps
  round trip             2.33  1.29    2.25  1.18    1.42  0.84  ms
  busiest core, UDP 200M  8.4  12.8     8.3  12.9     2.1   3.3  %

RTL8922AU on USB 2, Raspberry Pi 1 B+ at 5 GHz, 80 MHz:

                        long hold  short hold
  TCP up, 1 flow            102.3        87.7  Mbps
  CPU, UDP 20M               50.5        77.4  %
  loss, UDP 50M               3.8        85.7  %

Fixes: 32cee8a9bb66 ("wifi: rtw89: usb: Enable RX aggregation for RTL8922AU")
Reported-by: Nick Morrow <morrownr@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20261007210958.56528-1-lucid_duck@justthetip.ca
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/usb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index aafa8b9e93dfc..22a1a988f3073 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -819,10 +819,15 @@ static void rtw89_usb_rx_agg_cfg_v2(struct rtw89_dev *rtwdev)
 
 static void rtw89_usb_rx_agg_cfg_v3(struct rtw89_dev *rtwdev)
 {
-	const u32 rxagg_0 = FIELD_PREP_CONST(B_BE_RXAGG_0_EN, 1) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_NUM_TH, 255) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 32) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_BUF_SZ_1K, 20);
+	struct rtw89_usb *rtwusb = rtw89_usb_priv(rtwdev);
+	u32 rxagg_0 = FIELD_PREP_CONST(B_BE_RXAGG_0_EN, 1) |
+		      FIELD_PREP_CONST(B_BE_RXAGG_0_NUM_TH, 255) |
+		      FIELD_PREP_CONST(B_BE_RXAGG_0_BUF_SZ_1K, 20);
+
+	if (rtwusb->udev->speed == USB_SPEED_SUPER)
+		rxagg_0 |= FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 1);
+	else
+		rxagg_0 |= FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 32);
 
 	rtw89_write32(rtwdev, R_BE_RXAGG_0_V1, rxagg_0);
 	rtw89_write32(rtwdev, R_BE_RXAGG_1_V1, 0x1F);
-- 
2.53.0



