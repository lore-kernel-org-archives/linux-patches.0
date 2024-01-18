Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A71B96D;
	Thu, 18 Jan 2024 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575230; cv=none; b=l4QXb69OCuHtSq2Bh2x1fYkilK7RS0PJw8qA6EeYLoD6Wl/tmfVhg0TunLfVyXRYkAcihoLCoOqoOBweGbuSGtmxsJjcDa1BOzA+LiWwQ48Ccf/gUhG74+FFNdTf3/8ILXNiB3cOIhDHgtHKKZuEsBHsPqWuAYx0kIS6nXO9oiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575230; c=relaxed/simple;
	bh=A7QjHw/Q0bz4L+b1EZPeHXSNZTtrDzHrPzDpokXmGIo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Nuo+luBK3opib7AbZxkIBV759NHU2xT2ZcRu7q5MYDcKTPsE2CqFcAFbujdR2LX5f9bRfpiy03M/wG63KYlostkzipc6s6i9tyCRy2ufpgtrpPyRRnd2X3jHVFsHV1Rmdaeo78aOYehNFhLFHqJafEHpxbl/HMTe/qv0VvdSN7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGsNZmBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGsNZmBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480AAC433F1;
	Thu, 18 Jan 2024 10:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575229;
	bh=A7QjHw/Q0bz4L+b1EZPeHXSNZTtrDzHrPzDpokXmGIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGsNZmBb13hIvCbd7w46UrMCsw3xcz4iv2Pa0UvBsg/LIsVHVr7+LDBJqAqeYOIEu
	 6fXkVu4LptzUlFsdcJBalbVGL5jyFSiUToI/D5qUQETI9jJsaqGCqoaXu7qE6H+HHU
	 hyNcwX6kfX/ixvgCZrZvnxMOttkXKyvkaZjKnvGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/150] arm64: dts: rockchip: fix rk356x pcie msg interrupt name
Date: Thu, 18 Jan 2024 11:47:32 +0100
Message-ID: <20240118104321.481669553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

[ Upstream commit 3cee9c635f27d1003d46f624d816f3455698b625 ]

The expected name by the binding at this position is "msg" and the SoC's
manual also calls the interrupt in question "msg", so fix the rk356x dtsi
to use the correct name.

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20231114153834.934978-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index abee88911982..b7e2b475f070 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -970,7 +970,7 @@ pcie2x1: pcie@fe260000 {
 			     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "sys", "pmc", "msi", "legacy", "err";
+		interrupt-names = "sys", "pmc", "msg", "legacy", "err";
 		bus-range = <0x0 0xf>;
 		clocks = <&cru ACLK_PCIE20_MST>, <&cru ACLK_PCIE20_SLV>,
 			 <&cru ACLK_PCIE20_DBI>, <&cru PCLK_PCIE20>,
-- 
2.43.0



