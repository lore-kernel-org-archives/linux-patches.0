Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8D8BEB
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3094C433D2;
	Tue, 28 Mar 2023 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015966;
	bh=S9q6BGzNgYHWv+j9A33RmWNmCLCSlwrpcA8uIXi69p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnGZdffqF/gQ8GSE+qgcurmuT16gyFoda2KeqR0RkW/Uh9v6+rgASNh1d3da3ksx5
	 bFISzjXM8sRm37Hu+/5VCKsw/EpWX5wbbKbS2lnSzMFYNctsJChvDRnS7lvFPcS4Cz
	 9KtNFULw5MPJNLy3i0w828xb2XlfI4A4rorfbxGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/146] ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl
Date: Tue, 28 Mar 2023 16:41:46 +0200
Message-Id: <20230328142603.448703896@linuxfoundation.org>
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

[ Upstream commit 957c04e9784c7c757e8cc293d7fb2a60cdf461b6 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: c100ea86e6ab ("ARM: dts: add Netronix E60K02 board common file")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/e60k02.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/e60k02.dtsi b/arch/arm/boot/dts/e60k02.dtsi
index cfb239d5186ac..54b4de6a5925d 100644
--- a/arch/arm/boot/dts/e60k02.dtsi
+++ b/arch/arm/boot/dts/e60k02.dtsi
@@ -302,6 +302,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



