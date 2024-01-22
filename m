Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59914C5AF;
	Tue, 23 Jan 2024 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969271; cv=none; b=tm3dlcVJJ889/BGYgBOvsAQrnkUQW4Z6dy1ZaJ4zHb8LDrP6xZ4ZIDPZwe4E2MNLdbUgIohQAlV7Zc7ZIi28CNJnFr5+zOLLCpzeYacawb7yNX3H1IHHj268ev7Zokjhcb68UR5ZdSSGZMMCPuNWxybuF1kv8PXcqTBpzrWYFTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969271; c=relaxed/simple;
	bh=npdB1Cy0aOPAAVAZQaCQNwHLKAgeti5W7g51pZKyLZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4DFHM9Ie9XyA57vkcquEbvNWGhwWHdavzLTi2honpWZ+PS9A2GkFvkGGmz4E1g4Q9RuTUPWcY3+Geoggv8kfetEaV4vlZduBBzCP+IQtCaLu6k8FmMwIq1XdlSbRBvYZuuFglXSf/l2SVcV3Iq1nCa/IuMLgjTfkPoyWk5R28w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xATuXyp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xATuXyp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78FCC433F1;
	Tue, 23 Jan 2024 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969271;
	bh=npdB1Cy0aOPAAVAZQaCQNwHLKAgeti5W7g51pZKyLZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xATuXyp1qEZpzxMS+3g7aPzwmP49JJPFhlD1aHmJ1kCq/IV+4FcAur9Y5YfSvM3CE
	 3cM9SQe+JMaAK3AQ8IDMBqNUNqpZi2dVnEkuCp/AzuU3ikyQ9ZgriMaSsIfE0gbcMV
	 ncI9xYvzNaiGWVrB4syiGbInudZAj/jRZUqo1eDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 111/641] arm64: dts: ti: k3-am65-main: Fix DSS irq trigger type
Date: Mon, 22 Jan 2024 15:50:15 -0800
Message-ID: <20240122235821.513133549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5ebb87f467de..29048d6577cf 100644
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



