Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7650B509F06;
	Wed, 30 Sep 2026 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792413; cv=none; b=fgWuYv/CM6uRJ+06jpDyGKgqWwyi5kHfxZ+iiSo20pWUy3tMaPDVAZm5D90lRb8ZLlsdAUw5cGKnhRFhqINYekgxkoK8T3EgophFmBwZUsRWpYrM2h5vD6DhBBecf9V3lRNww9CHhUQGnnFrHZVQI3v1OjhWJ+m2JO27ZqJgkz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792413; c=relaxed/simple;
	bh=UhRJci+e4Xo8ol39JtmB/4BxTRRi2chxkRw3dTUq5BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBDejjPodBywMyM0QnwCtsl6RTDumVMPU2WSbt7zre2HStLDk6oYNzRXujKe8cgForyLhM9hXl/zOG6FYt29nfmpxPXseS3b6vk9PjaZ+NKo0ph4VifTaY0oOpjsgUFG+5xR6vNGyu3CSwAt4JW1dE7Pk0V4dS5XsGLCPUpLJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppfSPUey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppfSPUey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28981F000FF;
	Wed, 30 Sep 2026 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792412;
	bh=hnx/pPJVNpNnYte7UoT2TSeEAnKUUerEKqWirZOdyyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppfSPUeyFA+T7pYViSxHvXYrMCYWYPDC3RVH0vkCa8snqz75Ua76LZfeK1hyRg5qY
	 CqYKe97s+548aR2qauSCUy0rmHOQEUFnBIS3XfP6UGMHWlalz8/JciP095PvDh9wsf
	 w9mqA/hKgIaDdJcCwzvTlhMp0Y6vrIxWpoARRqzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 644/752] net: stmmac: selftests: Check the dev->features for S-TAG offload testing
Date: Wed, 30 Sep 2026 17:28:34 +0200
Message-ID: <20260930152412.200876654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce7a4d0c54eef..dd6ef393b1966 100644
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



