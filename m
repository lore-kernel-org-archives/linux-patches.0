Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794B25D525;
	Tue, 25 Mar 2025 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906281; cv=none; b=nKu69dSP9WGOYm0UKbnijkF934LSh0BRKssQmWT70lPxU2+Zc5SkwAPk8X1j4+UArmoo0t8GAlVVVcAWHWWnLOzwq0ipLhMRn1eV1aaY23XzSApIsUQqZFeI+s/kQdxhJrye90VhLlUefe4dEJAUJyBvRMk/REp63uT09eXqDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906281; c=relaxed/simple;
	bh=6uinkWHt4sm/zA19prInGs69U9k150SWaEauuRvnN8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGsYYE8FN38iS5IsXS+AGHuAOWKibjldoBHixNmwU2/QKbcSJp9js/s5iXYF2kKIBA4ZVAtFQ4szQBmpyrtoSCwF/X5MYjWeuwDrc1TLMyrTpTWu8bVq3LYz2UivpKYpugOkB3MdV90IiEro9vUhgAydsODZyKWq55LYA/JertE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/P/11AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/P/11AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5677C4CEE4;
	Tue, 25 Mar 2025 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906280;
	bh=6uinkWHt4sm/zA19prInGs69U9k150SWaEauuRvnN8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/P/11ALA8sHflMidk2l9WnAklNFyRxRocxIzknP1J8Qx+pr/v6Yxj+bto2oAa9DX
	 TGdWO6vTxvgnBDkH1VoKN1P1TnMCVYXrUylUOSNbUrkTWN5qJF7bKRVinxW5H15Rsw
	 j9ZF2xxGc1NTDDbP42db86GdcUYus8y471caasn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/116] arm64: dts: rockchip: remove supports-cqe from rk3588 tiger
Date: Tue, 25 Mar 2025 08:21:32 -0400
Message-ID: <20250325122149.346368927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 615094bb8ba38..a82fe75bda55c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
@@ -367,7 +367,6 @@ &sdhci {
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_cmd &emmc_clk &emmc_data_strobe>;
-	supports-cqe;
 	vmmc-supply = <&vcc_3v3_s3>;
 	vqmmc-supply = <&vcc_1v8_s3>;
 	status = "okay";
-- 
2.39.5



