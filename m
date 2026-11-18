Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019934;
	b=V4HHXQpzyDKhA366dadDHxhR7Pf/q7USaaK6nRSFkzUZFhLd+8BltyQx7uXMmYZNZPRn
	 ZHXutTmTF4btAj0dAKBxS8BrY467Jmp6Nlzp398nUE/BWlHHNb/zMqf1gnIhkd08uGG9m
	 qVV/Tn6P7WuhVHGooXiA0KRqzgOkW7E+4h3NShamkv23GRPMVmVy1U2RMVtmLHjebeXOd
	 sKSywQcJuCoNQjCkfzFCO0IHS+nWk6OhycbqTv3cWno0ie8ckR0on2Ih/2+m7UmazLVC9
	 yyfCYideJ+tlKFxcSuqbjYuhKOFbzVZGwfIn4LTAzJoISP4LD57GoUMf6cd07ApYCyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95WAVaZVzKEgPGT1NYYSNLbqEYWfZdYEVXeGpOguh08=;
	b=tUKfS1TotZpk5+rckgPqVYRtr+8RwuXtxlA+QhZXJcLlZgYqkO0OmmenKL12yoxEb/76
	 GT/9lE6oN6Xiwtw8mAYuMolj05aWS2WFIo0fwDsl/Lh2IbrO28D8RLvkOzobRG41X+wYp
	 IbPTcbFWajfsQsJh3Jmq/g5QU7LF7Dm8fPz5HTvvgmSpO7BIuuQ5XNXqtm8gvFMGDafkx
	 aMV75I7o+zyiBvu0ep6H+6jHlxB59V9pZlzKHkkYEVK+PAHP5o2h3vgVBIFtyULnxWfhA
	 nWYW0eF+LzdZALmqsyNeW3JMHc2TbczGU1nH1Mf9fwEE/qbXju93t8nkGRRXGE06BAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bluiri0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61370606A31C;
	Wed, 18 Nov 2026 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bluiri0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B229F1F000C4;
	Wed, 18 Nov 2026 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019934;
	bh=95WAVaZVzKEgPGT1NYYSNLbqEYWfZdYEVXeGpOguh08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bluiri0b1zqp7b9kY5tSIkihBG8ttd0txtjKoerAI9o/6SqwQgqKn7U6+9DQu/CJF
	 hrpiNho8jLmb8S7wsFaIRHihuYiGzfVIIeTF64FxtHBlvj2do71rUSY1ttkfSzR+GR
	 8zXopRWo8kRZMt5t3Db707iSpxjMVd6vWvOkDNJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1772/2651] hisi_acc_vfio_pci: reject live migration on 64KB page with QM_HW_V3 hardware
Date: Wed, 18 Nov 2026 15:50:12 +0100
Message-ID: <20261118150351.198363204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit a80597900b8a0f1a9e87360164695f6a0a10556c ]

On QM_HW_V3 (VF_CTRL mode) hardware with 64KB pages, the functional
region and migration registers share one BAR2 physical page with no
isolation, which leaks migration registers to the guest and causes
guest kernel calltrace under the KVM emulated device scheme.

The previous fix rejected the device in hisi_acc_vf_qm_init() during
open_device, returning -EINVAL and breaking passthrough entirely.
Move the drv_mode check into a helper called from probe() so that a
VF_CTRL device on a 64KB page is bound to the generic ops, keeping
passthrough working while disabling live migration.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20261013071929.3988687-3-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 32 ++++++++++++-------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2bdd625b0bcee..c82c59246a3f7 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1195,13 +1195,6 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
 	struct pci_dev *vf_dev = vdev->pdev;
-	u32 val;
-
-	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
-	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
-		hisi_acc_vdev->drv_mode = HW_ACC_MIG_PF_CTRL;
-	else
-		hisi_acc_vdev->drv_mode = HW_ACC_MIG_VF_CTRL;
 
 	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_PF_CTRL) {
 		/*
@@ -1665,21 +1658,34 @@ static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vd
 	hisi_acc_vdev->debug_migf = NULL;
 }
 
+static enum hw_drv_mode hisi_acc_vf_get_drv_mode(struct hisi_qm *pf_qm)
+{
+	u32 val;
+
+	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
+	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
+		return HW_ACC_MIG_PF_CTRL;
+
+	return HW_ACC_MIG_VF_CTRL;
+}
+
 static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev;
 	const struct vfio_device_ops *ops = &hisi_acc_vfio_pci_ops;
+	enum hw_drv_mode drv_mode = HW_ACC_MIG_VF_CTRL;
+	resource_size_t func_len;
 	struct hisi_qm *pf_qm;
-	int vf_id;
 	int ret;
 
 	pf_qm = hisi_acc_get_pf_qm(pdev);
 	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
-		vf_id = pci_iov_vf_id(pdev);
-		if (vf_id >= 0)
-			ops = &hisi_acc_vfio_pci_migrn_ops;
+		func_len = pci_resource_len(pdev, VFIO_PCI_BAR2_REGION_INDEX) >> 1;
+		drv_mode = hisi_acc_vf_get_drv_mode(pf_qm);
+		if (drv_mode == HW_ACC_MIG_VF_CTRL && func_len < PAGE_SIZE)
+			pci_warn(pdev, "migration not supported on 64KB pages with QM_HW_V3\n");
 		else
-			pci_warn(pdev, "migration support failed, continue with generic interface\n");
+			ops = &hisi_acc_vfio_pci_migrn_ops;
 	}
 
 	hisi_acc_vdev = vfio_alloc_device(hisi_acc_vf_core_device,
@@ -1687,6 +1693,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	if (IS_ERR(hisi_acc_vdev))
 		return PTR_ERR(hisi_acc_vdev);
 
+	hisi_acc_vdev->drv_mode = drv_mode;
+
 	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
-- 
2.53.0



