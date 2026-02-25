Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA32BAF7;
	Wed, 25 Feb 2026 01:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983102; cv=none; b=OEu2OKo8sRWlUPS+11j1YNdKZq/l8U7hGslXE4uffTAUCU/6ugVFYsIZOOJZqUgtIIHkSn8zBOgXiNHhCuLEOD3jbonBPKBwIt07l8t6G5DvW3ri6Fan57IERNJOPKirAKLx/wvGH5nnQcIG/buZQMk6T+y03Vhdmkzl/CR830M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983102; c=relaxed/simple;
	bh=OCCDPr2zUDY1OP+GVUrmIJB5r8vIpzPYSL0i1/hQtDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM13OS3ZtNqpBUoiyOB8DQqjc5m35TNa8GiDtSpkR3Fa+tcygToWNvwKGfhnjxZrr612W54J+fZaM2i9IYjnjl22xHMGRDunP2GH6b5hLmknFNSClI0eS7WjKhDFceeoulURGxD63sRXM0eZ5NLOCmRzqX+zIyT4am2QWdhPy4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUfc4acn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUfc4acn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9565AC116D0;
	Wed, 25 Feb 2026 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983102;
	bh=OCCDPr2zUDY1OP+GVUrmIJB5r8vIpzPYSL0i1/hQtDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUfc4acnMJfu9YTxJ9eKlLyJQ6CeheEEOk/M/UbN+Lwdnk0Dug7i725x5bnGIuERU
	 TLxleAGEub5gxFFR/9sGneOMLvZTCihtrCVKX/+mfaFCK8MXCic50wxgGf95NnohTU
	 n3J5pJsSDypEjHnb8o+qg11UwFjQFdO9ZX73gmJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 264/781] drm/msm/dsi_phy_14nm: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:16:13 -0800
Message-ID: <20260225012406.172237834@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



