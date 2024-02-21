Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C84B762C1;
	Wed, 21 Feb 2024 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524259; cv=none; b=IOwanVA4c2L0rIb6othYwM/+g5jWdyHHvO9OPilC1BIPu64UvZZGE4PDuEWfwjReOKWDpqeJx4vYZe61jbdI0prXxU98S675iG70OSBn/Xqc8Zd9AuhBvQ/pSQ+Tx3rNIK6ifn6wb+N2+FYhlatYvt0aO8Y2wBxBBIlNMtFj21A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524259; c=relaxed/simple;
	bh=8xhiUY1rhSxifl40RyqWgolkY1zzhkbi7bKIkTLc1+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdhqstfGO9wsZlFXq8qaj+ezqmM5SVq2HmgyBF2gKpZ5X2hlwQKKhol/PBdFvWlDKY/Mrx3sY9vE7s/05gFZc6bYarJVWPfxSsuLh6sON19rUikrj8e9jrV8PoRRKvErSVmsRkLxMKD7ic/pcbtroOxCy+qiQUB6yeIwXtldCRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByovN7J/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByovN7J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C92BC433F1;
	Wed, 21 Feb 2024 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524258;
	bh=8xhiUY1rhSxifl40RyqWgolkY1zzhkbi7bKIkTLc1+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByovN7J/NPPoyhDO+MK5zfd896hzaPmaoM/MxLagdXnQy8PVo0+5+jjipoNtmXapz
	 6T674bBfT1As8ttbJabRFma1iN+dTxVuQDwKhrArUkWyKV5kLvj2UkmfIyv83tbU8j
	 bzOjlGLhN/IT8sJrWUEKvQXhiRdL21Zf0kYfEbFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/379] ARM: dts: imx23/28: Fix the DMA controller node name
Date: Wed, 21 Feb 2024 14:05:42 +0100
Message-ID: <20240221125959.739157631@linuxfoundation.org>
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

[ Upstream commit 858d83ca4b50bbc8693d95cc94310e6d791fb2e6 ]

Per fsl,mxs-dma.yaml, the node name should be 'dma-controller'.

Change it to fix the following dt-schema warning.

imx28-apf28.dtb: dma-apbx@80024000: $nodename:0: 'dma-apbx@80024000' does not match '^dma-controller(@.*)?$'
	from schema $id: http://devicetree.org/schemas/dma/fsl,mxs-dma.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx23.dtsi | 2 +-
 arch/arm/boot/dts/imx28.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index ce3d6360a7ef..b236d23f8071 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -414,7 +414,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx23-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <7 5 9 26
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 6cab8b66db80..23ef4a322995 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -982,7 +982,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx28-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <78 79 66 0
-- 
2.43.0



