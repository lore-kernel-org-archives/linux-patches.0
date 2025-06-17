Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EB52ED175;
	Tue, 17 Jun 2025 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176545; cv=none; b=OW3K+m9oe2THUxcnoXMacHy/JYybplKoKuS8FhPT5k0b4NxkjYpuafCU9jIQaiG0WKVF3Hf3xFzkNaxQN4i8uGw57FN/FlOqpFMPUBjj2g7Lauk2mt2fJEGmEiddEkWa1bkl6XK+6Q3HoyIE2QE4485PKPF2tuKL4GpfuVpuAF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176545; c=relaxed/simple;
	bh=1WqBctlvkE6/8FTKBaC246Gcz2jJ3C0FfFBZXSefZw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggkgRkNSnkcqf4QNnUbx2a3c5II2pqc/8U3EXWMYMKQU9cpDSzLUmoCx994hEw/53CQUhA08icwqGqABOaK1np1AZa4vrD7eGkFs3Imf0lt69+/pX6p/YkS3Q4vdFwLJD4u4SQjInztJzE4dLtGF+lqFaKTEbjgElfrfuASQgGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojVTSaQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojVTSaQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90EC4CEE3;
	Tue, 17 Jun 2025 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176544;
	bh=1WqBctlvkE6/8FTKBaC246Gcz2jJ3C0FfFBZXSefZw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojVTSaQ7Msx2UGVRmwfsOjNbrZz03H70WIvH1zTVSDzIy491bbkFSGQsqwgdEKqdD
	 UVUAuR4MLtoC1ebH2dM1LM21wnOYPKTWByE1cQnIz9B1+G/KWlju587QymAlwderuz
	 ZXuiDwpLI1gqLE1dSIgktvOHVwXwOjE9VGKcv0cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 200/780] wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally
Date: Tue, 17 Jun 2025 17:18:28 +0200
Message-ID: <20250617152459.612287412@linuxfoundation.org>
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
index ba600d40bba46..410f637b1add5 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1224,10 +1224,7 @@ static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
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



