Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AD9207E14;
	Tue,  8 Apr 2025 11:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110770; cv=none; b=PCKvPyhK2ilryYNHXa38gW4qEQtOwP37Yd127Oq6yRCjHyguUs8352rcu3ruViC6Z4w93jCYIUE6vfNyqVbvjsLm1uVJKqR3hZpcuCsRL6oL63k26pDqIft8WOfNIEMoqRMH5TtwUTVf6bNPkabW1mQ5SbXOYJo7Q2UCCo2wq9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110770; c=relaxed/simple;
	bh=62sEO7Z8rY90xl/oI6zm1hpujNZnm/92002ILx1LQ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPWwvvOjjmjHCMzvV0KAFSj08tlCWOKrq0SaVnSP0Ygxg4wh/488ubMA1wfVk5ydHZnwWiFFW7Rf7BiXEKfc77gipatOIqBKpm9k66V72iFWVg6umHH5TDkBGpBOEqAcb8lRtDalPwz5eBA4ns+uD49llyFNuOO74wkzWNRZb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrXewGTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrXewGTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57165C4CEE5;
	Tue,  8 Apr 2025 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110769;
	bh=62sEO7Z8rY90xl/oI6zm1hpujNZnm/92002ILx1LQ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrXewGTH6v6jQGJfF5bHPU6WaNe5q3JNW8hATR6OUV0Mi0hmgyRn2XUGOyqvG06B0
	 jb2fbcVS98hDJWxqhAF4Z4NFeVVU2TzEwlfo6MkegRg9NsZFT7ALNpRQKNPIo4hRt6
	 VDi9QvU5K88XR1+pWObXdQWIkBV2qB2xChVn9mlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Jimmy Hon <honyuenkwun@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 187/731] arm64: dts: rockchip: Fix pcie reset gpio on Orange Pi 5 Max
Date: Tue,  8 Apr 2025 12:41:24 +0200
Message-ID: <20250408104918.627360095@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianfeng Liu <liujianfeng1994@gmail.com>

[ Upstream commit e0945a08fc7f7ed26c8dae286a3d30a68ad37d50 ]

According to the schematic, pcie reset gpio is GPIO3_D4,
not GPIO4_D4.

Fixes: c600d252dc52 ("arm64: dts: rockchip: Add Orange Pi 5 Max board")
Signed-off-by: Jianfeng Liu <liujianfeng1994@gmail.com>
Reviewed-by: Jimmy Hon <honyuenkwun@gmail.com>
Link: https://lore.kernel.org/r/20250311141245.2719796-1-liujianfeng1994@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-compact.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-compact.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-compact.dtsi
index 87090cb98020b..bcf3cf704a00e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-compact.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-compact.dtsi
@@ -73,7 +73,7 @@
 
 /* phy2 */
 &pcie2x1l1 {
-	reset-gpios = <&gpio4 RK_PD4 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&gpio3 RK_PD4 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc3v3_pcie_eth>;
 	status = "okay";
 };
-- 
2.39.5



