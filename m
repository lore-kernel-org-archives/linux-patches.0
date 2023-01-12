Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECE0746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82CCC433D2;
	Thu, 12 Jan 2023 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531936;
	bh=7jwwmwTuB25zG8hPI463ozNE0Nb6QUudG6CV8pzKtmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/EVGwfpQI+M9xk1vwwgslEWGWtcvQ6/SwFopdXHVisZFs16E5dUnUblwV1ClF+Ib
	 DYOVYFXYXfWyHrYj77DwUijiIrg2g+B9IkLf3xUHFSNfY61004jtvbqDkRZnpCJiKT
	 qu4sJ00fFxREZSDbC/plSb/zl1hYDy99lsTjkBpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/783] arm64: dts: qcom: msm8996: fix GPU OPP table
Date: Thu, 12 Jan 2023 14:45:19 +0100
Message-Id: <20230112135524.326805981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0d440d811e6e2f37093e54db55bc27fe66678170 ]

Fix Adreno OPP table according to the msm-3.18. Enable 624 MHz for the
speed bin 3 and 560 MHz for bins 2 and 3.

Fixes: 69cc3114ab0f ("arm64: dts: Add Adreno GPU definitions")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220724140421.1933004-7-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index ef5d03a15069..bc140269e4cc 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -651,17 +651,17 @@ gpu_opp_table: opp-table {
 				compatible  ="operating-points-v2";
 
 				/*
-				 * 624Mhz and 560Mhz are only available on speed
-				 * bin (1 << 0). All the rest are available on
-				 * all bins of the hardware
+				 * 624Mhz is only available on speed bins 0 and 3.
+				 * 560Mhz is only available on speed bins 0, 2 and 3.
+				 * All the rest are available on all bins of the hardware.
 				 */
 				opp-624000000 {
 					opp-hz = /bits/ 64 <624000000>;
-					opp-supported-hw = <0x01>;
+					opp-supported-hw = <0x09>;
 				};
 				opp-560000000 {
 					opp-hz = /bits/ 64 <560000000>;
-					opp-supported-hw = <0x01>;
+					opp-supported-hw = <0x0d>;
 				};
 				opp-510000000 {
 					opp-hz = /bits/ 64 <510000000>;
-- 
2.35.1



