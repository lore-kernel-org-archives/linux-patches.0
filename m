Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B605EEA8;
	Sat, 30 May 2026 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161180; cv=none; b=LCyj2xvB4ko5Om0jYRe3Om4pQ21Q1Om8nr663OCV3vCQA7iHJvStFGxP608TuOtctGAClSEI7kfj/YZ6BR6A9MgqdqJiHuVyVvyr+W80COfhaL8uBKoEmTUkXEgjVKm6k2JaEPaGAwDI9weNxbb6NKpiiPl1pHtglSX97wmUmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161180; c=relaxed/simple;
	bh=7ldIHJFTGwo2yql4+ERPcjy3F3JiqrJ13ei81yguroQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dxu+acJcQSXmZCOUM4f6fbaHyRRgPbkIXVTGuhN/sEqCyV4FXlIMBA9gfy6GLxTnN+znS1XND57DCVpxP8/xvwcczaUt1GDXvZn50r+dv64TXlfn96vCA8FFj6JP2Pvg9JWUJ5Y1bu9HYQ1b8+HLxKZuBB4wqA34WPC7itNj3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE8ADxsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE8ADxsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF54F1F00893;
	Sat, 30 May 2026 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161179;
	bh=nOyyYAb/CA50RU/pTXic2nplZw29WjGElnrqqCzVC6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE8ADxsgog3HozB/wJ2U1oaO11EZORb5+wfv1S/afXY3bKj76R6eOc9yxdFPlzXSi
	 t9+yRXzr2o4bqcgRHl09MZzzQibvlz+bSKaIkRbXsJoITIb0WkjqMZ2bhDqqMbFArL
	 QSRLiBxpYSse4e85KVdWm8b7JLizEPrv1L8RRKgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 549/969] PCI: Add PCIE_PME_TO_L2_TIMEOUT_US L2 ready timeout value
Date: Sat, 30 May 2026 18:01:13 +0200
Message-ID: <20260530160315.535628557@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit e78bd50b4078b3b2d9f85d97796b7c271e7860ca ]

Add the PCIE_PME_TO_L2_TIMEOUT_US macro to define the L2 ready timeout
as described in the PCI specifications.

Link: https://lore.kernel.org/r/20230821184815.2167131-2-Frank.Li@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Stable-dep-of: adaffed907f1 ("PCI: tegra194: Fix polling delay for L2 state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 85488bc8e7795..8b177931cf21e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -14,6 +14,12 @@
 #define PCI_EXP_AER_FLAGS	(PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE | \
 				 PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE)
 
+/*
+ * PCIe r6.0, sec 5.3.3.2.1 <PME Synchronization>
+ * Recommends 1ms to 10ms timeout to check L2 ready.
+ */
+#define PCIE_PME_TO_L2_TIMEOUT_US	10000
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
-- 
2.53.0



