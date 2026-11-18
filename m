Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045111;
	b=Jda72pToLyqvrIvjYNnXW8mYXNMxguN5nKJu9nvDfLGDbAsjQqHZos3lavtdLrCDyq6T
	 8ZktIK9bw6ufdGRuj2135LlyVvIEaxDt7oN8IUWRNv+6RfN7tCFktKABwqKBbBLK4ZnaY
	 2GUiP9lyTjy2oyLISoAqkNZ6LV1b4Od6pmXwdC1SQN3csE6EUQ7TO72xazJBD1vtB00GP
	 iz34z8xYWRcyMQrHff02n7YDYn85+AZV3nBFL+VP3/TyiInTIEbPyz0cFoReuB18scXr+
	 TnjJuV43vYi+ffbOno3lklLr4vwcuX49hKK3lJm0/UD3iDPYo2rlibVXyFhPz1WBFfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8wr8fxgG14nxHNngCTyrPgW2C2QFZl1dlvsdSwrDGwg=;
	b=aCyNRZOIluNU2tlQv/Od2KrhwOKHFom7jbf7dXzO/7kd5urb5YEfL9yM3H8rr4M+FsfX
	 NySEzZZh7nKmTBrm1FOFSGe9BisMKI9HiS5XPWb3jD2mqd3+lYmxMzTYP0DSxcax0Ta9n
	 hsgbsR++OpElAljAwUfAPJXAtun2D3vUzNEYohmLE+mh1r6aQ8uVYPGrAsWhxurrXDFpj
	 6ce1wR5uz8GoiA3sL4Qr3fd0MoKV4+A2zB7wd9aU2mmrfg49XgI2kJ/pCNJnY65J14wio
	 Q8pVBM6602Dv+ejnBTU4Z+EHKijkoP+q6meyfH53n2p8icvA9+21FOZFHKJ4AygHSQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMagn18E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E78606A31C;
	Wed, 18 Nov 2026 23:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMagn18E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690A61F000C4;
	Wed, 18 Nov 2026 23:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045110;
	bh=8wr8fxgG14nxHNngCTyrPgW2C2QFZl1dlvsdSwrDGwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMagn18EMUFMtK+RyC4eFuV5AzhrpEtSnZKZi24+ViKFQxlRElrDP+6YRlWtEtWG2
	 jTDGNeI8KXP4Ybqk22DUPje+nC1afsJRqf+X6c6zxLJTpLQaRw8h6WwmgdJB5fGRCl
	 xFCX7ZDLQXDuscab4MwjFuPk+QGBjlNiKcnaarl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0807/2857] media: cx18: Disable PCI device on probe failure
Date: Wed, 18 Nov 2026 15:30:41 +0100
Message-ID: <20261118150230.629626305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 84260972c3432..f3aa15ee4e6e3 100644
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



