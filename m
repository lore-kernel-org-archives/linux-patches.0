Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673915198D;
	Wed,  5 Feb 2025 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764762; cv=none; b=BhugXu22UcI/ROOTL1tpG0De7yMxnPYEFk2N5IswI0QZd6t+tPE4r/3NceZCwCZwZYKppdby61efcuTnA7ZaFwBZBbW4ohk7/N2R/z0M8419mqFHmMCi+DxfgHO9KVFTIh9dtaimZDUw/2j1S2qaBhjySFg1FEePCck1WTfG8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764762; c=relaxed/simple;
	bh=sF7KHbFAy0m7VKTqNxShnx5fHgQP5KwEMSFiSKje7+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iruqhSkuBM0lxg1GVG8lqVbJxSIUvvLvpQvhuFAmUZiGbnyFmUCjxhAvDfqi7RV/m+ODXaqirlN99n2Dms7vd6fObrhJD2uZ3ptm6HNaYr+GMJrxX7/z1+FMUe4gW/fmHThirsh2mrv5cSJ4S5TyHkuWz6cOBW+nIBUf0GX2xFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixKU65d6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixKU65d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15998C4CED1;
	Wed,  5 Feb 2025 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764762;
	bh=sF7KHbFAy0m7VKTqNxShnx5fHgQP5KwEMSFiSKje7+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixKU65d69irCRRgN6cJQ5EDJUhAfdY+XnwjlDjJ4CdYAuyexlMEYqgEAKBlmZ9AOu
	 K4jdWdPstZ8IGrP/m3bfPtEk6WqTbkr/rGWn8yteGlBmxdWrVqnFW0jB9eVN3zoN5j
	 5sG2SD53MrUyHENfeM8ZNF6YSHZV9ATkk/uwwHRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/393] ARM: dts: stm32: Fix IPCC EXTI declaration on stm32mp151
Date: Wed,  5 Feb 2025 14:42:01 +0100
Message-ID: <20250205134428.030540235@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aec7fa5ab5d8c..fe79d5d40c116 100644
--- a/arch/arm/boot/dts/st/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp151.dtsi
@@ -1165,7 +1165,7 @@
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



