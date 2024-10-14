Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840A1AAE08;
	Mon, 14 Oct 2024 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916590; cv=none; b=dRJCK9rWxC8oeXkKuk/ThhT6IpCcfFU+5dSnE9K9Y/VkJMaZdnv8YuIkh0dFNI+ifu/cBO8wI8JRy8CSKlMcW/MwRFmFXTauWtKeBfsZWvMol/j8javSne7HoNANI9OBiorw/VfLKogW0Nr1DAF2DBS6Zok7ZL3Zwuugh7qXJ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916590; c=relaxed/simple;
	bh=QdVhbrFS3irK+nZhOjSzkjsVLXF3jlQX2GxPOaeGGGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc70L1AFSCOJ8OJrycveHpuakiHIM62YYUajV3ytsaXzPmgLnFrs6nCd+wm5AARudS8Wf1SewWAwlFR5wo2wwYqH62L50ERYGHOhCDL/tJtKOcvBSg5zkM1VkUYVG24O9A3Z9ZuYHJ9wyldV/43aQdKyXIeiJToC01b5WOeVi0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHsKX1Rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHsKX1Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D398AC4CEC7;
	Mon, 14 Oct 2024 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916590;
	bh=QdVhbrFS3irK+nZhOjSzkjsVLXF3jlQX2GxPOaeGGGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHsKX1RdhfIW9aQKqHhW2NBdYcl3cX/i0YJmwPQ2B6MXNd8odVuyn+MUPqT+h+tHY
	 A//dwwi6EcKAZLfisO+UY4QQ6EmWHDviOygwE52cHjEPqUXUQvOkUyg+pRuBvRZpRo
	 XYJYOdXxeEUrr+t8GORy9UZNvjZTONtiJHT12Uyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/213] Revert "PCI/MSI: Provide stubs for IMS functions"
Date: Mon, 14 Oct 2024 16:18:29 +0200
Message-ID: <20241014141043.107386014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 372c669271bff736c5bc275c982d8d1b4f1f147c ]

This reverts commit 41efa431244f6498833ff8ee8dde28c4924c5479.

IMS (Interrupt Message Store) support appeared in v6.2, but there are no
users yet.

Remove it for now.  We can add it back when a user comes along.  If this is
re-added later, this could be squashed with these commits:

  0194425af0c8 ("PCI/MSI: Provide IMS (Interrupt Message Store) support")
  c9e5bea27383 ("PCI/MSI: Provide pci_ims_alloc/free_irq()")

which added the non-stub implementations.

Link: https://lore.kernel.org/r/20240410221307.2162676-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7b18a4b3efb0e..2b7e45bae9408 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1630,8 +1630,6 @@ struct msix_entry {
 	u16	entry;	/* Driver uses to specify entry, OS writes */
 };
 
-struct msi_domain_template;
-
 #ifdef CONFIG_PCI_MSI
 int pci_msi_vec_count(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
@@ -1664,11 +1662,6 @@ void pci_msix_free_irq(struct pci_dev *pdev, struct msi_map map);
 void pci_free_irq_vectors(struct pci_dev *dev);
 int pci_irq_vector(struct pci_dev *dev, unsigned int nr);
 const struct cpumask *pci_irq_get_affinity(struct pci_dev *pdev, int vec);
-bool pci_create_ims_domain(struct pci_dev *pdev, const struct msi_domain_template *template,
-			   unsigned int hwsize, void *data);
-struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev, union msi_instance_cookie *icookie,
-				 const struct irq_affinity_desc *affdesc);
-void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map);
 
 #else
 static inline int pci_msi_vec_count(struct pci_dev *dev) { return -ENOSYS; }
@@ -1732,25 +1725,6 @@ static inline const struct cpumask *pci_irq_get_affinity(struct pci_dev *pdev,
 {
 	return cpu_possible_mask;
 }
-
-static inline bool pci_create_ims_domain(struct pci_dev *pdev,
-					 const struct msi_domain_template *template,
-					 unsigned int hwsize, void *data)
-{ return false; }
-
-static inline struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev,
-					       union msi_instance_cookie *icookie,
-					       const struct irq_affinity_desc *affdesc)
-{
-	struct msi_map map = { .index = -ENOSYS, };
-
-	return map;
-}
-
-static inline void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map)
-{
-}
-
 #endif
 
 /**
@@ -2667,6 +2641,14 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 
+struct msi_domain_template;
+
+bool pci_create_ims_domain(struct pci_dev *pdev, const struct msi_domain_template *template,
+			   unsigned int hwsize, void *data);
+struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev, union msi_instance_cookie *icookie,
+				 const struct irq_affinity_desc *affdesc);
+void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map);
+
 #include <linux/dma-mapping.h>
 
 #define pci_printk(level, pdev, fmt, arg...) \
-- 
2.43.0



