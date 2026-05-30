Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BE939A4A4;
	Sat, 30 May 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164150; cv=none; b=YcbEfhG/n7WaGZ9sbTfIS8xPeyLaSHK21LRh07b2tSjdr1TllfzZ8cKkESW09VjiRwZ3WfV1rLFF0BRaW9wN/ELWucFVxaV8iQo4Iq22lOp9DXym2ZhjcDru9V4yVtVk9YPCvXmG/EDnmW53jWEUcUxMKtrhWBswFRMCTq5vL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164150; c=relaxed/simple;
	bh=L25fUlfuEGdBsB3RSVBj4ZD2kuZklKPBEQa28mYDtEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDWbzPMUqYj8LHmMw7gtoU/rwnK1CgikH2HEOd0E/+/9yVk+0co+acKSI2W1kjfHTnKesoGfcVXURIkMq6WjcKuQu+gVDrN/ENP8cscHDD8/A+hklEtqY+LUQuuFgeFJ7H+d0fJqRlX7rtqZCb8NRleIG5BQxK77CNcHVc6gYyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU/n+Cqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU/n+Cqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067671F00893;
	Sat, 30 May 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164149;
	bh=/VWuw3VsOl9dyIqtEpnbbLtq34hV9TB0od1lxsVNPOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GU/n+CqiGthsAsZgj/vHlXT3wd6qJLLsvHxs2phLV06uGjhqCx6KH9098qU+cBkto
	 4w0MD/lFXIFoX+BZGqurbe2OBFbFOzC++TMUG7PDtA54i1WKEo7q31dQSc68r6C7D0
	 zAWRtwtabkKlJryUAsvrghkKweDS5JzxLsxwDjgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/776] PCI: Add PCIE_PME_TO_L2_TIMEOUT_US L2 ready timeout value
Date: Sat, 30 May 2026 18:03:04 +0200
Message-ID: <20260530160252.494061546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index adae3e04c8c30..eda82a771ab82 100644
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



