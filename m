Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057671;
	b=wXd1QD8zl2o+Ygx54Jmc0J22A73NxSvF/1gLdsRLm8QgmoiFV9ubTiXPT3u9HAcXvrtR
	 lpSVtCbhSBVcTHgFdDII2ft8uK+zthy2NIaQljt4EznR7KQYktDLYP+EmvyX6lp0bqjgE
	 eRH8P6P4dkqWtDQh7E1a3xkYFuiNFgRR8ABqT3Ie1eaERJycnN2KIY2EuIdjQVYf+s+HH
	 yeAfBlL4096BHLZtDD3K+zWQfOtyRJMG/QbVpuiUtbNJYD+El9M+ivBBWewmF4EGFjUxY
	 fSYfXt0l6PxsyiAhSh2Tlvosh3RByPVIeH1+2m/8P5+g4IbdZY+NeSPrB1YngPwTdeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ai8n7oiqSw/Aa+9Fk1repUGKu1o8K71+CrY3i6JS1c=;
	b=TMPnAPfkWA5Xj+x7OJz81BeOfPtDmVCzVBeg7R3lX1MGnWrDVXJkbkwgXLcSmpImqPGq
	 S+zV6rAfEKetm25+ikAtY04xIeLT+J2UMcgTYl8oIttveQpzh3LRs9d8TvRVJQQ0tXvSg
	 92K/nT62AyUVb+geyiNE5UhIpFGVuIFK+y25WcfxzMFefbSeEHHsrTLlNnUf54WgNdUZQ
	 oW30QTujHVB7y5A32Gty3csPM7UzdneBHuJDGNsul/tIEc2r7NatPb0HQSETVZNlNpnst
	 ZldzD82XU2dMM2PtMWcMFTwhbg0qJb0i7YzFCoh04btzXG6UQpltGvwB9LBqip68UOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JeRl4MT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEDC606A33F;
	Thu, 19 Nov 2026 03:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JeRl4MT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D71F000C4;
	Thu, 19 Nov 2026 03:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057671;
	bh=4ai8n7oiqSw/Aa+9Fk1repUGKu1o8K71+CrY3i6JS1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JeRl4MTToeALzmHbnr8KkRw3lScplZNvJEL4esRWvvp+Uj8TzqCI4Rr8BeUXYfSc
	 kqjE+dmR+U92jaf/vUvnB83yKxQz4q0jMKJ2N4ohTXy+cStNi6e0JJiTvZ4IO/WK0d
	 Gxu1BcFD9IoJ/AW/ke5rUHJWcCV9ZYQmkZDOqLg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0212/1848] media: cx88: Disable PCI device on MPEG initialization failure
Date: Wed, 18 Nov 2026 15:37:30 +0100
Message-ID: <20261118145920.908888940@linuxfoundation.org>
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
 	err = pci_set_dma_mask(dev->pci, DMA_BIT_MASK(32));
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


