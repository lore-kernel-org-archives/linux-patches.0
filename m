Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B9A1FF5EC;
	Wed,  7 May 2025 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644014; cv=none; b=GuaQFZaT1sFs8B7KtwMVP5jx2nyuL0ofT9b+50WBCLiSd/srC6mrhbWQP8kdsoyuOMhfeyo0P2DBJoUAkC8xj/TqGAb3U0ciAzgiPMkl6cZpmlGCVvMKUPx5b6q8RIrFhIYz1hXvZDq3Nk8yXRMXfh+o4SlcJ/Y3xF8S467ZvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644014; c=relaxed/simple;
	bh=HAi9yoqyqsHK05+fVAMFOHHvKaM65JsbUT9nkgDDtAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nluz7QP80kJvmDek7SPqI5NpObBOY8pfS+ddYEhZ80WsJADW+KQxOmcbZq6jxf0ao4ZQdSrYwVjfU8/13sNza8mM14pqNIbU0VhGS2NBTF/lLE0p9pkR0quzltMuVLQnwMIkRqok8lf1dU7+Ad+a1/tJ8sa+JBAazakYxhY0Dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAWMtRL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAWMtRL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86051C4CEE2;
	Wed,  7 May 2025 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644014;
	bh=HAi9yoqyqsHK05+fVAMFOHHvKaM65JsbUT9nkgDDtAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAWMtRL20kt8+p2qqPQcwas2OCuzP9WRgB1bn6x5ZXkI6BOT+NsqaxQIMjY23XN1f
	 MhuEmIPHKu4vQXBJrjYsMDNDsEEIoU3gy2OtXam+7DnfTQHfelSDU9mHkI9YTycaQf
	 AcGWoj0MnlX/YMIT7os8JkzjllCUVW4QJxX0XHts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 092/183] net: ethernet: mtk_eth_soc: sync mtk_clks_source_name array
Date: Wed,  7 May 2025 20:38:57 +0200
Message-ID: <20250507183828.551026718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 477b8732b8609..1365888a4be11 100644
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



