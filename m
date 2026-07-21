Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E66646AA60;
	Tue, 21 Jul 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648120; cv=none; b=cKfgMMIW1rR02HtmnwAfZ5zyAuApkScl9Pe5wmcKIoYGgWJfwLciMemoSWIBVl+U/nPGWpH17aLAmFIRKWZ+xgItrGNugjcEYOiuAzG912tTf+PyTc2kZ61sTiQTRAsDhcQK0xZe4PvMoXWumiCU0kqSfdE2BEoOU+mTbDvpKos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648120; c=relaxed/simple;
	bh=BgyQxV2rkv+Rf/x0nTNev9Uyuy5bh2gT61yDPsQXQqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh2wHHMLiAhhIxOSR7J8bCzjn4L4HecNCGBHmV2sjiYTm173GzP+1WQIlIMDwhs11rz7PjRgNINqQsX/cSRBnh1ftMYJLAM+09E1BBkqtpit7ANvWSm5ucz07ssG9sFMEV9BTdfNkPGAv3UQGgy3Pg709lo/ZknPMnlHc1QNkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9UF49HQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9UF49HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575B31F000E9;
	Tue, 21 Jul 2026 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648118;
	bh=okGVN/0PTE3uOkLIYbMORkay35hLJS0FFw9MYUPjT+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9UF49HQC2Z77VvqFg8+emaqhGVtA2C1GRTIlnXie2JbDoN3XyX+8zNavq/g9P09f
	 1IKyuZTx1xW7slW+lHjLBL+pupkMe12brdIsP7ukbcUJhjU9EjHsjChogbhE/0WvYy
	 EY7QATXlVUf3Jnt18btrkb8u424YhjwTsrCjQSRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0077/2077] arm64: dts: rockchip: fix Ethernet PHY not found on PX30 Cobra
Date: Tue, 21 Jul 2026 16:55:50 +0200
Message-ID: <20260721152554.509380649@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit 6598ed3586a4b1cc79423666e66b9861631a6c7e ]

When not passing the PHY ID with an ethernet-phy-idX.Y compatible
property, the MDIO bus will attempt to auto-detect the PHY by reading
its registers and then probing the appropriate driver. For this to work,
the PHY needs to be in a working state.

Unfortunately, the net subsystem doesn't control the PHY reset GPIO when
attempting to auto-detect the PHY. This means the PHY needs to be in a
working state when entering the Linux kernel. This historically has been
the case for this device, but only because the bootloader was taking
care of initializing the Ethernet controller even when not using it.
We're attempting to support the removal of the network stack in the
bootloader, which means the Linux kernel will be entered with the PHY
still in reset and now Ethernet doesn't work anymore.

The devices in the field only ever had a TI DP83825, so let's simply
bypass the auto-detection mechanism entirely by passing the appropriate
PHY IDs via the compatible.

Fixes: bb510ddc9d3e ("arm64: dts: rockchip: add px30-cobra base dtsi and board variants")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260421-px30-eth-phy-v2-1-68c375b120fd@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-cobra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
index b7e669d8ba4d14..add917af5de783 100644
--- a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
@@ -397,7 +397,7 @@ &io_domains {
 
 &mdio {
 	dp83825: ethernet-phy@0 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+		compatible = "ethernet-phy-id2000.a140";
 		reg = <0x0>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&phy_rst>;
-- 
2.53.0



