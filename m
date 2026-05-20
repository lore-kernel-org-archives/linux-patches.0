Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02E91CDFCA;
	Wed, 20 May 2026 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295673; cv=none; b=L+kcZGIFw63sdGBf8N4k78apEdHEPuvZeZ+gk/Sw0Ye5Ppl3a26L9Ho+ehQEuJ44wQ/WYD6grMNwUhZ8/wv+ynMF9hC3b7WUuLU4URLGJ5tax6thvUyVC/UQEOVRQt56vhIoolz9hNr8g1uulHaarmha+K15jKG9qrwNShNtKfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295673; c=relaxed/simple;
	bh=GTbVl9yyP/vv2+AMb9m4i8p3SSR06LZBxdyDMn0rB18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv37IfnYPtkW6dTw3L/jXUeu48f8ihp88i4w78N/2pTFQ9OntNf/+yQoTKTM+M+JGMlN9pmCqzdnz8RLyUUdGeQIqXvxGvRtgb0h8ptWYMNi8qOppg1E0mAzKQSGyOWRu2rwues6SskfwUaVDvE55uCP3WnlAqR5ZADtWJtLajc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVIMIvu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVIMIvu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED21A1F000E9;
	Wed, 20 May 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295671;
	bh=oVGXuN7oovL5JzchTzruDnSbprdIJaVzJ/oYI6KVJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVIMIvu+gCA/vGdoey4xjbA6F+kUa0e1jSjjBulRlB0ZL1g0vy0ONhZg9X8X/Nqvp
	 s3z8gBpBVylUezXN5EVyUy675paMdHLAySIiICZx7VVx9qEsPrF2jdUNxLxqFAryU9
	 suvseeV4zgLO4UMrYNkxhf4qPBXy4gUO4XVZv5bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0507/1146] arm64: dts: rockchip: Add mphy reset to ufshc node
Date: Wed, 20 May 2026 18:12:37 +0200
Message-ID: <20260520162159.662719628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 792c42da47fa199f90492784e3c57280acd57f22 ]

The mphy reset signal is used to reset the physical adapter. Resetting
other components while leaving the mphy unreset may occasionally prevent
the UFS controller from successfully linking up with the device.

This addresses an intermittent hardware bug where the UFS link fails to
establish under specific timing conditions with certain chips. While
difficult to reproduce initially, this issue was consistently observed in
downstream testing and requires explicit mphy reset control for full
stability.

Fixes: c75e5e010fef ("scsi: arm64: dts: rockchip: Add UFS support for RK3576 SoC")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1773277913-29580-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index 49ccdf12ef7eb..8149e2bbde79a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1868,8 +1868,9 @@ ufshc: ufshc@2a2d0000 {
 			pinctrl-0 = <&ufs_refclk &ufs_rstgpio>;
 			pinctrl-names = "default";
 			resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>,
-				 <&cru SRST_A_UFS>, <&cru SRST_P_UFS_GRF>;
-			reset-names = "biu", "sys", "ufs", "grf";
+				 <&cru SRST_A_UFS>, <&cru SRST_P_UFS_GRF>,
+				 <&cru SRST_MPHY_INIT>;
+			reset-names = "biu", "sys", "ufs", "grf", "mphy";
 			reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_LOW>;
 			status = "disabled";
 		};
-- 
2.53.0



