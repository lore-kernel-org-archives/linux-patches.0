Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB1E18DF80;
	Wed, 25 Feb 2026 01:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983935; cv=none; b=MDhq7fjgNdjOgYVi7DEaVUkRX0VggpRnhFHRaZMeADzaAEXjiXi0aLeiuIgBtVxWEC8MAd7qAuY2w3bk4vZop0vHSJ55ImEtZriqVxVMDnyeuvFkGvRDtdvQXhxX9j49+qHJOJIr2ETG35oAOc4YsxWKE4W3qcaiknr2Mj4Czeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983935; c=relaxed/simple;
	bh=Z30WJ10w4qKEdXjTXnrXPrXBcTaMHoyODvr4mt0/eiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBoEk3/885bbD4FJCVwXGX5efNVorDtmgx1ikwtN34ucZIQvUKwZCeSBmlieU4MSgqPHMmYVCf7fUZvRzaXAbrHhpn7YMFi1C6jr1GAei97k/1c7MesZKeGDxVV3G89qfG0OIfmD9SuJ4LKFvw0oAuKz0RiNoPKmPB5mJ/Hgsdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=065gvbMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="065gvbMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB34C116D0;
	Wed, 25 Feb 2026 01:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983935;
	bh=Z30WJ10w4qKEdXjTXnrXPrXBcTaMHoyODvr4mt0/eiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=065gvbMO5bLij4Ssq4WWT1lLfSq2K5daMAaygKcx0PGI86mGEP0iVZbdgK3XYbY1G
	 Alsn1mDglDuUvwe8tB7HuAoZtQrd/A2tqMai+PGFm7cNJXmsYLd03GI5vcSW5iNxDw
	 lFYEe9lxR2r2OxNJ9wjCpd7+TaudWprFmK/mSVzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/641] drm/msm/dsi_phy_14nm: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:18:46 -0800
Message-ID: <20260225012353.822605799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 1d232f793d4dbffd329ad48b52954d4c8ca24db5 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: cc41f29a6b04 ("drm/msm/dsi_phy_14nm: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/697613/
Link: https://lore.kernel.org/r/20260108-clk-divider-round-rate-v1-24-535a3ed73bf3@redhat.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index fdefcbd9c2848..a156c7e7cea83 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -628,12 +628,7 @@ static int dsi_pll_14nm_postdiv_determine_rate(struct clk_hw *hw,
 
 	DBG("DSI%d PLL parent rate=%lu", pll_14nm->phy->id, req->rate);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       NULL,
-				       postdiv->width,
-				       postdiv->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, NULL, postdiv->width, postdiv->flags);
 }
 
 static int dsi_pll_14nm_postdiv_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



