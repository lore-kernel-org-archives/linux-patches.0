Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF66A03B;
	Tue, 23 Jan 2024 02:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975333; cv=none; b=ZPtXf9r0tPhgt/dYAh0DB/GXlIsdSiljrJfXkWkszf5cAgFIszHzcAJs3snBNeo3cs4RJ3ci5Oq9mMqMuuW/oLGtbhEJxc5ySFO4nIO5yY+q8/jhSpfBYOMf7ZFV0lp0cEJOvInXiUl8AASxozd6v1lM6C+OfhDvVEBLgd43VNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975333; c=relaxed/simple;
	bh=ucO3nlOV+gW1wpSIaDPw2iFZ0kn/58eFGxy45m99CDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXg4bqchY1hon2JIAbwxHzULRIDGI5nanCInKsWzuxPN1CBisCyW2ot9IOV0UyWK2bwaQPq/3W8xMK2BiizrArK0ixO7KHDcua9tHiZ6InIk/n12UAbAYQQP0dte8lSLVBgWw3PKaEmlpswBlzXacKP3HUOhpft7AshioIc798U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2apc2yUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2apc2yUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C65C43390;
	Tue, 23 Jan 2024 02:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975333;
	bh=ucO3nlOV+gW1wpSIaDPw2iFZ0kn/58eFGxy45m99CDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2apc2yUcvVu+32UI8+Q+rwEYZqivyjBm9y+F1gZ62vyDoK52cqJSl8oV5dZl3D93l
	 kulcd197GcXklRbXOOUZtL32tXwt52cHnOC0zBam35fTV3Rp5sptKQe99MHByYT9p3
	 A9yfwEQbhlzIms3tdOeQlzK07LV3U/Mzmb1E3OZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/583] clk: qcom: videocc-sm8150: Add missing PLL config property
Date: Mon, 22 Jan 2024 15:55:47 -0800
Message-ID: <20240122235821.075454099@linuxfoundation.org>
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

[ Upstream commit 71f130c9193f613d497f7245365ed05ffdb0a401 ]

When the driver was ported upstream, PLL test_ctl_hi1 register value
was omitted. Add it to ensure the PLLs are fully configured.

Fixes: 5658e8cf1a8a ("clk: qcom: add video clock controller driver for SM8150")
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231201-videocc-8150-v3-3-56bec3a5e443@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/videocc-sm8150.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/videocc-sm8150.c b/drivers/clk/qcom/videocc-sm8150.c
index 6a5f89f53da8..52a9a453a143 100644
--- a/drivers/clk/qcom/videocc-sm8150.c
+++ b/drivers/clk/qcom/videocc-sm8150.c
@@ -33,6 +33,7 @@ static struct alpha_pll_config video_pll0_config = {
 	.config_ctl_val = 0x20485699,
 	.config_ctl_hi_val = 0x00002267,
 	.config_ctl_hi1_val = 0x00000024,
+	.test_ctl_hi1_val = 0x00000020,
 	.user_ctl_val = 0x00000000,
 	.user_ctl_hi_val = 0x00000805,
 	.user_ctl_hi1_val = 0x000000D0,
-- 
2.43.0



