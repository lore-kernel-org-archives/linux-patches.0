Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FD176037;
	Wed, 21 Feb 2024 14:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525373; cv=none; b=TozJygtSwWe4KXadbfAJadOMdVXZzNWv0JuOy+XQLRTe94Q4VOE3uXnlUKT0tPBZhnacL2pjP7wMJuH8ARBq/U1kYaSqbFSTSlZdAepPltwZkxfIb6yalBVmTVpB2wJF2ZqayXDu3aS68Er3dAVZYfIFtFRUi+ef8hvx3f69MCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525373; c=relaxed/simple;
	bh=EgjFWmL5+gh65aDq3fR/d26ZaO1imO+WgL7e4Wb6w5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHYiPKaTSlR+fER5TDNnbuDpHj1ZmHiOl9oHiJrSPHrhYhSFBVfp6QDkoSEN3VCoxK7EMrInEL6kEMZUsv6Wxyq7Jc12UXm+M+LhxGpDPVQimiolxASGjqGQHQIYD+VgG2fxeT15bCbBC3tqMCfM/Fvc2XoKmtb48i5HY0iW8dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X12SWLdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X12SWLdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FDFC43394;
	Wed, 21 Feb 2024 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525372;
	bh=EgjFWmL5+gh65aDq3fR/d26ZaO1imO+WgL7e4Wb6w5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X12SWLddKzTUkcx8nKHUOmroxnyGPp07ZHwuwJiHr03gmgSb/+wDGBVX7XHyb9Xta
	 s7Tb6q3kQ7aEaUHXacq6Srun8Dgx14vviMyGOIMLUU4qP3FWnKWpadfmzgcnwu15s8
	 fSgopxX5t9plRIGo9qym+D8uns5eCHXYOlwEcmRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/267] ARM: dts: imx1: Fix sram node
Date: Wed, 21 Feb 2024 14:07:29 +0100
Message-ID: <20240221125943.334519973@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit c248e535973088ba7071ff6f26ab7951143450af ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

The node name should be sram.

Change the node name and pass the required properties to fix the
following dt-schema warnings:

imx1-apf9328.dtb: esram@300000: $nodename:0: 'esram@300000' does not match '^sram(@.*)?'
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: 'ranges' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx1.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx1.dtsi b/arch/arm/boot/dts/imx1.dtsi
index b30448cde582..a74870d03a67 100644
--- a/arch/arm/boot/dts/imx1.dtsi
+++ b/arch/arm/boot/dts/imx1.dtsi
@@ -268,9 +268,12 @@
 			status = "disabled";
 		};
 
-		esram: esram@300000 {
+		esram: sram@300000 {
 			compatible = "mmio-sram";
 			reg = <0x00300000 0x20000>;
+			ranges = <0 0x00300000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



