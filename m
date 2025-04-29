Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C9582C60;
	Tue, 29 Apr 2025 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947531; cv=none; b=Yyqyv01/ebHyGFsChpNRnKm1ieCdp+90+2nLlBdu30oPiD05q5PdMlNmKENpEQ9nis/B0utstejUPyXo50tUyQuvjyl9+Bb/X224tGwH3h4gcqZNXa0pajrnpTnohPdUyQcRsOsCbYjR+c2IJ6Fcct1xumollUq+n1U4nEYjnT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947531; c=relaxed/simple;
	bh=EBSoWfs76lluAOz9nHlzU5f67cZOgm9SEAc3PehoWMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEhhQJEL9UgAN/h454vy4sjR1SRZnsIm/ZsLNVsLOSaYtfH8LIQQz/lvWcLFGnqpl7YTCnrkp/NUK96EyR3VHWv0PNIiMkLIiVBjBNKUSBxR8rqgXBPBsArWp0/TBw8+kHGGwVwSMABxh/8h/64Qe8KaYsTemzUFws/QeY7/bPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxTmMe0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxTmMe0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDCFC4CEE3;
	Tue, 29 Apr 2025 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947530;
	bh=EBSoWfs76lluAOz9nHlzU5f67cZOgm9SEAc3PehoWMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxTmMe0KGk+EyaLTw3RYBL2+k9HRoBmcbuZe2C6AiQqFEycT8OQmyPktdJs5AIOyV
	 +2lsN1JoUhBX1Ejn5Rzzpo7iX+Bebcc/B+KwtjJ//E5MmIrC5HXMDjQHYec6OSQoX7
	 bImvCOM/4VgVlUaNlw/L7by4WCcjRlwKIz5GbE+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/280] arm64: dts: ti: k3-j784s4-j742s2-main-common: Fix serdes_ln_ctrl reg-masks
Date: Tue, 29 Apr 2025 18:39:25 +0200
Message-ID: <20250429161116.092270467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 38e7f9092efbbf2a4a67e4410b55b797f8d1e184 ]

Commit under Fixes added the 'idle-states' property for SERDES4 lane muxes
without defining the corresponding register offsets and masks for it in the
'mux-reg-masks' property within the 'serdes_ln_ctrl' node.

Fix this.

Fixes: 7287d423f138 ("arm64: dts: ti: k3-j784s4-main: Add system controller and SERDES lane mux")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20250228053850.506028-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
index 7721852c1f68a..2475130ecad11 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -84,7 +84,9 @@ serdes_ln_ctrl: mux-controller@4080 {
 					<0x10 0x3>, <0x14 0x3>, /* SERDES1 lane0/1 select */
 					<0x18 0x3>, <0x1c 0x3>, /* SERDES1 lane2/3 select */
 					<0x20 0x3>, <0x24 0x3>, /* SERDES2 lane0/1 select */
-					<0x28 0x3>, <0x2c 0x3>; /* SERDES2 lane2/3 select */
+					<0x28 0x3>, <0x2c 0x3>, /* SERDES2 lane2/3 select */
+					<0x40 0x3>, <0x44 0x3>, /* SERDES4 lane0/1 select */
+					<0x48 0x3>, <0x4c 0x3>; /* SERDES4 lane2/3 select */
 			idle-states = <J784S4_SERDES0_LANE0_PCIE1_LANE0>,
 				      <J784S4_SERDES0_LANE1_PCIE1_LANE1>,
 				      <J784S4_SERDES0_LANE2_IP3_UNUSED>,
-- 
2.39.5



