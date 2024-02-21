Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3B78B53;
	Wed, 21 Feb 2024 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522026; cv=none; b=tjeV0lax7tCHkciWirm1UFjcm2zeNDYowczyBoSeJBS+Tk6y1Kplrt/P2kzZSm+xwGMQeJ/UiGTRd5Lv1o3NpPqnynJOCwi91NEAeIi3Mu5sqoDv151ni/Sk6RZBgGVkWCTHL0Svig6gYawiV3jtqYsyQNSG2kV85SRZ35gzJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522026; c=relaxed/simple;
	bh=r1txinHbUXx2viOMxhfmx4o70izM49A2BPWIFXXERuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utkEY4EEgskdtBeeFDplvXmoRt52uGC+YV0McPZ2Ozsu233gyx4G+sUqBONtOdcOQu+TD3L7L1T75QQzc/BQv2EqjY6g8cerrMZYpTWEnA2ydX6doo8GUocDU1Xy0hyLX783Ryoxw9jZkUUIctDgAX6RiVBiXm4arYKRQqArh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Whj+kWgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Whj+kWgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D140C433C7;
	Wed, 21 Feb 2024 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522025;
	bh=r1txinHbUXx2viOMxhfmx4o70izM49A2BPWIFXXERuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Whj+kWgFMhTfgVhPRX79T7fhw9IEYPSXeuvrBZZkV4+j3oBFEzjrKRkFPl4dkUpV0
	 cFf8Vr430H1AIqFa2Vk92OnkHPUXL9ZmpgB0ACwKM2SVWUVDcl4UboYHPTS8uFsQea
	 XnFINchEyPbIPR0dTtranIcXpisQD44JtcWK7erI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Jack Pham <quic_jackp@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 030/476] arm64: dts: qcom: sm8150: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:01:21 +0100
Message-ID: <20240221130009.042137346@linuxfoundation.org>
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

commit 54524b6987d1fffe64cbf3dded1b2fa6b903edf9 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0c9dde0d2015 ("arm64: dts: qcom: sm8150: Add secondary USB and PHY nodes")
Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Cc: stable@vger.kernel.org      # 5.10
Cc: Jonathan Marek <jonathan@marek.ca>
Cc: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Link: https://lore.kernel.org/r/20231120164331.8116-11-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3094,8 +3094,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -3139,8 +3139,8 @@
 
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


