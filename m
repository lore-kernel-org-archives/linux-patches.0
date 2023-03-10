Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7852882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB4C433D2;
	Fri, 10 Mar 2023 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460710;
	bh=c8jeT6ltvB5ID49v2BsMi59CfPOVA52nih/uWv6bXIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/97DoUTveEZvQFeICWo8Jz6tLdM6yIMp6vAKA15qG4Oz9g+xZzE7JgGH15WqJdeU
	 21tVXHa9PxLclMuJsvzKov+dI7LMdPvzMWhAF9JoBMpZMyZea017GAAk+ccJhRUdwj
	 xLW3hXG6EZgzLZD1y8WieX2Qnd3RmteSY3ntMxPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 426/529] arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY
Date: Fri, 10 Mar 2023 14:39:29 +0100
Message-Id: <20230310133824.718542575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

commit 100d9c94ccf15b02742c326cd04f422ab729153b upstream.

Serdes register space sizes are incorrect, update them to match the
actual sizes from downstream QCA 5.4 kernel.

Fixes: 942bcd33ed45 ("arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-1-robimarko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -213,9 +213,9 @@
 			status = "disabled";
 
 			pcie_phy1: phy@8e200 {
-				reg = <0x8e200 0x16c>,
+				reg = <0x8e200 0x130>,
 				      <0x8e400 0x200>,
-				      <0x8e800 0x4f4>;
+				      <0x8e800 0x1f8>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;


