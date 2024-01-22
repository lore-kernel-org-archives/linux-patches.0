Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4262E5732A;
	Tue, 23 Jan 2024 00:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970657; cv=none; b=mzwgdiPbz5ifAevcsXa+sUWxjz9DqmqTNnt2EfOnATQPXCwtk+kVcGBwYo8ReGDpP8qFN/n4W3/Qz8K27fF1RoNbnTUl8MDt/TTUssVraKuBZLO3eo3skZ/YUp5BBKEo5tmWUtIt0vBXxoq4WmkW4OwDFZjNH8PYhZrp00YOI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970657; c=relaxed/simple;
	bh=H5Yoo/biCrU9wwz9S34QyL+C/daR/eTTgB4HUQzI8D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcTfJTyU5e17RJQ6Z4XjvS16XKY4dFhYGo0zQ8188fMn3VhIDhFDreLOoMrwj7r0UglEqXz+AiIIFNzI2uc/ugBWtWKvH15hVCGodCkeFxL4Pap/IuHfthLphDhlCjZDFObOBLJg/v3N63abcdWKkAyDxVucpZtIeiQFKaPLLsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlMH5hHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlMH5hHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A352C433C7;
	Tue, 23 Jan 2024 00:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970656;
	bh=H5Yoo/biCrU9wwz9S34QyL+C/daR/eTTgB4HUQzI8D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlMH5hHDGyPPlcgsc0V/LFwvUNl32DhJXyMts2XamNcskP7Ql7ErFI5t/A9RutrE+
	 L236YVxPYlPXqmkjp7ltZ/4pGex4wYSJ3EFssEyF3rBxZA/dCmh0Hmdz2xSEZ26gN5
	 90GeGhedrmUYNRDVStWr4EC9rrnyonWkTUVNB1LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/417] arm64: dts: ti: k3-am65-main: Fix DSS irq trigger type
Date: Mon, 22 Jan 2024 15:54:08 -0800
Message-ID: <20240122235754.481505050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit b57160859263c083c49482b0d083a586b1517f78 ]

DSS irq trigger type is set to IRQ_TYPE_EDGE_RISING in the DT file, but
the TRM says it is level triggered.

For some reason triggering on rising edge results in double the amount
of expected interrupts, e.g. for normal page flipping test the number of
interrupts per second is 2 * fps. It is as if the IRQ triggers on both
edges. There are no other side effects to this issue than slightly
increased CPU & power consumption due to the extra interrupt.

Switching to IRQ_TYPE_LEVEL_HIGH is correct and fixes the issue, so
let's do that.

Fixes: fc539b90eda2 ("arm64: dts: ti: am654: Add DSS node")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231106-am65-dss-clk-edge-v1-1-4a959fec0e1e@ideasonboard.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index ebb1c5ce7aec..83dd8993027a 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -856,7 +856,7 @@ dss: dss@4a00000 {
 		assigned-clocks = <&k3_clks 67 2>;
 		assigned-clock-parents = <&k3_clks 67 5>;
 
-		interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
 
 		dma-coherent;
 
-- 
2.43.0



