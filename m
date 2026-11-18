Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015367;
	b=wV5hWew6Wa4OFTlZHu/uaIzhFyJ9bWexM/vihLvx/hqTVcG+EkRebgcCEzfDXTSGvJ91
	 pp03cVKvOEmnt/9ajFV9XGgeXwIKZjPaqJzt7KAjtfM8hc4HRdeMk1cxXXhnMpli5UB6c
	 kGUcX97PHevro1MRPtqwQsvewOCO4xklOXXoHF4pZMOtmPaA5x9u8JV2DWdUl+LoNFTkb
	 jFSG1wTOGN/LO4+X1KCx6/whgthfAbPEAKHj/KzalGdO4CBiVLsjamdL167gjdjB8PwW1
	 Zp1Ixc3idMbDUyIAjRNWflLzNJitY0U4V+/aeP8tXVlPwHuUxt/IKs8UYlDklbGNN2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3mEjyHl7bWFF8AJkUuI71S9NFj0bkvJUB/3c4h9bE8=;
	b=e7Z3G5kFNh5KKGtSs3BdO8S99tHtpvdLR87v1rw/+/Us5h4AgxLz7+xX3XQEFzgEUp02
	 iN/O4zEdPr6onqpq/bv1/VJl5cZ/OqoSKTbT/CylXJUBO5eGs0jqiMvs08foyRkUIYpbN
	 D6Ny3l1Fzfc5PPyNTKpX/qN8DcYBM+MZyWq/pzCV68SqfyNikhvOBIW++CqcKSbX3r2Zl
	 +rtrqQmOyF+mv22odg7P0q8ECnQZXGiO3Z8KylIFowncuqStUTVGV7XeDLF286of5kGFD
	 UlL+AIHFueobSt4Ckk7+ofN49lNTW/yfemTsDkzNUMuTPgrGWfEHL0FMdAQ+8pZndUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQFDr7hP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849D1606A334;
	Wed, 18 Nov 2026 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQFDr7hP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A734C1F000C4;
	Wed, 18 Nov 2026 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015367;
	bh=i3mEjyHl7bWFF8AJkUuI71S9NFj0bkvJUB/3c4h9bE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQFDr7hPgu0uNAywttqKkoZA8WSaQU6cTs8AJOtCceCWkuQfJu5O/WE1JON27I+1k
	 8tI+zlEUE35vB8BeyP8dZV5v8/PWzMCocViKyZcKNalM5VKCbAxItgZA3+RkHgK7r/
	 x+bMsojlEjnmTfVjiFzrfyB5tTn+z0vLspeboINc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0147/2651] PCI: cadence: Fix enum type mismatch warning in LTSSM debugfs
Date: Wed, 18 Nov 2026 15:23:07 +0100
Message-ID: <20261118150253.145987447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit ce8034bb9c5c50f9f5c305856aff5d1c3efe3a30 ]

Fix Clang -Wenum-compare-conditional warning by using a single u32
variable to hold the LTSSM status value, replacing two separate enum
variables of different types.

Fixes: d70e964dc099 ("PCI: cadence: Add LGA IP debugfs for LTSSM status")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608201933.w2579mwx-lkp@intel.com/
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20260820232305.80596-1-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/cadence/pcie-cadence-debugfs.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-debugfs.c b/drivers/pci/controller/cadence/pcie-cadence-debugfs.c
index 0a308f95e9f6c..7b8354052aeab 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-debugfs.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-debugfs.c
@@ -210,24 +210,21 @@ static const char *cdns_pcie_hpa_ltssm_status_string(enum cdns_pcie_hpa_ltssm lt
 static int ltssm_status_show(struct seq_file *s, void *v)
 {
 	struct cdns_pcie *pci = s->private;
-	enum cdns_pcie_lga_ltssm lga_ltssm;
-	enum cdns_pcie_hpa_ltssm hpa_ltssm;
 	const char *str_ltssm;
-	u32 val;
+	u32 val, ltssm_val;
 
 	if (pci->is_hpa) {
 		val = cdns_pcie_hpa_readl(pci, REG_BANK_IP_REG,
 					  CDNS_PCIE_HPA_PHY_DBG_STS_REG0);
-		hpa_ltssm = FIELD_GET(CDNS_PCIE_HPA_LTSSM_STATUS_MASK, val);
-		str_ltssm = cdns_pcie_hpa_ltssm_status_string(hpa_ltssm);
+		ltssm_val = FIELD_GET(CDNS_PCIE_HPA_LTSSM_STATUS_MASK, val);
+		str_ltssm = cdns_pcie_hpa_ltssm_status_string(ltssm_val);
 	} else {
 		val = cdns_pcie_readl(pci, CDNS_PCIE_LM_BASE);
-		lga_ltssm = FIELD_GET(CDNS_PCIE_LGA_LTSSM_STATUS_MASK, val);
-		str_ltssm = cdns_pcie_lga_ltssm_status_string(lga_ltssm);
+		ltssm_val = FIELD_GET(CDNS_PCIE_LGA_LTSSM_STATUS_MASK, val);
+		str_ltssm = cdns_pcie_lga_ltssm_status_string(ltssm_val);
 	}
 
-	seq_printf(s, "%s (0x%02x)\n", str_ltssm,
-		   pci->is_hpa ? hpa_ltssm : lga_ltssm);
+	seq_printf(s, "%s (0x%02x)\n", str_ltssm, ltssm_val);
 
 	return 0;
 }
-- 
2.53.0



