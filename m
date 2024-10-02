Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D371D1E66;
	Wed,  2 Oct 2024 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879471; cv=none; b=Oo6tlgXrGd3zS+JbWjfBefUuq+U84fZuyiezXGn+40lhQgCMyXOdTKuncaS2yP5fXIuuDRhtm8Z4ojZ8mYSJ6JmwSG7BMFOoQD6sDEi85M1RzDwjKg/lMxQdt68ckNw34iCZY5Vg9w+R6W13Nc7eryIb6GKeR4iLj2ppZcTCfyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879471; c=relaxed/simple;
	bh=lGgAJyGRwJk2dYpfS/cAsLjgFA5qCvr/lWb9wT02D38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kThMivDvqJuYR9Nz+4tthuFNJShyj/g1RhnV/MTsvmjdwNG3ewiWzyRxPY0/QXRhJc5jL5PwMrQOEzq5CkijuisCYrBs6/caFsh2pyL42NEp1vba6HSvHtkaP84eoZxUOR3fhifiHum/3S0XaFoHbSCwISIhIRKiXnSPnWlk2uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdR0HAu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdR0HAu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D855C4CEC2;
	Wed,  2 Oct 2024 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879471;
	bh=lGgAJyGRwJk2dYpfS/cAsLjgFA5qCvr/lWb9wT02D38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdR0HAu4S5LFIno1RH1yyyFzHbi9apgPZFUEZ2xZ1IuYHl8TqG4pgUOYDBJJbpvvQ
	 vTDTFBulItTXSk0WqqdeBHolURGYppH8urBJ4Pu/akCIEU1ntzk7vUGFsN4vI6GfFW
	 eLwxNKljcAeX1YlRwc3zYPbYEtaYUjvlNnSn2yos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/538] arm64: dts: rockchip: Correct vendor prefix for Hardkernel ODROID-M1
Date: Wed,  2 Oct 2024 14:55:38 +0200
Message-ID: <20241002125756.138819845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 735065e774dcfc62e38df01a535862138b6c92ed ]

The vendor prefix for Hardkernel ODROID-M1 is incorrectly listed as
rockchip. Use the proper hardkernel vendor prefix for this board, while
at it also drop the redundant soc prefix.

Fixes: fd3583267703 ("arm64: dts: rockchip: Add Hardkernel ODROID-M1 board")
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240827211825.1419820-3-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
index a337f547caf53..6a02db4f073f2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
@@ -13,7 +13,7 @@
 
 / {
 	model = "Hardkernel ODROID-M1";
-	compatible = "rockchip,rk3568-odroid-m1", "rockchip,rk3568";
+	compatible = "hardkernel,odroid-m1", "rockchip,rk3568";
 
 	aliases {
 		ethernet0 = &gmac0;
-- 
2.43.0



