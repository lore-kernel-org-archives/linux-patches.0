Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E571DDCE;
	Tue, 16 Jul 2024 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145646; cv=none; b=oOzKAdVVgO2zwo8TlsqWi/Lf1curl4xaJzNBufr1a9iQBNbLg7KVjlNfjLHf8Nq93zb+9JDEMIeAD2TdJDeMXTRBCd9skCa2yA1UONLfd6akBZhJg+o9bQHInjHSX4ai69Wz/+C2c6nq5/NOlc7wb9imhiamdV3oNwTjIC0JB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145646; c=relaxed/simple;
	bh=S87oRf6/Jm2mQr7rXW1dNEoc8U2v+zRDpZ8IuZ4XOZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbbkFigKUVRXG/stYc71LOKZoN/w/eNoFA7l03y3XvYA+bt3+0XEm/iZboHJHBe0S6NJAtSeAipoXRvYvzh1jUy8q3pO/Nf3/VawNwwq16e2svdOs7XMtzX0Ko/PkWk+f/b4v1BEtReCT/gGcboIOouAD92lDhYzioN76AXrHW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7Nn1dq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7Nn1dq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA30EC116B1;
	Tue, 16 Jul 2024 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145646;
	bh=S87oRf6/Jm2mQr7rXW1dNEoc8U2v+zRDpZ8IuZ4XOZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7Nn1dq3gvB4xXIXScvplnbmE37aiMiRet/w6++INfOEkbJKKLDtlrWUriT7jr6Cm
	 PUonoDfLJpe5TjU4EB7ojLI20YMSd/v5dblU1PI0cjEQNbAYZo45W7IWhr19Q+clg8
	 gCJ2f+ME7zXWuIJwjITv00Q5HRPGmsntwYKaeGlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/121] arm64: dts: qcom: sc8180x: Fix LLCC reg property again
Date: Tue, 16 Jul 2024 17:31:39 +0200
Message-ID: <20240716152752.750553041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3df1627d8370a9c420b49743976b3eeba32afbbc ]

Commit '74cf6675c35e ("arm64: dts: qcom: sc8180x: Fix LLCC reg
property")' transitioned the SC8180X LLCC node to describe each memory
region individually, but did not include all the regions.

The result is that Linux fails to find the last regions, so extend the
definition to cover all the blocks.

This also corrects the related DeviceTree validation error.

Fixes: 74cf6675c35e ("arm64: dts: qcom: sc8180x: Fix LLCC reg property")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240525-sc8180x-llcc-reg-fixup-v1-1-0c13d4ea94f2@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index fbb9bf09078a0..dd207eb81360a 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2551,11 +2551,14 @@
 
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc8180x-llcc";
-			reg = <0 0x09200000 0 0x50000>, <0 0x09280000 0 0x50000>,
-			      <0 0x09300000 0 0x50000>, <0 0x09380000 0 0x50000>,
-			      <0 0x09600000 0 0x50000>;
+			reg = <0 0x09200000 0 0x58000>, <0 0x09280000 0 0x58000>,
+			      <0 0x09300000 0 0x58000>, <0 0x09380000 0 0x58000>,
+			      <0 0x09400000 0 0x58000>, <0 0x09480000 0 0x58000>,
+			      <0 0x09500000 0 0x58000>, <0 0x09580000 0 0x58000>,
+			      <0 0x09600000 0 0x58000>;
 			reg-names = "llcc0_base", "llcc1_base", "llcc2_base",
-				    "llcc3_base", "llcc_broadcast_base";
+				    "llcc3_base", "llcc4_base", "llcc5_base",
+				    "llcc6_base", "llcc7_base",  "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.43.0



