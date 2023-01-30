Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3939928EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92285C433EF;
	Mon, 30 Jan 2023 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086894;
	bh=z0boa9zazSW1EuHD5/almU8HZ4xq9lthdYN9VjRWhHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZy2n984YT4kpgIvWWC8KkA5zN6xlenlGLmBvaCf1oU986G9k7LdoCCJ3Ka6dP1fu
	 cGR5VJJxdUsv4UegPfa9F/oWlr9hiFrrj5vyK4aEs3ECMg6zstwjBIh0aaKoCf59RN
	 o31vhunS4Givovpg/F3pXnEtiDmJeNC9K7upBndw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/313] interconnect: qcom: msm8996: Fix regmap max_register values
Date: Mon, 30 Jan 2023 14:47:46 +0100
Message-Id: <20230130134338.128275638@linuxfoundation.org>
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

[ Upstream commit 4be39d5d86c690c60e2afe55787fc5ec4409d0f0 ]

The device tree reg starts at BUS_BASE + QoS_OFFSET, but the regmap
configs in the ICC driver had values suggesting the reg started at
BUS_BASE. Shrink them down (where they haven't been already, so for
providers where QoS_OFFSET = 0) to make sure they stay within their
window.

Fixes: 7add937f5222 ("interconnect: qcom: Add MSM8996 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> #db820c
Link: https://lore.kernel.org/r/20221210200353.418391-4-konrad.dybcio@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8996.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index 7ddb1f23fb2a..25a1a32bc611 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -1813,7 +1813,7 @@ static const struct regmap_config msm8996_a0noc_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0x9000,
+	.max_register	= 0x6000,
 	.fast_io	= true
 };
 
@@ -1837,7 +1837,7 @@ static const struct regmap_config msm8996_a1noc_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0x7000,
+	.max_register	= 0x5000,
 	.fast_io	= true
 };
 
@@ -1858,7 +1858,7 @@ static const struct regmap_config msm8996_a2noc_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0xa000,
+	.max_register	= 0x7000,
 	.fast_io	= true
 };
 
@@ -1886,7 +1886,7 @@ static const struct regmap_config msm8996_bimc_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0x62000,
+	.max_register	= 0x5a000,
 	.fast_io	= true
 };
 
@@ -1997,7 +1997,7 @@ static const struct regmap_config msm8996_mnoc_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0x20000,
+	.max_register	= 0x1c000,
 	.fast_io	= true
 };
 
-- 
2.39.0



