Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91867B3E5;
	Wed, 21 Feb 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522527; cv=none; b=q/PSXHSIIj2hUKhveidamz40BVX8S2qGdKN8VBVMmZa/PbeF4sokEg8TEXGLnJq4xeLtgaqnRcLnFs4duhNVUefuDk1gtUL+sBndiEobFe2V+ZCnJJb5VzT9vClpvDYy4l9SjY26Y1TYkrs4E61b4p/SRn4rxXvyl54EixSo7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522527; c=relaxed/simple;
	bh=/rZmtPZuHt+8P6o/wmE+As2vi+LDv15fqdtolTEmhqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdS0e+bUfGJ/YRr1Jh+nAuYF34ePDjJp0mh5HzJWJiCqvhbBUB2Lh+Wr6joSXcpesu662LnGHulWBiO2V5NwMKHEdVi3vxCP8yku0Pqq22pkZmhxM5VZvvwlR2Li4St+00FA9Cpk/NQ3adfEN9W0OEcSEwkqqUqwy7jN4CKDTGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpQS0EMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpQS0EMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF0CC433F1;
	Wed, 21 Feb 2024 13:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522526;
	bh=/rZmtPZuHt+8P6o/wmE+As2vi+LDv15fqdtolTEmhqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpQS0EMQwv6n5zVi75dLjyBMKHhWXBUBl0q9nI6BLG6OaAAkMnirjY0UPxvIlVS+G
	 /48I3uoT10sAr45tFbA5ol4VtMFZGucCp296Ur1n6PZyNtNvbKO1GWFrBQyVDDv6TW
	 ErEjAAi2Jk7gaEYwKpdTgXCF3REkV9iB30spsHb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/476] ARM: dts: imx25: Fix the iim compatible string
Date: Wed, 21 Feb 2024 14:03:59 +0100
Message-ID: <20240221130014.832286068@linuxfoundation.org>
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
index bd8ea2ec2457..5eb79a9ffe04 100644
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



