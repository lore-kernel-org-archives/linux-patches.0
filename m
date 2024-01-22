Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940D956468;
	Tue, 23 Jan 2024 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974018; cv=none; b=fupqqjYcB7SrnaAl4Ap0DXMo6M34E9zpl0yVdgt5gHIoOJg6vyceZQnRNTHzUi54H696vG9HyLTdqGOUd1/OcsjcxYQNtjfUkATMCh5sDl4bWLjaprAWY7Ptt8TMGf/gi0kotDO9WEpR9zHo3Aqb3j2HzEa6a8nkgjrVo+gEVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974018; c=relaxed/simple;
	bh=goDER4i0VgZxh8LJbhLV7LGNXZt3bZronhLQR5qnsGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFFCl9pusNXRRQswLadLzW+JAHD0fKkBETqF0MTCSIpeuBtstXz7okHRm640TL4EoRXQrEGkNhlEbg8eIfrcNdNIhgH+gLiNPJrSCgP+t0GhgyXQwqrOxsiXszjtKfXr5PC6CsdNtoXQU/Wh84E2rwmpV3r/YtIzdNAr7oTXbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqU529bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqU529bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5BEC43399;
	Tue, 23 Jan 2024 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974018;
	bh=goDER4i0VgZxh8LJbhLV7LGNXZt3bZronhLQR5qnsGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqU529btEjbO1jF5P9h2Qvt+elY0JhHxaYbW9gGB/7a/mMsDVy2INQF1Dzw7mhfXn
	 hADvan9zYoSWw1TMMiz/+ktrMwf0WE9NP9piHMaObneDkNe6WX/zedM9YjfuUciy96
	 r8+YU7OhaCg4qyy3bu0T5yZZuPDQ2JkOZMS1fYg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/374] arm64: dts: ti: k3-am65-main: Fix DSS irq trigger type
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235749.056444297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 4f232f575ab2..b729d2dee209 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -855,7 +855,7 @@ dss: dss@4a00000 {
 		assigned-clocks = <&k3_clks 67 2>;
 		assigned-clock-parents = <&k3_clks 67 5>;
 
-		interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
 
 		dma-coherent;
 
-- 
2.43.0



