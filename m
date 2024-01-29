Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EFE162778;
	Mon, 29 Jan 2024 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548382; cv=none; b=kVghDmPVdDcJq0FmzZJFBMkWHgGyWuUNgONzAzGxSiq/Sylk4OxtJ+veZyZZlDX2kNiKVBL9CPkaMpWlaOhrcarkATowy0CRyHnFfFUnU4oxY949RAHAxmRHAsK+tVsZbVKExIbCAH05AjFp+eIJt/OY2unUhRao3x9UfxPau2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548382; c=relaxed/simple;
	bh=WPXaq9WED8MZzGPTYp/TNhYzXDRXj6eAF+FqqDgeOjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNiZ0uXj6mQLRFWqVFzYDDVhal6KXTGeBFQ5Haeb6BJlMrEU70wkmZLL7LY5cB6W5c26EPXnhaxzpwKsmxBUEnGP5oviT0y4oCwzppcEwfCVD0hLT6Bdf9wcB26F218I+UiGw0wjtT6x7E0V5DZuSAx04Y4qhfQaW3pbchVA9uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClsDuvr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClsDuvr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2D3C433F1;
	Mon, 29 Jan 2024 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548381;
	bh=WPXaq9WED8MZzGPTYp/TNhYzXDRXj6eAF+FqqDgeOjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClsDuvr9p7Hj7EYLyM/nV6cFf/AN9P9y8kmq4utXyfFfJK/suNRJfwoSN4aR3DELa
	 Kv3nWSP++MHPDKXsQWnM5F16RTjhSj1yda8YM2gNtzImQaK4kVGEoZB4L40i16GY6C
	 lQKIN3HeQoeLgKQsMnZ4XMSpxQ1ww7Ynz5O/8zZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/185] ARM: dts: qcom: sdx55: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:05:53 -0800
Message-ID: <20240129170003.512072856@linuxfoundation.org>
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
index a4bf1d5ee206..eb1db01031b2 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -497,8 +497,8 @@ usb: usb@a6f8800 {
 
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



