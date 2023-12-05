Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160076FAF;
	Tue,  5 Dec 2023 03:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF3kfLAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A176DC433C7;
	Tue,  5 Dec 2023 03:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746630;
	bh=VtkESP/eImXc3FF5qT0GLlrJqspfqTPu9kn8WvIdi7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF3kfLAYbmvaPYrkBtA8gk0A/qpCDSBVO9NyOqscsqC13mOYQ+T1M1kLYm83Nrd0f
	 +kHgdRTxtuB6mts6Kf1pEgZ0NP3yFCEWv0/qJAWnUudNgeMO9H6BNNahACKQchX9wy
	 dtG30WjDTgKZBi8kh9bpy1rVv/kBJWQMwC1CyIpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/134] net: rswitch: Fix return value in rswitch_start_xmit()
Date: Tue,  5 Dec 2023 12:15:52 +0900
Message-ID: <20231205031540.547965425@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 1aaef8634a20b322c82e84f12a9b6aec1e2fd4fa ]

This .ndo_start_xmit() function should return netdev_tx_t value,
not -ENOMEM. So, fix it.

Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 898f22aa796e2..3ccf93184c9b2 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1532,7 +1532,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
 		if (!ts_info) {
 			dma_unmap_single(ndev->dev.parent, dma_addr, skb->len, DMA_TO_DEVICE);
-			return -ENOMEM;
+			return ret;
 		}
 
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-- 
2.42.0



