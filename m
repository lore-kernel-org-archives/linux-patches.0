Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6920E18F2CF;
	Wed,  5 Feb 2025 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767309; cv=none; b=OS01nbZKx/POujgwPqbgfNFJ5PwFU1FTJ3jEUJ6b/vYIm9cZ5Hkb+CLozwbGZUTI/MLhcK35ZJVAiOrbdeIKpgOehNJHqJVA2y9QhM7re+BqVcgM3X854QX4kp3bv5gAY3VYtzBQ2y9lWzYfeXi6SEG9H6zH00gqg52nv28x6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767309; c=relaxed/simple;
	bh=TR4gmKzBG1s6PaCQMo0LP8NJQQ6IZUtI7TbGkGGZr1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcAFUArrCxgzu/z4cLmALJB7t88PV3xuzcQJPS5XajpK/wT9DdoUBrwuCDzild5RVPPH3yqeyNwEF/9Zy444ebx6hHjy75KBK1zgUCbPjo1snTAXEx+Vn+207nd5I9meZY9o6xrFntAlbakMLz07QjcSoq4wVInYlmCCcUCkmWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fc5Bv96D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fc5Bv96D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB063C4CED1;
	Wed,  5 Feb 2025 14:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767309;
	bh=TR4gmKzBG1s6PaCQMo0LP8NJQQ6IZUtI7TbGkGGZr1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc5Bv96DSTyyqnzXNzHlD1rJi/rWnOhQhMi1lqC0Rzbc+aqT15CbGv83RP/KKwsDu
	 L9SwEXZgBt/Jr63m1pUmvW/jGT+pgXNBPFilQGCCJzuB6JSzm9MdK3LIcULZdgsUmL
	 03Kr4vfu8HWjDE+SDx4ykEakKSOnFg4xNghPZyh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 386/623] arm64: dts: qcom: sm6375: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:08 +0100
Message-ID: <20250205134510.990772101@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 223382c94f1f07c475d39713e4c058401480b441 ]

The SM6375 platform uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 59d34ca97f91 ("arm64: dts: qcom: Add initial device tree for SM6375")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-12-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6375.dtsi b/arch/arm64/boot/dts/qcom/sm6375.dtsi
index e0b1c54e98c0e..7c929168ed080 100644
--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -29,7 +29,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



