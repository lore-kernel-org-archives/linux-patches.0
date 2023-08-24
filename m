Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1914A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A049C433C7;
	Thu, 24 Aug 2023 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897687;
	bh=JU2Vjr5COC8q5RM7ll24SUyvLt9hoTLjcmEJvV9jvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svx/xVxdVWwCwsNsBKwvx+vCd/YEEZlPsGN5jl5EesD2PITRGDTD+kk5O5KQNUu7/
	 4kYdBxNtZwzjUAvVbPhZbnfjdkQUFk++cRsv5a0YnILsUq9HS4+yID0s6fuoQy3tye
	 PciVnR7sNT2e0IVVsZ7dHXpFhF6+IFam/SjxtUBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicente Bergas <vicencb@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/135] arm64: dts: rockchip: use USB host by default on rk3399-rock-pi-4
Date: Thu, 24 Aug 2023 19:09:28 +0200
Message-ID: <20230824170621.435230353@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicente Bergas <vicencb@gmail.com>

[ Upstream commit e12f67fe83446432ef16704c22ec23bd1dbcd094 ]

Based on the board schematics at
https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi_4c_v12_sch_20200620.pdf
on page 19 there is an USB Type-A receptacle being used as an USB-OTG port.

But the Type-A connector is not valid for OTG operation, for this reason
there is a switch to select host or device role.
This is non-compliant and error prone because switching is manual.
So, use host mode as it corresponds for a Type-A receptacle.

Signed-off-by: Vicente Bergas <vicencb@gmail.com>
Link: https://lore.kernel.org/r/20201201154132.1286-4-vicencb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: cee572756aa2 ("arm64: dts: rockchip: Disable HS400 for eMMC on ROCK Pi 4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 98f52fac13535..6dc6dee6c13e2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -671,7 +671,7 @@
 
 &usbdrd_dwc3_0 {
 	status = "okay";
-	dr_mode = "otg";
+	dr_mode = "host";
 };
 
 &usbdrd3_1 {
-- 
2.40.1



