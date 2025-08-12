Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E88F27604E;
	Tue, 12 Aug 2025 19:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025415; cv=none; b=sCR0sEInJgWGkO8WPEzPD8WBxEn7etRUjrbr21ikYq3yeGXb32uOYWYgYP0fVgFUOsobOnNURSJK61fu/5k9fatobLnDx77wBrATskZ/Oo4RFpG/cMDh6rqO08e0gX6w/3I50JQ/Ef5DfAgK3KDHxZIH7rw1nBwS54gU07tg1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025415; c=relaxed/simple;
	bh=K1ZKoF4zPud5y9hyxdSSTo3bHcGoxF2BVEt/+qGNLDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0PGfnWt//vIyarhg63b2HO7y8maSBp3IgnzXzSXAMEo8M6hPL819IZ9efKxiU0mwp65dzd9X3AiIQ32xzu7G1xIGSce1Jx7PSH3VhkZjU1n5ZLXTcXuz0p5xl0xYZtpLL4+k+khWPagwpz1npv1xBqxJTCJWJI44n+ZSAqP1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HN8sgNgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HN8sgNgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FD2C4CEF0;
	Tue, 12 Aug 2025 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025415;
	bh=K1ZKoF4zPud5y9hyxdSSTo3bHcGoxF2BVEt/+qGNLDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HN8sgNgH9bHG4SAghSnVABfIh7s7+4DOMk5SxHy88yTOVQaD5WfPg4T2uOJ3a5UAW
	 KYfT9ILNWNpR8zUcec9ubOOq6vif7b7njNCpq4iOngfm2YZ6CrofdTazSWivYWYDsP
	 +Qj9dK0C4Oirb5NWaJHLKeuuqtcDn+wCKYFe4FcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 033/480] arm64: dts: freescale: imx93-tqma9352: Limit BUCK2 to 600mV
Date: Tue, 12 Aug 2025 19:44:01 +0200
Message-ID: <20250812174358.753402431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 696a4c325fad8af95da6a9d797766d1613831622 ]

TQMa9352 is only using LPDDR4X, so the BUCK2 regulator should be fixed
at 600MV.

Fixes: d2858e6bd36c ("arm64: dts: freescale: imx93-tqma9352: Add PMIC node")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Acked-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
index 2cabdae24227..09385b058664 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0-or-later OR MIT)
 /*
- * Copyright (c) 2022 TQ-Systems GmbH <linux@ew.tq-group.com>,
+ * Copyright (c) 2022-2025 TQ-Systems GmbH <linux@ew.tq-group.com>,
  * D-82229 Seefeld, Germany.
  * Author: Markus Niebel
  */
@@ -110,11 +110,11 @@ buck1: BUCK1 {
 				regulator-ramp-delay = <3125>;
 			};
 
-			/* V_DDRQ - 1.1 LPDDR4 or 0.6 LPDDR4X */
+			/* V_DDRQ - 0.6 V for LPDDR4X */
 			buck2: BUCK2 {
 				regulator-name = "BUCK2";
 				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <1100000>;
+				regulator-max-microvolt = <600000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <3125>;
-- 
2.39.5



