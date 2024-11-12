Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546E120ADFD;
	Tue, 12 Nov 2024 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407606; cv=none; b=mp9YJkXdKWA608YoqG9avc0J/aFzGZO5/dbi6REziXhcfBUie52SZrTLUDtNmlo46N37Yno+Kv8gKa17ZU0gNx8J9WJAbzFuEfF+D5Ud2Ib7JlluxwqFDVE7WDaGZUJu9gJOrv4DeosUz8/Vv0acCoTsRbeox7OgNkon6csZWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407606; c=relaxed/simple;
	bh=PRDqa0UV+UaF4LARxOZ9h+c7bUVJYSarfRMKE4m7XOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j81vGE7KfBGGnd6bNlly8vHFaN9P1oFIZFpqM8D6nusSD29LzwMqT9tqkrOYk96rdHS8Y3fwbgxC3Zz4Na+W1LWPWHRjBoZBZRwsbAjomfjDpDh4cZTVCpc7vi83kiYtzWr0jMyc6vWz2TR67xbmuQZ9avmaefa0TxZG+yMySZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEnn4ks/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEnn4ks/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA332C4CECD;
	Tue, 12 Nov 2024 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407606;
	bh=PRDqa0UV+UaF4LARxOZ9h+c7bUVJYSarfRMKE4m7XOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEnn4ks/cXfUoYlbCS2h4ALhOgxshyobOJBkMIhVIBg+indLVndJn4gyjSxnFsjiz
	 tikJJ1w2cBp1sDykIJDLmRLspC9gBySc+o286dFEhFnQekrD4Sj+rVDp82nVsQJUsx
	 e8QkKu+Gg8nZOOIXypxMW0tdyvOTmv2dx0kOBNws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/119] arm64: dts: rockchip: fix i2c2 pinctrl-names property on anbernic-rg353p/v
Date: Tue, 12 Nov 2024 11:20:14 +0100
Message-ID: <20241112101848.957891163@linuxfoundation.org>
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

[ Upstream commit f94b934336e30cebae75d4fbe04a2109a3c8fdec ]

We want to control pins, not beer mugs, so rename pintctrl-names to the
expected pinctrl-names.

This was not affecting functionality, because the i2c2 controller
already had a set of pinctrl properties.

Fixes: 523adb553573 ("arm64: dts: rockchip: add Anbernic RG353P and RG503")
Fixes: 1e141cf12726 ("arm64: dts: rockchip: add Anbernic RG353V and RG353VS")
Cc: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-2-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dts | 2 +-
 arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dts b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dts
index 8aa93c646becf..5f1b12166231f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353p.dts
@@ -92,7 +92,7 @@
 };
 
 &i2c2 {
-	pintctrl-names = "default";
+	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2m1_xfer>;
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dts b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dts
index f49ce29ba5977..2957529a27486 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-anbernic-rg353v.dts
@@ -79,7 +79,7 @@
 };
 
 &i2c2 {
-	pintctrl-names = "default";
+	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2m1_xfer>;
 	status = "okay";
 
-- 
2.43.0



