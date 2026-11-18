Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038074;
	b=1rtByQNR0m/DhhdN8EXqpdEpXmBv/y+fp6wIUE+2+SnCHP/hDmFigu6exMS9d3ZbjQ1R
	 ukFSedwrXSJDBAtkEyF7jzvhCjrqufU7F4SJuVMF+VWJPeAhXTs/0ZYHF/FrFvBa1WqOs
	 GpEhwSzlJpoDeLGCoMlVK5F1nFxO5o9q4/CCJtmn7ZwrHZpC9gJpU/0t9M7g87Faiv6JZ
	 pFU4twnIgW0kyNfEDNRrXOJ2ia4HhEBdm0axZTuidz0RObH5VlQlL44yfAg4GsEm5SYtQ
	 hkgbffOrFdbs36sVVz69yytvlXE7poe4bSUBMWnN1vrkIJzEtl2mfftE7fp9yu5k0EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uiREoQSbn9s1/Pl2yQATCvt8FJ9+azQh6IbrZCyNg3Y=;
	b=XhUpEy6MSZ17RvB4lZhfcAtIoTmAC5jMeCZE9JCV50vXSTB+NMZxnTDEjVqZ3oRPw274
	 32a5j4zz8gn7HdOT4+qovTmgKHbJSiCiNLkiJYMucBE8nAm2BY0kvQpHR45z3F/Gf9Kl0
	 LHqb84tau/RidxDteZ66Kqn+RP+L6CoO1Xhkr1B3twhFiWasemH/PeD8IOEeOogaoSVXK
	 TIVqKW/+Q6CQIyDjEXfnFJyVOr887qmRr5GNINkNhxVSWgojzeUZZ9Sd5A0T2ePSQ3J+M
	 +I0Doc+C3jV7nl7WFOMWUqSilkckokiBywViX1wsINXfjEzOE6I5IKPBUs836u2ae7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxvRB29a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3653606A330;
	Wed, 18 Nov 2026 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxvRB29a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03A21F000C4;
	Wed, 18 Nov 2026 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038074;
	bh=uiREoQSbn9s1/Pl2yQATCvt8FJ9+azQh6IbrZCyNg3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxvRB29aTT8IS8CCDMHxIZ4uDELK0MsIeHc0IATZhFLFW4kB2VnywOPB7rHCRQHxA
	 3dX4PUADqMc8yyywWMWiByFbu0fxENNQq06uEb1E634INCQKDkkG7D+3hqE2DvIuaF
	 jjuPWeVhLorKsupnSaazaYLZqGXjDmwRcRK0DukQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1618/3318] arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC
Date: Wed, 18 Nov 2026 15:37:20 +0100
Message-ID: <20261118150409.732839045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 117d8d40be1ded4f35f3252efa83607a7134d5e0 ]

Connect the QMP PHY USB3 output to GCC so the USB3 PHY pipe clock can
propagate to the USB controller.

Cc: stable@vger.kernel.org
Fixes: a98bfb31f676 ("arm64: dts: qcom: ipq9574: Add USB related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-4-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ sashal: adjusted GCC node context for placeholder PCIe clock inputs and power-domain cells ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 82e4fd5eb388f..8a5df358d459d 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -285,7 +285,7 @@ gcc: clock-controller@1800000 {
 				 <0>,
 				 <0>,
 				 <0>,
-				 <0>;
+				 <&usb_0_qmpphy>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.53.0



