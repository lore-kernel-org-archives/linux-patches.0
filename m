Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889E43FF4;
	Tue, 23 Jan 2024 01:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974634; cv=none; b=rWs9J97kl3iQDazDsoHrEHGLa2ftvgtDNh6SGW6toxc8yBkpKxVymrzIQawffZi9aYrD+XT8IBPm53wyKLaobtrvKzoBANSnErdbAF9MskRDcW4Ca7xakeYd3EcCH7oqhG0c9GKLt8ja8yJ55fgBlzZQFxg4oz7CjTSqN/zCG0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974634; c=relaxed/simple;
	bh=xps5E6KKwQSWjv2Xk8Qmpdkt/iy9wJpIUcTbZjUXuo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djXJaeUD1SFCtyuoJKjrxewoYiQTCp2yNw3vqXb1lanudKIKvO87Kl3wZCoXQXr85HAQInzU5us/JIDmlltZ5h5+/jKAKfYZtxAYSI7LIGIBW4pjhDxh51ZHYPGLusrYiwPMwF/HfCg932WfKL/Ae5r/+/6V0UJ1nykcs37xjW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsYETXGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsYETXGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4150DC433C7;
	Tue, 23 Jan 2024 01:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974634;
	bh=xps5E6KKwQSWjv2Xk8Qmpdkt/iy9wJpIUcTbZjUXuo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsYETXGwu+GIpy+CD9y7CnFXhKvDOvUt5aM3kufn+SS9qAdwjGiIk6PUJ2laMwSBP
	 kl5UWThudlcVRrdoiVITXR33VVsvItUXuUBXgndAUa6dQpNEJScFW9f3ls/Zp/Yxr7
	 HY/Vu2o3QZeNmHS0yT20iI0NVCzsqIo1jH+Q1Uek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/583] arm64: dts: ti: k3-am65-main: Fix DSS irq trigger type
Date: Mon, 22 Jan 2024 15:52:29 -0800
Message-ID: <20240122235815.183620897@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index bc460033a37a..c98068b6c122 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -1034,7 +1034,7 @@ dss: dss@4a00000 {
 		assigned-clocks = <&k3_clks 67 2>;
 		assigned-clock-parents = <&k3_clks 67 5>;
 
-		interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
 
 		dma-coherent;
 
-- 
2.43.0



