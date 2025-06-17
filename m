Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E52EBDC0;
	Tue, 17 Jun 2025 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174590; cv=none; b=WTOpDcL38YbUZOZKyNCRylOnFJQ+8vzMiqro/gUw91u2Kc0b/PWAbps56Zkp0f2tfGN3xEAcolWNKtBwG3JuAC5a8doyqZa7nGMrA3MiCOZe61nlRBhY66FMkg7BIY9RznFnxgpy3rwHiQa0oqlqez3NAR+6Zikg8bhziAxZrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174590; c=relaxed/simple;
	bh=QeB3D0gZCQxkVDVoj5cvdRv9IyPBBJhVjDUA+RNzXtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGVprHoApwH7atRA4LE4ie8e+8I2RErRtMsV2wUJ22qhW8kXSMo5xuUAcEyK6P16D/iXEpxs0SFEw+mXinu2ASe4YXPS8skvZBIawYX789NUXr3vhoiS2wFOrmtr6Ud90uk3Qi1bMCc/HpTHA69Z+yTdojBjuB7no3JZP95b7S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjXY7Jy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjXY7Jy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B643C4CEE7;
	Tue, 17 Jun 2025 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174590;
	bh=QeB3D0gZCQxkVDVoj5cvdRv9IyPBBJhVjDUA+RNzXtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjXY7Jy2yCH/xV3GIMqWss1gzdjcvp897tRsDovfpczZ33Vn+HUeC32RAyQWkapCl
	 2zBJ+Se2tSKUtQwmoWl+JZPWEi01CC+ReCQwPdSdfbdc9ufSh7Sg1EnSx8yLd9ODku
	 pmyb6mg7Yig+ZGpx80u7G9MQaIcRPaMikfzHvqHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/356] wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT
Date: Tue, 17 Jun 2025 17:23:26 +0200
Message-ID: <20250617152341.882797417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen XIN <zhen.xin@nokia-sbell.com>

[ Upstream commit b2effcdc237979dcc533d446a792fc54fd0e1213 ]

The rtw88-sdio do not work in AP mode due to the lack of TX status report
for management frames.

Map the management frames to queue TX_DESC_QSEL_MGMT, which enables the
chip to generate TX reports for these frames

Tested-on: rtl8723ds

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Zhen XIN <zhen.xin@nokia-sbell.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250410154217.1849977-3-zhen.xin@nokia-sbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 9043569935796..4df04579e2e7a 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -718,10 +718,7 @@ static u8 rtw_sdio_get_tx_qsel(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	case RTW_TX_QUEUE_H2C:
 		return TX_DESC_QSEL_H2C;
 	case RTW_TX_QUEUE_MGMT:
-		if (rtw_chip_wcpu_11n(rtwdev))
-			return TX_DESC_QSEL_HIGH;
-		else
-			return TX_DESC_QSEL_MGMT;
+		return TX_DESC_QSEL_MGMT;
 	case RTW_TX_QUEUE_HI0:
 		return TX_DESC_QSEL_HIGH;
 	default:
-- 
2.39.5



