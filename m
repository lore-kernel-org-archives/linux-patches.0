Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054729;
	b=Cb75Q5bXzf61zqbRoe4dhpLN34HF5OiaKoN6u0m0MrrgSYb8lsqA+vpmoom8eA70mNf3
	 36DHeFstu3JzSFYCAcoPKRZIyqusX6rFMZCRJJIt/D/hIrErYlgsheqSb5kDrPrbRKlPV
	 aEKJIMrq10fcN3YwX6Mck8VqIEQq3PELVO82E9ox86/bveS7zHRbQxiPThk7ZTi9hfNFc
	 Rl/imk+TNrt3f6sk/k1oaGj1fYI9Vx2epZmytlAidtYtMd4Tg7Vi2UuagO/wVAC1UUl39
	 vn9E9W/pJY/2bazKbuhZQWCF7j6C1ldBlp1RyDIUhiQQgkFMp2Ay33ESojccmJbM6vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3jJQPSIaGMd3NHYLyt96WXJN0z3m4wmesPrUx5Ff9I=;
	b=5IBQSnySdAjcn1SABblDZOyE6oDWphqR/uN1LqLvSEabeIyB5poolzbuhpodMEAbtOT3
	 /loQrCmfwqaPzqSRWZF8QRzA9MfpO55shcdhgVzjtptinqNM02JTEe8V6BhrLiKT9/Lnd
	 8x6/lvJs0kzVBEtbk6+Na1nDo9GEDzBdWsgI5JKRBEy4w2gMC1rdP8i7F5wBnWwXwTg8T
	 qCBXpvVfvjI29D/veaSjZQRlrAOGgbfqm7qdYbL3MY8T35jDriTzlbuKbD2QhUbvZWm7u
	 FVUIDmsHc6ARJwK/xABrNMOIqSP+eNBW409lgarfA84fGjO0SyJDrrIIBc7qPW2yJrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kf8gSfqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32157606A325;
	Thu, 19 Nov 2026 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kf8gSfqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF581F000C4;
	Thu, 19 Nov 2026 02:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054729;
	bh=p3jJQPSIaGMd3NHYLyt96WXJN0z3m4wmesPrUx5Ff9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kf8gSfqqCqGVltHi/1EJ+NkltXXwV1hbFInjc3OI2Dg++prjxpzivRFTtYSmRHgfC
	 p+4aH4+/5uxDb56JCx5bFz4MHbrc2tJ0Sdd6qmVucMysSXaz+2I/r2pHg3ofTkE4BZ
	 zntbdHd3zyMWze+1Up1Z101nyxTy0QNxelIZ5m90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1337/2214] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:50:13 +0100
Message-ID: <20261118150104.932596801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-395-gp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-395-gp.dts b/arch/arm/boot/dts/armada-395-gp.dts
index 6dd9e9077f842..9ea447cd35a85 100644
--- a/arch/arm/boot/dts/armada-395-gp.dts
+++ b/arch/arm/boot/dts/armada-395-gp.dts
@@ -59,7 +59,6 @@ sata@a8000 {
 
 			/* CON18 */
 			sdhci@d8000 {
-				clock-frequency = <200000000>;
 				broken-cd;
 				wp-inverted;
 				bus-width = <8>;
-- 
2.53.0



