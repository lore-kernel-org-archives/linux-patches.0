Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D483C2D;
	Tue, 23 Jan 2024 00:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969604; cv=none; b=OfLEKW8nQsgIraTs7K82dJNgLmVktp7I4a2OFsEPkCnoJ4eGLcuEyXSXLWt2ASE/n3fh8J34nRrXjbeSrDqW70+lW4bF/Oi+HJ7ed4Myv2qFuPSAwO0OQ/lT/BNf+AHNsLz6bX7zJ4qodGV+hdh2UvAgsS49+LqZmL5/AWPO/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969604; c=relaxed/simple;
	bh=J0BnqyAEPsMC+wGJkii85BZ4EBr6ujxBQKZ8Jylt5SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr2c5+ap38CsVH5rhl2lQJksDDCzIme+yi7Wi+Va9wN+1JzVvTIAUDP+kvpqZxUNmSbD6uPShTnjIlkcDoGS6n6RWDl/jVS3hadSwrEL4DnPJw/M8Rd1BnacGPX57N+b0kYNhdrh1gd0rxZbsjWoonCUPsh+udcqFM0r5ZyIV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXRA5pzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXRA5pzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63383C433C7;
	Tue, 23 Jan 2024 00:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969604;
	bh=J0BnqyAEPsMC+wGJkii85BZ4EBr6ujxBQKZ8Jylt5SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXRA5pzwxkVLvvQ5U/Pa9r4QrtuRYUHDwawmMbXRCYUDLnVcARgpfv9KFNO5NpjwJ
	 4UsOUkb/t2EHdJk5sFgNTiGmi79lrSCUEJdRzCAO2nYbwu+OGKFg6rU1P52Er+9c4i
	 MMHA007akOrV9wDh5HYJP8KI0hRcfCJuUl0V2PTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 352/641] clk: qcom: dispcc-sm8550: Update disp PLL settings
Date: Mon, 22 Jan 2024 15:54:16 -0800
Message-ID: <20240122235828.939820870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit febd251d8775c4fb6e4acd6b5d7b0ed707f4611f ]

The settings in the driver seem to have been taken from an older
release. Update them to match the latest values.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-8-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index aefa19f3c2c5..0b8f0904b339 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -81,6 +81,10 @@ static const struct alpha_pll_config disp_cc_pll0_config = {
 	.config_ctl_val = 0x20485699,
 	.config_ctl_hi_val = 0x00182261,
 	.config_ctl_hi1_val = 0x82aa299c,
+	.test_ctl_val = 0x00000000,
+	.test_ctl_hi_val = 0x00000003,
+	.test_ctl_hi1_val = 0x00009000,
+	.test_ctl_hi2_val = 0x00000034,
 	.user_ctl_val = 0x00000000,
 	.user_ctl_hi_val = 0x00000005,
 };
@@ -108,6 +112,10 @@ static const struct alpha_pll_config disp_cc_pll1_config = {
 	.config_ctl_val = 0x20485699,
 	.config_ctl_hi_val = 0x00182261,
 	.config_ctl_hi1_val = 0x82aa299c,
+	.test_ctl_val = 0x00000000,
+	.test_ctl_hi_val = 0x00000003,
+	.test_ctl_hi1_val = 0x00009000,
+	.test_ctl_hi2_val = 0x00000034,
 	.user_ctl_val = 0x00000000,
 	.user_ctl_hi_val = 0x00000005,
 };
-- 
2.43.0



