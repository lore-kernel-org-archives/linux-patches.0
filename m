Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CD62E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8875BC433C8;
	Wed, 20 Sep 2023 12:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212006;
	bh=urahMXo2oEKPLFjZyH16MfsF6hrGrxxOtG6CjKCGxAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+1YfhgNjCHI93bUQ8J4GiE5g4qnEU/OoivYXfoieOODqCXE7f7D4b3AbKKXbFiwY
	 AWB7nspKnX8BAtKpXykMZHX9moqs6VneYdetnmAkPJaULsEG7WSS6etoKVwAzKwFl3
	 xOq7DWnCJQNMLOGaoFann8LgoUHz/EsIf19Rb9ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/273] drm/amdgpu: Replace numbers with PCI_EXP_LNKCTL2 definitions
Date: Wed, 20 Sep 2023 13:29:16 +0200
Message-ID: <20230920112850.074538854@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 35e768e296729ac96a8c33b7810b6cb1673ae961 ]

Replace hard-coded magic numbers with the descriptive PCI_EXP_LNKCTL2
definitions.  No functional change intended.

Link: https://lore.kernel.org/r/20191112173503.176611-4-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ce7d88110b9e ("drm/amdgpu: Use RMW accessors for changing LNKCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 22 ++++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/si.c  | 22 ++++++++++++++--------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index 40b62edd891f3..95b3a1f601e8b 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1491,13 +1491,19 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 
 				/* linkctl2 */
 				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 7));
-				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 7)));
+				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN);
+				tmp16 |= (bridge_cfg2 &
+					  (PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN));
 				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 7));
-				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 7)));
+				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN);
+				tmp16 |= (gpu_cfg2 &
+					  (PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN));
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				tmp = RREG32_PCIE(ixPCIE_LC_CNTL4);
@@ -1514,13 +1520,13 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 	WREG32_PCIE(ixPCIE_LC_SPEED_CNTL, speed_cntl);
 
 	pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-	tmp16 &= ~0xf;
+	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
-		tmp16 |= 3; /* gen3 */
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
 	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
-		tmp16 |= 2; /* gen2 */
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
-		tmp16 |= 1; /* gen1 */
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
 	pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE(ixPCIE_LC_SPEED_CNTL);
diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index 3b9e944bee180..e5fe304a28156 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1662,13 +1662,19 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
 
 				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 7));
-				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 7)));
+				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN);
+				tmp16 |= (bridge_cfg2 &
+					  (PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN));
 				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 7));
-				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 7)));
+				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN);
+				tmp16 |= (gpu_cfg2 &
+					  (PCI_EXP_LNKCTL2_ENTER_COMP |
+					   PCI_EXP_LNKCTL2_TX_MARGIN));
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
@@ -1683,13 +1689,13 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 	WREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL, speed_cntl);
 
 	pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-	tmp16 &= ~0xf;
+	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
-		tmp16 |= 3;
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
 	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
-		tmp16 |= 2;
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
-		tmp16 |= 1;
+		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
 	pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL);
-- 
2.40.1



