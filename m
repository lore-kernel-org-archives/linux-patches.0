Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D9712CDB5;
	Tue, 30 Apr 2024 10:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474472; cv=none; b=qnpgIudtu+q30XVU7CEbEHFwF9ybTOmag3uELSC2kq9Fw3Vb7IkilA/nJetPd9DtzFYlk6ElJU8h4x7l5aBpCvGSOjKtpMys6F01+QfAhf4zqkaJ9FfNEwtyIoTQY2aQrCbDSelX2jBYvpreR8e1KdnHzlEI6rP6+Njh2G02vDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474472; c=relaxed/simple;
	bh=9U3SiaUldx1ZZsD0t/pHua2qdQuE+nCGIdU6toUNhKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0k41xrf25y6+wCHh5JJVKUecja4KruLZK2itUe5avRAm3NffQ+qAsO0WCMNmAOP7fLAo3CbmZ68lHIWbB1ba9+B9gCrLg95cAlN/thVYbgwucwyO4Fs6ItKNCyZZKI6A+3Sz6CHpqPdc6a0aGgLKYWKeWJiSZcG16QmaOCQs+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiTWBdQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiTWBdQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16FDC2BBFC;
	Tue, 30 Apr 2024 10:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474472;
	bh=9U3SiaUldx1ZZsD0t/pHua2qdQuE+nCGIdU6toUNhKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiTWBdQh0ZOwZuqqMAvinhzZobO+7Xv74C11WCfyiWgpiDVjvPPWudMYnk8hlXiuv
	 6Z7DIpjyKr6g8/Q+VwjP6EOGuL5bmPVNoA/nDu1Sg3NbKJYEAEDrrH5xTi1AVqKMS6
	 Yt70ZUOMJ7AM9wNrtY5bbRI8zR6lDLk5R/RqYjJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.8 167/228] arm64: dts: qcom: sc8280xp: add missing PCIe minimum OPP
Date: Tue, 30 Apr 2024 12:39:05 +0200
Message-ID: <20240430103108.624275520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8b8ec83a1d7d3b6605d9163d2e306971295a4ce8 upstream.

Add the missing PCIe CX performance level votes to avoid relying on
other drivers (e.g. USB or UFS) to maintain the nominal performance
level required for Gen3 speeds.

Fixes: 813e83157001 ("arm64: dts: qcom: sc8280xp/sa8540p: add PCIe2-4 nodes")
Cc: stable@vger.kernel.org      # 6.2
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240306095651.4551-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1774,6 +1774,7 @@
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_4_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie4_phy>;
 			phy-names = "pciephy";
@@ -1872,6 +1873,7 @@
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_3B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie3b_phy>;
 			phy-names = "pciephy";
@@ -1970,6 +1972,7 @@
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_3A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie3a_phy>;
 			phy-names = "pciephy";
@@ -2071,6 +2074,7 @@
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_2B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie2b_phy>;
 			phy-names = "pciephy";
@@ -2169,6 +2173,7 @@
 			reset-names = "pci";
 
 			power-domains = <&gcc PCIE_2A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie2a_phy>;
 			phy-names = "pciephy";


