Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE738F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302141; cv=none; b=NThOzUvNXaAOFlhKlISHnQCji1Hv4xU8N+D8MIcZzypgGcwzvzf4otuVXmImDXwAqVjQz1kuKrjmtBcyvksmLPxTpVBzrTmmDgocct1X9v8ca3I7835O8tmd3DeiYrOfuuHEm+Lnx3rJq2qZLqXLbGXpfTnGCUh7X843Jy/QDIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302141; c=relaxed/simple;
	bh=kIZlFKHLR5rre/4VaGUIQR9v7cAmO+AiNlOlqoOTMpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+CmVJbk+pAxsXIt3MVylDToLJlJ+PDI2qzXTdXgXJcFdohiovZ8f00A6rkcTNWF5Ru0+Eikjr7LkkVeSoSBZgwKXDgkQSNcxDsXVVt1e0aGJsSP+MuXG0B4EoqGXgzHbtqiSboUf31v68PbKrNecrbUbCG2c9e7Ou9pZEYB/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C69dOnpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C69dOnpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3EBC19424;
	Sat, 28 Feb 2026 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302141;
	bh=kIZlFKHLR5rre/4VaGUIQR9v7cAmO+AiNlOlqoOTMpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C69dOnpnxK25Hst15xuBZvYu2QS/P8NS0JgLaJZ2kFPyTFzKST8Gj9J1BK85bvsd2
	 E1cluD6k7taN0SxxVHrmEx3VHFcGgWIkta8tnZKeyXF0w5qAfnUQFJOBDw9eNxIX2M
	 mtumW8BUN5rYm/J0eQf8A9LeQam++WAp8+6H+Mm7RAUwAlHRSrISjnO5YQTO38Mic7
	 D6LB2HzK/bXnmIB3aqdYOayN4K9ljHefAwBOTwM8+mckL4eUb3lBBE3Zq/4cVVTLDE
	 1xkp8G/9K7HPqCMCsG3/2/IoZptkbBRaqxRWn9ivHfn8nC0CZNVccYfoYCG9wyXUEX
	 OTcGF+YeTR/XQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/283] PCI: Add PCIE_MSG_CODE_ASSERT_INTx message macros
Date: Sat, 28 Feb 2026 13:04:36 -0500
Message-ID: <20260228180709.1583486-134-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 95cb8ff68851ed0d249fb8a1d9657987cd844e08 ]

Add "Message Routing" and "INTx Mechanism Messages" macros to enable
a PCIe driver to send messages for INTx Interrupt Signaling.

Values from PCIe r6.1, sec 2.2.8 and 2.2.8.1.

Link: https://lore.kernel.org/linux-pci/20240418-pme_msg-v8-1-a54265c39742@nxp.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d69a17947ffce..95603147e73c8 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -22,6 +22,24 @@
  */
 #define PCIE_PME_TO_L2_TIMEOUT_US	10000
 
+/* Message Routing (r[2:0]); PCIe r6.0, sec 2.2.8 */
+#define PCIE_MSG_TYPE_R_RC	0
+#define PCIE_MSG_TYPE_R_ADDR	1
+#define PCIE_MSG_TYPE_R_ID	2
+#define PCIE_MSG_TYPE_R_BC	3
+#define PCIE_MSG_TYPE_R_LOCAL	4
+#define PCIE_MSG_TYPE_R_GATHER	5
+
+/* INTx Mechanism Messages; PCIe r6.0, sec 2.2.8.1 */
+#define PCIE_MSG_CODE_ASSERT_INTA	0x20
+#define PCIE_MSG_CODE_ASSERT_INTB	0x21
+#define PCIE_MSG_CODE_ASSERT_INTC	0x22
+#define PCIE_MSG_CODE_ASSERT_INTD	0x23
+#define PCIE_MSG_CODE_DEASSERT_INTA	0x24
+#define PCIE_MSG_CODE_DEASSERT_INTB	0x25
+#define PCIE_MSG_CODE_DEASSERT_INTC	0x26
+#define PCIE_MSG_CODE_DEASSERT_INTD	0x27
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
-- 
2.51.0

