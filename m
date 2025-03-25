Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F9A1DBB13;
	Tue, 25 Mar 2025 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905892; cv=none; b=ihQgkcy4RmMRgF2IammZlbnpaymzi1fpxfwnV+mnnRGUXe5YTb6r1C+YTR097cVgAdPAy46EgC8OPC7rIXYXC1e/iA+L/bcUsBNxznyWCjGhSopASXQOLdBbLbLvNHGKa4JTJGjHsagV8KLJHBC+LHFVadAfOOQOfrZa53WcGxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905892; c=relaxed/simple;
	bh=9+yZVkgLvg5IKkR70xpgl4TWAzOW5OpXQBl7+Cfcmi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzHMGIimFyteVcC8to8dn95bvoi4C74kqI4gXgsxNf7DuGL5CDOpAouyqgLWulrZQ4Y6IV2jcoujYVsnsXcol+dZBfTa4TF9aoaR57mzMCE8wDUNPrMLhfKs71rg5k6w40BCKgEK+ZB9cpmVVWB00VIbgm6yQ3JOQpeRlGP0Wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMKTT2eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMKTT2eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53685C4CEE4;
	Tue, 25 Mar 2025 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905892;
	bh=9+yZVkgLvg5IKkR70xpgl4TWAzOW5OpXQBl7+Cfcmi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMKTT2eRxqJ9pG1d76pr5YrLlcdvp4HlonS8KYvpx6nCOG8FzkMg6LSlqL1G+GhFx
	 ugZJDXsp5d8CbfyVnky0TyhM3Xpw6ut1QRB3sFF5HG4z/0jtyYJ2j3jF2UZ2wiIbqP
	 X/PjOxxV++3fhYSQ6bIE0YA5WUdhYyXMiAsvKZd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 004/119] arm64: dts: rockchip: remove supports-cqe from rk3588 jaguar
Date: Tue, 25 Mar 2025 08:21:02 -0400
Message-ID: <20250325122149.174795638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 304b0a60d38dc24bfbfc9adc7d254d1cf8f98317 ]

The sdhci controller supports cqe it seems and necessary code also is in
place - in theory.

At this point Jaguar and Tiger are the only boards enabling cqe support
on the rk3588 and we are seeing reliability issues under load.

This can be caused by either a controller-, hw- or driver-issue and
definitly needs more investigation to work properly it seems.

So disable cqe support on Jaguar for now.

Fixes: d1b8b36a2cc5 ("arm64: dts: rockchip: add Theobroma Jaguar SBC")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250219093303.2320517-1-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts b/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
index 90f823b2c2191..7f457ab78015a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
@@ -503,7 +503,6 @@ &sdhci {
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_cmd &emmc_clk &emmc_data_strobe>;
-	supports-cqe;
 	vmmc-supply = <&vcc_3v3_s3>;
 	vqmmc-supply = <&vcc_1v8_s3>;
 	status = "okay";
-- 
2.39.5



