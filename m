Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366DC281369;
	Thu, 13 Feb 2025 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457762; cv=none; b=msDhho3lvNhs9QAbRJc55LbrUQ96paYW1wLfFZ4I9sc1lmwxcHFZ6HwRWucDDx2ehrmaZ+XOD9uGYrxRSH9x0jqkxDF6IOG1CCl4LEmP+UtVd4eaLVuRDakpk3ez0iPEyVug5Z/LNa/ehuTL5y9xfqmZm5Y31QN1AdiDU1o4vGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457762; c=relaxed/simple;
	bh=RemUqDVAE4pgGFwmWtJzPbt6bIoZ81+nhUE0ujAwi68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r46g6wvzlbTFL4ltmfTNSkz4zQkxTkRndBeXUQvJUD7eaLHRG6NT176TVlicugjTqaJrljpNIPpHv2plhUjMuL4B0r1iiNdGpX/fogCa67OAn7vV+Eo4e7Ftk1ZICV+KbyOtQPuiBiErsrdWxUV+lC7cKxwjcS3ct0n8Qqa9QZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ7hREKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ7hREKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F7FC4CED1;
	Thu, 13 Feb 2025 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457762;
	bh=RemUqDVAE4pgGFwmWtJzPbt6bIoZ81+nhUE0ujAwi68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ7hREKKn9wLpPWEUQCi0yCu8wlOSEcir+kOd+R9CxqthHDcYB0kLUglWlGZEMi7N
	 uLKivrrfFvOKj4YOapRyfFktoS4JhtqxP8mkdYOuVE1e2dpV1vboNQWnqXYeIyVaFc
	 9z1vZlQT9TRupg7PwXlCXseIjNUPdlOSWwwa1Toc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Fiona Klute <fiona.klute@gmx.de>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: [PATCH 6.12 207/422] wifi: rtw88: 8703b: Fix RX/TX issues
Date: Thu, 13 Feb 2025 15:25:56 +0100
Message-ID: <20250213142444.528502816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

commit a806a8160a0fcaff368bb510c8a52eff37faf727 upstream.

Fix 3 typos in 8703b driver. 2 typos in calibration routines are not
fatal and do not seem to have any impact, just fix them to match vendor
driver.

However the last one in rtw8703b_set_channel_bb() clears too many bits
in REG_OFDM0_TX_PSD_NOISE, causing TX and RX issues (neither rate goes
above MCS0-MCS1). Vendor driver clears only 2 most significant bits.

With the last typo fixed, the driver is able to reach MCS7 on Pinebook

Cc: stable@vger.kernel.org
Fixes: 9bb762b3a957 ("wifi: rtw88: Add definitions for 8703b chip")
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Fiona Klute <fiona.klute@gmx.de>
Tested-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250103075107.1337533-1-anarsoul@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8703b.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -911,7 +911,7 @@ static void rtw8703b_set_channel_bb(stru
 		rtw_write32_mask(rtwdev, REG_FPGA0_RFMOD, BIT_MASK_RFMOD, 0x0);
 		rtw_write32_mask(rtwdev, REG_FPGA1_RFMOD, BIT_MASK_RFMOD, 0x0);
 		rtw_write32_mask(rtwdev, REG_OFDM0_TX_PSD_NOISE,
-				 GENMASK(31, 20), 0x0);
+				 GENMASK(31, 30), 0x0);
 		rtw_write32(rtwdev, REG_BBRX_DFIR, 0x4A880000);
 		rtw_write32(rtwdev, REG_OFDM0_A_TX_AFE, 0x19F60000);
 		break;
@@ -1257,9 +1257,9 @@ static u8 rtw8703b_iqk_rx_path(struct rt
 	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x38008c1c);
 	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
 	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
-	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N, 0x8216000f);
+	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N, 0x8214030f);
 	rtw_write32(rtwdev, REG_RXIQK_PI_A_11N, 0x28110000);
-	rtw_write32(rtwdev, REG_TXIQK_PI_B, 0x28110000);
+	rtw_write32(rtwdev, REG_TXIQK_PI_B, 0x82110000);
 	rtw_write32(rtwdev, REG_RXIQK_PI_B, 0x28110000);
 
 	/* LOK setting */
@@ -1431,7 +1431,7 @@ void rtw8703b_iqk_fill_a_matrix(struct r
 		return;
 
 	tmp_rx_iqi |= FIELD_PREP(BIT_MASK_RXIQ_S1_X, result[IQK_S1_RX_X]);
-	tmp_rx_iqi |= FIELD_PREP(BIT_MASK_RXIQ_S1_Y1, result[IQK_S1_RX_X]);
+	tmp_rx_iqi |= FIELD_PREP(BIT_MASK_RXIQ_S1_Y1, result[IQK_S1_RX_Y]);
 	rtw_write32(rtwdev, REG_A_RXIQI, tmp_rx_iqi);
 	rtw_write32_mask(rtwdev, REG_RXIQK_MATRIX_LSB_11N, BIT_MASK_RXIQ_S1_Y2,
 			 BIT_SET_RXIQ_S1_Y2(result[IQK_S1_RX_Y]));


