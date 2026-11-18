Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016151;
	b=z4MmimdsZ7ATryd34lntjm2eG00U+IUSM/1fZRPre2II1VXXoS4LOOXdMvnv5RNM4jD9
	 fiuUQ1ktoTaZCnOFG73x60b35y9R520Lijfiod1PJuqHQRy2znH0pTc3cAMVQW4yIO39n
	 W+EEwiNvQA2dBBxSOMx04oIGQ1IxwTR1HAtyjQe02QjIEmqXc3lK4zX4iLikNEUOKAna6
	 r92nB6PEIuW+3gU+rCITGDBoqvPmlwZQoTvf3xLsjosppxMWzxoak/E9fUDf/hnkuYBoe
	 EXaW2lkKm/h2aXzCDcBViBLtjI+gFs/pTWTcr844zpalfdb1A9uk64FNWisCSAxJI7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=taN+1CaRNOSyO8HEOt2HelXz0+21C/hvGvracpMxVAY=;
	b=m8To4jlYQaHLWl3gPMsF+AjbqQRHK7NLgA4FRe3c8OHTgnf4PYHf1yfba/HoFSUQOMfS
	 vohFRBJ73NALtqG3Mi+psAZsQdJqxHdcvN+Q1R3AcwTgY+svhJBddlDTr5RnpWxJezNf4
	 IVo5TIGkYiiDsnB9ziOMgYBz89Xh4pMsExfEEnUpm75ITxgfgUc7wv8oOud4hbL7Eeixs
	 FnmQp4DP2geVHFA5vEGLk7ZYdFYRzsLScxN3n8iuaKPKa5xcJP/pq/hBtzfSn7ThmswpZ
	 cVw7KFM1XUSk5QL+9yAFbcixNczL0RXc4m5b6ayB9iXR4dvsPcpgZFnl2VqfYWRnmeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6cYUr0Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C4060A2620;
	Wed, 18 Nov 2026 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6cYUr0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18481F000CF;
	Wed, 18 Nov 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016151;
	bh=taN+1CaRNOSyO8HEOt2HelXz0+21C/hvGvracpMxVAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6cYUr0Y9ljR2b8hRU/r2D59QNLo3LtgvKEXMMpVY2SApUAEYJDh1F5MTkigeThKV
	 Sdc2mJMQRm0GxS/NzvBzLKynbCY34HiPxqVjoJz/WrYhhjrq/SRJc9RO0LYLUyCjSK
	 VEYsIdhw7MCCkgCBCWUB/SqVYC5Wg1CubsoQfGEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0385/2651] arm64: dts: qcom: eliza: Connect USB3 PHY pipe clock to GCC
Date: Wed, 18 Nov 2026 15:27:05 +0100
Message-ID: <20261118150301.693524121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 1c34e5dd83217f8952c8d96f9851981999acc8b7 ]

The GCC USB3 primary PHY pipe clock is sourced by the USB3 pipe output of
the USB/DP QMP PHY. The corresponding GCC clock input was left as an
empty clock specifier when the USB nodes were added.

Connect the QMP PHY USB3 output to GCC so the USB3 PHY pipe clock can
propagate to the USB controller.

Fixes: 88ddafb01ec0 ("arm64: dts: qcom: eliza: Describe the ADSP and USB related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260826-dts-qcom-eliza-add-missing-usb-dp-phy-clk-to-gcc-v2-1-bf6746a849ba@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/eliza.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 66ea4aaafd73a..45853c11a03c1 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -655,7 +655,7 @@ gcc: clock-controller@100000 {
 				 <&ufs_mem_phy 0>,
 				 <&ufs_mem_phy 1>,
 				 <&ufs_mem_phy 2>,
-				 <0>;
+				 <&usb_dp_qmpphy QMP_USB43DP_USB3_PIPE_CLK>;
 
 			power-domains = <&rpmhpd RPMHPD_CX>;
 
-- 
2.53.0



