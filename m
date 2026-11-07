Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064103;
	b=4Fr7lCutBgIKIkrdX1x6qvhcaEee+rz3BdzHj8Qtf6r1UEf3SMzwRFPeyLrpW5YgIXLH
	 9RLc8CKPXSKSZoP732rnDXVu4Kf0IPAsZna7vzvqSt0zjk2J4AwE2UyD8ecT2L3zBwLph
	 8suGU/tPrsCgjcbbfCEmKM3FzTJJgCLZU999VLQJPCLfxakfWYCbaaQuCrFTUYZSj4YpL
	 rspdLNLhk7/sV6Ai11ClAhqxEBZ1bVO4MXlDc0SFjjtWrNah/hRd+OzYeVTj9RjXe5l5W
	 EJUIQYP2QZJSrypDE5L1D3VzWCGf6WDA26NEeZtbaYAnGben7Vr60WZKXTaXN6+K6jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PliyPqpRZoIaqOXNB5mElSLJXRWi11B4IJZA3LKLKRE=;
	b=XqKtAZ8744ehRE2B94lPlxhyYjCKvmELHAoQ1fOJ+FSF1uskhqz82LrLpVYsiW8UaWWX
	 MT3lLjmYqcD/edDk6nQwwEGeky+YAyW+Qqy4+TugfRfWZJLx4L029CU2uGfDojFTsfx6L
	 8aerUG25ssevK82LBEOlpTHrOj+8kHJkbrSLQ8gQvfJyhtzK5NDGRs8AyLBSir/LieiFu
	 +4rJK7pR5xGvvvGZA7HdElkkeH47I/cFXuIrt8rqZivqwsV5xrieVyMq5cc63UvGgHIH+
	 n38C1ff//shKSbhoDddn93IUbmqrAlqNVMrNK7Xs0ks1zrINggVn5cksIcwH6Mzgdhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0HgNtu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B5A606B882;
	Sat,  7 Nov 2026 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0HgNtu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E941F0089F;
	Sat,  7 Nov 2026 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064102;
	bh=PliyPqpRZoIaqOXNB5mElSLJXRWi11B4IJZA3LKLKRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0HgNtu8moRaJQYq37/pvZeDJy/AtrHPGADvaE1pv0jZ6I1Rl140iSjBljotI8B7w
	 WG1oeu/DA77C1PNAlFeMIuaoiO3xYHwpJQQvGZPPTw6hUzbV3oho0B/L+JpG4JKObY
	 ugLc0JEC8yJzQX5HCsijMKWggQXKNwYkA72UtHEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0263/1257] media: cx18: Disable PCI device on probe failure
Date: Sat,  7 Nov 2026 08:42:39 -0500
Message-ID: <20261107134946.763864706@linuxfoundation.org>
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
index 214fac7af61e5..ac90ce6cd0445 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -805,12 +805,12 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
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
@@ -834,6 +834,10 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 		   cx->pci_dev->irq, pci_latency, (u64)cx->base_addr);
 
 	return 0;
+
+err_disable_device:
+	pci_disable_device(pci_dev);
+	return -EIO;
 }
 
 static void cx18_init_subdevs(struct cx18 *cx)
@@ -1120,6 +1124,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	cx18_iounmap(cx);
 free_mem:
 	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
+	pci_disable_device(pci_dev);
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
 err:
-- 
2.53.0



