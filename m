Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA65F28D8E8;
	Thu, 27 Nov 2025 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255485; cv=none; b=GiHYdP2BdvhSuRU3Bz/Qmld+ZgyYptyTTFi1n6pdEptvD5LExqTya9+H9pwqcbEBBLfPOArXIUhP1EEOTdwwOTVsCQNGoPqZRWbhWYEPrbbXLxh4mbzsGrtcsdYMMhIr1Si+Xs0NsYmZPz7gHoxlvPjaEHPieI3rYUL78TBkTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255485; c=relaxed/simple;
	bh=sr+9PST12/JLU0Fa5wb1L3qfkHJzk1LqrdOXMROlxuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxvGm/ieNKBS4L58ppyVLLk3d+XE4iNc2ph2gakkLnTj/G6hFpc5nt3IZuFYo2/mDkIhcYrUrCQrgpsHnTTEyD44KMOElqTvHMPyAcAELku6/CxBVHX8ztiIxsHjrRi5c0I0AlCjhzdyBsxuAbgGsYtNG0WqghlGQHjBWqNtHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJCz41ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJCz41ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35191C4CEF8;
	Thu, 27 Nov 2025 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255485;
	bh=sr+9PST12/JLU0Fa5wb1L3qfkHJzk1LqrdOXMROlxuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJCz41ZVzuzCt2tImJm7W5h8aJS//Vy8qSgrWM6IdaQcJ912T5sw7nBKnAIHAPSlW
	 QPrSKoFWMPE9OM4FFoimK7f5hQD+dcdTjeHYbf2ueHPkF9PIVXusWIq2qmEnaShD5H
	 2uFamhJBgm9dlZ+NaN+OhaFDRYlvuQ24FqlwHr58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.17 010/175] arm64: dts: rockchip: disable HS400 on RK3588 Tiger
Date: Thu, 27 Nov 2025 15:44:23 +0100
Message-ID: <20251127144043.333267719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit baa18d577cd445145039e731d3de0fa49ca57204 upstream.

We've had reports from the field that some RK3588 Tiger have random
issues with eMMC errors.

Applying commit a28352cf2d2f ("mmc: sdhci-of-dwcmshc: Change
DLL_STRBIN_TAPNUM_DEFAULT to 0x4") didn't help and seemed to have made
things worse for our board.

Our HW department checked the eMMC lines and reported that they are too
long and don't look great so signal integrity is probably not the best.

Note that not all Tigers with the same eMMC chip have errors, so the
suspicion is that we're really on the edge in terms of signal integrity
and only a handful devices are failing. Additionally, we have RK3588
Jaguars with the same eMMC chip but the layout is different and we also
haven't received reports about those so far.

Lowering the max-frequency to 150MHz from 200MHz instead of simply
disabling HS400 was briefly tested and seem to work as well. We've
disabled HS400 downstream and haven't received reports since so we'll go
with that instead of lowering the max-frequency.

Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Fixes: 6173ef24b35b ("arm64: dts: rockchip: add RK3588-Q7 (Tiger) SoM")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251112-tiger-hs200-v1-1-b50adac107c0@cherry.de
[added Fixes tag and stable-cc from 2nd mail]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
@@ -382,14 +382,12 @@
 	cap-mmc-highspeed;
 	mmc-ddr-1_8v;
 	mmc-hs200-1_8v;
-	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
 	mmc-pwrseq = <&emmc_pwrseq>;
 	no-sdio;
 	no-sd;
 	non-removable;
 	pinctrl-names = "default";
-	pinctrl-0 = <&emmc_bus8 &emmc_cmd &emmc_clk &emmc_data_strobe>;
+	pinctrl-0 = <&emmc_bus8 &emmc_cmd &emmc_clk>;
 	vmmc-supply = <&vcc_3v3_s3>;
 	vqmmc-supply = <&vcc_1v8_s3>;
 	status = "okay";


