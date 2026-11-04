Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829345;
	b=lfLo2hsGZT00wnFihrmtKDpCzpTdI7lfRkDwBKOXs4KMXqMTPFB2vl3mJXpJOQ2gaESo
	 Zp7GJ3Y0M6hptwSLmQROKIT0byVmQjwJfge05bznCGWfhx0fl3TPYnO4Ok1ly/h5N4E5a
	 f28SBF2TgBMOVgwRcv7dz0SuC/cHtrfuyOkR/YU0M0VgLMYbMvRnrgmzackdQID/Mmz3r
	 XpqmuB5rqlFH9TFu17QeXMmWowP8Z/InpJtQS4ddn4r2bFr33Lf85DxF3SAUpQvKX4XFo
	 /Tr3TE5RPWZKkYCie0elTGfWz0jbPy3rNrB+Xdw20bP8cjKB5qvICQEQWx87wh21IPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n02kr0RimIzjmb+Qu+5tpqEizuqQ8vu2TL0HtGPBL6Y=;
	b=AnoZcu9uLOxSsMviva9c84HG/0C7f0kqfphmOBHP+bAjtveD1kddW81EPCexCJqeNDAa
	 8vgulkRxRaqkqCcUb1XfV9E7cwLlTlkR1OLp9rU1DiDuAORO/loke6hHzGmksOweVIbQQ
	 qDnEgNR9+z23+kV/dDMV2SMnhRgb31blpFlE4Ln2QvF9uRW85s54ehghOnoQpOaxBc5xa
	 dlckSqMTGjNjLsGb2ZWQAdkp69Uje1Q585KVfDfbF1t/ku/RwlGxVBYvl/ytOOM3nBqkm
	 ap8z8bjR4n3FuLtr8JJe77OE+dBMtdZsXbl9iUvauUAyPrFr2/jKsVba2DKbDjVfyUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLaUNyUJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4202160A5BDE;
	Wed,  4 Nov 2026 21:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLaUNyUJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AFB1F00919;
	Wed,  4 Nov 2026 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829345;
	bh=n02kr0RimIzjmb+Qu+5tpqEizuqQ8vu2TL0HtGPBL6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLaUNyUJCl08RK3Xb3YwwNTV0EYPDbrM+/9pd9OSh2xcCeAX3qB1ljVQoB+tGV/JU
	 qqYVYhvKcXwidwhGG5LJ6zMyL/bgXDHpxH53qHgEaKwOsDtHCZJSpf+wl8K3/WdCNW
	 kRNZaC41s24EnObbjZbXKMFSGjldw2QsguSzrFYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0068/1005] drm/amdgpu: Guard reads in pcie state readout
Date: Wed,  4 Nov 2026 15:56:41 -0500
Message-ID: <20261104211045.519062681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 230753e46a4a9d04dad6a9b5dbaeb7fd52add7d0 ]

Internal US/DS switch may not be exposed in passthrough. Guard the
upstream port reads to avoid a NULL dereference.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 59 +++++++++++++++-------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index 15e70415c35b4..b73e114206cc1 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -613,6 +613,29 @@ static struct aqua_reg_list pcie_reg_addrs[] = {
 	{ smreg_0x1A380088, 6, DW_ADDR_INCR },
 };
 
+/*
+ * Return the GPU's internal US switch port, or NULL if it is not visible
+ * (e.g. passthrough) or the EP is parented under an unrelated bridge.
+ */
+static struct pci_dev *aqua_vanjaram_get_us_pdev(struct amdgpu_device *adev)
+{
+	struct pci_dev *ds_pdev, *us_pdev;
+
+	ds_pdev = pci_upstream_bridge(adev->pdev);
+	if (!ds_pdev || ds_pdev->vendor != PCI_VENDOR_ID_ATI ||
+	    pci_pcie_type(ds_pdev) != PCI_EXP_TYPE_DOWNSTREAM)
+		return NULL;
+
+	us_pdev = pci_upstream_bridge(ds_pdev);
+	if (!us_pdev ||
+	    (us_pdev->vendor != PCI_VENDOR_ID_ATI &&
+	     us_pdev->vendor != PCI_VENDOR_ID_AMD) ||
+	    pci_pcie_type(us_pdev) != PCI_EXP_TYPE_UPSTREAM)
+		return NULL;
+
+	return us_pdev;
+}
+
 static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 					     void *buf, size_t max_size)
 {
@@ -620,7 +643,7 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 	uint32_t start_addr, incrx, num_regs, szbuf;
 	struct amdgpu_regs_pcie_v1_0 *pcie_regs;
 	struct amdgpu_smn_reg_data *reg_data;
-	struct pci_dev *us_pdev, *ds_pdev;
+	struct pci_dev *us_pdev;
 	int aer_cap, r, n;
 
 	if (!buf || !max_size)
@@ -652,25 +675,27 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 		}
 	}
 
-	ds_pdev = pci_upstream_bridge(adev->pdev);
-	us_pdev = pci_upstream_bridge(ds_pdev);
+	us_pdev = aqua_vanjaram_get_us_pdev(adev);
+	if (us_pdev) {
+		pcie_capability_read_word(us_pdev, PCI_EXP_DEVSTA,
+					  &pcie_regs->device_status);
+		pcie_capability_read_word(us_pdev, PCI_EXP_LNKSTA,
+					  &pcie_regs->link_status);
+
+		aer_cap = pci_find_ext_capability(us_pdev, PCI_EXT_CAP_ID_ERR);
+		if (aer_cap) {
+			pci_read_config_dword(us_pdev,
+					      aer_cap + PCI_ERR_COR_STATUS,
+					      &pcie_regs->pcie_corr_err_status);
+			pci_read_config_dword(us_pdev,
+					      aer_cap + PCI_ERR_UNCOR_STATUS,
+					      &pcie_regs->pcie_uncorr_err_status);
+		}
 
-	pcie_capability_read_word(us_pdev, PCI_EXP_DEVSTA,
-				  &pcie_regs->device_status);
-	pcie_capability_read_word(us_pdev, PCI_EXP_LNKSTA,
-				  &pcie_regs->link_status);
-
-	aer_cap = pci_find_ext_capability(us_pdev, PCI_EXT_CAP_ID_ERR);
-	if (aer_cap) {
-		pci_read_config_dword(us_pdev, aer_cap + PCI_ERR_COR_STATUS,
-				      &pcie_regs->pcie_corr_err_status);
-		pci_read_config_dword(us_pdev, aer_cap + PCI_ERR_UNCOR_STATUS,
-				      &pcie_regs->pcie_uncorr_err_status);
+		pci_read_config_dword(us_pdev, PCI_PRIMARY_BUS,
+				      &pcie_regs->sub_bus_number_latency);
 	}
 
-	pci_read_config_dword(us_pdev, PCI_PRIMARY_BUS,
-			      &pcie_regs->sub_bus_number_latency);
-
 	pcie_reg_state->common_header.structure_size = szbuf;
 	pcie_reg_state->common_header.format_revision = 1;
 	pcie_reg_state->common_header.content_revision = 0;
-- 
2.53.0



