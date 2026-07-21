Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2D544AB68;
	Tue, 21 Jul 2026 21:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669051; cv=none; b=szc0CEbIYH64QVfk+DFb4DP08cYzIdaAUzsXOSpbbB7Zi+0BBLdJ9L/P9P50tw7wyMV3BB8jCLvV+Mr8dSV96QcreLVdUYLrrQnTLzAN73sZV7AuDBHGk0iU6VcYl0V4oHZKRJ/Uc4yOYMmOu8EqpegWHgPMDHFthCrqHDTr1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669051; c=relaxed/simple;
	bh=VfyHLp04VtNrrpIH/oX7XOFgW/gvGR4s6PhpkjqTBOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnO75mv+9pfpZ8ePDt9rFdEw0gt9shWtCnCxd6/lw9VvhJi7w+rNZft0922ddpunIUjOmJbEtgpJfaG1fx/ihXQfLE1ZrJ7s/oopvXG5iQB8dUZMyYzv449xiJJz6qnf+B/uFOjf+NxtNiSHZQiQGVNkqn96CJymRSDXIPNz6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpuEFcrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpuEFcrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E711F000E9;
	Tue, 21 Jul 2026 21:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669050;
	bh=GZCxoMwHCm+8ArGNcLTaf4tocK1JOg429OE32lNZt4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpuEFcrsOUOqUvoQ6eEtkp+nK8mGn7MxZw8cXVZZOTdF4DO1nEjSfePYLsA0MnFIv
	 KuUR/nNqJkUUWjh/3NGxvDNgBHnhhgZ2Gy+rlfpyUyNTh/8OniFNtjFRk+WPLdiLsG
	 nfD6eRPwlQ7RMaoLLQaXhdvL8GngQWYTMKJOoROE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0407/1067] hwspinlock: qcom: avoid uninitialized struct members
Date: Tue, 21 Jul 2026 17:16:48 +0200
Message-ID: <20260721152433.735241732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 8752c396ce3b2136b3d4c906fe103f6efb6782d9 ]

The reg_field is allocated on stack, so using the REG_FIELD macro will
ensure that unused members do not have uninitialized values.

Fixes: 19a0f61224d2 ("hwspinlock: qcom: Add support for Qualcomm HW Mutex block")
Link: https://sashiko.dev/#/patchset/20260319105947.6237-1-wsa%2Brenesas%40sang-engineering.com
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260512091339.31085-2-wsa+renesas@sang-engineering.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/qcom_hwspinlock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
index 3f08cd4a5c2801..319959b11ef4f0 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -178,7 +178,6 @@ static struct regmap *qcom_hwspinlock_probe_mmio(struct platform_device *pdev,
 static int qcom_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct hwspinlock_device *bank;
-	struct reg_field field;
 	struct regmap *regmap;
 	size_t array_size;
 	u32 stride;
@@ -200,9 +199,7 @@ static int qcom_hwspinlock_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bank);
 
 	for (i = 0; i < QCOM_MUTEX_NUM_LOCKS; i++) {
-		field.reg = base + i * stride;
-		field.lsb = 0;
-		field.msb = 31;
+		struct reg_field field = REG_FIELD(base + i * stride, 0, 31);
 
 		bank->lock[i].priv = devm_regmap_field_alloc(&pdev->dev,
 							     regmap, field);
-- 
2.53.0



