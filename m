Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034415;
	b=eubcB6GdsC/xUIK+0/XslHejvL48DNpir/aV3g14hvj5UVwydBqRJhr7DoMpmMmnYwN1
	 FfrCqR+mATSUi6sD4ZyIQ4/NzRMqFLdEFfPhl+soZMPCqETxEnlo/PGVlST9ENRfwFeRv
	 CToE7UElJiWQV/LibUUyc+z1RXIM8fd/Dve3fKDHcs9ZjEukSiTrVkd9gGVN7o3K6SWIx
	 +0eG+rubQAV3nYJcRl4yrQeazL1ljE8GWwW/ogQpoDTi3FAAle86PNHa1fNurW8xDQUGt
	 0tDho4guVzmtUptqs9ohSSIDIHlNdr7O7fe2FX2UywDjcvNIx1Ol9FzPcTmUc9x+Qeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Amn9GRZKeoWlR5QmO8RivP8Ka72E6MJQl2JlLIr70cI=;
	b=N0dC5aciOXDe52foY1r7nkgL0C8TOYRTjLF7TSrtFQXFdE6CE8wLKUrC5rHT6mZWBGFU
	 u5NjhMpc8uMK5WtF0t4SzgKq1nbcjshLPOp8psc3Hdo3Fe3ChDghOQO6a39DL4oZMSo4S
	 jX1392Jn0whwEqcaMip1sjo540u68FyTWRYvaTvTkeflSVgQqLrUuZfOr+8TlYD2ztmpx
	 oFImYblugfRrMEsdfyrPC0dokWCE8sqWLURhbLICPgDnu/Fvep2dkcL6utDrYSRUpANgm
	 N/oUvkge6B1zaMoZZRXnCD3V6mMCsCoFeXelQfdwenwGDs6yp6L93+9T4xEqQ4BDgvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gPx3iAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EC1606A32F;
	Wed, 18 Nov 2026 20:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gPx3iAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB1F1F000C4;
	Wed, 18 Nov 2026 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034415;
	bh=Amn9GRZKeoWlR5QmO8RivP8Ka72E6MJQl2JlLIr70cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gPx3iAZfSID5iHgJr3DSP3BD43dAY0k8sbVI1J73is5C8bvA2COf7hpZOFpoWogO
	 Eo8jjDd05esc7wyavLtm6zV8H/xNYv38dJiweZ3PttSFZ4JeVVU0elwzlnrJqUvwFG
	 EnoV1/z/Ju2EL82nwaRrio28fY+A6nwX+ZBkEXI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0360/3318] media: cx88: Disable PCI device on MPEG initialization failure
Date: Wed, 18 Nov 2026 15:16:22 +0100
Message-ID: <20261118150326.930958725@linuxfoundation.org>
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


