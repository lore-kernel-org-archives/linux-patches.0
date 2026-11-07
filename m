Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062264;
	b=MW2KkO5IviVWExexigez9pwk6tm/aW/DQqljTF67LmLrkVyo0Bj5/seXW3chb+gWOMUD
	 D4T6nCw82r/5SaOOrDA/6GjXC4abwqniRwy6+rPiNxXajiy4yeO7+iY60CVQ403cwlIt3
	 TIgYx5f2Jj1Qb87TNTNfTSJMn5+2tE8BLyVtHxIyfbhsBfkPSlBH7BtBheWJsu4notM9u
	 NkGsSS6tLhlYnKdVRA5wX08xbigGF7SchhWQPCq+tX7RS4fmY8BE4Z7xkQo6zCScsTG6Q
	 t6Eb5AJDEmroap7aDx8L5QUEkfGLZW/1ukf6kTDpvnVQV8LHbmn1WYidTvRvOVsB1XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oOXrel/RqBr/iRPKe2j18hvL8nmX+0vExEjX+lLPqKk=;
	b=pMiIN36TklX6iTI+YZX0VnHw2pRDf8+FGai/s6qHyQzMRHBf9ntglrmwgnUUD2xjSyar
	 kZZ3YStmJP+S8w3T5aNcOq2bIRGunxeIVmKaJzTcrB3RR3QahD3FDxT0CnDTZn+u9WUuf
	 FqMCOhwsdpN0UX29diWndO7j7TKIhXw8n8GCjoAS+5UFbet5ereo41WJkGNiW1OZGmTm0
	 aRv9pwBQTiNx1CRjn95X7+b0ODVuLE5ukzynZ/qhDmNtoeKFJn7Sh4abN3D4jdUZy5kri
	 FewoMUA+zIPCxQTZh9YMqcG2NTRCODr2l+eNg+7+O4UP6tJyIEVoIl6+DxNjUnpP3ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhnIvMFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DBB606A334;
	Sat,  7 Nov 2026 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhnIvMFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628221F008A1;
	Sat,  7 Nov 2026 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062263;
	bh=oOXrel/RqBr/iRPKe2j18hvL8nmX+0vExEjX+lLPqKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhnIvMFgZX6QGkhF7JnJyOAzHoVBWigl/eMrNvW5WwWw39/SeZHOgFukxpAnOfq60
	 2rlLjR9eoigG/VriWM1/pvn+bvaNqNpcdr994e8lDUlq1bi8EHLeBK7ZcmnMP21FW/
	 ACuEiC8U3RbdmC+xxX6U/SL6YIOMgqURakPtjJRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1207/1536] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Sat,  7 Nov 2026 08:53:43 -0500
Message-ID: <20261107135031.653282757@linuxfoundation.org>
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
index 7dc65f38d2fdb..2962e66e2e413 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -88,6 +88,7 @@ static void unregister_dpio_irq_handlers(struct fsl_mc_device *dpio_dev)
 
 	/* clear the affinity hint */
 	irq_set_affinity_hint(irq->virq, NULL);
+	devm_free_irq(&dpio_dev->dev, irq->virq, &dpio_dev->dev);
 }
 
 static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
@@ -280,10 +281,10 @@ static void dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
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



