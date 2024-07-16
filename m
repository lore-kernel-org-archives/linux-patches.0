Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9B019E7C6;
	Tue, 16 Jul 2024 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144946; cv=none; b=pW091gkkAZd3mIJ33JYiD6nLy2GhOIz4dCqgdVz6U7pb0Wa6qlM3ngUj8ZlJhiS/GMbg9S77zDNyBSbAfXS+YabrTU+O+3/8j9Y5FagnMQc2r1iMPtsk4CBC/x81DTftnmKlsns6TpslEcHz1ERB7nU+aFJgSX3x3O17OWedobM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144946; c=relaxed/simple;
	bh=Uf6HwnpM7fW92u9IffeKmi4t9f5jeE3+Al/+DOtuC54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6aYEQ5K5eed7VgLe33CiDcBabEoMeeOb5HPlNSYp35P8xUwomGQEA2OxVSDMQqjeohzyCrcKghQT6gQYnuAHSirNDJAUyO1zgWWgTYTlFmsiztMOT5Bq5VeNDcM6uEI7cP73XJreLKy6rRJSVG7spOCW5XAYATuFLywTI38T08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fidfcqhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fidfcqhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98309C116B1;
	Tue, 16 Jul 2024 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144946;
	bh=Uf6HwnpM7fW92u9IffeKmi4t9f5jeE3+Al/+DOtuC54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fidfcqhwKpXDZwKC6ARKyrxO7di/ah16RSYWKm4oyAlkKffkKBNgZeSxZZN3rqDu4
	 G2cyE0VqzME8k80m+Hqdbc6bPp5blVCTcQWp9csMQq+BB8U6rbssab0aOSHoIx+ter
	 6PEQTbexQFwPgDXcedzOBBW0M3fJbX43a17Nj8Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 048/143] arm64: dts: qcom: x1e80100: Fix PCIe 6a reg offsets and add MHI
Date: Tue, 16 Jul 2024 17:30:44 +0200
Message-ID: <20240716152757.834737519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 8e99e770f7eab8f8127098df7824373c4b4e8b5c ]

The actual size of the DBI region is 0xf20 and the start of the
ELBI region is 0xf40, according to the documentation. So fix them.
While at it, add the MHI region as well.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240604-x1e80100-dts-fixes-pcie6a-v2-1-0b4d8c6256e5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 6b40082bac68c..ee78185ca5387 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2737,15 +2737,17 @@
 			device_type = "pci";
 			compatible = "qcom,pcie-x1e80100";
 			reg = <0 0x01bf8000 0 0x3000>,
-			      <0 0x70000000 0 0xf1d>,
-			      <0 0x70000f20 0 0xa8>,
+			      <0 0x70000000 0 0xf20>,
+			      <0 0x70000f40 0 0xa8>,
 			      <0 0x70001000 0 0x1000>,
-			      <0 0x70100000 0 0x100000>;
+			      <0 0x70100000 0 0x100000>,
+			      <0 0x01bfb000 0 0x1000>;
 			reg-names = "parf",
 				    "dbi",
 				    "elbi",
 				    "atu",
-				    "config";
+				    "config",
+				    "mhi";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			ranges = <0x01000000 0 0x00000000 0 0x70200000 0 0x100000>,
-- 
2.43.0



