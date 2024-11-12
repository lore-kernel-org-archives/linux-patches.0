Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5329B22EE70;
	Tue, 12 Nov 2024 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407967; cv=none; b=mTi6N07kmn6LSHEeScJfGjFMF5HR7FmPggJyWV2ZkFf9Ip4nU+5bLqJ7QdCseEaDPVCI93bCdQknqhMSGLBR5zna2OgAiayQpBzyWNxx8WldfLzoRV9toD8zzwez8IHrUmxpo0KuwRc8yzx/Gjnj9CvoF3b9fqCsflNzbYSJUJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407967; c=relaxed/simple;
	bh=sE0riKMpkD6jAtws+Py/DLDmNDaIYbbOi9PDV58L4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2ae5/XjmXT9vFxEyqpGQkGdDtbzVeUGPGfPwSCtpD0TiPyVDiJNFNJvLvxkiywDcePauM3HXcdz1j6+lJo7BtY8cmtN3oEME3Kl/RwHnT8OyL8JqfIUoL3ZIQJB+8PAoEIlzPkdq8DGbfmP77GiVJmSOJk2yqQ6A+6WAWJZg7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajQM3bAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajQM3bAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF1DC4CECD;
	Tue, 12 Nov 2024 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407967;
	bh=sE0riKMpkD6jAtws+Py/DLDmNDaIYbbOi9PDV58L4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajQM3bAw2aAiKsA16Y3HgqqFjvoy7tuO5qGHxeD2h+OaXv876xrW/mcS720n28v/F
	 9mDH91uQfXxM8l0XNn5Uxiw/g2f2+lwpGFsB2t78fqwCYLbz4ja1y9OJsYODFaVEzy
	 cdQBKw7F4eg2zAGUMCtGOySCAoE9P9VO9gUvMqOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bostandzhyan <jin@mediatomb.cc>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/184] arm64: dts: rockchip: remove num-slots property from rk3328-nanopi-r2s-plus
Date: Tue, 12 Nov 2024 11:19:37 +0100
Message-ID: <20241112101901.607504978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



