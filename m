Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AE125B2;
	Mon,  9 Feb 2026 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647573; cv=none; b=A/aSlkcGH5kv5SLab6XCKsGhbt47174qiEnKlLqNcE+9urF80wErR8Gie4D1hmF2RiNcY8GGOl9K/RqFyf9sNghaU1fy1u3+q+/Vif2+HpKlVH9CCPc84101tkpLCkM+sAmuts6m3VEGGGaCl53yGdp6sMgL1KuExnnw/7ptpJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647573; c=relaxed/simple;
	bh=moAvsI5Iqorwm+Bq/JkKsZFQZ6Ntcbz/dWYujtN9ZXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYvwfoRkyMg1+E+IBCsX5RjJAAT4A7TSd8/nZXbbhWnknsc6pD26OlxqQqKZFUOadNi49PTIzvAMESZWfvHDZNygAS/qqK5mL1roV0yzhasSQTE1XXS72iGhtI5T4Fp5zyCfuQXz8rXTykaJuvSPe81bD1zR+aBq12nJvIru0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0P3iZV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0P3iZV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C422CC116C6;
	Mon,  9 Feb 2026 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647573;
	bh=moAvsI5Iqorwm+Bq/JkKsZFQZ6Ntcbz/dWYujtN9ZXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0P3iZV9JZMVqYnSSR1BXABNNqNWoOHlAlKpPZpc1UGSVc/t+3Pj+WWR6SEctMUJC
	 OftqVMzdSxOMvXv4wsLkACZAf30Ib3fME2+XHCsvl6VrrFmikCyvTnaOpEfC0XUrtf
	 RQBDefto0YJQ12LmUjboClew8cPVFBHkPZDBlRUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/175] net: enetc: Remove CBDR cacheability AXI settings for ENETC v4
Date: Mon,  9 Feb 2026 15:23:34 +0100
Message-ID: <20260209142325.580900979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 9ae13b2e64fcd2ca00a76b7d60fc4641a6b9209d ]

For ENETC v4 these settings are controlled by the global ENETC
command cache attribute registers (EnCAR), from the IERB register
block.

The hardcoded CDBR cacheability settings were inherited from LS1028A,
and should be removed from the ENETC v4 driver as they conflict
with the global IERB settings.

Fixes: e3f4a0a8ddb4 ("net: enetc: add command BD ring support for i.MX95 ENETC")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260130141035.272471-3-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 3d5f31879d5c6..a635bfdc30afc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -74,10 +74,6 @@ int enetc4_setup_cbdr(struct enetc_si *si)
 	if (!user->ring)
 		return -ENOMEM;
 
-	/* set CBDR cache attributes */
-	enetc_wr(hw, ENETC_SICAR2,
-		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
-
 	regs.pir = hw->reg + ENETC_SICBDRPIR;
 	regs.cir = hw->reg + ENETC_SICBDRCIR;
 	regs.mr = hw->reg + ENETC_SICBDRMR;
-- 
2.51.0



