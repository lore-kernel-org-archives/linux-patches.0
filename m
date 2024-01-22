Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38461664B7;
	Tue, 23 Jan 2024 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971664; cv=none; b=mB6ogtl13FmKFOvEsSose0cnXANbcPlstUusvexjifvZ09FGUoAbIb9/046SVDU5Tff+skyThwgqp/jxUGW5MuZ6uupQat5zOWg+n+1nBSpMRtqmeBy3H3E9naGVF1sNFuzlGlpyc9oO4smRWXWE+ku/dmpllKryQoD/tUKZut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971664; c=relaxed/simple;
	bh=uVtXgHEDgaE9jCa8GZBb0+bDgP2oE2GfluBOSsGpgUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jyktng1ndgrIdm4iQ02ZXe8N6AtwfjkugTqLSqvOmHUlAqgTgWbk00jNwjIwON3r0CVHhJbkuCfGQWXcLalO/i6n2S23IpFO9I6j/fnDRh/mQL3Uh87j6JJfKi6zBCCRmaCCL9Vnsis0Qe87xIeqf6nwbLTFA52hOUcOnveRBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcXGBijU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcXGBijU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D98C433F1;
	Tue, 23 Jan 2024 01:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971664;
	bh=uVtXgHEDgaE9jCa8GZBb0+bDgP2oE2GfluBOSsGpgUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcXGBijUoUNUCvhIHnqJ6gPu6TLhhgQ0ylD2/P8ZG9YwlC3Xf8wYM+xmOEPiTPkMt
	 xqkQcTmEDsZgaofS6S66Lor8kkqwx78egy7GfVHmuYNmIOGI10Wrd/JQH2jCtikYnF
	 U482IXL8WEVodelXPm5hVewvWBcFKd1LGK4vbOFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/286] clk: qcom: videocc-sm8150: Update the videocc resets
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235738.944585918@linuxfoundation.org>
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
index 3087e2ec8fd4..03697a7910fa 100644
--- a/drivers/clk/qcom/videocc-sm8150.c
+++ b/drivers/clk/qcom/videocc-sm8150.c
@@ -218,6 +218,10 @@ static const struct regmap_config video_cc_sm8150_regmap_config = {
 
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



