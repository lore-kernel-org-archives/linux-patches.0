Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060604;
	b=Cg4ZfXZomeuphuZcpMCE9CIg0GvMpEwSk4RyREUkYzdtXwSORc3AtusxCb87Yw/9YHHx
	 w1qoIMDISaOmStBcnbSlbS9JrVfCRDV7v7bVfLVD6XNnwZO/uW4dZoXmu8wOf4MahUQ9P
	 H9BkmXUvXV9voD6hQNSw0225rx9UrfDsfqjgFwxnblyb8kZibgQrBFFnkgteYeOWK12j8
	 XTzAYj+KfUnLWbnQVmJdhly/jSCgJ2GarcFyfkDSOHfTFfLWxv7Lm9a9oXt3N/PvksXjZ
	 zHANY+77gzMU8BGyRbEj/WmOcE78c9pPKKPhudejJr8A4pkW5Iw6KVshTcWe5jblc1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISr1tKopIqSWaHJHNaG1THz7GuXHB0+USrzouYE6pAs=;
	b=gc3+KkR3b3AU/Fn/g4KSgmzX0T5ERu+tTRrj9PSXI1QW73wabW/go4SHClG9vatlblE3
	 czolDmUMfZjF0sUq2+0Ik65RxWd50El1HVoC5OWhjJLL5Oy0EabDlalQV+fM+nPqK46Eu
	 Rm008IWgOMFKh0owONmn/H/rAg4sVqi2OOc/6wiNN2Ed7P6mFZ+7Qkg6YX9fP47d6zuiV
	 fH7Vrfi0qktl5NIJZXpI+Achuu/UKKkRkWUZQB9kkDawJowOsgs14KErQmY67hLUjpKC/
	 hP/lHijOds0b/kWWdtz1DiJ0I/j8i/rpk76T6gviWA0jRn70H3zelFIbvyODgHV+yIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uawfvPwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDFE606A32C;
	Sat,  7 Nov 2026 14:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uawfvPwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4421F0089F;
	Sat,  7 Nov 2026 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060604;
	bh=ISr1tKopIqSWaHJHNaG1THz7GuXHB0+USrzouYE6pAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uawfvPwUSaCKdJDz4tR50wI79wngzo8wWPoUakm0t0WAX91LnjfzWJgnttTYixDZV
	 Hhf+MEM666DB0KRUGBQwtSl9Hp+riNDwktvQtthr5QiSywBXlY1iMotN2m8ESUHE7o
	 IUk0OpZbnF7UBcLHpHZTxF4CDvxcIGXBHM8ZTI7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0057/1536] drm/amdgpu: Guard reads in pcie state readout
Date: Sat,  7 Nov 2026 08:34:33 -0500
Message-ID: <20261107134959.264254238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 9c89e234c7869..87e21de7f5710 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -757,6 +757,29 @@ static struct aqua_reg_list pcie_reg_addrs[] = {
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
@@ -764,7 +787,7 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 	uint32_t start_addr, incrx, num_regs, szbuf;
 	struct amdgpu_regs_pcie_v1_0 *pcie_regs;
 	struct amdgpu_smn_reg_data *reg_data;
-	struct pci_dev *us_pdev, *ds_pdev;
+	struct pci_dev *us_pdev;
 	int aer_cap, r, n;
 
 	if (!buf || !max_size)
@@ -796,25 +819,27 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
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



