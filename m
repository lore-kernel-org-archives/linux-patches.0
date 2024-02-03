Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B4125AC;
	Sat,  3 Feb 2024 04:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933594; cv=none; b=VrhjIJmDWSl9uiP+6GqnlBcpvOBpQkgKRel7EYIDh2j/XY9QkwxJ5ruQUi7ws7fSTmchOdj/pJqOGGL9RHGFKlNAAnF7R/9zAHWFeYCrq0mLIwkIi71Et3AHMtk6QQwuEI6yNr9Uq+zQQlsRZ7qURfGf+sC63SWcfdgBljrSN4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933594; c=relaxed/simple;
	bh=y27ww/N6iPfUD7CX3aWFwhJHgxHWx8+dnSGofJiePuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJ0iH+SYTMisyDaOMK1mZbzhVB2Jc3SZq1ti5jNWo3xZDIqADGgH5z4cie6p6/h/NdKKkOTZzUbSWhutajAqg/tcN5BvJyt281SLFI+ojVK8dpcrceYH3jjEHXhAo0LV9zop08hbFDmOdlBOyQ6ttiIQHKr4OYUn1WshxpWmVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5kN6r46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5kN6r46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F156BC433F1;
	Sat,  3 Feb 2024 04:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933594;
	bh=y27ww/N6iPfUD7CX3aWFwhJHgxHWx8+dnSGofJiePuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5kN6r46nM81EOzZAyRWQXImZrDYMK/PhrO0AdcqNR6EEBFI1u6J4+ttvbnvbxJth
	 smOPoohtx2oZ3GipPTUPIvB54K+af0k2XS7NyIeb9VG57KReiRU+/atnDucwRz8AQ4
	 3b02j7pIuABE3i7T+0EmJ1RrJ+lsl0aY/WiQCcok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/322] arm64: dts: qcom: msm8996: Fix in-ports is a required property
Date: Fri,  2 Feb 2024 20:03:52 -0800
Message-ID: <20240203035403.507712805@linuxfoundation.org>
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

[ Upstream commit 9a6fc510a6a3ec150cb7450aec1e5f257e6fc77b ]

Add the inport of funnel@3023000 to fix 'in-ports' is a required property
warning.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
Link: https://lore.kernel.org/r/20231210072633.4243-3-quic_jinlmao@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index c8e0986425ab..4d87cba47c76 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -443,6 +443,19 @@
 		reg = <0x0 0x80000000 0x0 0x0>;
 	};
 
+	etm {
+		compatible = "qcom,coresight-remote-etm";
+
+		out-ports {
+			port {
+				modem_etm_out_funnel_in2: endpoint {
+					remote-endpoint =
+					  <&funnel_in2_in_modem_etm>;
+				};
+			};
+		};
+	};
+
 	psci {
 		compatible = "arm,psci-1.0";
 		method = "smc";
@@ -2643,6 +2656,14 @@
 			clocks = <&rpmcc RPM_QDSS_CLK>, <&rpmcc RPM_QDSS_A_CLK>;
 			clock-names = "apb_pclk", "atclk";
 
+			in-ports {
+				port {
+					funnel_in2_in_modem_etm: endpoint {
+						remote-endpoint =
+						  <&modem_etm_out_funnel_in2>;
+					};
+				};
+			};
 
 			out-ports {
 				port {
-- 
2.43.0



