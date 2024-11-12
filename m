Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D8820D4E3;
	Tue, 12 Nov 2024 10:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407553; cv=none; b=VI92+GDjZh6LMjE16bLJzRaeCDJDh8ToRVLDua5n5ebdIp5TIo7BPI1bpM5ig2Xfnb0GH4QEHW0XSul5BEhDnOfGRsbtT2IYygFwY5cBFzvugl6D2J2UePBLsHd9ElPCRVhCVJe5BHTM5NdFx22HxEzz4t/rjEqPKf7/GccAqHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407553; c=relaxed/simple;
	bh=2rxOIsOvfS94X+fwcltQ1YR1/UZKnYdpKJgsAvuTiH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR7jPmWktzhzs9aw3qS/aelRH9stXbLTAXjKs/vhadTig3kQZK9V5VwsgO7UDwUTthZ8E2XtlGOBtAsE6gQmzhogsyuQhed0g0Ye4hTXX9GNmaVvfTq7IuCQBDqOABW3bsBKmgCRexf8208cQmBA1lVtibUB7DV1ex+doUGphTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHH1bV8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHH1bV8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A553BC4CECD;
	Tue, 12 Nov 2024 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407553;
	bh=2rxOIsOvfS94X+fwcltQ1YR1/UZKnYdpKJgsAvuTiH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHH1bV8kMvX7H83gb186uWBSedF3+hxVMJGwAawQnX00kTxwN656zUbooHB/Kug33
	 SGbxobJn8tXMagvpAGrPNNr3ysGjDdwySzkr/Q9YHsTxueRsfaEsG0QJxloI4P/sgf
	 16KHcsAbHoPQnqSFluYqpco4gWWJ8JtFIHHjSQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Klaus Goger <klaus.goger@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/119] arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion
Date: Tue, 12 Nov 2024 11:20:19 +0100
Message-ID: <20241112101849.146746175@linuxfoundation.org>
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

[ Upstream commit 5ed96580568c4f79a0aff11a67f10b3e9229ba86 ]

All Theobroma boards use a ti,amc6821 as fan controller.
It normally runs in an automatically controlled way and while it may be
possible to use it as part of a dt-based thermal management, this is
not yet specified in the binding, nor implemented in any kernel.

Newer boards already don't contain that #cooling-cells property, but
older ones do. So remove them for now, they can be re-added if thermal
integration gets implemented in the future.

There are two further occurences in v6.12-rc in px30-ringneck and
rk3399-puma, but those already get removed by the i2c-mux conversion
scheduled for 6.13 . As the undocumented property is in the kernel so
long, I opted for not causing extra merge conflicts between 6.12 and 6.13

Fixes: d99a02bcfa81 ("arm64: dts: rockchip: add RK3368-uQ7 (Lion) SoM")
Cc: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Cc: Klaus Goger <klaus.goger@theobroma-systems.com>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-7-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
index 5753e57fd7161..e8859cfd2d39b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
@@ -60,7 +60,6 @@
 			fan: fan@18 {
 				compatible = "ti,amc6821";
 				reg = <0x18>;
-				#cooling-cells = <2>;
 			};
 
 			rtc_twi: rtc@6f {
-- 
2.43.0



