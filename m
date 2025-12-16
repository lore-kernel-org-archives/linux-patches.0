Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B57834D3BB;
	Tue, 16 Dec 2025 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885319; cv=none; b=PhNFc0DRQ8X3Nnsydb6kT2RKt7BNoWKffRit3C8iZM1IQx0SLegLcZ8IcJYjyAl3VH25h6S/rtJ/1YAFk79U6R1f9OJ2tS1dlg7J8s+GaQQS3v2K/YxShl7P4mH0amG+57rBeyJTT+dBktpqmXFuVEV+/Frna1Ri6+J9KMIg4Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885319; c=relaxed/simple;
	bh=gXhJ5NC2wX6o50hcvU40kpt37gzgD6Bv9FLBsVMq+js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCF4/ZeXerawSDMCDpoAY9wrSsvC+2yAyXNJL7b4tO8ok2luPFghqYcS4XQZ2U/HG3fzkbVTtoelIljQJbkIJ/KJmFsOYPOZTFauetYl/VKouKxjv1cdsHCWrvDVVB4lAU31Da+dxYFCRXSdcZMS+7YUDxP3upw9gpiIj72ZArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvoECqBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvoECqBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35457C4CEF1;
	Tue, 16 Dec 2025 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885318;
	bh=gXhJ5NC2wX6o50hcvU40kpt37gzgD6Bv9FLBsVMq+js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvoECqBcMXA+ySSRbLePwwy1WDi4ULJ/FZp2e983WFRYx5koHVcVMrI1aJvUBsIS8
	 Va1GClNZT8sozPLqWKPa0nT50SWxXlcpHF07eSbdf2VEVEUB0d32tTgFVyxUWNd0Xb
	 wMR03ruv+ZKbEPLihpu/A2KK+xpnJVh95Xg3/MRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/507] arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdhc1 props
Date: Tue, 16 Dec 2025 12:08:21 +0100
Message-ID: <20251216111347.717409563@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 8b7e58ab4a02601a0e86e9f9701d4612038d8b29 ]

Remove the un-intended duplicate properties from usdhc1.

Fixes: 0d5b288c2110e ("arm64: dts: freescale: Add imx8mp-venice-gw7905-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
index cbf0c9a740faa..303995a8adce8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -423,9 +423,6 @@ &usdhc1 {
 	bus-width = <4>;
 	non-removable;
 	status = "okay";
-	bus-width = <4>;
-	non-removable;
-	status = "okay";
 };
 
 /* eMMC */
-- 
2.51.0



