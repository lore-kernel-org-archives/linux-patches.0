Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBD2330B03;
	Fri, 17 Oct 2025 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715835; cv=none; b=aKbmfDeszrAxmN6FquNChYVZDc2mXlsusGc646AroXuTJBk3mMUDZMleuAxxLW9n/jbvtChZ+O7n0g8wXPAiVP2L0j+FHT26VwrSeYtYJYJaduPrVGAn5TIOUwUdXBYLBv1+1fE8WgK/wgqakGhBaPOM4YPL3oQEGBs0UQ49Eas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715835; c=relaxed/simple;
	bh=IIuYaI7EJ6s8AZ+/VtBNJrv9eujYMXjof7Wq7eN8/H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDJaQDUnKcqUABdrmJJisGGoQ8G8GLcNR+pqHC+iwG/StDtxSrJGcBqLw5sDukNtn4lO/k297DKDpBO3BTO6seDsYVzJ8mB0OWBrmpX+U+Riuk1gBFAhgWGbnDm1ylNEjMANhX7CcP2T10Nn+ReSN1CPvyfdsGzMzLyfOWKU0sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEX1H6D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEX1H6D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84836C113D0;
	Fri, 17 Oct 2025 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715834;
	bh=IIuYaI7EJ6s8AZ+/VtBNJrv9eujYMXjof7Wq7eN8/H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEX1H6D19Eqhd9BpO4zG8g0rjHxdjZzp2/4hxz+dzM0W8eCRf+WYHGJvcBfVGGw+f
	 BdcWbDR7vPE0o4ISe3j5PhnHor6ZNm8YVMPJWayHNoVHocUKKqLbvDTIaYsiicUBJo
	 Gm2t6Vo3j1j9so7cu0zRf7CVxrVv/gLD0U/zIpr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 354/371] arm64: dts: qcom: qcs615: add missing dt property in QUP SEs
Date: Fri, 17 Oct 2025 16:55:29 +0200
Message-ID: <20251017145214.893160884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 6a5e9b9738a32229e2673d4eccfcbfe2ef3a1ab4 ]

Add the missing required-opps and operating-points-v2 properties to
several I2C, SPI, and UART nodes in the QUP SEs.

Fixes: f6746dc9e379 ("arm64: dts: qcom: qcs615: Add QUPv3 configuration")
Cc: stable@vger.kernel.org
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250630064338.2487409-1-viken.dadhaniya@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -631,6 +631,7 @@
 				interconnect-names = "qup-core",
 						     "qup-config";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				operating-points-v2 = <&qup_opp_table>;
 				status = "disabled";
 			};
 
@@ -654,6 +655,7 @@
 						     "qup-config",
 						     "qup-memory";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				required-opps = <&rpmhpd_opp_low_svs>;
 				dmas = <&gpi_dma0 0 1 QCOM_GPI_I2C>,
 				       <&gpi_dma0 1 1 QCOM_GPI_I2C>;
 				dma-names = "tx",
@@ -681,6 +683,7 @@
 						     "qup-config",
 						     "qup-memory";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				required-opps = <&rpmhpd_opp_low_svs>;
 				dmas = <&gpi_dma0 0 2 QCOM_GPI_I2C>,
 				       <&gpi_dma0 1 2 QCOM_GPI_I2C>;
 				dma-names = "tx",
@@ -703,6 +706,7 @@
 				interconnect-names = "qup-core",
 						     "qup-config";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				operating-points-v2 = <&qup_opp_table>;
 				dmas = <&gpi_dma0 0 2 QCOM_GPI_SPI>,
 				       <&gpi_dma0 1 2 QCOM_GPI_SPI>;
 				dma-names = "tx",
@@ -728,6 +732,7 @@
 				interconnect-names = "qup-core",
 						     "qup-config";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				operating-points-v2 = <&qup_opp_table>;
 				status = "disabled";
 			};
 
@@ -751,6 +756,7 @@
 						     "qup-config",
 						     "qup-memory";
 				power-domains = <&rpmhpd RPMHPD_CX>;
+				required-opps = <&rpmhpd_opp_low_svs>;
 				dmas = <&gpi_dma0 0 3 QCOM_GPI_I2C>,
 				       <&gpi_dma0 1 3 QCOM_GPI_I2C>;
 				dma-names = "tx",


