Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059628;
	b=GOxltZSL7VE2u+gzthEPkYT0Xz/0Pp0bKIQx/pt3ScBIzyk3LYvRa5F/ZlJwlqjZDHGb
	 LOFwzXJLUpFskRUW1MBg7zsRws9WHFAlZfrduwHF2ayG4NZ5zvzL/Nuqa4wWfJAxCe3CZ
	 l68I/PkX/RMEvBVfMYXGmgQAmnvKtxgJEDhLJ/Bw/Iiw2ixMdTkujPqV53B3UpZsefEUN
	 r1wfOn7nrKpIJxuISlmZEDfXvFNqEl4OQJ8/DCArY/CkYUNC5kirgcegg6pCFhcW86sv5
	 8KoNl27R6R/yQJ/5iFIE+OixOAmn9+x0P55nbdRYiQGaswxtz9pmxQ9RNFYDXU/5lhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBC1ZCEf7YVcFN87q2nbq4V6bgxZYwx4qwIc2EjahHo=;
	b=rZUJG3PLtZE2zCeKiZObFFuTKURVtv0MfYtvM2Bduc/SBioO6blenPcqLC13OEOQ+IEd
	 0MmvfVSJD07bAA32XaEDSfUA7veZGGA/kKF9Xwf4aKCicRcq5PLpmzvxpYnBaEGdc4ZLG
	 90i4uLhtpXqgPtXsSu8pARk7fPFJmcOzILcIinB//aMZpzPYU9lytLF+hII55ZqJQtqPt
	 1z1ZjDakg6Q1oOrx6ptSMVwxaCFb5Z2lu87XjzlorzGszDKlP19x9QNhamN7EV6kggcxw
	 owiwV+RuKvM1nRawCXdacKwxLr7r0rYPA1S5k5dessBIO9PnT/DmEjOE9d7mPEhAwYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7kwUpX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6378160A2617;
	Thu, 19 Nov 2026 03:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7kwUpX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38BC1F000C5;
	Thu, 19 Nov 2026 03:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059628;
	bh=hBC1ZCEf7YVcFN87q2nbq4V6bgxZYwx4qwIc2EjahHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7kwUpX5sMVf6hXTSmyNdE7v6PiPn5TX03UFdEfU6+HslG3tIUvXRUwGcGlG3FOrz
	 7HHGLLwgHwGc+h3W8OzwHltKfbngxmxg/tYp2uB2qlizIFBtErsS2WDHgPvI1XOfL2
	 Xq4ZdSBsC0XXmCq1DpISTEC7b9lKpO8Uy+hyEqmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0909/1848] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Wed, 18 Nov 2026 15:49:07 +0100
Message-ID: <20261118145954.903016048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed devm_free_irq() to use irq->msi_desc->irq instead of irq->virq. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/dpio-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index e1dd4cc0702da..8a93dabe1727a 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -89,6 +89,7 @@ static void unregister_dpio_irq_handlers(struct fsl_mc_device *dpio_dev)
 
 	/* clear the affinity hint */
 	irq_set_affinity_hint(irq->msi_desc->irq, NULL);
+	devm_free_irq(&dpio_dev->dev, irq->msi_desc->irq, &dpio_dev->dev);
 }
 
 static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
@@ -280,10 +281,10 @@ static int dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
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



