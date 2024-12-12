Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF46B2397A8;
	Thu, 12 Dec 2024 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021339; cv=none; b=odeWYW07KeXK3Ejydq1k5hcCgueigZBXjfohEpwb+ST+8BufrlUiuRUy32/dIiwII8kKr7tD3E6YuH2iL1u53kRo/de9c47ch/agMrvAr10doWOTfFX+AjGy1Nhp/WyCJw66VItQeluWO+2KlJ4ZWj0eqp/lJkeF+VFu9QeC2PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021339; c=relaxed/simple;
	bh=3XjKXGiMDPx8O03KyPYilV8g8DJfAlb469HHQlaByeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFruhkHO2tq6US7dKURv9YScja3R/VmkPGxhiZnrNpUeiGwQ8+NzXfV3tdjYz/FlohbsJq+eAKb7hx8heGf1HHXH2/JYnD6cHZ/X5zB9o+c/6RnC1FSXgw3NnIeKHHvyFRniEufEBzcV2F5XCyVLsp0y858yGoLQSsYTEzkDv9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUttgiD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUttgiD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5208DC4CECE;
	Thu, 12 Dec 2024 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021338;
	bh=3XjKXGiMDPx8O03KyPYilV8g8DJfAlb469HHQlaByeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUttgiD6VCPvCVaBXdQsJFs8OwJVxAB9yoVzQvzk2RmiyYvRa+T6dVW4kSUIezL/s
	 d9q9v6zRimsR1lKmUwnwyP4kB3OSKCBrYuRRjh3CniFG2h5ZyQcJOxe8ZZs1x8FzuC
	 Mc0k+U7yldnFgamaDlelt7HChe6Vb+yBDFemfn2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 709/772] pinctrl: qcom: spmi-mpp: Add PM8937 compatible
Date: Thu, 12 Dec 2024 16:00:54 +0100
Message-ID: <20241212144419.195393453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit f755261190e88f5d19fe0a3b762f0bbaff6bd438 ]

The PM8937 provides 4 MPPs.
Add a compatible to support them.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/20241031-msm8917-v2-4-8a075faa89b1@mainlining.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c b/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
index 6937157f50b3c..148cc107b7aff 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
@@ -964,6 +964,7 @@ static const struct of_device_id pmic_mpp_of_match[] = {
 	{ .compatible = "qcom,pm8226-mpp", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8841-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pm8916-mpp", .data = (void *) 4 },
+	{ .compatible = "qcom,pm8937-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pm8941-mpp", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8950-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pmi8950-mpp", .data = (void *) 4 },
-- 
2.43.0



