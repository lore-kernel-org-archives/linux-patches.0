Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2044C1D7E5C;
	Tue, 21 Jul 2026 20:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665651; cv=none; b=uwlQ0MhyWnyoubGbEP8WifL559nuOd6J+bdV3ZxxeYTmnOKcIR/MnuF/IN25GLkDYbi94es4bULQc5lHwqYofqAV337kBHJ/PnDfmwSHWQUrH+irHap3pz5JNJ4Z5kRrn2F18uS1h7KsA6k80iKUR9wmlJq6sS62CjihpNo8JLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665651; c=relaxed/simple;
	bh=SNIs5TKoOljNNiy8LJNat0mm+tT+DOtLvB13d6Qlc+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imAypmO6h8nrJRel2hK4X+C5TzwLVZ9Te6FFslo7+rR4qMCI9YLCh3FJ+eopKtQHSSchk0YZVBlOnpwAlCJVLtJjBbN7RkS0MuIYTm+JxoK4G/0udwmexMg+UJhh90sQfQpFR9f+g0FCNKnabx8Y0LYE69wBkfE7xNWPxvr9f2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMMqSSXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMMqSSXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F65C1F000E9;
	Tue, 21 Jul 2026 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665649;
	bh=ZqIexj0yJwzekYQtiILPfe4De7jzdEQr7vSwUKwp3/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMMqSSXcxXx1Czs5uyDPifirvwAb0NJPiuMP/LaxBfTW1ObxFXtgb6SeZEKLQLBSA
	 rBNequ+RQykb0Dt9TxgQFvWQy6cq1j4mQIF3I8kAxfIS5PVz+OAkk8coTVRpWGVJHc
	 y53/PZqyR2FQNvIZcdvrSNkZrn67JXCEAIWEsv6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weixin Guo <2298701336@qq.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0384/1266] arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc
Date: Tue, 21 Jul 2026 17:13:41 +0200
Message-ID: <20260721152450.417747215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68a72ac24cd4b4..5d0bcabc51964c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -244,7 +244,7 @@ rk809: pmic@20 {
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



