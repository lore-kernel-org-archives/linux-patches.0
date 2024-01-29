Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D24E15A4A8;
	Mon, 29 Jan 2024 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548061; cv=none; b=YId4nqQPbfjBmSsAYDR5fcO5LokEwZHdC+vXrQfHf6iZU+5IxAuraaZy+OFqr3/o7vo4i09S2QVj7EntACnMhXf+kuMkghmqfcm35IDi50yZ07daJolp9d3AxHcphLFoNB8Ndkzcj+VHENHVWMsv2GJAQnYDvxNVOp0vvFkhIZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548061; c=relaxed/simple;
	bh=TNxJMELA01FJSdwl9QiFbuvezfvjR50nW31gWCmEwkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oA30uaWIeR9rLrhy2usNHePVHPTQRNhB/Yv0XWYgfuF8DpQPMUGBTF7LS1HUbIf5mewOgjdajcqTGvh45j2es2oavIOvqGs/bErwQ0wYH1puT4+cVW2Cfp63n4XHS9hPMuc285GI3l2LDjDB9PA3TabeuUjREBRlzbAHBsTOU5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va8psU7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va8psU7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF44C433F1;
	Mon, 29 Jan 2024 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548061;
	bh=TNxJMELA01FJSdwl9QiFbuvezfvjR50nW31gWCmEwkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va8psU7K6WPnbnwEcLZMKAlnSXwzIrUkng1gJ/TiHXcS8ta6iknWnaAauw0JR5eTm
	 36hsoHD3VcJ5r56Yss7LcnW9BEPUsoFZ77/RLhXV/0PPs8Wa9PRpS6f63qu8LhHXmS
	 3WPLWijQSWGX/uqxOAJQBOSuTDcgHI+yETSl8Hq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 067/346] ARM: dts: qcom: sdx55: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:01:38 -0800
Message-ID: <20240129170018.357126585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit d0ec3c4c11c3b30e1f2d344973b2a7bf0f986734 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: fea4b41022f3 ("ARM: dts: qcom: sdx55: Add USB3 and PHY support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -587,8 +587,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 158 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 157 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


