Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B197E55B;
	Tue, 25 Mar 2025 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905894; cv=none; b=Wow6+Q1LGB4yfdUVmYKM4j3BrscYFFhP/gvmqFB13VQBuMjdTpMpCoWAUvwsSLQhoJLy/dGZsQZBZpRq/MvCJ7E5ZgJZ/k7haaj7fMyS8KzMv21bwVuC3Bcv4Yk85hn6o9ORF4jYmR2QYyoNIk8LbsjUVhD83/27U9GD5yCtk0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905894; c=relaxed/simple;
	bh=noE+0hjSDiWAZ5FDHn+6bgFyQSavW8lS1kjC+ijIigE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCWEXz4j+KQTQLK6Q8qFsIOafsE+u60uZSrar0ivh41aXzBa0ABVRi0wNbgwgm41lWGIfFLb2yfJoto0j/cftqF2pJfONRcGV1wYOaUt8t+9sR8/n7GfilKkVdNt+mSbcCjyD5voJ+s+d/hDwxZ8X+3nmffN9JbI0sXNF5zav3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4gAJWMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4gAJWMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D868C4CEE4;
	Tue, 25 Mar 2025 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905894;
	bh=noE+0hjSDiWAZ5FDHn+6bgFyQSavW8lS1kjC+ijIigE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4gAJWMcG8vqBqUP1ksRrhsp9/Z/GEQgSkMqPXB2ySHBxzJMg8etJvFy6dPVjj7Ie
	 h+ia8wTyH7lMiqt57VAodmXmh7LtzDqlYZTuJWcUBEp4btgNQe2f9w99FVDL7Bu+59
	 S//VjGfhG7q2APX/ZEc5OiTwXxGE346c5yzS7wmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 005/119] arm64: dts: rockchip: remove supports-cqe from rk3588 tiger
Date: Tue, 25 Mar 2025 08:21:03 -0400
Message-ID: <20250325122149.198543583@linuxfoundation.org>
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

[ Upstream commit 3e0711f89e5e7b0c7b2ab4843dc92dcbbdbba777 ]

The sdhci controller supports cqe it seems and necessary code also is in
place - in theory.

At this point Jaguar and Tiger are the only boards enabling cqe support
on the rk3588 and we are seeing reliability issues under load.

This can be caused by either a controller-, hw- or driver-issue and
definitly needs more investigation to work properly it seems.

So disable cqe support on Tiger for now.

Fixes: 6173ef24b35b ("arm64: dts: rockchip: add RK3588-Q7 (Tiger) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250219093303.2320517-2-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
index 81a6a05ce13b6..e8fa449517c27 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
@@ -386,7 +386,6 @@ &sdhci {
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_cmd &emmc_clk &emmc_data_strobe>;
-	supports-cqe;
 	vmmc-supply = <&vcc_3v3_s3>;
 	vqmmc-supply = <&vcc_1v8_s3>;
 	status = "okay";
-- 
2.39.5



