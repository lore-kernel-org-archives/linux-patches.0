Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B8620D4E3;
	Tue, 12 Nov 2024 10:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407559; cv=none; b=Ej/qsmdv9dS/wqxlHeZKSs8uQFonyOva8pLr/BEU7FsiCWmWEFQwjTmgDvhbleBvLvADizvbvf9lDBGOdbP6CiBVekTd/6cK1wVPSDPPHJKFK9TcqZwkcIQyErTPUTXbciHhN68HM7vk0M+qBAGpR5/a7YxQKi0UB6bA2ABvYqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407559; c=relaxed/simple;
	bh=J7YIpgn2MSloPxQydLrIzOlSLJvV0CEAI4HpLYRb7Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH2cb+qIQpzTc6rw2kp8UWKavvFhl4vXnFE9izy3hdqPES+Eog5dxETvTKuXfh5Wi/6KzvCM9p1Bky8/SLw4NLuHp20iDLdbcir9kwJ6kjY+T4nldhc/J+8IK5UDLBdScrnPuBRsUaszDX/0of8n4HjO247JDvq+8j2V5MdsN40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzQNoRSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzQNoRSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29252C4CECD;
	Tue, 12 Nov 2024 10:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407559;
	bh=J7YIpgn2MSloPxQydLrIzOlSLJvV0CEAI4HpLYRb7Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzQNoRSf+xacABWdSBWoSnne5e7pJJ/dsrdS9AhNpI3f7Li3S7fEa7Ylj/66kQL2Q
	 qB4x4KOkhkiKC1KVewkQ2mvnCaRgfdR5sNR0pGw4yDNn1nI9oMYqjBPHCONorO4HMB
	 iKUTZatgtKZa+MI7XPY5bDmIUlxPnDaS64Q595sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bostandzhyan <jin@mediatomb.cc>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/119] arm64: dts: rockchip: remove num-slots property from rk3328-nanopi-r2s-plus
Date: Tue, 12 Nov 2024 11:20:21 +0100
Message-ID: <20241112101849.221447662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit b1f8d3b81d9289e171141a7120093ddefe7bd2f4 ]

num-slots was not part of the dw-mmc binding and the last slipage of
one of them seeping in from the vendor kernel was removed way back in
2017. Somehow the nanopi-r2s-plus managed to smuggle another on in the
kernel, so remove that as well.

Fixes: b8c028782922 ("arm64: dts: rockchip: Add DTS for FriendlyARM NanoPi R2S Plus")
Cc: Sergey Bostandzhyan <jin@mediatomb.cc>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-9-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
index 3093f607f282e..4b9ced67742d2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
@@ -24,7 +24,6 @@
 	disable-wp;
 	mmc-hs200-1_8v;
 	non-removable;
-	num-slots = <1>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_clk &emmc_cmd &emmc_bus8>;
 	status = "okay";
-- 
2.43.0



