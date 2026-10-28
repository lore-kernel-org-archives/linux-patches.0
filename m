Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214290;
	b=wuVmFhKVNs4PNnks5WYSU0/xUmfNLB5kRn37fkIhmj7M3QdIr3b1EkIZIoz1SegJ7xgg
	 73nwkrTWmF9wacettQewZ8t1b9hrE2hKSPRHqGF0UYMtTofIunGIfKQnGrIN6iqbbBnNR
	 dNCwuemKZAUdkO+bTtl76a2Tww27q2UU8BJvwxarupizPy3WjGb5QKHg7dB9si6cPpo8d
	 QbsLWLd8jDnFR/GEeR2q03s5RRt3fEDXAqjKo89TbWLggwYwl6Rp2jlTUMBaxUYxLsLcy
	 XYgjLrjXTCSHA/QJ/Ip7fHSR+n0LRkObq0fozd8h09wRXGzr1ch+33adn4EPhbPryUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMRp0nB2ZG8qhgjyFavnbSaztIJ9fj8zgv2ci7Jedv0=;
	b=bNcrzbtBgHpzTdlpQPO9mRUGGsH5hmDA7egzgRvUaEw4BqykiqMTqHxSW8h6lCroMxrY
	 Af8yy3dMK4bt45YVpAsR2AC2TvxR4xN/3x4DFFGE9fGElgMebygTn1tpxxw2ivjAeei6c
	 LsdayvOTNdtQjKwTS6kNuPt5oMFoJ5CaSF+KRRIe+izQYwbUMbxgAdi8so0q82c0m8jHB
	 gtyW5zcyB+/q4w4tivYAiLRgY/wqalRupuynAAGXS3rZWzOXE0mwjWM2pldL3rbPqth2r
	 6nhsIEQGKonqRTd3KX5YD49t9P8J3d2En0NZaCwJZw7SR5Sgwe3Esb+M54uQSRZOfGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3fPEswk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2E606A334;
	Wed, 28 Oct 2026 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3fPEswk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1EB1F01825;
	Wed, 28 Oct 2026 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214289;
	bh=KMRp0nB2ZG8qhgjyFavnbSaztIJ9fj8zgv2ci7Jedv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3fPEswkZ7khaPW3C9oIkm2ckjXILPc454+6Yn8ViKngS1CTNwZIT7XsbO9TZABy9
	 go/Pcaw5C05OPui0dXGkxSqYACVc3YwEVETKAa5uE8zY7tTkkoR578JIPmxn9peaZn
	 wg3m1u9pJLvZxEmpF2miDWrG9iKM4Ds2CTh+c+1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0804/1887] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Wed, 28 Oct 2026 17:48:20 +0100
Message-ID: <20261028170517.726155833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 2777a40998deb36f96b6afc48bd397cf58a4edf0 ]

If the VF device driver is not loaded in the Guest OS and we attempt to
perform device data migration, the address of the migrated data will
be NULL.
The live migration recovery operation on the destination side will
access a null address value, which will cause access errors.

Therefore, live migration of VMs without added VF device drivers
does not require device data migration.
In addition, when the queue address data obtained by the destination
is empty, device queue recovery processing will not be performed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20250510081155.55840-6-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index e682c14614998..77ddf681b9dc2 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 	}
 
-	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
-	if (ret) {
-		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return ret;
-	}
-
-	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 	return 0;
 }
 
@@ -497,6 +490,20 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	if (migf->total_length < sizeof(struct acc_vf_data))
 		return -EINVAL;
 
+	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
+	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
+		dev_info(dev, "resume dma addr is NULL!\n");
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		return 0;
+	}
+
+	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_STATE\n");
+		return -EINVAL;
+	}
+	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+
 	qm->eqe_dma = vf_data->eqe_dma;
 	qm->aeqe_dma = vf_data->aeqe_dma;
 	qm->sqc_dma = vf_data->sqc_dma;
@@ -1269,6 +1276,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 
 	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
-- 
2.53.0



