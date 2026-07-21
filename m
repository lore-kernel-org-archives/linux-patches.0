Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4146AA86;
	Tue, 21 Jul 2026 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648424; cv=none; b=KEHt8xm11EiN91vQcJ66poWtYkzy25RIBeNFViTCSAQmPa10n7QbFyXoxhl6vMtN+04OMqd1Jtvik4SQcT8mHO2zbKA8Y4y9otliAn2PB62uD22IYTMVU5+MYsqeNoSrlVadcYhgIP81dXrdo3TMF/R59l4dNZv8Gfg7z3GCaes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648424; c=relaxed/simple;
	bh=GJBV1W/YVjhARcwXnLVjUX5vBVe3rxNyXH8VysUeK+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elK+gfCh+BrRLA6D6be2/KhBVYenlWuwj8kcm9chKSCfYwFBrTNrOUmOd20+hY7UVF96Z2ZuqfC6ms0C7v9w3oAdFke9juPLeVQ6b83L/TdsZpOxNEDUOchmwbu/9GlyL6jyVaHskq2n0P2ru9D1vohX4h0PllxpT7mmJGbw5Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4ZKKRHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4ZKKRHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AEA1F00A3A;
	Tue, 21 Jul 2026 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648423;
	bh=hWfVh8CpTMxF1r2YRmyEAMvEY4VL56yuoAe0uGkKubE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4ZKKRHGmiqfZwBFM5FsvdJiVLimO/Cl4emuhXRZU5+XOW9zszOd2o+rx3BeAFDbL
	 o763kU56L8ZIaZc+xcJ6OluaW2jJjyGJ4UOzZTLTme9rr6/2DiCnQpUfKwOCHU1eOp
	 JW59EuzugvHvpx9JRZtSIcOivtMtUzLRWsEzPZc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0177/2077] arm64: dts: qcom: sdm630: set adsp compute-cbs regs properly
Date: Tue, 21 Jul 2026 16:57:30 +0200
Message-ID: <20260721152556.858498877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolay Goppen <setotau@mainlining.org>

[ Upstream commit e8e1fb5c703fc6962103ffdc60830df99351c139 ]

Changing FastRPC compute-cbs' reg values to matching iommu streams
solves SMMU translation errors when trying to use FastRPC on ADSP
so change FastRPC compute-cbs' reg values that way

Fixes: af2ce7296643 ("arm64: dts: qcom: sdm630: Add FastRPC nodes to ADSP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Nickolay Goppen <setotau@mainlining.org>
Link: https://lore.kernel.org/r/20260429-qcom-sdm660-cdsp-adsp-fastrpc-dts-fix-v5-3-16bc82e622ad@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index bef3213165d668..4b47efdb57b213 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -2459,27 +2459,27 @@ fastrpc {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					compute-cb@1 {
+					compute-cb@3 {
 						compatible = "qcom,fastrpc-compute-cb";
-						reg = <1>;
+						reg = <3>;
 						iommus = <&lpass_smmu 3>;
 					};
 
-					compute-cb@2 {
+					compute-cb@7 {
 						compatible = "qcom,fastrpc-compute-cb";
-						reg = <2>;
+						reg = <7>;
 						iommus = <&lpass_smmu 7>;
 					};
 
-					compute-cb@3 {
+					compute-cb@8 {
 						compatible = "qcom,fastrpc-compute-cb";
-						reg = <3>;
+						reg = <8>;
 						iommus = <&lpass_smmu 8>;
 					};
 
-					compute-cb@4 {
+					compute-cb@9 {
 						compatible = "qcom,fastrpc-compute-cb";
-						reg = <4>;
+						reg = <9>;
 						iommus = <&lpass_smmu 9>;
 					};
 				};
-- 
2.53.0



