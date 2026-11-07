Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061123;
	b=BibLtONRCLQfJA4JBM6RHZ7FarzcmogesZmqHwMpCJ/T3GTiH8aqLsadeZDDA19S7xaV
	 dkh23sMGRvvTfqfVIa3/hpWCTtqy7O/QqXJlFpda8B7naikbFbU85Bt+yWkuJuRuiC+aq
	 gALQjXFEJ4pqe2uWph+wCoCyRD9AKzLvNwIkmtjr/jlBx37W3uhIfP8wPNHGq8i3cFIP0
	 sdcVUZ4TevwQiJQaKGv5uDCrCAUpKthAGckfBve16AASAzQacpPYINkCLRL9nxhhKAznz
	 sM+xJIwhYHQdczrbExneQ/uJmYQOVgno71uoFaHWDONWrdztnuGMtl6vJp1HpvBwBuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIp6ZRKqeQ3afXhPqODmsAIP1ki79cW1BEEmLW6GPyU=;
	b=mTt/P9DPf/JSH9oYCaO98qIEOzL+pr5BlPnmBLHiu523IG6JvhzzSon7E+D+Pwtz+/HO
	 BJg62fpoIhaQzTg5dV4+46EHgoTFC5F7eOLMixe7GBvm95eLmVXOtdold42bTUgkAIpKO
	 2GQcdcfjZp9YA40ny07ciSvJSIQA3JVl+sg/kEX4IgZeP8xv8XzyEaaesALau7+5FKO00
	 6/E47EPvlK49/n2IXdJWgzpj6+Uc4gHh6YA6LXy0ebFSLedK5zDGOwBztjDm079DDWn3b
	 QfNBKIwyR7eNxBpUwsiEB3GreNK//ZkCKfBq7TN+rKaXNIimZYlF1IaZVV0BABZ52Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06wSdxxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A50606A332;
	Sat,  7 Nov 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06wSdxxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7181F0089F;
	Sat,  7 Nov 2026 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061122;
	bh=uIp6ZRKqeQ3afXhPqODmsAIP1ki79cW1BEEmLW6GPyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06wSdxxy5JX3ybUqeC3fAUjMWLb8G4xx5adxaRRQmOnCSDgIUMxmbfecM4E0vJej5
	 qQjIueSuMxuYDv81xE37ewo76hjnOF+UO/3rFLv/ROmPM5ApKkrmr5WTfgGznyQTOp
	 13NSeqx0ERBNKFnGrcP10X0KYbJ8zZlUgoEltxoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0436/1536] media: cx88: Disable PCI device on MPEG initialization failure
Date: Sat,  7 Nov 2026 08:40:52 -0500
Message-ID: <20261107135009.803584781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


