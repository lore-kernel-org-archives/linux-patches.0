Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1097446AA71;
	Tue, 21 Jul 2026 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648427; cv=none; b=exv4+8rqpVLLgVh4HEoI3f6mgLiWEKka8JIf4wJOfIXUe6B3NgtlZevhQMSnFY8l4aJgfqWWdf2z+ibUt2FuY0bIEwucqEm/FikwMlQ1pNsA0CABiPpd3OxjYmM5dQwwC162GVdbZGEGIVPny+1Y+v2+OZkwTySELHRMvvvKaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648427; c=relaxed/simple;
	bh=k4KBoNHl6fhcKf7ZCISm29O8l3hv95kfI9zvBQNVFtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAU45ASukmpHBCSRhWZkMnMM+XIjwdUuY0e35UNZKzEoRXI4BG/c60WyEoLGbcrAhcn/0H2EKFbyy4e5tKsj4O8ypWRJs/DoHuo0aaLdIpyzjAmDrZE/8ykuuGd0jJin3TZ2IUiD+xSAlkkb9rIxMw/AXrlpuTzHiGwfQRQZALs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnLC8pgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnLC8pgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F751F000E9;
	Tue, 21 Jul 2026 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648426;
	bh=D8RwDfFKXADi2+WlYHMeI3izhc41kveAhTD2Rvn5kcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnLC8pgzyN8q8Nb5JcGuNOb13dzR/HEg+v14xkfE2vaQ1hkVHh4f4mn0Zea4HFeQB
	 J8thZq/qXoYs7M7gXgYstC65CBq28kn1r3h8MBm+jWcLUk9I/u7AZgAGHVqruBoWub
	 jt6/8zSogZ47dJbhkvaX46hoiv7c/2Vi7Idx1DMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0195/2077] arm64: dts: qcom: sm8750: Fix DSI1 phy reference clock rate
Date: Tue, 21 Jul 2026 16:57:48 +0200
Message-ID: <20260721152557.281014970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f4d7c5875a215cd3989b59d13a9c30cec9f0a33b ]

The DSI PHY CXO clock input is the SoC CXO divided by two.  DSI0 already
uses correct one, but DSI1 got copy-paste from SM8650.  Wrong clock
parent will cause incorrect DSI1 PHY PLL frequencies to be used making
the DSI panel non-working, although there is no upstream user of DSI1.

Fixes: 818ae2b389bc ("arm64: dts: qcom: sm8750: Add display (MDSS) with Display CC")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260331165645.233965-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 18fb52c14acd75..320aec62e462d2 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -3313,7 +3313,7 @@ mdss_dsi1_phy: phy@ae97000 {
 					    "dsi_pll";
 
 				clocks = <&dispcc DISP_CC_MDSS_AHB_CLK>,
-					 <&rpmhcc RPMH_CXO_CLK>;
+					 <&bi_tcxo_div2>;
 				clock-names = "iface",
 					      "ref";
 
-- 
2.53.0



