Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D4E8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB08C433EF;
	Tue, 28 Mar 2023 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015969;
	bh=jEd4lwlknR72hJ4HJpOPTxv9Cb4vk20t0U6zbpIMi+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNJNgamoK7ApVS8KYhoSUu/2gjFQlDZlghrmr6S7Wt42G8j3ZEBfNlxHo5Hq2c0Ij
	 FRO1/Dm4AeIfrxvT2+JQYADeQGYm0wV091vCct8UsaN+NCLSinV1S0jhF2CrsyKwvI
	 XCkS2KrlTAHhtAgYrZzx0y7QpfKyvthxmauzepJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/146] ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl
Date: Tue, 28 Mar 2023 16:41:47 +0200
Message-Id: <20230328142603.490499665@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 1cd489e1ada1cffa56bd06fd4609f5a60a985d43 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 9c7016f1ca6d ("ARM: dts: imx: add devicetree for Tolino Shine 2 HD")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
index a17b8bbbdb956..f2231cb1e32df 100644
--- a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
+++ b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
@@ -597,6 +597,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



