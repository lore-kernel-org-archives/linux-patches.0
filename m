Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8293C156E4;
	Sat,  3 Feb 2024 04:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933378; cv=none; b=cj31c8HVi0l/qK81mtmDgmSxvCqq38nw5v2Q2QY9MU40zAdHYaqpbwcOjo8Rw369V1JI8YwAGqXP/5m2lBieOldi71q6quMcau5HeLJAowLzwJ4m0gOLUKVRhrmH7MVCWGHZ68OuP8uEJ7qObqBPZxpMMy6VpEDR0yOgRB51yZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933378; c=relaxed/simple;
	bh=MT99ETjIXI3i9SRioBp65lU4gWygn3UqGpnAec7NA0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePaHwUzJnSkF545NkJkdK+nxHduAyElQ78jXOw8MVAOU5OPS397YE0S7odch5VZOSKxbQxM1wVTKTzOsuio3WlGS7/dPIzn1U8odCGU+5FtiKRM0FayIQWSGHWJaZIPJ474kh/Q4ZkXUcjo9jjtiLPPR6XMseMunNqdQxovsvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc1DRIta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc1DRIta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CFAC43394;
	Sat,  3 Feb 2024 04:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933378;
	bh=MT99ETjIXI3i9SRioBp65lU4gWygn3UqGpnAec7NA0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc1DRItaLfB9EKghLg/7JLqRFinOoDYGqr/KQcxWvAQaSw5s8Ki6WYqnwpNAFSFi4
	 gtmqqTHvOEnJxOuX8mxxG9Ryk5nCIenaFKX3pV7YJ2TnJ7iXg3PkGgTwpd29x1j21E
	 hRcbYkBNDty03Nk+0eaZ/mtr0fQohFfPqLeKCJPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/219] arm64: dts: qcom: msm8996: Fix in-ports is a required property
Date: Fri,  2 Feb 2024 20:04:21 -0800
Message-ID: <20240203035329.663096457@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
index 9de2248a385a..789121171a11 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -390,6 +390,19 @@
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
@@ -2565,6 +2578,14 @@
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



