Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5119819CCEC;
	Tue, 22 Jul 2025 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192871; cv=none; b=F19JZRn2KZEWe/Ru7wRDSYx8RYECaajD15gVZ/D0AMbOP+xvAdWM/pq+IBZ6J2cXBFJqDVwoZy54FzN5Dog3yqpq9Y2pPtqpp2AkCKgAEMzBmIUcgwN/1EKeGNkjjWwdYYa+YjT0t0UlaxnZ9yCW98WvgxYjIQ6swKiwH1s2Wpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192871; c=relaxed/simple;
	bh=YYr6KWUnKJ2qZSKoESIr/vPrqfBhs13cgz04Y6ewImo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCaGWOVcLWDhu5d7eLwJilvbVNFKcE25iWqeKyv7DkjV14CLxM3dNZVcWX6obJ5NyDkr3rRxZEGTkpJequNogCqToOGUIqMzy9wwaSy4N0Q+e8ovbGaTuvOI4CKLouEiDunGN4nEMTqadkjvbiFb2gtZ3B7uy5rSmvPR1BMIlCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfQw57Be; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfQw57Be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEBCC4CEEB;
	Tue, 22 Jul 2025 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192871;
	bh=YYr6KWUnKJ2qZSKoESIr/vPrqfBhs13cgz04Y6ewImo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfQw57Bes3yA+aVxpImHdlRsLMlYEYiGuWfTkraMeFWpo983ShK5UDdu2VpToBGUb
	 hbgosrRM7v2vVQXtvQ7+cVr+MHXY4TG6gnWBWB/asZ9KDlg0jDWbaixIAzZRpB8A5h
	 eFSHHJoPfVyy9Mp6inuIXeEod5+7E2rNdwE9WlDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/158] arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi 4B
Date: Tue, 22 Jul 2025 15:44:27 +0200
Message-ID: <20250722134343.870796914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 98570e8cb8b0c0893810f285b4a3b1a3ab81a556 ]

cd-gpios is used for sdcard detects for sdmmc.

Fixes: 3f5d336d64d6 ("arm64: dts: rockchip: Add support for rk3588s based board Cool Pi 4B")
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20250524064223.5741-2-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
index 074c316a9a694..9713f05f92e9c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
@@ -438,6 +438,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
-- 
2.39.5



