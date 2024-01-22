Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0263FF4;
	Tue, 23 Jan 2024 01:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974636; cv=none; b=JEMQ3X2EBPg6fUDckQr+E3L6TQ73YzW2qNVbhGuXYeAZDr7b2D9/oMnOpSdnh6CU1O3flS+E5y9SFErtkVycmhURYGT0psrCHoGbzZOPS1whGXXHQMxX5AoSQc8A/5TJRpBHiEr/fAUPpvIU/0HBLqKokp2v12PjCuBpEzEnx58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974636; c=relaxed/simple;
	bh=5ASZxyxJog0BMoB7wPdKDIOqLNRwa1FwkgKudzU8YM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moEJENz2/05DVjv2kZn+WUaBZ1dDvnPVN7LYhcFttRDhrdyIAUA+ErQkZh2ouj6Vc9MnkPqycoNc+BlV7upyIj+mB+Z/XlWoxE9oRM7zVvSvjMXK+mbesvhmUOSEDhFFoJTTkwN6V+h4Isg8dElwfAED/XFmvqW29BwJETx0Ax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFZP1/Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFZP1/Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C423C433F1;
	Tue, 23 Jan 2024 01:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974636;
	bh=5ASZxyxJog0BMoB7wPdKDIOqLNRwa1FwkgKudzU8YM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFZP1/Ss7WmouWUJ7L3fThRP60ikByFN5nCyzMSKnhHcgeqUMKUBTuqsIG3trxm/a
	 Ccf9xDQohKTlUy1688wvgSuc+sZULa9nauKADGrGVmhj5dV/v+49yk7TPJX2oGyot+
	 NLr0Ce0K8ouR0ItI93bNt47ECQacFbQncQvHTnaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/374] clk: qcom: gpucc-sm8150: Update the gpu_cc_pll1 config
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235751.602820708@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 6ebd9a4f8b8d2b35cf965a04849c4ba763722f13 ]

Update the test_ctl_hi_val and test_ctl_hi1_val of gpu_cc_pll1
as per latest HW recommendation.

Fixes: 0cef71f2ccc8 ("clk: qcom: Add graphics clock controller driver for SM8150")
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231122042814.4158076-1-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sm8150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sm8150.c b/drivers/clk/qcom/gpucc-sm8150.c
index 8422fd047493..c89a5b59ddb7 100644
--- a/drivers/clk/qcom/gpucc-sm8150.c
+++ b/drivers/clk/qcom/gpucc-sm8150.c
@@ -37,8 +37,8 @@ static struct alpha_pll_config gpu_cc_pll1_config = {
 	.config_ctl_hi_val = 0x00002267,
 	.config_ctl_hi1_val = 0x00000024,
 	.test_ctl_val = 0x00000000,
-	.test_ctl_hi_val = 0x00000002,
-	.test_ctl_hi1_val = 0x00000000,
+	.test_ctl_hi_val = 0x00000000,
+	.test_ctl_hi1_val = 0x00000020,
 	.user_ctl_val = 0x00000000,
 	.user_ctl_hi_val = 0x00000805,
 	.user_ctl_hi1_val = 0x000000d0,
-- 
2.43.0



