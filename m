Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2231C0DE7;
	Mon,  1 Apr 2024 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990908; cv=none; b=ipb5tIKgQ8ZH8KenYTqjSdqlAaONDGye136eqCizYQtNXklYAnD397C8BEAYKRXjnKWHfoEHWp7OofxE19yd6ovj1Kj78jmxbAY6fQjJ4c8VwMVzOioGK+KTRVWkdbkOTTXkcWXYy60WsXAGAEr3xy+yAdeUQRvOrHpTCv7qpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990908; c=relaxed/simple;
	bh=kmNIvFGsWInwoshYbbaP/j7BPpzDKalnXzA4aBHiZh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vkj2n3lwF4qwTMQoxbpA3kubjKV1XZ+DwPmhTIOEsEhFVBmlqt3X/hpy35FBgjIda51998ixbHIQEyRLkGLri7BIqnwwU43vqGi+ZSCZWE0iFbrCXNEgtAWF6Klsja6w5oqcQ+WtjjevfU3frk09yWNd7jksru0IJvGHcRaDecQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7ElrpkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7ElrpkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D311C433C7;
	Mon,  1 Apr 2024 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990908;
	bh=kmNIvFGsWInwoshYbbaP/j7BPpzDKalnXzA4aBHiZh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7ElrpkX2y/vE5tvow3gxdDze2eKraVciCoEtme7s9qON9vwee0X8+pn2LHJB3YNn
	 SRHuYxwEP8nlS3xVHOIDpwIqYjYiaoL57qJWaGt/g6gKauyKE0sRdS3/meZAXc2vnp
	 BTTDl4SVa9rXs9i10vSsDhZOmpD5o/0SPGM3zZRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/272] vfio/pci: Remove negative check on unsigned vector
Date: Mon,  1 Apr 2024 17:44:53 +0200
Message-ID: <20240401152533.857237213@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 6578ed85c7d63693669bfede01e0237d0e24211a ]

User space provides the vector as an unsigned int that is checked
early for validity (vfio_set_irqs_validate_and_prepare()).

A later negative check of the provided vector is not necessary.

Remove the negative check and ensure the type used
for the vector is consistent as an unsigned int.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/28521e1b0b091849952b0ecb8c118729fc8cdc4f.1683740667.git.reinette.chatre@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: fe9a7082684e ("vfio/pci: Disable auto-enable of exclusive INTx IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6a9c6a143cc3a..258de57ef9564 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -317,14 +317,14 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 }
 
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
-				      int vector, int fd, bool msix)
+				      unsigned int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct eventfd_ctx *trigger;
 	int irq, ret;
 	u16 cmd;
 
-	if (vector < 0 || vector >= vdev->num_ctx)
+	if (vector >= vdev->num_ctx)
 		return -EINVAL;
 
 	irq = pci_irq_vector(pdev, vector);
@@ -399,7 +399,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 			      unsigned count, int32_t *fds, bool msix)
 {
-	int i, j, ret = 0;
+	unsigned int i, j;
+	int ret = 0;
 
 	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
 		return -EINVAL;
@@ -410,8 +411,8 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	}
 
 	if (ret) {
-		for (--j; j >= (int)start; j--)
-			vfio_msi_set_vector_signal(vdev, j, -1, msix);
+		for (i = start; i < j; i++)
+			vfio_msi_set_vector_signal(vdev, i, -1, msix);
 	}
 
 	return ret;
@@ -420,7 +421,7 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	int i;
+	unsigned int i;
 	u16 cmd;
 
 	for (i = 0; i < vdev->num_ctx; i++) {
@@ -542,7 +543,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
-	int i;
+	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-- 
2.43.0



