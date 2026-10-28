Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212385;
	b=AE6M+az3SSYOg+CDqMXv6n8/DPG6V9RPrdJp7Dpw2b2H8AU7Uuk6plXnX035hbFZcQ1O
	 GwonNd72CJr4XzD7pzLjpdBexpTqyF9+xwbEHbl+PCNKdAIZoZ3s18wMWA4Elq4bK4QCv
	 Hdx1niGRFADF8nTPp+H3JN62P3mHVJI+T9ocFu2GHVnijj5t+bRK03ezulDiPDfmGJ9E1
	 IMDrsi1GOMO5fNBwiWMQ8q8YhxSFrrbN5hALm9G219XOnZKInOPyKA5cSyAL8KintrdH1
	 yvxjWjVgWBjJ44ArBEr4R5A3HmhgUxA96QfF4KE0ci+1MPW12bO06GnBtOKpOfvkm2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueRYI/Ha/AmhfB7ZBforjMiETQaaQQhArK1Er4bjVa8=;
	b=wJBAkLsAnJmikrrWPjPI4qse78O7hrfVABuCOJ9ai4hsLAeBmfrv1tYR5nc19TMoqzRs
	 jKqhWJhRAEWHNsQBu7ll7XprQM/hEf2QwRtf6+qc5nLCmIFhTXixzpG1Huz+4VAS4s0i4
	 F0mHagUmRPICpOMZkkZiTB/4mhJnfKqsFbHHLoBmgJMAWr6Q/YZvbu6BFmqG1jw8SUqQY
	 1LEvE41Ir0cKuWyYw4Obqj7byFCBIOJ9bbtIaTq8UaEyvsoeWO2BdATAiZZTZyrJyFkTE
	 +LBtZVZH7Zvg8DOAYb1T28aO4BOel4J4m1MVUAxrc312zsTyuYVcC2WuC37gDQ7zpdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsN9TdF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E259D606A31D;
	Wed, 28 Oct 2026 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsN9TdF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1BA1F01825;
	Wed, 28 Oct 2026 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212384;
	bh=ueRYI/Ha/AmhfB7ZBforjMiETQaaQQhArK1Er4bjVa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsN9TdF2FTnM6Mo0SAzR8TDy8OcnV93JvFhlHnL2H/61hWImzfFWUbDJnvYq0Iysx
	 AmK3fTayZ+rxa9VDbzChql8mzMVUu0vA2nSfxyz22gVPq+AVRewi/iayLf9SVxE6Uo
	 LAYvprCcvIYvDkj/yx7SsXK2Nz8oL1aXalSYSpq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0135/1887] wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown
Date: Wed, 28 Oct 2026 17:37:11 +0100
Message-ID: <20261028170502.307743762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit d9be5e75530772fc31637070d51e5717d6aeaa2a ]

wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
which only dequeues the timer and does not wait for a callback that is
already executing; the preceding free_irq() calls synchronize the
interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
therefore be running past the teardown and use the wcn freed along
with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
reads wcn->tx_ack_skb and passes wcn->hw to
ieee80211_tx_status_irqsafe().

Fix this by using timer_shutdown_sync(), which waits for a running
callback and also prevents the timer from being rearmed again. The
timer is set up again by wcn36xx_dxe_init() on the next start, so the
start/stop cycle is unaffected.

This issue was found by an in-house static analysis tool.

Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260910020907.3353-1-fanwu01@zju.edu.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ Adapted the patch to replace del_timer() instead of timer_delete(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 4e9e13941c8f4..b168db800e07e 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -1054,7 +1054,7 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
 	free_irq(wcn->tx_irq, wcn);
 	free_irq(wcn->rx_irq, wcn);
-	del_timer(&wcn->tx_ack_timer);
+	timer_shutdown_sync(&wcn->tx_ack_timer);
 
 	if (wcn->tx_ack_skb) {
 		ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
-- 
2.53.0



