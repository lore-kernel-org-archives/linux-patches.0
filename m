Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD2628387;
	Sun,  1 Sep 2024 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208161; cv=none; b=g9Ch0DejA7ZVAjM7Gj3YgkD1LnJ7Os9JxrpVHCEArJ98hkJ4JYgOVBEFCFraxNjT/e9LMhgLanWhSVN1iRm3CMi0gPaM4EwTZM2pPcm/XWC5FRYCdxwt6+D5yhNp9HldV6RuXhiexiWbhp8HSnDdbfbym0fJfT+Sz0h5082XkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208161; c=relaxed/simple;
	bh=LRwoZzce6rHKC2wpxir7s4yhaL+yZ9lRuPYPrJoMReE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIaVSvXnoVyWTI8b8cF/DJRiLdSr7/uR9l8p1nANhVoY8zXaCPqZaNZmGkmR2tncl6XKakmnIBJcqtHCS9K/o3zO4oKqBjJfU027XBUqWY+hy76s33E586RLIvBrwVA8ubADv1L5xx9gLgyywbQ4zpZ1x1Z03UyXNdJiNYQZEx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfSdnVl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfSdnVl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3834FC4CEC3;
	Sun,  1 Sep 2024 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208160;
	bh=LRwoZzce6rHKC2wpxir7s4yhaL+yZ9lRuPYPrJoMReE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfSdnVl6VDzkBBmPxNmGnvCxNhCbyjnfsvdaSxUbFkrsrq4CbTiHBpn0MpjQoJ73R
	 naaDV8nGf3/+kPxJypyKJWoIN8Nixk5eHBJ4U08Fd6LnxJWCOKip0b+zKaO6d+kP/c
	 cMVVKL0BO5HUr/n1qL8M2f0Wx+U1pcq031dvGGL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 91/93] arm64: dts: freescale: imx93-tqma9352-mba93xxla: fix typo
Date: Sun,  1 Sep 2024 18:17:18 +0200
Message-ID: <20240901160811.158618182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 5f0a894bfa3c26ce61deda4c52b12e8ec84d876a ]

Fix typo in assignment of SD-Card cd-gpios.

Fixes: c982ecfa7992 ("arm64: dts: freescale: add initial device tree for MBa93xxLA SBC board")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
index 3c5c67ebee5d3..aaf9685ef0fbb 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
@@ -437,7 +437,7 @@
 	pinctrl-0 = <&pinctrl_usdhc2_hs>, <&pinctrl_usdhc2_gpio>;
 	pinctrl-1 = <&pinctrl_usdhc2_uhs>, <&pinctrl_usdhc2_gpio>;
 	pinctrl-2 = <&pinctrl_usdhc2_uhs>, <&pinctrl_usdhc2_gpio>;
-	cd-gpios = <&gpio3 00 GPIO_ACTIVE_LOW>;
+	cd-gpios = <&gpio3 0 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	no-sdio;
-- 
2.43.0



