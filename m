Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214570;
	b=ONSXubkFUn8V+4hziqYF0E2zH4us1k2KZCRuFxQCHZFnBMsSsrT5qBK8RGuNc5Cd7N79
	 T/Mvx49tEvEuQT/PEjG2zBU5i0YrWa2rOFpAtDdJtIqRpwnSMTFSW5zo3OXthDpdqI9FE
	 G3oikuSN8IsirkhQfFPQZYs5oHFIvSc5g5/oXEx0hSWpotH7Ox9RV4nbVCWIlh/WDUIJ8
	 UdquGjwFo8O+k5KMSgsXTP4pSGuQ5Mfahv6GknCH/fZYj0mb4CPKp3S9lTH2X7lKghB6M
	 bTxesUuNgJ+wjRQrnaOepWx0SWN/KD/dw4HlmHdOLi57KlPDFJmnthf081EltaJUrGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PhNjCnkdleylAicWaU8EH/Le9LfquzrGTgErftCmJs=;
	b=rT/BJtBwc5wlrcStAgEm0cpKk+Xxfob96g4MV1tc06/GZVP4bcGgArlivWb6USlNmDDD
	 RK0+otooecBf8UjQgX/LoKF+uP9mCuem55aOerrwOU7jWQpdzkiHuPCc7UNRi68tMri23
	 uJOEA+6cInuSST+bc+KCtlM4MHmrH4roa287SCbiP/b+927ZvLziV9xb2KF4GIYL9wBDD
	 tgCEn6EYpquUcMf+0Ekrwr0Ygg7EO6Xd+ZAmYEK6mMvY7DR02KxQakBCBq6uY3E0EfVMO
	 WmEbhBXEMsZu4gefXxXa5hTCEkL63ikzA1SlMpjf3g6UmyUwwiyejArqAXm3BM/sEfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj4X8vWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C5D606A31C;
	Wed, 28 Oct 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj4X8vWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0381F01828;
	Wed, 28 Oct 2026 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214569;
	bh=4PhNjCnkdleylAicWaU8EH/Le9LfquzrGTgErftCmJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nj4X8vWU3eRXdUy21r63izFHbnTL6gVQcYjl+aSSWjq1r3thdG7bMbICh669LQ6P7
	 20GsaqIofi4HtFLo9pCveaC2/+C1oIMBNf6i9no35YkqesMBYQ8Rebn+fHx+pQthlz
	 Hy1M+VK7CcYkgT2CZCHQ0urMa9ZxAPh5SqqS6E3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0862/1887] crypto: hisilicon/qm - request reserved interrupt for virtual function
Date: Wed, 28 Oct 2026 17:49:18 +0100
Message-ID: <20261028170519.035778996@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 9228facb308157ac0bdd264b873187896f7a9c7a ]

The device interrupt vector 3 is an error interrupt for
physical function and a reserved interrupt for virtual function.
However, the driver has not registered the reserved interrupt for
virtual function. When allocating interrupts, the number of interrupts
is allocated based on powers of two, which includes this interrupt.
When the system enables GICv4 and the virtual function passthrough
to the virtual machine, releasing the interrupt in the driver
triggers a warning.

The WARNING report is:
WARNING: CPU: 62 PID: 14889 at arch/arm64/kvm/vgic/vgic-its.c:852 its_free_ite+0x94/0xb4

Therefore, register a reserved interrupt for VF and set the
IRQF_NO_AUTOEN flag to avoid that warning.

Fixes: 3536cc55cada ("crypto: hisilicon/qm - support get device irq information from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 38 +++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9ebd7b3d97be7..216d8ea775e9d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4557,6 +4557,15 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_done);
 
+static irqreturn_t qm_rsvd_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = data;
+
+	dev_info(&qm->pdev->dev, "Reserved interrupt, ignore!\n");
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t qm_abnormal_irq(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
@@ -4856,7 +4865,7 @@ static void qm_unregister_abnormal_irq(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	u32 irq_vector, val;
 
-	if (qm->fun_type == QM_HW_VF)
+	if (qm->fun_type == QM_HW_VF && qm->ver < QM_HW_V3)
 		return;
 
 	val = qm->cap_tables.qm_cap_table[QM_ABN_IRQ_TYPE_CAP_IDX].cap_val;
@@ -4873,17 +4882,28 @@ static int qm_register_abnormal_irq(struct hisi_qm *qm)
 	u32 irq_vector, val;
 	int ret;
 
-	if (qm->fun_type == QM_HW_VF)
-		return 0;
-
 	val = qm->cap_tables.qm_cap_table[QM_ABN_IRQ_TYPE_CAP_IDX].cap_val;
 	if (!((val >> QM_IRQ_TYPE_SHIFT) & QM_ABN_IRQ_TYPE_MASK))
 		return 0;
-
 	irq_vector = val & QM_IRQ_VECTOR_MASK;
+
+	/* For VF, this is a reserved interrupt in V3 version. */
+	if (qm->fun_type == QM_HW_VF) {
+		if (qm->ver < QM_HW_V3)
+			return 0;
+
+		ret = request_irq(pci_irq_vector(pdev, irq_vector), qm_rsvd_irq,
+				  IRQF_NO_AUTOEN, qm->dev_name, qm);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to request reserved irq, ret = %d!\n", ret);
+			return ret;
+		}
+		return 0;
+	}
+
 	ret = request_irq(pci_irq_vector(pdev, irq_vector), qm_abnormal_irq, 0, qm->dev_name, qm);
 	if (ret)
-		dev_err(&qm->pdev->dev, "failed to request abnormal irq, ret = %d", ret);
+		dev_err(&qm->pdev->dev, "failed to request abnormal irq, ret = %d!\n", ret);
 
 	return ret;
 }
@@ -5222,6 +5242,12 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 	pci_set_master(pdev);
 
 	num_vec = qm_get_irq_num(qm);
+	if (!num_vec) {
+		dev_err(dev, "Device irq num is zero!\n");
+		ret = -EINVAL;
+		goto err_get_pci_res;
+	}
+	num_vec = roundup_pow_of_two(num_vec);
 	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
 	if (ret < 0) {
 		dev_err(dev, "Failed to enable MSI vectors!\n");
-- 
2.53.0



