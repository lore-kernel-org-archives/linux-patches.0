Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE2158D71;
	Mon, 29 Jan 2024 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548063; cv=none; b=NFtf6Av58vALGxL4EMWsXiRdYg7cY8U8/e1q9CMNMmnv6mJC5ToR2aqdPeLuLkMzDtBq56mD/Vi1Cpkx3EvMKSiRd2uf//hXIKZoAzIkJqm/6sx4okC0QcMSF6Nx77FrntP9MCQnxclTxXZMehVnphaMtwOmHW8mnHVKLmxdVpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548063; c=relaxed/simple;
	bh=hJygC1NoUfuWdhEBoRYWVBt5o72TLGiqqo5FCUXFmkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/h01wIUZwek0JwQ6AT0gdckFN/QPj9bBpxTAgGk2nbur4Jr1K5Tv2PtAZBRYTL1u70aw1cxpDWWO3gCLEYJMtllHSLTkfvY9w62cDqLLTVIOgNMcGIXUncfjd8/eo1zyC7990IUgVwj9tZLnxk6xJrZ0WIWVE4X1GGcMW2gDic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQkhpiBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQkhpiBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2998C433F1;
	Mon, 29 Jan 2024 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548062;
	bh=hJygC1NoUfuWdhEBoRYWVBt5o72TLGiqqo5FCUXFmkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQkhpiBh5uAhq3GEH2+Q5mVgzjsknF53vdZq6R1EBKGXPULUOBeG8qFmlOnx1RqMq
	 NCOMbp/2sf5TaVjOFxt+H1m3wlTXqJC+LWeepFspUAvud4rzD9lF5KPftU6T0bJxek
	 EkH4awbpgC+B1eT9r9/uBKv7TKIEVnS7b9O984OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 069/346] ARM: dts: qcom: sdx55: fix pdc #interrupt-cells
Date: Mon, 29 Jan 2024 09:01:40 -0800
Message-ID: <20240129170018.416363318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit cc25bd06c16aa582596a058d375b2e3133f79b93 upstream.

The Qualcomm PDC interrupt controller binding expects two cells in
interrupt specifiers.

Fixes: 9d038b2e62de ("ARM: dts: qcom: Add SDX55 platform and MTP board support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -612,7 +612,7 @@
 			compatible = "qcom,sdx55-pdc", "qcom,pdc";
 			reg = <0x0b210000 0x30000>;
 			qcom,pdc-ranges = <0 179 52>;
-			#interrupt-cells = <3>;
+			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
 		};


