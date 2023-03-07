Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DBDBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F745C433EF;
	Tue,  7 Mar 2023 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209166;
	bh=g7LA7gJVmd7MenBk4WFEPNIZtEEhoLZUHGMu4bfqYO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIX1yeQTHK1mBnmN+344m1ovkzwy9ZxRrpRhJKqtPKWiVfOjthja1PXyu7fmDGin5
	 PkqUTV5gvO2vg0tKoEbq2+VALxCpWD8Igb0sdd+fsKvbctr5N0r2YLwxVguUNXJ4fZ
	 Hhafyk87sam6OKLkjEQy2Zzug7pO7Uv/AUM1Umlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0132/1001] wifi: mt76: mt7915: add missing of_node_put()
Date: Tue,  7 Mar 2023 17:48:24 +0100
Message-Id: <20230307170027.793698928@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 18425d7d74c5be88b13b970a21e52e2498abf4ba ]

Add missing of_node_put() after of_reserved_mem_lookup()

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index c06c56a0270d6..686c9bbd59293 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -278,6 +278,7 @@ static int mt7986_wmac_coninfra_setup(struct mt7915_dev *dev)
 		return -EINVAL;
 
 	rmem = of_reserved_mem_lookup(np);
+	of_node_put(np);
 	if (!rmem)
 		return -EINVAL;
 
-- 
2.39.2



