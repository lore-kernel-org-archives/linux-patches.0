Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24662DB7B8;
	Sat, 12 Sep 2026 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222575; cv=none; b=JQJRVy4lE8w33y5mtvwIgbBW3kUFfQIERTWQT8Si+hDtg+8jUa9vF+XUnK92o/GD2z/qyO9/OkWndg6XtkEcUQvEi2Js4fRyK18pqGavc/u0VmVxWygNdEy5YwCeBIj27erCE4SpEYm+LmMHyFGrKqYPwoksiLiM7r8J8OnhzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222575; c=relaxed/simple;
	bh=60GobmaEMTPGOFud2MkGBtU0s9e0p1ZGHuBp5mgm5ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0sbk8ru2eSO+ASXTb39gGz/f3SsXPRfEJAfzEgQU2zFcjKNl4tM7vHgb+yGEPvBzSaPprnJqOL3qUEq+fd9vEfFL0Bx7pt/6hMNbFlFI9hpPa44HkFmTSVEXqPviOjeqLvLE5jgeQpn7+pbg7N1n9eCcv3KTfeu8yHt2o5tX/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxhbZSUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxhbZSUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C391F000FF;
	Sat, 12 Sep 2026 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222574;
	bh=0adRI/0QGyaPufolP8j0gNRe+BRwwD6Gx5I7C2fjl9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxhbZSUffRRjbpZjlsv5bUpIQgpKPkUfrKyrVbUID9y9H/zi6E45YblbhfpLMgpAo
	 XxSudDKMGumedy5DaMjV2rfj+6NXy0q4JuyqXIxJX8uI7pa1zjNVGpn6wjjfoLRgnE
	 yTzot64C6sidu1RMOCZkW9rafIJLpW8u5CiJQzLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0613/1424] regulator: tps6594-regulator: remove interrupt_count
Date: Sat, 12 Sep 2026 08:50:45 +0200
Message-ID: <20260912065621.019230108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 16d1a9bf36ef649b1fdb866985b4b87584491fac ]

In .probe() interrupt_count and nr_types is essentially the same. It
contains the number of different interrupt per LDO or buck converter.
Drop one. This is a preparation patch to further simplify the handling
of different variants of this PMIC.

This patch is only compile-time tested.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250703113153.2447110-6-mwalle@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7fd28093b3ef ("regulator: tps6594: Fix device node reference leaks in multiphase loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index 0193efb5dffa9..1284a702db8f2 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -577,18 +577,15 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	const struct regulator_desc *multi_regs;
 	const struct tps6594_regulator_irq_type **ldos_irq_types;
 	const struct regulator_desc *ldo_regs;
-	size_t interrupt_count;
 
 	if (tps->chip_id == TPS65224) {
 		bucks_irq_types = tps65224_bucks_irq_types;
-		interrupt_count = ARRAY_SIZE(tps65224_buck1_irq_types);
 		multi_regs = tps65224_multi_regs;
 		ldos_irq_types = tps65224_ldos_irq_types;
 		ldo_regs = tps65224_ldo_regs;
 		multi_phase_cnt = ARRAY_SIZE(tps65224_multi_regs);
 	} else {
 		bucks_irq_types = tps6594_bucks_irq_types;
-		interrupt_count = ARRAY_SIZE(tps6594_buck1_irq_types);
 		multi_regs = tps6594_multi_regs;
 		ldos_irq_types = tps6594_ldos_irq_types;
 		ldo_regs = tps6594_ldo_regs;
@@ -686,29 +683,27 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 
 		error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
 						 bucks_irq_types[buck_idx],
-						 interrupt_count, &irq_idx);
+						 nr_types, &irq_idx);
 		if (error)
 			return error;
 
 		error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
 						 bucks_irq_types[buck_idx + 1],
-						 interrupt_count, &irq_idx);
+						 nr_types, &irq_idx);
 		if (error)
 			return error;
 
 		if (i == MULTI_BUCK123 || i == MULTI_BUCK1234) {
 			error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
 							 tps6594_bucks_irq_types[buck_idx + 2],
-							 interrupt_count,
-							 &irq_idx);
+							 nr_types, &irq_idx);
 			if (error)
 				return error;
 		}
 		if (i == MULTI_BUCK1234) {
 			error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
 							 tps6594_bucks_irq_types[buck_idx + 3],
-							 interrupt_count,
-							 &irq_idx);
+							 nr_types, &irq_idx);
 			if (error)
 				return error;
 		}
@@ -727,7 +722,7 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 					     "failed to register %s regulator\n", pdev->name);
 
 		error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
-						 bucks_irq_types[i], interrupt_count, &irq_idx);
+						 bucks_irq_types[i], nr_types, &irq_idx);
 		if (error)
 			return error;
 	}
@@ -742,7 +737,7 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 						     pdev->name);
 
 			error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
-							 ldos_irq_types[i], interrupt_count,
+							 ldos_irq_types[i], nr_types,
 							 &irq_idx);
 			if (error)
 				return error;
-- 
2.53.0



