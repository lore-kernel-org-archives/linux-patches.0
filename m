Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB241F75B7;
	Tue,  3 Dec 2024 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239342; cv=none; b=FFtjqES1HFE50U/fryrPcWunN3V59WGGwAbOw5Pz54dksN36u3t9/adlcCY5yeS4JEZ2/ZoIKgUJcsnyOZF4FLCCSc3OvVdSIGRDHRlgNtatztqMU3YAn6wVy5Hs0AsP5+/LhfnAXqlchb9nIX/oTp9XYV1T9uHDv8slx19Y/TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239342; c=relaxed/simple;
	bh=iSwwvW+y51kq4ZzCPifiS0zRlvZtlBurq0TDFb8O7P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8qId/2uj0o59ZwtDYaOCFYBIPCCDL85eD5XYURMhbK2e/Dn0M7cyMVudKnKvgCvO/A2Cucr9kD3VTop7hDa7uoz4S20RNskqsRMCg5MOun4Gw9R/DGubVpBFeJRMbTJhWtcQeyqe3DZS90MgiMUgRecVtTqKCVGHAZV6MXf7J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fvaz0p4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fvaz0p4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7145AC4CECF;
	Tue,  3 Dec 2024 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239340;
	bh=iSwwvW+y51kq4ZzCPifiS0zRlvZtlBurq0TDFb8O7P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fvaz0p4JB1M0GKdGQ4guqrga/HNqaHsI5xUGjZktrkO054lkVYeuc+sh0nSzSHvzu
	 uPE0bOCHj4cb1+eILJqU57mdJODmSi0ZN4NSFPyxi3Dovh/46ljBxfw5BjXWbYnsj0
	 crjSQQlsQ/6y0m9NlztxzL8hoGlvpvy+kXVAx1Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 549/817] phy: airoha: Fix REG_CSR_2L_PLL_CMN_RESERVE0 config in airoha_pcie_phy_init_clk_out()
Date: Tue,  3 Dec 2024 15:42:01 +0100
Message-ID: <20241203144017.336229918@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 09a19fb75498985cbb598f1fa43a7d2416925c30 ]

Fix typo configuring REG_CSR_2L_PLL_CMN_RESERVE0 register in
airoha_pcie_phy_init_clk_out routine.

Fixes: d7d2818b9383 ("phy: airoha: Add PCIe PHY driver for EN7581 SoC.")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20240918-airoha-en7581-phy-fixes-v1-1-8291729a87f8@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-airoha-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-airoha-pcie.c b/drivers/phy/phy-airoha-pcie.c
index bd3edaa986c8b..3113be0a0e5b6 100644
--- a/drivers/phy/phy-airoha-pcie.c
+++ b/drivers/phy/phy-airoha-pcie.c
@@ -456,7 +456,7 @@ static void airoha_pcie_phy_init_clk_out(struct airoha_pcie_phy *pcie_phy)
 	airoha_phy_csr_2l_clear_bits(pcie_phy, REG_CSR_2L_CLKTX1_OFFSET,
 				     CSR_2L_PXP_CLKTX1_SR);
 	airoha_phy_csr_2l_update_field(pcie_phy, REG_CSR_2L_PLL_CMN_RESERVE0,
-				       CSR_2L_PXP_PLL_RESERVE_MASK, 0xdd);
+				       CSR_2L_PXP_PLL_RESERVE_MASK, 0xd0d);
 }
 
 static void airoha_pcie_phy_init_csr_2l(struct airoha_pcie_phy *pcie_phy)
-- 
2.43.0



