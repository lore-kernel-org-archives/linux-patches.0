Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAB523CE;
	Tue,  3 Dec 2024 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241857; cv=none; b=VKVfvmEOcHlodYWgrqGFb4gwGKQ/E2yOSgJ54QhB18c6JK5zzwD6ESnU1suDmhZS7cVMkSmlvzzcOmlAFDJOfTyabIbjwIdq/hrxUrTZ114lfdwJVgRSTUfYv5/w7v9hpO3JtaYd/1g7orDq7555xELk8yAmfwDiEWe7K5WeYk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241857; c=relaxed/simple;
	bh=izbBIK3zoOFaNIysmynFRtanAdmxCZUrFKtA9klKzkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X++yEw440Nss0rG814ev8K3q2szlrLpUuhX8DfOjmPgtZE6EiCAnuZoQZ56ACCmMx48u6r9NcSKBsp2Nd8HfHdncakQf5VMkLE7/gF/r+ypLQBPEkRuXwjnEVs/usuUu3OL8rbMvw+pZhpJ2lwhD8bZ137H7ZBRnNSDsvobjoCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpdlNrUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpdlNrUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC95C4CECF;
	Tue,  3 Dec 2024 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241856;
	bh=izbBIK3zoOFaNIysmynFRtanAdmxCZUrFKtA9klKzkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpdlNrURQDeZP7jEQignj8NpIAeSMoNBH5rmzls+6R7hQVYwDt3opUNgGqn1PZNGG
	 yI5zFPZ62vnNWKP2gT8C0zRavavugbqQbht3PsY70XVTbjTaawlNqJnVXI8mDCxgz1
	 FqbJDbKkUbn9nSRMuowMBsObSHja/X8WAZYVh1Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/826] phy: airoha: Fix REG_CSR_2L_JCPLL_SDM_HREN config in airoha_pcie_phy_init_ssc_jcpll()
Date: Tue,  3 Dec 2024 15:44:24 +0100
Message-ID: <20241203144804.703125661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6fd016c965d241673a2e62afbf9eeb4bcbfbbe45 ]

Fix typo configuring REG_CSR_2L_JCPLL_SDM_HREN register in
airoha_pcie_phy_init_ssc_jcpll routine.

Fixes: d7d2818b9383 ("phy: airoha: Add PCIe PHY driver for EN7581 SoC.")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20240918-airoha-en7581-phy-fixes-v1-3-8291729a87f8@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-airoha-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-airoha-pcie.c b/drivers/phy/phy-airoha-pcie.c
index 9a7ce65f87f05..56e9ade8a9fd3 100644
--- a/drivers/phy/phy-airoha-pcie.c
+++ b/drivers/phy/phy-airoha-pcie.c
@@ -802,7 +802,7 @@ static void airoha_pcie_phy_init_ssc_jcpll(struct airoha_pcie_phy *pcie_phy)
 	airoha_phy_csr_2l_set_bits(pcie_phy, REG_CSR_2L_JCPLL_SDM_IFM,
 				   CSR_2L_PXP_JCPLL_SDM_IFM);
 	airoha_phy_csr_2l_set_bits(pcie_phy, REG_CSR_2L_JCPLL_SDM_HREN,
-				   REG_CSR_2L_JCPLL_SDM_HREN);
+				   CSR_2L_PXP_JCPLL_SDM_HREN);
 	airoha_phy_csr_2l_clear_bits(pcie_phy, REG_CSR_2L_JCPLL_RST_DLY,
 				     CSR_2L_PXP_JCPLL_SDM_DI_EN);
 	airoha_phy_csr_2l_set_bits(pcie_phy, REG_CSR_2L_JCPLL_SSC,
-- 
2.43.0



