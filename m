Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BBD4C62;
	Wed, 21 Feb 2024 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525292; cv=none; b=p/MrwGFBMOWhziJFucXf8PTgHKTPkAOkS9yIwca0f/GzFtEr+2brF3h7SzRm/QPVXkbiN8ZtOPzOL7g9qVuDyKP3xSJ3+SuMthRgBRzinuPzEdfsnFMmNE6tfegVt5pjeN75X7m2DLO5H83UwRFovjdQsC550pCcUc9a4KtsqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525292; c=relaxed/simple;
	bh=jTlv8LOKJ8hWHZXOYjN5L/Yq/QPOe/pL+Yiu36WMAqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9OxDAERyWW+kaL7KB1c+WiQSF8zNea7CobqAxrtBZewI8P3bEB7/YQe8K0ZOGr3uJ2BigVqBBxH93jHgQgxTx2blezF7Bn6pQra4V8WQCyNhtJPDfi9ZZ7ex0Iz+4ZIJUS9/hd0ulzd1BUqUF/7MuafElwaya/UnUZ8Qp2IK4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JAY3G2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JAY3G2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2837BC433F1;
	Wed, 21 Feb 2024 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525291;
	bh=jTlv8LOKJ8hWHZXOYjN5L/Yq/QPOe/pL+Yiu36WMAqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JAY3G2sDf8e5O93o/D5YSkmLlOmwTBZ/uwe6rgyMePJ6HuwF+qJLe1YDBLTQAb47
	 lsC9YFm6f5KujSC8xRU76mZHLA6Uc2mBaYzr0dH+F5Kwy+LZCn0wt9QfErvIAYVg+N
	 46bpFPACeo2BiEwWdyry92VsIIzIfIJo4QHP+BrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/267] ARM: dts: imx23/28: Fix the DMA controller node name
Date: Wed, 21 Feb 2024 14:07:33 +0100
Message-ID: <20240221125943.481882843@linuxfoundation.org>
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
index 42700d7f8bf7..ba1705595b29 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -406,7 +406,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx23-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <7 5 9 26
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 235c69bd181f..26dc6c9e1e6c 100644
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



