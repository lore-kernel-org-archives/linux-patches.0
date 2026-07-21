Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E93ED3B2;
	Tue, 21 Jul 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649367; cv=none; b=dBTfuso3nC2WJ/TsvszKjDSvMcvaReKCOx4CtZScqYCp7X4hIkCmE+3DnldvV0JkFvkANWIWh+sEq3y9jBDFPtWWaQvO/ex9gT6kJogzJMwD2zSP+WVPk3VaCJa3BPXeIGRmbD/Pg3iMzZn2FzLCFAiMC8PJR8dEAvxwgaqyBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649367; c=relaxed/simple;
	bh=Bh76mHAy7yE7QVQSZq2zSWi7Fw93WDPtYWZEYbta7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWpHArfbK1cbrhXs4ZwGFBRyA5hpBZkiUwRp5Xa89BE/+owrPjhFjfysi4luzJkmBEoUbPe4iTy+Q154BHGnHF1i5JXPxrwI5SFAE2ihm09Dd+/ZuKNxL3oKa5Njvbf6S2HfZeLeUxQLqRs4nX+19RRFh9VamsADwi1Y6O2rqXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKsVRg96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKsVRg96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF421F000E9;
	Tue, 21 Jul 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649366;
	bh=MYeRiqqgJR+CVtWM13LDRBAaAhjCfsoKmcyuFIGT5Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKsVRg967NifhD2iZEJdFSwG05LI6J68Lx1OIeHyzPT4AR+iaBdzSqXZ4iRZqoy6z
	 MCDSBi6dOhWo1jF1Gb7EDIKPNaa5SXH9J+EXBd2R4jPKo9BlFkBVroLUfUP+aBCxzo
	 YQd3qKjFbvGJQKeN3H9KyMHwGGt7Lfzi1m3ajVQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0508/2077] arm64: dts: freescale: fsl-ls1028a-tqmls1028a-mbls1028a: switch mmc aliases
Date: Tue, 21 Jul 2026 17:03:01 +0200
Message-ID: <20260721152604.797488879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nora Schiffer <nora.schiffer@ew.tq-group.com>

[ Upstream commit 08886fa69c0f56f886b63d7835da0632ea4082f7 ]

All modern TQ-Systems boards follow the convention that mmc0 is the eMMC
and mmc1 is the SD-card when both interfaces exist, reducing differences
between boards for both documentation and U-Boot code (which uses the
same Device Trees). Adjust the recently added MBLS1028A Device Tree
accordingly.

Fixes: 0538ca1f102d ("arm64: dts: ls1028a: Add mbls1028a and mbls1028a-ind devicetrees")
Signed-off-by: Nora Schiffer <nora.schiffer@ew.tq-group.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/fsl-ls1028a-tqmls1028a-mbls1028a.dtsi  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-tqmls1028a-mbls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a-tqmls1028a-mbls1028a.dtsi
index cf338b2e800645..426a81e1743f11 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-tqmls1028a-mbls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-tqmls1028a-mbls1028a.dtsi
@@ -17,8 +17,8 @@ aliases {
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
-		mmc0 = &esdhc; /* SD-Card */
-		mmc1 = &esdhc1; /* eMMC */
+		mmc0 = &esdhc1; /* eMMC */
+		mmc1 = &esdhc; /* SD-Card */
 		serial0 = &duart0;
 		serial1 = &duart1;
 	};
-- 
2.53.0



