Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029266;
	b=4SS8QCA1utrxY/nfGAzszdUAhxiBI4Zk29Yap/eo4YSbiKiw7jKk9IDbtmLUEoeSsCs8
	 rMln4aOLMHJik0i87UkTIlQ+iWiljL5Xw+tmxPcWkAjBbtFQSdzKvshJRENw+PcmCuZmh
	 hIXMGIaUSpLxVEiOCbV11Z2GPsGV3+Vj9UJIYbQaYT8qe6Hyk2Z1fiWcdbNnHH9hE97Y6
	 Y5keDCco24ZNz0OnLCLBd+0fqEubaxoOpVOnY0iM/+quVW8zXCiKKfc5DZbxlhC79ZeYE
	 AU1V50/6TjivSvlIvJguCBeu6Eo8t5UWrtYU2xOC7mzeGaWDxt6lK1cYGXQf0tc0Atg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxVbDiWUQHfCDWCgLsc3Uza+iOkt7RW97ZUBrX4Ulzo=;
	b=sXwKjBCPLbSwIuxTS8BZcqQroCjimDXz7zm2in6xs34ylCG9nMMOmfh8looleTIgjh+v
	 2AmRKjK0Oc19DkOAtDeoaLZ3UmyTD+HWtW+3CMQXw5LhGhbzzgiAN5Q/SyDIdcL3GkL6n
	 a+LmerwBITV2YZs3J5cXdznd/uDKehDpukU/9TE++gXFMFPQMCC8TL//adBJF9bIfVD0b
	 rIhUDyw7AkH8/OKYxF9VNc0SQQDwmBQkwcmJxNLk0XJO8mC1KPNfEm/z6lG5VCsfp1OMZ
	 IatHgE6s8xex9nnQX+o1dp0c1bhGbt3xLk1evh1kf8Ym7A1wykzVbs4b2LXXVTJdxhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5S07eU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0BE606A31C;
	Wed, 18 Nov 2026 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5S07eU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CABB1F000C4;
	Wed, 18 Nov 2026 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029266;
	bh=SxVbDiWUQHfCDWCgLsc3Uza+iOkt7RW97ZUBrX4Ulzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5S07eU4op7DmtAoQduvNTP5Vg41aabJ03eM3fOyjtB4VgaP4YAkR1bSTII+8XDdS
	 zzbMmyMZ4HALGJK9UoTQBpLx8h2bx9bsmFiWSdWVpOSfp2jrCMxkSnUGju9RA4VDb3
	 3095nIGZlarCTeWHvaeH3G35ORCMjF3MBRm4RQtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0289/1756] wifi: ath12k: Free allocated external IRQs on request_irq() failure
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118150019.894291267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 9a78703ec4a895bd2e99bf43bd18d76683126c19 ]

When external IRQ configuration fails, the driver does not release all
IRQs that were successfully requested before the failure. This can leak
IRQ resources during probe failure.

Free previously requested external IRQs when external IRQ configuration
fails.

Also remove the NAPI instance with netif_napi_del() before freeing the
associated netdev to properly clean up the NAPI resources.

Store the IRQ number only after request_irq() succeeds to avoid recording
an IRQ that was not successfully requested.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260819110215.2485514-3-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 2017b54dc9f92..3ccd15accf87e 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -356,11 +356,11 @@ static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
 	}
 }
 
-static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
+static void ath12k_pci_free_ext_irq(struct ath12k_base *ab, int num_ext_irq_grp)
 {
 	int i, j;
 
-	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
+	for (i = 0; i < num_ext_irq_grp; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
 		for (j = 0; j < irq_grp->num_irq; j++)
@@ -374,7 +374,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 static void ath12k_pci_free_irq(struct ath12k_base *ab)
 {
 	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
-	ath12k_pci_free_ext_irq(ab);
+	ath12k_pci_free_ext_irq(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 }
 
 static void ath12k_pci_ce_irq_enable(struct ath12k_base *ab, u16 ce_id)
@@ -619,8 +619,6 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 			int vector = (i % num_vectors) + base_vector;
 			int irq = ath12k_pci_get_msi_irq(ab->dev, vector);
 
-			ab->irq_num[irq_idx] = irq;
-
 			ath12k_dbg(ab, ATH12K_DBG_PCI,
 				   "irq:%d group:%d\n", irq, i);
 
@@ -631,22 +629,24 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 			if (ret) {
 				ath12k_err(ab, "failed request irq %d: %d\n",
 					   vector, ret);
-				goto fail_request;
+
+				for (n = 0; n < j; n++)
+					free_irq(ab->irq_num[irq_grp->irqs[n]], irq_grp);
+
+				netif_napi_del(&ab->ext_irq_grp[i].napi);
+				free_netdev(ab->ext_irq_grp[i].napi_ndev);
+				goto fail_allocate;
 			}
+
+			ab->irq_num[irq_idx] = irq;
 		}
 		ath12k_pci_ext_grp_disable(irq_grp);
 	}
 
 	return 0;
 
-fail_request:
-	/* i ->napi_ndev was properly allocated. Free it also */
-	i += 1;
 fail_allocate:
-	for (n = 0; n < i; n++) {
-		irq_grp = &ab->ext_irq_grp[n];
-		free_netdev(irq_grp->napi_ndev);
-	}
+	ath12k_pci_free_ext_irq(ab, i);
 	return ret;
 }
 
-- 
2.53.0



