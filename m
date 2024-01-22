Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DE5651B0;
	Tue, 23 Jan 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971569; cv=none; b=j1ESqeKqFcuPrRQ0C4je1pOdXckFPqhdWBrzwXzutvLe9eSKesUodWAu6FrL2/S/SLoyzayRJlDhDTml5kX6Q0ixSO3u8DDy38hkTFsnDi9HLdTUPGsDVKnMLiGjGhoW9jW5ungeod12R83oC9mKajcWZhBXtbq1vUoLVCaDST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971569; c=relaxed/simple;
	bh=Arre9bIU4fkvSl9W9Dn4VMsfoOTGygg2C4xrlnqCo6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcKDZ0vym19vcuy0Iz8WgQ1ZYQLb3fu31jW1v1bQtL1MdSwflD7WMxUe3sh2IkY8dtYY7Vut6ehcL5Kwi6yJ9jS0j7cWCxB8qbaTzqL8VmZF/CidiEK7tqICdvpRAtkNHXcnA7VwVJ6BOLq5UBuZ/+ho1DS0F1+fuxX/LrZaIFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4GpOpNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4GpOpNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8F9C43390;
	Tue, 23 Jan 2024 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971568;
	bh=Arre9bIU4fkvSl9W9Dn4VMsfoOTGygg2C4xrlnqCo6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4GpOpNQAKpD8aJNY2DZFJ1mGQPl1o4/nKzM/pYW2tuOL2cYwP0HW20RYI3YvtCfO
	 U9YcZyRb6n90ozwuAasPi+pOqmHChIP8ksh0Q0hKLO71Dse79f+CTS4ti4dUC2Wnwz
	 brkznEmt2y0aSUlca+wGgwKXsHwhw5kHVFne3neY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/286] clk: qcom: videocc-sm8150: Add missing PLL config property
Date: Mon, 22 Jan 2024 15:58:03 -0800
Message-ID: <20240122235738.982036515@linuxfoundation.org>
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
index 03697a7910fa..61089cde4222 100644
--- a/drivers/clk/qcom/videocc-sm8150.c
+++ b/drivers/clk/qcom/videocc-sm8150.c
@@ -37,6 +37,7 @@ static struct alpha_pll_config video_pll0_config = {
 	.config_ctl_val = 0x20485699,
 	.config_ctl_hi_val = 0x00002267,
 	.config_ctl_hi1_val = 0x00000024,
+	.test_ctl_hi1_val = 0x00000020,
 	.user_ctl_val = 0x00000000,
 	.user_ctl_hi_val = 0x00000805,
 	.user_ctl_hi1_val = 0x000000D0,
-- 
2.43.0



