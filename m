Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5048B6775D;
	Tue, 23 Jan 2024 02:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975302; cv=none; b=f26UKLTfZhSgi5S6y3S6jVIaiUaFP3NJyMc/Mo12bN0tnjlMxsvoaMzZyysYvZNKof6ZbfmW4LsChlAYq6NMZ8ulcmNapdP3ZQsc7BISLvZVHeXkY4rw7zHyhXiT5KY0cQuOYEv/cHMFragIT0r7QIxFg6DJVV60dbhE+spv1V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975302; c=relaxed/simple;
	bh=e9UAed4bJarMeRhC9hkIBm3gkw9GhCdY69S3twQAVMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS+ydB8K83b1PeL01uQ8P5KTdXfx/tbh1uobrhAnzTvvIZK0o0QbyYspj6M+asQ0THBoi0JssBPcgunhtAaPPS74p0V42rUW/pWhnUnFtuOqy6oGH5N8HypOBPl2etq49jFTKj77thV/M5pu1Q++HZazTTOmkiXh+tP8RMP1kEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtsVAkAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtsVAkAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0E6C43394;
	Tue, 23 Jan 2024 02:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975302;
	bh=e9UAed4bJarMeRhC9hkIBm3gkw9GhCdY69S3twQAVMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtsVAkAU2zCU331PrDc7+sUZe/NrAU80tNNiCHWeqVmBRO7PUWTJTlCpmyNWAQNZq
	 cn9IwLJe6kyEKc2C/69qQQWvLmaHDakc2uG1vlkKTa7XK+nX0sh1JpK1YhdYb3EDe8
	 1xvpOwQOpJ45fvSgVmb0AePX2u6up3v08Toa+urY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/583] clk: qcom: gpucc-sm8150: Update the gpu_cc_pll1 config
Date: Mon, 22 Jan 2024 15:55:18 -0800
Message-ID: <20240122235820.172396405@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



