Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030362;
	b=1Uy3c4pdBpPknJvp2uCh4s8p0FczLDhOHuhOlzl+B7aKpckhaPPIn4y+fB9R0GaXKaIj
	 2Ndibhxe91ww+6a38wQhHqx4ANBLNoq+NetKSb3gD/fqPHgMZl7BUvjytSHJnmt5KXvXP
	 jkHl68zmA/+bifO3tyCrSrxbZZupMgThVKzB/Naqi+OeeM8+Y6O+WU2mTynoPJUzknvsE
	 mDVMoCG2CgmH0nedwadlNSWG/Ys1B5GsG+l4EY53opjzk5PqSKmQv4BYot6DNoFJgEntB
	 5EFLTlCEnZFN+ZVZaLgXu9WH0J5m+onYMlxLIBf5ybrYrFiVrJizprQddHlWcVSa2pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FpzZqi2pjB7GoC/n6X46OBOqgqgFwHpK5/kbA4VNgkc=;
	b=PcF1fWyJFBH1a/Wnqg9a2CeoyVQ9cdbGtMQRMH8ibtDJx7W3uq1ksv2rX02bLoMlfKG/
	 136DYBMBEdUsgpFPUV4MhDRm7H7rmAhjnvGye8Iq8bGoIV6UR28mBDY+3ZsVfn1ojL4im
	 oZZPA0obPenHbiXvBKxwlIT7d3xe/WWSIA+3W2+CyIOpbTGN7aZYSFExiHFJWkeyAtM06
	 z8ffdfTjHHpnc6e8N1fS7jVVnX2/naJ0BVe8UJ0QXiYVhaJAAWdVJ/aDYAf/wFDhLV4id
	 jYrmX2bqwm6bDhs2uhFqZ2HS56PpuBlgiOu6ndxD8KJY6odcFJg0wBu9LuxCpyPXDLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp55WfTE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9E606B118;
	Wed, 18 Nov 2026 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp55WfTE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F21F000C4;
	Wed, 18 Nov 2026 19:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030361;
	bh=FpzZqi2pjB7GoC/n6X46OBOqgqgFwHpK5/kbA4VNgkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp55WfTENCJnO6a2mKYcuITVpTdjraC1JvqUrkJeuqKK6BmjzfjqirKtq8C0XQTYo
	 Gdyq7FpBNaes7caTTy3CuG3JuTaKD7C26fHIOGk8LhcR5HxZUYjBXnLlBoCT88nbg8
	 zbe5y3MhSMCbhPnpMRHVkJ+vdsQ2hvVPNNGYqKHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0676/1756] arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118150036.182272289@linuxfoundation.org>
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
index 54f55fa083fb7..ed681e0661d6d 100644
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



