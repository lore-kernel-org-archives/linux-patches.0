Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E395125AC;
	Sat,  3 Feb 2024 04:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933595; cv=none; b=LEIlVb97aNfSlu9Q1ewz7QWNDTUcX9dwHedQapetN05RWc2WCvyfFc/xv73jG1iCZlm4IiqVCYUKaF8uNQWYICZtRx0mjLNR39AxXNSlEg3mLEpsMeZIQlQ8Xs9NPRufL0EL68h9RNb0T9k+HAMf/zCj27QT/DsnNwSXdE92xgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933595; c=relaxed/simple;
	bh=UDDYiMU8BJNs5qVegKCvgRB8xvt7dTZKtmb3ouarVak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1x6qhVDalcbVaTdOd3xkvdfNmkAif+wvMVxRiIORRMN8XnmuVJqxXhiL/D8wVuhLVHojvabWH4IVn+4XeAYx7ds9dqWrcYwEVRJdgIahW/ZhZnMb+EIVvxC7/3UJ1jRCWIRGK2s164tgroysC0PgjIhPPK7SSAT5CvJKczQKnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC3tcnqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC3tcnqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCDFC43390;
	Sat,  3 Feb 2024 04:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933594;
	bh=UDDYiMU8BJNs5qVegKCvgRB8xvt7dTZKtmb3ouarVak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC3tcnqsRnnBDXVXV+wA6OG81N3TAGsI2UWX7nAgyJChYUwqc2oBU8JJZXcbA6lpG
	 5ihHUf98beyaeg/UNHVn2ZoWVP5hRqquyKc5gED3W0wcQcVXdp7ec0bxYqsENIi/Xt
	 sIHuKZ54SDFdscbFFTlOhOaDjGyVyLRuva/pNlpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/322] arm64: dts: qcom: msm8998: Fix out-ports is a required property
Date: Fri,  2 Feb 2024 20:03:53 -0800
Message-ID: <20240203035403.543312936@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mao Jinlong <quic_jinlmao@quicinc.com>

[ Upstream commit ae5ee3562a2519214b12228545e88a203dd68bbd ]

out-ports is a required property for coresight ETM. Add out-ports for
ETM nodes to fix the warning.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
Link: https://lore.kernel.org/r/20231210072633.4243-4-quic_jinlmao@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 32 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index f180047cacb0..f91c58c844af 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2034,9 +2034,11 @@
 
 			cpu = <&CPU4>;
 
-			port {
-				etm4_out: endpoint {
-					remote-endpoint = <&apss_funnel_in4>;
+			out-ports {
+				port {
+					etm4_out: endpoint {
+						remote-endpoint = <&apss_funnel_in4>;
+					};
 				};
 			};
 		};
@@ -2051,9 +2053,11 @@
 
 			cpu = <&CPU5>;
 
-			port {
-				etm5_out: endpoint {
-					remote-endpoint = <&apss_funnel_in5>;
+			out-ports {
+				port {
+					etm5_out: endpoint {
+						remote-endpoint = <&apss_funnel_in5>;
+					};
 				};
 			};
 		};
@@ -2068,9 +2072,11 @@
 
 			cpu = <&CPU6>;
 
-			port {
-				etm6_out: endpoint {
-					remote-endpoint = <&apss_funnel_in6>;
+			out-ports {
+				port {
+					etm6_out: endpoint {
+						remote-endpoint = <&apss_funnel_in6>;
+					};
 				};
 			};
 		};
@@ -2085,9 +2091,11 @@
 
 			cpu = <&CPU7>;
 
-			port {
-				etm7_out: endpoint {
-					remote-endpoint = <&apss_funnel_in7>;
+			out-ports {
+				port {
+					etm7_out: endpoint {
+						remote-endpoint = <&apss_funnel_in7>;
+					};
 				};
 			};
 		};
-- 
2.43.0



