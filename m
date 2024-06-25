Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A014A087;
	Tue, 25 Jun 2024 09:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309262; cv=none; b=BfZU8PAdRaUo1hU3agRtS5Wey0ic24juAdvMl7rjJ3hX+4oU3paZvF5+zh0j/8QGDoJIVTZU+zDgN2ArlqCXJvhnhCbGRxp9/JjB1yTS8pOOaFW6gO7+zv52ImWIeh0uV41U+5z4+wvvKCcN0VJd6Cdd6A+agyjZ+fgo1UbVtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309262; c=relaxed/simple;
	bh=lvvGAzLwqJqNh7aGCpmuzEwtXEuQtutYj5D1k7+RYlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvGeS3TcYo2we9WLdUd8AmnQtaCO/jfxC52FY44KGEJvo8mBMoCcPezfG9yuat3+Oh5/lmVGut5zMA5cjz5S5f5Awn/cBiZzFE2iP7Mrk0oTuYBtgqzEBsjhaoepenIZhfQZcm5+hJB5z80S+o7V+gJj2YU9tYxfEz/YQOaQ9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSylNxtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSylNxtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D711C32781;
	Tue, 25 Jun 2024 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309262;
	bh=lvvGAzLwqJqNh7aGCpmuzEwtXEuQtutYj5D1k7+RYlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSylNxtmqPRoKN42u+/Cj+iPkOWeAFBYsYojDjgFxdRB3sSI0PjU0xjPxpySX9vHx
	 IppUztk9xYgsdRv30ARuScttgPl16EAXa92eoyZjbuXS+rvBz8i1xyWCTax99RU4yJ
	 fuNySuDWEzGsJQltl8DgXUIMP1anLoM8QG2b1d+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/192] arm64: dts: imx93-11x11-evk: Remove the no-sdio property
Date: Tue, 25 Jun 2024 11:33:11 +0200
Message-ID: <20240625085541.739376051@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit a5d400b6439ac734a5c0dbb641e26a38736abc17 ]

The usdhc2 port is connected to the microSD slot. The presence of the
'no-sdio' property prevents Wifi SDIO cards, such as CMP9010-X-EVB [1]
to be detected.

Remove the 'no-sdio' property so that SDIO cards could also work.

[1] https://www.nxp.com/products/wireless-connectivity/wi-fi-plus-bluetooth-plus-802-15-4/cmp9010-x-evb-iw416-usd-interface-evaluation-board:CMP9010-X-EVB

Fixes: e37907bd8294 ("arm64: dts: freescale: add i.MX93 11x11 EVK basic support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index cafd39130eb88..a06ca740f540c 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -168,7 +168,6 @@
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	status = "okay";
-	no-sdio;
 	no-mmc;
 };
 
-- 
2.43.0



