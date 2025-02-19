Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5793D1DE2BF;
	Wed, 19 Feb 2025 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956360; cv=none; b=Y6dJlugGzpG1f42JxgOTztUKW7YCd1z44h529kMz9YeId1wJJlEFPXsdao0kbIz+eGzvwbDgnw2WFRwNRdZ1dKGlaFgzmmX8JynnN9aYVq9A1t5SncUzla0ORQShOWHj6pNTZsVbLt432rDClkszonM91R2k8co7A0TZMjS2ZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956360; c=relaxed/simple;
	bh=QF//QZAtBnL24yrHRrESzPT264FdKvT3T7L/v5RnLoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy498c6HaS/GJ4Jg3VAGOy69BXTM0VMQ5rjlwUQr6I7jtj1OLpIjRj6sSP03XcZC9OIybz9DBJYTDt9OEI2o6lPRYx5nylJw4PtojEHcQ9Y/xLiqdCUTSQcxqFrCQ9yyGnE4fq6uSm8rCtgKpvNqhi1Wb2XOef/lFBhvcqh1F1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOEMxcI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOEMxcI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA5EC4CED1;
	Wed, 19 Feb 2025 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956360;
	bh=QF//QZAtBnL24yrHRrESzPT264FdKvT3T7L/v5RnLoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOEMxcI48oKLQ3y64oGqk8QSehnwypf2xyXBdchmbDElySJXfHn72/7SvlJ8qVfiu
	 MBt+5Vsn8RWbfQA+8sWRoq3D3NRfvcX3UD/DM/ATJKq+mV8YzkwFvCTk7rE7xrlkMJ
	 B35GkgRtnsX5fCQKw6ODutVPedvU2lIgD/1Wg4K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/578] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property
Date: Wed, 19 Feb 2025 09:22:37 +0100
Message-ID: <20250219082658.994002443@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 02e784c5023232c48c6ec79b52ac8929d4e4db34 ]

The LP5562 led@1 reg property should likely be set to 1 to match
the unit. Fix it.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241006022012.366601-1-marex@denx.de
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index 3bbafb68ba5c5..543282fe2abbd 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -65,7 +65,7 @@
 		};
 
 		led@1 {
-			reg = <0>;
+			reg = <1>;
 			chan-name = "button-backlight1";
 			led-cur = /bits/ 8 <0x32>;
 			max-cur = /bits/ 8 <0xC8>;
-- 
2.39.5



