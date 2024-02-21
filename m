Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F497BAFE;
	Wed, 21 Feb 2024 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522195; cv=none; b=fMZLfXzOnCgHQBB3Hl6oIoX/5J1E6pt0t2RqpBSkNm8oOZtUwifos/Fb1jQWtJV4IlPeDfCO+iA5zqDJapNI3JTkNEVpBXwtN87GJ14uvzj5Ns/c07DXZcLiMxpd0iBqEuCVD9QOwkDO8z4T5AKrsJv0Kn5xVFPCUv/Xd+PYvnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522195; c=relaxed/simple;
	bh=vPIt2Pmr2hZKkWcBbHyOtCCptzWynkCZClKdrGT/7zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga9doO3BgcVEUwoJICrsWxMF8gYCQDcWPLQVPkrvVGYe4fC3QlQWYf3HhRnDjfk0NMqxj4CpDQyIA0GHTEFiVdyf0dtqhAZJ89Fk3c5339eNJBasCsS6WmqXmNjj9J8qxgRiGK8BWj5h9NnAgRGn+I9jlNbksNTUJg88kfzl8vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+YTAacL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+YTAacL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0BEC433F1;
	Wed, 21 Feb 2024 13:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522194;
	bh=vPIt2Pmr2hZKkWcBbHyOtCCptzWynkCZClKdrGT/7zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+YTAacLrFDU5Xa83gtlwyNP/rqsLAlvXAUzMBABRJQlPgbgs3vfd9/7TPIQrGgYF
	 CRriQXhtG38umN75emY+RUZ79dadA631TftqSuzhErmbafFFvvJtkhV0xRhgtz7akM
	 mzET5Sv3DI5adhobSxxyZR+WF2s4f2AR0ORK9Zuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/476] ARM: dts: qcom: sdx55: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:02:32 +0100
Message-ID: <20240221130011.709339520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit d0ec3c4c11c3b30e1f2d344973b2a7bf0f986734 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: fea4b41022f3 ("ARM: dts: qcom: sdx55: Add USB3 and PHY support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 73fa0ef6b69e..4e7381d0e205 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -422,8 +422,8 @@ usb: usb@a6f8800 {
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 158 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 157 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
-- 
2.43.0



