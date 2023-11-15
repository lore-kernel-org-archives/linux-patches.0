Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A742A28382
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJ3sQuLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CC0C433C7;
	Wed, 15 Nov 2023 19:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076388;
	bh=mKJB6wgoKI96AfRhjgDItfS4HE6Vj887+8S2Z/0I0zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJ3sQuLDyZbMdMdgJ0P7cLch1HqEETYhPsUAUJffbWgkW/ZNNYDwJg03Pd6eDYfUF
	 cIhOVhZkHRaSPmcfj7ZizgHcwmZkFo614inWPqv/XlLmhDIY6SxLk7iUSXdQl4QZoh
	 MMfmLdPnv2caA+R193Rw/pcFvKL69rOOLNKDxY/w=
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
Subject: [PATCH 6.5 261/550] arm64: dts: qcom: sdm845: Fix PSCI power domain names
Date: Wed, 15 Nov 2023 14:14:05 -0500
Message-ID: <20231115191618.803610561@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 1ce413263b7f9..617be27e79523 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -144,15 +144,15 @@ panel_in_edp: endpoint {
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
@@ -338,6 +338,8 @@ flash@0 {
 
 
 &apps_rsc {
+	/delete-property/ power-domains;
+
 	regulators-0 {
 		compatible = "qcom,pm8998-rpmh-regulators";
 		qcom,pmic-id = "a";
-- 
2.42.0



