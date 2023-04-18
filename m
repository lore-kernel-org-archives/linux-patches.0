Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDB82572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3CC433EF;
	Tue, 18 Apr 2023 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822344;
	bh=UeapDqoFCU/e0mlgZE+qav74B4r1hZnvn4+6MryPqbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/0kwxQIhb1FW4cJbtfaOMak0SZjv+nYDJSMUFrgPNJ/4jJXdSC//lBXQP1S1m2LB
	 Xp1pP/lgzh2yDxkB0YVdW5TSsuzWwKQGFjhpi/HrSe2z491DQ9C1sfeKtmNs4BxeHg
	 JHBliVkwM6SZWwL6V4U6tYgR0R6sa5qBRlcoV6Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.2 115/139] PCI/MSI: Provide missing stub for pci_msix_can_alloc_dyn()
Date: Tue, 18 Apr 2023 14:23:00 +0200
Message-Id: <20230418120318.093188643@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

commit 195d8e5da3acb17c5357526494f818a21e97cd10 upstream.

pci_msix_can_alloc_dyn() is not declared when CONFIG_PCI_MSI is disabled.

There is no existing user of pci_msix_can_alloc_dyn() but work is in
progress to change this. This work encounters the following error when
CONFIG_PCI_MSI is disabled:

  drivers/vfio/pci/vfio_pci_intrs.c:427:21: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]

Provide definition for pci_msix_can_alloc_dyn() in preparation for users
that need to compile when CONFIG_PCI_MSI is disabled.

[bhelgaas: Also reported by Arnd Bergmann <arnd@kernel.org> in
drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c; added his Fixes: line]

Fixes: fb0a6a268dcd ("net/mlx5: Provide external API for allocating vectors")
Fixes: 34026364df8e ("PCI/MSI: Provide post-enable dynamic allocation interfaces for MSI-X")
Link: https://lore.kernel.org/oe-kbuild-all/202303291000.PWFqGCxH-lkp@intel.com/
Link: https://lore.kernel.org/r/310ecc4815dae4174031062f525245f0755c70e2.1680119924.git.reinette.chatre@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org	# v6.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1623,6 +1623,8 @@ pci_alloc_irq_vectors(struct pci_dev *de
 					      flags, NULL);
 }
 
+static inline bool pci_msix_can_alloc_dyn(struct pci_dev *dev)
+{ return false; }
 static inline struct msi_map pci_msix_alloc_irq_at(struct pci_dev *dev, unsigned int index,
 						   const struct irq_affinity_desc *affdesc)
 {


