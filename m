Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028900;
	b=I98ABqEt/+uaV03aMnIxHgw45HalVZR4rY8yscbZLWWq+U55Gb2u1YZQ/SDkfQn9mQzW
	 mFP2xiLfc5ZFijfr5qCPF3YzBgiBYLeWsyQYROzGhO6/CQCASUJZ1NFc2k4IXL5/R9HHw
	 plk8/vLfxIjVOrrvHtFzPKcA+C1HjkrLHXhUHUa6H/1TQde3cSrUO9hy4m2rki21TDYlc
	 txcC1XsWpQ27x8pv3om4Ymdjcrqnt4Fo92qj5stsOSnyaSCkgp1HLPR3QCLaqoQOxFsiu
	 I0ihTO+CcLQA9vXwWMAeMtKva+POzaADjgNgkIOeAss+nHrI7bf5j5FXSo2iaE+4F7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJOe1LIwOCVa4M+5sDR7FzKPzqbG0zWtJ/Mr1/JL4N4=;
	b=YXhfZHq7lBGgK5TDekCoTbChGe5NPkNxTDcjiKiUClI/RgF926RjLjCpGlXS6kenlRqj
	 VbP2/on5oT8eV9y77Whx4QZmIwhVMTXU08Rgl+6dT/ZnUVnWoapolAEb24XxmeHwE9J+X
	 fQo9PUHAa5eLmsMOVRC1EQfd/QVYrw0tJGRN3uRxQpDhPDHzVehirYapWPJVqfl6JZL7P
	 pHW56QaSIdJ+aFcd4+UaDZQi4WLRqlQnPz9eB/MZraiiScck+jHqDwHd1KXpFGMw97FFA
	 bZ2DEHIRp1SCHyFqUt7Vto0XEuSlLOXdstjjHOr2S341UUftoZbaTo9Q/X4yBQVlrCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDsC0mre;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92E606A331;
	Wed, 18 Nov 2026 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDsC0mre
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7C91F000C5;
	Wed, 18 Nov 2026 19:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028900;
	bh=yJOe1LIwOCVa4M+5sDR7FzKPzqbG0zWtJ/Mr1/JL4N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDsC0mreQ+0ue3XD4qY+2tWgT2VabKsTG51wrdqqnPgFCqBswBXoXEPysUnVil8Je
	 eYjsWLXQQK3L+3QsbBeod2/WsM36/DIKCzDgDodUWGQAqlDC9H8dq1vYbnCBiwNkFL
	 WLZpy04npzhvJS9eOZssaWho1ahIZoYq5U1jKWsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0157/1756] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:38:04 +0100
Message-ID: <20261118150014.374169013@linuxfoundation.org>
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



