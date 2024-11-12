Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07751C1AD1;
	Tue, 12 Nov 2024 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407941; cv=none; b=Ln2QMwIAmuV3OjV1zqRWbHXHsuELUT2dM8Ba4M2pBq6n8Z7Vo/niSeUx6mBVaKvie3IHV19ZKgIAeW/NNVTvK64lOc1n00FEKey69vMHG6twg780AzuXm2AJGF21eWaW50ywEzNjfFMs8u4KYrDogmANTn1BETzdLuUkrdhPREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407941; c=relaxed/simple;
	bh=OX3RZUAICmq8HqQiQfgcrHVlnoVQwERhFcN1PALL3Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8A1kgwAVhhrtgO7U+8CgFxKy0GXqV6vyG5+dXLt3eVxJsN5cmyE33KZaJ951gXWml9q+Cm5Cb1ZYZXXid89WGiW9ZVIZusjbQ13n7KnO/iB8Zu1K9d35LriEeizbin3ef7QJEZ3M+x8sdPgwirqcGcdCaJG+QcMDkPXiQtjwu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nb/TnpRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nb/TnpRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F322C4CECD;
	Tue, 12 Nov 2024 10:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407941;
	bh=OX3RZUAICmq8HqQiQfgcrHVlnoVQwERhFcN1PALL3Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb/TnpRx7peSO8AgiSzRBNFDshIWbi4LapeuS87hbdFlg849GuO5V6/eJJ4DiEtEC
	 1I3x3wLGgB22y/zLmmLpTcCBEVw85WgCYKOfJ8LlO3M/kIe5RtZcfCOmHplolKJGa5
	 XausS57xKtLq71x+S6FKj5gQC+WhoCgvCrO4HIFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/184] arm64: dts: rockchip: fix i2c2 pinctrl-names property on anbernic-rg353p/v
Date: Tue, 12 Nov 2024 11:19:29 +0100
Message-ID: <20241112101901.306363643@linuxfoundation.org>
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
index a73cf30801ec7..9816a4ed4599e 100644
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
index e9954a33e8cd3..a79a5614bcc88 100644
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



