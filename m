Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051660;
	b=S1/wiR26FkPCeV2GPktoB2nbRxp3InuY/HII6VPbTbU7MyeGXUnMrU05m4y/ibAvk+Ta
	 xI/FPSrdq2KxieFuWTKTpyiZaHTgWhdUn58h8KX+Yn/il4xvKnhcLCwrMXMVCen8cdeM9
	 VZ50DKbWq8aKAHizjaeenX2DT13FjwUTRYmR3cpkf0NMMWUWrh2KVVKeBSE7uYK9LMAq2
	 Q7rAxjBXPcT5sZMsrYi3mJ03mpODwxriEOzgL26BcOw7rE7uZtm2MJ4baH3z2N5f/LAFa
	 jRKJiOd3UmZ2+CPLLsZy6iy3mrU6dZpyX9k4CEpPgQSBgz6KB11d2Jt4lzCMn/XdEbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4nnrV5jH8vIs038ysDVBp1BAM2QKFCP0Bd2RrtNpBE=;
	b=HXuQByOVD9qioy94RTZU0PN5d542FhhgK2lf0rax76tlnw1Jr2svg8BIeE/BNE7tzGLt
	 g1SQzIXJV1qTUYfFJ1l3b5wKYlyJXrxe2Zr0oWtgnD7wK+a6uX7b+ZqbFif5PmlaFYEVP
	 zz9ZIBZn4hEC1Uh0CqWnOZQzjWJlJdCCHecVnp01TfxW2USCrbX+WC0Dd22d3xr0Gv2ko
	 lq1uaJpS2rjpAMaFqKiByI3kcU8wtiQRkOjJf0CjAWhOTQBzRHjuv7qMqr6uVIKX8zRS8
	 9dIEuFeAfZaoqcpHf8w+AGg3xz+AZpB535bl4C14gD8fdLxcoIb+qTW8iqVCHIJyKgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXOdVI9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691D5606A31C;
	Thu, 19 Nov 2026 01:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXOdVI9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FF91F000C4;
	Thu, 19 Nov 2026 01:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051660;
	bh=f4nnrV5jH8vIs038ysDVBp1BAM2QKFCP0Bd2RrtNpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXOdVI9rez2lxU2pt8SDMnAhdmMurQS5IGb+FLRFQ1y88gTH3IO1EH4m0VbKQyjlu
	 oTf9vnDetQCWoX4LtU94im/kzvqGBFkXYnL3JcB0vimuxb+o/lVEkLQZpQdgCBhtw7
	 hiJ6TLnc0AlG0/6tdi+RxjZztaspscC9Ged+t9tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0260/2214] media: cx88: Disable PCI device on MPEG initialization failure
Date: Wed, 18 Nov 2026 15:32:16 +0100
Message-ID: <20261118150020.518882314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


