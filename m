Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015848;
	b=zxKk9d3wQ7u3hVS66JKzjxDwYPQ1AGiouwIajoxFmo+a+HnL1zCp+Ha2MMz6FiU/S5yY
	 CZ4dnIFeOP591N62Ty4kal6uD7+fTUaFYUTDwuKnp8pGNZWATMeHrKBfGoYDagqg0Ztic
	 INImo3ioXAEHMSn4LQe9S+GO1H/GqoK4BnWgl5Gxh0M4QnUJldrVxLPmwR0TaTiIluxgj
	 7vHDEUG3ZlibAguNxI6bwxsrMbz6VsU5DR+xZCkVLqqo6pgBrMvRSGgP+m1xBHbwxfjYn
	 2h4DzFfMx9lOsXVVmiM02BtAmgNWO62E9pvpEEp3AFCUmr8mIc2jTh2KgFo+fyMCCvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nz7Wlf/X4Gv3CDyNR/tkJ80zv3Zh296z2B7qNPP+ILE=;
	b=EWrzMbg7j5ijtoC30inQBO9z6An5E4+Ac2U07iZl2ndOvQa/3TLV6DGIhajYVVFWU1gW
	 clCP4hM+xLqeTicGNlKRJW48kiyvOdAabiDwhik24Ix6mcCgq30h1UhAKYuq0CQ4j8L2f
	 6jpgC0WulEpzQmAjVIB0YgaOgwwAEE+8ivA7s1F9EIB4Yxvo/zo1XCkHU68ETyM45VWLJ
	 rhrStVlYqajyatLgJoLSa6dOygNkve+AxMsc5cM4aXOdqH55EXxrUMA1bR4Alf+CtMa/d
	 nmdWbJC/0iMUefnVz4+g8lioLppMdwa1/Jnh7y1sKocOK2eqJb4wtdnBGJMixI0TgRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjWfDsFq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D740606A31C;
	Wed, 18 Nov 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjWfDsFq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF811F000C4;
	Wed, 18 Nov 2026 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015848;
	bh=Nz7Wlf/X4Gv3CDyNR/tkJ80zv3Zh296z2B7qNPP+ILE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjWfDsFqEcHQDczSGblxySt1VUbLQQsemC/3HLgJzTYJUVsz3leL8yI53TDqU+wrH
	 lgYFQPe4T/XkWZcxiNsqFu9c8qAp+j+wsM2Jwclg1hCfTkU2ggGxxMO06B+sfATtr2
	 NzIknDfxEUQ/PvuiynnbKUZal4ryMxWuhZkdnaNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0319/2651] wifi: ath12k: Free allocated CE IRQs on request_irq() failure
Date: Wed, 18 Nov 2026 15:25:59 +0100
Message-ID: <20261118150259.359412282@linuxfoundation.org>
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

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 12ca935af2e68447e9218a615ebbb5ff7faf1554 ]

When CE IRQ configuration fails, the driver does not release all IRQs
that were successfully requested before the failure. This can leak IRQ
resources during probe failure.

Free the previously requested CE IRQs before returning from the error
path to ensure that partially initialized IRQ resources are properly
cleaned up during probe failure.

Factor out the CE IRQ cleanup into a helper to reuse the cleanup logic
during both error handling and driver teardown.

Also free CE IRQs when external IRQ configuration fails, before
returning from the error path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260819110215.2485514-2-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 29 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 8978edb44ceca..4270f5d6ce4e7 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -313,6 +313,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
 	ath12k_mhi_set_mhictrl_reset(ab);
 }
 
+static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
+{
+	int i, irq_idx;
+
+	for (i = 0; i < num_ce; i++) {
+		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
+			continue;
+
+		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
+		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
+	}
+}
+
 static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 {
 	int i, j;
@@ -330,15 +343,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 
 static void ath12k_pci_free_irq(struct ath12k_base *ab)
 {
-	int i, irq_idx;
-
-	for (i = 0; i < ab->hw_params->ce_count; i++) {
-		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
-			continue;
-		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
-		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
-	}
-
+	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
 	ath12k_pci_free_ext_irq(ab);
 }
 
@@ -671,6 +676,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 		if (ret) {
 			ath12k_err(ab, "failed to request irq %d: %d\n",
 				   irq_idx, ret);
+
+			ath12k_pci_free_ce_irq(ab, i);
 			return ret;
 		}
 
@@ -681,8 +688,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 	}
 
 	ret = ath12k_pci_ext_irq_config(ab);
-	if (ret)
+	if (ret) {
+		ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



