Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367111640B;
	Sat,  3 Feb 2024 04:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933806; cv=none; b=YqpdPDQ4RO7Gts4HjurjOzCjuxR2Qrw6orRSgyPpnI5CV9XY4Dzm6F1x71qZWNTTXRoHxNtbc1k6NXVpr4CpBQ+PmaJ1abMkqlZD3DIBq3VPLKq0krbdg1Yj7ihPRMH7fsPK0QruNL+SxTflWiRxmoUUsStkrDAke9TAjRKV4uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933806; c=relaxed/simple;
	bh=Pu+IfkMaYUTKytqowyAklRNNO9AMPhk4I5sdiwclMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJolhnLiJmYAF4j344qYE+/wK1BgM9P7pEam2R+sIQYS/eY6ztMAviFs5m0bHCn03fb2rX1cbMMn/fOvxtSITesUDlxYLE/fk51hB+HWYtaYaEq/tCR36B9it5PVtzVHsaG3VKZ/z5zfIzrpwbW4zgHIua1qew9hhzJUFpX42Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcZ0meRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcZ0meRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017FEC43399;
	Sat,  3 Feb 2024 04:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933806;
	bh=Pu+IfkMaYUTKytqowyAklRNNO9AMPhk4I5sdiwclMUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcZ0meRCdZIfQvCvU70QSTT1rzx2NyojRBI8UW6/KqzyqKYGEkXXwpF3iPY01z/52
	 TWDmN10DuMyVvh96FKQ7le7MBVQFQb7RN0E7ldoQiESvthDrmwkp7j/4n8fsJr/3Oe
	 YIlOQHl5zN9IQTi9Y5Ckn0q7y6AllMZ/rMxaQFmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 113/353] ARM: dts: imx1: Fix sram node
Date: Fri,  2 Feb 2024 20:03:51 -0800
Message-ID: <20240203035407.328850909@linuxfoundation.org>
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
 arch/arm/boot/dts/nxp/imx/imx1.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx1.dtsi b/arch/arm/boot/dts/nxp/imx/imx1.dtsi
index e312f1e74e2f..4aeb74479f44 100644
--- a/arch/arm/boot/dts/nxp/imx/imx1.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx1.dtsi
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



