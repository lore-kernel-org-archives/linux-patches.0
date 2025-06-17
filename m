Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3104E2F362C;
	Tue, 17 Jun 2025 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176535; cv=none; b=rl2Jpv1X0OMGJL2edp2tUzdZw2RZI2K0/44qtawsktVbbqx0Vi+f67QzPDUDV3wmy15a/WItZ+XpJIJ8RsCxtAsgMJRWTlMZpEofvbNO+1XSy4VidyrSSSNqrLJwTZ/EDjd2DgiwQB5zy/HJvjJ7d/8zEuPquB3M50gL/jelKPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176535; c=relaxed/simple;
	bh=8YnolWLG41LWxjEibj7TR9wr6q8M5DNkuyRWaoTTm3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4tShLLRDrvmivvSurIyEzsDFqI+4M3oykFbFah6P4mBvSX/TfVJ55YvcwnahKO/fOWWhw6L8FwFdDFUKxLepOcKiWPu5xgJ1AIUvQ/ThvNBC0FdDu7p8ION6WbOqvG2/v4e3PFmn8KvtIQd5hHd8pNAQ+kIKQpze1hDgnwO0CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg7Hgxgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg7Hgxgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43837C4CEE3;
	Tue, 17 Jun 2025 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176534;
	bh=8YnolWLG41LWxjEibj7TR9wr6q8M5DNkuyRWaoTTm3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg7Hgxgqh60mayPr6r3+tvZvgycagA2lYvg1k1PkPCWohQJbtL7aDKhV5hndLpXzq
	 jt1CeZ6XQH5rUWXjKzy8+kesupafuzhuzPmXY+PNUnJmFUJdi9g34n7rGHoYGsKaW2
	 cAs1ONKm0b6EVtFKb2ibqweZoe3vx3Hzlpb9FkZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 199/780] wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT
Date: Tue, 17 Jun 2025 17:18:27 +0200
Message-ID: <20250617152459.573292226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6209a49312f17..ba600d40bba46 100644
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



