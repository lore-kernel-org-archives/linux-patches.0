Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAFF7BAFF;
	Wed, 21 Feb 2024 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524107; cv=none; b=U2Vt7GvUwGR0x/YIe9pGDhgrW4PAkXAaUkMST/LA7OaQlW1xXgd/dP7wmHnop+RhJInhaEasiG8HCCNNiRyuBgqx3EgNF7H6P2sfB5IfxCKZio+bmdorHZL+LGuagHngnIp8A9/FJbxnjiLQQHmElbh2OXx36+4SsXvvxx2qN2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524107; c=relaxed/simple;
	bh=g9bRE5+3mOAq2fuVCJtlZR0afnRVoCM+VD2FGgsZ1GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3XlV8m1k8S8MMyzlOJqo/iCLqoGxzpWwqsSNYp54QR2o25nuj280/LpIw4+17B2SAZ2rTMgZXyT9oYJPD1Vk7d3WoTneo9/uNQbCU4FajnaSqtLBlLGi3ouZEPpXabHh66JOMRD9EOk7G2xGg/PKzQjg9bxGcZEMcxEC/1qEvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWGcqveT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWGcqveT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDCAC43390;
	Wed, 21 Feb 2024 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524106;
	bh=g9bRE5+3mOAq2fuVCJtlZR0afnRVoCM+VD2FGgsZ1GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWGcqveTFLsuMkJniCTVzhomK2cJRJoP3YFOg4QLLde1EXEomEGfA6Wpvc0qb82eN
	 8w23HIFRY8MAncx80mphlbZhaCcebBsEc8xi6Uz5dMRlVPrGEzY8AHVz0dIe1Ktir/
	 ANhIwBiG4XelTLdsjnvA1/QLy5xRNnGpuev5w2yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/379] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Wed, 21 Feb 2024 14:05:25 +0100
Message-ID: <20240221125959.242426479@linuxfoundation.org>
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
index 31ccf65d159b..b4cab6a21437 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1235,7 +1235,7 @@
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



