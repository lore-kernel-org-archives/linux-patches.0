Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60966265CCD;
	Tue, 30 Sep 2025 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245456; cv=none; b=PddvAQqVNfixojP4PxRFx/6ETXqxde2mEL8O5ihOXHh9St9YJEzY64imi2pC7YhJtHKFnvk5BOGTgIi8xlA+9RVra7lJmGkZhhFNSLI9EII1MOAFS45qF1pHNeQKtkBpeDG0WEVa+mWp7UkoVcNQ+jOX1C6BPhxcIXMGqot4V1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245456; c=relaxed/simple;
	bh=gUoGuxa7/F7orGHQ85dDQB3VjVnucFxO5q5IJL0QzzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV00VCL204tDVkFRqtxMTWAZLKgZg63yJf3Uv8YAGv279EWJdMq0KBP8+cP3Y3ogKcaugpxAUw13OG7fV7XnwpGMhpDZ26toU2dUfvCDKooJxwkB4beYmnHt78co6rz03+Ams2/hcAFinDHarValeu8kLfhcO8epyEwNMJpU854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQ2UX2vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQ2UX2vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A1C4CEF0;
	Tue, 30 Sep 2025 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245456;
	bh=gUoGuxa7/F7orGHQ85dDQB3VjVnucFxO5q5IJL0QzzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQ2UX2vNMAmL8Y4PA+of8dQP7/XkT3ca0FQb8FZa4a/6w/v/kxAm7aLvhEun1Dyp4
	 wUOwlJTiCqPMuGOCbr+OuZfV3/VjEsVyjowZj1VDpDLOnmmzcfRAKZQ4a+u/izdPBM
	 rpli6n0LRcjihkOlDDdgA9PO78VHpi1atWQodHKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/73] arm64: dts: imx8mp: Correct thermal sensor index
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143821.532521798@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a50342f976d25aace73ff551845ce89406f48f35 ]

The TMU has two temperature measurement sites located on the chip. The
probe 0 is located inside of the ANAMIX, while the probe 1 is located near
the ARM core. This has been confirmed by checking with HW design team and
checking RTL code.

So correct the {cpu,soc}-thermal sensor index.

Fixes: 30cdd62dce6b ("arm64: dts: imx8mp: Add thermal zones support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 86af7115ac60c..e05a1029975af 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -227,7 +227,7 @@
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 0>;
+			thermal-sensors = <&tmu 1>;
 			trips {
 				cpu_alert0: trip0 {
 					temperature = <85000>;
@@ -257,7 +257,7 @@
 		soc-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 1>;
+			thermal-sensors = <&tmu 0>;
 			trips {
 				soc_alert0: trip0 {
 					temperature = <85000>;
-- 
2.51.0



