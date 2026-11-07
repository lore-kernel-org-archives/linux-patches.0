Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062154;
	b=mrLb5JPTbsBZDSed9KrUCg6/CgazExAmXilX8Koij0eyS+MgdY/Q3uFDTLT0a6DCuLBq
	 bxJSWPvW7y55hm3Vwwww6e6BEXX+Ls92pQgAMNg4drCz+OgzmSpkChrQ6yavYDBDI+X8L
	 OpSu0KSA8njiTs4UHbBu/TLSnU0RXT2BnDgIWAd1p9+oI9okvZW2sqV4818npW9jO9umA
	 9hnFzdRF8cB7q+ws2taSagL483D1FNn0dPzn7aQMuvCRSeXu3XRsxyMf2LYtUgizPTcX6
	 rq9ZN0Q614Ie3ul97G5vd/+rvhaW1pD1pbhlHbZKep3VgeGv3C5XmcUNfpebIx5X+8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2tGPRhrmk/pA3aRHRVwuCRwxIenBi8x+o8LTBPEfZ0c=;
	b=CCcr2LY7a2KsWF4slqdjLEtRLYWEEfBF+D51cDQVHBJBQrBNWoHlI+//gUIaik3f+n3e
	 yrQVl3QIpIkCD+yMILpzmZSsowNUbo96NMQdOAFxJBw0Zzzcq3+LArzRsesn/rV2Eic0J
	 Jf6FCOvriqZroqHlP5LsTp9HN6Ki22ymsOMLE6qPwJ9T3rodLfLwwAQ0WPtPCEUkt/+Jm
	 O6Um7M7IBebbif9b5Qzg6Szs0kxhj5I0WUP23Y3QL/AKvFKrdR/FXT46ZWcOJAoxo3zlC
	 TGzmlEmK1ArBeGubPqgLDPP0gSh9GjkvurnF6ocwIoptyxIm8vzyyNlVJQgVDyo3nRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjeEbzNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A41606A66A;
	Sat,  7 Nov 2026 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjeEbzNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1917A1F008A4;
	Sat,  7 Nov 2026 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062154;
	bh=2tGPRhrmk/pA3aRHRVwuCRwxIenBi8x+o8LTBPEfZ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjeEbzNPukDnVt5d9G0xadMw7Y/6mRS2AqUDcbTy6XST0+gDuyxDNoczijyKb++Iy
	 aXTjTuRDrfxHxoNRNbs39PQEB88mzpruxRgA3wsLA+JBkAcrJlY/qEkmc6eQpK7xJ9
	 slwNRIhc1kn+X+bAaGD//9mxHWN45jjwguUbKNuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1070/1536] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Sat,  7 Nov 2026 08:51:26 -0500
Message-ID: <20261107135027.745158194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 521ad948e04934b2d70ae899bc016bbb38802e90 ]

init_l440gx() takes a single reference on the PIIX4 ISA bridge with
pci_get_device() and drops it again right after the lookups, before
the flash window is set up.  The pci_assign_resource() failure path
then calls pci_dev_put() on the same device a second time, releasing a
reference that is no longer owned and underflowing the reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 832b880d1aaf8..85cd273ce0654 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(dev);
 			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
-- 
2.53.0



