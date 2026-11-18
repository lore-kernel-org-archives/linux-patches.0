Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026066;
	b=OwBKSlG+x8K4PO01+V4abw5ZDU9QAHJgttE1QBhnblJgFKtNfI/zltYJ4Ih04/iAVLIz
	 fzlLRiv+KZkqAamLO4INa53sgfTHk8cxz3B2zZeJkw0aECs1niXmd/6qK0kHQ1hf98cny
	 CujficVH60tb5Nkkq/Zpr/7q0obD1INed5AqjMSlkilDb+vwDi/qTmc04Bj5Ebf/WWA+7
	 Yl8VaERvTFLAd1G4cP5EAHSIO5Y4MTDQE2tPSXEAVjIy839SD7MLbrKItcsnflNJMu6dc
	 BHbZmbJMOUQ+DlQmGPyBRMkVQ5mzFbY52hy+EPikZdt/Rel9Jzw7FTnJcYxCqwiDw4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpgYfwLPhp8COPTBp8sLvrq7di6Ku9VUUdGm9LRSXkM=;
	b=4tNVR0JHQY29Kq4D1cMgVi4Pa0WxFuU6TpFVd47madlM9DY3tQxNKpL/L4yEinKRdI7V
	 rtJb8FcQTVtulG9JopYsCgcC7CvhaHHLvrypKjWnniqwiodYC8ecZp1hWr53XoNnabV5a
	 qL74yllJOoyb5tI8prVPvFa6d3n1iWv8zD1VYB/aHpj8o5xa8fJIDoInUT8rdwsnSnOP4
	 V7s5yqnPJWABrHmFnSoqnA0lh0BIsM297b4M0TuELzUf1aJsILS3JL+gjtMAUDG4i5bob
	 CcuSvBzz7aEhLpaO+kZr7ecAeo8FubNPhyILgrBR0sURKCNWan0nSCqtOfg7KEonLGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mw1CjCoh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E48606A331;
	Wed, 18 Nov 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mw1CjCoh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717701F000C5;
	Wed, 18 Nov 2026 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026066;
	bh=dpgYfwLPhp8COPTBp8sLvrq7di6Ku9VUUdGm9LRSXkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mw1CjCohhMMZNmL6AEStC/lYUKlPANY1QPEnimcD79BN9Nn0hpd1W2mxGHdAt77LP
	 pm4IU6JT2FNLwv17MdQunNSFkBwibhVi3aVp4/Tmf17z6h/94kV93s2MCmIjEOKIOE
	 Dinf/bBtISOJ4GCcnGw7wL2SjlPERZchubj+nlrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1303/2151] PCI/P2PDMA: Do not tear down the allocate attribute on registration failure
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118150209.568289635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7c4d6505a1f8a1ebe8019b7f988ed494b696653b ]

pci_p2pdma_add_resource() installs pci_p2pdma_unmap_mappings() as a devres
action with the devres allocated p2p_pgmap as its data, and only then adds
the range to the pool:

  error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
                                   p2p_pgmap);
  if (error)
          goto pages_free;

  p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
  error = gen_pool_add_owner(p2pdma->pool, ...);
  if (error)
          goto pages_free;

The action removes the allocate attribute for the whole device, which tears
down existing userspace mappings of every BAR already registered on it.
Both failures here get that wrong, in opposite ways.

devm_add_action_or_reset() runs the action when it cannot allocate its
devres node, so an -ENOMEM while registering a second BAR unmaps the first
one. Use devm_add_action() and let the error path unwind only what this
call created.

gen_pool_add_owner() allocates a chunk and can also fail with -ENOMEM.
There the action is registered, and the error path frees p2p_pgmap with
devm_kfree() while leaving the action pointing at it. On unbind devres
runs the action and pci_p2pdma_unmap_mappings() dereferences
p2p_pgmap->mem->owner->kobj, which is freed memory. Give that failure its
own label and drop the action with devm_remove_action(), which removes it
without running it.

Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
Fixes: f58ef9d1d135 ("PCI/P2PDMA: Separate the mmap() support from the core logic")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-1-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 1004a4f055dfe..751b3897ea18f 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -346,8 +346,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		goto pgmap_free;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
-					 p2p_pgmap);
+	error = devm_add_action(&pdev->dev, pci_p2pdma_unmap_mappings,
+				p2p_pgmap);
 	if (error)
 		goto pages_free;
 
@@ -357,13 +357,15 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
 			&pgmap->ref);
 	if (error)
-		goto pages_free;
+		goto mappings_remove;
 
 	pci_info(pdev, "added peer-to-peer DMA memory %#llx-%#llx\n",
 		 pgmap->range.start, pgmap->range.end);
 
 	return 0;
 
+mappings_remove:
+	devm_remove_action(&pdev->dev, pci_p2pdma_unmap_mappings, p2p_pgmap);
 pages_free:
 	devm_memunmap_pages(&pdev->dev, pgmap);
 pgmap_free:
-- 
2.53.0



