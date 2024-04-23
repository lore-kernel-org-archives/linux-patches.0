Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F347143C57;
	Tue, 23 Apr 2024 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908613; cv=none; b=sMrnluJnJOC8yeCGnYilPhnFAMpaY4JAiaLH8SjSKOE06Wrklk/DuGTWniop2Xi6vQoCiEBwT4IhYsmeG9Cn8PyNct/mPVQ9w2XZoHm/cFdEKFQXbMX+IlZPk1MTSTGHjLnhQzA3w0LeAMhjlvO0XlyhzPFiQjtrhPNDc/65luw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908613; c=relaxed/simple;
	bh=Fk7pFPpydlAq1HgAsqycgYhas8zQG7vSYZqN+5A0qyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVoNoYjPrEvC2WoMwn+XzEYINvi1i+cZntOtV0V2zTlrxPhJEJ4Ds7/xzGpwDEyPc5YVImFSj9z3xBvyGLtHTQ2kqxTbpnycRPzT+bQzu78s78yIWZAMPV4m4f6kT8ugW8q7up6xpuO4tMNng+JxdKgUUA1U3b62uDsukSkMH08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=papzVyeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="papzVyeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AF2C3277B;
	Tue, 23 Apr 2024 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908613;
	bh=Fk7pFPpydlAq1HgAsqycgYhas8zQG7vSYZqN+5A0qyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=papzVyeEdOy5kQCE5BUiut8jkgOIqwbUdAKRdmuuyx3X1LdFi/Xi1AncMGW7ryxm4
	 EUsQcr/XxdwNd/CBLVvCr0en7+T+mIYo5GrxZ0VibllEHZr28YGwPDrxJZYJvF1WLi
	 9M/UnCY33Tc55ukEpjtYWpejR3KFMkVORONR7S3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/158] PCI: Simplify pcie_capability_clear_and_set_word() to ..._clear_word()
Date: Tue, 23 Apr 2024 14:38:41 -0700
Message-ID: <20240423213858.489629522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 0fce6e5c87faec2c8bf28d2abc8cb595f4e244b6 ]

When using pcie_capability_clear_and_set_word() but not actually *setting*
anything, use pcie_capability_clear_word() instead.

Link: https://lore.kernel.org/r/20231026121924.2164-1-ilpo.jarvinen@linux.intel.com
Link: https://lore.kernel.org/r/20231026121924.2164-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[bhelgaas: squash]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 8 ++++----
 drivers/pci/quirks.c    | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 7e3b342215e5b..19a673aa08eb2 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -689,10 +689,10 @@ static void pcie_config_aspm_l1ss(struct pcie_link_state *link, u32 state)
 	 * in pcie_config_aspm_link().
 	 */
 	if (enable_req & (ASPM_STATE_L1_1 | ASPM_STATE_L1_2)) {
-		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
-						   PCI_EXP_LNKCTL_ASPM_L1, 0);
-		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
-						   PCI_EXP_LNKCTL_ASPM_L1, 0);
+		pcie_capability_clear_word(child, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPM_L1);
+		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPM_L1);
 	}
 
 	val = 0;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e1c652b1c53a4..fa770601c655a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4571,9 +4571,9 @@ static void quirk_disable_root_port_attributes(struct pci_dev *pdev)
 
 	pci_info(root_port, "Disabling No Snoop/Relaxed Ordering Attributes to avoid PCIe Completion erratum in %s\n",
 		 dev_name(&pdev->dev));
-	pcie_capability_clear_and_set_word(root_port, PCI_EXP_DEVCTL,
-					   PCI_EXP_DEVCTL_RELAX_EN |
-					   PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
+	pcie_capability_clear_word(root_port, PCI_EXP_DEVCTL,
+				   PCI_EXP_DEVCTL_RELAX_EN |
+				   PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 /*
-- 
2.43.0



