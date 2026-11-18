Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017777;
	b=wZMrBr5xvVSgcyCu/rE1c7QCNKIR4Gdo7HWS6B/Ut8XWBhFXy6rSsCV1PQfVm6iKdTW4
	 C5bfCM0p6wm+zJK3nuAX4qYQGiyiTMuteuCJgKSnVkGppQWGv5YLlGUW6udLGTPc9v+gG
	 ++++prJ6N4sBSpH4TxDQy30Dd7+S7Y04jYCLxpkN0PbImAUvzG6SAj0ibNg7GYKeyZ28u
	 5HvdUqk3ylRgkKm4J4LYKq8dPFiTzl9DvVgLBiIZPzPtJ66SZUctnVp/5DUjn8qY9O7sQ
	 sA5dkcv0Qa0jL9XOFJ5fV8GjLRKLRISnuctz1AWql16s8B9gzl9XSySSh2BhTL4dv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdSwFlSEg/dFrM+RS33jkcpxGpnLhsBIVs/dz8t3Bms=;
	b=EmOEsPqT9maIax+VNTR9+LB9xgyL16ieqnDJdLs09MbJnezZqubHFhxgY689CxVEpjQQ
	 Dud0KJIX6jKTRYiVcB8dsCu06Ai0Ao81vmYR5KWU48IUtme7o8lRahi6RuLEE40687COz
	 YhxG67Tb6F5Dw/HFDWtxlrM5/fOdkochR/jc2wcAUOjfxyz0xBHAerMlwwQ9Nyyejbv7W
	 Pi9tkUEbk4eTw2AkTTQHmg3aUSOkAUE+5g7fn9JfBTrV+sROb86htx/OT6a84xh9DkWKU
	 CoVwr8Vn5w8fohAtPcx1PeVXqvEJVR0mctFVoXG2VUzgrpocHWGjwDuzAuyi9yIZtZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVyuQ4SB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15A606A32C;
	Wed, 18 Nov 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVyuQ4SB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FD51F000C5;
	Wed, 18 Nov 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017777;
	bh=YdSwFlSEg/dFrM+RS33jkcpxGpnLhsBIVs/dz8t3Bms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVyuQ4SBlDPXrsX3i3XthcuqF4UhPWQNiLmP2Wn7hAXvsOD4u4ACExd3PH3w7gwc4
	 LHoZ20eShJxJ+OrGQ2XmEGGGuOgQ0aB6WFehX4fhXXkXswGnS0UCypRx5DsqJUm9u+
	 8hHmeBl4sjENRuerrr8PU0wF+9ImUspV8zls3OlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0998/2651] arm64: dts: imx93-11x11-frdm: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118150323.838970671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ab6fc27a020a18a765e17bc445b64ee18b6244de ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: eb2f28413e23 ("arm64: dts: freescale: add support for NXP i.MX93 FRDM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-frdm-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-frdm-common.dtsi b/arch/arm64/boot/dts/freescale/imx93-11x11-frdm-common.dtsi
index 5c8fdd77ec15b..32e5054cc091b 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-frdm-common.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-frdm-common.dtsi
@@ -99,7 +99,7 @@ vdev1vring1: vdev1vring1@a4018000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -121,7 +121,7 @@ &cm33 {
 		 <&mu1 1 1>,
 		 <&mu1 3 1>;
 	mbox-names = "tx", "rx", "rxdb";
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



