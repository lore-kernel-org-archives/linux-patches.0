Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481D013AC6;
	Sat,  3 Feb 2024 04:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933809; cv=none; b=suO3XcGPqWnRVw7SYtKlWSR1EUuXRZ6YCAkV30aznk02H0qD1rtRmzVgaRRWRmLb/+au+PDoMQSCLquS9HXszaav5yUHN2d+SfYDlGtqFlQ5t/15uRXV6vJPvz/ml0nhyuzJCaU8Nob3EFvfH5Ppvm0ObjrTbJ8BjzL6+dasNPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933809; c=relaxed/simple;
	bh=Ly63srSRoJMr9QDZRUjxeco28Obu2gqxmmzBHuLdrdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V20XPONDudf3CLulNSS28VVxEc8wV6q99s9fmG04Ci1xsb8QxUIYmMI5/winSqF6UEUvBejlzQiQ+oNY6sJ4iehcjc+FqvIZ00P98u4J0pNQNnd0d+pXWShVw2S9rfO0Y6FQlHnSvdjv+IdCAaKoIuIUyMuFEKp+HK/BCkIE4Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxzq8F/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxzq8F/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139CFC43390;
	Sat,  3 Feb 2024 04:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933809;
	bh=Ly63srSRoJMr9QDZRUjxeco28Obu2gqxmmzBHuLdrdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxzq8F/ga8WRI70ROOhwz+IK3o4BwMllCA0K+DD6kIKItdNB6CKVvy5k/G6XRUTex
	 BtL/Hv8yEvwCV1Y7VN1PLy5o2KyaNShtnVYCKrms41JVhA62B+AcT19kYiN2j+vltB
	 XKK5+kFP9Jx+ERsUEdaVa/pVwBAU87a8XLk1X/Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 125/353] ARM: dts: imx23/28: Fix the DMA controller node name
Date: Fri,  2 Feb 2024 20:04:03 -0800
Message-ID: <20240203035407.688903687@linuxfoundation.org>
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
index fdf18b7cb2f6..9cba1d0224f4 100644
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
index 6932d23fb29d..37b9d409a5cd 100644
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



