Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023CBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A91C4339E;
	Tue,  7 Mar 2023 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209534;
	bh=rfVfIaRx6dePdCZ8joFqIgq3d63uUC9LR8Nftb6vJ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhH8Jqky7kPZXBr9S+vMdU8RpMEDADlVYjx4Ri/GsTzu6qHrFQlTZ1o+/OeSSXLHE
	 FVlQsp35LD5xoSAHGI+711hDoPQc0uq10EyWPgrPCRaVbvnidiX19Lt723Nd9OUrmV
	 1+JPMCei4uSkBlq+c6z6DfO9jvq6qekng5rvvF+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0249/1001] wifi: mt76: fix switch default case in mt7996_reverse_frag0_hdr_trans
Date: Tue,  7 Mar 2023 17:50:21 +0100
Message-Id: <20230307170032.604309774@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit aed8d9b506c22848add261ffad8fdabc57f21964 ]

The switch default case for frame_contorl is invalid. Return -EINVAL
error for it.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ce4242f90e9f9..96ced4c039ce1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -469,7 +469,7 @@ static int mt7996_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	skb_pull(skb, hdr_gap + sizeof(struct ethhdr) - 2);
-- 
2.39.2



