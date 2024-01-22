Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FCC5EE78;
	Tue, 23 Jan 2024 01:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974410; cv=none; b=OVd/oEEpQ0DaOSIfGqGcapXhObZZYxqJV5u4OhJynU5MWn2Vu/EjzLO8wV7IV8w9sAYPGX1B8CM8OpffmQLKmQbIuL4apuUDp/EdEGvW0Bqrb5NRQDYqZ2lh5tOqnX7xD8Qs2A0T7obCUYmy7g0ns5Kehmgzg0fD6ITblG3wOOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974410; c=relaxed/simple;
	bh=9WH4Hk+JRK9zHUus7vZ+fQoZqq3vMNg+uZhJLFuJphI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbDQEEwBtMovJ0JaLjcdtF8Brx6F0cLykTA4H+2ARJAxTI0qGz1zZ4ovip9s3O8WXp5ZEsnlDOHZRR46O6K8GteDZMJPu5PI6JYOU+duJXurTBW5SBoypjrXPI9EjJ3QY4Pw2+UEiYGXYCVYaeN0pM5jpadz4KCditMLCv4xBsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSthiYsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSthiYsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C2FC433F1;
	Tue, 23 Jan 2024 01:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974410;
	bh=9WH4Hk+JRK9zHUus7vZ+fQoZqq3vMNg+uZhJLFuJphI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSthiYsp7lVbIls2yJHDkKx2MUHwgk+ftOsPJzpSzBCPFmdVLm2So192ANVDM35La
	 AA8PTh2Erxl5Ry57Qu13hUVXZT/p11eY5zdcIyZxicoCuCgp53jCGhlfc5IjdQ2LdY
	 eUyw9cScJduDXqlw6kt2BJnaBHNzFQmjDUGLsnvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/374] clk: qcom: videocc-sm8150: Add missing PLL config property
Date: Mon, 22 Jan 2024 15:57:50 -0800
Message-ID: <20240122235752.084616976@linuxfoundation.org>
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



