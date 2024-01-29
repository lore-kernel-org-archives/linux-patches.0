Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D726F075;
	Mon, 29 Jan 2024 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548461; cv=none; b=GKfdgXJFUiA9ODkEsLOVRh/uz9satAVnU6IFtL8QtsMMMGfkrafOvBhiJ35qxpLr6jxRcdyU58bMwu8QjrU10ouzE7HCWHKJJCi4jl8Zxad8HmZRLukLsHU6jj4GEDcI9Q4ucF4h3eLeie0h9caa0aszmn5I0IfzqSz878EoZWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548461; c=relaxed/simple;
	bh=qqy2mDaM1hTEl6wxKH3TFRQqW/8Pnepj5A+5du81PoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZsON8l/5EzTTzBe8Jt4IPLX22AkX3scRRT7G9xiK2woS5zo3zPpi6N2+IveOli/VMLCsAV2MlPkI54CLTofLIEQxKTATrDrkUgxzBYlYGzY8j7IHn90ChQUKPBbuvID4LWKnocHYiIxgcnrDYY2TfVoDtkDG+vIUjkXCM7bvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP85vYHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP85vYHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F312C433F1;
	Mon, 29 Jan 2024 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548461;
	bh=qqy2mDaM1hTEl6wxKH3TFRQqW/8Pnepj5A+5du81PoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP85vYHc+DR7OJq4wddL3rv1ZxBJ4+XJWpt8t1u1wRsG/apD4mBqOrHxFojY6tUOn
	 R/FgKTKNE+tvmeu50TqOtMP2M1vongIpWnczRFAyqWtb2RivbsfOXnKZnOqvsb5mX2
	 FlPiGM75nTh/HQcHtHLF8U8qWhnL5aiIveuYQPrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 074/331] ARM: dts: qcom: sdx55: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:02:18 -0800
Message-ID: <20240129170017.089229587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit d0ec3c4c11c3b30e1f2d344973b2a7bf0f986734 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: fea4b41022f3 ("ARM: dts: qcom: sdx55: Add USB3 and PHY support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -594,8 +594,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 158 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 157 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


