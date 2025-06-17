Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAF2DFF04;
	Tue, 17 Jun 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175447; cv=none; b=J0lVBkPZbipAJG2zc9x+woLSZD4x7xpS6VPJ+xVK9ZPsT8SQvawRJ6xTZ0lwYi34CMV8PphFgyDgcOpRIFkNHNmWzSuCEG2OKy0mix7H7lFPCWSxI3fmKQX9c2w7h/w1rxeavSDtMI+R6ifSPbwPpyGAsEsm4l24v9VCHpkDHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175447; c=relaxed/simple;
	bh=6wIwrUIevz0OAjkhvA/oili5iKUANLSisFQ4vTdy868=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glTDJC/zy0dvlch+/jrBGSFb8NsaVdULli/I9Ryd7LNUe+bXqcI4u/BDp3gngerqGuj25l+nhr9io+B2Itj27AHbO2ZuPa6xttVUjLJVuo8WTjhxgSiIq3GwXx/sfxUZHKERTkWo1r24TyQHkhw+oPFFCDdsPrhF1abfxGwrAKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4Z21GXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4Z21GXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78268C4CEE3;
	Tue, 17 Jun 2025 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175446;
	bh=6wIwrUIevz0OAjkhvA/oili5iKUANLSisFQ4vTdy868=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4Z21GXTEKSITkJBqt194J96AVpeUdSyKUEx9Ro8V3eKoHd2CghJMYTdHA+LTVuLg
	 xDwVwNAMnuDHhntThBRSdzaGTZOpzMJ0HOD9Jn3JjlPQc1uRhWTEoDcP6Mf/jhiM9B
	 6t6Fez0ASWmm80CztZBhZP1Sdcub8HW8hYJyYtHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/512] wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT
Date: Tue, 17 Jun 2025 17:21:33 +0200
Message-ID: <20250617152424.736054267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 1d62b38526c48..0316a0bec96e2 100644
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



