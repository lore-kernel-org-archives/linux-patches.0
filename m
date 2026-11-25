Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622610;
	b=w3k4v1t/IhbW3kLvlET0+0hyeMxRPjTBsHMoVBxZ4LYyhvz7ZKSQfKUDy3f4BOATNm2W
	 mZWragv8UH2DbYsXo7PZtqgadIUI2CzBRN9FRScSFGOi8Hxmthf66EWnacNd8m4ckkgCt
	 BLXOJxL8Lx1Cks9wboeCYRXW4Tw7x+qERNa0KJab8Oo4uUloNs0wGYzbfNFlQHPZGBU/x
	 kTT8+yNwbkuGHVUEAQtXgmP/TpeTJqyypwvowc3+rRQ7a8jOPcCeZuNDydpdUPl3WuonL
	 Z2384WWVFpFJ7qYphHdDeJDUxlZNraswANN6LDENQ/Br+4BTSqhBVee3fzKOWhKLv3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wd1Pkgas0ie9zb9XQMAEBOxOEeFG4HgBYNOMNueZRBM=;
	b=FpagrXm+Y8mlAk7Ovhjreotf5J1zKpyFWFViZkf/jKU/fUEfqMu6WFFleFGehgKsJX0u
	 oKs4Jnnficr4PKis2Dl/mu+AJE0leNgTxPV2lDiiRbz+0OVi+hruIqbAPEXmZRxUEo/Es
	 akgeOireaaprnOfPpDmTJCOef4fdirhUNGY5tC0Qs2OtpJKMbjNWIMzF7UjTn/Qx3LTXh
	 oaqZJtfTFYk2/sTkjW8cYWuT+0RELTpFnFQm0QHrZcq3/y1qpa3bQzxQGFRxbP5N/NsSj
	 6upaSwW2I8zBDpdhI16URDi74svv/GHeGrMXV+l16lQqHFOv8kv3emeuqu6ruMJZx+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbOdNjCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0E606A323;
	Wed, 25 Nov 2026 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbOdNjCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511821F000C4;
	Wed, 25 Nov 2026 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622609;
	bh=wd1Pkgas0ie9zb9XQMAEBOxOEeFG4HgBYNOMNueZRBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbOdNjCGAvsOSA1aSmPE7Fd33+H/G2T32q9x6AbL15egy0kb8C6Yl2ZmKlN2OZ/9d
	 y6V2eHUAP65+/SX9ULMeaDMe9eecilw2O6JU+iSV8/a4+bCAbHBBbuQY4lG6jxv6zn
	 WYJyr4AgRApogVssmPUhgeZexZz4Uv/eGMKBYc9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 590/990] wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths
Date: Wed, 25 Nov 2026 15:32:37 +0100
Message-ID: <20261125143835.912273606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit ebc938ba1d5ff33652013b99c7b9a74f05690336 ]

Currently, NAPI instances and their associated netdevs allocated for AHB
external IRQ groups are not released when external IRQ configuration
fails. They are also not freed when arch_init() fails after
ath12k_ahb_config_irq() succeeds during probe, or when the driver is
unloaded.

Fix this by adding a common cleanup helper to release the NAPI instances
and associated netdevs. Call it from the external IRQ configuration error
path, probe error path, and driver cleanup path.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com
[renamed label err_free_irq]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Dropped the arch_init/arch_deinit parts missing on this branch and routed the ath12k_core_init() failure in probe to the new err_free_ext_napi label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 41 ++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 1a1195951a140..39cb9901dbd76 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -183,6 +183,26 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
 	}
 }
 
+static void ath12k_ahb_free_napi_for_group(struct ath12k_ext_irq_grp *irq_grp)
+{
+	netif_napi_del(&irq_grp->napi);
+	free_netdev(irq_grp->napi_ndev);
+	irq_grp->napi_ndev = NULL;
+}
+
+static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
+{
+	int i;
+
+	for (i = 0; i < num_ext_irq_grp; i++)
+		ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
+}
+
+static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
+{
+	ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
+}
+
 static void ath12k_ahb_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
 {
 	int i;
@@ -580,8 +600,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 		irq_grp->grp_id = i;
 
 		irq_grp->napi_ndev = alloc_netdev_dummy(0);
-		if (!irq_grp->napi_ndev)
-			return -ENOMEM;
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			goto free_napi_ndev;
+		}
 
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath12k_ahb_ext_grp_napi_poll);
@@ -628,12 +650,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 					       ath12k_ahb_ext_interrupt_handler,
 					       IRQF_TRIGGER_RISING,
 					       irq_name[irq_idx], irq_grp);
-			if (ret)
+			if (ret) {
 				ath12k_warn(ab, "failed request_irq for %d\n", irq);
+				ath12k_ahb_free_napi_for_group(irq_grp);
+				goto free_napi_ndev;
+			}
 		}
 	}
 
 	return 0;
+
+free_napi_ndev:
+	ath12k_ahb_free_napi(ab, i);
+	return ret;
 }
 
 static int ath12k_ahb_config_irq(struct ath12k_base *ab)
@@ -1071,11 +1100,14 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ret = ath12k_core_init(ab);
 	if (ret) {
 		ath12k_err(ab, "failed to init core: %d\n", ret);
-		goto err_rproc_deconfigure;
+		goto err_free_ext_napi;
 	}
 
 	return 0;
 
+err_free_ext_napi:
+	ath12k_ahb_free_ext_napi(ab);
+
 err_rproc_deconfigure:
 	ath12k_ahb_deconfigure_rproc(ab);
 
@@ -1115,6 +1147,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 {
 	struct platform_device *pdev = ab->pdev;
 
+	ath12k_ahb_free_ext_napi(ab);
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);
-- 
2.53.0



