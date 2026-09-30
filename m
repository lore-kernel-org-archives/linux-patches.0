Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661B46D559;
	Wed, 30 Sep 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787364; cv=none; b=Txick4lCSXHpB62DA2wWQI/1BsrGkS7AX3al5acdpkEyFG4AavwmgeiObjLmYxNlXJ2csFbOLTxRu4FAZzkALPYZZb+8Xk8VxajAYuYcgk3T99nJy50F8/w1n7oPVtXcQng6LAkl4Zhe+/BRHwXPvApMWHiFw6veDdAL2JXeo5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787364; c=relaxed/simple;
	bh=KU4VXf4DOILTCHI9heLcZuadEPLu0PJV+4KSp4sz0w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1ha50uVMaTSiNiRaYqHgcAg9Rt8VebnMvIadqusjgWaBqSYqq+YtIgt23MzInQ3QW/apmGVi//kSlPB+9gX3rnLEjBDFbEvh4YEqcSvRktUUwyZagTfgqjuLqzIIoAfGUNaDpGXaU6xLJZ8wr7wgvBxhXy9oqYnvYNs8vMU67o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2xuxJnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2xuxJnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAE41F000FF;
	Wed, 30 Sep 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787362;
	bh=+KgkdhjUlUU9Noa69p2Eo0LFuinqouobZIZVBs8zCGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2xuxJnA3RSCemLaAL5eczc+VWHmnU6BsnOaqKr6TDf03GUvCB98rZi0tHcsKvfeh
	 BbkcZTpMZ98YBaPSPtKZtVxleB/kEvfqt7HCE/bKQOeEPhtJTqaIAAo6r4AU7fkUv+
	 fcqez7YlIquKozADw6xfnk0Vd09zejh3fT35amS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 159/457] net: stmmac: selftests: Check the dev->features for S-TAG offload testing
Date: Wed, 30 Sep 2026 17:24:24 +0200
Message-ID: <20260930152349.480848069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 045d644ae50b5..53bb911b69ffb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1435,7 +1435,7 @@ static int stmmac_test_vlanoff(struct stmmac_priv *priv)
 
 static int stmmac_test_svlanoff(struct stmmac_priv *priv)
 {
-	if (!priv->dma_cap.dvlan)
+	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_TX))
 		return -EOPNOTSUPP;
 	return stmmac_test_vlanoff_common(priv, true);
 }
-- 
2.53.0



