Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425811FBEB0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301915; cv=none; b=nI3X4oaqocVmygzVKjRSnK1+Eaj+CZZLcxwjZnKQT9nHATUXOMCY7FKIIiqFOaA8EH2po+ZTaV9uDrMkWrB02v1vXl4I+pOmlwf94ykgXNbCb1ZIpuwb9Yiqomtk59S/iZWXXIP+cfH5JFoRX97rYr/dvuIJq9yoGIVkJ5o/TLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301915; c=relaxed/simple;
	bh=LqouKln1HkUR3sanZFx7v6Kcl7Ca++KCYXaFyXqZxbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4imF3OtZkS6PwhwH64/2wDm+D24Iq7+N86GKBipndce3N2ujdzsZ98XGKfnH5SYC/7lUHxKIsGdD4lx7OHPGlFz9/4JD9x6n8tJhiqzRNgRrYKgMDhE1Gax6l4ZAn9QXxQUIZCOllWuQzJombN9WlsnOAQilEdSg/QcNz9TD4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lmp1AgSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lmp1AgSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D835C2BC87;
	Sat, 28 Feb 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301915;
	bh=LqouKln1HkUR3sanZFx7v6Kcl7Ca++KCYXaFyXqZxbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lmp1AgSK3EC612VLWR40yVLUdnDT/iNscpn64Qg9gHXT7PLVm3FGxr/7GuSvDKODX
	 hZ9qN7J+2xskAO5N2S7ipqpv5QYRtNrg981IHwvMYr+WQIuOUzoJiNIpFkoIfEwORG
	 VZCEYfad4Mmz4e4mgj275L4LbUFzASqtnZG0ShHTMJNTj97uoYTwO3SUeWTVr7Y1Vf
	 5DbQsFHVO8R1itorlRouY0fpe8OLnyUw6Hy0PH6P1YH0p9CCsdqTI3QHVcK6+cKuwU
	 aOsLTq+dk7Syaq7uGZGKXa8OWB5RHZIJYDXvbhCkzCVESNc+SicVTOqgxLXgru30T+
	 sBpA0FPVkcv2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/385] pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition
Date: Sat, 28 Feb 2026 12:59:29 -0500
Message-ID: <20260228180011.1568201-347-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 9791d9ba5087c..4e90b29640ff0 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
@@ -73,7 +73,7 @@ static const char * const i2s1_ws_groups[] = { "gpio7" };
 static const char * const i2s1_data_groups[] = { "gpio8", "gpio9" };
 static const char * const wsa_swr_clk_groups[] = { "gpio10" };
 static const char * const wsa_swr_data_groups[] = { "gpio11" };
-static const char * const i2s2_data_groups[] = { "gpio12", "gpio12" };
+static const char * const i2s2_data_groups[] = { "gpio12", "gpio13" };
 
 static const struct lpi_pingroup sm8250_groups[] = {
 	LPI_PINGROUP(0, 0, swr_tx_clk, qua_mi2s_sclk, _, _),
-- 
2.51.0

