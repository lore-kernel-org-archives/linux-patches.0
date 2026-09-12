Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDD23A562;
	Sat, 12 Sep 2026 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232295; cv=none; b=KmRsKEFrsh2Pm2D2FqN1q7w+Cq7iESO+/PLM8jlu0ITRFQyzyv0DIKA8MCd8i+Zw5NzBnZ2lvlHCsBIKWr2VrsJzwQtLIr+BcSBJN6Kh6mt32hHxdq0FD5ruWX63jNaZVmU5le6VTOxfYh9b9F3Y0A2134trfqhUdtDglu/c4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232295; c=relaxed/simple;
	bh=wUovO1MkvHqytHCnEgVMH000dm9NWmhKrHlL1981gHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uixSos19JMS9otJaAEOI2BV08tcQboX4wMnEfPNwmy1b+p+/zGNq/alsHAMM86jfySKHuPF4ALevIZgXzf0KM6qx2TLdddfT3secp5C0L/oXJWskQ1qbzssoiVDkaizG7lzCVP0r1o4f2Em/dDL1j3So8Tfox4gErXkSHBKUpfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbWwucZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbWwucZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E402F1F000FF;
	Sat, 12 Sep 2026 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232294;
	bh=uyCJdmALzRSSR3UQ1WEdv9L7bgfO/BjeIVa1FCc9lpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbWwucZDirJHpZ0gpmQ9C++aBuQTzMoV8aiOrafHt8o7/15izsHRT3G1b0dHVr63U
	 IbewgUbH3L22IKKVviMeuymJ75t6AqA1b/jugRMEuV1WmRfnUj9isyX+jBD9NTf9pN
	 r8ZoI8fMtiumTsh0Yuu9xuP+Mb/hrXWN93YyWxz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1173/1191] arm64: dts: qcom: sm8550: Fix the aoss_qmp node name
Date: Sat, 12 Sep 2026 09:05:01 +0200
Message-ID: <20260912065614.486633733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 3a63e478b3c01b7c0eddba1121200b089bf1df12 ]

The proper name for it is power-management. Currently, with the node
name being power-controller, the bindings check fails due to the
property #power-domain-cells missing.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230127131441.1157679-1-abel.vesa@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 218ebb6d41c0f..45fb37bf08f66 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1814,7 +1814,7 @@ tsens2: thermal-sensor@c273000 {
 			#thermal-sensor-cells = <1>;
 		};
 
-		aoss_qmp: power-controller@c300000 {
+		aoss_qmp: power-management@c300000 {
 			compatible = "qcom,sm8550-aoss-qmp", "qcom,aoss-qmp";
 			reg = <0 0x0c300000 0 0x400>;
 			interrupt-parent = <&ipcc>;
-- 
2.53.0



