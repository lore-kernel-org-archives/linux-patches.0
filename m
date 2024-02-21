Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D5076037;
	Wed, 21 Feb 2024 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524174; cv=none; b=TrEnjouNRV4PY4ARkquS6ZOur3YXprmnIEcABM6kbL9Q9kJJuXDgFwBzY2HHaNliWdDf3EMtJq4er/l8kLnCbZYAsSbblxy3L9/8keaSaWeNEln//2g1pqrl+vcZnNQcJ47b+Y07kkl169rc5N9srsBFdiUALLRzimsxyJJuy0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524174; c=relaxed/simple;
	bh=nvERe/5lxoG1Z6D3gjWl9lbw1TMqT2yTsHQdUN1mQEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJLFWdZVfHAQnoC+ED5BW7V0B5upQqb7Z2VT193/8nWIKzajf5QMQJH+K7ygsVPcbmCCku91rDUMgYhXxAcNpHlEtN8i7CYTx9cEw7fqw5DkOFUV9r2CXnI63Wg/gjvPZ/2tnEMXnUvTK1YznLFUuJzzjhtBWW3QhPricSSbsEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8Mivgin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8Mivgin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1157BC433F1;
	Wed, 21 Feb 2024 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524174;
	bh=nvERe/5lxoG1Z6D3gjWl9lbw1TMqT2yTsHQdUN1mQEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8Mivgin30hq+HHkeedNLg5txml6L/65sUhLABVb4lkBj13I2zniKdiO06zZ6FLv7
	 pcc2iFShTPsEWwngOOE6/VeKDtKwpXqDXJd5Q6QsjxStZeNVIKafzF/6rU3T8MCKwK
	 XCtiL7q2uFvU5eUKZD13f3K4xjgwa8Ve3LnINOVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/379] arm64: dts: qcom: msm8996: Fix in-ports is a required property
Date: Wed, 21 Feb 2024 14:05:46 +0100
Message-ID: <20240221125959.854951299@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index 0bc5fefb7a49..d766f3b5c03e 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -139,6 +139,19 @@
 		reg = <0 0 0 0>;
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
@@ -1374,6 +1387,14 @@
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



