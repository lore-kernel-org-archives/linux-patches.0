Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2933F111AE;
	Sat,  3 Feb 2024 04:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933571; cv=none; b=KwnjZ0PHl1WgcuXuC7oSYhD5tXkYHNxoxnMhq+tgai/u5HzcTcEDkdjZdHFPB8WSqM+yhy3iNDKpmgIBPfIcdox1ZfIMGZt9u7pEz/y6y3AxhUqqMhkDS+QULgGiA86HTa4ZfyrRIJr4Bb1h8niQ8diZu8JXNikn+DZ5Jm1dzaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933571; c=relaxed/simple;
	bh=7gpO1wKX51jSO7hx1num0MpsdaA5NSmIrSiYwe/iB9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnxhRIAkGIonAhBjAlGS7NgrZPMGSXxzmCl+wfMP9aeV+N6qaCWIMYP4e410d8yG+/lIOA6W1djxsqCW6F867mcPkMW+R+zksLY7skS47VM/cLOb2/6ny2srJONjmR6gKKI84brtPBZu4tks4PSt2sPNeEReAu38+/xdhzQSkLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa6MOHSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa6MOHSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97443C433A6;
	Sat,  3 Feb 2024 04:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933570;
	bh=7gpO1wKX51jSO7hx1num0MpsdaA5NSmIrSiYwe/iB9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa6MOHSFLMCJKcXZtnsK7IFUdMedbe42yzDAiW9XeitYgcigXsSVI0wFoEDl28WYM
	 JDTF7KA4E1TgF3asOCJ+WhUk+qtnSpjIcP3VobapoMk3B9GutIthG9D2FrL1WrfQHj
	 Uo1YVPiN1xXo0dzkF1joeKwWrtzpu1IQFtydswKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/322] ARM: dts: imx23/28: Fix the DMA controller node name
Date: Fri,  2 Feb 2024 20:03:43 -0800
Message-ID: <20240203035403.226436909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 858d83ca4b50bbc8693d95cc94310e6d791fb2e6 ]

Per fsl,mxs-dma.yaml, the node name should be 'dma-controller'.

Change it to fix the following dt-schema warning.

imx28-apf28.dtb: dma-apbx@80024000: $nodename:0: 'dma-apbx@80024000' does not match '^dma-controller(@.*)?$'
	from schema $id: http://devicetree.org/schemas/dma/fsl,mxs-dma.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/mxs/imx23.dtsi | 2 +-
 arch/arm/boot/dts/nxp/mxs/imx28.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/mxs/imx23.dtsi b/arch/arm/boot/dts/nxp/mxs/imx23.dtsi
index 5eca942a52fd..14c07b585f82 100644
--- a/arch/arm/boot/dts/nxp/mxs/imx23.dtsi
+++ b/arch/arm/boot/dts/nxp/mxs/imx23.dtsi
@@ -412,7 +412,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx23-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <7>, <5>, <9>, <26>,
diff --git a/arch/arm/boot/dts/nxp/mxs/imx28.dtsi b/arch/arm/boot/dts/nxp/mxs/imx28.dtsi
index 763adeb995ee..9b73130887ea 100644
--- a/arch/arm/boot/dts/nxp/mxs/imx28.dtsi
+++ b/arch/arm/boot/dts/nxp/mxs/imx28.dtsi
@@ -990,7 +990,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx28-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <78>, <79>, <66>, <0>,
-- 
2.43.0



