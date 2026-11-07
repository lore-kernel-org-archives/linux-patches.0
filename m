Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064428;
	b=xj6tXCgzqtEJ53+ngAwy2rCVJyzklPMiIzilwRh4ByhoE8Pdw8lg8DDw6mRUyvDJ+K0G
	 TxLKAR/vCdHherTYjrVVyADOSutn1OS90sxeoN5jAX1zPuFkN2yA182inRPUO7Q++miVP
	 xsHhileOhovFfhdnxm02/jTXYMeAVYswbMQtKN7JVieDJcazfU0Dokm2rAlmQ07fCWjJQ
	 f9tgbgnqntv0YhPkYQB8aWut043MRmD+pAiZ3KdbFbkA44eGP5lYEel4LrPfA38gOVHRr
	 yMMhkwVHJcOaiNYPdtCPMZmSapDyHBQn8QZwguoGRw83hzHBltyWn7kzXL8YwQs3Z0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lb+2IOte2D0sr7HHj09vHf3jKupn/mdoXAPsf4nMgsA=;
	b=DnA4S0VftBCyIEOKl4fTUSwzZxHdU3V5eQ9B/OcLPL+WJaPmkDOv2Yapu04uWjCHshRd
	 cV0i5okSGJkHpu8qivBaSrFllK8n0L6CDDPCKyGl1em4ahDsCl5ddygnL1QlMHMKXgxxN
	 L1iRE/1cghFIiK5QJFKC710eMljfGXuxTeW9cUFlnLRtoFjM0inGtE2fdcSzHxucvz9Ho
	 H8sxs/cJN1ZLQbd9wHE7GqFMqpbdWprxK8gImQrGUIcEjNoCEWbqA2mup6kifxa/6yFXk
	 PBt3ThXz40vP4vvV7y4E5NjexeViSYequsw4ICNo/CuhQNMduK5PqqGouRmOH3DUZiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDJrxhPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41E8606A9C6;
	Sat,  7 Nov 2026 15:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDJrxhPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ABE1F008A1;
	Sat,  7 Nov 2026 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064427;
	bh=Lb+2IOte2D0sr7HHj09vHf3jKupn/mdoXAPsf4nMgsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDJrxhPtpAfmV3jOob5kCItJoiMQZkcpVs4xWbztEDP0pnwztSw2BB09DM09x6P7P
	 TOP4+Wr4lqPC1Ad0jFaGeiZgso2H42vBp/jU0zKKUiYKuopHScDV9+SGF2ibwo3k9e
	 ZYrguOZ8IqpWNLDIqWCcdMM3fb8JuMsNOPKde2g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0477/1257] perf: xgene: initialize lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:46:13 -0500
Message-ID: <20261107134952.624979302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index ab3623fab914c..0aa2b605fd53d 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1873,6 +1873,8 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
+	raw_spin_lock_init(&xgene_pmu->lock);
+
 	rc = devm_request_irq(&pdev->dev, irq, xgene_pmu_isr,
 				IRQF_NOBALANCING | IRQF_NO_THREAD,
 				dev_name(&pdev->dev), xgene_pmu);
@@ -1881,8 +1883,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



