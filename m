Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D728853A;
	Wed,  4 Feb 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217825; cv=none; b=Y4iD79p1k5GZmj24o99g9Tm5LIfEtlpPc2g0RgNjIdPPALrCGYYOBnlxrrbFpyVmFs7SfmljZ8zqsvJvrNx3+1GN61wuLfz5sxzkqSdgErvP2H8FMTsFG4NE3mkBCknB5/zdnZ8WxuzZJwC6pAZ+3Gy+5yqFsxOOiMC1NKfcQHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217825; c=relaxed/simple;
	bh=mknn42S5slKzscwMF37v9BGDbDhF+3okKwyacmNJHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnCS0tch+DzN1/X93IewMjRSGXVpmfFpePy9Sq0OzpDMi7nXqn0w35be8B9+cly5Knz/un/vzIkZtMC8z6xCyq4GN617oNqWzirZtkAH6E9t81rP0gRkm7K5Au9eYtQzp8GYF+9kzoVTnfKKzpJBp17xoxvThCdTi7GlghtyvA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXDQwTqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXDQwTqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972C1C4CEF7;
	Wed,  4 Feb 2026 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217825;
	bh=mknn42S5slKzscwMF37v9BGDbDhF+3okKwyacmNJHt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXDQwTqCZpUTponxFTQrhtBf1r9R2oKdkwPS/ndfkj07Gveqr9c7MK6+mRyeP0R6w
	 I/9bzmrb7njX1vyTtjoFVpqVUsD/Q4pu1iHDLCeXlcOLSKoUcMhTijZvp3wA5yt2T1
	 1r2qGdzewn9NIkaiCpiKz9+4BAbHqWdncQM//HQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 123/280] arm64: dts: rockchip: remove dangerous max-link-speed from helios64
Date: Wed,  4 Feb 2026 15:38:17 +0100
Message-ID: <20260204143914.061377761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -427,7 +427,6 @@
 
 &pcie0 {
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <2>;
 	pinctrl-names = "default";
 	status = "okay";


