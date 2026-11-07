Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064621;
	b=cZE+JfHNhu47tVMmTUINfS+0rJV65ng+p4+JQKGyvmlJViTLfA5T7oc1KaJMZhpOCjCI
	 GVdkISysNOCcRFiqSvW0Pf9RgXgrH4V0a6RKemEa0P5h1CRzOlfDuDYC8OBVO8YxYJYMr
	 q3QwRE8NW9gPhmCNfXAAp12lpDkeOkzXHzlevP7wwIsQaXiTJP/aZoWEkB8KU3W0zIYGl
	 KHApsJeLBOMADgQlXQB3ZM2BDwIKH7bDsZXSp6xbJlsZglYJKkBIBwqHTpKXvp/ZJXaBq
	 LZMQTC86+q1qDqiPjJuxisCp8EvxdXfMDh3djfWlPWFMAhiE7gN+UcR6euAzkna09dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87Da0HIMkaUtSl12i1U9hCfpkxQxGPBaxUgobvZeFXM=;
	b=btbC0yXj7/htFZJWJqWxzFW6PBxXiHpQUGBSkvZjtW9cJJ2gH9u1wpkrZTnqWT2Ix8A+
	 5Cg+eYVDyPcZE5aaGd5gY7x5UMhKcj8FZDNbxQQWric0ZuXm49aclhO2WWIJ1LLEbi7CG
	 wqUfeMqy8y2U5TAy6u5TVsKpW52qCEM0C6w20E47NuOdIwYPP9YLnDxyeoC4eZEF8MrYP
	 cM2neOzHwUxyhmKGYmwM1w2Zi0NVW0xTjkHEAYhS7MGftrBXziL82ehJSnn8ttgXvLrDd
	 z2pG3UVDqKiWBO9mqM6lS8emEYKdKTUN1tly42kM0nz2P0/hGs93Cxmt5DYHsKlPfpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uV8gGP+T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26648606A9DE;
	Sat,  7 Nov 2026 15:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uV8gGP+T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81141F0089F;
	Sat,  7 Nov 2026 15:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064621;
	bh=87Da0HIMkaUtSl12i1U9hCfpkxQxGPBaxUgobvZeFXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uV8gGP+TOq3wSfE5c3mY3yjHUd2UZWLXAqWkfo6lWqmffp5DqC/Wt6kJty4CI1ywf
	 YMsCBeTzrjx2eZKdI6/eSY/wzaO/o7+OP+QCElnxaEbnVlyBItuf0vTAUCi01ttI4e
	 GRzmG5MMKB0eksz8WgTBIVej/c1WAPyHCVHximNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0592/1257] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Sat,  7 Nov 2026 08:48:08 -0500
Message-ID: <20261107134955.684891268@linuxfoundation.org>
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

[ Upstream commit a7831c657c90e8f9165f6bbe0cc56262fee075e8 ]

The DPIO interrupt handler accesses priv->io, but dpaa2_dpio_remove()
releases that object before tearing down the interrupts. The IRQ was
requested with devm_request_irq(), and unregister_dpio_irq_handlers()
only clears its affinity hint. fsl_mc_free_irqs() returns IRQ resources
to the MC resource pool without freeing the handler. An interrupt can
therefore access the freed I/O object before devres releases the IRQ.

Explicitly free the managed IRQ in unregister_dpio_irq_handlers() before
returning its resource to the pool, and perform IRQ teardown before
releasing the I/O object. This also waits for an in-flight handler while
the object is still valid.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 993fec7e11ca ("bus: fsl-mc: dpio: add the DPAA2 DPIO object driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20261002194802.375497-3-mhun512@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/dpio-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 8d3134622a285..d8f28fb7c37aa 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -88,6 +88,7 @@ static void unregister_dpio_irq_handlers(struct fsl_mc_device *dpio_dev)
 
 	/* clear the affinity hint */
 	irq_set_affinity_hint(irq->virq, NULL);
+	devm_free_irq(&dpio_dev->dev, irq->virq, &dpio_dev->dev);
 }
 
 static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
@@ -276,10 +277,10 @@ static void dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
 	priv = dev_get_drvdata(dev);
 	cpu = dpaa2_io_get_cpu(priv->io);
 
-	dpaa2_io_down(priv->io);
-
 	dpio_teardown_irqs(dpio_dev);
 
+	dpaa2_io_down(priv->io);
+
 	cpumask_set_cpu(cpu, cpus_unused_mask);
 
 	err = dpio_open(dpio_dev->mc_io, 0, dpio_dev->obj_desc.id,
-- 
2.53.0



