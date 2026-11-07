Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062254;
	b=ShUGNTD7E//UL/kPGuD9XfX2AFgNVO8YjbBWZDSdQHino1LVE2stNUzxB7L1cyThFbLQ
	 rAtDjsXqfHOtoPwNi19IGSQb4wzpwuewhGLzY5WAq04/CM6GrLFmNIKG9zoGvdznryxhf
	 Ixlv8Ocq6/MkEm/Q5I57YQUfPY6Mz53icctnYnPvi7pw2X7c6bgnwIpPQVNwukkOBpEkW
	 B4BAiM/CM3SG2zY/JhQrEzGAgUeZsdOq1voIBiJl/SwGZlcNrOfgtlwAsuSzy5PNMUXmr
	 u4TRigTVMfUP14cN1ZkHQgdNwfNppu/RL/Jus1oTDeESbSkaEuQCL6HVgsEHg6UPtOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fvcFgP0z4Yc9+wUdmw1ruElIni+xlI7efO3xbWB/cNw=;
	b=C8ElsQ4LagT1u5dLjei2oYuptcuD66vrIUlRuWY2N9wlrMNksqgX6WFZXT6rAEgupvYL
	 NOvgnaZwlK5X4Uli/vEWTVG8ftNwvpVxZzOX65UUnXsazQo01ph+XmU5Kn9DLFukUIazT
	 bZnj+E1O+Kf0YVt5grLTtOoCviIET+lpz1aoq9uvu65NEqJ8lSrk7n0dpPKCunb/z/7TW
	 xdm1KW3b40dAiu9C9hWJphL8XW8tAsrGbHueb03zzZ+JBKmXpTCE1mZkLYu0SoFeRRbO5
	 DXv+OM/cibjWfB+V9aASPELfH8BVE3z340qoXQc9VLKyH/eQRuljqR95eUJbV/BFQ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaeRdJTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA660A261C;
	Sat,  7 Nov 2026 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaeRdJTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE1E1F008A2;
	Sat,  7 Nov 2026 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062254;
	bh=fvcFgP0z4Yc9+wUdmw1ruElIni+xlI7efO3xbWB/cNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaeRdJTSdyAtwyGqGVnEOkERXKDq1+7hA7Bk6PJViuX5GNFz+uhiGm2tkK1Byqt78
	 Yh1wVbaaxfNiX5rDy6bdbddi8HLkiRG/xJtEzuA4aO5XZ2ecgZZYUz78ce0mmVhmpj
	 Q2WVVVMlNY5LzGWOUPeJ0TjmkntraBc8ds/TkXYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1159/1536] perf: xgene: initialize lock before requesting IRQ
Date: Sat,  7 Nov 2026 08:52:55 -0500
Message-ID: <20261107135030.279234217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c01466ae1e3d9..45bc62cf3f783 100644
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



