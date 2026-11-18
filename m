Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043718;
	b=KqvN8y3hwCFzDKdp39izwkL4tHinO3Rhp4Edh+VhBoq7Ysp2GwYGuJeTvqSTfoszbh1Z
	 VLr1uuw+Qn3Oe/dQQk7IcC2drAhVvtpjsX85gb3o/W4tV19kesojz7dKGOvNOb2L5c8Jz
	 5iDRfXp1/yVwkozkxOIFG/USxnNFd3fGh4CTrrS++PEQCKEhOYaMj8kBC/Mjf2n5nvVwG
	 8GLa2mKHZXc6FahFVB7kU0gZNXg8A0WDilGDwZN+tV6jOPSj3JTmlfYp1DQ87ts8Wfp6W
	 P2IT4C9t417gAliYeYqBdL5uldHIi+zQc8T+rMkE2hxl1VgfVLgUclkRL14+KjOMLdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nDmBQRYdU8hW1VSbbiSZhuunSrCJLgnI+ARevwrsCl0=;
	b=b5bZAeiw4rgaqB9+SVVKm1Ong3Z7zkDlgcArG7cbhF/eua56okq8DmxVRO6dcKo4Pt2u
	 dhtX6cQiJZdUsLFQkKCnf1z0k6PHPqXp8LBzsFGIlANN+c6oN19ewlsSzgKWtlKyC87cF
	 8Cz7k2wEllDQE5PPdXf/9joqvIlB9I2wG/2d6U+p9FD/nof/6lafSiJvBuV2LU/X6S9II
	 XGp5usgPqhlr0/XnxCdCoGXMQS4mEQnsymzSSjLpqLWakgzOMQAjB9CDrTDyoKE+gf47p
	 0BdUL/aAKYjqAEJOGLdqk8yizZDinXGA2TX4+JwzPjG1Ir32/FPxP0bIT++vul0ikiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyaAZvuO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51A606A32C;
	Wed, 18 Nov 2026 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyaAZvuO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED13E1F000C5;
	Wed, 18 Nov 2026 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043718;
	bh=nDmBQRYdU8hW1VSbbiSZhuunSrCJLgnI+ARevwrsCl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyaAZvuOJU/t3fOu/hE0DN5qDwmWzPkCHzpKUIdOuDvRcyM0YX0gRceCc51SjyYcB
	 d2xzLXfCz3eAydzw2te7tk4X/aIGfqR3C2fZ+40OrO6zll2TvJZdTw0+EKSNnXEchz
	 BDJ3+MP0ZiZFxsomuywuscZa5+Jtyp2A4GAsPKl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0309/2857] media: cx88: Disable PCI device on MPEG initialization failure
Date: Wed, 18 Nov 2026 15:22:23 +0100
Message-ID: <20261118150212.571244632@linuxfoundation.org>
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


