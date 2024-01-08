Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87C51C4D;
	Mon,  8 Jan 2024 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiSf2SY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0F3C433C7;
	Mon,  8 Jan 2024 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728439;
	bh=MNYVDJSo0SBn4Yuuy/S1CvoStcndTHtszH4QwZFUaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiSf2SY2l3/vATXWpm3n5n3OexSwnHsBMTrKtqrS5yKKebNDPxAo5h54IrTh0IgZ6
	 Nb6FWN3DkPr/R6uY9s7NWIxmkF0b9qDCCbDPGiePWfjIFlUsMotOowuspwgZ7eIMds
	 u737lzel43HzA52uBLX5zEv/gk71/LTSWc66zLCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	David Heidelberg <david@ixit.cz>,
	Stephen Boyd <swboyd@chromium.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/150] arm64: dts: qcom: sdm845: Fix PSCI power domain names
Date: Mon,  8 Jan 2024 16:35:27 +0100
Message-ID: <20240108153514.715998236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit a5f01673d3946e424091e6b8ff274716f9c21454 ]

The original commit hasn't been updated according to
refactoring done in sdm845.dtsi.

Fixes: a1ade6cac5a2 ("arm64: dts: qcom: sdm845: Switch PSCI cpu idle states from PC to OSI")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230912071205.11502-1-david@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index 985824032c522..43ee28db61aa8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -150,15 +150,15 @@ &cpufreq_hw {
 };
 
 &psci {
-	/delete-node/ cpu0;
-	/delete-node/ cpu1;
-	/delete-node/ cpu2;
-	/delete-node/ cpu3;
-	/delete-node/ cpu4;
-	/delete-node/ cpu5;
-	/delete-node/ cpu6;
-	/delete-node/ cpu7;
-	/delete-node/ cpu-cluster0;
+	/delete-node/ power-domain-cpu0;
+	/delete-node/ power-domain-cpu1;
+	/delete-node/ power-domain-cpu2;
+	/delete-node/ power-domain-cpu3;
+	/delete-node/ power-domain-cpu4;
+	/delete-node/ power-domain-cpu5;
+	/delete-node/ power-domain-cpu6;
+	/delete-node/ power-domain-cpu7;
+	/delete-node/ power-domain-cluster;
 };
 
 &cpus {
@@ -351,6 +351,8 @@ flash@0 {
 
 
 &apps_rsc {
+	/delete-property/ power-domains;
+
 	regulators-0 {
 		compatible = "qcom,pm8998-rpmh-regulators";
 		qcom,pmic-id = "a";
-- 
2.43.0



