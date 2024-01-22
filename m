Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632E462A0B;
	Tue, 23 Jan 2024 01:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974995; cv=none; b=SAqTE2q7grs+l+6HvAdZ38v9Req1gCTt56ES0nFXhQoOGPdb75V8zNznFhjIheTnSLQeDxzOJZrGLnE7ui3WVByIjaWkEfiyCk3oT3znm5O9HcJMCP5Mw3mmgGy2DwlRBp0z9NMrOc5mXu7W6aRWd2SRIBjQhZIC3m3EYNDZEvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974995; c=relaxed/simple;
	bh=+KrHzyFrJ9aJBebAWvLeIx9Bmn1N6fgQK2+9dYxxf9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYMZYBF5am+XnRb7JlGX3FtSzm+Tmypw6NYtV9WzQigVpVzCNxLe5VIkvNQeV34giEUZyeZytpRWT+J8Dw5k+PyNxYd0Y0yhrbFe6wbRs7NqM2FMnr6E/b2UzO7HcXbTWxvWXYoW2CvyLj1k885uXsUq1Ak92hEcZXoOsJd6uj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XguwHM6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XguwHM6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B45C433F1;
	Tue, 23 Jan 2024 01:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974994;
	bh=+KrHzyFrJ9aJBebAWvLeIx9Bmn1N6fgQK2+9dYxxf9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XguwHM6/+/isPm6iZL4gbLvzzuKhwHz/xZZhN6S+TyrWLK2qwJ+pQd+Bo3UKA4Jm6
	 MTL6yIQ7KrOL7nF7m7HqeLKN2RGPvKRDLwhiKYJCEkdxpFjtN5qBlsc2HiyNS/OcCL
	 k+hclzAEJkh5aGkiU0KVPgvJuGIJnSlZ8Bo9G5oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/583] arm64: dts: qcom: sc8180x: Mark PCIe hosts cache-coherent
Date: Mon, 22 Jan 2024 15:53:56 -0800
Message-ID: <20240122235817.662141608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 45e8c72712345263208f7c94f334fa718634f557 ]

The PCIe controllers on 8180 are cache-coherent. Mark them as such.

Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231219-topic-8180_pcie_dmac-v1-1-5d00fc1b23fd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 486f7ffef43b..0d85bdec5a82 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1751,6 +1751,7 @@ pcie0: pci@1c00000 {
 
 			phys = <&pcie0_lane>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -1858,6 +1859,7 @@ pcie3: pci@1c08000 {
 
 			phys = <&pcie3_lane>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -1965,6 +1967,7 @@ pcie1: pci@1c10000 {
 
 			phys = <&pcie1_lane>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -2072,6 +2075,7 @@ pcie2: pci@1c18000 {
 
 			phys = <&pcie2_lane>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
-- 
2.43.0



