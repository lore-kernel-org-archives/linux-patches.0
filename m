Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60446191F67;
	Wed,  3 Jul 2024 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003716; cv=none; b=ifIL3yacoBZakNatijM7sDwhL3FSgRkz4pwBpQQuEDk+M3c1R89D0fAq5wG4LmLP9q17YipPArWzWQg4SrpVFp3fREthlFPMT+FhAWTeT1/w/AtASHuS1tzu00nDG7UPxMuaje1QasbPtNyjy9vq9AYlcsbk9sXrw0BOT3yaHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003716; c=relaxed/simple;
	bh=CoKSwJvzDQ5AZ745rZsJ4UKQhPwL0O9hme30YWMyL5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV1RPRvxYjtk1sCaydV32Ab7KzIfp74V/DOVX2jkDLrcfIJvR9ouo2yhS7qF42PpRSdH0RW/sxLAgJlk+Q0jsk9+lFfkpk342rUpDMhAPEb59FeSCbGhOFsiJwxorTGUkzVaGIre94SFnwP98e0a84RUCmwKL5DHkWhKKIFKI0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgP2b3Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgP2b3Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70D0C2BD10;
	Wed,  3 Jul 2024 10:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003716;
	bh=CoKSwJvzDQ5AZ745rZsJ4UKQhPwL0O9hme30YWMyL5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgP2b3CgJSAZylzeA7hYGqhRHHFeo5B8MWoV0fwSoCykIYk5wKk05b9k6qgC7EcLB
	 2mrf4gwBz2EmjTTftKIRycV4784WNbd0aQQmrh7CUmMcZ0O0ZkNsyQt2raiXt05i9C
	 Ia2RfUvr1S5E9T0FcNS/l60KgzeWaCdfFfKAlNCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/139] arm64: dts: rockchip: Add sound-dai-cells for RK3368
Date: Wed,  3 Jul 2024 12:40:36 +0200
Message-ID: <20240703102835.684070336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9c24de1ba43c5..16aec16725c57 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
@@ -677,6 +677,7 @@
 		dma-names = "tx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&spdif_tx>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -688,6 +689,7 @@
 		clocks = <&cru SCLK_I2S_2CH>, <&cru HCLK_I2S_2CH>;
 		dmas = <&dmac_bus 6>, <&dmac_bus 7>;
 		dma-names = "tx", "rx";
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -701,6 +703,7 @@
 		dma-names = "tx", "rx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2s_8ch_bus>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



