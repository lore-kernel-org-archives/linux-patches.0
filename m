Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76F7E792;
	Wed,  5 Feb 2025 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766330; cv=none; b=RXnncmI/wVcdupYhSXFjK3Vll9t1ZG8b5Ll9NF3I4xHleIC+60HbvqXTI59w6CDKDAUuroz/Us9tVQC6RDLm6i4375AwDRcx3BC4wd3hngrWyzflfZQzBZzhik0RGdfv2kyn58UrgKv2BKbyCYPkwtiGT6Xbvi2QkyoZ0MioSeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766330; c=relaxed/simple;
	bh=r+m7l9/rJK5uoitkwhR4LeqB2OjcEBMZgxUdKT+A+yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzkvHEbz1wVOci7RpPs/qCESCza1NZUALWat6pVvjeoWBm7jUQOaX+i7uQIg8k4drpW6Mb0lx57HX3ZNDf+awQ0R5PcJONuLSz8Z0MdA/TEIBZ8iSwxD4Olh1wmJsOq/SCpETg3ua7VW4szQX/pF47GjFZbn6ZEQ9Cn3QQl3XvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubD3SO+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubD3SO+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE43BC4CED1;
	Wed,  5 Feb 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766330;
	bh=r+m7l9/rJK5uoitkwhR4LeqB2OjcEBMZgxUdKT+A+yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubD3SO+qUiOvPKnNvnegDAHOWFqYH92VyNl3VT7yMAfqI+g0wJnLyD2bVXk3F+KoC
	 l9pv3axWzcD2YEt/GlKpoPiQCSNsvbyTpSIilKnPXbgOd0aCmzBHs0+6yG/sir5Hla
	 WV9RMuYNkcBOWFK7dWt/Lq5GB5z2Acz5gZUiHrAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/590] ARM: dts: stm32: Fix IPCC EXTI declaration on stm32mp151
Date: Wed,  5 Feb 2025 14:41:06 +0100
Message-ID: <20250205134507.173066583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

[ Upstream commit 4ea654242e0c75bdf6b45d3c619c5fdcb2e9312a ]

The GIC IRQ type used for IPCC RX should be IRQ_TYPE_LEVEL_HIGH.
Replacing the interrupt with the EXTI event changes the type to
the numeric value 1, meaning IRQ_TYPE_EDGE_RISING.

The issue is that EXTI event 61 is a direct event.The IRQ type of
direct events is not used by EXTI and is propagated to the parent
IRQ controller of EXTI, the GIC.

Align the IRQ type to the value expected by the GIC by replacing
the second parameter "1" with IRQ_TYPE_LEVEL_HIGH.

Fixes: 7d9802bb0e34 ("ARM: dts: stm32: remove the IPCC "wakeup" IRQ on stm32mp151")
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp151.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp151.dtsi b/arch/arm/boot/dts/st/stm32mp151.dtsi
index 4f878ec102c1f..fdc42a89bd37d 100644
--- a/arch/arm/boot/dts/st/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp151.dtsi
@@ -129,7 +129,7 @@
 			reg = <0x4c001000 0x400>;
 			st,proc-id = <0>;
 			interrupts-extended =
-				<&exti 61 1>,
+				<&exti 61 IRQ_TYPE_LEVEL_HIGH>,
 				<&intc GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "rx", "tx";
 			clocks = <&rcc IPCC>;
-- 
2.39.5



