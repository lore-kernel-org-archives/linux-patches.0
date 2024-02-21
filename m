Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94D69942;
	Wed, 21 Feb 2024 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523685; cv=none; b=ltZQKepvPVrGORz7OAX4y9hsNZzKJqHXdUPyHI4ryK6UHsQ3c5YpW5yfgIH60Qc7qgQ9/1M57CvQB7HotsZwhGJMz+o8eP9jKWR2HLqDRcMfYt0OMCH2tJlziqu/qpoMq4XPNvVjgnFMOLGOUxxMWMq+36gmTiez8D2ilRRgtrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523685; c=relaxed/simple;
	bh=zN4NfyxNHF4UZnBFFdNnpuqyo43oBiZuz6wOCQl4Zr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmZ6N0GsxDxNj3FYRZQfn/nmgqfkjcb0xMFTBUYprL6LrTograbmOuvoBZn8pqUJPqkti4cj6oNhYCpUJ5/NoQOse4N5YQbh7b8yJBLOWG88dOVNv+P8vLNna6FvY6p8Q8hg9W7QYQJJYMxj6uKzQWHstJEthHJPXETpR6tmtl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEupoLK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEupoLK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0CDC433C7;
	Wed, 21 Feb 2024 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523685;
	bh=zN4NfyxNHF4UZnBFFdNnpuqyo43oBiZuz6wOCQl4Zr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEupoLK/jKJlXSJkOawFznDxSQCF88pJm51X2WnMIVHyApjLYKsgL4Aiy5z7AXuTZ
	 pYxe9nQ/zOKf1x9/X28MOImeHbT/obdamBoqPkAUC88Z4uU0d2lzN2n7dyGOLdG/yG
	 TYhGE2Hp2nDg6S5w5iO405aOHpNZZ7cseAAGui20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 027/379] arm64: dts: qcom: sdm845: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:03:26 +0100
Message-ID: <20240221125955.721060236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 84ad9ac8d9ca29033d589e79a991866b38e23b85 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Cc: stable@vger.kernel.org      # 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-9-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -3567,8 +3567,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -3615,8 +3615,8 @@
 
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


