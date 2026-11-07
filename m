Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063278;
	b=Bnf6eAs+Qn73V/Vuq7707pepva4q2eNusSJ2vuidnLpOAQSyeYkpHYFs1GhsdD9ST95f
	 hG5GdzZAnte0z1oV35AdAeJrmOrOKNmes3oVDOR7x0eXjovT9fJApXP9KOuB9kCyZqCkT
	 qp7MIB3PO/mLZ27zauSldm3+75j/F0zJlp1ykxcIZhsLp0jSI6q7aD92stS0QW2nT9Ev1
	 +fuQ7f0U5H8q5KmgVTYOSdEXZgjkWdxItqC1r56S4k4XCZjA16Cr1DDdUcLjUseOsHQBJ
	 HCV+KtV5UNUpamAtdLRQMvJoQIRPcfKIq1oDL0xh+uerFMVQeOR4ulsRW8zLW2Tpp5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j02t9I3+nxujIHcjrfj9aNe0CRVLpq6v/8a41MUiKo0=;
	b=pyXr0v8mxt4flD0RfZIW2SRjnQloo/5D4Ija4/KIuUcE+C+Y9wS9RL3oAFkz3NcfRpyD
	 qeszHpmM/YYUXDhJxZ0+ooa0rNmhIPMYejV+Gjb5Ejpq/Pg/D1/V5yevQEMjmybCobGTX
	 9TbNBtNAG1dRkwJnFUc4I6vJ+zpOIIrGaDaJefnfPx7512YHGXY+JlqQaTYfNgOY8iRam
	 FNQ8zc4hun851EVRKg9LHMFhFlZAibKo521pF/bOu4pmK/A4aKgJrIFxxYmi3Vh1wAg0Y
	 U13343YnSbL287UOpHRSoHtMKkSOs/aajlirIXlHSBE3C56KmbrcnKnqkvKbgvnMGRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Mstk/WYi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C520E606A32D;
	Sat,  7 Nov 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mstk/WYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F17C1F0089F;
	Sat,  7 Nov 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063277;
	bh=j02t9I3+nxujIHcjrfj9aNe0CRVLpq6v/8a41MUiKo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mstk/WYirx/1wA4n78+qSAQaIBBaPByd6dNALy11dVmngUBGmbp8zN8munJX9ZQqd
	 76Kg/wYnC1+5qhsim3DF+lQUkbZolx5t2ux84afpXWf6Ii9NOeWS8rCrvd96n1zy6d
	 1Z4jArJc7sjfudyVrVQ2Yo9z2vH7F0C0cJctJ5TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 437/869] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Sat,  7 Nov 2026 08:51:59 -0500
Message-ID: <20261107134908.594779608@linuxfoundation.org>
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



