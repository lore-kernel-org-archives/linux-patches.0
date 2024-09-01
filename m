Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106EA1C68C;
	Sun,  1 Sep 2024 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208624; cv=none; b=TF9ObyOVakQux8hwI5BWvZUGP8gR7nrmaa3pbAdY9K+NqThpf/x6kK/K1KA4Hjt0dW9gnmw7nsEiNkLLkZhLLK7J7KWmr7pV8EqM0S+l8nGst1KmhUIvs1gpo9DGQjIrRA831wkW9TvNzvx9H6Hl56RxV+e/JaNQ3e2JIBi7pFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208624; c=relaxed/simple;
	bh=i1EgrYOHDHeB5aomN/mKuRJI+g+nu+MtBYY+Ufnp79g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbZ43OHjGud4ZWdGabLJg+OjETDA/e42wId7TYnf2gup9u6TfEY100D2m04pMOheSVOyYa445HW4C4kWSsQ40l4aNT5Mb0O5xKKeomd85uGwD1KEAQaq494OLu4Q3GzV1jTevmkhyn5x6ygdEAT7CIgUkF5tIMUAtvPDzfbpMsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqOw/H7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqOw/H7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F0C4CEC3;
	Sun,  1 Sep 2024 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208623;
	bh=i1EgrYOHDHeB5aomN/mKuRJI+g+nu+MtBYY+Ufnp79g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqOw/H7v0Ec8dJq00xZo9+ZTyQal4LumuEMZyUtITsyg9kQmNOaM53UlxxSq3aqHg
	 rvREb76z9h8RyMAfNS5IJO7nCnY0FTCciA5twIqqfpor54nfwNWw5yg8lhwSW8IQcM
	 NIOtwIDJNhIaK3HfEkoYDHhbSDHnrUPfcdD3DqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/149] arm64: dts: qcom: ipq5332: Fix interrupt trigger type for usb
Date: Sun,  1 Sep 2024 18:17:31 +0200
Message-ID: <20240901160822.712276182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit 60a76f7826b88ebf7697a56fdcd9596b23c2b616 ]

Trigger type is incorrectly specified as IRQ_TYPE_EDGE_BOTH
instead of IRQ_TYPE_LEVEL_HIGH. This trigger type is not
supported for SPIs and results in probe failure with -EINVAL.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Fixes: 927173bf8a0e ("arm64: dts: qcom: Add missing interrupts for qcs404/ipq5332")
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/20240723100151.402300-3-quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5332.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5332.dtsi b/arch/arm64/boot/dts/qcom/ipq5332.dtsi
index 770d9c2fb4562..e3064568f0221 100644
--- a/arch/arm64/boot/dts/qcom/ipq5332.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5332.dtsi
@@ -321,8 +321,8 @@
 			reg = <0x08af8800 0x400>;
 
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 53 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 52 IRQ_TYPE_EDGE_BOTH>;
+				     <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pwr_event",
 					  "dp_hs_phy_irq",
 					  "dm_hs_phy_irq";
-- 
2.43.0



