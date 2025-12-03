Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6568E255F2D;
	Wed,  3 Dec 2025 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780826; cv=none; b=QVGPcGXnb9S29qel3sZ/xULuIxZGNpO8C4HgSLLYQU37UMnx7OF20UIqcHW2w8gjKRSdujmIZqehtTrCftUvbDsTzEc+17ySAJfIObRqw2Eelu8ugqPdcc8dKCyspia/xLU/FIf5MxHXEBuf333Q4IE/uGIN9sKjp1X/7v6rkzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780826; c=relaxed/simple;
	bh=8APOHNfaa1KZAJekPXjoQvS6ferYjyAlC3fhoOCluEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJbnpkAYT5c3QX6jCguc9kG5n6hEkxy8PenhfmrvW5ubNUX5i9+cyk4gByEGI5hcsnLulUZ67sj27WSgXjNNXB1PIBKAC/knaltWcpLP+uwjqahPmmMOwWYoz9u8VUUuxebkt7Bk9y4hXSXw1HW5FT2KU+cQyZthUGp+Y3LYH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgFhxOsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgFhxOsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90FFC4CEF5;
	Wed,  3 Dec 2025 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780826;
	bh=8APOHNfaa1KZAJekPXjoQvS6ferYjyAlC3fhoOCluEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgFhxOsQyQCILirM0pRgU+oWmCGjgEf4mmHiHs4iGJwZ8ZK4SHnJxMytXU3Pp6ukb
	 7cdKetOJxun2YNJw321G60VKSRQFdCsUChaqFaMElC4DQxRP0cankxwHuNuRnBqd5+
	 qHUMFUMGU+0HzDxXm+wiK9K5S/SkZJOfaD+5Gkic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 068/132] arm64: dts: imx8qm-mek: fix mux-controller select/enable-gpios polarity
Date: Wed,  3 Dec 2025 16:29:07 +0100
Message-ID: <20251203152345.816488367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit e89ee35567d3d465ef0715953170be72f5ef1d4c upstream.

According to the board design, set SEL to high means flipped
connection (TX2/RX2). And the TCPM will output logical 1 if it needs
flipped connection. So switch to active high for select-gpios.
The EN pin on mux chip is low active, so switch to active low for
enable-gpios too.

Fixes: b237975b2cd5 ("arm64: dts: imx8qm-mek: add usb 3.0 and related type C nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -114,8 +114,8 @@
 		compatible = "nxp,cbdtu02043", "gpio-sbu-mux";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec_mux>;
-		select-gpios = <&lsio_gpio4 6 GPIO_ACTIVE_LOW>;
-		enable-gpios = <&lsio_gpio4 19 GPIO_ACTIVE_HIGH>;
+		select-gpios = <&lsio_gpio4 6 GPIO_ACTIVE_HIGH>;
+		enable-gpios = <&lsio_gpio4 19 GPIO_ACTIVE_LOW>;
 		orientation-switch;
 
 		port {


