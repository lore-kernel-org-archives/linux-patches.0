Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317621744D;
	Tue, 12 Nov 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408016; cv=none; b=DJnGT0lGeDKARzNgNKWMk5vcVgvbksxYI18UoOywyJTBW6gsnCCyJIaZtTLbwePewz4mbq4bMaY6mUrnQL/GSmfH5T/9KR8wjAacLThbwQ2YVc7KNw15w6qyxgMvRoyfWzW2wP5RY8cMhhq1de4l7q3btRSedhoIPo/rIVq+V6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408016; c=relaxed/simple;
	bh=ccmC89so6d6cNW94E/YN2h/e0CO0C3ETc0eLjEDgyvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnrc7EFnGwCMjAEsMVmOgVmLk6Ew+4tQLLyuXFuvXw3VToMKzuqGOfUwZdPtWnGMtoJmLh8lEWUW74P+6mmNkcG7bqQJm0scykyDkUndOv7q+McsCj6/XberDVCqpwZP3JWTFGeMIO059nVEepaq/o9SaLadkGi+hD7oQmXOieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVldyUA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVldyUA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7337DC4CECD;
	Tue, 12 Nov 2024 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408015;
	bh=ccmC89so6d6cNW94E/YN2h/e0CO0C3ETc0eLjEDgyvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVldyUA89/HTfjytPA6SQLBc8aFzohhONZMJS2WVM5mfOu9340lxCVdGvN1nLkylf
	 PhIUYf4MXqpnuR6q86ZM/Xbj0VpNZ3JrO7MYxycbjyYqo/ORitW3NjXZXzJXerD822
	 R6JQ3TNMAPDrQpTeI95o2aBOX8RyaQiq9COCO4iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Braam <martijn@brixit.nl>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Ondrej Jirman <megi@xff.cz>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 026/184] arm64: dts: rockchip: remove orphaned pinctrl-names from pinephone pro
Date: Tue, 12 Nov 2024 11:19:44 +0100
Message-ID: <20241112101901.871917452@linuxfoundation.org>
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

[ Upstream commit 3577d5e2bc1ff78808cbe2f233ae1837ee2ce84c ]

The patch adding display support for the pinephone pro introduced two
regulators that contain pinctrl-names props but no pinctrl-assignments.

Looks like someone forgot the pinctrl settings, so remove the orphans
for now, until that changes.

Fixes: 3e987e1f22b9 ("arm64: dts: rockchip: Add internal display support to rk3399-pinephone-pro")
Cc: Martijn Braam <martijn@brixit.nl>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-11-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
index ef754ea30a940..855e0ca92270b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -167,7 +167,6 @@
 		regulator-max-microvolt = <1800000>;
 		vin-supply = <&vcc3v3_sys>;
 		gpio = <&gpio3 RK_PA5 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
 	};
 
 	/* MIPI DSI panel 2.8v supply */
@@ -179,7 +178,6 @@
 		regulator-max-microvolt = <2800000>;
 		vin-supply = <&vcc3v3_sys>;
 		gpio = <&gpio3 RK_PA1 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
 	};
 
 	vibrator {
-- 
2.43.0



