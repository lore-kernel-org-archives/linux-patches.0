Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA40332EAE;
	Sat, 12 Sep 2026 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225033; cv=none; b=ZKSY5lhrJ5rnoqVr4B8fuIhM9nhN1LPCCGhRI9EsEnLCr+6KCXF2GBjDG3hz49scmqqhDuwI57QvqDAkfw6LXX0PHTBSTW4+PWvL8tEFILj0QkhfPXl7NW9Uj8T1xHcETjNzJIgzP67gW5I2RiPT5R0eEQ3vM6+pnKHl0RK8niE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225033; c=relaxed/simple;
	bh=cQoms9HJTcaqTAfaNsdj9l9zcuDjNNIWh+YbVgBrJrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs3FnXFNVF1ntwc9Bba4Lex4UCXtPyTZjcqziUuD0PAKBULnelFURRVEoOZevlPFqe6RZQxojZvqO3qtNubh8ZApLOcFjEvW7EloM0Dz9iazf9Yx9ZuYVY6DNkGa79TmhaeCfcvkt8siDH4DiQRGMhA2PPC9zGVEzKMiPiOe5ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy5WGxXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy5WGxXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7671F000FF;
	Sat, 12 Sep 2026 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225029;
	bh=lmkqdklHY3wGnc8Vjfxl78Lh133kwFuyHRKSlvjpCy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qy5WGxXjemstEnp2rwWL/HMZavT7fQq/yHSezxegWPUu9hHKPwplQxjFH9WQDkwW1
	 VLPNLZ7e1Bvw+GpXHxCRYeaLBQrAbtdl+IQvPdxrGv4HfciW4SMvjAbriCvWk/0RQZ
	 9NcdGDhbBrAjF6WniMMEEVHGnQmJ4HlJ+3m/0d2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1115/1424] regulator: qcom-rpmh: Fix PMIC5 BOB bypass mode handling
Date: Sat, 12 Sep 2026 08:59:07 +0200
Message-ID: <20260912065632.272462970@linuxfoundation.org>
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

From: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>

[ Upstream commit abd14bebb87e0fa2749371272c8b31d6ee5f0a36 ]

Currently, when `rpmh_regulator_set_mode_bypass()` helper function
is called to set bypass mode, it sends PMIC4's BOB bypass mode
value for even if its a PMIC5 BOB.

To fix this, introduce new hw_data parameter`pmic_bypass_mode`
to store bypass mode value. Use it to send correct PMIC bypass
mode value that corresponds to PMIC4/5 BOB regulators from the
helper function.

Fixes: 610f29e5cc0e8d58 ("regulator: qcom-rpmh: Update PMIC modes for PMIC5")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260801-b4-read-rpmh-v5-v6-2-9fcb54928523@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index b2e359ac31693..4bdab1abf7ede 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -75,6 +75,7 @@ enum rpmh_regulator_type {
  * @hpm_min_load_uA:		Minimum load current in microamps that requires
  *				high power mode (HPM) operation.  This is used
  *				for LDO hardware type regulators only.
+ * @pmic_bypass_mode:		The PMIC bypass mode value.
  * @pmic_mode_map:		Array indexed by regulator framework mode
  *				containing PMIC hardware modes.  Must be large
  *				enough to index all framework modes supported
@@ -88,6 +89,7 @@ struct rpmh_vreg_hw_data {
 	const struct linear_range	voltage_range;
 	int					n_voltages;
 	int					hpm_min_load_uA;
+	int					pmic_bypass_mode;
 	const int				*pmic_mode_map;
 	unsigned int			      (*of_map_mode)(unsigned int mode);
 };
@@ -274,7 +276,7 @@ static int rpmh_regulator_vrm_set_mode_bypass(struct rpmh_vreg *vreg,
 		return pmic_mode;
 
 	if (bypassed)
-		cmd.data = PMIC4_BOB_MODE_PASS;
+		cmd.data = vreg->hw_data->pmic_bypass_mode;
 	else
 		cmd.data = pmic_mode;
 
@@ -663,6 +665,7 @@ static const struct rpmh_vreg_hw_data pmic4_bob = {
 	.ops = &rpmh_regulator_vrm_bypass_ops,
 	.voltage_range = REGULATOR_LINEAR_RANGE(1824000, 0, 83, 32000),
 	.n_voltages = 84,
+	.pmic_bypass_mode = PMIC4_BOB_MODE_PASS,
 	.pmic_mode_map = pmic_mode_map_pmic4_bob,
 	.of_map_mode = rpmh_regulator_pmic4_bob_of_map_mode,
 };
@@ -800,6 +803,7 @@ static const struct rpmh_vreg_hw_data pmic5_bob = {
 	.ops = &rpmh_regulator_vrm_bypass_ops,
 	.voltage_range = REGULATOR_LINEAR_RANGE(3000000, 0, 31, 32000),
 	.n_voltages = 32,
+	.pmic_bypass_mode = PMIC5_BOB_MODE_PASS,
 	.pmic_mode_map = pmic_mode_map_pmic5_bob,
 	.of_map_mode = rpmh_regulator_pmic4_bob_of_map_mode,
 };
-- 
2.53.0



