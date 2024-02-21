Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4717F76905;
	Wed, 21 Feb 2024 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522617; cv=none; b=L6OHW+N89D8QFcwoNNqAGZ1tR1Fz5PddQwyT4e4lDV5WulqiFgMtigHhnGzZIjRENXZzBE0rQz7eJvlQriKYtkozDFM2Fp4YvOf9Twn8wmKeLf++8GEE/6WUwQ8/TxNUqfaQ10vGAaqttFAPBvgE4EjjRfvzTcCyJlmwucdSGW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522617; c=relaxed/simple;
	bh=ZZJ2AvN91pJIH0TsqHg08XU8Ta/qeWiIHseXTDzDzPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ET9RfpmGVtCwovxaCRAtfctiWrJY71F9+F+bLNRnVMe9XXJh1wgI4FtpInYy8iNwpbZz8PIgrKDS4hCAM3gcOS6/RLJzu0PIvW9ZkFV+CNhY3CpfnE4JI4Vbwv7vpW8ReIs+Nl2HIdkc+Cof9zne6MnBi4fL8uoxdttN9mtlVi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKW8vRU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKW8vRU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5653BC433C7;
	Wed, 21 Feb 2024 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522616;
	bh=ZZJ2AvN91pJIH0TsqHg08XU8Ta/qeWiIHseXTDzDzPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKW8vRU2CRrJT726VMOP69W6DFET+IaV+LDM/nCaCQy1q1vyAM0AyVZPlOL/yyJv0
	 3Ji0Bo6KafjJ425K6adVs+rmDG4SwuIZjhk3qjnkBrjFtqg81oZOhdAmrBcmyRlrjS
	 lB2xmKEd7qjOPZrZH9mhODNmbp7Sl1SDBuBUYBHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/476] ARM: dts: imx25/27-eukrea: Fix RTC node name
Date: Wed, 21 Feb 2024 14:03:53 +0100
Message-ID: <20240221130014.619706350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 68c711b882c262e36895547cddea2c2d56ce611d ]

Node names should be generic. Use 'rtc' as node name to fix
the following dt-schema warning:

imx25-eukrea-mbimxsd25-baseboard.dtb: pcf8563@51: $nodename:0: 'pcf8563@51' does not match '^rtc(@.*|-([0-9]|[1-9][0-9]+))?$'
	from schema $id: http://devicetree.org/schemas/rtc/nxp,pcf8563.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi | 2 +-
 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi b/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
index 0703f62d10d1..93a6e4e680b4 100644
--- a/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
+++ b/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
@@ -27,7 +27,7 @@
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	pcf8563@51 {
+	rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 	};
diff --git a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
index 74110bbcd9d4..4b83e2918b55 100644
--- a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
+++ b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
@@ -33,7 +33,7 @@
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	pcf8563@51 {
+	rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 	};
-- 
2.43.0



