Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F4A125BF;
	Sat,  3 Feb 2024 04:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933357; cv=none; b=tqN6OHXdMUdoOXd+wZObhylm/20+VjDYfl1ZLBK0nnCn01NLiL2iQgJoRE+eVnB8d2waq2EPW27Mt/9sMZKqPfDJv1KyTKejHIYhfqVJjbV4fVePQkOKIas3MuQReCr3hgG3b0LUVK+cXNL9QUad0QobMPPcbuYKcTWzkRsE/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933357; c=relaxed/simple;
	bh=j/ma5VLHhx4LFml5JW/K6MPLyAeftvP2btc20ntCu0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmoSsp2UrmwpM3jNNmq1q3RmBFmZUu5B/t1HhFHCQZ5R7AfimHUmxbfGrGtC8glXVqFSxIShSafWd8/Qwa5lue6w8s2P4oxcZ+REOPuCR9fo/mJKOp6nV4p4C0P5WD+9RCw8VouV37xDVfzDkCny6Ty1QI7kp05lW+ABtQ4tXrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkIpg5C3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkIpg5C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454D4C433C7;
	Sat,  3 Feb 2024 04:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933357;
	bh=j/ma5VLHhx4LFml5JW/K6MPLyAeftvP2btc20ntCu0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkIpg5C3b6Zl4Py17MS6RGcVDFDZ42iZN9id787liCDe3wYHO+NtlAhGf1/uphF7O
	 VCcJxvCWAhUvdvS0Rg0jFyYV48bzhzis91RmVLpEgsLzCAaurAWf9Lv8zSdvQzDIX8
	 pyzIeTpAu7HUlZRQFTTvbIHmDgZ4vx5jq08kbWZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/219] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Fri,  2 Feb 2024 20:03:53 -0800
Message-ID: <20240203035325.382724203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4aadb841ed49bada1415c48c44d21f5b69e01299 ]

nand-controller.yaml bindings says #size-cells shall be set to 0.
Fixes the dtbs_check warning:
arch/arm/boot/dts/nxp/imx/imx7s-mba7.dtb: nand-controller@33002000:
 #size-cells:0:0: 0 was expected
  from schema $id: http://devicetree.org/schemas/mtd/gpmi-nand.yaml#

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 44085ef27977..4b23630fc738 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1283,7 +1283,7 @@
 		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



