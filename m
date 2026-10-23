Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774713;
	b=ZsrFJLg3PXdB8hi7mRvd7vIcJRDjzvm5U/YLLBzYQ66gRBsQphsa9WN9Wp9zbruNNeiL
	 +baiCeJfbZ5RgZmSGsKbA3XDjwqx7yWh9m/L821ec3x74KFrdKjkQnIgPMtsq/6vhNLz/
	 byjtG0Vujwn49OU9OirS+i9BJXhBvY2QCEsmGgEdJhv4qCYoUiA+y6H/c3kReNYZVI5wQ
	 yo3Ia0rDJVkoM6zUGphTXdeEgJLSkUal49Qg7bQRAHWahStGBRR+yPnXzZvXH8dz+nciB
	 Mgr9VM0aYTydGHM6bwJyVNwPcnTp4nQ60iXdQWtu6hWygQ6DlisJnwvhaGd2+p4XX9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnTiUw49EPLWQUkECAQ+/vAwwIL46fXwMRpVvYmZY8E=;
	b=iTWtPI9AjLN5EixYdaMkOwdSjIZEi5sT/z72nEbI8ihoZHNMTdZp90Vw/ygm6j8GpKo7
	 gwaQ15TjVDwJ8DwrVBK15OrDO2fJJwOznGbJ1iB9NGrxT47PVTelkUI6wkGZB7/ObXja8
	 iFkzAMv3MODzFrtLbTYm4dOYPgYd+M/VIGyF/QAvlBbfZhWwjTr0vRM1R/exoSEdBmdxN
	 AZRyiRL31zLXm8Ol9yFUYf7kPddGOGC0cF4z338I1YXtPUKK0r6qXjncLmd6DU5RhZD7P
	 03ReLt3Ff+QdVi3k26KTqwTPxskkUSpOSHBQ/hqVYpaY3yFNRwVDIsjbzbdK1VfSfsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sd3xQbIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA2606A31A;
	Fri, 23 Oct 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sd3xQbIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192841F01825;
	Fri, 23 Oct 2026 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774712;
	bh=lnTiUw49EPLWQUkECAQ+/vAwwIL46fXwMRpVvYmZY8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sd3xQbIO+NL+1aIufb8NnQxmutuQhoUMP2A2KH3FtUwBTh8S930EFnOZ6yYBR5f/d
	 S/VJQ3xEEEF1pANCckic3YLZXWmoj++FGfVqH6RNVVBVgOkbOQxcdpDAxucEjpi3aa
	 YXc3dQI8A5PYCnHNaA/ZhJ9+4XAtlkcC1jDWM5KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Alexander Gruhlke <gruhlke@mailbox.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 095/242] PCI: Ignore Immediate Readiness on Samsung 990 PRO and 990 EVO Plus NVMe
Date: Fri, 23 Oct 2026 18:38:57 +0200
Message-ID: <20261023163716.024332478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gruhlke <gruhlke@mailbox.org>

[ Upstream commit 0f8b5d90d179b9639be1dbeff59d6d971e6b0527 ]

The Samsung 990 PRO [144d:a80c] advertises Immediate Readiness, so
pcie_flr() doesn't wait after FLR, but the drive returns ~0 for up to 7 ms.
Since commit 10baa9b4df40 ("PCI: Drop unnecessary retries when restoring
BARs"), the config restore after FLR is lost, which breaks VFIO passthrough
of the drive.  Firmware 8B2QJXD7 responds right after FLR, but older
firmware such as 1B2QJXD7 doesn't, and the firmware version isn't visible
here.

[bhelgaas: The Samsung 990 EVO Plus [144d:a80d] with 2B2QKXG7 firmware
seems to have the same problem.]

Ignore Immediate Readiness on these devices, so pcie_flr() waits.

Fixes: 10baa9b4df40 ("PCI: Drop unnecessary retries when restoring BARs")
Link: https://bbs.archlinux.org/viewtopic.php?id=314833
Link: https://bbs.archlinux.org/viewtopic.php?pid=2312085#p2312085
Suggested-by: Lukas Wunner <lukas@wunner.de>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Alexander Gruhlke <gruhlke@mailbox.org>
[bhelgaas: squashed in Samsung 990 EVO Plus from
https://lore.kernel.org/all/20261016102042.641801-1-gruhlke@mailbox.org]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20261011190145.23621-2-gruhlke@mailbox.org
Link: https://patch.msgid.link/20261016102042.641801-1-gruhlke@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0500d5fd4f112..86e6af409da23 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5623,6 +5623,18 @@ static void quirk_no_flr_snet(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLIDRUN, 0x1000, quirk_no_flr_snet);
 
+/* Some Samsung SSDs advertise Immediate Readiness but aren't ready after FLR */
+static void quirk_no_imm_ready(struct pci_dev *dev)
+{
+	if (!dev->imm_ready)
+		return;
+
+	pci_info(dev, "Ignoring incorrectly advertised Immediate Readiness support\n");
+	dev->imm_ready = 0;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SAMSUNG, 0xa80c, quirk_no_imm_ready);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SAMSUNG, 0xa80d, quirk_no_imm_ready);
+
 static void quirk_no_ext_tags(struct pci_dev *pdev)
 {
 	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
-- 
2.53.0



