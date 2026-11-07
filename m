Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063141;
	b=ZMCkKTWVURZncYXMSK7h9EFdXlKWeas5z0vFXinEaEYk3yHTsDyCzcdfoYguw1A2nzNX
	 itQGzhid3V2dpQZbeLrLHxdZvcAr2Q625GYoxRRF7qxJjv1Xu09Xp9MQpwfXUW9AwG9Py
	 3XuLzzoW9kU0askQ9vQ9y9AZAwuom1m5fiZ+HmkJLD+uqsteEzM5NVxi9JrnoHaxcpwxE
	 P7Wpyfv80R9D5AEIlx/tJlRM1M0yUhdg3Qpw90btTVpFnW5/EFlxxfhpEigRsxCaPVLYs
	 RBK91X3KE7mwKg5fK94n6oZYpkNZBiUMjyDVlYFoqYNepOyTWRsTtePFUGccSackkPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwSiJlmX1o1a1Ypkn6LGRN65O1zxJDJKUTMrNVLORyg=;
	b=a96jvfiJEwNHuFJhegytTrze5VKWnH0Y0xUdyJyX8VQsZf5tQNM635lHy17XrThHivHC
	 PWcWucnhtDq0CYz5uHJXS9+efEik/daHvnGj26tDDqJgmJuKTqt+G/J60ug7Tf64Mt1pk
	 O4R0ynI//Sjcf26RY/g8PfPOBXPM97lxMw4GclPqAanu6CR1iNRpEnXHsjPT62AyPaIjO
	 pG4IlXo5brGk+FH8I5CP3+lGJ7rmQ7VL44Etb35pddGhRLbky/EJFwj6WH8mfr4efXEco
	 gPhAW7FUbtVc8e3Z3xXvBEVJVaqq+FWzV4K0p3mjzP4yd21C//ZoZrak6qJUGq9WbtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKG2jAKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57489606D80D;
	Sat,  7 Nov 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKG2jAKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071AD1F0089F;
	Sat,  7 Nov 2026 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063136;
	bh=iwSiJlmX1o1a1Ypkn6LGRN65O1zxJDJKUTMrNVLORyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKG2jAKYeaB+yV5FIXbjan9QE9uy3o2YS0D4xmu+RGxi2A0K82Sb0OIWM42Jdy+o6
	 CLMqNdNXSRWctsvZA8RzlyZJyweFOOPn91kTND5ASn9Sa3zQDgI76pHTo7IHd5NDcx
	 e3YZlOBVUamQzLjVWZewh3fk8LV+1B+5Lx2zKVGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 365/869] perf: xgene: initialize lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:50:47 -0500
Message-ID: <20261107134905.054956857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 33b5497bdc06e..ecbcd2d39f9ed 100644
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
@@ -1883,8 +1885,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



