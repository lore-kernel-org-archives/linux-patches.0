Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C7E1DFD89;
	Wed,  6 Nov 2024 12:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896477; cv=none; b=jXG0xRMRbbwVpj5QBOx/MOVUCYAV2mO4I/+QD4de2CxkuO9FekNZelaIH8rUI0yc6bbkZZ4UhWRuCqYtYpURPj6MQfWMlG2nyoiM743GtezE+oEEwQTCeXcea2KztR7F5LMuTM32Bzymf9ObW3Rrx8phz0CaTHs1Ccf5Q9aU+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896477; c=relaxed/simple;
	bh=7/nvfeGtR8GQIeO9J6oBU+IJlbxVKPiTIY/Qcni8ZR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQyKBFVzEh3vbkLMRVlFMhD2+lbL9gqCSUC9/eJubOPIVrEBt8lglidQGXo2DIk2EHx3R/rSZxgZPdcWtgKCT31wGQOejTf6DVu8tdRuq0q5BtjwWcr4uPp2guZBfua+kCr50uKmYKMqYYKsYsjgZyYw37z7puMTb1WZP6rIKt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEk9tduf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEk9tduf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15161C4CECD;
	Wed,  6 Nov 2024 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896477;
	bh=7/nvfeGtR8GQIeO9J6oBU+IJlbxVKPiTIY/Qcni8ZR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEk9tdufQuGDs3l8Z84pcwEDErlM3KBGU1IKG20dNIPo7ZA+IUyQDbbnInXnH6A8z
	 FUoeNcK71/mpcl2MGosfmQ6W+D9CTiDyixaxRDpF8sQemdzVfM2XUDMM+8RDPDJjn2
	 LeyCeUuiHmZMqDeU38opbN+zrTwcOepjWdNrWgTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 215/245] arm64: dts: qcom: x1e80100: fix PCIe4 interconnect
Date: Wed,  6 Nov 2024 13:04:28 +0100
Message-ID: <20241106120324.547435679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit f3bba5eb46ddb8f460fc808a65050a9bf2f7ef23 upstream.

The fourth PCIe controller is connected to the PCIe North ANoC.

Fix the corresponding interconnect property so that the OS manages the
right path.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Cc: stable@vger.kernel.org	# 6.9
Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Sibi Sankar <quic_sibis@quicinc.com>
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241024131101.13587-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -3068,7 +3068,7 @@
 			assigned-clocks = <&gcc GCC_PCIE_4_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			interconnects = <&pcie_south_anoc MASTER_PCIE_4 QCOM_ICC_TAG_ALWAYS
+			interconnects = <&pcie_north_anoc MASTER_PCIE_4 QCOM_ICC_TAG_ALWAYS
 					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
 					 &cnoc_main SLAVE_PCIE_4 QCOM_ICC_TAG_ALWAYS>;


