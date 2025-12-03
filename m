Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E6334C36;
	Wed,  3 Dec 2025 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777194; cv=none; b=hm7LaCq2+C9Yz/q9jITDSTqStoGQVU6fajVRSL1w32TORG+Tl5lL//eDkfIfKQvfWzfDE/GEPv7RRnsDQDIpdeeD8/fJ6KpNWDyz6GjpgNHjEJJ5+yerLJJyDpcORbau1XaA7YdamcN7R4WINeC0msD429CHIaQv95RFchIONv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777194; c=relaxed/simple;
	bh=IaCOAt3isRXwvGDlscJFu1osfagcG2hnXzdwTdBehwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpYwvOGPXah7OXRWM3Kjc7z3m3mt/IVDq27+11MPegCRv3ebrY3kkaon37CGP3vW2AGorL3pxj4o7g3BhFjnkAsGC80r/vYbvvgiRXwImFkZhsBwXH7t1VR0svQGLVzdPNYYsbzOFk9PGmkVDEnRRB8QToWIcpqxTonjQk9JWnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dd9N9RSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dd9N9RSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21401C4CEF5;
	Wed,  3 Dec 2025 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777194;
	bh=IaCOAt3isRXwvGDlscJFu1osfagcG2hnXzdwTdBehwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd9N9RSCDBvCnkAHL+mGxRGj6+PGgkLYhQEvFjBgj6P9Yicc/YSwFILtryJ69u1Oz
	 de86rfiaLQaPCvMgsWyZ73lEXRHbfX5z2k3JcsecOKa6OnHaZStV9o9JmlNEGFMZc7
	 7yauKDN2TK0nqY5qFN5j2Az+BeS3Gjz7tI3AF0yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.17 078/146] arm64: dts: imx8dxl: Correct pcie-ep interrupt number
Date: Wed,  3 Dec 2025 16:27:36 +0100
Message-ID: <20251203152349.318699823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit f10a788e4b6a0ebe8629177894ca779b2dc6203d upstream.

Correct i.MX8DXL's pcie-ep interrupt number.

Fixes: d03743c5659a9 ("arm64: dts: imx8q: add PCIe EP for i.MX8QM and i.MX8QXP")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi
index ec466e4d7df5..5c0d09c5c086 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi
@@ -54,3 +54,8 @@ pcie0_ep: pcie-ep@5f010000 {
 		interrupt-names = "dma";
 	};
 };
+
+&pcieb_ep {
+	interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "dma";
+};
-- 
2.52.0



