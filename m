Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC561624D5;
	Mon, 24 Feb 2025 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407930; cv=none; b=JjVi3dvLH8tfaJoecfU0SsPeCCvdyYFTq15RCc1B2p80fPSWweUvstDw3wXEahgNNlECMM2uey6W39VkKM8+SPnA8zbyNUZuX3htm681JFrHdSxb9QCUb1AefN+S28u5thPDucsuZR4eg5KTsMK1Z8H8tBcSF0CflavdrBn8dGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407930; c=relaxed/simple;
	bh=Y7X2OXiQFh6khghTjaC/80bezUNgo5FSs2eJ9FrEyBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxP29uB30xJXxbLtYYPG7l0xntR2pIStpi7YBGKSHGo34mVMg+J3f6XvSWqD9pwz0JnuhTiU7UAQp9EexyPjYoLGmDMFPqCog8CtGsApREzOPzDkUWV1X0w6gGRCjIgfoiju/WSCx0i6kGQEA0nOsZDWyliYftNtH8LE+sx7BOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/yQdQ0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/yQdQ0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3BBC4CED6;
	Mon, 24 Feb 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407930;
	bh=Y7X2OXiQFh6khghTjaC/80bezUNgo5FSs2eJ9FrEyBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/yQdQ0/ZCCni49Qkk2wkqd5TiRWTHApUZgDSNuwqChUZxrQxsY3sjcvaQcdR0+gG
	 zA40RBs5JGQvd8njQ7f1WLd6L7tMvPSLVf29gwIjyKI9e+7pfcY1dB+jIjfbbVuiSA
	 JQrOpQke2O4ESfjMhdnlTIQ7/4P7f9lKAYnRvywM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <quic_lxu5@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/140] arm64: dts: qcom: sm8550: Add dma-coherent property
Date: Mon, 24 Feb 2025 15:34:09 +0100
Message-ID: <20250224142604.980436439@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ling Xu <quic_lxu5@quicinc.com>

[ Upstream commit 4a03b85b8491d8bfe84a26ff979507b6ae7122c1 ]

Add dma-coherent property to fastRPC context bank nodes to pass dma
sequence test in fastrpc sanity test, ensure that data integrity is
maintained during DMA operations.

Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Link: https://lore.kernel.org/r/20240125102413.3016-2-quic_lxu5@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: a6a8f54bc2af ("arm64: dts: qcom: sm8550: Fix ADSP memory base and length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index f3a0e1fe333c4..51407c482b51f 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -4006,6 +4006,7 @@
 						reg = <3>;
 						iommus = <&apps_smmu 0x1003 0x80>,
 							 <&apps_smmu 0x1063 0x0>;
+						dma-coherent;
 					};
 
 					compute-cb@4 {
@@ -4013,6 +4014,7 @@
 						reg = <4>;
 						iommus = <&apps_smmu 0x1004 0x80>,
 							 <&apps_smmu 0x1064 0x0>;
+						dma-coherent;
 					};
 
 					compute-cb@5 {
@@ -4020,6 +4022,7 @@
 						reg = <5>;
 						iommus = <&apps_smmu 0x1005 0x80>,
 							 <&apps_smmu 0x1065 0x0>;
+						dma-coherent;
 					};
 
 					compute-cb@6 {
@@ -4027,6 +4030,7 @@
 						reg = <6>;
 						iommus = <&apps_smmu 0x1006 0x80>,
 							 <&apps_smmu 0x1066 0x0>;
+						dma-coherent;
 					};
 
 					compute-cb@7 {
@@ -4034,6 +4038,7 @@
 						reg = <7>;
 						iommus = <&apps_smmu 0x1007 0x80>,
 							 <&apps_smmu 0x1067 0x0>;
+						dma-coherent;
 					};
 				};
 
@@ -4140,6 +4145,7 @@
 						iommus = <&apps_smmu 0x1961 0x0>,
 							 <&apps_smmu 0x0c01 0x20>,
 							 <&apps_smmu 0x19c1 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@2 {
@@ -4148,6 +4154,7 @@
 						iommus = <&apps_smmu 0x1962 0x0>,
 							 <&apps_smmu 0x0c02 0x20>,
 							 <&apps_smmu 0x19c2 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@3 {
@@ -4156,6 +4163,7 @@
 						iommus = <&apps_smmu 0x1963 0x0>,
 							 <&apps_smmu 0x0c03 0x20>,
 							 <&apps_smmu 0x19c3 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@4 {
@@ -4164,6 +4172,7 @@
 						iommus = <&apps_smmu 0x1964 0x0>,
 							 <&apps_smmu 0x0c04 0x20>,
 							 <&apps_smmu 0x19c4 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@5 {
@@ -4172,6 +4181,7 @@
 						iommus = <&apps_smmu 0x1965 0x0>,
 							 <&apps_smmu 0x0c05 0x20>,
 							 <&apps_smmu 0x19c5 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@6 {
@@ -4180,6 +4190,7 @@
 						iommus = <&apps_smmu 0x1966 0x0>,
 							 <&apps_smmu 0x0c06 0x20>,
 							 <&apps_smmu 0x19c6 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@7 {
@@ -4188,6 +4199,7 @@
 						iommus = <&apps_smmu 0x1967 0x0>,
 							 <&apps_smmu 0x0c07 0x20>,
 							 <&apps_smmu 0x19c7 0x10>;
+						dma-coherent;
 					};
 
 					compute-cb@8 {
@@ -4196,6 +4208,7 @@
 						iommus = <&apps_smmu 0x1968 0x0>,
 							 <&apps_smmu 0x0c08 0x20>,
 							 <&apps_smmu 0x19c8 0x10>;
+						dma-coherent;
 					};
 
 					/* note: secure cb9 in downstream */
-- 
2.39.5



