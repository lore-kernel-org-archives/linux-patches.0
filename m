Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029263;
	b=OijYb8FCT42i+kQDqtklTvFmOrK5Z6jIPn3HirXhbU4K4WJa/K2Sb/48MDoMIUr7llrU
	 m3UZjMzGgOsW5YLH7Oxl3KeG+H8o5nyc0kIO17sC47PNLX4zaK8oMoCHbMG7qTDNvLRU1
	 xCdl8RYR37x/l/Tff0HOudBhzsIMSGM3Lrmvcj9tyz2r3zgP/91i5TzKj7M+XsGwIqROn
	 C5gTeiwKl83fGsO9JOoDQqmbyIK4bWj7Nzu8rO7qddSy0Ct/TaNDouwhI9DaMp8QmaptH
	 7eKhYjV63QoJitwLNerQ7UejqPuKOqWNRMEGp/c6lgSwTpLqRMxsVQ0mtaSqaw64rqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y17RfUGiinTCDVi+xm9sBSIcVWhGwJm+fRbGl6zwzVk=;
	b=Yyb7rP0R6vPLDW0Q4xsxjnpfM2b3k/4Xfe8/gVxWjQLUWu0xn2viHvsqqi7XVKJn0HcR
	 jz/n9fmbjmBN3uZNryHKh1MyZqlLDA7cAMNaUz6D0foSabA47nmC08w5Wr7zKIIti9i0b
	 3PQYlHBvXppFE9ohxyld8howaGroXep7J+tOabBX6ea6Qq0NP8E6JAz9egxHaQ6fgGDlK
	 3cIZuFGNNESbu7LUBM9Qd7prU9SSDpb63ugskZLfRUxLgqdPSyrfBzluBZfvkZL7qBdTB
	 Qa9Kkt3oAoMSgVa+BzNCUCgJPkstcp2TYk/ENfbU4p12hVu5YMcEhRQzmNnvwLPIvCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qD6OcgL0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36031606A325;
	Wed, 18 Nov 2026 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qD6OcgL0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846571F000C4;
	Wed, 18 Nov 2026 19:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029263;
	bh=y17RfUGiinTCDVi+xm9sBSIcVWhGwJm+fRbGl6zwzVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qD6OcgL04M/KtmgDV8qvwN5YCQ/yghUS1+YeYZsOoCe9/ZdhxXeSgTDEPrSgF6bpe
	 zlxfVzx2hP6lb7LLIfKh66MNGXpjvKKQBF/UwUbCAaoM17qUyQx68Bfwqs2XpEWZ3M
	 ekbEJTgm7iDcdmMZ2VmoI+eDCeZUWvBSfYE6fuW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0288/1756] wifi: ath12k: Free allocated CE IRQs on request_irq() failure
Date: Wed, 18 Nov 2026 15:40:15 +0100
Message-ID: <20261118150019.855621232@linuxfoundation.org>
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
index 4ba0c1bb32341..2017b54dc9f92 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -343,6 +343,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
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
@@ -360,15 +373,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 
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
 
@@ -690,6 +695,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 		if (ret) {
 			ath12k_err(ab, "failed to request irq %d: %d\n",
 				   irq_idx, ret);
+
+			ath12k_pci_free_ce_irq(ab, i);
 			return ret;
 		}
 
@@ -700,8 +707,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
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



