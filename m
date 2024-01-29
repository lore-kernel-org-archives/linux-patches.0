Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4CE15A497;
	Mon, 29 Jan 2024 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548267; cv=none; b=GLrtHrq53v5a1nbIo2gU2KWsnCphIcZfP1q5a9L17pyYjCTj4e/yBX8QvTJ1l8FTWbvKborDtMTyC5qHFyKmh2z6vOCkpOnfudGKSkjGDvrrQYzzUbYX9a/viZGkvOOghuw6xcg5UJdn2XEnrwNYLydlxcstHc93Vkk+ttWGDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548267; c=relaxed/simple;
	bh=9LKy4wShUo3Qykac4DJxUfuckb7Kdy5g7SFGiACevwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoOwYJUplC/1FLqUSH1X5kuX95ipS+27MruYnZf0b55j8bbJL3kPEnAvGWdZqKi+su1q5qqLVpvJytxAuBWFmLefMyXiRIJbV+iFGOS3BEWz1VftIhXV30pgZR500Gjsm93Fp0eCK/2SEW7zer7T49GqaWIpWO2ZWek8Ch+vyTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuNiExuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuNiExuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCB3C43390;
	Mon, 29 Jan 2024 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548267;
	bh=9LKy4wShUo3Qykac4DJxUfuckb7Kdy5g7SFGiACevwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuNiExuh3ZwL/jg+w+/HiyCDgb77jOVAMN7NLGy66PYjU46ZmoecVnMc3BPj77y2o
	 nehjeBu8clMw/kG3BQCUUkWBfE//Jts8iW+iD51QDnR5AZG1ppnB6gCkTblt0+jnJe
	 TUIx2y5DrBslw5HaRj7aI9Wcw8UHxwyviKUdj+UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 034/185] arm64: dts: qcom: sc7180: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:03:54 -0800
Message-ID: <20240129165959.691872567@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 9b956999bf725fd62613f719c3178fdbee6e5f47 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2769,8 +2769,8 @@
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


