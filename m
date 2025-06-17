Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF8118E025;
	Tue, 17 Jun 2025 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178089; cv=none; b=qduQzWQZvlZZqge5OmShPGGdqVmo2LKPgjSRh+gGkC7yfKNa1Pq7dWmijW8f2sLjqpbeHyzK3EaXvXW9pVnUIVsMTptTKYZGxCFjk/q0r1HQ75Qzc8d2RiqD6mcTi+2rQNQ2qaLxfCnTJDUc3JiUoSpuG9L4xRFrLrZn/o5DNPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178089; c=relaxed/simple;
	bh=+Sh9F4pJnDFECUiaEsdEcROJHCgJ5akjg5ZuI8Ii+dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF6jaNZ1lF41cF4yJUed9hCb2gneeeJKsW2zGZFqmKS+QRzgZ6VVeFqg830mwaU6jaV16VRvKCP7rtWFkrm64+wpHxdLzFFiTUYX/nCPQRlH5yh8XGxNJOh0wN7ti0kXbjv5ZWwSHLOf+iRvWXI/ilU9WeHTjYg/4UbuEzRPGVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DayB/GxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DayB/GxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806BFC4CEE3;
	Tue, 17 Jun 2025 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178089;
	bh=+Sh9F4pJnDFECUiaEsdEcROJHCgJ5akjg5ZuI8Ii+dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DayB/GxXeNp7D0mRhBFoVpe2v+FhVVqMYc/LTFH89wdEDP7KSSEPAmBj8dzfESbQA
	 yUXOJ6n6IW3xoQp1tnKFJ5jqd8s5Ob5HHHVA3RwnbT8FDNhWWF81hHC9NO8JGD2Zja
	 Z4NdNXZhVbJWO0y3B99TP8zJKNC/qnZQt0sP3FCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 408/780] arm64: dts: qcom: msm8998: Remove mdss_hdmi_phy phandle argument
Date: Tue, 17 Jun 2025 17:21:56 +0200
Message-ID: <20250617152508.079227920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 7ebdb205d4b9dd839a93a9b8975ce8ccf86b882a ]

The node has #clock-cells = <0>, as it only provides a single clock
output.

This leads to a turbo sneaky bug, where the dt checker shows that we
have additional clocks in the array:

clock-controller@c8c0000: clocks: [[3, 0], [39, 178], [156, 1],
[156, 0], [157, 1], [157, 0], [158], [0], [0], [0], [39, 184]]
is too long

..which happens due to dtc interpreting <&mdss_hdmi_phy 0> as
<&mdss_hdmi_phy>, <0> after taking cells into account.

Remove the superfluous argument to both silence the warning and fix
the index-based lookup of subsequent entries in "clocks".

Fixes: 2150c87db80c ("arm64: dts: qcom: msm8998: add HDMI nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250327-topic-more_dt_bindings_fixes-v2-4-b763d958545f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 7eca38440cd7e..fa6769320a238 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2795,7 +2795,7 @@
 				 <&mdss_dsi0_phy DSI_BYTE_PLL_CLK>,
 				 <&mdss_dsi1_phy DSI_PIXEL_PLL_CLK>,
 				 <&mdss_dsi1_phy DSI_BYTE_PLL_CLK>,
-				 <&mdss_hdmi_phy 0>,
+				 <&mdss_hdmi_phy>,
 				 <0>,
 				 <0>,
 				 <&gcc GCC_MMSS_GPLL0_DIV_CLK>;
-- 
2.39.5



