Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49A15A4BA;
	Mon, 29 Jan 2024 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548068; cv=none; b=pOKD4j9DhK4ovHbbsVhCch+G/coguDmVPYO/9af5L8/zkPdKyBCOWZCQgE50hK/jjO9vVJZ/gmKOkCh1y/CIbUad+9UvBDYXH3vORX8LPY8XWoStGIYCHRk135/0zPCiYILoQVn/elw/NdmsX6ThkPDX0XiDPmwAjs2yfSGXRT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548068; c=relaxed/simple;
	bh=GFg130xJ+I3aRG94ZiuPIikc7fht608nHelwttJmRPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWnqoEsxJ+ZuxVYgZFwqEcSfsE6NMZ6/TbAQoFwzIUuBazASefYyJUxQLNMLOpL3EjfHrpMti1ZhLbHam1l6qBV6Lz3iT9XSzGc6wYqAtiz5Q4MBcT4bQK8hrt+gUGph7B5htSoA+hrq7UzDjngtoJYiRh5t0alOZ7i4Y5fIjOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPNDcVBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPNDcVBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11046C43390;
	Mon, 29 Jan 2024 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548068;
	bh=GFg130xJ+I3aRG94ZiuPIikc7fht608nHelwttJmRPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPNDcVBZJk8k2Th9Lfz/YjIpOn/+hEbzeWi3LSTzNA9X1bZbVrFy6+sG8E/oOaZH1
	 Qs6UDik6TA8ptZPxlNBcREf2UFUivdKMHSf44N8MMTXi5Q/E/ERKfYksTWosF+5sKy
	 erFh97EVSFyFsro6nnkf3M38n5qVShWA5Tcb2fp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 075/346] arm64: dts: qcom: sc7180: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:01:46 -0800
Message-ID: <20240129170018.595091443@linuxfoundation.org>
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

commit 9b956999bf725fd62613f719c3178fdbee6e5f47 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2966,8 +2966,8 @@
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


