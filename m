Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040397;
	b=yvZpji+dlew4/SoZvZ2+DA8mhyszwGnkvROAzxy193s6ArIK8pkXiMsacQ9vEAlrBxci
	 x4bL3N8Xmz2l1szQJPrNmwXSDt/726aJ5G+GgQVPQrIFPTU2Jx51XPMAf/PPcLW++ZxFc
	 EGe3xF42CA3kRV6gmPcocWR9uoA9oroEb7cvWRaF0sgwxULOKoZrKIuMiQiRkPkm2hkow
	 LE8gUP+21VssQL4dZc7IIRWJxFtSMK9KBIH1JStFYKttgun92RaRJTKpOFg5CoFlbDOSz
	 50jKqEKU5wbu+uraSWRnWZoOJ6G4dhHf0wsIB++u/wx86wCPftGyS0OVFFJDLxeJezQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RszJNGaPWgrPih2sywtBWeBL3EWrKYw370gQ+f9a0IA=;
	b=GzaesAjpMawZFDlJavd0SygB+JdXhpu+B/cwaCa7ufVRjkTTqXsY31E8H4AGTAxuoFFF
	 EKH0JVoT43brRiMu43WFW3Sy8vKPqTs4d8gksw0EAIotOrMf2vWpEaVInb4ZrbyJ4cuMJ
	 6UOJ1EiMQIbl8jmqBtv09D/RTBUwafNifMl4iMmCOxARJGWs56z7dzc3jBAfFT32ngb3/
	 zVxaaX/uV24E9v7h62vThO9jenoy6ZYxSR0MOzX4rqMsuo90hVWYvHHSR4ORza7cQQH9B
	 BvMN+OWGgnfkLrZ0bB9uCJVjU8EOi9dFH6p4C/te6UedQbHYdQY3RZ6iXBpFeUdpTOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzKdF0zl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E97606A330;
	Wed, 18 Nov 2026 22:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzKdF0zl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658991F000C5;
	Wed, 18 Nov 2026 22:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040397;
	bh=RszJNGaPWgrPih2sywtBWeBL3EWrKYw370gQ+f9a0IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzKdF0zlEzDTNMNpT49Ph/TgUJPcG9J97ExoofAQqtvHaQy/9y8aCYFpl6dV6IaCL
	 0QFhdYTm6Fye2FUmZnF0VtpydWWmUloI2dQEswOtu9ZaYBkMHBjGysIboyQVTAj2t+
	 ocIphd4bTcE5V/exyoN3SB5wjXIL8Z0+DkPCotD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2441/3318] arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150434.681172441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f55e49b75c65c3e38e7bbe1d735f79128a50126e ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 014fbffa25a7 ("arm64: dts: imx8ulp-evk: enable CM33 node")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 69dd8e31027c8..d23513437e37e 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -62,7 +62,7 @@ vdev1vring1: vdev1vring1@aff18000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a8400000 {
+		vdev0buffer: vdev0buffer@a8400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa8400000 0 0x100000>;
 			no-map;
@@ -90,7 +90,7 @@ &cm33 {
 	mboxes = <&mu 0 1>,
 		 <&mu 1 1>,
 		 <&mu 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



