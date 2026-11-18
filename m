Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058265;
	b=NBpQlqlEaKjOqKeZMkoJGU1UKSm17PNZx7dhiu96Mg9/BVguCtQyvXTSpNCsqPYViXhz
	 aHs/6AeK//6HUT94NlZ6mTnaN9X7+8qhsbkMV6hWL/Cu9LngT1xZFGt87or/Ahn1s6JFQ
	 RbOkCH3y+13F+S3cIPNuenQVULWG0ioGxq8+Cyi+V7cu+3Tk+vYf3L0qqVxhJW+MOm0j5
	 SlZrMQFCwmky0pa1VZAxv4v1casfN+6T20g4D4kfH/Wo1K6fWz/RLxztJjOshfLQTyPmh
	 qqIMvdG89IE7E11t2lIIXGg6vTWbTxK24oH819dCljX+sXCSV3WPAKg0sCRM3x9/fIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRo6wUairNtJKnVkiy8RZ62jAsBajKt2W08+uxzKsEc=;
	b=mjbkw2buuBkI8qz/Av53ZYNMgP5lT2CqOKxuIL9MVFwR9w6u/VDwEcDBwk/P7n/hZiyu
	 3gSTjxNUWn2E9gONR9Pd1MLjY6N4rOFOW9WEIA/yB+2f8zItYyvmuwlDY1y7gWapmU7fL
	 39Jl0NE1tiQKXpdvjQWvVg7TTFac5E0kf+HjimrWQ7j+hPzLSsFj3Oz1gJjuNsV+sGEpC
	 2BnrXL9BAVhLtib2qbPSeKZWFJfovh6SIWH6y6rsWUS4sApJ/d0JwEJ9HQ/m9b2eMlD9J
	 /CyUX7WhsNdAsjLuVoAKhjXfPh+ga0U/v5OXyIW50A/dcLyjqfGjWLbhvDhXFBr0wBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NGX/59t0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF43606A31C;
	Thu, 19 Nov 2026 03:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGX/59t0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888531F000C4;
	Thu, 19 Nov 2026 03:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058265;
	bh=CRo6wUairNtJKnVkiy8RZ62jAsBajKt2W08+uxzKsEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGX/59t0s4z7/RWDc+Lzzp6iKZMKXRhHnflClXXjLT/kKVmPEUtbIFEfOJSSG9i8L
	 gL8IZa7bNWsZubnxwLmj/LEX+FTPTrkWunhIn0H44WvDnd02Q2ZRlAe0MoHQGUewJh
	 bHNKxY3R8oqkzKWG2KgO1rB4aDuzyUtbKMiROg0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0424/1848] media: cx18: Disable PCI device on probe failure
Date: Wed, 18 Nov 2026 15:41:02 +0100
Message-ID: <20261118145931.890543385@linuxfoundation.org>
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
index 95aed00f353bd..650c502f6d711 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -807,12 +807,12 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 	}
 	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
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
@@ -836,6 +836,10 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 		   cx->pci_dev->irq, pci_latency, (u64)cx->base_addr);
 
 	return 0;
+
+err_disable_device:
+	pci_disable_device(pci_dev);
+	return -EIO;
 }
 
 static void cx18_init_subdevs(struct cx18 *cx)
@@ -1122,6 +1126,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	cx18_iounmap(cx);
 free_mem:
 	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
+	pci_disable_device(pci_dev);
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
 err:
-- 
2.53.0



