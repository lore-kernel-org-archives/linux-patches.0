Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637D93C1401;
	Sat, 30 May 2026 18:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165560; cv=none; b=adHzd4c9OIlozOZkM9YFQfQpUqlU52QBTEV9VQSuheFAxzIAGswveDw9rfz52H65W6DXy4rM1RDysPfz7pGvur1vt/jXajlGDP9rWJ/F+xOOhxlt0UeaIDYmdkJ1MeEDVZz2tQ3ZZbb6SSK4Bxq9gTfQTvrgBKgUJ0TV7lbaaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165560; c=relaxed/simple;
	bh=Nubtpdee2FIW6d9T60avdGY6bj8TigWmqq4jY/MbUug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOzJFlo9PacdvZdNzlLvlm9Jf3FodJAjwkxqjN1TcBI6ODrl4jJrxd6asI0QZSafBQt8fxTXrLHm56QhmEpEv5Tg/kugFENG3cilAKIEyMtYy8a9wueP4RY3YUm1waADTEcrTzjBkLjHmpJR/IOKxA1JTEQa3ML7vb6ni2H1pnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZOjlwqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZOjlwqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55261F00893;
	Sat, 30 May 2026 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165559;
	bh=Vj+UM1PUbAyWA4D+j1G8p5ZqPPrnPv+tMlVz9ALrd/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZOjlwqkIZJIscka8G7NnZ8TZaBF+2DwKaV1xlPT+kD0awl4TJWYn9E0q/qViDRJX
	 n+pL5xrCRIVoPsxAF/O0g408dO/cBkXmsBd1cb+9vPiiJv2yE/BYQbsQZQ/nxDU5MA
	 d5pr8/EIykmMcH+YFTGnNki5lj91oSrI2VSw3X6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/589] arm64: dts: imx8mq-librem5: Dont mark buck3 as always on
Date: Sat, 30 May 2026 17:59:55 +0200
Message-ID: <20260530160227.753209120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 99e71c029213d3cfcc4f39a534c73d1828ffb341 ]

With the pmic driver fixed we can now shut off the regulator in the gpc.

Signed-off-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 511f76bf1dce ("arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -671,7 +671,6 @@
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
 				rohm,dvs-run-voltage = <900000>;
-				regulator-always-on;
 			};
 
 			buck4_reg: BUCK4 {


