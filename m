Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC126B0BE;
	Tue,  8 Apr 2025 12:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114367; cv=none; b=Qmw7ZRLL6TGmZY8jOBVZyEUN762K1BwotA27ypER1XIywo3mS8O5k9aFhZClUqxB9Q4fSReJzpF3bevKRWLkker/oaSB0jaGxNAbQlKKBKI3g2fz9e6fdqqged4nNEiuxOpiun3xHXKm/zai1Tctuxch05bjmYnzdpjTcreZRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114367; c=relaxed/simple;
	bh=4xpjbKjUJu/+N8KkjUmpsgy6PkZT3y4oNrm16vQVTK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtnWV8cn70Z9RZdPaYmvafNW/QBq7/XH5wEyzDsW1iVfwAyPipY4bjvWgyRKMF4kFBd0RqEQZYGk4G+6zkpadpjtKwMlKXpX0DKzPYGRkwObMHSqS5Rg/jEPb9mcWMmSnJxPJK2dy3Pu+byc9dJ7kHwY6QSAWU0ldMyLckQQmEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHZNyhXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHZNyhXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D534C4CEE5;
	Tue,  8 Apr 2025 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114367;
	bh=4xpjbKjUJu/+N8KkjUmpsgy6PkZT3y4oNrm16vQVTK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHZNyhXq0rmucqFZlT1QYxjtu/1AsB8bhmzGO0o/mT9gEXwxbPnFeQgfylXhQEtZP
	 8OCuoU2inwrpdxDgXou1C+4cRnXXBobjZu9H3UuE4Ke26HF0vbcgxSjfHzsKWlDBR4
	 x3JjoEt9VmjKKMTRB9+Lq4iqVlvDnWRMWxUis/d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/499] regulator: pca9450: Fix enable register for LDO5
Date: Tue,  8 Apr 2025 12:44:15 +0200
Message-ID: <20250408104852.319353819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit f5aab0438ef17f01c5ecd25e61ae6a03f82a4586 ]

The LDO5 regulator has two configuration registers, but only
LDO5CTRL_L contains the bits for enabling/disabling the regulator.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://patch.msgid.link/20241218152842.97483-6-frieder@fris.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 9714afe347dcc..1ffa145319f23 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -454,7 +454,7 @@ static const struct pca9450_regulator_desc pca9450a_regulators[] = {
 			.n_linear_ranges = ARRAY_SIZE(pca9450_ldo5_volts),
 			.vsel_reg = PCA9450_REG_LDO5CTRL_H,
 			.vsel_mask = LDO5HOUT_MASK,
-			.enable_reg = PCA9450_REG_LDO5CTRL_H,
+			.enable_reg = PCA9450_REG_LDO5CTRL_L,
 			.enable_mask = LDO5H_EN_MASK,
 			.owner = THIS_MODULE,
 		},
@@ -663,7 +663,7 @@ static const struct pca9450_regulator_desc pca9450bc_regulators[] = {
 			.n_linear_ranges = ARRAY_SIZE(pca9450_ldo5_volts),
 			.vsel_reg = PCA9450_REG_LDO5CTRL_H,
 			.vsel_mask = LDO5HOUT_MASK,
-			.enable_reg = PCA9450_REG_LDO5CTRL_H,
+			.enable_reg = PCA9450_REG_LDO5CTRL_L,
 			.enable_mask = LDO5H_EN_MASK,
 			.owner = THIS_MODULE,
 		},
@@ -835,7 +835,7 @@ static const struct pca9450_regulator_desc pca9451a_regulators[] = {
 			.n_linear_ranges = ARRAY_SIZE(pca9450_ldo5_volts),
 			.vsel_reg = PCA9450_REG_LDO5CTRL_H,
 			.vsel_mask = LDO5HOUT_MASK,
-			.enable_reg = PCA9450_REG_LDO5CTRL_H,
+			.enable_reg = PCA9450_REG_LDO5CTRL_L,
 			.enable_mask = LDO5H_EN_MASK,
 			.owner = THIS_MODULE,
 		},
-- 
2.39.5



