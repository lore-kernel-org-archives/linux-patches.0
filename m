Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022830;
	b=NWQf/cVQ/TmlkOTmABxe+UDCLzdYwwibz2TaZcQzn65weSUm989+8kko96KpFsVjIBqU
	 d2Z8ZeE+NXb39xtd3LE2fbo5mworEMcBPbxHyrVuqydcnqJtoeyL00Tjfd9Mqj4dDPfhd
	 0zNecYexb0UdomdzDUNlptN4nDk7kqiF+oHZrxGnps9Lw4ks0Mt5LREKZLj/dcEjupjyR
	 2OKVZ2PhVqGDtIciPMRgqnF2KhTEJioY7xwoo9I/s5+ZDFVurPiFhfRDqIFPGir44oEMc
	 thW9YFopNKDt6flwKAg83q0f0OaGw2EM+8O2cRlogj4qQpG25TZ7YDUqgBeUpZ8awuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wgfPBoxxAJCJITPGwzOQqtnH9UNQJWmZekcKNJ0RxBI=;
	b=iCSYGmX5miZJNxE+l314PuPcnq8Zi/RturEsxNk2iaBe1qysL2j2LDD16e4Cc2naRGoY
	 VExh3WW3vhh/tuSNT0qcfetOgTjQerh9Vy0uIR/7vSGvlIfPwFtYWSVVz7+OryJ3JKFLN
	 T4/GDa4L6lkRYWgP0SoPoAU1L+MhijB4cuzgjDCtt+SpZMxbFw1RjqfSlD3E5DMdsCTPy
	 mRXxi/tl6FCObwsa0Y16Xhutss/8LX0zDYmg9iwT3U1/499EGXxv1McIDQg5AEw2XSTFL
	 4ubbBBLDCuijffYdm03FVrhKIYPurGeLCkBozQog+ZFOxhvvVuZslaAtLbHZVKG/nTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIBKqoHQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F000606A775;
	Wed, 18 Nov 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIBKqoHQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FDB1F000C4;
	Wed, 18 Nov 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022830;
	bh=wgfPBoxxAJCJITPGwzOQqtnH9UNQJWmZekcKNJ0RxBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIBKqoHQ6zxBdz3xkG+anmaATceaLDvAXmFQYEeVxmpzW9IdoBoANbwAzO8MZd4mG
	 uydT5ye8KV2XhvqnuUzcgIZJBU0YwLjdFOopsDo3AbNlZF4fU4gTZclSJ6ddQFzFnO
	 a1by/3k7IERNoujNQgbhG9XRiLRET0g6wePvvNDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0154/2151] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:31:29 +0100
Message-ID: <20261118150127.369053179@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a56183c7f15215d804290808a2b5a1fa997aa9cd ]

The SDHCI node carries a "clock-frequency" property, but the
marvell,armada-380-sdhci binding does not define it and dtbs_check
rejects the node as a result. No driver consumes it either: only a
few other sdhci-pltfm based drivers (imx, mcf, iproc, arasan,
dwcmshc, xenon) read that property, while sdhci-pxav3 derives the
maximum clock from the io clock rate.

Remove the property.

Fixes: 356645123581 ("ARM: dts: mvebu: armada-395-gp: add support for the Armada 395 GP Board")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-395-gp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-395-gp.dts b/arch/arm/boot/dts/marvell/armada-395-gp.dts
index 6dd9e9077f842..9ea447cd35a85 100644
--- a/arch/arm/boot/dts/marvell/armada-395-gp.dts
+++ b/arch/arm/boot/dts/marvell/armada-395-gp.dts
@@ -59,7 +59,6 @@ sata@a8000 {
 
 			/* CON18 */
 			sdhci@d8000 {
-				clock-frequency = <200000000>;
 				broken-cd;
 				wp-inverted;
 				bus-width = <8>;
-- 
2.53.0



