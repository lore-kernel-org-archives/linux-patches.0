Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030359;
	b=1u0jg802097BmsvePylohDM9gTBXSwOmeV9BH+0pq7khqqqFJRWaZvLyL1w0xAWYOes7
	 ZJ8j2uXrhUB6CA9zHMw/4bvNPooTNQuodPkpoltynvhTwB+o9fFPSpUiI/ik/i2f7Q0dq
	 +QMMZpH/g0gQ746APzkwBW9qyz8RNpVUnWGZDSrz6bs+ijO/G5cAUer0iXbyg8PZp2arf
	 ZHJ1jAbKwNYnuCDSyPxW0c8XqweXMb553XZCAmyKLSxYxU0TmQuuk7ydKeduKgSngJqN+
	 RLV6fwEQKrVGTGryIk15mDE1D0DUMMzLNofiFXylqP630A+fbXcovkswUU2hOMI7gaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXJISdpWxXL+5FdymsTLaNyfhYA6dK4rOpE4WfWfxzA=;
	b=ASWQ7Cue5KMkKJkJZuB2Ec0+1g/qRHBUOUSpAjOneNKwU6qr2l9zdt/nC/M0h3MfGgSy
	 F5W2jy8Tb8QujJxFe0jBZS6HSL5ZoIEdJzCO7StmCnjjbb5hwF7J8mESeGH9BGgcL/UVA
	 /0zgvjLtrr9DBR+9RpN4ICcKC6F89fiGkEiDNN0PLbmAeo/3kx96rO78RQwmEDajVk8cm
	 cssFnx5SOwre90Jlu4xmQIZQckIVr9MJxCz+/DiCzQkJLu/ZU1iXn/Kc+LbCqs/caPty8
	 FwXdcc3xNng6yVHqoRmLttxze2Wujg+o37O8P+pg4P9dgWiLOx3H6nBHAolz1PHlxbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4fd8xWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F715606B101;
	Wed, 18 Nov 2026 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4fd8xWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586CF1F000C4;
	Wed, 18 Nov 2026 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030358;
	bh=zXJISdpWxXL+5FdymsTLaNyfhYA6dK4rOpE4WfWfxzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4fd8xWznkdTXXn5sNoIOftZHLRkZfUWeYt+1kkVJ2yt0/KJgDGjSf6b9RhZXJV7M
	 movHb11c6DxWvH/pgLVgzDqedhWvECWq7y6b0pumDriW35hEiSqzFDPgreXLgCzm6F
	 aEETN44fBD1SGJ/H/dPHRe6UtKwWzm1QitiOD/PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0675/1756] arm64: dts: imx8qm-mek: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:46:42 +0100
Message-ID: <20261118150036.145072960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 32a37e0d0b425..b7bb7dcc1d77c 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -37,57 +37,57 @@ reserved-memory {
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
@@ -236,7 +236,7 @@ imx8qm-cm4-0 {
 		mboxes = <&lsio_mu5 0 1
 			  &lsio_mu5 1 1
 			  &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table0>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 
@@ -251,7 +251,7 @@ imx8qm-cm4-1 {
 		mboxes = <&lsio_mu6 0 1
 			  &lsio_mu6 1 1
 			  &lsio_mu6 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev2vring0>, <&vdev2vring1>,
+		memory-region = <&vdev0buffer>, <&vdev2vring0>, <&vdev2vring1>,
 				<&vdev3vring0>, <&vdev3vring1>, <&rsc_table1>;
 		power-domains = <&pd IMX_SC_R_M4_1_PID0>, <&pd IMX_SC_R_M4_1_MU_1A>;
 
-- 
2.53.0



