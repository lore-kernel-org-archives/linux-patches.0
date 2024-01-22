Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3514A098;
	Tue, 23 Jan 2024 00:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969199; cv=none; b=LD1AfUjX25xvl3oD3cdqAVpQieJJ3ymm6wHQncKcFvFnpuauykwWMH1FZibb7ujW8PLW0X20GoYMHlKgqhwPCsc3SzxTojam9vRInx894jeKnrsyi7I4deoIpZOH/By4sAuJawqc+2KuIVmncyKuF9+MsvK0iBfJrddOfqbWlfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969199; c=relaxed/simple;
	bh=0iULTJcoVxFpkRocYFBfdrdDl2XahsJiHLjVnpahO9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tr6BInGnleccx67bzaaLGNtHjCdURLTYpGTr7Wm+GJFMC8m0r3dTWfEcsi/pfl5WxiQZ8MXxS4tWv45n3JWf69/IUvlRh46Rs5R53AbgvFYpTb5M1tjllrgF+MISOkrc0myAYEbvzFFqQTZfLgLaQopIinQpkPQjAXDgRnyTYlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcno3Oad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcno3Oad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CFAC433C7;
	Tue, 23 Jan 2024 00:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969199;
	bh=0iULTJcoVxFpkRocYFBfdrdDl2XahsJiHLjVnpahO9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcno3OadkCcXqGeyYwiGSb7kt8gbsGfi1rJ9J/t21q8erP/42NN3HHm+pWCgGA6MK
	 E9x5TLkgaiKHBXj3Gh2nn9JFq65LSFPQW8gFOSQyNviCmTNxeM3IYAuMf0s7CkoOlW
	 UXZwoIv9dOqdcO5QLA280sU31+5x0eqNOTa8uDz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 093/641] arm64: dts: qcom: sc8280xp-x13s: Use the correct DP PHY compatible
Date: Mon, 22 Jan 2024 15:49:57 -0800
Message-ID: <20240122235820.952172894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0cd080dd6d08817c9980d2069197b066636b0f23 ]

The DP PHY needs different settings when an eDP display is used.
Make sure these apply on the X13s.

FWIW
I could not notice any user-facing change stemming from this commit.

Fixes: f48c70b111b4 ("arm64: dts: qcom: sc8280xp-x13s: enable eDP display")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230929-topic-x13s_edpphy-v1-1-ce59f9eb4226@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 38edaf51aa34..6a4c6cc19c09 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -601,6 +601,7 @@ mdss0_dp3_out: endpoint {
 };
 
 &mdss0_dp3_phy {
+	compatible = "qcom,sc8280xp-edp-phy";
 	vdda-phy-supply = <&vreg_l6b>;
 	vdda-pll-supply = <&vreg_l3b>;
 
-- 
2.43.0



