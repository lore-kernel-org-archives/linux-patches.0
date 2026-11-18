Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017755;
	b=F7mNNaxDpvR7Ge9kNnMwhc/6KFpaa08q0VowT+La0bvGFSRTuzJkLEdBzIRgR4zVG1LV
	 eBkvK+mq5qdV3zW49TDk6aOYNj1BPo2Sg/wDLaZDQ7ATB+tjSTwlYbM2dAsZOTpBcb2g7
	 troqsOekqaLULbcEJsulLGfoIcgIVndeQ35f60RRLjju+4gHthEgZEUH2MQE4Ha+nI1We
	 x4TzL95aB4ivPrMLUElwtNORIddUhhM0Hi/yh4MSJ6OroTq1vLrv2xWxLusjkzzOTjyy2
	 kCTFz22UbiC64XZaJA9ArbIqnZBFwyU2usoczhd+4ZethCCyDPvvgV04W3r2kGz3wQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVUq2+L20dSiVPWaAvDzi97fZDiStTisHzrGZwj5jJo=;
	b=iw4U21J2kUoKKWHOpkqU16OuH+1IoVX4L/ALsvtppzXfuBbKWTuoJlzf9Bso5PvKmOTf
	 fbDQrcBAxeEX+oH4aaDcB5x4mibuDV4qEuO7e3/Ee8WhF9Qp2iQ5232h69pmzHVf+yCHJ
	 sAO3p+lLFBXxwBClAkvIrUuKxYpci5Oamndt49b0DF8LH/EYNqXSFn204HBJkrXjshH9p
	 3c5hS5ujQGrE+GFtcqwtIpD0nvIRH31kuLrJGt2gaHm0MDka4kDzeIBYsjrUkPjF+9giX
	 zH0QpNF2aqiUenR2ekVhyNZfrQ5ilU24j8IbMSkwETyAPAjbsnv2MecRjsxx0hISCxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uxf2JkI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD0A606A333;
	Wed, 18 Nov 2026 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxf2JkI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F81F000D3;
	Wed, 18 Nov 2026 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017755;
	bh=gVUq2+L20dSiVPWaAvDzi97fZDiStTisHzrGZwj5jJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxf2JkI/zocLoDV75xYwz/s610rA0SCq+c5z3cUGWIDqzxeqAzy2RUh9CyvS8fzbR
	 Zm3VPSbt8sHlxEIiM9ch7ml2c+tNDW63r/q/8U5g29a1ZUcqWYzb0UMEGUzaAToIW/
	 Krp0GkwOKZCI58OLva9p3GnOr+m6U0YzR/3NdyW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0995/2651] arm64: dts: imx8qxp-mek: fix dsp reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:15 +0100
Message-ID: <20261118150323.722265323@linuxfoundation.org>
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

[ Upstream commit 715f8f8877d03025a2af98b4128c83441617eb74 ]

The imx_dsp_rproc driver checks for the name "vdev0buffer" to skip
mapping the vdev buffer region, as it is handled by
rproc_add_virtio_dev. With the node named "memory", the check fails
and the region gets unnecessarily mapped.

Rename the DSP reserved memory nodes to use proper names for
consistency with other remoteproc reserved memory regions and to
ensure the vdev0buffer check works correctly.

Rename the DSP reserved memory nodes to use the expected names so
the driver can correctly identify and handle each region.

Fixes: f3e22e1d8171 ("arm64: dts: imx8qxp-mek: add dsp rproc-related mem regions")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 6322ff471175c..eb994f3e28729 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -273,17 +273,17 @@ vdev0buffer: vdev0buffer@90400000 {
 			no-map;
 		};
 
-		dsp_vdev0vring0: memory@942f0000 {
+		dsp_vdev0vring0: vdev0vring0@942f0000 {
 			reg = <0 0x942f0000 0 0x8000>;
 			no-map;
 		};
 
-		dsp_vdev0vring1: memory@942f8000 {
+		dsp_vdev0vring1: vdev0vring1@942f8000 {
 			reg = <0 0x942f8000 0 0x8000>;
 			no-map;
 		};
 
-		dsp_vdev0buffer: memory@94300000 {
+		dsp_vdev0buffer: vdev0buffer@94300000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x94300000 0 0x100000>;
 			no-map;
-- 
2.53.0



