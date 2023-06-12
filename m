Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8DD134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64924C433EF;
	Mon, 12 Jun 2023 10:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566655;
	bh=p8/J1IWMB823FHy2ftLNQjQSDlMewV8lA0iChZXFhhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnlsnwWNVfd0LU2M5KQ9wd5zm7QKZWK9T5GkygLXM7wNFiua/uWq+KbmtPVRCoxZ3
	 xdbjrpkHu5iQ5n+cR7ZDqRFzcxFD/WI0Nm0XSC/BOPEvDCP7v0a4NSA8yMX8l94O87
	 FxvBlMvVopAu2SeFl9glSaDCOkDte5bHfe/iiVVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/132] arm64: dts: imx8qm-mek: correct GPIOs for USDHC2 CD and WP signals
Date: Mon, 12 Jun 2023 12:27:21 +0200
Message-ID: <20230612101715.173824288@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 2b28fc688cdff225c41cdd22857500e187453ed7 ]

The USDHC2 CD and WP sginal should be on LSIO_GPIO5.

Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index ce9d3f0b98fc0..607cd6b4e9721 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -82,8 +82,8 @@ &usdhc2 {
 	pinctrl-0 = <&pinctrl_usdhc2>;
 	bus-width = <4>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
-	cd-gpios = <&lsio_gpio4 22 GPIO_ACTIVE_LOW>;
-	wp-gpios = <&lsio_gpio4 21 GPIO_ACTIVE_HIGH>;
+	cd-gpios = <&lsio_gpio5 22 GPIO_ACTIVE_LOW>;
+	wp-gpios = <&lsio_gpio5 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
 
-- 
2.39.2



