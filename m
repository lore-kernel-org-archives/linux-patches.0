Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625313;
	b=q1V1+s/y2dtazbZ4pJsa82r7ZfLe3GACgzUG/lvzCQBFnErAX286bTyVmmUu0CwjM4GZ
	 A+riSf+bGU+fqFleB2yNqQOPcZBHRyzYe/FxAxidFH6qGUUyYyAXS/MIrQhtPhB8h/lgX
	 SVaZ8VTbrMASK78QCsOcXvYYzvr/JnOHdRklSVtlERGJOQ6EuVXnJYC6kVrW6Uz6hlHVN
	 MuDl8Xu8q56qEHGva9GRcytMM15HotqVuYh5KeC8B+0HiFzkhdj7A4RD5DCPULGQo+Mp7
	 o/tEjbA+WqAGAGKlkGv4jRttfmvCItwZA2Bk4+zYLeHrJZJmn498qcv6OHJxCkFT4Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+/iB7I3WZAHAqrI340Q5E7gOepc7+ExmBhNdMW9KOQ=;
	b=DU7IUmJXl5f6/31kgLcV7EPVf4OpaZILWNGHLEWtQWPtYFq0hmK6teSoNsdGJAt7b54Q
	 WlPSR/D11LXQrr1pjkQ5JKAF7tD4BUvM7Aw93jYipjdCCSHnQziVsOPNENl84qwjAYQF0
	 53PNhFx8x8rM3h09yJEI23wl/yyX6w7GdF5Xs9jc/EMovmdRohMu352G4JDC2/ybbX9dM
	 f5K1qLhhkm03IDee2SRo6fm5VbmplkuKlyab7kUrE9WxVSXLJiutj2/hHyfJaj4hJHrGz
	 M7A9/c1SC2ViVY+K0h9B5/W8xv/FckL0Y5ZcLJiyy7jhmxp6beeyCSDLuaLZP0P4udg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/rdiLeq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6D3606A31E;
	Wed, 25 Nov 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/rdiLeq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791871F000C6;
	Wed, 25 Nov 2026 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625313;
	bh=e+/iB7I3WZAHAqrI340Q5E7gOepc7+ExmBhNdMW9KOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/rdiLeqdEI3uDVanQ9xG4w+pqehFcYIvExwsQJ1qTB+XUm7gdAYstmW9RVKb4Ai+
	 vn2XDMukokeC0qHJRwdR8cedAZ49uqjDov+XSwLsKUbBE4VoPN2Dd6FV4IoaUOh1nF
	 SxkFKhIvQQu0LWDgTLzDvnM5Na8rfzDYWH+43Yhs=
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
Subject: [PATCH 6.12 476/816] PCI/P2PDMA: Do not tear down the allocate attribute on registration failure
Date: Wed, 25 Nov 2026 15:33:44 +0100
Message-ID: <20261125143900.218141647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Passes pdev instead of p2p_pgmap as the devres action data in both devm_add_action() and devm_remove_action(), since the older unmap callback takes a struct pci_dev *. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 01c8b79a9e0d7..d438ff25d2de1 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -331,8 +331,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		goto pgmap_free;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
-					 pdev);
+	error = devm_add_action(&pdev->dev, pci_p2pdma_unmap_mappings,
+				pdev);
 	if (error)
 		goto pages_free;
 
@@ -342,13 +342,15 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
 			&pgmap->ref);
 	if (error)
-		goto pages_free;
+		goto mappings_remove;
 
 	pci_info(pdev, "added peer-to-peer DMA memory %#llx-%#llx\n",
 		 pgmap->range.start, pgmap->range.end);
 
 	return 0;
 
+mappings_remove:
+	devm_remove_action(&pdev->dev, pci_p2pdma_unmap_mappings, pdev);
 pages_free:
 	devm_memunmap_pages(&pdev->dev, pgmap);
 pgmap_free:
-- 
2.53.0



