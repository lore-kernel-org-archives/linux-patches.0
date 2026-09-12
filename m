Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138DE3E40F3;
	Sat, 12 Sep 2026 09:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206461; cv=none; b=pG/l+ENNzolUZHGN1l4SAnjSr+YIbR6l+bLaeafq6megXfZfXYjvbLfLRH3F9Q+LfjdjnAezHNmzQIBI3D9xC6WnZm8qnY+QS2qMMnXHa1KChB7Lz6hWZRGqd3k3MkKZO89RZGyT7ssWZF+L1amigmnKqVURwL409qVj3uiZVVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206461; c=relaxed/simple;
	bh=QQvvYSFi9ZsX4tISwgcEk0IW1aY370XT1/QjC59xLIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtJMUfHtMQ02e2tfnlta4DLrUm6evNB3BsJoMrvvgs861VUQ+CSb4A2SmA8/yU1DFb68n75oAV2JUO2oORVREAJYx9wiDrHmPAmf4r+5SLlPXm+dfbsIzRbkaz5xNNH5IHMa8+S3fnUBkdzBoKy1lVlMqMkQFfmbNKtevAOeUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jq01gdDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jq01gdDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D221F000FF;
	Sat, 12 Sep 2026 09:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206459;
	bh=xv53o+sDPQFKyAb42tHvlfRPNJGIzHgbNgVx3xxnaE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jq01gdDiRMykrXTzvqOlmppdovcQIksO+V2C5TJ7XPPqHssn/aMHQRil+K1Cva6Pv
	 heAgxFpLJ5O6GESHDX3F/K3glFpfivTJirLLaLlQvELlEqd9HpbDf8uEhknG7d72oP
	 q0In0056ZoBkJAIpFz184/qmnDjCy+oq9FM2gpbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH 6.18 0211/1518] arm64: dts: qcom: sm8750: wire UFS to ice instance
Date: Sat, 12 Sep 2026 08:39:40 +0200
Message-ID: <20260912065628.261995122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit ac456227d22952b656ad291ebd2d3d3e498e3d95 ]

The Inline Crypto Engine (ICE) exists as a standalone DT node, but the
UFS node lacks the required qcom,ice phandle reference.

Add the qcom,ice property to explicitly associate the UFS controller
with its ICE instance.

Fixes: d288abc3a70e ("arm64: dts: qcom: sm8750: Add UFS nodes for SM8750 SoC")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> # on sm8750-mtp
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429-sm8750_ice_dt_fix-v1-1-2540dc337082@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 2760c4f7e6f35..b714207e4c158 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -3558,6 +3558,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phy-names = "ufsphy";
 
 			#reset-cells = <1>;
+			qcom,ice = <&ice>;
 
 			status = "disabled";
 
-- 
2.53.0



