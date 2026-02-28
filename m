Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C839B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302630; cv=none; b=LdxCW2f5QKMcSTOsFBhB8mwNrHRgHgIMLUkKdCx05Rt5N/8tKESwpMYMuvC9V0tZumWuY7n+SwfrZ9ON8J8jj1jgDFUTDXQaOFh2DmsoOZ0t35ZSaiKF5iV3/36t2XfmlsmzDBbehyXgoBHBrt26M6QCNeOneLIzJYCJD+atb1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302630; c=relaxed/simple;
	bh=hKiIiP1O+Vn2+TTtA1YiNQ6Yn+w4gybn1L/M7ivmQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvZfh/oBkQMksxkF6x/w6ltd1G9khHf1ugU6ecT4sJ9oMNP/wwWAh+yX9MuQBaJOD4zH6CfV9yhVHXhsTUoxOjDR3ewvsD7PDt51/KLQEX/jvAuJUIgTumBIL0OGZP1HD3XPK31nF+keRSKiy0BrINNwxH5vjkugFQEfE79HFYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7kLOiau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7kLOiau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758DAC116D0;
	Sat, 28 Feb 2026 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302630;
	bh=hKiIiP1O+Vn2+TTtA1YiNQ6Yn+w4gybn1L/M7ivmQZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7kLOiauMKfRCVi36m5mBaq4+TqrYf3fpFVtOLNwdLL0u1sldBVc9Gs1soX080ZR2
	 4o+YF9VlnI7xNA9kYWVbgcpKduujJe6s1O3ncZGSZ98BXPZTOKXAWgv6m3QYa1TYMA
	 obgMS6Sj84HUAhcvBdg99Bdt9nAN3K5p81KLpB7gyWQDSGmnqlE5bF+l7oIYXsKiZq
	 FU5SJUeOuG01v44YhoXbtfuWTWXly7VByc+UP0zmpBIw0RY9VaecUdShPq+hfGjLuC
	 8b7uxkltIW0tg/Yjlq0rLJSDKwpdo4Bom9e6Ht8t2zhBk0nTAFHFyZ/PwKyWcA5HXz
	 nC3OzPU3G/L3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/164] pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition
Date: Sat, 28 Feb 2026 13:14:48 -0500
Message-ID: <20260228181505.1600663-149-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit eabf273c8466af3f033473c2d2267a6ea7946d57 ]

The i2s2_data function is available on both gpio12 and gpio13. Fix the
groups definition.

Fixes: 6e261d1090d6 ("pinctrl: qcom: Add sm8250 lpass lpi pinctrl driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c b/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
index ddbc6317f2a74..422ef44b86423 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
@@ -88,7 +88,7 @@ static const char * const i2s1_ws_groups[] = { "gpio7" };
 static const char * const i2s1_data_groups[] = { "gpio8", "gpio9" };
 static const char * const wsa_swr_clk_groups[] = { "gpio10" };
 static const char * const wsa_swr_data_groups[] = { "gpio11" };
-static const char * const i2s2_data_groups[] = { "gpio12", "gpio12" };
+static const char * const i2s2_data_groups[] = { "gpio12", "gpio13" };
 
 static const struct lpi_pingroup sm8250_groups[] = {
 	LPI_PINGROUP(0, 0, swr_tx_clk, qua_mi2s_sclk, _, _),
-- 
2.51.0

