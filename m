Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B281D52D;
	Thu, 23 May 2024 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470125; cv=none; b=m/HJqbEMFKn3jT/k0SytKqTioR1+iJ+E29WrwWq1c7f95jFk5wll6pwT0FuNtEa4BBq90IizMTBeiobi3VhWulzNf1MXHl7bkMaHQqsI6ZjWVDnbOlwWT5cpcTCU0Un8pLbo7fwt8E+wXddNPzrsWMmNGRAxta+egmyERvq0bJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470125; c=relaxed/simple;
	bh=jowO80mJUiu32oLMQWrZ456/ZNEBno7fgecgZXoVaJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g23KOgzDYylQCjfJLJs60hnd4riatGDfabE01396OwolIaRxyFb+5754gLyufivoW4H1O4+alr+bBRm+0oM0SAWp9jg6i4aSu2htrlhsy9S1P7q+FMR8ggHQLUb99KKx+MjpvbLcTRC7Dd+EtPkQ8wWvzXNngPlw63MJMbiA3gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFFsoC1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFFsoC1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F4CC3277B;
	Thu, 23 May 2024 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470125;
	bh=jowO80mJUiu32oLMQWrZ456/ZNEBno7fgecgZXoVaJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFFsoC1r/Wc/wdKoh8KbKYkvQ1uGGUUbdbaRx+B0jkZ3CuQ33G8gczaRPg7fuOVrN
	 nmR3R2t3Jsw0ga9yd2bHmvyTuDW2y6/JGrxWDaJo7M50FZ+Xj/F1yZ8GXwfcqCWD0z
	 BASVXWNsNimIby+ns6luOwJCNWOrKSxfPGxCdDLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	Rob Herring <robh@kernel.org>,
	Alex Elder <elder@linaro.org>
Subject: [PATCH 5.4 11/16] arm64: dts: qcom: Fix interrupt-map parent address cells
Date: Thu, 23 May 2024 15:12:44 +0200
Message-ID: <20240523130326.174127361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

commit 0ac10b291bee84b00bf9fb2afda444e77e7f88f4 upstream.

The 'interrupt-map' in several QCom SoCs is malformed. The '#address-cells'
size of the parent interrupt controller (the GIC) is not accounted for.

Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210928192210.1842377-1-robh@kernel.org
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -872,10 +872,10 @@
 			interrupts = <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
 			interrupt-map-mask = <0 0 0 0x7>;
-			interrupt-map =	<0 0 0 1 &intc 0 135 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 2 &intc 0 136 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 3 &intc 0 138 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 4 &intc 0 139 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-map =	<0 0 0 1 &intc 0 0 135 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 2 &intc 0 0 136 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 3 &intc 0 0 138 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 4 &intc 0 0 139 IRQ_TYPE_LEVEL_HIGH>;
 
 			clocks = <&gcc GCC_PCIE_0_PIPE_CLK>,
 				 <&gcc GCC_PCIE_0_MSTR_AXI_CLK>,


