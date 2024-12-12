Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EC0226171;
	Thu, 12 Dec 2024 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018404; cv=none; b=sLZcnaQSdtv6wG7xqA6a7agzcwjKVfEOqO4OmH60bSXt6Agfe/JXXoQZzMAq4Oiuc1+8IZ7WD9kfdrBRpIvDSwYJ8Towy70D5KQCvU4PgbGzZT1TbrOwrSEaAPFEpvD2b2h6yKH8YY6j8mcZMmyRV4Nz+kRLUQ7Ux2hz9A63dl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018404; c=relaxed/simple;
	bh=B1569Kk7cQSsUAqa2o2ZGGnPqgKrSMRPys2tfKM+1ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfBN2ykD+n9Km8CaOZxnP9y4P3jgyK0VISjSOFZCI7InxHh8SNaxmOI2vuCwzgqEoYfKRgvgUpGzfDCiRb3+EiaQ6HSz91P1UZuz/lWg89MVscugo8eNk9+zb1KhmNqGhqwNNLqDe7B99E7PuO0UEK4oUK2JJX0bL98HQZuW4RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yomiwpc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yomiwpc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89A4C4CEDD;
	Thu, 12 Dec 2024 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018404;
	bh=B1569Kk7cQSsUAqa2o2ZGGnPqgKrSMRPys2tfKM+1ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yomiwpc7CAee6Lp7D3+7eJj8Zurf/BkEW6ZYHC4tG747SBN9IBzM2ONS/yWXhoBOL
	 uXn1qBIvjaK9pLZMirlAXgoRIwAI76j7MdxcnIOXyZ1lNE0auP2Mc9Q7iPiWp6yxgt
	 jD8ivk9y0V/DpU6G0Srb4m5k197U2nt9PHTVSeIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/356] thermal/drivers/qcom/tsens-v1: Add support for MSM8937 tsens
Date: Thu, 12 Dec 2024 16:00:02 +0100
Message-ID: <20241212144255.762447814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit e2ffb6c3a40ee714160e35e61f0a984028b5d550 ]

Add support for tsens v1.4 block what can be found in
MSM8937 and MSM8917.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20241113-msm8917-v6-5-c348fb599fef@mainlining.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v1.c | 21 ++++++++++++++-------
 drivers/thermal/qcom/tsens.c    |  3 +++
 drivers/thermal/qcom/tsens.h    |  2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index dc1c4ae2d8b01..1a7874676f68e 100644
--- a/drivers/thermal/qcom/tsens-v1.c
+++ b/drivers/thermal/qcom/tsens-v1.c
@@ -162,28 +162,35 @@ struct tsens_plat_data data_tsens_v1 = {
 	.fields	= tsens_v1_regfields,
 };
 
-static const struct tsens_ops ops_8956 = {
-	.init		= init_8956,
+static const struct tsens_ops ops_common = {
+	.init		= init_common,
 	.calibrate	= tsens_calibrate_common,
 	.get_temp	= get_temp_tsens_valid,
 };
 
-struct tsens_plat_data data_8956 = {
+struct tsens_plat_data data_8937 = {
 	.num_sensors	= 11,
-	.ops		= &ops_8956,
+	.ops		= &ops_common,
 	.feat		= &tsens_v1_feat,
 	.fields		= tsens_v1_regfields,
 };
 
-static const struct tsens_ops ops_8976 = {
-	.init		= init_common,
+static const struct tsens_ops ops_8956 = {
+	.init		= init_8956,
 	.calibrate	= tsens_calibrate_common,
 	.get_temp	= get_temp_tsens_valid,
 };
 
+struct tsens_plat_data data_8956 = {
+	.num_sensors	= 11,
+	.ops		= &ops_8956,
+	.feat		= &tsens_v1_feat,
+	.fields		= tsens_v1_regfields,
+};
+
 struct tsens_plat_data data_8976 = {
 	.num_sensors	= 11,
-	.ops		= &ops_8976,
+	.ops		= &ops_common,
 	.feat		= &tsens_v1_feat,
 	.fields		= tsens_v1_regfields,
 };
diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index ee22672471e81..0aff3318aa19a 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -1118,6 +1118,9 @@ static const struct of_device_id tsens_table[] = {
 	}, {
 		.compatible = "qcom,msm8916-tsens",
 		.data = &data_8916,
+	}, {
+		.compatible = "qcom,msm8937-tsens",
+		.data = &data_8937,
 	}, {
 		.compatible = "qcom,msm8939-tsens",
 		.data = &data_8939,
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index 2805de1c68279..b94a84c94e29a 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -642,7 +642,7 @@ extern struct tsens_plat_data data_8960;
 extern struct tsens_plat_data data_8226, data_8909, data_8916, data_8939, data_8974, data_9607;
 
 /* TSENS v1 targets */
-extern struct tsens_plat_data data_tsens_v1, data_8976, data_8956;
+extern struct tsens_plat_data data_tsens_v1, data_8937, data_8976, data_8956;
 
 /* TSENS v2 targets */
 extern struct tsens_plat_data data_8996, data_ipq8074, data_tsens_v2;
-- 
2.43.0



