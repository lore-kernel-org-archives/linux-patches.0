Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AA71DDF5;
	Thu, 15 Aug 2024 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728576; cv=none; b=mCyW/OoxpuOITlH98FdtG1sytmA7tzqI/HI5BvG8JXmHk63B6J79XZgOtsnWbLC6BW68vEjJ+6PVsJoEaBmLOtXHjpDlz8c52PfbIjv9dqW0Imruw8Ayikaecz2w6Jm0CkkVtVtFEo1kLFfoFJHbTvkNn0W4OGJ0cxJPvHSLm18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728576; c=relaxed/simple;
	bh=lK7B4Zo/YyBwT5o0CRH4BQc4PxorVmwx7ALiciAROOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbP9buVC8cD8mhCjfbZC5p46KOa8l9E4l2zdII7ksBp/ijkhYd8TfeLkAqnQlGyHvphK3ilnwe3o0ZWQxPVkzidwdf6g5FPBXVR4G4nw/Ry7wB6LZGUfKrT0rsyotDDcwBKBLsjwjpLiD+SBKfrZyMWCCzzGtHugHANjsgxWzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRu5jxpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRu5jxpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CE9C32786;
	Thu, 15 Aug 2024 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728576;
	bh=lK7B4Zo/YyBwT5o0CRH4BQc4PxorVmwx7ALiciAROOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRu5jxpLkD2/zswwIa5xZptzWiJzaUndfwrbVkLHCYJz0uzYppvLW5JlP2rfjHXCk
	 6Edl8yDlGaCSM6gX8Vr8nBoVjV1GMDG0+6oPv6bZMq/3zoGE5yB//ZrZmglAD9xBe2
	 +eoX5ZmPAo0q7Oof6pW5TA09kbCShqu9evXWYmik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/196] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Thu, 15 Aug 2024 15:22:10 +0200
Message-ID: <20240815131852.582555243@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0f2ddb128fa20f8441d903285632f2c69e90fae1 ]

The VOP on RK3328 needs to run at a higher rate in order to produce a
proper 3840x2160 signal.

Change to use 300MHz for VIO clk and 400MHz for VOP clk, same rates used
by vendor 4.4 kernel.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-2-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index f6931f8d36f6d..ab870b9043967 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -649,8 +649,8 @@ cru: clock-controller@ff440000 {
 			<0>, <24000000>,
 			<24000000>, <24000000>,
 			<15000000>, <15000000>,
-			<100000000>, <100000000>,
-			<100000000>, <100000000>,
+			<300000000>, <100000000>,
+			<400000000>, <100000000>,
 			<50000000>, <100000000>,
 			<100000000>, <100000000>,
 			<50000000>, <50000000>,
-- 
2.43.0



