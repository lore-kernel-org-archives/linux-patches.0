Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062263;
	b=16VVURPrMjZG036Li9A02Ir5MhJ8BUIg9GxE3IvMHtksIJTbUpW/PaElM2e0tT/1oqja
	 AjbSemP0kzhx93ks4j38bQkrozQYvdY51a8LEGCRAPmCtW/LwRnXFTwMuP5kha1z2hzE8
	 GyRnXIaPaPTUmmNBh6Ba7irW3fSST0PxBa8lFHmJnIVfFC8trXuEWhYnh6KZH6rN5nTB1
	 ECjC/dWVHhVznlierXslw0svwdpSCKaMTZ1K13DOK6nEsUsjF8TylNaRGa4JYcdI/j7/m
	 GGtrSRRPzjYUoX2O1wr5NMm/2M3T09OTdPuWdNpSLx6ptgKjIQveTTBvGTjlrJdT4zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EXPrk9ssEhAVocRaxcjZlryc2GXuvbHWzoo315xZxuc=;
	b=jXlHchcO6zHlA/hM9VhA/NI3hxnRDKuz7xqx67mFSUHrJB/Wx18MHcv2DVD2tiYlKFkW
	 ysMMaqIzsySO2hxJyVbzLkX30WtcYvpSxaZh7+UMWyBbYxfBTQhyto6eZq/eC1WCyJlgP
	 LJQt1qdLuGt3rG7MRO9mc+9pMwXXQtibrZkvdFrXjKyqCBteatIvqS24iiL9622iznrPr
	 QVd7PQZG8oOQRAsF6AQNo2L32nklYd4B/b5BoOjNfGIhw+XXDfhjZ3XAyeuS42TOtvx+t
	 Tx2kMKiOfzXmj32SVY++8j/2jgiKgbvQ3Xq8cyffBVekM7AtqAxnwrGHf1XJLmdrowg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO433axR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBF60A262A;
	Sat,  7 Nov 2026 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO433axR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4667F1F0089F;
	Sat,  7 Nov 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062262;
	bh=EXPrk9ssEhAVocRaxcjZlryc2GXuvbHWzoo315xZxuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO433axRJcEvXc/s3bv0erCuGPm1xAZ2ajPhrkt9nOuehpoH75GZU7aKoWDay8cAI
	 C1k10OC9EL7+PziV6Sc8fOIjGmi2lc2nYIBC8jdpZLHgS0c8BhXzh5x78V7GlQsSjX
	 Y7ixZgcMuJ+CjisANS0QsSsA6j9e22rztN5ARhaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1206/1536] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Sat,  7 Nov 2026 08:53:42 -0500
Message-ID: <20261107135031.625315027@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 45ecea8c55521d424513178fb612cefffb09a9f5 ]

IRQ registration happens after dpaa2_io_create(), but its failure path
only releases the IRQ resources and the MC portal. The I/O object stays
allocated and published in the service list and per-CPU lookup table,
while devres unmaps its portal registers after probe fails.

Call dpaa2_io_down() on IRQ registration failure to remove the object
from those lookup structures and free it. Reorder the error labels so
that a failed dpaa2_io_create() still skips this cleanup.

Remove unregister_dpio_irq_handlers() from the probe error path, since
no IRQ handler or affinity hint has been installed when registration
fails.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: fe8fe7723a3a ("soc: fsl: dpio: register dpio irq handlers after dpio create")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20261002194802.375497-2-mhun512@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/dpio-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 9e3fddd8f5a91..7dc65f38d2fdb 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -248,9 +248,9 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 
 	return 0;
 
-err_dpaa2_io_create:
-	unregister_dpio_irq_handlers(dpio_dev);
 err_register_dpio_irq:
+	dpaa2_io_down(priv->io);
+err_dpaa2_io_create:
 	fsl_mc_free_irqs(dpio_dev);
 err_allocate_irqs:
 	dpio_disable(dpio_dev->mc_io, 0, dpio_dev->mc_handle);
-- 
2.53.0



