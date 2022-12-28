Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3FD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E6DC433EF;
	Wed, 28 Dec 2022 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239324;
	bh=qjmxD+5YGuMRDM6VNVHrJ1TKtw9cOCmIcGTAGg7AaA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGkOjeYUYAlYo1RbW1dwgTOg0d6kcNGBVCLUCNes98uwNxyvszqMRfM1NhMTXon/X
	 euDdXgjghoAR51XjlSg8QEI5VuTHGCvVVjfSekdJifT7lf/pr9zdCI6tXR1INORgd6
	 SwZnRSwTRFdBVqSv2EDUd2JYv1vg3OzMzaCuKsKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/731] regulator: qcom-rpmh: Fix PMR735a S3 regulator spec
Date: Wed, 28 Dec 2022 15:35:08 +0100
Message-Id: <20221228144302.388834795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit dd801b2265c81bf0c8b0b4b8f7c1e7bfed078403 ]

PMR735a has a wider range than previously defined. Fix it.

Fixes: c4e5aa3dbee5 ("regulator: qcom-rpmh: Add PM7325/PMR735A regulator support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221110210706.80301-1-konrad.dybcio@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 7f458d510483..27efdbbd90d9 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -1108,7 +1108,7 @@ static const struct rpmh_vreg_init_data pm7325_vreg_data[] = {
 static const struct rpmh_vreg_init_data pmr735a_vreg_data[] = {
 	RPMH_VREG("smps1",  "smp%s1",  &pmic5_ftsmps520, "vdd-s1"),
 	RPMH_VREG("smps2",  "smp%s2",  &pmic5_ftsmps520, "vdd-s2"),
-	RPMH_VREG("smps3",  "smp%s3",  &pmic5_hfsmps510, "vdd-s3"),
+	RPMH_VREG("smps3",  "smp%s3",  &pmic5_hfsmps515, "vdd-s3"),
 	RPMH_VREG("ldo1",   "ldo%s1",  &pmic5_nldo,      "vdd-l1-l2"),
 	RPMH_VREG("ldo2",   "ldo%s2",  &pmic5_nldo,      "vdd-l1-l2"),
 	RPMH_VREG("ldo3",   "ldo%s3",  &pmic5_nldo,      "vdd-l3"),
-- 
2.35.1



