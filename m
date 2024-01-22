Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6275EE62;
	Tue, 23 Jan 2024 01:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974407; cv=none; b=TzzJO7EDkKZpR0gqj/1Il7z+Dkq4Rnviu7v0qFW0RKBJKZr2R1GFSXQPtsa77uFAqPXYxKISsFPHdTsWg/Lr5kICu+41w0tr6nW27aRV7Q7fO7RjH7DBj5INvxYac5xfFWFehTqjPf0We1Ws8YWk7hdTmCvFrKQwIXedltlBHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974407; c=relaxed/simple;
	bh=xlaeMjpUDpnNwJqaklZVDRsKydLOLUR5N/ooyKijPas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPplY97b7qkOUFDutJWVmQkiDIys4Dc/I8LDWsPHeSl+cn4EX917KLrh3Bp8IWagvW8ba7Ja7aQ/1VBzAhyrmWDGYiyAtPaSPHKI9a3UcO0xoTU5GbvSAXs7NeAqIch1voEKW0P6Rf/4lfZtgVrzpgjggBAFsM6TYnIuWjmXGvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17yTKPHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17yTKPHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AF5C433C7;
	Tue, 23 Jan 2024 01:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974407;
	bh=xlaeMjpUDpnNwJqaklZVDRsKydLOLUR5N/ooyKijPas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17yTKPHcLwUU7D0R9vvZkdu7fcZYvHorzQr/BErb5S05x4hQncRJUWjtqyiZ9flgP
	 Y6fwayFAY2GrnzCXoHentegTTJAA1hYL2VgAFPT0gIi5hl76k8x8s01t3p83sPO2iJ
	 akMj7tXeGWTJXlBg1P8Sm6fuvH34yJFb6a9KVV/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/374] clk: qcom: videocc-sm8150: Update the videocc resets
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235752.052856527@linuxfoundation.org>
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



