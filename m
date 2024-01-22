Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B79657A3;
	Tue, 23 Jan 2024 00:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971519; cv=none; b=DB/9T/B50AdoYSBUrI+Bs1wGz3kw9XEgYtD5G7XfoYF4xeH4TajJ1RoI0hdJXhQFg/N1sPrmkiJOfkqp1NlIY8feHbDRKqQF0eI7HLx23U8Xrf1KMdd0eVF11Scov3KuQoZDYUj3YCnvumTXttQdqbY80OxHezrIwDZGKd6dyHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971519; c=relaxed/simple;
	bh=DFuP1XSrQgoqOAXkA83ZFEQ2dR3XQF644d3364YxPaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQcX1exAqYZj4bLZW3wNiPYudFlSz1INySXOswZwH37Do+4F+LJX4VwW/Vi3MJvhnmp+YXLemqL1n0ZoUqbJcIWJqrHd4VIij88M/0WvThjmfifAtThHvKnb0I0jYTqWNg/Dhne3BPaHfb7cy14JmKbogiW6ATRqFHogXt1Xbww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5ORLyoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5ORLyoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487D1C433C7;
	Tue, 23 Jan 2024 00:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971518;
	bh=DFuP1XSrQgoqOAXkA83ZFEQ2dR3XQF644d3364YxPaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5ORLyoUD5YxAMFdG0xzYOKcQGiAYteF06po8uEZa2LhqyVDaGQx8wGtYUqN/YsaN
	 EmglTPH112Gvr9YOoNo1q4mydhDwic6N6RK4bVYmEwW7Moz/rbsGePNl8uqxuCYDO2
	 kTcTUtbVVjMaKeLxB8+4YB7V1nK7Ru479ZdS/Iwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/286] clk: qcom: gpucc-sm8150: Update the gpu_cc_pll1 config
Date: Mon, 22 Jan 2024 15:57:51 -0800
Message-ID: <20240122235738.531561699@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 27c40754b2c7..3d9b296a6e4a 100644
--- a/drivers/clk/qcom/gpucc-sm8150.c
+++ b/drivers/clk/qcom/gpucc-sm8150.c
@@ -38,8 +38,8 @@ static struct alpha_pll_config gpu_cc_pll1_config = {
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



