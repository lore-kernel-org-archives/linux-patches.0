Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E357F1A9F96;
	Thu, 15 Jan 2026 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497453; cv=none; b=E/lG71wQNW+qYXzOP1t82QooCLgO8yv7SZk+bWN/zW1YXucgYX8YV6qGUpa0uuJrgeuK4JD+val0Ftsw/tnGdcvr6KfaUs5W6oyKdnmDAgZXB55yuafLb0ZSu45m3GDwDxhq0mdIhhhcWz/xogwn8MnYoGlU6LRIMXNSJmyNQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497453; c=relaxed/simple;
	bh=xf1jX+H78AcWAb+W5og1m44u5xoJcAcDVPYgxIDRfNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5tyvbeXexue1/RhurTYsOPbJh5Pjtl7c7uuTVvV5jl9hJ176iE/BiwV7hGEwWdyTKWccSXDX5khDkiPcM2pB369II3+5lB0YvXR1SDnTMP206AR8w7iR4UrIfhgRNyl9IFaGCeCm77f+6mzl0FsCiXTgQHhChzXC2HpYHckjL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni3VEZaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni3VEZaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67887C116D0;
	Thu, 15 Jan 2026 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497452;
	bh=xf1jX+H78AcWAb+W5og1m44u5xoJcAcDVPYgxIDRfNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni3VEZafcXX5Smrh4FXXmWQE0koRhVI5WVpAgdz0uZ/m79Sge1RU2bQ6A9cD25EtZ
	 nK5qf/zCnN3U5CN+k/kcNkCKc6JcpaOtqzR7+h3nULr1qDR8qJVO3SpLlspRU47mcR
	 V8qy6tzeM/xgZFNUfLLNgm2rqWJVpfsgemJ1P6gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/554] dt-bindings: PCI: amlogic: Fix the register name of the DBI region
Date: Thu, 15 Jan 2026 17:42:32 +0100
Message-ID: <20260115164249.361716211@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5bd90bc0712e..9c3b8e65c42a3 100644
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



