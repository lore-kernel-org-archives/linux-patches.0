Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA4D23F413;
	Tue, 22 Jul 2025 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193462; cv=none; b=Q7mCH2SXD1jR05KOSCF9mw19mhDktrFMb8Z/294/2n52u1egLWt9wjtGlJGHiFl84D3CKyHsWwYVwuiYWlgIgza29Oh5gtS6uOktf26UOoxYLVWQdIgCFyhFFkZ54Lk4MrpCl/Z0JuzDP/8BSLptUZwdAuVygHty2HmIhya1fa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193462; c=relaxed/simple;
	bh=uv8bJP0XsEMEU8UULekS0tQJrmyBwVKB3gv+FwBfl4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L31rgw2ttgLTdBXGC1r+Uv0uDSwkESuO0mTt3h37ZMkaj9wtiSOU/hzZYiWZ0XnwFiuZQm+r5PeF68jglpUTxf6/CzdC3DnueIi76VBT8D9P7Q4XzPhGV0sdj2D96Y2W/PSvYHe7hZqDSCyA9JsOtbFq5NeUt0BFRx6EC3349dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA21D+N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA21D+N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A18CC4CEEB;
	Tue, 22 Jul 2025 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193461;
	bh=uv8bJP0XsEMEU8UULekS0tQJrmyBwVKB3gv+FwBfl4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA21D+N5Q2iLzI1WllB/lZDZaLiCo26TFrfcCuGqK9i22upMlqS6Lvu7G9nifwnu3
	 mCyFgjHSCiiSGmEV5FZDzt+2iJkVcsdfqP7y3XFmUFg5o5oox86sK15ALCx6bCcF2c
	 kvZCtVQMy61JELzcTi85NHlc1K7kvBeZOR/YeHFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 098/187] arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi 4B
Date: Tue, 22 Jul 2025 15:44:28 +0200
Message-ID: <20250722134349.430490924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b717c4017a46..b2947b36fadaf 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
@@ -474,6 +474,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
-- 
2.39.5



