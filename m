Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D863043B2;
	Wed, 28 Jan 2026 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615472; cv=none; b=bPTv5Hy972afnOf92uUmt9/Yf7B75E+zECoOfFDq+VlfE2MbY+M6Y/FwBamN8uVZzob8Tt19uniE75cmmzkzYQm/Jku9qXu+dykio49KDiDWlrl9cQ5qWn1PxFZVKb98ewHm+A8ygCJWFqQTX3gD5kbowY+ULYADKeN0jcMzirc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615472; c=relaxed/simple;
	bh=KfDapkdmXOemZPdIkN057Tl/bKsDqTELtIaF3U9Dwfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5Xpt45xy4trlsW+2X1au6l5tHYz488Hp5kCN5KPRJEhrp6oRwiDiO/B3tOUKy2dPz7tIVL2qdmpJ4gWEoonCufO5UW+vlyW84w36ZXWX1yJh1H2o4YmTLYR5oji9X/8LmCw+NSORiJuzMjjSmj5kIZrmLMelJooY4ipd2OTGdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4/XFkD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4/XFkD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04088C2BC86;
	Wed, 28 Jan 2026 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615472;
	bh=KfDapkdmXOemZPdIkN057Tl/bKsDqTELtIaF3U9Dwfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4/XFkD4v6F9FFhu6pp7mANNT1ipG0WBPxB2QH1CmExrRpYjWtK6MglsLU3hXPMDz
	 /2oDs2mCUvlCj2y1Y5ifiFgMssRdsd9+mxHgqDxihxVNBPqpetKF9UPjb70IxH/sQo
	 AfceqzfdbxTSykZ3FjQVgGZgA/IaARJlvK6k1Y0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/227] arm64: dts: qcom: sm8550: Fix compile warnings in USB controller node
Date: Wed, 28 Jan 2026 16:20:47 +0100
Message-ID: <20260128145344.424953610@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 9dbc9bed01837717b8ab755cf5067a6f8d35b00f ]

With W=1, the following error comes up:

Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

This is because the child node being removed during flattening and moving
to latest bindings.

Fixes: 33450878adfc ("arm64: dts: qcom: sm8550: Flatten the USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251203144856.2711440-2-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7724dba75db79..e294dc9c68c9a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -4097,8 +4097,6 @@ usb_dp_qmpphy_dp_in: endpoint {
 		usb_1: usb@a600000 {
 			compatible = "qcom,sm8550-dwc3", "qcom,snps-dwc3";
 			reg = <0x0 0x0a600000 0x0 0xfc100>;
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			clocks = <&gcc GCC_CFG_NOC_USB3_PRIM_AXI_CLK>,
 				 <&gcc GCC_USB30_PRIM_MASTER_CLK>,
-- 
2.51.0



