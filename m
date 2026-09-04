Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB56421F0F;
	Fri,  4 Sep 2026 06:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502520; cv=none; b=TaECX5zsvvJlNywv5LGnC47+SD98FRvx6eKwS6j4OgilILLfwklOoVF9U1VKHhiURuxjUDNsl5RHPqFv7WSRWMeilvHbzGqDTiH40cbSNmFIZizporRwZweib8PbNKJbvSut/57Q0GN0LgD8zEoqNVV3ZNcoUxSukV9aRRKRG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502520; c=relaxed/simple;
	bh=bxpYq0tXAfoDGPYmoNOgrbuKONUkvTNJDP5/hbUF4ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCi+cuwduhF5PwMonsQT53FhXryAsFHWKV/y+HU16Rck+V8NIqSdf93vwljwuNvVhAGFFi+BljEttlg+aaz7Skix2WfI24QIrMrmUbg1YoGx5GcR3RuOc95hT+fywtjKk9PFvU1z9m8arxbypoMts79VNxtbkNKrxei/YWOTyoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ2tC5Px; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ2tC5Px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110C41F00A3D;
	Fri,  4 Sep 2026 06:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502519;
	bh=SPubsipdYR8ugPDMsfmiXswHvUcksbqfSCnn4sSBih4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQ2tC5Pxf/tTUjlEU7I0dYWHcB4h1PYVJ3o8oN0kkp3bSV8qaJOBJc0xRPdPvZRJ2
	 m59LdwtJ0iJkaSTlmVCkY1RhM2UyktJ3XayshDmkgiykgK6mPXFiRTNA1yC6vpB+TA
	 7oeF/Je9auwLiehKGbqDmDSzCfFKUua19TPedXD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 237/403] regulator: qcom-refgen: correct the regulator type to CURRENT
Date: Fri,  4 Sep 2026 07:00:40 +0200
Message-ID: <20260904045740.260488817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit 05dfeb2d0ccf87a7b92cd149a393b8423a26a04e upstream.

As per the REFGEN IP team, this block supplies the reference current to
the PHYs in the SoC. So, correct the regulator type to REGULATOR_CURRENT
to match with the HW behavior.

Fixes: 7cbfbe237960 ("regulator: Introduce Qualcomm REFGEN regulator driver")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260617-ipq9650_refgen-v4-1-c505ea6c6661@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/qcom-refgen-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/qcom-refgen-regulator.c
+++ b/drivers/regulator/qcom-refgen-regulator.c
@@ -66,7 +66,7 @@ static const struct regulator_desc sdm84
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= qcom_sdm845_refgen_enable,
 		.disable	= qcom_sdm845_refgen_disable,
@@ -82,7 +82,7 @@ static const struct regulator_desc sm825
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= regulator_enable_regmap,
 		.disable	= regulator_disable_regmap,


