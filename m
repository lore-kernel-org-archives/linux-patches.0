Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036312;
	b=JMOIahAkYBUZvbksCV/e1C5O7A8iou33SkXusu5t+1Co5QoEWO74xKfiQXywuiNASIlw
	 fTfx8+4yKKvBu4q1WuymwkdaHdgy3yPaOLkp+zgQ+uGrh6m8wKmK1IstvcB42slMG6gpt
	 uIU8KXP3p2txOuLWkO2Aq5+TIuwrjJRi7n0nvIaV+DidtuezMIZKu4Xt1bDlwqxnKKYkL
	 sCPTnpsWNWUigPkv1sfFoM+XmzACyk6QMZQp2BFn0YO50BxyK84RjeMUAaKjoSmxMm0vR
	 59AYwbk1nHqxWVzI6JCk9fngyme2Pb2aXwUkXaiSQaOIZT4b7SJYTaQjkfCHlGjDUmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uuW/Y7wrO3tSfKGO1jeVq8BxycZOFHqwP85+PHkYIfY=;
	b=GLHXoeTkU5v540XfLEnT16JMDm7ln5p4EFvfzLZgHQF1wOj61fM+foqKW1PKNlXa5JZU
	 cetYclpqsIek4AeNWtMQUrT6T7Yk+r52tJhXD9TtT+2Uuw9okhb0bzlH2HoML35tfeQpo
	 TlLaTGVyhQGY3+BhvTD6ZATukftClLFhfrxXFi0gEDDe3m3SGfk9rE+c+QjCcw/0lv8Ih
	 R/JmV0TkuKh634JDVpKLqNAhy0n6oL5WpZncQF4SjLcfHUBsOT9g5j7OXRQI2DYJ1N0EQ
	 ibPbjBommp2wLUAx8tFGiR/QhMUNKNWDK6eXtobTJfIH6chha7uHB1NMcAPy/Ec6dig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7BwPMG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA84E606A320;
	Wed, 18 Nov 2026 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7BwPMG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F541F000C4;
	Wed, 18 Nov 2026 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036311;
	bh=uuW/Y7wrO3tSfKGO1jeVq8BxycZOFHqwP85+PHkYIfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7BwPMG8IWtI1gYPuXT/apEqhbC4EDrs4/jrYzTp4do2WeuctJTeWlAIIDgklQ7+Y
	 sIWwydYwtNnU/Tj+KOAN7ReumDndD8wFVqGen4E10JNfupLYrP808jz8p2LpnsjChm
	 ba7WQXx+AYSlWgLxBozhotpSnLFFoKMO+R8R7bPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1012/3318] perf: xgene: initialize lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:27:14 +0100
Message-ID: <20261118150350.242193408@linuxfoundation.org>
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
index 9972bfc11a5ca..56449eb936459 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1892,6 +1892,8 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
+	raw_spin_lock_init(&xgene_pmu->lock);
+
 	rc = devm_request_irq(&pdev->dev, irq, xgene_pmu_isr,
 				IRQF_NOBALANCING | IRQF_NO_THREAD,
 				dev_name(&pdev->dev), xgene_pmu);
@@ -1902,8 +1904,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



