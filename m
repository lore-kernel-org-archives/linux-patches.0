Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024797;
	b=iQQsLGMkXa3cuLVxwvNatFLUOqVeds7/3CPir9aO/cuKXVbD5Jy+iOS6A6L0iP7i52aj
	 DNqZk8ui0podP6n8abzBbaYmgS5Y/MDEh1CWW0g6PQSNR5IaAnRiTg9sFWs5RAX9rvt0d
	 0T5tgQ6ngtqlGmtZEONWrsExQtMYWRZjcJMQ0lGmgPG1YWaXkX9dRfPJOrOLaOTVvUKkX
	 cddZb9yydnjU5WGEcdZf4Sjw+13hmYF3LhMP/BcE6k4eIZ2P3FYujihhKhLaTJijJRVHR
	 k/ztbRkSG6y6i5sEogiEj6+ZG6eQppoii9tCRMA3kUVereWZps79Ojvzuw2oXB8gxvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cf3odIjApMf/3bVmbpbKa/UZbsx37+9iUUVeRFyk218=;
	b=rwdOYo9hVVe4VCYiRh5WGp8Hk8fPPhJADA3CxwYwLhX+nxcKgm81Xvbdo+q/soDQRKTJ
	 cE78aNVAmhQNa5AZUXj46qfgd3dqTmnvj9LZcjaG0nF1aTbMqtA5WAnuUoVE9DWRAsj7A
	 THuYY1MCShglDhlOJTWrfFXAh/Xc7s7vdOA/OaTHhgCzeuJNTGKEYSpu8K+nUMnyyJv3C
	 qyZ9Rv4w2pw8wiy/upidFzZlFfgLr/filSnQ3YILNWopdAenZLPWScagIfnw4bNGInLB5
	 99fcMFQd2QOfp6WzrDBkXHWd4YpJR6vaYEprMX2pnSTIGlBxvlX3vqqyszZbYS9GlOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZCaiQmo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1315606A31C;
	Wed, 18 Nov 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZCaiQmo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0881F000C4;
	Wed, 18 Nov 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024796;
	bh=Cf3odIjApMf/3bVmbpbKa/UZbsx37+9iUUVeRFyk218=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZCaiQmo9egJHqYw5wFTLZQpy72QIiJg5LyOic4y7/W5CYGAUxyUk/nfFCzZrrcpP
	 mI1uETPVZ+oXhWuVfvmi4yFm/4VC4FhqHwNIvVg6zKwUWF+y49uGRAJ1mkB15HHtyH
	 KpENoDSQPlo0BW2khF/s89WHmZvaTlkXAl/F0Gds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0851/2151] arm64: dts: imx93-14x14-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:06 +0100
Message-ID: <20261118150153.246107659@linuxfoundation.org>
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

[ Upstream commit e62f7ef5320d05361ee7f665568d05361b0c59d9 ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 0481dadbc5e5 ("arm64: dts: imx93: support i.MX93-14x14-EVK board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts b/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
index f9eebd27d640c..35693b2f28d0d 100644
--- a/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
@@ -69,7 +69,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -184,7 +184,7 @@ &cm33 {
 	mboxes = <&mu1 0 1>,
 		 <&mu1 1 1>,
 		 <&mu1 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



