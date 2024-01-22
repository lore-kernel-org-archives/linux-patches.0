Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5A612BEB9;
	Tue, 23 Jan 2024 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971418; cv=none; b=eoC723ercCFQsK49n04LBAUGwGF20JEptWPbHWwomhi0/f60n7Sw0mktFKiyv4/bF1YLDM0UoBNW/vx6k33PwdytPJK+ESXz24aCqW8Obw+zlswej8iSy+LRHuTi9R0epG1m8S3/fKjBpdaUlrPef4eQk+UH2agjUqskn5IcBOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971418; c=relaxed/simple;
	bh=PVaGru2tEWbaTb8PMhWfalqAuHFfnI8U7AuR1aczkR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEt5yeO9X+goQibo53egglOXdClkOIXLP+vbM5uSUFDVpwzfWEWCUrnAHm1vy62Zp/BWTV+bki4PCphfRlFV9UfX6dKO0uDsFi0wtHi/qdOkICaczSYHqH0v/K7cu4SOZD1I2buQE8GgoPc/U0CLoPfbxWQqjrPRYRJhMRuw1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1X26LqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1X26LqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2896DC433F1;
	Tue, 23 Jan 2024 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971417;
	bh=PVaGru2tEWbaTb8PMhWfalqAuHFfnI8U7AuR1aczkR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1X26LqQFLsatAJF8TaI5gcedp8Nd7foptQ8uZnp//aEJi93zlpoJ7VkwTb8r9TkZ
	 hHWmG4ltIv+gdfWmv7IqU4LN9ek3oRrdFtW5nL3sQU+lvI+3GZFZtofftfrcWFTOS6
	 5rvZTLTfYSAVYOY/xXH7ZXN82KJhem5xLduBikB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/417] clk: qcom: videocc-sm8150: Update the videocc resets
Date: Mon, 22 Jan 2024 15:56:24 -0800
Message-ID: <20240122235759.404653175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 1fd9a939db24d2f66e48f8bca3e3654add3fa205 ]

Add all the available resets for the video clock controller
on sm8150.

Fixes: 5658e8cf1a8a ("clk: qcom: add video clock controller driver for SM8150")
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231201-videocc-8150-v3-2-56bec3a5e443@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/videocc-sm8150.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/qcom/videocc-sm8150.c b/drivers/clk/qcom/videocc-sm8150.c
index 1afdbe4a249d..6a5f89f53da8 100644
--- a/drivers/clk/qcom/videocc-sm8150.c
+++ b/drivers/clk/qcom/videocc-sm8150.c
@@ -214,6 +214,10 @@ static const struct regmap_config video_cc_sm8150_regmap_config = {
 
 static const struct qcom_reset_map video_cc_sm8150_resets[] = {
 	[VIDEO_CC_MVSC_CORE_CLK_BCR] = { 0x850, 2 },
+	[VIDEO_CC_INTERFACE_BCR] = { 0x8f0 },
+	[VIDEO_CC_MVS0_BCR] = { 0x870 },
+	[VIDEO_CC_MVS1_BCR] = { 0x8b0 },
+	[VIDEO_CC_MVSC_BCR] = { 0x810 },
 };
 
 static const struct qcom_cc_desc video_cc_sm8150_desc = {
-- 
2.43.0



