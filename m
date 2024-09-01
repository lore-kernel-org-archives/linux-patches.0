Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E3A28387;
	Sun,  1 Sep 2024 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208147; cv=none; b=FysGLelr220yljEBBt/L7sazLeKFltLzrV1NTs3TOeeN5/Y9CGP305vjUt9dUZ3VnTrk2PjPTQQ8mQwnlhI4W8UM5f3mIjAxAIVLCe7+rsTq9JiaKXChOSehWt3FrST9gdbzzzY/eGLv9sQRb/PVaypEYq12Svv8LBnTVxy+46I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208147; c=relaxed/simple;
	bh=/QKd+x68M4jlw4SZ8PVWyyAUffC0wUSn2n+ZhNMmWFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWBtgUgqlmU1Wcmy+VCibsjVOT9TJHo1lyR+WxYtFC7vrONH5dziTOF0quCmS4BogayupMpHYHC4oQmZqGuwJVgZX3IIyTdl0vDraMdxHvQ6BYM8C4r4Docptump/+1BjUZ+Gwxptb4vJbJIzKOgIYe9D1Pg/rDjCTJYHM8PB2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMzx6zWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMzx6zWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2194C4CEC3;
	Sun,  1 Sep 2024 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208147;
	bh=/QKd+x68M4jlw4SZ8PVWyyAUffC0wUSn2n+ZhNMmWFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMzx6zWllRb3/FaSZK+bc3w2E6R87ia7IYXnyKExL4J90vm2eT78oa4Tq1UHn3OyA
	 guKh+/KO9/AnPBdW2pPjL63B4VSO0D7603AupyLtUentCIe1B/Gwfa0CJx7chxrbkB
	 P1ttm9oH+1U4o5huGggq4xPy1CmW+r9S3vy+vpWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 87/93] arm64: dts: imx93: add nvmem property for fec1
Date: Sun,  1 Sep 2024 18:17:14 +0200
Message-ID: <20240901160811.008614154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit b2ab0edaf484d578e8d0c06093af0003586def72 ]

Add nvmem property for fec1 to get mac address.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 109f256285dd ("arm64: dts: imx93: update default value for snps,clk-csr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 943b7e6655634..1b7260d2a0fff 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -786,6 +786,8 @@
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
 				fsl,stop-mode = <&wakeupmix_gpr 0x0c 1>;
+				nvmem-cells = <&eth_mac1>;
+				nvmem-cell-names = "mac-address";
 				status = "disabled";
 			};
 
@@ -888,6 +890,11 @@
 			reg = <0x47510000 0x10000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
+
+			eth_mac1: mac-address@4ec {
+				reg = <0x4ec 0x6>;
+			};
+
 		};
 
 		s4muap: mailbox@47520000 {
-- 
2.43.0



