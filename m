Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039454;
	b=wFboTuutmuiSMKJW/KEwMaMFVuK/iUWHcDtS1eav2pbbBWOgPAjzwmAIxqZn8rKa5pGL
	 hpkBnu2z0RGxvI3AMMjIYLHsfGmKpAulL87j/udvDwnx5+bJyK1gYBNciIgcJhQYryz9G
	 CCpLJtThIn7qQXS8qnAp68gTn0kXu6lJQBQ/d42CjiAOJj1iLMy8UPLWq1KVoezyfCYmw
	 JGfM2BzJzi5UY70JGC8MFhXTZ3K53a11uk8JDsUyqBgt1FJvraLS3m6a2NkTyesStDXo9
	 3E0ZHDZxzX2/K5oHbgX+VAmUitgpMbPn3j3uco97wUcfLx1tU2yNf5164JQeY5YOTDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nugi18hl76pxZFJQhzaanJdLZNfjLyMWdV2ybxxsESY=;
	b=PWnDTDvNUELJUsGC6lw6iZ1HCby0BF4VQBBBs/HlKkR6yXyoR/RR/y8OxbElUkbR61Jq
	 i4+FVofJ1oUZ9pNe54yPmlobUl/ssfAywAO4wOnCBvZWNo3GBsOZaVunTmjoum3Q3F2og
	 8iinLxV4TvRu+opFwzQG61+phwAg6QiSIC5bg1f9MEh0dbPY+mlA+1EiAATkM1oZNjj2c
	 x/vQObONm1M4PHAx85GTMW7KLwc9l46ESQSAgj8J43KBAduui4lNXer+JEbfo4T7aoJYa
	 u/s4fx2rd+xMRqJm7ukqnHNkS8z/zlxKYNfchSTbA4oI26fliPzr8Rj700Qhq4yMLiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhVO1OZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44064606A331;
	Wed, 18 Nov 2026 22:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhVO1OZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129A1F000C5;
	Wed, 18 Nov 2026 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039453;
	bh=Nugi18hl76pxZFJQhzaanJdLZNfjLyMWdV2ybxxsESY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhVO1OZ59HAnxXKE2okxDOZgSYJqss1ZR15VmwtqKEZ+kR5D497KXt1bxPtPVMgIk
	 WYDpaBHfW9uf6eb/HONYwxN3fBG0oZlTgmxLkPFtM/u5I9enLQsQr0duK8GgJtCcee
	 S6YVLCCKspTtn4i3znVxRtxszFXfyCbY6l2XW4RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2107/3318] wifi: ath12k: Free allocated CE IRQs on request_irq() failure
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118150425.286700988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8db438988ae22..c515bc1421384 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -329,6 +329,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
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
@@ -345,15 +358,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 
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
 
@@ -614,6 +619,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 		if (ret) {
 			ath12k_err(ab, "failed to request irq %d: %d\n",
 				   irq_idx, ret);
+
+			ath12k_pci_free_ce_irq(ab, i);
 			return ret;
 		}
 
@@ -624,8 +631,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
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



