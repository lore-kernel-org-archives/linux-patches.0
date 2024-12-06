Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A961537D4;
	Fri,  6 Dec 2024 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496316; cv=none; b=ravR69/RuVHo1HGluVQVvWGVKUeHlBS79fh5TXl3q4zbcvFU+yqgf3Cc9Dxiq1tCBLQX5jCGNhPbugfp9B7wGEy86oxt0DcnZuwYTOue9rBIEaVe6oHMDK9GPY15trbGGKFxMh03i1aTJcMLjBnasd3LAnhYmK/6Zr5cHBT5w3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496316; c=relaxed/simple;
	bh=WpK0wWJxzEtQapwcTBAGyib4oPGOto0QlC4Szt3jJn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVM1/bd0cxZkTsLapfjIM6wfgfofmAfuajI5vcqNgK6Iw8vL/Kjm6gNhV2XTL5E1OPYcB1vbCcUjDUamPPjZZnzLp+se9KP6oXNY4aPqSl8O1yHsXL/cl1714QS/8NGMveGZE0mdHni1P1IySpuqHGXE58YiIx1GJo1UOuASDFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlvUh9+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlvUh9+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1057C4CED1;
	Fri,  6 Dec 2024 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496316;
	bh=WpK0wWJxzEtQapwcTBAGyib4oPGOto0QlC4Szt3jJn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlvUh9+TrBThVz009Yc8EaT5Dtx3XbpDEuFO8D0fpoRjXhwk4bBS7K/6ptxmJ5xA8
	 hPC40SBIQemtnZ95FFt6CR8bggrbbX95Umq6+Hht6hAwiBVUpI4vF/8zvRaJm3qTse
	 imkpLgs8aCR1xu6wW7kn3u0in15Bgu/j1JGIrgBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 085/146] PCI: keystone: Add link up check to ks_pcie_other_map_bus()
Date: Fri,  6 Dec 2024 15:36:56 +0100
Message-ID: <20241206143530.931274134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 9e9ec8d8692a6f64d81ef67d4fb6255af6be684b upstream.

K2G forwards the error triggered by a link-down state (e.g., no connected
endpoint device) on the system bus for PCI configuration transactions;
these errors are reported as an SError at system level, which is fatal and
hangs the system.

So, apply fix similar to how it was done in the DesignWare Core driver
commit 15b23906347c ("PCI: dwc: Add link up check in dw_child_pcie_ops.map_bus()").

Fixes: 10a797c6e54a ("PCI: dwc: keystone: Use pci_ops for config space accessors")
Link: https://lore.kernel.org/r/20240524105714.191642-3-s-vadapalli@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
[kwilczynski: commit log, added tag for stable releases]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -455,6 +455,17 @@ static void __iomem *ks_pcie_other_map_b
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pci);
 	u32 reg;
 
+	/*
+	 * Checking whether the link is up here is a last line of defense
+	 * against platforms that forward errors on the system bus as
+	 * SError upon PCI configuration transactions issued when the link
+	 * is down. This check is racy by definition and does not stop
+	 * the system from triggering an SError if the link goes down
+	 * after this check is performed.
+	 */
+	if (!dw_pcie_link_up(pci))
+		return NULL;
+
 	reg = CFG_BUS(bus->number) | CFG_DEVICE(PCI_SLOT(devfn)) |
 		CFG_FUNC(PCI_FUNC(devfn));
 	if (!pci_is_root_bus(bus->parent))


