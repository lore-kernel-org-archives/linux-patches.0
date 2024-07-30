Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD1183CDB;
	Tue, 30 Jul 2024 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355660; cv=none; b=Kow0dJibnqpYtY3T2IAB4Cnipn7S4+vA2RWWbTo520xhacQGVqELCzUQ2NejNhSb4hYQ37yeH8iDQZu41qmFdm2A5YWKFtLA3SXScbAk84hd1A2U5yPoY8cYGdqbQbswZ/XvTruLZX5JaQqy7IldjouRxP5s1rV1qhBYS4LRpik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355660; c=relaxed/simple;
	bh=lcn9rCqHhypVgfwgA4HnUnDrJcYZrdhAD1lsZ8TeZJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1ffZ3FuPL9GHS1H/dAFtaCWU5OspjFngbKhcL6KndQQsHOhuY1aQwfWi8zLpEvv/hJnDXBToCXxoudNmfJ/epYquoLbpVjYYZkC8iGN5qDwsv2gz7Uy1JEOhv0yLcJAJvi/O3Jx5Vbdmrwj4vXhUCPJUCoTk9z6WZW6nl5j6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9d43bnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9d43bnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF6EC32782;
	Tue, 30 Jul 2024 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355659;
	bh=lcn9rCqHhypVgfwgA4HnUnDrJcYZrdhAD1lsZ8TeZJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9d43bnIHBfJ/ls6G6n4DPToBV98sz+yP4k6/AjREf6TX0d3OKNqdXNHpE/vpH/tc
	 FiHAZ0Q3RknHfuYnSWNEu5sbzcCh5jPOb0T3UYPtkyiV73Yk/5lszaCCwrWd/Vq+nK
	 DKaSrxigDKd40GMa0S0mxu+i0UaFXwlQ4RHRwPsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 077/809] arm64: dts: ti: k3-am62p-main: Fix the reg-range for main_pktdma
Date: Tue, 30 Jul 2024 17:39:13 +0200
Message-ID: <20240730151727.682601219@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit a6e6604c600aeedf9700de4a55255850391bc3fc ]

For main_pktdma node, the TX Channel Realtime Register region 'tchanrt'
is 128KB and Ring Realtime Register region 'ringrt' is 2MB as shown in
memory map in the TRM[0] (Table 2-1).
So fix ranges for those register regions.

[0]: <https://www.ti.com/lit/pdf/spruj83>

Fixes: b5080c7c1f7e ("arm64: dts: ti: k3-am62p: Add nodes for more IPs")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20240430105253.203750-4-j-choudhary@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
index 900d1f9530a2a..2b9bc77a05404 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
@@ -123,8 +123,8 @@ main_pktdma: dma-controller@485c0000 {
 			compatible = "ti,am64-dmss-pktdma";
 			reg = <0x00 0x485c0000 0x00 0x100>,
 			      <0x00 0x4a800000 0x00 0x20000>,
-			      <0x00 0x4aa00000 0x00 0x40000>,
-			      <0x00 0x4b800000 0x00 0x400000>,
+			      <0x00 0x4aa00000 0x00 0x20000>,
+			      <0x00 0x4b800000 0x00 0x200000>,
 			      <0x00 0x485e0000 0x00 0x10000>,
 			      <0x00 0x484a0000 0x00 0x2000>,
 			      <0x00 0x484c0000 0x00 0x2000>,
-- 
2.43.0



