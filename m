Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212592;
	b=LaAbE93ydfJFbLNALemGEXQibhIuxNJg0h0eLvqAmYc7z/Kwwn0vzeGMhKTKF3aGy9In
	 SZmaJ4i5gOyoCmeTslc6l4L3SSVqcTV/OXA833tdEuxIKPfDdSKB1CJBwyASp5JPQ6dXJ
	 8V2Wp80XvgLbFvA/XOJMrSCsuuqzcLkOy7UiiwkQrmXSTEdx03w2Qn3Hrxfneyiahxcnb
	 /LsjJV+m/UdiktweD+/1Zdw+xx3KHntk+U9H+e9BuX/38eI29LAqh+hTqsBDSuaFaGtbN
	 U0eoP9Bw6Ka7kyi4mRwhhKCzr8XgrTqF71yxd0yCVHmoR8EzLQRy8SQuyPZRug2446w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yOlK4GKv4JQ6oRXwAeA0nKZFFMxgkvfESovp2+Uql8=;
	b=H/qWpDNPqrBZrXkJNraff3fLyQ3XGbnNimwpx/wASTlqGfRNVtiwdkZ7xnoFSJhZITHH
	 yhB4CdY5Ze3w4IN7vytUrnqnQKtlFgteRmNentHnzXZcODwG91N3Xw6QpYc/jkOvWr3rt
	 qg+tGaFW1hRZ7Vw2iWpvC8P7k9ptNVhfnFsfXZ7A9z4qPYh2u5HY1/enVQFzYotWCcP1D
	 jXyxBlnJdgdhi9F1xDmo6m5PnpKJkxfNr0gKqZmydJK1lP7p4o1RQl4i7j1TDT9eCxelv
	 oKgWIj1Vpq3CCmspR9ovuQpQXpYiPRSjC0SHHdI8Nh0pFzj2fj+taa/7Itp4ZL79z8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QUumepg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DB4606A31A;
	Wed, 28 Oct 2026 18:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QUumepg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94911F01825;
	Wed, 28 Oct 2026 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212592;
	bh=2yOlK4GKv4JQ6oRXwAeA0nKZFFMxgkvfESovp2+Uql8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QUumepgHvARDI0+6IXLe+Fdw7H+/RBu0TE+EI94McSGlC1ICFZHJXSCIGoBv/3c5
	 eRb/LYNBCdz8CJBrsMPtzI2j8QSsYlM/zUTydDZNWtL9L/ZXjp8jxKdvr1xcVVTSPN
	 iJVtg6onCnYjUl39iNs34n+HYEhux8Acs8wkFsUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0154/1887] net: ena: fix MMIO read buffer leak on probe failure
Date: Wed, 28 Oct 2026 17:37:30 +0100
Message-ID: <20261028170502.737855566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9476b4468862927297c94c440863cd8ed1e7cc83 ]

ena_device_init() initializes the MMIO read mechanism with
ena_com_mmio_reg_read_request_init(), which allocates a coherent DMA
buffer for MMIO read responses.

The normal removal path releases this buffer through
ena_com_mmio_reg_read_request_destroy(). However, if ena_probe() fails
after ena_device_init() succeeds, the error path destroys the admin
resources and eventually frees ena_dev without destroying the MMIO read
request, leaving the coherent DMA buffer allocated.

Call ena_com_mmio_reg_read_request_destroy() in the probe error path
before releasing the remaining device resources.

This issue was found by manual code inspection.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260921154202.471662-3-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjusted cleanup context due to missing PHC, devlink, and customer-metrics code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5159fb9fbe66f..9e92ccf13419f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4497,6 +4497,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_com_mmio_reg_read_request_destroy(ena_dev);
 err_netdev_destroy:
 	free_netdev(netdev);
 err_free_region:
-- 
2.53.0



