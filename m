Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024778;
	b=wsaFSkDEntm8v7L5Bg5ahkjjlmcQu4EFQdpvdEb3xVJThkPW1HF+5tkLMj0vT69M2sk+
	 jO7+833A5EIDqMObujpB9QslvD+XaUmFat6qO0GSB9IU1CzIPa9d5NN2xjzMdnNYClY5e
	 MOvFkTNSmzm8bafoQHueImvBy6dW1d+orQronwZbLs/dgKhRR/DtZoVdIfkth+Or3sAUO
	 wF2+fuBWhS9t00nYrYwGIb0b8WniOCKo4mizL5/IhNUfQKvcCFmLwuEAoy08QWu9vMyww
	 VwhpXijsvDelEImOBjdUYv7ht0dXJQANT/0Ee2bOiiBOT5vvPhNtiF18iuaj/CCbysQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdGOX1/s4UEVdLaE7Oz5CFhVfEpITxcTf4rd1xoMP6U=;
	b=r+hC4olz1gjrv6ebtzJ2HOvbSDhvW1f/C0y4mVOwN79wRfXCo5+JTHBIJ2uij/cBhewX
	 O3pqt+Oxgq5D8L3ksYRN67c+eGRXEIamujZBHF1R8MiZ8hHKz4vj8880izBqD8olOZ+Y2
	 r/20gRZNIvjviCb3+GcRtOnGsHiBHy5Bh3ozz70N7L5ipJFdyKjg+/RH1m0HhT4huiEbi
	 b20c25xfZ8iZZyU4I5EC5JjBeIzFlpxO18JP/H90Z8pib8jnnRaYEf6u9F5pTOuY306Rn
	 9DScmHv8+1+7yf8ThJylujVMbsS8iaIEepfB+ahq/0GrmBvizqDxfygh+VFEmnyCaoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEjXyWox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD2606A339;
	Wed, 18 Nov 2026 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEjXyWox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E601F000C5;
	Wed, 18 Nov 2026 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024778;
	bh=QdGOX1/s4UEVdLaE7Oz5CFhVfEpITxcTf4rd1xoMP6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEjXyWoxVVIY/e4SKIkybjJz6h3BLlQwWUEShVGMIdzCOqnV7FQuXKrIMdPCBwTOR
	 J+4BR7SyI9rnVpXsQBHCUAWn+kCXko+eIRYBPNSBaknNcE0Blo1DkavL9EERV/NgKK
	 PkQq6ulkAF2fjzqFKIpaKRqtkr+jniJqEqeG6PiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0846/2151] arm64: dts: imx8qm-mek: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118150153.072041674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c712a46c10d38ce7869a9d81d7986e844a4e9f24 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: 52c9971edd4f ("arm64: dts: imx8qm-mek: add cm4 remote-proc and related memory region")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index a97883873b564..cea9156049b2c 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -44,57 +44,57 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		vdev0vring0: memory@90000000 {
+		vdev0vring0: vdev0vring0@90000000 {
 			reg = <0 0x90000000 0 0x8000>;
 			no-map;
 		};
 
-		vdev0vring1: memory@90008000 {
+		vdev0vring1: vdev0vring1@90008000 {
 			reg = <0 0x90008000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring0: memory@90010000 {
+		vdev1vring0: vdev1vring0@90010000 {
 			reg = <0 0x90010000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring1: memory@90018000 {
+		vdev1vring1: vdev1vring1@90018000 {
 			reg = <0 0x90018000 0 0x8000>;
 			no-map;
 		};
 
-		rsc_table0: memory@900ff000 {
+		rsc_table0: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdev2vring0: memory@90100000 {
+		vdev2vring0: vdev2vring0@90100000 {
 			reg = <0 0x90100000 0 0x8000>;
 			no-map;
 		};
 
-		vdev2vring1: memory@90108000 {
+		vdev2vring1: vdev2vring1@90108000 {
 			reg = <0 0x90108000 0 0x8000>;
 			no-map;
 		};
 
-		vdev3vring0: memory@90110000 {
+		vdev3vring0: vdev3vring0@90110000 {
 			reg = <0 0x90110000 0 0x8000>;
 			no-map;
 		};
 
-		vdev3vring1: memory@90118000 {
+		vdev3vring1: vdev3vring1@90118000 {
 			reg = <0 0x90118000 0 0x8000>;
 			no-map;
 		};
 
-		rsc_table1: memory@901ff000 {
+		rsc_table1: rsc-table@901ff000 {
 			reg = <0 0x901ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
@@ -440,7 +440,7 @@ imx8qm-cm4-0 {
 		mboxes = <&lsio_mu5 0 1
 			  &lsio_mu5 1 1
 			  &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table0>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 
@@ -455,7 +455,7 @@ imx8qm-cm4-1 {
 		mboxes = <&lsio_mu6 0 1
 			  &lsio_mu6 1 1
 			  &lsio_mu6 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev2vring0>, <&vdev2vring1>,
+		memory-region = <&vdev0buffer>, <&vdev2vring0>, <&vdev2vring1>,
 				<&vdev3vring0>, <&vdev3vring1>, <&rsc_table1>;
 		power-domains = <&pd IMX_SC_R_M4_1_PID0>, <&pd IMX_SC_R_M4_1_MU_1A>;
 
-- 
2.53.0



