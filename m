Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5464346AA6B;
	Tue, 21 Jul 2026 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648309; cv=none; b=AuC93zpvswx+t9TlpaOzg/62PjUpiZFi5mgCrW65qCw57Ld6mDlS2cMbHnK7AamzY1lPZs4rCeNIILZxtwDlstQHiVbssD8C/6QEJA4CdzGROFxtDbpDIpg+6MVt0XXKqMOpxtoAeh5uXwgiWCaoaagqfe1mQ+sCdJSJhpjQwRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648309; c=relaxed/simple;
	bh=CMVFvXeTHsYu50AHqK5Rvi/9Lou+sKBx10ch0tDzE7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFHJWjbRz4tiixMBFo6axTQy/hVF8A0OE6AAL4rkg3ZD0raxIqR5WL2khA9SMyOHfo0caMjd9cNaECM7AVb9nsxDFh0JygUirsh7TwooyB2wQV2DmQBvsN0cgHgz5GZavFtWGnxzONAtWl2wWXQBLLyQSamVNqBGsJk8fvQ7LeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prU7vxVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prU7vxVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33541F00A3A;
	Tue, 21 Jul 2026 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648307;
	bh=hzVxjDQzdNx3XhgUiO8ep5q/0PNQCqerE3BgIAnO12Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prU7vxVmRNYDV4n2nOcH/smafi61GEepHTOysZ3XHP1X3b5L+IWE9cXfhPiRWxGPx
	 hVUwIy89HSfafSZeSW8ZRxtlQwXXsf6jOBsrgwcNTBcxYh9lTbpd/9O7svsKRLl6Sw
	 tU/LbOctFQsAkxUjcTCyU7AgGbXbcjJFRR2vhUKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weixin Guo <2298701336@qq.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0150/2077] arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc
Date: Tue, 21 Jul 2026 16:57:03 +0200
Message-ID: <20260721152556.223970190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e499064e03579..985770e3a5e2cc 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -245,7 +245,7 @@ rk809: pmic@20 {
 		compatible = "rockchip,rk809";
 		reg = <0x20>;
 		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PA7 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <RK_PA3 IRQ_TYPE_LEVEL_LOW>;
 		clock-output-names = "rk808-clkout1", "rk808-clkout2";
 		assigned-clocks = <&cru I2S1_MCLKOUT_TX>;
 		assigned-clock-parents = <&cru CLK_I2S1_8CH_TX>;
-- 
2.53.0



