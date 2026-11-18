Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052521;
	b=VzMQJvwnpXPV68Kd5wgt4T9g81jiLHT0EPaPw/398sikK/Jaxt/ABLd4ruT4vpuqKf6I
	 Cy82WBFFH8nHUxCwUlIerq2RbcEekKM7XmKjAYZPYrBUpKPPhTg7vYVrgDORa6+rmoSEy
	 SyQVBBOqkXJ6h+l8EDgWKXTmAuWqMA/QTa5RYM6ODT0Lj4hxdV0U0JCXSCnMwujy/cx3Q
	 X+0YSx6QQVosChF12e6D4QCUJdfZKnCS/lD+fjrWoqcUEpg3198iaXI2nU0oH4SMUkigm
	 DmV6Avc3UEdEMv2ta9zSNm18gLVUIGjyUCozQlqGFUESUNrhiopKUMp6NXfrCkuqsvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CiaBcuNt4y6GHQTwqe1QW/vw/UE3LH3J25f9q/u+SoI=;
	b=FN+zDevs2Suo57Xu15E3/O9lAIjEnEZDwCjN3sAUU1BWmW0AFA0ojfBzX72B7IqB6YxZ
	 0aF07HxfH6uin87XFsWt9t3M2q1i5/rlGk3PviDyWU7x1FVODKsI3A56yzjHCADzCL0j2
	 gnrxDaMhx60kXpgl4x3jtsNRGYW20CocPXie5SIdS9754E1W8hlgYHrqaTkoFVKumnoi0
	 3uhaLgoPXdj+1ZjiSE2RGUassrfo0n6L1T376TPkxjPucpgiH2OANHfCIbSqHBgjuw0EJ
	 b4q8+VpZw962o7Kd4RPaE09zHttBWY9XFuj5sMsnnaoa9Te1sNxxsiL+uKPruwxeGOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KthbgOka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A60606A31C;
	Thu, 19 Nov 2026 01:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KthbgOka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB01F000C4;
	Thu, 19 Nov 2026 01:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052521;
	bh=CiaBcuNt4y6GHQTwqe1QW/vw/UE3LH3J25f9q/u+SoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KthbgOkaan1t2Ewig2LXvOGOWiUrTq8950xF5OvN8cMawMlxvgZhdzq+NK7ptYNPf
	 1mw2M2MqzLPedpnlrSMz4KNJ0OsZJ5AET//imlAe99I4YQeVxbaWa02zf+bMn6Llcw
	 NSIkBDMVIPY7BrWYYgdJ+V9Ju2doNMNOu4hwpci8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0576/2214] perf: xgene: initialize lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:37:32 +0100
Message-ID: <20261118150033.987452077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit d4b7b0c77142b3bc535192fa65130474a129c487 ]

xgene_pmu_probe() requests the PMU IRQ before initializing
xgene_pmu->lock. request_irq() enables IRQ handling before it returns,
so xgene_pmu_isr() can run in this window and acquire the uninitialized
raw spinlock.

Initialize the lock before requesting the IRQ so the handler always sees a
valid lock.

Fixes: 832c927d119b ("perf: xgene: Add APM X-Gene SoC Performance Monitoring Unit driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/xgene_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/xgene_pmu.c b/drivers/perf/xgene_pmu.c
index 2b6d476bd2137..4a6e0c7ca082b 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1896,6 +1896,8 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
+	raw_spin_lock_init(&xgene_pmu->lock);
+
 	rc = devm_request_irq(&pdev->dev, irq, xgene_pmu_isr,
 				IRQF_NOBALANCING | IRQF_NO_THREAD,
 				dev_name(&pdev->dev), xgene_pmu);
@@ -1906,8 +1908,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



