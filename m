Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621874;
	b=NMiy9HXCudnwzXHCec9AyMXyofnt3RE/Xxo/I6dil3z3H1hf4sz9VgJYWLpGzwUKjIia
	 O2MLBOV0V07i7iSyE+moFjPGpf+NzTe/ORT3HuVqGWNfltIuiqH845Vk6OYSJKMKvM05o
	 64OnrYEcaRjgdl0Ix2MU1JKzA865Zs1Z2erzeCF6/PT8QNyCxSRIu2cd+NMq8wx7QVgk8
	 /AKyxdZ54wFsT8f9Usfu9iTk/g0B1F7p6Ry2Bn1X9C/dfh0OZdGpS1VLEBO1/AWEFdG8s
	 OGEHi0qnbsSG1FYHBYlYa7Ue9i0K9jbWZgP4bTQWiNbNZdCWC4Ag6pFt/8XZR3VcDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyedOfY5UiY+PU+wCahFkTRwm9WRVEa9XyfHKQbpDxU=;
	b=lZMvJt1olxtLOmezm7WuTbvKn3YmZABcF11TXuzgT3BTWZMyLdSM++xjGCGkDymVkDz5
	 1cmkgY5LkyQIy71wTbwWtT07nhMUqq1whTy5hEIRYymRTRozcqM3xi+S8ZXzu+Ut1E1aM
	 4EVPJiMzrkYt4E1ATurFgtg1xQBTF4fRJhsMIU1Nt2h3qbMpnc5Ii4FJGVJzh9LsCcZQp
	 uyYP+0gSR7I7hIz0t9XcuTTsna5JRR//X5f1KGMwEBCKuJpO1m5NyRRHxD0HuPqwFTRUV
	 fST9CF2sY0UFtIlVV9xQXxTuYjMp8wGKiiULU6+mn4tAFJeuyhzdysiFTxIlUxq0Q0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQgOyXK5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F310606A321;
	Wed, 25 Nov 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQgOyXK5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBC71F000C6;
	Wed, 25 Nov 2026 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621874;
	bh=uyedOfY5UiY+PU+wCahFkTRwm9WRVEa9XyfHKQbpDxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQgOyXK5CkFRJQGE/z3RK9ib4vFE2qV5BE+WzajcvyX1UB/pvefHhFjYAYBDPURDw
	 afpVqX2EEdIVj/0Q34sB69qX3G/qXk8RNc3k86J5RoG+LdjdggVrus5XMZ/S9dN7CV
	 5I1h/+h27KkQM3bB6QklsqsXcsvJQNs9wBMBqaMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/990] ASoC: amd: ps: guard adata->sdw dereferences with NULL check in IRQ handler
Date: Wed, 25 Nov 2026 15:28:49 +0100
Message-ID: <20261125143830.572342956@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 41e06aaef9c000c1bb52d8a6f73ae66c9bd36d83 ]

The ACP external IRQ handler is registered before sdw_amd_probe() assigns
adata->sdw, so a stray interrupt in the probe window could reach the
adata->sdw->pdev[i] dereference with adata->sdw still NULL.

The same window exists on the teardown side: after sdw_amd_exit() frees
the context but before adata->sdw is cleared by the caller.

Add NULL checks for adata->sdw in acp63_irq_handler() before dereferencing
->pdev[0] and ->pdev[1], and in handle_acp70_sdw_wake_event() for the same
reason.  The interrupt-status register write that acknowledges the IRQ is
kept outside the guard so the hardware bit is always cleared regardless of
whether the SoundWire context is live.

Fixes: e1cb350610ce ("ASoC: amd: ps: handle SoundWire interrupts in acp pci driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261107175339.3547918-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index c75aac4af73b5..07bdfdf0d760f 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -26,16 +26,20 @@ static void handle_acp70_sdw_wake_event(struct acp63_dev_data *adata)
 	struct amd_sdw_manager *amd_manager;
 
 	if (adata->acp70_sdw0_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw0_wake_event = 0;
 	}
 
 	if (adata->acp70_sdw1_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw1_wake_event = 0;
 	}
 }
@@ -209,18 +213,22 @@ static irqreturn_t acp63_irq_handler(int irq, void *dev_id)
 	ext_intr_stat = readl(adata->acp63_base + ACP_EXTERNAL_INTR_STAT);
 	if (ext_intr_stat & ACP_SDW0_STAT) {
 		writel(ACP_SDW0_STAT, adata->acp63_base + ACP_EXTERNAL_INTR_STAT);
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
 	ext_intr_stat1 = readl(adata->acp63_base + ACP_EXTERNAL_INTR_STAT1);
 	if (ext_intr_stat1 & ACP_SDW1_STAT) {
 		writel(ACP_SDW1_STAT, adata->acp63_base + ACP_EXTERNAL_INTR_STAT1);
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
-- 
2.53.0



