Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCDC28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CA3C433EF;
	Mon, 30 Jan 2023 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086890;
	bh=aH5unU8TfgzYcKYYA1/3+3JaY9ipWGLSX8E0g004OYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XA4WqeqmfmRdPsqUpwOXZlJvvinqz+6ZDBDrmrTYBJqHJ/T+xoIkBVUFrSg4MaTz
	 GLgaHJ2fvY6hLJQKxGYjPXlznf44VZaTUF8zMtX57COzB9sfpKo+DzZbyO7CCZySFY
	 yGDB2jPDqpYM6B+cxcUID6lFi9MEhRjlM8Kc4Y1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/313] interconnect: qcom: msm8996: Provide UFS clocks to A2NoC
Date: Mon, 30 Jan 2023 14:47:45 +0100
Message-Id: <20230130134338.077249760@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 60426ff08af6a21275d9c879c0dfb09406469868 ]

On eMMC devices the bootloader has no business enabling UFS clocks.
That results in a platform hang and hard reboot when trying to vote
on paths including MASTER_UFS and since sync_state guarantees that
it's done at boot time, this effectively prevents such devices from
booting. Fix that.

Fixes: 7add937f5222 ("interconnect: qcom: Add MSM8996 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> #db820c
Link: https://lore.kernel.org/r/20221210200353.418391-3-konrad.dybcio@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8996.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index c2903ae3b3bc..7ddb1f23fb2a 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -33,6 +33,13 @@ static const char * const bus_a0noc_clocks[] = {
 	"aggre0_noc_mpu_cfg"
 };
 
+static const char * const bus_a2noc_clocks[] = {
+	"bus",
+	"bus_a",
+	"aggre2_ufs_axi",
+	"ufs_axi"
+};
+
 static const u16 mas_a0noc_common_links[] = {
 	MSM8996_SLAVE_A0NOC_SNOC
 };
@@ -1859,6 +1866,8 @@ static const struct qcom_icc_desc msm8996_a2noc = {
 	.type = QCOM_ICC_NOC,
 	.nodes = a2noc_nodes,
 	.num_nodes = ARRAY_SIZE(a2noc_nodes),
+	.clocks = bus_a2noc_clocks,
+	.num_clocks = ARRAY_SIZE(bus_a2noc_clocks),
 	.regmap_cfg = &msm8996_a2noc_regmap_config
 };
 
-- 
2.39.0



