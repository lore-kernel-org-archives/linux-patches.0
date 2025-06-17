Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988CD239E85;
	Tue, 17 Jun 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178097; cv=none; b=UKiv3decIwGkYre1SrtKi39OqmpAr1/qvvNUYhi5CX4xjUb/zwHQiVrzieYlB8g4ZXXPweMkga99WAhplFbclkewdGKD5HNMogeMqltnIjpV++NG4elEeLJ0eTo9yS0VjacY2YBc1S6zSWMZFrmHvHmtZ4znPOkSj4dr3G13QcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178097; c=relaxed/simple;
	bh=YIROW0S7HNU4DZXZ3xOeh4SZ4aQMMLEcXA43R+t7nQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg8kESAfRZMNQudyMBRPMngs0829KIHFR4QNS4H7SXqmU2KiXflNvawCZD0/NIZ9nqQoPwF80savJa7vPciCfnFioE6Xv58BpOi0eZq4fScs1s0lg0hxXWCoidWkZ+02EG3E+SPPpeGGwwRAKCKBpYXhQ5k954F9RVFbuIYsMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9Ub1DWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9Ub1DWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185F1C4CEE3;
	Tue, 17 Jun 2025 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178095;
	bh=YIROW0S7HNU4DZXZ3xOeh4SZ4aQMMLEcXA43R+t7nQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9Ub1DWaLgz1VAx6IF4OCu4JD3UOkIzJSYxueDcM0Hpdmhg8/92KfxGGAb7evag1W
	 F1d7WQ5hlijnssk7qIVq0Qu3i1Lr8Aa6/70r+5nJlMnZR8TLoU3YMDOFI2A14Clx8Y
	 gke3jxmxh24yU0iRAg62fySj41Sfqhk1DyFdPflU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 409/780] arm64: dts: qcom: qcs615: Fix up UFS clocks
Date: Tue, 17 Jun 2025 17:21:57 +0200
Message-ID: <20250617152508.119676026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit ea172f61f4fdb17aaaf8def980ee309a3b727eea ]

The clocks are out of order with the bindings' expectations.

Reorder them to resolve the errors.

Fixes: a6a9d10e7969 ("arm64: dts: qcom: qcs615: add UFS node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250327-topic-more_dt_bindings_fixes-v2-12-b763d958545f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
index 8db06d17eb474..1206548490438 100644
--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -1022,10 +1022,10 @@
 				      "bus_aggr_clk",
 				      "iface_clk",
 				      "core_clk_unipro",
-				      "core_clk_ice",
 				      "ref_clk",
 				      "tx_lane0_sync_clk",
-				      "rx_lane0_sync_clk";
+				      "rx_lane0_sync_clk",
+				      "ice_core_clk";
 
 			resets = <&gcc GCC_UFS_PHY_BCR>;
 			reset-names = "rst";
@@ -1060,10 +1060,10 @@
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <37500000>,
-						 /bits/ 64 <75000000>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
-						 /bits/ 64 <0>;
+						 /bits/ 64 <0>,
+						 /bits/ 64 <75000000>;
 					required-opps = <&rpmhpd_opp_low_svs>;
 				};
 
@@ -1072,10 +1072,10 @@
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <75000000>,
-						 /bits/ 64 <150000000>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
-						 /bits/ 64 <0>;
+						 /bits/ 64 <0>,
+						 /bits/ 64 <150000000>;
 					required-opps = <&rpmhpd_opp_svs>;
 				};
 
@@ -1084,10 +1084,10 @@
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <150000000>,
-						 /bits/ 64 <300000000>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
-						 /bits/ 64 <0>;
+						 /bits/ 64 <0>,
+						 /bits/ 64 <300000000>;
 					required-opps = <&rpmhpd_opp_nom>;
 				};
 			};
-- 
2.39.5



