Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E730C373;
	Wed, 28 Jan 2026 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615119; cv=none; b=IuK+LktMpcMckuRKTyAly6DO5evuhuCZlcRfSN8u7uqc5bV5s6ifLk3Cuw4GKBc88e7eQCseqIu6RPdU2lQSt78nFVInWLpDWkcetAmO7bJx3XAYGdCqJPF7tfDc3GBUpxQakQftWqWh/cjgk6wBOx1l8AdkzLwNRWQvfD4AWYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615119; c=relaxed/simple;
	bh=XBLZZj/r43MYR/zhwOIRE843S8+zGU6msDf2Kv8BHIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9iIG/gLrud/k25cvz/DBVlfwy2toobYO5rT62gamb9JfnbcZgclGqNdsFGOyTurYco32ferdchOAFEARA7FVny4V+MgJ9O8WkFLgl6xDKOnmdWXIlBsISezgdIrUyf4dokYmAp2b4e127DA4cfX1gsSBGHR/cfHx410XqqU65M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvklVon2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvklVon2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293E6C4CEF1;
	Wed, 28 Jan 2026 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615119;
	bh=XBLZZj/r43MYR/zhwOIRE843S8+zGU6msDf2Kv8BHIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvklVon2ilXXLNsAnc0ClJWu4mjrCwe9P5mD0GYCPJaKcJScQJwrze9dxqkxeGFhc
	 k77ZxJfIq4MkFoYr5Z5xmNYr0rLTSqsvgm/iyd8MtU2IW66Vvyo6Y2XTAL29m8qNZ3
	 oDbam3Tl0umvbDUV/cWWoE13nPyvRrCDSkplGd1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 052/169] arm64: dts: rockchip: remove dangerous max-link-speed from helios64
Date: Wed, 28 Jan 2026 16:22:15 +0100
Message-ID: <20260128145335.887889658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geraldo Nascimento <geraldogabriel@gmail.com>

commit 0368e4afcf20f377c81fa77b1c7d0dee4a625a44 upstream.

Shawn Lin from Rockchip strongly discourages attempts to use their
RK3399 PCIe core at 5.0 GT/s speed, citing concerns about catastrophic
failures that may happen. Even if the odds are low, drop from last user
of this non-default property for the RK3399 platform, helios64 board
dts.

Fixes: 755fff528b1b ("arm64: dts: rockchip: add variables for pcie completion to helios64")
Link: https://lore.kernel.org/all/e8524bf8-a90c-423f-8a58-9ef05a3db1dd@rock-chips.com/
Cc: stable@vger.kernel.org
Reported-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/43bb639c120f599106fca2deee6c6599b2692c5c.1763415706.git.geraldogabriel@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts
@@ -424,7 +424,6 @@
 
 &pcie0 {
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <2>;
 	pinctrl-names = "default";
 	status = "okay";


