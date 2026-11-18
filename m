Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039153;
	b=e/iHtDrmOdkuSxfMOZhDWa8UXVKLxXD1Ir9kLwWLWMHg2xw9FZhPiPUHQ9CXW5Y/Gr5b
	 LNeeAoRV3MtRlcAbS5Ny8K2LCcIV4NIPZ2GPp9Mbu4Xxy2JFickwyJPcxdyg6jkCi9BoQ
	 /brs9BkL7iGfVFEDQRftlLMaN4P+gQ54k92Ygzxv+tJDCCYsAV3AY2RA7VD+IYX32bHP5
	 PiCAGP5mjJCU1uRciCkudV8QaNpep7G/G+PIOZQPNN1mK/a2uXke1m/XyOQkkBEwHJz9W
	 sTCou0IV8+rrVclFWvRNmNyHVGkyaL5kVEzkFBzlh/0O9W5koIexntgP++nc/yvh8aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YCAcUbKvhbil3l3Y6eXqzNwTfblBpwFJlqew4U8GlYg=;
	b=MikbzXo/bcfHSp1T7AjjPyQS3AxGVn1aRNifU+rfg9XaejEJTeMoH5B6pSwmhkZdvptt
	 lrk9VqITsC3w+IVZcFJs2tbwCDJIHPiSApi9WlY3XIa4z4tAI8IZn8JuPiA8DS6s9t8Qb
	 xJoV+xake8U4aQdt/6KDvDb2nt9+ZU4K976EC98DP6gDDm2Tcizm9TTtvIcRlaR+SLFEu
	 +WS5wjyMqqINQHVYlDvw7t0S8ad7Px1SUXr6e+Amt/VKzXk5hfGUM980xTbEdM1u537bq
	 8D98OZqJainz1RpcdknawAtG6dAxTBBmQInI0rTEjZX+HFCZu31lrYV4q4rS89EV0uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTW4+XD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35153606A31C;
	Wed, 18 Nov 2026 21:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTW4+XD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769101F000C4;
	Wed, 18 Nov 2026 21:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039153;
	bh=YCAcUbKvhbil3l3Y6eXqzNwTfblBpwFJlqew4U8GlYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTW4+XD2U0Ro/A3nw7cW7ymo5OQljwAGAXUV3HxHRpI0yWoBl5QL0HM96Y/H1y9Jo
	 QBAYL2z2M3GOJNTH3J5tGDo0xdl0AEAFzCd7O4IHEMF5qkdcP89+OOt1/IsPm6A9Qq
	 EQZERhvQMyVgKnlFPdUzXrSuBVwLULl6gnWutpM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1997/3318] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150421.963070402@linuxfoundation.org>
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



