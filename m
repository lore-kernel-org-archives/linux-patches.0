Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B81718A6AE;
	Tue, 17 Jun 2025 15:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174599; cv=none; b=jOoOY9T+6+V5YXtOUhhL2yeHTbrg8txgOXQd08HaIFkZW8va0oTjBTwwF/2vF4Unt50CEpKmElwM9PSJ7kuulTX0QDO2BjOPXaUjemkXUc3Re6fel1y6xCMPVTLdNFcoHx9Mh0OnAMPdCNhe57dlNCscTMpSJronkWPBaiEzdiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174599; c=relaxed/simple;
	bh=aFAwHBsLzfUcD7mDwysCiKvLLiMjo15EGMBOIY1Orz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHShf2feP2O3+JOVEhcnERXBz+ISsrt+YPYhogzLcncvP+biWUo+wTOLd2cJL9R8j76xkJfOFqsg6hg9YEFZtnyrC7s1RPj8rCk5W1al3qvdGp2uIn3OykdZdhiCncvc0GR7tffAl0kV+1NPnrKCmU033t6CxIxk1mFG/qEnEqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGbpzkLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGbpzkLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C858AC4CEE3;
	Tue, 17 Jun 2025 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174599;
	bh=aFAwHBsLzfUcD7mDwysCiKvLLiMjo15EGMBOIY1Orz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGbpzkLcsSj6gkCXev5CIiSbq93QaFQfyRKa2LFdhqXKFZ30sxa2qTV4TUc9JhB4s
	 aF0KppRzpTx3hJ6bd/6x5PnqHN5P3nqlXbQTqUfM+D0wid8r9GXwLBMxyQgM7tlGZb
	 xJIUbqVPzJjKIZnoKGMv/q+f/UfGxcXdgpxprpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/356] wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally
Date: Tue, 17 Jun 2025 17:23:27 +0200
Message-ID: <20250617152341.921296606@linuxfoundation.org>
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

[ Upstream commit fc5f5a0ec463ae6a07850428bd3082947e01d276 ]

The rtw88-sdio do not work in AP mode due to the lack of TX status report
for management frames.

Make the invocation of rtw_sdio_indicate_tx_status unconditional and cover
all packet queues

Tested-on: rtl8723ds

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Zhen XIN <zhen.xin@nokia-sbell.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250410154217.1849977-2-zhen.xin@nokia-sbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 4df04579e2e7a..832a427279b40 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1223,10 +1223,7 @@ static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
 		return;
 	}
 
-	if (queue <= RTW_TX_QUEUE_VO)
-		rtw_sdio_indicate_tx_status(rtwdev, skb);
-	else
-		dev_kfree_skb_any(skb);
+	rtw_sdio_indicate_tx_status(rtwdev, skb);
 }
 
 static void rtw_sdio_tx_handler(struct work_struct *work)
-- 
2.39.5



