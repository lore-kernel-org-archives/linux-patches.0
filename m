Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812FE176ADE;
	Wed, 19 Feb 2025 09:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957069; cv=none; b=GL0PsWrFuBAiNJUgTmyRPWION8y+hfSLiMsVZ5OGU73tBKMeoYwUqGEe0IoaiWpcqa/XnXnbO3wITL+oYzUSJtbpYmKkYZwcYV9y1gtzUuUodsjTTZaY5+27TRBEd6M+IkjeQhfNPv6CV5szZ2vbqPvKMJTSeeGR6EgHtW8CEoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957069; c=relaxed/simple;
	bh=uwOppEO5OMwGVj2/Dg/0gVLudpgIbxTKZYSy7AReqdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjBhwGLVGhka58WfC+YpkiDBhEJ0eDp0HuiygHW/PsOHQFjYbowaSkb5qSbTXglfQYrutg/0CMAX762LhD3ICil+9GCDGMGHW0TOjcq7DFNsmQE1nYh2+Tie54hcRTmEmSftcogU/E3vXyfKe+UBmAio/LkOg/YqHahL4b+GnRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMpr56hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMpr56hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A8C4CED1;
	Wed, 19 Feb 2025 09:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957069;
	bh=uwOppEO5OMwGVj2/Dg/0gVLudpgIbxTKZYSy7AReqdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMpr56hb4IDKl6D5/FraSDy4RurqYVVkj/1o0QP6v0zGoSiLy0MCv+JZYfT6zPnF0
	 k834+25p+ra+b+Rs9QOD30aKaT+uVWJzcbCV9tP47BWQ3QDmVuTYhFlGbaUgcLu7Us
	 n9kxHQZ2QyV6p8fXfsU3I7GtOvyoccYpIN3CBBmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 398/578] arm64: dts: qcom: sm6350: Fix MPSS memory length
Date: Wed, 19 Feb 2025 09:26:42 +0100
Message-ID: <20250219082708.679636550@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit cd8d83de9cc9ecfb1f9a12bc838041c4eb4d10bd upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 489be59b635b ("arm64: dts: qcom: sm6350: Add MPSS nodes")
Cc: stable@vger.kernel.org
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-16-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -923,7 +923,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm6350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_EDGE_RISING>,
 					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


