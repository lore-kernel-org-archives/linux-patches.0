Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3442252E;
	Sat, 12 Sep 2026 08:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202444; cv=none; b=FaI0Rnn5+eWDd06cArfcfoZBFC1KRSSzI6RS82wKyqRp1EN9zPHdrhcK+vQImWhPex1B5n0B9HrsinrRQ7GQKobIdETVho6aez54Rh121fCzU1ubSKVNpLGD4paA3aGjvDNJQT/r9KimPldSF4uc3SudXMa7vUyM2lA9yUaKpuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202444; c=relaxed/simple;
	bh=9Mkn3IuICuTTjUVu79cX/z7kxiLhqXu1JdNVxsvpYgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTXnoutMxR7L+Okg02Rve99yN1XNM95xBzfkmZhnKH9QpJ7dC9bt+bi/6IM8glPiOL2sSqktHy1O52fvbhWCDGFoStpUOz+vF6F8oNVGpI6X+fICM5A77plBnBjPOjys4dOTZKsS99CHz3j09OHJtN9u1uO1oV+vUTmtlyVKQYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6eg4Ok9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6eg4Ok9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68FD1F000FF;
	Sat, 12 Sep 2026 08:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202443;
	bh=DG0CdS0poftaLMXGj8F848SkZMLQEgNNaLIQVV2EgV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6eg4Ok9nvRcLiWz26wVLkOA9a8eL8U/WfJchZP6qfMdBNFaj/yYLbaiK0enR7/6F
	 eXYC21HWFnDE7tRULsax3UiTi92BZkv08g0HBJ1qUvRgxI2VJGbuVpsG6DMY1rWGgv
	 THTim2Nl0tCUWF/O4f4AJi0IMirmhLbpXJrBn7JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1205/1815] regulator: qcom-rpmh: Fix PMIC5 BOB bypass mode handling
Date: Sat, 12 Sep 2026 08:49:15 +0200
Message-ID: <20260912065717.296644819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 73856e3df337a..ef5523ff427b8 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -111,6 +111,7 @@ static const struct resource_name_formats vreg_rsc_name_lookup[NUM_REGULATOR_TYP
  * @hpm_min_load_uA:		Minimum load current in microamps that requires
  *				high power mode (HPM) operation.  This is used
  *				for LDO hardware type regulators only.
+ * @pmic_bypass_mode:		The PMIC bypass mode value.
  * @pmic_mode_map:		Array indexed by regulator framework mode
  *				containing PMIC hardware modes.  Must be large
  *				enough to index all framework modes supported
@@ -125,6 +126,7 @@ struct rpmh_vreg_hw_data {
 	int					n_linear_ranges;
 	int					n_voltages;
 	int					hpm_min_load_uA;
+	int					pmic_bypass_mode;
 	const int				*pmic_mode_map;
 	unsigned int			      (*of_map_mode)(unsigned int mode);
 };
@@ -311,7 +313,7 @@ static int rpmh_regulator_vrm_set_mode_bypass(struct rpmh_vreg *vreg,
 		return pmic_mode;
 
 	if (bypassed)
-		cmd.data = PMIC4_BOB_MODE_PASS;
+		cmd.data = vreg->hw_data->pmic_bypass_mode;
 	else
 		cmd.data = pmic_mode;
 
@@ -767,6 +769,7 @@ static const struct rpmh_vreg_hw_data pmic4_bob = {
 	},
 	.n_linear_ranges = 1,
 	.n_voltages = 84,
+	.pmic_bypass_mode = PMIC4_BOB_MODE_PASS,
 	.pmic_mode_map = pmic_mode_map_pmic4_bob,
 	.of_map_mode = rpmh_regulator_pmic4_bob_of_map_mode,
 };
@@ -975,6 +978,7 @@ static const struct rpmh_vreg_hw_data pmic5_bob = {
 	},
 	.n_linear_ranges = 1,
 	.n_voltages = 32,
+	.pmic_bypass_mode = PMIC5_BOB_MODE_PASS,
 	.pmic_mode_map = pmic_mode_map_pmic5_bob,
 	.of_map_mode = rpmh_regulator_pmic4_bob_of_map_mode,
 };
-- 
2.53.0



