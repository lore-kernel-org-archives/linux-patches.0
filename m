Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B11335F61E;
	Sat, 12 Sep 2026 07:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197261; cv=none; b=Zx+Wu6TcHLkza9DAlwzyH/umKz8Z3s397aK4tkuaEeiqJ80Ql1qU3aWjL9DF4CIs9C7SUIduZJDI54//9HH056TCDPOTTwc5H9LAlb4ikAuxQdtb7TLLUv7gBJ9dibpksrJikZXI9YjPFSEcLmOPEarJYSgK7YD1Nbrsv6yq2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197261; c=relaxed/simple;
	bh=2XlIx8qguAhd2RK5jplO5RloZwJl+krqRZJs6OOniKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+uk0VuNvDweiIniYmYZUaUzyzGNU6WDrutkXd/m52LbsC3hytYUgvlHDNe+sTXCFQOpJiQTtxnnqbpc3LQ3kQuMbhQ3tmFMkxOhrknP2t/YIPvSp8bth6uMVnY4cyq/CIh758eoXjDuRWuww7RvXTCVfY5gseAnw6aM5U/biTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saJDHelp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saJDHelp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40A91F000FF;
	Sat, 12 Sep 2026 07:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197260;
	bh=3v7ZCaBQPbLQhWVcC523OE8b549ui3hQZCcF9Gjko/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saJDHelpSi+3JUcL87lgmsdkC8wtHUYD3uX/9yRXxFzdUEr/k4E1/3aiwtN8gi9mS
	 8pRZN9ZGxC7NBCuydUtgXudkhOPY/rH9IaDkBl4wUJM6EiJS8KWKMw3ZqxGTgJwZLA
	 Hf557eivglMiaCngGa6LjDyserVvFqDt/gNCx5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0094/1815] arm64: dts: imx93-kontron: set memory node to 0x80000000/1GiB
Date: Sat, 12 Sep 2026 08:30:44 +0200
Message-ID: <20260912065651.214197594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 9c269fe7eae8cb60d8d6c326dd8955818722fae9 ]

The start address of the DRAM area is 0x80000000. The minimal size of the
DDR on the SoM is 1 GiB.

Fixes: 2b52fd6035b7 ("arm64: dts: Add support for Kontron i.MX93 OSM-S SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi b/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
index c79b1df339db1..f881912cde460 100644
--- a/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
@@ -15,9 +15,9 @@ aliases {
 		rtc1 = &bbnsm_rtc;
 	};
 
-	memory@40000000 {
+	memory@80000000 {
 		device_type = "memory";
-		reg = <0x0 0x40000000 0 0x80000000>;
+		reg = <0x0 0x80000000 0 0x40000000>;
 	};
 
 	chosen {
-- 
2.53.0



