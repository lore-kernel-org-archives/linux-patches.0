Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B552427F89;
	Sat, 12 Sep 2026 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209036; cv=none; b=M4GbKlZ6tXiMRPI4CKw19R2S2pCksRONKdBvdrj2vJoREPL0IaVjGU4lTEwQLb7rEKP0sivv4W0EL8TfDFbtyLGuumF0VkthJn3EXmqUbGAM4mMtE89bzoabgJGuGt81Nq34crWpharjKnI3ePI6HZ8nsKK5Ab8t7Ds+eFWEJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209036; c=relaxed/simple;
	bh=hr+Lnk93duTXWT9G/O4VrV5NpqjV0k4Wp6I2V44gMPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dnif96O8bLHd5D7hdrQFlx/g73CaqC9XNdfeVb3FCVWuSTMyy8Bw2Gv6eg2W66oLaoddeXUZz1ILj08+jTbVOZyYJiGeruxyI/O3ihkh7zs48azeX1MFZ00XBxcPaL+MMjJyGrwMp0+WgGP8zpNz7yw1S/oBtCgiE1eBRH5vYVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEAuifWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEAuifWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E584A1F000FF;
	Sat, 12 Sep 2026 10:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209035;
	bh=/hMB2As9HMyUrs5QYPSaNIlrQXGzqhCCsAnsXi4+g+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEAuifWQelTaCpvHlcL3brHLYlz8qITbNkRh/NCzO9E7jCxtM87p164ryhMxxCi4F
	 hoN9MBojo3wusiJmFAUX9VeYZ3DCVkK3O2P091lqjU1tVSFaqfPY+ZK/ViZtuYOXHC
	 odD81gC5FnygR2aQWioRam8+BdjUNylYS3eDsBa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0696/1518] arm64: dts: qcom: lemans: add QCrypto node
Date: Sat, 12 Sep 2026 08:47:45 +0200
Message-ID: <20260912065639.180199529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

[ Upstream commit 173c43d0e4a435a95568d6b912d0d45c37d6d75f ]

Add Qualcomm Crypto Engine device node for LeMans platform.

QCE and Crypto DMA nodes patch was applied as part of the
commit 7ff3da43ef44 ("arm64: dts: qcom: sa8775p: add QCrypto nodes"),
however was partially reverted by commit 92979f12a201 ("arm64: dts: qcom:
sa8775p: Partially revert "arm64: dts: qcom: sa8775p: add QCrypto nodes"")
due to compatible-string being miss-matched against schema.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251224-enable-qualcomm-crypto-engine-for-lemans-v2-1-a707e3d38765@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 19b4c47fc973 ("arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 9ea0bf47851b1..72d8270cf3af0 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -2773,6 +2773,18 @@ cryptobam: dma-controller@1dc4000 {
 				 <&apps_smmu 0x481 0x00>;
 		};
 
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sa8775p-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01dfa000 0x0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x480 0x0>,
+				 <&apps_smmu 0x481 0x0>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE0 QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+			interconnect-names = "memory";
+		};
+
 		ctcu@4001000 {
 			compatible = "qcom,sa8775p-ctcu";
 			reg = <0x0 0x04001000 0x0 0x1000>;
-- 
2.53.0



