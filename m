Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036051;
	b=DR3/af8/qoOkYCfrzIpMmubR/rtiTZLhUP5r9MinhJ7aBcCCkflJcgmIp8mxOZvLHjqM
	 C0RDb2jvhM2zvHpkxBVyIN4RgDB3URELR/b43n/xskCSfO4DF5sQuKiBtVMft5E6VR1+w
	 V065aSNDwjzAVhJgk+ukyr4Q7jkUG8U3xU6/iK2MU8f3Dk+MyG9kgRgsK/st37Cm0+9EW
	 F+E91cK8wEZdNhNvITVzTCrgp9thBL07J8PixjOwmG0PZWEBUI6mFPWH39/LV1kZJvzwr
	 COPnxqHvp1SFVM3oF3KbvVH3N0Q962tP1QJenYJHJfKTkAROoyQ//WjR9Ddj2F1L8VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QPuMhRxu1+VCilbPw6zKfu3PlKwB/ivHIoRW86TN7pQ=;
	b=tEtPoVYWzBUN2azxE3XjVfo3+8s7iJNJ4Djc6u4iX6mFn5iAu5yM47Y6CknKX+G2Ggue
	 tb33DtBQWxpCZqCEtq9J3BJVk2ppjRFPeRoll3eUgAB75Nd6Txj1N+UOcAc5S3lHu6iz2
	 suiaPeRvK0cdZ2MheAjDmwdifwA3/8SHahuTkdLIp1ONhEoc8KkR+jGlgbtSI10bDQBBE
	 7gr2QTQxSue7LwYriP4v71CfPl4SVw6NnsHwyEToMiJr0831WglOlurFR49T4jo93Ime9
	 ud9aFq71lataLAa3R8It6u6FHIDIopqR7dlSJ7VPLksElx/UUBSqvTwvzGEHLozvaOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcjhOcdZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F40606A31C;
	Wed, 18 Nov 2026 21:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcjhOcdZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A0B1F000C4;
	Wed, 18 Nov 2026 21:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036050;
	bh=QPuMhRxu1+VCilbPw6zKfu3PlKwB/ivHIoRW86TN7pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcjhOcdZ5rLr8dD/JtTQrnFMi5cZFAumUD2eDwImm3SpjnTpkov1epHx1bXP7Bhna
	 qpTHf0/I6sT0Ri+5iGGzKYRZnFHI6nSmlQa1j/wYO0Gqx/QAyeSznSwLp4rsoWNOKy
	 q3SQ6mKLoutve9wXVV7+K0rlvR5KKWWCorbSmZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0919/3318] media: cx18: Disable PCI device on probe failure
Date: Wed, 18 Nov 2026 15:25:41 +0100
Message-ID: <20261118150347.097206973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 743fcc9613744..7c6de8ceb909d 100644
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



