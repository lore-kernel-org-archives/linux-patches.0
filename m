Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015562;
	b=wqewbqYf2+4X5rD4p04Vd/VdQSYOlMbwaOfOgqahYdWdqjYsDgHlqaTEx4Mt+Kcf0Ol4
	 Syd5ybRC1RmF99ptVwEQDZ01zdr5qD6GmTfVaFLn+tAvSJ1VVf/LWP88xwEgLd5GFVXk3
	 kBvSz3FsCJBgIm+A63rn2PilvCpJLQRxnKjIAqOHhOXxPTo+R78CSxEUUTpUGWxFuzzSC
	 11i6OF6Tx9/ICNbQUlRG8odChpczB4mzUu6098C/syK4jP6sBuO2Xy0NtV89FO5Y4u6xx
	 OxmyBuc/3nvgeI71Zj/xN133zTF4rZ9EqZl38OFQbe5LeuIpioMFQjnr+ps+rZE+EgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q77pMvtUgNvouBxkDyuwBvFLknCHlUkTwTPDkvlR/ao=;
	b=NfQe1fdAdx01fmtkDhBAcw3fKERqziC8aO20tG2Vruuxw/ZI711i5s7+B61o02ROCbu8
	 ssJG8cwHFtnsFodlnZjyTv3v3i725JcYYAzuIzOTqk4/iWuupa0Pbk9H9uJXRTi4yHrlb
	 h3DvZzh5TbBxwIZh/1PgrqK58KvU4RhenQdNlASwTeBIuY4gSfh4jRDfpLZs7mvs/YLIC
	 loQijHMekmo0zWcwK5Tz0/c04eQRkqoF4+JM52hszQcefOHvJ/KGaXxGXd8RkIbDQK1jv
	 MfrwMjw4WnFtqryS/dQB1sBT9+oRTnmh2zj0HmXgZtJ8rErhJzHO8ZQ/fxD8M+YsPAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdByoHvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D052A60A2602;
	Wed, 18 Nov 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdByoHvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4C1F000C4;
	Wed, 18 Nov 2026 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015562;
	bh=Q77pMvtUgNvouBxkDyuwBvFLknCHlUkTwTPDkvlR/ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdByoHvXvUkwF+NH0PbKQMRp13HcXL5iMWbI3IH4lk4GoUmc7GhU2PO77He1EXAuv
	 //+5ZVbwl5E5dTm/JhwO009ZBPAycCqx50Y/OPmhW/eXZp0w54zEybQUMb0g8ZLJMb
	 XQpldGl6QlQcXuxxdyk4iwjKK4RCGwvWt5Q69DcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0219/2651] arm64: dts: qcom: purwa: Drop the Hamoa workaround for PDC
Date: Wed, 18 Nov 2026 15:24:19 +0100
Message-ID: <20261118150255.752038884@linuxfoundation.org>
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

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 13ca1c0b7d8a3ab1e59cb3e780c1dd7441e22515 ]

X1P42100 (Purwa) shares the X1E80100 (Hamoa) PDC device, but the hardware
register bug addressed in commit e9a48ea4d90b ("irqchip/qcom-pdc:
Workaround hardware register bug on X1E80100") is already fixed in
X1P42100 silicon.

X1E80100 compatible forces the software workaround. Use the X1P42100
specific compatible string for the PDC node to remove the workaround.

Fixes: f08edb529916 ("arm64: dts: qcom: Add X1P42100 SoC and CRD")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806-purwa-pdc-v4-3-62467f4b4ddc@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/purwa.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/purwa.dtsi b/arch/arm64/boot/dts/qcom/purwa.dtsi
index c698e6cb2543c..4348dd3d1dc59 100644
--- a/arch/arm64/boot/dts/qcom/purwa.dtsi
+++ b/arch/arm64/boot/dts/qcom/purwa.dtsi
@@ -224,6 +224,11 @@ &pcie6a_phy {
 	compatible = "qcom,x1p42100-qmp-gen4x4-pcie-phy";
 };
 
+/* X1P42100 PDC is same as X1E80100, but without hardware register bug */
+&pdc {
+	compatible = "qcom,x1p42100-pdc", "qcom,pdc";
+};
+
 &qfprom {
 	gpu_speed_bin: gpu-speed-bin@119 {
 		reg = <0x119 0x2>;
-- 
2.53.0



