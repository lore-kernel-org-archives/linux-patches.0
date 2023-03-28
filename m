Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF5D8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3402EC433D2;
	Tue, 28 Mar 2023 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014705;
	bh=xP7nSp9eV98Qnkf7CTqbpoDHS4UhTgVPbD/j/d5lWv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bks5ymhOi/psulZNZHikuHYFlYz3fA7LtBiW2qckBOisIRdL66JjRav5v5ebZ/cCx
	 1NnIfCjQIjBfVsXicT0Fg1p0ITvsZI+l/qa10yHPttofWenSr8bCfGmqC9LlqLqnOh
	 sjfID8eqf2Q/QF7w4wH/wMkioD14OmUnVPuQZHm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 022/240] ARM: dts: imx6sll: e70k02: fix usbotg1 pinctrl
Date: Tue, 28 Mar 2023 16:39:45 +0200
Message-Id: <20230328142620.581941463@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

[ Upstream commit 3d37f7685d525e58674c23d607020e66d501dcd1 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 3bb3fd856505 ("ARM: dts: add Netronix E70K02 board common file")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/e70k02.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/e70k02.dtsi b/arch/arm/boot/dts/e70k02.dtsi
index 27ef9a62b23cf..a1f9fbd6004aa 100644
--- a/arch/arm/boot/dts/e70k02.dtsi
+++ b/arch/arm/boot/dts/e70k02.dtsi
@@ -312,6 +312,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



