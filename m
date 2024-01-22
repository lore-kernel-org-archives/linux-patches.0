Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2E154446;
	Tue, 23 Jan 2024 00:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969375; cv=none; b=FcA+HECPe0KINGcpmvlMhrf8YYqTK3rMNwJxx1JVIDAEM7WBmmzY0Gavq5TijJGbGBIpqvOSb8Lxpza9TsMDIY1062j8CSLuFB0isQS45sbVFL5csHcS8RRjLQtoYw8E9xIuLHiBuiMtURJPTMewcTC+zNoIAY86gQq6oraZ/sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969375; c=relaxed/simple;
	bh=WWV7gMRe6CdkDhBUbc1D4JV9sK0OOuTGF1uF5zsjvnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK6q7aqtxbc9wbJxe4stb9kJUJz/jCXSRk/sO3j6LYNmAcFGdO1mtfD55QCrBRWZRawd7EWHLaLExcXECoJ4+TwVHTTcI7YtC12nY3Ay7EOHUOmeZlrfKwXnPC3R/5CKozNZcDFbaGPBTlCDQfyXSg4jaY50o3nauqVpO9fxOSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jB1E8VVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jB1E8VVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B9C43394;
	Tue, 23 Jan 2024 00:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969375;
	bh=WWV7gMRe6CdkDhBUbc1D4JV9sK0OOuTGF1uF5zsjvnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jB1E8VVmxnxz0WTZcQ/KZuDDmSg1aq+RreA/WAnD3f6qb2O4Ai5Hn2xxwGzhoYYJ3
	 t0SLZ/gG8V0IUaRSn/XVTf0NBB5Yrld/8nlkWlvVaoDh4etR4JaS6nKaV3oWeX/ySW
	 Wu1PUbV04pXdKsryjWI3oT1FwY+/ZtAwhevRzz0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 204/641] arm64: dts: qcom: sc8180x: Mark PCIe hosts cache-coherent
Date: Mon, 22 Jan 2024 15:51:48 -0800
Message-ID: <20240122235824.341119351@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index a34f438ef2d9..59ab5428348d 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1751,6 +1751,7 @@ pcie0: pci@1c00000 {
 
 			phys = <&pcie0_phy>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -1848,6 +1849,7 @@ pcie3: pci@1c08000 {
 
 			phys = <&pcie3_phy>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -1946,6 +1948,7 @@ pcie1: pci@1c10000 {
 
 			phys = <&pcie1_phy>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
@@ -2044,6 +2047,7 @@ pcie2: pci@1c18000 {
 
 			phys = <&pcie2_phy>;
 			phy-names = "pciephy";
+			dma-coherent;
 
 			status = "disabled";
 		};
-- 
2.43.0



