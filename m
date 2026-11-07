Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063264;
	b=tYqRNvaSATPuj8f81ONZ6zqs5DslcJDLl0acBAEnqs01LG86Z38nbdQiXiuY+9oSKbiv
	 w9cqUbq35Wo2gcbODvK+TThMQDDKZsQxGysb+4E+3PM58V6bBF0cuAahecgsTKKpbOTKm
	 Vue5qyjQ3gPojHa3CGs/sisDkUhDwi8YI60e4DLvlZCL8YJfNe7o44iry75/I+rLRSHKk
	 b7+oBhNGbqI6XFd2lyvyXR0wvo2VVnQdzNha53IxG+kajhtmvHv3r75xGM1LxvH4mzt5b
	 zV417yQoxPcPxNi21RsjWZlxllfEUalfxn4NnIutucr2yUQtkb79xWyH4t4yMRapjKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fkwLPRgFxgq8w7DfpM7hL0bo3sPXRaO6oo4JJPKMO1w=;
	b=TYDsyed1VME/evbA5uXDzwAwRs2fGclq78VoK1dijp94i1KS/AA13yE2lvY+lwKDgEma
	 KCsUcjGER5YhjMwMcmS5jZ/+Zc8uCDB9c3W82Y2CEvxS+F7aUYWWTzNPj8b/MWQbVxgv0
	 ynQRcxj2Uu73ILH24IBchE/djreqrJnpoFHERumBbCy1znr+fIh4gPBypYLJwufDLf0eL
	 l4RGcRTmUboGp+/RQziDy7Ki64qxKvHgmFa9fELidWrOirlgB2Muje+4j51e3sWNU40qO
	 Faggx/gN4SWKrMWArxzkurI3CJSG0SDdFNdW39esjLrfCIFkqcdigTqA0Kl5K1Gi4lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJV3Hdyh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E0606A331;
	Sat,  7 Nov 2026 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJV3Hdyh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF5B1F008A1;
	Sat,  7 Nov 2026 14:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063263;
	bh=fkwLPRgFxgq8w7DfpM7hL0bo3sPXRaO6oo4JJPKMO1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJV3HdyhbuImWPA1R1sWUGz0rlrelfeeMCNV37YkPuDSlLq/bz8IPNX0aV8gfF93Y
	 RbtRUaAmPFDtkmWDYthhTc1cZT4Q2U7Bs9J4uEyAnOCL8i98tVGcx/iEtq3Ofeoe4h
	 qZ6aVswASQs9MQE4tFCXVOJxbFqf4ZOr9CadHSl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/869] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Sat,  7 Nov 2026 08:51:58 -0500
Message-ID: <20261107134908.566776610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



