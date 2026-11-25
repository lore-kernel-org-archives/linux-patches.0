Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617755;
	b=tHdDv1vslRC6K0OL8VzA8S5QLlId2TgwWMz7vW04AyC5tk9ugiEPMgCQ6WR48eIJ9JAI
	 FrGpJl/5sAijY22yVUXTAMmVSGIUzg8AUAON1cG0OBn28QjPMQQ7/5iv4k4j8KeO4oBdF
	 LDiaZxGWeekgAAtmY5QoVzVzxAOJNMJMgACWLsGG+RXYf0W6/q0Gv8Bo4UubKMbbU2fpo
	 9HlbZwr1dkPp/8Uw4P9gvX9z3oMXFkMKuEkNmTb5/kqQhTwUuHswV6/SKA6o8ygGPb+KA
	 AYoq2g814lldHbkTIzTc/GaytPu0i+49dJpmjuaKo+yubq2ciBDjp6UXn9CnKPgECIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enGcEcF36ZGVkjtBQeafHns38mdbp5qzBikoTd+O9nA=;
	b=uawyiTtlkc2I9y3Zv53knXsSTGcnpX1M1Fs37+VeSju8+5+k/4luhcLJYKZTJjeKdSQc
	 K4VvAsP8sxVJ5vVpvbLPAsH0QnCcWPwU/7e/hMi007r9pBCuNu+ZeWJeklYDvGwlGq7+q
	 7w1TucdC95Cgrn4IL1xHefTAa86rMJ/+R9bG01ju0+bh0KSBQ7blP9rEMAg84hnlCamMa
	 DrP5ZUun/81aRbv2hygZdcQioukSBdPNknReNUrHXYj07jIneytysawYHQHPRwnDdz59g
	 cC9snyUn/RvYtRQm8ePc8Di0kiyZl/CBcR+Ps1pOS90jcmFNJQQDG5+sW1HarHW42HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElsSAP2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A6606A321;
	Wed, 25 Nov 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElsSAP2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA951F000D8;
	Wed, 25 Nov 2026 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617754;
	bh=enGcEcF36ZGVkjtBQeafHns38mdbp5qzBikoTd+O9nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElsSAP2D91993JicmDCd09FxtU1mwXcn440DatEpfRS91FieKbqDX3L3I1DN/xOQT
	 apmQVmYeUpnnKUxyyiCsQbVXwffdQK9n1hISewtImO74DQ/I6uDFTZEAmYxHOfaUXj
	 tKiMMJe7P+IsTLLrsCfpxBhzXaxO5m/AC1BxZGwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0062/1005] wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler
Date: Wed, 25 Nov 2026 15:23:20 +0100
Message-ID: <20261125143823.193940490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 216dd4fc57435726506e250ba2483f31ddc3c01b ]

On AHB platforms such as IPQ5332, IRQ group 3 maps multiple hardware
rings to a single NAPI instance. Each ring is assigned its own IRQ
line, but all IRQs in the group share one napi struct and one poll
function.

When two IRQs from the same group fire simultaneously on different
CPUs, both handlers call ath12k_ahb_ext_grp_disable(), which invokes
disable_irq_nosync() for every IRQ in the group. This increments the
interrupt controller's disable reference count for each IRQ twice. The
single NAPI poll that runs calls ath12k_ahb_ext_grp_enable() once,
decrementing each count from 2 to 1. Because the count never reaches 0,
all IRQs in the group remain permanently masked by the interrupt
controller.

With no further interrupts, TX completions stop being reaped from the
WBM release ring. The pending TX descriptor count grows until the WBM
idle link descriptor pool is exhausted. Once full, TX ring allocation
fails and no new packets including management frames can be enqueued.
This causes stations to disassociate with reason 34 (DISASSOC_LOW_ACK)
and ath12k_mac_flush() to time out:
"failed to flush transmit queue, data pkts req N pending N"
where N equals ATH12K_NUM_POOL_TX_DESC(ab).

Fix this by using napi_schedule_prep() to atomically test-and-set
NAPI_STATE_SCHED before disabling IRQs. Only the first CPU to win the
atomic operation disables the group and calls __napi_schedule(). Any
concurrent handler that loses the race skips the disable entirely,
keeping the reference count balanced. Guard the enable_irq() call in
the poll routine with the return value of napi_complete_done() to
prevent an unbalanced enable if the NAPI instance was re-scheduled
before the poll completed.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.7-00587-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Reviewed-by: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20261015084445.3045925-1-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index df79f15c1ccae..31009313e07b8 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -574,8 +574,8 @@ static int ath12k_ahb_ext_grp_napi_poll(struct napi_struct *napi, int budget)
 
 	work_done = ath12k_dp_service_srng(dp, irq_grp, budget);
 	if (work_done < budget) {
-		napi_complete_done(napi, work_done);
-		ath12k_ahb_ext_grp_enable(irq_grp);
+		if (likely(napi_complete_done(napi, work_done)))
+			ath12k_ahb_ext_grp_enable(irq_grp);
 	}
 
 	if (work_done > budget)
@@ -591,9 +591,10 @@ static irqreturn_t ath12k_ahb_ext_interrupt_handler(int irq, void *arg)
 	/* last interrupt received for this group */
 	irq_grp->timestamp = jiffies;
 
-	ath12k_ahb_ext_grp_disable(irq_grp);
-
-	napi_schedule(&irq_grp->napi);
+	if (napi_schedule_prep(&irq_grp->napi)) {
+		ath12k_ahb_ext_grp_disable(irq_grp);
+		__napi_schedule(&irq_grp->napi);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



