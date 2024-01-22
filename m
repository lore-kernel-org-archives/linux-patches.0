Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8DE23C6;
	Tue, 23 Jan 2024 00:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969577; cv=none; b=E6eHjn2cQ9algIB06frM864fIHWRc/RvIxgtCw+A5y9ZSMFD4N6KTs0iRzzD+J85W1ut7dQ00yaIyhs97RYwZu5LNjm9S9G5eIDMqWVf7BXZ+85temaA25fcu6UmeQEPEeDqO4eGmrLkFHtRKMksMesSHnoqoJ4IEnFfN1E6n3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969577; c=relaxed/simple;
	bh=MCeVCTpc3KW3W+ARZWsQcRFP3bHHnMfnz4GOOglM3so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYHASUfglqqSDMpM0f8GKhL/gp8zLLzpYqC5zcdGiGM06r649vYAEYr2fHnyiiDBf/AB/9VAV1TApyCgPk6PgZpzOCIG5V0sVeEt9CY42m2rJpUY5ndGKKzii+8BDzSPaR8Dk1mb9yyIX8J7sdBNNO7/DDF70SeJ4X1DJK7LGfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQXYTCWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQXYTCWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1D8C43390;
	Tue, 23 Jan 2024 00:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969577;
	bh=MCeVCTpc3KW3W+ARZWsQcRFP3bHHnMfnz4GOOglM3so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQXYTCWoL5okEg/jUleBOjIuUHsUAuvVNTqyPSnyeBBwcysRtaYF5+J1Z9nOry6mT
	 LWlOGfnqS9XmBL3MXIBm8VyPAHiNWGHJ99ynmvLHXvyp1j4KVxpeB5rNjJ/KVBamZj
	 7Q43zHgB3r42AUCF5gvOjG2MH0Qra20AKLObAVVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 333/641] clk: qcom: videocc-sm8150: Add missing PLL config property
Date: Mon, 22 Jan 2024 15:53:57 -0800
Message-ID: <20240122235828.323896805@linuxfoundation.org>
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
index 1afdbe4a249d..5579463f7e46 100644
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



