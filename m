Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017808;
	b=BaAZlh55oWojugX0t0KHLUula+u+XDm9huN+At3zPDWGF92WJqdQWzB3rGVcpfALYaUr
	 SXQgg+mq6bKmd+CeS1QtQ1wJgVKkFba2DM4FiTk9ILzlkTLB+poUYjFMH9K1aypTDplDT
	 JxA24/fVW7TELfntXBwnZLklU+76bZlZ0A/p6uIKzvfbIO/WqPMaxzYCuCkenqkffsFAI
	 QboYyA89jz5eGIVrf41WKBVJNM0tPXyHALwlWNddjq0xN/qCd87gU/Vp25arx0wspFrKE
	 Y+xOGDERS677C3LBpdFCSAeiJfY8Gt01tgTZY4rfjye3kk2LtpS56s4sFK8myyMtmwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsnNxJAm9xn+qAr5YusbdI5b/p7RWNgVn79LyoPT7Sw=;
	b=bryhMkwvSwtCmy/eSK6k/6csM4p4ndmtkGyBLZx+e5SwNa2/RWOGIFDvNkfzPKhTb7ZT
	 AKTgno1oXh+vZKAk1q1epK6N9Xx9FGyDc6DN480lEskzo04idxs5nksUhhVKh96gQqgFj
	 2QR2NhilQTNRKUdHXOMAD59dhBsY+rNa+WYOb7hCklUaAd0vLsaRiqHCUlPFEP8aG8Dqf
	 NuFBSOWUGfmkGlIG6zzKEHikLEOCouPqccNkQnX842vDHR0U0+Hd8E4unaGECDN8p20zG
	 Q7GMiWSuhB9xWOUpys81YBUvkvo+IUejszKDU/Q85mpXffIjsHfOPYoZkv06QGDtELg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7RnkIrC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6AF60A260E;
	Wed, 18 Nov 2026 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7RnkIrC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30231F000CB;
	Wed, 18 Nov 2026 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017808;
	bh=zsnNxJAm9xn+qAr5YusbdI5b/p7RWNgVn79LyoPT7Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7RnkIrCUSKK3EsuifdqdvK2Olb1t65Oavfx1y/EFmHWl1ZfY1YlmUC0BGzCcfC+z
	 wMB8v1wLhjFjJrzeYNC7KldepafbQul3QwDH9on8qpptyd5Kl16SpYoUhRZQ1b6Zf/
	 8FLUREf35CGAIa0lPhFzoK42Ja1USgMFWFIl6Z4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0999/2651] arm64: dts: imx93-14x14-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150323.876326633@linuxfoundation.org>
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
index ec78c03f4788b..3ea50d8080344 100644
--- a/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
@@ -75,7 +75,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -222,7 +222,7 @@ &cm33 {
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



