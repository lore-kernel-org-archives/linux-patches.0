Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B50346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302236; cv=none; b=peNiEFKpCghssTAheDY9kcMCDyx+kU+XMNFyeYH63MhKKT9fhQ3tZv2uDajEVbO4xkv62V1TipmMnUmbGUImZlKMNhEh1tRn2VgCUhs5iBhm1xznQwO9wfopKjHlz/HY0sSWkH0VIxLLFloujycO0w5N2S3pRU5O04FcJED7zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302236; c=relaxed/simple;
	bh=hKiIiP1O+Vn2+TTtA1YiNQ6Yn+w4gybn1L/M7ivmQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE8fTM1zGLbHNG/OwoeIadmdja9Vtap2RdZQ7phF7ZHqC2VvytMCnmo9xNYq+UKBSYeJCWWjsYbSilpHSyac9ttb5RKP9daElXbcuH4bPbcnesDRM2bfcVB8Bh1V4qXYZbd+SqH1iNCYn/oMLnNFtWj+lCp5cevTL08vTBRrI4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTWgEb0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTWgEb0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCEC19423;
	Sat, 28 Feb 2026 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302236;
	bh=hKiIiP1O+Vn2+TTtA1YiNQ6Yn+w4gybn1L/M7ivmQZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTWgEb0fTUz+jr6xOgB6F9z/iUS2QrXWNCRRUWRwTKsTt1gQ3OlClcWqGysCFoM3+
	 fuUSXasRdkx/zNqGXdhIO68VVmNum/hlx0RR9mgMAWbelDGhVkxMW62l+Uh3ngq4Nh
	 KegGpPfTFFtHpDtnujWi2nQN1hPp59V7mu3tlFjKYx3I9hZg5g6+9A/Ky74D4Trfx8
	 bc0ZtbWYqrRxaJ+ghYA4gkoRXH2EgBy6BrQv4LjbVbvvGiIuHWsWUYNuugvFNbLr3Z
	 HjB1IZz4S/YD0egk5WJ9S33VWyY0U26KT2SANo/uE+rTongsdpqErTd9JKiamnSVN6
	 7l802Auocowbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/283] pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition
Date: Sat, 28 Feb 2026 13:06:29 -0500
Message-ID: <20260228180709.1583486-247-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

