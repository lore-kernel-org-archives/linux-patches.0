Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D02321442;
	Wed,  3 Dec 2025 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779336; cv=none; b=B3Qb9dxZKJiqHUBRAFp1wTp/zJUaUvKMkkCg0fTDZWLH0iR7/5BRt1xPwHts4Yd20chgcf2fIaaxSFgsVwB/bcfsPRyaLzWCHD3MakjvWU7+Eu9632Yo2+nHFCsEJJfnSI802l2uUoN0mFuDH0mujGWyIWuW954SYUazC0oD7/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779336; c=relaxed/simple;
	bh=KbZX+9XMuKDoCG8jWmFZcJYTuPcnO5wcHz2gEwJew8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6aIUa16tHCaoHVntCGfQhhVq5RMKNrMuvYKkCZVWfBcpKQL65IEoB//m/q1+XIMqFkrkrpwwHERcDKs9/THO3tp4GnBBkGYzuPAbEgmjfbIonkmaTvtZaIWYrYQnpbMy2AamLdfcwzAH9MeoWTLkiRqcYA73WxZqLUoHscGH+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQwDltNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQwDltNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFCEC4CEF5;
	Wed,  3 Dec 2025 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779335;
	bh=KbZX+9XMuKDoCG8jWmFZcJYTuPcnO5wcHz2gEwJew8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQwDltNqBPZjaXkVvMlFDP++TzV+HveraBQJgyEZbI2KZgWr0DyrDSnrZwV/7Z7Av
	 5B0W1TgVmTYww/rwf/YAxPHTmmYBc7e2gcJw9z9MbekjQmUpQYtSu8pdbJlqi229sS
	 co1m3ffQophFUejJRpE4x26d2FbnOkRvGgaiXVUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/568] phy: cadence: cdns-dphy: Enable lower resolutions in dphy
Date: Wed,  3 Dec 2025 16:23:32 +0100
Message-ID: <20251203152448.415523243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harikrishna Shenoy <h-shenoy@ti.com>

[ Upstream commit 43bd2c44515f8ee5c019ce6e6583f5640387a41b ]

Enable support for data lane rates between 80-160 Mbps cdns dphy
as mentioned in TRM [0] by setting the pll_opdiv field to 16.
This change enables lower resolutions like 640x480 at 60Hz.

[0]: https://www.ti.com/lit/zip/spruil1
(Table 12-552. DPHY_TX_PLL_CTRL Register Field Descriptions)

Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Link: https://lore.kernel.org/r/20250807052002.717807-1-h-shenoy@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/cdns-dphy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
index d65a7aeefe792..565f281b36eaf 100644
--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -146,7 +146,7 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 
 	dlane_bps = opts->hs_clk_rate;
 
-	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
+	if (dlane_bps > 2500000000UL || dlane_bps < 80000000UL)
 		return -EINVAL;
 	else if (dlane_bps >= 1250000000)
 		cfg->pll_opdiv = 1;
@@ -156,6 +156,8 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 		cfg->pll_opdiv = 4;
 	else if (dlane_bps >= 160000000)
 		cfg->pll_opdiv = 8;
+	else if (dlane_bps >= 80000000)
+		cfg->pll_opdiv = 16;
 
 	cfg->pll_fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
 					  cfg->pll_ipdiv,
-- 
2.51.0



