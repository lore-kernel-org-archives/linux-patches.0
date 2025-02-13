Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486826B0A5;
	Thu, 13 Feb 2025 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459734; cv=none; b=TOUbB1z1tJQN8h/TIsGjI98rAejP0INzx5lZ9RNK8DZDmYZS4wr8Gv1W2Mm4NnKygXPSv/lLrO8jbWNCM+Bxb0V0EVMQ2IcSzSuQnOdQ3KVM2twZ9bOmijSWlFBcJ1TheTpT0a5ikDuwrAbsj/dVSAkJO8yLZoC1yhkmXCL7Eyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459734; c=relaxed/simple;
	bh=Gaalpc2T0jCItNSk5U85AaSI5rX2mgk64yue10rQdoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxi0+lr9HU+QCWhd12RySWa2WDw5zAAcAO8K7EhQxK2iSZlX5j0P+ljW8R2Hlb5ok9zdlUA96LSdRYKWiiorOSXQLndR23Ht4vd65Rce5s7kNN0KYamdaWHdqINZlpd/Djk4XLspDO4ZTHlQz/RKg2YPwVgY389z8zFuAIWhFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTe37eTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTe37eTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC2EC4CED1;
	Thu, 13 Feb 2025 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459733;
	bh=Gaalpc2T0jCItNSk5U85AaSI5rX2mgk64yue10rQdoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTe37eTc+Pz3csBG4hW1/B4gHJqyyah2hovt3cR50M/gxJdB8GD/2z+7hTGphBSJD
	 1o/J4wPqXRHIgLLe2DazsQpCrY6+hwJRuWk3AuWtNtgFdqJE59HKJiv/Ok50zL9QZa
	 Hsrn7Znx3UJ9SVBcBf9ymAodg32Ewvgz+F27qZM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 306/443] arm64: dts: qcom: sm6350: Fix uart1 interconnect path
Date: Thu, 13 Feb 2025 15:27:51 +0100
Message-ID: <20250213142452.423736877@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit be2f81eaa2c8e81d3de5b73dca5e133f63384cb3 upstream.

The path MASTER_QUP_0 to SLAVE_EBI_CH0 would be qup-memory path and not
qup-config. Since the qup-memory path is not part of the qcom,geni-uart
bindings, just replace that path with the correct path for qup-config.

Fixes: b179f35b887b ("arm64: dts: qcom: sm6350: add uart1 node")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-sm6350-uart1-icc-v1-1-f4f10fd91adf@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -936,7 +936,7 @@
 				power-domains = <&rpmhpd SM6350_CX>;
 				operating-points-v2 = <&qup_opp_table>;
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
-						<&aggre1_noc MASTER_QUP_0 0 &clk_virt SLAVE_EBI_CH0 0>;
+						<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_QUP_0 0>;
 				interconnect-names = "qup-core", "qup-config";
 				status = "disabled";
 			};


