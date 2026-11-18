Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058393;
	b=JmrA9rP1fdNRl2z1BLK9fOTmtMTzhF3ZBwHkzAsKfiQScvLr77SaBy+ValpRxqNX04pw
	 sX0QwRWrzqkcrU0Im5tU0e+Aj0TmYWpZ5dDjp7y6W4VbvirmqT21ti+JWM+LKe6yYKKT2
	 tknbW01lSKY2em7OUrTPunQBbpFKmjJFRaqsdMpfjcDh9RFboIXr4h/0Tjd44JT+0LkQ+
	 9qNxTIX8D2jTLnZuGVoL/KP6+jqfWDW65/B3yXPCXRGQTgqJquF1SWym060/3nDwBhHJH
	 F4R8y/xoECD6ce9eOMTlchE/h+o7z6x/FIzqbjvzmhYEHjXeai56uBSTzaw978mW13g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mTF++hD2u8H/VMK/0JJmFGsqmrUxWKv8aJqMcs25r58=;
	b=bpRQPTNh6ULmhSCbMZKrvDhiLwUNZP3MEmNvHPdAkzoSOGSCYAyc/b4NNbEsrqCYIxyw
	 c1ep2yEMxQXM0nX3O+eHh2ZpV0k8W9ZElNToLTEOicohQn3aCL89APNAzpD6ahPTM5hzk
	 pTnAX1/BjIOBJrrpc6wMf6YjDVA4EIH6G4Rrkdrsk/xigOXpfo82cWjw6sjfFSsH8niB+
	 yMexqC1hvBpabniphW3ZxP7lfKobrKGQDRdv3fWHJCNNWWYc8889aDO8QYRtwOiKHwfZ6
	 0RvN1Oa7xF1aMKx5Wa1FY0kly/m9/Kv4YEpTG0BbM8t65HK62aADQItt+JG7W4IbJ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ojGEkFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A2606A320;
	Thu, 19 Nov 2026 03:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ojGEkFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A88A1F000C7;
	Thu, 19 Nov 2026 03:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058392;
	bh=mTF++hD2u8H/VMK/0JJmFGsqmrUxWKv8aJqMcs25r58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ojGEkFPiSlpWoXBjpSPDJWvnpiJytw4Sx1kdZCNgruFLetYI+pq9EQs8pEAGXUjH
	 pOC2Cpe7+A/dWWKVYC0pyFxsYJFrszhWa0VU1gjD0/+NuD3wvfCiBwB+VhRxdi1xJ5
	 Dfl4kkB1HYU0NIaY34Eoo/ybXF2eahMmotUJs7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0469/1848] perf: xgene: initialize lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118145933.981897983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 633cf07ba6723..43136bad22a4b 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1900,6 +1900,8 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
+	raw_spin_lock_init(&xgene_pmu->lock);
+
 	rc = devm_request_irq(&pdev->dev, irq, xgene_pmu_isr,
 				IRQF_NOBALANCING | IRQF_NO_THREAD,
 				dev_name(&pdev->dev), xgene_pmu);
@@ -1910,8 +1912,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



