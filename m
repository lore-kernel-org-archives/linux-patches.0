Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B901EEE8;
	Tue, 23 Jan 2024 00:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969520; cv=none; b=on7JqsTmZkfR8P+Yt1lZXrL2U5AbdLYj9FQpF+AEZ35nYr4aORkIAVGAL2RYkBxofiPkf2lOhXKePSCP/GvTp9+QzqJ+lHGLY8twXklp2z4WzWVcGrjzzP0Y6bpel2wGFjB9x2vXY8Y4Q75+lvt6iZ8vibd2tscJItZ5+YNehPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969520; c=relaxed/simple;
	bh=KmXTxCnnwHgMco5hU0CgAmGgeQyIqdUbJBUgHUjVRCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqKtfIYa8TMYgzedU3zz6B/XguRpN4TYgu3WmdK1qmA4H5D4xeV9lKwOSgAcD+fLNjHeZ+91dGy7NeEjR4Lc8+VIPtBGBO06FyUaYLOo3wmYusRgwP4o3kMb/0PMF6hU9AvRrbrmk00fOs91vTb4O/5w/89APV1wZchLLsoSpuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7KnhHz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7KnhHz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FFEC433A6;
	Tue, 23 Jan 2024 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969520;
	bh=KmXTxCnnwHgMco5hU0CgAmGgeQyIqdUbJBUgHUjVRCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7KnhHz9wTwMTREWpryJPgcdYY/XY1eT4RH0rnTkNfdSbXJ9JN2OIqWInD/WtPuxf
	 90RpfESQmyKkv2hlPXexDbaIeEcD9cwaL1kV2kG3+fsXH1lvrgVrRUgZfZYJTRcj0w
	 ZGxmdJkp/+5lVafCWXScee5y16COdBWoK/0JAaV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 302/641] clk: qcom: gpucc-sm8150: Update the gpu_cc_pll1 config
Date: Mon, 22 Jan 2024 15:53:26 -0800
Message-ID: <20240122235827.362117385@linuxfoundation.org>
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



