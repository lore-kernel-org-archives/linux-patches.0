Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935AB627F3;
	Tue, 23 Jan 2024 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971257; cv=none; b=kzXlM+73Rzo4ukLS/HfuK4pQA7DozvKw4xH+KK9Gr34YWF9Z8Fc/x5htde2uweGgEEYGGKhdzbUyr8YTrs+qEa4k+HqeEBC6YRpIs5NqDDrJvCM325k8YFlcbv+0pOR/BLiQ4R5uIGepIbtgbuZ0vcFEVmJTXb72XUW4WCdLVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971257; c=relaxed/simple;
	bh=PJ7LU4glwfvABsssfXQ5o/W29CMn+ByjfpR4hfcyoS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5MtmKz71b5geG8byIm8mwO6M+GZgWafTDPNxbTIcN2iWx8iGPi6dBtgbz5Yqr/Nh0vZ6OlpbsnLW8xLB1jG8EI8T4gzYL8p8BWZG/E+CvXTGjpJi4q5oXu3UuqpBDj6NcW+EP6E0B6tmKtnoTiHGskew2l1obpANpf9JPyaOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQzbiGro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQzbiGro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49201C433F1;
	Tue, 23 Jan 2024 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971257;
	bh=PJ7LU4glwfvABsssfXQ5o/W29CMn+ByjfpR4hfcyoS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQzbiGroEqHe5Fb3caifsfVzAGe4Y5/3T0dTrgdyrXYlJhjfNLwE521eRgP10g4M3
	 CnBKd4HCwTECmIJYAUQdHqio5QYUG7fmFeQwN5JRHwJo2/SF3Ak9pav0mB+p2HcFcO
	 /wbxRGWyTSkX58DDt+DOq5bfO0P9fU2FpDisGmCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/286] arm64: dts: ti: k3-am65-main: Fix DSS irq trigger type
Date: Mon, 22 Jan 2024 15:57:05 -0800
Message-ID: <20240122235736.710365180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 4265f627ca16..a3538279d710 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -865,7 +865,7 @@ dss: dss@4a00000 {
 		assigned-clocks = <&k3_clks 67 2>;
 		assigned-clock-parents = <&k3_clks 67 5>;
 
-		interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
 
 		status = "disabled";
 
-- 
2.43.0



