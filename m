Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA8746D55F;
	Tue, 21 Jul 2026 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648752; cv=none; b=oSFE4HClU7/rnCoMDuxbdsfv0d6ZeCQvIcivpBFztUSSR7O1L2YRPy50tht/LqCJj84iUmx0RNOoXFGqJ1E8YQE0nc2a1qy95GM4nQsbfLoDBfYiFDcZ8SIFIXx8iEDg8gvqQ3H0RjmpJW0wGsUhsTFUL48+U/T4VDw2dUfx2ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648752; c=relaxed/simple;
	bh=ZKV92dTg4n3x0+Mx3PP2e/mXxpQJODdjOEzziDFE2lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aivFPzLd8g8KTgKZankUGMfyk0atukc397PDMptIW3+HSCw6aQXj3qczwg81cimLhpNoNgcjimETbznaadjkU/1+2Ehrr+T7G8LeiMTx0SgE2bprBchfquZt9A0ke+lUnOidgsageQoLgbbL6TehbxrCAZRkZf0tcKwoGEFLiCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPQ/xUru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPQ/xUru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3671F000E9;
	Tue, 21 Jul 2026 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648751;
	bh=0oOanTWALWTdzUE/DUwA7mIJKKonYYlsBt1u0586ADc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPQ/xUru5wr27vY4tHKVOi+gRaYelftAdKj/JLGA2QK5b2+7yQjFMbuXAqh/9jE8F
	 Jm5A45lGOgQzcpcpb72/XLNHl6LbTNwv51TCSD8liLOFYheuIOQ7GSfpoEUNNkG9HL
	 62YAkFQT/fj0zcIEhr0Jx+4gqqDNVLItL8ifvDgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0275/2077] arm64: dts: qcom: glymur: Fix wrong interrupt number for i2c19
Date: Tue, 21 Jul 2026 16:59:08 +0200
Message-ID: <20260721152559.166368072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>

[ Upstream commit ecabfe832b817bd1c1fdb8841d7bc706bf621ef1 ]

The i2c19 node at 0x88c000 uses GIC SPI 584, but that interrupt
belongs to the neighboring i2c18/spi18 node at 0x888000. The correct
interrupt for i2c19 is GIC SPI 585, as used by its sibling nodes
spi19 and uart19 which share the same register base and clock.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-glymur-fix-i2c19-irq-v1-1-7d5968bd9b2b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 780708a9d8d45f..63df60b7e010e2 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -968,7 +968,7 @@ &config_noc SLAVE_QUP_2 QCOM_ICC_TAG_ALWAYS>,
 			i2c19: i2c@88c000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x0088c000 0x0 0x4000>;
-				interrupts = <GIC_SPI 584 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 585 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP2_S3_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_2 QCOM_ICC_TAG_ALWAYS
-- 
2.53.0



