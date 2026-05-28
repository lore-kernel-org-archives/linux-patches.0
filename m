Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520272F1FEC;
	Thu, 28 May 2026 20:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998404; cv=none; b=GcUPCtmrWhStKP9UIJ9EqDA1c58cw7SqWzBKenLfpeyRlqwmGcxqNejNnIbu3avS+rtjGm/GhqgmjhOrWftAlgp74j09n/mZGCFTs1ONFibC5rQEOAwFxyzBw+chfMoPqyqbPsHfZvze0YET97upH7H3N2hONCn6bcdnczgc0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998404; c=relaxed/simple;
	bh=YxZLm8RcTiaYLUOfwCPYpV5Y0HgeQ+mdyB9jEToSbMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7035+ztZSdUMDGUtIhBJOV/HuODF68Jz8FAhwB4lYurOMfr3uMFY3t7rFt/7wNs9FSmypcRsGqZyNVhhm4yXIel6mBc1OyVwsu14on4IBR8gQvX2zEpeuMCfKRy8RtFbNnipaG5oTyzc3bBJiGpZRjGEkahBIXxxrmDwPjsnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJYxDcDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJYxDcDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0551F000E9;
	Thu, 28 May 2026 20:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998403;
	bh=y3BC7volhL6qyQylbVJdCfye97hyJD9sNK4NAJruKzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJYxDcDBaxp0Ww1Pniqf+J4MKWpHUPNbNaouGHJsXIlRuS3+gPMLTp8bDBTwANwcR
	 /b3AXiubJ9/9uZIwP7uYv6uKom4pP5ZkjI4gzTixHP3HM90nDWdhLWmc+TSJB5TzGm
	 AdVCLusEPumS1nmS010v4lDhKD0VkJzVrVyfEdYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.0 114/461] phy: qcom: edp: Fix AUX_CFG8 programming for DP mode
Date: Thu, 28 May 2026 21:44:03 +0200
Message-ID: <20260528194650.273584246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongxing Mou <yongxing.mou@oss.qualcomm.com>

commit bf237a9fcbbf9d658522f7315ffc04bf2d49be42 upstream.

AUX_CFG8 depends on whether the PHY is operating in eDP or DP mode, not
the selected swing/pre-emphasis table. All supported platforms already
have the proper tables, so remove the unnecessary check.

Cc: stable@vger.kernel.org
Fixes: 6078b8ce070c ("phy: qcom: edp: Add set_mode op for configuring eDP/DP submode")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Link: https://patch.msgid.link/20260427-edp_phy-v5-4-3bb876824475@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-edp.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-edp.c
+++ b/drivers/phy/qualcomm/phy-qcom-edp.c
@@ -256,12 +256,7 @@ static int qcom_edp_phy_init(struct phy
 	       DP_PHY_PD_CTL_PLL_PWRDN | DP_PHY_PD_CTL_DP_CLAMP_EN,
 	       edp->edp + DP_PHY_PD_CTL);
 
-	/*
-	 * TODO: Re-work the conditions around setting the cfg8 value
-	 * when more information becomes available about why this is
-	 * even needed.
-	 */
-	if (edp->cfg->dp_swing_pre_emph_cfg && !edp->is_edp)
+	if (!edp->is_edp)
 		aux_cfg[8] = 0xb7;
 
 	writel(0xfc, edp->edp + DP_PHY_MODE);


