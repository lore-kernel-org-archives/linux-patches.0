Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344EE11181;
	Sat,  3 Feb 2024 04:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933379; cv=none; b=aqmuE0TdUVTmeR8czDcsLnvYtunT7a2rQf9ZvUrL2shMeFnQGA0ax/eeOIA5msroJkLiUevbyZsLJzPpZ9p7Ss5LFU73ArE4HeaaafKOaiRdjX7WqnVnPJoJTFfcSHatfQjhZCgRjMFqTwq/iLesGCSTKF+2fb5u7Rgt2IA960w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933379; c=relaxed/simple;
	bh=jlTxuHKnacgXDOcrj+lbsPb3HsyR385fZSmbUAWNhE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPsO1TLo3YMmHKC/OnSMgbnq/IqyDR0+RbYBXMKSYGwkTD8xOZmo6cwE7qZrlEY/VUK25oXa1lT9SMXIqy7GWWjAV5oLXMxgdw+LSwFcDT/AqciAXwolqHhpNXDZseEs3RhVjcOW4GY4kOgcxNzX+bJqAnmJLWBKAp4MDhB2eFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAMnPtjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAMnPtjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35A3C433C7;
	Sat,  3 Feb 2024 04:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933379;
	bh=jlTxuHKnacgXDOcrj+lbsPb3HsyR385fZSmbUAWNhE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAMnPtjs+vFSVfalN/eCBJLLBpgjtLD7zPURAGtVE7c96ub1HnAwDvugDYRR90+nN
	 hBOTAAOsT0nWGj7bxh5yTC5LUFUl3gEUNARQ4Or/Zz5FVtEK2XNZsACDiw5m5k5TV5
	 uTiYJ7iE70wyAM9o29vrXowM36Zu/3ufXJrJHzY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/219] arm64: dts: qcom: msm8998: Fix out-ports is a required property
Date: Fri,  2 Feb 2024 20:04:22 -0800
Message-ID: <20240203035329.843221447@linuxfoundation.org>
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
index b00b8164c4aa..7a41250539ff 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1903,9 +1903,11 @@
 
 			cpu = <&CPU4>;
 
-			port{
-				etm4_out: endpoint {
-					remote-endpoint = <&apss_funnel_in4>;
+			out-ports {
+				port{
+					etm4_out: endpoint {
+						remote-endpoint = <&apss_funnel_in4>;
+					};
 				};
 			};
 		};
@@ -1920,9 +1922,11 @@
 
 			cpu = <&CPU5>;
 
-			port{
-				etm5_out: endpoint {
-					remote-endpoint = <&apss_funnel_in5>;
+			out-ports {
+				port{
+					etm5_out: endpoint {
+						remote-endpoint = <&apss_funnel_in5>;
+					};
 				};
 			};
 		};
@@ -1937,9 +1941,11 @@
 
 			cpu = <&CPU6>;
 
-			port{
-				etm6_out: endpoint {
-					remote-endpoint = <&apss_funnel_in6>;
+			out-ports {
+				port{
+					etm6_out: endpoint {
+						remote-endpoint = <&apss_funnel_in6>;
+					};
 				};
 			};
 		};
@@ -1954,9 +1960,11 @@
 
 			cpu = <&CPU7>;
 
-			port{
-				etm7_out: endpoint {
-					remote-endpoint = <&apss_funnel_in7>;
+			out-ports {
+				port{
+					etm7_out: endpoint {
+						remote-endpoint = <&apss_funnel_in7>;
+					};
 				};
 			};
 		};
-- 
2.43.0



