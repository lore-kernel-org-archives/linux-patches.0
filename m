Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024775;
	b=4JvkK5qa5dm9GrknwG8Dkr3MWKBgVCSsQY/QUqCDL+OPOcs9v33qWYV0YT9KeocFMZBL
	 aNGRrkF6UM6YwgfBrAmGyqV2X8Q4v18zpmHPXKBwh5syxuMBixeNma4IZarTIymU+Mn2w
	 L1JN0soo4dA8DrtvgOL7TOLeYlue855IkSOFmjjB5h/wPvYepYxRMqB3oLFWcYqD/UO/c
	 0JCNC1nrQv2UU9MMQOrHp/At25Rh1NBtV1fioCj2ah5fk9cTIDD3Ih5Guw4QS3JdJU9lz
	 f5a/Cjmdr4fiiGvWuLY+Pl3mHCl5Gi5tFrYIpo4/ZjU81OTT3aSt0DPLlPafwLsvzCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sSVCneLe8a2uq5a/nLu3ElGelylHolCkDUTONm+ds+I=;
	b=5DCGmUu86bBDuYRrijEe7A1A0Xf9kzZcI+lxagfXFk0FGkyluNCnqw/5XZXA09Fhj4Rg
	 5shvBHXVux8P4OO3zQdjbdRztrTGkLAJZndUMqnj/xH1GDe50KYETfoo1mNhyxsZhbd5q
	 VQJ1GPUStZiiB2+k6OpFmTSjp4CkBH+cHV/TS5A5zVgC69J6em273ngF0uYsy0+yHKDGa
	 4koHX86w8NkDUCnVh7ZG3gCR9nUVFpFkvw9dskB+ztAQ48Ltye8YmN44eaiiJTxrQ+tDj
	 YWHAK8VjRtHPu1hFcTjiXdNsvKXAHndjKfwEEwwnDaRHl8RiuzRFAsLQ7Hr1j9RIssw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z852dApe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A091606A325;
	Wed, 18 Nov 2026 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z852dApe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B961F000C9;
	Wed, 18 Nov 2026 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024775;
	bh=sSVCneLe8a2uq5a/nLu3ElGelylHolCkDUTONm+ds+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z852dApernC8MQxDR9sb35QHNBrnHDdrIC2eAvtP9yuGiHtsxQd7/jHO0p1PiZkUT
	 uI4xLxhNWKLrtoCT6UaH6X9Ee3QKrFjq8qzFg6hqau24Di/hNZtDPucxU3npJC6Vvd
	 bh9XQpcmuESSXgbk6/+OKIWfjKBXs1hjGzlLb1ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0845/2151] arm64: dts: imx8dxl-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:00 +0100
Message-ID: <20261118150153.037457644@linuxfoundation.org>
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

[ Upstream commit c4e5f1a143799651aba2c4f66860b63b56786306 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: ee39dbd9a6cb ("arm64: dts: imx8dxl-evk: add imx8dxl_cm4, lsio mu5, related memory region")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 605a423a1b668..40d6e175f1400 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -29,7 +29,7 @@ imx8dxl-cm4 {
 		clocks = <&clk_dummy>;
 		mbox-names = "tx", "rx", "rxdb";
 		mboxes = <&lsio_mu5 0 1 &lsio_mu5 1 1 &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 		fsl,resource-id = <IMX_SC_R_M4_0_PID0>;
@@ -65,32 +65,32 @@ linux,cma {
 			linux,cma-default;
 		};
 
-		vdev0vring0: memory0@90000000 {
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
 
-		rsc_table: memory-rsc-table@900ff000 {
+		rsc_table: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory-vdevbuffer@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
-- 
2.53.0



