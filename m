Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A731EF0AE;
	Tue,  3 Dec 2024 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239254; cv=none; b=tjhowzgBgDVq6V6hFZj2ooEh/yIG4xgZ0CEBiQRaJK59J9v81vKSIGbpokWH+zuBywBmzrH2SdHuHnd05rDMCxejos2Yh7CjfW3axLwGz3oBdRYUN8mVcTNV3jVIpzKHpi0VrfqCg62xN05ApiaPWRJF8xUI0UlmBodLmx6z+C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239254; c=relaxed/simple;
	bh=+EWxVFaHc/tnUjQhyyqRfIVo35Fe1YfQBCXu1+ds3kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgjmjOxhVRnDxEb2pFrXTIDtuTEDNZ2Tl9YZEUe+R1dsG6lI0ZBbm6hOHBVDy2Pcm9L0K8axJhN7a5MqxCLDcXl3v9c2gfJu6Nm3YxT4Iic2hWE5cPmOx6oc0OPBcJuMe/ypD+fUvDPAibXjPzaZ248nZndG2+KAcBMnjvFWEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT75BfUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT75BfUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABCDC4CECF;
	Tue,  3 Dec 2024 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239253;
	bh=+EWxVFaHc/tnUjQhyyqRfIVo35Fe1YfQBCXu1+ds3kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT75BfUskf+Gl0SqELdmeF3KJaa+34MQVfYZXCHeMjPWCYMAjJrwAjxVlPAt0XXCH
	 VpSn8PUiUWtX4Oz4PAhZDxLmpuW5gMwi7jWBUhiWYsBEaip4s5JExzk7GmLUCpuFFc
	 LRLfwNySzsPQj0r6wg2/p9XoG6LfkH2UQSemu8no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 551/817] phy: airoha: Fix REG_CSR_2L_JCPLL_SDM_HREN config in airoha_pcie_phy_init_ssc_jcpll()
Date: Tue,  3 Dec 2024 15:42:03 +0100
Message-ID: <20241203144017.416129292@linuxfoundation.org>
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
index 3e5f49d9942a6..9d222898760bc 100644
--- a/drivers/phy/phy-airoha-pcie.c
+++ b/drivers/phy/phy-airoha-pcie.c
@@ -799,7 +799,7 @@ static void airoha_pcie_phy_init_ssc_jcpll(struct airoha_pcie_phy *pcie_phy)
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



