Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BAE1BF24;
	Sat,  3 Feb 2024 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933799; cv=none; b=HyuIpFBXpFm3bFK8sIVxku4wINuUGbMZiXVFaTZa3XeZ1arBSqz1DjVwy/3jidDInIMdyea1BEugYGL3Ip8omgwPVSCo4VTXcmf8+1UHRQXpcsoET9A8/QO55/yslSh+QaCT0A0xFx4ON4VOBNRWeE4DrMGaMsWIpI950mJb/5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933799; c=relaxed/simple;
	bh=tP45OdTe5m+8ur+J8Z5WClkXEWNpYIxJCMitKPGZ0WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftvHY3nSCj40eGdcJeL/fCpgyneScVwTPD33bTakpdV7y40v0rhhoLmNxm30JWafrK6uA0n5quM76iN5o1i1fKm5hL45n/72bXnjJLs2yeO1n4+7zIVmOWRQA0jEd7P0IucCFMy7U8h6tSLyuWXGA01JfabHjVgQsWpQQwIh5Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izFnSftx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izFnSftx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C054EC43390;
	Sat,  3 Feb 2024 04:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933798;
	bh=tP45OdTe5m+8ur+J8Z5WClkXEWNpYIxJCMitKPGZ0WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izFnSftxsnvTd/jHLUfqB/w5QTBEkINUz+VMSThA4PXrAbAN2zz2o4JjKn8yKs1a5
	 /of7ZTq8a8xNh5Jzx0KwzADN97gUhsuMMVZ299r7I3DJozzFbPpIBGdzp+dfNooby6
	 MNDnzxLZdjSP6NqAE/Qv9RNuoSDtd0TGEEH2+dLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 110/353] ARM: dts: imx25/27-eukrea: Fix RTC node name
Date: Fri,  2 Feb 2024 20:03:48 -0800
Message-ID: <20240203035407.245076029@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/nxp/imx/imx25-eukrea-cpuimx25.dtsi | 2 +-
 arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-cpuimx25.dtsi b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-cpuimx25.dtsi
index 0703f62d10d1..93a6e4e680b4 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-cpuimx25.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-cpuimx25.dtsi
@@ -27,7 +27,7 @@
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	pcf8563@51 {
+	rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 	};
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
index 74110bbcd9d4..4b83e2918b55 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
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



