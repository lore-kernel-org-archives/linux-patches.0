Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B5C34F27A;
	Tue, 16 Dec 2025 11:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885636; cv=none; b=G5KM6U2vJI3aOikBA80PjYXu1GOnjw37nMmtn95Ktt9Ged00BNDUqGJNujaYoVX3CwrU3s1pHYc+Sdmjhxqq2VGwcuAf7bKbm36Gj2uOaDnmy0cykj1evAD8LTAazQIvrD0+CedCUMZ0WgUKE8NmDmev83qBZXuxDEHmsZZQcuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885636; c=relaxed/simple;
	bh=rkB+3/n9Y6kGxpOTmXfBTJAOynjeGMEBxpOI9aM15s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejFYJW7W7JFW2yzxyBvkmz+35aB+psi6yRDqd3+/FW2heJnxVuWBGb2iZRIXgPUOWMPYGQEvU9MeHHDVvb2mAVXtri49odUEm/HRej0iTk664vkpow2pVwOrIzdbVrorFHLXQSre7LgG1/HNuXcxt5JZJ3BONtatNoGSk7AbYOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuVSC43l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuVSC43l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432BBC4CEF1;
	Tue, 16 Dec 2025 11:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885635;
	bh=rkB+3/n9Y6kGxpOTmXfBTJAOynjeGMEBxpOI9aM15s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuVSC43lKNt9n4Ch0yFk5vn388gm0xMqTDrBU32oEXAyCHTYZE4XIJGV8Q9dfF1zY
	 BIZnyYlHkWsMI0PwAuX3H6/aQCgp8G+2Yx4jp994mHfBHh6u7R6VfTBZjbJi4VPJtg
	 JCl/B5g8tZigbht4qpBattLUPZFTJDFprEvXlafg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 198/507] dt-bindings: PCI: amlogic: Fix the register name of the DBI region
Date: Tue, 16 Dec 2025 12:10:39 +0100
Message-ID: <20251216111352.682171144@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 4813dea9e272ba0a57c50b8d51d440dd8e3ccdd7 ]

Binding incorrectly specifies the 'DBI' region as 'ELBI'. DBI is a must
have region for DWC controllers as it has the Root Port and controller
specific registers, while ELBI has optional registers.

Hence, fix the binding. Though this is an ABI break, this change is needed
to accurately describe the PCI memory map.

Fixes: 7cd210391101 ("dt-bindings: PCI: meson: add DT bindings for Amlogic Meson PCIe controller")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251101-pci-meson-fix-v1-1-c50dcc56ed6a@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml b/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml
index 79a21ba0f9fd6..c8258ef403283 100644
--- a/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml
@@ -36,13 +36,13 @@ properties:
 
   reg:
     items:
-      - description: External local bus interface registers
+      - description: Data Bus Interface registers
       - description: Meson designed configuration registers
       - description: PCIe configuration space
 
   reg-names:
     items:
-      - const: elbi
+      - const: dbi
       - const: cfg
       - const: config
 
@@ -113,7 +113,7 @@ examples:
     pcie: pcie@f9800000 {
         compatible = "amlogic,axg-pcie", "snps,dw-pcie";
         reg = <0xf9800000 0x400000>, <0xff646000 0x2000>, <0xf9f00000 0x100000>;
-        reg-names = "elbi", "cfg", "config";
+        reg-names = "dbi", "cfg", "config";
         interrupts = <GIC_SPI 177 IRQ_TYPE_EDGE_RISING>;
         clocks = <&pclk>, <&clk_port>, <&clk_phy>;
         clock-names = "pclk", "port", "general";
-- 
2.51.0



