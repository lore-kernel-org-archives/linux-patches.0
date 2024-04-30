Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4512C46D;
	Tue, 30 Apr 2024 10:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473961; cv=none; b=NQEIq4xaa8YNxeBGpaw5qfhrosgLrtmPRJ3M1f12xTFW8nsixBB9gBO/+uD/F7TfMQ1bliFoL2vASzEh5HGQHcgizIhraEXUVDO2yEbwXZwGoedQyQr5v07F4evumnZbvjXovPiVjIY2uIUN75Fo4FRMl5FbOe1pcE4VgY5wcbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473961; c=relaxed/simple;
	bh=Lb7h2LuoBIQVCUm3qi1FJkMclWIqxz++gshJLRB39no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k97+aFWCtPtUIJ6cSQHakJrHyTbloc3zEs3EZYkojPlzHPnw6rpksvW0h002UNNR/jR6HmG5t4Lcu9Jltf3T3Xy/HdQ48FOFj/1qD/ZodxcPceLr4agjJ0Z6BzC24jp2eRt9hNIqjdu2cMhwckvCOj/GGfdsJf4FvxbagmJml6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3w+ptNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3w+ptNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95049C4AF19;
	Tue, 30 Apr 2024 10:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473961;
	bh=Lb7h2LuoBIQVCUm3qi1FJkMclWIqxz++gshJLRB39no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3w+ptNLYpWjfFsPezVzRSzqFOcmUy7L7uMnfyKHO04X6fo/SGcBuvIgRyaUhfooZ
	 hs3+tF9r0w1ZEfgejDJSmrPl3FDGxsFAaEOLEuDNrADhMiOrlCEJ0iK2dtJY97LUHv
	 KRiL6DB7cNhPA8aNvJLg/0yJyKM+qSBMRoit7xYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 007/228] arm64: dts: rockchip: enable internal pull-up on Q7_USB_ID for RK3399 Puma
Date: Tue, 30 Apr 2024 12:36:25 +0200
Message-ID: <20240430103104.026412635@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit e6b1168f37e3f86d9966276c5a3fff9eb0df3e5f ]

The Q7_USB_ID has a diode used as a level-shifter, and is used as an
input pin. The SoC default for this pin is a pull-up, which is correct
but the pinconf in the introducing commit missed that, so let's fix this
oversight.

Fixes: ed2c66a95c0c ("arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-1-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index c08e69391c015..d4324e57729b5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -458,7 +458,7 @@
 	usb3 {
 		usb3_id: usb3-id {
 			rockchip,pins =
-			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 };
-- 
2.43.0



