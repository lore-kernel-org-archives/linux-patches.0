Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019649;
	b=4Ui8FsvzM+B6cWjPltOcOfLqttVrUYOqa/A9vmd1lPc36JuenB5NTq3hz0KY5JhXmJt3
	 5eO/63W0dRKKPbiAVOAeMkb6+d372TfhepGUB+acH8603Dq1U1q/cTfincecvchdiO7hq
	 EpPDsSaUGw2B+4fNr5xjtMtx788IP1yEJUzOYtoRFzk6j52JEX4pv1AuGu6gc/SwIe/T0
	 Bgmj3vpcTs4HaJndj1iM41q2NcM2/ZvXrxrfn1/ae8l+5m/jVtttQTQO6wz5pf6CpP63g
	 XtcVc+EMXDZL5vvcRenKlVT8FwXHsk7MzpHim//z5+bi7sZ5TwAVqvDLMdjFZLOCTxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DpmJZifdg9NfwheGDzia8MY17IKU/TerChrgXXFr9T8=;
	b=jRTE2BNE+iIoQeKywKCkdamhnGRxSPH7VVOgcG0nvqqo6PMx4JFf3j2ACmvItUvI2YWV
	 jEZcYaAUGFsXt9EYFtz8ekqYTRQDcXgpNbsgrffOd7HEJ3Z9AjyXz+Z2pvn+ftS4wFRHq
	 eh/Yl8/FlxwU77AYv8mluzrep9w/hA7V6lMFTvlKYJZBlfpuMv4NteBusbuKL4VzB01Pi
	 tKGV2oeUoOEpjuWke6W+C7pvKJCpGdXXnN+O7rSkA1c+wgedr4OaKunmk1kZ3m0Ug93le
	 0jKA5CQ6LBN4uaLQ3VboCU4UkGROy+R/m4f6iIavarJMzjxwgbaFhs1vfKVcwFNq43Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRNJ2pB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2A1606A325;
	Wed, 18 Nov 2026 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRNJ2pB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078631F000C4;
	Wed, 18 Nov 2026 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019649;
	bh=DpmJZifdg9NfwheGDzia8MY17IKU/TerChrgXXFr9T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRNJ2pB8eO9LdTtpvdGHqEUS6PShAE+w1wohVlmjsDtzqZ/0mkUCldIc2xCgFSGcC
	 zOnXYvYlYWzOw0ksOd9le9LC00PA4q1/Rqi3zwoilbtJ7nvbOCo7eiaFgLLMk05B1p
	 Cb/i4DYj9oscHDmHOwzVWwhhdoqAgpUEWCO6fdS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1672/2651] wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118150347.896377757@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 41 ++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index d89a49c6ebb74..df79f15c1ccae 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -191,6 +191,26 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
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
@@ -594,8 +614,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
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
@@ -647,12 +669,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
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
@@ -1229,7 +1258,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ret = ab_ahb->device_family_ops->arch_init(ab);
 	if (ret) {
 		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
-		goto err_rproc_deconfigure;
+		goto err_free_ext_napi;
 	}
 
 	ret = ath12k_core_init(ab);
@@ -1243,6 +1272,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 err_deinit_arch:
 	ab_ahb->device_family_ops->arch_deinit(ab);
 
+err_free_ext_napi:
+	ath12k_ahb_free_ext_napi(ab);
+
 err_rproc_deconfigure:
 	mutex_lock(&ath12k_rproc_info_lock);
 	ath12k_ahb_deconfigure_rproc(ab);
@@ -1285,6 +1317,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
+	ath12k_ahb_free_ext_napi(ab);
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);
-- 
2.53.0



