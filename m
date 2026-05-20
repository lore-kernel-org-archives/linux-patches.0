Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0FE31A575;
	Wed, 20 May 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295654; cv=none; b=N944P3Jr0znyULSot/pXiD4aFaIQwIC2DxffzOjUzrxut9E/nN1fHAQhFdKJWlycEG2PNlS4etVAHBKN5zrFbd4AyEWeZkv0GzZieambwyI/H5GEY9udZKCaO9amH/XP+l8jzJZGVtb+OmwCTQ/5xYtsskMSUpKHhp8U3ix/9hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295654; c=relaxed/simple;
	bh=HDX+mdC/aYpll5b8MAsQt4VrbYkmFShaG0I51yu2iqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2GazqUUXbuEACKwMeKlcjgfb1udTYs+IVCqtEBDDka+ZJ7C2nc48Z6e1MDHnzFyVNA2fvTapA7evHinQWwF1hVws6a73sIJ24262qnFSZKm3++781npmlMvtmFXI9uMQw2WZ2As5mxo1BZ2GLIndoeYuB23lmoMmWwLc5el+jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPCf2fC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPCf2fC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2991F000E9;
	Wed, 20 May 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295653;
	bh=SoBErP1r4MkgX5Q9JL9e+6k8Pg7biM9guDSZwOADfyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPCf2fC5atXJj4lFla231Td5NZdcRujGfKB9/2nymRF5u1TRW9O2JhYaptVQRS0sU
	 ZYa5ACW1qp3+N2f6SBUpJx/g2gfd0XSZqK3hH/nUUoyb0xqUr/sNtSvFQNS3xvCSqb
	 yrICvo7oVpAKX5x0v5bFiwIuBVe/Z1KTnL6VYATM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0474/1146] arm64: dts: rockchip: Make Jaguar PCIe-refclk pin use pull-up config
Date: Wed, 20 May 2026 18:12:04 +0200
Message-ID: <20260520162158.921576933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 952affaf455cf..500a0bad1ea30 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts
@@ -588,7 +588,7 @@ led1_pin: led1-pin {
 
 	pcie30x4 {
 		pcie30x4_clkreqn_m0: pcie30x4-clkreqn-m0 {
-			rockchip,pins = <0 RK_PC6 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pins = <0 RK_PC6 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 
 		pcie30x4_perstn_m0: pcie30x4-perstn-m0 {
-- 
2.53.0



