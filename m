Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343B7CF29;
	Wed, 21 Feb 2024 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522571; cv=none; b=SyECqjKUNUhcpaJ9dKaNaNfRDI6fprmp7a3HB6d/eM7oaXfK90y/gXLWOlXAiWs+fQWScAU4/Fmc8veyyDU8bjhDNAdgqL8JAA7dkKsN6+xi9Aia38JRTtBIHob+UTj1QmXEYsat+SiZG8ZpL2360aM8pH2kmxo7QXZU0VbFtuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522571; c=relaxed/simple;
	bh=Ku+a2kt1ECAG0jDJUiZJTYL82EPLu3NhgzL93qiI/QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXzrEWctHGoAtfGkD5C5yyf4HS74Sh82PXYJ3aMzuEZY7BZhkeLL2q8rWuJGNBhvsKkTYXQEgBu5MZ16hSvI7EnVNuB9NTRS2Y8Hu9JyLCG41d2PRbPxPwVrtevt8JNTa4GhSz8EgG9Q9ZHvnfn4Whap+bSpUtFJ2A/oCI5x03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlCfscMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlCfscMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F9BC43390;
	Wed, 21 Feb 2024 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522571;
	bh=Ku+a2kt1ECAG0jDJUiZJTYL82EPLu3NhgzL93qiI/QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlCfscMJTeFyuLXD3A0zWWYhrm9wLFDaL3tP6OD5upJ2tW0EFnaBDQPQOYyIx1mx7
	 E9HoRJHuueUrYbw0Hyl2NojnS5dm4iDuBtXAFi6wKligflniw2K270VaMpxgtV0Tsf
	 TmmRMzg1gcTH7w43OOImnIR+56hvfGCgYaNcP4wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/476] arm64: dts: qcom: msm8998: Fix out-ports is a required property
Date: Wed, 21 Feb 2024 14:04:08 +0100
Message-ID: <20240221130015.201092465@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7d72b0d579e..7eadecba0175 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1863,9 +1863,11 @@
 
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
@@ -1880,9 +1882,11 @@
 
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
@@ -1897,9 +1901,11 @@
 
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
@@ -1914,9 +1920,11 @@
 
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



