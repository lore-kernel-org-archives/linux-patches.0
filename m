Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019416;
	b=0hII5nKQeHAaVZdKWm1ce5ezsBs6MJ463shZoOinNf6j9IQEyqXMmEXbhs45QARaosMe
	 dZIaIs4nsHaOP5GpjOXpPWrupOr3F/nw0vvLXa8t7+UFuLKTc5lBs6thlLfq/Y9D6N7uH
	 aQBiu2kyu+7eRbcnXEjIbr9PnbXkN+yFxBW5TF2YhWbO1z/x3ZLPxDtL/d6I3sgCOnS8J
	 /UKe8DIeEch9S5z8ONJrhPgWZSs6RJp7oULALrK+1ISDB6iQDolvhOE2MVqLXx3sH4Rvk
	 SEfnjsktE1gWbfVs1aiBbtKPJVvpKYfRehr7iszz5yh3CoGSITCycTrqsxkSUusXIfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfCVxutLra1vesC/sHFrRkpxjnwSencFAX/as/6JlHo=;
	b=MaomcfkBF7HcXa+T6r86SEku8NPwMrvFjg+pgz4awl/R2cQmj3K3d3fZLVVZPfsACMAC
	 C0L3xgh8OrWM+7eNehdXfuFJCu+ttOUndRWoJ4VYZiw3yzE+Sww8G3Q0+i1d+6chtS/sB
	 OtglAPcamGVzVYHxxFuUft92aJJkiTDuhzMYnMTT+K7Txcj+mu6dVUcDkCfDs8O2GJY4b
	 DISH5K2hZv826VBszHhxAJ4AZ4w/aZzyYVUEZxMYYqIoEfuPFMS+C5Awf6ONhc74oVbnS
	 UnUGp3V3IrRSXIS05uwkqRCkr0+JH5VtfOsngX5Lls3tyYn3ZNAWKGjqedx+InWowZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxTws+6a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC57060A3801;
	Wed, 18 Nov 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxTws+6a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1A21F0182A;
	Wed, 18 Nov 2026 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019416;
	bh=yfCVxutLra1vesC/sHFrRkpxjnwSencFAX/as/6JlHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxTws+6a+652B+TfR4NZDPEhDg93TdQxeP33HtzEENh1izkQnrrYCHYctTZFyB0Br
	 aM6wfPDueH3PjhtO6z3LdePpDJ+84MNml6ADD7wM8dlQ19pGajDl0zvDntToaEWOu3
	 5GKNdOmfdGjqs58CUPk56V0McgGr2YW6mekHihgE=
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
Subject: [PATCH 7.3 1571/2651] PCI/P2PDMA: Do not tear down the allocate attribute on registration failure
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150344.495990142@linuxfoundation.org>
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
index 9334eb314663e..8124bcebfa2d3 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -440,8 +440,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		goto pgmap_free;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
-					 p2p_pgmap);
+	error = devm_add_action(&pdev->dev, pci_p2pdma_unmap_mappings,
+				p2p_pgmap);
 	if (error)
 		goto pages_free;
 
@@ -451,13 +451,15 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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



