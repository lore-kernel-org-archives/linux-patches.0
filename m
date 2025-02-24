Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D49192D9D;
	Mon, 24 Feb 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408443; cv=none; b=mFT9dLF4bylro4N1RAE2D4QpiodCjLIH6rdblKfehHv0Kb3+8WbLLXB1jc3ycw+p+hb6nsE0iBRzAAhjYp3HVCayCH50lYfETLKm0fslYJLsgco7irn+bbMEQVkkxR3CsFDfppUafcL4csTMBsNijaoYaPyP0voJIIezz5WLQlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408443; c=relaxed/simple;
	bh=yiQidxdVlLXjSXSMz3zOKVCadgtufD8Bf7e5ygkMLdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjtCzuABaUXpd87fqOy14TCLRvMdM94e13oFijcgECeIkEYeDRo5d+H9LT/x8hOt2/qrZCI/A5Xt35EeqRJhRVMH/enM6N4mNtUQpZG1bhf+tNjTTwGcBE5nste/1SeHMKg7iIU7eOHT0UTQ13zwaaDFPYQv/8HsHwJzUFqbBPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mc8zfVkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mc8zfVkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73317C4CED6;
	Mon, 24 Feb 2025 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408442;
	bh=yiQidxdVlLXjSXSMz3zOKVCadgtufD8Bf7e5ygkMLdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mc8zfVkkZoWvXu7BUb0bKIASgKhr2IZzjfwrgrFjARhVx53WsTRuTtBZwEu93Zoxx
	 G0SNIcuITZZQJLtlEXii5sdVFe1hJB8VDcEzeOHW7s0fvj4n3uMY9KJ4r0OCFk/Uxf
	 GINqJQHaTI7xtNbAVrZZYfOdQliM5U2QYWYdAbhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <pstanner@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/154] PCI: Make pcim_request_all_regions() a public function
Date: Mon, 24 Feb 2025 15:33:46 +0100
Message-ID: <20250224142608.149696252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit d9d959c36bec59f11c0eb6b5308729e3c4901b5e ]

In order to remove the deprecated function
pcim_iomap_regions_request_all(), a few drivers need an interface to
request all BARs a PCI device offers.

Make pcim_request_all_regions() a public interface.

Link: https://lore.kernel.org/r/20241030112743.104395-2-pstanner@redhat.com
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: d555ed45a5a1 ("PCI: Restore original INTX_DISABLE bit by pcim_intx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/devres.c | 3 ++-
 include/linux/pci.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index b133967faef84..2a64da5c91fb9 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -939,7 +939,7 @@ static void pcim_release_all_regions(struct pci_dev *pdev)
  * desired, release individual regions with pcim_release_region() or all of
  * them at once with pcim_release_all_regions().
  */
-static int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
+int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
 {
 	int ret;
 	int bar;
@@ -957,6 +957,7 @@ static int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
 
 	return ret;
 }
+EXPORT_SYMBOL(pcim_request_all_regions);
 
 /**
  * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4e77c4230c0a1..000965a713edf 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2293,6 +2293,7 @@ static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) { }
 #endif
 
+int pcim_request_all_regions(struct pci_dev *pdev, const char *name);
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void __iomem *pcim_iomap_region(struct pci_dev *pdev, int bar,
 				const char *name);
-- 
2.39.5



