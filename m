Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015839;
	b=YSUQdpWk1Vm9cMlQrOsYMCF91Hrhn4RUOyWZkErYjyMheAGXS00YllSbxmbXYeOzMN/G
	 E6mZ9SYk+H2Wzzn2FqrrSNBwhTbLtC0r5AFweHHj+FwIzXl4fjXuRMRp6dKdVEBiTD5sf
	 akrOJm96Wa4uACp5D8IxhTP9Qrcn8PFYN5KeK17QK1RBPiL4R8OUnNz4JK2g5Er94eFiq
	 B6teAc5Sv8c6EOH1cfDEq9Z1zimu73BcqUnDIJG4a3sOds7hjNObzgFNBDcFdRn3rG1el
	 pGQLREkt7r3wgch/ebIbBGOCUiczzOt3G7ILuejZb1y2oGXV7IhJHsJZyc2NhOBix4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvGunDlNBJfY2bk2msPwVaOKTlydnGDzSUUjb967U4Y=;
	b=rQ4P8Wt0zKqZGep+CRiLKRduSk7rzl+flphVm8wKzefmfNc3ElR3HvIZy8Zc3CZW9xLD
	 DT183UfB+UvOcHB6SAXzhs9nF+SEum10BJWsI3FrwxgSm0IQG/Z8f6/tI8yCEGo1PoHs7
	 Km+U3WIdkjIfyRq+QUkuHALyVxyWW2zDAnGBrGPtbewASXDmM/nH4OQRAtm5fTlWcXvho
	 xr/L7OYMu24xqMEHmEEZHP7nhJg/5XuI7s0Qad1BGUJ+jIo4lIvXWSM21JhVasg7hWQTl
	 Hl7du0Z1neD8SvD/PECnR+MU5dwjJfM7eQwlp8bRAwoG+1nRbmf33i7NRsDcjZcHGWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pykia/EF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3473606A332;
	Wed, 18 Nov 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pykia/EF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F6D1F000C5;
	Wed, 18 Nov 2026 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015839;
	bh=uvGunDlNBJfY2bk2msPwVaOKTlydnGDzSUUjb967U4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pykia/EFy2/Una6qMfamNPh/k5b5v04DVWIuR/Vq0t2lXGQcQBMGrDkCCr5lbJQkC
	 qCEXEeXl7tVwrZw6PlE//0dpn6lu4/Ea0zZ2oKX/g0BKF5kJadRdhkXwkqoxcXpGvh
	 wsYMAJZmlb25cqvWJLiL1AMrVTTMdiaUFoMgeHZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0316/2651] wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry
Date: Wed, 18 Nov 2026 15:25:56 +0100
Message-ID: <20261118150259.257093560@linuxfoundation.org>
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

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit 4de5a8a0edddc453f1a4c93b6d9f09013a23b72e ]

ath12k_wifi7_dp_tx() maps the original MSDU into ti.paddr and
stores the address in skb_cb->paddr. When an extended MSDU descriptor
is used, the function later maps the ext descriptor and overwrites
ti.paddr and ti.data_len with the ext-desc DMA address and length.

If TCL ring allocation then fails, the error path first unmaps the
ext-desc DMA address from skb_cb->paddr_ext_desc. It then falls through
to fail_unmap_dma, which uses ti.paddr/ti.data_len for the original
MSDU unmap. At that point ti.paddr still refers to the ext-desc
mapping, so the ext descriptor is unmapped twice and the original MSDU
mapping is left mapped.

Fix the original MSDU unwind to use skb_cb->paddr and skb->len instead
of ti.paddr/ti.data_len. The ti fields cannot be used after the ext
descriptor is mapped because they are intentionally reused for the
buffer submitted to TCL. Also clear skb_cb->paddr_ext_desc after the
ext-desc unmap so a TCL ring retry cannot observe stale ext-desc DMA
state from the previous attempt.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: 37a068fc9dc4 ("wifi: ath12k: Handle error cases during extended skb allocation")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index e14f1d190ba8d..adeac4043b99b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -449,15 +449,17 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	return 0;
 
 fail_unmap_dma_ext:
-	if (skb_cb->paddr_ext_desc)
+	if (skb_cb->paddr_ext_desc) {
 		dma_unmap_single(dp->dev, skb_cb->paddr_ext_desc,
 				 skb_ext_desc->len,
 				 DMA_TO_DEVICE);
+		skb_cb->paddr_ext_desc = 0;
+	}
 fail_free_ext_skb:
 	kfree_skb(skb_ext_desc);
 
 fail_unmap_dma:
-	dma_unmap_single(dp->dev, ti.paddr, ti.data_len, DMA_TO_DEVICE);
+	dma_unmap_single(dp->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 
 fail_remove_tx_buf:
 	ath12k_dp_tx_release_txbuf(dp, tx_desc, pool_id);
-- 
2.53.0



