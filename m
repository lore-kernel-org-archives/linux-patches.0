Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55AE1442E8;
	Fri,  6 Dec 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496832; cv=none; b=dzTZ3u99TAAD/M5WQDHHQtpuKE0ZAYpOVnzOcXoXqXCm9LFYttEzVZl0lzzIms2ZKlu325tqLYihp9fKw6F8q47VgYA5xyyk3eBAb656tx96WCXnVJz1+6E3akIpJwXg38DT43dcvKdiwMybxYEqVKID2ObdBJeFpuaNpK/Rkq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496832; c=relaxed/simple;
	bh=6o1gqZpqARCPK9rWb4In3VZrjiLRfStkxo+0EQ1pJWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6FCdHKLtEXrW8vtym+e69lSrzIv0rqs0GLLgCQj0O9qWGUyEHWyGLwOEJp0VZ54Cxks7y4yjQcoqp7YLKnNUXnUsJXzrWDiv3BkCR7ZKaVkwzonumEA3Ycy8al0xvB3N4XUSc6zRy70H8AR1CBxCXVWt+P2yX0EPX2ePf/Nubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdHpjvOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdHpjvOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42486C4CED1;
	Fri,  6 Dec 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496832;
	bh=6o1gqZpqARCPK9rWb4In3VZrjiLRfStkxo+0EQ1pJWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdHpjvOPc69DGsznSy9dWS6IbuZwL+L4U0nqBsveahxhj0dsfgfPz+U389qcdTGnE
	 +paugosodzjxpvgcnNVDwz/Vh0yhaRrSc9xxQyHyd7QojrtF1gNUgdhplFro7mH29z
	 EGkvL3uclVx0ph/VvW19k3eWG+QFeQe/u0he+RqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/676] arm64: dts: qcom: sm6350: Fix GPU frequencies missing on some speedbins
Date: Fri,  6 Dec 2024 15:28:58 +0100
Message-ID: <20241206143658.005516043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 600c499f8f5297c2c91e8146a8217f299e445ef6 ]

Make sure the GPU frequencies are marked as supported for the respective
speedbins according to downstream msm-4.19 kernel:

* 850 MHz: Speedbins 0 + 180
* 800 MHz: Speedbins 0 + 180 + 169
* 650 MHz: Speedbins 0 + 180 + 169 + 138
* 565 MHz: Speedbins 0 + 180 + 169 + 138 + 120
* 430 MHz: Speedbins 0 + 180 + 169 + 138 + 120
* 355 MHz: Speedbins 0 + 180 + 169 + 138 + 120
* 253 MHz: Speedbins 0 + 180 + 169 + 138 + 120

Fixes: bd9b76750280 ("arm64: dts: qcom: sm6350: Add GPU nodes")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20241002-sm6350-gpu-speedbin-fix-v1-1-8a5d90c5097d@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 2efceb49a3218..f271b69485c5c 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1351,43 +1351,43 @@ gpu_opp_table: opp-table {
 				opp-850000000 {
 					opp-hz = /bits/ 64 <850000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L1>;
-					opp-supported-hw = <0x02>;
+					opp-supported-hw = <0x03>;
 				};
 
 				opp-800000000 {
 					opp-hz = /bits/ 64 <800000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_TURBO>;
-					opp-supported-hw = <0x04>;
+					opp-supported-hw = <0x07>;
 				};
 
 				opp-650000000 {
 					opp-hz = /bits/ 64 <650000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_NOM_L1>;
-					opp-supported-hw = <0x08>;
+					opp-supported-hw = <0x0f>;
 				};
 
 				opp-565000000 {
 					opp-hz = /bits/ 64 <565000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_NOM>;
-					opp-supported-hw = <0x10>;
+					opp-supported-hw = <0x1f>;
 				};
 
 				opp-430000000 {
 					opp-hz = /bits/ 64 <430000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_SVS_L1>;
-					opp-supported-hw = <0xff>;
+					opp-supported-hw = <0x1f>;
 				};
 
 				opp-355000000 {
 					opp-hz = /bits/ 64 <355000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_SVS>;
-					opp-supported-hw = <0xff>;
+					opp-supported-hw = <0x1f>;
 				};
 
 				opp-253000000 {
 					opp-hz = /bits/ 64 <253000000>;
 					opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS>;
-					opp-supported-hw = <0xff>;
+					opp-supported-hw = <0x1f>;
 				};
 			};
 		};
-- 
2.43.0



