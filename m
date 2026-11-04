Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831141;
	b=AwoHD7JXTimwmSDAP9HdXD1kUHB9hW5kdW+mI2517yVxgjOOL9Jj6oZesP+y5feXlnwy
	 W49QDIO/K1MZ0fje+eXEi2PN19b6MTws4OgopN/DdZ85751VKMrB1EBy9R95xmUoA6rpk
	 ZTCDeaINhPRRPmfquZCiTLae0ZBJy6oytLE45LrmGq9mjy68WP3RFG2Boy+wOwcXGgIZ4
	 +/u4yLswSYGfmb4PVP42cWm0RKTohxfnfgog8WZP3dUHe7dH9kk0NN8uBvJLAeGB/XGeG
	 XMUyxiW4lvd2tlhAv+BirkKGAs5rXFuABj51RB1fnygFzG00m5G05bf15J3oUaciosQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjhTT0KPjeJadx3VRzeixdBgVp+yzszgqsPLiAx7hUw=;
	b=5E/u9XMmnx+8ZY9tRZAQxPrqMDGzlvClisgLx7M1rnoaRYVLmUNdnpLR7vnRZ0oPChkt
	 HfXEDvmStdWczubqKHqGobZ973n2hQcm+U8oGh+He9EwW2AcWlDbE9GE1Bt6aGnxAYFCp
	 5cUcZERgLozKVEtrm9YBu8CBRBLFPhdg5/oJws+siqLaRHbOwYqgdH9qVUvcDCkc6PcNH
	 qhTqukXJcbBL6f40ZP1+9B2JLUHKngE0BST0cwFeAAcnarUyeUClwbI9JLuc8zCrV1cTC
	 kYMErqF9Jq0gp/I8n3xC4W1ERbwlxHV0BJ2qpbGjsQE1PfZurcqjjVfcHOUk+NQvk3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCk31yA8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FF9606B3B8;
	Wed,  4 Nov 2026 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCk31yA8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10BF1F000C1;
	Wed,  4 Nov 2026 22:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831141;
	bh=WjhTT0KPjeJadx3VRzeixdBgVp+yzszgqsPLiAx7hUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCk31yA885u05Cx1MhBRfVwYTve39c6WhpZEqRtqcan+VVKNG+khVgI7r/WKLiCzc
	 Pt38I7fLhYT9qMICiYncfwwxs9/tPuPaCp3Isr9+uAYZdzwhxhI2fTBIn8K4zZJ3Ek
	 mNbTzYoyQBpUZCY9x2BMerhQ1RoWAro4P+t28hYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0523/1005] media: cx88: Disable PCI device on MPEG initialization failure
Date: Wed,  4 Nov 2026 16:04:16 -0500
Message-ID: <20261104211058.567682311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

commit 80494a83223bc972145c23890b083d20651512bd upstream.

cx8802_init_common() enables the PCI device, then returns directly if
DMA mask setup or IRQ registration fails. cx8802_probe() frees the
device and drops the shared core reference without disabling PCI.

Disable the PCI device on both post-enable failures. Preserve -EIO for
a DMA mask failure and the original request_irq() error. Do not call
the full fini helper because the IRQ was not successfully requested.
The successful probe and normal removal paths are unchanged.

These missing error-path disables are present in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx88/cx88-mpeg.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -392,7 +392,8 @@ static int cx8802_init_common(struct cx8
 	err = dma_set_mask(&dev->pci->dev, DMA_BIT_MASK(32));
 	if (err) {
 		pr_err("Oops: no 32bit PCI DMA ???\n");
-		return -EIO;
+		err = -EIO;
+		goto fail_disable_device;
 	}
 
 	dev->pci_rev = dev->pci->revision;
@@ -413,13 +414,17 @@ static int cx8802_init_common(struct cx8
 			  IRQF_SHARED, dev->core->name, dev);
 	if (err < 0) {
 		pr_err("can't get IRQ %d\n", dev->pci->irq);
-		return err;
+		goto fail_disable_device;
 	}
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
 	/* everything worked */
 	pci_set_drvdata(dev->pci, dev);
 	return 0;
+
+fail_disable_device:
+	pci_disable_device(dev->pci);
+	return err;
 }
 
 static void cx8802_fini_common(struct cx8802_dev *dev)


