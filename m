Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55D71BE22B;
	Tue,  2 Jul 2024 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941209; cv=none; b=GDrKmF5s9OdXS17r83Wn+tVsuogN5lRofH5u3uyfa7vonVJ5fXPyuQEK1z10moYZqHiTg2Cj4W4l9oTz4XJc6GSJ9d+qX+lJj7Vp2+qjpfCXJIsPQl740aGRQTfSnBYhDb6nusbKVM7oJMIOtCBOMljY6030SfuvEu4DKH16U6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941209; c=relaxed/simple;
	bh=z9vV9m+wGXYyWzFwjILmTHYwu6ctHcCJ8XWhBK8AJnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/u0VYxWyEhk21NpV5/CQ9jmH0Iw0flzNoXFAK3bdvbiMfWCiDgjQRra4HJ9E5G41gt7xDdwny+ImIvZsEm6je5mvHiaC8+hq/zj3m8H1hyCjh4YAwJmibMCLGipuIwbNBCfPTNKNt13cDP2vxAz9xxlc3Y4XhBA7e2PRuxsZwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHpasERc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHpasERc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEBDC116B1;
	Tue,  2 Jul 2024 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941209;
	bh=z9vV9m+wGXYyWzFwjILmTHYwu6ctHcCJ8XWhBK8AJnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHpasERcGH7gkeT+Fu3uwZ1kinIOiSFPJJGzxCXfAQi817VX1MIlViWLbCWtbJwSd
	 aB3HNiLx1BoPg6FseefapBH1c8EBxT5CcCChS+/82vyYJFFkRybDpMMHraYrupKF5+
	 ftkISKPCFosMG2sI0S/wtpb9V6hGqTUZIB3lbqvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/163] arm64: dts: rockchip: Add sound-dai-cells for RK3368
Date: Tue,  2 Jul 2024 19:04:34 +0200
Message-ID: <20240702170239.116176918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 8d7ec44aa5d1eb94a30319074762a1740440cdc8 ]

Add the missing #sound-dai-cells for RK3368's I2S and S/PDIF controllers.

Fixes: f7d89dfe1e31 ("arm64: dts: rockchip: add i2s nodes support for RK3368 SoCs")
Fixes: 0328d68ea76d ("arm64: dts: rockchip: add rk3368 spdif node")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20240623090116.670607-4-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368.dtsi b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
index a4c5aaf1f4579..cac58ad951b2e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
@@ -790,6 +790,7 @@
 		dma-names = "tx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&spdif_tx>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -801,6 +802,7 @@
 		clocks = <&cru SCLK_I2S_2CH>, <&cru HCLK_I2S_2CH>;
 		dmas = <&dmac_bus 6>, <&dmac_bus 7>;
 		dma-names = "tx", "rx";
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -814,6 +816,7 @@
 		dma-names = "tx", "rx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2s_8ch_bus>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



