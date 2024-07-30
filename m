Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A965E1BF337;
	Tue, 30 Jul 2024 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355225; cv=none; b=bdRukq9+3Y7vD1NLcgFhyAMD5IubQiJqh6MSUz75CTgJKnxd7+260our5395XprGKNFWp8neDLI/MmPNisgCEiAneZr7ALBYzfOHmrtEqJ/olAAP2I1bHZd/qxn6G8A8R1gBNVdhJBC27sapZZCCS6jj3XzAJUnxD4Q/vStDCBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355225; c=relaxed/simple;
	bh=1r3wzTx7GspTyQ/bShF2/1GAyk0U+h/v6GwXvMrljwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHJchTENjF5l3TIHCuoSXSAlgsf4pqJOEFr23Y6aIVmGD1uECpue26UTBNOpQEK+pTcVh5Me1yK7ME/gwFTaZGw+l+uBIK1ri2S24JSsFQ0aDj6AH5AjbsiROvAYyHw79PEKv+enLvvc4InDNuxtIGC926qDLwpfS/TznjHGwJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiNd8qGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiNd8qGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1825EC32782;
	Tue, 30 Jul 2024 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355225;
	bh=1r3wzTx7GspTyQ/bShF2/1GAyk0U+h/v6GwXvMrljwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiNd8qGbk+Tyv+NWssXY5Qq/ETInhttJT1A2OX09wXOTdGK3/sv5Sj7lPZWQbMwJA
	 yNwWHn/mGkgE3Enc19dlNmzXowCCXl6U/z0iRSf5Dc7ogC+14Kn5RZJycoKD/85hJE
	 IAsAJw+dTRgiAvxUPhUeA5EtDkKNGro+UK25ol1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/440] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Tue, 30 Jul 2024 17:44:43 +0200
Message-ID: <20240730151617.718439898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0f2ddb128fa20f8441d903285632f2c69e90fae1 ]

The VOP on RK3328 needs to run at a higher rate in order to produce a
proper 3840x2160 signal.

Change to use 300MHz for VIO clk and 400MHz for VOP clk, same rates used
by vendor 4.4 kernel.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-2-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index d42846efff2fe..5adb2fbc2aafa 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -820,8 +820,8 @@ cru: clock-controller@ff440000 {
 			<0>, <24000000>,
 			<24000000>, <24000000>,
 			<15000000>, <15000000>,
-			<100000000>, <100000000>,
-			<100000000>, <100000000>,
+			<300000000>, <100000000>,
+			<400000000>, <100000000>,
 			<50000000>, <100000000>,
 			<100000000>, <100000000>,
 			<50000000>, <50000000>,
-- 
2.43.0



