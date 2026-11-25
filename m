Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624076;
	b=a0xRcRmOWr2/pmvMliXPqN7jcUJfhDVdwi4bJvWz3nZMfqkKqtgHxEyTsqmVjn9+kukH
	 XuPJSDpBfNgpqCh2j53Mlw0luljaluV1GWaCp5tGp2BFdif1l/M4XIAtuf+yaXX3uGEu8
	 cxVN43zRn+ruongD1Tmy1bZlQr8okSRVhbo06OyGs+Z23aRZSoGBVyKA0dTfwZzv8/pvD
	 2bTqIscPNlgaApSSoMUL7FqVtzyObnaZdZwKtCLYLcVfwRv7jbalolMAAWULrBe/qur1N
	 HKD0PWzAawW2YtUJd+ArNwMW6iuFUWgH4GdbcKP7r51vHWs10YikxPy6p1YLu4fSnqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EmdDc3jtk4rnwWjaT9T3WeStciMkKOs8YeKlrWWdH6k=;
	b=rxB6O4GUi/fqCfzokXV8e3/wJx4GzeYY3BHY8KY9/wMmPkZy9SpckOTIawTwcK7NjZ+7
	 z2M0J61ksS6ck6owa9RvU/F47d6RJQ020KDQIW+ts0AvhGIu4FiWxc+/ojnXGs5vWX6mo
	 uaGfIKnrmIBVxvoJ6YdnaBrAUuYcfbeLst7y/j6fNmCfpo24PynBP5j1lrmrEIfdBZfsY
	 JahpkQG55fgn7Kxpambnyt8ne4DopxF04hSmbrxwOzDEQxIwvEcxunZZ99/yGUCHdGpff
	 53Zeitv1YAPkH8SqTEKt6/hM9MfPBaA3q8Dx73MHqdo5JlyULTspM+e+pcbAj2KX9zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DY075oc6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F7D606A321;
	Wed, 25 Nov 2026 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DY075oc6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE951F000D0;
	Wed, 25 Nov 2026 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624076;
	bh=EmdDc3jtk4rnwWjaT9T3WeStciMkKOs8YeKlrWWdH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY075oc68GQ2y1s661/oPnBFIXqbEU/UDQPk490YLZA1CieUNn/f5s3ZktJuXi2bG
	 3nHmVGlMhnWuuB0TcPqwmk5GKHTYw5CEQXy/M8Wqg97PU/GYaWRw4vDYJY832OJK5N
	 AnK8U5KFl4I5qugJz9yx5kjS9xDfBVcQ/m9LazG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/816] net: ethernet: mtk_wed: setup WDMA_RING_TX(0) for non-DBDC MT7986
Date: Wed, 25 Nov 2026 15:27:04 +0100
Message-ID: <20261125143850.981284377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit dd6efae5529107cc8db277eaeaff5c5f15e6bc15 ]

WDMA_RING_TX(0) is required to set MTK_WED_WDMA_RING_TX for WED RX
but on a non-DBDC MT7986 it is never setup because idx is 1.

Setting MTK_WED_WDMA_RING_TX with WDMA_RING_TX(1) is not feasible because
WED still tries to send through WDMA_RING_TX(0). This is verified with
register dump.

Fix this by calling mtk_wed_wdma_tx_ring_setup if wed is v2 and
rx_ring[0] is not allocated and reset tx_wdma[0] if it's already
allocated also add error messages and bail when mtk_wed_start fails.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-4-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 005b653a7e3a9..a8a78ea9f2352 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -2346,7 +2346,20 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++)
 		if (!dev->rx_wdma[i].desc)
-			mtk_wed_wdma_rx_ring_setup(dev, i, 16, false);
+			if (mtk_wed_wdma_rx_ring_setup(dev, i, 16, false)) {
+				dev_err(dev->hw->dev, "wdma rx ring %d setup failed\n", i);
+				return;
+			}
+
+	/*
+	 * non-DBDC MT7986 allocates only rx_ring[1] and tx_wdma[1] during setup
+	 * but tx_wdma[0] is also needed for WED to function.
+	 */
+	if (mtk_wed_is_v2(dev->hw) && !dev->rx_ring[0].desc)
+		if (mtk_wed_wdma_tx_ring_setup(dev, 0, MTK_WED_WDMA_RING_SIZE, !!dev->tx_wdma[0].desc)) {
+			dev_err(dev->hw->dev, "wdma tx ring 0 setup failed\n");
+			return;
+		}
 
 	mtk_wed_hw_init(dev);
 	mtk_wed_configure_irq(dev, irq_mask);
-- 
2.53.0



