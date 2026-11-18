Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054619;
	b=WIOSh5yYLpYsymHf/MgG6QiR55ETTgoiVHHR6Nz49A74VNvBl42EpldFM5Uya0YHqYXW
	 v1uxIIf6GA1tUhpHOu/xij/rSOnEowf1e5x3EmK9Mcw1OCSVz8XM2L73Cihuq9T6NsiBw
	 xMmvqNFlnDkLN/zHF6L8H241nfsrYEAl/WJAmKpLfgvP+eJas74O7r+gVw5swUqpduabU
	 HPf8CAEVQJsbGl9LgvJR8W2IOcChCOhUDBdmcStsF7+O0FkFWqPxiEwzhBrdzwNmH7jt8
	 uPN/iSm5UiO8cHSsQOJSdJwMazSlNKVcK9GOLyLtAQNubLbcWukXjIbe2ET6NOlFJBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DpneocGsfusG+6OZacQgJTFNhw8dHEvCjtWqCt8GNy0=;
	b=DD1R7KpKy8QiYqLBMoq1MjSNv+Ag7Z32tDwbA+VnvY8PZ1ypAnxI4iH8kBz8d+ZnAuke
	 gmNQTTLtxghfXunckxYW5SSzlgD0eQtKBM+9gflFSCBKO9uLMkucOw0WwP0n2ZftAutMc
	 2h6BC/J3w4JkeLO9TCOzs32Q4tPAMqMGhpPvFtoED6eEeB2C2A1tfJdeWwT3714XhUZMm
	 is7l/HiqDDbOGl/4cV4YnmuStZCHyu2nKSEJJV7oeuxlOLIcH9NKeqPUgpCJXh3a4tqib
	 Tv9hwhWSMuCZiwgitaHb2pIxJ4NNXDRWl7QIjDQYZlS25QYzgS1OAVRg73DjVEoo/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNGjqFAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0847606A32F;
	Thu, 19 Nov 2026 02:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNGjqFAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EAF1F000C5;
	Thu, 19 Nov 2026 02:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054618;
	bh=DpneocGsfusG+6OZacQgJTFNhw8dHEvCjtWqCt8GNy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNGjqFAf6mEeLEW/Pw+swrK/5wQyUt6x20L1eqDYJ1Ka11x23JPSJsQx+/jiZm5MJ
	 /CXnN5DtR2EPQyeq6ngT0b7lVnyK73Y1unAGYQF4bAXdTawRng7MzAI+Yc6m9h0JhG
	 hyJuO4OXiwmSY0g42iRAqIJohd2U1kAt5Ox7asco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1340/2214] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:50:16 +0100
Message-ID: <20261118150105.036910118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 5df4320a30a87f9bb918ace7b389026917c8d896 ]

This spi node is specified in armada-38x.dtsi with proper compatible
strings whereas they are not present here. Instead of copy and pasting
various lines, just reference the node in the dtsi.

This dts seems to predate the move of spi from internal-regs to the soc
node so this moves it in line there.

Allows proper probing of SPI at runtime.

Remove the microsom_spi1_cs_pins pinctrl group and its reference in
&spi1. The group only muxed mpp59 to the "spi1" function, but that
pin (SPI1 cs0) is already covered by spi1_pins, which selects the
same function for mpp56-59 in armada-38x.dtsi.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 1ed6ddf1719a7..33e30528bc7ca 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -254,13 +254,6 @@ sata3: sata-port@1 {
 				};
 			};
 
-			spi@10680 {
-				pinctrl-0 = <&spi1_pins
-					     &microsom_spi1_cs_pins>;
-				pinctrl-names = "default";
-				status = "okay";
-			};
-
 			sdhci@d8000 {
 				bus-width = <4>;
 				cd-gpios = <&gpio0 20 GPIO_ACTIVE_LOW>;
@@ -327,11 +320,13 @@ helios_fan2_pins: helios_fan2_pins {
 					marvell,pins = "mpp48", "mpp55";
 					marvell,function = "gpio";
 				};
-				microsom_spi1_cs_pins: spi1-cs-pins {
-					marvell,pins = "mpp59";
-					marvell,function = "spi1";
-				};
 			};
 		};
 	};
 };
+
+&spi1 {
+	pinctrl-0 = <&spi1_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.53.0



