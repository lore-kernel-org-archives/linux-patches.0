Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2265D5336E;
	Tue,  3 Dec 2024 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240361; cv=none; b=jbDUi87kidlbZRZq8cQ7U69CSRMeV8T7VnybTNU++KHOfAUBMCQG+WnO0mGco4+CoZwo3ZSSx9zGWJBFpNyRLbPfRKCeQZ2cRvXvVckJ1kLz3HtKrpAmrjvdsgUP1Nge4UxVU/KVBVviswoVEb4guEthFy9QLsdTWsT8KWaNLc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240361; c=relaxed/simple;
	bh=xN01toMkaL6ff4V+vchFOjLz7fvRnYmhmHbnAOR5ezw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNn56XTMwMqvJZwyiCAJtab2XbQQ0AkhgT0hO1L5Skyn/UWqczJdW8+JXOam4vfqjiufUzMmRTM1b3qXeHE5L8T975nHjaQIAX9A9gGosfmJbAt7Ednn8IaejbGFBIoXfSWnE/DgejmlnrgBt1HAydHqb04P/FWxIMuoNRmGZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCh2kiZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCh2kiZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD8CC4CECF;
	Tue,  3 Dec 2024 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240360;
	bh=xN01toMkaL6ff4V+vchFOjLz7fvRnYmhmHbnAOR5ezw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCh2kiZtjo2ipAnvk1tcob0VbLXPoRv2KHtNLBsstlGkKJZjf1WFQIS8FioD2AYaG
	 Al3cukZkf3/k3UvM+Q4pp5dBFWJ9XZm3+5f8V1IUKOeF2a0VoJ/aI0KziY/I0nN/gX
	 9+coR3Yu4HsSAX3rzZKGS/U0j+Nw0eqvD26JPn+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/826] arm64: dts: qcom: sm6350: Fix GPU frequencies missing on some speedbins
Date: Tue,  3 Dec 2024 15:37:20 +0100
Message-ID: <20241203144748.149682974@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7986ddb30f6e8..4f8477de7e1b1 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1376,43 +1376,43 @@ gpu_opp_table: opp-table {
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



