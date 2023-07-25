Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73C615AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48193C433C8;
	Tue, 25 Jul 2023 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282658;
	bh=kK0bVCKqojvfcHew3zJ5fmoz2XFHiYAhE8yeQHK8vlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGs5PezjsXkE8cBi70lwxc3OLiaoHhoWEO/7QaA5T3qvokCUcmVjsFGBAIbUZncRj
	 0bQURuEsfZa2TZHIkC2XCBIJUJiHoizo1zFlG4sd8tqHWdF4iBvjQ6QkQBjtqehpBb
	 u3BjvJt9Hbe9yW5l3HTgbbO9/qW0XLFwEkR+Mrhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 191/227] net: ethernet: mtk_eth_soc: always mtk_get_ib1_pkt_type
Date: Tue, 25 Jul 2023 12:45:58 +0200
Message-ID: <20230725104522.714191935@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 9f9d4c1a2e82174a4e799ec405284a2b0de32b6a ]

entries and bind debugfs files would display wrong data on NETSYS_V2 and
later because instead of using mtk_get_ib1_pkt_type the driver would use
MTK_FOE_IB1_PACKET_TYPE which corresponds to NETSYS_V1(.x) SoCs.
Use mtk_get_ib1_pkt_type so entries and bind records display correctly.

Fixes: 03a3180e5c09e ("net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/c0ae03d0182f4d27b874cbdf0059bc972c317f3c.1689727134.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 316fe2e70fead..1a97feca77f23 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -98,7 +98,7 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 
 		acct = mtk_foe_entry_get_mib(ppe, i, NULL);
 
-		type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+		type = mtk_get_ib1_pkt_type(ppe->eth, entry->ib1);
 		seq_printf(m, "%05x %s %7s", i,
 			   mtk_foe_entry_state_str(state),
 			   mtk_foe_pkt_type_str(type));
-- 
2.39.2



