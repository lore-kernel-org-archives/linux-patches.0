Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064620;
	b=zYRcoLPzxxJnDWVjC0NhJ3kFVpCpBFjRG2N+5PV44RBRIFRqDy5AUmLZeO8ordtqQW7j
	 4cP6shi6v+v25AtzdFu6/b6AI8v5qidx7tP9mHMzaTAV+gUa1HW+PNFb5MpK2TYYHpR/1
	 ZX0hl/sf7eIGWJeQaDi55W43Z2nZB+RwwX4fvLWIUl1PzhIxHlB9MqeFwraSnBCxHYUPe
	 90+P2X84L+uoZJQa9NtEFAyLDP1mz/rTePLPkmxLiMHgCJPi8tDmSpWVueMPlNjWgQbOX
	 ijIazGNgmlmkbo5zsy4P3Jwc6d7BlTDPC5RxSsMMlFa6cLm3FsZDe/lfoNfYBE05bKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jtINlgZxUajz/MsuZAtnFyqbZl8I0RRaTJzdG+lJXKI=;
	b=evYx2vZyo/Ss9ppilH9b+CkB/05Cp/JU2ady0UYYe5xMcdtxwz7jPjxTclsqirYU1cHk
	 cQ39w4EsWISpWb6hPaomHhUMEEAKKKWTQ1+x6SmjbVzlv1spicHgSdkalBJmrhJ9xOxWe
	 tWMieVH9JQPr/dLTVGB1uLfeSqVJ7Us76A9UKMPPHVAulq6ZO1ZTg+7lNSy/qMOQ2aOsA
	 A6K1qnAc0PfZ7RPrfFDNXRj0I7t/18Fy6RwfNig4IHLXEamuHQDloqaaTgNFrR4JTkyOf
	 Ak7FjVAcqdYQBKmJm1kPUFsqSrW9oPDir63w6iuL6WMjZi1OJ51/V1DY7ceNKI5EFuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaPiAO69;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B7606A9DE;
	Sat,  7 Nov 2026 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaPiAO69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5501F0089F;
	Sat,  7 Nov 2026 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064619;
	bh=jtINlgZxUajz/MsuZAtnFyqbZl8I0RRaTJzdG+lJXKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaPiAO69/+vYo5/GSFyokFBxsZP4RW1KHPnFn+b9VDY6mpa/GFyMpBCImKs/+neuA
	 j32PWb60Sv6+yBDdtV4fz9/d+Boh1+qOdRCwLkdojz16opqXzv3xylklKg4k4L9DHm
	 8yH92i+J/aHCP15u2QTvzOGDxdIwLtXD7QDn2jmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0591/1257] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Sat,  7 Nov 2026 08:48:07 -0500
Message-ID: <20261107134955.659414909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index d5198ffc44550..8d3134622a285 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -244,9 +244,9 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 
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



