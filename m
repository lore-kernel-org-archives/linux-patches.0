Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04C228DF3C;
	Wed,  7 May 2025 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644698; cv=none; b=DkslyQrFBrA435lkNLzj2sR+57QvfnCUWGWKg1WCInurDtYjlfqh31ECimBpJE+sGaL2FU+TwA4z58frN4wysLBqmYL83eJ64ADY010CRC2BvKRmT9uhfUmfIwHedbOo+8Ww56DrWArzBjV8wFqF6JgdCKbpqMT7zZHXQsS469E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644698; c=relaxed/simple;
	bh=RIdfq6LQa7/SDKSSSwtdjhc1TC6O5yS9gQyN541zSGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbKIqW37RW6oIt13Wpkl/sFSrZzQ2B6/AO06SEGr50k4ca0BXWrfkoUZXkHBvLrUXCTndFJmS5MWqQpZZNV7h1e++V2WBGR5f3fMx/pwUxbHpjKSmyS64/U/enfEXzrfCFvBDX/jEzvDSOaECyIFx2oOdTt9a0vqPdYZFxJrHvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EK8wMPO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EK8wMPO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426C5C4CEEE;
	Wed,  7 May 2025 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644698;
	bh=RIdfq6LQa7/SDKSSSwtdjhc1TC6O5yS9gQyN541zSGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EK8wMPO1M5NO7mICOZEFa1W2MTELdLskp2IDBtK87d9ENIrcrhLcKJEf5fyR0id2d
	 1rZwfKhJjJtOTwOMBf0/Et8mJE0tuvxHfG0AAbLiiM7ETn1ekfDm4qRd2iodwirjMH
	 k0MaIxA0PhyrH9w7apGsPXyrCOdr3t/D1gqiLVRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/164] net: ethernet: mtk_eth_soc: sync mtk_clks_source_name array
Date: Wed,  7 May 2025 20:39:32 +0200
Message-ID: <20250507183824.486019533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 8c47d5753a119f1c986bc3ed92e9178d2624e1e8 ]

When removing the clock bits for clocks which aren't used by the
Ethernet driver their names should also have been removed from the
mtk_clks_source_name array.

Remove them now as enum mtk_clks_map needs to match the
mtk_clks_source_name array so the driver can make sure that all required
clocks are present and correctly name missing clocks.

Fixes: 887b1d1adb2e ("net: ethernet: mtk_eth_soc: drop clocks unused by Ethernet driver")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/d075e706ff1cebc07f9ec666736d0b32782fd487.1745555321.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 223aee1af4430..5e7280479ca1c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -269,12 +269,8 @@ static const char * const mtk_clks_source_name[] = {
 	"ethwarp_wocpu2",
 	"ethwarp_wocpu1",
 	"ethwarp_wocpu0",
-	"top_usxgmii0_sel",
-	"top_usxgmii1_sel",
 	"top_sgm0_sel",
 	"top_sgm1_sel",
-	"top_xfi_phy0_xtal_sel",
-	"top_xfi_phy1_xtal_sel",
 	"top_eth_gmii_sel",
 	"top_eth_refck_50m_sel",
 	"top_eth_sys_200m_sel",
-- 
2.39.5



