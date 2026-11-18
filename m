Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017411;
	b=P9AZyhBZTYMRwL3xKqqnnDIcYvoCm79vz2unew6AY/Fqt0HBgEvTabkB/HlWX6b/mPZI
	 Ni3yJfG/5U444wBqFOy52sFqmkpN3iVlgRAgwDm94nLqLkhee/r0pFAWRkUhDdF2sqkEq
	 kXvHfp2uXq8CqQ97FIggC83PFEMm20fJV7LqQBipTuldw3KSdVhdGNMXxlYZI9vB3Ark+
	 YY+CdiUHOuBrWEm+bvEYWjg9a4v/99OeEz9DLv/cQwJZy+b6wP0wsqcDiCGKv2eoRRgZw
	 SMOJ+4v/crvDq2Kvyq5jGBraRliRTonDZVhNpcyDcq0zkNqpLmS7Z8iwt63zlRNpokg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=luGQfw48PCqZSaeaYYAyKFp0YotEZF75epvXAJGAkWo=;
	b=RDtgG91ltn+WYVT0rhQJ+mmyJ6oyz62U9O8Uw8NQmcvJ62gUPQO3WVcEuULHLB3/2hyF
	 8YPDurOXPIJueornF+bHiyPtX8kLevHyP00vPzd8+J+iAC1HsQSuDeCftH5kzqbuVk7ts
	 dGEDZGgK/wcUv6Orvbe41zGl4y45pD6lw1SC3xsRem/lABXC/YHa5B8J+uL1GkjLJklgp
	 i39Fh3wCGt7mA6hg5GmNbj1VeSqenJQ+xcYXoaXPjfvMQRRZURIJJHc7KI3sTOvRRsakJ
	 0CoobgUezFP0VQODpMCEzMJ1JycV2igVqmHG7puPpRDCTuTlhtU/TlIAgggrwUkmVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECcPWmm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369DB606A325;
	Wed, 18 Nov 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECcPWmm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595521F000C4;
	Wed, 18 Nov 2026 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017410;
	bh=luGQfw48PCqZSaeaYYAyKFp0YotEZF75epvXAJGAkWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECcPWmm7BIObc481zSKN3ODVIycH7nBC75R4hi7HvEsp9MHC8vluuOsQuhk6+8JRg
	 y5snizWFVTZj5LPA/G504XWZgmr5e13zfmnZ8jTJN7Qf4kBePwLT3cu+F01h+tbmSP
	 ZPsWkjj+iFTnRl7iqtv5JSnxqs2IibTaUaaIz2YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0876/2651] arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118150319.393335561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit 0d567fb7def9564d15c334ec0fa5f5f6a0114ffa ]

Both SerDes PHY nodes were configured with 'phy-supply = <&vreg_l5a>',
which was incorrect on two counts: vreg_l5a is not a supply the PHY
requires, and only one rail was described where the hardware needs two.

The PHY requires vdda-0p9 (vreg_l4a) and vdda-1p2 (vreg_l1c). Replace
the incorrect phy-supply with these two named properties on both nodes.

Fixes: 5ef26fb8b3ed ("arm64: dts: qcom: sa8775p-ride: enable the SerDes PHY")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-4-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
index 144f117ba5116..72f7457047222 100644
--- a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
@@ -856,12 +856,16 @@ &qup_uart17_rx {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
+
 	status = "okay";
 };
 
 &serdes1 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
+
 	status = "okay";
 };
 
-- 
2.53.0



