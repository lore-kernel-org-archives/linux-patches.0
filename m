Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F04BEE54;
	Sat, 12 Sep 2026 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206134; cv=none; b=FwrClXTyOWZXHDDzEBUIYYx6quKhyVHD4o1k9RcloZ7HNdzCZLmKIq8Sf31pI40yM1srCTAYwNIGna7R1FIhmR8EzrjZS/Ieij4+wrDLknLb3JNRHeQfhZdwqS902CUjQhAPtfKD/Ji5K0xXdLfaWr2HRWeymAF4bSRY+qZBJ9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206134; c=relaxed/simple;
	bh=OCzdRtBArUha59OaOXJZt+C7GRw6UUVX6Vibgf/52D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnEgl/d3rZAw1mHYknEf7qPY9ExHiVaZ4rAXTJcNbsrSqOckk1p1nrfgBtXOP0bmIcdNHo4c9p4fdefKMD4gzjAfNSDE57M9HRlE/R+eQsIr4xqG7fwau0GZFtGo0XfJEV+fhT/9q7sqntDb2dSPnpZcRoV0Qr6qVdnDwyBrjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu7f92Sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu7f92Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221F21F000FF;
	Sat, 12 Sep 2026 09:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206133;
	bh=Q5EYatJZrKw7hMnhVkPIyqv04lOtyEX/UfHB8kKcskk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu7f92SzCzp7E+895OmssNDh8aj6fyX+Sk9Kk0Gn8afezp+LyeH1zCwrCWyCm56SS
	 ZN3eoQyqw3QWTqsaCn00roQk8gQR0MxDMEc9XTagccGxbWjWyFPWzF9kpg7ihg2f/T
	 FVJTBiK3yfBhEIu/94hM02Qgewn5IMFrP/XqMs0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0137/1518] arm64: dts: imx93-kontron: set memory node to 0x80000000/1GiB
Date: Sat, 12 Sep 2026 08:38:26 +0200
Message-ID: <20260912065626.594643767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



