Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44416611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5059C433D2;
	Sun, 28 May 2023 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303377;
	bh=eyobeZ0XXKHmNHx+kw0YJwrgCkDks5pnGZyGYIFIOq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC2lauQKIwvSPc1D6Ci5uPQChKvLM/WkN1dJWzqhm5NbPekUpGcoVkFWPoVE7mjKV
	 yEEl0pbzDJ+Lp1cFedv4/hJT5rTDPMKNpW7QDGqYlKP1GAgd0WjJuUKgU9dWJmtdDw
	 /CnsanE7Ih2aPkxShlavThVooqO8MJoWr2/qV/LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 5.15 52/69] regulator: pca9450: Fix BUCK2 enable_mask
Date: Sun, 28 May 2023 20:12:12 +0100
Message-Id: <20230528190830.314064987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit d67dada3e2524514b09496b9ee1df22d4507a280 upstream.

This fixes a copy & paste error.
No functional change intended, BUCK1_ENMODE_MASK equals BUCK2_ENMODE_MASK.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Originally-from: Robin Gong <yibin.gong@nxp.com
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de
Link: https://lore.kernel.org/r/20230512081935.2396180-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/pca9450-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -256,7 +256,7 @@ static const struct pca9450_regulator_de
 			.vsel_reg = PCA9450_REG_BUCK2OUT_DVS0,
 			.vsel_mask = BUCK2OUT_DVS0_MASK,
 			.enable_reg = PCA9450_REG_BUCK2CTRL,
-			.enable_mask = BUCK1_ENMODE_MASK,
+			.enable_mask = BUCK2_ENMODE_MASK,
 			.ramp_reg = PCA9450_REG_BUCK2CTRL,
 			.ramp_mask = BUCK2_RAMP_MASK,
 			.ramp_delay_table = pca9450_dvs_buck_ramp_table,
@@ -494,7 +494,7 @@ static const struct pca9450_regulator_de
 			.vsel_reg = PCA9450_REG_BUCK2OUT_DVS0,
 			.vsel_mask = BUCK2OUT_DVS0_MASK,
 			.enable_reg = PCA9450_REG_BUCK2CTRL,
-			.enable_mask = BUCK1_ENMODE_MASK,
+			.enable_mask = BUCK2_ENMODE_MASK,
 			.ramp_reg = PCA9450_REG_BUCK2CTRL,
 			.ramp_mask = BUCK2_RAMP_MASK,
 			.ramp_delay_table = pca9450_dvs_buck_ramp_table,


