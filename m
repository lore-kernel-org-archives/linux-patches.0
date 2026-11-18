Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030643;
	b=ZEuKsrfHcn/Opy78+00qcGzfcd5iy8GqDxho3CJqwfxH9gjURuO0TYMPlEM6dT1WK8CV
	 1IN7ZgWcgQ5fqW/YkTzNbDn1Bl59gNhE18ZDo7YyShz/DvWMMz3aBpzuYr6wjtEK3uGgf
	 Q4Hk2OTMOKygb/0Kl/eLhEZEPz8/cnAQ7LWtnvAehM6XH4eR2qN6HazU8QXTPzdoaUznP
	 PhG4zeCP/26ryWozkMOBPF71RPVRTi+Li2wxHfh4AJtBdmAax6hA++lUrCu1GS622v1DW
	 EnYkkFLY8G/FCjqZ4Fy0uHs+ptgSEdYZBoKnFqg7ALG9o4z3RmyDlQg9IQssjm7FXUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hlbs1Kvu6J0bTbU1h2HFgjHHiNmyMkuMLGBnm65Iymc=;
	b=bGosDIhrgRuvqo/PdIao2xirsC5S1Q2ebXZFlHnY48nhkZIT5Kz+ew1dv3IpMaCBS65S
	 JmSb6acOR0hYCU+vZu4LydkCNqVNFBuK21QgJakOQU6TBOKkNgaIUJB6ZxTJk2ZHUKprh
	 MKAUAt/kaBWMMlUDRigOUEbn1WZneI/oKJsAN28iwQEEOqz5YqMoG1gXwS2+Au1WRBOOS
	 3lr5poKuAG0G7aen/kYCNB499t8ZJsKI88McnOXFacDwAagY+era6WQOkLZ9A83rCNk/A
	 dY5JsjZXEt0zZgIk9Z6XoXv4cFGE07SuVSvgz4UM8v/mQGHE8BRLcZg8MT/R0m6BmSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dzx0E9JE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F01606A31C;
	Wed, 18 Nov 2026 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dzx0E9JE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9D31F000C8;
	Wed, 18 Nov 2026 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030643;
	bh=Hlbs1Kvu6J0bTbU1h2HFgjHHiNmyMkuMLGBnm65Iymc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dzx0E9JEVLqwEbfIHGzp7i0QYDKsXGwCemsZoOw+ASciZwjHmlX3LpXbVcOOr8OCt
	 2Rcn2oOI0bHSAKql6MvG0Cz6/jqocX+ELfLh2okdDkCEwRJzzbiOwoUdsEITbDMY/p
	 PE9dnqKq5XFO6wzNIweUNIgSFlU3xsw2z7LLKHQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Sukhavasi <akash.sukhavasi@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0776/1756] phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118150040.518689095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Sukhavasi <akash.sukhavasi@gmail.com>

[ Upstream commit 7540fc0a4f667b6773d10753a602a42a3113087b ]

When hi3670_pcie_pll_ctrl() fails, hi3670_pcie_allclk_ctrl() returns
-EINVAL directly, skipping the close_clocks cleanup path. This leaves
the PLL with its power-down bit cleared.

Use goto close_clocks instead, which disables the PLL and propagates
the original error code from hi3670_pcie_pll_ctrl().

Found while investigating a Smatch warning.

Fixes: 73075011ffff ("phy: HiSilicon: Add driver for Kirin 970 PCIe PHY")
Signed-off-by: Akash Sukhavasi <akash.sukhavasi@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708-b4-hi3670-v1-1-f9236f3e585c@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hi3670-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/hisilicon/phy-hi3670-pcie.c b/drivers/phy/hisilicon/phy-hi3670-pcie.c
index 6903148367dfc..e99ef06d41c81 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -476,7 +476,7 @@ static int hi3670_pcie_allclk_ctrl(struct hi3670_pcie_phy *phy, bool clk_on)
 	ret = hi3670_pcie_pll_ctrl(phy, true);
 	if (ret) {
 		dev_err(dev, "Failed to enable pll\n");
-		return -EINVAL;
+		goto close_clocks;
 	}
 	hi3670_pcie_hp_debounce_gt(phy, true);
 	hi3670_pcie_phyref_gt(phy, true);
-- 
2.53.0



