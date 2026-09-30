Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD19C51AFD2;
	Wed, 30 Sep 2026 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789216; cv=none; b=p/LWUXRnEY+/6XlHai9nwYMMpVRJy6bv++IabJads5iok4OcU66YX3bg89eGxYGwUD2mQE+lrBcAiPomQWRDa4ahVy7zWM9W9RVKyKoLpVNsoxrVo0fuCgTOFU+PeTwjalSeiHi0N3HQEUB/ZNYF0QdSuqO7EI+hzSwVKpWwHyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789216; c=relaxed/simple;
	bh=LQlgrEUBN3z+hr5k9p4LOi7g4wmwBDvnwduQGYv6Uf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIocPDPVNEnmX6IUyrS2byZ7zv5cS+K5bMpL1a04ahovsClcZTSWLwFRbhkIVaEQYKML70Gdq6NdWznJSDHMiHaUOwA7U0g2lVPkft02jm6FNiH79ycyagw6bygBxEtLipD36ae1peIsNdT1r0dqPGEP2Fq+D54hm7KTewfkVnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyLfHBHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyLfHBHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134791F0089A;
	Wed, 30 Sep 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789215;
	bh=NwDWaSE9Mb+YJuX+tzr4AUXQ5zfQLOuonrSs+RS58Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyLfHBHLaCoyMq9mF5gJ19ARn4CF52XI1rTSF6td1CDREj0vxCvkM/RDeB8wuJHxZ
	 Ih2ayYwPZrWVQANEwJ62asqaUQGFw9hzPwtTkDuxvc6in8HBE6a8gGbyUDRs6Ini+a
	 50425gV+uCTX+CZ34OkIj4aAmfAGR/f+6jJ+4GiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/877] net: stmmac: selftests: Check the dev->features for S-TAG offload testing
Date: Wed, 30 Sep 2026 17:21:48 +0200
Message-ID: <20260930152423.247609263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit ba804b23d76d278ee475b8427fa7c5623ce5e270 ]

The S-TAG offload insertion incorrectly checks the dvlan (double vlan)
DMA cap, which is different than S-TAG support. Use
NETIF_F_HW_VLAN_STAG_TX to check if the feature is supported instead.

Note that this flag isn't set in stmmac yet, but contrary to ARP
offload, this is a feature that has a chance to get there eventually so
let's leave the selftest here for now. It'll report -EOPNOTSUPP in the
meantime.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260917215339.2022523-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index e1a5a0316d8d9..6f2edff624134 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1395,7 +1395,7 @@ static int stmmac_test_vlanoff(struct stmmac_priv *priv)
 
 static int stmmac_test_svlanoff(struct stmmac_priv *priv)
 {
-	if (!priv->dma_cap.dvlan)
+	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_TX))
 		return -EOPNOTSUPP;
 	return stmmac_test_vlanoff_common(priv, true);
 }
-- 
2.53.0



