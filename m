Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617937;
	b=L5zkn336/dHHwYSUjmEEBCi63ChjE0JuzhZXlhahjXmlKVnOT7o8npPUGjo/4lq26Ube
	 FAMRirL4wcrL0vqBDFeSy1Ej0aLQ7sL7NzdIPsOg8geJLjLwnEkLaZa7IM0rFT97VruiB
	 25b4sgRr195hIwMqYERH5eNQ/mLCfjMV6UuzPa8wbKuPTim3LzudUQd6Ht+jIYozpTPxC
	 BpbTo9DTyxGKd4mhZigWosxLtDD0ZAL5m72fiyIQJBeqxIQw9Vj1l4fQDmNl0Qiy6+n76
	 2BnodH1qVpm306zoUvj6mjd4G+s3o/tvbnQmumlI4icJhUK4yU4yPZvgCTRafGjV7Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oZ1LyMm/i3qKTmJF1qRhMM2cpQYI6uPilYqXPvJI1As=;
	b=JRNMEtvglVq2eFNaLOYCDnxt8gX3AbC4zPB7dh9De/CM44fNyJgwLSSKuZrfRsLBZb9n
	 pnXs/tEdEHOQf0wzJjZPPwSW9FDPkqPq0TIhFW9nSoychOSKV/qfDwzKiNMRYWLOp2i7Z
	 klizY6V1MjkbT+htzB8aigPBuzqoERccNLt4lx6/ytdPO3kWdmUmrw9Ye9nwO3n8Qn5+M
	 o20hMPcVXHBmhncw43GhjG08A2W4kG/2JW4hdGxOIUgB1GMVccJEUEKKWW130iaExtiPL
	 gIBvBrCWkVyfJ31NHlSf3gV/miR4D1pmqStGtsIoFMVB0jONPWzTz37gZFLFUY7KgSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RnLoL/Jh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECDC606A33F;
	Wed, 25 Nov 2026 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RnLoL/Jh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3CE1F000ED;
	Wed, 25 Nov 2026 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617937;
	bh=oZ1LyMm/i3qKTmJF1qRhMM2cpQYI6uPilYqXPvJI1As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnLoL/Jh5sbGcm5t92GbSgE41jQAqF7Yx8b/qTDEGoqNGiVDoZFERMFn2VW5jRHGE
	 YyDoRXH3I8nxwV1YH+1f0aMC23buUT5r0WidAskc5zxA4UklKeOmSch6VGcO1gSBy+
	 uw8AxsRqu0Y34qgCxni3XTG2FSgN5OWjJEJxEXrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0077/1005] net: ethernet: mtk_wed: fix reset condition for rx wdma
Date: Wed, 25 Nov 2026 15:23:35 +0100
Message-ID: <20261125143823.543418939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 7180a42d8e616f919dcff4b90a13b9a5ecea665b ]

In mtk_wdma_rx_reset, currently only resets the CPU index of the rings
that doesn't have a descriptor. This is wrong because no descriptor
means the ring is not configured.

Also mtk_wed_start makes sure that all rx_wdma rings are set up this
would lead to no ring getting their CPU index reset.

Fix this by inverting the reset condition so allocated rings will be
reset.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724172040.1653-1-hujy652%40gmail.com
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-2-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index d55042ccaff16..3f0be70c3f145 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -257,7 +257,7 @@ mtk_wdma_rx_reset(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
-		if (dev->rx_wdma[i].desc)
+		if (!dev->rx_wdma[i].desc)
 			continue;
 
 		wdma_w32(dev,
-- 
2.53.0



