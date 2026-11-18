Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024788;
	b=cQQgAm/JCqI9nmmfmLbaU6MS5XUCEZD/ebUH1j2GSu6HhJL1WVdj2oFFVzbqymYrU7mR
	 Gq4m8nD7rDB6BlD+dIcrBoSdwYYjcMZbEOD+sHKUXl8rgVSWfJPVbk7iz50lOns6nAJPx
	 z48jCxwoEuq720MaD6J7wdqtmzuIj4sgdRWdDz2b+noswhqfo03iKBtZhaUo0Nt/+sfzu
	 MRXvglY+yhzNR/veHIQNvkGIBNQhVZ2ZsDg4ZIM1MwY0cg1WMXkIyIbRAc23OvYpqd+Xm
	 RfI4p91SEPXXlljNhTD6DNzy+yiV/B4fHqjiRasAfyW2QCn6YwJdAAmGETeVPl31oYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZM+ye0gnpDDGDwaTHogdpoG/ZKROfOtPenL8y6a+M9o=;
	b=E5hhDEJXQJ7nLn7phfYRXZtkrR2GAWrYBswuG5o+79at0aTGuJlT1YwEroSkPlEKkGZP
	 faFzUyzY7rWqJ5ARJmkpp03tn7bMkMy+1IIrDDPyXtoRQpxi5v2OGt7721hXSvZ77/oFg
	 oGF2+SApx/eMzuusaXGxwaWrnGZCKzhmrRgiqrxEwfxG9iUT/90hgr0hZBOdklPb+dUDX
	 LEM9/XA9A8UHFwDtQ/bQFi83lStTMRTq+VAqUpD2wgbmT//zL99kG+Ux4yq1HiQn9Ez+J
	 X8OIah5s2xqqaxBEGAjZ5xeBP3H3fqDjSRlw3CpKbBDRkQmimz2pl+6NDT6W1yiHFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6txiOW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BD6606A31C;
	Wed, 18 Nov 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6txiOW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CF81F000C4;
	Wed, 18 Nov 2026 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024788;
	bh=ZM+ye0gnpDDGDwaTHogdpoG/ZKROfOtPenL8y6a+M9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6txiOW8n1MXIj7YQKE07J02rwcvnvJX9MoEC6YJdqfAs2tft4i/O+pCAxOPu/lNj
	 0UsxnuJEvPh+/R7yUB9DCwSbTMVSJKqUrrdKnVLwQGFhAVXeRlaV7NBGrUE9wjn6wG
	 hWLcfyCWFQNGy6KdKFv6mroOXhCuMIvaEqQe8uW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0849/2151] arm64: dts: imx8qxp-mek: fix dsp reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118150153.177828912@linuxfoundation.org>
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
index 4279510fc5c3b..53e71f4314b31 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -257,17 +257,17 @@ vdev0buffer: vdev0buffer@90400000 {
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



