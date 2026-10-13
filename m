Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B0A3AFD03;
	Tue, 13 Oct 2026 11:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892586; cv=none; b=Wimq25Ih14NcpRPqBZn9qf6EOoAML5v/NHnwQQsyGYVcE0LzW1yo6GzvZeKKTIAg+ElGhhMOuWSxpNkq2FJ906exc2vE28nEDCONpiA5tnOugOWZ1NIIG/FLl9YIMm2Iqitw0F/26Lhulnrf+u9D/dWkzAyAjxoxkqhlb1rUknc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892586; c=relaxed/simple;
	bh=2frUz7OIGGFnwi72Hiw2xs6ki6/d+AhoAs6SA7uYEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUGRuF3rygW1tHm0gyEfFo1F32nIwqePKi0QdiPdtOB3MKERhtld02oW6ITFa2jqlzJdr6xnQLdeK6SOKgCIKzeYYx5EKocg2a2lrWFmzqiEMJxUAPuIsZCv/7AiRBr5sMN+6jyxooRA9ZkL4EBvMW9hX/qgq/RP+1ji0JBPWP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyhGr6Fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyhGr6Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D11F000FF;
	Tue, 13 Oct 2026 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892584;
	bh=1hajsRJGUZdkpmtn8l2eDMFbjN/WmsIMZeh3KU1koi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyhGr6Fx5wyhtnNeBDk9akuCYqZgyTk84YiZSKB9ZjOkT9yCc24l4dCbIOjJTbn6h
	 S54jM833k87ESS2bQi1TmVw9p+T+t4xmriAdhSTMY7mY3yfgI2So8oEPvAOtD6WwOf
	 NoLv2Gsq0Fa3NxAqllyDJstwCiNViZxiOVgfVytg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 178/281] clk: qcom: gpucc-glymur: Mark the GPU CX GDSC as votable
Date: Tue, 13 Oct 2026 13:38:14 +0200
Message-ID: <20261013112859.485849632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 8f3f88309fa4e975ac27368ee945c2c202251a7c ]

The GPU CX GDSC on Glymur is a votable power domain and hence should
not be polled for power-off status during GDSC disable. Also, its
power-on status should be read from the GDS hardware control register.

Accommodate this by removing POLL_CFG_GDSCR and adding the VOTABLE
flag for the GPU CX GDSC, similar to other platforms (e.g. SM8750 and
Milos).

Fixes: 67e645285dd0 ("clk: qcom: Add support for GPUCC and GXCLK for Glymur")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260801-kaanapali-gpu-voteable-v1-1-fe804d24d2e9@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-glymur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gpucc-glymur.c b/drivers/clk/qcom/gpucc-glymur.c
index 001b2454786a0..cac51de20b295 100644
--- a/drivers/clk/qcom/gpucc-glymur.c
+++ b/drivers/clk/qcom/gpucc-glymur.c
@@ -510,7 +510,7 @@ static struct gdsc gpu_cc_cx_gdsc = {
 		.name = "gpu_cc_cx_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = RETAIN_FF_ENABLE | VOTABLE,
 };
 
 static struct clk_regmap *gpu_cc_glymur_clocks[] = {
-- 
2.53.0



