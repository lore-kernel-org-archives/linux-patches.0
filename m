Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062946;
	b=ooMTCVewUZ+43jMsul6d/ZPK9k1jg64cJNZs7GVAgN9t5kJrum5sqyBoIBMjbVH7fSgQ
	 QjmYBJnaP/GoDK9+SOyb9SQIiDpVcu7MO4LW8fHOOfCbMiiCVtGRmDBMTzbh820QlyeEU
	 KnG6WLwt7oooJpGRzBg4+rvcjJ/xV+ys9kiSoz6IT86+MpWEA1GKkWyplmkGInKc3qRcM
	 kBNbrqJ83Qt642VOoW854dIbiFfy3TLsC5J4vBPt/bI1GLWkjm8oEOjtURo77BlIE5KN8
	 61IfAXhZJ53uLWwADKE/S3jaC0YEZUoxLyF+I8rU+3nedoF0cLg1TaxRs3KRj3ecgYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nqX5/X9YQ/Ohms3sXTt/QUi/yCC5fhzgZgj7vX+9MlI=;
	b=wsGr+uSFagF68d1RJ7HlleKir78m+Adgg+8a6Ff0WxqvDkN4pXTbSv9IDskfWhOEUvFr
	 MCriZ8/RLdoe3/uUPoZ1qoxpZbbXaxiTOwUbVU+8pd0bEuh40xBZE9nTkWiB1DB1sVhjQ
	 1RfG2Ov4OaqRnABYUVeEFJxdL2t7e75Pwl8A2mwBWk/37ZzWB/jTmNf/rnGlpGqO7X7u9
	 UOzWNv5DPzTq3tL9qDrIBgXfWwm9/l6+FURfH1oI8yiWunp07gwWhTHdP4qWs0xHGgeI4
	 ZfoW2gJv8tQC5Dc20ISYhAeJ5Jx/2kB6JcGzAHYPf2/JilYeQulRTclQTI3a55MP31Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKXz+Nnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC6606A326;
	Sat,  7 Nov 2026 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKXz+Nnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4053D1F0089F;
	Sat,  7 Nov 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062946;
	bh=nqX5/X9YQ/Ohms3sXTt/QUi/yCC5fhzgZgj7vX+9MlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKXz+Nnred7HtHfEM8v/iDfnLGTiAh7g+J9/bjzVDZoEH1braAAl5NOFK723eRGLU
	 zPXnnoipwJscjHFLzEiY/zO4ZZ27C3ygnuH99LhzNc42HAc2jw6l0LBQBH/1Bhd1ut
	 3LxcTBfAUMZGVV7gKWAzIa38MmBHvz2st7h/IVrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/869] media: cx18: Disable PCI device on probe failure
Date: Sat,  7 Nov 2026 08:48:14 -0500
Message-ID: <20261107134859.145455230@linuxfoundation.org>
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

[ Upstream commit 2aefbc29765641e1e1a26b96cee194ac7d34ff49 ]

cx18_setup_pci() enables the PCI device but does not disable it when
DMA mask setup or the memory-region reservation fails. Later probe
failure paths release the region without balancing the enable either.

Unwind the enable inside cx18_setup_pci() when that helper fails after
enabling the device. Once setup succeeds, disable it in the probe
cleanup after releasing the memory region. Setup failures skip that
cleanup, so each successful enable is balanced exactly once.

Keep the existing error codes and normal removal path unchanged.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1c1e45d17b66 ("V4L/DVB (7786): cx18: new driver for the Conexant CX23418 MPEG encoder chip")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx18/cx18-driver.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 74c59a94b2b05..d3bd31e38efa4 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -806,12 +806,12 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 	}
 	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		CX18_ERR("No suitable DMA available, card %d\n", cx->instance);
-		return -EIO;
+		goto err_disable_device;
 	}
 	if (!request_mem_region(cx->base_addr, CX18_MEM_SIZE, "cx18 encoder")) {
 		CX18_ERR("Cannot request encoder memory region, card %d\n",
 			 cx->instance);
-		return -EIO;
+		goto err_disable_device;
 	}
 
 	/* Enable bus mastering and memory mapped IO for the CX23418 */
@@ -835,6 +835,10 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 		   cx->pci_dev->irq, pci_latency, (u64)cx->base_addr);
 
 	return 0;
+
+err_disable_device:
+	pci_disable_device(pci_dev);
+	return -EIO;
 }
 
 static void cx18_init_subdevs(struct cx18 *cx)
@@ -1121,6 +1125,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	cx18_iounmap(cx);
 free_mem:
 	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
+	pci_disable_device(pci_dev);
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
 err:
-- 
2.53.0



