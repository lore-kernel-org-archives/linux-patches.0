Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9F26B954;
	Tue,  8 Apr 2025 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116145; cv=none; b=jzPjr9y4K9szAX2hiuvU4Q4vf7q6ftovWXSDwRPBCntmb66PyJdqHuhfz5sjoLWeUl0aNlkA2MspHyqx7KerJB8t/iT90VthXCsY+zsCrj/emfd415H66lec8cVk3mRg8a9EsBiOc3ouAn4Jp1Qzh+ZGIm8mMsXCa0rdRCXQzZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116145; c=relaxed/simple;
	bh=3HHxb+nOgh8mim0l7VaIG8ToclPn2rcB1ZaRIliV5ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKEG3CIIVx1vVsOzk12ELr1FxQs0215lm0b1Doqf5axQb3tdQDMy62i1IDwWH4tTVC4dS27kxtOotoW/jE3zOR6DCQr0d63mYzBT73fBmE2dV38KFvqWPW0s1HC+LdPu2mrbZq718w1NxOzGyZT4ujqShdBMPCGZLDbbvyXiNRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E08LUBWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E08LUBWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B209C4CEE5;
	Tue,  8 Apr 2025 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116145;
	bh=3HHxb+nOgh8mim0l7VaIG8ToclPn2rcB1ZaRIliV5ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E08LUBWAycTh9KuTXkIMixEIYZtVlCerD2jKg6W3WYgrLDvqi8/2lBy5TewJ+LmBQ
	 OMcEa2ho0s+4wRHB3gQavTiaLOaVGiEXuz8xnH40R8LLQO3Womp0ywpYthUngYYIIi
	 zvS2mFHueBgfTZ4GGIa5UaFu8epEacDweHOPRnJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/423] regulator: pca9450: Fix enable register for LDO5
Date: Tue,  8 Apr 2025 12:45:58 +0200
Message-ID: <20250408104846.495162384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



