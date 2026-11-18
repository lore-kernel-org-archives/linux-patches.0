Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046391;
	b=o4/C6IyikAdwk9hB3eqwE3Kwhjxj6qhwfAAPxMBbnf8bgpXqDmEfCAiFeAReUHMTlwUr
	 jFwQo7hoI//ReUe/Dvpb28CU1gCycU1Uycj3WL2lL3NvW7G/ZvwVChfnfwWh74ebb8fTh
	 h49FSRDi4DWpiDMhvNhSETL4Uz0nLJk7cXV5bsITnbYv9VlkBP/A1CHWQTHNCFYJN5hsh
	 +4aTEFZ59EL5fq6xZPXdJrEQBbRcqwP83+vEt4UwW7teHoRmG1L3aZ1NrB2oZIrp6/V6m
	 RaT90FPoXUKMFm0YzW1nmGwU/xMH82cEqR9Fb26Mj8lSNF/I8Stf4IRd5hjMXFj+AOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pz2bOm/vtHbENwrvzS1Y0CupTvaxyAoUWHxh1pCJ9OM=;
	b=pXUPtuzqE581bKHDu7GGkfW4zCCyOfyg4KnlgMc10fBx6NLzmxALSRmiDQcc2Nm72dg7
	 hI8Ec+Yp+zqtRz/Uh2uqE+Oa+2i21AtD9ph8WxUY8YPdjTrrICuTfK7sNj/gH8+OfiBwA
	 uFxFTkNI25p2VQ4kYmCNn7jxDU51hDX7P3acn/dO9wuJK5Gbl2jKJrPXLINz4hGwbFQIu
	 slV5yy6ICrgtuWzr/QBz2wWe9G/tnp23Toa6I5P/Og1h+3N3CfmFCAHQscxbbtCrt6c3e
	 Fjzk1c9/kRdeC+5OvmPK9nnRSFAD2qEH+kBwVb+IwGf3rE2i50QYh3+V9PXHQPJZg+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC4gWLCP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3F606A32A;
	Wed, 18 Nov 2026 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC4gWLCP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE31F000C4;
	Wed, 18 Nov 2026 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046391;
	bh=Pz2bOm/vtHbENwrvzS1Y0CupTvaxyAoUWHxh1pCJ9OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC4gWLCPzrsnfk+RVOm4/hNqCGhW5Ek2Gtg6LuTqxVOuAk/lNMtTF3wMvZexBUd0H
	 Hiics13KefNJ5Ig1oTl3aMB0G+/WGep2GKVcb8s6QMAtgXJ8k+/Ppwd1WcYHLIPc58
	 H7yEVjan+pxzyyq3mGjNwmRRRIOu7B61dpIR1Qqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1265/2857] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Wed, 18 Nov 2026 15:38:19 +0100
Message-ID: <20261118150247.076096653@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 1f8efac19a0870cdfdf8477e447e5a07ddce9623 ]

viommu_probe() marks the device DRIVER_OK before populating the event
virtqueue and registering the IOMMU device in sysfs.  viommu_fill_evtq()
hands the device a set of device-writable buffers through
virtqueue_add_inbuf(), so from that point on the device may write into
them and into the rings.

If either step fails, the error path deletes the virtqueues without
resetting the device first.  The event buffers are allocated with
devm_kmalloc_array() and are released as probe unwinds, so the device can
go on writing to memory that has been freed.

Reset the device before deleting the virtqueues, the way viommu_remove()
already does.

Fixes: edcd69ab9a32 ("iommu: Add virtio-iommu driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261004182218.177343-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index fd86ccb709ec5..e6644c4465e29 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1174,12 +1174,12 @@ static int viommu_probe(struct virtio_device *vdev)
 	/* Populate the event queue with buffers */
 	ret = viommu_fill_evtq(viommu);
 	if (ret)
-		goto err_free_vqs;
+		goto err_reset_vdev;
 
 	ret = iommu_device_sysfs_add(&viommu->iommu, dev, NULL, "%s",
 				     virtio_bus_name(vdev));
 	if (ret)
-		goto err_free_vqs;
+		goto err_reset_vdev;
 
 	iommu_device_register(&viommu->iommu, &viommu_ops, parent_dev);
 
@@ -1191,6 +1191,8 @@ static int viommu_probe(struct virtio_device *vdev)
 
 	return 0;
 
+err_reset_vdev:
+	virtio_reset_device(vdev);
 err_free_vqs:
 	vdev->config->del_vqs(vdev);
 
-- 
2.53.0



