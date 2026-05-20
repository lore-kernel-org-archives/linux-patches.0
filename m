Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC59E3A874C;
	Wed, 20 May 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298322; cv=none; b=ee/Msyp9THToyV6eRPJa2PhFPjFkv1qn3IoQVDxZW4d5kym/pse8hrYPAu4GEDzdRGmaktEkrdbGynTuHvO4gNewVaSWa7zNNfUJLvH5pnMnrjlMNcfMwyvLne0Gri9FbpIuNmKBhdbF3VPg7o1PCdiAXgpajujQ2s/R73LPiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298322; c=relaxed/simple;
	bh=dwZJKmv1T2tGFkrd1CUfO5noAjiWUoKC3OsljqcX8nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0EpGzOby2RNw58hUfI9i08XoiJhgfglyQb7uv4jPcv9VwPqptcFwQwp+5rN0+Znz76uAf3SzHA5yK5cY0/ZKq3MCChdS1rgs7KOelHi94XSQE/In3B7RlxVy2JpDfBoqV5JFSO240gztQB3tp4Xyhu5YtFBBZjmiG1OleNRJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuHdLxnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuHdLxnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7621F000E9;
	Wed, 20 May 2026 17:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298320;
	bh=ap5Asy32MEEDtMb2kJInU7P/m4jgGMSrp/tProoaP9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuHdLxnKF+TjWRHdSxLkWcPa6TSsuwZV4Z1HEPOTaTBU0O4qKtlwzz/Y21zA80Z73
	 x5rcniDtzxuk+kQCj86wVyStSGfPWppnH3fWachcXhHyt7CRzi5aQUIt8eBtctHmuv
	 iHUedmM33dDlndUYxhrpZeEDwE/BVlfTNrwuAh+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/957] arm64: dts: rockchip: Make Jaguar PCIe-refclk pin use pull-up config
Date: Wed, 20 May 2026 18:14:10 +0200
Message-ID: <20260520162142.487713200@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit f45d4356feeba1c8dac3414b688f59292ddfc9f9 ]

The hardware PU/PD config of the pin after reset is to pull-up and on
Jaguar this will also keep the device in reset until the driver actually
enables the pin. So restore this boot pull-up config of the pin on Jaguar
instead of setting it to pull-none.

Suggested-by: Quentin Schulz <quentin.schulz@cherry.de>
Fixes: 0ec7e1096332 ("arm64: dts: rockchip: add PCIe3 support on rk3588-jaguar")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260210080303.680403-5-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts b/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
index 176925d0a1a80..557158093b586 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
@@ -585,7 +585,7 @@ led1_pin: led1-pin {
 
 	pcie30x4 {
 		pcie30x4_clkreqn_m0: pcie30x4-clkreqn-m0 {
-			rockchip,pins = <0 RK_PC6 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pins = <0 RK_PC6 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 
 		pcie30x4_perstn_m0: pcie30x4-perstn-m0 {
-- 
2.53.0



