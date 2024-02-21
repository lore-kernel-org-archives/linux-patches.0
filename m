Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB1978B4B;
	Wed, 21 Feb 2024 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524241; cv=none; b=DJ8nO2zcDc4sWYzGlqLVDNOgE29w8FaPQZta0B4LYSRRU14cCO7B9IaKJjFpegjZ0catYnuzElaDYVlVCcyZLaKP4D8zj+xNygK077faMMp3b/zXnypOyQqxA94Cemsot9uezKtrlpWEmbvsA7RiLpZaV7qDsunGg5tldE4JCeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524241; c=relaxed/simple;
	bh=N2vQLl94ALkbV+3d1k6r47VzF2njmFKS/RvGR+0Jp3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlTzwrwLx/0a0tGISs91u7Lt/Mz19NjSI4XaYlF6G1ThOPmug1uc5se6K5Lsuc7ro5o6sYW6vnUENGVXA/C6UwO+y0O103yXo9Qsvfiyms7X9zV8dY5iTSuSaZHDhlPqnHQJq+LWqGT2wGHY+hfl3sJrP+mah/aXqbOolqCqHNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETtsScV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETtsScV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE731C433C7;
	Wed, 21 Feb 2024 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524241;
	bh=N2vQLl94ALkbV+3d1k6r47VzF2njmFKS/RvGR+0Jp3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETtsScV/eOWV1RaaeHVrnqzzJfmbWv3Ujicq01ydrnH6XO2dJypx43Mq2d924uQs0
	 DVu2Sze3xrSj9XIMGOOYurw9d106k/2gWGAWIjvt6AAJf6bJ7ocJs17zPE+9ES5fEz
	 HC2s9lh1mczcEAp7IDGEzR3q/P0/us0FnIX2XoCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/379] ARM: dts: imx25: Fix the iim compatible string
Date: Wed, 21 Feb 2024 14:05:38 +0100
Message-ID: <20240221125959.621299706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f0b929f58719fc57a4926ab4fc972f185453d6a5 ]

Per imx-iim.yaml, the compatible string should only contain a single
entry.

Use it as "fsl,imx25-iim" to fix the following dt-schema warning:

imx25-karo-tx25.dtb: efuse@53ff0000: compatible: ['fsl,imx25-iim', 'fsl,imx27-iim'] is too long
	from schema $id: http://devicetree.org/schemas/nvmem/imx-iim.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index d24b1da18766..99886ba36724 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -543,7 +543,7 @@
 			};
 
 			iim: efuse@53ff0000 {
-				compatible = "fsl,imx25-iim", "fsl,imx27-iim";
+				compatible = "fsl,imx25-iim";
 				reg = <0x53ff0000 0x4000>;
 				interrupts = <19>;
 				clocks = <&clks 99>;
-- 
2.43.0



