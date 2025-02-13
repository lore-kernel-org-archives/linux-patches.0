Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5462222B3;
	Thu, 13 Feb 2025 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458000; cv=none; b=gymq2KICsJRpKyOJjDCaO5FzqLmlh+80uFBeeI3yBcM3rcTuA8KWM7t0xtdmDt4ymqoDbTjgpQtbOpFxcqnYiEa9kOsJMLipCgdTexqTO4H5jjeb147Y1Vzxxky9sB5K3TnoxKAkvltMdBmkA3ZqywTudOvN0327JA+eqNob5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458000; c=relaxed/simple;
	bh=6i9nRiFjR2n9dUu5KYlsui5V//HH08wb2LIaNzcja6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyijrqoIEa7G3vMsj0K7bVddjkS+aaPVzVqJXcHoCwpvr4FF/jENLBYBtjfGdFaZpma6d2vsh7IRpdL0x0YP9nKOyG0/SLmBZiIetVmSpil+lslTsHBBztGlD2iFCl522Pg65nsi4ESHVrMRFbvpWGXtbyalCFgUd5cvNAAe3g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUksTvFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUksTvFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C6C4CED1;
	Thu, 13 Feb 2025 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458000;
	bh=6i9nRiFjR2n9dUu5KYlsui5V//HH08wb2LIaNzcja6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUksTvFcDzdI/UCWPhWsdOt8DkCwsXioxsvwNXfyU+H4bW13SHI9HeG+DXqIR6aUd
	 KivJ4S+5Np77oieH7PSLIF1vohn4I0cW7TdNF6EAuj8K2bRvDqUhxT5v8MrSIAyV+i
	 zgqTBJsAgmTXEwMWoNzvXeeBg7PeZ82mtgLl2ALI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 273/422] arm64: dts: qcom: sm6115: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:02 +0100
Message-ID: <20250213142447.078356181@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 846f49c3f01680f4af3043bf5b7abc9cf71bb42d upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x4040.  Value of 0x100000 covers
entire Touring/CDSP memory block seems to big here.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Cc: stable@vger.kernel.org
Fixes: 96ce9227fdbc ("arm64: dts: qcom: sm6115: Add remoteproc nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-22-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -2744,7 +2744,7 @@
 
 		remoteproc_cdsp: remoteproc@b300000 {
 			compatible = "qcom,sm6115-cdsp-pas";
-			reg = <0x0 0x0b300000 0x0 0x100000>;
+			reg = <0x0 0x0b300000 0x0 0x4040>;
 
 			interrupts-extended = <&intc GIC_SPI 265 IRQ_TYPE_EDGE_RISING>,
 					      <&cdsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


