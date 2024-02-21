Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5381169D32;
	Wed, 21 Feb 2024 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521331; cv=none; b=H6eZGng67TQwmWvrIb9E8DQz9P/VYjxksqvCIQDIHxbyK+1kuedG4cekr7qMimtCu/mpgmGOAjEQ2ERil6Fk2ZzoaLGetQ7AiAjQgWC4en9tAEAhzNVNehw/k536ym0rgFFUXrwcZxSdMrOoHGl3Q9lOImzLcflM5KvvgGrZJq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521331; c=relaxed/simple;
	bh=on20rCgx+9kY59Y/muXaQRMvjnSvLBVdc+46uI9MP0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDPpr7oNQoB0z9o3k37Uds2GRpETa+6/3rl6Uy4XJIQuKyZ+4zux18ZN3S7n96s6hQfaVu8egHUurJj7/nXt0hUEXzaC22W2HhJB4BBRGAn4gA98GDI2x7oVX1jxJZEDeyGts1nCrap5KKbateNXUqVJuW5hfUJz89zN0h4mJ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIWgP6gI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIWgP6gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB58CC433C7;
	Wed, 21 Feb 2024 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521330;
	bh=on20rCgx+9kY59Y/muXaQRMvjnSvLBVdc+46uI9MP0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIWgP6gIJAhXrusLV4Dvm3yhtkmUcvaL6cCkuyted6U1H67jNmYmun4VaZrezwHAY
	 dS2bCTKk+vdxWDDIh0ePpQRM1fKL4UTxm1F8fzL2m0T7VKUpCFZez6gfCX7HcN9cMh
	 pkaI80AjuVYmQ4w21vskXC/6rA6bxoU0UYgDHz5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/202] ARM: dts: imx25/27-eukrea: Fix RTC node name
Date: Wed, 21 Feb 2024 14:06:26 +0100
Message-ID: <20240221125934.548359882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e4d7da267532..5858ec8a409a 100644
--- a/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
+++ b/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
@@ -35,7 +35,7 @@
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	pcf8563@51 {
+	rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 	};
diff --git a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
index c85f9d01768a..56c790705155 100644
--- a/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
+++ b/arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi
@@ -39,7 +39,7 @@
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	pcf8563@51 {
+	rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 	};
-- 
2.43.0



