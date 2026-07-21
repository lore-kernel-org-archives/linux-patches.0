Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B044AB6D;
	Tue, 21 Jul 2026 21:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668751; cv=none; b=XWZzWWYDsbu2h+L4hoL2Nnh9dCkfiJ604v8XFWkjodKS2IW+0K48cUBg090w9+bqd5+g322KwZHv/PK5hCNOWvPCy4WwgUp+QMkjaKRvJ+PPxDp4QZ4ONJSI4cIgLHXEGlnatS6XFxa4bruKIs7h5fgskyqoP9h9qYUeCaaHf1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668751; c=relaxed/simple;
	bh=XEHd2f9ANo9HWml93TOgkI9DXKISVak/Lo+/6XA584A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfTCBnCIUI2P9enkygx6AQK/CkKaxwwpz8TQ51dUQ4XifzhyLtK+c6KXF/iSc4235m41q6IlMgOwhkMBwDngOKf+H4vhbOJA+RJn5uVUm7vGIdmYzP+2B8tZLXlr2lUJ4ohD4UrJ1KgBjgcbJkp3hhBmwl+PmA1VZjEGfCtbGJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwW2JW8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwW2JW8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4D81F000E9;
	Tue, 21 Jul 2026 21:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668749;
	bh=OseQ3Z0EDCN1hvXveN5k85l/bg7J+P/dwxiFeiYzsKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwW2JW8E28aKUU5cNT4N0Hid3rCL4tRN8Tv15eEygaxtOFcOTZnL9dBPhAwdd3FA7
	 mgS1hNRGNyp15BdnmPSIe1ShfK1T3poVjNx2ONkNN2zaJmNIu5yuCBrw3WD7HBQotI
	 DaDYAKRWKMY0jh+WQA2WnAyLSKzku045m8fLC5rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weixin Guo <2298701336@qq.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0295/1067] arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc
Date: Tue, 21 Jul 2026 17:14:56 +0200
Message-ID: <20260721152431.201202789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weixin Guo <2298701336@qq.com>

[ Upstream commit 460bac478c5fe69054ffc60d607bba03bcaf909b ]

The RK809 PMIC interrupt pin on the Firefly ROC-RK3566-PC (Station M2)
is physically connected to GPIO0_A3 (RK_PA3) according to the board's
schematic.

Currently, the PMIC node incorrectly specifies RK_PA7 for the interrupt,
which prevents the PMIC from correctly signaling interrupts. (Note that
the pinctrl node 'pmic_int' correctly configures RK_PA3).

Fix this by updating the interrupts property to use RK_PA3.

Fixes: 30ac9b4e25d8 ("arm64: dts: rockchip: add dts for Firefly Station M2 rk3566")
Signed-off-by: Weixin Guo <2298701336@qq.com>
Link: https://patch.msgid.link/tencent_5035EEE630C845B1B51DEA4284DE23DCCE06@qq.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 9fd262334d77da..fcc6bbf5696f45 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -208,7 +208,7 @@ rk809: pmic@20 {
 		compatible = "rockchip,rk809";
 		reg = <0x20>;
 		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PA7 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <RK_PA3 IRQ_TYPE_LEVEL_LOW>;
 		clock-output-names = "rk808-clkout1", "rk808-clkout2";
 
 		pinctrl-names = "default";
-- 
2.53.0



