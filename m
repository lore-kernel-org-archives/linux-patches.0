Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB315EFA1;
	Wed,  5 Feb 2025 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767198; cv=none; b=ZuYUITPXzitRLAFc4713f5NFA++w3U5IB4lYmXeG7rhyxWwEJx4yK8UCIqDeU2KgfoTk1ojdzkiDXsqeE1zXNTX00jkrpP5ZO2h8ugtcJQv+4UpjDApK/Sbhd3f/6scd6KaUFPHZF7OjIafeZkGpOa9hU4UtbfBqtObQtRHJblc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767198; c=relaxed/simple;
	bh=L9vCNrmBdZrcig/tqXcoXIteWUSlIifWj3Mt613yuMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOb+mwNqAIqMJ1aARRBPyS0MbxwcnCNh/X+y6EbwF4pitoopYGOzvlN3t3WWYceLLobNxY7aE5QB5ZEWotgkGpXp30YsQv5fJGl9gJ8id6mNi0bVlz19ghMCghUq0Nldm9P8uTNYiYnNMOcFUGYL8bSZObZGjDlphxQuidgKdyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoUUPf0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoUUPf0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC01C4CED1;
	Wed,  5 Feb 2025 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767198;
	bh=L9vCNrmBdZrcig/tqXcoXIteWUSlIifWj3Mt613yuMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoUUPf0vWeUH8T7vcM1HpPbZZAZFfvLKalc2EUP+Pri5wTsLIu2Xkacy/T+jGNUvs
	 UAjWeaXMSVxk2EaAN8wW5sNoCNAMsUXdGekd4rMulIbIRrTrW4Ca3PuN25ED2pqRej
	 5cs6iXrf61cMDyHffSFqRSXaMCHpHNR0VFHg+O6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 341/623] ARM: dts: stm32: Fix IPCC EXTI declaration on stm32mp151
Date: Wed,  5 Feb 2025 14:41:23 +0100
Message-ID: <20250205134509.273397276@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index b28dc90926bda..e7e3ce8066ece 100644
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



