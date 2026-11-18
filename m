Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045317;
	b=k0J1LeDX3eFjvMmuITIHbUcXS+2VvASXwcgbkol1unObzppPqeE//bP3Ek0ZnbBZTg+1
	 DhEj5BdY411ZU6CfEIYKNiPbBwp3b4fAdKgkDS6/nX1BEtUxwSGJmEAe9LhBaEUsEz+ik
	 Jx5w3G2qgasuNE44t6tkWbzfLdk0Qm3vE2ED5ZGLqaBItglgHal4IW5jGH8enqljBM+j0
	 wlHH9iWKVPv61ZB+JJXDIR1qXRNGUkusUSrK03lKZpWpORD8Vk9IEO51aj5lHuqM/pB6d
	 njvV6RwZCekMJrXmnfw46bph49u4CO4fcUy/ljzj8q7VE/xEH/MbqFXVgUUFoIzqj1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3umsxfB33OV5KldM4ggAOQ8JxiuHpF0UcWtO1R6NKYc=;
	b=EUldycIWxpKIpoK782bPzLIuBk3URqlgqYEatk1GekGYPciuOA7MzR1vQftiWsRtULJd
	 WrpzUiHH6eIEGYfxJWaatYUwjw7/KkuGBd0z/bCIrof1DFnIVtwz25QBsKTqAwgny2YtQ
	 jE7pI2faX4GyBlZcHwzULca6EETNKjUe8bNUvcVC/Hc2rtGT8/Ir6jYHRPvnrmK9rxVMj
	 zQIHTMluUjAgvE4W2+LcBOr1V8ZKdy4lBvLDxZ9Q2fdqfTzeyN+oBM7RTTcLEFXQ/Q0sL
	 emEqh099sfG8txm2m/H6m5jOZQRhTRen71QKg1YoZxpJ4Y7JnpHKVcrpHhd7W/1tAOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUTYmz3E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEA3606A325;
	Wed, 18 Nov 2026 23:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUTYmz3E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59AF1F000C4;
	Wed, 18 Nov 2026 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045317;
	bh=3umsxfB33OV5KldM4ggAOQ8JxiuHpF0UcWtO1R6NKYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUTYmz3ELZAlJ/Wm+5shPRPYhs0L9GCRE5FJqPtIiE4D0t8tTh16WaCBu4ugbyOCC
	 wwv9viziNHt5tNM6kqr2b2nQ/lz/udZ2X4wQ7bWS6PpzqtHAKARc0hwd4pLj0JuhsR
	 NnBLRhTQf0CIj+3YWifQjU4aQlR+FNDqj08G/gmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0878/2857] perf: xgene: initialize lock before requesting IRQ
Date: Wed, 18 Nov 2026 15:31:52 +0100
Message-ID: <20261118150233.175850025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0c32dffc7edef..42ab66655f6a9 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1894,6 +1894,8 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
+	raw_spin_lock_init(&xgene_pmu->lock);
+
 	rc = devm_request_irq(&pdev->dev, irq, xgene_pmu_isr,
 				IRQF_NOBALANCING | IRQF_NO_THREAD,
 				dev_name(&pdev->dev), xgene_pmu);
@@ -1904,8 +1906,6 @@ static int xgene_pmu_probe(struct platform_device *pdev)
 
 	xgene_pmu->irq = irq;
 
-	raw_spin_lock_init(&xgene_pmu->lock);
-
 	/* Check for active MCBs and MCUs */
 	rc = xgene_pmu_probe_active_mcb_mcu_l3c(xgene_pmu, pdev);
 	if (rc) {
-- 
2.53.0



